//from RubenVerg, with optimizations from dzaima (ported to older gcc by effbiae)
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct seq_buffer {
  uint8_t *buf;
  uint_fast32_t len;
  uint_fast32_t cap;
} seq_buffer;

static __attribute__((always_inline)) seq_buffer new_seq_buffer(uint_fast32_t cap) {
  seq_buffer b;
  b.buf = malloc(cap);
  b.len = 0;
  b.cap = cap;
  return b;
}

#define code(chr) " \0 \1\3  \2"[(chr) & 0x7]
#define grow(b) do { b.buf = realloc(b.buf, b.cap * 2); b.cap *= 2; } while (0)
#define push(b, chr) { b.buf[b.len++] = code(chr); } while (0)
#define shrink(b) do { b.buf = realloc(b.buf, b.len + 18); } while (0)

#define BATCH 4
static inline void count2_part(uint8_t*restrict buf, uint8_t*restrict sums, uint8_t*restrict consts) {
  uint8_t sum0=0, sum1=0, sum2=0, sum3=0;
  #pragma GCC unroll(1)
  for (uint_fast32_t i = 0; i < 224; i++) {
    uint8_t code = buf[i] << 2 | buf[i+1];
    sum0 += code == consts[0];
    sum1 += code == consts[1];
    sum2 += code == consts[2];
    sum3 += code == consts[3];
  }
  sums[0] = sum0;
  sums[1] = sum1;
  sums[2] = sum2;
  sums[3] = sum3;
}

// GGTATTTTAATTTATAGT
static inline void countspecific(const seq_buffer *buf, uint_fast32_t i0, uint_fast32_t i1, uint_fast32_t* specifics) {
  for (uint_fast32_t i = i0; i < i1; i++)
    if (__builtin_expect_with_probability(
       buf->buf[i+0] == code('G')
     & buf->buf[i+1] == code('G') // this will past the end at the end, but there's padding so it's fine
     & buf->buf[i+2] == code('T'),1,0.5)) {
      ++specifics[0];
      if (buf->buf[i+3] == code('A')) {
        ++specifics[1];
        if (buf->buf[i+4] == code('T')
         && buf->buf[i+5] == code('T')) {
          ++specifics[2];
          if (buf->buf[i+6] == code('T')
           && buf->buf[i+7] == code('T')
           && buf->buf[i+8] == code('A')
           && buf->buf[i+9] == code('A')
           && buf->buf[i+10] == code('T')
           && buf->buf[i+11] == code('T')) {
            ++specifics[3];
            if (buf->buf[i+12] == code('T')
             && buf->buf[i+13] == code('A')
             && buf->buf[i+14] == code('T')
             && buf->buf[i+15] == code('A')
             && buf->buf[i+16] == code('G')
             && buf->buf[i+17] == code('T'))
              ++specifics[4];
          }
        }
      }
    }
}

uint8_t consts[16] = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15};
__attribute__((noinline))
static inline void countall(const seq_buffer *buf, uint_fast32_t* specifics, uint_fast32_t* acgt_acgt) {
  uint8_t sums[16] = {};
  uint_fast32_t nw = buf->len - 1;
  for (uint_fast32_t i = 0; i < nw; i+= 224) {
    uint_fast32_t left = nw - i;
    countspecific(buf, i, i+(left>224?224:left), specifics);
    if (left < 224) {
      for (uint_fast32_t j = i; j < nw; j++) {
        acgt_acgt[buf->buf[j] << 2 | buf->buf[j+1]] += 1 << 4;
      }
    } else {
      for (uint8_t k = 0; k < 16; k+= BATCH) {
        count2_part(buf->buf + i, sums+k, consts+k);
      }
      for (int j = 0; j < 16; j++) acgt_acgt[j] += sums[j] << 4;
    }
  }
}

int gr(const void* a, const void* b) {
  uint_fast32_t a1 = *(const uint_fast32_t*)a >> 4;
  uint_fast32_t b1 = *(const uint_fast32_t*)b >> 4;
  return (a1 < b1) - (a1 > b1);
}
#define _Countof(x) (sizeof(x)/sizeof(x[0]))
int main(void) {
  char buf[0x1000];

  while (fgets(buf, _Countof(buf), stdin) && memcmp(">THREE", buf, _Countof(">THREE") - 1));

  seq_buffer b = new_seq_buffer(0x10000000);

  while (fgets(buf, _Countof(buf), stdin) && *buf != '>') {
    char* end = strchr(buf, '\n');
    size_t n = (end==NULL ? strlen(buf) : end - buf);
    for (size_t i = 0; i < n; i++) b.buf[b.len+i] = code(buf[i]);
    b.len += n;
    if (b.cap - b.len < _Countof(buf)) grow(b);
  }
  shrink(b);
  for (int i = 0; i < 18; i++) b.buf[b.len+i] = 0; // make sure that the padding is not undefined values

  uint_fast32_t sz2[4 * 4];
  for (uint_fast32_t i = 0; i < _Countof(sz2); i++) sz2[i] = i;
  uint_fast32_t specifics[5] = {0,0,0,0,0};
  countall(&b, specifics, sz2);

  uint_fast32_t sz1[4] = { 0, 1, 2, 3 };
  for (uint_least32_t i = 0; i < 4; i++) sz1[i] = ((sz2[i << 2 | 0b00] >> 4) + (sz2[i << 2 | 0b01] >> 4) + (sz2[i << 2 | 0b10] >> 4) + (sz2[i << 2 | 0b11] >> 4) + (b.buf[b.len - 1] == i)) << 4 | i;

  qsort(sz1, _Countof(sz1), sizeof(sz1[0]), &gr);
  for (size_t i = 0; i < _Countof(sz1); i++)
    printf("%c %.3f\n", "ACGT"[sz1[i] & 0b11], 100.0 * (sz1[i] >> 4) / b.len);
  puts("");
  qsort(sz2, _Countof(sz2), sizeof(sz2[0]), &gr);
  for (size_t i = 0; i < _Countof(sz2); i++)
    printf("%c%c %.3f\n", "ACGT"[sz2[i] >> 2 & 0b11], "ACGT"[sz2[i] & 0b11], 100.0 * (sz2[i] >> 4) / (b.len - 1));
  puts("");

  printf("%d\tGGT\n", (int) specifics[0]);
  printf("%d\tGGTA\n", (int) specifics[1]);
  printf("%d\tGGTATT\n", (int) specifics[2]);
  printf("%d\tGGTATTTTAATT\n", (int) specifics[3]);
  printf("%d\tGGTATTTTAATTTATAGT\n", (int) specifics[4]);
}

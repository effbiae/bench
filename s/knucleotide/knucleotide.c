//contributed by @RubenVerg Sep 2026 (ported to an older c standard)
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct seq_buffer {
	uint8_t *buf;
	uint_fast32_t len;
	uint_fast32_t cap;
} seq_buffer;

static inline seq_buffer new_seq_buffer(uint_fast32_t cap) {
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

inline void count1(const seq_buffer *buf, uint_fast32_t* acgt) {
	for (uint_fast32_t i = 0; i < buf->len; i++) acgt[buf->buf[i]] += 1 << 4;
}

inline void count2(const seq_buffer *buf, uint_fast32_t* acgt_acgt) {
	for (uint_fast32_t i = 0; i < buf->len - 1; i++) acgt_acgt[buf->buf[i] << 2 | buf->buf[i+1]] += 1 << 4;
}

// GGTATTTTAATTTATAGT
static inline void countspecific(const seq_buffer *buf, uint_fast32_t *count3, uint_fast32_t *count4, uint_fast32_t *count6, uint_fast32_t *count12, uint_fast32_t *count18) {
	for (uint_fast32_t i = 0; i < buf->len; i++)
		if (buf->buf[i+0] == code('G')
		 && buf->buf[i+1] == code('G')
		 && buf->buf[i+2] == code('T')) {
			++*count3;
			if (buf->buf[i+3] == code('A')) {
				++*count4;
				if (buf->buf[i+4] == code('T')
				 && buf->buf[i+5] == code('T')) {
					++*count6;
					if (buf->buf[i+6] == code('T')
					 && buf->buf[i+7] == code('T')
					 && buf->buf[i+8] == code('A')
					 && buf->buf[i+9] == code('A')
					 && buf->buf[i+10] == code('T')
					 && buf->buf[i+11] == code('T')) {
						++*count12;
						if (buf->buf[i+12] == code('T')
						 && buf->buf[i+13] == code('A')
						 && buf->buf[i+14] == code('T')
						 && buf->buf[i+15] == code('A')
						 && buf->buf[i+16] == code('G')
						 && buf->buf[i+17] == code('T'))
					         	++*count18;
					}
				}
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
		for (size_t i = 0; buf[i] != 0; i++)
                        if (buf[i] != '\n')
                                push(b, buf[i]);
		if (b.cap - b.len < _Countof(buf)) grow(b);
	}
	shrink(b);

	uint_fast32_t c3 = 0, c4 = 0, c6 = 0, c12 = 0, c18 = 0;

	{
		uint_fast32_t sz1[4] = { 0, 1, 2, 3 };
		count1(&b, sz1);
		qsort(sz1, _Countof(sz1), sizeof(sz1[0]), &gr);
		for (size_t i = 0; i < _Countof(sz1); i++)
			printf("%c %.3f\n", "ACGT"[sz1[i] & 0b11], 100.0 * (sz1[i] >> 4) / b.len);
	}
	puts("");
	{
		uint_fast32_t sz2[4 * 4];
		for (uint_fast32_t i = 0; i < _Countof(sz2); i++) sz2[i] = i;
		count2(&b, sz2);
		qsort(sz2, _Countof(sz2), sizeof(sz2[0]), &gr);
		for (size_t i = 0; i < _Countof(sz2); i++)
		printf("%c%c %.3f\n", "ACGT"[sz2[i] >> 2 & 0b11], "ACGT"[sz2[i] & 0b11], 100.0 * (sz2[i] >> 4) / (b.len - 1));
	}
	puts("");

	countspecific(&b, &c3, &c4, &c6, &c12, &c18);
	printf("%d\tGGT\n", (int)c3);
	printf("%d\tGGTA\n", (int)c4);
	printf("%d\tGGTATT\n", (int)c6);
	printf("%d\tGGTATTTTAATT\n", (int)c12);
	printf("%d\tGGTATTTTAATTTATAGT\n", (int)c18);
}

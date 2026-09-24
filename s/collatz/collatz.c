// contributed by Marshall Sep 2026
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

typedef __uint32_t u32;
typedef __uint64_t u64;

// r = n*m+o for big n and (2^32-1)*m+o <= 2^64-1
int big_fma(int l, u32* r, u32* n, u32 m, u64 o) {
  for (int i=0; i<l; i++) {
    u64 p = (u64)m*n[i] + o;
    r[i] = (u32)p;
    o = p>>32;
  }
  r[l] = o;
  while (o==0 && l>0) o = r[--l];
  return l + 1;
}

// collatz sequence length of 1+2^e
// = 3*(e/2) + length for 1 + 2^(e%2) * 3^(e/2)
int pow_collatz_len(int e) {
  const u32 mp = 20; // 3^mp < 2^32
  u32 pows[mp+1];
  for (u32 i=0, p=1; i<=mp; i++) { pows[i] = p; p *= 3; }
  int t = e/2;
  int all = e/32+1; u32* n = malloc(all*8);
  n[0] = pows[t%mp] << (e%2);
  int l = 1;
  for (int i = t/mp; i--; ) l = big_fma(l, n, n, pows[mp], 0);
  n[0]++; for (int i=0; n[i]==0; ) n[++i]++; // increment must terminate: 1+3^a = 2^b has no solutions for b>2, by taking mod 8
  t *= 3; // iteration counter
  while (1) {
    u64 r = n[0];
    int k = 0; for (int sh=0; ; k++) {
      int z = __builtin_ctzll(r);
      sh += z;
      if (l==1 && (r&(r-1))==0) { free(n); return t+sh+k; }
      if (sh >= 32) { r >>= z - (sh-32); break; }
      r = (r>>z)*3 + 1;
    }
    t += 32 + k;
    l--;
    if (k > mp) {
      l = big_fma(l, n+1, n+1, pows[mp], 0);
      k -= mp;
    }
    l = big_fma(l, n, n+1, pows[k], r);
    if (all-l < 2) { all*=2; n = realloc(n, all*8); }
  }
}

int main(int argc, char **argv) {
  printf("%d\n", pow_collatz_len(argc<=1 ? 10000 : atoi(argv[1])));
}

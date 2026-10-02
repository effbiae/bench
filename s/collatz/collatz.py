#find length of collatz sequence starting at 1+2^x
#@Fiuzeri Oct 2026
import math,sys

def collatz0(bits, x):
    muls = 0
    while bits > 0:
        if x % 2:
            muls += 1
            x = 3 * x + 1
        else:
            bits -= 1
            x >>= 1
    return (x, 3**muls, muls)

cache = [ collatz0(8, x) for x in range(256) ]

def collatz(x):
    i = 0
    while x >= 2**32:
        w0 = x & 2**32-1
        w1, p1, m1 = cache[w0 & 255]; w1 += p1 * (w0 >> 8)
        w2, p2, m2 = cache[w1 & 255]; w2 += p2 * (w1 >> 8)
        w3, p3, m3 = cache[w2 & 255]; w3 += p3 * (w2 >> 8)
        w4, p4, m4 = cache[w3 & 255]; w4 += p4 * (w3 >> 8)
        i += 32 + m1 + m2 + m3 + m4
        x = w4 + (p1 * p2 * p3 * p4) * (x >> 32)
    while x >= 256:
        w, p, m = cache[x & 255]
        i += 8 + m
        x = w + p * (x >> 8)
    while x > 1:
        i += 1
        x = 3*x+1 if x%2 else x >> 1
    return i

x = int((sys.argv+["10000"])[1])
print(3 * (x >> 1) + collatz((3**(x >> 1) << (x & 1)) + 1))

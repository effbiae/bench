#find length of collatz sequence starting at 1+2^x
#the loop was optimized by Fiuzeri
import math,sys
def collatz(x):
 i=0
 while x != 1:
    x += x << 1 | 1
    k = (x&-x).bit_length()
    x >>= k - 1
    i += k
 return i
x=int((sys.argv+["10000"])[1])
s=1+2**x
print(collatz(s))

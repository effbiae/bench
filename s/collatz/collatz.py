#find length of collatz sequence starting at 1+2^x
import math,sys
def collatz(x):
 i=0
 while x!=1:
  if x%2==0:x//= 2
  else:x=3*x+1
  i+=1
 return i
x=int((sys.argv+["10000"])[1])
s=1+2**x
print(collatz(s))

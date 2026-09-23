#find longest collatz sequence for a range of integers
import math,sys
cache={}
def encache(trajectory,remaining_steps):
 for i,start in enumerate(trajectory):
  cache[start]=len(trajectory)-i+remaining_steps
def collatz(start):
 steps=0
 number=start
 trajectory=[start]
 while number!=1:
  if number in cache:
   encache(trajectory,cache[number])
   return cache[start]
  if number%2==0:number//= 2
  else:number=3*number+1
  trajectory.append(number)
  steps+=1
 encache(trajectory,0)
 return steps
x=int((sys.argv+["400"])[1])
s=2**x;n=x**2;l=0
for start in range(s,s+n):l=max(l,collatz(start))
print(l)

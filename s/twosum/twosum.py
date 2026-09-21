import sys,math
#Widynski's Squares counter-based random number generator
def cbrng(ctr, key):
    ff = 0Xffffffffffffffff
    x = (ctr * key) & ff
    y = x
    z = (x * x) & ff
    x = (z + y) & ff
    x = (x >> 32) | (x << 32) & ff
    z = (x * x) & ff
    x = (z + y) & ff
    x = (x >> 32) | (x << 32) & ff
    z = (x * x) & ff
    return ((z + y) >> 32) & 0xffffffff
n=int((sys.argv+["20000"])[1])
rn=[cbrng(x,n)%n for x in range(n)]
p=.99+(.005*(math.log(n,10)-5)) #found experimentally to balance results up to n=10**6
m=math.floor(n*p)
a,h=rn[0:m],set(rn[m:])

i=0;b=[]
for x in a:
 for y in h:
  if x-y in h:i+=1;break
 else:b.append(x-math.floor(n/2))
print(i)

#https://www.geeksforgeeks.org/dsa/find-triplets-array-whose-sum-equal-zero/
i=0;d={}
for j in range(len(b)):
 for k in range(j+1,len(b)):
  x=-(b[j]+b[k])
  if x in d:
   for y in d[x]:i+=1
 if b[j]not in d:d[b[j]]=[]
 d[b[j]].append(j)
print(i)

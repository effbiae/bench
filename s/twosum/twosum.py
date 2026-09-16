import sys,math
def cbrng(x,s):p=2147483647;x=(s+x*158345789)%p;x=(12345+x*48271)%p;return(98765+x*69069)%p
n=int((sys.argv+["1000"])[1])
f=[1] #generate factorial lookup
for i in range(1,20):f.append(f[-1]*(i+1))
l=[i for i in range(len(f))if n<=f[i]][0]
m=math.floor(n*l/(l+1))
rn=[cbrng(x,n)%n for x in range(n)]
a,h=rn[0:m],rn[m:]
d=set(h);i=0
for x in a:
 for y in h:
  if x-y in d:i+=1;break
print(i/m)

find existence of pair sums in a list
-------------------------------------

eg is there a pair that sums to 5 in [0,1,2,3]? yes, 2+3=5

the problem is to find existence count of sums so given

 `a=[4,5,6]` and `h=[0,1,2,3]`

the result is 2 because there are two elements in `a` equal to pair sums from `h`

 (4=1+3, 5=2+3). there is no pair in `h` that sums to 6

the output is `2/len(a)` or 0.66666666667


fine details
------------

an array friendly counter based random number generator is:
```
 def cbrng(x,s):p=2147483647;x=(s+x*158345789)%p;x=(12345+x*48271)%p;return(98765+x*69069)%p
```

parse n from argv and find `l`, the inverse factorial of n
```
 n=int((sys.argv+["1000"])[1])
 f=[1] #generate factorial lookup
 for i in range(1,20):f.append(f[-1]*(i+1))
 l=[i for i in range(len(f))if n<=f[i]][0]
```

generate the random numbers mod n for n
```
 rn=[cbrng(x,n)%n for x in range(n)]
```

cut the random list, with `l/(l+1)` fraction of items in `a` and `h` the remainder
```
 m=math.floor(n*l/(l+1))
 a,h=rn[0:m],rn[m:]
```
`a` contains needles, `h` is the haystack

for each needle in `a`, count the times when there are two items in `h` where `h1+h2==a`
```
 d=set(h);i=0
 for x in a:
  for y in h:
   if x-y in d:i+=1;break
```

print the proportion of needles that equal a sum of a pair in haystack
(print with full precision of a double)
```
 print(i/m)
```

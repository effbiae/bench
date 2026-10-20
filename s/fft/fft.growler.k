tau: 2*pi: 3.141592653589793
txp: {,/',/+'+''++'(0N;_%#x)#(0N;_%#*x)#/:x} / blocked transpose, ideally the interpreter should do this natively
mul: {(-/x*y;+/x*|y)}
btfly: {[lo;hi;k;n]: (lo+t;lo-t:$[n!4*k;mul[c,%1.0-c*c:`cos@tau*k%n;hi];k;(-hi 1;hi 0);hi])}
fft1: {x[;2/bit] {(lo;hi):+'x@\:/:.=y; (+,/+btfly'[lo;hi;(#lo)#!n;2*n:y?1])[;<<y]}/ bit:|2\!#*x}
fft2: {fft1@txp'+mul'[+fft1@x;`cos`sin@\:/:(*\:/!'s)*tau%*/s:#'1*:\*x]}
top: {$[(10*x)<m:_%#y; i@o[x;y@i:&y>s@(>s:(-m)?y)[x]]; x#>y]}
fmt:{(*x),".",1_x}'"0"^-10$$_0.5+1e9*

N: (*/23#2)^`I$`argv[2]
m: (-n:*/2+&-2!#(-2!)\N)!N / decompose
a: 1103515245;A: n(  a*)/1 / skip ahead n iterations in LCG
c: 12345     ;C: n(c+a*)/0
x:(-1.0+%[;32768]@65536!-65536!(m-1)(C+A*)\(n-1)(c+a*)\c+a*N;(m;n)#0.0)

mag:,/{+/x*x}@fft2 x
`0:($`f$i),'"\t",'fmt@%(1%N*N)*(@[;0;%;4]@4*mag)@i:top[10;(-2!#mag)#mag]

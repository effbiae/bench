/ Fiuzeri -- Oct '26
tau: 2*pi: 3.141592653589793
/ blocked transpose, ideally the interpreter should do this natively
T: {,/',/+'+''++'(0N;_%#x)#(0N;_%#*x)#/:x}
/ helpers for complex numbers
(ι:): {(-x[1];x[0])}         / i x
(ι): {(x[0]-y[1];x[1]+y[0])} / x + i y
(×): {(-/x*y;+/x*|y)}        / x * y
(ω): {x×`cos`sin@\:tau*y}    / x * exp(i*tau*y)

btfly2: {[k;x0;x1] (x0+x1;x0-x1:$[k~0.0;x1;k~0.25;ιx1;x1ωk])}
btfly4: {[k;x0;x1;x2;x3] $[k~0.0;;(x1;x2;x3):(x1;x2;x3)ω'1 2 3*k]
 (x0p2+x1p3;x0m2ιx1m3;(x0p2:x0+x2)-x1p3:x1+x3;(x0m2:x0-x2)-ιx1m3:x1-x3)}
fft1: {x[(1+|/'b)/b] {(,/+$[2~#x;btfly2;btfly4]'[(#*x)#(!n)%(#x)*n:y?1].x@:.=y)[<<y]}/ b:|4\!#x}
fft2: {+fft1@+T'+(fft1@+x)ω'(*\:/!'s)%*/s:#'1*:\*x}
top: {$[(10*x)<m:_%#y; i@o[x;y@i:&y>s@(>s:(-m)?y)[x]]; x#>y]}
fmt: {(*x),".",1_x}'"0"^-10$$_0.5+1e9*

N: (*/23#2)^`I$`argv[2]
n: (-m:*/2+&-2!#(-2!)\N)!N
a: 1103515245;a2:a*a  ;an: n(   a2*)/1
c: 12345     ;c2:c+a*c;cn: n(c2+a2*)/0
(even;odd):(-32768+65536!-65536!(-1+-2!m)(cn+an*)\'1(c+a*)\(n-1)(c2+a2*)\c+a*N)%32768
Z:fft2(even;odd)
Zfl: {x:||'x; ((*|l) :':l:(*|)'x) :':'x}'(::;-:)@'Z / flipped, rotated
mag:,/0.25*{[Z;Zfl;k]{+/x*x}@Z+Zfl+(Z-Zfl)ωk}'[+Z;+Zfl;-0.25+(((-2!m)*!n)+\:!-2!m)%N]
`0:($`f$i),'"\t",'fmt@%(1%N*N)*(@[;0;%;4]@4*mag)@i:top[10;mag]

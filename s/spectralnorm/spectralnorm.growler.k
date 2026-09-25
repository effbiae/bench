/#!/usr/bin/env amber
/Amber entry Sep 2026
i:!n:. `argv 2
R:16;A:{1%1+x+0.5*s*1+s:x+i}'i
G:{x_y#i}'[-1_b;1_b:?(R*!-_-n%R),n]
mv:mv:{[v](+/v*)'A};mt:{[w]+/{[w;g]+/(w g)*A g}[w]'G}
B:{mt mv x};u:B v:B 9{B B x}/n#1.0;r:$_0.5+1e9*%(+/u*v)%+/v*v
`0:(-9_r),".",-9#r

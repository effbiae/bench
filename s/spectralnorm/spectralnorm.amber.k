/spectralnorm. Row x of A is 1/(E[x+j]+x+1) with E[s]=s(s+1)/2, so every row is a window on E.
/One pass over A per multiply by AtA: for each block of R rows, A.v for those rows, then the same
/rows, still in cache, scaled and summed into At.(A.v).
i:!n:. `argv 2
R:16;E:0.5*s*1+s:!2*n
G:{x_y#i}'[-1_b;1_b:?(R*!-_-n%R),n]
A:{1%(1.0+x)+E x+i}'i
B:{[v]+/{[v;g]a:A g;+/((+/v*)'a)*a}[v]'G}
u:B v:B 9{B B x}/n#1.0;r:$_0.5+1e9*%(+/u*v)%+/v*v
`0:(-9_r),".",-9#r

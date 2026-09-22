#!/usr/bin/env amber
/Amber entry Sep 2026
x:1:"/dev/stdin";h:(&x=">")2
t:(1+h+(x@h+!200)?"\n")_x;d:t@&t>"\n";n:#d
f:{[k;c;n]{x," ",(-3_r),".",-3#r:$_0.5+1e5*y}'[k;c%n]@>c}
`0:(f[,'"ACGT";{+/d=x}'"acgt";n]),,""
`0:(f["ACGT"@+4 4\!16;(#'=(4*-1_c)+1_c:"acgt"?d)@!16;n-1]),,""
s:" "\"GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT";P:"ggtattttaatttatagt"
`0:"\t"/'+($(#'{x@&P[y]=d@x+y}\[&(-1_g)&1_g:d="g";2+!16])@-3+#'s;s)

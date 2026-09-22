#!/usr/bin/env amber
/Amber entry Sep 2026
x:1:"/dev/stdin";h:(&x=">")2
t:(1+h+(x@h+!200)?"\n")_x;d:t@&t>"\n";n:#d
f:{[k;c;n]{x," ",(-3_r),".",-3#r:$_0.5+1e5*y}'[k;c%n]@>c}
c2:(#'=p:(-1_4*c)+1_c:"acgt"?d)@!16
`0:(f[,'"ACGT";(+/'4 4#c2)+(!4)=c@n-1;n]),,""
`0:(f["ACGT"@+4 4\!16;c2;n-1]),,""
s:" "\"GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT";P:"ggtattttaatttatagt"
`0:"\t"/'+($(#'{x@&P[y]=d@x+y}\[&p=10;2+!16])@-3+#'s;s)

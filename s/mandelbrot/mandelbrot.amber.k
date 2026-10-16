/from @amber Oct 2026
n:$[#a:`argv 2;. a;#a:.[{1:x};,"/dev/stdin";{""}];. a;0];tx:n=0;n:$[tx;4096;n];N:n+0.0;k:-_-n%8
ci:((2*!n)%N)-1.0
h:$[&/(=;-|:)1_ci;_n%2;n-1]
R:2;T:R*8*k;nb:-_-(h+1)%R

j:(!8)+\:8*!k;X:,/(R*k)#'(-1.5+(2*j)%N)+100.0*~j<n
XA:X-0.25;XA2:XA*XA;XB2:(X+1.0)*X+1.0
in:{[XA;XA2;XB2;Y;YY](((XA2+YY)*(XA2+YY)+XA)<0.25*YY)|(XB2+YY)<0.0625}
it:{[cr;ci;s](zr;zi):s;(cr+(zr*zr)-zi*zi;ci+2.0*zr*zi)}
ok:{[zr;zi]4.0>(zr*zr)+zi*zi}
ch:{[s;l](zr;zi;cr;ci;id):s;(zr;zi):l it[cr;ci]/(zr;zi);j:&ok[zr;zi];(zr j;zi j;cr j;ci j;id j)}

blk:{[b]y:ci (n-1)&(b*R)+!R;Y:T#,/k#'y
 m:0+in[XA;XA2;XB2;Y;Y*Y];c:&~m;cr:X c;cy:Y c
 s:ch/[(cr;cy;cr;cy;c);2 3 4 5 6 7 8 9 5]
 m[s 4]:1
 2/(8;_T%8)#m}
v:(k*h+1)#,/`pe(blk;!nb)
v:$[h<n-1;[r:(h+1;k)#v;,/r,|1_(n-h)#r];v]

$[tx;`0:{" #"@n#,/+(8#2)\x}'(n;k)#v;"/dev/stdout"1:"P4\n",($n)," ",($n),"\n",`c$v]

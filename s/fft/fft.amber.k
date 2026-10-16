/from @amber Oct 2026
N:$[#a:`argv 2;. a;#a:.[{1:x};,"/dev/stdin";{""}];. a;524288];M:_N%2;m:4294967296;a:1103515245;c:12345

pw:{[a;c;n]{[s](A;C;p;q):s;(A,m!A*p;C,m!(A*q)+C;m!p*p;m!(p*q)+q)}/[n;(,1;,0;a;c)]}
lg:(-1+#2\)
B:4096&M;nb:_M%B
(A;C;p;q):pw[m!a*a;m!(a*c)+c;lg B];A2:m!a*A;C2:m!c+a*C
(H;J;p;q):pw[p;q;lg nb]
S:m!J+H*m!(a*N)+c
(zr;zi):,/'+{[A;C;A2;C2;x]((3.0517578125e-05*_(m!C+A*x)%65536)-1.0;(3.0517578125e-05*_(m!C2+A2*x)%65536)-1.0)}[A;C;A2;C2]'S

q8:_N%8;t:(6.283185307179586%N)*!q8+1;c0:`cos t;s0:`sin t
cq:c0,|-1_s0;sq:s0,|-1_c0
wc:cq,-|1_-1_cq;ws:sq,|1_-1_sq

bf:{[tr;ti;R;I]h:_(#R)%2;er:h#R;ur:h_R;ei:h#I;ui:h_I
 (er+(tr*ur)+ti*ui;er-(tr*ur)+ti*ui;ei+(tr*ui)-ti*ur;ei-(tr*ui)-ti*ur)}
st:{[d](R;I):d;s:#R;j:(_M%s)*!s;,/'2 2#+bf'[wc j;ws j;R;I]}
L:lg M;k:_L%2;P:*/k#2;Q:_M%P
d:k st/(,zr;,zi)
tw:{[k1;R;I]j:(2*k1)*!Q;g:~j<M;j-:M*g;f:1.0-2.0*g;c:f*wc j;s:f*ws j;((R*c)+I*s;(I*c)-R*s)}
d:+tw'[!P;d 0;d 1]
(zr;zi):,/'(L-k) st/(,,/+:)'d

(ar;ai):1_'(zr;zi);(br;bi):|'(ar;ai)
Y:{[ar;ai;br;bi;c;s]((ar+br+(c*ai+bi)+s*br-ar)*ar+br+(c*ai+bi)+s*br-ar)+((ai-bi)+(c*br-ar)-s*ai+bi)*(ai-bi)+(c*br-ar)-s*ai+bi}
V:(v*v:(*zr)+*zi),Y[ar;ai;br;bi;1_wc;1_ws]

i:$[M<640;!M;[b:|/'(64;_M%64)#V;&~V<b@(>b)@9]]
i:(10&#i)#i@>V i
f9:{r:$_0.5+1e9*x;r:((0|10-#r)#"0"),r;(-9_r),".",-9#r}
`0:{($x),".0\t",f9 y}'[i;(%V i)%N]

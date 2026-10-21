N:$[#a:`argv 2;. a;#a:.[{1:x};,"/dev/stdin";{""}];. a;8388608];M:_N%2;m:4294967296;a:1103515245;c:12345
lg:(-1+#2\);L:lg M;k:_L%2;P:*/k#2;Q:_M%P

/make the random numbers: jump the LCG ahead so each chunk can start on its own, all in floats
pw:{[a;c;n]{[s](A;C;p;q):s;(A,m!A*p;C,m!(A*q)+C;m!p*p;m!(p*q)+q)}/[n;(,1;,0;a;c)]}
(A;C;p;q):pw[m!a*a;m!(a*c)+c;lg Q];A2:m!a*A;C2:m!c+a*C;(H;J;p;q):pw[p;q;lg P];S:m!J+H*m!(a*N)+c
K:{(x*4.656612873077393e-10;(65536!x)*3.0517578125e-05;y*4.656612873077393e-10)}'[(A;A2);(C;C2)]
smp:{[l;h;a;b;c]x:(a*l)+(b*h)+c;(((x-1.5258556231856346e-05)+206158430208.0)-206158430208.0)-((((x-0.9999999997671694)+13510798882111488.0)-13510798882111488.0)+1.0)}
g:{smp[1.0*65536!x;1.0*_x%65536].'K}

/the butterflies, 4 at a time when we can
wj:{[j]t:j*6.283185307179586%N;(`cos t;`sin t)}
cm:{[c;s;x](xr;xi):x;((c*xr)+s*xi;(c*xi)-s*xr)}
b4:{[t;e0;e1;u0;u1](er;ei):e0;(cr;ci):cm[t 0;t 1;u0];(ar;ai):cm[t 2;t 3;e1];(br;bi):cm[t 4;t 5;u1]
 (u0;u1):(er+cr;ei+ci);er-:cr;ei-:ci;(cr;ci):(ar+br;ai+bi);ar-:br;ai-:bi
 ((u0+cr;u1+ci);(er+ai;ei-ar);(u0-cr;u1-ci);(er-ai;ei+ar))}
b2:{[t;x;y](xr;xi):x;(yr;yi):cm[t 0;t 1;y];((xr+yr;xi+yi);(xr-yr;xi-yi))}
tt:{[R;nr;r]j:(_M%nr)*r;+,/wj'$[R=4;(j;j%2;1.5*j);,j]}

/the twist between the two halves, from two small tables instead of lots of cos and sin
b:64&Q;ia:&(_Q%b)#b;(TAc;TAs):(P;_Q%b)#/:wj(2*b)*,/(!P)*\:!_Q%b;(TBc;TBs):(P;b)#/:wj 2*,/(!P)*\:!b
twd:{[nr;r;o]{[o;r](ac;as):(TAc r;TAs r)@\:ia;(bc;bs):Q#/:(TBc r;TBs r);cm[(ac*bc)-as*bs;(as*bc)+ac*bs;o]}'[o;r+nr*!#o]}
none:{[nr;r;o]o}

/one pass over the chunks, then the fft: big passes first, then each block of rows on its own core while it is in cache
F:{[B;pre;post;nr;a]post[nr;a 0;B .(,a 1),pre a 2]}
lp:{[D;nr;R;pre;post;rho;n0;par]cr:_(#D)%nr;h:_cr%R;rl:&nr#h;e:(cr*rl)+(nr*h)#!h;r:rho+n0*rl;nr:n0*nr
 rl:F[$[R=4;b4;b2];pre;post;nr];a:+(r;tt[R;nr;r];+D e+/:h*!R);,/+$[par;`pe(rl;a);rl'a]}
lr:{[D;q;pre;post;rho;n0]j:0;do[#q;(nr;R):q j;D:lp[D;nr;R;$[j;::;pre];$[j=-1+#q;post;none];rho;n0;0];j+:1];D}
sched:{r:((_x%2)#4),(2!x)#2;+(-1_*\1,r;r)}
fft:{[D;n;pre;post]ps:sched n;c:#D;s:+/(c%128)>*'ps;n0:$[s<#ps;*ps s;c];i:0
 do[s;(nr;R):ps i;D:lp[D;nr;R;$[i;::;pre];$[i=-1+#ps;post;none];0;1;1];i+:1];$[s=#ps;:D;0]
 q:{[n0;p](_(p 0)%n0;p 1)}[n0]'s_ps;,/+`pe({[q;pre;post;n0;x]lr[x 0;q;pre;post;x 1;n0]}[q;$[s;::;pre];post;n0];+((n0;_c%n0)#D;!n0))}

/columns, flip, rows
D:fft[S;k;{g'x};twd];fl:{,/'+`pe({+x};(_(#x)%64&#x;64&#x)#x)}
(re;im):+D;D:0;re:fl re;im:fl im;D:+(re;im);re:0;im:0;D:fft[D;L-k;::;none]

/turn the half size answer back into the full one, a chunk and its mirror together
(cb;sb):wj[!P];(ca;sa):wj[P*!Q];pi:P!P-!P;f0:{x[;0]}'+D;G:D;D:0
Vz:{[ar;ai;br;bi;c;s]u:ar+br+(c*ai+bi)+s*br-ar;v:(ai-bi)+(c*br-ar)-s*ai+bi;(u*u)+v*v}[f0 0;f0 1;f0[0]Q!Q-!Q;f0[1]Q!Q-!Q;ca;sa]
up:{[i;j](ar;ai):G i;(br;bi):@[;0;:;]'[(G j)[;pi];f0[;Q!Q-i]]
 c:(ca[i]*cb)-sa[i]*sb;s:(sa[i]*cb)+ca[i]*sb;p:ar+br;q:ai+bi;d:br-ar;e:ai-bi;g:(c*q)+s*d;h:(c*d)-s*q
 (((p+g)*p+g)+(e+h)*e+h;@[(((p-g)*p-g)+(h-e)*h-e)@pi;0;:;Vz j])}
V:`pe({up[x 0;x 1]};+(!_Q%2;Q-1+!_Q%2));V:(V[;0]),|V[;1];G:0;V[0]:@[V 0;0;%;4.0]

/top 10, only looking in chunks that can hold one
(ci;cv):$[Q<10;(!M;,/V);[mx:|/'V;th:(mx@>mx)@9;,/'+{[x]j:&~(V x)<th;((P*x)+j;(V x)j)}'&~mx<th]]
i:(10&#ci)#>cv;f9:{r:"0"^-10$$_0.5+1e9*x;(-9_r),".",-9#r}
`0:{($x),".0\t",f9 y}'[ci i;(%cv i)%N]

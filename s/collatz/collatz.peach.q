B:16777216;c:{[y]({(x mod B)+0,-1_ floor x%B}/)y,0};z:{(1+(|/)where 0<x)#x};ms:{[y;s;r]z c((s*y)+r*0=til count y),0}
pw3:{[k;o]r:{[y;i]ms[y;387420489;0]}/[enlist 1;til floor k%18];r:ms[r;(*/)(k mod 18)#3;0];r:$[o;ms[r;2;0];r];ms[r;1;1]}
sh:{[y;k]d:(*/)k#2;e:floor B%d;z[(floor y%d)+e*(1_y,0)mod d]};tb:{[b]w:({[y]0<y 1}{[y]$[y[0]mod 2;(1+3*y 0;y 1;1+y 2);(floor 0.5*y 0;-1+y 1;y 2)]}/)(b;8;0);(w 2;w 0)}
a:flip(tb')til 256;TP:a[0];TR:a[1];ws:{[w]i:w mod 256;(TR[i]+((*/)(TP i)#3)*floor w%256;TP i)};lw:{[w]z[c[enlist w]]}
mp:{[y;p]$[p<19;ms[y;(*/)p#3;0];ms[ms[y;(*/)(floor 0.5*p)#3;0];(*/)(p-floor 0.5*p)#3;0]]}
blk:{[y]a:ws[first y];b:ws[a 0];d:ws[b 0];p:(a 1)+(b 1)+d 1;h:mp[z[1_y];p];u:lw[d 0];n:(count h)|count u;(z[c[(n#h,n#0)+n#u,n#0]];24+p)}
tail:{[y]v:(+/)y*({[i](*/)i#B}')til count y;(({[s]1<s 0}{[s]$[s[0]mod 2;(1+3*s 0;1+s 1);(floor 0.5*s 0;1+s 1)]}/)(v;0))1}
run:{[n]k:floor n%2;o:n mod 2;r:{[y]2<count y 0}{[y]b:blk[y 0];(b 0;(y 1)+b 1)}/(pw3[k;o];3*k);(r 1)+tail[r 0]}
-1 string run value first .z.x, enlist"100";
\\

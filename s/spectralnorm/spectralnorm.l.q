/from Amber entry Sep 2026
i:til n:value first .z.x, enlist"100"
R:16;A:{1%1+x+0.5*s*1+s:x+i}each i
G:({x _ y#i}')[-1_b;1_b:distinct(R*til ceiling n%R),n]
mv:mv:{[v](sum v*)each A};mt:{[w]sum{[w;g]sum(w g)*A g}[w]each G}
B:{mt mv x};u:B v:B 9{B B x}/n#1.0;r:first sqrt(sum u*v)%sum v*v
-1 .Q.f[9]r;

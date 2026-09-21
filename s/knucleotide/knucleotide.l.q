T:"x"$@[256#4+0i;"i"$"GTACgtac";:;0 1 2 3 0 1 2 3]
S:" " vs "GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT"
pr:{[k;c;t]-1 ({x," ",.Q.f[3]y}.'flip(k;100*c%t)) idesc c;-1"";}
{[i]i:(last where i=0x3e)_i;D::T(i?0x0a)_i;d:D where D<0x04;n:count d;u:-1_d;v:1_d;b:"x"$til 4;
    g:{[u;a]where u=a}[u]each b;c2:raze{[v;b;j]sum each(v j)=/:b}[v;b]each g;c:T last S;ix:g"i"$c 0;
    r:(enlist count ix),count each{[d;n;c;x;j]x where(x<n-j)and c[j]=d x+j}[d;n;c]\[ix;1+til 17];
    pr[enlist each"GTAC";(sum each 4 4#c2)+(til 4)="i"$last d;n];pr[flip("GTAC"raze 4#'til 4;"GTAC"raze
  4#enlist til 4);c2;n-1];
    -1{(string x),"\t",y}'[r -1+count each S;S];} read1`:/dev/stdin
\\

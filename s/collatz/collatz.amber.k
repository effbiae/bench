/collatz: steps from 1+2^n down to 1. The number is base-2^32 limbs, lowest first, allowed to run
/a little over 2^32 between carries. A block takes 32 halvings off the bottom limb with two lookups
/in 16-bit tables, then multiplies the rest by 3^k. Blocks only look at the bottom, so T of them run
/on a small window of low limbs, and the top is then multiplied by the total 3^K in whole steps of
/3^19, the most an uncarried limb can take: about one multiply-and-carry of the big number per block.
D:-B:*/32#2;Hd:-H:65536;P3:33(3*)\1;T:64
/16 halvings of every 16-bit residue at once: odd a goes to (3a+1)/2. TK odd steps, TR what is left
(TR;TK):16{(a;k):x;(-2!a+(2!a)*1+2*a;k+2!a)}/(!H;H#0);TP:P3 TK
cr:{h:D!x;x:(B!x)+0 :':h;$[t:*|h;x,t;x]}   /one round of carrying: limbs stay below 2^32+2^31
blk:{[s](x;c):s;w:B!x0:*x                  /w: the low 32 bits, exact even when x0 is over 2^32
 i:H!w;k:TK i;w:(TR i)+(TP i)*Hd!w;j:H!w;k+:TK j;w:(TR j)+(TP j)*Hd!w
 u:1_x;u[0]+:D!x0                          /divide by 2^32, keeping x0's overflow
 $[k>19;u:(P3 k-19)*cr u*P3 19;u:u*P3 k]
 u[0]+:w;(cr u;c+32+k)}
mul:{[x;K]q:-19!K;cr(P3 K-19*q)*q{cr x*P3 19}/x}   /x*3^K, carried
/x is top*2^(32(T+1)) + window; T blocks turn the window into w, and x into top*3^K*2^32 + w
bat:{[s](x;c):s;(w;d):T blk/(cr(T+1)#x;c);x:0,mul[(T+1)_x;d-c+32*T];x[!#w]+:w;$[(T+1)<#w;x:cr x;0];(x;d)}
tail:{*|{1<*x}({($[2!x;1+3*x;-2!x];y+1)}.)/x}
/1+2^n is 1+2^(n mod 2)*3^(n div 2) after 3*(n div 2) steps
run:{h:-2!x;s:mul[,1+2!x;h];s[0]+:1;(v;c):{1<#*x}blk/{(cr@*x;x 1)}{(3*T)<#*x}bat/(s;3*h);tail(*v;c)}
`0:$run@. `argv 2

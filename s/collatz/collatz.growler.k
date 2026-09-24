B:16777216                       / we chop the number into chunks, each one holds a value below 2^24
c:{[y]{(B!x)+0,-1_ _x%B}/y,0}    / carrying, same as by hand but base 2^24; repeats because a carry can spill into the next chunk too
z:{(1+|/&0<x)#x}                 / chop off the empty chunks at the top
ms:{[y;s;r]z c((s*y)+r*0=!#y),0} / Pretty much the same as the previous t3 func except that now we take 3 and 1 as arguments
                                 / and it tacks a 0 on the end so there's room when the number grows, which matters once you multiply by something big like 3^18; i.e. ms[5 1;3;1]=16 3
pw3:{[k;o]r:{[y;i]ms[y;387420489;0]}/[,1;!_k%18];r:ms[r;*/(18!k)#3;0];r:$[o;ms[r;2;0];r];ms[r;1;1]}  / This is a bit more interesting, multiplies by 3^18 precisely k/18 times, then by 3^(k mod 18).
                                                                                                     / If o=1 then it doubles, otherwise nothing, then adds 1.
sh:{[y;k]d:*/k#2;e:_B%d;z[(_y%d)+e*d!1_y,0]} / halving function generalized to dividing by 2^k; note: sh[y;1]~z hf y with hf the halving function from my prior native script
tb:{[b]w:{[y]0<y 1}{[y]$[2!y 0;(1+3*y 0;y 1;1+y 2);(_0.5*y 0;-1+y 1;y 2)]}/(b;8;0);(w 2;w 0)} / also kinda interesting, this basically runs collatz until precisely 8 halvings have happened
                                                                                              / for example: tb 7 = 5 8 because 7->22->11->34->17->52->26->13->40->20->10->5->16->8
                                                                                              / so in the time it took to get 8 halvings, the last value is 8 and there were precisely 5 triples (here 8 halvings and final number 8 is total coincidence e.g. tb 3 = 4 2)
T:tb'!256;TP:{[e]e 0}'T;TR:{[e]e 1}'T / same for all 256 bytes: TP = the triples, TR = what's left
ws:{[w]i:256!w;(TR[i]+(*/(TP i)#3)*_w%256;TP i)} / w -> TR+3^TP*(w div 256), gives (new w;triples)
lw:{[w]z[c[,w]]} / w can be bigger than one limb, so just hand it to the carry and let it split itself up
mp:{[y;p]$[p<19;ms[y;*/p#3;0];ms[ms[y;*/(_0.5*p)#3;0];*/(p-_0.5*p)#3;0]]}  / multiply by 3^p, but if p is big do it in two goes
                                                                           / otherwise a limb times 3^19+ gets too big and the carry's division stops being exact
blk:{[y]a:ws[*y];b:ws[a 0];d:ws[b 0];p:(a 1)+(b 1)+d 1;h:mp[z[1_y];p];u:lw[d 0];n:(#h)|#u;(z[c[(n#h,n#0)+n#u,n#0]];24+p)} / the whole point: three ws in a row chew through the low limb (24 bits) without touching the big number at all
                                                                                                                          / then we fix up the rest in one shot: drop the low limb (1_y is free), multiply what's left by 3^p, add the leftover w back on
                                                                                                                          / that's 24+p collatz steps for the price of about four passes, instead of 24+p passes
tail:{[y]v:+/y*{[i]*/i#B}'!#y;({[s]1<s 0}{[s]$[2!s 0;(1+3*s 0;1+s 1);(_0.5*s 0;1+s 1)]}/(v;0))1} / once it's small enough, glue the limbs back into one ordinary number and just count steps the boring way
run:{[n]k:_n%2;o:2!n;r:{[y]2<#y 0}{[y]b:blk[y 0];(b 0;(y 1)+b 1)}/(pw3[k;o];3*k);(r 1)+tail[r 0]} / put it together: jump straight to 1+2^o*3^k (that's 3k steps for free), then blocks while we still have more than 2 limbs, then the tail
`0:$run@`I$*x

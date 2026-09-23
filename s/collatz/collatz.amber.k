B:4294967296;H:2147483648

c:{[y]{(B!x)+0,-1_ _x%B}/y,0}                /carry: keep y mod B per limb, push the overflow up, repeat
z:{(1+|/&0<x)#x}                             /drop the high limbs that went to zero

hf:{[y]z[(_0.5*y)+H*2!1_y,0]}                /y div 2: halve each limb, carry the next limb's low bit in
t3:{[y]z[c[(3*y)+0=!#y]]}                    /3y+1: triple every limb, add 1 to the lowest, then carry

st:{[y]$[2!*y;t3[y];hf[y]]}                  /one step: odd -> 3y+1, even -> y div 2

n:. `argv 2

v:@[((_n%32)#0),*/(32!n)#2;0;+;1]            /start at 2^n+1
r:{[y]~(,1)~y 0}{[y](st[y 0];1+y 1)}/(v;0)   /step until the number is 1, counting steps
`0:$r 1


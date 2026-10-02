/@Fiuzeri Oct 2026 (Adapted to Amber)
D:-B:*/32#2; PW3:18(3*)\1; (TR;TP):+{2#{8>*|x}({$[2!x;(1+3*x;1+y;z);(-2!x;y;1+z)]}.)/x,0 0}'!256; PW3TP: PW3 TP
carry:{(B!x)+0 :':D!x,:0} / only one round of carrying fixes the bottom word
trim:{(-*>|0<x)_x}
pow3:{carry (PW3 18!y)*(-18!y){carry x*PW3 18}/x} / loop instead of recursion: no call-stack limit

byte:{((TR i)+(PW3TP i)*-256!x;y+TP i:256!x)}.
word:{(w;p):4 byte/(*x),0; (trim carry @[;0 1;+;(B;D)!'w] pow3[1_x;p];y+32+p)}.
tail:{*|{1<*x}({($[2!x;1+3*x;-2!x];y+1)}.)/(*x;y)}.

run:{tail{1<#*x}word/(trim carry @[;0;+;1] pow3[,1+2!x;-2!x];3*-2!x)}
`0:$run@. `argv 2

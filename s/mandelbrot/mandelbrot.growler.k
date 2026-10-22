#!/bin/env k
step:{[c;z] c+(-/z*z;2.0*/z)}
stepk:*|(*:)({[i;c;z;m] ((|/m)*i-1;c;z;m&:4.0>+/z*z:7 step[c]/z)}.)/
block0:{[z] (~^*z)&4.0>+/z*z:49 step[z]/z} / partially covered, shortcircuit unlikely
block1:{[z] stepk (7;z;z;~^*z)} / fully outside, might shortcircuit

N: (*/12#2)^. `argv 2
U: (~2!N)+-2!N
d:(|!64 64)[;|>-8!!64*64] / bit reversed tile
tx:{-1.5 -1.0+2.0*x%N}
`1:,/("P4\n";$N;" ";$N;"\n")
img:U#,/{[y] `C$(N+8!-N)#'`B$+{
 c: tx (63*!2 2)+(x;y)*64
 b:0.25 0.0625>+/'v*v:(0.25 0.0;1.0 0.0)+\:c
 $[|/&/'b;64#-1
   2|//b; `I$`b$block0@tx d+(x;y)*64
          `I$`b$block1@tx d+(x;y)*64]}[;y]'!-64!63+N}'!-64!63+U
`1:,/img,(N-U)#(~2!N)_|img

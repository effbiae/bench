#!/bin/env k
/ from @Fiuzeri  Oct 2026
step:{[c;z] c+(-/z*z;2.0*/z)}
stepk:~*|(*:)({[i;c;z;m] ((~&/m)*i-1;c;z;m|:`b$4.0<+/z*z:7 step[c]/z)}.)/
block:{[z] $[&/m: `b$(0.25>+/v*v:z+0.25 0.0)|(0.0625>+/v*v:z+1.0 0.0); m / fully inside discs
             |/m; `b$(~^*z)&4.0>+/z*z:49 step[z]/z / partially covered, shortcircuit unlikely
             stepk (7;z;z;m)]} / fully outside, might shortcircuit

N:. `argv 2
br:`c$2/|2\!256
C:-64!N+63
img:N#N#'`B$,'/,/'(2#C)#{`I$block@-1.5 -1.0+2.0*((x*64)+|!64 64)%N}'+!2#C
`1:,/("P4\n";$N;" ";$N;"\n";br 256!`C$`b$,/img)

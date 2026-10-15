/ from @Fiuzeri  Oct 2026
step:{[c;z] c+(-/z*z;2.0*/z)}
stepk:*|(*:)({[i;c;z;m] ((|/m)*i-1;c;z;m&:4.0>+/z*z:7 step[c]/z)}.)/
block:{[z] $[&/m: (0.25>+/v*v:z+0.25 0.0)|(0.0625>+/v*v:z+1.0 0.0); m / fully inside discs
             |/m; (~^*z)&4.0>+/z*z:49 step[z]/z / partially covered, shortcircuit unlikely
             stepk (7;z;z;~m)]} / fully outside, might shortcircuit

C:-64!63+N:. `argv 2
d:(|!64 64)[;|>-8!!64*64] / bit reversed tile
`1:,/("P4\n";$N;" ";$N;"\n")
{[y] `1:'`C$(N+8!-N)#'`B$+{`I$`b$block@ -1.5 -1.0+2.0*(d+(x;y)*64)%N }[;y]'!C;}'!C;

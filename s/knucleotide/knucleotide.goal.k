d:uc+/(1+x[;;3]?">TH")_x:=-read STDIN
f:{e:{>(&x!¿c)!=c:%x}p:128/"b"$x^d
 k:!e; v:"i"$round 1e5*(.e)%#p
 "\n"/{"$x "+"."/(0,-3+&y)_y:$y}'[+/""\"b"$128\k;v]}
s:!"GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT"
g:"\n"/{($+/&/("b"$x)="b"$(&x)^d)+"\t$x"}':
say"\n\n"/,/(f'1 2;g s)

/translated to goal from growler/k code by @Fiuzeri andrea piseri
cmb:{(y~*y)or:y@o[x;#y];*|(y-x){((,(1|#*x)#-1+**y),x),'y}\/,''y+!'-!1+x}
PI:3.14159265358979323
SOLARMASS:4*PI*PI
DAYSPERYEAR:365.24

BODIES:![!"name p v m"
         (::;+:;+:;::)@'+(
          ("sun"   ;  0.0                     0.0                     0.0
                      0.0                     0.0                     0.0
                      SOLARMASS)
          ("jupiter"; 4.84143144246472090e00 -1.16032004402742839e00  -1.03622044471123109e-01
                      1.66007664274403694e-03 7.69901118419740425e-03 -6.90460016972063023e-05*DAYSPERYEAR
                      9.54791938424326609e-04*SOLARMASS)
          ("saturn";  8.34336671824457987e00  4.12479856412430479e00  -4.03523417114321381e-01
                     -2.76742510726862411e-03 4.99852801234917238e-03  2.30417297573763929e-05*DAYSPERYEAR
                      2.85885980666130812e-04*SOLARMASS)
          ("uranus";  1.28943695621391310e01 -1.51111514016986312e01  -2.23307578892655734e-01
                      2.96460137564761618e-03 2.37847173959480950e-03 -2.96589568540237556e-05*DAYSPERYEAR
                      4.36624404335156298e-05*SOLARMASS)
          ("neptune"; 1.53796971148509165e01 -2.59193146099879641e01   1.79258772950371181e-01
                      2.68067772490389322e-03 1.62824170038242295e-03 -9.51592254519715870e-05*DAYSPERYEAR
                      5.15138902046611451e-05*SOLARMASS))]

PAIRS:cmb[2;!#*BODIES]
(BODIESp;BODIESv;BODIESm):BODIES"p""v""m"

adv:{[dt]
  dist:-/'BODIESp[;PAIRS]
  mass:-1 1*|BODIESm[PAIRS]
  mag:dist*`dt%norm*sqrt norm:+/dist*dist
  BODIESv[;,/PAIRS]+:,'/mass*´`mag
  BODIESp+:dt*BODIESv
  dt}

advance:{y adv/x}

energy:{
  d:-/'BODIESp[;PAIRS]
  M:*/BODIESm[PAIRS]
  m:BODIESm
  v:BODIESv
  u:+/M%sqrt+/d*d
  k:0.5*+/m*+/v*v
  k-u}

report:{say{"-0."/"-."\"."/(0,-9+&x)_x:$"i"$round 1e9*x}energy 1}
offset:{p:-+/'BODIESv*`BODIESm;BODIESv[;0]:p%BODIESm[0]}

{offset 1;report 1;advance[0.01;x];report 1}"i"$ARGS 1

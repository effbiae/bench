cmb:{?[y~*y;::;:y@o[x;#y]];*|(y-x){((,(1|#*x)#-1+**y),x),'y}\/,''y+!'-!1+x}
PI:3.14159265358979323
SOLARMASS:4*PI*PI
DAYSPERYEAR:365.24

S:       ("sun";(0. 0 0;0. 0 0;SOLARMASS)
      "jupiter";(4.84143144246472090e00 -1.16032004402742839e00 -1.03622044471123109e-01
                1.66007664274403694e-03 7.69901118419740425e-03 -6.90460016972063023e-05 * DAYSPERYEAR
                9.54791938424326609e-04 * SOLARMASS)
       "saturn";(8.34336671824457987e00 4.12479856412430479e00 -4.03523417114321381e-01
               -2.76742510726862411e-03 4.99852801234917238e-03 2.30417297573763929e-05 * DAYSPERYEAR
                2.85885980666130812e-04 * SOLARMASS)
       "uranus";(1.28943695621391310e01 -1.51111514016986312e01 -2.23307578892655734e-01
                2.96460137564761618e-03 2.37847173959480950e-03 -2.96589568540237556e-05 * DAYSPERYEAR
                4.36624404335156298e-05 * SOLARMASS)
      "neptune";(1.53796971148509165e01 -2.59193146099879641e01 1.79258772950371181e-01
                2.68067772490389322e-03 1.62824170038242295e-03 -9.51592254519715870e-05 * DAYSPERYEAR
                5.15138902046611451e-05 * SOLARMASS))
S@:&2!!#S
PAIRS:+cmb[2;!#S]
/
def advance(dt, n, bodies=S, pairs=PAIRS):

    for i in range(n):
        for (([x1, y1, z1], v1, m1),
             ([x2, y2, z2], v2, m2)) in pairs:
            dx = x1 - x2
            dy = y1 - y2
            dz = z1 - z2
            mag = dt * ((dx * dx + dy * dy + dz * dz) ** (-1.5))
            b1m = m1 * mag
            b2m = m2 * mag
            v1[0] -= dx * b2m
            v1[1] -= dy * b2m
            v1[2] -= dz * b2m
            v2[0] += dx * b1m
            v2[1] += dy * b1m
            v2[2] += dz * b1m
        for (r, [vx, vy, vz], m) in bodies:
            r[0] += dt * vx
            r[1] += dt * vy
            r[2] += dt * vz
\
deltav:{[dt;p]S0:S@*p; p1:*S0;v1:S0 1;m1:S0 2
              S1:S@p 1;p2:*S1;v2:S1 1;m2:S1 2
        d:p1-p2;mag:dt*1%x*sqrt x:+/d*d
        (v1-d*mag*m2;v2+d*mag*m1)}
adv:{[dt]{[dt;x]S::@[S;x;:;{@[S x;1;:;y]}'[x;deltav[dt;x]]]}[dt]'PAIRS
         {[dt;x]S::@[S;x;{[dt;x;y;z](x+dt*y;y;z)}[dt].]}[dt]'!#S;dt}
advance:{y adv/x}
/

def report_energy(bodies=S, pairs=PAIRS, e=0.0):

    for (((x1, y1, z1), v1, m1),
         ((x2, y2, z2), v2, m2)) in pairs:
        dx = x1 - x2
        dy = y1 - y2
        dz = z1 - z2
        e -= (m1 * m2) / ((dx * dx + dy * dy + dz * dz) ** 0.5)
    for (r, [vx, vy, vz], m) in bodies:
        e += m * (vx * vx + vy * vy + vz * vz) / 2.
    print("%.9f" % e)
\
reportp:{S0:*S;S1:S 1;
         S0:S@*x; p1:*S0;v1:S0 1;m1:S0 2
         S1:S@x 1;p2:*S1;v2:S1 1;m2:S1 2
         d:p1-p2;(m1*m2)%sqrt+/d*d}
reportx:{(-+/(reportp'PAIRS))++/{(p;v;m):x;m*(+/v*v)%2.}'S}
report:{say{"-0."/"-."\"."/(0,-9+#""\x)_x:$"i"$_0.5+1e9*x}reportx 1}
/
def offset_momentum(ref, bodies=S, px=0.0, py=0.0, pz=0.0):

    for (r, [vx, vy, vz], m) in bodies:
        px -= vx * m
        py -= vy * m
        pz -= vz * m
    (r, v, m) = ref
    v[0] = px / m
    v[1] = py / m
    v[2] = pz / m
\
offset:{p:-+/{(p;v;m):x;v*m}'S;S[0;1]:p%S[0;2]}
/
def main(n, ref='sun'):
    offset_momentum(BODIES[ref])
    report_energy()
    advance(0.01, n)
    report_energy()

if __name__ == '__main__':
    main(int(sys.argv[1]))
\
{offset 1;report 1;advance[0.01;x];report 1}"i"$ARGS 1

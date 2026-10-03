#from Fiuzeri
from math import sqrt
import sys

def dot(u,v):
  return sum(ui*vi for ui,vi in zip(u,v))

def mv(M,u):
  return [dot(Mi,u) for Mi in M]

def main(n):
  A  = [[1.0/((i+j)*(i+j+1)/2+i+1) for j in range(n)] for i in range(n)]
  At = [[1.0/((i+j)*(i+j+1)/2+i+1) for i in range(n)] for j in range(n)]
  u = v = [1]*n
  for i in range(20):
    u, v = v, mv(At,mv(A,v))
  print("%.9f" % sqrt(dot(u,v)/dot(u,u)))

if __name__ == '__main__':
  main( int(sys.argv[1]) if len(sys.argv) > 1 else 100 )

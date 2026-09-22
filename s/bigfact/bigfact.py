#print (x!+x)!/x!!
import sys;sys.set_int_max_str_digits(1000000)
def prod(x,y): #(x+y)!/x!
 r=x+1
 for i in range(r+1,x+y+1):r*=i
 return r
fact=lambda x:prod(0,x)
f =lambda x:fact(fact(x)+x)/fact(fact(x)) #(x!+x)!/x!!
fO=lambda x:prod(fact(x),x) #optimised f
a=5;assert(fO(a)==f(a))
print(fO(int((sys.argv+["300"])[1])))

#print (x!+x)!/x!
import sys;sys.set_int_max_str_digits(1000000)
def prod(x,y): #(f+x)!/f!
 r=x+1
 for i in range(r+1,x+y+1):r*=i
 return r
fact=lambda x:prod(0,x)
exp= lambda x:fact(fact(x)+x)/fact(fact(x)) #(x!+x)!/x!
expO=lambda x:prod(fact(x),x) #simplified (x!+x)!/x!
a=5;assert(expO(a)==exp(a))
print(expO(int((sys.argv+["300"])[1])))

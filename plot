#!/usr/bin/env python3
from plotnine import*;from pandas import *;from subprocess import run;import os,json,sys;from scipy.stats import gmean
m=(sys.argv+["index"])[1]
want='suite imp memory cputime walltime returnvalue terminationreason'.split()
t=read_csv(f"{m}.csv")[want]
a=t.groupby(['suite','imp']).agg({'walltime':['median'],'memory':['median'],'cputime':['median'],'returnvalue':['max'],
                                  'terminationreason':['first']})
a.columns=[c[0]for c in a.columns];a=a.reset_index()
n=merge(a,a.groupby(['suite'])['walltime'].min(),on='suite')
n['norm']=n['walltime_x']/n['walltime_y']

f=n.query("returnvalue==0")
s=f.groupby('imp')['norm'].apply(gmean).sort_values()
f['imp']=Categorical(f['imp'],categories=s.index,ordered=True)
g = (
    f.groupby(['imp'])['norm']
    .agg(ymin='min', ymax='max',centre=gmean)
    .reset_index()
)
print(g)
p=(ggplot(g, aes(x='imp',y='centre'))
 + geom_errorbar(aes(ymin='ymin', ymax='ymax'), color='gray', width=0.2, size=1)
 + geom_point(size=3, color='gray')
 + theme_light()
 + labs(title="How many times slower?",
        x="Language Implementation",
        y="Program elapsed seconds%fastest program")
 + scale_y_log10()
)
p.save(f'{m}.svg')

t='''<table><tr><th>&#215; <th>source <th>2^ <th>secs <th>mem <th>gz <th>cpu secs</tr><tr>'''
imp,nj=[json.load(open(x))for x in["imp.json","o/n"]]

for n,x in n.groupby('suite'):
 x=x.sort_values(by='norm')
 print(x)
 for i,r in x.iterrows():
  i=r['imp']
  impi1=imp[i][1]if type(imp[i][1])is list else [imp[i][1]]
  bn=[f'{n}.{x}'for x in impi1 if os.path.exists(f's/{n}/{n}.{x}')][0]
  h=f'https://github.com/effbiae/bench/blob/master/s/{n}/{bn}'
  gz=len(run(f'gzip -c s/{n}/{bn}', shell=True, capture_output=True, text=False, check=True).stdout)
  a1=a.query('suite==@n and imp==@i').groupby(['suite','imp']).filter(lambda x: len(x)==1)
  tr=r['terminationreason'];rv=r['returnvalue']
  t+='<tr>'+(
   f"""<td>{r['norm']:#.3g} <td><a href="{h}">{bn}</a> <td>{nj[n]} <td>{r['walltime_x']:.3g} <td>{r['memory']/1e3:,.0f}
       <td>{gz:,}           <td>{r['cputime']:,.3g}"""if rv==0 else 
   f"""<td>x                <td><a href="{h}">{bn}</a> <td>{nj[n]} <td>'{tr}({rv})           <td>{r['memory']/1e3:,.0f}
       <td>{gz:,}           <td>'{tr}({rv})""")+'</tr>'
 t+=("<tr></tr>")
t+=("</table>")
content={'index':'''<p>This is the current round of the benchmarks game.  See <a href=r1.html>Round 1</a> for the last round performance.  It's never too late to add your language to this round or previous rounds or to improve any program from any round.  
    <p>See description of 
        <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/spectralnorm.html#spectralnorm">spectralnorm</a>. collatz requires the length of the collatz sequence starting at 1+2^x
    <p>Reference implementations are 
        <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/spectralnorm-python3-8.html>spectralnorm.py</a> and 
        <a href=https://github.com/effbiae/bench/blob/master/s/ref/collatz.py>collatz.py</a>
    ''','r1':'''    <p>These are the descriptions for 
       <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody">nbody</a> and
       <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/knucleotide.html#knucleotide>knucleotide</a> benchmarks.
    <p>Reference implementations are 
        <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/nbody-python3-8.html>nbody.py</a> and 
        <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/knucleotide-python3-1.html>knucleotide.py</a>
    <p>Python and gcc are included in the game as the languages to beat.
    '''}

with open(f'{m}.html','w')as f:
 with open(f'page.tmpl')as g:
  f.write(g.read()%{'table':t,'content':content[m],'m':m})

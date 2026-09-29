#!/usr/bin/env python3
from plotnine import*;from pandas import *;from subprocess import run;import os,json,sys
m=(sys.argv+["index"])[1]
t=read_csv(f"{m}.csv")
#print(t['suite imp walltime'.split()])
want='suite imp memory cputime walltime_x walltime_y'.split()
a=merge(t,t.groupby(['suite','imp'])['walltime'].median(),on=['suite','imp'])[want]
n=merge(a,a.groupby(['suite'])['walltime_y'].min(),on='suite')
n['norm']=n['walltime_x']/n['walltime_y_y']
print(n)
s=n.groupby('imp')['norm'].median().sort_values()
n['imp'] = Categorical(n['imp'], categories=s.index, ordered=True)
f=n.groupby(['suite','imp']).filter(lambda x: len(x)>1)
p=(ggplot(f) + geom_boxplot(aes(x="factor(imp)", y="norm"))
 + labs(title="How many times slower?",
        x="Language Implementation",
        y="Program elapsed seconds%fastest program")
 + scale_y_log10())
p.save(f'{m}.svg')
t='''<table>
     <tr>
        <th>&#215;
        <th>source
        <th>secs
        <th>mem
        <th>gz
        <th>cpu secs
      <tr>'''
imp=json.load(open("imp.json"))
for n,x in n.groupby('suite'):
 b=merge(x,x.groupby('imp')['norm'].median()).groupby('imp').first().sort_values(by='norm')
 for i,r in b.iterrows():
  impi1=imp[i][1]if type(imp[i][1])is list else [imp[i][1]]
  bn=[f'{n}.{x}'for x in impi1 if os.path.exists(f's/{n}/{n}.{x}')][0]
  h=f'https://github.com/effbiae/bench/blob/master/s/{n}/{bn}'
  gz=len(run(f'gzip -c s/{n}/{bn}', shell=True, capture_output=True, text=False, check=True).stdout)
  a1=a.query('suite==@n and imp==@i').groupby(['suite','imp']).filter(lambda x: len(x)==1)
  t+='<tr>'+(
   f"""<td>{r['norm']:#.3g} <td><a href="{h}">{bn}</a> <td>{r['walltime_x']:.3g} <td>{r['memory']/1e3:,.0f}
       <td>{gz:,}           <td>{r['cputime']:,.3g}"""if not len(a1)else 
   f"""<td>x                <td><a href="{h}">{bn}</a> <td>timeout               <td>{r['memory']/1e3:,.0f}
       <td>{gz:,}           <td>timeout""")
 t+=("<tr></tr>")
t+=("</table>")
content={'index':'''<p>This is the current round of the benchmarks game.  See <a href=r1.html>Round 1</a> for the last round performance.  It's never too late to add your language to this round or previous rounds or to improve any program from any round.  
    <p>See description of <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/spectralnorm.html#spectralnorm">spectralnorm</a>. collatz requires the length of the collatz sequence starting at 1+2^x
    ''','r1':'''    <p>These are the descriptions for <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/nbody.html#nbody">nbody</a> and <a href=https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/knucleotide.html#knucleotide>knucleotide</a> benchmarks.
    <p>Python and gcc are included in the game as the languages to beat.
    '''}

with open(f'{m}.html','w')as f:
 with open(f'page.tmpl')as g:
  f.write(g.read()%{'table':t,'content':content[m],'m':m})

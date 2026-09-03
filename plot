#!/usr/bin/env python3
from plotnine import*;from pandas import *
t=read_csv("o/run.csv")
n=merge(t,t.query('imp=="gcc"').groupby('suite')['walltime'].median(),on='suite')
n['norm']=n['walltime_x']/n['walltime_y']
s = n.groupby('imp')['norm'].median().sort_values().index
n['imp'] = Categorical(n['imp'], categories=s, ordered=True)
p=(ggplot(n) + geom_boxplot(aes(x="factor(imp)", y="norm"))
 + labs(title="How many times slower? (quartiles)",
        x="Language Implementation",
        y="Program elapsed seconds%fastest program"))
p.save('h.svg')
h=(merge(n,n.groupby(['suite','imp'])['norm'].median(),on=['suite','imp'])
   .groupby(['suite','imp']).first()
).sort_values(by=['suite','norm_y'])
t='''<table>
     <tr>
        <th>&#215;
        <th>source
        <th>secs
        <th>mem
        <th>gz
        <th>cpu secs
      <tr>'''
for n,x in n.groupby('suite'):
 b=merge(x,x.groupby('imp')['norm'].median()).groupby('imp').first().sort_values(by='norm')
 for i,r in b.iterrows():
  bn=f'{n}-{i}.ext'
  i=f'https://github.com/effbiae/bench/s/{n}/{bn}'
  t+=f"""<tr>
   <td>{r['norm']:#.3g}
   <td><a href="{i}">{bn}</a>
   <td>{r['walltime_x']:>6.2f}
   <td>{round(r['memory']/1e3):>10}
   <td>gz
   <th>{r['cputime']:>6.2f}
   </tr>"""
 t+=("<tr>")
t+=("</table>")
with open('index.html','w')as f:
 with open('index.tmpl')as g:
  f.write(g.read().replace('<table>',t))

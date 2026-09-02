#!/usr/bin/env python3
from plotnine import*;from pandas import *
t=read_csv("o/run.csv")
n=merge(t,t.query('imp=="gcc"').groupby('suite')['walltime'].median(),on='suite')
n['norm']=n['walltime_x']/n['walltime_y']
s = n.groupby('imp')['norm'].mean().sort_values().index
n['imp'] = Categorical(n['imp'], categories=s, ordered=True)
p=(ggplot(n) + geom_boxplot(aes(x="factor(imp)", y="norm")))
p.save('h.png')


# The Computer Language Benchmarks Game
# https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
#
# submitted by Ian Osgood
# modified by Sokolov Yura
# modified by bearophile
# 2to3
# then modified to remove hashing in non-overlapping cases (no rules)

from sys import stdin

def gen_freq(seq, frame, frequences):
    ns = len(seq) + 1 - frame
    if frame == 1:
        for s in ["A","C","G","T"]:
            frequences[s] = seq.count(s)
    else:
        # overlapping is possible, so using count is not possible.
        frequences.clear()
        for ii in range(ns):
            nucleo = seq[ii:ii + frame]
            if nucleo in frequences:
                frequences[nucleo] += 1
            else:
                frequences[nucleo] = 1
    return ns, frequences


def sort_seq(seq, length, frequences):
    n, frequences = gen_freq(seq, length, frequences)

    l = sorted(list(frequences.items()), reverse=True, key=lambda seq_freq: (seq_freq[1],seq_freq[0]))

    print('\n'.join("%s %.3f" % (st, 100.0*fr/n) for st,fr in l))
    print()

def main():
    frequences = {}
    for line in stdin:
        if line[0:3] == ">TH":
            break

    seq = []
    for line in stdin:
        if line[0] in ">;":
            break
        seq.append( line[:-1] )
    sequence = "".join(seq).upper()

    for nl in 1,2:
        sort_seq(sequence, nl, frequences)

    for se in "GGT GGTA GGTATT GGTATTTTAATT GGTATTTTAATTTATAGT".split():
        print("%d\t%s" % (sequence.count(se), se))

main()

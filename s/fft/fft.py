import sys
import numpy as np
import matplotlib.pyplot as plt
from scipy.fft import fft, fftfreq

def lcg(seed,a,c,m):
    return (a * seed + c) % m

def nlcg(n,seed,a,c,m):
    Xn = seed
    r = []
    for i in range(n):
        Xn = lcg(Xn,a,c,m)
        r.append(Xn)
    return r

N=int((sys.argv+[16])[1])
input=[i/2**31 for i in nlcg(N,N,1103515245,12345,2**31)]

# Parameters
fs = N            # Sampling frequency (Hz)
duration = 1.0    # Duration (seconds)
sampling_rate = N # Hz (Number of samples per second)

# 2. Compute the FFT
# The raw FFT contains complex numbers and is symmetric (two-sided)
fft_raw = fft(input)

# 3. Calculate the true physical frequencies
# fftfreq generates the correct frequency bins based on sample count and rate
frequencies = fftfreq(N, 1 / sampling_rate)

# 4. Clean up the spectrum for real-world visualization
# Since a real signal's FFT is symmetrical, we only look at the positive half
half_N = N // 2
positive_frequencies = frequencies[:half_N]

# Take the absolute value to get the magnitude, and normalize by N
amplitude = np.abs(fft_raw[:half_N]) / N
# Multiply by 2 to account for the dropped negative frequencies
amplitude[1:] = amplitude[1:] * 2

r=sorted(zip(positive_frequencies, amplitude),key=lambda x:-x[1])
[print(f'{x[0]}\t{x[1]:.9f}')for x in r[:10]]

import cmath,sys,numpy

def fft(x):
    """
    Compute the 1D Discrete Fourier Transform using the Cooley-Tukey FFT algorithm.
    Input array length must be a power of 2.
    """
    N = len(x)

    # Base case: a sequence of length 1 is its own DFT
    if N <= 1:
        return x

    # Check if the length is a power of 2
    if N % 2 != 0:
        raise ValueError("The length of the input array must be a power of 2.")

    # Divide step: Separate into even and odd indices
    X_even = fft(x[0::2])
    X_odd  = fft(x[1::2])

    # Combine step: Calculate the twiddle factors and merge results
    # Pre-allocating the output list
    X = [0] * N
    half_N = N // 2

    for k in range(half_N):
        # Calculate the twiddle factor W_N^k = e^(-j * 2 * pi * k / N)
        twiddle = cmath.exp(-2j * cmath.pi * k / N)

        # Butterfly operations
        X[k]          = X_even[k] + twiddle * X_odd[k]
        X[k + half_N] = X_even[k] - twiddle * X_odd[k]

    return X

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

fft_raw = fft(input)

half_N = N // 2
positive_frequencies = [float(x) for x in range(half_N)]

# Take the absolute value to get the magnitude, and normalize by N
amplitude = numpy.abs(fft_raw[:half_N]) / N
# Multiply by 2 to account for the dropped negative frequencies
amplitude[1:] = amplitude[1:] * 2

r=sorted(zip(positive_frequencies, amplitude),key=lambda x:-x[1])
[print(f'{x[0]}\t{x[1]:.9f}')for x in r[:10]]

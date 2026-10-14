import sys, numpy, scipy

# Parameters
fs = int((sys.argv+['1024'])[1]) # Sampling frequency (Hz)
duration = 1.0  # Duration (seconds)
f = 2.0  # Frequency of the square wave (Hz)

# Time vector
t = numpy.linspace(0, duration, int(fs * duration), endpoint=False)
# Generate a square wave with a 50% duty cycle (alternates between -1 and 1)
square_wave = scipy.signal.square(2 * numpy.pi * f * t, duty=0.5)

[print(x) for x in square_wave]

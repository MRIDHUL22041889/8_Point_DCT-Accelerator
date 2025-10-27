import numpy as np
from scipy.fftpack import dct

x = np.array([10, 20, 30, 40, 50, 60, 70, 80], dtype=float)
y = dct(x, type=2, norm='ortho')

print(y*2.82)

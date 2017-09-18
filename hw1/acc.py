import numpy as np
import matplotlib.pyplot as plt
plt.rc('text', usetex=True)

m = [1, 10, 100, 1000, 10000]
acc = [0.92, 0.917, 0.913, 0.855, 0.724]

plt.plot(np.log10(m),acc)
plt.xlabel('$\log_{10}(m)$')
plt.ylabel('accuracy')
plt.show()

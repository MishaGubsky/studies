import numpy as np
from second import second_phase as second_phase
from simplex_method_first import first_phase

if __name__ == '__main__':
    c = np.matrix([1, 2, 0])
    b = np.matrix([4, 2])
    A = np.matrix([[1, 3, 1], [0, 2, 1]])
    x = first_phase(c, b, A)[0]
    B = first_phase(c, b, A)[1]

    print 'x_opt', second_phase(c, B, x, A)
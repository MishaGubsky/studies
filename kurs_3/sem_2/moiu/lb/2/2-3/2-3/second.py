import numpy as np
from first import reverse as rev


def second_phase(c, B, x, A):
    Ab = np.matrix(np.zeros((A.shape[0], B.size)))
    Cb = []

    for i in range(B[0].size):
        Ab[:, i] = A[:, B[0, i]]
        Cb.append(c[0, B[0, i]])

    reverse_Ab = rev(Ab)

    return iterated(A, Ab, reverse_Ab, c, Cb, B, x)


def reverse(Ab_, reverse_Ab, k):
    l = reverse_Ab * Ab_[:, k]
    l[k] = -1
    q = l * (-1 / Ab_[k, k])
    Q = np.matrix(np.eye(len(Ab_)))
    Q[:, k] = q
    return np.matrix(Q * reverse_Ab)


def iterated(A, Ab, reverse_Ab, c, Cb, B, x):
    N = []
    for i in range(c[0].size):
        if i not in B:
            N.append(i)

    u = np.matrix(Cb * reverse_Ab)
    delta = np.matrix(u * A - c)

    J0 = None
    for i in range(len(N)):
        if delta[0, N[i]] < 0:
            J0 = N[i]
            break
    if J0 is None:
        # print x
        return x

    z = np.matrix(reverse_Ab * A[:, J0])

    theta, J_ = None, None
    for i in range(B[0].size):
        if z[i, 0] > 0:
            newtheta = x[0, B[0, i]] / z[i, 0]
            if theta is None or newtheta < theta:
                theta = newtheta
                J_ = i
    if J_ is None:
        return "The target function is not limited above!"

    x[0, J0] = theta
    for i in range(B[0].size):
        x[0, B[0, i]] -= z[i, 0] * theta

    B[0, J_] = J0
    Ab[:, J_] = A[:, J0]
    reverse_Ab = reverse(Ab, reverse_Ab, J_)
    Cb = []
    for i in range(B[0].size):
        Ab[:, i:i + 1] = A[:, B[0, i]]
        Cb.append(c[0, B[0, i]])

    return iterated(A, Ab, reverse_Ab, c, Cb, B, x)

if __name__ == '__main__':
    c = np.matrix([1, 1])
    B = np.matrix([1])
    x = np.matrix([0, 0])
    A = np.matrix([1, -1])

    # c = np.matrix([1, 1, 0, 0, 0])
    # B = np.matrix([2, 3, 4])
    # x = np.matrix([0, 0, 1, 3, 2])
    # A = np.matrix([[-1, 1, 1, 0, 0], [1, 0, 0, 1, 0], [0, 1, 0, 0, 1]])

    print second_phase(c, B, x, A)

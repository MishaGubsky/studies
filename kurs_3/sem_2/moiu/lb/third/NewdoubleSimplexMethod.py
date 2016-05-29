__author__ = 'Mikhail'
import numpy as np

from first.first import reverse
from second.second import A_little_moment


def iterated(A, Ab, reverse_Ab, c, Cb, B, b, y, d_down, d_up):
	N = []
	for i in range(c[0].size):
		if i not in B:
			N.append(i)

	delta = np.matrix(np.zeros(c[0].size))
	for i in range(c[0].size):
		delta[0, i] = y * A[:, i] - c[0, i]

	N_plus, N_minus = [], []
	for i in range(len(N)):
		if delta[0, N[i]] >= 0:
			N_plus.append(N[i])
		else:
			N_minus.append(N[i])

	return itr(N_plus, N_minus, N, reverse_Ab, delta, A, y)

def itr(N_plus, N_minus, N, reverse_Ab, delta, A, y):


	# Psevdoplan
	K = np.matrix(np.zeros(c[0].size))
	for i in range(K[0].size):
		if i in N_plus:
			K[0, i] = d_down[0, i]
		elif i in N_minus:
			K[0, i] = d_up[0, i]

	Kb = np.matrix(np.zeros(len(N)))

	sum = np.matrix(np.zeros(A.shape[0]))
	for i in range(len(N)):
		sum += A[:, N[i]].transpose() * K[0, N[i]]

	index = reverse_Ab * np.matrix(b - sum).transpose()

	for i in range(len(B)):
		K[0, B[i]] = index[i, 0]

	J0 = None
	for i in range(len(B)):
		if K[0, B[i]] < d_down[0,B[i]] or K[0, B[i]] > d_up[0,B[i]]:
			J0 = B[i]
			break

	if J0 is None:
		print('\nOptimal plan:')
		return K


	if K[0, J0] < d_down[0, J0]:
		S = 1
	else: # K[J0] > d_up[0, J0]:
		S = -1

	delta_y = S * reverse_Ab[B.index(J0), :]


	Mu = np.matrix(np.zeros(c[0].size))
	for i in range(c[0].size):
		Mu[0, i] = np.matrix(delta_y * A[:, i])



	sigma = np.matrix(np.zeros(len(N)))
	for i in range(sigma[0].size):
		sigma[0, i] = float('inf')

	sigmaMin = float('inf')
	Jn = None
	for i in range(len(N)):
		if (N[i] in N_plus and Mu[0, N[i]] < 0) or (N[i] in N_minus and Mu[0, N[i]] > 0):
			sigma[0, i] = - delta[0, N[i]] / Mu[0, N[i]]
			if sigma[0, i] < sigmaMin:
				sigmaMin = sigma[0,i]
				Jn = N[i]

	if Jn is None:
		return "The objective function is not limited from above!"


	new_delta = np.matrix(np.zeros(c[0].size))
	for i in range(new_delta[0].size):
		new_delta[0,i] = delta[0,i]+ Mu[0,i]*sigmaMin

	new_y = y + delta_y * sigmaMin

	B.remove(J0)
	B.append(Jn)

	Ab = np.matrix(np.zeros((A.shape[0], len(B))))
	Cb = []
	for i in range(len(B)):
		Ab[:, i] = A[:, B[i]]
		Cb.append(c[0, B[i]])


	reverse_Ab = np.linalg.inv(Ab)

	N.remove(Jn)
	N.append(J0)

	if Jn in N_plus:
		N_plus.remove(Jn)
	else:
		N_minus.remove(Jn)

	if S == 1:
		N_plus.append(J0)
	else:
		N_minus.append(J0)


	return itr(N_plus, N_minus, N, reverse_Ab, new_delta, A, new_y)



def iterate(A, B, c, b, d_down, d_up):
	Ab = np.matrix(np.zeros((A.shape[0], len(B))))
	Cb = []
	for i in range(len(B)):
		Ab[:, i] = A[:, B[i]]
		Cb.append(c[0, B[i]])

	reverse_Ab = np.linalg.inv(Ab)


	y = np.matrix(Cb * reverse_Ab)

	return iterated(A, Ab, reverse_Ab, c, Cb, B, b, y, d_down, d_up)


# c = np.matrix([-1, -1, 0, 0, 0])
# B = np.matrix([2, 3, 4])
# A = np.matrix([[1, -5, 1, 0, 0], [-3, 1, 0, 1, 0], [1, 1, 0, 0, 1]])
# b = np.matrix([-10, -12, 1])

c = np.matrix([-2, 1, 0, 4, 3, 1])
B = [1, 3, 4]
b = np.matrix([3, 1, -3])
A = np.matrix([[1, 1, -1, 0, 0, 2], [1, 0, 2, 1, 0, -3], [1, 0, 4, 0, 1, 3]])
d_down = np.matrix([0, 0, 0, 0, 0, 0])
d_up = np.matrix([0, 0, 0, 0, 0, 0])


# c = np.matrix([2, 3, -1, 4, -2, 5, 1])
# B = [1, 3, 4]
# b = np.matrix([10, 4, 10])
# A = np.matrix([[-3, 1, 1, 2, 0, 6, -2], [4, 2, 1, 0, 0, -5, 0], [5, 0, 1, 0, 1, -3, 1]])
# d_down = np.matrix([-1, 0, 1, -1, 0, 1, 0])
# d_up = np.matrix([3, 3, 3, 3, 3, 3, 3])


print(iterate(A, B, c, b, d_down, d_up))

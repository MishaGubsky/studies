__author__ = 'Mikhail'
import numpy as np

from first.first import reverse
from second.second import A_little_moment


def iterated(A, Ab, reverse_Ab, c, Cb, B, b, y):
	N = []
	for i in range(c[0].size):
		if i not in B:
			N.append(i)
	N = np.matrix(N)

	# Psevdoplan
	K = np.matrix(np.zeros(c[0].size))
	Kb = np.matrix(reverse_Ab * np.transpose(b))

	for j in range(Kb.size):
		K[0, B[0, j]] = Kb[j, 0]

	Jn = 0
	for i in range(Kb.size):
		if Kb[i] < 0 and Kb[i] < Kb[Jn]:
			Jn = i

	if Jn == 0 and Kb[Jn] >= 0:
		print('\nOptimal plan:')
		print(K)
		return

	# Jn = B[0, Jn]
	# print('Kappa:')
	# print(K)

	delta_y = reverse_Ab[Jn, :]
	Mu = np.matrix(np.zeros(N[0].size))
	compatible = False
	for i in range(N[0].size):
		Mu[0, i] = np.matrix(delta_y * A[:, N[0, i]])
		if Mu[0, i] < 0:
			compatible = True

	if not compatible:
		print('\nSystem is not compatible!')
		return

	# print("Mu:")
	# print(Mu)

	j, s = 0, np.matrix(np.zeros(N[0].size))

	for j in range(Mu[0].size):
		if Mu[0, j] < 0:
			s[0, j] = (c[0, N[0, j]] - float(np.transpose(A[:, N[0, j]]) * np.transpose(y))) / Mu[0, j]
		else:
			s[0, j] = Mu[0, j]

	# print("Sigma:")
	# print(z)

	s0, J0 = min((s[0, idx], idx) for idx in range(s[0].size))

	# Jn <-> J0
	B[0, Jn] = N[0, J0]


	# print('\nIteration:')

	# new Ab
	Ab[:, Jn] = A[:, N[0, J0]]

	# print('Ab:')
	# print(Ab)

	# new reverse_Ab
	reverse_Ab = A_little_moment(Ab, reverse_Ab, Jn)

	# reverse_Ab = np.linalg.inv(Ab)
	# print('reverse_Ab:')
	# print(reverse_Ab)

	# new Cb
	Cb = []
	for i in range(B[0].size):
		Cb.append(c[0, B[0, i]])

	# new y
	y = y + s0 * delta_y
	# print("Co-plan:")
	# print(y)

	return iterated(A, Ab, reverse_Ab, c, Cb, B, b, y)


def iterate(A, B, c, b):
	# print('Iteration:')
	Ab = np.matrix(np.zeros((A.shape[0], B.size)))
	Cb = []

	for i in range(B[0].size):
		Ab[:, i] = A[:, B[0, i]]
		Cb.append(c[0, B[0, i]])

	# print('Ab:')
	# print(Ab)

	reverse_Ab = reverse(Ab)
	# print('reverse_Ab:')
	# print(reverse_Ab)

	# print("Co-plan:")
	y = np.matrix(Cb * reverse_Ab)

	iterated(A, Ab, reverse_Ab, c, Cb, B, b, y)


# c = np.matrix([-1, -1, 0, 0, 0])
# B = np.matrix([2, 3, 4])
# A = np.matrix([[1, -5, 1, 0, 0], [-3, 1, 0, 1, 0], [1, 1, 0, 0, 1]])
# b = np.matrix([-10, -12, 1])

c = np.matrix([-4, -3, -7, 0, 0])
B = np.matrix([3, 4])
b = np.matrix([-1, -1])
A = np.matrix([[-2, -1, -4, 1, 0], [-2, -2, -2, 0, 1]])

iterate(A, B, c, b)

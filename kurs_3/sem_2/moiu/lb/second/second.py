__author__ = 'Mikhail'

import numpy as np

from first.first import reverse as rev

def main():
	ma, vc, vx, vB = [], [], [], []
	with open('inputForSecondLb') as f:
		vc.append(list(map(lambda x: int(x), f.readline().replace("c=", '').split(','))))
		vx.append(list(map(lambda x: int(x), f.readline().replace("x=", '').split(','))))
		vB.append(list(map(lambda x: int(x) - 1, f.readline().replace("B=", '').split(','))))
		for l in f.readlines():
			ma.append(list(map(lambda x: int(x), l.replace('\n', '').split(' '))))


	# I need to work
	c = np.matrix(vc,dtype=np.float)
	B = np.matrix(vB,dtype=np.float)
	x = np.matrix(vx,dtype=np.float)
	A = np.matrix(ma,dtype=np.float)
	return secondPhase(c,B,x,A)



def secondPhase(vc,vB,vx,ma):

	np.set_printoptions(precision=5, suppress=True)
	c = vc
	B = vB
	x = vx
	A = ma

	Ab = np.matrix(np.eye(B[0].size))
	Cb = []
	for i in range(B[0].size):
		Ab[:, i:i + 1] = A[:, B[0, i]:B[0, i]+1]
		Cb.append(c[0, B[0, i]])


	reverse_Ab = rev(Ab)
	reverse_Ab = np.linalg.inv(Ab)

	return iterated(A, Ab, reverse_Ab, c, Cb, B, x)


def A_little_moment(Ab_, reverse_Ab, k):
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
		return "The objective function is not limited from above!"


	x[0, J0] = theta
	for i in range(B[0].size):
		x[0, B[0, i]] -= z[i, 0] * theta

	B[0, J_] = J0
	Ab[:, J_] = A[:, J0]
	# reverse_Ab = A_little_moment(Ab, reverse_Ab, J_)

	reverse_Ab = np.linalg.inv(Ab)
	Cb.clear()
	for i in range(B[0].size):
		Ab[:, i:i + 1] = A[:, B[0, i]]
		Cb.append(c[0, B[0, i]])

	return iterated(A, Ab, reverse_Ab, c, Cb, B, x)


# print(main())

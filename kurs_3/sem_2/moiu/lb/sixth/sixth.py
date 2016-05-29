__author__ = 'Mikhail'
import numpy as np

from first.first import reverse
from second.second import secondPhase as sp

def fun(f, x):
	value = float(f[0] * x.transpose())
	D = 0
	for k in range(f[1][0].size):
		for l in range(f[1][0].size):
			if k == l:
				D += f[1][k, k] * x[0, k]
			else:
				D += 0.5 * f[1][k, l] * x[0, k] * x[0, l]
	value += D * 0.5
	return value

def calculate_grad(f, x):
	grad = np.matrix(np.zeros(x[0].size))  # ?
	for i in range(x[0].size):
		grad[0, i] = f[0][0, i] + f[1][i] * x.transpose()

	return grad


def get_active_indexes(G, x):
	indexes = []
	for i in range(len(G)):
		value = fun(G[i], x) + G[i][2]
		if value == 0:
			indexes.append(i)
	return indexes


def to_canonical(grad, not_zero_indexes):
	new_grad = np.matrix(np.zeros(grad[0].size + len(not_zero_indexes)))
	j = 0
	for i in range(grad[0].size):
		new_grad[0, j] = grad[0, i]
		j += 1
		if i in not_zero_indexes:
			new_grad[0, j] = -grad[0, i]
			j += 1
	return new_grad


def add_limitations(grad_G, x, indexes):
	grad = np.matrix(np.zeros((len(grad_G) + x[0].size, grad_G[0][0].size + x[0].size + len(grad_G))))
	side_index = grad_G[0][0].size
	for i in range(len(grad_G)):
		grad[i, 0:grad_G[i][0].size] = grad_G[i]
		grad[i, side_index] = 1
		side_index += 1

	for i in range(x[0].size):
		grad[len(grad_G) + i, i] = 1
		grad[len(grad_G) + i, side_index] = 1
		side_index += 1
		if i in indexes:
			grad[len(grad_G) + i, i + 1] = -1
	return grad


def update_grad_f(grad_f, size):
	grad = np.matrix(np.zeros(size))
	grad[0, 0:grad_f[0].size] = -1 * grad_f[0]
	return grad


def get_plan(opt_l, x, not_zero_indexes):
	l = np.matrix(np.zeros(x[0].size))
	j = 0
	for i in range(x[0].size):
		l[0, i] = opt_l[0, j]
		j += 1
		if i in not_zero_indexes:
			l[0, i] = opt_l[0, j]
			j += 1
	return l


def calculate_x_(x, t, new_l, alpha, slater_x):
	return x + t * new_l + alpha * t * (slater_x - x)


def start(f, G, slater_x, x):
	grad_f = calculate_grad(f, x)

	# active indexes
	Ia = get_active_indexes(G, x)

	grad_G = []
	for i in Ia:
		grad_G.append(calculate_grad(G[i], x))

	# # to canonical view
	not_zero_indexes = np.nonzero(x[0].transpose())[0]
	canonical_grad_f = to_canonical(grad_f, not_zero_indexes)


	canonical_grad_G = []
	for i in range(len(grad_G)):
		canonical_grad_gi = to_canonical(grad_G[i], not_zero_indexes)
		canonical_grad_G.append(canonical_grad_gi)


	# prepare to simplex method
	new_grad_G = add_limitations(canonical_grad_G, x, not_zero_indexes)
	new_grad_f = update_grad_f(canonical_grad_f, new_grad_G[0].size)
	l = np.matrix(np.zeros(new_grad_G[0].size))
	for i in range(l[0].size - x[0].size, l[0].size):
		l[0, i] = 1
	B = np.matrix([i for i in range(l[0].size - new_grad_G[:, 0].size, l[0].size)])


	opt_l = sp(new_grad_f, B, l, new_grad_G)
	print(opt_l)

	# opt_l = np.matrix([1, 0, 0, 0, 0, 1])
	new_l = get_plan(opt_l, x, not_zero_indexes)

	# check opt x~
	if grad_f * new_l.transpose() == 0:
		print('Plan opt:')
		print(x)
		return

	a = grad_f * new_l.transpose()
	b = (slater_x - x) * grad_f.transpose()
	if b > 0:
		alpha = -a / (2 * b)
	else:
		alpha = 1

	t = 2
	loop = True
	x_ = None
	while loop:
		t /= 2
		print("t = {}".format(t))
		x_ = calculate_x_(x, t, new_l, alpha, slater_x)
		if fun(f, x) < fun(f, x_) and all([fun(G[i], x_) >= 0 for i in range(len(G))]):
			loop = False
	print('Plan opt:')
	print(x)
	return














########################## input  ########################
def input():
	# f:
	c = np.matrix([-3, -3])
	D = np.matrix([[2, 1], [1, 2]])
	f = (c, D)


	# G:
	G = []

	# gi:
	c = np.matrix([1, -1])
	D = np.matrix([[1, 0], [0, 1]])
	alpha = -1
	gi = (c, D, alpha)
	G.append(gi)

	c = np.matrix([-1, 1])
	D = np.matrix([[1, 0.5], [0.5, 1]])
	alpha = -3 / 2
	gi = (c, D, alpha)
	G.append(gi)

	slater_x = np.matrix([0, 0])
	x = np.matrix([0, 1])

	start(f, G, slater_x, x)


input()

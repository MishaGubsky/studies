__author__ = 'Mikhail'
import numpy as np


def north_west_method(a, b):
	x = np.matrix(np.zeros((a[0].size, b[0].size)))
	j, i = 0, 0
	B = []
	while i in range(a[0].size):
		m = min(a[0, i], b[0, j])
		a[0, i] -= m
		b[0, j] -= m
		x[i, j] = m
		B.append((i, j))
		if a[0, i] == 0:
			i += 1
		if b[0, j] == 0:
			j += 1
	answer = {'B': B, 'x': x}
	return answer


def compute_u_v(B, c):
	u_count = c[0].size - 1
	v_count = c[:, 0].size
	a = np.array(np.zeros((len(B), u_count + v_count)))
	b = np.array(np.zeros(len(B)))
	for i in range(len(B)):
		if B[i][0] != 0:
			a[i, B[i][0] - 1] = 1
		a[i, u_count + B[i][1]] = 1
		b[i] = c[B[i][0], B[i][1]]
	solved_u_v = np.linalg.solve(a, b)

	u = [0]
	for i in range(u_count):
		u.append(solved_u_v[i])

	v = []
	for i in range(u_count, u_count + v_count):
		v.append(solved_u_v[i])

	return {'u': u, 'v': v}


def getNeighbors(node, seq):
	neighbors = []
	row = False
	colomn = False
	for j in seq:
		if j[0] == node[0] and not colomn:
			neighbors.append(j)
			colomn = True
		if j[1] == node[1] and not row:
			neighbors.append(j)
			row = True
	return neighbors


def createPath(h, node, path):
	for i in h[node]:
		if i not in path:
			path.append(i)
			return createPath(h, i, path)
	return path


def find_cycle(B, start_node):
	seq = set(B)
	h = {}
	for i in range(len(B)):
		seq.remove(B[i])
		nodes = getNeighbors(B[i], seq)
		if len(nodes) > 1:
			seq.add(B[i])
			h.setdefault(B[i], nodes)
	return createPath(h, start_node, [start_node])


def iterate(x, B, c):
	u_v = compute_u_v(B, c)
	u = u_v['u']
	v = u_v['v']

	# calculate N
	N = []
	for i in range(c[0].size):
		for j in range(c[:, 0].size):
			if (i, j) not in B:
				N.append((i, j))

	# check u+v < c
	for i in range(len(N)):
		if u[N[i][0]] + v[N[i][1]] > c[N[i][0], N[i][1]]:

			# () Add -> B
			B.append(N[i])
			B.sort()

			# calculate cycle
			path = find_cycle(B, N[i])

			# find min node of cycle and it value
			min_node = path[1]
			for i in range(1, int(len(path) / 2)):
				if x[min_node[0], min_node[1]] > x[path[i * 2 + 1][0], path[i * 2 + 1][1]]:
					min_node = path[i * 2 + 1]

			min_value = x[min_node[0], min_node[1]]


			# update X
			for i in range(len(path)):
				if i % 2:
					x[path[i][0], path[i][1]] -= min_value
				else:
					x[path[i][0], path[i][1]] += min_value


			# remove min mod from B
			B.remove(min_node)


			return iterate(x, B, c)
	return x


a = np.matrix([70, 80, 70])
b = np.matrix([100, 60, 60])
c = np.matrix([[5, 2, 8], [2, 1, 6], [7, 5, 4]])

# a = np.matrix([80, 80, 90])
# b = np.matrix([50, 100, 100])
# c = np.matrix([[1, 1, 6], [10, 3, 5], [4, 5, 8]])

# a = np.matrix([50, 50, 100])
# b = np.matrix([40, 90, 70])
# c = np.matrix([[2, 5, 3], [4, 3, 2], [5, 1, 2]])

_x = north_west_method(a, b)
B = _x['B']
x = _x['x']
# print(x)

print(iterate(x, B, c))

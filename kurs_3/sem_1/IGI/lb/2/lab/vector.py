from lab.myxrange import my_xrange

__author__ = 'Mikhail'

import random


class vector(list):
	def __init__(self, nodes=[]):
		self.nodes = nodes

	def __len__(self):
		return self.nodes.__len__()

	def __iter__(self):
		return self.nodes.__iter__()

	def __getitem__(self, item):
		return self.nodes[item]

	def __setitem__(self, key, value):
		self.nodes[key] = value

	def __eq__(self, other):
		len_eq = len(self) == len(other)
		elements_eq = all(map(lambda x, y: x == y, self, other))
		return len_eq and elements_eq

	def __add__(self, other):
		len_eq = len(self) == len(other)
		if not len_eq:
			raise ValueError('Vectors are not the same lenght')
		for i in my_xrange(self.__len__()):
			self.nodes[i] += other[i]
		return self.nodes

	def __sub__(self, other):
		len_eq = len(self) == len(other)
		if not len_eq:
			raise ValueError('Vectors are not the same lenght')
		for i in my_xrange(self.__len__()):
			self.nodes[i] -= other[i]
		return self.nodes

	def __mul__(self, other):
		if type(other) is vector:
			len_eq = len(self) == len(other)
			if not len_eq:
				raise ValueError('Vectors are not the same lenght')
			for i in my_xrange(self.__len__()):
				self.nodes[i] *= other[i]
			return self.nodes
		else:
			for i in my_xrange(self.__len__()):
				self.nodes[i] *= other
			return self.nodes

	def __rmul__(self, other):
		return self * other

	def __call__(self):
		yield self.nodes


f = vector(list(my_xrange(2, 15, 3)))
g = vector(list(my_xrange(3, 16, 3)))
print(g - f)

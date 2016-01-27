import numbers

__author__ = 'Mikhail'


class linear_function(object):
	def __init__(self, k=0, b=0):
		self.k = k
		self.b = b

	def __call__(self, x0):
		if isinstance(x0, linear_function):
			return linear_function(self.k * x0.k, self.k * x0.b + self.b)
		elif isinstance(x0, numbers.Number):
			return self.k * x0 + self.b
		else:
			raise ValueError('Arguments not correct')

	def __getitem__(self, item):
		return self(item)

	def __add__(self, other):
		if not isinstance(other, (numbers.Number, linear_function)):
			raise ValueError('Arguments not correct')
		elif isinstance(other, linear_function):
			return linear_function(self.k + other.k, self.b + other.b)
		else:
			return linear_function(self.k, self.b + other)

	def __mul__(self, other):
		if not isinstance(other, (numbers.Number, linear_function)):
			raise ValueError('Arguments not correct')
		elif isinstance(other, linear_function):
			return linear_function(self.k * other.k, self.k * other.b + self.b)
		else:
			return linear_function(self.k * other, self.b * other)

	def __str__(self):
		if self.k == 0 and self.b == 0:
			return "f(x) = 0".format(round(self.k, 2), round(self.b, 2))
		elif self.k == 0:
			return "f(x) = {}".format(round(self.b, 2))
		elif self.b == 0:
			return "f(x) = {}x".format(round(self.k, 2))
		else:
			if self.b > 0:
				return "f(x) = {}x + {}".format(round(self.k, 2), round(self.b, 2))
			else:
				return "f(x) = {}x - {}".format(round(self.k, 2), round(self.b, 2).__abs__())

	def __eq__(self, other):
		if isinstance(other, linear_function):
			return self.k == other.k and self.b == other.b
		else:
			return False

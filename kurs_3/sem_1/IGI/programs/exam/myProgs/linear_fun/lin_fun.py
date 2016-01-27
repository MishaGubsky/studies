import numbers

__author__ = 'Mikhail'


class linear_function(object):
	def __init__(self, k=0, b=0):
		self.k = k
		self.b = b

	def __call__(self, x0):
		if isinstance(x0, linear_function):
			return linear_function(self.k * x0.k, self.b + self.k * x0.b)
		elif isinstance(x0, numbers.Number):
			return self.k * x0 + self.b

	def __add__(self, other):
		if isinstance(other, linear_function):
			return linear_function(other.k + self.k, self.b + other.b)
		elif isinstance(other, numbers.Number):
			return linear_function(self.k, self.b + other)

	def __mul__(self, other):
		if isinstance(other, linear_function):
			return linear_function(other.k * self.k, self.b + self.k * other.b)
		elif isinstance(other, numbers.Number):
			return linear_function(self.k * other, self.b * other)


	def __str__(self):
		if self.k == 0 and self.b == 0:
			return "f(x)=0"
		elif self.k == 0:
			return "f(x)={}".format(round(self.b, 2))
		elif self.b == 0:
			return "f(x)={}x".format(round(self.k, 2))
		elif self.b > 0:
			return "f(x)={}x+{}".format(round(self.k, 2), round(self.b, 2))
		elif self.b < 0:
			return "f(x)={}x-{}".format(round(self.k, 2), abs(round(self.b, 2)))


f=linear_function(5,2)
print f(linear_function(3,2))
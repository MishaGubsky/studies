import numbers

__author__ = 'Mikhail'


class recursive_dict(object):
	def __init__(self):
		self.__values__ = {};

	def __getitem__(self, key):
		if key not in self.__values__:
			self.__values__[key] = recursive_dict()
		if not isinstance(key, (str, numbers.Number)):
			raise ValueError("This key is not a string or a number")
		return self.__values__.__getitem__(key)

	def __str__(self):
		if len(self.__values__) == 0:
			return '{}'
		else:
			return '{' + '\n'.join(str(key) + ':' + str(self.__values__[key]) for key in self.__values__.keys()) + '}'

	def __setitem__(self, key, value):
		if isinstance(key, (str, numbers.Number)):
			self.__values__.__setitem__(key, value)
		else:
			raise ValueError("This key is not a string or a number")

#
# d = recursive_dict()
# d['a']['b'] = 1
# print(str(d))

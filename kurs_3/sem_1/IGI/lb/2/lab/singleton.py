import unittest

__author__ = 'Mikhail'


class singleton(object):
	def __init__(self, cls):
		self._cls = cls
		self.instance = {}

	def __call__(self, *args, **kwargs):
		if self not in self.instance:
			_inst = self._cls.__new__(self._cls, *args, **kwargs)
			_inst.__init__(*args, **kwargs)
			self.instance[self] = _inst
		return self.instance[self]

@singleton
class Sample(object):
	def __init__(self, _arg):
		self.arg = _arg
	def foo(self):
		pass


class test_singlton(unittest.TestCase):
	def test_single(self):
		first_obj = Sample(7)
		second_obj = Sample(15)
		self.assertTrue(first_obj is second_obj)
		self.assertEqual(first_obj, second_obj, 15)
		del first_obj
		first_obj = Sample(21)
		self.assertTrue(first_obj is second_obj)
		self.assertEqual(first_obj, second_obj, 7)


s = Sample(4)
d = Sample(5)
print(s is d)
print(d.foo())

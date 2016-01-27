import random
import datetime

from pip._vendor.requests.packages.urllib3.connectionpool import xrange

from fusked.class_filter import seq_filter
from lab.json import from_json, to_json
from fusked.linear_function import linear_function
from lab.logger import logger
from lab.model_creator import model_creator, str_field, bool_field, int_field, float_field
from lab.myxrange import my_xrange
from fusked.natural_merge_sort import merge_sort
from lab.recursive_dict import recursive_dict
from lab.vector import vector
from fusked.cached import cached_decorator

__author__ = 'Mikhail'

import unittest


class test_vector(unittest.TestCase):
	vector_len = 5
	items = list(range(2, 15, 3))
	_vector = vector(items)

	def test_length(self):
		self.assertEqual(len(self._vector), self.vector_len)
		self.assertEqual(len(vector()), 0)

	def test_equal(self):
		self.assertEquals(self._vector, self._vector)
		self.assertEquals(self._vector, vector(self.items))
		self.assertNotEquals(self._vector, self._vector[::-1])

	def test_iterator(self):
		self.assertEquals(self._vector, self.items)
		self.assertEquals(vector(), [])

	def test_operations(self):
		self.assertEqual(self._vector * 1, self._vector)
		self.assertEqual(self._vector * 3, 3 * self._vector)
		self.assertEqual(self._vector + self._vector, self._vector * 2)
		self.assertEqual(self._vector - self._vector, self._vector * 0)
		self.assertEqual(self._vector * self._vector, self._vector * self._vector)


class test_recDict(unittest.TestCase):
	def test_general(self):
		d = recursive_dict()
		d['a'] = 1
		d['b']['a'] = 10
		self.assertEqual(d['a'], 1)
		self.assertEqual(d['b']['a'], 10)


class test_json(unittest.TestCase):
	obj = {
		'a': 1,
		'b': '2',
		'c': [1, 2, ['1', '2', '3'], 3]
	}
	string_json_obj = '{"a": 1, "b": "2", "c": [1, 2, ["1", "2", "3"], 3]}'
	obj1 = {
		'a': [1, 2, True],
		'b': {'a': None, 'b': 1.0},
		'd': {'a': 10, 'b': {'a': 20}},
		'c': [{'a': False}, [1, 2, None], "papka"],
	}
	string_json_obj1 = '{"a": 10}, "b": {"b": 1.0, "a": null}, "c": [{"a": false}, [1, 2, null], "papka"], "a": [1, 2, true], "d": {"b": {"a": 20}}'

	def test_to_json(self):
		self.assertEquals(to_json(self.obj), self.string_json_obj)
		self.assertEquals(to_json(self.obj1), self.string_json_obj1)

	def test_from_json(self):
		self.assertEqual(from_json(self.string_json_obj), self.obj)
		self.assertEquals(from_json(to_json(self.obj)), self.obj)


#class test_singlton(unittest.TestCase):


class test_natural_sort(unittest.TestCase):
	sort_class = merge_sort()
	f = datetime.datetime.now()
	sort_class.create_sequance(500)
	print('time of creating: ' + str(datetime.datetime.now() - f))
	f = datetime.datetime.now()
	sort_class.sorting()
	print('time of sorting: ' + str(datetime.datetime.now() - f))


class test_myxrange(unittest.TestCase):
	def test_myrange(self):
		self.assertEquals([x for x in my_xrange(10)], [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
		self.assertEquals([x for x in my_xrange(10, 17)], [10, 11, 12, 13, 14, 15, 16])
		self.assertEquals([x for x in my_xrange(1, 100, 15)], [1, 16, 31, 46, 61, 76, 91])
		self.assertEquals([x for x in my_xrange(10, 1, -1)], [10, 9, 8, 7, 6, 5, 4, 3, 2])
		self.assertEquals([x for x in my_xrange(1, 10, -1)], [])


class test_model_creator(unittest.TestCase):
	class Student(object, metaclass=model_creator):
		name = str_field()
		male = bool_field(True)
		age = int_field()
		gpa = float_field()

	def test_model_creater(self):
		s1 = self.Student(name="Garik")
		self.assertEquals(s1.name, 'Garik')
		s2 = self.Student(name='Antoshka', age=19, gpa=8.7, male=True)
		self.assertEquals(s2.age, 19)
		self.assertNotEqual(s2.gpa, 9.0)
		self.assertEquals(s2.male, True)


class test_logger(unittest.TestCase):
	class LoggedClass(logger):
		def instance_method(self, a, b):
			return a + b

	def test_logger(self):
		logged_class = self.LoggedClass()
		logged_class.instance_method(10, 20)
		self.assertEqual(logged_class.log[0]['result'], 30)
		self.assertEqual(logged_class.log[0]['name'], 'instance_method')
		self.assertEqual(logged_class.log[0]['args'], (10, 20))
		self.assertNotEqual(str(logged_class), '')


class test_linear_fun(unittest.TestCase):
	def test_substitution(self):
		function = linear_function(4, 5)
		self.assertEqual(function(0), function.b)
		self.assertEqual(function(1), function.k + function.b)

	def test_composition(self):
		first_function = linear_function(2, 2)
		second_function = linear_function(5, 5)
		self.assertEqual(linear_function(10, 12), first_function(second_function))

	def test_tostring(self):
		self.assertEqual(str(linear_function(0, 0)), 'f(x) = 0')
		self.assertEqual(str(linear_function(1, 0)), 'f(x) = 1x')
		self.assertEqual(str(linear_function(-1, 0)), 'f(x) = -1x')
		self.assertEqual(str(linear_function(5, 0)), 'f(x) = 5x')
		self.assertEqual(str(linear_function(0, 5)), 'f(x) = 5')
		self.assertEqual(str(linear_function(5, 5)), 'f(x) = 5x + 5')
		self.assertEqual(str(linear_function(-5, -5)), 'f(x) = -5x - 5')

	def test_addition(self):
		function = linear_function(7, 9)
		self.assertEqual(function + function, function * 2)


class test_filter(unittest.TestCase):
	def test_filtering(self):
		filter_functions = [lambda elem: elem > 0,
		                    lambda elem: elem % 7 == 0,
		                    lambda elem: elem ** 3 > 100,
		                    ]
		iterable = [random.randint(-100, 100)
		            for i in range(100)
		            ]
		for filter_func in filter_functions:
			filtered = seq_filter(iterable)
			self.assertEquals(filtered.filter(filter_func), list(x for x in filter(filter_func, iterable)))
			self.assertNotEqual(str(filtered), '')


class test_cached(unittest.TestCase):
	@cached_decorator
	def _sum(self, numbers):
		self.num_of_calls += 1
		return sum(numbers)

	def test_cached_function(self):
		self.num_of_calls = 0
		numbers_count = 7
		numbers = [random.randint(-10, 10) for i in xrange(numbers_count)]
		self._sum(numbers)
		self.assertEqual(self._sum(numbers), sum(numbers))
		self.assertEqual(self.num_of_calls, 1)
		self.assertEqual(self._sum(numbers), self._sum(numbers))
		self.assertEqual(self._sum(numbers), sum(numbers))
		self.assertEqual(self.num_of_calls, 1)
		self.assertNotEqual(self._sum(numbers[:-1]),
		                    self._sum(numbers))
		self.assertEqual(self.num_of_calls, 2)

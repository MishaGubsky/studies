# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import to_json, from_json, ParseException

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_arrays(self):
        a = []
        b = [1, 2, 3]
        c = ['a', b, []]
        self.assertEqual(to_json(a), '[]')
        self.assertEqual(to_json(b), '[1,2,3]')
        self.assertEqual(to_json(c), '["a",[1,2,3],[]]')

    def test_values(self):
        self.assertEqual(to_json(False), 'false')
        self.assertEqual(to_json(None), 'null')
        self.assertEqual(to_json(-1.23), '-1.23')

    def test_dict(self):
        obj = {'a': {'b': 10}}
        self.assertEqual(to_json(obj), '{"a":{"b":10}}')

    def test_class(self):
        class A(object):
            def __init__(self):
                self.a = 10

        self.assertEqual(to_json(A()), '{"a":10}')

    def test_notimplemented_error(self):
        try:
            self.assertRaises(NotImplementedError, to_json(range(1, 10)))
        except RuntimeError as e:
            self.assertIsInstance(e, NotImplementedError)

    def test_parse(self):
        self.assertEqual(from_json(""), None)

    def test_parse_a(self):
        try:
            self.assertRaises(ParseException, from_json('[[]'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_b(self):
        try:
            self.assertRaises(ParseException, from_json('[{}}]'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_c(self):
        try:
            self.assertRaises(ParseException, from_json(',,'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_d(self):
        try:
            self.assertRaises(ParseException, from_json('[{{{{{}}]'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_e(self):
        try:
            self.assertRaises(ParseException, from_json('{]}'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_f(self):
        try:
            self.assertRaises(ParseException, from_json('{"a":[[[[}'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_parse_g(self):
        try:
            self.assertRaises(ParseException, from_json('{"a":{{}'))
        except BaseException as e:
            self.assertIsInstance(e, ParseException)

    def test_equal(self):
        obj = [{'a': 1, 'b': [
            [[1, 2, 3, [[5, 6, [False, [True], [{}, {}, {}, None, False, True, 10.12, -10.13123123]],
                         {'a': {'b': {'c': {'d': [-1, -2, -3, 0]}}}}]]]]]}, {}, {}, False, "sample text",
               {'!': [{}, [{'"': 'this \t is \n quote key'}, {}]]}]
        self.assertSequenceEqual(from_json(to_json(obj)), obj)

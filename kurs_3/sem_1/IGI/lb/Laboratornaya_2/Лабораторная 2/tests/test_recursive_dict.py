# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import RecursiveDict

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_general(self):
        d = RecursiveDict()
        d['a'] = 1
        d['b']['a'] = 10
        self.assertEqual(d['a'], 1)
        self.assertEqual(d['b']['a'], 10)

    def test_exceptions_set(self):
        try:
            d = RecursiveDict()
            d['a'][{}] = 1
        except Exception as e:
            self.assertIsInstance(e, KeyError)

    def test_exceptions_get(self):
        try:
            d = RecursiveDict()
            d[d]
        except Exception as e:
            self.assertIsInstance(e, KeyError)

    def test_contains(self):
        d = RecursiveDict()
        self.assertEqual('a' in d, False)
        self.assertEqual('a' in d, False)
        self.assertEqual('a' in d['a']['b']['c'], False)
        self.assertEqual('a' in d, True)
        d['a'] = 1
        self.assertEqual('a' in d, True)

    def test_delete(self):
        d = RecursiveDict()
        d['a']['b']['c'] = 10
        del d['a']['b']
        self.assertEqual('b' in d['a'], False)

    def test_str(self):
        d = RecursiveDict()
        d['a']['b'] = 1
        self.assertEqual(str(d), '{"a":{"b":1}}')
        self.assertEqual(str(RecursiveDict()), '{}')

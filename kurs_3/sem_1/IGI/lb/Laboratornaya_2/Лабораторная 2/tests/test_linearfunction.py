# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import LinearFunction

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_math(self):
        f = LinearFunction(10, 4)
        g = LinearFunction(8, 5)
        self.assertNotEqual(f, g)
        self.assertEqual(f + g, LinearFunction(18, 9))
        self.assertEqual(f - g, LinearFunction(2, -1))
        self.assertEqual(-f, LinearFunction(-10, 4))
        self.assertEqual(f(1), f[1])
        self.assertEqual(f(1), 14)
        self.assertEqual(f * 2, LinearFunction(20, 4))
        self.assertEqual(f + 2, LinearFunction(10, 6))
        self.assertEqual(f - 2, LinearFunction(10, 2))
        self.assertEqual(f(g), f[g])
        self.assertEqual(f(g), g(f))

    def test_str(self):
        f = LinearFunction(1.23, 5.6789)
        self.assertEqual(str(f), '1.23 x + 5.68')

    def test_incompatible_types_sum(self):
        try:
            f = LinearFunction(5, 6)
            f + 'a'
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_incompatible_types_mul(self):
        try:
            f = LinearFunction(5, 6)
            f * 'a'
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_incompatible_types_sub(self):
        try:
            f = LinearFunction(5, 6)
            f - 'a'
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_incompatible_types_eq(self):
        try:
            f = LinearFunction(5, 6)
            f == 'a'
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_incompatible_types_call(self):
        try:
            f = LinearFunction(5, 6)
            g = f['a']
        except Exception as e:
            self.assertIsInstance(e, TypeError)

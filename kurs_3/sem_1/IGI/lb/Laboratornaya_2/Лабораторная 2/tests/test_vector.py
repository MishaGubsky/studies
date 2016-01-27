# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import Vector

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_math(self):
        a = Vector(1, 2, 3)
        b = Vector(2, 3, 4)
        self.assertEqual(-a, Vector(-1, -2, -3))
        self.assertEqual(b - a, Vector(1, 1, 1))
        self.assertEqual(a + b, Vector(3, 5, 7))
        self.assertEqual(b - 1, a)
        self.assertEqual(a + 1, b)
        self.assertEqual(a * 1, a)
        self.assertAlmostEqual(a * a, 14)
        self.assertAlmostEqual(a.len(), 3.7417, 3)

    def test_get_set(self):
        a = Vector()
        a[10] = 10
        a[11] = 10
        a[0] = 10
        self.assertEqual(a[0], 10)
        self.assertEqual(a[10], 10)
        self.assertEqual(a[5], 0)

    def test_str(self):
        a = Vector()
        self.assertEqual(str(a), 'Vector(0, 0)')

    def test_raise_sum(self):
        try:
            a = Vector()
            self.assertRaises(TypeError, a + 'a')
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_raise_sub(self):
        try:
            a = Vector()
            self.assertRaises(TypeError, a - 'a')
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_raise_mul(self):
        try:
            a = Vector()
            self.assertRaises(TypeError, a * 'a')
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_raise_eq(self):
        try:
            a = Vector()
            self.assertRaises(TypeError, a == 'a')
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_raise_get_set(self):
        try:
            a = Vector()
            a[-1] = -1
        except Exception as e:
            self.assertIsInstance(e, IndexError)

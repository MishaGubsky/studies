# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import CustomRange

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_range(self):
        self.assertSequenceEqual([x for x in CustomRange(5)], [0, 1, 2, 3, 4])
        self.assertSequenceEqual([x for x in CustomRange(1, 5)], [1, 2, 3, 4])
        self.assertSequenceEqual([x for x in CustomRange(5, step=2)], [0, 2, 4])
        self.assertSequenceEqual([x for x in CustomRange(0, -5, step=-1)], [0, -1, -2, -3, -4])
        self.assertSequenceEqual([x for x in CustomRange(0, -5, -1)], [0, -1, -2, -3, -4])

    def test_infinite_range(self):
        try:
            self.assertRaises(ValueError, CustomRange(stop=5, step=-1))
        except Exception as e:
            self.assertIsInstance(e, ValueError)

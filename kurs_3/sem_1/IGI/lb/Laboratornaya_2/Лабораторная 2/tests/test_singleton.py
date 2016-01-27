# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import Singleton

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_singleton(self):
        class Sample(object, metaclass=Singleton):
            def __init__(self):
                self.num = 0

        a = Sample()
        b = Sample()
        self.assertEqual(a.num, b.num)
        a.num = 100
        self.assertEqual(a.num, b.num)
        b.num = 50
        self.assertEqual(a.num, b.num)

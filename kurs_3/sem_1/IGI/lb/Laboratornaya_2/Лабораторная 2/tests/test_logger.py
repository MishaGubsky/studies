# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import Logger

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_functions(self):
        logger = Logger()

        @logger(flag='TEST', format='{fname}({args})={result}')
        def f(a=10, b=20):
            return a + b

        @logger(format='{fname} -> {result}')
        def g(a=10, b=20):
            return a * b

        f()
        f(5, 5)
        g()
        g(5, 5)
        expected_log = "f(a = 10,b = 20)=30\nf(a = 5,b = 5)=10\ng -> 200\ng -> 25"
        self.assertEqual(str(logger), expected_log)
        logger.clear()
        self.assertEqual(str(logger), '')

    def test_class(self):
        class A(Logger):
            def __init__(self):
                Logger.__init__(self, format='A.{fname} -> {result}')

            def f(self, num):
                return num * num

        a = A()
        a.f(4)
        a.f(5)
        a.f(6)
        expected_log = "A.f -> 16\nA.f -> 25\nA.f -> 36"
        self.assertEqual(str(a), expected_log)

    def test_args_kwargs(self):
        logger = Logger()

        @logger(format='{fname} -> {result}')
        def h(*args, **kwargs):
            return len(args), len(kwargs)

        h(1, 2, 3)
        h(a=1, b=2, c=3)
        expected_log = 'h -> (3, 0)\nh -> (0, 3)'
        self.assertEqual(str(logger), expected_log)

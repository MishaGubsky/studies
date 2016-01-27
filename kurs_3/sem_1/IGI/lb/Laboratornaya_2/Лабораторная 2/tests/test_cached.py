# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest
from lab2 import cached

__author__ = 'asaskevich'


@cached(debug=True)
def sample_sum(a=10, b=20):
    return a + b


class TestCase(unittest.TestCase):
    def test_sample_sum(self):
        self.assertEqual(sample_sum(), 30)
        self.assertEqual(sample_sum(), 30)
        self.assertEqual(sample_sum(20), 40)

    def test_output(self):
        import sys
        from io import StringIO

        saved_stdout = sys.stdout
        try:
            out = StringIO()
            sys.stdout = out
            sample_sum(10)
            sample_sum(10)
            output = out.getvalue().strip()
            self.assertEqual(output, '@cached: calculate result 30\n@cached: (10,) {}')
        finally:
            sys.stdout = saved_stdout

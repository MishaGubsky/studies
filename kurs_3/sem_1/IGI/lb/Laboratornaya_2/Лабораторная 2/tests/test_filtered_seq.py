# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest
from lab2 import FilteredSequence, CustomRange

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_filtering(self):
        lst = [x for x in CustomRange(0, 100)]
        predicate = lambda x: 10 < x < 40 and x % 2 == 0
        filtered = list(filter(predicate, lst))

        f_seq = FilteredSequence(lst, predicate)
        self.assertSequenceEqual([x for x in f_seq], filtered)
        self.assertSequenceEqual(f_seq % predicate, filtered)

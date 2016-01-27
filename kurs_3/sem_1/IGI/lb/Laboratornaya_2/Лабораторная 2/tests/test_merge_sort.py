# !/usr/bin/python
# -*- coding: utf-8 -*-
import random
import unittest
from lab2 import merge_sort, CustomRange

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_sort(self):
        fname = 'd:/Work/JetBrains/PyCharm/lab_2/content/test_case.txt'
        chunk = 10
        n = 10 * chunk
        with open(fname, 'w') as f:
            f.writelines('{}\n'.format(random.randint(-1000000, 1000000)) for _ in range(n))

        merge_sort(fname, chunk)

        with open(fname) as f:
            nums = [int(x) for x in f.readlines()]
            for i in CustomRange(len(nums) - 1):
                self.assertLessEqual(nums[i], nums[i + 1])

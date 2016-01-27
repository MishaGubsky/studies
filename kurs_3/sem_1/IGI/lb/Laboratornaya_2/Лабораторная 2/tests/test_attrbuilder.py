# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest
from lab2 import AttrBuilderMetaClass

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_class(self):
        class Sample(object, metaclass=AttrBuilderMetaClass('d:/Work/JetBrains/PyCharm/lab_2/content/attributes.json')):
            pass

        self.assertEqual(Sample.field_a, 100)
        self.assertEqual(Sample.field_b, "some string")
        # instances
        self.assertEqual(Sample().field_a, 100)
        self.assertEqual(Sample().field_b, "some string")

        self.assertSequenceEqual(Sample.array, [1, 2, 3, 4])
        self.assertDictEqual(Sample.dict, {'a': 'a', 'b': 'b'})

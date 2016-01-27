# !/usr/bin/python
# -*- coding: utf-8 -*-
import unittest

from lab2 import ModelCreator, SetField, BoolField, StringField, ListField, TupleField, IntField, FloatField, DictField

__author__ = 'asaskevich'


class TestCase(unittest.TestCase):
    def test_something(self):
        class Sample(object, metaclass=ModelCreator):
            name = StringField()
            male = BoolField(default=True)
            phones = ListField()
            sets = SetField(default=set())
            tuples = TupleField()
            age = IntField(default='18')
            height = FloatField()
            books = DictField()

        man = Sample(name='John', sets=set([1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, ]), tuples=('a', 'b'), height=170.34)
        man.phones = [10000, 20000, 30000, 40000]
        man.books = {'Tolstoy': ['War and Peace']}
        self.assertEqual(man.name, 'John')
        self.assertEqual(man.height, 170.34)
        self.assertEqual(man.age, 18)
        self.assertSequenceEqual(man.phones, [10000, 20000, 30000, 40000])

    def test_set_raise(self):
        class Sample(object, metaclass=ModelCreator):
            name = IntField()

        try:
            s = Sample()
            s.name = '123aaa'
        except Exception as e:
            self.assertIsInstance(e, TypeError)

    def test_cast_default(self):
        try:
            class Sample(object, metaclass=ModelCreator):
                name = IntField(default=[1, 2, 3])

        except Exception as e:
            self.assertIsInstance(e, TypeError)

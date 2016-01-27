# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import ModelCreator, SetField, BoolField, StringField, ListField, TupleField, IntField, FloatField, DictField

__author__ = 'asaskevich'


def main():
    class Sample(object, metaclass=ModelCreator):
        name = StringField()
        male = BoolField(default=True)
        phones = ListField()
        sets = SetField(default=set())
        tuples = TupleField()
        age = IntField(default=18)
        height = FloatField()
        books = DictField()

    man = Sample(name='John', sets=set([1, 2, 2, 3, 3, 4, 4, 4, 5, 5, 6, ]), tuples=('a', 'b'), height=170.34)
    man.phones = [10000, 20000, 30000, 40000]
    man.books = {'Tolstoy': ['War and Peace']}
    print(man.name, man.male, man.phones, man.sets, man.tuples, man.age, man.height, man.books)


if __name__ == '__main__':
    main()

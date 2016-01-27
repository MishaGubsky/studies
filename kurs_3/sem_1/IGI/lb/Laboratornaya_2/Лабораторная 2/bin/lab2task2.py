# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import to_json

__author__ = 'asaskevich'


def main():
    class A(object):
        def __init__(self, array):
            self.a = {"a": array}
            self.b = "str"
            self.c = 10

    class B(object):
        def __init__(self):
            self.field = A([1, 2, 3])

    class C(A, B):
        def __init__(self):
            A.__init__(self, ['A', 'B'])
            B.__init__(self)
            self.complex_class = [A(['a', 'b', 'c']), B()]

    print('int:', to_json(1))
    print('float:', to_json(3.14))
    print('str:', to_json('1'))
    print('list:', to_json([1, 2, 3, ]))
    print('tuple:', to_json(('a', 'b', 'c')))
    print('dict:', to_json({'a': 1, 'b': [1, 2, 3], "c": {}, "d": {"e": 1}, "f": {"flag": True, "null": None}}))
    print('complex object:', to_json(C()))


if __name__ == '__main__':
    main()

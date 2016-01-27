# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import to_json, from_json

__author__ = 'asaskevich'


def main():
    obj = [{'a': 1, 'b': [
        [[1, 2, 3, [[5, 6, [False, [True], [{}, {}, {}, None, False, True, 10.12, -10.13123123]],
                     {'a': {'b': {'c': {'d': [-1, -2, -3, 0]}}}}]]]]]}, {}, {}, False, "sample text",
           {'!': [{}, [{'"': 'this \t is \n quote key'}, {}]]}]
    json = to_json(obj)
    parsed = from_json(json)
    print(json)
    print(parsed)
    print('obj == parsed is', parsed == obj)


if __name__ == '__main__':
    main()

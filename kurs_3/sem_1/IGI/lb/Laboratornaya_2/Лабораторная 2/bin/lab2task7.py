# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import AttrBuilderMetaClass
import re

__author__ = 'asaskevich'


def main():
    class Sample(object, metaclass=AttrBuilderMetaClass('d:/Work/JetBrains/PyCharm/lab_2/content/attributes.json')):
        pass

    for attr in dir(Sample):
        if not re.match('__[\w\d]+__', attr):
            print(attr, '=', getattr(Sample, attr))


if __name__ == '__main__':
    main()

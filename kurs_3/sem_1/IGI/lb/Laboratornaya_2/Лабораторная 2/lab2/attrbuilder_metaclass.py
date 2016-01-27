# !/usr/bin/python
# -*- coding: utf-8 -*-
from lab2 import from_json

__author__ = 'asaskevich'


def AttrBuilderMetaClass(fname):
    """
    Возвращает метакласс, загружающий аттрибуты класса из JSON-файла
    :param fname: имя JSON-файла
    :return: метакласс, зашружающий аттрибуты и добавляющий их к классу (не экземпляру)
    """

    class AttrBuilderMetaClassHidden(type):
        def __new__(cls, name, parents, dct):
            with open(fname) as attrs:
                content = ''.join(attrs.readlines())
                obj = from_json(content)
                for tuple in obj.items():
                    key = tuple[0]
                    value = tuple[1]
                    if key is not dct:
                        dct[key] = value
            return super(AttrBuilderMetaClassHidden, cls).__new__(cls, name, parents, dct)

    return AttrBuilderMetaClassHidden

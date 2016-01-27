# !/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'asaskevich'


class Singleton(type):
    """
    Метакласс - синглтон
    """
    __instances__ = {}

    def __call__(cls, *args, **kwargs):
        # при отсутствии сохраненного экземпляра - создает его
        if cls not in cls.__instances__:
            cls.__instances__[cls] = super(Singleton, cls).__call__(*args, **kwargs)
        return cls.__instances__[cls]

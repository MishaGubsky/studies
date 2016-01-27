# !/usr/bin/python
# -*- coding: utf-8 -*-
__author__ = 'asaskevich'


def cached(debug=False):
    """
    Декоратор, кеширующий вызовы функций. При повторном вызове функции с теми же аргументами возвращает закешированный
    результат
    :param debug: флаг - при его установке выводит сохраненный результат
    :return: декоратор
    """

    def cached_decorator(func):
        cache = []

        def wrapped(*args, **kwargs):
            def get_cached_result():
                for item in cache:
                    cached_args = item[0]
                    cached_kwargs = item[1]
                    cached_result = item[2]
                    args_equals = cached_args == args
                    kwargs_equals = cached_kwargs == kwargs
                    if kwargs_equals and args_equals:
                        return True, cached_result
                return False, None

            has_cached_copy, stored_result = get_cached_result()
            if has_cached_copy:
                if debug:
                    print('@cached:', args, kwargs)
                return stored_result
            else:
                result = func(*args, **kwargs)
                if debug:
                    print('@cached: calculate result', result)
                cache.append((args, kwargs, result))
                return result

        return wrapped

    return cached_decorator

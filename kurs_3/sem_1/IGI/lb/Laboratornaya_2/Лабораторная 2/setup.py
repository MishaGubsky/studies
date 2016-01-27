# !/usr/bin/python
# -*- coding: utf-8 -*-
from setuptools import setup, find_packages

from lab2 import VERSION

__author__ = 'asaskevich'

setup(name='lab2',
      version=VERSION,
      description='BSUIR, Python, Lab 2',
      author='Alex Saskevich, 353501',
      author_email='asaskevich@xbsoftware.com',
      url='https://bsuir.by/',
      packages=find_packages(),
      install_requires=[],
      test_suite='nose.collector',
      tests_require=['nose'],
      scripts=[
          'bin/lab2task1.py',
          'bin/lab2task2.py',
          'bin/lab2task3.py',
          'bin/lab2task4.py',
          'bin/lab2task5.py',
          'bin/lab2task6.py',
          'bin/lab2task7.py',
          'bin/lab2task8.py',
          'bin/lab2task9.py',
          'bin/lab2task10.py',
          'bin/lab2add_task1.py',
          'bin/lab2add_task2.py',
          'bin/lab2add_task4.py',
      ]
      )

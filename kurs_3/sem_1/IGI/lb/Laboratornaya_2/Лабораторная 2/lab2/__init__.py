# !/usr/bin/python
# -*- coding: utf-8 -*-
from .cached import cached
from .customrange import CustomRange
from .logger import Logger
from .json import to_json, from_json, ParseException
from .merge_sort import merge_sort
from .linear_function import LinearFunction
from .recursivedict import RecursiveDict
from .vector import Vector
from .filtered_seq import FilteredSequence
from .model_creator import ModelCreator, Field, StringField, ListField, TupleField, SetField, DictField, BoolField, \
    FloatField, IntField
from .attrbuilder_metaclass import AttrBuilderMetaClass
from .singleton import Singleton

VERSION = '1.2'
__author__ = 'asaskevich'

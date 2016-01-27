__author__ = 'Mikhail'


class field(object):
	def __init__(self, _type, _default):
		self.type = _type
		if _type is not object:
			self.convert = _type
		else:
			self.converter = lambda x: x
		if type(_default) is self.type:
			self.default = _default
		elif _default is not None:
			try:
				self.default = self.convert(_default)
			except:
				raise TypeError("")
		else:
			self.default = None

	def convert(self, value):
		if not issubclass(type(value), self.type):
			raise TypeError("")
		return self.converter(value)


class object_field(field):
	def __init__(self, default=None):
		super(object_field, self).__init__(object, default)


class int_field(field):
	def __init__(self, default=None):
		super(int_field, self).__init__(int, default)


class float_field(field):
	def __init__(self, default=None):
		super(float_field, self).__init__(float, default)


class str_field(field):
	def __init__(self, default=None):
		super(str_field, self).__init__(str, default)


class bool_field(field):
	def __init__(self, default=True):
		super(bool_field, self).__init__(bool, default)


class model_creator(type):
	def __call__(self, *args, **kwargs):
		instance = super(model_creator, self).__call__()
		for attr_name, value in kwargs.items():
			if not hasattr(instance, attr_name):
				setattr(instance, attr_name, value)
				#raise ValueError("not instance")
			attr = getattr(instance, attr_name)
			if issubclass(type(attr), field):
				setattr(instance, attr_name, attr.convert(value))
		return instance

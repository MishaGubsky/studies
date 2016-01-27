from functools import wraps

__author__ = 'Mikhail'


class logger(object):
	format_pattern = ''.join(('Method: {name}\n',
	                          'Arguments: {args}\n',
	                          'Result: {result}\n'))

	def __init__(self, log_format=format_pattern):
		self.log = []
		self.log_format = log_format

	def __getattribute__(self, attribute_name):
		attribute = super(logger, self).__getattribute__(attribute_name)
		if callable(attribute) and attribute_name != 'log_method':
			return self.log_method(attribute)
		else:
			return attribute

	def __str__(self):
		log_string = ''
		for method in self.log:
			log_string += self.log_format.format(**method)
		return log_string

	def log_method(self, method):
		@wraps(method)
		def wrapper(*args, **kwargs):
			result = None
			try:
				result = method(*args, **kwargs)
			except:
				result = Exception
				raise
			finally:
				self.log.append(
					{'name': method.__name__,
					 'args': args,
					 'result': result}
				)

		return wrapper

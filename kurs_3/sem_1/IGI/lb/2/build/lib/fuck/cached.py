__author__ = 'Mikhail'


def cached_decorator(fun):
	arr_of_fun_values = []

	def wrapped(*args, **kwargs):
		key = 'args: {0}, kwargs: {1}'.format(args, kwargs)
		saved_value = None
		for item in arr_of_fun_values:
			if item[0] == key:
				saved_value = item[1]
				break

		if saved_value is None:
			saved_value = fun(*args, **kwargs)
			arr_of_fun_values.append((key, saved_value))

		return saved_value
	return wrapped

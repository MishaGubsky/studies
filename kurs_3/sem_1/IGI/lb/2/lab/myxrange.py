__author__ = 'Mikhail'

def my_xrange(*args):

	start = 0
	step = 1

	if len(args) == 0:
		raise ValueError('Argument not found')
	if len(args) == 1:
		stop = args[0]
	elif len(args) == 2:
		start, stop = args[0], args[1]
	else:
		start, stop, step = args[0], args[1], args[2]

	if step == 0:
		raise ValueError('Step cannot be zero')

	if(step>0):
		i = start
		while i < stop:
			yield i
			i += step
	else:
		i = start
		while stop < i:
			yield i
			i += step



print([x for x in my_xrange(10,1,-1)])

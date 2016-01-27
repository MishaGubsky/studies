from django.shortcuts import render


# Create your views here.
from ex.models import Order


def simple_num(request, id):
	number = int(id)
	lst = list()
	seq = list(range(number + 1))
	seq[0], seq[1] = 0, 0
	i = 2
	while i <= number:
		if seq[i] != 0:
			lst.append(seq[i])
			for j in range(i, number + 1, i):
				seq[j] = 0
		i += 1
	order = Order(input=number, output=str(lst))
	order.save()
	return render(request, 'simple_num.html', {'list': lst})


def see_db(request):
	order = Order.objects.all()
	return render(request, 'see_db.html', {'items': order})

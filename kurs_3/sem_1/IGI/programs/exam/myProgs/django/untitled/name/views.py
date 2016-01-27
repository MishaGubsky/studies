from django.shortcuts import render
from name.models import Order_Model


def simple_num(request, id):
	number = int(id)
	prime = list(range(number + 1))
	prime[0] = prime[1] = 0
	lst = []
	i = 2
	while i <= number:
		if prime[i] != 0:
			lst.append(prime[i])
			for j in range(i, number + 1, i):
				prime[j] = 0
		i += 1

	order = Order_Model(input=number, output=str(lst))
	order.save()
	return render(request, 'simple_num.html', {'list': lst})


def see_db(request):
	orders = Order_Model.objects.all()
	return render(request, 'see_db.html', {'items': orders})



from django.shortcuts import render, redirect, render_to_response
import cx_Oracle
from django.http import HttpResponseRedirect
from django.contrib import auth
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required
from db_project.settings import ADMIN_CURSOR

# Create your views here.
from shop.models import *


def show_items_catalog(request):
	cur = ADMIN_CURSOR.cursor()
	cur.execute('select * from catalog_view')
	items = [Item(i) for i in cur]
	return render(request, 'catalog_list.html', {'items': items})


def item_detail(request, pk):
	# if request.COOKIES['priority'] == 1:
	cur = ADMIN_CURSOR.cursor()
	# else:
	# 	cur = cx_Oracle.connect('auth_user1128@localhost:1521/xe').cursor()
	req = "select * from items where id=" + str(pk)
	cur.execute(req)
	item = Item(list(cur)[0])
	if request.POST:
		item_name = request.POST.get('name', '')
		item_type = request.POST.get('type', '')
		item_notes = request.POST.get('notes', '')
		cur.callproc('update_item', [item.id, item_name, item_type, item_notes])
		item.name = item_name
		item.type = item_type
		item.notes = item_notes
		return redirect('/admin/adminPanel/')
	return render(request, 'item_detail.html', {'item': item})


def create_order(request):
	cur = ADMIN_CURSOR.cursor()
	cur.execute("select * from items")
	items = [Item(i) for i in cur]

	cur.execute("select * from providers")
	providers = [Provider(i) for i in cur]
	log_error = ''
	if request.POST:
		item_id = request.POST.get('item_id', '')
		provider_id = request.POST.get('provider_id', '')
		qty = request.POST.get('qty', '')
		print(item_id)
		print(provider_id)
		print(qty)
		try:
			qty = int(qty)
			cur.callproc('insert_order', [item_id, provider_id, qty])
			return redirect('/admin/adminPanel/')
		except ValueError:
			log_error = "QTY not a number"

	return render(request, 'new_order.html', {'items': items,
	                                          'providers': providers,
	                                          'log_error': log_error})


def create_invoice(request):
	cur = ADMIN_CURSOR.cursor()
	cur.execute("select * from items")
	items = [Item(i) for i in cur]

	cur.execute("select * from providers")
	providers = [Provider(i) for i in cur]
	log_error = ''
	if request.POST:
		item_id = request.POST.get('item_id', '')
		provider_id = request.POST.get('provider_id', '')
		amount = request.POST.get('amount', '')
		price = request.POST.get('price', '')

		try:
			amount = int(amount)
			price = int(price)

			cur.execute("select * from invoices_view")
			invoices = [Invoice(i) for i in cur]

			for i in invoices:
				if (i.provider_id == int(provider_id) and
						    i.item_id == int(item_id) and
					    ((i.invoice_date is None and
							      i.invoice_amount is None) or
							     i.invoice_amount < i.order_qty)
				    ):
					print(i.order_id)
					cur.callproc('insert_invoice', [i.order_id, amount, price])
					return redirect('/admin/adminPanel/')
			log_error = 'Order to this item not found'
		except ValueError:
			log_error = "Amount or Price not a number"
	return render(request, 'new_invoice.html', {'items': items,
	                                            'providers': providers,
	                                            'log_error': log_error})


def login(request):
	if request.method == "POST":
		user_name = request.POST.get('login', '')
		user_pass = request.POST.get('password', '')

		cur = ADMIN_CURSOR.cursor()
		user_exist = cur.callfunc('auth_user', cx_Oracle.NUMBER, [user_name, user_pass])

		if user_exist == -1:
			return render(request, 'login.html', {'login_error': "This login does't exist"})
		elif user_exist == 0:
			return render(request, 'login.html', {'login_error': "Wrong password"})
		else:
			print "all right"
			req = "select * from users where id=" + str(int(user_exist))
			cur.execute(req)
			user = list(cur)[0]

			response = redirect('/')
			response.set_cookie(key='priority', value=user[1])
			response.set_cookie(key='user_nickname', value=user[2])

			cur.close()
			return response
	return render(request, 'login.html', {})


def logout(request):
	response = redirect('/')
	response.delete_cookie('priority')
	response.delete_cookie('user_nickname')
	return response


def register(request):
	if request.method == "POST":
		user_name = request.POST.get('login', '')
		user_pass = request.POST.get('password', '')

		cur = ADMIN_CURSOR.cursor()
		user_exist = cur.callfunc('auth_user', cx_Oracle.NUMBER, [user_name, user_pass])

		if user_exist != -1:
			return render(request, 'register.html', {'login_error': "This login already used"})
		elif user_exist == -1:
			new_user = cur.callproc('insert_user', [user_name, user_pass])
			print list(new_user)
			response = redirect('/')
			response.set_cookie(key='priority', value=3)
			response.set_cookie(key='user_nickname', value=user_name)
			return response
	return render(request, 'register.html', {})


def adminPanel(request):
	cur = ADMIN_CURSOR.cursor()
	cur.execute("select * from user_view")
	users = [User(i) for i in cur]
	cur.execute("select * from providers")
	providers = [Provider(i) for i in cur]
	cur.execute("select * from site_item_view")
	sites = [Site(i) for i in cur]
	cur.execute("select * from invoices_view")
	invoices = [Invoice(i) for i in cur]
	cur.execute("select * from sales_view")
	sales = [SaleTable(i) for i in cur]
	cur.execute("select * from items")
	items = [Item(i) for i in cur]
	return render(request, 'adminPanel.html', {'users': users, 'providers': providers,
	                                           'sites': sites, 'invoices': invoices,
	                                           'sales': sales, 'items': items})


def user_detail(request):
	cur = ADMIN_CURSOR.cursor()
	log = "'" + str(request.COOKIES['user_nickname']) + "'"
	req = "select * from user_view where login=" + log
	print(req)
	cur.execute(req)
	user = User(list(cur)[0])

	login_error = ''
	if request.method == "POST":
		old = request.POST.get('old_password', '')
		new = request.POST.get('new_password', '')
		confirm = request.POST.get('confirm_password', '')
		print(new)
		print(confirm)
		if old != user.password:
			login_error = "Wrong old password"
		elif new != confirm:
			login_error = "Passwords don't match"
		else:
			new_user = cur.callproc('update_user', [user.id, user.role_id, user.login, new])
			print list(new_user)
			login_error = "Password saved"

	req = "select * from sales_view where user_id=" + str(user.id)
	cur.execute(req)
	sales = [SaleTable(i) for i in cur]
	has_sales = len(sales)
	return render(request, 'user_detail.html',
	              {'user': user, 'sales': sales,
	               'has_sales': has_sales,
	               'login_error': login_error})


def provider_detail(request, pk):
	cur = ADMIN_CURSOR.cursor()
	req = "select * from providers where id=" + str(pk)
	cur.execute(req)
	provider = Provider(list(cur)[0])
	if request.POST:
		provider_name = request.POST.get('name', '')
		provider_type = request.POST.get('address', '')
		provider_notes = request.POST.get('phone', '')
		cur.callproc('update_provider', [provider.id, provider_name, provider_type, provider_notes])
		return redirect('/admin/adminPanel/')
	return render(request, 'provider_detail.html', {'provider': provider})


def admin_user_detail(request, pk):
	cur = ADMIN_CURSOR.cursor()
	req = "select * from user_view where id=" + str(pk)
	cur.execute(req)
	user = User(list(cur)[0])
	req = "select * from sales_view where user_id=" + str(user.id)
	cur.execute(req)
	sales = [SaleTable(i) for i in cur]
	has_sales = len(sales)

	cur.execute("select * from roles")
	roles = [{'id': i[0], 'discription': i[1]} for i in cur]

	return render(request, 'user_detail.html',
	              {'user': user, 'sales': sales,
	               'has_sales': has_sales, 'roles': roles})


def item_delete(request, pk):
	cur = ADMIN_CURSOR.cursor()
	req = "delete from items where id=" + str(pk)
	cur.execute(req)
	return request


# def admin_user_delete(request, pk):
# 	cur = ADMIN_CURSOR.cursor()
# 	cur.callproc('delete_user', [pk])
# 	return redirect('/admin/adminPanel/')


# def provider_delete(request, pk):
# 	return None


def item_buy(request, pk):
	cur = ADMIN_CURSOR.cursor()
	req = "select * from catalog_view where catalog_id=" + str(pk)
	cur.execute(req)
	items = [Item(list(cur)[0])]
	if request.POST:
		count = request.POST.get('count', '')
		try:
			count = int(count)
			if count > items[0].count:
				log_error = "We haven't got so much!"
			else:
				user_name = "'" + str(request.COOKIES['user_nickname']) + "'"

				cur.callproc('user_order', [str(request.COOKIES['user_nickname']), items[0].id, count,
				                            items[0].price, items[0].catalog_id])
				items[0].count -= count
				log_error = "We accepted your order. Reservation expire after 48 hours.\nWe're waiting you!"
		except ValueError:
			log_error = "Input a number"

		return render(request, 'catalog_list.html', {'items': items,
		                                             'can_buy': True, 'log_error': log_error})

	return render(request, 'catalog_list.html', {'items': items,
	                                             'can_buy': True})


def create_item(request):
	if request.POST:
		name = request.POST.get('name', '')
		type = request.POST.get('type', '')
		notes = request.POST.get('notes', '')

		cur = ADMIN_CURSOR.cursor()
		cur.callproc('insert_item', [name, type, notes])
		return redirect('/admin/adminPanel/')
	return render(request, 'new_item.html')


def create_provider(request):
	if request.POST:
		name = request.POST.get('name', '')
		type = request.POST.get('address', '')
		notes = request.POST.get('phone', '')

		cur = ADMIN_CURSOR.cursor()
		cur.callproc('insert_provider', [name, type, notes])
		return redirect('/admin/adminPanel/')
	return render(request, 'new_provider.html')


def delete_order(request):
	return None


def update_sales(request):
	print(request.POST.getlist('check_list'))
	return redirect('/admin/adminPanel/')

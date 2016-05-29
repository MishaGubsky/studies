from __future__ import unicode_literals

from django.db import models


# Create your models here.
class Item():
	def __init__(self, object):
		self.id = object[0]
		self.name = object[1]
		self.type = object[2]
		self.notes = object[3]
		if len(object) > 4:
			self.price = object[4]
			self.count = object[5]
			self.catalog_id = object[6]


class User():
	def __init__(self, object):
		self.id = object[0]
		self.role_id = object[1]
		self.login = object[2]
		self.password = object[3]
		self.role = object[4]


class Provider():
	def __init__(self, object):
		self.id = object[0]
		self.name = object[1]
		self.address = object[2]
		self.phone = object[3]


class Site():
	def __init__(self, object):
		self.provider_id = object[0]
		self.item_id = object[1]
		self.item_name = object[2]
		self.provider_name = object[3]
		self.order_date = object[4]
		self.invoice_date = object[5]
		self.order_qty = object[6]
		self.invoice_amount = object[7]
		self.site_amount = object[8]


class Invoice():
	def __init__(self, object):
		self.item_id = object[0]
		self.item_name = object[1]
		self.provider_name = object[2]
		self.order_date = object[3]
		self.invoice_date = object[4]
		self.order_qty = object[5]
		self.invoice_amount = object[6]
		self.cost_price = object[7]
		self.provider_id = object[8]
		self.order_id = object[9]


class SaleTable():
	def __init__(self, object):
		self.user_id = object[0]
		self.item_id = object[1]
		self.user_login = object[2]
		self.item_name = object[3]
		self.sale_date = object[4]
		self.sale_amount = object[5]
		self.item_price = object[6]
		self.completed = object[7]

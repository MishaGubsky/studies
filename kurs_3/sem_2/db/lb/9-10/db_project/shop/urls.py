__author__ = 'Mikhail'

from django.conf.urls import url
from shop import views

urlpatterns = [
	url(r'^$', views.show_items_catalog),
	url(r'^item/(?P<pk>[0-9]+)/$', views.item_detail, name='item_detail'),
	url(r'^item/new/$', views.create_item, name='item_new'),
	url(r'^item/(?P<pk>[0-9]+|None)/buy/$', views.item_buy, name="item_catalog_buy"),

	url(r'^user/(?P<pk>[0-9]+)/$', views.admin_user_detail, name='admin_user_detail'),
	url(r'^user/userPanel/$', views.user_detail, name='user_detail'),

	url(r'^provider/(?P<pk>[0-9]+)/$', views.provider_detail, name='admin_provider_detail'),
	url(r'^provider/new/$', views.create_provider, name='provider_new'),

	url(r'^order/new/$', views.create_order, name='order_new'),
	url(r'^order(?P<pk>[0-9]+)/delete$', views.delete_order, name='order_delete'),

	url(r'^invoice/new/$', views.create_invoice, name='invoice_new'),
	url(r'^sales/update/$', views.update_sales, name='sales_update'),


	# url(r'^post/new/$', views.post_new, name='post_new'),
	# url(r'^post/(?P<pk>[0-9]+)/edit/$', views.post_edit, name='post_edit'),
	# url(r'^post/(?P<pk>[0-9]+)/comment/$', views.add_comment_to_post, name='add_comment_to_post'),
	# url(r'^comment/(?P<pk>[0-9]+)/approve/$', views.comment_approve, name='comment_approve'),
	# url(r'^comment/(?P<pk>[0-9]+)/remove/$', views.comment_remove, name='comment_remove'),
	url(r'^accounts/registration/$', views.register, name='registration'),
	url(r'^accounts/login/$', views.login, name='login'),
	url(r'^accounts/logout/$', views.logout, name='logout'),
	url(r'^admin/adminPanel/$', views.adminPanel, name='adminPanel'),
	# url(r'^post/(?P<pk>[0-9]+)/like/$', views.add_like, name='like'),
	# url(r'^post/(?P<pk>[0-9]+)/dislike/$', views.add_dislike, name='dislike'),
]

from django.conf.urls import url
from blog import views

__author__ = 'Mikhail'

urlpatterns = [
	url(r'^$', views.post_list),
	url(r'^post/(?P<pk>[0-9]+)/$', views.post_detail, name='post_detail'),
	url(r'^post/new/$', views.post_new, name='post_new'),
	url(r'^post/(?P<pk>[0-9]+)/edit/$', views.post_edit, name='post_edit'),
	url(r'^post/(?P<pk>[0-9]+)/comment/$', views.add_comment_to_post, name='add_comment_to_post'),
	url(r'^comment/(?P<pk>[0-9]+)/approve/$', views.comment_approve, name='comment_approve'),
	url(r'^comment/(?P<pk>[0-9]+)/remove/$', views.comment_remove, name='comment_remove'),
	url(r'^accounts/registration/$', views.registration, name='registration'),
	url(r'^accounts/login/$', views.login, name='login'),
	url(r'^accounts/logout/$', views.logout, name='logout'),
	url(r'^post/(?P<pk>[0-9]+)/like/$', views.add_like, name='like'),
	url(r'^post/(?P<pk>[0-9]+)/dislike/$', views.add_dislike, name='dislike'),
]

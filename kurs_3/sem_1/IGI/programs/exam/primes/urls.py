from django.conf.urls import url

from . import views

urlpatterns = [
    url(r'^list/(?P<number>[0-9]+)/$', views.index),
]

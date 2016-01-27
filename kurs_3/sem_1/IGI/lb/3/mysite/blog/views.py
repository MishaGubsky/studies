from django.shortcuts import render

from django.contrib.auth.forms import UserCreationForm
from django.views.generic import FormView

__author__ = 'Mikhail'


class RegisterFormView(FormView):
	form_class = UserCreationForm

	success_url = "/login/"
	template_name = "register.html"

	def form_valid(self, form):
		form.save()
		return super(RegisterFormView, self).form_valid(form)
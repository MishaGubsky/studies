__author__ = 'Mikhail'

from django.forms import ModelForm
from .models import *


class PostForm(ModelForm):
	class Meta:
		model = Post
		fields = ('title', 'category', 'text')

class CommentForm(ModelForm):
	class Meta:
		model = Comment
		fields = ('author', 'text')


class CategoryForm(ModelForm):
	class Meta:
		model = Category
		fields = ('category',)

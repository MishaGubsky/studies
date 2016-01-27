import datetime
from django.db import models


class Post(models.Model):
	author = models.ForeignKey('auth.User')
	category = models.ForeignKey('blog.Category', null='allow')
	title = models.CharField(max_length=200)
	text = models.TextField()
	created_date = models.DateTimeField(
		default="2015-10-10")
	published_date = models.DateTimeField(
		blank=True, null=True)

	def publish(self):
		self.published_date = datetime.datetime.now()
		self.save()

	def approved_comments(self):
		return self.comments.filter(approved_comment=True)

	def get_likes(self):
		return self.likes

	def get_dislikes(self):
		return self.dislikes

	def __str__(self):
		return self.title


class Comment(models.Model):
	post = models.ForeignKey('blog.Post', related_name='comments')
	author = models.ForeignKey('auth.User')
	text = models.TextField()
	created_date = models.DateTimeField(default="2015-10-10")
	approved_comment = models.BooleanField(default=False)

	def approve(self):
		self.approved_comment = True
		self.save()

	def __str__(self):
		return self.text


class Like(models.Model):
	post = models.ForeignKey('blog.Post', related_name='likes')
	like = models.BooleanField(default=False)
	author = models.ForeignKey('auth.User')

	def __str__(self):
		return self.author


class Dislike(models.Model):
	post = models.ForeignKey('blog.Post', related_name='dislikes')
	dislike = models.BooleanField(default=False)
	author = models.ForeignKey('auth.User')


class Category(models.Model):
	category = models.TextField(default='Not Category')

	def __str__(self):
		return self.category

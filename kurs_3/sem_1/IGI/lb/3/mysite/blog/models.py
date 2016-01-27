from django.db import models
import datetime


class Post(models.Model):
	author = models.ForeignKey('auth.User')
	title = models.CharField(max_length=200)
	caption = models.CharField(max_length=1500)
	created_date = models.DateTimeField(datetime.datetime.now())
	published_date = models.DateTimeField(blank=True, null=True)

	def publish(self):
		self.published_date = datetime.datetime.now()
		self.save()

	def __str__(self):
		return self.title

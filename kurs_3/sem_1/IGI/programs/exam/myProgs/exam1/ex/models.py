from django.db import models


# Create your models here.
class Order(models.Model):
	input = models.IntegerField()
	output = models.TextField()

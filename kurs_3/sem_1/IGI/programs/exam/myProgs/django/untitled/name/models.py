from django.db import models

class Order_Model(models.Model):
	input = models.IntegerField()
	output = models.TextField()


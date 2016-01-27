from django.db import models


class Number(models.Model):
    numbers = models.CharField(max_length=5000)
    # dateof = models.DateTimeField('Date')

    def __str__(self):
        return self.numbers

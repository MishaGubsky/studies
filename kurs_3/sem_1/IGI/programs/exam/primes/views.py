from django.shortcuts import render
from .models import *
from django.utils import timezone


def index(request, number):
    result = []
    for n in range(2, int(number) + 1):
        for i in range(2, n+1):
            if n % i == 0 and n != i:
                break
        else:
            result.append(str(n))
    result = " ".join(result)

    q = Number(numbers=result)
    q.save()

    return render(request, 'exam/primes.html', {"primes": result.split(" ")})

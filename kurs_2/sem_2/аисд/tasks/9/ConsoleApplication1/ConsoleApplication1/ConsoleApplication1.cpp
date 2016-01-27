// ConsoleApplication1.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <stdlib.h>
#include <conio.h>

int* mas;

void quickSort(int l, int r)
{
	int x = mas[l + (r - l) / 2];
	//запись эквивалентна (l+r)/2, 
	//но не вызввает переполнения на больших данных
	int i = l;
	int j = r;
	while (i <= j)
	{
		while (mas[i] < x) i++;
		while (mas[j] > x) j--;
		if (i <= j)
		{
			int c = mas[i];
			mas[i] = mas[j];
			mas[j] = c;

			i++;
			j--;
		}
	}
	if (i<r)
		quickSort(i, r);

	if (l<j)
		quickSort(l, j);
}

int _tmain(int argc, _TCHAR* argv[])
{
	int n;
	std::cin >> n;
	int* mas = (int*)malloc(sizeof(int));
	for (int i = 0; i < n; i++)
	{
		scanf("%d",mas[i]);
	}
	quickSort(0,n-1);
	std::cout << mas[n - 1] * mas[n - 2];
	return 0;
}


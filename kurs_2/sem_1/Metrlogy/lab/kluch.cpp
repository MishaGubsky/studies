// kluch.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include "stdlib.h"
#include <cstdlib>
#include <locale.h>
#include "conio.h"


int summ (int p, int** a)
{
    int sum=0;
    for (int i = 0; i < 7; i++)
    {
         sum=sum+a[i][p];
    }
    return sum;
}

int max (int*a)
{
    int max=1;
    for(int i=0; i<8;i++)
    {
        if (a[max]<a[i])
        {
           max=i;
        }
    }
   return max+1;
}

int min (int*a)
{
    int min=1;
    for(int i=0; i<8;i++)
    {
        if (a[min]>a[i])
        {
           min=i;
        }
    }
  return min+1;
}


int _tmain(int argc, _TCHAR* argv[])
{
    //srand(2);
	setlocale(LC_ALL,"Russian");
    int** a=(int**)malloc(7*sizeof(int*));
    for (int i = 0; i < 7; i++)
	{
        a[i]=(int*) malloc(8*sizeof(int));
	}

	for (int i = 0; i < 7; i++)
	{
        for (int j = 0; j < 8; j++)
		{
            a[i][j]=rand()%30;
            printf("%d ",a[i][j]);
		}
        printf("\n");
	}
	
    int* b=(int*)malloc(8*sizeof(int)) ;
    for (int i = 0; i < 8; i++)
    {
        b[i]=summ(i, a);
    }
	
    printf("\n");

    for (int j = 0; j < 8; j++)
		{
            printf("%d ",b[j]);
		}
	printf("\n");
    printf("min сумма в %d, max сумма в %d",min(b), max(b));
     printf("\n");
	system("pause");
	return 0;
}


// ConsoleApplication1.cpp : Defines the entry point for the console application.
//
//

#include "stdafx.h"
#include <stdlib.h>
#include <time.h>



int summ (int i, int** a)
{
    int sum=0;
    for (int k = 0; k < 7; k++)
    {
        sum=sum+a[k][i];
    }
    return sum;
}

int max (int*b)
{
    int max=0;
    for(int i=1; i<8;i++)
    {
        if (b[max]<b[i])
        {
           max=i;
        }
    }
   return max+1;
}

int min (int*b)
{
    int min=0;
    for(int i=1; i<8;i++)
    {
        if (b[min]>b[i])
        {
           min=i;
        }
    }
  return min+1;
}


int _tmain(int argc, _TCHAR* argv[])
{
    srand(time(NULL));
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
	
    printf("\nmin summ from %d, max summ from %d cols\n",min(b), max(b));
    
	system("pause");
	return 0;
}


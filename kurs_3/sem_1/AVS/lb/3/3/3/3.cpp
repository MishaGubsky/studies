// 3.cpp : Defines the entry point for the console application.
//
#include "stdafx.h"
#include <omp.h>
#include <iostream>

#define row_b_col_a		100
#define col_b			100
#define row_a			100
#define count_of_run	2


float a[row_a][row_b_col_a], b[row_b_col_a][col_b], c[row_a][col_b];

void initialize()
{
	for (int i = 0; i < row_b_col_a; i++)
	{
		#pragma omp parallel
		{
			#pragma omp for nowait
			for (int j = 0; j < col_b; j++)
			{
				//b[i][j] = i*j + std::pow(-1, j) * (j+5);
				b[i][j] = (float)(rand() % 100 + 9) / (rand() % 100 + 11);
			}

			#pragma omp for nowait
			for (int j = 0; j < row_a; j++)
			{
				//a[j][i] = i*j + std::pow(-1, j) * 7;

				//std::cout << omp_get_thread_num() << std::endl;
				a[j][i] = (float)(rand() % 100 + 7) / (rand() % 100 + 13);
			}
		}
	}
}


void multi()
{
	int i, col, row;

	
	#pragma omp parallel for private(i, col, row)
	for (i = 0; i < row_a; i++)
	{
		for (col = 0; col < row_b_col_a; col++)
		{
			for (row = 0; row < col_b; row++)
			{
				c[i][row] += a[i][col] * b[col][row];
				//#pragma omp critical
				//std::cout << omp_get_thread_num() << std::endl;
			}
		}
	}

}


void print()
{
	for (size_t i = 0; i < row_a; i++)
	{
		for (size_t j = 0; j < col_b; j++)
		{
			printf("%f ", c[i][j]);
		}
		printf("\n");
	}
}

void main()
{
	omp_set_dynamic(0);
	double current_time = 0, time_init = 0;
	double time_many_thread[10] = {0,0,0,0,0,0,0,0,0,0};
	for (int i = 0; i < count_of_run; i++)
	{

		current_time = omp_get_wtime();
		initialize();
		time_init += omp_get_wtime() - current_time;
		/*printf("\n");
		printf("\n");
		printf("\n");*/

		for (int p = 0; p < 10; p++)
		{

			omp_set_num_threads(p+1);
			current_time = omp_get_wtime();
			multi();
			time_many_thread[p] += omp_get_wtime() - current_time;

		}
	}

	std::cout << "Average runtime of init is " <<
		time_init / count_of_run << std::endl;

	for (int i = 0; i < 10; i++)
	{

	std::cout << "Average runtime of "<<i+1<<" thread is " << 
		time_many_thread[i]/count_of_run << std::endl;
	}

		


	//std::cout << std::endl;
	//print();
	int x;
	std::cin >> x;
}


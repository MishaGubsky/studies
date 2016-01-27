#include <iostream>
#include <vector>
using namespace std;

long long k = 0;


void Merge(int* A[], int l, int m, int r);

void MergeSort(int* A[], int l, int r)
{
	int m;

	if (l < r)
	{
		m = (l + r) / 2;
		MergeSort(A, l, m);
		MergeSort(A, m + 1, r);
		Merge(A, l, m, r);
	}
}

void Merge(int* A[], int l, int m, int r)
{
	int pos1 = l;
	int pos2 = m + 1;
	int pos3 = 0;

	int *buffer = new int[r - l + 1];

	while (pos1 <= m && pos2 <= r)
	{
		if ((*A)[pos1] <= (*A)[pos2])
		{
			buffer[pos3] = (*A)[pos1++];
			pos3++;
		}
		if ((*A)[pos1] > (*A)[pos2])
		{
			k += m + 1 - pos1;
			buffer[pos3++] = (*A)[pos2++];

		}
	}
	while (pos2 <= r)
		buffer[pos3++] = (*A)[pos2++];
	while (pos1 <= m)
		buffer[pos3++] = (*A)[pos1++];

	for (pos3 = 0; pos3 < r - l + 1; pos3++)
	{
		(*A)[l + pos3] = buffer[pos3];
	}
	delete  buffer;
}


int main()
{
	int *A = new int[1000000];
	int length;
	cin >> length;

	for (int i = 0; i < length; i++)
	{
		cin >> A[i];
	}
	MergeSort(&A, 0, length - 1);

	cout << k;
	delete A;
	return 0;
}
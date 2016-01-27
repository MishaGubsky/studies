#include <cstdio>
#include <vector>
#include <algorithm>
#include <map>
#include <iostream>

using namespace std;


int main()
{
	int n;
	cin >> n;
	map<int, size_t> A;
	for (int i = 0; i < n; i++) {
		size_t input;
		scanf("%ld", &input);
		A[input] = i + 1;
	}

	int m;
	cin >> m;
	map<int, size_t> B;
	for (int i = 0; i < m; i++) {
		size_t input;
		scanf("%ld", &input);
		B[i] = input;
	}

	vector<size_t> I;
	for (int i = 0; i < m; i++) {
		size_t temp = B[i];
		size_t index = A[temp];
		if (!index)
			A.erase(index);
		else 
			I.push_back(index - 1);
	}
	n = I.size();





	vector<long long> d(n + 1, 1000000001);

	d[0] = -1;
	for (size_t i = 0; i < n; i++) {
		size_t j = (size_t)(upper_bound(d.begin(), d.end(), I[i]) - d.begin());
		if (d[j - 1] < I[i] && I[i] < d[j])
			d[j] = I[i];
	}

	long long ans = 0;
	for (int i = 1; i < n + 1; i++)
		if (d[i] != 1000000001)
			ans = i;

	printf("%ld\n", ans);
}






#include <stdio.h>
#include <iostream>
#include <list>
using namespace std;

int main()
{
	int n = 0, k = 0;
	cin >> n >> k;
	list<long long> L;
	for (int i = 0; i < n; i++)
	{
		long long input;
		cin >> input;
		L.push_back(input);
	}
	L.sort();

	long long ans = 1, module = 1000000007;
	if (k % 2)
	{
		ans = L.back();
		ans %= module;
		L.pop_back();
		k--;
	}
	if (k > 1)
	{
		for (int i = 0; i < k; i+=2)
		{
			list<long long>::iterator after_begin = L.begin(); after_begin++;
			list<long long>::iterator previos_end = L.end(); previos_end--; previos_end--;

			long long after_first = *after_begin;
			long long prev_last = *previos_end;
			long long left = L.front();
			long long right = L.back();
			right *= prev_last; 
			left *= after_first;
			if (left >= right) 
			{
				if (ans < 0) 
				{
					left = right;
					L.pop_back(); L.pop_back();
				}
				else
				{
					L.pop_front(); L.pop_front();
				}
					left %= module;
					ans *= left;
					ans %= module;
				
			}
			else 
			{
				right %= module;
				ans *= right;
				ans %= module;
				L.pop_back(); L.pop_back();
			}
		}
	}

	if (ans < 0)
		ans += module;

	printf("%ld\n", ans);
	return 0;
}


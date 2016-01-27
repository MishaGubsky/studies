#include <iostream>
#include <algorithm>
#include <string>
#include <vector>
using namespace std;


bool IsSorted(string x) {
	for (unsigned int i = 0; i < x.length() - 1; i++) {
		if (x[i] > x[i + 1])
			return false;
	}

	return true;
}

int main()
{
	int N;
	cin >> N;
	vector<string> a;
	unsigned int shift = 0;
	vector<unsigned int> shifts;
	for (int i = 0; i < N; i++)
	{
		string input;
		cin >> input;
		if (IsSorted(input))
		{
			a.push_back(input);
			shifts.push_back(shift);
		}
		else
			shift++;
	}
	int _n = a.size();
	vector<int> d(_n, 0);
	vector<int> p(_n, -1);
	for (size_t i = 0; i < _n; i++)
	{
		d[i] = a[i].length();
		for (int j = 0; j < i; j++)
			if (a[j][a[j].length() - 1] <= a[i][0])
			{
				if (a[i].length() + d[j]>d[i])
					d[i] = d[j] + a[i].length();
				p[i] = j;
			}
	}

	int ans = 0, pos = 0;
		vector<int> path;
	if (_n > 0)
	{
		ans = d[0];
		for (int i = 1; i<_n; ++i)
			if (d[i] > ans) {
				ans = d[i];
				pos = i;
			}

		while (pos != -1) {
			path.push_back(pos+shifts[pos]);
			pos = p[pos];
		}
		sort(path.begin(), path.end());
	}
	

	cout << ans << ' ' << path.size() << endl;
	for (int i = 0; i<(int)path.size(); i++)
		cout << path[i]+1 << ' ';

	cout << endl;

	return 0;
}

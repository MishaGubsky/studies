#include <iostream>
#include <stdio.h>
using namespace std;


void Multiply(int x, int y, int z)
{
	long double C =(long double) x / z;
	for (int i = 1; i < y; i++)
	{
		C *= x;
	}
	long long _C = (long long)C;
	char s[50], _s[50];
	sprintf(_s, "%lld", _C);
	long long p = 1;
	for (int i = 0; i < y; i++)
	{
		p = (p*x)%z;
	}
	C = (long double)p / z;

	sprintf(s, "%.15Lf", C);
	cout << _s << '.' << s + 2 << endl;
}


int main()
{ 
	int x,y, z;
	cin >> x;
	cin >> y;
	cin >> z;
	Multiply(x, y, z);
	return 0;
}


#include <stdio.h>
int main(int argc, char* argv[])
{
	char* s = new char[1000 * 1000 * 30];
	gets(s);
	int i;
	for (i = 0; s[i] != '\0'; i++)
	{
		if (s[i] == ' ')
			s[i] = '\0';
	}
	i--;
	for (; i >= 0; i--)
	{
		if (s[i] == '\0')
		{
			printf(&(s[i]) + 1);
			printf(" ");
		}
	}
	printf(&(s[i]) + 1);
	delete[] s;
	return 0;
}


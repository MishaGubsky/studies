#include "stdafx.h"
#include "locale.h"


#define n			8
#define offset		n
#define def_array	{ 1, 2, 3, 4, 5, 6, 7, 8 }
#define null_array	{ 0, 0, 0, 0, 0, 0, 0, 0 }


void calc(__int8* a, __int8* b, __int8* c, __int16* d, __int16* f)
{
	__int8	mmx_a[n];
	__int8	mmx_b[n];
	__int8	mmx_c[n];
	__int16 mmx_d[n];
	__int16 mmx_f[n];

	memcpy_s(&mmx_a, n * sizeof(__int8),  a, n * sizeof(__int8));
	memcpy_s(&mmx_b, n * sizeof(__int8),  b, n * sizeof(__int8));
	memcpy_s(&mmx_c, n * sizeof(__int8),  c, n * sizeof(__int8));
	memcpy_s(&mmx_d, n * sizeof(__int16), d, n * sizeof(__int16));


	__asm 
	{
		pxor			mm7, mm7						//Обнуляем mm7

		movq			mm0, mmx_a						//Загружаем А
		paddsb			mm0, mmx_b;						//Складываем А и В
		movq			mm1, mm0						
		punpcklbw		mm0, mm7						//Расширяем до слова
		punpckhbw		mm1, mm7

		movq			mm2, mmx_c						//Загружаем С
		movq			mm3, mmx_c
		punpcklbw		mm2, mm7						//Расширяем до слова
		punpckhbw		mm3, mm7
		paddsw			mm2, mmx_d						//Складываем с D
		paddsw			mm3, mmx_d + offset;

		pmullw			mm0, mm2;						//Умножаем (A+B) * (C+D)
		pmullw			mm1, mm3
		movq			mmx_f, mm0						//Достаем результат
		movq			mmx_f + offset, mm1;
		emms
	}


	memcpy_s(f, n * sizeof(__int16), &mmx_f, n * sizeof(__int16));
}


int _tmain(int argc, _TCHAR* argv[])
{
	setlocale(LC_ALL, "");


	__int8  a[n] = def_array;
	__int8  b[n] = def_array;
	__int8  c[n] = def_array;
	__int16 d[n] = def_array;
	__int16 f[n] = null_array;
	calc(a, b, c, d, f);


	printf_s("F = (A + B) * (C + D)\n");
	printf_s("Результирующий массив: ");
	for (int i = 0; i < n; i++)
		printf_s("%d ", f[i]);


	getchar();
	return 0;
}

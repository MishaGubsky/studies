#define _CRT_SECURE_NO_WARNINGS
#define UNICODE
#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

HINSTANCE hInst;

// Идентификаторы дочерних элементов управления
#define ID_RED      2
#define ID_BLUE     3
#define ID_GREEN    4
#define ID_RHOMBUS  5
#define ID_SQUARE   6
#define ID_ROUND    7
#define ID_STAR     8
#define ID_CHECKBOX 9
// Дескрипторы окон дочерних элементов управления
HWND hWndradioGroup = NULL;
HWND hWndButton = NULL;
HWND hWndCheckBox = NULL;
HWND hWndRadioButton1 = NULL;
HWND hWndRadioButton2 = NULL;
HWND hWndEdit = NULL;
HWND hWndList = NULL;
HWND hWndCombo = NULL;
HWND hGrpButtons1 = NULL;
HWND hGrpButtons2 = NULL;
// Переменная для изменения цвета фона одного из окон
int color = 0;

char szAppName[] = "RclockApp";
char szAppTitle[] = "Remote Clock";

// Метрики шрифта с фиксированной шириной символов
LONG cxChar, cyChar;

RECT rc;
int *szBuf;
int i = 0, j = 0,k=0 ;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	WNDCLASS wc;
	HWND hWnd;
	MSG msg;

	hInst = hInstance;

	memset(&wc, 0, sizeof(wc));
	wc.lpszClassName = L"RclockApp";
	wc.lpfnWndProc = (WNDPROC)WndProc;
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.hInstance = hInstance;
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);
	// Установить цветом фона цвет элементов управления по-умолчанию:
	wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1);
	wc.lpszMenuName = NULL;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;

	RegisterClass(&wc);

	// Создание главного окна приложения.
	hWnd = CreateWindow(
		L"RclockApp", L"Win32 Элементы управления",
		WS_OVERLAPPED | CS_DBLCLKS|  // Перекрываемое окно
		WS_CAPTION |    // С заголовком
		WS_SYSMENU |    // С системным меню
		WS_MINIMIZEBOX,     // С кнопкой "свернуть"
		CW_USEDEFAULT, CW_USEDEFAULT, 800, 600,
		NULL, NULL, hInst, NULL);



	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	while (GetMessage(&msg, NULL, 0, 0))
	{
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}
	return msg.wParam;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam)
{
	wchar_t* str = L"Каркас Windows программы";
	int strLength = wcslen(str);
	UINT code;      // код уведомления
	UINT idCtrl;     // идентификатор дочернего окна
	HWND hChild;
	POINT pos;
	HDC hdc;
	TCHAR greeting[] = _T("Hello, World!");
	PAINTSTRUCT ps;
	//DWORD i=0;
	HBRUSH hBrush;
	switch (msg)
	{

	case WM_PAINT:
		HDC hdc;
		PAINTSTRUCT ps;
		RECT rc;

		// Перерисовываем внутреннюю область окна
		hdc = BeginPaint(hWnd, &ps);

		GetClientRect(hWnd, &rc);

		// Рисуем в окне строку символов, полученную от
		// приложения STIME
		DrawText(hdc, (LPCWSTR)szBuf, -1, &rc,
			DT_SINGLELINE | DT_CENTER | DT_VCENTER);

		EndPaint(hWnd, &ps);
		break;
	case WM_COPYDATA:
		szBuf =(int*) ((PCOPYDATASTRUCT)lParam)->lpData;
		//szBuf = (int*)(((PCOPYDATASTRUCT)lParam)->cbData);
		i = szBuf[0];
		j = szBuf[1];
		k = szBuf[2];
		//i = ((PCOPYDATASTRUCT)lParam)->cbData;
		// Перерисовываем содержимое окна, отображая в нем
		// полученную строку символов
		//MessageBox(NULL, (LPCWSTR)i, (LPCWSTR)i, MB_OK);
		//InvalidateRect(hWnd, NULL, TRUE);
		break;
	case WM_RBUTTONDOWN:
	case WM_LBUTTONDOWN:
	{
		if (k == 1)
		{
			hdc = GetDC(hWnd);
			hBrush = CreateSolidBrush(RGB(255, 0, 0));
			switch (i)
			{
			case 1:
				hBrush = CreateSolidBrush(RGB(255, 0, 0));
				break;
			case 2:
				hBrush = CreateSolidBrush(RGB(0, 0, 255));
				break;
			case 3:
				hBrush = CreateSolidBrush(RGB(0, 255, 0));
				break;
			}
			SelectObject(hdc, hBrush);

			switch (j)
			{
			case 1:
				POINT poly[5];

				poly[0].x = LOWORD(lParam);
				poly[0].y = HIWORD(lParam);

				poly[1].x = LOWORD(lParam) - 50;
				poly[1].y = HIWORD(lParam) + 50;

				poly[2].x = LOWORD(lParam);
				poly[2].y = HIWORD(lParam) + 100;

				poly[3].x = LOWORD(lParam) + 50;
				poly[3].y = HIWORD(lParam) + 50;

				poly[4].x = LOWORD(lParam);
				poly[4].y = HIWORD(lParam);

				Polyline(hdc, poly, 5);
				FloodFill(hdc, LOWORD(lParam), HIWORD(lParam) + 20, 0x000000);
				break;
			case 2:
				Rectangle(hdc, LOWORD(lParam), HIWORD(lParam), LOWORD(lParam) + 100, HIWORD(lParam) + 100);
				break;
			case 3:
				Ellipse(hdc, LOWORD(lParam), HIWORD(lParam), LOWORD(lParam) + 100, HIWORD(lParam) + 100);
				break;
			case 4:
				POINT poly1[11];

				poly1[0].x = LOWORD(lParam);
				poly1[0].y = HIWORD(lParam);

				poly1[1].x = LOWORD(lParam) - 20;
				poly1[1].y = HIWORD(lParam) + 50;

				poly1[2].x = LOWORD(lParam) - 80;
				poly1[2].y = HIWORD(lParam) + 50;

				poly1[3].x = LOWORD(lParam) - 30;
				poly1[3].y = HIWORD(lParam) + 75;

				poly1[4].x = LOWORD(lParam) - 50;
				poly1[4].y = HIWORD(lParam) + 100;

				poly1[5].x = LOWORD(lParam);
				poly1[5].y = HIWORD(lParam) + 80;

				poly1[6].x = LOWORD(lParam) + 50;
				poly1[6].y = HIWORD(lParam) + 100;
				poly1[7].x = LOWORD(lParam) + 30;
				poly1[7].y = HIWORD(lParam) + 75;

				poly1[8].x = LOWORD(lParam) + 80;
				poly1[8].y = HIWORD(lParam) + 50;

				poly1[9].x = LOWORD(lParam) + 20;
				poly1[9].y = HIWORD(lParam) + 50;

				poly1[10].x = LOWORD(lParam);
				poly1[10].y = HIWORD(lParam);

				Polyline(hdc, poly1, 11);
				FloodFill(hdc, LOWORD(lParam), HIWORD(lParam) + 20, 0x000000);
				break;
			}


			ReleaseDC(hWnd, hdc);
		}
	}break;
	case WM_DESTROY:
	{
		PostQuitMessage(0);
	} break;
	default: return DefWindowProc(hWnd, msg, wParam, lParam);
	}
	return 0l;
}

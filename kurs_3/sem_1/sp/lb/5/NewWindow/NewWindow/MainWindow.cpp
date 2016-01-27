
#include <windows.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

HINSTANCE hInst;


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
	UINT code;      // код уведомления
	UINT idCtrl;     // идентификатор дочернего окна
	HWND hChild;
	HDC hdc;
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
		EndPaint(hWnd, &ps);
		break;
	case WM_COPYDATA:
		szBuf =(int*) ((PCOPYDATASTRUCT)lParam)->lpData;
		i = szBuf[0];
		j = szBuf[1];
		k = szBuf[2];
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
				poly[0].y = HIWORD(lParam)-50;

				poly[1].x = LOWORD(lParam) - 40;
				poly[1].y = HIWORD(lParam) ;

				poly[2].x = LOWORD(lParam);
				poly[2].y = HIWORD(lParam) + 50;

				poly[3].x = LOWORD(lParam) + 40;
				poly[3].y = HIWORD(lParam) ;

				poly[4].x = LOWORD(lParam);
				poly[4].y = HIWORD(lParam)-50;

				Polyline(hdc, poly, 5);
				FloodFill(hdc, LOWORD(lParam), HIWORD(lParam), 0);
				break;
			case 2:
				Rectangle(hdc, LOWORD(lParam)-50, HIWORD(lParam)-50, LOWORD(lParam) + 50, HIWORD(lParam) + 50);
				break;
			case 3:
				Ellipse(hdc, LOWORD(lParam)-50, HIWORD(lParam)-50, LOWORD(lParam) + 50, HIWORD(lParam) + 50);
				break;
			case 4:
				POINT poly1[11];

				poly1[0].x = LOWORD(lParam);
				poly1[0].y = HIWORD(lParam)-90;

				poly1[1].x = LOWORD(lParam) - 30;
				poly1[1].y = HIWORD(lParam) - 30;

				poly1[2].x = LOWORD(lParam) - 90;
				poly1[2].y = HIWORD(lParam) - 20;

				poly1[3].x = LOWORD(lParam) - 50;
				poly1[3].y = HIWORD(lParam) + 30;

				poly1[4].x = LOWORD(lParam) - 60;
				poly1[4].y = HIWORD(lParam) + 90;




				poly1[5].x = LOWORD(lParam);
				poly1[5].y = HIWORD(lParam) + 70;

				poly1[6].x = LOWORD(lParam) + 60;
				poly1[6].y = HIWORD(lParam) + 90;

				poly1[7].x = LOWORD(lParam) + 50;
				poly1[7].y = HIWORD(lParam) + 30;

				poly1[8].x = LOWORD(lParam) + 90;
				poly1[8].y = HIWORD(lParam) - 20;

				poly1[9].x = LOWORD(lParam) + 30;
				poly1[9].y = HIWORD(lParam) - 30;

				poly1[10].x = LOWORD(lParam);
				poly1[10].y = HIWORD(lParam)-90;

				Polyline(hdc, poly1, 11);
				FloodFill(hdc, LOWORD(lParam), HIWORD(lParam), 0);
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
	return 0;
}

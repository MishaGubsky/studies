#include <windows.h>
#include <time.h>
#include <tchar.h>

#define SCREEN_W	1366
#define SCREEN_H	768
#define WINDOW_W	800
#define WINDOW_H	600

#define BUTTON_W	96
#define BUTTON_H	32

#define SQUARE_LEN			20

#define ID_MAIN_WND			0
#define ID_CANVAS_WND		1
#define ID_BTN_START_WND	2
#define ID_BTN_STOP_WND		3 


const TCHAR szWindowClass[] = _T("win32app");
const TCHAR szTitle[] = _T("Lab6");

HWND hWndCanvas, hWndStartBtn, hWndStopBtn;
HANDLE threads[3];	//handle's of threads
POINT pos[3];
int c = -1;

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

DWORD CALLBACK MyThreadFunc(LPVOID param);
void RandomFunc(POINT &speed);

HBRUSH colors[3]={
	CreateSolidBrush(RGB(0, 255, 255)),
	CreateSolidBrush(RGB(255, 0, 255)),
	CreateSolidBrush(RGB(255, 255, 0))}; 
 
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
	WNDCLASS wc;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.hCursor = LoadCursor(hInstance, IDC_ARROW);
	wc.hIcon = LoadIcon(hInstance, IDI_APPLICATION);
	wc.hInstance = hInstance;
	wc.hbrBackground = HBRUSH(COLOR_WINDOW + 1);
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.lpszMenuName = nullptr;
	wc.lpszClassName = szWindowClass;
	wc.lpfnWndProc = WndProc;

	if (!RegisterClass(&wc))
	{
		MessageBox(nullptr, _T("Call to RegisterClass(wc) failed!"), _T("Ok"), 0);
		return 1;
	}

	HWND hMainWnd = CreateWindow(
		szWindowClass,
		szTitle,
		WS_OVERLAPPEDWINDOW,
		(SCREEN_W - WINDOW_W) / 2, (SCREEN_H - WINDOW_H) / 2,
		WINDOW_W, WINDOW_H,
		nullptr,
		(HMENU)ID_MAIN_WND,
		hInstance,
		nullptr
		);

	if (!hMainWnd)
	{
		MessageBox(nullptr, _T("Call to CreateWindow(hMainWnd) failed!"), _T("Ok"), 0);
		return 1;
	}

	ShowWindow(hMainWnd, nCmdShow);
	UpdateWindow(hMainWnd);

	MSG msg;

	while(GetMessage(&msg, nullptr, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return int(msg.wParam);
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	HINSTANCE hInstance;
	static POINT speed[3];
	RECT rect;
	HDC hdc;
	PAINTSTRUCT ps;

	switch (message) {
		case WM_CREATE:
			hInstance = ((LPCREATESTRUCT)lParam)->hInstance;
			hWndCanvas = CreateWindow(
				_T("static"),
				nullptr,
				WS_CHILD | WS_BORDER,
				0, 0,
				WINDOW_W - 16,
				WINDOW_H - 136,
				hWnd,
				(HMENU)ID_CANVAS_WND,
				hInstance,
				nullptr
				);

			if (!hWndCanvas) {
				MessageBox(nullptr, _T("Call to CreateWindow(hWndCanvas) failed!"), _T("Ok"), 0);
				return 1;
			}

			hWndStartBtn = CreateWindow(
				_T("button"),
				_T("Start"),
				WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_PUSHBUTTON,
				WINDOW_W / 2 - BUTTON_W, WINDOW_H - 120,
				BUTTON_W, BUTTON_H,
				hWnd, 
				(HMENU)ID_BTN_START_WND,
				hInstance,
				nullptr
				);

			if (!hWndStartBtn) {
				MessageBox(nullptr, _T("Call to CreateWindow(hWndStartBtn) failed!"), _T("Ok"), 0);
				return 1;
			}

			hWndStopBtn = CreateWindow(
				_T("button"),
				_T("Stop"),
				WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_PUSHBUTTON,
				WINDOW_W / 2, WINDOW_H - 120,
				BUTTON_W, BUTTON_H,
				hWnd,
				(HMENU)ID_BTN_STOP_WND,
				hInstance,
				nullptr
				);

			if (!hWndStopBtn) {
				MessageBox(nullptr, _T("Call to CreateWindow(hWndStopBtn) failed!"), _T("Ok"), 0);
				return 1;
			}
			//Create threads and random speed's for primitives
			srand(time(NULL));
			for (int i = 0; i < 3; i++) {
				RandomFunc(speed[i]);
				threads[i] = CreateThread(nullptr, 0, MyThreadFunc, &speed[i], CREATE_SUSPENDED, nullptr);
				pos[i].x = WINDOW_W / 2; pos[i].y = WINDOW_H / 2;
			}
			break;
		case WM_COMMAND:
			if (LOWORD(wParam) == ID_BTN_START_WND) {
				for (int i = 0; i < 3; i++) {
					ResumeThread(threads[i]);
				}
				SetTimer(hWnd, 1, 1, nullptr);
				EnableWindow(hWndStartBtn, false);
				EnableWindow(hWndStopBtn, true);
			}
			else if (LOWORD(wParam) == ID_BTN_STOP_WND) {
				for (int i = 0; i < 3; i++) {
					SuspendThread(threads[i]);
				}
				KillTimer(hWnd, 1);
				EnableWindow(hWndStopBtn, false);
				EnableWindow(hWndStartBtn, true);
			}
			break;
		case WM_PAINT:
			hdc = BeginPaint(hWnd, &ps);
			for (int i = 0; i < 3; i++) {
				SelectObject(hdc,colors[i]);
				Rectangle(hdc, pos[i].x - SQUARE_LEN / 2, pos[i].y - SQUARE_LEN / 2, pos[i].x + SQUARE_LEN / 2, pos[i].y + SQUARE_LEN / 2);
			}
			EndPaint(hWnd, &ps);
			break;
		case WM_TIMER:
			GetClientRect(hWndCanvas, &rect);
			InvalidateRect(hWnd, &rect, TRUE);
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

DWORD CALLBACK MyThreadFunc(LPVOID param) {
	c++;
	int i = c; 
	POINT speed = *((POINT*)param);
	while (true) {
		if (pos[i].x + SQUARE_LEN / 2 >= WINDOW_W - 16) {
			pos[i].x = WINDOW_W - SQUARE_LEN / 2 - 16;
			speed.x = -speed.x;
		}
		else if (pos[i].x - SQUARE_LEN / 2 <= 0) {
			pos[i].x = SQUARE_LEN / 2;
			speed.x = -speed.x;
		}
		if (pos[i].y + SQUARE_LEN / 2 >= WINDOW_H - 136) {
			pos[i].y = WINDOW_H - SQUARE_LEN / 2 - 136;
			speed.y = -speed.y;
		}
		else if (pos[i].y - SQUARE_LEN / 2 <= 0) {
			pos[i].y = SQUARE_LEN / 2;
			speed.y = -speed.y;
		}
		pos[i].x += speed.x;
		pos[i].y += speed.y;
		Sleep(10);
	}
	return 0;
}

void RandomFunc(POINT &speed) {
	speed.x = rand() % 5 - 2;
	speed.y = rand() % 5 - 2;
}
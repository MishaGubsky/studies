#include <windows.h>
#include <time.h>
#include <tchar.h>

#define SCREEN_W	1366
#define SCREEN_H	768
#define WINDOW_W	450
#define WINDOW_H	200

#define BUTTON_W	96
#define BUTTON_H	32

#define ID_MAIN_WND			0
#define ID_CANVAS_WND		1
#define ID_BTN_MUTEX_WND	2
#define ID_BTN_Semaphore_WND	4
#define ID_BTN_STOP_WND		3
#define ID_THREAD_MUTEX		5
#define ID_THREAD_SEMAPHORE		6

const TCHAR szWindowClass[] = _T("win32app");
const TCHAR szTitle[] = _T("Lb7");

HWND hEdit, hWndMutexBtn, hWndSemaphoreBtn, hWndStopBtn,hMainWnd;
HANDLE threads[3];

#define SQUARE_LEN			20

typedef struct Vector {
	int x;
	int y;
};

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow);
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);

DWORD CALLBACK ThreadMutexFunc(LPVOID param);
DWORD CALLBACK ThreadSemaphoreFunc(LPVOID param);

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

	hMainWnd = CreateWindow(
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



static bool mutex=false;
static bool semaphore=false;

struct ThreadStruct
{
	TCHAR ThreadString[8];
	HWND* hEdit;
};
HANDLE hMutex,hSemaphore;

struct ThreadStruct TS[3]={{L"String1",NULL},{L"String2",NULL},{L"String3",NULL}};

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	HINSTANCE hInstance;

	HDC hdc;
	PAINTSTRUCT ps;
	char ind[20];


	switch (message) {
		case WM_CREATE:
			hInstance = ((LPCREATESTRUCT)lParam)->hInstance;

			hEdit=CreateWindow(_T("Edit"),_T(""), WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT, 
			WINDOW_W /2 -50,10, 100, 20, hWnd, (HMENU)5006, hInstance, NULL); 

			hWndMutexBtn = CreateWindow(
				_T("button"),
				_T("Mutex"),
				WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_PUSHBUTTON,
				WINDOW_W / 4 - BUTTON_W/2, WINDOW_H - 120,
				BUTTON_W, BUTTON_H,
				hWnd, 
				(HMENU)ID_BTN_MUTEX_WND,
				hInstance,
				nullptr
				);

			
			hWndSemaphoreBtn = CreateWindow(
				_T("button"),
				_T("Semaphore"),
				WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_PUSHBUTTON,
				WINDOW_W *2/ 4- BUTTON_W/2, WINDOW_H - 120,
				BUTTON_W, BUTTON_H,
				hWnd,
				(HMENU)ID_BTN_Semaphore_WND,
				hInstance,
				nullptr
				);

			hWndStopBtn = CreateWindow(
				_T("button"),
				_T("Stop"),
				WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_PUSHBUTTON,
				WINDOW_W*3/4 - BUTTON_W/2, WINDOW_H - 120,
				BUTTON_W, BUTTON_H,
				hWnd,
				(HMENU)ID_BTN_STOP_WND,
				hInstance,
				nullptr
				);
			hMainWnd=hWnd;
		break;



		case WM_COMMAND:
			if (LOWORD(wParam) == ID_BTN_MUTEX_WND) {
				if(mutex||semaphore)
				{
					for (int i = 0; i < 3; i++) 
						SuspendThread(threads[i]);	
					semaphore=false;	
				}
				mutex=true;

				hMutex=CreateMutex(NULL,FALSE,NULL);
				for (int i = 0; i < 3; i++) {
					
					threads[i] = CreateThread(nullptr, 0, ThreadMutexFunc, &TS[i], 0, nullptr);
					
					ResumeThread(threads[i]);
							}
			

			}
			else if (LOWORD(wParam) == ID_BTN_Semaphore_WND) {
				if(mutex||semaphore)
				{
					for (int i = 0; i < 3; i++) 
						SuspendThread(threads[i]);	
					mutex=false;	
				}
				semaphore=true;

				hSemaphore=CreateSemaphore(NULL,1,1,NULL);
				for (int i = 0; i < 3; i++) {	
					threads[i] = CreateThread(nullptr, 0, ThreadSemaphoreFunc, &TS[i], 0, nullptr);
					ResumeThread(threads[i]);
				}
				
			}
			else if (LOWORD(wParam) == ID_BTN_STOP_WND) {
				
				if(mutex||semaphore)
				{
					for (int i = 0; i < 3; i++) 
						SuspendThread(threads[i]);	
				}
				SendMessage(hEdit,WM_SETTEXT,0,0);
				semaphore=false;
				mutex=false;			
			}
			break;
		case WM_DESTROY:
			if(mutex||semaphore)
				{
					for (int i = 0; i < 3; i++) 
						SuspendThread(threads[i]);	
				}
			PostQuitMessage(0);
			break;
		case WM_PAINT:
			{
			PAINTSTRUCT ps;
			HDC hdc=BeginPaint(hWnd,&ps);
			EndPaint(hWnd,&ps);
			}
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}



DWORD CALLBACK ThreadMutexFunc(LPVOID param) {
	ThreadStruct* ts=(ThreadStruct*)param;
	while (true) {
		WaitForSingleObject(hMutex,INFINITE);

		SendDlgItemMessage(hMainWnd,5006,WM_SETTEXT,0,(LPARAM)(ts->ThreadString));
		InvalidateRect(hMainWnd,0,TRUE);

		ReleaseMutex(hMutex);
		Sleep(1000);
		}
	return 0;
}

DWORD CALLBACK ThreadSemaphoreFunc(LPVOID param) {
	ThreadStruct* ts=(ThreadStruct*)param;
	while (true) {
		WaitForSingleObject(hSemaphore,INFINITE);

		SendDlgItemMessage(hMainWnd,5006,WM_SETTEXT,0,(LPARAM)(ts->ThreadString));
		InvalidateRect(hMainWnd,0,TRUE);

		ReleaseSemaphore(hSemaphore,1,NULL);
		Sleep(1000);
		}
	return 0;
}
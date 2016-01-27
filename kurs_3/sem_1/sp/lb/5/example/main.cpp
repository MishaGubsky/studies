/*******************************************************************************************************************
Элементы управления(Контролы).
Это дочерние окна. Позиционируются относительно родительского окна.
Оконная процедура родительского принимает сообщение WM_COMMAND от дочерних окон с информацией об изменениях в них.
Имена классов предопределенных дочерних элементов управления:
"button", "edit”, "static", "listbox", "combobox" и "scrollbar".
При создании дочернего окна используются общие оконные стили: WS_CHILD,WS_VISIBLE,WS_CLIPSIBLINGS,
и специальные стили элементов управления вида: BS_XXXX,ES_XXXX,SS_XXXX,LBS_XXXX,CBS_XXXX,SBS_XXXX
Некотрые функции для работы с дочерними окнами:
CreateWindow,DestroyWindow,MoveWindow,EnableWindow,ShowWindow,HideWindow,SetWindowText,GetWindowText
********************************************************************************************************************/
#define _CRT_SECURE_NO_WARNINGS
#define UNICODE
#include <windows.h>
#include <windowsx.h>
#include <commctrl.h>
#include <time.h>
// Оконная процедура главного окна
LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
// Оконная процедура одного из дочерних окон
//LRESULT CALLBACK WndProc2(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

HINSTANCE hInst;

char szAppName[] = "StimeApp";
char szAppTitle[] = "Time Sender";
// Имя приложения RTIME
char szServerAppName[] = "RclockApp";
// Идентификатор главного окна приложения RTIME
HWND hWndServer;

// Структура для передачи данных между процессами
// при помощи сообщения WM_COPYDATA
COPYDATASTRUCT cd;

// Буферы для передаваемых данных
int szBuf[3] , s[3];
char szTerminated[] = "<Terminated<";


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
HWND hRed = NULL;
HWND hRhombus = NULL;
// Переменная для изменения цвета фона одного из окон
int color = 0;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	WNDCLASS wc;
	HWND hWnd;
	MSG msg;

	hInst = hInstance;

	hWnd = FindWindow((LPCWSTR)szAppName, NULL);
	if (hWnd)
	{
		// Если было, выдвигаем окно приложения на
		// передний план
		if (IsIconic(hWnd))
			ShowWindow(hWnd, SW_RESTORE);
		SetForegroundWindow(hWnd);
		return FALSE;
	}

	// Ищем окно серверного приложения RCLOCK и сохраняем
	// его идентификатор
	hWndServer = FindWindow(L"RclockApp", NULL);
	if (hWndServer == NULL)
	{
		// Если окно серверного приложения не найдено,
		// выводим сообщение об ошибке и завершаем работу
		// приложения
		//MessageBox(NULL, L"Установлена", L"Кнопка checkbox", MB_OK);
		MessageBox(NULL, L"Server RCLOCK not found", (LPCWSTR)szAppName,
			 MB_OK);
		return FALSE;
	}

	memset(&wc, 0, sizeof(wc));
	wc.lpszClassName = L"MyWindow";
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
		L"MyWindow", L"Win32 Элементы управления",
		WS_OVERLAPPED |  // Перекрываемое окно
		WS_CAPTION |    // С заголовком
		WS_SYSMENU |    // С системным меню
		WS_MINIMIZEBOX,     // С кнопкой "свернуть"
		CW_USEDEFAULT, CW_USEDEFAULT, 800, 600,
		NULL, NULL, hInst, NULL);
	
	hGrpButtons1 = CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"Выбор цвета:",
		WS_VISIBLE | WS_CHILD | BS_GROUPBOX,// <----BS_GROUPBOX does nothing on the grouping 
		10, 30,
		350, 110,
		hWnd,
		(HMENU)0,
		hInst, NULL);
	hRed = CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"красный",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP,  // <---- WS_GROUP group the following radio buttons 1st,2nd button 
		15, 50,
		300, 20,
		hWnd, //<----- Use main window handle
		(HMENU)ID_RED,
		hInst, NULL);
	CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"синий",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,  // Styles 
		15, 70,
		300, 20,
		hWnd,
		(HMENU)ID_BLUE,
		hInst, NULL);
	CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"зеленый",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,  // Styles 
		15, 90,
		300, 20,
		hWnd,
		(HMENU)ID_GREEN,
		hInst, NULL);

	hGrpButtons2 = CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"Выбор примитива:",
		WS_VISIBLE | WS_CHILD | BS_GROUPBOX,// <----BS_GROUPBOX does nothing on the grouping 
		370, 30,
		350, 110,
		hWnd,
		(HMENU)1,
		hInst, NULL);
	hRhombus = CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"ромб",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON | WS_GROUP,  // <---- WS_GROUP group the following radio buttons 1st,2nd button 
		375, 50,
		300, 20,
		hWnd, 
		(HMENU)ID_RHOMBUS,
		hInst, NULL);
	CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"квадрат",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,  // Styles 
		375, 70,
		300, 20,
		hWnd,
		(HMENU)ID_SQUARE,
		hInst, NULL);
	CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"круг",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,  // Styles 
		375, 90,
		300, 20,
		hWnd,
		(HMENU)ID_ROUND,
		hInst, NULL);
	CreateWindowEx(WS_EX_WINDOWEDGE,
		L"BUTTON",
		L"звезда",
		WS_VISIBLE | WS_CHILD | BS_AUTORADIOBUTTON,  // Styles 
		375, 110,
		300, 20,
		hWnd,
		(HMENU)ID_STAR,
		hInst, NULL);

	hWndCheckBox = CreateWindow(
		L"button", L"draw",
		WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | BS_AUTOCHECKBOX,
		15, 140, 150, 30,
		hWnd, (HMENU)ID_CHECKBOX, hInst, NULL);


	ShowWindow(hWnd, nCmdShow);
	UpdateWindow(hWnd);

	SendMessage(hRed, BM_SETCHECK, 1, 0l); // Перевести в состояние "отмечена"
	SendMessage(hRhombus, BM_SETCHECK, 1, 0l);

	szBuf[0] = 1;
	szBuf[1] = 1;
	cd.cbData = sizeof(szBuf)+1;
	//memcpy(cd.lpData, szBuf, sizeof(int) * 3);//
	cd.lpData = &szBuf;

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
	switch (msg)
	{
	case WM_COMMAND:
	{
		int vasgen = -1;
		code = HIWORD(wParam);       // код уведомления
		idCtrl = LOWORD(wParam);     // идентификатор дочернего окна
		hChild = (HWND)lParam;       // дескриптор дочернего окна
		
		switch (idCtrl)
		{
		case ID_RED :
			szBuf[0] = 1;
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_BLUE:
			
			szBuf[0] = 2;
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_GREEN:
			szBuf[0] = 3;
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_RHOMBUS:
			szBuf[1] = 1;
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_SQUARE:
			szBuf[1] = 2;
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_ROUND:
			szBuf[1] = 3;

			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_STAR:
			szBuf[1] = 4;
	
			SendMessage(hWndServer, WM_COPYDATA,
				(WPARAM)hWnd, (LPARAM)&cd);
			break;
		case ID_CHECKBOX:
			if (idCtrl == ID_CHECKBOX && code == BN_CLICKED) {

				if (SendMessage(hWndCheckBox, BM_GETCHECK, 0, 0l) != 0) {
					szBuf[2] = 1;	
					SendMessage(hWndServer, WM_COPYDATA,
						(WPARAM)hWnd, (LPARAM)&cd);
				}
				else {
					szBuf[2] = 0;
					SendMessage(hWndServer, WM_COPYDATA,
						(WPARAM)hWnd, (LPARAM)&cd);
				}
			}
			break;
		}


	}; return 0;
	case WM_DESTROY:
	{
		PostQuitMessage(0);
	} break;
	default: return DefWindowProc(hWnd, msg, wParam, lParam);
	}
	return 0l;
}


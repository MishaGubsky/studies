#include <windows.h>
#include <windowsx.h>
#include "TCHAR.H"
#include <psapi.h>


LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);
void SetPriority(DWORD dwPriority);
void PrintProcessName(DWORD processID, bool theFirst);
void GetProcess(bool theFirst);
void SetPriority(DWORD dwPriority);
int PrintModules(DWORD processID);

HINSTANCE hInst;

#define ID_LISTONE       1
#define ID_LISTTWO       2

#define ID_HIGH          3
#define ID_IDLE          4
#define ID_NORMAL        5
#define ID_REALTIME      6

HWND hWndListOne = NULL;
HWND hWndListTwo = NULL;

DWORD twar[1024];
int i = 0;



int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	WNDCLASS wc;
	HWND hWnd;
	MSG msg;

	hInst = hInstance;

	memset(&wc, 0, sizeof(wc));
	wc.lpszClassName = L"MyWindow";
	wc.lpfnWndProc = (WNDPROC)WndProc;
	wc.style = CS_HREDRAW | CS_VREDRAW;
	wc.hInstance = hInstance;
	wc.hIcon = LoadIcon(NULL, IDI_APPLICATION);
	wc.hCursor = LoadCursor(NULL, IDC_ARROW);

	wc.hbrBackground = (HBRUSH)(COLOR_BTNFACE + 1);
	wc.lpszMenuName = NULL;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;

	RegisterClass(&wc);

	hWnd = CreateWindow(
		L"MyWindow", L"Laboratory8",
		WS_OVERLAPPED |
		WS_CAPTION |
		WS_SYSMENU |
		WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, 800, 480,
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
	switch (msg)
	{
	case WM_CREATE:
	{
		hWndListOne = CreateWindow(L"listbox", NULL,
			WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | WS_BORDER |
			WS_VSCROLL |
			LBS_NOTIFY,
			5, 10, 355, 430,
			hWnd, (HMENU)ID_LISTONE, hInst, NULL);

		hWndListTwo = CreateWindow(L"listbox", NULL,
			WS_CHILD | WS_VISIBLE | WS_CLIPSIBLINGS | WS_BORDER |
			WS_VSCROLL |
			LBS_NOTIFY,
			375, 10, 390, 430,
			hWnd, (HMENU)ID_LISTTWO, hInst, NULL);

		GetProcess(true);
	}; return 0;
	case WM_COMMAND:
	{
		int j = 0;
		switch (LOWORD(wParam))
		{
		case ID_IDLE:
			SetPriority(IDLE_PRIORITY_CLASS);
			break;
		case ID_NORMAL:
			SetPriority(NORMAL_PRIORITY_CLASS);
			break;
		case ID_HIGH:
			SetPriority(HIGH_PRIORITY_CLASS);
			break;
		case ID_REALTIME:
			SetPriority(REALTIME_PRIORITY_CLASS);
			break;

		case ID_LISTONE:
			if (HIWORD(wParam) == LBN_DBLCLK)
			{
				SendMessage(hWndListTwo, LB_RESETCONTENT, 0, 0);
				i = SendMessage(hWndListOne, LB_GETCURSEL, 0, 0);
				if(i<=1024&&i>=0)
					PrintModules(twar[i]);
			}
			break;
		}
	}; return 0;

	case WM_CONTEXTMENU:
	{
		HMENU hMenu = CreatePopupMenu();

		AppendMenu(hMenu, MFT_STRING, ID_IDLE, L"IDLE");
		AppendMenu(hMenu, MFT_STRING, ID_NORMAL, L"NORMAL");
		AppendMenu(hMenu, MFT_STRING, ID_HIGH, L"HIGH");
		AppendMenu(hMenu, MFT_STRING, ID_REALTIME, L"REALTIME");

		TrackPopupMenu(hMenu, TPM_RIGHTBUTTON |
			TPM_TOPALIGN |
			TPM_LEFTALIGN,
			LOWORD(lParam),
			HIWORD(lParam), 0, hWnd, NULL);
		DestroyMenu(hMenu);
	}
	break;
	case WM_DESTROY:
	{
		PostQuitMessage(0);
	} break;
	default: return DefWindowProc(hWnd, msg, wParam, lParam);
	}
	return 0;
}


void GetProcess(bool theFirst)
{
	DWORD aProcesses[1024], cbNeeded, cProcesses;
	unsigned int j;
	EnumProcesses(aProcesses, sizeof(aProcesses), &cbNeeded);
	cProcesses = cbNeeded / sizeof(DWORD);
	for (j = 0; j < cProcesses; j++)
	{
		if (aProcesses[j] != 0)
		{
			PrintProcessName(aProcesses[j],theFirst);
		}
	}
}


void PrintProcessName(DWORD processID, bool theFirst)
{
	TCHAR szProcessName[MAX_PATH] = TEXT("<unknown>");
	HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION |
		PROCESS_VM_READ,
		FALSE, processID);

	if (NULL != hProcess)
	{
		HMODULE hModule;
		DWORD cbNeeded;

		if (EnumProcessModules(hProcess, &hModule, sizeof(hModule),&cbNeeded))
		{
			GetModuleBaseName(hProcess, hModule, szProcessName,
				sizeof(szProcessName) / sizeof(TCHAR));
		}
	}
	
	if (_tcscmp(szProcessName, L"<unknown>"))
	{	
		if (theFirst)
		{
			twar[i] = processID;
			i++;
		}
		switch (GetPriorityClass(hProcess))	
		{
		case IDLE_PRIORITY_CLASS:
			ListBox_AddString(hWndListOne, _tcscat(szProcessName,L" | IDLE"));
			break;
		case NORMAL_PRIORITY_CLASS:
			ListBox_AddString(hWndListOne, _tcscat(szProcessName, L" | Normal"));
			break;
		case REALTIME_PRIORITY_CLASS:
			ListBox_AddString(hWndListOne, _tcscat(szProcessName, L" | Realtime") );
			break;
		case HIGH_PRIORITY_CLASS:
			ListBox_AddString(hWndListOne, _tcscat(szProcessName, L" | High"));
			break;
		}
	}
	CloseHandle(hProcess);
}


void SetPriority(DWORD dwPriority)
{
	i = SendMessage(hWndListOne, LB_GETCURSEL, 0, 0);
	if (i >= 0 && i <= 1024)
	{
		HANDLE hProcess = OpenProcess(PROCESS_ALL_ACCESS,
			FALSE, twar[i]);
		SetPriorityClass(hProcess, dwPriority);
		CloseHandle(hProcess);
		SendMessage(hWndListOne, LB_RESETCONTENT, 0, 0);
		GetProcess(false);
	}
}

int PrintModules(DWORD processID)
{
	HMODULE hModuleuls[1024];
	HANDLE hProcess;
	DWORD cbNeeded;
	unsigned int i;

	hProcess = OpenProcess(PROCESS_QUERY_INFORMATION |
		PROCESS_VM_READ,
		FALSE, processID);
	if (NULL == hProcess)
		return 1;

	if (EnumProcessModules(hProcess, hModuleuls, sizeof(hModuleuls), &cbNeeded))
	{
		for (i = 0; i < (cbNeeded / sizeof(HMODULE)); i++)
		{
			TCHAR szModulName[MAX_PATH];

			if (GetModuleFileNameEx(hProcess, hModuleuls[i], szModulName,
				sizeof(szModulName) / sizeof(TCHAR)))
			{
				SendMessage(hWndListTwo, LB_ADDSTRING, 0, (LPARAM)szModulName);
			}
		}
	}
	CloseHandle(hProcess);
	return 0;
}
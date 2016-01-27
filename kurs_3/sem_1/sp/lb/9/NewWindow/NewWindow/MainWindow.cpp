#include <windows.h>
#include <tchar.h>
#include <stdlib.h>
#include <string>
#include <map>
#include <io.h>

using namespace std;

#define SCREEN_W		1366
#define SCREEN_H		768
#define WINDOW_W		1280
#define WINDOW_H		728

#define ID_WND_MAIN						0
#define ID_WND_EDIT						1
#define ID_LISTBOX_VALUES				2
#define ID_HKEY_CURRENT_USER			3
#define ID_HKEY_CLASSES_ROOT			4
#define ID_HKEY_LOCAL_MACHINE			5
#define ID_HKEY_USERS					6
#define ID_HKEY_CURRENT_CONFIG			7

HWND hWndListboxValues, hEdit, hWndButton[5];

const TCHAR szWindowClass[] = _T("win32RegApp");
const TCHAR szTitle[] = _T("Laboratory9");

map <std::string, std::string> mapData;

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd);
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);
void MyReadRegFunc(HKEY hKey, const char* path, string strPath);

int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd) {
	WNDCLASS wc;
	wc.style = CS_VREDRAW | CS_HREDRAW;
	wc.cbClsExtra = 0;
	wc.cbWndExtra = 0;
	wc.lpfnWndProc = WndProc;
	wc.hInstance = hInstance;
	wc.hCursor = LoadCursor(hInstance, IDC_ARROW);
	wc.hIcon = LoadIcon(hInstance, IDI_APPLICATION);
	wc.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
	wc.lpszMenuName = nullptr;
	wc.lpszClassName = szWindowClass;

	if (!RegisterClass(&wc)) {
		MessageBox(nullptr, _T("Call to RegisterClass(wc) failed!"), _T("Ok"), 0);
		return 1;
	}

	HWND hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
							 (SCREEN_W - WINDOW_W) / 2, 0, WINDOW_W, WINDOW_H,
							 nullptr, HMENU(ID_WND_MAIN), hInstance, nullptr);

	if (!hWnd) {
		MessageBox(nullptr, _T("Call to CreateWindow(hWnd) failed!"), _T("Ok"), 0);
		return 1;
	}

	ShowWindow(hWnd, nShowCmd);
	UpdateWindow(hWnd);

	MSG msg;
	while (GetMessage(&msg, nullptr, 0, 0)) {
		TranslateMessage(&msg);
		DispatchMessage(&msg);
	}

	return (int)msg.wParam;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
	switch (message) {
		case WM_CREATE:
			HINSTANCE hInstance;
			hInstance = ((LPCREATESTRUCT)lParam)->hInstance;
			hEdit = CreateWindow(_T("edit"), nullptr, WS_CHILD | WS_VISIBLE | ES_READONLY | 
				WS_BORDER,10, 10, WINDOW_W - 36, 20,hWnd, HMENU(ID_WND_EDIT), hInstance, nullptr);

			hWndListboxValues = CreateWindow(_T("listbox"), nullptr, WS_CHILD | WS_VISIBLE | 
				WS_BORDER | LBS_NOTIFY | WS_VSCROLL,10, 40, WINDOW_W - 36, WINDOW_H - 50 - 76,
				hWnd, HMENU(ID_LISTBOX_VALUES), hInstance, nullptr);


			hWndButton[0] = CreateWindow(_T("button"), _T("HKEY_LOCAL_MACHINE"), WS_CHILD | 
				WS_CLIPSIBLINGS | WS_VISIBLE | BS_PUSHBUTTON,172, WINDOW_H - 80, 170, 30,
				hWnd, HMENU(ID_HKEY_LOCAL_MACHINE), hInstance, nullptr);


			hWndButton[1] = CreateWindow(_T("button"), _T("HKEY_CLASSES_ROOT"), WS_CHILD | 
				WS_CLIPSIBLINGS | WS_VISIBLE | BS_PUSHBUTTON,352, WINDOW_H - 80, 170, 30,
				hWnd, HMENU(ID_HKEY_CLASSES_ROOT), hInstance, nullptr);


			hWndButton[2] = CreateWindow(_T("button"), _T("HKEY_USERS"), WS_CHILD | 
				WS_CLIPSIBLINGS | WS_VISIBLE | BS_PUSHBUTTON,532, WINDOW_H - 80, 170, 30,
				hWnd, HMENU(ID_HKEY_USERS), hInstance, nullptr);

			hWndButton[3] = CreateWindow(_T("button"), _T("HKEY_CURRENT_USER"), WS_CHILD | 
				WS_CLIPSIBLINGS | WS_VISIBLE | BS_PUSHBUTTON,712, WINDOW_H - 80, 170, 30,
				hWnd, HMENU(ID_HKEY_CURRENT_USER), hInstance, nullptr);

			hWndButton[4] = CreateWindow(_T("button"), _T("HKEY_CURRENT_CONFIG"), WS_CHILD | 
				WS_CLIPSIBLINGS | WS_VISIBLE | BS_PUSHBUTTON,892, WINDOW_H - 80, 180, 30, 
				hWnd, HMENU(ID_HKEY_CURRENT_CONFIG), hInstance, nullptr);


			break;
		case WM_COMMAND:
			if (HIWORD(wParam) == BN_CLICKED) {
				map<string, string>::iterator iter;
				mapData.clear();
				Rectangle(GetDC(hWnd),40,WINDOW_H - 78,120,WINDOW_H-57 );
				SendMessage(hWndListboxValues, LB_RESETCONTENT, 0, 0);
				SetWindowText(hEdit, NULL);
				switch (LOWORD(wParam)) {
					
					case ID_HKEY_CURRENT_USER:
						MyReadRegFunc(HKEY_CURRENT_USER, nullptr, "HKEY_CURRENT_USER");
						break;
					case ID_HKEY_CLASSES_ROOT:						
						MyReadRegFunc(HKEY_CLASSES_ROOT, nullptr, "HKEY_CLASSES_ROOT");
						break;
					case ID_HKEY_LOCAL_MACHINE:						
						MyReadRegFunc(HKEY_LOCAL_MACHINE, nullptr, "HKEY_LOCAL_MACHINE");
						break;
					case ID_HKEY_USERS:						
						MyReadRegFunc(HKEY_USERS, nullptr, "HKEY_USERS");
						break;
					case ID_HKEY_CURRENT_CONFIG:						
						MyReadRegFunc(HKEY_CURRENT_CONFIG, nullptr, "HKEY_CURRENT_CONFIG");
						break;

				}
				
				TextOut(GetDC(hWnd),50,WINDOW_H - 75,L"All Found",9);
				for (iter = mapData.begin(); iter != mapData.end(); iter++) {
					SendMessageA(hWndListboxValues, LB_ADDSTRING, 0, LPARAM(iter->first.c_str()));
				}
			}
			if (LOWORD(wParam) == ID_LISTBOX_VALUES && HIWORD(wParam) == LBN_SELCHANGE) {
				SetWindowTextA(hEdit, NULL);
				int index = SendMessageA(hWndListboxValues, LB_GETCURSEL, 0, 0);
				if (index != -1) {
					char buffer[1024];
					SendMessageA(hWndListboxValues, LB_GETTEXT, index, (LPARAM)buffer);
					string clickData = mapData[string(buffer)];
					SendMessageA(hEdit, WM_SETTEXT, 0, LPARAM(clickData.c_str()));
				}
			}
			break;
		case WM_DESTROY:
			PostQuitMessage(0);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
	}

	return 0;
}

void MyReadRegFunc(HKEY hKey, const char* path, string strPath) {
	HKEY tmp;
	DWORD keys = 0;
	DWORD values = 0;
	if (RegOpenKeyExA(hKey, path, 0, KEY_READ, &tmp) == ERROR_SUCCESS) {
		if (path) {
			strPath += '\\' + string(path);
		}
		RegQueryInfoKeyA(tmp, nullptr, 0, 0, &keys, 0, 0, &values, 0, 0, 0, nullptr);
		for (int j = 0; j < values; j++) {
			char valueName[1024];
			DWORD nameSz = sizeof(valueName);
			RegEnumValueA(tmp, j, valueName, &nameSz, 0, 0, 0, 0);
			char valueData[1024];
			DWORD dataSz = sizeof(valueData);
			RegGetValueA(tmp, nullptr, valueName, RRF_RT_REG_SZ | RRF_RT_REG_MULTI_SZ, 0, valueData, &dataSz);
			string strData = valueData;

			if (strData.find("C:\\") == 0 || strData.find("D:\\") == 0 || strData.find("c:\\") == 0 || strData.find("d:\\") == 0) {
				if (_access(strData.c_str(), 0) == -1) {   //дабы проверить сущ ли файл 
					string strName = strPath + '\\' + string(valueName);
					mapData[strName] = strData;
				}
			}
		}
		for (int i = 0; i < keys; i++) {
			char dwValue[1024];
			DWORD dwSize = sizeof(dwValue);
			RegEnumKeyExA(tmp, i, dwValue, &dwSize, 0, 0, 0, 0);
			MyReadRegFunc(tmp, dwValue, strPath);

		}
		RegCloseKey(tmp);
	}
}









































/*int slashIndex = strData.find_last_of('\\');
				int pointIndex = strData.find_first_of('.', slashIndex);
				if (pointIndex != string::npos) {
					int spaceIndex = strData.find_first_of(' ', pointIndex); 
					if (spaceIndex != string::npos) {
						strData.resize(spaceIndex);
					}
					int commaIndex = strData.find_first_of(',', pointIndex);
					if (commaIndex != string::npos) {
						strData.resize(commaIndex);
					}
					int serviceIndex = strData.find("-k", pointIndex);
					if (serviceIndex != string::npos) {
						strData.resize(serviceIndex);
					}
				}*/
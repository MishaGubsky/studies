#include <windows.h> // заголовочный файл, содержащий функции API
#include <string.h>
#include <tchar.h>
#include <stdlib.h>
//#include "resource.h"

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wPARAM, LPARAM lPARAM);
void AddMenus(HWND);
void AddOtherWindows(HWND, HINSTANCE);


static TCHAR szWindowClass[] = _T("win32app");
static TCHAR szTitle[] = _T("The Second laboratory");
HWND hListBox1;
HWND hListBox2;
HWND hBAdd;
HWND hBCLear;
HWND hBToRight;
HWND hBDelete;
HWND hEdit;


int WINAPI WinMain(HINSTANCE hInstance, 
				   HINSTANCE hPrevInstance, 
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
    WNDCLASSEX wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
	wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(hInstance, MAKEINTRESOURCE(IDC_ARROW));
    wcex.hbrBackground  = CreateSolidBrush(RGB(0, 0, 0));
    wcex.lpszMenuName   = NULL;
    wcex.lpszClassName  = szWindowClass;
    wcex.hIconSm        = LoadIcon(0, _T("icon.ico"));



    if (!RegisterClassEx(&wcex))
    {
        MessageBox(NULL,
            _T("Call to RegisterClassEx failed!"),
            _T("Win32 Help"),
            NULL);

        return 1;
    }



    HWND hWnd = CreateWindow(
        szWindowClass,
        szTitle,
        WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT,
        450, 360,
        NULL,
        NULL,
        hInstance,
        NULL
    );



    if (!hWnd)
    {
        MessageBox(NULL,
            _T("Call to CreateWindow failed!"),
            _T("Win32 Help"),
            NULL);
        return 1;
    }




 
	
    // The parameters to ShowWindow explained:
    // hWnd: the value returned from CreateWindow
    // nCmdShow: the fourth parameter from WinMain
    ShowWindow(hWnd,nCmdShow);
    UpdateWindow(hWnd);



	// Main message loop:
    MSG msg;
    while (GetMessage(&msg, NULL, 0, 0))
    {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return (int) msg.wParam;
}



LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR greeting[] = _T("THUNDERATION!");

    switch (message)
    {  

	
	
	case WM_COMMAND:
		{
          switch(LOWORD(wParam)) {
             
           }
		  break;
		}

	

	case WM_DESTROY:
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
        break;
    }

    return 0;
}

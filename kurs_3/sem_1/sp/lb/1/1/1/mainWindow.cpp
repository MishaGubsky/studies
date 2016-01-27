#include <windows.h> // заголовочный файл, содержащий функции API
#include <string.h>
#include <tchar.h>
#include <stdlib.h>
#include "resource.h"

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wPARAM, LPARAM lPARAM);
void AddMenus(HWND);



static TCHAR szWindowClass[] = _T("win32app");
static TCHAR szTitle[] = _T("The First laboratory");
POINT point;



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
	wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_ICON1));
    wcex.hCursor        = LoadCursor(hInstance, MAKEINTRESOURCE(IDC_CURSOR1));
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
        500, 300,
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


	point.x=200;
	point.y=100;
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


	INT32 dx=5;
    INT32 dy=5;

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	
    PAINTSTRUCT ps;
    HDC hdc;
    TCHAR greeting[] = _T("THUNDERATION!");

    switch (message)
    {
    case WM_PAINT:
        hdc = BeginPaint(hWnd, &ps);
		
    SetTextColor(hdc, RGB(255,255,255));
    SetBkColor(hdc, RGB(255,0,0));



        TextOut(hdc,
            point.x, point.y,
            greeting, _tcslen(greeting));


        EndPaint(hWnd, &ps);
        break;
    

	case WM_CREATE:
		AddMenus(hWnd);
		break;
	case WM_COMMAND:
		{
          switch(LOWORD(wParam)) {
              case 1:
				  SetTimer(hWnd,3,100,0);
				  break;
              case 2:
				  KillTimer(hWnd,3);
                  Beep(50, 100);
                  break;
           }
		  break;
		}
		   case WM_TIMER:
			   {
				   RECT rect;
				   GetClientRect(hWnd,&rect);
				   switch (LOWORD(wParam))
				   {
				   case 3:
					   if((point.x+dx+125>rect.right)||(point.x+dx<0))
						   dx=-dx;
					   if((point.y+dy+71>rect.bottom)||(point.y+dy<0))
						   dy=-dy;
					   point.x+=dx;
					   point.y+=dy;
					   InvalidateRect(hWnd,NULL,TRUE);
					   break;
				   case 2:
					   break;
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

void AddMenus(HWND hwnd) 
{
  HMENU hMenubar;
  HMENU hMenu;

  hMenubar = CreateMenu();
  hMenu = CreateMenu();

  AppendMenuW(hMenu, MF_STRING, 1, L"&Start");
  AppendMenuW(hMenu, MF_SEPARATOR, 0, NULL);
  AppendMenuW(hMenu, MF_STRING, 2, L"&Stop");

  AppendMenuW(hMenubar, MF_POPUP, (UINT_PTR)hMenu, L"&Menu");
  SetMenu(hwnd, hMenubar);
}
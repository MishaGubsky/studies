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



	
	AddOtherWindows(hWnd, hInstance);



 
	
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
              case 1000://add
				  {
					  _TCHAR buf[256];
					  GetWindowText(hEdit, buf,256);

					  INT32 size=GetWindowTextLength(hEdit);
					  if((size==0)||(SendMessage(hListBox1,LB_FINDSTRINGEXACT,0,(LPARAM)buf))!=-1)
					  {
							MessageBox(hWnd, L"Ошибка при добавлении строки в список", L"Ошибка", MB_OK);
							SendMessage(hEdit, WM_SETTEXT, 0, 0);
							break;
					  }

					  SendMessage(hListBox1, LB_ADDSTRING, 0, (LPARAM)buf);
					  SendMessage(hEdit, WM_SETTEXT, 0, 0);
				  }
				  break;
			  case 1001://clear
					SendMessage(hListBox1, LB_RESETCONTENT, 0, 0);
					SendMessage(hListBox2, LB_RESETCONTENT, 0, 0);
                  break;
			  case 1002://to right
				  {
						INT32 i = SendMessage (hListBox1, LB_GETCURSEL, 0, 0) ;//выбор индекса 
						if(i!=-1)
						{
							_TCHAR szd[256];
							SendMessage (hListBox1, LB_GETTEXT, i, (LPARAM)szd);//по индексу выбирается имя 
							if(SendMessage(hListBox2,LB_FINDSTRINGEXACT,NULL,(LPARAM)szd)==-1)
								SendMessage(hListBox2, LB_ADDSTRING, 0, (LPARAM)szd);
							
						}					
					break;
				  }
              case 1003://delete
				  {
					  INT32 i = SendMessage (hListBox1, LB_GETCURSEL, 0, 0) ;//выбор индекса 
					  SendMessage(hListBox1,LB_DELETESTRING,i,0);	
					  i = SendMessage (hListBox2, LB_GETCURSEL, 0, 0) ;//выбор индекса 
					  SendMessage(hListBox2,LB_DELETESTRING,i,0);
					  break;
				  }
           }
		  break;
		}

	/*
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
			   }*/


	case WM_DESTROY:
        PostQuitMessage(0);
        break;

    default:
        return DefWindowProc(hWnd, message, wParam, lParam);
        break;
    }

    return 0;
}

/*void AddMenus(HWND hWnd) 
{

  HMENU hMenubar;
  HMENU hMenu;

  hMenubar = CreateMenu();
  hMenu = CreateMenu();

  AppendMenuW(hMenu, MF_STRING, 1, L"&Start");
  AppendMenuW(hMenu, MF_SEPARATOR, 0, NULL);
  AppendMenuW(hMenu, MF_STRING, 2, L"&Stop");

  AppendMenuW(hMenubar, MF_POPUP, (UINT_PTR)hMenu, L"&Menu");
  SetMenu(hWnd, hMenubar);
}*/


void AddOtherWindows(HWND hWnd, HINSTANCE hInstance) 
{
	hListBox1 =  CreateWindow(
		TEXT("ListBox"),
		NULL,
		WS_CHILD|WS_VISIBLE|LBS_STANDARD,
		10, 10, 200, 200,
		hWnd,
		NULL,
		hInstance,
		NULL);
 

	hListBox2 =  CreateWindow(
		TEXT("ListBox"),
		NULL,
		WS_CHILD|WS_VISIBLE|LBS_STANDARD,
		220, 10, 200, 200,
		hWnd,
		NULL,
		hInstance,
		NULL);

	hBAdd = CreateWindow(
		TEXT("BUTTON"),
		TEXT("Add"),
		WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
                15, 260, 70, 27,hWnd,
				(HMENU)1000, hInstance, NULL);
	
	hBCLear = CreateWindow(
		TEXT("BUTTON"),
		TEXT("Clear"),
		WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
                125, 260, 70, 27,hWnd,
				(HMENU)1001, hInstance, NULL);
	
	hBToRight = CreateWindow(
		TEXT("BUTTON"),
		TEXT("ToRight"),
		WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
                235, 260, 70, 27,hWnd,
				(HMENU)1002, hInstance, NULL);
	
	hBDelete = CreateWindow(
		TEXT("BUTTON"),
		TEXT("Delete"),
		WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
                345, 260, 70, 27,hWnd,
				(HMENU)1003, hInstance, NULL);

	hEdit =  CreateWindow(
		TEXT("Edit"), TEXT("Give me anything"), WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT, 
		110,225, 200, 20, hWnd, (HMENU)1005, hInstance, NULL); 

}
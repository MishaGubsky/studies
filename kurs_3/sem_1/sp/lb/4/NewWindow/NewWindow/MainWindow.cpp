#include <windows.h> // заголовочный файл, содержащий функции API
#include <string.h>
#include <tchar.h>
#include <stdlib.h>
#include "resource.h"

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wPARAM, LPARAM lPARAM);
void AddMenus(HWND);
void AddOtherWindows(HWND, HINSTANCE);


static TCHAR szWindowClass[] = _T("win32app");
static TCHAR szTitle[] = _T("The Second laboratory");

HINSTANCE hInstance;

int WINAPI WinMain(HINSTANCE hInst, 
				   HINSTANCE hPrevInstance, 
                   LPSTR lpCmdLine,
                   int nCmdShow)
{
	hInstance=hInst;
    WNDCLASSEX wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);
	wcex.style          = CS_HREDRAW | CS_VREDRAW;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInstance;
	wcex.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(hInstance, MAKEINTRESOURCE(IDC_ARROW));
    wcex.hbrBackground  = CreateSolidBrush(RGB(255, 255, 255));
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
        450, 350,
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

	HWND hEditX,hEditY,hAdd;
	HBITMAP hBm;
	HBITMAP hBm1;
	HBITMAP hBm2;
	HBITMAP hBm3;
	int curX=-1,curY=-1,y=curX,x=curY,dx=5,dy=5;
	void GoTo();
	bool Check(char* buf);



LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	HDC  hdc,hMemDC;
    PAINTSTRUCT ps;
	RECT rec={0,0,50,50}, windowRec;
    LPDRAWITEMSTRUCT pdis;
    TCHAR LabelX[] = _T("X=");
    TCHAR LabelY[] = _T("Y=");
    static int i = 0;
	
	
	HBITMAP hBmp;

    switch (message)
    {
		
        case WM_CREATE:
			
			GetWindowRect(hWnd,&windowRec);
			hBm= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP1));
			hBm1= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP2));
			hBm2= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP3));
			hBm3= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP4));
			
				hEditX =  CreateWindow(
			TEXT("Edit"), TEXT(""), WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT, 
			125,5, 30, 20, hWnd, (HMENU)1006, hInstance, NULL); 
			
				hEditY =  CreateWindow(
			TEXT("Edit"), TEXT(""), WS_CHILD | WS_VISIBLE | WS_BORDER | ES_LEFT, 
			275,5, 30, 20, hWnd, (HMENU)1006, hInstance, NULL); 

			

				hAdd = CreateWindow(
			TEXT("BUTTON"),TEXT("Add"),WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
			180, 3, 50, 30,hWnd,(HMENU)1005, hInstance, NULL);




            SetTimer(hWnd, 1000, 100, NULL);
            return 0;



        case WM_TIMER :
            if(wParam == 1000)
            {
                i += 1;
				i=i%4;
                InvalidateRect (hWnd, NULL, TRUE); //обновление окна
            }
            return 0;


        case WM_PAINT :
			
				hdc = BeginPaint (hWnd, &ps);
				TextOut(hdc,105, 5,LabelX, _tcslen(LabelX));//X=
				TextOut(hdc,255, 5,LabelY, _tcslen(LabelY));//X=

				

				
				if((curX!=-1)&&(curY!=-1))//дабы не рисовала до введения чисел в editы
				{

						hMemDC = CreateCompatibleDC(NULL);
						switch(i)
							{				
							case 0:	
									SelectObject(hMemDC,hBm);
									break;
							case 1:					
									SelectObject(hMemDC,hBm1);	
									break;
							case 2:				
									SelectObject(hMemDC,hBm2);
									break;
							case 3:
									SelectObject(hMemDC,hBm3);	
									break;
						}
						GoTo();
			

						BitBlt(hdc, curX, curY, 32, 32, hMemDC, 0, 0, SRCCOPY);
			
						DeleteDC( hMemDC );
						DeleteDC( hdc );
          
						EndPaint(hWnd, &ps);
				}
            return 0;
		case WM_LBUTTONDOWN:
			{
				y=HIWORD(lParam);
				x=LOWORD(lParam);
				return 0;
			}

		case WM_COMMAND:
		{
          switch(LOWORD(wParam)) {
              case 1005:
				  {
					  
					GetWindowRect(hWnd,&windowRec);
					  _TCHAR buf[256];
					  char buf1[256];
					  //координата Х
					  GetWindowText(hEditX, buf,256);
					  CharToOem(buf,buf1);
					  if(Check(buf1))
					  {
						  if(atoi(buf1)+32<450)
						  {
						    curX=atoi(buf1);
							x=curX;
						  }
						  else
						  {
							  MessageBox(hWnd, L"Ошибка! введите число поменьше", L"Ошибка", MB_OK);
						  }
					  }
					  else
					  {
						  MessageBox(hWnd, L"Ошибка! введите число", L"Ошибка", MB_OK);
						  SendMessage(hEditX, WM_SETTEXT, 0, 0);
							break;
					  }


					  ///Координата У
					  GetWindowText(hEditY, buf,256);
					  CharToOem(buf,buf1);
					  if(Check(buf1))
					  {
						  if(atoi(buf1)+62<350)
						  {
							curY=atoi(buf1)+30;
							y=curY;
						  }
						  else
						  {
							  MessageBox(hWnd, L"Ошибка! введите число поменьше", L"Ошибка", MB_OK);
						  }
					  }
					  else
					  {
						  MessageBox(hWnd, L"Ошибка! введите число", L"Ошибка", MB_OK);
						  SendMessage(hEditY, WM_SETTEXT, 0, 0);
							break;
					  }

				  }
		  }
		}


		case WM_ERASEBKGND:
		{
			break;
		}
        case WM_DESTROY :
            KillTimer (hWnd, 1000);
            PostQuitMessage (0);
            return 0;
    }
    return DefWindowProc (hWnd, message, wParam, lParam);

    return 0;
}

bool Check(char* buf)
{
	int i=0;
	if(buf[0]=='\0')
		return false;
	while(buf[i]!='\0')
		if((buf[i]>='0')&&(buf[i]<='9'))
			i++;
		else
			return false;
	return true;
}

void GoTo()
{
	if(curX>x)
			{
				if(curX-x<5)
					curX=x;
				else
					curX-=dx;
			}
			if(curX<x)
			{
				if(x-curX<5)
					curX=x;
				else
					curX+=dx;
			}
			if(curY>y)
			{
				if(curY-y<5)
					curY=y;
				else
					curY-=dy;
			}
			if(curY<y)
			{
				if(y-curY<5)
					curY=y;
				else
					curY+=dy;
			}
}
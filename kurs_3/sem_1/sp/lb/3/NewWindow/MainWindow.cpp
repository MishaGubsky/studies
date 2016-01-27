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
HWND hButton;
HWND hButton1;

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
    wcex.hbrBackground  = CreateSolidBrush(RGB(0, 128, 128));
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
        700, 500,
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


	hButton=CreateWindow(_T("button"), _T("Press me"), WS_CHILD|WS_VISIBLE | BS_OWNERDRAW|BS_PUSHBUTTON,
			230, 10, 100, 50, hWnd, (HMENU)1000, hInstance, NULL);

	hButton1=CreateWindow(_T("button"), _T("Press me"), WS_CHILD|WS_VISIBLE | BS_OWNERDRAW|BS_PUSHBUTTON,
			370, 10, 100, 50, hWnd, (HMENU)1001, hInstance, NULL);
	
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
    LPDRAWITEMSTRUCT pdis;
	HBITMAP hBm= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP1));
	HBITMAP hBm1= LoadBitmap(hInstance, MAKEINTRESOURCE(IDB_BITMAP2));
	HBRUSH hBrushWhite= CreateSolidBrush(RGB(255, 255, 255));
	HBRUSH hBrushRed= CreateSolidBrush(RGB(255, 0, 0));
	HBRUSH hBrushGreen= CreateSolidBrush(RGB(0, 255, 0));
	HBRUSH hBrushDBlue= CreateSolidBrush(RGB(0, 0, 255));
	HBRUSH hBrushYellow= CreateSolidBrush(RGB(255, 255, 0));
	HBRUSH hBrushBlack=CreateSolidBrush(RGB(0, 0, 0));
	HBRUSH hBrushOrange= CreateSolidBrush(RGB(255, 128, 64));
	HBRUSH hBrushViolet= CreateSolidBrush(RGB(128, 0, 255));
	HBRUSH hBrushBlue= CreateSolidBrush(RGB(128, 255, 255));

	HPEN hPenWhite= CreatePen(2,2,RGB(255, 255, 255));
	HPEN hPenRed= CreatePen(2,2,RGB(255, 0, 0));
	HPEN hPenGreen= CreatePen(2,2,RGB(0, 255, 0));
	HPEN hPenBlue= CreatePen(2,2,RGB(0, 0, 255));
	HPEN hPenYellow= CreatePen(2,2,RGB(255, 255, 0));
	HPEN hPenBlack= CreatePen(2,2,RGB(0, 0, 0));




	int x0=0,y0=0;
	
    switch (message)
    {  
	case WM_DRAWITEM:
		{
			pdis = (LPDRAWITEMSTRUCT)lParam;
			hdc = CreateCompatibleDC(pdis->hDC);
			switch(pdis->CtlID) {
			case 1000:
				{
					FillRect(pdis->hDC, &pdis->rcItem, hBrushRed);
					SelectObject(hdc,hBm);
					BitBlt(pdis->hDC, 2, 2, 96, 96, hdc, 0, 0, SRCCOPY);
					FrameRect(pdis->hDC, &pdis->rcItem, (HBRUSH)GetStockObject(BLACK_BRUSH));
					
                DeleteDC(hdc);
					break;
				}
			case 1001:
				{
					FillRect(pdis->hDC, &pdis->rcItem, hBrushRed);
					SelectObject(hdc,hBm1);
					BitBlt(pdis->hDC, 2, 2, 96, 96, hdc, 0, 0, SRCCOPY);
					FrameRect(pdis->hDC, &pdis->rcItem, (HBRUSH)GetStockObject(BLACK_BRUSH));
					
                DeleteDC(hdc);
				} 
        return TRUE;

			break;
		}
	
	case WM_COMMAND:
		{
		switch(LOWORD(wParam)) {
				case 1000:
					if (BN_CLICKED == HIWORD(wParam))
					{
						
						hdc=GetDC(hWnd);
						SelectObject(hdc, hBrushWhite);
						
						SelectObject(hdc, hPenBlack);
						

						
						Rectangle(hdc,300,260,400,360);


						
						Ellipse(hdc,380,340,410,370);//Низ право
						
						Ellipse(hdc,390,265,420,295);//верх право
						
						Ellipse(hdc,290,340,320,370);//Низ лево
						
						Ellipse(hdc,310,265,280,295);//верхлево

						
						
						Ellipse(hdc,295,175,325,205);//ухо лево
						
						Ellipse(hdc,375,175,405,205);//ухо право
						
						Ellipse(hdc,295,180,405,260);//голова


						
						
						Ellipse(hdc,325,205,345,225);//glas лево
						
						Ellipse(hdc,355,205,375,225);//glas право

						
						SelectObject(hdc, hBrushBlack);
						
						Ellipse(hdc,332,212,339,219);
						
						Ellipse(hdc,362,212,369,219);
						
						
						hdc=GetDC(hWnd);
						SelectObject(hdc, hBrushWhite);

						Ellipse(hdc,325,215,375,265);//хавалка

						POINT points1[4];
						points1[0].x=342;
						points1[0].y=222;
						points1[1].x=358;
						points1[1].y=222;
						points1[2].x=350;
						points1[2].y=230;
						points1[3].x=342;
						points1[3].y=222;

						Polyline(hdc,points1,4);
						
						Rectangle(hdc,320,280,380,340); //мал кв


						//picture

						
						SelectObject(hdc, hBrushYellow);
						Ellipse(hdc,346,304,355,315);

						
						SelectObject(hdc, hBrushRed);
						Ellipse(hdc,345,290,360,305);
						
						SelectObject(hdc, hBrushOrange);
						Ellipse(hdc,355,300,370,315);
						
						
						SelectObject(hdc, hBrushGreen);
						Ellipse(hdc,349,312,364,327);
						
						SelectObject(hdc, hBrushDBlue);
						Ellipse(hdc,335,312,350,327);
						
						SelectObject(hdc, hBrushViolet);
						Ellipse(hdc,333,298,348,313);
						
						SelectObject(hdc, hPenBlack);



						//hunny
						Arc(hdc, 450, 305, 470, 375, 460, 305, 460, 375);
						Arc(hdc, 500, 375, 520, 305, 510, 375, 510, 305);
						
						MoveToEx(hdc, 460, 305, NULL);
						LineTo(hdc, 510, 305);
						
						MoveToEx(hdc, 460, 375, NULL);
						LineTo(hdc, 510, 375);


						
						POINT points[5];//м
						points[0].x=462;
						points[0].y=347;
						points[1].x=462;
						points[1].y=333;
						points[2].x=469;
						points[2].y=347;
						points[3].x=476;
						points[3].y=333;
						points[4].x=476;
						points[4].y=347;
						Polyline(hdc,points,5);

						POINT points2[9];//е


						
						points2[0].x=481;
						points2[0].y=347;
						points2[1].x=481;
						points2[1].y=333;
						points2[2].x=492;
						points2[2].y=333;
						points2[3].x=481;
						points2[3].y=333;
						points2[4].x=481;
						points2[4].y=340;
						points2[5].x=486;
						points2[5].y=340;
						points2[6].x=481;
						points2[6].y=340;
						points2[7].x=481;
						points2[7].y=347;
						points2[8].x=492;
						points2[8].y=347;


						
						Polyline(hdc,points2,9);

						
						Ellipse(hdc,483,328,486,331);
						
						Ellipse(hdc,487,328,490,331);

						
						POINT points3[8];//д

						points3[0].x=497;
						points3[0].y=347;

						points3[1].x=497;
						points3[1].y=340;
						points3[2].x=499;
						points3[2].y=340;
						points3[3].x=504;
						points3[3].y=333;
						points3[4].x=509;
						points3[4].y=340;
						points3[5].x=497;
						points3[5].y=340;
						points3[6].x=511;
						points3[6].y=340;
						points3[7].x=511;
						points3[7].y=347;
						
						Polyline(hdc,points3,8);

						
						DeleteDC(hdc);

					}
					break;
				case 1001:
					if (BN_CLICKED == HIWORD(wParam))
					{
						hdc=GetDC(hWnd);
						SelectObject(hdc, hBrushWhite);
						Rectangle(hdc,40,100,650,425);
						DeleteDC(hdc);
					}
					break;
				default:
					return DefWindowProc(hWnd, message, wParam, lParam);
			break;
			}


	case WM_PAINT:
		{
			
			
			hdc=BeginPaint(hWnd,&ps);
			SelectObject(hdc, hBrushWhite);
			Rectangle(hdc,40,100,650,425);
			
            DeleteDC(hdc);	
			EndPaint(hWnd,&ps);
			break;
		}



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
}

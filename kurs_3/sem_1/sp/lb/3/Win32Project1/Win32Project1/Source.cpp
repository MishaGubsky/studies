
#include <windows.h>
 
HWND hwnd, simple_button, icon_button;
HINSTANCE hInstance;
HICON hIcon1; 
LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
 
int WINAPI WinMain( HINSTANCE hInstance, HINSTANCE hPrevInstance,
			LPSTR lpCmdLine, int nCmdShow )
{

  MSG  msg ;    
  WNDCLASSEX wc;
   wc.cbSize = sizeof(WNDCLASSEX);
	wc.style          = CS_HREDRAW | CS_VREDRAW;
    wc.lpfnWndProc    = WndProc;
    wc.cbClsExtra     = 0;
    wc.cbWndExtra     = 0;
    wc.hInstance      = hInstance;
	wc.hIcon          = LoadIcon(hInstance, MAKEINTRESOURCE(IDI_APPLICATION));
    wc.hCursor        = LoadCursor(hInstance, MAKEINTRESOURCE(IDC_ARROW));
    wc.hbrBackground  = CreateSolidBrush(RGB(0, 0, 0));
    wc.lpszMenuName   = NULL;
    wc.lpszClassName  = TEXT("Win32 Basic Window ");
    //wcex.hIconSm        =LoadCursor(hInstance, MAKEINTRESOURCE(IDC_));
 

 hwnd = CreateWindow( wc.lpszClassName, TEXT("Win32 Basic Window "),
                WS_OVERLAPPEDWINDOW,
                100, 100, 330, 270, 0, 0, hInstance, 0);  
 
 ShowWindow(hwnd, nCmdShow);
 UpdateWindow(hwnd);
 
 
  while( GetMessage(&msg, NULL, 0, 0))
  {
    TranslateMessage(&msg);
    DispatchMessage(&msg);
  }
  return (int) msg.wParam;
}
 HWND button1;

LRESULT CALLBACK WndProc( HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam )
{
 
  switch(msg)
   {
   case WM_CREATE:
	    {
        button1 =   CreateWindow(TEXT("button"), TEXT("Button"),    
		             WS_VISIBLE | WS_CHILD | BS_PUSHBUTTON,
		             80, 10, 100, 50,        
		             hwnd, (HMENU)100, NULL, NULL);
       
        hIcon1 = LoadIcon (NULL, IDI_WARNING);
        SendMessage(icon_button,BM_SETIMAGE,IMAGE_ICON,(LPARAM)hIcon1);
 
	    break;
	}
 
    case WM_DESTROY:
       {
        PostQuitMessage(0);
        return 0;
       }
 
   }
 
 return DefWindowProc(hwnd, msg, wParam, lParam);
}
; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

    .686                        ; create 32 bit code
    .model flat, stdcall        ; 32 bit memory model
    option casemap :none        ; case sensitive

    include calc00.inc          ; local includes for this file

.code

start:

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

  ; ------------------
  ; set global values
  ; ------------------
    mov hInstance,   rv(GetModuleHandle, NULL)
    mov CommandLine, rv(GetCommandLine)
    mov hIcon,       rv(LoadIcon,hInstance,500)
    mov hCursor,     rv(LoadCursor,NULL,IDC_ARROW)
    mov sWid,        rv(GetSystemMetrics,SM_CXSCREEN)
    mov sHgt,        rv(GetSystemMetrics,SM_CYSCREEN)

    call Main

    invoke ExitProcess, eax

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

Main proc

    LOCAL Wwd:DWORD,Wht:DWORD,Wtx:DWORD,Wty:DWORD
    LOCAL wc:WNDCLASSEX
    LOCAL icce:INITCOMMONCONTROLSEX

    LOCAL hButton:HWND
    LOCAL lbl:HWND

  ; --------------------------------------
    mov icce.dwSize, SIZEOF INITCOMMONCONTROLSEX  ; set the structure size
    xor eax, eax                                  ; set EAX to zero
    or eax, ICC_WIN95_CLASSES
    mov icce.dwICC, eax
    invoke InitCommonControlsEx,ADDR icce         ; initialise the common control library
  ; --------------------------------------

    STRING szClassName,   "CalcClass"
    STRING szDisplayName, "Calc00"

  ; ---------------------------------------------------
  ; set window class attributes in WNDCLASSEX structure
  ; ---------------------------------------------------
    mov wc.cbSize,         sizeof WNDCLASSEX
    mov wc.style,          CS_BYTEALIGNCLIENT or CS_BYTEALIGNWINDOW
    m2m wc.lpfnWndProc,    OFFSET WndProc
    mov wc.cbClsExtra,     NULL
    mov wc.cbWndExtra,     NULL
    m2m wc.hInstance,      hInstance
    m2m wc.hbrBackground,  COLOR_BTNFACE+1
    mov wc.lpszMenuName,   NULL
    mov wc.lpszClassName,  OFFSET szClassName
    m2m wc.hIcon,          hIcon
    m2m wc.hCursor,        hCursor
    m2m wc.hIconSm,        hIcon

  ; ------------------------------------
  ; register class with these attributes
  ; ------------------------------------
    invoke RegisterClassEx, ADDR wc

  ; ---------------------------------------------
  ; set width and height
  ; ---------------------------------------------

    mov Wwd, 240
    mov Wht, 124

  ; ------------------------------------------------
  ; Top X and Y co-ordinates for the centered window
  ; ------------------------------------------------
    mov eax, sWid
    sub eax, Wwd                ; sub window width from screen width
    shr eax, 1                  ; divide it by 2
    mov Wtx, eax                ; copy it to variable

    mov eax, sHgt
    sub eax, Wht                ; sub window height from screen height
    shr eax, 1                  ; divide it by 2
    mov Wty, eax                ; copy it to variable

  ; -----------------------------------------------------------------
  ; create the main window with the size and attributes defined above
  ; -----------------------------------------------------------------
    invoke CreateWindowEx, WS_EX_LEFT, addr szClassName, addr szDisplayName, \
            WS_OVERLAPPED or WS_SYSMENU, \
            Wtx, Wty, Wwd, Wht, NULL, NULL, hInstance, NULL
    mov hWnd, eax

    invoke CreateWindowEx, 0, addr EditClassName, NULL, \
            WS_CHILD or WS_VISIBLE or WS_BORDER or SS_CENTER or SS_CENTERIMAGE or WS_TABSTOP, \
            16, 16, 32, 24, hWnd, Entry1ID, hInstance, NULL
    mov hEdit1, eax

    invoke CreateWindowEx, 0, addr LabelClassName, NULL, \
            WS_CHILD or WS_VISIBLE or SS_CENTER or SS_CENTERIMAGE, \
            64, 16, 24, 24, hWnd, LabelPlusID, hInstance, NULL
    invoke SetWindowText, eax, addr LabelPlusText

    invoke CreateWindowEx, 0, addr EditClassName, NULL, \
            WS_CHILD or WS_VISIBLE or WS_BORDER or SS_CENTER or SS_CENTERIMAGE or WS_TABSTOP, \
            104, 16, 32, 24, hWnd, Entry2ID, hInstance, NULL
    mov hEdit2, eax

    invoke CreateWindowEx, 0, addr LabelClassName, NULL, \
            WS_CHILD or WS_VISIBLE or SS_CENTER or SS_CENTERIMAGE, \
            152, 16, 24, 24, hWnd, LabelEquID, hInstance, NULL
    invoke SetWindowText, eax, addr LabelEquText

    invoke CreateWindowEx, 0, addr LabelClassName, NULL, \
            WS_CHILD or WS_VISIBLE or SS_CENTER or SS_CENTERIMAGE, \
            192, 16, 32, 24, hWnd, LabelResID, hInstance, NULL
    mov hRes, eax

    invoke CreateWindowEx, 0, addr ButtonClassName, NULL, \
            WS_CHILD or WS_VISIBLE or WS_TABSTOP, \
            16, 56, 208, 24, hWnd, ButtonID, hInstance, NULL
    invoke SetWindowText, eax, addr ButtonText

    invoke ShowWindow,hWnd, SW_SHOWNORMAL
    invoke UpdateWindow,hWnd

    call MsgLoop
    ret

Main endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

MsgLoop proc

    LOCAL msg:MSG

    push ebx
    lea ebx, msg

    xor eax, eax
    .while 1
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if !eax

        invoke IsDialogMessage, hWnd, addr msg
        .if !eax
            invoke TranslateMessage, addr msg
            invoke DispatchMessage,  addr msg
        .endif
    .endw

    pop ebx
    mov eax, msg.wParam
    ret

MsgLoop endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

WndProc proc hWin:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD

    LOCAL status1:DWORD
    LOCAL status2:DWORD

    Switch uMsg
      case WM_DESTROY
        invoke PostQuitMessage,NULL
        return 0

      case WM_COMMAND
        mov ax, word ptr [wParam]
        .if ax == ButtonID
          invoke GetDlgItemInt, hWnd, Entry1ID, addr status1, TRUE
          mov edi, eax

          invoke GetDlgItemInt, hWnd, Entry2ID, addr status2, TRUE
          add edi, eax

          .if !status1 || !status2
            mov dword ptr [TextBuff], "(:"
            invoke SetWindowText, hRes, addr TextBuff
          .else
            invoke dwtoa, edi, addr TextBuff
            invoke SetWindowText, hRes, addr TextBuff
          .endif
        .endif
    Endsw

    invoke DefWindowProc,hWin,uMsg,wParam,lParam
    ret

WndProc endp

; いいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいいい

end start

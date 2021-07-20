.386
.model flat, stdcall
option casemap :none

include windows.inc
include user32.inc
include kernel32.inc

includelib user32.lib
includelib kernel32.lib

    szText macro name, text:vararg
        local lbl
        jmp lbl
        name db text, 0
        lbl:
    endm

    WinMain proto :DWORD, :DWORD, :DWORD, :DWORD
    WndProc proto :DWORD, :DWORD, :DWORD, :DWORD

.data

    hInstance   dd ?
    lpszCmdLine dd ?

.code

start:
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    invoke GetCommandLine
    mov lpszCmdLine, eax

    invoke WinMain, hInstance, NULL, lpszCmdLine, SW_SHOWDEFAULT
    invoke ExitProcess, 0

WinMain proc hInst :DWORD, hPrevInst :DWORD, szCmdLine :DWORD, nShowCmd :DWORD
    local wc :WNDCLASSEX
    local msg :MSG
    local hWnd :HWND

    szText szClassName, "MyWindowClass"
    szText szWindowTitle, "Window Title here"

    mov wc.cbSize, sizeof WNDCLASSEX
    mov wc.style, CS_HREDRAW or CS_VREDRAW or CS_BYTEALIGNWINDOW
    mov wc.lpfnWndProc, WndProc
    mov wc.cbClsExtra, NULL
    mov wc.cbWndExtra, NULL

    push hInst
    pop wc.hInstance

    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, offset szClassName

    invoke RegisterClass, addr wc
    invoke CreateWindowEx, WS_EX_APPWINDOW, addr szClassName, addr szWindowTitle, WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
        NULL, NULL, hInst, NULL

    mov hWnd, eax

    invoke ShowWindow, hWnd, nShowCmd
    invoke UpdateWindow, hWnd

MessagePump:
    invoke GetMessage, addr msg, NULL, 0, 0

    cmp eax, 0
    je MessagePumpEnd

    invoke TranslateMessage, addr msg
    invoke DispatchMessage, addr msg

    jmp MessagePump

MessagePumpEnd:

    mov eax, msg.wParam
    ret
WinMain endp

WndProc proc hWnd :DWORD, uMsg :DWORD, wParam :DWORD, lParam :DWORD
    .if uMsg == WM_DESTROY

        invoke PostQuitMessage, 0

        xor eax, eax
        ret

    .endif

    invoke DefWindowProc, hWnd, uMsg, wParam, lParam
    ret
WndProc endp

end start

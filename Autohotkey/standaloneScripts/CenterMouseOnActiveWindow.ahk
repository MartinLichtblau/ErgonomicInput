; RegisterShellHookWindow #ref: https://autohotkey.com/board/topic/60521-how-to-activate-the-window-currently-under-mouse-cursor/
Gui +LastFound
hWnd := WinExist()
DllCall("RegisterShellHookWindow", UInt,Hwnd)
MsgNum := DllCall("RegisterWindowMessage", Str,"SHELLHOOK")
OnMessage(MsgNum, "ShellWinMessage")
return

/*
    @Title: ShellWinMessage
    @Desc: subscribe to get called when active/focused window changes
*/
ShellWinMessage(wParam, lParam) {
    WinGetTitle, title, ahk_id %lParam%
    ; tooltip Title: %title% ++ %lParam% ++ %wParam%
    if (wParam = 4 || wParam = 32772) {
        ; if (Title != "") {
            gosub CenterMouseOnActiveWindow
        ; }
    }
}

/*
    @Title: CenterMouseOnActiveWindow
    @Desc: moves mouse cursor in center of active window, if it isn't already above it / within bounds
*/
CenterMouseOnActiveWindow:
    Sleep 50 ; wait for GUI
    activeWinId := WinExist("A")
    MouseGetPos,,, winIdUnderMouse
    if (activeWinId != winIdUnderMouse) { ; check if mouse above active window
        ; CoordMode,Mouse,Screen ; not necessary when using DLL-call SetCursorPos
        WinGetPos, winTopL_x, winTopL_y, width, height, A
        winCenter_x := winTopL_x + width/2
        winCenter_y := winTopL_y + height/2
        ;MouseMove, X, Y, 0 ; does not work with multi-monitor
        DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
        ;Tooltip winTopL_x:%winTopL_x% winTopL_y:%winTopL_y% winCenter_x:%winCenter_x% winCenter_y:%winCenter_y%
    }
return
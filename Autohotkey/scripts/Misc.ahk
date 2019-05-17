/*
    @Title: Misc
    @Desc: a collection of miscellaneous code snippets
    @Maturity:2
*/
Misc_Setup:
    #SingleInstance force
    #Persistent
    #Include %A_WorkingDir%\lib\Commands.ahk

    ; RegisterShellHookWindow #ref: https://autohotkey.com/board/topic/60521-how-to-activate-the-window-currently-under-mouse-cursor/
    Gui +LastFound
    hWnd := WinExist()
    DllCall("RegisterShellHookWindow", UInt,Hwnd)
    MsgNum := DllCall("RegisterWindowMessage", Str,"SHELLHOOK")
    OnMessage(MsgNum, "ShellWinMessage")
    return



/*
    @Title: ShellWinMessage
    @Desc: subscribed to get called when active/focused window changes
*/
ShellWinMessage(wParam, lParam) {
    WinGetTitle, title, ahk_id %lParam%
    if (wParam = 4 || wParam = 32772) {
        if (Title != "") {
            gosub CenterMouseOnActiveWindow
        }
    }
}

; switch Ctrl+Z and Ctrl+Y Undo/Redo so it's easier on the ring finger
$^z::
    SendInput ^y
    return

$^y::
    SendInput ^z
    return
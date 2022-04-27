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
    ; tooltip Title: %title% ++ %lParam% ++ %wParam%
    if (wParam = 4 || wParam = 32772) {
        ; if (Title != "") {
            gosub CenterMouseOnActiveWindow
        ; }
    }
}

; switch Ctrl+Z and Ctrl+Y Undo/Redo so it's easier on the ring finger
$^z::
    SendInput ^y
    return

$^y::
    SendInput ^z
    return

Tab & Right::
    SendInput %RIGHTTAB_sc%
    return
Tab & Down::
    SendInput %LEFTTAB_sc%
    return
;Tab up::SendInput {Tab}
$*Tab::Tab
;$*Tab up::return
;$*Tab::
    AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 1)
    AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 0)
    return

SendInput {Tab}

; What is this code about? Well, I didn't use it lately, so...
;+^,::
;    output := StrReplace(clipboard, "`r`n", ", ")
;    SendInput %output%
;    return
;
;+^.::
;    output := StrReplace(clipboard, "`r`n", ", ")
;    output := SubStr(output, 1, -2)  ;remove ending whitespace and comma
;    SendInput session_id = ANY(ARRAY[%output%])
;    return

/*
    @Title: PageButtonScroll
*/
;PgUp::SendInput {WheelUp 3} ;{WheelUp 17} ; {Up 15}
PgUp:: MouseClick,WheelUp,,,3,0,D,R
;PgDn::SendInput {WheelDown 5} ;{WheelDown 17} ; {Down 15}
PgDn::MouseClick,WheelDown,,,3,0,D,R
; +Space::Send {WheelDown 5}
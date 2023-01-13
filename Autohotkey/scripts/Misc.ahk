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
    DllCall("RegisterShellHookWindow", UInt,Hwnd) ; better version at https://www.autohotkey.com/boards/viewtopic.php?t=59149
    MsgNum := DllCall("RegisterWindowMessage", Str,"SHELLHOOK")
    OnMessage(MsgNum, "ShellWinMessage")
    sendTabOnRelease := 1
    SetTimer, ChangePowerPlan, 50
    return


PowerPlan := 0
ChangePowerPlan() {
    global PowerPlan
    ;tooltip %A_Cursor%
    if (A_TimeIdlePhysical < 5000 || trackpadRButtonDown || trackpadMButtonDown) {
        if (powerPlan != 2){
            SendInput !^2
            powerPlan := 2
            Tooltip 2, 0,0
        }
    } else {
        if (powerPlan != 3 && A_Cursor != "Unknown"){
            SendInput !^3
            powerPlan := 3
            Tooltip 3, 0,0
        }
    }
    return
}


/*
    @Title: ShellWinMessage
    @Desc: subscribed to get called when active/focused window changes
    @Parameter: See https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-registershellhookwindow
        wParam = what happend
        lParam = which window was involved
*/
ShellWinMessage(wParam, lParam, yParam, xParam) {
    ;Sleep 100
    WinGetTitle, title, ahk_id %lParam%
    WinGetClass, class, ahk_id %lParam%
    WinGet, Pid, PID, ahk_id %lParam%
    WinGet, Process, ProcessName, ahk_id %lParam%
    ;WinGet, ActiveControlList, ControlList, ahk_id %lParam% ; rarely works nore explanatory if it does
    ;tooltip %yParam% %xParam% | wParam: %wParam% | lParam: %lParam% | PID: %Pid% | Title: %title% | Class: %class% | Process: %Process% | Controls: %ActiveControlList%, 0, 3000 ;, 20 ; tooltip NR. 20
    if (wParam = 4 || wParam = 32772 || wParam = 54 || wParam = 53) { ; remove wParam = 16 since it reacts to invisibles
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

sendTabOnRelease = 1
Tab & Right::
    sendTabOnRelease := 0
    SendInput %RIGHTTAB_sc%
    return
Tab & Down::
    sendTabOnRelease := 0
    SendInput %LEFTTAB_sc%
    return
Tab & PgDn::
    sendTabOnRelease := 0
    SendInput !{Right}
    return
$Tab::
    if sendTabOnRelease
        SendInput {Tab} ;     AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 1) AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 0)
    sendTabOnRelease := 1
    return

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
PgUp::
    MouseClick,WheelUp,,,3,0,D,R
    return

;PgDn::SendInput {WheelDown 5} ;{WheelDown 17} ; {Down 15}
PgDn::
    MouseClick,WheelDown,,,3,0,D,R
    return
; +Space::Send {WheelDown 5}

!WheelUp::
    SendInput %LEFTTAB_sc%
    return

!WheelDown::
    SendInput %RIGHTTAB_sc%
    return

; >>>>>>>>>>>>>>>>>>>>>>>>>>> Programming (related) addons

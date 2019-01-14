/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
#SingleInstance force
#Persistent
Process,priority,,Realtime
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey
#include %A_WorkingDir%\lib\AutoHotInterception\AutoHotInterception.ahk
gosub Setup
return

Global mouseId, holdButton, xSum, ySum, movementThreshold, AHI, runFlag

Setup:
    OnExit("ExitFunc")
    if(A_Args.Length() != 2)
        ExitApp
    gosub InitVars
    gosub InitAhi
    SetSystemCursor("IDC_SIZEALL",0,0)
    ExitOnInput()
    return

InitVars:
    runFlag := true
    mouseId := A_Args[1]
    holdButton := A_Args[2]
    movementThreshold := 8
    gosub ResetXY ; reset values since vars initially have undefined values
    return

InitAhi:
    AHI := new AutoHotInterception()
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("FixedAxisScrolling"))
    ;AHI.SubscribeMouseButton(mouseId, holdButton, false, Func("ExitOnHoldButton")) ; is too slow
    return

/*
    @Title: FreePlaneScroll
    @Desc: scrolls in any direction, i.e. not bound to straight axis movements.
    #note some apps don't allow such movements and will only respond to axial scrolls in a row, e.g. gChrome
*/
FreePlaneScrolling(x, y) {
    xSum := xSum + x
    ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)

    if(abs_xSum > movementThreshold || abs_ySum > movementThreshold) {
        if(abs_ySum >= abs_xSum) { ; up/down
            if (ySum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 5, -1) ; Wheel Down
                ySum := 0
            } else {
                AHI.SendMouseButtonEvent(mouseId, 5, 1) ; Wheel Up
                ySum := 0
            }
        } else { ; right/left
            if (xSum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 6, 1) ; Wheel Right
                xSum := 0
            } else {
                AHI.SendMouseButtonEvent(mouseId, 6, -1) ; Wheel Left
                xSum := 0
            }
        }
    }
    ;Tooltip i=%i% | x: %x%  y: %y% | ySum: %ySum% | xSum: %xSum% ;top left is minus for x and y
}

/*
    @Title: FixedAxisScrolling
    @Desc: scrolls on fixed axis, hence diagonal movements aren't possible like on an unrestricted plane.
        That is so simply because with any move both X and Y are reset.
*/
FixedAxisScrolling(x, y) {
    if(!runFlag)
        Exit
    global xSum := xSum + x
    global ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)

    if(abs_xSum > movementThreshold || abs_ySum > movementThreshold) {
        if(abs_ySum >= abs_xSum) { ; up/down
            if (ySum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 5, -1) ; Wheel Down
                gosub ResetXY
            } else {
                AHI.SendMouseButtonEvent(mouseId, 5, 1) ; Wheel Up
                gosub ResetXY
            }
        } else { ; right/left
            if (xSum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 6, 1) ; Wheel Right
                gosub ResetXY
            } else {
                AHI.SendMouseButtonEvent(mouseId, 6, -1) ; Wheel Left
                gosub ResetXY
            }
        }
    }
    ;Tooltip i=%i% | x: %x%  y: %y% | ySum: %ySum% | abs_xSum: %abs_xSum% ;top left is minus for x and y
}

ResetXY:
    xSum := 0
    ySum := 0
return

; @Desc: run in parallel since it's a function
ExitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    ExitApp
    /*
    if(ErrorLevel){
        runFlag := false
        AHI.SubscribeMouseMoveRelative(mouseId, false, Func("FixedAxisScrolling"))
        restoreCursors()
    }
    */
}

ExitOnHoldButton(state) {
    ExitApp
}

ExitFunc(ExitReason, ExitCode)
{
    ; Do not call ExitApp -- that would prevent other OnExit functions from being called.
    restoreCursors()
    return

    /*
    if(WinExist("Mousescroll.ahk ahk_class AutoHotkey")) {
        Tooltip %scriptName% exists time:%A_ClickCount%
        PostMessage, 0x111, 65307, 0 ; The message is sent to the "last found window" due to WinExist() above.
        ;Tooltip Exit
        return
    } else {
         return
    }
    */
}
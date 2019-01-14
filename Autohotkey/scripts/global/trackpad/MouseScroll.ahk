/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
#SingleInstance force
#Persistent
;Process,priority,,Realtime
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey

Global mouseId, xSum, ySum, movementThreshold, runFlag
return




Setup_MouseScroll(mId) {
    ;Tooltip Setup_MouseScroll
    InitVars(mId)
}

InitVars(mId) {
    runFlag := false
    mouseId := mId
    movementThreshold := 8
    gosub ResetXY
}

ResetXY:
    xSum := 0
    ySum := 0
    return

Start_MouseScroll() {
    ;Tooltip MS_Start
    SetSystemCursor("IDC_SIZEALL",0,0)
    runFlag := true
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("FixedAxisScrolling"))
}

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
    if(runFlag){
        ;Tooltip FixedAxisScrolling %x% %y%
        xSum := xSum + x
        ySum := ySum + y
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
}

; @Desc: run in parallel since it's a function
ExitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    Stop_MouseScroll()
}

Stop_MouseScroll() {
    ;Tooltip Stop_MouseScroll
    runFlag := false
    AHI.SubscribeMouseMoveRelative(mouseId, false, Func("FixedAxisScrolling"))
    restoreCursors()
}
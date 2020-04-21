/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
#SingleInstance force
#Persistent
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey

#Include %A_WorkingDir%\lib\Functions.ahk
Global mouseId, ms_xSum, ms_ySum, ms_movementThreshold, ms_runflag, ms_isCursorChanged
return




Setup_MouseScroll(mId) {
    ;Tooltip Setup_MouseScroll
    ms_InitVars(mId)
}

ms_InitVars(mId) {
    ms_runflag := false
    mouseId := mId
    ms_movementThreshold := 1
    gosub ms_ResetXY
}

ms_ResetXY:
    ms_xSum := 0
    ms_ySum := 0
    return

Start_MouseScroll() {
    ;Tooltip MS_Start
    SetSystemCursor("IDC_SIZEALL")
    ms_runflag := true
    AHI.SubscribeMouseMoveRelative(mouseId, true, Func("ms_MouseMovement"))
}

Stop_MouseScroll() {
    ;Tooltip Stop_MouseScroll
    ms_runflag := false
    ; AHI.SubscribeMouseMoveRelative(mouseId, false, Func("ms_MouseMovement"))
    AHI.UnsubscribeMouseMoveRelative(mouseId)
    gosub ms_ResetXY
    setTimer RestoreCursors, -100
}

; @Desc: run in parallel since it's a function
ms_ExitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    Stop_MouseScroll()
}

/*
    @Title: FreePlaneScroll
    @Desc: scrolls in any direction, i.e. not bound to straight axis movements.
    #note some apps don't allow such movements and will only respond to axial scrolls in a row, e.g. gChrome
*/
ms_MouseMovement(x, y) {
    if(ms_runflag) {
        ;Tooltip ms_FixedAxisScrolling %x% %y%
        ms_xSum := ms_xSum + (x)
        ms_ySum := ms_ySum + (y)
        abs_xSum := abs(ms_xSum) ; functions possible: ln/log = starts quick and slows down
        abs_ySum := abs(ms_ySum)   ; sqrt or * x to start quick
        ; Tooltip %abs_xSum% %abs_ySum%
        if(abs_xSum > ms_movementThreshold || abs_ySum > ms_movementThreshold) {
            ms_FixedAxisScrolling(ms_xSum, ms_ySum, abs_xSum, abs_ySum)
        }
    }
}

/*
    @Title: ms_FixedAxisScrolling
    @Desc: scrolls on fixed axis, hence diagonal movements aren't possible like on an unrestricted plane.
        That is so simply because with any move both X and Y are reset.
*/
ms_FixedAxisScrolling(ms_xSum, ms_ySum, abs_xSum, abs_ySum) {
    if(abs_ySum > abs_xSum) { ; up/down
        if (ms_ySum > 0) {
            MouseClick,WheelDown,,,%abs_xSum%,0,D,R
        } else {
            MouseClick,WheelUp,,,%abs_xSum%,0,D,R
        }
    } else { ; right/left
        if (ms_xSum > 0) {
            SendInput {WheelRight}
        } else {
            SendInput {WheelLeft}
        }
    }
    gosub ms_ResetXY
    ;Tooltip i=%i% | x: %x%  y: %y% | ms_ySum: %ms_ySum% | abs_xSum: %abs_xSum% ;top left is minus for x and y
}

/*
    @Title: FreePlaneScroll
    @Desc: scrolls in any direction, i.e. not bound to straight axis movements.
    #note some apps don't allow such movements and will only respond to axial scrolls in a row, e.g. gChrome
*/
/*
ms_FreePlaneScrolling(x, y) {
    ms_xSum := ms_xSum + (x*x) ; quadratic increase
    ms_ySum := ms_ySum + (y*y) ; quadratic increase
    abs_xSum := abs(ms_xSum)
    abs_ySum := abs(ms_ySum)

    if(abs_xSum > ms_movementThreshold || abs_ySum > ms_movementThreshold) {
        if(abs_ySum > abs_xSum) { ; up/down
            if (ms_ySum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 5, -1) ; Wheel Down
                ms_ySum := 0
            } else {
                AHI.SendMouseButtonEvent(mouseId, 5, 1) ; Wheel Up
                ms_ySum := 0
            }
        } else { ; right/left
            if (ms_xSum > 0) {
                AHI.SendMouseButtonEvent(mouseId, 6, 1) ; Wheel Right
                ms_xSum := 0
            } else {
                AHI.SendMouseButtonEvent(mouseId, 6, -1) ; Wheel Left
                ms_xSum := 0
            }
        }
    }
    ;Tooltip i=%i% | x: %x%  y: %y% | ms_ySum: %ms_ySum% | ms_xSum: %ms_xSum% ;top left is minus for x and y
*/
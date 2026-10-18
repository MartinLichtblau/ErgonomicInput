/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
Setup_MouseScroll:
    global ms_runflag := false
    global ms_isCursorChanged := false
    global ms_anchorX := 0
    global ms_anchorY := 0
    global ms_xDirection := 0
    global ms_yDirection := 0
    global ms_xDirectionTime := 0
    global ms_yDirectionTime := 0
    return

Start_MouseScroll() {
    if (ms_runflag)
        return
    CoordMode, Mouse, Screen
    MouseGetPos, ms_anchorX, ms_anchorY
    ms_xDirection := 0
    ms_yDirection := 0
    ms_xDirectionTime := A_TickCount
    ms_yDirectionTime := A_TickCount
    ms_isCursorChanged := false
    ms_runflag := true
    SetTimer, ms_PollMouseMovement, 10
}

Stop_MouseScroll() {
    SetTimer, ms_PollMouseMovement, Off
    ms_runflag := false
    if (ms_isCursorChanged) {
        SetTimer, RestoreCursor, -100
        ms_isCursorChanged := false
    }
}

; @Desc: run in parallel since it's a function
ms_ExitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    ;Stop_MouseScroll()
}

ms_PollMouseMovement:
    CoordMode, Mouse, Screen
    MouseGetPos, currentX, currentY
    movementX := currentX - ms_anchorX
    movementY := currentY - ms_anchorY
    if (movementX || movementY) {
        if (!ms_isCursorChanged) {
            SetSystemCursor("")
            ms_isCursorChanged := true
        }
        DllCall("SetCursorPos", "Int", ms_anchorX, "Int", ms_anchorY)
        ms_MouseMovement(movementX, movementY)
    }
    return

ms_MouseMovement(x, y) {
    global ms_runflag, ms_xDirection, ms_yDirection, ms_xDirectionTime, ms_yDirectionTime
    if (!ms_runflag)
        return

    now := A_TickCount
    if (x) {
        direction := x > 0 ? 1 : -1
        if (!ms_xDirection || direction = ms_xDirection || now - ms_xDirectionTime >= 80) {
            ms_xDirection := direction
            ms_xDirectionTime := now
        } else
            x := 0
    }
    if (y) {
        direction := y > 0 ? 1 : -1
        if (!ms_yDirection || direction = ms_yDirection || now - ms_yDirectionTime >= 80) {
            ms_yDirection := direction
            ms_yDirectionTime := now
        } else
            y := 0
    }

    if (x || y)
        ms_FixedAxisScrolling(1.5 * x, 2.2 * y)
}

/*
    @Title: ms_FixedAxisScrolling
    @Desc: scrolls on fixed axis, hence diagonal movements aren't possible like on an unrestricted plane.
        That is so simply because with any move both X and Y are reset.
*/
ms_FixedAxisScrolling(x, y) {
    if(abs(y) >= abs(x)) { ; up/down
        if (y > 0) {
            MouseClick,WheelDown,,,1,0,D,R
        } else {
            MouseClick,WheelUp,,,1,0,D,R
        }
    } else { ; right/left
        if (x > 0) {
            MouseClick,WheelRight,,,%x%,0,D,R
        } else {
            MouseClick,WheelLeft,,,abs(x),0,D,R
        }
    }
}


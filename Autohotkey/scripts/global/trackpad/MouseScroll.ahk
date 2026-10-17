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

#Include %A_ScriptDir%\lib\Functions.ahk
Global ms_runflag, ms_isCursorChanged, output_stepSize, ms_anchorX, ms_anchorY, ms_verticalRemainder, ms_horizontalRemainder
return




Setup_MouseScroll() {
    ;Tooltip Setup_MouseScroll
    ms_InitVars()
}

ms_InitVars() {
    global ms_runflag, ms_verticalRemainder, ms_horizontalRemainder
    ms_runflag := false
    ms_verticalRemainder := 0
    ms_horizontalRemainder := 0
}


Start_MouseScroll() {
    ;Tooltip MS_Start
    global ms_runflag, ms_anchorX, ms_anchorY, ms_verticalRemainder, ms_horizontalRemainder
    if (ms_runflag)
        return
    CoordMode, Mouse, Screen
    MouseGetPos, ms_anchorX, ms_anchorY
    ms_verticalRemainder := 0
    ms_horizontalRemainder := 0
    SetSystemCursor("")
    ms_runflag := true
    SetTimer, ms_PollMouseMovement, 10
}

Stop_MouseScroll() {
    ;Tooltip Stop_MouseScroll
    SetTimer, ms_PollMouseMovement, Off
    ms_runflag := false
    setTimer RestoreCursor, -100
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
    if (movementX || movementY)
        DllCall("SetCursorPos", "Int", ms_anchorX, "Int", ms_anchorY)
    if (movementX || movementY)
        ms_MouseMovement(movementX, movementY)
    return

ms_MouseMovement(x, y) {
    if (ms_runflag)
        ms_FixedAxisScrolling(1.5 * x, 2.2 * y)
}

/*
    @Title: ms_FixedAxisScrolling
    @Desc: scrolls on fixed axis, hence diagonal movements aren't possible like on an unrestricted plane.
        That is so simply because with any move both X and Y are reset.
*/
ms_FixedAxisScrolling(x, y) {
    if(abs(y) >= abs(x)) { ; up/down
        if (y > 0) { ; @TODO write if to use better scrolling (postmw) for Chrome
            ;PostMW(-y) 
            MouseClick,WheelDown,,,1,0,D,R ;
        } else {
            ;PostMW(-y) 
            MouseClick,WheelUp,,,1,0,D,R ;
        }
    } else { ; right/left
        if (x > 0) {
            MouseClick,WheelRight,,,%x%,0,D,R
        } else {
            MouseClick,WheelLeft,,,abs(x),0,D,R
        }
    }
    ;Tooltip i=%output_stepSize% | ms_xSum: %ms_xSum% | ms_ySum: %ms_ySum% | abs_xSum: %abs_xSum% | abs_ySum: %abs_ySum% ;top left is minus for x and y
}
; ms_FixedAxisScrolling(x, y) {
;     global ms_verticalRemainder, ms_horizontalRemainder
;     if (Abs(y) >= Abs(x)) { ; up/down
;         ms_verticalRemainder += -y * 0.1
;         wheelDelta := ms_verticalRemainder >= 0 ? Floor(ms_verticalRemainder) : Ceil(ms_verticalRemainder)
;         if (wheelDelta) {
;             PostMW(wheelDelta)
;             ms_verticalRemainder -= wheelDelta
;         }
;     } else { ; right/left
;         ms_horizontalRemainder += x * 0.1
;         wheelDelta := ms_horizontalRemainder >= 0 ? Floor(ms_horizontalRemainder) : Ceil(ms_horizontalRemainder)
;         if (wheelDelta) {
;             PostMW(wheelDelta, true)
;             ms_horizontalRemainder -= wheelDelta
;         }
;     }
; }

PostMW(delta, horizontal := false)
{ ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms645617(v=vs.85).aspx
  CoordMode, Mouse, Screen
  MouseGetPos, x, y
  Modifiers := 0x8*GetKeyState("ctrl") | 0x1*GetKeyState("lbutton") | 0x10*GetKeyState("mbutton")
              |0x2*GetKeyState("rbutton") | 0x4*GetKeyState("shift") | 0x20*GetKeyState("xbutton1")
              |0x40*GetKeyState("xbutton2")
  PostMessage, % horizontal ? 0x20E : 0x20A, delta << 16 | Modifiers, y << 16 | x ,, A
}


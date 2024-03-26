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
Global ms_xSum, ms_ySum, ms_movementThreshold, ms_runflag, ms_isCursorChanged, output_stepSize
return




Setup_MouseScroll(mId) {
    ;Tooltip Setup_MouseScroll
    ms_InitVars(mId)
}

ms_InitVars(mId) {
    ms_runflag := false
    ms_movementThreshold := 1
}


Start_MouseScroll(tpId) {
    ;Tooltip MS_Start
    SetSystemCursor("IDC_SIZEALL")
    ms_runflag := true
    AHI.SubscribeMouseMoveRelative(tpId, true, Func("ms_MouseMovement"))
}

Stop_MouseScroll(tpId) {
    ;Tooltip Stop_MouseScroll
    ms_runflag := false
    ; AHI.SubscribeMouseMoveRelative(mouseId, false, Func("ms_MouseMovement"))
    AHI.UnsubscribeMouseMoveRelative(tpId)
    setTimer RestoreCursor, -100
}

; @Desc: run in parallel since it's a function
ms_ExitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    ;Stop_MouseScroll()
}

ms_MouseMovement(x, y) {
    if(ms_runflag) {
        ;Tooltip ms_FixedAxisScrolling %x% %y%
        ms_FixedAxisScrolling(1.5*x, 2.2*y) ;ms_FixedAxisScrolling(1.1**x, 1.3**y)

    }
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

PostMW(delta)
{ ;http://msdn.microsoft.com/en-us/library/windows/desktop/ms645617(v=vs.85).aspx
  CoordMode, Mouse, Screen
  MouseGetPos, x, y
  Modifiers := 0x8*GetKeyState("ctrl") | 0x1*GetKeyState("lbutton") | 0x10*GetKeyState("mbutton")
              |0x2*GetKeyState("rbutton") | 0x4*GetKeyState("shift") | 0x20*GetKeyState("xbutton1")
              |0x40*GetKeyState("xbutton2")
  PostMessage, 0x20A, delta << 16 | Modifiers, y << 16 | x ,, A
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
        if(abs_ySum >= abs_xSum) { ; up/down
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
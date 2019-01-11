/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
    #NOOOOOOOOOOOOOOOOTTTTTTTTEEEEEEEEEEEEEE
        If I had included it into TrackScroll I wouldn't have the issues with the separate thread instance
        which is sometimes stuck and won't stop.
*/
;Tooltip MS_On
#SingleInstance force
#Persistent
Process,priority,,Realtime

#include %A_ScriptDir%\AutoHotInterception\AutoHotInterception.ahk

; Parameter: %pressDeviceId% %pressKey% %scrollMouseId%
if(A_Args.Length() != 3)
    ExitApp
global pressDeviceId := A_Args[1]
global pressKey := A_Args[2]
global scrollMouseId := A_Args[3]
;Tooltip Parameters: pressDeviceId: %pressDeviceId% pressKey: %pressKey%   scrollMouseId: %scrollMouseId%

; AHI
global AHI := new AutoHotInterception()
AHI.SubscribeMouseMoveRelative(scrollMouseId, true, Func("FixedAxisScrolling"))
gosub ResetXY ; reset values since var have undefined value

AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent")) ;keep it or Exit hooks won't work
exitOnInput()
return ; End of Auto-execute section




/*
; Subscribe to correct device and key
; #note currently only AHI Button Ids possible
if(pressDeviceId < 11) { ; it's a keyboard
    ;AHI.SubscribeKey(pressDeviceId, GetKeySC(pressKey), true, Func("PressKeyEvent"))
} else { ; it's a mouse
    Tooltip %pressKey%
    AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent"))
}
*/


/*
    @Title: FreePlaneScroll
    @Desc: scrolls in any direction, i.e. not bound to straight axis movements.
    #note some apps don't allow such movements and will only respond to axial scrolls in a row, e.g. gChrome
*/
FreePlaneScrolling(x, y) {
    global xSum := xSum + x
    global ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)

    if(abs_xSum > 8 || abs_ySum > 8) { ; moveThreshold=8
        if(abs_ySum >= abs_xSum) { ; up/down
            if (ySum > 0) {
                AHI.SendMouseButtonEvent(scrollMouseId, 5, -1) ; Wheel Down
                ySum := 0
            } else {
                AHI.SendMouseButtonEvent(scrollMouseId, 5, 1) ; Wheel Up
                ySum := 0
            }
        } else { ; right/left
            if (xSum > 0) {
                AHI.SendMouseButtonEvent(scrollMouseId, 6, 1) ; Wheel Right
                xSum := 0
            } else {
                AHI.SendMouseButtonEvent(scrollMouseId, 6, -1) ; Wheel Left
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
    global xSum := xSum + x
    global ySum := ySum + y
    abs_xSum := abs(xSum)
    abs_ySum := abs(ySum)

    if(abs_xSum > 7 || abs_ySum > 7) { ; moveThreshold=8
        if(abs_ySum >= abs_xSum) { ; up/down
            if (ySum > 0) {
                AHI.SendMouseButtonEvent(scrollMouseId, 5, -1) ; Wheel Down
                gosub ResetXY
            } else {
                AHI.SendMouseButtonEvent(scrollMouseId, 5, 1) ; Wheel Up
                gosub ResetXY
            }
        } else { ; right/left
            if (xSum > 0) {
                AHI.SendMouseButtonEvent(scrollMouseId, 6, 1) ; Wheel Right
                gosub ResetXY
            } else {
                AHI.SendMouseButtonEvent(scrollMouseId, 6, -1) ; Wheel Left
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


exitOnInput() {
    Input, UserInput, V L1 B, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
    if(ErrorLevel)
        ExitApp
}

; Exit on release of pressKey
PressKeyEvent(state) {
    ;Tooltip MS_Off
    ;tooltip PressKeyEvent
    ;SystemCursor("Toggle")
    ;Sleep 50
    AHI := 1
ExitApp
}

/* #alternative
; Exit on release of pressKey
PressKeyEvent(state) {
    ;Tooltip MS_Off
    ;tooltip PressKeyEvent
    ;SystemCursor("Toggle")
    Sleep 50
    ExitApp
}

~*MButton up::
~*RButton up::
    Tooltip Exit:MouseScroll
ExitApp
*/

SystemCursor(OnOff=1)   ; INIT = "I","Init"; OFF = 0,"Off"; TOGGLE = -1,"T","Toggle"; ON = others
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13 ; system cursors
        , b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13   ; blank cursors
        , h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13   ; handles of default cursors
    if (OnOff = "Init" or OnOff = "I" or $ = "")       ; init when requested or at first call
    {
        $ = h                                          ; active default cursors
        VarSetCapacity( h_cursor,4444, 1 )
        VarSetCapacity( AndMask, 32*4, 0xFF )
        VarSetCapacity( XorMask, 32*4, 0 )
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor   := DllCall( "LoadCursor", "uint",0, "uint",c%A_Index% )
            h%A_Index% := DllCall( "CopyImage",  "uint",h_cursor, "uint",2, "int",0, "int",0, "uint",0 )
            b%A_Index% := DllCall("CreateCursor","uint",0, "int",0, "int",0
                , "int",32, "int",32, "uint",&AndMask, "uint",&XorMask )
        }
    }
    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b  ; use blank cursors
    else
        $ = h  ; use the saved cursors

    Loop %c0%
    {
        h_cursor := DllCall( "CopyImage", "uint",%$%%A_Index%, "uint",2, "int",0, "int",0, "uint",0 )
        DllCall( "SetSystemCursor", "uint",h_cursor, "uint",c%A_Index% )
    }
}
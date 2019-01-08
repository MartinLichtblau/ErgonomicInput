/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
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
AHI.SubscribeMouseMoveRelative(scrollMouseId, true, Func("MouseEvent"))
AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent"))


/*
; Subscribe to correct device and key
; #note currently only AHI Button Ids possible
if(pressDeviceId < 11) { ; it's a keyboard
    ;AHI.SubscribeKey(pressDeviceId, GetKeySC(pressKey), true, Func("PressKeyEvent"))
} else { ; it's a mouse
    Tooltip %pressKey%
    AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent"))
}

; Exit on release of pressKey
PressKeyEvent(state) {
    tooltip PressKeyEvent
    if(!state)
        ExitApp
}
*/





global xSum := 0
global ySum := 0
MouseEvent(x, y){
    xSum := xSum + x
    ySum := ySum + y
    if(xSum > 10) {
        SendInput {WheelRight}
        xSum = 0
        ySum = 0
    } else if(xSum < -10) {
        SendInput {WheelLeft}
        xSum = 0
        ySum = 0
    } else if(ySum > 8) {
        SendInput {WheelDown}
        xSum = 0
        ySum = 0
    } else if(ySum < -10) {
        SendInput {WheelUp}
        xSum = 0
        ySum = 0

    }
    ;Tooltip i=%i% | x: %x%  y: %y% | xSum: %xSum% ;top left is minus for x and y
}

/*
if (DiffHrVr > 2 || DiffHrVr < -2) {
			IF (absHrDist > absVrDist) {
				smoothHrDist := ceil(log(absHrDist)) ; converted into positive int number
				if (hrDist > 0) {
					Send {WheelDown %smoothHrDist%}
				} else {
					Send {WheelUp %smoothHrDist%}
				}
			} ELSE {
				smoothVrDist := ceil(log(absVrDist)) ; converted into positive int number
				if (vrDist > 0) {
					Send {WheelRight %smoothVrDist%}
				} else {
					Send {WheelLeft %smoothVrDist%}
				}
			}
		}

        AHI.SendMouseButtonEvent(scrollMouseId, 5, 1) ; vWheelDown
        AHI.SendMouseButtonEvent(scrollMouseId, 5, 0) ; vWheelUp
*/





/*
; #note this version is too fucking over-complicated
ScrollWithMouse(key) {
    CoordMode, Mouse, Screen ; #note needs to be set inside function, at top of script it won't work
    MouseGetPos, oldX, oldY
	SystemCursor("Toggle")

	While GetKeyState(key, "P") {
        MouseGetPos, newX, newY
		vrDist := newX-oldX
		absVrDist := Abs(vrDist)
		hrDist := newY-oldY
		absHrDist := Abs(hrDist)

		DiffHrVr := absHrDist - absVrDist
		;Tooltip %absHrDist% %absVrDist%
		if (DiffHrVr > 2 || DiffHrVr < -2) {
			IF (absHrDist > absVrDist) {
				smoothHrDist := ceil(log(absHrDist)) ; converted into positive int number
				if (hrDist > 0) {
					Send {WheelDown %smoothHrDist%}
				} else {
					Send {WheelUp %smoothHrDist%}
				}
			} ELSE {
				smoothVrDist := ceil(log(absVrDist)) ; converted into positive int number
				if (vrDist > 0) {
					Send {WheelRight %smoothVrDist%}
				} else {
					Send {WheelLeft %smoothVrDist%}
				}
			}
		}
		DllCall("SetCursorPos", int, oldX, int, oldY)  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
		    ; MouseMove didn't work on multi-monitor https://www.autohotkey.com/docs/commands/MouseMove.htm
        ; Sleep 20
        ; Tooltip, %A_CoordModeMouse% — X: %newX% | %oldX%  Y: %newY% | %oldY%
	}
	SystemCursor("Toggle")
}

/*
ScrollWithMouse(key) {
	CoordMode, Mouse, Screen ; The fucking bug! that bugged my head!
	Modifiers := 0x8*GetKeyState("ctrl") | 0x1*GetKeyState("lbutton") | 0x10*GetKeyState("mbutton")
              |0x2*GetKeyState("rbutton") | 0x4*GetKeyState("shift") | 0x20*GetKeyState("xbutton1")
              |0x40*GetKeyState("xbutton2")
	MouseGetPos, oldX, oldY

	While GetKeyState(key, "P") {
		MouseGetPos, newX, newY
		MouseMove, oldX, oldY, 0
		movVer := oldX-newX
		movHor := oldY-newY

		IF (Abs(movHor) > Abs(movVer)) {
			PostMessage, 0x20A, movHor*2 << 16 | Modifiers, oldY << 16 | oldX ,, A
		} ELSE {
			PostMessage, 0x20A, movHor*2 << 16 | Modifiers, oldX << 16 | oldY ,, A
		}
	}
	MouseMove, oldX, oldY, 0
	;Sleep 20
return
}
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
*/
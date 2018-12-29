/*
    @Title: Trackpad
    @Desc: change trackpad buttons behavior
*/
Process, priority,, Realtime


$*MButton::
	Click, down,
	Keywait,MButton,
	Click, up,
return


$*LButton::
	;SetMouseDelay, 10
	; Tooltip %A_MouseDelay%
	KeyWait, LButton, T0.2
	if (ErrorLevel) {
		ScrollWithMouse("LButton")
		;SystemCursor("On")
	} else if (A_PriorHotkey == "$*LButton") {
		;Tooltip %A_PriorKey% %A_PriorHotkey% %A_ThisHotkey%
		;SystemCursor("On")
		Click,down,Middle,,
		Sleep 10
		Click,up,Middle,,
	}
return
;Critical, On
;#MaxThreadsPerHotkey 1
$*LButton Up::
	;Tooltip up
	if WinExist("Task Switching") {
		SendInput {Alt Up}
	}

	; BlockInput,On
	; Sleep, 100
	; BlockInput,Off
	; ;Tooltip %A_PriorKey% %A_PriorHotkey% %A_ThisHotkey%

Return
; ; ;Critical, Off
;#MaxThreadsPerHotkey 1


; #note: I can't make it work like LButton. The left hardware trackpad button seems to be the problem. I tried everything!
$*RButton::
	KeyWait, RButton, T0.2
	if (ErrorLevel) {
		ScrollWithMouse("RButton")
	} else if (A_PriorHotkey == "$*RButton") {
		Click,,right
	}
return
$*RButton Up::
	if WinExist("Task Switching") {
		SendInput {Alt Up}
	}
return


/*
    @Title: EasyScroll
    @Desc: scroll by press- and holding h with middle-finger while controlling trackpoint with index-finger
    #note: any other key could be used. Even alternative ones to allow changing positions
*/
*h::
    KeyWait, h, T0.15
	if (ErrorLevel) {
    	ScrollWithMouse("h")
    } else {
        SendInput {blind}h
    }
return


;this version is too fucking over-complicated
ScrollWithMouse(key) {
	MouseGetPos, oldX, oldY
	SystemCursor("Toggle")

	While GetKeyState(key, "P") {
		MouseGetPos, newX, newY
		MouseMove, oldX, oldY, 0
		vrDist := newX-oldX
		absVrDist := Abs(vrDist)
		hrDist := newY-oldY
		absHrDist := Abs(hrDist)
		;Tooltip, %newX% | %oldX% movVer:%movVer%

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
		;MouseMove, oldX, oldY, 0
        ;Sleep 20
	}
	SystemCursor("Toggle")
return
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
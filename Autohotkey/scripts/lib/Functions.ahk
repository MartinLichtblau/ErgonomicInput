#SingleInstance force
#Persistent
return

/*
    @Desc: shows relevant and often needed integrated A_variables
*/
showKeyVars:
    Tooltip A_PriorKey: %A_PriorKey% | A_PriorHotkey: %A_PriorHotkey% | A_ThisHotkey: %A_ThisHotkey% | A_TimeSinceThisHotkey:%A_TimeSinceThisHotkey% | A_TimeSincePriorHotkey:%A_TimeSincePriorHotkey% ; #debug
    return


/*
    @reasonWhy: simply "PostMessage,0x111,65307,,,MouseScroll.ahk" will lead to problems if said script doesn't exist
*/
ExitScript(scriptName) {
    ;foundCount := 0
    Loop 5 {
        if(WinExist(scriptName . ".ahk" . " ahk_class AutoHotkey")) {
            ;foundCount++
            ;Tooltip %scriptName% exists %A_INdex% %foundCount%
            PostMessage, 0x111, 65307, 0 ; The message is sent to the "last found window" due to WinExist() above.
            ;return
        }
        Sleep 10
    }
}

/*
    @Title: LongPressCommand
    @Desc: produce different command depending on press-duration of pressedKey
    @Parameter: all strings
    #reminder {%string%} interprets it as string and %string% as a raw command
*/
LongPressCommand(pressKey, shortCmd, longCmd) {
    ;Tooltip Quick Cmd: %quickCmd% | Long Cmd: %longCmd%
    KeyWait, %pressKey%, T0.2
    If ErrorLevel {
        if ("gosub" == SubStr(longCmd, 1, 5)) {
            longCmdLabel := SubStr(longCmd, 7)
            Gosub %longCmdLabel%
        } else {
            SendInput %longCmd%
        }
    } else {
        if ("gosub" == SubStr(shortCmd, 1, 5)) {
            shortCmdLabel := SubStr(shortCmd, 7)
            Gosub %shortCmdLabel%
        } else {
            SendInput %shortCmd%
        }
    }
    Keywait, %pressKey%,
}

/*
    #note: can't work because once a hotkey is defined it cannot be removed, hence this function only works once.
*/
DeactivateHookedKeyUntilRelease(pressKey) {
    Hotkey, %pressKey%,, UseErrorLevel
    if (ErrorLevel ==  5 || ErrorLevel ==  6) {
        ; 5 = The command attempted to modify a nonexistent hotkey.
        ; 6 = The command attempted to modify a nonexistent variant of an existing hotkey. To solve this, use Hotkey IfWin to set the criteria to match those of the hotkey to be modified.
        Hotkey, %pressKey%, JustReturn, On
        KeyWait, %pressKey%,
        Hotkey, %pressKey%, Off
    }
}

DeactivateKeyUntilRelease(pressKey) {
    Hotkey, %pressKey%, JustReturn, On
    KeyWait, %pressKey%,
    Hotkey, %pressKey%, Off
}

JustReturn:
    return

/*
    @Title: ReplaceOnLongPress
    @Desc: On long press of pKey it is substituted with charToWrite
*/
ReplaceOnLongPress(pKey, charToWrite) {
    SendInput {%pKey%}
	KeyWait, %pKey%, T0.20
	if (ErrorLevel && A_TimeIdleKeyboard >= 200) { ; A_Time* to ensure that no other key was pressed in between
	    SendInput {BS}%charToWrite%
	}
	KeyWait, %pKey%,
}

/*
    @Title: PrintMonitorSetup
*/
MonitorSetup() {
    sysget, ct, MonitorCount
    sysget, pri, MonitorPrimary
    out .= "MonitorCount: " ct "`n"
    out .= "MonitorPrimary: " pri "`n"
    Loop % ct {
    	Sysget, mon, Monitor, % A_Index
    	out .= "`nMonitor #" A_Index " coords:`n"
    	out .= "Left: " monLeft "`n"
    	out .= "Right: " monRight "`n"
    	out .= "Top: " monTop "`n"
    	out .= "Bottom: " monBottom "`n"
    }
    MsgBox %out%
}

MouseSpy() {
    ; This example allows you to move the mouse around to see
    ; the title of the window currently under the cursor:
    #Persistent
    SetTimer, WatchCursor, 100
return
}
WatchCursor:
    CoordMode,Mouse,Screen
    MouseGetPos, xpos, ypos, id, control
    WinGetTitle, title, ahk_id %id%
    WinGetClass, class, ahk_id %id%
    ToolTip, xpos:%xpos% ypos:%ypos%`n ahk_id %id%`nahk_class %class%`n%title%`nControl: %control%
return

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
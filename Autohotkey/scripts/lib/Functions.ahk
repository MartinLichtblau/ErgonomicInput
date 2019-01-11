#SingleInstance force
#Persistent
;Process,priority,,Realtime

/*
    @Desc: shows relevant and often needed integrated A_variables
*/
showKeyVars:
    Tooltip A_PriorKey: %A_PriorKey% | A_PriorHotkey: %A_PriorHotkey% | A_ThisHotkey: %A_ThisHotkey% | A_TimeSinceThisHotkey:%A_TimeSinceThisHotkey% | A_TimeSincePriorHotkey:%A_TimeSincePriorHotkey% ; #debug
    return


/*
    @reasonWhy: simply "PostMessage,0x111,65307,,,MouseScroll.ahk" will lead to problems if said script doesn't exist
*/
KillScript(scriptName){
    if(WinExist(scriptName . ".ahk" . " ahk_class AutoHotkey")) {
        ;Tooltip %scriptName% exists
        PostMessage, 0x111, 65307, 0 ; The message is sent to the "last found window" due to WinExist() above.
    }
}


/*
    @Desc: produce different command depending on time pressing the key
    #reminder {%string%} interprets it as string and %string% as a raw command
*/
LongPressCommand(pressedKey, shortCommand, longCommand) {
    KeyWait, %pressedKey%, T0.4
    If ErrorLevel {
        SendInput %longCommand%
    } else {
        SendInput %shortCommand%
    }
    KeyWait, %pressedKey%
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
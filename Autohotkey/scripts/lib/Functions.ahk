#SingleInstance force
#Persistent
;Process,priority,,Realtime

#Include %A_ScriptDir%/lib/Functions.ahk




/*
    @Desc: produce different command depending on time pressing the key
    #reminder {%string%} interprets it as string and %string% as a raw command
*/
LongPressCommand(pressedKey, shortCommand, longCommand) {
    KeyWait, %pressedKey%, T0.4
    If ErrorLevel {
        SendInput %longCommand%
    }
    Else {
        SendInput %shortCommand%
    }
    KeyWait, %pressedKey%
}

OpenNewTabWithSelection() {
    oldClip := clipboard
    Send ^c
    Sleep 200
    if (oldClip == clipboard) {
        SendInput ^t ; open empty tab / start page
    } else {
        ; Open new tab with selection
        Send ^l
        Sleep 100
        Send ^a^v!{Enter}
    }
    clipboard := oldClip
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
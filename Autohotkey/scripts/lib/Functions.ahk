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

; Source:   Serenity - https://autohotkey.com/board/topic/32608-changing-the-system-cursor/
; Modified: iseahound - https://www.autohotkey.com/boards/viewtopic.php?t=75867

SetSystemCursor(Cursor := "", cx := 0, cy := 0) {

   static SystemCursors := {APPSTARTING: 32650, ARROW: 32512, CROSS: 32515, HAND: 32649, HELP: 32651, IBEAM: 32513, NO: 32648
                        ,  SIZEALL: 32646, SIZENESW: 32643, SIZENS: 32645, SIZENWSE: 32642, SIZEWE: 32644, UPARROW: 32516, WAIT: 32514}

   if (Cursor = "") {
      VarSetCapacity(AndMask, 128, 0xFF), VarSetCapacity(XorMask, 128, 0)

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CreateCursor", "ptr", 0, "int", 0, "int", 0, "int", 32, "int", 32, "ptr", &AndMask, "ptr", &XorMask, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if (Cursor ~= "^(IDC_)?(?i:AppStarting|Arrow|Cross|Hand|Help|IBeam|No|SizeAll|SizeNESW|SizeNS|SizeNWSE|SizeWE|UpArrow|Wait)$") {
      Cursor := RegExReplace(Cursor, "^IDC_")

      if !(CursorShared := DllCall("LoadCursor", "ptr", 0, "ptr", SystemCursors[Cursor], "ptr"))
         throw Exception("Error: Invalid cursor name")

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", cx, "int", cy, "uint", 0, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if FileExist(Cursor) {
      SplitPath Cursor,,, Ext ; auto-detect type
      if !(uType := (Ext = "ani" || Ext = "cur") ? 2 : (Ext = "ico") ? 1 : 0)
         throw Exception("Error: Invalid file type")

      if (Ext = "ani") {
         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x10, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      } else {
         if !(CursorShared := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x8010, "ptr"))
            throw Exception("Error: Corrupted file")

         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      }
      return
   }

   throw Exception("Error: Invalid file path or cursor name")
}

RestoreCursor() {
   return DllCall("SystemParametersInfo", "uint", SPI_SETCURSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
}

SendArrowKey(keyName)
{
    if(keyName = "Right") {
        keySc := 333
    } else if(keyName = "Left") {
        keySc := 331
    } else if(keyName = "Down") {
        keySc := 336
    } else if(keyName = "Up") {
        keySc := 328
    }
    AHI.SendKeyEvent(1, keySc, 1)
    AHI.SendKeyEvent(1, keySc, 0)
    ;Send {blind}{Right}
}

MoveCursorToShow(){
    touchscreenId := AHI.GetMouseId(0x056A, 0x5146)
    ;AHI.SendMouseMoveAbsolute(touchscreenId, 30000, 30000)
    ;SetSystemCursor("")
    ;RestoreCursors()
    AHI.SendMouseMove(touchscreenId, 4, 50)
    Sleep 1000

    AHI.SendMouseButtonEvent(touchscreenId, 0, 1) ;SendInput {LButton Down}
    Sleep 100 ; Essential, or click won't be recognized
    AHI.SendMouseButtonEvent(touchscreenId, 0, 0) ;SendInput {LButton Up}
    ;AHI.SendMouseMove(trackpadId, 1, -100)
    ;AHI.SendMouseMove(trackpadId, 1, 100)
    ;MouseMove, 0,100,, R
    ;Sleep 10
    ;MouseMove, 0,-100,, R
    ;SendInput {LButton}
    ;MouseGetPos,,, WinUMID
    ;tooltip %WinUMID%
    ;WinActivate, ahk_id %WinUMID%

        ;if(%A_Cursor% = Unknown){
        ;MouseMove, 0,-1,, R ; move cursor up 1px, only to make it show up, in case touch was shown before.
        ;SetSystemCursor("")
        ;sleep 1000
        ;SendInput {LButton}
        ; DllCall("ShowCursor", Int,1)
        ;}
}

MoveCursorToLeft(){
    MouseMove, 0, 1000,
}

Global Autoscroll := 0
Autoscroll() {
        ;MouseClick,WheelDown,,,3,0,D,R
        ;SendInput {Down}
        ; StartTime := A_TickCount
       ; KeyWait, sc163
        ;px_down := A_TickCount - StartTime
        move_distance := 80
        ;tooltip %px_down% %StartTime% %A_TickCount%
        ;MoveCursorToShow()

        CoordMode, Mouse, Screen
        MouseGetPos, X, Y
        MouseMove, 0, 0,, R ;DllCall("SetCursorPos", "int", X, "int", Y+1)
        Y -= move_distance ; move cursor 30px UP first
        DllCall("SetCursorPos", "int", X, "int", Y)
        SendInput {MButton}
        Sleep 100
        ; tooltip %A_Cursor% ; Arrow is normal pointer and middle scroll is unknown
        Y += move_distance ; move cursor 30px down to initiate slow down scroll
        DllCall("SetCursorPos", "int", X, "int", Y)
        if (A_Cursor == "Unknown") {
            Autoscroll := 1
        } else {
            Autoscroll := 0
        }
        ;tooltip : %Autoscroll% %A_Cursor%
        return
}


GetAhiDeviceIdByHandle(handle) {
    for dix, device in AHI.GetDeviceList() {
        If InStr(device.Handle, handle) {
            return device.id
        }
    }
    return 0
}

/*
GetAhiDeviceIdsByHandle(deviceHandles) {
    DeviceList := AHI.GetDeviceList()
    FoundDeviceIds := {}
    for dix, device in DeviceList {
        for hix, handle in deviceHandles {
            If InStr(device.Handle, handle) {
                ;Tooltip % device.id trackpadHandle
                FoundDeviceIds.push(device.id)
                ;Tooltip % TrackpadIdList.Length()
            }
        }
    }
    return TrackpadIdList
}
*/
/*

*/
#SingleInstance force
#Persistent
return


/*
    @Title: AltTab
    @Desc: switch to previously focused window
    @note: integrated AltTab function only works without ~, hence without letting the modifier pass through.
*/
AltTab:
	if WinExist("Task Switching") { ; in german if WinExist("Programmumschaltung")
        ;Tooltip "just tab"
        Send {Tab}
	} else {
		;Tooltip "Open menu"
		Send {Alt Down}{Tab}
	}
return
AltTabRelease:
    if (GetKeyState("LAlt")) {
        ;if (A_PriorHotkey == "~RButton & t" || A_PriorHotkey == "~RButton & s") ; #delete: just a dirty fix for the slowly opening Quicktabs extension
        ;    Sleep 200
        SendInput {LAlt up}
    }
return


/*
    @Title: WinOrganize
    @Desc: moving windows around on the screens
    @Requirement: deactivate Windows Snap suggestion for that to work satisfying
    @TODO decide whinch of the two versions is better
*/
WinOrganizeLeft(pKey){
	KeyWait,%pKey%,T0.3
	If ErrorLevel {
		;WinMaximize, A ; maximize directly
		SendInput {LWin Down}{Down}{LWin Up}
	} else
		SendInput {LWin Down}{Left}{LWin Up}
	KeyWait,%pKey%,
return
}
WinOrganizeRight(pKey){
	KeyWait,%pKey%,T0.3
	If ErrorLevel {
		WinMaximize, A ; maximize directly
		;SendInput {LWin Down}{Up}{LWin Up}
	} else
		SendInput {LWin Down}{Right}{LWin Up}
	KeyWait,%pKey%,
return
}

/*
    @Title: MoveMouseToCaret
    #note would be nice, but pretty useless since nearly no app uses windows integrated caret function
*/
MoveMouseToCaret:
    MouseMove, A_CaretX, A_CaretY, 0
return

/*
    @Title: CenterMouseOnActiveWindow
    @Desc: moves mouse cursor in center of active window, if it isn't already above it / within bounds
*/
CenterMouseOnActiveWindow:
    Sleep 50 ; wait for GUI
    activeWinId := WinExist("A")
    MouseGetPos,,, winIdUnderMouse
    if (activeWinId != winIdUnderMouse) { ; check if mouse above active window
        ; CoordMode,Mouse,Screen ; not necessary when using DLL-call SetCursorPos
        WinGetPos, winTopL_x, winTopL_y, width, height, A
        winCenter_x := winTopL_x + width/2
        winCenter_y := winTopL_y + height/2
        ;MouseMove, X, Y, 0 ; does not work with multi-monitor
        DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
        ;Tooltip winTopL_x:%winTopL_x% winTopL_y:%winTopL_y% winCenter_x:%winCenter_x% winCenter_y:%winCenter_y%
    }
return

/*
    @Title: OpenTabWithSelection
    @Desc: open new empty tab if nothing selected, and else open the selection in new tab
    #note: Would always delay opening of any new tab
*/
OpenTabWithSelection:
    oldClip := clipboard
    Send ^c
    Sleep 400 ; need to wait for clipboard, but that also delays opening new tabs
    if (oldClip == clipboard) {
        SendInput ^t ; open empty tab / start page
    } else {
        ; Open new tab with selection
        Send ^l
        Sleep 100
        Send ^a^v!{Enter}
    }
    clipboard := oldClip
return

/*
    @Title: OpenTabWOSelection
    @Desc: on short press opens empty tab and on long press a new tab with selected text or url
*/
OpenTabWOSelection(pressKey) {
    clipTemp := ClipboardAll
    SendInput ^c
    KeyWait, %pressKey%, T0.3
    if ErrorLevel {
        ; Open new tab with selection
        Send ^l
        Sleep 50
        Send ^v
        Sleep 50
        Send !{Enter}
    } else {
        ; Open Tab without selection
        SendInput ^t
    }
    Clipboard := clipTemp
    KeyWait, %pressKey%
}

/*
    @Title:
    @Desc: moves active windows to other screen
    @Req: Dual-Monitor setup
*/
MoveWinBetweenScreens(pressKey) {
    KeyWait, %pressKey%, T0.3
    If ErrorLevel {
        SendInput {LWin Down}{LShift Down}{RIGHT}{LShift Up}{LWin Up}
        Sleep 100
        WinMaximize, A
        gosub CenterMouseOnActiveWindow
    } else {
        WinMaximize, A
    }
    KeyWait, %pressKey%
}

/*
    @Title: ReadMode
    @Desc: one shortcut to activate the optimal environment for reading
*/
readModeActive := false
ReadMode:
    readModeActive := !readModeActive
    if(readModeActive) {
            ; Highlight all quotes since often most concise part of whole text
            Send ^l
            Sleep 100
            SendInput find{Tab}
            Sleep 100
            ; Lookup unicode of quotation marks, which are special characters, so ahk understands.
              ; https://unicode-table.com/en/
            Send [{U+201C}{U+0022}{U+201E}](.*?)[{U+201D}{U+0022}
            Sleep 500
            Send {Blind}{Text}]
            Sleep 100
            Send {Enter}
    }

    Send {F11}
    ;Send !r ; color for reading #
    ;Send #^c ; use windows display filters to inverse colors

    ; activate tool for text markup/annotation/highlighting
    ; Send !h ; Hypothesis
    ; Send !l ; Liner
    ; use Worldbrains Mememx

    return

/*
    @Title: ChangeTranslateModeOnLongPress
    @Desc: on short press it quickly translates in place and on long press opens multiple sites with more comprehensive translations
    @Requirements:
        - Translate extension is installed in browser and put on Alt+t. E.g. @GoogleTranslateExtension
        - @InstantMultiTranslationExtension is installed and configured as needed
*/
ChangeTranslateModeOnLongPress(pressKey) {
    clipTemp := ClipboardAll
    KeyWait, %pressKey%, T0.3
    If ErrorLevel {
        SendInput ^c
        Sleep 100
        ; Comprehensive translation
        SendInput {ESC}
        Sleep 50
        SendInput ^t
        Sleep 200
        SendInput m{Space}
        Sleep 50
        SendInput t{space}
        SendInput ^v
        Sleep 50
        SendInput {Enter}
    } else {
        ; Quick Translate
        SendInput !t
    }
    Clipboard := clipTemp
    KeyWait, %pressKey%
}

/*
    @Title: MuteTabsToggle
    @Desc: mute or unmute tabs on short press and send F11 on long press
*/
muteToggle := false
MuteTabsToggle:
    muteToggle := !muteToggle
    if(muteToggle) {
        SendInput +!,
        ; Tooltip mute all but current tab
    } else {
        SendInput +!.
        ; Tooltip unmute all tabs
    }
    return

/*
    @Title: TogglePresentationMode
    @Desc: toggle between presentation mode, when active keeping PC awake
*/
presentationModeActive := false
TogglePresentationMode:
    presentationModeActive := !presentationModeActive
    if (presentationModeActive) {
        SetTimer, SendAwakeSignal, 60000
        Tooltip Presentation Mode %presentationModeActive%, 10000, 10000
    } else {
        SetTimer, SendAwakeSignal, Off
        Tooltip
    }

    SendAwakeSignal:
        SendInput {Shift}
    return


/*
    @Title: Dictation
    @Desc: toggle windows 10 dictation feature and close it on click of any key other than the toggle key itself
*/
dictationActive := false
dicStartTime := 0
Dictation:
    if (!dictationActive) {
        dicStartTime := A_TickCount
        SendInput #h ; open dictation
        dictationActive := true
        Hotkey, $F9, off ; deactivate hotkey so input can detect
        Loop {
            dicOpenSince := A_TickCount - dicStartTime
            if (A_TimeIdle < dicOpenSince-100) {
                goto Dictation
            }
            Sleep, 100
        }
        /*
        Input, key, L1 M V, {LButton}{RButton}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
        if (ErrorLevel = "NewInput" or ErrorLevel = "Max" or InStr(ErrorLevel, "EndKey:")) {
          gosub Dictation
        }
        */
    } else {
        SendInput #h ; close dictation
        dictationActive := false
        Hotkey, $F9, on
    }
    return
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
    SendInput {Alt Up}
	if WinExist("Task Switching"){
		;Tooltip AltTabRelease
		gosub CenterMouseOnActiveWindow
    }
return


/*
    @Title: WinOrganize
    @Desc: moving windows around on the screens
    @Requirement: deactivate Windows Snap suggestion for that to work satisfying
    @TODO decide whinch of the two versions is better
*/
WinOrganizeLeft(pKey){
	KeyWait,%pKey%,T0.2
	If ErrorLevel {
		;WinMaximize, A ; maximize directly
		SendInput {LWin Down}{Down}{LWin Up}
	} else
		SendInput {LWin Down}{Left}{LWin Up}
	KeyWait,%pKey%,
return
}
WinOrganizeRight(pKey){
	KeyWait,%pKey%,T0.2
	If ErrorLevel {
		WinMaximize, A ; maximize directly
		;SendInput {LWin Down}{Up}{LWin Up}
	} else
		SendInput {LWin Down}{Right}{LWin Up}
	KeyWait,%pKey%,
return
}

/*
    @Title: TypeArrow
    @Desc: make arrow-keys accessible in the center
*/
Left:
	Send {blind}{Left}
return

Up:
	Send {blind}{Up}
return

Right:
	Send {blind}{Right}
return

Down:
	Send {blind}{Down}
return

Home:
	Send {blind}{Home}
return

End:
	Send {blind}{End}
return

/*
    @Title: MoveMouseToCaret
    #note would be nice, but pretty useless since nearly no app uses windows integrated caret function
*/
MoveMouseToCaret:
    MouseMove, A_CaretX, A_CaretY, 0
return

/*
    @Title: CenterMouseOnActiveWindow
*/
CenterMouseOnActiveWindow:
    Sleep 50
    ; CoordMode,Mouse,Screen ; not necessary when using DLL-call SetCursorPos
    WinGetPos, winTopL_x, winTopL_y, width, height, A
    winCenter_x := winTopL_x + width/2
    winCenter_y := winTopL_y + height/2
    ;MouseMove, X, Y, 0 ; does not work with multi-monitor
    DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
    ;Tooltip winTopL_x:%winTopL_x% winTopL_y:%winTopL_y% winCenter_x:%winCenter_x% winCenter_y:%winCenter_y%
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
    KeyWait, %pressKey%, T0.4
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
MoveWinBetweenScreens:
    SendInput {LWin Down}{LShift Down}{RIGHT}{LShift Up}{LWin Up}
    Sleep 100
    WinMaximize, A
    gosub CenterMouseOnActiveWindow
    return

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
            SendInput [��"�](.*?)[�"�
            Sleep 500
            Send ]
            Send {Enter}
    }

    Send {F11}
    Send !r ; color for reading #

    ; activate tool for text markup/annotation/highlighting
    ;Send !h ; Hypothesis
    Send !l ; Liner
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
    SendInput ^c
    KeyWait, %pressKey%, T0.4
    If ErrorLevel {
        ; Comprehensive translation
        SendInput {ESC} ; #test if it closes blocking windows without causing problems, then keep it
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
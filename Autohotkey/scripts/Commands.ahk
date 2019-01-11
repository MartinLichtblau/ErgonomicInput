/*
    @Title: TabLeft
    @Desc: switch one tab left
*/
TabLeft:
	SendInput ^{PgUp}
	;SendInput +^{Tab}
Return


/*
    @Title: TabRight
    @Desc: switch one tab right
*/
TabRight:
	Send ^{PgDn}
	;SendInput ^{Tab}
Return


/*
    @Title: TabSearch
    @Desc: Opening Chrome extension for searching tabs, history and bookmarks
*/
TabSearch:
	Send ^+w
return


/*
    @Title: PreviousTab
    @Desc: Jumping back to last visited tab
*/
PreviousTab:
	Send !z ; #note can' t set ^+q in chrome as extension shortcut, hence it's mapped on x
return


/*
    @Title: DesktopLeft
    @Desc: switch one desktop to the left
*/
DesktopLeft:
	Send {LCtrl Down}{LWin Down}{Left}{LWin Up}{LCtrl Up}
return


/*
    @Title: DesktopRight
    @Desc: switch one desktop to the right
*/
DesktopRight:
	Send {LCtrl Down}{LWin Down}{Right}{LWin Up}{LCtrl Up}
return


/*
    @Title: WinView
    @Desc: Opening overview showing all desktop and open windows
*/
WinView:
    Send #{Tab}
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
	if WinExist("Task Switching"){
		SendInput {Alt Up}
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
		;WinMaximize, A ; maximize directly
		SendInput {LWin Down}{Up}{LWin Up}
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
    CoordMode,Mouse,Screen
    WinGetPos, winTopL_x, winTopL_y, width, height, A
    winCenter_x := winTopL_x + width/2
    winCenter_y := winTopL_y + height/2
    ;MouseMove, X, Y, 0 ; does not work with multi-monitor
    DllCall("SetCursorPos", int, winCenter_x, int, winCenter_y)
    ;Tooltip winTopL_x:%winTopL_x% winTopL_y:%winTopL_y% winCenter_x:%winCenter_x% winCenter_y:%winCenter_y%
return

/*
    @Title: OpenTabWithSelection
*/
OpenTabWithSelection:
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
return
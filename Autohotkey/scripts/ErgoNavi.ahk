/*
    @Title: ErgoNavi
    @Desc: bring all frequently used commands together for better ergonomic navigation
*/
#SingleInstance force
#Persistent
Process,priority,,Realtime
#Include %A_ScriptDir%/lib/Functions.ahk
return




;---------------------------------LeftHand--------------------------------
;--------------------------------------------F-Row
;--------------------------------------------Number-Row
    ~RButton & 1:: 
    ~RButton & 3:: Browser_Back
    ~RButton & 4:: Browser_Forward
;--------------------------------------------TopLetter-Row
    ~RButton & w:: gosub PreviousTab
    $^+w:: gosub PreviousTab
    ~RButton & q:: gosub TabSearch
    $^+q:: gosub TabSearch
    ~RButton & f:: gosub TabLeft
    <^<+f:: gosub TabLeft
    ~RButton & a:: gosub TabRight
    <^<+a:: gosub TabRight

;--------------------------------------------Home-Row
    ~RButton & p:: gosub WinView
    <^<+p:: gosub WinView
    ~RButton & r:: gosub DesktopLeft
    <^<+r:: gosub DesktopLeft
    ~RButton & s:: gosub DesktopRight
    <^<+s:: gosub DesktopRight
    ~RButton & t:: gosub AltTab
    <+<^t:: gosub AltTab
    ~RButton & d::LongPressCommand("d", "^w", "!{F4}")

;--------------------------------------------LowerLetter-Row
    ~RButton & c::LongPressCommand("c", "^w", "!{F4}")
    ~RButton & v::LongPressCommand("v", "^t", "+^t") ; perhaps extend with OpenNewTabWithSelection()
    ~RButton & x::LongPressCommand("x", "^n", "+^n")

;--------------------------------------------MISC
    $*RButton Up:: gosub AltTabRelease
    $~*LCtrl up:: gosub AltTabRelease








;---------------------------------RightHand--------------------------------
;--------------------------------------------F-Row
;--------------------------------------------Number-Row
;--------------------------------------------TopLetter-Row
~MButton & j:: gosub MoveMouseToCaret ; gosub PreviousTab
~MButton & l:: gosub Up
~MButton & u:: gosub Right
; b
~MButton & sc019:: gosub Home ; sc019 = ö
~MButton & sc01A:: gosub End ; sc01A = ü
; +

;--------------------------------------------Home-Row
~MButton & h:: gosub Left
~MButton & n:: gosub Down
; e
; i
~MButton & o:: gosub TabSearch
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #

;--------------------------------------------LowerLetter-Row
~MButton & x:: gosub AltTab
~MButton & k:: gosub TabLeft
~MButton & m:: gosub TabRight
~MButton & ,:: gosub DesktopLeft
~MButton & .:: gosub DesktopRight
~MButton & sc035:: gosub WinView ; sc035 = -

;--------------------------------------------MISC
$*MButton Up:: gosub AltTabRelease






; ---------------------------------Functions--------------------------------
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


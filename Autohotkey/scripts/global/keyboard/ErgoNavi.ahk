/*
    @Title: ErgoNavi
    @Desc: bring all frequently used commands together for better ergonomic navigation
        commands are mirrored on left and right hands; here with modifiers MButton and RButton.
    @ModifierKeys: MButton, RButton
    @Maturity:6
*/
ErgoNavi_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime
    #Include %A_WorkingDir%\lib\Commands.ahk
    #Include %A_WorkingDir%\lib\Functions.ahk
    return



;--------------------------------------------F-Row

;--------------------------------------------Number-Row
~MButton & 0::
~RButton & 3:: SendInput %GOBACK_sc%

~MButton & 9::
~RButton & 4:: SendInput %GOFORWARD_sc%

;--------------------------------------------TopLetter-Row
~MButton & sc01B:: gosub MoveWinBetweenScreens

~MButton & sc01A:: LongPressCommand("sc01A", ADDRESSBAR_sc, SEARCH_sc) ; sc01A = ü
~RButton & w:: LongPressCommand("w", ADDRESSBAR_sc, SEARCH_sc)

~MButton & sc019:: Tooltip vacant ; sc019 = ö
~RButton & q:: Tooltip vacant

~MButton & u:: LongPressCommand("u", LEFTTAB_sc, "^1")
~RButton & f:: LongPressCommand("f", LEFTTAB_sc, "^1") ; SendInput %LEFTTAB_sc% #try: go to first/last tab on long press

~MButton & b:: LongPressCommand("b", RIGHTTAB_sc, "^9")
~RButton & a:: LongPressCommand("a", RIGHTTAB_sc, "^9") ; SendInput %RIGHTTAB_sc%

;--------------------------------------------Home-Row
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

~MButton & o::
~RButton & p:: SendInput %TABSEARCH_sc%

~MButton & i::
~RButton & r:: SendInput %LATERTAB_sc%

~MButton & e::
~RButton & s:: SendInput %PREVIOUSTAB_sc%

~MButton & n::
~RButton & t:: gosub AltTab

~MButton & h:: LongPressCommand("h", CLOSETAB_sc, CLOSEWINDOW_sc)
~RButton & d:: LongPressCommand("d", CLOSETAB_sc, CLOSEWINDOW_sc)

;--------------------------------------------LowLetter-Row
~MButton & sc035:: Tooltip vacant

~MButton & .::
~RButton & z:: SendInput %WINVIEW_sc%

~MButton & m::
~RButton & y:: SendInput %LEFTDESKTOP_sc%

~MButton & ,::
~RButton & c:: SendInput %RIGHTDESKTOP_sc%

~MButton & k:: OpenTabWOSelection("k")
~RButton & v:: OpenTabWOSelection("v")

~MButton & x::
~RButton & x:: LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)

;--------------------------------------------MISC
; $*RButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge
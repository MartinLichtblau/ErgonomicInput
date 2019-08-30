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
    ;Process,priority,,High
    #Include %A_WorkingDir%\lib\Commands.ahk
    #Include %A_WorkingDir%\lib\Functions.ahk
    return



;--------------------------------------------F-Row

;--------------------------------------------Number-Row
~MButton & 8::
~RButton & 3:: SendInput %LEFTDESKTOP_sc%

~MButton & 9::
~RButton & 4:: SendInput %RIGHTDESKTOP_sc%

~MButton & 7::
~RButton & 5:: SendInput %WINVIEW_sc%

;--------------------------------------------TopLetter-Row
~MButton & sc01B:: MoveWinBetweenScreens("sc01B") ; sc01B = +

;~MButton & sc01A:: LongPressCommand("sc01A", ADDRESSBAR_sc, SEARCH_sc) ; sc01A = ü
~MButton & sc019:: LongPressCommand("sc019", ADDRESSBAR_sc, SEARCH_sc) ; sc019 = ö
~RButton & g::
~RButton & w::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 7
    return

~RButton & q:: Gosub gotoKeep

~MButton & b::
~RButton & f::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 9
    return

~MButton & u::
~RButton & a::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 8
    return

;~RButton & g:: OpenTabWOSelection("g") ; LongPressCommand("g", "^t", "^n")
~MButton & j:: OpenTabWOSelection("j") ; LongPressCommand("j", "^t", "^n")

~MButton & l:: Enter

;--------------------------------------------Home-Row
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

~MButton & o:: LongPressCommand("o", ADDRESSBAR_sc, SEARCH_sc)
~RButton & p:: LongPressCommand("p", ADDRESSBAR_sc, SEARCH_sc)

~MButton & i:: LongPressCommand("i", ADDRESSBAR_sc, SEARCH_sc)
~RButton & r:: LongPressCommand("r", ADDRESSBAR_sc, SEARCH_sc)

~MButton & n::Del
    ;AHI.SendKeyEvent(kbdId, deleteSc, 1)
    ;AHI.SendKeyEvent(kbdId, deleteSc, 0)
    return
    ; SendInput %LEFTTAB_sc% ;LongPressCommand("n", LEFTTAB_sc, "^1")
~RButton & s:: SendInput %LEFTTAB_sc% ;LongPressCommand("s", LEFTTAB_sc, "^1")

~MButton & e::Tab

    ; SendInput %RIGHTTAB_sc% ;LongPressCommand("e", RIGHTTAB_sc, "^9")
~RButton & t:: SendInput %RIGHTTAB_sc% ;LongPressCommand("t", RIGHTTAB_sc, "^9")

~MButton & h::
    AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    ;SendInput {Backspace}
    return
    ; nLongPressCommand("h", CLOSETAB_sc, CLOSEWINDOW_sc)
~RButton & d:: LongPressCommand("d", CLOSETAB_sc, CLOSEWINDOW_sc)

;--------------------------------------------LowLetter-Row
~MButton & sc035:: Tooltip vacant

~MButton & sc034:: ; sc034 = .
~RButton & z::

~MButton & sc033:: ; sc033 = ,
~RButton & y:: SendInput %GOFORWARD_sc%

~MButton & m::
~RButton & c:: SendInput %GOBACK_sc%

~MButton & k::
    AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    ;SendInput {Backspace}
    return
~RButton & v:: gosub AltTab

~MButton & x::t
~RButton & x:: LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)

;--------------------------------------------MISC
; $*RButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge

gotoKeep:
    SendInput %TABSEARCH_sc%
    Sleep 300
    SendInput Calendar
    Sleep 100
    SendInput {Enter}
    Sleep 300
    SendInput %LEFTTAB_sc%
    Sleep 200
    SendInput ^l
    Sleep 200
    SendRaw https://keep.google.com/#search  ;https://keep.google.com/{#}home
    Sleep 100
    SendInput {Enter}
    return
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
~MButton & 0::
~RButton & 3:: SendInput %GOBACK_sc%

~MButton & 9::
~RButton & 4:: SendInput %GOFORWARD_sc%

;--------------------------------------------TopLetter-Row
~MButton & sc01B:: MoveWinBetweenScreens("sc01B") ; sc01B = +

;~MButton & sc01A:: LongPressCommand("sc01A", ADDRESSBAR_sc, SEARCH_sc) ; sc01A = ü
~MButton & sc019:: LongPressCommand("sc019", ADDRESSBAR_sc, SEARCH_sc) ; sc019 = ö
~RButton & w:: LongPressCommand("w", ADDRESSBAR_sc, SEARCH_sc)

~RButton & q:: Gosub gotoKeep

~MButton & u:: LongPressCommand("u", LEFTTAB_sc, "^1")
~RButton & f:: LongPressCommand("f", LEFTTAB_sc, "^1") ; SendInput %LEFTTAB_sc% #try: go to first/last tab on long press

~MButton & b:: LongPressCommand("b", RIGHTTAB_sc, "^9")
~RButton & a:: LongPressCommand("a", RIGHTTAB_sc, "^9") ; SendInput %RIGHTTAB_sc%

~RButton & g:: OpenTabWOSelection("g") ; LongPressCommand("g", "^t", "^n")
~MButton & j:: OpenTabWOSelection("j") ; LongPressCommand("j", "^t", "^n")

~MButton & l:: Enter

;--------------------------------------------Home-Row
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

~MButton & o::
~RButton & p::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 7
    return

~MButton & i::
~RButton & r::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    Hotkey, RButton up, test
    SendInput 7
    return

~MButton & e::
~RButton & s::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 9
    return

; #MaxThreadsPerHotkey 2 ; this kills lots of code
~MButton & n::
~RButton & t::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    ;Hotkey, RButton up, test,
    SendInput 8
    ;if (!alreadyHooked)
      ;  gosub releaseHook
    return

global alreadyHooked := false @TODO find a way to make this fine
releaseHook:
    alreadyHooked := true
    KeyWait, RButton,
    SendInput {LAlt up}
    alreadyHooked := false
    return
test:
    tooltip test
    ;gosub AltTabRelease
    SendInput {LAlt up}
    ;Hotkey, RButton up, Off
    return

~MButton & h:: LongPressCommand("h", CLOSETAB_sc, CLOSEWINDOW_sc)
~RButton & d:: LongPressCommand("d", CLOSETAB_sc, CLOSEWINDOW_sc)

;--------------------------------------------LowLetter-Row
~MButton & sc035:: Tooltip vacant

~MButton & sc034:: ; sc034 = .
~RButton & z:: SendInput %WINVIEW_sc%

~MButton & m::
~RButton & y:: SendInput %LEFTDESKTOP_sc%

~MButton & sc033:: ; sc033 = ,
~RButton & c:: SendInput %RIGHTDESKTOP_sc%

~MButton & k::
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
    Send https://keep.google.com/{#}home
    Sleep 100
    SendInput {Enter}
    return
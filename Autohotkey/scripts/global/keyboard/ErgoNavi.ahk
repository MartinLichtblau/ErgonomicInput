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
~RButton & w::

~RButton & q::
    Gosub gotoKeep
    return

~MButton & u::
    SendInput {Esc}
    return

~MButton & b::
~RButton & f::
~RButton & a::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 9
    return

~RButton & g::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 7
    return
    ; OpenTabWOSelection("g") ; LongPressCommand("g", "^t", "^n")
~MButton & j:: OpenTabWOSelection("j") ; LongPressCommand("j", "^t", "^n")

~MButton & l:: Enter ; AHI doesn't make windows UAC work

;--------------------------------------------Home-Row
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

~MButton & o::
~RButton & p::
    LongPressCommand("p", ADDRESSBAR_sc, SEARCH_sc)
    return

~MButton & i::
~RButton & r::
    SendInput %GOFORWARD_sc%
    return

~MButton & n::
    AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 1)
    AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 0)
    return
    ; SendInput %LEFTTAB_sc% ;LongPressCommand("n", LEFTTAB_sc, "^1")
~RButton & s::
  SendInput %GOBACK_sc%
  return

~MButton & e::
    SendInput {RShift down}{Tab}{RShift up}
    /*
    AHI.SendKeyEvent(kbdId, GetKeySC("LShift"), 1)
        AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 1)
        AHI.SendKeyEvent(kbdId, GetKeySC("Tab"), 0)
        AHI.SendKeyEvent(kbdId, GetKeySC("LShift"), 0)
    */
    ; SendInput %RIGHTTAB_sc% ;LongPressCommand("e", RIGHTTAB_sc, "^9")
    return

~RButton & t:: SendInput %LEFTTAB_sc% ;LongPressCommand("s", LEFTTAB_sc, "^1")

~MButton & h::
    AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    ;SendInput {Backspace}
    return
    ; nLongPressCommand("h", CLOSETAB_sc, CLOSEWINDOW_sc)
~RButton & d::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 8
    return
        ; LongPressCommand("d", CLOSETAB_sc, CLOSEWINDOW_sc)

;--------------------------------------------LowLetter-Row
~MButton & sc035:: Tooltip vacant

~MButton & sc034:: ; sc034 = .
~RButton & z::
    SendInput %GOFORWARD_sc%
    return

~MButton & sc033:: ; sc033 = ,
~RButton & y::
    SendInput %GOBACK_sc%
    return

~MButton & m::
~RButton & c::
    gosub AltTab
    return

~MButton & k::
    AHI.SendKeyEvent(kbdId, GetKeySC("Delete"), 1)
    AHI.SendKeyEvent(kbdId, GetKeySC("Delete"), 0)
    ;SendInput {Delete}
    return
~RButton & v:: SendInput %RIGHTTAB_sc% ;LongPressCommand("t", RIGHTTAB_sc, "^9")

~MButton & x::
~RButton & x::
    LongPressCommand("x", CLOSETAB_sc, CLOSEWINDOW_sc) ; LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)
    return

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
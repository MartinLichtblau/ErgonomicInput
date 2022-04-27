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

;--------------------------------------------RIGHT HAND
#if trackpadMButtonDown
$*MButton:: return

;--------------------SPECIAL KEYS
~MButton & n::
~MButton & l:: Enter

~MButton & k:: Delete

~MButton & h:: Backspace

~MButton & x::Esc

~MButton & u::Tab

~MButton & b::
  SendInput {RShift down}{Tab}{RShift up}
  return

;--------------------ARROW KEYS
~MButton & e:: SendArrowKey("Up")

~MButton & sc033:: ; sc033 = ,
  SendArrowKey("Down")
  return

~MButton & m::
  SendArrowKey("Left")
  return

~MButton & i::
  SendArrowKey("Right")
  return

~MButton & sc034:: Home ; sc034 == .

~MButton & sc035:: End ; sc035 == -

;--------------------MOVE WINDOWS
~MButton & sc01B:: MoveWinBetweenScreens("sc01B") ; sc01B = +

~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #

~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

;--------------------MISC
;~MButton & sc01A:: LongPressCommand("sc01A", ADDRESSBAR_sc, SEARCH_sc) ; sc01A = ü

~MButton & sc019:: LongPressCommand("sc019", ADDRESSBAR_sc, SEARCH_sc) ; sc019 = ö

~MButton & j:: OpenTabWOSelection("j") ; LongPressCommand("j", "^t", "^n")

#if

;--------------------------------------------LEFT HAND
#if trackpadRButtonDown
$*RButton:: return

RButton & 3:: Send %LEFTDESKTOP_sc%

RButton & 4:: Send %RIGHTDESKTOP_sc%

~RButton & 5:: SendInput %WINVIEW_sc%

~RButton & w::
    LongPressCommand("w", CLOSETAB_sc, CLOSEWINDOW_sc) ; LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)
    return

~RButton & q::
    return

~RButton & f::
    LongPressCommand("f", REOPENCLOSEDTAB_sc, RELOAD_sc)
    return

~RButton & a::
    SendInput %LEFTTAB_sc% ;LongPressCommand("s", LEFTTAB_sc, "^1")
    return

~RButton & g::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 7
    return
    ; OpenTabWOSelection("g") ; LongPressCommand("g", "^t", "^n")

~RButton & p::
    LongPressCommand("p", ADDRESSBAR_sc, SEARCH_sc)
    return

~RButton & r::
    SendInput %GOFORWARD_sc%
    return

~RButton & s::
  SendInput %GOBACK_sc%
  return

~RButton & t::
    SendInput %RIGHTTAB_sc% ;LongPressCommand("t", RIGHTTAB_sc, "^9")
    return

~RButton & d::
    if (!GetKeyState("LAlt")) {
            SendInput {LAlt down}
        }
        SendInput 8
        return

~RButton & z::
    SendInput %GOFORWARD_sc%
    return

~RButton & y::
    SendInput %GOBACK_sc%
    return

~RButton & c::
    gosub AltTab
    return

~RButton & v::
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 9
    return

~RButton & x::Esc

~RButton & Space::
    gosub AltTab
    return

#if

~ Ctrl & w::
   LongPressCommand("w", CLOSETAB_sc, CLOSEWINDOW_sc)
   return

;--------------------------------------------MISC
; $*RButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge

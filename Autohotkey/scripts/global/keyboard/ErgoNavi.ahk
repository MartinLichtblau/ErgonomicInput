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
    #Include %A_ScriptDir%\lib\Commands.ahk
    #Include %A_ScriptDir%\lib\Functions.ahk
    return

;--------------------------------------------RIGHT HAND
#if trackpadMButtonDown
$*MButton:: return

;--------------------SPECIAL KEYS
*l:: Enter
*Space:: Enter

*h:: Backspace

*x:: Delete

*u::Tab

*b::
  SendInput {RShift down}{Tab}{RShift up}
  return

;--------------------ARROW KEYS
*n:: SendArrowKey("Up")
*k:: SendArrowKey("Left")
*e:: SendArrowKey("Right")
*m:: SendArrowKey("Down")

*i:: Home
*o:: End

sc033::SendInput {Enter} ; sc033 = ,

sc034::SendInput #. ; sc034 == .

sc035:: return ; sc035 == -

;--------------------MOVE WINDOWS
sc01B:: MoveWinBetweenScreens("sc01B") ; sc01B = +

sc02B:: WinOrganizeRight("sc02B") ; sc02B = #

sc028:: WinOrganizeLeft("sc028") ; sc028 = ä

;--------------------MISC
sc01A:: LongPressCommand("sc01A", ADDRESSBAR_sc, SEARCH_sc) ; sc01A = ü

sc019:: LongPressCommand("sc019", "{AppsKey}", SEARCH_sc) ; sc019 = ö

j:: OpenTabWOSelection("j") ; LongPressCommand("j", "^t", "^n")


; Shift::SendInput {Enter}

#if

;--------------------------------------------LEFT HAND
#if trackpadRButtonDown

3::
    SendInput %LEFTDESKTOP_sc%
    ;Keywait, 3
    return

    /**
    if (!GetKeyState("LCtrl") && !GetKeyState("LWin")) {
       Tooltip here
       Send {LCtrl Down}{LWin Down}
    }
    SendInput {Left}
    return
    */

4::
    SendInput %RIGHTDESKTOP_sc%
    ;Keywait, 4
    return

5:: SendInput %WINVIEW_sc%

w::
    LongPressCommand("w", CLOSETAB_sc, CLOSEWINDOW_sc) ; LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)
    return

q::return


f::
    LongPressCommand("f", REOPENCLOSEDTAB_sc, RELOAD_sc)
    return

a::
    if WinActive("ahk_exe explorer.exe") {  
        SendInput ^+{Tab}
    } else {
        SendInput %LEFTTAB_sc% ;LongPressCommand("s", LEFTTAB_sc, "^1")
    } 
    return

g::
    MoveCursorToLeft()
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 7
    return
    ; OpenTabWOSelection("g") ; LongPressCommand("g", "^t", "^n")

p::
    goto SearchBookmarks
    return

r::
    if (!GetKeyState("LCtrl")) {
      SendInput {LCtrl down}
    }
    SendInput {Tab}
    return
    SendInput ^+r
    return

s::
    SendInput ^l ; !d ; or ^l ;+^s ;(Vivaldi Quick Search)
    return

t::
    if WinActive("ahk_exe explorer.exe") {  
        SendInput ^{Tab}
    } else {
        SendInput %RIGHTTAB_sc% ;LongPressCommand("t", RIGHTTAB_sc, "^9")
    } 
    return

d::
    ; MoveCursorToLeft()
    if (!GetKeyState("LAlt")) {
        SendInput {LAlt down}
    }
    SendInput 9
    return


z::
    SendInput %GOFORWARD_sc% ;!{Right} ; Browser_Forward ;%GOFORWARD_sc%
    return

y::
    SendInput %GOBACK_sc% ;!{Left} ; %Browser_Back% %GOBACK_sc%
    return

c::
    MoveCursorToLeft()
    gosub AltTab
    return

v::
    MoveCursorToLeft()
    if (!GetKeyState("LAlt")) {
            SendInput {LAlt down}
        }
        SendInput 8
        return

x::Esc

Space::
    gosub AltTab
    return

#if

~Ctrl & w::
   LongPressCommand("w", CLOSETAB_sc, CLOSEWINDOW_sc)
   return

;--------------------------------------------MISC
; $*RButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge

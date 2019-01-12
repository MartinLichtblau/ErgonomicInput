/*
    @Title: ErgoNavi
    @Desc: bring all frequently used commands together for better ergonomic navigation
*/
#SingleInstance force
#Persistent
Process,priority,,Realtime
#Include %A_ScriptDir%\Commands.ahk
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
    $<^<+w:: gosub PreviousTab
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
    <^<+t:: gosub AltTab
    ~RButton & d::LongPressCommand("d", "^w", "!{F4}")

;--------------------------------------------LowerLetter-Row
    ~RButton & c::LongPressCommand("c", "^w", "!{F4}")
    ~RButton & v::LongPressCommand("v", "^t", "+^t") ; perhaps extend with OpenNewTabWithSelection()
    ~RButton & x::LongPressCommand("x", "^n", "+^n")
    ; @TODO reload also used often

;--------------------------------------------MISC
    ; $*RButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge
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
~MButton & sc01B:: gosub MoveAWinBetweenScreens


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
; $*MButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge







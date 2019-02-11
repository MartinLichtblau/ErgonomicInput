/*
    @Title: ErgoNavi
    @Desc: bring all frequently used commands together for better ergonomic navigation
    @ModifierKeys: MButton, RButton, Ctrl+Shift
    @Maturity:6
*/
ErgoNavi_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime
    #Include %A_WorkingDir%\lib\Commands.ahk
    #Include %A_WorkingDir%\lib\Functions.ahk
    return


;---------------------------------LeftHand--------------------------------
;--------------------------------------------F-Row
;--------------------------------------------Number-Row
    ~RButton & 3::Browser_Back
    ~RButton & 4::Browser_Forward

;--------------------------------------------TopLetter-Row
    ~RButton & w:: gosub TabSearch
    ~RButton & q::
    ~RButton & f:: gosub TabBackward
    ~RButton & a:: gosub TabBackward
    ~RButton & g:: gosub TabForward

;--------------------------------------------Home-Row
    ~RButton & p::LongPressCommand("p", "^l", "^f")
    ~RButton & r:: gosub TabLeft
    ~RButton & s:: gosub TabRight
    ~RButton & t:: gosub AltTab
    ~RButton & d::LongPressCommand("d", "^w", "!{F4}")

;--------------------------------------------LowLetter-Row
    ~RButton & z:: gosub WinView
    ~RButton & y:: gosub DesktopLeft
    ~RButton & c:: gosub DesktopRight
    ~RButton & v::OpenTabWOSelection("v")
    ~RButton & x::LongPressCommand("x", "^+t", "^r")

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
~MButton & sc01B:: gosub MoveWinBetweenScreens


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







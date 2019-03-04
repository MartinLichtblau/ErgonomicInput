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
    ~RButton & 3::SendInput %GOBACK_sc%
    ~RButton & 4::SendInput %GOFORWARD_sc%

;--------------------------------------------TopLetter-Row
    ~RButton & w::LongPressCommand("w", ADDRESSBAR_sc, SEARCH_sc)
    ; q
    ~RButton & f::SendInput %LEFTTAB_sc%
    ~RButton & a::SendInput %RIGHTTAB_sc%

;--------------------------------------------Home-Row
    ~RButton & p::SendInput %TABSEARCH_sc%
    ~RButton & r::SendInput %LATERTAB_sc%
    ~RButton & s::SendInput %PREVIOUSTAB_sc%
    ~RButton & t:: gosub AltTab
    ~RButton & d::LongPressCommand("d", CLOSETAB_sc, CLOSEWINDOW_sc)

;--------------------------------------------LowLetter-Row
    ~RButton & z::SendInput %WINVIEW_sc%
    ~RButton & y::SendInput %LEFTDESKTOP_sc%
    ~RButton & c::SendInput %RIGHTDESKTOP_sc%
    ~RButton & v::OpenTabWOSelection("v")
    ~RButton & x::LongPressCommand("x", REOPENCLOSEDTAB_sc, RELOAD_sc)

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
~MButton & o::
~MButton & sc028:: WinOrganizeLeft("sc028") ; sc028 = ä
~MButton & sc02B:: WinOrganizeRight("sc02B") ; sc02B = #

;--------------------------------------------LowerLetter-Row
~MButton & x:: gosub AltTab
~MButton & k::
~MButton & m::
~MButton & ,::
~MButton & .::
~MButton & sc035:: ; sc035 = -

;--------------------------------------------MISC
; $*MButton Up:: gosub AltTabRelease ; @TODO in conflict with @Trackpad MButton hotkeys. #open.merge







/*
    @Title: ErgoNavi
    @Desc: bring all frequently used commands together for better ergonomic navigation
*/
Process, priority,, Realtime


/*
    @Title: TabLeft
    @Desc: switch one tab left
*/
~RButton & f::
~LButton & k::
<^<+f::
	Send ^{PgUp}
	;SendInput +^{Tab}
Return
/*
    @Title: TabRight
    @Desc: switch one tab right
*/
~RButton & p::
~LButton & m::
<^<+p::
	Send ^{PgDn}
	;SendInput ^{Tab}
Return


/*
    @Title: TabSearch
    @Desc: Opening Chrome extension for searching tabs, history and bookmarks
*/
; ~RButton & 1::
; ^+1::
; ~RButton & 2::
; ^+2::
; ~LButton & 0::
; ~LButton & sc00c:: ;sc00c = ß
; ~LButton & sc00d:: ;sc00d = ´
; ~LButton & sc019:: ;sc019 = ö
~LButton & o::
~RButton & w::
	Send ^+w
return
/*
    @Title: TabPrevious
    @Desc: Jumping back to last visited tab
*/
; ~LButton & x::
; ~LButton & j::
; ~RButton & c::
~LButton & j::
~RButton & q::
^+q::
	Send !z ; #note can' t set ^+q in chrome as extension shortcut, hence it's mapped on x
return


/*
    @Title: BrowserBack
    @Desc: jump backward in history
*/
;~RButton & z::
~RButton & 3::
~LButton & i::
<^<+3::
    Send !{Left}
return
/*
    @Title: BrowserForward
    @Desc: jump forward in history
*/
;~RButton & y::
~RButton & 4::
~LButton & e::
<^<+4::
    Send !{Right}
return


/*
    @Title: DesktopLeft
    @Desc: switch one desktop to the left
*/
~RButton & r::
~LButton & ,::
<^<+r::
	Send {LCtrl Down}{LWin Down}{Left}{LWin Up}{LCtrl Up}
return
/*
    @Title: DesktopRight
    @Desc: switch one desktop to the right
*/
~RButton & s::
~LButton & .::
<^<+s::
	Send {LCtrl Down}{LWin Down}{Right}{LWin Up}{LCtrl Up}
return


/*
    @Title: WinView
    @Desc: Opening overview showing all desktop and open windows
*/
~RButton & a::
~LButton & sc035:: ; sc035 = -
<^<+a::
	Send #{Tab}
return


/*
    @Title: AltTab
    @Desc: switch to previously focused window
    @note: integrated AltTab function only works without ~, hence without letting the modifier pass through.
*/
~LButton & x::
~RButton & t::
<+<^t::
	if WinExist("Task Switching") { ; in german if WinExist("Programmumschaltung")
			;Tooltip "just tab"
			SendInput {Tab}
	} else {
		;Tooltip "Open menu"
		SendInput {Alt Down}{Tab}
	}
return
~LShift & ~LCtrl Up::
~LCtrl & ~LShift Up::
	if WinExist("Task Switching")
		SendInput {Alt Up}	
	;else 
	;	SendInput {Esc}
return


/*
;------F123-RowF ;Deactivate Windows Snap suggestion for that to work satisfying
<^F1::  
	KeyWait, F1, T0.3                        
	If ErrorLevel {  
		WinMaximize, A   
		;SendInput {LWin Down}{Down}{LWin Up}
	}Else
		SendInput {LWin Down}{Left}{LWin Up}
	KeyWait, F1,
Return

<^F2:: 	
	KeyWait, F2, T0.3                          
	If ErrorLevel {  
		WinMaximize, A
		;SendInput {LWin Down}{Up}{LWin Up}
	}Elsen
		SendInput {LWin Down}{Right}{LWin Up}
	KeyWait, F2, 
Return

;--------------------------------------------12345-Row     
;Moves windows with arrow up and down around on the screen
WinUpDown(key)
{
	if (key = "2" or key = "SC00B")
	{
		SendInput {LWin Down}{Up}{LWin Up}
	}
	else if (key = "1" or key = "SC00C")
	{
		SendInput {LWin Down}{Down}{LWin Up}
	}
Return	
}

<^sc029:: 
<^SC00D:: ;"´"
	SendInput {LWin Down}{Shift Down}{Left}{Shift Up}{LWin  Up}
	Sleep 30
	WinMaximize, A
Return

<^1::
<^SC00B:: ;"0"
	key := SubStr(A_ThisHotkey, 3)
	KeyWait, %key%, T0.3
	If ErrorLevel {  
		WinUpDown(key)
	}Else
		SendInput {LWin Down}{Left}{LWin Up}
	KeyWait, %key%, 
Return

<^2::
<^SC00C:: ;"ß"
	key := SubStr(A_ThisHotkey, 3)
	;MsgBox %key%
	KeyWait, %key%, T0.3               
	If ErrorLevel {  
		WinUpDown(key)
	}Else
		SendInput {LWin Down}{Right}{LWin Up}
	KeyWait,%key%, 
Return

<^3:: 
<^9::
	SendInput !{Left}
Return

<^4::
<^8:: 
	SendInput !{Right}            
Return
;Space & 5:: 6  7 ...............

;------------------------------------------QWERT-Row
$^q::
;$^p::
	;MsgBox %A_ThisHotkey%
	key := SubStr(A_ThisHotkey, 3)
	KeyWait, %key%, T0.4                         	
	If ErrorLevel			
		SendInput ^n
	Else
		SendInput ^r
	KeyWait,q
Return

$<^w:: 
$<^i::
	SendInput ^+{tab} ;alternative SendInput ^{PgUp}
	KeyWait,w
Return

^o::
^e::
	SendInput ^{tab} ;^{tab} ;alternative SendInput ^{PgDn}
	KeyWait,e
Return

 

$<^r::
$<^u::
	key := SubStr(A_ThisHotkey, 9) ;e.g. A_ThisHotkey is "Space & r" 
	;MsgBox %key%
	KeyWait, %key%, T0.4                        



	If ErrorLevel
		SendInput !{F4}
	Else        
		SendInput ^w
	KeyWait,%key%
Return

<^t::
	KeyWait, t, T0.3
	If ErrorLevel   								
		Send,^+t
	else
		Send,^t
	loop{	
	Sleep,50
	if !GetKeyState("<^", "P")
		break
	}
Return


;------ASDFG-Row
;Space & a:: SendInput ^a  

 

<^g::
<^h::
	Send {LWin Down}{Tab Down}
	Send {Tab Up}{LWin Up}
Return


*/
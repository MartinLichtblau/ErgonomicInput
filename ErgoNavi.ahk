Process, priority,, Realtime

;in chrome searching tabs with <^<!w
/*
~RButton Up::
	If (A_TimeSincePriorHotkey <= 200) {
		Click,,right
	}
	; if WinExist("Task Switching") {
		; SendInput {Alt Up}
	; }
return

~RButton::
	Keywait,~RButton,T0.20  ;Safety feature, so that space doesn't fire by mistake
	IF (!ErrorLevel && A_PriorKey = "~RButton") {
		Click,,right
	}
return
~RButton up::
	if WinExist("Task Switching") {
		SendInput {Alt Up}
	}
return


RButton::
	;Tooltip down1 %ErrorLevel%
	Input, SingleKey, T0.3 V B L1, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
	; can add T0.3 to only let fast clicks through and laggard ones not
	;Tooltip down2 %ErrorLevel%
	;KeyWait RButton
return
RButton up::
	Input
	;whenever Input command is used without params, the ErrorLevel will be just 0 or 1
	; depending if another Input was running already
	if (ErrorLevel == 0) {
		Click,,right
		;SendInput {RButton}
	}
	;Tooltip up %ErrorLevel%
	
	;just so that Wintab works
	if WinExist("Task Switching") {
		SendInput {Alt Up}
	}
return
*/

; #note: I can't make it work like LButton. The left hardware trackpad button seems to be the problem. I tried everything!
$*RButton::
	KeyWait, RButton, T0.2
	if (!ErrorLevel && A_PriorHotkey == "$*RButton") {
		Click,,right,,
	}
return
$*RButton Up::
	if WinExist("Task Switching") {
		SendInput {Alt Up}
	}
return


/*
Chrome extension searching tab and jumping back 
*/
;TabSearch
; ~RButton & 1::
; ^+1::
; ~RButton & 2::
; ^+2::
; ~LButton & 0::
; ~LButton & sc00c:: ;sc00c = ß
; ~LButton & sc00d:: ;sc00d = ´
; ~LButton & sc019:: ;sc019 = ö
~LButton & b::
~RButton & w::
	Send ^+w
return

;TabJumpBack
; ~LButton & x::
; ~LButton & j::
; ~RButton & c::
~LButton & sc019:: ;sc019 = ö
~RButton & q::
^+q::
	Send !z ; #note can' t set ^+q in chrome as extension shortcut, hence it's mapped on x
return

/*
Switching tabs: moving left or right
*/
;TabLeft
~RButton & f::
~LButton & l::
<^<+f::
	Send ^{PgUp}
	;SendInput +^{Tab}
Return

;TabRight
~RButton & p::
~LButton & u::
<^<+p::		
	Send ^{PgDn}
	;SendInput ^{Tab}
Return	


/*
*/
;WinView
~RButton & a::
~LButton & o:: ;sc028 = ä
<^<+a::
	Send #{Tab}
return


/*
Desktop navigation: moving to left or right desktop
*/
;DeskLeft
~RButton & r::
~LButton & e::
<^<+r::
	Send {LCtrl Down}{LWin Down}{Left}{LWin Up}{LCtrl Up}
return

~RButton & s::
~LButton & i::
<^<+s::
	Send {LCtrl Down}{LWin Down}{Right}{LWin Up}{LCtrl Up}
return


/*
Window navigation: change to previous one
*/
;MButton & x::AltTab ;AltTab only works with ~, hence without letting it pass through
~LButton & h::
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
Browser back and forward, thus moving back or forth
*/
;~RButton & z::
~RButton & 3::
~LButton & 9::
<^<+3::Browser_Back
return

;~RButton & y::
~RButton & 4::
~LButton & 8::
<^<+4::Browser_Forward
return
; in chrome <^<!c:: previous tab


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
	}Else
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
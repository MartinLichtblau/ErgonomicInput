Process, priority,, Realtime


~LButton & k::
AppsKey & x::
;RButton & x::
	Send {blind}{Left}
Return


~LButton & n::
AppsKey & h::
;RButton & h::
	Send {blind}{Up}
Return


~LButton & ,::
AppsKey & n::
;RButton & n::
	Send {blind}{Right}
Return


~LButton & m::
AppsKey & k::
;RButton & k::
	Send {blind}{Down}
Return

;sc019
~LButton & sc034:: ;sc034 = .
AppsKey & d::
~RButton & z::
<+<^z::
	Send {blind}{Home}
Return

;sc01A
~LButton & sc035:: ;sc035 = . 
AppsKey & v::
~RButton & sc056:: ; sc056 = <
<+<^sc056:: ; sc056 = <
	Send {blind}{End}
Return

/*
RButton::
	;MsgBox %A_PriorKey%
	;#task only fire if pressed < X sec, to reduce risk of false rclick.
	IF(A_PriorKey = ";RButton"){
		Send {;RButton}
	}
return   
*/
   


/*
;hide mouse cursor > https://autohotkey.com/docs/commands/DllCall.htm#HideCursor
;---------------------------------One Finger Alt Scroll---------------------------------------------------------
;Ref: https://autohotkey.com/board/topic/54263-touchpad-scrolling/

*;RButton::
	CoordMode, Mouse, Screen ; The fucking bug! that bugged my head!  
	MouseGetPos, oldX, oldY
	rClickOnExit:=true
	autofire=0 ;autofire is true if mouse moved X times in a row
	i=0 ;total loops, gets reset with j 
	mouseMovedFor=0 ;times it moved during those loops
  
	While GetKeyState(";RButton", "P")
	{
		;MsgBox %i%
		MouseGetPos, x, y
		MouseMove, oldX, oldY, 0
		i++
		
		movVer := Abs(x-oldX)
		movHor := Abs(y-oldY)
		
		IF( Max(movVer, movHor) > 2){ ;moved
			mouseMovedFor++
			rClickOnExit:=false
			
			IF(mouseMovedFor = 1){ 
				;Click once
				;ToolTip "Click once"
				
				IF (movHor > movVer){
					if (y > oldY){
						Send {blind}{DOWN down}{DOWN up}
					}else if (y < oldY){
						Send {blind}{UP down}{UP up}
					}
				}ELSE{
					if (x > oldX){
						Send {blind}{Right down}{Right up}
					}else if (x < oldX){
						Send {blind}{Left down}{Left up}
					}
				}
			}ELSE IF(mouseMovedFor > 15){ 
				;autofire
				;ToolTip "Autofire"
				
				IF (movHor > movVer){
					if (y > oldY){
						Send {blind}{DOWN}
					}else if (y < oldY){
						Send {blind}{UP}
					}
				}ELSE{
					if (x > oldX){
						Send {blind}{Right}
					}else if (x < oldX){
						Send {blind}{Left}
					}
				}
			}
		}ELSE{ ;didn't move
			i:=0
			mouseMovedFor:=-1
		}
		
		
		
		
	}
	IF(rClickOnExit)
		Send {;RButton}
		
return
*/






/*
Pseudo code 

I want: 
	- short push <2sec single click (force independent)
	- holding longer than 2sec = autofire (force dependent)
	- force dependent 

	monitor 
		if mouse strike continued 
			calc how many px it moved
			calc average: sum of all px of rounds / number rounds
		else
			calc how long strike lastest
			if mouse moved <2sec
				moved more than 
		single click
	moved >2secö
		autofire
	
*/


/*
; use a scroll lock key #If GetKeyState("<^", "P")
;Critical,On
;#bug behaves strangely in various situations, e.g. to move windows. #task find a better way to map wheel to arrow
;~WheelDown::ToolTip %A_EventInfo%
*WheelUp::
	Send {blind}{UP down}{UP up}
Return
*WheelDown::
	Send {blind}{Down down}{Down up}
Return
*WheelLeft::
	Send {blind}{Left down}{Left up}
Return
*WheelRight::
	Send {blind}{Right down}{Right up}
Return
*/

/* 
Variations 
Send {blind}{Left down}{Left up}
*/

;Critical,Off



;Navigate windows > AltTab https://autohotkey.com/docs/Hotkeys.htm#AltTabDetail
;Shift & Backspace::AltTabAndMenu 

/*

;LButton::Enter

;^WheelDown::Return
;^WheelUp::Return
!WheelLeft::Send ^{Left}
!WheelRight::Send ^{Right}
!+WheelLeft::Send ^+{Left}
!+WheelRight::Send ^+{Right}

;SC163 is FN key
SC163::END

^WheelDown::Return
^WheelUP::Return
^Right::Send ^{RIGHT}
^Left::Send ^{Left}
*/

;h & b::Enter
;h & b::Enter
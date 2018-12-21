

ESC::ESC

F1::Volume_Mute
ESC & F1::
	SendInput {F1}
Return


F2::Volume_Down
ESC & F2::
	SendInput {F2}
Return


F3::Volume_Up
ESC & F3::
	SendInput {Volume_Up}
Return

F4::F2


F9::Media_Prev
ESC & F9::
	SendInput {F9}
Return

F10::Media_Play_Pause
ESC & F10::
	SendInput {F10}
Return

F11::Media_Next
ESC & F11::
	SendInput {F11}
Return


F12::^+l ; like button: e.g. to like a song
ESC & F13::
	SendInput {F12}
Return


/* Alternative method with long press. But that wouldn't work well with volume up/down. 
$F1::
	KeyWait,F1,T0.33                        
	If ErrorLevel
		SendInput {F1}
	Else        
		SendInput {Volume_Mute}
	KeyWait,F1,L
Return
*/
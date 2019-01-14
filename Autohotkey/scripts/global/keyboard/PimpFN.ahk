/*
    @Title: PimpFN
    @Desc: personalizing F-keys functions by combining some of the default ones and some of FN modified
    @Requirements: set F-Keys to default F1-12, not special computer dependent functions
*/


/*
    @Desc: Use Esc-key for toggling F-key behavior instead of FN-key, because it's better reachable together with F-keys
*/
ESC up::
    SendInput {Esc}
return


;------------------------------------- F1 - F4 -----------------------------
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
	SendInput {F3}
Return


F4::F2


;------------------------------------- F5 - F8 -----------------------------
; F5 = F5

F7::
    run %A_ScriptDir%/lib/AutoHotInterception/Monitor.ahk
return

F8:: gosub toggleReadMode



;------------------------------------- F9 - F12 -----------------------------
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


;------------------------------------- Functions -----------------------------
/* #Alternative method with long press like in @AltGrify
    But that wouldn't work well with volume up/down.
$F1::
	KeyWait,F1,T0.33                        
	If ErrorLevel
		SendInput {F1}
	Else        
		SendInput {Volume_Mute}
	KeyWait,F1,L
Return
*/


/*
    @TODO
*/
toggleReadMode:
    Send !h ; activate tool for text markup/annotation/highlighting
    Send !r ; color for reading #
    Send {F11}
return
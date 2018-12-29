/*
    @Title: Thinkpad
    @Desc: adapt Thinkpads default behavior
*/
Process, priority,, Realtime


{ ; PrtSc::AppsKey
/**
Makes Print screen behave like AppsKey
*/

; done through registry with SharpKeys
}


{ ; Insert::Del
/**
Only temporalily Insert is Del, since it got no use 
*/

; done through registry with SharpKeys
}


{ ; TrackpadMiddleClickScroll
/**
Use Trackpad for scrolling and also have MiddlButton with Middlclick ability
*/

; 1. set in windows 
; 2. use TpMiddle.exe v0.6

$MButton::
/**

	;SendInput {MButton down}
	MouseClick, middle,,, 1, 0, D
	Input,var, V L1 M,{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause},
	If ErrorLevel
	{
		MouseClick, middle,,, 1, 0, U
		MsgBox, MButton released
	}
	;Keywait,LButton,D
	;MsgBox "trts"
	;MsgBox % var
	;SendInput {MButton up}
return

~LButton::
~RButton:: 
	Input,,T0.1,,
	;MouseClick, middle,,, 1, 0, U
return


$MButton::	
	If GetKeyState("MButton","D"){
		;MsgBox "down"
		SendInput {MButton up}
	}
	else{
		;MsgBox "up"
		SendInput {MButton down}
	}
return
*/		
	
/**
^+m::
	SendInput, {ScrollLock down}	
Return

^+::
	SendInput, {ScrollLock up}	
Return
*/
	
/**
#MaxThreadsPerHotkey 2
$MButton::	
	If GetKeyState("MButton","D"){
		;MsgBox "down"
		Input,,T0.1,,
		SendInput {MButton up}
	}
	else{
		;MsgBox "up"
		SendInput {MButton down}
		Tooltip,MButton,,,
		
		Input,var, L1 M,{ESC}{Tab}{RButton}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause},
		If ErrorLevel
		{
			SendInput {MButton up}
			Tooltip,,,,
			;MsgBox, MButton released
		}
	}
return
#MaxThreadsPerHotkey 1

~LButton::
~RButton:: 
	Input,,T0.1,,
	;MouseClick, middle,,, 1, 0, U
return
*/

/*
; Only for test purposes: to simulate middleClicks.
SetKeyDelay, -1, -1, -1
SetMouseDelay, -1
^+3::
	;SendInput {MButton up}
	Tooltip 2sec to MiddleClick
	Sleep 2000
	Tooltip,,,,
	SendInput {MButton down}{MButton up}
return


}
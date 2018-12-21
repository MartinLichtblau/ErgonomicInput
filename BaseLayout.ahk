Process, priority,, Realtime

/**
Fundamental keyboard layout changes; e.g. language, space, backspace, ...
*/

/*
1. My Keyboard Layout based on COLEMAK
*/

/**
@Title: ShiftSpace
@Desc: For example, you can use the space bar both as a normal Space bar and as a Shift.
Intuitively, it'll be a Space when you want a whitespace, and a Shift when you want it to act as a shift. 
I.e. when you simply press and release it, it is the usual space,  
but when you press other keys, say X, Y and Z, while holding down the space, 
then they will be treated as ⇧ Shift plus X, Y and Z.
@Ref.: https://autohotkey.com/board/topic/57344-spacebar-as-space-and-as-shift/
*/
Critical, On
~LShift::
	; with * operator typing feels more responsive
	Input, SingleKey, V B L1, {BS}{DEL} ; removing EndKeys makes even fast/simultanious combinations like Shift+i work,
		; without producing a space afterwards. I assume it makes it much faster.
	; old 	Input, SingleKey, V B L1, {LControl}{RControl}{LAlt}{RAlt}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}
	; removed from EndKeys  {LShift}{RShift}
	; if (ErrorLevel == "NewInput") { ;If it was interupted by the release of LShift, it means nothing else happend in between
		; SendInput {Space}
	; }
	;Tooltip down %ErrorLevel% ;keep for debug
	;Keywait,LShift, L ;don't use this and don't use a time limit to produce a space (to allow release when reconsidering),
		; because windows autofires after a configurable delay, if this happens the new input stops Input command automatically
return
;Critical, Off
~LShift up::
	; #note if you leave up through with ~, then is doesn't get fast Shift+keys and makes also a space.
	;; furthermore without * it is faster 
	Input
	;whenever Input command is used without params, the ErrorLevel will be just 0 or 1
	; depending if another Input was running already
	;Tooltip up %ErrorLevel% %A_TimeSincePriorHotkey% ;keep for debug
	if (!ErrorLevel && A_TimeSincePriorHotkey < 150) {
		SendInput {Space}
	}
return
Critical, Off
/*
~*LShift::	;tilde so it gets triggered already on down, in cobination with any key, hence can be used as modifier key
	Tooltip %A_PriorHotkey%
	Keywait,LShift,T0.20 L  ;Safety feature, so that space doesn't fire by mistake
		;when you click shift, but then pause and release reduced from .25
	IF(!ErrorLevel && A_PriorKey = "LShift"){
		SendInput {Space}
	}
	Keywait, LShift, ; CRUCIAL: without this it makes space even on long press (since autofire is going through)
Return

;Critical, On
~LControl::	;tilde so it gets triggered already on down, in cobination with any key, hence can be used as modifier key
	Keywait,LControl,T0.20 L  ;Safety feature, so that space doesn't fire by mistake
		;when you click shift, but then pause and release reduced from .25
	IF(!ErrorLevel && A_PriorKey = "LControl"){
		SendInput {Space}
	}
	Keywait, LControl, ; CRUCIAL: without this it makes space even on long press (since autofire is going through)
Return
;Critical, Off

~LCtrl Up::	;tilde so it gets triggered already on down, in cobination with any key, hence can be used as modifier key
;MsgBox %A_PriorKey%
	IF(A_PriorKey = "LControl"){
		SendInput {Space}
	}
	
;Critical, On
~LShift::	;tilde so it gets triggered already on down, in cobination with any key, hence can be used as modifier key
	Keywait,LShift,T0.20 L ;Safety feature, so that space doesn't fire by mistake
		;when you click shift, but then pause and release reduced from .25
	IF !ErrorLevel && A_PriorKey = "LShift" ;if only space was quickly tapped
		SendInput {Space}
	
Return
;Critical, Off

; Optimized new version, but can cause unintended space since even long press will create space
Critical, On
~LShift::	;tilde so it gets triggered already on down, in cobination with any key 
	Keywait,LShift
	if(A_PriorKey = "LShift") ;
		SendInput {Space}
	Keywait,LShift
Return
Critical, On
*/

/*
So that space can be used like Ctrl to erase whole words
#note use send instead of SendInput so that Input commands is able to detect it
*/
<+Del::
	Send ^{Del}
return
<+BS::
	Send ^{Bs}
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>TAB ESCAPE>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Capslock::Backspace
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<TAB ESCAPE<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 



;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>BigKeys remapping>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
/*
"^" mapped to Backspace
Capslock mapped to Enter
LShift mapped to Entf and RShift mapped to Esc (Esc and Esc depend on experience since I don't know how often and how I 
use it 
*/
	
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<BigKeys remapping<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 

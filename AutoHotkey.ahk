/*
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>IMPORTANT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
- run authotkey as admin
#insight two Critical passage make problems, letting auto repeat through and messing all up
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<IMPORTANT<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
*/

#Include  %A_ScriptDir% ;First things first, to set directoy for all other includes
#SingleInstance force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey
;#MaxThreadsBuffer On
#InstallKeybdHook ;important, oterwise
#InstallMouseHook
#UseHook				
;#MaxHotkeysPerInterval 200
SetKeyDelay -1 ;so that also the Send commands are instantaneous (it's even possible to set the press duration)
	; but then in some scripts you need to add delays manually (mostly if interacts with UI)
;SetMouseDelay, 0
/**
Title: ReloadAhk
Explanation: reloads all Autohotkey scripts
*/
$^s:: 
	KeyWait, s, T0.3       
	If ErrorLevel {
		SendInput {blind}{LCtrl Up}{s Up} ;perhaps needed
	
		; pupose of block input and all is to prevent keys getting through, esp. the S
		SplashTextOn,,, Reloading Autohotkey....
		Blockinput, On 
		Sleep 2000
		SplashTextOff	  
		SetCapsLockState, OFF
		Blockinput, Off
		
		Reload
		return ; won't reach that point since ahk does a full reset
	} Else { 
		SendInput ^s  
	}
return


/**
Title: AhkKeyhistory
Desc: shows Autohotkey keyhistory
*/
$^r::
	KeyWait, r, T0.3       
	If ErrorLevel {  
		KeyHistory
	} Else {
		SendInput ^r
	}
	KeyWait, r, 
return


#Include BaseLayout.ahk

#Include ErgoNavi.ahk

#Include TypeArrow.ahk

#Include AltGrify.ahk

#Include PimpFN.ahk

;#Include Thinkpad.ahk

#Include BrowserTricks.ahk

#Include Print.ahk

#Include Misc.ahk



/*
    @Title: AutoHotkey
    @Desc: main script to bring all else together
    #note: run authotkey as admin
*/
SetWorkingDir, %A_ScriptDir%
#SingleInstance force
#Persistent

Process, priority,, Realtime
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 0 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey
;#MaxThreadsBuffer On ; = Causes some or all hotkeys to buffer rather than ignore keypresses when their #MaxThreadsPerHotkey limit has been reached.
;#MaxThreadsPerHotkey 5 ; = Sets the maximum number of simultaneous threads per hotkey or hotstring.

SetKeyDelay 0 ;so that also the Send commands are instantaneous (it's even possible to set the press duration)
	; but then in some scripts you need to add delays manually (mostly if interacts with UI)
SetMouseDelay, 0

/*
    @Title: SetupIncludedAutoExecutes
    @Desc: If included script needs to run their own auto-execute section,
        put a GoSub label here to their auto-exec section to setup
    @Req: Includes must come after
    @Ref: https://jacksautohotkeyblog.wordpress.com/2017/10/10/how-to-write-easy-merge-autohotkey-scripts-technique-example/
*/
Global AHI := new AutoHotInterception()
GoSub, BaseLayout_Setup
GoSub, Trackpad_Setup


/*
    @Title: Includes
    @Desc: include scripts that need to run constantly, right from the start
    #note order shouldn't matter here
*/
#Include %A_ScriptDir%\global\keyboard\BaseLayout.ahk
#Include %A_ScriptDir%\global\trackpad\Trackpad.ahk
#Include %A_ScriptDir%\global\keyboard\AltGrify.ahk
#Include %A_ScriptDir%\global\keyboard\PimpFN.ahk
#Include %A_ScriptDir%\global\keyboard\ErgoNavi.ahk
#Include %A_ScriptDir%\context-sensitive\BrowserOnly.ahk

return ; end of auto-execute section






/*
    @Title: ReloadAhk
    @Desc: reload Autohotkey, including all scripts
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


/*
    @Title: AhkKeyhistory
    @Desc: open Autohotkey keyhistory
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
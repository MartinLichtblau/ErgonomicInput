/*
    @Title: +AutoHotkey
    @Desc: main script to bring all else together
    @Requirements:
        - Set Autohotkey.exe as default application to open .ahk files
        - run authotkey as admin
*/
SetWorkingDir, %A_ScriptDir%
#SingleInstance force
#Persistent
Process, priority,, Realtime
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SetBatchLines -1
ListLines Off
;#KeyHistory 20 ;set it to 0/off if you don't use functions that need it, e.g. A_PriorKey
;#InstallKeybdHook
;#InstallMouseHook
SetKeyDelay 0 ; , -1 ;so that also the Send commands are instantaneous (it's even possible to set the press duration)
	; but then in some scripts you need to add delays manually (mostly if interacts with UI)
SetMouseDelay, 0
DetectHiddenWindows, Off

/*
    @Title: SetupIncludedAutoExecutes
    @Desc: If included script needs to run their own auto-execute section,
        put a GoSub label here to their auto-exec section to setup
    @Req: Includes must come after
    @Ref: https://jacksautohotkeyblog.wordpress.com/2017/10/10/how-to-write-easy-merge-autohotkey-scripts-technique-example/
*/
GoSub, Ahi_Setup
GoSub, Trackpad_Setup
GoSub, SpecialKeys_Setup
GoSub, ShortcutList_Setup
GoSub, Misc_Setup


/*
    @Title: Includes
    @Desc: include scripts that need to run constantly, right from the start
    #note order shouldn't matter here
*/
#Include %A_ScriptDir%\ShortcutList.ahk
#Include %A_ScriptDir%\global\keyboard\SpecialKeys.ahk
#Include %A_ScriptDir%\global\trackpad\Trackpad.ahk
#Include %A_ScriptDir%\global\keyboard\AltGrify.ahk
#Include %A_ScriptDir%\global\keyboard\PimpFN.ahk
#Include %A_ScriptDir%\global\keyboard\ErgoNavi.ahk
#Include %A_ScriptDir%\context-sensitive\BrowserOnly.ahk
#Include %A_ScriptDir%\Misc.ahk
#include %A_ScriptDir%\lib\AutoHotInterception\lib\AutoHotInterception.ahk
return ; end of auto-execute section

Ahi_Setup:
    global AHI
    AHI := new AutoHotInterception()
    return

/*
    @Title: ReloadAhk
    @Desc: reload Autohotkey, including all scripts
*/
;Del::ReloadAhk()
$^s::
	KeyWait, s, T0.3
	if ErrorLevel {
        ReloadAhk()
	} else {
		SendInput ^s
	}
	KeyWait, s,
    return

ReloadAhk() {
    SplashTextOn,,, Reloading Autohotkey....
	Reload
	return
}

/*
    @Title: AhkKeyhistory
    @Desc: open Autohotkey keyhistory
*/
;*Insert:: KeyHistory
$^r::
	KeyWait, r, T0.3
	If ErrorLevel {  
		KeyHistory
	} Else {
		SendInput ^r
	}
	KeyWait, r,
    return
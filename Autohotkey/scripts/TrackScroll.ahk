/*
    @Title: TrackScroll
    @Desc: swap trackad buttons for ergonomic reasons and for easy scrolling
    @Recommendation: for right-handed, swap left and right button in windows, so right trackpoint-hand has LButton underneath
    #note don't know how to do all that only for trackpad
*/
#include %A_ScriptDir%\lib\AutoHotInterception\AutoHotInterception.ahk
Global AHI, trackpadId

TrackScroll_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime

	DetectHiddenWindows, on
    SetTitleMatchMode, 2

    AHI := new AutoHotInterception()
    trackpadId := AHI.GetMouseId(0x0000, 0x0000)
    AHI.SubscribeMouseButton(trackpadId, 2, true, Func("MButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 1, true, Func("RButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 0, true, Func("LButtonEvent"))
return




MButtonEvent(state) {
	if(state){
        AHI.SendMouseButtonEvent(11, 0, 1) ; LButton down
        ;Tooltip MButton down
	}
    else {
        AHI.SendMouseButtonEvent(11, 0, 0) ; LButton up
        ;Tooltip MButton up
    }
}
RButtonEvent(state) {
    if(state) {
        AHI.SendMouseButtonEvent(11, 2, 1) ; MButton down
    } else {
        AHI.SendMouseButtonEvent(11, 2, 0) ; MButton up
        /* Wait in case the script is just starting
        Sleep 50
        If (WinExist("MouseScroll.ahk ahk_class AutoHotkey")) {
            ;Tooltip MouseScroll running
            PostMessage, 0x111, 65307, 0 ; The message is sent to the "last found window" due to WinExist() above.
            ;PostMessage,0x111,65307,,,MouseScroll.ahk
        }
        */
    }
}
LButtonEvent(state) {
	if(state) {
        AHI.SendMouseButtonEvent(11, 1, 1) ; RButton down
        ;Tooltip LButton down
	} else {
	    AHI.SendMouseButtonEvent(11, 1, 0) ; RButton up
	    /*
	    if WinExist("Task Switching")
	        SendInput {Alt Up}
        */

        ; THE ONLY surefire way to kill the run script (in case it's stuck in between)
         Sleep 100
         If (WinExist("MouseScroll.ahk ahk_class AutoHotkey")) {
             ;Tooltip MouseScroll running
             PostMessage, 0x111, 65307, 0 ; The message is sent to the "last found window" due to WinExist() above.
             ;PostMessage,0x111,65307,,,MouseScroll.ahk
         }
        ;Tooltip LButton up
	}
}


/*
    @Title LButtonScroll
    @Desc:
        - hold Lbutton to scroll by moving mouse
        - LButton makes MButton click
    @Reason: like this the right hand can scroll easily and the MButton-key is good enough for left clicks
*/
$*MButton::
    KeyWait, MButton, T0.15
    if (ErrorLevel) {
       run AutoHotkey.exe %A_ScriptDir%\lib\MouseScroll.ahk %trackpadId% "2" %trackpadId%
    } else if (A_PriorKey == "MButton") {
        Tooltip
        Send {MButton down}
        Sleep 50
        Send {MButton up}
    }
return


/*
    @Title RButtonScroll
    @Desc: hold Rbutton to scroll by moving mouse
    #note: I can't make it work like LButton. The left hardware trackpad button seems to be the problem. I tried everything!
        after reboot all ok
*/
$*RButton::
    KeyWait, RButton, T0.15
    if (ErrorLevel) {
       run AutoHotkey.exe %A_ScriptDir%\lib\MouseScroll.ahk %trackpadId% "1" %trackpadId%
    } else if (A_PriorKey == "RButton") { ; A_PriorHotkey does not seem to work
        ;Tooltip %A_PriorKey% %A_PriorHotkey%
        Send {RButton}
    }
return

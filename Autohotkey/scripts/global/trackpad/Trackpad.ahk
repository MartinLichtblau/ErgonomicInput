/*
    @Title: Trackpad
    @Desc: swap trackad buttons for ergonomic reasons and for easy scrolling
    @Recommendation: for right-handed, swap left and right button in windows, so right trackpoint-hand has LButton underneath
    #note don't know how to do all that only for trackpad
*/
#include %A_WorkingDir%\lib\AutoHotInterception\AutoHotInterception.ahk
#Include %A_WorkingDir%\lib\Commands.ahk
#Include %A_WorkingDir%\lib\Functions.ahk
#Include %A_WorkingDir%\global\trackpad\MouseScroll.ahk

Global AHI, trackpadId


Trackpad_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime

	DetectHiddenWindows, on
    SetTitleMatchMode, 2

    if(AHI == "")
        Global AHI := new AutoHotInterception()
    trackpadId := AHI.GetMouseId(0x0000, 0x0000)
    AHI.SubscribeMouseButton(trackpadId, 2, true, Func("MButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 1, true, Func("RButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 0, true, Func("LButtonEvent"))
    Setup_MouseScroll(trackpadId)
return




MButtonEvent(state) {
	if(state){
        AHI.SendMouseButtonEvent(11, 0, 1) ; LButton down
	}
    else {
        AHI.SendMouseButtonEvent(11, 0, 0) ; LButton up
    }
    ExitScript("MouseScroll")
}

RButtonEvent(state) {
    if(state) {
        AHI.SendMouseButtonEvent(11, 2, 1) ; MButton down
        run AutoHotkey.exe %A_WorkingDir%\global\trackpad\MouseArrow.ahk %trackpadId% "2"
    } else {
        AHI.SendMouseButtonEvent(11, 2, 0) ; MButton up
        ExitScript("MouseArrow")
    }
}

LButtonEvent(state) {
    ;Tooltip %state% %A_TickCount%
	if(state) {
        AHI.SendMouseButtonEvent(trackpadId, 1, 1) ; RButton down
        Start_MouseScroll()
	} else {
	    Stop_MouseScroll()
        AHI.SendMouseButtonEvent(trackpadId, 1, 0) ; RButton up
	}

}

/*
    @Title LButtonScroll
    @Desc:
        - hold Lbutton to scroll by moving mouse
        - LButton makes MButton click
    @Reason: like this the right hand can scroll easily and the MButton-key is good enough for left clicks
*/
$*MButton:: return
$*MButton up::
    gosub AltTabRelease
   ; A_PriorHotkey does not seem to work
    ; A_TimeSincePriorHotkey if you are undecided and don't wanna take it back
    ; gosub showKeyVars
    if (A_PriorKey == "MButton") {
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
    return
$*RButton up::
    gosub AltTabRelease
    if (A_PriorKey == "RButton" && A_TimeSincePriorHotkey < 300)
        SendInput {RButton}
    return
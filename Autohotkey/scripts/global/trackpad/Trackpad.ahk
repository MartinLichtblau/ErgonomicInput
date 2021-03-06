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
#Include %A_WorkingDir%\global\trackpad\MouseArrow.ahk

Global trackpadId

Trackpad_Setup:
    #SingleInstance force
    #Persistent

    global AHI
    if(AHI == "")
        global AHI := new AutoHotInterception()
    trackpadId := AHI.GetMouseId(0x0000, 0x0000)
    AHI.SubscribeMouseButton(trackpadId, 2, true, Func("MButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 1, true, Func("RButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 0, true, Func("LButtonEvent"))
    Setup_MouseScroll(trackpadId)
    Setup_MouseArrow(trackpadId)
    return



MButtonEvent(state) {
    ;Tooltip MButtonEvent %state%
	if(state){
        AHI.SendMouseButtonEvent(trackpadId, 0, 1) ; LButton down
	}
    else {
        AHI.SendMouseButtonEvent(trackpadId, 0, 0) ; LButton up
    }
}

RButtonEvent(state) {
    if(state) {
        AHI.SendMouseButtonEvent(trackpadId, 2, 1) ; MButton down
        Start_MouseArrow()
    } else {
        Stop_MouseArrow()
        AHI.SendMouseButtonEvent(trackpadId, 2, 0) ; MButton up
    }
}

LButtonEvent(state) {
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
    ;gosub showKeyVars
    ; if (A_PriorKey == "MButton" && A_TimeSincePriorHotkey < 200) {
    if (A_PriorHotkey == "$*MButton" && A_TimeSincePriorHotkey < 200) {
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
    if (A_PriorKey == "RButton" && A_TimeSincePriorHotkey < 200) {
        SendInput {RButton}
    }
    return
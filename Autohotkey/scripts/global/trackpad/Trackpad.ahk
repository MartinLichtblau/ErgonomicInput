/*
    @Title: Trackpad
    @Desc: swap trackad buttons for ergonomic reasons and for easy scrolling
    @Recommendation: for right-handed, swap left and right button in windows, so right trackpoint-hand has LButton underneath
    #note don't know how to do all that only for trackpad
*/
#include %A_ScriptDir%\lib\AutoHotInterception\AutoHotInterception.ahk
#Include %A_ScriptDir%\lib\Commands.ahk
#Include %A_ScriptDir%\lib\Functions.ahk
#Include %A_ScriptDir%\global\trackpad\MouseScroll.ahk
#Include %A_ScriptDir%\global\trackpad\MouseArrow.ahk

global trackpadId

Trackpad_Setup:
    #SingleInstance force
    #Persistent

    if(AHI == "")
        global AHI
        AHI := new AutoHotInterception()
    trackpadId := AHI.GetMouseId(0x0000, 0x0000)
    AHI.SubscribeMouseButton(trackpadId, 2, true, Func("MButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 1, true, Func("RButtonEvent"))
    AHI.SubscribeMouseButton(trackpadId, 0, true, Func("LButtonEvent"))
    Setup_MouseScroll(trackpadId)
    ;Setup_MouseArrow(trackpadId)
    return


global trackpadLButtonDown := false
MButtonEvent(state) {
    ;Tooltip MButtonEvent %state%
	if(state){
        AHI.SendMouseButtonEvent(trackpadId, 0, 1) ; LButton down
        trackpadLButtonDown := true
	}
    else {
        AHI.SendMouseButtonEvent(trackpadId, 0, 0) ; LButton up
        trackpadLButtonDown := false
    }
}

global trackpadMButtonDown := false
RButtonEvent(state) {
    ;Tooltip RButtonEvent %state%
    if(state) {
        global downTime := A_TickCount
        ;AHI.SendMouseButtonEvent(trackpadId, 2, 1) ; MButton down
        trackpadMButtonDown := true
        Start_MouseArrow(trackpadId)
    } else {
        Stop_MouseArrow()
        ;AHI.SendMouseButtonEvent(trackpadId, 2, 0) ; MButton up
        pressDuration := A_TickCount - downTime
        noKeyInputBetween := pressDuration <= A_TimeIdleKeyboard
        if (pressDuration < 200 && noKeyInputBetween) {
            Send {MButton down}
            Sleep 50
            Send {MButton up}
        }
        trackpadMButtonDown := false ; @TODO #bug sometimes this var doesn't get reset. Probably because no event is fired.
    }
}

global trackpadRButtonDown := false
LButtonEvent(state) {
    ;Tooltip LButtonEvent %state%, 400, 100
	if(state) {
        global downTime := A_TickCount
        ;AHI.SendMouseButtonEvent(trackpadId, 1, 1) ; RButton down
        trackpadRButtonDown := true
        Start_MouseScroll()
	} else {
	    Stop_MouseScroll()
        ;AHI.SendMouseButtonEvent(trackpadId, 1, 0) ; RButton up
        gosub AltTabRelease
        pressDuration := A_TickCount - downTime
        noKeyInputBetween := pressDuration <= A_TimeIdleKeyboard
        if (pressDuration < 200 && noKeyInputBetween) {
            ;SendInput {RButton}
            AHI.SendMouseButtonEvent(trackpadId, 1, 1) ; RButton down
            AHI.SendMouseButtonEvent(trackpadId, 1, 0) ; RButton up
        } else if (GetKeyState("LCtrl")) {
            SendInput {LCtrl up} ; necessary for making press-hold-switch-release-select commands like for tab switching possible
        }
        trackpadRButtonDown := false
	}
}

;$*RButton::
;    return
;$*RButton up::
;
;    return
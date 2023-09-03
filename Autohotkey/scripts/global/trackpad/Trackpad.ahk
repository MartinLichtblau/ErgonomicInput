/*
    @Title: Trackpad
    @Desc: swap trackad buttons for ergonomic reasons and for easy scrolling
    @Recommendation: for right-handed, swap left and right button in windows, so right trackpoint-hand has LButton underneath
    #note don't know how to do all that only for trackpad
*/
#Include %A_ScriptDir%\lib\Commands.ahk
#Include %A_ScriptDir%\lib\Functions.ahk
#Include %A_ScriptDir%\global\trackpad\MouseScroll.ahk
#Include %A_ScriptDir%\global\trackpad\MouseArrow.ahk

Trackpad_Setup:
    #SingleInstance force
    #Persistent
    SetupTrackpad(GetAhiDeviceIdByHandle("ACPI\VEN_LEN&DEV_009A")) ; Lenovo X1 Yoga G3 Trackpad
    SetupTrackpad(GetAhiDeviceIdByHandle("HID\VID_17EF&PID_60EE&REV_0127&MI_01&Col01")) ; Lenovo Bluetooth TrackPoint Keyboard II
    ;Setup_MouseArrow(trackpadId)
    return

global trackpadLButtonDown := false
MButtonEvent(tpId, state) {
    ;Tooltip MButtonEvent %state% %tpId%
	if(state){
        AHI.SendMouseButtonEvent(tpId, 0, 1) ; LButton down
        trackpadLButtonDown := true
	}
    else {
        AHI.SendMouseButtonEvent(tpId, 0, 0) ; LButton up
        trackpadLButtonDown := false
    }
}

global trackpadMButtonDown := false
RButtonEvent(tpId, state) {
    ;Tooltip RButtonEvent %state%
    if(state) {
        global downTime := A_TickCount
        ;AHI.SendMouseButtonEvent(trackpadId, 2, 1) ; MButton down
        trackpadMButtonDown := true
        Start_MouseArrow(tpId)
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
LButtonEvent(tpId, state) {
    ;Tooltip LButtonEvent %state%, 400, 100
	if(state) {
        global downTime := A_TickCount
        ;AHI.SendMouseButtonEvent(trackpadId, 1, 1) ; RButton down
        trackpadRButtonDown := true
        Start_MouseScroll(tpId)
	} else {
	    Stop_MouseScroll(tpId)
        ;AHI.SendMouseButtonEvent(trackpadId, 1, 0) ; RButton up
        gosub AltTabRelease
        pressDuration := A_TickCount - downTime
        noKeyInputBetween := pressDuration <= A_TimeIdleKeyboard
        if (pressDuration < 200 && noKeyInputBetween) {
            ;SendInput {RButton}
            AHI.SendMouseButtonEvent(tpId, 1, 1) ; RButton down
            AHI.SendMouseButtonEvent(tpId, 1, 0) ; RButton up
        } else if (GetKeyState("LCtrl")) {
            SendInput {LCtrl up} ; necessary for making press-hold-switch-release-select commands like for tab switching possible
        }
        trackpadRButtonDown := false
	}
}

SetupTrackpad(tpId) {
    if tpId <= 0
        return
    AHI.SubscribeMouseButton(tpId, 2, true, Func("MButtonEvent").bind(tpId))
    AHI.SubscribeMouseButton(tpId, 1, true, Func("RButtonEvent").bind(tpId))
    AHI.SubscribeMouseButton(tpId, 0, true, Func("LButtonEvent").bind(tpId))
    Setup_MouseScroll(tpId)
}
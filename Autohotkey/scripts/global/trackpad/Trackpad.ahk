/*
    @Title: Trackpad
    @Desc: Map the trackpad buttons to clicks and mouse scrolling.
*/
#Include %A_ScriptDir%\lib\Commands.ahk
#Include %A_ScriptDir%\global\trackpad\MouseScroll.ahk

Trackpad_Setup:
    #SingleInstance force
    #Persistent
    Setup_MouseScroll()
    return

global trackpadMButtonDown := false
global trackpadRButtonDown := false
global LButtonLocked := false
global trackpadMiddleDownTime := 0
global trackpadRightDownTime := 0

$*MButton::
    if (LButtonLocked) {
        LButtonLocked := false
        SendInput {Blind}{LButton up}
        return
    }
    SendInput {Blind}{LButton down}
    return

$*MButton Up::
    if (!LButtonLocked)
        SendInput {Blind}{LButton up}
    return

; Either press order locks left-click until the next middle-button click.
RButton & MButton::
MButton & RButton::
    LButtonLocked := true
    Stop_MouseScroll()
    SendInput {Blind}{LButton down}
    return

$*RButton::
    if (LButtonLocked)
        return
    trackpadMiddleDownTime := A_TickCount
    trackpadMButtonDown := true
    Start_MouseScroll()
    return

$*RButton Up::
    if (!GetKeyState("LButton", "P"))
        Stop_MouseScroll()
    if (!LButtonLocked && A_TickCount - trackpadMiddleDownTime < 200 && A_TickCount - trackpadMiddleDownTime <= A_TimeIdleKeyboard) {
        Send {MButton down}
        Sleep 50
        Send {MButton up}
    }
    trackpadMButtonDown := false
    return

$*LButton::
    trackpadRightDownTime := A_TickCount
    trackpadRButtonDown := true
    Start_MouseScroll()
    return

$*LButton Up::
    if (!GetKeyState("RButton", "P"))
        Stop_MouseScroll()
    gosub AltTabRelease
    if (A_TickCount - trackpadRightDownTime < 200 && A_TickCount - trackpadRightDownTime <= A_TimeIdleKeyboard)
        SendInput {Blind}{RButton down}{RButton up}
    else if (GetKeyState("LCtrl"))
        SendInput {LCtrl up}
    trackpadRButtonDown := false
    return
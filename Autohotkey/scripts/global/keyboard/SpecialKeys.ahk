/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/
;#include %A_ScriptDir%\lib\AutoHotInterception\lib\AutoHotInterception.ahk

SpecialKeys_Setup:
    #SingleInstance force
    #Persistent

    ; Init Variables
    if(AHI == "")
        global AHI
        AHI := new AutoHotInterception()
    global kbdId = 1 ; use 1st/primary keyboard to intercept and also for output
    RemapSpecialKeys()
    RemapOtherKeys()
    return

RemapSpecialKeys() {
    MapKeyAtoB("LShift", "Tab")
    MapKeyAtoB("RShift", "Tab")
    MapKeyAtoB("Tab", "Backspace")
    MapKeyAtoB("^", "Delete")
    MapKeyAtoB("Capslock", "Enter")
    MapKeyAtoB("LAlt", "LCtrl")
    MapKeyAtoB("LCtrl", "LWin")
    MapKeyAtoB("^", "Delete")
    MapKeyAtoB("LWin", "LAlt")
    MapKeyAtoB("PrintScreen", "LAlt")
    MapKeyAtoB("RAlt", "Lctrl")
    MapKeyAtoB("RCtrl", "AppsKey")
    AHI.SubscribeKey(kbdId, GetKeySC("Space"), true, Func("SpaceShiftEvent"))    
}

RemapOtherKeys() {
    MapKeyAtoB("q", "w")
    MapKeyAtoB("w", "q")
}

MapKeyAtoB(a, b) {
    AHI.SubscribeKey(kbdId, GetKeySC(a), true, Func("KeyEvent").bind(GetKeySC(b)))
}

KeyEvent(b, state) {
    if(state) {
        AHI.SendKeyEvent(kbdId, b, 1)
    } else {
        AHI.SendKeyEvent(kbdId, b, 0)
    }
}

; Fn Key Press
sc163:: Autoscroll()

Global Autoscroll := 0
Autoscroll() {
        ;MouseClick,WheelDown,,,3,0,D,R
        ;SendInput {Down}
        ; StartTime := A_TickCount
       ; KeyWait, sc163
        ;px_down := A_TickCount - StartTime
        move_distance := 80
        ;tooltip %px_down% %StartTime% %A_TickCount%
        ;MoveCursorToShow()

        CoordMode, Mouse, Screen
        MouseGetPos, X, Y
        MouseMove, 0, 0,, R ;DllCall("SetCursorPos", "int", X, "int", Y+1)
        Y -= move_distance ; move cursor 30px UP first
        DllCall("SetCursorPos", "int", X, "int", Y)
        SendInput {MButton}
        Sleep 100
        ; tooltip %A_Cursor% ; Arrow is normal pointer and middle scroll is unknown
        Y += move_distance ; move cursor 30px down to initiate slow down scroll
        DllCall("SetCursorPos", "int", X, "int", Y)
        if (A_Cursor == "Unknown") {
            Autoscroll := 1
        } else {
            Autoscroll := 0
        }
        ;tooltip : %Autoscroll% %A_Cursor%
        return
}

/*
    @Title: SpaceShift
    @Desc: use Space as both Shift and Space
    #note manual time calculation is just a #fix because internal A_TimeSince.. vars don't work (since AHI hides input)
    #note A_PriorKey needs some key event after down-event and it slow; hence various ways to deal with it:
        see: #Alt1.1, #Alt1.2
*/
global shiftSpaceDown := false
SpaceShiftEvent(state) {
    static timeOfInitDown
    if(state) {
        if(!shiftSpaceDown) {
            AHI.SendKeyEvent(kbdId, GetKeySC("LShift"), 1)
            ; Send {LShift Down}
            shiftSpaceDown := true
            timeOfInitDown := A_TickCount
        }
    } else {
        AHI.SendKeyEvent(kbdId, GetKeySC("LShift"), 0)
        ; Send {LShift Up}
        shiftSpaceDown := false
        ; pressDuration := A_TickCount - timeOfInitDown
        Sleep 1 ; #Alt1.2 =fix wait so it recognizes the LShift up event ; 0 or 1 ms seems to make a bigger difference
        ;Tooltip %A_TimeIdleKeyboard% %A_TimeIdlePhysical% %pressDuration% %A_PriorKey%
        if(A_PriorKey == "LShift" && (A_TickCount - timeOfInitDown) < 200) { ; A_TimeIdleKeyboard >= pressDuration && doesn't work since fast typing overlap
            AHI.SendKeyEvent(kbdId, GetKeySC("Space"), 1)
            AHI.SendKeyEvent(kbdId, GetKeySC("Space"), 0)
        }
    }
}

/*
    @Title: SpaceErase like Ctrl to erase whole words
    #note use send instead of SendInput so that Input commands are able to detect it
*/

/*<+Del::
    SendInput {LCtrl down}{Del}{LCtrl up}
    return
*/

<+BS::
    SendInput {LCtrl down}{BS}{LCtrl up}
    return
    /*
    AHI.SendKeyEvent(kbdId, lShiftSc, 0) ; up so only Ctrl
    @Desc: Because of it superior position it should be usable+Bs is pressed
    AHI.SendKeyEvent(kbdId, lCtrlSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 1)
    AHI.SendKeyEvent(kbdId, backspaceSc, 0)
    AHI.SendKeyEvent(kbdId, lCtrlSc, 0)
    AHI.SendKeyEvent(kbdId, lShiftSc, 1) ; set it to down as it was before. #risk: it could have been
        ; physically released while the hotkey was pressed, leaving it in an inconsistent state.
    return
    */


/*
    @Title: CtrlShift
*/
~LShift & ~LCtrl up::
~LCtrl & ~LShift up::
    if(A_PriorKey == "LControl" || A_PriorKey == "LShift") {
        SendInput {Enter}
    }
    return
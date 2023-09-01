/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/

SpecialKeys_Setup:
    #SingleInstance force
    #Persistent
    SetupAllKeyboards()
    ;ApplyMappingsToKeyboard(AHI.GetKeyboardIdFromHandle("ACPI\VEN_LEN&DEV_0071"), getKeyboardMappings())
    return

getKeyboardMappings() {
    static mappings := [["LShift", "Tab"]
        ,["RShift", "Tab"]
        ,["Tab", "Backspace"]
        ,["^", "Delete"]
        ,["Capslock", "Enter"]
        ,["LAlt", "LCtrl"]
        ,["LCtrl", "LWin"]
        ,["LWin", "LAlt"]
        ,["PrintScreen", "LAlt"]
        ,["RAlt", "Lctrl"]
        ,["RCtrl", "AppsKey"]
        ,["q", "w"]
        ,["w", "q"]]
    return mappings
}

SetupAllKeyboards() {
    keyboardIds := {}
    keyboardIds.push(AHI.GetKeyboardIdFromHandle("ACPI\VEN_LEN&DEV_0071"))
    keyboardIds.push(AHI.GetKeyboardIdFromHandle("HID\VID_17EF&PID_60EE&REV_0127&MI_00"))
    RemapAllKeyboards(keyboardIds)
}

RemapAllKeyboards(keyboardIds) {
    for index, kbdId in keyboardIds {
        ApplyMappingsToKeyboard(kbdId, getKeyboardMappings())
    }
}

ApplyMappingsToKeyboard(kbdId, mappings) {
    ;tooltip % kbdId mappings[8][1] mappings[8][2]    
    for index, mapping in getKeyboardMappings() {
        MapKeyAtoB(mapping[1], mapping[2], kbdId)
    }
    AHI.SubscribeKey(kbdId, GetKeySC("Space"), true, Func("SpaceShiftEvent").bind(kbdId))
}

MapKeyAtoB(a, b, kbdId) {
    ;tooltip % kbdId a b
    AHI.SubscribeKey(kbdId, GetKeySC(a), true, Func("KeyEvent").bind(GetKeySC(b), kbdId))
}

KeyEvent(b, kbdId, state) {
    ;tooltip % b kbdId state
    if(state) {
        AHI.SendKeyEvent(kbdId, b, 1)
    } else {
        AHI.SendKeyEvent(kbdId, b, 0)
    }
}


/*
    @Title: SpaceShift
    @Desc: use Space as both Shift and Space
    #note manual time calculation is just a #fix because internal A_TimeSince.. vars don't work (since AHI hides input)
    #note A_PriorKey needs some key event after down-event and it slow; hence various ways to deal with it:
        see: #Alt1.1, #Alt1.2
*/
global shiftSpaceDown := false
SpaceShiftEvent(kbdId, state) {
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

<+BS::
    SendInput {LCtrl down}{BS}{LCtrl up}
    return
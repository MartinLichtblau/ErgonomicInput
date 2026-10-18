/*
    @Title: SpecialKeys
    @Desc: fundamental changes of special keys, concerning mapping and behavior
    #Maturity:7
*/

SpecialKeys_Setup:
    spaceShiftDown := false
    return

$~*LShift::
    if (!spaceShiftDown) {
        spaceShiftDown := true
        spaceShiftStart := A_TickCount
    }
    return

$~*LShift up::
    if (!spaceShiftDown)
        return
    pressDuration := A_TickCount - spaceShiftStart
    spaceShiftDown := false
    if (pressDuration < 200 && A_PriorKey == "LShift")
        SendInput {Space}
    return

<+BS::
    SendInput {LCtrl down}{BS}{LCtrl up}
    return
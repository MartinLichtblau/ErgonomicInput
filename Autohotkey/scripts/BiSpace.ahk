/*
    @Title: BiSpace
    @Desc: fundamental changes of layout; e.g. language, space, backspace, ...
    @Requirements:
        - registry remap Space-key so it becomes LShift
*/
BiSpace_Setup:
    #SingleInstance force
    #Persistent
    Process,priority,,Realtime
return




/*
    @Title: ShiftSpace
    @Desc: For example, you can use the space bar both as a normal Space bar and as a Shift.
    Intuitively, it'll be a Space when you want a whitespace, and a Shift when you want it to act as a shift.
    I.e. when you simply press and release it, it is the usual space,
    but when you press other keys, say X, Y and Z, while holding down the space,
    then they will be treated as ⇧ Shift plus X, Y and Z.
    @Ref.: https://autohotkey.com/board/topic/57344-spacebar-as-space-and-as-shift/
*/
~LShift:: ; tilde so it gets triggered already on down, in cobination with any key, hence can be used as modifier key
    ; @TODO how it it going without * Less responsive? Without it, Space shouldn't be p
    Keywait,LShift, L ; just to deactivate autofire
return
; Critical, On ; makes it only slower
~*LShift up::
    ; @TODO without * it's faster, but with it you can produce a space while you hold a key, e.g. when tying speedy
    ; %A_PriorHotkey% does not work, since not every key has a hotkey
    IF(A_TimeSincePriorHotkey < 150 && A_PriorKey = "LShift") {
        SendInput {Space}
    }
return
; Critical, Off

/*
    @Title: SpaceErase
    @Desc: Because of it superior position it should be usable like Ctrl to erase whole words
    #note use send instead of SendInput so that Input commands are able to detect it
*/
<+Del::
	Send ^{Del}
return

<+BS::
	Send ^{Bs}
return
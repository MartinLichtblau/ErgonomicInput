/*
    @Title: MouseScroll
    @Desc: hold key to scroll by moving mouse>cursor
*/
#SingleInstance force
#Persistent
Process,priority,,Realtime

#include %A_ScriptDir%\AutoHotInterception\AutoHotInterception.ahk

; Parameter: %pressDeviceId% %pressKey% %scrollMouseId%
if(A_Args.Length() != 3)
    ExitApp
global pressDeviceId := A_Args[1]
global pressKey := A_Args[2]
global scrollMouseId := A_Args[3]
;Tooltip Parameters: pressDeviceId: %pressDeviceId% pressKey: %pressKey%   scrollMouseId: %scrollMouseId%

; AHI
global AHI := new AutoHotInterception()
AHI.SubscribeMouseMoveRelative(scrollMouseId, true, Func("MouseEvent"))
AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent"))


/*
; Subscribe to correct device and key
; #note currently only AHI Button Ids possible
if(pressDeviceId < 11) { ; it's a keyboard
    ;AHI.SubscribeKey(pressDeviceId, GetKeySC(pressKey), true, Func("PressKeyEvent"))
} else { ; it's a mouse
    Tooltip %pressKey%
    AHI.SubscribeMouseButton(pressDeviceId, pressKey, false, Func("PressKeyEvent"))
}
*/


~MButton up::
~RButton up::
    Tooltip Exit:MouseScroll
ExitApp



global xSum := 0
global ySum := 0
MouseEvent(x, y){
    xSum := xSum + x
    ySum := ySum + y
    if(xSum > 10) {
        SendInput {WheelRight}
        xSum = 0
        ySum = 0
    } else if(xSum < -10) {
        SendInput {WheelLeft}
        xSum = 0
        ySum = 0
    } else if(ySum > 8) {
        SendInput {WheelDown}
        xSum = 0
        ySum = 0
    } else if(ySum < -10) {
        SendInput {WheelUp}
        xSum = 0
        ySum = 0

    }
    ;Tooltip i=%i% | x: %x%  y: %y% | xSum: %xSum% ;top left is minus for x and y
}

/*
    @Title: AltGrify
    @Desc: On long press of key writes german AltGr counterpart (char that is normally on that key on german querty layout).
        To remove lag it always writes normal char at first and deletes it if pressed longer, hence swaps it with altgr char.
    @Requirements: none
    @Recommendations: remove AltGr functionality of keyboard layout since you use this instead
    @Maturity:5
*/
AltGrify_Setup:
    #SingleInstance force
    #Persistent
    #Include %A_WorkingDir%\lib\Functions.ahk
    return


;--------------------------------------------Row2 / Number Row
$2::ReplaceOnLongPress("2", "{U+00B2}") ; U+00B2 = "²"
$3::ReplaceOnLongPress("3", "{U+00B3}")  ; U+00B3 = "³"
$6::ReplaceOnLongPress("6", "{U+005E}") ; U+005E = ^
$7::ReplaceOnLongPress("7", "{{}")
$8::ReplaceOnLongPress("8", "{[}")
$9::ReplaceOnLongPress("9", "{]}")
$0::ReplaceOnLongPress("0", "{}}")

;--------------------------------------------MISC
$sc00C::ReplaceOnLongPress("sc00C", "{\}") ; here sc00C = ß
$sc056::ReplaceOnLongPress("sc056", "{|}") ; here sc056 = <
$sc01B::ReplaceOnLongPress("sc01B", "{~}") ; here sc01B = +
$q::ReplaceOnLongPress("q", "@")
;$e::ReplaceOnLongPress("e", "{U+20AC}")

;--------------------------------------------Custom
$sc035::ReplaceOnLongPress("sc035", "{U+2012}") ; sc035 = - | ; EM Dash: {U+2014} = "—" | EN Dash: {U+2013} = "-" | Figure Dash: {U+2012} = "‒"
$1::ReplaceOnLongPress("1", "{u+27a4}") ; {u+27a4} = "➤"
$sc034::ReplaceOnLongPress("sc034", ":") ; sc034 = .
$sc02B::ReplaceOnLongPress("sc02B", "'") ; sc02B = #
$sc033::ReplaceOnLongPress("sc033", ";") ; sc033 = ;

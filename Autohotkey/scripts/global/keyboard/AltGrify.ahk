/*
    @Title: AltGrify
    @Desc: On long press of key writes german AltGr counterpart (char that is normally on that key on german querty layout).
        To remove lag it always writes normal char at first and deletes it if pressed longer, hence swaps it with altgr char.
    @Requirements: none
    @Recommendations: remove AltGr functionality of keyboard layout since you use this instead
*/
#SingleInstance force
#Persistent
;Process,priority,,Realtime




$2::OnLongPress("2", "U+00B2") ; U+00B2 = "²"
$3::OnLongPress("3", "U+00B3")  ; U+00B3 = "³"
$7::OnLongPress("7", "{")
$8::OnLongPress("8", "[")
$9::OnLongPress("9", "]")
$0::OnLongPress("0", "}")
$sc00C::OnLongPress("sc00C", "\") ; sc00C = ß
$sc056::OnLongPress("sc056", "|") ; sc056 = <
$sc01B::OnLongPress("sc01B", "~") ; sc01B = +
$sc011::OnLongPress("q", "@") ; sc011 = q
; Additional custom ones
$sc035::OnLongPress("sc035", "U+2012") ; sc035 = - | ; EM Dash: {U+2014} = "—" | EN Dash: {U+2013} = "-" | Figure Dash: {U+2012} = "‒"
$1::OnLongPress("1", "U+27a4") ; {u+27a4} = "➤"

; #note: guess could also work without backspace by using Input command
OnLongPress(PressedKey, CharToWrite) {
	SendInput {%PressedKey%}
	KeyWait, %PressedKey%, T0.3
	if ErrorLevel {
		SendInput {BS}{%CharToWrite%}
	}
	KeyWait, %PressedKey%,
}


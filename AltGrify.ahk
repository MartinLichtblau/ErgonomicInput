
/**
On long press of key writes german AltGr counterpart (char that is normally on that key on german querty layout).
To remove lag it always writes normal char at first and deletes it if pressed longer, hence swaps it with altgr char.
*/

$2::OnLongPress(SubStr(A_ThisHotkey, 2), "U+00B2") ; U+00B2 = "²"
$3::OnLongPress(SubStr(A_ThisHotkey, 2), "U+00B3")  ; U+00B3 = "³"
$7::OnLongPress(SubStr(A_ThisHotkey, 2), "{")
$8::OnLongPress(SubStr(A_ThisHotkey, 2), "[")
$9::OnLongPress(SubStr(A_ThisHotkey, 2), "]")
$0::OnLongPress(SubStr(A_ThisHotkey, 2), "}")
$sc00C::OnLongPress(SubStr(A_ThisHotkey, 2), "\") ; sc00C = ß
$sc056::OnLongPress(SubStr(A_ThisHotkey, 2), "|") ; sc056 = <
$sc01B::OnLongPress(SubStr(A_ThisHotkey, 2), "~") ; sc01B = +
$q::OnLongPress(SubStr(A_ThisHotkey, 2), "@")

; Additional custom ones
$sc035::OnLongPress(SubStr(A_ThisHotkey, 2), "U+2014") ; sc035 = - | ; {U+2014} = "—"
$1::OnLongPress(SubStr(A_ThisHotkey, 2), "U+27a4") ; {u+27a4} = "➤"

OnLongPress(PressedKey, CharToWrite) {
	SendInput {%PressedKey%}
	KeyWait, %PressedKey%, T0.3
	if ErrorLevel {
		SendInput {BS}{%CharToWrite%}
	}
	KeyWait, %PressedKey%,
}


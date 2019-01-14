/*
    @Title: Print
    @Desc: prints current website as .pdf in certain folder
    @TODO broken print_open
*/
global clipTemp := ""


PrintInChromeToFolder(folder) {
	clipTemp := Clipboard ;temp save Clipboard content
	printChrome()
	;Sleep 1000
	filename := print_save(folder)
	MsgBox, 0,, Open PDF?, 1
	IfMsgBox OK
		print_open("local", folder, filename)
	Clipboard := clipTemp 				;reset to old Clipboard content
    return
}

printChrome() {
	SendInput ^p ;print in chrome
	Sleep 3000  ;Wait for print preview to be open and responsive
    return
}

print_save(folder) {
	saveAs = Save As ;String depends on which system language is used
	SendInput {Enter} 					;Click save (print pdf)
	WinWaitActive, %saveAs%, , 10
	if ErrorLevel
	{
		MsgBox, Speichern unter timed out.
		Reload
	}
	Sleep 500
	Send ^c 					;takes the given pdf name
	filename := Clipboard
	Sleep 333 ;needed because clipboard takes time
	Clipboard := folder
	Sleep 333

	loop{
		Send ^l
		Sleep 333
		Send ^a
		Send ^v
		Send {Enter}
		Sleep 333
		Send {Enter}
		WinWaitClose %saveAs%, , 1
		if(!ErrorLevel)
			break
	}
    return filename
}

print_open(type, folder, filename) {
	Sleep 1000
	If(type == "local") {
	    fullPath := folder . filename . ".pdf"
		Run, open %fullPath% ; Open pdf with local software ;//update: perhaps the ".pdf" has to be removed for it to work
	}else if(type == "chrome") {
		Clipboard = https://drive.google.com/drive/search?q=%filename%
		Send ^t
		Send ^l
		Send ^v {Enter}
	}else if(type == "drive") {
		Run, explore %folder%
		Sleep 300
		Send ^f
		Clipboard := filename
		Send ^v {ENTER}
		Sleep 300
		Send {down}{up}
	} else
		MsgBox "Error: Wrong type of program to open pdf file"
	;not in use >>>>>>>>>>>>>>>>>>>
	;Clipboard = http://fivefilters.org/pdf-newspaper/makepdf.php?feed=%Clipboard%&v=2&mode=single-story&template=A4&images=true&fulltext=true
	;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    return
}

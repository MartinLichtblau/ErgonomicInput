/*
    @Title: ShortcutList
    @Desc: creates global variables for shortcuts of any application to have them in one place and
        consistent throughout different scripts.
    #note: there seems to be a bug since ahk trows error if first shortcut after global contains parenthesis {},
        hence wrapped in "".
*/

ShortcutList_Setup:
    global WINVIEW_sc = "#{Tab}" ; Opening overview showing all desktop and open windows
    global LEFTDESKTOP_sc = "{LCtrl Down}{LWin Down}{Left}{LWin Up}{LCtrl Up}" ; switch one desktop to the left
    global RIGHTDESKTOP_sc = "{LCtrl Down}{LWin Down}{Right}{LWin Up}{LCtrl Up}" ; switch one desktop to the right
    global LEFTTAB_sc = "^{PgUp}" ; switch one tab to the left
    global RIGHTTAB_sc = "^{PgDn}" ; switch one tab to the right
    global GOBACK_sc := "{Browser_Back}" ; "!{Left}"
    global GOFORWARD_sc = "{Browser_Forward}" ; "!{Right}"
    global ADDRESSBAR_sc = "^l" ; focus address bar""
    global SEARCH_sc = "^f" ; search in app
    global TABSEARCH_sc = "!7"
    global PREVIOUSTAB_sc = "!8"
    global LATERTAB_sc = "!9"
    global CLOSETAB_sc = "^w"
    global CLOSEWINDOW_sc = "!{F4}"
    global REOPENCLOSEDTAB_sc = "^+t"
    global RELOAD_sc = "^r"
    return
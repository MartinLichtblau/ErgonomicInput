/*
    @Title: ShortcutList
    @Desc: creates global variables for shortcuts of any application to have them in one place and
        consistent throughout different scripts.
    #note: there seems to be a bug since ahk trows error if first shortcut after global contains parenthesis {},
        hence wrapped in "".
*/

ShortcutList_Setup:
    global WINVIEW_sc = "#{Tab}" ; Opening overview showing all desktop and open windows ,
        LEFTDESKTOP_sc = {LCtrl Down}{LWin Down}{Left}{LWin Up}{LCtrl Up} ; switch one desktop to the left ,
        RIGHTDESKTOP_sc = {LCtrl Down}{LWin Down}{Right}{LWin Up}{LCtrl Up} ; switch one desktop to the right ,
        LEFTTAB_sc = ^{PgUp} ; switch one tab to the left ,
        RIGHTTAB_sc = ^{PgDn} ; switch one tab to the right ,
        GOBACK_sc = Browser_Back ; go one step back to prior page ,
        GOFORWARD_sc = Browser_Forward ; go one step forward to later page ,
        ADDRESSBAR_sc = "^l" ; focus address bar ,
        SEARCH_sc = "^f" ; search in app ,
        TABSEARCH_sc = "!+7",
        PREVIOUSTAB_sc = "!+8",
        LATERTAB_sc ="!+9",
        CLOSETAB_sc = "^w",
        CLOSEWINDOW_sc = "!{F4}",
        REOPENCLOSEDTAB_sc = "^+t",
        RELOAD_sc = "^r"
    return
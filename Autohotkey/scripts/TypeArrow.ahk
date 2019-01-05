/*
    @Title: TypeArrow
    @Desc: make arrow-keys accessible in the center
*/
Process, priority,, Realtime


~LButton & h::
	Send {blind}{Left}
Return


~LButton & l::
	Send {blind}{Up}
Return


~LButton & u::
	Send {blind}{Right}
Return


~LButton & n::
	Send {blind}{Down}
Return


~LButton & b::
	Send {blind}{Home}
Return


~LButton & sc019:: ; sc019 = ö
	Send {blind}{End}
Return
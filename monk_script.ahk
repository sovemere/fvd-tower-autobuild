#SingleInstance Force
#Persistent
SetDefaultMouseSpeed, 0  ; Set mouse to maximum speed (instant)

global script_active := false

; Calculate position from bottom-left corner (1080p monitor)
screen_height := 1080  
target_x := 320        
target_y := screen_height - 145  

; Toggle script on/off with = key
=::
script_active := !script_active
if (script_active) {
    SoundBeep, 800, 200
} else {
    SoundBeep, 400, 200
}
return

; Hook into right click when script is active
#If script_active
RButton::
MouseGetPos, current_x, current_y
Click right
Send {Ctrl down}
MouseMove, %target_x%, %target_y%, 0
Click
MouseMove, %current_x%, %current_y%, 0
Send {Ctrl up}
return
#If

ExitScript:
ExitApp
return
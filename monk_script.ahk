#SingleInstance Force
#Persistent
SetDefaultMouseSpeed, 0  ; Set mouse to maximum speed (instant)

global script_active := false

; Calculate position from bottom-left corner (1080p monitor)
screen_height := 1080  
target_x := 320        
target_y := screen_height - 145  

; Toggle script on/off with = key
0::
script_active := !script_active
MouseGetPos, cursor_x, cursor_y  ; Get current cursor position

if (script_active) {
    SoundBeep, 800, 200
    ToolTip, Conversion Activated, %cursor_x%, %cursor_y%
    SetTimer, RemoveToolTip, -1000  ; Remove tooltip after 1 second
} else {
    SoundBeep, 400, 200
    ToolTip, Conversion Deactivated, %cursor_x%, %cursor_y%
    SetTimer, RemoveToolTip, -1000  ; Remove tooltip after 1 second
}
return

; Function to remove the tooltip
RemoveToolTip:
ToolTip
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
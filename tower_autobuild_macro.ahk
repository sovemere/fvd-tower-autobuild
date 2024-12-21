#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%

global startX := 0
global startY := 0
global dragEndX := 0
global dragEndY := 0
global isTracking := false
global currentX := 0
global currentY := 0
global totalXDisplacement := 0
global totalYDisplacement := 0
global targetXDisplacement := 0
global targetYDisplacement := 0
global xMultiplier := 1    ; 1 for right, -1 for left
global yMultiplier := 1    ; 1 for down, -1 for up
global terminateLoop := false  

Hotkey, ~LButton & Shift, MouseMoveRoutine, Off
Hotkey, ~Shift & LButton, MouseMoveRoutine, Off
Hotkey, Esc, EscapeHandler, Off 

F8::
    if (isTracking) {
        isTracking := false
        ToolTip, Autobuild Deactivated
        SetTimer, RemoveToolTip, -1000
        
        Hotkey, ~LButton & Shift, Off
        Hotkey, ~Shift & LButton, Off
        Hotkey, Esc, Off  
    } else {
        isTracking := true
        ToolTip, Autobuild Activated
        SetTimer, RemoveToolTip, -1000
        
        Hotkey, ~LButton & Shift, On
        Hotkey, ~Shift & LButton, On
        Hotkey, Esc, On  
    }
return

EscapeHandler:  
    terminateLoop := true
    ToolTip, Building Halted
    SetTimer, RemoveToolTip, -1000
return

MouseMoveRoutine:
    terminateLoop := false

    MouseGetPos, startX, startY
    
    Loop {
        if !GetKeyState("LButton", "P")
            break
        MouseGetPos, dragEndX, dragEndY
        Sleep, 10
    }
    
    targetXDisplacement := dragEndX - startX
    targetYDisplacement := dragEndY - startY
    
    xMultiplier := (targetXDisplacement >= 0) ? 1 : -1
    yMultiplier := (targetYDisplacement >= 0) ? -1 : 1  ; Inverted Y axis
    
    directionStr := (yMultiplier = 1) ? "Up" : "Down"
    directionStr .= (xMultiplier = 1) ? "right" : "left"
    SetTimer, RemoveToolTip, -1000
    
    MouseMove, startX, startY, 0
    
    currentX := startX
    currentY := startY
    totalXDisplacement := 0
    totalYDisplacement := 0
    
    ; Set mouse speed
    SetMouseDelay, 1
    
    Click
        
    ; 37 up
    MouseMove, currentX, currentY - (37 * yMultiplier), 0
    currentY := currentY - (37 * yMultiplier)
    totalYDisplacement -= (37 * yMultiplier)
    Click

    ; 37 down and 73 right
    MouseMove, currentX + (73 * xMultiplier), currentY + (37 * yMultiplier), 0
    currentX := currentX + (73 * xMultiplier)
    currentY := currentY + (37 * yMultiplier)
    totalXDisplacement += (73 * xMultiplier)
    totalYDisplacement += (37 * yMultiplier)
    Click

    ; 19 up and 37 right
    MouseMove, currentX + (37 * xMultiplier), currentY - (19 * yMultiplier), 0
    currentX := currentX + (37 * xMultiplier)
    currentY := currentY - (19 * yMultiplier)
    totalXDisplacement += (37 * xMultiplier)
    totalYDisplacement -= (19 * yMultiplier)
    Click


    Loop {
        if (terminateLoop) {
            terminateLoop := false  ; Reset flag
            break
        }

        ; 37 up and 73 left
        MouseMove, currentX - (73 * xMultiplier), currentY - (37 * yMultiplier), 0
        currentX := currentX - (73 * xMultiplier)
        currentY := currentY - (37 * yMultiplier)
        totalXDisplacement -= (73 * xMultiplier)
        totalYDisplacement -= (37 * yMultiplier)
        Click

        ; 37 down
        MouseMove, currentX, currentY + (37 * yMultiplier), 0
        currentY := currentY + (37 * yMultiplier)
        totalYDisplacement += (37 * yMultiplier)
        Click

        ; 55 up and 37 right
        MouseMove, currentX + (37 * xMultiplier), currentY - (55 * yMultiplier), 0
        currentX := currentX + (37 * xMultiplier)
        currentY := currentY - (55 * yMultiplier)
        totalXDisplacement += (37 * xMultiplier)
        totalYDisplacement -= (55 * yMultiplier)
        Click

        ; 37 down and 73 right
        MouseMove, currentX + (73 * xMultiplier), currentY + (37 * yMultiplier), 0
        currentX := currentX + (73 * xMultiplier)
        currentY := currentY + (37 * yMultiplier)
        totalXDisplacement += (73 * xMultiplier)
        totalYDisplacement += (37 * yMultiplier)
        Click

        ; 73 left
        MouseMove, currentX - (73 * xMultiplier), currentY, 0
        currentX := currentX - (73 * xMultiplier)
        totalXDisplacement -= (73 * xMultiplier)
        Click

        ; 19 up and 109 right
        MouseMove, currentX + (109 * xMultiplier), currentY - (19 * yMultiplier), 0
        currentX := currentX + (109 * xMultiplier)
        currentY := currentY - (19 * yMultiplier)
        totalXDisplacement += (109 * xMultiplier)
        totalYDisplacement -= (19 * yMultiplier)
        Click
        
        ; Small counter-movement at end of loop
        MouseMove, currentX - (2 * xMultiplier), currentY + (1 * yMultiplier), 0
        currentX := currentX - (2 * xMultiplier)
        currentY := currentY + (1 * yMultiplier)
        totalXDisplacement -= (2 * xMultiplier)
        totalYDisplacement += (1 * yMultiplier)
        
        if (Abs(totalXDisplacement) > Abs(targetXDisplacement) || Abs(totalYDisplacement) > Abs(targetYDisplacement))
            break
    }
return

RemoveToolTip:
    ToolTip
return
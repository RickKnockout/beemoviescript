#Requires AutoHotkey v2.0
#HotIf WinActive("EVE")
; F6 to start, F7 to stop
; === SETTINGS ===
filePath := "script.txt"
delayMs := Random(500,1500)
focusHotkey := "{F15}" ; Set Chat Channel Focus hotkey in EVE options

global stop := false

; === STOP KEY ===
F7::
{
    global stop
    stop := true
}

; === MAIN HOTKEY ===
F6::
{
    global stop
    stop := false

    if !FileExist(filePath) {
        MsgBox "File not found: " filePath
        return
    }

    content := FileRead(filePath)
    lines := StrSplit(content, "`n")

    for line in lines {

        if (stop)
            break

        line := Trim(line, "`r`n`t ")
        if (line = "")
            continue

        ; Focus window
        Send focusHotkey
        Sleep 100

        if (stop)
            break

        ; Send text
        SendText line
        Send "{Enter}"

        elapsed := 0
        while (elapsed < delayMs) {
            if (stop)
                break
            Sleep 50
            elapsed += 50
        }

        if (stop)
            break
    }

    if (stop)
        ToolTip "Stopped."
    else
        ToolTip "Done."

    SetTimer () => ToolTip(), -1000
}

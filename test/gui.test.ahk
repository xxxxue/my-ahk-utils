#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        temp_w := 499
        temp_arr := [
            "w" temp_w,
            "h399",
        ]
        __Assert GuiUtil.createControlOptions(temp_arr), "w499 h399"
    }
} catch Error as e {
    throw e
}

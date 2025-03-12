#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        __Assert KeyUtil.virtualKeyToKeyName("9"), "Tab"
    }
    {
        __Assert KeyUtil.scanCodeToKeyName("15"), "Tab"
    }
} catch Error as e {
    throw e
}

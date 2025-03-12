#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        __Assert NumberUtil.convert_10To16("30"), "1E"
    }
    {
        __Assert NumberUtil.convert_10To16_0x("30"), "0x1e"
    }
    {
        __Assert NumberUtil.convert_16To10("0x1E"), 30
    }
} catch Error as e {
    throw e
}

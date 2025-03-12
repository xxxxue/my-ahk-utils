#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        __Assert PathUtil.concat("c:\cbs\", "\dds"), "c:\cbs\dds"
        __Assert PathUtil.concat(["c:\cbs\", "\dds"]*), "c:\cbs\dds"
        __Assert PathUtil.concat("c:/cbs/", "\dds"), "c:\cbs\dds"
        __Assert PathUtil.concat("c:\cbs\", "\dds\"), "c:\cbs\dds"
        __Assert PathUtil.concat("c:", "dds", "ad"), "c:\dds\ad"
        __Assert PathUtil.concat("c:", "dds\", "ad"), "c:\dds\ad"
        __Assert PathUtil.concat("c:", "dds", "ad\"), "c:\dds\ad"
        __Assert PathUtil.concat("c:\", "\dds\", "\ad"), "c:\dds\ad"
        __Assert PathUtil.concat(".\", "dds", "ad"), ".\dds\ad"
        __Assert PathUtil.concat(".\\", "//dds//", "\ad"), ".\dds\ad"
        __Assert PathUtil.concat("c:\//aa\///////bbb\\\\\\\\\\\abc.txt"), "c:\aa\bbb\abc.txt"
    }
    {
        __Assert PathUtil.getRelativePath("c:\aaa\bbb/\abc.txt", "c:\aaa"), "bbb\abc.txt"
        __Assert PathUtil.getRelativePath("c:\aaa/\bbb\abc.txt", "c:\aaa\"), "bbb\abc.txt"
        __Assert PathUtil.getRelativePath("c:/\aaa/\\\bbb\/\\abc.txt", "c:\aaa\\\"), "bbb\abc.txt"
    }
} catch Error as e {
    throw e
}

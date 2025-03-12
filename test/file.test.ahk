#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        __Assert FileUtil.fileGetExtName("c:\\abc/\ddd//efs.txt"), "txt"
        __Assert FileUtil.fileGetExtName("c:\\abc/\ddd//efs.txt", true), ".txt"
        __Assert FileUtil.fileGetExtName("efs.txt", true), ".txt"
    }
    {
        __Assert FileUtil.fileGetName("c:/\abc/\ddd\\efs.txt"), "efs.txt"
        __Assert FileUtil.fileGetName("c:\abc\ddd\efs.txt", false), "efs"
        __Assert FileUtil.fileGetName("c:/\abc/\ddd"), "ddd"
    }
    {
        __Assert FileUtil.dirGetName("c:/\abc/\ddd"), "ddd"
    }
    {
        __Assert FileUtil.fileGetParentDirName("c:/\abc\\ddd/\efs.txt"), "c:\abc\ddd"
    }
    {
        __Assert FileUtil.dirGetParentDirName("c:/\abc\\ddd/\"), "c:\abc"
    }
    ; NOTE: 由于 ahk 会把所有脚本合并到执行的脚本中,所以相对路径是以执行的脚本为目标
    ; ../ 是执行当前的脚本才有效, 如果执行的是 test-all.ahk 则需要改为./
    {
        __Assert FileUtil.isFile("./"), false
        __Assert FileUtil.isFile("./README.md"), true
    }
    {
        __Assert FileUtil.isDir("./"), true
        __Assert FileUtil.isDir("./README.md"), false
    }
} catch Error as e {
    throw e
}

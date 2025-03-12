#Include "array.ahk"
#Include "object.ahk"
#Include "string.ahk"
/**
 * 传入若干个参数,打印这些参数并换行,参数之间空格分隔
 * @param {Array} params 
 */
p(params*) {
    ; static is_open_console := false
    ; if !is_open_console {
    ;     DllCall("AllocConsole")
    ;     is_open_console := true
    ; }
    ; stdout := FileOpen("*", "w", "UTF-8")
    ; arr := []
    ; for item in params {
    ;     item_msg := ""
    ;     if item is Array {
    ;         item_msg := ArrayUtil.toString(item)
    ;     } else if (item is Object) {
    ;         item_msg := ObjectUtil.toString(item)
    ;     } else if (item is Map) {
    ;         item_msg := MapUtil.toString(item)
    ;     } else {
    ;         item_msg := String(item)
    ;     }
    ;     arr.Push(item_msg)
    ; }
    ; text := ArrayUtil.join(arr, " ") . "`n"
    ; stdout.Write(text)
    MyUtil.print(params*)
}
class MyUtil {
    /**
     * 获取本地操作系统的语言 中文是 zh-CN
     */
    static getLocaleLanguage() {
        LOCALE_NAME_MAX_LENGTH := 85
        lpLocaleName := Buffer(bufferSize := LOCALE_NAME_MAX_LENGTH * A_PtrSize, 0)
        length := DllCall("Kernel32\GetUserDefaultLocaleName", "Ptr", lpLocaleName.Ptr, "Int", cchLocaleName := LOCALE_NAME_MAX_LENGTH, "Int")
        return StrGet(lpLocaleName.Ptr, length, "UTF-16")
    }
    static openConsole() {
        if !DllCall("GetStdHandle", "uint", -11, "ptr")
            DllCall("AllocConsole")
    }
    static hasConsole() {
        return DllCall("GetStdHandle", "uint", -11, "ptr")
    }
    /**
     * 传入若干个参数,打印这些参数并换行,参数之间空格分隔
     * @param {Array} params 
     */
    static print(params*) {
        arr := []
        for item in params {
            item_msg := ""
            if item is Array {
                item_msg := ArrayUtil.toString(item)
            } else if (item is Object) {
                item_msg := ObjectUtil.toString(item)
            } else if (item is Map) {
                item_msg := MapUtil.toString(item)
            } else {
                item_msg := String(item)
            }
            arr.Push(item_msg)
        }
        text := ArrayUtil.join(arr, " ") . "`n"
        FileAppend(text, "*", "UTF-8")
    }
    static printJson(params*) {
        if !DllCall("GetStdHandle", "uint", -11, "ptr") {
            ; OpenConsole()
            return
        }
        output := ""
        for item in params {
            item_msg := ""
            switch {
                case item is Array, item is Object, item is Map:
                    item_msg := JSON.stringify(item)
                default:
                    item_msg := String(item)
            }
            output := StringUtil.concat(output, item_msg, " ")
        }
        output := StringUtil.concat(output, "`n")
        FileAppend(output, "*", "UTF-8")
    }
    /**
     * 执行命令 并获取内容 
     * 
     * (结果中可能有 \`r\`n 换行符,如果有影响,需要替换掉)
     * 
     * { Output:Number, ExitCode:String }
     * @param sCmd 命令
     * @param sDir 
     * @param sEnc 
     * @example
     * ;执行一个 nodejs 脚本 并返回结果
     * ("node aaa.js")
     */
    static execCommandToVar(sCmd, sDir := "", sEnc := "CP0") {
        ; Create 2 buffer-like objects to wrap the handles to take advantage of the __Delete meta-function.
        oHndStdoutRd := { Ptr: 0, __Delete: delete(this) => DllCall("CloseHandle", "Ptr", this) }
        oHndStdoutWr := { Base: oHndStdoutRd }
        if !DllCall("CreatePipe"
            , "PtrP", oHndStdoutRd
            , "PtrP", oHndStdoutWr
            , "Ptr", 0
            , "UInt", 0)
            throw OSError(, , "Error creating pipe.")
        if !DllCall("SetHandleInformation"
            , "Ptr", oHndStdoutWr
            , "UInt", 1
            , "UInt", 1)
            throw OSError(, , "Error setting handle information.")
        PI := Buffer(A_PtrSize == 4 ? 16 : 24, 0)
        SI := Buffer(A_PtrSize == 4 ? 68 : 104, 0)
        NumPut("UInt", SI.Size, SI, 0)
        NumPut("UInt", 0x100, SI, A_PtrSize == 4 ? 44 : 60)
        NumPut("Ptr", oHndStdoutWr.Ptr, SI, A_PtrSize == 4 ? 60 : 88)
        NumPut("Ptr", oHndStdoutWr.Ptr, SI, A_PtrSize == 4 ? 64 : 96)
        if !DllCall("CreateProcess"
            , "Ptr", 0
            , "Str", sCmd
            , "Ptr", 0
            , "Ptr", 0
            , "Int", True
            , "UInt", 0x08000000
            , "Ptr", 0
            , "Ptr", sDir ? StrPtr(sDir) : 0
            , "Ptr", SI
            , "Ptr", PI)
            throw OSError(, , "Error creating process.")
        ; The write pipe must be closed before reading the stdout so we release the object.
        ; The reading pipe will be released automatically on function return.
        oHndStdOutWr := ""
        ; Before reading, we check if the pipe has been written to, so we avoid freezings.
        nAvail := 0, nLen := 0
        while DllCall("PeekNamedPipe"
            , "Ptr", oHndStdoutRd
            , "Ptr", 0
            , "UInt", 0
            , "Ptr", 0
            , "UIntP", &nAvail
            , "Ptr", 0) != 0 {
            ; If the pipe buffer is empty, sleep and continue checking.
            if !nAvail && Sleep(100)
                continue
            cBuf := Buffer(nAvail + 1)
            DllCall("ReadFile"
                , "Ptr", oHndStdoutRd
                , "Ptr", cBuf
                , "UInt", nAvail
                , "PtrP", &nLen
                , "Ptr", 0)
            sOutput .= StrGet(cBuf, nLen, sEnc)
        }
        ; Get the exit code, close all process handles and return the output object.
        DllCall("GetExitCodeProcess"
            , "Ptr", NumGet(PI, 0, "Ptr")
            , "UIntP", &nExitCode := 0)
        DllCall("CloseHandle", "Ptr", NumGet(PI, 0, "Ptr"))
        DllCall("CloseHandle", "Ptr", NumGet(PI, A_PtrSize, "Ptr"))
        return { Output: sOutput, ExitCode: nExitCode }
    }
    /**
     * 设置亮度
     * @param {Integer} p_value 亮度值
     * @returns {Integer} 是否成功 true / false
     */
    static setBrightnessValue(p_value) {
        ; 不合规的值,改为默认值
        if (!(0 < p_value && p_value <= 100)) {
            p_value := 10
            current_brightness := 10
        }
        set_brightness_cmd := 'powershell (Get-WmiObject -Namespace root/wmi -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,' p_value ')'
        cmd_out := MyUtil.execCommandToVar(set_brightness_cmd)
        return cmd_out.ExitCode == 0
    }
    /**
     * 获取亮度
     */
    static getBrightnessValue() {
        get_brightness_cmd := 'powershell (Get-WmiObject -Namespace root/wmi -Class WmiMonitorBrightness).CurrentBrightness'
        cmd_out := MyUtil.execCommandToVar(get_brightness_cmd)
        if cmd_out.ExitCode == 0 {
            value := StringUtil.replace(cmd_out.Output, "`r`n", "")
            return Integer(value)
        }
        return 0
    }
}
class GroupUtil {
    /**
     * 批量添加到 group
     * @param {String} p_group_name 
     * @param {Array} p_group_item_arr 
     */
    static addArray(p_group_name, p_group_item_arr) {
        for id, value IN p_group_item_arr {
            GroupAdd(p_group_name, value)
        }
    }
}
; 这里主要复写ToString方法即可,其他的不做处理
class MapUtil {
    static toString(m) {
        return "Map(" ({}).ToString.Bind(m)() ")"
    }
}
; 符号链接
class SymbolicLinkUtil {
    static Create(destinationPath, sourcePath, isDir := false) {
        ; Ensure paths are absolute and clean
        sourcePath := this.GetFullPath(sourcePath)
        destinationPath := this.GetFullPath(destinationPath)
        ; Check if destination directory exists
        destDir := RegExReplace(destinationPath, "\\[^\\]+$")
        if !DirExist(destDir) {
            try DirCreate(destDir)
            catch as e {
                return { success: false, error: "Cannot create destination directory: " e.Message }
            }
        }
        ; Check for and remove existing link/file
        if FileExist(destinationPath) {
            try {
                attributes := FileGetAttrib(destinationPath)
                if InStr(attributes, "L")  ; It's a symbolic link
                    RunWait('cmd.exe /c rmdir "' destinationPath '"', , "Hide")
                else
                    FileDelete(destinationPath)
            }
            catch as e {
                return { success: false, error: "Cannot remove existing file: " e.Message }
            }
        }
        ; Attempt to create symbolic link
        try {
            if this.HasAdminRights() {
                ; Direct method if we have admin rights
                result := DllCall("Kernel32.dll\CreateSymbolicLinkW",
                    "Str", destinationPath,
                    "Str", sourcePath,
                    "UInt", isDir ? 1 : 0)
                if (result)
                    return { success: true }
            } else {
                ; Fallback to elevated CMD if we don't have admin rights
                command := 'cmd.exe /c mklink ' (isDir ? '/D ' : '')
                . '"' destinationPath '" "'
                . sourcePath '"'
                RunWait(command, , "Hide")
                if FileExist(destinationPath)
                    return { success: true }
            }
        }
        catch as e {
            return { success: false, error: "Failed to create symbolic link: " e.Message }
        }
        return { success: false, error: "Unknown error creating symbolic link" }
    }
    static Remove(linkPath) {
        if !FileExist(linkPath)
            return { success: true }  ; Already gone
        try {
            attributes := FileGetAttrib(linkPath)
            if InStr(attributes, "L") {  ; It's a symbolic link
                RunWait('cmd.exe /c rmdir "' linkPath '"', , "Hide")
            } else {
                FileDelete(linkPath)
            }
            return { success: true }
        }
        catch as e {
            return { success: false, error: "Failed to remove link: " e.Message }
        }
    }
    static GetFullPath(path) {
        ; Convert relative path to absolute
        if (SubStr(path, 1, 1) = ".")
            path := A_WorkingDir "\" path
        return RegExReplace(path, "\\+", "\")  ; Clean up multiple backslashes
    }
    static HasAdminRights() {
        try {
            return DllCall("shell32\IsUserAnAdmin")
        }
        catch {
            return false
        }
    }
    static IsSymlink(path) {
        if !FileExist(path)
            return false
        try {
            attributes := FileGetAttrib(path)
            return InStr(attributes, "L")
        }
        catch {
            return false
        }
    }
}
class PathUtil {
    /**
     * 连接路径,这个函数会处理一些一些麻烦情况,路径的最后一定不含\
     * @param {String*} params 多个字符串, 或 数组, 数组需要用 星号 展开 (['a','b']*)
     * 
     * @example
     * ("c:\cbs\", "\dds"), "c:\cbs\dds"
     * (["c:\cbs\", "\dds"]*), "c:\cbs\dds"
     * ("c:/cbs/", "\dds"), "c:\cbs\dds"
     * ("c:\cbs\", "\dds\"), "c:\cbs\dds"
     * ("c:", "dds", "ad"), "c:\dds\ad"
     * ("c:", "dds\", "ad"), "c:\dds\ad"
     * ("c:", "dds", "ad\"), "c:\dds\ad"
     * ("c:\", "\dds\", "\ad"), "c:\dds\ad"
     * (".\", "dds", "ad"), ".\dds\ad"
     * (".\\", "//dds//", "\ad"), ".\dds\ad"
     * ("c:\//aa\///////bbb\\\\\\\\\\\abc.txt"), "c:\aa\bbb\abc.txt"
     * @returns {String}
     */
    static concat(params*) {
        arr := []
        for id, value IN params {
            ; 移除左右的 "/" "\"
            data := StringUtil.trim(value, "\")
            data := StringUtil.trim(data, "/")
            ; 替换中间的 为 "\"
            data := RegExReplace(data, "/\+", "\")
            data := RegExReplace(data, "\/+", "\")
            data := RegExReplace(data, "\\+", "\")
            data := RegExReplace(data, "/+", "\")
            arr.Push(data)
        }
        ; 在每个项之间加入 "\"
        return ArrayUtil.join(arr, "\")
    }

    /**
     * 获取相对路径
     * @param p_path_1 
     * @param p_path_2 
     * @example
     * ("c:\cbs\dds\hhh\abc.txt", "c:\cbs\dds"), "hhh\abc.txt"
     * @returns {String}
     */
    static getRelativePath(p_path_1, p_path_2) {
        p_path_1 := PathUtil.concat(p_path_1)
        p_path_2 := PathUtil.concat(p_path_2)
        result := StringUtil.trimStart(StringUtil.replace(p_path_1, p_path_2, ""), "\")
        return result
    }
}
class ClipboardUtil {
    /**
     * 获取当前选择的文本
     * @param p_command 
     */
    static getSelectedText(p_command := "^c") {
        ; 备份当前的剪贴板内容
        backup := ClipboardAll()
        ; 清空变量
        A_Clipboard := ''
        ; 发送命令 (默认:复制 (可以传参,比如 ^v 剪切)
        Send(p_command)
        ; 等待剪贴板, 获取到新数据后,把剪贴板恢复到旧数据
        if !ClipWait(1, 1)
            return (A_Clipboard := backup)
        txt := A_Clipboard
        A_Clipboard := backup
        return txt
    }
}

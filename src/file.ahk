#Include "string.ahk"
#Include "array.ahk"
#Include "utils.ahk"
class FileUtil {

    /**
     * 写入文件 (文件不存在会创建)
     * 
     * 如果想要写入多行数据,请用 fileWriteAllLines,会用换行符分割
     * 
     * 如果是对象或者其他,请先转为 JSON 字符串再调用这个方法
     * @param {String | Object | Array} p_data 数据
     * @param {String} p_file_path 文件路径
     */
    static fileWrite(p_data, p_file_path) {
        ; 存在则删除
        if FileExist(p_file_path) {
            ; 删除文件 (默认是追加数据,所以要先删除)
            FileDelete(p_file_path)
        }
        ; 创建文件并写入数据
        FileAppend(p_data, p_file_path, "UTF-8")
    }

    /**
     * 写入文件 (文件不存在会创建)
     * 支持数组,会转为用换行符分割的字符串,再存储
     * @param {String | Object | Array} p_data 数据
     * @param {String} p_file_path 文件路径
     */
    static fileWriteAllLines(p_data, p_file_path) {
        file_data := p_data
        ; 数组 转为 字符串, 其他类型不受影响,直接存
        if p_data is Array {
            separator := "`r`n"
            file_data := ArrayUtil.join(p_data, separator)
        }
        FileUtil.fileWrite(file_data, p_file_path)
    }
    /**
     * 读取文件 (文件不存在会创建)
     * 
     * 如果是是用换行符分割的,请使用 fileReadAllLines
     * @param {String} p_file_path 
     * @param {Func} p_default_data_fn 延迟调用,防止提前计算
     * @returns {String | Object}
     */
    static fileRead(p_file_path, p_default_data_fn := unset) {
        if !FileExist(p_file_path) {
            default_data := ""
            if IsSet(p_default_data_fn) {
                default_data := p_default_data_fn()
            }
            FileUtil.fileWrite(default_data, p_file_path)
        }
        file_data := FileRead(p_file_path, "UTF-8")
        return file_data
    }

    /**
     * 读取文件 (文件不存在会创建)
     * 
     * 一定要是可以用 "\r\n" 换行符分割的, 其他类型请使用 fileRead / 标准库的 FileRead
     * @param {String} p_file_path 
     * @param {Func} p_default_data_fn 延迟调用,防止提前计算
     * @returns {Array}
     */
    static fileReadAllLines(p_file_path, p_default_data_fn := unset) {
        if !FileExist(p_file_path) {
            default_data := ""
            if IsSet(p_default_data_fn) {
                default_data := p_default_data_fn()
            }
            FileUtil.fileWriteAllLines(default_data, p_file_path)
        }
        file_data := FileRead(p_file_path, "UTF-8")
        separator := "`r`n"
        file_data_arr := StringUtil.split(file_data, separator)
        return file_data_arr
    }

    /**
     * 获取文件的扩展名
     * @param {String} pathStr 
     * @param {Boolean} p_retain_dot 是否保留 "点"
     * @example
     * __FileGetExtName("c:\\abc/\ddd//efs.txt") ;"txt"
     * __FileGetExtName("c:\\abc/\ddd//efs.txt", true) ;".txt"
     * __FileGetExtName("efs.txt", true) ;".txt"
     * @returns {String} 
     */
    static fileGetExtName(p_path_str, p_retain_dot := false) {
        ; 处理一些不合规的情况
        data := PathUtil.concat(p_path_str)
        ; 取出倒数第一个值
        temp := StrSplit(data, "\")[-1]
        arr := StringUtil.split(temp, ".")
        ; 无效的情况, 返回空
        if ArrayUtil.length(arr) <= 1 || (ArrayUtil.length(arr) == 2 && arr[1] == "") {
            return ""
        }
        return p_retain_dot ? "." arr[-1] : arr[-1]
    }

    /**
     * 获取 文件名
     * @param {String} p_path_str 
     * @param {Boolean} p_retain_suffix 保留扩展名
     * 
     * @example
     * __FileGetName("c:/\abc/\ddd\\efs.txt") ;"efs.txt"
     * __FileGetName("c:\abc\ddd\efs.txt", false) ;"efs"
     * __FileGetName("c:/\abc/\ddd") ;"ddd"
     * @returns {String} 
     */
    static fileGetName(p_path_str, p_retain_suffix := true) {
        ; 处理一些不合规的情况
        data := PathUtil.concat(p_path_str)
        ; 取出倒数第一个值
        temp := StrSplit(data, "\")[-1]

        return p_retain_suffix ? temp : StringUtil.split(temp, ".")[1]
    }

    /**
     * 获取文件夹名
     * @param {String} p_path_str 
     * @example
     * __DirGetName("c:/\abc/\ddd") ;"ddd"
     * @returns {String} 
     */
    static dirGetName(p_path_str) {
        return FileUtil.fileGetName(p_path_str)
    }

    /**
     * 获取路径的文件夹路径 ( 本质是去掉最后一级 )
     * @param {String} pathStr 
     * @example
     * __FileGetParentDirName("c:\abc\ddd\efs.txt") ;"c:\abc\ddd"
     * @returns {String} 
     */
    static fileGetParentDirName(pathStr) {

        ; 处理一些不合规的情况
        data := PathUtil.concat(pathStr)

        path_arr := StringUtil.split(data, "\")
        ; 截取, 去掉最后一个
        arr := ArrayUtil.slice(path_arr, 1, -2)

        if ArrayUtil.length(arr) == 0 {
            return ""
        }

        return ArrayUtil.join(arr, "\")
    }
    /**
     * 获取文件夹的上一级文件夹 ( 本质是去掉最后一级 )
     * @param {String} pathStr 
     * @example
     * __DirGetParentDirName("c:/\abc\\ddd/\") ;"c:\abc"
     * @returns {String} 
     */
    static dirGetParentDirName(pathStr) {
        return FileUtil.fileGetParentDirName(pathStr)
    }

    /**
     * 文件删除
     * 
     * 核心逻辑: 先判断存在, 然后删除
     * @param p_path 
     */
    static fileDelete(p_path) {
        if FileExist(p_path) {
            FileDelete(p_path)
        }
    }
    /**
     * 文件夹不存在 则 创建
     * @param p_dir_path 
     */
    static dirCreateIfNoExist(p_dir_path) {
        if !DirExist(p_dir_path) {
            DirCreate(p_dir_path)
        }
    }

    /**
     * 同级目录备份旧文件,并删除本体
     * @param p_file_path 文件地址
     * @param p_append_name 备份文件的追加名称
     */
    static fileBackupAndDelete(p_file_path, p_append_name := "-" A_Now) {
        if FileExist(p_file_path) {
            FileCopy(p_file_path, p_file_path p_append_name)
            FileDelete(p_file_path)
        }
    }

    /**
     * 是否是文件
     * @param p_path_or_attr 路径 / FileGetAttrib(...)
     * @param p_is_path 如果提前使用 FileGetAttrib 获取了属性,这里要传入 false
     * @returns {Integer} true / false
     */
    static isFile(p_path_or_attributes, p_is_path := true) {
        return FileUtil.includesAttrib(p_path_or_attributes, "A", p_is_path)
    }
    /**
     * 是否是文件夹
     * @param p_path_or_attr 路径 / FileGetAttrib(...)
     * @param p_is_path 如果提前使用 FileGetAttrib 获取了属性,这里要传入 false
     * @returns {Integer} true / false
     */
    static isDir(p_path_or_attributes, p_is_path := true) {
        return FileUtil.includesAttrib(p_path_or_attributes, "D", p_is_path)
    }
    /**
     * 检查一个 地址/文件属性字符串 是否包含某个属性
     * @param p_path_or_attributes 路径 / FileGetAttrib(...)
     * @param p_attr 要检查的属性
     * @param p_is_path 如果提前使用 FileGetAttrib 获取了属性,这里要传入 false
     * @returns {Integer} true / false
     */
    static includesAttrib(p_path_or_attributes, p_attrib, p_is_path := true) {
        attr := p_path_or_attributes
        if (p_is_path) {
            attr := FileGetAttrib(p_path_or_attributes)
        }
        return StringUtil.includes(attr, p_attrib)
    }
}

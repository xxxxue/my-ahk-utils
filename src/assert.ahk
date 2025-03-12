#Include "array.ahk"
#Include "string.ahk"
#Include "utils.ahk"
#Include "json.ahk"
__Assert(data, true_data) {
    ; 两个数组
    if data is Array && true_data is Array {
        __AssertArray(data, true_data)
        return
    }
    ; 异常: 不同类型
    if Type(data) != Type(true_data) {
        p "type error: " Type(data) "___" Type(true_data)
        throw "type error: " Type(data) "___" Type(true_data)
    }
    ; 异常: 两个值不相等
    if (
        data != true_data
        || StringUtil.toCode(data) != StringUtil.toCode(true_data)
    ) {
        p "error: [" data "] : [" true_data "]"
        throw "error: [" data "] : [" true_data "]"
    }
}
/**
 * @param {Array} arr 
 * @param {Array} true_arr 
 */
__AssertArray(arr, true_arr) {
    error_index := -1
    error_value := ""
    error_true_value := ""
    error_msg := ""
    ; 必须是两个数组
    if arr is Array && true_arr is Array {
        ; item 数量必须相同
        if ArrayUtil.length(arr) == ArrayUtil.length(true_arr) {
            for index, value IN arr {
                true_value := true_arr[index]
                ; 两个值 和 类型 都必须相同
                if (Type(value) != Type(true_value)
                || StringUtil.toCode(value) != StringUtil.toCode(true_value)) {
                    error_index := index
                    error_value := value is String ? StringUtil.toString(value) : value
                    error_true_value := true_value is String ? StringUtil.toString(true_value) : true_value
                    error_msg := "array error: error_index: " error_index ", error_value: " error_value ", true_value: " error_true_value
                    break
                }
            }
        } else {
            ; 长度不同,直接报错
            error_msg := "array error: 具体内容看输出区域, length:" ArrayUtil.length(arr) "->" ArrayUtil.length(true_arr)
            p arr
            p true_arr
        }
    } else {
        error_msg := "参数类型不是数组:" Type(arr) "___" Type(true_arr)
    }
    ; 如果有错误信息,就抛出异常
    if StrLen(error_msg) > 0 {
        p error_msg
        throw error_msg
    }
}

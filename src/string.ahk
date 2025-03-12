#Include "array.ahk"
class StringUtil {
    /**
     * 获取变量名
     * @param value 变量的引用
     * @example
     * name:="a"
     * (&name) ;name
     * @returns {String}
     */
    static nameOf(&value) {
        return StrGet(NumGet(ObjPtr(&value) + 8 + 6 * A_PtrSize, 'Ptr'), 'UTF-16')
    }
    /**
     * 移除字符串中的某个子字符串
     * @param {String} str
     * @param {String} value 要移除的字符串
     * @example
     * ("abc", "b"), "ac"
     * ("abcb", "b"), "ac"
     * ("abc", "c"), "ab"
     * @returns {String} 
     */
    static remove(str, value) {
        if value == "" {
            return str
        }
        return StrReplace(str, value, unset, true)
    }
    /**
     * 移除字符串左边的子字符串,如果左边不匹配就不管
     * @param {String} str
     * @param {String} value 要移除的左边的字符串
     * @example
     * ("a5bc", "a"), "5bc"
     * ("abca", "a"), "bca"
     * ("abc", "b"), "abc"
     * ("abc", "c"), "abc"
     * @returns {String} 
     */
    static removeLeft(str, value) {
        if value == "" {
            return str
        }
        if StringUtil.startsWith(str, value) {
            return StringUtil.subString(str, StrLen(value) + 1, -1)
        }
        return str
    }
    /**
     * 移除字符串右边的子字符串,如果右边不匹配就不管
     * @param {String} str
     * @param {String} value 
     * @example
     * ("ac3c", "c"), "ac3"
     * ("abc", "b"), "abc"
     * ("abc", "a"), "abc"
     * @returns {String} 
     */
    static removeRight(str, value) {
        if value == "" {
            return str
        }
        if StringUtil.endsWith(str, value) {
            return StringUtil.subString(str, 1, StrLen(str) - StrLen(value))
        }
        return str
    }
    /**
     * 返回指定字符串的长度, 如果长度已够原样返回, 长度不够则从开始填充, 填充过程可能截断 strFill
     * @param {String} str
     * @param {Integer} num 指定要返回的字符串长度
     * @param {String} strFill 不够长度时用来填充的字符串
     * @example
     * ("123", 6, "z"), "zzz123"
     * ("12", 10, "YYYY-MM-DD"), "YYYY-MM-12"
     * ("09-12", 10, "YYYY-MM-DD"), "YYYY-09-12"
     * @returns {String} 
     */
    static padStart(str, num, fillStr := " ") {
        output := ""
        len := StrLen(str)
        fillLen := StrLen(fillStr)
        if len >= num {
            return str
        }
        if (mul := (num - len) // fillLen) >= 1 {
            output := StringUtil.concat(StringUtil.repeat(fillStr, mul), str)
        } else {
            output := str
        }
        output := StringUtil.concat(StringUtil.subString(fillStr, 1, num - StrLen(output)), output)
        return output
    }
    /**
     * 返回指定字符串的长度, 如果长度已够原样返回, 长度不够则从结尾填充, 填充过程可能截断strFill
     * @param {String} str
     * @param {Integer} num 指定要返回的字符串长度
     * @param {String} strFill 不够长度时用来填充的字符串
     * @example
     * ("xxx123", 2, "ab"), "xxx123"
     * ("12", 10, "YYYY-MM-DD"), "12YYYY-MM-"
     * ("09-12", 10, "YYYY-MM-DD"), "09-12YYYY-"
     * @returns {String} 
     */
    static padEnd(str, num, fillStr := " ") {
        output := ""
        len := StrLen(str)
        fillLen := StrLen(fillStr)
        if len >= num {
            return str
        }
        if (mul := (num - len) // fillLen) >= 1 {
            output := StringUtil.concat(str, StringUtil.repeat(fillStr, mul))
        } else {
            output := str
        }
        output := StringUtil.concat(output, StringUtil.subString(fillStr, 1, num - StrLen(output)))
        return output
    }
    /**
     * 返回重复字符串
     * @param str 
     * @param {Integer} count 重复次数
     * @example
     * ("a",3) ;"aaa"
     * ("hello",2) ;"hellohello"
     * @returns {String} 
     */
    static repeat(str, count) {
        o := ''
        loop count
            o := o . str
        return o
    }
    /**
     * 让 for 支持遍历字符串
     * @param {String} str 
     * @param {Number} paramNum for 需要的参数数量 (1 值 , 2 索引与值)
     * @example
     * for item in StringUtil.forEnumerator(str,1)
     * for index, item in StringUtil.forEnumerator(str, 2)
     * @returns {Closure} 一个可以被 for 调用的方法
     */
    static forEnumerator(str, paramNum) {
        index := 0
        len := StrLen(str)
        return Enumerator
        Enumerator(&k, &v?) {
            char := SubStr(str, ++index, 1)
            if paramNum == 1 {
                k := char
            } else {
                k := index
                v := char
            }
            return index <= len
        }
    }
    /**
     * 获取字符串的内容
     * @param {String} str
     * @param {Integer} start_index 开始的索引  可以为负数, 内部会转为真实的索引
     * @param {Integer} end_index 结束索引 (可空,默认为 开始索引+1)   可以为负数, 内部会转为真实的索引
     * @example
     * ("1234567", -3, 2), "2345" ;ahk索引从 1 开始, 倒数第三个是索引 5, 所以结果为索引 2 到 索引 5 的字符
     * ("1234567", 2, 4), "234"
     * @returns {String}
     */
    static subString(str, params*) {
        len := StrLen(str)
        ; 将负数索引, 转为 真实的索引
        for index, item in params {
            if item < 0 {
                params[index] := len + item + 1
            }
        }
        if ArrayUtil.length(params) == 1 {
            return SubStr(str, params[1], 1)
        } else if ArrayUtil.length(params) == 2 {
            if params[1] > params[2] {
                start := params[2]
                end := params[1]
            } else {
                start := params[1]
                end := params[2]
            }
            ; 字符串, 开始索引, 长度
            return SubStr(str, start, end - start + 1)
        } else {
            throw IndexError("The number of parameters must be 1 or 2.")
        }
    }
    /**
     * 将字符串的所有字符编码拼接起来
     * 
     * 可转为 number ,一般可以用来排序
     * @param {String} str
     * @example
     * ("asdf"), "97115100102"
     * @returns {String} 
     */
    static toCode(str) {
        output := ""
        for item in StringUtil.forEnumerator(str, 1) {
            output := StringUtil.concat(output, Ord(item))
        }
        return output
    }
    /**
     * 返回对应字符串的字符编码数组
     * @param {String} str
     * @example
     * ("asdf"), [97, 115, 100, 102]
     * @returns {Array<Integer>} 
     */
    static toCodes(str) {
        newArr := []
        for item in StringUtil.forEnumerator(str, 1) {
            newArr.Push(Ord(item))
        }
        return newArr
    }
    /**
     * 将字符串切割成数组
     * @param {String} str
     * @param {Array, String} separator 一个分隔符或分隔符组成的数组, 不传就是切割成单个字符 
     * @param count 切割次数 -1 表示无限次, 0 表示不切割
     * @example
     * ("111.222.333", "."), ["111", "222", "333"]
     * ("111.222.333", ".", 1), ["111", "222.333"]
     * ("fff"), ["f", "f", "f"]
     * ("abc.", ".", 1), ["abc", ""]
     * (".abc", ".", 1), ["", "abc"]
     * ("1 a 3s  6x", [A_Space, A_Tab]), ["1", "a", "3s", "", "6x"]
     * @returns {Array<String>} 
     */
    static split(str, separator := '', count := -1) {
        if count != -1 {
            count++
        }
        return StrSplit(str, separator, unset, count)
    }
    /**
     * 从右边开始将字符串切割成数组
     * @param {String} str
     * @param {Array, String} seqator 一个分隔符或分隔符组成的数组, 不传就是切割成单个字符 
     * @param count 切割次数 -1 表示无限次, 0 表示不切割
     * @example
     * ("111.222.333", "."), ["111", "222", "333"]
     * ("111.222.333", ".", 1), ["111.222", "333"]
     * ("fff"), ["f", "f", "f"]
     * ("abc.", ".", 1), ["abc", ""]
     * (".abc", ".", 1), ["", "abc"]
     * ("1 a 3s  6x", [A_Space, A_Tab]), ["1", "a", "3s", "", "6x"]
     * @returns {Array} 
     */
    static splitRight(str, seqator := "", count := -1) {
        if count == 0 {
            return [str]
        }
        arr := StringUtil.split(str, seqator)
        if count == -1 {
            return arr
        }
        resultArr := []
        loop arr.Length {
            if A_Index <= count {
                ArrayUtil.unShift(resultArr, arr.Pop())
            }
        }
        if arr.Length != 0 {
            ArrayUtil.unShift(resultArr, ArrayUtil.join(arr, seqator))
        }
        return resultArr
    }
    /**
     * 判断字符串是否已某个子字符串开头
     * @param startStr
     * @param caseSense 是否区分大小写, 默认区分
     * @example
     * ("111.222.333", "111"), true
     * ("asdf", "A"), false
     * ("asdf", "a", false), true
     * ("111.222.333", "2.333"), false
     * ("111.222.333", "222"), false
     * @returns {Integer} true 1 或 false 0
     */
    static startsWith(str, startStr, caseSense := true) {
        return InStr(str, startStr, caseSense) == 1
    }
    /**
     * 判断字符串是否已某个子字符串结尾
     * @param endStr 
     * @param caseSense 是否区分大小写, 默认区分
     * @example
     * ("111.222.333", "111"), false
     * ("asdf", "F"), false
     * ("asdf", "F",false), true
     * ("asdf", "f"), true
     * ("111.222.333", "2.333"), true
     * ("111.222.333", "222"), false
     * @returns {Integer} true 1 或 false 0
     */
    static endsWith(str, endStr, caseSense := true) {
        str_index := InStr(str, endStr, caseSense, -1)
        if str_index <= 0 {
            ; 0 为 没有找到, 直接 return ,不用再验证正确
            return 0
        }
        valid_index := StrLen(str) - StrLen(endStr) + 1
        return str_index == valid_index
    }
    /**
     * 判断字符串是否包含子字符串
     * @param subStr 
     * @param caseSense 是否区分大小写, 默认区分
     * @example
     * ("123", "2"), true
     * ("qwe", "2"), false
     * ("123", "123"), true
     * ("asd", "ASD"), false
     * ("asd", "ASD", false), true
     * ("asd", "ASDF"), false
     * @returns {Integer} true 1 或 false 0
     */
    static includes(str, item, caseSense := true) {
        return InStr(str, item, caseSense) != 0
    }
    /**
     * 任意项 包含 即可为 true
     * @param {String} str 
     * @param {Array} item_arr 
     * @param {Integer} caseSense 是否区分大小写,默认区分
     * @param params 
     * @example
     * ("123", ["2"]), true
     * ("123", ["2", "c"]), true
     * ("abc", ["A", "B"]), false
     * ("abc", ["A", "B"], false), true
     * @returns {Integer} true 1 或 false 0
     */
    static IncludeSome(str, item_arr, caseSense := true) {
        return ArrayUtil.some(item_arr, item => StringUtil.includes(str, item, caseSense))
    }
    /**
     * 必须包含传入的所有的 item 才返回 true
     * @param {String} str 
     * @param {Array} item_arr 
     * @param {Integer} caseSense 是否区分大小写,默认区分
     * @example
     * ("123", ["2"]), true
     * ("123", ["2", "c"]), false
     * ("abc", ["A", "B", "C"]), false
     * ("abc", ["A"], false), true
     * @returns {Integer} true 1 或 false 0
     */
    static includeEvery(str, item_arr, caseSense := true) {
        return ArrayUtil.every(item_arr, item => StringUtil.includes(str, item, caseSense))
    }
    /**
     * 获取 item 在字符串中的位置
     * @param str 
     * @param item 
     * @param caseSense 是否区分大小写, 默认区分
     * @example
     * ("abc", "b"), 2
     * ("abc", "B"), 0
     * ("abc", "B", false), 2
     * @returns {Integer} 位置从 1 开始, 未找到返回 0
     */
    static indexOf(str, item, caseSense := true) {
        return InStr(str, item, caseSense)
    }
    /**
     * 获取子字符串在字符串中的所有位置, 
     * @param p_str 
     * @param p_item_str 
     * @param p_caseSense 是否区分大小写, 默认区分
     * @example
     * ("abcbbbc", "b"), [ 2, 4, 5, 6 ]
     * ("abcbbbc", "B"), []
     * ("abcbbbc", "B", false), [ 2, 4, 5, 6 ]
     * @returns {Array<Integer>} 包含所有位置的数组
     */
    static indexOfAll(p_str, p_item_str, p_caseSense := true) {
        resultArr := []
        start_pos := 1
        str_length := StrLen(p_str)
        item_str_lenth := StrLen(p_item_str)
        loop {
            i := InStr(p_str, p_item_str, p_caseSense, start_pos)
            if i > 0 {
                resultArr.Push(i)
                start_pos := i + item_str_lenth
                if start_pos > str_length {
                    break
                }
            } else {
                break
            }
        }
        return resultArr
    }
    /**
     * 从右向左搜索, 返回搜索到的第一个索引
     * 
     * (比如 2,4位置都有, lastIndexOf 返回 4, indexOf 返回 2)
     * @param str 
     * @param item 
     * @param caseSense 是否区分大小写, 默认区分
     * @example
     * ("abcba", "b"), 4
     * ("abcba", "B"), 0
     * ("abcba", "B", false), 4
     * @returns {Integer}
     */
    static lastIndexOf(str, item, caseSense := true) {
        return InStr(str, item, caseSense, -1, -1)
    }
    /**
     * 删除字符串两边的指定字符
     * @param str 
     * @param {String} omitChars 要删除的字符, 默认为 空字符
     * @example
     * (" abcba "), "abcba"
     * (" abcba    "), "abcba"
     * ("aba","a"), "b"
     * @returns {String}
     */
    static trim(str, omitChars?) {
        return Trim(str, omitChars?)
    }
    ; -----NEW
    /**
     * 返回删除空格后的字符串
     * @param str 
     * @param chars 
     * @example
     * (" abcba "), "abcba"
     * (" abcba    "), "abcba"
     * ("aba", "a"), "b"
     * @returns {String}
     */
    static trim2(str, chars := ' \t`n`r') {
        return Trim(str, chars)
    }
    /**
     * 删除字符串左边的指定字符, 默认删除空白
     * @param {String} omitChars 
     * @example
     * (" abcba "), "abcba "
     * (" abcba    "), "abcba    "
     * ("aba", "a"), "ba"
     * @returns {String} 
     */
    static trimLeft(str, omitChars?) {
        return LTrim(str, IsSet(omitChars) ? omitChars : unset)
    }
    /**
     * 返回从开头删除空格的字符串
     * @param str 
     * @param chars 
     */
    static trimStart(str, omitChars?) {
        return LTrim(str, IsSet(omitChars) ? omitChars : unset)
    }
    /**
     * 删除字符串右边的指定字符, 默认删除空白
     * @param {String} omitChars 
     * @returns {String} 
     */
    static trimRight(str, omitChars?) {
        return RTrim(str, IsSet(omitChars) ? omitChars : unset)
    }
    /**
     * 返回删除末尾空格后的字符串
     * @param str 
     * @param chars 
     */
    static trimEnd(str, chars := ' \t`n`r') {
        return RTrim(str, chars)
    }
    /**
     * 获取字符串长度 (删除两侧空白,如果全是空白,长度就是 0)
     * 
     * 无特殊需求可使用 isEmpty()
     * @param str 
     * @example
     * ("        "), 0
     * (" abcba "), 5
     * (" abcba    "), 5
     * ("aba"), 3
     * @returns {Integer} 字符串长度
     */
    static lengthAndTrim(str) {
        return StrLen(Trim(str))
    }
    /**
     * 获取字符串长度
     * @param {String} str 
     * @example
     * (" abcba "), 7
     * (" abcba    "), 10
     * ("aba"), 3
     * ("        "), 8
     * @returns {Integer}
     */
    static length(str) {
        return StrLen(str)
    }
    /**
     * 返回指定索引处字符的 Unicode 码
     * @param {String} str 
     * @param {Integer} index 索引, 从1开始
     * @example
     * ("abcde",2), 98
     * ("水果",2), 26524
     * @returns {Integer} Unicode 码
     */
    static charCodeAt(str, index) {
        return Ord(SubStr(str, index, 1))
    }
    /**
     * 将多个字符串连接起来
     * @param params* 
     * @example
     * ("a",1,"b",2), "a1b2"
     * @returns {String} 
     */
    static concat(str, params*) {
        o := str
        for item in params {
            o := o . item
        }
        return o
    }
    /**
     * 使用字符串包裹另一个字符串
     * @param wrapStr 
     * @example
     * ("a","##"), "##a##"
     * @returns {String} 
     */
    static wrap(str, ch) {
        return ch str ch
    }
    /**
     * 给字符串包裹一个 " ", 常用于表示它是字符串类型
     * @example
     * ("a"), '"a"'
     * @returns {String} 
     */
    static toString(str) {
        return StringUtil.wrap(str, '"')
    }
    /**
     * 替换字符串中的某些子字符串
     * 
     * 复杂需求请使用 RegExReplace 正则替换
     * 
     * @param {String} Needle 要搜索的子字符串
     * @param {String} ReplaceText 替换的字符, 不传就替换成空
     * @param {String | Integer} CaseSense 是否区分大小写, 默认区分
     * @param {VarRef} OutputVarCount 指针存储替换的次数
     * @param {Integer} Limit 默认 -1, 表示最大替换次数
     * @example 
     * ("xaabcaa","a",""), "xbc"
     * @returns {String} 
     */
    static replace(str, params*) {
        return StrReplace(str, params*)
    }
    /**
     * 在开头填充指定的字符
     * @param str 
     * @param p_length 填充后的长度
     * @param pad 填充的字符,默认 空格
     * @example
     * ("a", 5, "b"), "bbbba"
     * ("a", 5), "    a"
     * ("aaa", 1), "aaa"
     * @returns {String}
     */
    static padStart2(str, p_length, pad := ' ') {
        while (StrLen(str) < p_length) {
            loop parse pad {
                str := A_LoopField str
            } until (StrLen(str) == p_length)
        }
        return str
    }
    /**
     * 用给定的字符串将字符串末尾填充到给定长度。如有需要，可重复执行。
     * @param str 
     * @param p_length 
     * @param pad 
     * @example
     * ("a", 5, "b"), "abbbb"
     * ("a", 5), "a    "
     * ("aaa", 1), "aaa"
     * @returns {String}
     */
    static padEnd2(str, p_length, pad := ' ') {
        while (StrLen(str) < p_length) {
            loop parse pad {
                str .= A_LoopField
            } until (StrLen(str) == p_length)
        }
        return str
    }
    /**
     * 截取字符串
     * @param {String} res 
     * @param {Integer} start 开始的索引
     * @param {Integer} end  结束的索引 (不传则截取到末尾)
     * @example
     * ("12345", 2), "2345"
     * ("12345", 8), ""
     * ("12345", 2,4), "234"
     * @returns {String}
     */
    static subString2(res, start, end := unset) {
        return SubStr(res, start, IsSet(end) ? end - start + 1 : unset)
    }
    /**
     * 提取字符串的一部分并返回一个新字符串
     * @param {String} res 
     * @param {Integer} start 开始的索引
     * @param {Integer} end  结束的索引 (不传则截取到末尾)
     * @example
     * ("12345", 2), "2345"
     * ("12345", 8), ""
     * ("12345", 2, 4), "234"
     * @returns {String}
     */
    static slice(str, start := 1, end := unset) {
        return SubStr(str, start, IsSet(end) ? end - start + 1 : unset)
    }
    /**
     * 将字符串拆分为子字符串数组
     * @param str 
     * @param delimiter 分隔符
     * @param limit 结果的数量限制
     * @example
     * ("12345"), ["1", "2", "3", "4", "5"]
     * ("12345", , 2), ["1", "2345"]
     * ("1.2.3.4.5", "."), ["1", "2", "3", "4", "5"]
     * ("1.2.3.4.5", ".", 2), ["1", "2.3.4.5"]
     * @returns {Array}
     */
    static split2(str, delimiter := '', limit := -1) {
        return (limit == 0) ? [] : StrSplit(str, delimiter, '', limit)
    }
    /**
     * 检查字符串是否以指定字符开头
     * @param str 
     * @param search_str 
     * @param start_pos 
     * @example
     * ("12345", "1"), true
     * ("12345", "1", 2), false
     * ("12345", "1", 1), true
     * ("12345", "2"), false
     * @returns {Integer} true / false
     */
    static startsWith2(str, search_str, start_pos := 1) {
        return search_str == SubStr(str, start_pos, StrLen(search_str))
    }
    /**
     * 返回字符串是否以指定值结束
     * @param str 
     * @param search_str 查找的字符串
     * @param end_pos 结尾的索引, 比如 "12345" 传入 3, 会将索引3之后的字符去掉,结果是"123"再去判断是否以某个字符结尾
     * @example
     * ("12345", "5"), true
     * ("12345", "1", 2), false
     * ("12345", "1", 1), true
     * ("12345", "1"), false
     * @returns {Integer} true / false
     */
    static endsWith2(str, search_str, end_pos := unset) {
        str_len := StrLen(str)
        if !IsSet(end_pos)
            end_pos := str_len
        srch_len := StrLen(search_str)
        return search_str == SubStr(str, end_pos - srch_len + 1, srch_len)
    }
    /**
     * 翻转字符串
     * @example
     * ("12345"), "54321"
     * @returns {String} 
     */
    static reverse(str) {
        return ArrayUtil.join(ArrayUtil.reverse(StringUtil.split(str)), "")
    }
    /**
     * 小写
     * @param str 
     */
    static toLowerCase(str) {
        return StrLower(str)
    }
    /**
     * 大写
     * @param str 
     * @returns {String} 
     */
    static toUpperCase(str) {
        return StrUpper(str)
    }
    /**
     * URL 编码
     * @param url 
     * @param component 
     */
    static urlEncode(url, component := false) {
        flag := component ? 0xc2000 : 0xc0000
        DllCall('shlwapi\UrlEscape', 'str', url, 'ptr*', 0, 'uint*', &len := 1, 'uint', flag)
        DllCall('shlwapi\UrlEscape', 'str', url, 'ptr', buf := Buffer(len << 1), 'uint*', &len, 'uint', flag)
        return StrGet(buf)
    }
    /**
     * 是否为空
     * 
     * 会删除两侧空格
     * @param p_str 
     */
    static isEmpty(p_str) {
        return StringUtil.lengthAndTrim(p_str) == 0
    }
}

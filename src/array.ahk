#Include "string.ahk"
class ArrayUtil {
    /**
     * 对一个只包含数字的数组求和
     * 
     * 小数点需要用 Round(...)
     * @param {Array} arr
     * @example
     * ArrayUtil.sum([1, 2, 3, 4, 5]), 15
     * Round(ArrayUtil.sum([1.2, 2.6, 3.5]), 1), Round(7.3, 1)
     * @returns {Integer} 
     */
    static sum(arr) {
        return ArrayUtil.reduce(arr, (m, i) => i + m)
    }
    /**
     * 从左向右的累加器
     * 
     * 模仿 JavaScript 中 Reduce 方法
     * @param {Array} arr
     * @param ReduceFunc 
     * @param {Number} initial 初始化的值
     * @example
     * ; 1 + 2 + 3 +4 + 5
     * ([1, 2, 3, 4, 5], (a, b) => a + b), 15
     * ; 1 + 1.2 + 2.6 + 3.5
     * Round(this_func([1.2, 2.6, 3.5], (a, b) => a + b, 3), 1), Round(10.3, 1)
     * @returns {Any} 
     */
    static reduce(arr, ReduceFunc, initial?) {
        if !IsSet(initial) {
            reduceArr := ArrayUtil.slice(arr, 2, -1)
            memo := arr[1]
        } else {
            reduceArr := ArrayUtil.clone(arr)
            memo := initial
        }
        for item in reduceArr {
            memo := ReduceFunc(memo, item)
        }
        return memo
    }
    /**
     * 从右向左 的累加器
     * 模仿 JavaScript  中 ReduceRight 方法
     * @param {Array} arr
     * @param ReduceFunc 
     * @param initial 初始值
     * @example
     * ; 25 - 9 - 7 - 3 - 1
     * ([1, 3, 7, 9, 25], (a, b) => a - b), 5
     * ; 13.5 - 2.6 - 1.2
     * Round(ArrayUtil.reduceRight([1.2, 2.6], (a, b) => a - b, 13.5), 1), Round(9.7, 1)
     * @returns {Number} 
     */
    static reduceRight(arr, ReduceFunc, initial?) {
        reduceArr := []
        if !IsSet(initial) {
            reduceArr := ArrayUtil.slice(arr, 1, -2)
            memo := arr[-1]
        } else {
            reduceArr := ArrayUtil.clone(arr)
            memo := initial
        }
        loop ArrayUtil.length(reduceArr) {
            memo := ReduceFunc(memo, reduceArr[-A_Index])
        }
        return memo
    }
    /**
     * 将一个数组连接成字符串
     * @param {Array} arr
     * @param {String} separator 连接符 (默认以逗号连接)
     * @example
     * ;文件中换行用 "`r`n"
     * ([1, 2, 3]), "1,2,3"
     * ([1, 2, 3],"#"), "1#2#3"
     * @returns {String}
     */
    static join(arr, separator := ",") {
        result := ""
        len := ArrayUtil.length(arr)
        for index, item in arr {
            result := result . String(item)
            ; ahk 的索引是从1开始的,所以最后一位 等于 长度
            if (index < len) {
                result := result . separator
            }
        }
        return result
    }
    /**
     * 交集
     * 
     * 第一个数组 相对于 剩余数组 共同拥有的项
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2, 3, 4], [2, 3, 4], [2, 5]), [2]
     * @returns {Array} 
     */
    static intersect(arr, params*) {
        newArr := []
        for item in arr {
            value := item
            ; 全部包含该项
            if ArrayUtil.every(params, (i) => ArrayUtil.includes(i, value)) {
                newArr.Push(value)
            }
        }
        return newArr
    }
    /**
     * 并集
     * 
     * 取出所有数组中的项, 无重复,返回新的数组
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2, 3], [2, 3, 4], [1, 2, 5]), [1, 2, 3, 4, 5]
     * @returns {Array} 
     */
    static union(arr, params*) {
        newArr := ArrayUtil.clone(arr)
        for item IN params {
            for i IN item {
                if !ArrayUtil.includes(newArr, i) {
                    newArr.Push(i)
                }
            }
        }
        return newArr
    }
    /**
     * 补集
     * 
     * 取出在所有数组中独一无二的项, 组成新的数组
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2, 3], [2, 3, 4], [2, 3]), [1, 4]
     * @returns {Array} 
     */
    static complement(arr, params*) {
        newArr := []
        iArr := ArrayUtil.intersect(arr, params*)
        for item in ArrayUtil.union(arr, params*) {
            if !ArrayUtil.includes(iArr, item) {
                newArr.Push(item)
            }
        }
        return newArr
    }
    /**
     * 差集
     * 
     * 第一个数组 比 剩余数组 多出的项
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2, 3], [ 3, 4], [2, 4]), [1]
     * @returns {Array} 
     */
    static minus(arr, params*) {
        newArr := []
        for item in arr {
            value := item
            ; 全部不包含
            if ArrayUtil.every(params, (i) => !ArrayUtil.includes(i, value)) {
                newArr.Push(value)
            }
        }
        return newArr
    }
    /**
     * 遍历数组并返回一个新数组,可用来修改数组的每一项
     * @param {Array} arr
     * @param {Func} mapfn
     * @example
     * ([1, 2, 3], (a) => a * 10), [10, 20, 30]
     * @returns {Array}
     */
    static map(arr, mapfn) {
        newArr := []
        for item in arr {
            newArr.Push(mapfn(item))
        }
        return newArr
    }
    /**
     * 过滤数组,返回一个过滤后的新数组
     * @param {Array} arr
     * @param {Func} filterfn
     * @example
     * ([1, 2, 3, 4], (a) => Mod(a, 2) == 0), [2, 4]
     * @returns {Array}
     */
    static filter(arr, filterfn) {
        newArr := []
        for item in Arr {
            if filterfn(item) {
                newArr.Push(item)
            }
        }
        return newArr
    }
    /**
     * 删除数组的第一个元素 或 从第一个开始的多个元素, 
     * 
     * 如果只删除一个元素则返回该元素, 
     * 
     * 删除多个则返回被删除元素组成的数组,
     * 
     * 该方法会修改原数组
     * @param {Array} arr
     * @param {Integer} count 要删除的数量
     * @example
     * temp := [1, 2, 3, 4]
     * __Assert ArrayUtil.shift(temp, 1), 1
     * __AssertArray temp, [2, 3, 4]
     * 
     * temp := [1, 2, 3, 4]
     * __AssertArray ArrayUtil.shift(temp, 2), [1, 2]
     * __AssertArray temp, [3, 4]
     * @returns {Any | Array}
     */
    static shift(arr, count := 1) {
        ; 取出准备删除的元素,并返回
        ret := ArrayUtil.slice(arr, 1, count)
        ; 修改原数组,删除目标索引的值
        ArrayUtil.itemSet(arr, [], 1, count)
        ; 如果是1个,则取出来返回,多个则返回数组
        return ArrayUtil.length(ret) == 1 ? ret[1] : ret
    }
    ;
    /**
     * 由于很多时候变量类型没有智能提示
     * 手动写注释指定类型又很麻烦
     * 所以搞一个方法来获得数组的Length
     * @param {Array} arr
     */
    static length(arr) {
        return arr.Length
    }
    /**
     * 向数组头部添加多个元素,并返回原数组,
     * 
     * 该方法修改原数组
     * @param {Array} arr
     * @param {Any*} params 多个参数
     * @example
     * temp := [3, 4, 5]
     * __AssertArray ArrayUtil.unShift(temp, 1, 2), [1, 2, 3, 4, 5]
     * __AssertArray temp, [1, 2, 3, 4, 5]
     * @returns {Array}
     */
    static unShift(arr, params*) {
        arr.InsertAt(1, params*)
        return arr
    }
    /**
     * 将多个数组连接成一个新数组 并返回
     * 
     * 该方法会修改原数组
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2], [3, 4], [5, 6]), [1, 2, 3, 4, 5, 6]
     * @returns {Array}
     */
    static concat(arr, params*) {
        for item in params {
            arr.Push(item*)
        }
        return arr
    }
    /**
     * 函数返回值全部为真 则返回真, 否则为假
     * 
     * @param {Array} arr
     * @param {Func} everyfn
     * @example
     * ([1, 2, 3], (a) => a < 3), false
     * ([1, 2, 3], (a) => a < 5), true
     * @returns {Integer} true / false 
     */
    static every(arr, everyfn) {
        flag := true
        for item in arr {
            if !everyfn(item) {
                flag := false
                break
            }
        }
        return flag
    }
    /**
     * 任意一个函数的返回值为 true, 则返回 true
     * @param {Array} arr
     * @param {Func} somefn
     * @example
     * ([1, 2, 3], (a) => 4 < a), false
     * ([1, 2, 3], (a) => 2 < a), true
     * @returns {Integer} true / false 
     */
    static some(arr, somefn) {
        flag := false
        for item in arr {
            if somefn(item) {
                flag := true
                break
            }
        }
        return flag
    }
    /**
     * 删除所有某项 或 指定次数, 并返回原数组
     * 
     * 该方法会修改原数组
     * @param {Array} arr
     * @param {Number} count 默认 0 表示删除所有的相同项, 1表示删除1次,  
     * @example
     * temp := [0, 1, 1, 2]
     * __AssertArray ArrayUtil.remove(temp, 1), [0, 2]
     * __AssertArray temp, [0, 2]
     * 
     * temp := [0, 1, 1, 2]
     * __AssertArray ArrayUtil.remove(temp, 1, 1), [0, 1, 2]
     * __AssertArray temp, [0, 1, 2]
     * @returns {Array}
     */
    static remove(arr, value, count := 0) {
        i := 0
        loop ArrayUtil.length(arr) {
            if A_Index > ArrayUtil.length(arr) {
                break
            }
            if arr[A_Index] == value {
                arr.RemoveAt(A_Index)
                i++
                A_Index--
                if count == 0 {
                    continue
                } else if i == count {
                    break
                }
            }
        }
        return arr
    }
    /**
     * 传入一个待删除元素组成的数组, 从原数组中删除这些项, 返回原数组, 
     * 
     * 该方法会修改原数组
     * @param {Array} arr
     * @param delArr 一个包含待删除元素的数组
     * @param count 每个要删除元素可以被删除的次数, 0 表示删除所有
     * @example
     * temp := [0, 1, 1, 2]
     * __AssertArray ArrayUtil.removeAll(temp, [1, 2]), [0]
     * __AssertArray temp, [0]
     * 
     * temp := [0, 1, 1, 2]
     * __AssertArray ArrayUtil.removeAll(temp, [1, 2], 1), [0, 1]
     * __AssertArray temp, [0, 1]
     * @returns {Array}
     */
    static removeAll(arr, delArr, count := 0) {
        for item IN delArr {
            ArrayUtil.remove(arr, item, count)
        }
        return arr
    }
    /**
     * 传入一个函数, 找到结果为真的第一个数组项并返回
     * @param {Array} arr
     * @param {Func} findfn 用来查找的函数
     * @param {Any} p_default_value 没有找到的时候返回的值
     * @example
     * ([1, 2, 3, 4], (a) => a > 2), 3
     * ([1, 2, 3, 4], (a) => a > 7), ""
     * ([1, 2, 3, 4], (a) => a > 7, "NULL"), "NULL"
     * @returns {Any}
     */
    static find(arr, findfn, p_default_value := "") {
        for item in arr {
            if findfn(item) {
                return item
            }
        }
        return p_default_value
    }
    /**
     * 传入一个函数, 返回结果为真的所有项组成的新数组
     * @param {Array} arr
     * @param {Func} find_all_fn
     * @example
     * ([1, 2, 3, 4], (a) => a > 2), [3, 4]
     * ([1, 2, 3, 4], (a) => a > 7), []
     * @returns {Array}
     */
    static findAll(arr, find_all_fn) {
        newArr := []
        for item in arr {
            if find_all_fn(item) {
                newArr.Push(item)
            }
        }
        return newArr
    }
    /**
     * 判断一个数组是否包含某个项目, 返回一个布尔值 0 或 1
     * @param {Array} arr
     * @param {Any} value
     * @example
     * ([1, 2], 3), false
     * ([1, 2], 2), true
     * (["a", "B"], "B"), true
     * (["a", "b"], "B"), false
     * @returns {Integer} true / false
     */
    static includes(arr, value) {
        for item in arr {
            if item == value {
                return true
            }
        }
        return false
    }
    /**
     * 如果数组包含传入参数中的一个项那么返回 True, 否则返回 False
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2], 3, 4), false
     * ([1, 2], 3, 2), true
     * (["a", "B"], "B"), true
     * (["a", "b"], "B"), false
     * @returns {Integer} true / false
     */
    static includeSome(arr, params*) {
        return ArrayUtil.some(params, item => ArrayUtil.includes(arr, item))
    }
    /**
     * 如果数组包含传入参数中的所有项那么返回 True, 否则返回 False
     * @param {Array} arr
     * @param {Array*} params 多个数组
     * @example
     * ([1, 2], 3, 4), false
     * ([1, 2], 2, 1), true
     * (["a", "B"], "B"), true
     * (["a", "b"], "B", "a"), false
     * (["a", "b"], "b", "a"), true
     * @returns {Integer}  true / false
     */
    static includeEvery(arr, params*) {
        return ArrayUtil.every(params, item => ArrayUtil.includes(arr, item))
    }
    /**
     * 查看value在数组中的位置
     * @param {Array} arr
     * @param value 查看value在数组中的索引位置
     * @example
     * arr := ["哈哈", "嘿嘿"]
     * 
     * arr.IndexOf("嘿嘿") // 2
     * @returns {Integer} 如果在数组中返回索引, 0 表示不在
     */
    static indexOf(arr, value) {
        for index, item in arr {
            if item == value {
                return index
            }
        }
        return 0
    }
    /**
     * 传入一个值或函数返回匹配到的项对应索引组成的新数组
     * @param {Array} arr
     * @param ValueOrFunc 一个要查找的值或者一个用于查找的函数,函数返回true表示匹配成功
     * @example
     * arr := ["木瓜", "西瓜", "土豆", "草莓", "葡萄", "甜瓜", "西瓜"]
     * 
     * arr.IndexOfAll("西瓜") // [2, 7]
     * 
     * arr.IndexOfAll(i => i.Includes("瓜")) // [1, 2, 6, 7]
     * @returns {Array<Integer>} 返回包含所有找到索引的数组
     */
    static indexOfAll(arr, fn) {
        newArr := []
        if type(fn) != "Func" {
            checkfn := (item) => item == fn
        } else {
            checkfn := fn
        }
        for index, item in arr {
            if checkfn(item) {
                newArr.Push(index)
            }
        }
        return newArr
    }
    /**
     * 将数组扁平化
     * @param {Array} arr
     * @param depth 要铺平数组的层数 0表示无限扁平化
     * @example
     * arr := [1, 2, [3, [4, 5]]]
     * 
     * arr.Flat() // [1,2,3,4,5]
     * 
     * arr.Flat(1) // [1,2,3,[4,5]]
     * @returns {Array<T>} 
     */
    static flat(arr, depth := 0, count := 0) {
        newArr := []
        for item in arr {
            if type(item) == "Array" && (depth == 0 || depth != count) {
                newArr.Push(ArrayUtil.flat(item, depth, count + 1)*)
            } else {
                newArr.Push(item)
            }
        }
        return newArr
    }
    /**
     * 数组排序,该方法不改变数组本身,返回新数组
     * @param {Array} arr
     * @param SortFunc 一个用于排序的函数, 默认值 (a,b) => a - b
     * @example
     * arr := [8, 2, 1, 9]
     * 
     * arr.Sort() // [1,2,8,9]
     * 
     * arr.Sort((a,b) => b-a) // [9,8,2,1]
     * @returns {Array<T>} 
     */
    static sort(arr, sortfn := (a, b) => a - b) {
        if ArrayUtil.length(arr) < 1 {
            return []
        }
        left := []
        right := []
        middle := []
        base := arr[1]
        for item in arr {
            cond := sortfn(item, base)
            if cond < 0 {
                left.push(item)
            } else if cond > 0 {
                right.push(item)
            } else {
                middle.push(item)
            }
        }
        return ArrayUtil.concat([], ArrayUtil.sort(left, sortfn), middle, ArrayUtil.sort(right, sortfn))
    }
    /**
     * 翻转数组, 返回一个新数组
     * @param {Array} arr
     * @example
     * 
     * @returns {Array<T>} 
     */
    static reverse(arr) {
        newArr := []
        loop ArrayUtil.length(arr) {
            newArr.Push(arr[-A_Index])
        }
        return newArr
    }
    /**
     * 数组去重
     * @param {Array} arr
     * @example
     * arr := [1,1,1,2,2,2]
     * 
     * arr.Unique() // [1,2]
     * @returns {Array<T>} 
     */
    static unique(arr) {
        newArr := []
        for item in arr {
            if !ArrayUtil.includes(newarr, item) {
                newArr.Push(item)
            }
        }
        return newArr
    }
    /**
     * 数组克隆
     * @param {Array} arr 
     */
    static clone(arr) {
        return arr.Clone()
    }
    /**
     * 数组切片, 可以获取一段数据
     * 
     * (不传参数,则克隆数组)
     * @param {Array} arr 
     * @param {Integer} start_index 开始索引
     * @param {Integer} end_index 结束索引
     * @example
     * 
     * @returns {Array}
     */
    static slice(arr, start_index := 1, end_index := unset) {
        if !IsSet(end_index) {
            return arr[start_index]
        }
        if (IsSet(end_index)) {
            params := [start_index, end_index]
            outArr := []
            for index, item in params {
                ; 将倒序索引,转为实际的索引
                if item < 0 {
                    params[index] := item + ArrayUtil.length(arr) + 1
                }
            }
            index := params[1]
            end := params[2]
            loop {
                outArr.Push(arr[index])
                index++
            } until index > end
            return outArr
        }
    }
    /**
     * 设置数组中的值
     * @param {Array} arr 
     * @param {Any | Array} value 目标值
     * @param {Integer} start_index 开始索引
     * @param {Integer?} end_index 结束索引
     * @example
     */
    static itemSet(arr, p_value, p_start_index, p_end_index := unset) {
        if !IsSet(p_end_index) {
            arr[p_start_index] := p_value
            return
        }
        params := [p_start_index, p_end_index]
        for index, item in params {
            ; 将 负数 的转为对应的倒序索引
            if item < 0 {
                params[index] := item + ArrayUtil.length(arr) + 1
            }
        }
        ; 移除对应索引位置的数据 (索引,长度), 然后 用 InsertAt 再添加进来新的数据
        arr.RemoveAt(params[1], params[2] - params[1] + 1)
        ; 因为 InsertAt 支持多个值,所以 p_value 可以是数组
        if p_value is Array {
            if ArrayUtil.length(p_value) > 0 {
                ; 插入多个值到指定位置, 可传多个参数, 数组用 value*,
                arr.InsertAt(params[1], p_value*)
            }
        } else {
            ; 插入一个值到指定的索引位置
            arr.InsertAt(params[1], p_value)
        }
    }
    /**
     * 将数组转换成字符串表示
     * @param {Array} arr
     * @example
     * arr := [1,2,3]
     * 
     * arr.ToString() // "123"
     * 
     * String(arr) // "123"
     */
    static toString(arr) {
        output := "["
        for item in arr {
            item_str := type(item) == "String" ? StringUtil.toString(item) : String(item)
            output := StringUtil.concat(output, " ", item_str, ",")
        }
        if StringUtil.subString(output, -1) == "," {
            output := StringUtil.subString(output, 1, -2)
        }
        output := output . " ]"
        return output
    }
    /**
     * Returns a section of the array from 'start' to 'end', optionally skipping elements with 'step'.
     * @param start Optional: index to start from. Default is 1.
     * @param end Optional: index to end at. Can be negative. Default is 0 (includes the last element).
     * @param step Optional: an integer specifying the incrementation. Default is 1.
     * @example
     * 
     * 
     * @returns {Array}
     */
    static slice2(arr, start := 1, end := 0, step := 1) {
        len := arr.Length, i := start < 1 ? len + start : start, j := Min(end < 1 ? len + end : end, len)
        r := []
        if len = 0
            return []
        if i < 1
            i := 1
        if step = 0
            throw Error("Slice: step cannot be 0", -1)
        else if step < 0 {
            while i >= j {
                r.Push(arr[i])
                i += step
            }
        } else {
            while i <= j {
                r.Push(arr[i])
                i += step
            }
        }
        return arr := r
    }
    /**
     * 交换元素
     * @param arr 
     * @param index_a 
     * @param index_b 
     */
    static swap(arr, index_a, index_b) {
        temp := arr[index_b]
        arr[index_b] := arr[index_a]
        arr[index_a] := temp
        return arr
    }
}

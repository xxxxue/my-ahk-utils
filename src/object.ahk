#Include "array.ahk"
class ObjectUtil {
    /**
     * 一个属性,获取对象的长度
     * 
     * obj := {a: 1, b: 2}
     * 
     * __ObjectLength(obj) // 2
     */
    static length(obj, *) {
        return ArrayUtil.length(ObjectUtil.keys(obj))
    }
    /**
     * 将多个对象进行合并
     * 
     * obj := {a: 1, b: 2, c: 3}
     * 
     * obj.Merge({c: 8, d: 9}) // { a: 1, b: 2, c: 8, d: 9 }
     * @returns {Object} 
     */
    static merge(obj, params*) {
        for oitem in params {
            for k, v in oitem {
                obj[k] := v
            }
        }
        return obj
    }
    /**
     * 判断一个对象是否包含某个属性
     * @param {Object} obj
     * 
     * obj := {a: 1, b: 2, c: 3}
     * 
     * obj.Has("d") // 0
     * 
     * obj.Has("c") // 1
     * @returns {Integer} 
     */
    static has(obj, prop) {
        return obj.HasOwnProp(prop)
    }
    /**
     * 判断一个对象是否包含某个属性
     * @param {Object} obj
     * obj := {a: 1, b: 2, c: 3}
     * 
     * obj.Contains("d") // 0
     * 
     * obj.Contains("c") // 1
     * @returns {Integer} 
     */
    static contains(obj, prop, cases := true) { ; cases 表示是否大小写敏感
        if cases {
            return obj.HasOwnProp(prop)
        }
        for key, _ in obj {
            if prop == key {
                return true
            }
        }
        return false
    }
    /**
     * 
     * @param {Object} obj
     * @param paramNum 
     */
    static forEnumerator(obj, paramNum) {
        EnumFn := obj.OwnProps()
        return innerEnum
        innerEnum(&arg1, &arg2?) {
            if paramNum == 1 {
                flag := EnumFn(&innerArg1)
                if !flag {
                    return flag
                }
                arg1 := obj.%innerArg1%
            } else if paramNum == 2 {
                flag := EnumFn(&arg1, &arg2)
                if !flag {
                    return flag
                }
            }
        }
    }
    /**
     * 获取对象的key组成的数组
     * @param {Object} obj
     * obj := {a: 1, b: 2}
     * 
     * obj.Keys() // ["a", "b"]
     * @returns {Array} 
     */
    static keys(obj) {
        arr := []
        for key in ObjectUtil.forEnumerator(obj, 1) {
            arr.Push(key)
        }
        return arr
    }
    /**
     * 获取对象的Value组成的数组
     * @param {Object} obj
     * obj := {a: 1, b: 2}
     * 
     * obj.Values() // [1, 2]
     * @returns {Array} 
     */
    static values(obj) {
        arr := []
        for _, value in ObjectUtil.forEnumerator(obj, 2) {
            arr.Push(value)
        }
        return arr
    }
    /**
     * 获取对象的key value对组成的数组
     * @param {Object} obj
     * obj := {a: 1, b: 2, c: 3}
     * 
     * obj.Items() // [ { key: "a", value: 1 }, { key: "b", value: 2 }, { key: "c", value: 3 } ]
     * @returns {Array} 
     */
    static items(obj) {
        arr := []
        for k, v in ObjectUtil.forEnumerator(obj, 2) {
            arr.Push({ key: k, value: v })
        }
        return arr
    }
    /**
     * 返回一个对象的字符串表示
     * @param {Object} obj
     * obj := {a: 1, b: 2, c: 3}
     * 
     * obj.ToString() // "{ a: 1, b: 2, c: 3 }"
     * @returns {String} 
     */
    static toString(obj) {
        o := "{ "
        for k, v in ObjectUtil.forEnumerator(obj, 2) {
            o := StringUtil.concat(o, k, ": ", type(v) == "String" ? StringUtil.wrap(v, '"') : String(v), ", ")
        }
        if StringUtil.subString(o, -2, -1) == ", " {
            o := StringUtil.subString(o, 1, -3)
        }
        o := o " }"
        return o
    }
    /**
     * 获取对象的某个值
     * @param { Object } obj 对象
     * @param { String } keys 值的路径
     * @example
     * (g_config, "pos.end_btn")
     */
    static getValue(obj, keys) {
        result := ""
        current_obj := obj
        for item IN StrSplit(keys, ".") {
            if current_obj.HasOwnProp(item) {
                value := current_obj.%item%
                if value is Object && NOT (value is Array) {
                    current_obj := value
                } else {
                    result := value
                    break
                }
            } else {
                break
            }
        }
        return result
    }
    /**
     * 深克隆
     * @param obj 
     */
    static deepClone(obj) {
        objs := Map(), objs.Default := ''
        return clone(obj)
        clone(obj) {
            switch Type(obj) {
                case 'Array', 'Map':
                    o := obj.Clone()
                    for k, v in o
                        if IsObject(v)
                            o[k] := objs[p := ObjPtr(v)] || (objs[p] := clone(v))
                    return o
                case 'Object':
                    o := obj.Clone()
                    for k, v in o.OwnProps()
                        if IsObject(v)
                            o.%k% := objs[p := ObjPtr(v)] || (objs[p] := clone(v))
                    return o
                default:
                    return obj
            }
        }
    }
}

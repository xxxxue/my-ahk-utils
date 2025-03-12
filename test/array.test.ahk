#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        ; 默认
        __Assert ArrayUtil.sum([1, 2, 3, 4, 5]), 15
        ; 指定初始值,与 小数类型
        __Assert Round(ArrayUtil.sum([1.2, 2.6, 3.5]), 1), Round(7.3, 1)
    }
    {
        ; 默认
        __Assert ArrayUtil.reduce([1, 2, 3, 4, 5], (a, b) => a + b), 15
        ; 指定初始值,与 小数类型
        __Assert Round(ArrayUtil.reduce([1.2, 2.6, 3.5], (a, b) => a + b, 3), 1), Round(10.3, 1)
    }
    {
        ; 默认
        __Assert ArrayUtil.reduceRight([1, 3, 7, 9, 25], (a, b) => a - b), 5
        ; 指定初始值,与 小数类型
        __Assert Round(ArrayUtil.reduceRight([1.2, 2.6], (a, b) => a - b, 13.5), 1), Round(9.7, 1)
    }
    {
        ; 默认逗号分割
        __Assert ArrayUtil.join([1, 2, 3]), "1,2,3"
        ; 空分割
        __Assert ArrayUtil.join([1, 2, 3], ""), "123"
        ; 自定义分隔符
        __Assert ArrayUtil.join([1, 2, 3], "#"), "1#2#3"
    }
    {
        ; 交集
        __Assert ArrayUtil.intersect([1, 2, 3, 4], [2, 3, 4], [2, 5]), [2]
    }
    {
        ; 并集
        __Assert ArrayUtil.union([1, 2, 3], [2, 3, 4], [1, 2, 5]), [1, 2, 3, 4, 5]
    }
    {
        ; 补集
        __Assert ArrayUtil.complement([1, 2, 3], [2, 3, 4], [2, 3]), [1, 4]
    }
    {
        ; 差集
        __Assert ArrayUtil.minus([1, 2, 3], [3, 4], [2, 4]), [1]
    }
    {
        ; 每项乘 10
        __Assert ArrayUtil.map([1, 2, 3], (a) => a * 10), [10, 20, 30]
    }
    {
        ; 筛选出能被 2 整除的项 (偶数)
        __Assert ArrayUtil.filter([1, 2, 3, 4], (a) => Mod(a, 2) == 0), [2, 4]
    }
    {
        temp := [1, 2, 3, 4]
        ; 返回被移除的项,由于只有 1 项,所以类型不是数组
        __Assert ArrayUtil.shift(temp, 1), 1
        ; 原数组被修改
        __Assert temp, [2, 3, 4]
        temp := [1, 2, 3, 4]
        ; 返回被移除的项,由于移除了多项,所以类型为数组
        __Assert ArrayUtil.shift(temp, 2), [1, 2]
        ; 原数组被修改
        __Assert temp, [3, 4]
    }
    {
        ; 在开头添加 2 个值
        temp := [3, 4, 5]
        __Assert ArrayUtil.unShift(temp, 1, 2), [1, 2, 3, 4, 5]
        __Assert temp, [1, 2, 3, 4, 5]
    }
    {
        ; 拼接多个数组
        temp := [1, 2]
        __Assert ArrayUtil.concat(temp, [3, 4], [5, 6]), [1, 2, 3, 4, 5, 6]
        __Assert temp, [1, 2, 3, 4, 5, 6]
    }
    {
        ; 有 1 个不符合,所以返回 false
        __Assert ArrayUtil.every([1, 2, 3], (a) => a < 3), false
        ; 全部都符合, 所以返回 true
        __Assert ArrayUtil.every([1, 2, 3], (a) => a < 5), true
    }
    {
        ; 都不大于 4, 所以返回 false
        __Assert ArrayUtil.some([1, 2, 3], (a) => a > 4), false
        ; 3 比 2 大, 所以返回 true
        __Assert ArrayUtil.some([1, 2, 3], (a) => a > 2), true
    }
    {
        ; 移除所有符合的项
        temp := [0, 1, 1, 2]
        __Assert ArrayUtil.remove(temp, 1), [0, 2]
        __Assert temp, [0, 2]
        ; 只移除 1 次符合的项
        temp := [0, 1, 1, 2]
        __Assert ArrayUtil.remove(temp, 1, 1), [0, 1, 2]
        __Assert temp, [0, 1, 2]
    }
    {
        ; 移除所有符合的项
        temp := [0, 1, 1, 2]
        __Assert ArrayUtil.removeAll(temp, [1, 2]), [0]
        __Assert temp, [0]
        ; 只移除 1 次符合的项
        temp := [0, 1, 1, 2]
        __Assert ArrayUtil.removeAll(temp, [1, 2], 1), [0, 1]
        __Assert temp, [0, 1]
    }
    {
        ; 找到第一个匹配的项,后面的忽略
        __Assert ArrayUtil.find([1, 2, 3, 4], (a) => a > 2), 3
        ; 默认值
        __Assert ArrayUtil.find([1, 2, 3, 4], (a) => a > 7), ""
        __Assert ArrayUtil.find([1, 2, 3, 4], (a) => a > 7, "NULL"), "NULL"
    }
    {
        __Assert ArrayUtil.findAll([1, 2, 3, 4], (a) => a > 2), [3, 4]
        __Assert ArrayUtil.findAll([1, 2, 3, 4], (a) => a > 7), []
    }
    {
        __Assert ArrayUtil.includes([1, 2], 3), false
        __Assert ArrayUtil.includes([1, 2], 2), true
        __Assert ArrayUtil.includes(["a", "B"], "B"), true
        __Assert ArrayUtil.includes(["a", "b"], "B"), false
    }
    {
        __Assert ArrayUtil.includeSome([1, 2], 3, 4), false
        __Assert ArrayUtil.includeSome([1, 2], 3, 2), true
        __Assert ArrayUtil.includeSome(["a", "B"], "B"), true
        __Assert ArrayUtil.includeSome(["a", "b"], "B"), false
    }
    {
        __Assert ArrayUtil.includeEvery([1, 2], 3, 4), false
        __Assert ArrayUtil.includeEvery([1, 2], 2, 1), true
        __Assert ArrayUtil.includeEvery(["a", "B"], "B"), true
        __Assert ArrayUtil.includeEvery(["a", "b"], "B", "a"), false
        __Assert ArrayUtil.includeEvery(["a", "b"], "b", "a"), true
    }
    ; TODO: indexOf
} catch Error as e {
    throw e
}

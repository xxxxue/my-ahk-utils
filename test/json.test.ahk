#Include "../include-all.ahk"

try {
    ; 由于 ahk object 自身的问题 ( object 初始化后,会自动按照英文字母重新排列 key )
    ; 导致 json 字符串中 key 顺序与源码中的不同
    ; https://github.com/thqby/ahk2_lib/issues/83
    {
        ; 一般都是要指定为 false , 
        ; 否则会 对象->string->map . 对象获取值 和 map获取值 不通用,就会报错
        a := JSON.parse('{"a":1,"b":[1,2,3,4,5]}', , false)
        __Assert a.a, 1
        __Assert a.b, [1, 2, 3, 4, 5]
    }
    {
        data := {
            a: 1,
            b: [1, 2, 3, 4, 5]
        }
        a := JSON.stringify(data)
        __Assert Type(a), "String"
        ; FileUtil.fileWrite(a, "./json_test.json")
    }
} catch Error as e {
    throw e
}

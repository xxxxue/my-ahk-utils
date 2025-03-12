#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../include-all.ahk"
try {
    {
        name := "a"
        if StringUtil.nameOf(&name) != "name" {
            throw "error"
        }
    }
    {
        __Assert StringUtil.remove("abc", "b"), "ac"
        __Assert StringUtil.remove("abcb", "b"), "ac"
        __Assert StringUtil.remove("abc", "c"), "ab"
    }
    {
        __Assert StringUtil.removeLeft("a5bc", "a"), "5bc"
        __Assert StringUtil.removeLeft("abca", "a"), "bca"
        __Assert StringUtil.removeLeft("abc", "b"), "abc"
        __Assert StringUtil.removeLeft("abc", "c"), "abc"
    }
    {
        __Assert StringUtil.removeRight("ac3c", "c"), "ac3"
        __Assert StringUtil.removeRight("abc", "b"), "abc"
        __Assert StringUtil.removeRight("abc", "a"), "abc"
    }
    {
        __Assert StringUtil.padStart("123", 6, "z"), "zzz123"
        __Assert StringUtil.padStart("12", 10, "YYYY-MM-DD"), "YYYY-MM-12"
        __Assert StringUtil.padStart("09-12", 10, "YYYY-MM-DD"), "YYYY-09-12"
    }
    {
        __Assert StringUtil.padEnd("xxx123", 2, "ab"), "xxx123"
        __Assert StringUtil.padEnd("12", 10, "YYYY-MM-DD"), "12YYYY-MM-"
        __Assert StringUtil.padEnd("09-12", 10, "YYYY-MM-DD"), "09-12YYYY-"
    }
    {
        __Assert StringUtil.repeat("a", 3), "aaa"
        __Assert StringUtil.repeat("hello", 2), "hellohello"
    }
    {
        item_index := 1
        for item in StringUtil.forEnumerator("abc", 1) {
            if item_index == 1 {
                __Assert(item, "a")
            } else if item_index == 2 {
                __Assert(item, "b")
            } else if item_index == 3 {
                __Assert(item, "c")
            } else {
                throw "item_index cannot be greater than 3"
            }
            item_index++
        }
        for index, item in StringUtil.forEnumerator("abc", 2) {
            if index == 1 {
                __Assert(item, "a")
            } else if index == 2 {
                __Assert(item, "b")
            } else if index == 3 {
                __Assert(item, "c")
            } else {
                throw "index cannot be greater than 3"
            }
        }
    }
    {
        __Assert StringUtil.subString("1234567", -3, 2), "2345" ;ahk索引从 1 开始, 倒数第三个是索引 5, 所以结果为索引 2 到 索引 5 的字符
        __Assert StringUtil.subString("1234567", 2, 4), "234"
    }
    {
        __Assert StringUtil.toCode("asdf"), "97115100102"
    }
    {
        __Assert StringUtil.toCodes("asdf"), [97, 115, 100, 102]
    }
    {
        __Assert StringUtil.split("111.222.333", "."), ["111", "222", "333"]
        __Assert StringUtil.split("111.222.333", ".", 1), ["111", "222.333"]
        __Assert StringUtil.split("fff"), ["f", "f", "f"]
        __Assert StringUtil.split("abc.", ".", 1), ["abc", ""]
        __Assert StringUtil.split(".abc", ".", 1), ["", "abc"]
        __Assert StringUtil.split("1 a 3s  6x", [A_Space, A_Tab]), ["1", "a", "3s", "", "6x"]
    }
    {
        __Assert StringUtil.splitRight("111.222.333", "."), ["111", "222", "333"]
        __Assert StringUtil.splitRight("111.222.333", ".", 1), ["111.222", "333"]
        __Assert StringUtil.splitRight("fff"), ["f", "f", "f"]
        __Assert StringUtil.splitRight("abc.", ".", 1), ["abc", ""]
        __Assert StringUtil.splitRight(".abc", ".", 1), ["", "abc"]
        __Assert StringUtil.splitRight("1 a 3s  6x", [A_Space, A_Tab]), ["1", "a", "3s", "", "6x"]
    }
    {
        __Assert StringUtil.startsWith("111.222.333", "111"), true
        __Assert StringUtil.startsWith("asdf", "A"), false
        __Assert StringUtil.startsWith("asdf", "a", false), true
        __Assert StringUtil.startsWith("111.222.333", "2.333"), false
        __Assert StringUtil.startsWith("111.222.333", "222"), false
    }
    {
        __Assert StringUtil.endsWith("111.222.333", "111"), false
        __Assert StringUtil.endsWith("asdf", "F"), false
        __Assert StringUtil.endsWith("asdf", "F", false), true
        __Assert StringUtil.endsWith("asdf", "f"), true
        __Assert StringUtil.endsWith("111.222.333", "2.333"), true
        __Assert StringUtil.endsWith("111.222.333", "222"), false
    }
    {
        __Assert StringUtil.includes("123", "2"), true
        __Assert StringUtil.includes("qwe", "2"), false
        __Assert StringUtil.includes("123", "123"), true
        __Assert StringUtil.includes("asd", "ASD"), false
        __Assert StringUtil.includes("asd", "ASD", false), true
        __Assert StringUtil.includes("asd", "ASDF"), false
    }
    {
        __Assert StringUtil.IncludeSome("123", ["2"]), true
        __Assert StringUtil.IncludeSome("123", ["2", "c"]), true
        __Assert StringUtil.IncludeSome("abc", ["A", "B"]), false
        __Assert StringUtil.IncludeSome("abc", ["A", "B"], false), true
    }
    {
        __Assert StringUtil.includeEvery("123", ["2"]), true
        __Assert StringUtil.includeEvery("123", ["2", "c"]), false
        __Assert StringUtil.includeEvery("abc", ["A", "B", "C"]), false
        __Assert StringUtil.includeEvery("abc", ["A"], false), true
    }
    {
        __Assert StringUtil.indexOf("abc", "b"), 2
        __Assert StringUtil.indexOf("abc", "B"), 0
        __Assert StringUtil.indexOf("abc", "B", false), 2
    }
    {
        __Assert StringUtil.indexOfAll("abcbbbc", "b"), [2, 4, 5, 6]
        __Assert StringUtil.indexOfAll("abcbbbc", "B"), []
        __Assert StringUtil.indexOfAll("abcbbbc", "B", false), [2, 4, 5, 6]
    }
    {
        __Assert StringUtil.lastIndexOf("abcba", "b"), 4
        __Assert StringUtil.lastIndexOf("abcba", "B"), 0
        __Assert StringUtil.lastIndexOf("abcba", "B", false), 4
    }
    {
        __Assert StringUtil.trim(" abcba "), "abcba"
        __Assert StringUtil.trim(" abcba    "), "abcba"
        __Assert StringUtil.trim("aba", "a"), "b"
    }
    ;  ----- NEW
    {
        __Assert StringUtil.trim2(" abcba "), "abcba"
        __Assert StringUtil.trim2(" abcba    "), "abcba"
        __Assert StringUtil.trim2("aba", "a"), "b"
    }
    {
        __Assert StringUtil.trimLeft(" abcba "), "abcba "
        __Assert StringUtil.trimLeft(" abcba    "), "abcba    "
        __Assert StringUtil.trimLeft("aba", "a"), "ba"
    }
    {
        __Assert StringUtil.trimStart(" abcba "), "abcba "
        __Assert StringUtil.trimStart(" abcba    "), "abcba    "
        __Assert StringUtil.trimStart("aba", "a"), "ba"
    }
    {
        __Assert StringUtil.trimRight(" abcba "), " abcba"
        __Assert StringUtil.trimRight(" abcba    "), " abcba"
        __Assert StringUtil.trimRight("aba", "a"), "ab"
    }
    {
        __Assert StringUtil.trimEnd(" abcba "), " abcba"
        __Assert StringUtil.trimEnd(" abcba    "), " abcba"
        __Assert StringUtil.trimEnd("aba", "a"), "ab"
    }
    {
        __Assert StringUtil.lengthAndTrim(" abcba "), 5
        __Assert StringUtil.lengthAndTrim(" abcba    "), 5
        __Assert StringUtil.lengthAndTrim("aba"), 3
        __Assert StringUtil.lengthAndTrim("        "), 0
    }
    {
        __Assert StringUtil.length(" abcba "), 7
        __Assert StringUtil.length(" abcba    "), 10
        __Assert StringUtil.length("aba"), 3
        __Assert StringUtil.length("        "), 8
    }
    {
        __Assert StringUtil.charCodeAt("abcde", 2), 98
        __Assert StringUtil.charCodeAt("水果", 2), 26524
    }
    {
        __Assert StringUtil.concat("a", 1, "b", 2), "a1b2"
    }
    {
        __Assert StringUtil.wrap("a", "##"), "##a##"
    }
    {
        __Assert StringUtil.toString("a"), '"a"'
    }
    {
        __Assert StringUtil.replace("xaabcaa", "a", ""), "xbc"
    }
    {
        __Assert StringUtil.padStart2("a", 5, "b"), "bbbba"
        __Assert StringUtil.padStart2("a", 5), "    a"
        __Assert StringUtil.padStart2("aaa", 1), "aaa"
    }
    {
        __Assert StringUtil.padEnd2("a", 5, "b"), "abbbb"
        __Assert StringUtil.padEnd2("a", 5), "a    "
        __Assert StringUtil.padEnd2("aaa", 1), "aaa"
    }
    {
        __Assert StringUtil.subString2("12345", 2), "2345"
        __Assert StringUtil.subString2("12345", 8), ""
        __Assert StringUtil.subString2("12345", 2, 4), "234"
    }
    {
        __Assert StringUtil.slice("12345", 2), "2345"
        __Assert StringUtil.slice("12345", 8), ""
        __Assert StringUtil.slice("12345", 2, 4), "234"
    }
    {
        __Assert StringUtil.split2("12345"), ["1", "2", "3", "4", "5"]
        __Assert StringUtil.split2("12345", , 2), ["1", "2345"]
        __Assert StringUtil.split2("1.2.3.4.5", "."), ["1", "2", "3", "4", "5"]
        __Assert StringUtil.split2("1.2.3.4.5", ".", 2), ["1", "2.3.4.5"]
    }
    {
        __Assert StringUtil.startsWith2("12345", "1"), true
        __Assert StringUtil.startsWith2("12345", "1", 2), false
        __Assert StringUtil.startsWith2("12345", "1", 1), true
        __Assert StringUtil.startsWith2("12345", "2"), false
    }
    {
        __Assert StringUtil.endsWith2("12345", "5"), true
        __Assert StringUtil.endsWith2("12345", "1", 2), false
        __Assert StringUtil.endsWith2("12345", "1", 1), true
        __Assert StringUtil.endsWith2("12345", "1"), false
    }
    {
        __Assert StringUtil.reverse("12345"), "54321"
    }
    {
        ; toLowerCase
        __Assert StringUtil.toCode(StringUtil.toLowerCase("A")), StringUtil.toCode("a")
    }
    {
        ; toUpperCase
        __Assert StringUtil.toCode(StringUtil.toUpperCase("a")), StringUtil.toCode("A")
    }
    {
        ;  //NOTE: urlEncode
    }
    {
        __Assert StringUtil.isEmpty(""), true
        __Assert StringUtil.isEmpty("    "), true
        __Assert StringUtil.isEmpty("a"), false
        __Assert StringUtil.isEmpty("  a  "), false
    }
} catch Error as e {
    throw e
}

# my-ahk-utils

常用的 AutoHotKey 工具库

## 使用

到源码中查看具体有哪些函数

```js
#Include <my-ahk-utils\include-all>

; 所有的类都是以 Util 结尾
StringUtil.includes("123", "2") ; true
```

### script library folders

https://www.autohotkey.com/docs/v2/Scripts.htm#lib

ahk 会自动在 3 个位置寻找库的代码

- Documents 的 Lib 文件夹 (推荐),
  - C:\Users\admin\Documents\AutoHotkey\Lib
- ahk 安装目录中的 Lib 文件夹
- 当前项目的 Lib 文件夹

下面将源码软链接到 Documents 目录

我的文件夹层级:

```
AutohotkeyProject
    my-ahk-utils
        include-all.ahk
    hello-ahk
        main.ahk
```

需要先手动在 Documents 中创建名称为 AutoHotkey 的目录,

然后使用 cmd 执行下面的命令

```bash
mklink /J C:\Users\admin\Documents\AutoHotkey\Lib D:\Work\AutohotkeyProject
```
## vscode plugin

https://github.com/mark-wiemer/ahkpp

## code ref

很多高级的功能, 各种第三方库 和 windows api 封装

https://github.com/thqby/ahk2_lib

https://github.com/Autumn-one/ahk-standard-lib

https://github.com/iseahound/Environment.ahk
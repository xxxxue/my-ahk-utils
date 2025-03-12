# my-ahk-utils

常用的 AutoHotKey 工具库

## install

到源码中查看具体有哪些函数

```js
#Include <my-ahk-utils\include-all>

; 所有的类都是以 Util 结尾
StringUtil.includes("123", "2") ; true
```

## script library folders

https://www.autohotkey.com/docs/v2/Scripts.htm#lib

ahk 会自动在 3 个位置寻找库的代码

- Documents 的 Lib 文件夹 (推荐), 
  - C:\Users\admin\Documents\AutoHotkey\Lib
- ahk 安装目录中的 Lib 文件夹
- 当前项目的 Lib 文件夹

下面的脚本是将源码放到 Documents 目录

修改 `target_dir`, 执行后, 

在桌面上会创建 `ahk_lib_dir_link_tool` 文件夹, 里面有 bat 脚本, 

运行 `create-link.bat`

将本地的源码文件夹映射到 Lib 目录,

然后就可以在脚本中导入文件夹名称, 不需要再写绝对路径

我的文件夹层级:

```
AutohotkeyProject
    my-ahk-utils
        include-all.ahk
    hello-ahk
        main.ahk
```

```js
#Requires AutoHotkey v2.0
#SingleInstance Force

; 自己的 AutoHotKey 代码目录
target_dir := "D:\Work\AutohotkeyProject"

create_dir(p_dir_path) {
    if !DirExist(p_dir_path) {
        DirCreate(p_dir_path)
    }
}

document_ahk_dir := A_MyDocuments "\AutoHotkey"
create_dir(document_ahk_dir)

desktop_bat_dir := A_Desktop "\ahk_lib_dir_link_tool"
if DirExist(desktop_bat_dir) {
    throw desktop_bat_dir " is exist"
}
create_dir(desktop_bat_dir)

create_link_command_str := "mklink /J " document_ahk_dir "\Lib " target_dir
remove_link_command_str := "rmdir " document_ahk_dir "\Lib"

FileAppend(create_link_command_str, desktop_bat_dir "\create-link.bat", "UTF-8")
FileAppend(remove_link_command_str, desktop_bat_dir "\remove-link.bat", "UTF-8")
```
## vscode plugin

https://github.com/mark-wiemer/ahkpp

## code ref

很多高级的功能, 各种第三方库 和 windows api 封装

https://github.com/thqby/ahk2_lib

https://github.com/Autumn-one/ahk-standard-lib

https://github.com/iseahound/Environment.ahk
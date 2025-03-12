class GuiUtil {
    static getYaHeiUIFontName() {
        return "Microsoft YaHei UI"
    }

    /**
     * 显示一个对话框
     * @param p_text 内容
     * @param p_open_ok_cancel_btn 显示确认与取消按钮
     * @param p_ok_fn 点击确定后执行的方法
     * @param p_font_size 字体大小
     * @param p_font_name 字体名称
     */
    static msgBox(
        p_text,
        p_open_ok_cancel_btn := false,
        p_ok_fn := "",
        p_font_size := 14,
        p_font_name := this.getYaHeiUIFontName()
    ) {
        g := Gui()
        g.Title := "提示:"
        g.SetFont("s" p_font_size, p_font_name)
        g.AddText("", p_text)
        if p_open_ok_cancel_btn {
            timer_time_number := 6
            control_text := g.AddText("cRed", "请仔细阅读," timer_time_number " 秒后,解锁确定按钮")
            SetTimer(timer_show_btn, 1000)
            control_btn := g.AddButton("Disabled", "确定")
            control_btn.OnEvent("Click", ok_fn)
            ok_fn(*) {
                if p_ok_fn {
                    p_ok_fn()
                }
                g.Destroy()
            }
            timer_show_btn() {
                if control_text && control_btn {
                    timer_time_number--
                    control_text.Text := "请仔细阅读," timer_time_number " 秒后,解锁确定按钮"
                    if timer_time_number <= 0 {
                        control_text.Opt("+Hidden")
                        control_btn.Opt("-Disabled")
                        ;  停止 timer
                        SetTimer(, 0)
                    }
                } else {
                    SetTimer(, 0)
                }
            }
            g.AddButton("x+m", "取消").OnEvent("Click", (*) => destory_gui())
            destory_gui() {
                control_text := ""
                control_btn := ""
                g.Destroy()
            }
        }
        g.Show()
    }

    /**
     * 高性能刷新控件数据 (防止闪烁,减少重绘次数)
     * @param { Gui.DDL | Gui.DropDownList | Gui.ComboBox | Gui.ListBox | Gui.Tab} p_control 控件 (必须是指定类型的控件, 其他控件没有 delete / add 方法)
     * @param { Array } p_items 添加的内容 
     */
    static refreshDataControl(p_control, p_items) {
        ; 关掉重绘, 数据量大时，可防止闪烁，减少重绘次数，提升性能
        p_control.Opt("-Redraw")
        ; 清空
        p_control.Delete()
        ; 添加数据
        p_control.Add(p_items)
        ; 开启重绘
        p_control.Opt("+Redraw")
    }

    /**
     * 在鼠标位置显示 ToolTip,并自动销毁
     * @param msg 
     */
    static showTip(msg, p_period := -2000) {
        ToolTip(msg)
        SetTimer(() => ToolTip(), p_period)
    }

    /**
     * 创建控件的 options , 只需把参数放到数组, 
     * 
     * (如果不用那就需要写一长串的 string)
     * @param {Array<String>} p_options_arr 数组
     * @returns {String} 用空格拼接好的字符串
     */
    static createControlOptions(p_options_arr) {
        return ArrayUtil.join(p_options_arr, " ")
    }

    /**
     * 设置托盘图标的图片
     * 
     * (标准库这个函数,没有文件时会报错,所以用这个包一层)
     * @param p_img_path 图片路径
     */
    static traySetIcon(p_img_path) {
        if FileExist(p_img_path) {
            TraySetIcon(p_img_path)
        }
    }
    /**
     * 添加一个菜单项, 并设置为 双击托盘图标默认执行
     * 
     * (如果不希望添加菜单项, 请使用 标准库的 A_TrayMenu.Default:="my_name")
     * @param {Func} fn 执行的函数,在调用 show 和 一些逻辑
     * @param {String} menu_item_name 菜单项的名称
     * @param {Integer} is_double_click 是否双击, 默认是双击, false 单击
     * @param {Integer} add_top_divider 上方添加 1 条分割线
     * @param {Integer} add_bottom_divider 下方添加 1 条分割线
     * @example
     * GuiUtil.trayClickExecMenuItem(show_gui, "打开界面")
     * show_gui() {
     *     g_gui.Show()
     * }
     */
    static trayClickExecMenuItem(fn, menu_item_name := "打开界面", is_double_click := true, add_top_divider := true, add_bottom_divider := false) {
        if add_top_divider {
            A_TrayMenu.Add()
        }
        A_TrayMenu.Add(menu_item_name, (*) => fn())
        if add_bottom_divider {
            A_TrayMenu.Add()
        }
        A_TrayMenu.Default := menu_item_name
        A_TrayMenu.ClickCount := is_double_click ? 2 : 1
    }
}

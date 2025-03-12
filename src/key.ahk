class KeyUtil {
    /**
     * vk 转 名称
     * 
     * 核心代码:
     * GetKeyName参数 和 按键历史列表中是十六进制的. 程序中是 十进制, 不可以直接获取. 需要先 Format 为 十六进制
     * @param {Number | String} p_virtualKey 9="Tab" , 
     * @returns {String}
     */
    static virtualKeyToKeyName(p_virtualKey) {
        return GetKeyName(Format("vk{:X}", p_virtualKey))
    }
    /**
     * sc 转 名称
     * 
     * 核心代码:
     * GetKeyName参数 和 按键历史列表中是十六进制的. 程序中是 十进制, 不可以直接获取. 需要先 Format 为 十六进制
     * @param {Number | String} p_scanCode 15="Tab"
     * @returns {String}
     */
    static scanCodeToKeyName(p_scanCode) {
        return GetKeyName(Format("sc{:X}", p_scanCode))
    }
    /**
     * 等待任意一个按键,并返回 keyName, 无按键则返回 ""
     * 
     * 使用前请开启键盘Hook #UseHook true
     * 
     * 已知问题,拦截不到已经被定义热键的键
     * @param {String} p_options 
     * @param {bool} p_listen_key_down 
     * @returns {String} 大小写敏感, 常用的修饰键 LControl,LAlt,LShift
     */
    static keyWaitAny(p_options := "T3", p_listen_key_down := true) {
        key_name := ""
        ih := InputHook(p_options)
        ih.KeyOpt("{All}", "N")
        ih.MinSendLevel := 1
        if p_listen_key_down {
            ih.OnKeyDown := fn
        } else {
            ih.OnKeyUp := fn
        }
        ih.Start()
        ih.Wait()
        fn(InputHookObj, VirtualKey, ScanCode) {
            key_name := KeyUtil.virtualKeyToKeyName(VirtualKey)
            InputHookObj.Stop()
        }
        return key_name
    }
}

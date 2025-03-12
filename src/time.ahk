class TimeUtil {
    /**
     * 格式化后的当前时间 (人类可读的格式,常用来显示), 
     * 
     * 如果想要自定义请使用 FormatTime() 或用 A_Year A_Mon 等变量去拼接
     * @example
     * 2001-01-16 23:44:37.912
     * @returns {String} 
     */
    static nowFormat() {
        return FormatTime(, "yyyy-MM-dd HH:mm:ss.") A_MSec
    }
    /**
     * 当前时间 (精确到毫秒) 最后 3 位是毫秒
     * 
     * 不想要毫秒,请使用标准库的 A_Now
     * @example
     * 20120116234605138
     * @returns {String} 
     */
    static now() {
        return A_Now A_MSec
    }
    /**
     * 当前时间 (精确到毫秒 并转为数字类型)
     * @example
     * 20120116234605138
     * @returns {Integer} 
     */
    static nowNumber() {
        return (A_Now A_MSec) * 1
    }
}

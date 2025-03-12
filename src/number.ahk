class NumberUtil {
    /**
     * 返回数字对应的字符
     * 
     * 66.ToChar() // "B"
     * @returns {String} 
     */
    static toChar(num) {
        return Chr(num)
    }
    static toString(num) {
        return String(num)
    }
    /**
     * 10 进制转 16 进制 (30->1e)
     * @param {String|Number} p_number_data 
     * @returns {String}
     */
    static convert_10To16(p_number_data) {
        if IsNumber(p_number_data) {
            return Format("{:X}", p_number_data)
        } else {
            throw p_number_data " 不是有效的数字"
        }
    }
    /**
     * 10 进制转 16 进制 (30->0x1e)
     * @param {String|Number} p_number_data 
     * @returns {String}
     */
    static convert_10To16_0x(p_number_data) {
        if IsNumber(p_number_data) {
            return Format("{:#x}", p_number_data)
        } else {
            throw p_number_data " 不是有效的数字"
        }
    }
    /**
     * 16 进制转 10 进制 (0x1E->30)
     * @param {String|Number} p_number_data "0xEE" | 0xEE
     * @returns {Number}
     */
    static convert_16To10(p_number_data) {
        ; return Number(Format("{:d}", p_number_data))
        if IsNumber(p_number_data) {
            return Number(p_number_data)
        } else {
            throw p_number_data " 不是有效的数字"
        }
    }
}

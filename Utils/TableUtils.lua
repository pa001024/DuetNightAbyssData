local function TableToStringPretty(obj1)
    local str_repeat, str_gsub = string.rep, string.gsub
    local pairs, type, tostring, next = pairs, type, tostring, next
    local quotes = {
        ["\t"] = "\\t",
        ["\r"] = "\\r",
        ["\n"] = "\\n",
        ["\""] = "\\\"",
        ["\\"] = "\\\\"
    }
    local get_indent = function(level)
    end
    local quote_str = function(str)
    end
    local wrap_key = function(val)
    end
    local wrap_val = function(val, level)
    end
    local is_array = function(arr)
    end
    local dump_obj = function(obj, level)
    end

    function get_indent(level)
        return str_repeat("\t", level)
    end

    function quote_str(str)
        str = str_gsub(str, "[%c\\\"]", quotes)
        return "\"" .. str .. "\""
    end

    function wrap_key(val)
        if "number" == type(val) or "boolean" == type(val) then
            return "[" .. tostring(val) .. "]"
        elseif "string" == type(val) then
            return "[" .. quote_str(val) .. "]"
        end
    end

    function wrap_val(val, level)
        if "table" == type(val) then
            return dump_obj(val, level)
        elseif "number" == type(val) then
            if val ~= math.huge and val ~= -math.huge then
                return tostring(val)
            end
        elseif "string" == type(val) then
            return quote_str(val)
        elseif "boolean" == type(val) then
            return tostring(val)
        end
    end

    function is_array(arr)
        local count, ret = 0, true
        for k, v in pairs(arr) do
            count = count + 1
            if ret and count ~= k then
                ret = false
            end
        end
        return ret, count
    end

    function dump_obj(obj, level)
        if "table" ~= type(obj) then
            return wrap_val(obj)
        end
        level = level + 1
        local indent = nil ~= next(obj) and get_indent(level) or ""
        local tokens = {"{"}
        local ret, count = is_array(obj)
        if ret then
            for i = 1, count do
                local wrapped_val = wrap_val(obj[i], level)
                if wrapped_val then
                    tokens[#tokens + 1] = indent .. wrapped_val .. ","
                end
            end
        else
            local keys = {}
            for k, _ in pairs(obj) do
                table.insert(keys, {wrap_key(k), k})
            end
            table.sort(keys, function(a, b)
                return a[1] < b[1]
            end)
            for _, kt in ipairs(keys) do
                local k = kt[2]
                local v = obj[k]
                local wrapped_key = kt[1]
                local wrapped_val = wrap_val(v, level)
                if wrapped_key and wrapped_val then
                    tokens[#tokens + 1] = indent .. wrapped_key .. " = " .. wrapped_val .. ","
                end
            end
        end
        tokens[#tokens + 1] = get_indent(level - 1) .. "}"
        return table.concat(tokens, "\n")
    end

    return dump_obj(obj1, 0)
end

local TableUtils = {}

---@param Table table
---@return string
function TableUtils:Dump(Table)
    local TableStr = TableToStringPretty(Table)
    return TableStr
end

return TableUtils

local bson = require("bson")
local zlib = require("zlib")
local bOpenCompress = false
local SerializeUtils = {}

local function IsObjId(str)
  if 14 == #str and 0 == string.byte(string.sub(str, 1, 1)) then
    return true
  end
  return false
end

function SerializeUtils:ToStringEx(value)
  local ValueType = type(value)
  if "table" == ValueType then
    return self:TableToStr(value)
  elseif "string" == ValueType then
    if IsObjId(value) then
      return self:SerializeObjId(value)
    else
      return string.format("%q", value)
    end
  elseif "number" == ValueType or "boolean" == ValueType then
    return tostring(value)
  elseif "userdata" == ValueType then
    return self:SerializeUserdata(value)
  end
end

function SerializeUtils:IsArrayTable(t)
  if not t or type(t) ~= "table" then
    return false
  end
  local max_index = 0
  local count = 0
  for key, _ in pairs(t) do
    if type(key) == "number" then
      if key ~= math.floor(key) then
        return false
      end
      if key <= 0 then
        return false
      end
      if key > max_index then
        max_index = key
      end
      count = count + 1
    else
      return false
    end
  end
  if 0 == count then
    return true
  end
  return max_index == count
end

function SerializeUtils:TableToStr(t)
  if nil == t then
    return ""
  end
  local retstr = "{"
  if SerializeUtils:IsArrayTable(t) then
    for i = 1, #t do
      local signal = ","
      if 1 == i then
        signal = ""
      end
      retstr = retstr .. signal .. self:ToStringEx(t[i])
    end
  else
    local signal = ""
    for key, value in pairs(t) do
      if type(key) == "number" or type(key) == "string" then
        retstr = retstr .. signal .. "[" .. self:ToStringEx(key) .. "]=" .. self:ToStringEx(value)
      elseif type(key) == "userdata" then
        retstr = retstr .. signal .. "*s" .. self:TableToStr(getmetatable(key)) .. "*e" .. "=" .. self:ToStringEx(value)
      else
        retstr = retstr .. signal .. key .. ":" .. self:ToStringEx(value)
      end
      signal = ","
    end
  end
  retstr = retstr .. "}"
  return retstr
end

function SerializeUtils:StrToTable(str)
  print(_G.LogTag, str)
  if nil == str or type(str) ~= "string" or "" == str then
    return {}
  end
  return load("return " .. str)()
end

local function DefaultSerializeUserdata(value)
  return "\"" .. tostring(value) .. "\""
end

function SerializeUtils:SerializeUserdata(value)
  local result = {}
  if not value.IsSerializable or not value:IsSerializable() then
    print(_G.LogTag, "SerializeUtils:SerializeUserdata Failed for bSerialized is not exist.")
    return DefaultSerializeUserdata(value)
  end
  local str = CommonUtils.Split(tostring(value), ":")
  result.SerializeName = str[1]
  local ValueString = value:ToString()
  ValueString = string.gsub(ValueString, "\r\n", "")
  ValueString = string.gsub(ValueString, "%s+", "")
  result.ValueString = ValueString
  return self:TableToStr(result)
end

function SerializeUtils:SerializeObjId(value)
  local result = {}
  local ret = ""
  for index = 3, #value do
    ret = ret .. string.format("%02X", string.byte(string.sub(value, index, index)))
  end
  result.ObjIdStr = ret
  return self:TableToStr(result)
end

function SerializeUtils:TransformTable(Table)
  if Table.SerializeName then
    local userdata = load("return " .. Table.SerializeName .. "()")()
    userdata:InitFromString(Table.ValueString)
    return userdata
  elseif Table.ObjIdStr then
    return bson.objectid(Table.ObjIdStr)
  end
  for key, value in pairs(Table) do
    if type(value) == "table" then
      Table[key] = self:TransformTable(value)
    end
  end
  return Table
end

function SerializeUtils:Serialize(Table, threshold)
  threshold = threshold or 1024
  local Serialized = self:TableToStr(Table)
  if bOpenCompress and threshold < #Serialized then
    return self:CompressString(Serialized)
  else
    return Serialized
  end
end

function SerializeUtils:UnSerialize(TableStr)
  if not TableStr or "" == TableStr then
    return {}
  end
  TableStr = self:DecompressString(TableStr)
  return self:TransformTable(self:StrToTable(TableStr))
end

function SerializeUtils:CompressString(str)
  if not str or "" == str then
    return str
  end
  if #str < 100 then
    return str
  end
  local ok, compressed = pcall(function()
    local deflate = zlib.deflate()
    return deflate(str, "finish")
  end)
  if not ok or not compressed then
    print(_G.LogTag, "Compression failed: " .. tostring(compressed))
    return str
  end
  if #compressed >= #str then
    return str
  end
  local header = string.pack(">B", 90)
  return header .. compressed
end

function SerializeUtils:DecompressString(Str)
  if not Str or "" == Str then
    return Str
  end
  if #Str <= 1 or 90 ~= Str:byte(1) then
    return Str
  end
  local compressed_data = Str:sub(2)
  local ok, decompressed = pcall(function()
    local inflate = zlib.inflate()
    return inflate(compressed_data, "finish")
  end)
  if not ok or not decompressed then
    error("Decompression failed: " .. tostring(decompressed))
  end
  return decompressed
end

return SerializeUtils

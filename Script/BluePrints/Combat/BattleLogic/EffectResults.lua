local msgpack = require("msgpack_core")
local WeaponAppearanceFields = {
  {name = "SkinId", type = "number"},
  {name = "GradeLevel", type = "number"},
  {
    name = "Colors",
    type = "table",
    schema = {
      {name = "Colors", type = "table"},
      {
        name = "SpecialColor",
        type = "number"
      }
    }
  },
  {
    name = "AccessorySuit",
    type = "table"
  }
}
local SchemaRegistry = {
  [1] = {
    Name = "WeaponBornInfo",
    Fields = {
      {
        name = "AppearanceInfo",
        type = "table",
        schema = WeaponAppearanceFields
      }
    }
  },
  [2] = {
    Name = "CharAppearanceSuit",
    Fields = {
      {name = "SkinId", type = "number"},
      {name = "SkinLevel", type = "number"},
      {name = "HairId", type = "number"},
      {name = "Colors", type = "table"},
      {name = "HairColors", type = "table"},
      {
        name = "AccessorySuit",
        type = "table"
      },
      {
        name = "AccessoryCustomParams",
        type = "table"
      },
      {
        name = "IsCornerVisible",
        type = "boolean"
      }
    }
  }
}
local SchemaIds = {WeaponBornInfo = 1, CharAppearanceSuit = 2}

local function NotifyError(Msg)
  pcall(function()
    Battle(GWorld.GameInstance):ShowBattleError(Msg)
  end)
end

local SeenUnknownFields = {}

local function HintUnknownField(Name)
  if SeenUnknownFields[Name] then
    return
  end
  SeenUnknownFields[Name] = true
  pcall(function()
    DebugPrint("SchemaPack", "字段[" .. Name .. "] 不在 schema 中，按动态字段同步；若非动态字段，建议加入 schema")
  end)
end

local function ArrayHeader(N)
  if N <= 15 then
    return string.char(144 + N)
  end
  return string.char(220, math.floor(N / 256), N % 256)
end

local function PackScalar(V)
  return string.sub(msgpack.pack({V}), 3)
end

local PackLeaf

function PackLeaf(Value)
  local T = type(Value)
  if "table" ~= T then
    return PackScalar(Value)
  end
  local N = #Value
  if N > 0 and nil ~= Value[1] and nil ~= Value[N] then
    local Count = 0
    local IsArray = true
    for K in pairs(Value) do
      Count = Count + 1
      if type(K) ~= "number" or 0 ~= K % 1 or K < 1 or K > N then
        IsArray = false
        break
      end
    end
    if IsArray and Count == N then
      local Parts = {
        ArrayHeader(N)
      }
      for I = 1, N do
        Parts[I + 1] = PackLeaf(Value[I])
      end
      return table.concat(Parts)
    end
  end
  return msgpack.pack(Value)
end

local PackSchema

function PackSchema(Data, Schema)
  local Indices = {}
  local Values = {}
  local Consumed = {}
  for Idx, Field in ipairs(Schema) do
    local Name = Field.name
    Consumed[Name] = true
    local Value = Data[Name]
    if nil ~= Value then
      local Expected = Field.schema and "table" or Field.type
      if type(Value) == Expected then
        local Packed
        if Field.schema then
          Packed = PackSchema(Value, Field.schema)
        else
          Packed = PackLeaf(Value)
        end
        if Packed then
          Indices[#Indices + 1] = Idx
          Values[#Values + 1] = Packed
        else
          NotifyError("SchemaPack: 字段[" .. Name .. "]打包返回 nil（值类型可能不支持），已跳过 — 找战斗程序")
        end
      else
        NotifyError("SchemaPack: 字段[" .. Name .. "]应为 " .. Expected .. "，实为 " .. type(Value) .. "，已跳过 — 找战斗程序")
      end
    end
  end
  local Unknown = {}
  for K, V in pairs(Data) do
    if nil == Consumed[K] then
      Unknown[K] = V
      HintUnknownField(tostring(K))
    end
  end
  local PiParts = {
    ArrayHeader(#Indices)
  }
  for _, Idx in ipairs(Indices) do
    PiParts[#PiParts + 1] = PackScalar(Idx)
  end
  local PvParts = {
    ArrayHeader(#Values)
  }
  for I = 1, #Values do
    PvParts[I + 1] = Values[I]
  end
  return ArrayHeader(3) .. table.concat(PiParts) .. table.concat(PvParts) .. msgpack.pack(Unknown)
end

local UnpackSchema

function UnpackSchema(Inner, Schema)
  local PresentIndices = Inner[1]
  local PresentValues = Inner[2]
  local UnknownMap = Inner[3]
  local Result = {}
  if type(PresentIndices) ~= "table" or type(PresentValues) ~= "table" then
    return Result
  end
  for I = 1, #PresentIndices do
    local Field = Schema[PresentIndices[I]]
    if Field then
      local Value = PresentValues[I]
      if Field.schema and type(Value) == "table" then
        Result[Field.name] = UnpackSchema(Value, Field.schema)
      else
        Result[Field.name] = Value
      end
    end
  end
  if type(UnknownMap) == "table" then
    for K, V in pairs(UnknownMap) do
      Result[K] = V
    end
  end
  return Result
end

local Decode
local MAX_DECODE_DEPTH = 64

function Decode(Bytes, Pos, Depth)
  Depth = Depth or 0
  if Pos > #Bytes or Depth > MAX_DECODE_DEPTH then
    return nil, Pos
  end
  local B = string.byte(Bytes, Pos)
  Pos = Pos + 1
  if B <= 127 then
    return B, Pos
  end
  if B >= 224 then
    return B - 256, Pos
  end
  if B <= 143 then
    local N = B - 128
    local Map = {}
    for I = 1, N do
      local K
      K, Pos = Decode(Bytes, Pos, Depth + 1)
      local V
      V, Pos = Decode(Bytes, Pos, Depth + 1)
      if nil ~= K then
        Map[K] = V
      end
    end
    return Map, Pos
  end
  if B <= 159 then
    local N = B - 144
    local Arr = {}
    for I = 1, N do
      Arr[I], Pos = Decode(Bytes, Pos, Depth + 1)
    end
    return Arr, Pos
  end
  if B <= 191 then
    local Len = B - 160
    if Pos + Len - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + Len - 1), Pos + Len
  end
  if 192 == B then
    return nil, Pos
  end
  if 194 == B then
    return false, Pos
  end
  if 195 == B then
    return true, Pos
  end
  if 202 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">f", Bytes, Pos)
  end
  if 203 == B then
    if Pos + 7 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">d", Bytes, Pos)
  end
  if 204 == B then
    if Pos > #Bytes then
      return nil, Pos
    end
    return string.byte(Bytes, Pos), Pos + 1
  end
  if 205 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">I2", Bytes, Pos)
  end
  if 206 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">I4", Bytes, Pos)
  end
  if 207 == B then
    if Pos + 7 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">I8", Bytes, Pos)
  end
  if 208 == B then
    if Pos > #Bytes then
      return nil, Pos
    end
    return string.byte(Bytes, Pos) - 256, Pos + 1
  end
  if 209 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">i2", Bytes, Pos)
  end
  if 210 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">i4", Bytes, Pos)
  end
  if 211 == B then
    if Pos + 7 > #Bytes then
      return nil, Pos
    end
    return string.unpack(">i8", Bytes, Pos)
  end
  if 217 == B then
    local L = string.byte(Bytes, Pos)
    Pos = Pos + 1
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 218 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    local L = string.unpack(">I2", Bytes, Pos)
    Pos = Pos + 2
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 219 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    local L = string.unpack(">I4", Bytes, Pos)
    Pos = Pos + 4
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 196 == B then
    local L = string.byte(Bytes, Pos)
    Pos = Pos + 1
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 197 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    local L = string.unpack(">I2", Bytes, Pos)
    Pos = Pos + 2
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 198 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    local L = string.unpack(">I4", Bytes, Pos)
    Pos = Pos + 4
    if Pos + L - 1 > #Bytes then
      return nil, Pos
    end
    return string.sub(Bytes, Pos, Pos + L - 1), Pos + L
  end
  if 220 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    local N = string.unpack(">I2", Bytes, Pos)
    Pos = Pos + 2
    if N > #Bytes - Pos + 1 then
      return nil, Pos
    end
    local Arr = {}
    for I = 1, N do
      Arr[I], Pos = Decode(Bytes, Pos, Depth + 1)
    end
    return Arr, Pos
  end
  if 221 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    local N = string.unpack(">I4", Bytes, Pos)
    Pos = Pos + 4
    if N > #Bytes - Pos + 1 then
      return nil, Pos
    end
    local Arr = {}
    for I = 1, N do
      Arr[I], Pos = Decode(Bytes, Pos, Depth + 1)
    end
    return Arr, Pos
  end
  if 222 == B then
    if Pos + 1 > #Bytes then
      return nil, Pos
    end
    local N = string.unpack(">I2", Bytes, Pos)
    Pos = Pos + 2
    if N > #Bytes - Pos + 1 then
      return nil, Pos
    end
    local Map = {}
    for I = 1, N do
      local K
      K, Pos = Decode(Bytes, Pos, Depth + 1)
      local V
      V, Pos = Decode(Bytes, Pos, Depth + 1)
      if nil ~= K then
        Map[K] = V
      end
    end
    return Map, Pos
  end
  if 223 == B then
    if Pos + 3 > #Bytes then
      return nil, Pos
    end
    local N = string.unpack(">I4", Bytes, Pos)
    Pos = Pos + 4
    if N > #Bytes - Pos + 1 then
      return nil, Pos
    end
    local Map = {}
    for I = 1, N do
      local K
      K, Pos = Decode(Bytes, Pos, Depth + 1)
      local V
      V, Pos = Decode(Bytes, Pos, Depth + 1)
      if nil ~= K then
        Map[K] = V
      end
    end
    return Map, Pos
  end
  return nil, Pos
end

local function UnpackEffectStruct(InEffectStruct)
  if not InEffectStruct then
    return
  end
  local Str = InEffectStruct:GetResult()
  if not Str or "" == Str then
    return
  end
  local FromSchema = false
  if #Str >= 2 and string.byte(Str, 1) == 147 and string.byte(Str, 2) == 195 then
    FromSchema = true
    local Ok, Packed = pcall(Decode, Str, 1)
    if Ok and type(Packed) == "table" then
      local Reg = SchemaRegistry[Packed[2]]
      if Reg and Packed[3] then
        local Ok2, Result = pcall(UnpackSchema, Packed[3], Reg.Fields)
        if Ok2 then
          return Result
        end
      end
    end
    NotifyError("SchemaPack: schema 数据解码失败，回退旧格式 — 找战斗程序")
  end
  local Ok3, Result = pcall(msgpack.unpack, Str)
  if Ok3 then
    return Result
  end
  if not FromSchema then
    NotifyError("SchemaPack: BornInfo 解包失败(数据损坏)，返回 nil — 找战斗程序")
  end
  return nil
end

local function ToEffectStruct(self, InEffectStruct, SchemaId)
  self.Add = nil
  self.ToEffectStruct = nil
  if self.IsEmpty then
    return
  end
  self.IsEmpty = nil
  local EffectStruct = InEffectStruct
  if nil == EffectStruct then
    EffectStruct = FEffectStruct()
  end
  local s0
  if SchemaId then
    local Reg = SchemaRegistry[SchemaId]
    if Reg then
      local Inner = PackSchema(self, Reg.Fields)
      local MagicBytes = PackScalar(true)
      local IdBytes = PackScalar(SchemaId)
      if MagicBytes and IdBytes and Inner then
        s0 = ArrayHeader(3) .. MagicBytes .. IdBytes .. Inner
      else
        NotifyError("SchemaPack: 内部打包错误(Magic/Id/Inner=" .. tostring(MagicBytes) .. "/" .. tostring(IdBytes) .. "/" .. tostring(Inner) .. ") schema=" .. tostring(Reg.Name) .. "，回退旧格式 — 找战斗程序")
        s0 = msgpack.pack(self)
      end
    else
      NotifyError("SchemaPack: 未注册的 schema id=" .. tostring(SchemaId) .. "，回退旧 msgpack 格式 — 找战斗程序")
      s0 = msgpack.pack(self)
    end
  else
    s0 = msgpack.pack(self)
  end
  if not s0 then
    DebugPrint("SchemaPack", "ToEffectStruct 打包失败")
    return EffectStruct
  end
  EffectStruct:SetResult(s0, #s0)
  return EffectStruct
end

local LocalResults = {
  IsEmpty = true,
  Add = function(self, Value)
    Value.Add = nil
    Value.ToEffectStruct = nil
    if Value.IsEmpty then
      return
    end
    Value.IsEmpty = nil
    self.IsEmpty = false
    table.insert(self, Value)
  end,
  ToEffectStruct = ToEffectStruct
}
local LocalResult = {
  IsEmpty = true,
  Add = function(self, Type, Value)
    self.IsEmpty = false
    table.insert(self, {
      [Type] = Value
    })
  end,
  ToEffectStruct = ToEffectStruct
}
local EffectResults = {
  Results = function()
    local _LocalResults = New(LocalResults)
    setmetatable(_LocalResults, {
      __newindex = function(mytable, key, value)
        rawset(mytable, "IsEmpty", false)
        rawset(mytable, key, value)
      end
    })
    return _LocalResults
  end,
  Result = function()
    local _LocalResult = New(LocalResult)
    setmetatable(_LocalResult, {
      __newindex = function(mytable, key, value)
        rawset(mytable, "IsEmpty", false)
        rawset(mytable, key, value)
      end
    })
    return _LocalResult
  end,
  UnpackEffectStruct = UnpackEffectStruct,
  Schemas = SchemaIds
}
return EffectResults

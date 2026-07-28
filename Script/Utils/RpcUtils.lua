local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local ClassModule = require("NetworkEngine.Class")
local ClassMgr = require("NetworkEngine.Common.ClassManager")
local SerializeUtils = require("Utils.SerializeUtils")
local RpcUtils = {}

function RpcUtils.RevertArgs(Args)
  if type(Args) ~= "table" then
    return Args
  end
  if 0 == #Args then
    return Args
  end
  for i = 1, #Args do
    Args[i] = RpcUtils.DumpArg(Args[i])
  end
  return Args
end

function RpcUtils.DumpArg(Arg)
  if type(Arg) == "table" and Arg.IsCustomType then
    local ArgDump = {}
    ArgDump.__type = Arg.__Name__
    ArgDump.value = Arg:all_dump(Arg)
    return ArgDump
  else
    return Arg
  end
end

function RpcUtils.ConvertArgs(Args)
  if type(Args) ~= "table" then
    return Args
  end
  if 0 == #Args then
    return Args
  end
  for i = 1, #Args do
    Args[i] = RpcUtils.LoadArg(Args[i])
  end
  return Args
end

function RpcUtils.LoadArg(Arg)
  if type(Arg) == "table" and Arg.__type and Arg.value then
    local Type = ClassMgr:GetType(Arg.__type)
    if Type then
      return Type:convert(Arg.value)
    else
      return Arg
    end
  else
    return Arg
  end
end

function RpcUtils.PackOfflineArgs(Args, PackArgs)
  if false == PackArgs then
    return Args
  end
  return SerializeUtils:Serialize(Args)
end

function RpcUtils.UnpackOfflineArgs(Args, PackArgs)
  if false == PackArgs then
    return Args
  end
  if type(Args) == "string" then
    return SerializeUtils:UnSerialize(Args)
  end
  return Args
end

return RpcUtils

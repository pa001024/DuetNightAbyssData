require("UnLua")
local Version = require("EMCache.Version")
local rapidjson = require("rapidjson")
local crypt = require("crypt")
local MiscUtils = require("Utils.MiscUtils")
local CryptKey = crypt.base64encode("DuetNightAbyss")
local MaxFileSize = 16777218
local FileNamePart = "EMCache"
local CommonTag = "Common"
local FileDir = UEMPathFunctionLibrary.GetProjectSavedDirectory() .. "SaveGames/" .. FileNamePart .. "/"
local EMCache = Class()
EMCache.CommonCache = {}
EMCache.UserCache = {}

function EMCache:_GetCacheInstance(bUseUUID, bCreateIfNil)
  if nil == bCreateIfNil then
    bCreateIfNil = true
  end
  if bUseUUID then
    if next(EMCache.UserCache) then
      return EMCache.UserCache
    end
    if bCreateIfNil then
      EMCache.UserCache = self:_RealLoadCache(bUseUUID)
      EMCache.UserCache.IsUserCache = true == bUseUUID
    end
    return EMCache.UserCache
  else
    if next(EMCache.CommonCache) then
      return EMCache.CommonCache
    end
    if bCreateIfNil then
      EMCache.CommonCache = self:_RealLoadCache(bUseUUID)
    end
    return EMCache.CommonCache
  end
end

function EMCache:_IsDedicatedServer()
  if self._bDedicatedServer == nil then
    local GameInstance = GWorld.GameInstance
    if not IsValid(GameInstance) then
      GameInstance = UE4.UGameplayStatics.GetGameInstance(UE.UEngine:GetDefaultObject())
    end
    if not IsValid(GameInstance) then
      DebugPrint(ErrorTag, "GameInstace都还没初始化好，不允许使用本地缓存")
      if self.__DebugKey then
        DebugPrint(ErrorTag, Traceback(nil, string.format("非法调用的Key：%s", self.__DebugKey), false))
      end
      self.__DebugKey = nil
      return true
    end
    self._bDedicatedServer = IsDedicatedServer(GameInstance)
  end
  return self._bDedicatedServer
end

function EMCache:Get(Key, bUseUUID)
  self.__DebugKey = Key
  if self:_IsDedicatedServer() then
    return
  end
  self.__DebugKey = nil
  local Cache = self:_GetCacheInstance(bUseUUID)
  if not Cache or not next(Cache) then
    return nil
  end
  return Cache[Key]
end

function EMCache:Set(Key, Value, bUseUUID)
  self.__DebugKey = Key
  if self:_IsDedicatedServer() then
    return
  end
  self.__DebugKey = nil
  local Cache = self:_GetCacheInstance(bUseUUID)
  if not Cache then
    return
  end
  Cache[Key] = Value
end

function EMCache:Remove(Key, bUseUUID)
  self.__DebugKey = Key
  if self:_IsDedicatedServer() then
    return
  end
  self.__DebugKey = nil
  local Cache = self:_GetCacheInstance(bUseUUID)
  if not Cache or not next(Cache) then
    return
  end
  Cache[Key] = nil
end

function EMCache:_GetCacheName(bUseUUID)
  local Tag = CommonTag
  if bUseUUID then
    local Avatar = GWorld:GetAvatar() or self.TempAvatar
    if not Avatar then
      Utils.Traceback(ErrorTag, LXYTag .. "[EMCache Error]Avatar is nil, Can't Get user Cache")
      return
    end
    Tag = tostring(Avatar.Account)
    if Avatar.Hostnum then
      Tag = tostring(Avatar.Hostnum) .. "_" .. Tag
    end
    return FileNamePart .. "_" .. Tag
  end
  return Tag .. "_" .. FileNamePart
end

function EMCache:_Save(bUseUUID, bNeedClean)
  if self:_IsDedicatedServer() then
    return
  end
  DebugPrint("[laixiaoyang]EMCache:_Save, " .. (bUseUUID and "用户" or "公共") .. "缓存触发保存！！！ 是否Clean：" .. tostring(bNeedClean))
  local Cache = self:_GetCacheInstance(bUseUUID, false)
  if not Cache or not next(Cache) then
    print(_G.LogTag, "[EMCache]_SaveFile, Cache is Empty or nil")
    return
  end
  local Res = self:_RealSaveCache(Cache, bUseUUID)
  if Res and bNeedClean then
    if bUseUUID then
      EMCache.UserCache = {}
    else
      EMCache.CommonCache = {}
    end
  end
  return Res
end

function EMCache:_RealLoadCache(bUseUUID)
  if not self._SaveGameClassWrap then
    self._SaveGameClassWrap = MiscUtils.LazyLoadClass("/Game/BluePrints/Client/BP_EMSaveGame.BP_EMSaveGame_C", true)
  end
  local CacheName = self:_GetCacheName(bUseUUID)
  if not CacheName then
    return {}
  end
  local SaveGame = UE.UGameplayStatics.LoadGameFromSlot(CacheName, 0)
  if not IsValid(SaveGame) then
    print(_G.LogTag, "[EMCache]_LoadFile, Load SaveGame Failed!!")
    return {}
  end
  if #SaveGame.EMCacheContent > MaxFileSize then
    GWorld.logger.error(string.format("缓存内容超过2M了，跳过本次序列化并删除该缓存 ：%s", CacheName))
    return {}
  end
  local FileContent = ""
  try({
    exec = function()
      FileContent = self:Decryption(SaveGame.EMCacheContent)
    end,
    catch = function(err)
      DebugPrint(ErrorTag, "本地缓存解密失败", err)
    end
  })
  local EMCacheVersion = Version.GetVersion(bUseUUID)
  local Cache = self:Deserialize(FileContent, EMCacheVersion)
  if not Cache or Cache.Version ~= EMCacheVersion then
    if Cache then
      DebugPrint(WarningTag, "[laixiaoyang]EMCache:_RealLoadCache," .. (bUseUUID and "用户" or "公共") .. "缓存版本过低，触发重建缓存，旧版本号:" .. Cache.Version .. "，新版本号:" .. EMCacheVersion)
      EMCache:Reset(false, bUseUUID)
    else
      DebugPrint(ErrorTag, "本地缓存文件不兼容\\意外损坏\\被人为修改了，重建新的空白缓存")
      DebugPrint(ErrorTag, Traceback(nil, string.format("出错的缓存文件 %s", CacheName), true))
    end
    Cache = {}
    Cache.Initialized = 1
    Cache.Version = EMCacheVersion
  end
  return Cache
end

function EMCache:_RealSaveCache(Cache, bUseUUID)
  if Cache.IsUserCache == nil then
    Cache.IsUserCache = false
  end
  if nil == bUseUUID then
    bUseUUID = false
  end
  if Cache.IsUserCache ~= bUseUUID then
    local Prediction = bUseUUID and "用户缓存" or "公共缓存"
    local Actural = Cache.IsUserCache and "用户缓存" or "公共缓存"
    DebugPrint(Traceback(ErrorTag, "本地缓存保存失败，缓存类型串了" .. "  预计要保存的：" .. Prediction .. "  实际保存的：" .. Actural))
    return
  end
  local FileContent = self:Serialize(Cache, Version.GetVersion(bUseUUID))
  if string.isempty(FileContent) then
    DebugPrint(ErrorTag, "本地缓存保存失败，原因：缓存序列化失败")
    return
  end
  local CacheName = self:_GetCacheName(bUseUUID)
  if not CacheName then
    DebugPrint(ErrorTag, "本地缓存反序列化失败，原因：缓存路径生成失败")
    return
  end
  if GWorld.IsDev then
    if not UE4.UBlueprintFileUtilsBPLibrary.DirectoryExists(FileDir) then
      DebugPrint(DebugTag, "创建本地缓存明文目录", FileDir)
      UE4.UBlueprintFileUtilsBPLibrary.MakeDirectory(FileDir)
    end
    local ExtraPath = FileDir .. CacheName .. ".json"
    if #FileContent > MaxFileSize then
      GWorld.logger.error(string.format("缓存内容超过2M了，太大的缓存怀疑是有写入泄漏，查一下到底哪里有写入泄漏\n有问题的缓存文件: %s", ExtraPath))
    end
    local file = io.open(ExtraPath, "w")
    if file then
      file:write(FileContent)
      file:close()
    else
      DebugPrint(ErrorTag, "本地缓存名文保存失败，放弃保存明文", ExtraPath)
    end
  end
  if not IsValid(UE.UGameplayStatics) then
    DebugPrint(ErrorTag, "本地缓存保存失败，原因：没辙了，蓝图函数库都被GC了...")
    return
  end
  if not self._SaveGameClassWrap then
    self._SaveGameClassWrap = MiscUtils.LazyLoadClass("/Game/BluePrints/Client/BP_EMSaveGame.BP_EMSaveGame_C", true)
  end
  local SaveGameClass = self._SaveGameClassWrap:get()
  if not IsValid(SaveGameClass) then
    DebugPrint(ErrorTag, "本地缓存保存失败，原因：SaveGameClass创建失败")
    return
  end
  local SaveGame = UE.UGameplayStatics.CreateSaveGameObject(SaveGameClass)
  if not IsValid(SaveGame) then
    DebugPrint(ErrorTag, "本地缓存保存失败，原因：SaveGame对象创建失败")
    return
  end
  SaveGame.EMCacheContent = self:Encryption(FileContent)
  local Res = UE.UGameplayStatics.SaveGameToSlot(SaveGame, CacheName, 0)
  SaveGame.EMCacheContent = ""
  return Res
end

function EMCache:SaveUser(bNeedClean, TempAvatar)
  self.TempAvatar = TempAvatar
  self:_Save(true, bNeedClean)
  self.TempAvatar = nil
end

function EMCache:SaveCommon(bNeedClean)
  self:_Save(false, bNeedClean)
end

function EMCache:SaveAll(bNeedClean)
  self:SaveUser(bNeedClean)
  self:SaveCommon(bNeedClean)
end

function EMCache:Reset(bClean, bUseUUID)
  if nil == bClean then
    bClean = true
  end
  
  local function RealReset(Dir)
    local FileNames = TArray("")
    local Res = UE4.URuntimeCommonFunctionLibrary.GetAllFileNamesInDic(Dir, FileNames)
    assert(Res, "清空本地缓存失败，" .. Dir .. "路径不存在")
    for i = 1, FileNames:Length() do
      local FileFull = FileNames:GetRef(i)
      if bClean then
        UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(FileFull)
      else
        local FileName = Split(FileFull, "/")
        FileName = FileName[#FileName]
        local CacheName = self:_GetCacheName(bUseUUID)
        if not CacheName then
          return
        end
        if not bUseUUID and string.sub(FileName, 1, #CommonTag) == CommonTag then
          UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(FileFull)
          break
        elseif bUseUUID and string.sub(FileName, 1, #CacheName) == CacheName then
          UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(FileFull)
          break
        end
      end
    end
  end
  
  local SaveGameDir = UKismetSystemLibrary.GetProjectSavedDirectory() .. "SaveGames/"
  RealReset(SaveGameDir)
  if GWorld.IsDev then
    RealReset(FileDir)
  end
  if bClean then
    EMCache.UserCache, EMCache.CommonCache = {}, {}
  elseif bUseUUID then
    EMCache.UserCache = {}
  else
    EMCache.CommonCache = {}
  end
end

function EMCache:Serialize(Obj, EMCacheVersion)
  if EMCacheVersion and not Obj.Version then
    Obj.Version = EMCacheVersion
  end
  local Params = {}
  if GWorld.IsDev then
    Params = {
      pretty = true,
      sort_keys = true,
      indent = "    "
    }
  end
  local Content
  try({
    exec = function()
      Content = rapidjson.encode(Obj, Params)
    end,
    catch = function(err)
      DebugPrint(ErrorTag, "本地缓存序列化失败", err)
    end
  })
  return Content
end

function EMCache:Deserialize(Str, EMCacheVersion)
  local Type = type(Str)
  if "nil" == Type or "" == Str then
    return nil
  elseif "number" == Type or "string" == Type or "boolean" == Type then
    Str = tostring(Str)
  else
    return nil
  end
  local Cache
  try({
    exec = function()
      Cache = rapidjson.decode(Str, {key2number = true})
      Cache.Initialized = 1
      if not Cache.Version then
        Cache.Version = EMCacheVersion
      end
    end,
    catch = function(err)
      DebugPrint(ErrorTag, "本地缓存反序列化失败", err)
    end
  })
  return Cache
end

function EMCache:Encryption(ContentStr)
  local Encrypted = crypt.xor_str(ContentStr, CryptKey)
  local EMCacheContent = {}
  for i = 1, string.len(Encrypted) do
    table.insert(EMCacheContent, string.format("%02X", string.byte(Encrypted, i)))
  end
  return table.concat(EMCacheContent)
end

function EMCache:Decryption(ContentStr)
  local EMCacheContent = {}
  for Char in string.gmatch(ContentStr, "(..)") do
    table.insert(EMCacheContent, string.char(tonumber(Char, 16)))
  end
  local Encrypted = table.concat(EMCacheContent)
  return crypt.xor_str(Encrypted, CryptKey)
end

return EMCache

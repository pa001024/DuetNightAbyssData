local RougeProSceneObjAttr = require("BluePrints.DungeonObject.RougePro.ObjSpawn.RougeProSceneObjAttr")
local RougeProSceneObjManager = DungeonClass.Class()

local function ForEachId(IdOrList, Callback)
  if type(IdOrList) == "table" then
    for i = 1, #IdOrList do
      Callback(IdOrList[i])
    end
  elseif nil ~= IdOrList then
    Callback(IdOrList)
  end
end

local function CreateObjectAttr(AttrTemplate)
  if nil == AttrTemplate then
    return nil
  end
  local Attr = RougeProSceneObjAttr()
  Attr:CopyFrom(AttrTemplate)
  Attr:SetAlive(true)
  return Attr
end

function RougeProSceneObjManager:BeginPlay()
  self:CleanupAllSceneObj()
end

function RougeProSceneObjManager:OnRoundFinish()
  self:CleanupAllSceneObj()
end

function RougeProSceneObjManager:CleanupAllSceneObj()
  self.StaticCreatorAttrTemplateList = {}
  self.RandomCreatorAttrTemplateList = {}
  self.MonsterSpawnAttrTemplateList = {}
  self.MonsterSceneObjAttrList = {}
  self.MechanismSceneObjAttrList = {}
end

function RougeProSceneObjManager:GetMonsterSceneObjAttr(UniqueId)
  return self.MonsterSceneObjAttrList and self.MonsterSceneObjAttrList[UniqueId]
end

function RougeProSceneObjManager:GetMechanismSceneObjAttr(UniqueId)
  return self.MechanismSceneObjAttrList and self.MechanismSceneObjAttrList[UniqueId]
end

function RougeProSceneObjManager:IsExistMonster(Filter)
  for UniqueId, SceneObjAttr in pairs(self.MonsterSceneObjAttrList or {}) do
    if true == Filter(SceneObjAttr, UniqueId) then
      return true
    end
  end
  return false
end

function RougeProSceneObjManager:IsExistMechanism(Filter)
  for UniqueId, SceneObjAttr in pairs(self.MechanismSceneObjAttrList or {}) do
    if true == Filter(SceneObjAttr, UniqueId) then
      return true
    end
  end
  return false
end

function RougeProSceneObjManager:RegisterMonsterSceneObjAttr(UniqueId, AttrTemplate)
  local Attr = CreateObjectAttr(AttrTemplate)
  if UniqueId and Attr then
    self.MonsterSceneObjAttrList[UniqueId] = Attr
  end
  return Attr
end

function RougeProSceneObjManager:RegisterMechanismSceneObjAttr(UniqueId, AttrTemplate)
  local Attr = CreateObjectAttr(AttrTemplate)
  if UniqueId and Attr then
    self.MechanismSceneObjAttrList[UniqueId] = Attr
  end
  return Attr
end

function RougeProSceneObjManager:SceneObjManagerStaticCreatorActive(StaticPointList, AttrTemplate, UnitId)
  ForEachId(StaticPointList, function(StaticCreatorId)
    self.StaticCreatorAttrTemplateList[StaticCreatorId] = AttrTemplate
  end)
  self:ActiveStaticCreator(StaticPointList, UnitId)
end

function RougeProSceneObjManager:SceneObjManagerStaticCreatorDestroy(StaticPointList)
  self:NotifyGameModeInActivateStaticCreator(StaticPointList)
  ForEachId(StaticPointList, function(StaticCreatorId)
    self.StaticCreatorAttrTemplateList[StaticCreatorId] = nil
  end)
end

function RougeProSceneObjManager:OnServerActiveStaticCreator(Infos)
  for i = 1, #Infos do
    local Info = Infos[i]
    local AttrTemplate = self.StaticCreatorAttrTemplateList[Info.StaticCreatorId]
    if AttrTemplate and self:GetMonster(Info.UniqueId) then
      self:RegisterMonsterSceneObjAttr(Info.UniqueId, AttrTemplate)
    elseif AttrTemplate and self:GetMechanism(Info.UniqueId) then
      self:RegisterMechanismSceneObjAttr(Info.UniqueId, AttrTemplate)
      if AttrTemplate:GetRewardDropBoxInfo() then
        self:OnCreateRougeProEventRewardDropBox(Info.UniqueId, AttrTemplate)
      end
    end
    self.StaticCreatorAttrTemplateList[Info.StaticCreatorId] = nil
  end
end

function RougeProSceneObjManager:SceneObjManagerSpawnMonsterTrigger(UnitSpawnId, AttrTemplate, IsResume)
  ForEachId(UnitSpawnId, function(SpawnId)
    self.MonsterSpawnAttrTemplateList[SpawnId] = AttrTemplate
  end)
  if IsResume then
    self:ServerTriggerResumeMonsterSpawn(UnitSpawnId, false)
  else
    self:ServerTriggerCreateMonsterSpawn(UnitSpawnId, false)
  end
end

function RougeProSceneObjManager:SceneObjManagerSpawnMonsterPause(UnitSpawnId, IsDestroy)
  if IsDestroy then
    self:ServerTriggerDestroyAll(UnitSpawnId, false)
  else
    self:ServerTriggerPauseMonsterSpawn(UnitSpawnId)
  end
  ForEachId(UnitSpawnId, function(SpawnId)
    self.MonsterSpawnAttrTemplateList[SpawnId] = nil
  end)
end

function RougeProSceneObjManager:OnCreateMonster(UniqueId, CreatorType, CreatorId)
  if "MonsterSpawn" ~= CreatorType then
    return
  end
  local AttrTemplate = self.MonsterSpawnAttrTemplateList[CreatorId]
  if AttrTemplate and self:GetMonster(UniqueId) then
    self:RegisterMonsterSceneObjAttr(UniqueId, AttrTemplate)
  end
end

function RougeProSceneObjManager:OnDestroyMonster(UniqueId)
  self.MonsterSceneObjAttrList[UniqueId] = nil
end

function RougeProSceneObjManager:OnCreateMechanism(UniqueId, ExtraParams)
  local AttrTemplate = ExtraParams and ExtraParams.SceneObjAttr
  if AttrTemplate and self:GetMechanism(UniqueId) then
    self:RegisterMechanismSceneObjAttr(UniqueId, AttrTemplate)
  end
end

function RougeProSceneObjManager:OnDestroyMechanism(UniqueId)
  self.MechanismSceneObjAttrList[UniqueId] = nil
end

function RougeProSceneObjManager:SceneManagerDestroyObj(filter)
  for UniqueId, SceneObjAttr in pairs(self.MonsterSceneObjAttrList or {}) do
    if filter(SceneObjAttr) then
      self.MonsterSceneObjAttrList[UniqueId] = nil
    end
  end
  for UniqueId, SceneObjAttr in pairs(self.MechanismSceneObjAttrList or {}) do
    if filter(SceneObjAttr) then
      self.MechanismSceneObjAttrList[UniqueId] = nil
    end
  end
end

return RougeProSceneObjManager

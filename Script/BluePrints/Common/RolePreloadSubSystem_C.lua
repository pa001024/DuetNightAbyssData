require("Unlua")
require("Const")
local AssetPathTable = require("Utils.PreloadAssetPath")
local M = Class()
local PIELoadLimit = false
local PIELoadLimitNum = 5
local bUseAssetPathStaticData = true
UE4.URolePreloadGameInstanceSubsystem.SetUseAssetPathStaticData(bUseAssetPathStaticData)
local DungeonPreloadOutTime = 15
UE4.URolePreloadGameInstanceSubsystem.SetDungeonPreloadOutTime(DungeonPreloadOutTime)

function M:Init_Lua()
  self:SetMaxAsyncLoadNum(15)
  self.DungeonAssetsPreloading = false
  self.DungeonAssetsPreloadFinishCb = nil
  self.OutTimeHandle = nil
end

function M:GetUseAssetPathStaticData()
  return bUseAssetPathStaticData
end

function M:EnableOptimization()
  return Const.EnableDungeonAssetsPreload
end

function M:EnablePIELimit()
  local IsPIE = UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self)
  return PIELoadLimit and IsPIE
end

function M:CacheDungeonPhantomAssets_Lua(UnitId)
  if not UnitId then
    return
  end
  local Paths = self:GetPathsTable()
  local BPMeshs = self:PreparePhantomAllBPMesh(UnitId)
  local Montages = self:CommonPrepareAllBattleMontage(EObjType.PhantomCharacter, UnitId)
  Paths = Paths + BPMeshs + Montages
  self:BuildDungeonRoleAssetRequest_Lua(UnitId, Paths)
end

function M:CommonPrepareMonSkillEffects(UnitId)
  local PreloadEffects = require("Utils.MonsterEffectsPath")
  if not PreloadEffects then
    return {}
  end
  local MonsterData = DataMgr.Monster[UnitId]
  if nil == MonsterData then
    return {}
  end
  UnitId = MonsterData.BattleRoleId
  local RetPathTable = {}
  if PreloadEffects[UnitId] and not IsEmptyTable(PreloadEffects[UnitId]) then
    for _, v in pairs(PreloadEffects[UnitId]) do
      local EffectPath = DataMgr.VisualEffect[v]
      if EffectPath and EffectPath.EffectPath then
        table.insert(RetPathTable, FEMLoadPath(EffectPath.EffectPath))
      end
    end
  end
  return RetPathTable
end

function M:CommonPreparePlayerSkillEffects(PlayerCharacter, IsPrepareMainPlayer)
  local PreloadEffects = require("Utils.PlayerEffectsPath")
  if not PreloadEffects or not PlayerCharacter then
    return {}
  end
  local RetPathTable = {}
  local UnitId = PlayerCharacter.CurrentRoleId
  local ModelId = PlayerCharacter.ModelId
  if not ModelId or 0 == ModelId then
    ModelId = UnitId
  end
  local ModelEffectsTable = PreloadEffects.PlayerEffects[ModelId]
  if ModelEffectsTable and not IsEmptyTable(ModelEffectsTable) then
    for _, v in ipairs(ModelEffectsTable) do
      table.insert(RetPathTable, FEMLoadPath(v))
    end
  end
  local AccessoryType2Id = PlayerCharacter.CharacterFashion and PlayerCharacter.CharacterFashion.AccessoryType2Id
  if AccessoryType2Id then
    local AccessoryEffects = PreloadEffects.AccessoryEffects
    for _, AccessoryId in pairs(AccessoryType2Id) do
      local EffectsTable = AccessoryEffects and AccessoryEffects[AccessoryId]
      if EffectsTable and not IsEmptyTable(EffectsTable) then
        for _, v in ipairs(EffectsTable) do
          table.insert(RetPathTable, FEMLoadPath(v))
        end
      end
    end
  else
    AccessoryType2Id = {}
  end
  if PlayerCharacter.Weapons then
    local function _CommonPreparePlayerWeaponEffects(PreloadEffects, RetPathTable, AccessoryType2Id, WeaponId)
      local AccessoryEffects = PreloadEffects.AccessoryEffects
      
      local AccessoryGroups = PreloadEffects.AccessoryGroups
      local WeaponEffects = PreloadEffects.WeaponEffects
      local EffectsTable = WeaponEffects and WeaponEffects[WeaponId]
      if EffectsTable and not IsEmptyTable(EffectsTable) then
        for _, v in ipairs(EffectsTable) do
          table.insert(RetPathTable, FEMLoadPath(v))
        end
      end
      for _, AccessoryId in pairs(AccessoryType2Id) do
        local AccessoryGroupName = AccessoryGroups and AccessoryGroups[AccessoryId]
        if AccessoryGroupName then
          local WeaponBlueprintPath = DataMgr.BattleWeapon[WeaponId].WeaponBlueprint
          local WeaponBlueprint = string.match(WeaponBlueprintPath, "([^%.]+)")
          local BlueprintInfo = WeaponBlueprint and DataMgr.WeaponBlueprintId[WeaponBlueprint]
          if BlueprintInfo and BlueprintInfo.WeaponBlueprintId then
            local WeaponFx = DataMgr.WeaponFX[BlueprintInfo.WeaponBlueprintId]
            local GroupEffect = WeaponFx and WeaponFx[AccessoryGroupName]
            if GroupEffect and GroupEffect.FXAsset then
              table.insert(RetPathTable, FEMLoadPath(GroupEffect.FXAsset))
            end
          end
        end
      end
    end
    
    for _, Weapon in pairs(PlayerCharacter.Weapons) do
      _CommonPreparePlayerWeaponEffects(PreloadEffects, RetPathTable, AccessoryType2Id, Weapon.WeaponId)
    end
  end
  if IsPrepareMainPlayer then
    local MainPlayEffects = PreloadEffects.MainPlayEffects
    for _, v in ipairs(MainPlayEffects) do
      table.insert(RetPathTable, FEMLoadPath(v))
    end
  end
  return RetPathTable
end

function M:CommonPreparePlayerFrontSightUI(PlayerCharacter)
  local FrontSightUtils = require("Utils.FrontSightUtils")
  if not IsValid(PlayerCharacter) then
    return {}
  end
  local RetPathTable = {}
  local Weapons = {
    PlayerCharacter.RangedWeapon,
    PlayerCharacter.UltraWeapon
  }
  local StyleNames = {}
  for _, Weapon in pairs(Weapons) do
    if IsValid(Weapon) then
      local SightUIName = FrontSightUtils:GetWeaponSightUI(Weapon, PlayerCharacter.ModelId)
      local WeaponStyleNode = FrontSightUtils:GetWeaponStyleNode(SightUIName)
      if WeaponStyleNode and not StyleNames[WeaponStyleNode] then
        local FrontSightUIPath = FrontSightUtils:GetFrontSightUIPath(WeaponStyleNode)
        if FrontSightUIPath then
          StyleNames[WeaponStyleNode] = 1
          table.insert(RetPathTable, FEMLoadPath(FrontSightUIPath))
        end
      end
      local MagazineCapacity = Weapon:GetAttr("MagazineCapacity")
      local AmmoBarStyleName = FrontSightUtils:GetAmmoBarStyle(Weapon, WeaponStyleNode, MagazineCapacity, SightUIName)
      if AmmoBarStyleName and not StyleNames[AmmoBarStyleName] then
        local AmmoBarUIPath = FrontSightUtils:GetAmmoBarUIPath(AmmoBarStyleName)
        if AmmoBarUIPath then
          StyleNames[AmmoBarStyleName] = 1
          table.insert(RetPathTable, FEMLoadPath(AmmoBarUIPath))
        end
      end
    end
  end
  return RetPathTable
end

function M:CommonPrepareAllMontage(ObjType, UnitId)
  local ModelData = self:GetModelData(ObjType, UnitId)
  if nil == ModelData then
    return {}
  end
  if not ModelData.MontageFolder then
    return {}
  end
  local MontageFolder = ModelData.MontageFolder
  local AssetStringIndex = UE4.UKismetStringLibrary.FindSubstring(MontageFolder, "Asset/")
  MontageFolder = UE4.UKismetStringLibrary.GetSubstring(MontageFolder, AssetStringIndex, UE4.UKismetStringLibrary.Len(MontageFolder))
  local _, Paths = self.GetFolderAssetPaths(MontageFolder)
  return Paths:ToTable()
end

function M:CommonPrepareAllExceptBattleMontage(ObjType, UnitId)
  return {}
end

function M:GetModelData(ObjType, UnitId)
  if ObjType == EObjType.MonsterCharacter then
    local Data = DataMgr.Monster[UnitId]
    local ModelData = DataMgr.Model[Data.ModelId]
    return ModelData
  elseif ObjType == EObjType.PhantomCharacter then
    local PhantomData = DataMgr.Phantom[UnitId]
    local PhantomRoleInfo = DataMgr.BattleChar[PhantomData.BattleRoleId]
    local ModelData = DataMgr.Model[PhantomRoleInfo.ModelId]
    return ModelData
  elseif ObjType == EObjType.PlayerCharacter then
    local PlayerRoleInfo = DataMgr.BattleChar[UnitId]
    local ModelData = DataMgr.Model[PlayerRoleInfo.ModelId]
    return ModelData
  elseif ObjType == EObjType.NpcCharacter then
    local NpcData = DataMgr.Npc[UnitId]
    local ModelData = NpcData and NpcData.ModelId and DataMgr.Model[NpcData.ModelId]
    return ModelData
  else
    return nil
  end
end

function M:GetPathsTable()
  local Paths = setmetatable({}, {
    __add = function(Paths, newtable)
      for i = 1, #newtable do
        table.insert(Paths, #Paths + 1, newtable[i])
      end
      return Paths
    end
  })
  return Paths
end

function M:CacheDungeonGameAssetsOuter_Test(FinishCallback)
  self.DungeonAssetsPreloading = true
  self.DungeonAssetsPreloadFinishCb = FinishCallback
  self.LoadingUnitNum = 0
  self.DungeonLoadingRequests = {}
  self:EnableLimitLoadNum(false)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  self.Players = GameState and GameState:GetAllPlayer():ToTable()
  if self.Players then
    for _, PlayerCharacter in pairs(self.Players) do
      self:PreloadPlayerAssets(PlayerCharacter)
      self:PreloadSummonAssets(PlayerCharacter.CurrentRoleId)
    end
  else
    DebugPrint("CacheDungeonGameAssetsOuter  Can Not Find PlayerInfo!!!!!!!!!!!!!!!")
  end
  local MonsterIds = {7002001, 7003001}
  if MonsterIds and #MonsterIds > 0 then
    for i = 1, #MonsterIds do
      self:CacheDungeonMonsterAssets_Lua(MonsterIds[i], true)
    end
  end
  if self.OutTimeHandle then
    UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, self.OutTimeHandle)
    self.OutTimeHandle = nil
  end
  
  local function OutTimeFunc()
    GWorld.logger.errorlog("wzj- 副本资源预加载超时, 超时时间:" .. DungeonPreloadOutTime .. "秒")
    self:PreloadDungeonGameAssetsFinished_Lua()
  end
  
  self.OutTimeHandle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, OutTimeFunc}, DungeonPreloadOutTime, false, 0)
  self:ConsumeDungeonRoleAssetRequest_Lua()
  return true
end

function M:GetSupplementaryDataFromLua(ModelId, Type, Label)
  local Out = {}
  if not AssetPathTable or not ModelId then
    return Out
  end
  local TypeName = Type and tostring(Type) or ""
  local LabelName = Label and tostring(Label) or ""
  local ModelEntry = AssetPathTable[ModelId]
  if not ModelEntry then
    return Out
  end
  local TypeEntry = ModelEntry[TypeName]
  if not TypeEntry then
    return Out
  end
  
  local function ProcressSingleLabel(inLabel)
    local all = TypeEntry[inLabel]
    if all and type(all) == "table" then
      for _, p in ipairs(all) do
        table.insert(Out, p)
      end
    end
  end
  
  if "" == LabelName or nil == LabelName or "None" == LabelName then
    for k, _ in pairs(TypeEntry) do
      ProcressSingleLabel(k)
    end
  else
    ProcressSingleLabel(LabelName)
  end
  return Out
end

return M

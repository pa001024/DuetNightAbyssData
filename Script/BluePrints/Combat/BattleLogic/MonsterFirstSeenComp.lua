local MonsterUtils = require("Utils.MonsterUtils")
local Component = {}

function Component:Initialize()
  self.FirstSeen = {}
  self.NextMonsterPanel = {}
end

function Component:ShowMonsterFirstSeenPanel(UnitId, RealUnitId)
  local UnitGuideId = DataMgr.Monster[RealUnitId].GuideId
  if UnitGuideId then
    self:ShowMonsterStrongPanel(UnitGuideId, UnitId)
    return
  end
  self:ShowCommonPanel(UnitId)
end

function Component:CheckMonsterGalleryRuleId(UnitId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local MonsterInfo = DataMgr.Monster[UnitId]
  if not MonsterInfo then
    return false
  end
  local GalleryRuleId = MonsterInfo.GalleryRuleId
  if not GalleryRuleId then
    return false
  end
  for key, value in ipairs(Avatar.FirstMonsters) do
    local Info = DataMgr.Monster[value]
    if Info then
      local Id = Info.GalleryRuleId
      if GalleryRuleId == Id then
        return true
      end
    end
  end
  return false
end

function Component:ShowCommonPanel(UnitId)
  local Monster = DataMgr.Monster[UnitId]
  if not Monster then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if not GameInstance then
    return
  end
  local UIManger = GameInstance:GetGameUIManager()
  if not UIManger then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local IsInEditor = false
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GameInstance) then
    IsInEditor = true
  else
    IsInEditor = false
  end
  local NewMonsterPanel = UIManger:GetUIObj("CommonNewMonster")
  if not NewMonsterPanel then
    print(_G.LogTag, "Showing Monster First Seen Panel" .. tostring(UnitId))
    if IsInEditor then
      UIManger:LoadUINew("CommonNewMonster", UnitId)
    else
      UIManger:LoadUIAsync("CommonNewMonster", function()
      end, UnitId)
    end
  else
    print(_G.LogTag, "Showing Monster Next Seen Panel" .. tostring(UnitId))
    self.NextMonsterPanel[#self.NextMonsterPanel + 1] = UnitId
  end
end

function Component:ShowNextMonsterPanel()
  if 0 == #self.NextMonsterPanel then
    return true
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if not GameInstance then
    return true
  end
  local UIManger = GameInstance:GetGameUIManager()
  if not UIManger then
    return true
  end
  local UnitId = self.NextMonsterPanel[1]
  table.remove(self.NextMonsterPanel, 1)
  local NewMonsterPanel = UIManger:GetUIObj("CommonNewMonster")
  if not NewMonsterPanel then
    print(_G.LogTag, "Showing Next Monster Panel " .. tostring(UnitId))
    if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(GameInstance) then
      UIManger:LoadUINew("CommonNewMonster", UnitId)
    else
      UIManger:LoadUIAsync("CommonNewMonster", function()
      end, UnitId)
    end
  else
  end
  return false
end

function Component:ShowMonsterStrongPanel(UnitGuideId, UnitId)
  local ChildGuideUIInfo = DataMgr.UIGuide[UnitGuideId]
  if not ChildGuideUIInfo then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local FlowManager = USubsystemBlueprintLibrary.GetWorldSubsystem(GWorld.GameInstance, UGameFlowManager)
  local Flow = FlowManager:CreateFlow("GuideMain")
  Flow.OnBegin:Add(Flow, function()
    local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, UnitGuideId)
    UIStateAsyncActionBase.OnGuideEnd:Add(self, function()
      local bShow = self:CheckMonsterGalleryRuleId(UnitId)
      local MonsterInfo = DataMgr.Monster[UnitId]
      local GalleryRuleId = MonsterInfo.GalleryRuleId
      local DisableArchive = DataMgr.GalleryRule[GalleryRuleId].DisableArchive
      if not bShow and not DisableArchive then
        self:ShowCommonPanel(UnitId)
      end
      FlowManager:RemoveFlow(Flow)
    end)
  end)
  FlowManager:AddFlow(Flow)
end

return Component

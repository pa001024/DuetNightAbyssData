local MonsterUtils = require("Utils.MonsterUtils")
local GameFlowUtils = require("Utils.GameFlowUtils")
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
  if not Monster.GalleryRuleId then
    return
  end
  if DataMgr.GalleryRule[Monster.GalleryRuleId].DisableArchive then
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
  if not Avatar:CheckFirstMonster(Monster.GalleryRuleId, true) then
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
  local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
  if DungeonId and Avatar.Dungeons[DungeonId] and Avatar.Dungeons[DungeonId].AutoProgress > 0 then
    return
  end
  Avatar:CheckStrongGuideFirstMonster(UnitGuideId, true)
  GameFlowUtils:AddFlow("GuideMain", {
    GWorld.GameInstance,
    function(_, Flow)
      local UIStateAsyncActionBase = UE4.UUIStateAsyncActionBase.ShowGuideUI(self, UnitGuideId)
      UIStateAsyncActionBase.OnGuideEnd:Add(self, function()
        self:ShowCommonPanel(UnitId)
        GameFlowUtils:RemoveFlow(Flow)
      end)
    end
  })
end

return Component

require("UnLua")
local RomanNum = Const.RomanNum
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_LvName:SetText(GText("UI_LEVEL_NAME"))
  self.New_Tag:SetVisibility(ESlateVisibility.Collapsed)
  self.Bg_List:BindEventOnClicked(self, self.OnSubCellClicked)
end

function M:BindEventOnClicked(Obj, Func, ...)
  if not Obj or not Func then
    return
  end
  self.Obj = Obj
  self.Func = Func
  self.Params = {
    ...
  }
end

function M:SetSelect(bSelected)
  if not self.Bg_List then
    return
  end
  if self.Bg_List.IsCantInteractable then
    return
  end
  self:StopAllAnimations()
  if bSelected then
    self:PlayAnimation(self.Select)
    self.Bg_List:SelectCell()
  else
    self:PlayAnimation(self.Normal)
    self.Bg_List:OnCellUnSelect()
  end
end

function M:InitDungeonInfo(DungeonId, Index, IsShowDungeonName, Parent)
  self.DungeonId = DungeonId
  self.Parent = Parent
  local Data = DataMgr.Dungeon[DungeonId]
  if not Data then
    DebugPrint("[HardBossEvent] 找不到关卡数据:", DungeonId)
    return
  end
  if self.Bg_List then
    self.Bg_List.IsSelect = false
  end
  local HardBossType = DataMgr.HardBossEventDungeon[DungeonId] and DataMgr.HardBossEventDungeon[DungeonId].HardBossType
  if "Reward" == HardBossType then
    self.Title_Type:SetText(GText("UI_HardBossEvent_RewardType"))
  elseif "Challenge" == HardBossType then
    self.Title_Type:SetText(GText("UI_HardBossEvent_ChallengeType"))
  else
    self.Title_Type:SetText("")
  end
  if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
    self:SetVisibility(ESlateVisibility.Visible)
    self.Bg_List.IsCantInteractable = false
    self:PlayAnimation(self.Normal)
    if self.Bg_List.Normal then
      self.Bg_List:PlayAnimation(self.Bg_List.Normal)
    end
  else
    self.Bg_List.IsCantInteractable = true
    self:PlayAnimation(self.Forbidden)
  end
  if IsShowDungeonName then
    self.Title_Level:SetText(GText(Data.DungeonName))
  else
    self.Title_Level:SetText(GText(RomanNum[Index]))
  end
  if Data.DungeonLevel then
    self.Text_Lv:SetVisibility(ESlateVisibility.Visible)
    self.Text_Lv:SetText(Data.DungeonLevel)
  else
    self.Text_Lv:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnSubCellClicked()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  if self:IsMatching() then
    return false
  end
  if self.DungeonId and PageJumpUtils:CheckDungeonCondition(DataMgr.Dungeon[self.DungeonId].Condition, true) and self.Obj and self.Func then
    self.Func(self.Obj, table.unpack(self.Params))
  end
end

function M:RefreshBtnState(bIsMatching)
  if nil == bIsMatching then
    bIsMatching = self:IsMatching()
  end
  if not self.DungeonId then
    return
  end
  local Data = DataMgr.Dungeon[self.DungeonId]
  if not Data then
    return
  end
  if PageJumpUtils:CheckDungeonCondition(Data.Condition) then
    self.Bg_List.IsCantInteractable = bIsMatching
    if not self.Bg_List.IsSelect then
      self:StopAllAnimations()
      self:PlayAnimation(bIsMatching and self.Forbidden or self.Normal)
    end
  end
end

function M:IsMatching()
  local MatchTimingBar = UIManager(self):GetUIObj("DungeonMatchTimingBar")
  return MatchTimingBar and true
end

return M

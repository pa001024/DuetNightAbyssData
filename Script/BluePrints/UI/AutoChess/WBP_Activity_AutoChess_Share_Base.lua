require("UnLua")
local UIUtils = require("Utils.UIUtils")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.SelectedSquadIdx = Model:GetEditingSuqadIndex() or 1
  self:InitTab()
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "AutoChessShare", nil)
  self:AddDispatcher(EventID.OnAutoChessSetSharedSquad, self, self.OnSquadTabChanged)
  self:Init()
end

function M:Close()
  AudioManager(self):SetEventSoundParam(self, "AutoChessShare", {ToEnd = 1})
  M.Super.Close(self)
end

function M:Destruct()
  self:UnBindEvents()
  M.Super.Destruct(self)
end

function M:Init()
  self:InitRankInfo()
  self:InitShareMain()
  self:InitRankWins()
  self:InitEvents()
  self:RefreshAll()
  self:PlayInAnim()
  self:RefreshOpInfoByInputDevice()
end

function M:PlayInAnim()
  if self.In then
    self:PlayAnimationForward(self.In)
  end
end

function M:GetTabWidget()
  return self.Com_Tab or self.WBP_Com_Tab_M
end

function M:InitTab()
  local Tab = self:GetTabWidget()
  if not Tab then
    return
  end
  local TabConfigData = {
    TitleName = GText("Event_Title_103016"),
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BackCallback = function()
      self:Close()
    end,
    BottomKeyInfo = {},
    OwnerPanel = self
  }
  Tab:Init(TabConfigData)
end

function M:InitRankInfo()
  if self.Level and self.Level.InitContent then
    self.Level:InitContent()
  end
end

function M:InitShareMain()
  if self.Main and self.Main.InitContent then
    self.Main.Owner = self
    self.Main:InitContent(self.SelectedSquadIdx)
  end
end

function M:InitRankWins()
  if self.Right and self.Right.InitContent then
    self.Right.Owner = self
    self.Right:InitContent()
  end
end

function M:InitEvents()
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:UnBindEvents()
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    self.GameInputModeSubsystem = nil
  end
end

function M:RefreshAll()
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return
  end
  local AutoChess = Avatar.AutoChess
  local RankLevel = AutoChess.RankLevel or 1
  local RankScore = AutoChess.RankScore or 0
  if self.Level and self.Level.Refresh then
    self.Level:Refresh(RankLevel, RankScore)
  end
  if self.Main and self.Main.RefreshAll then
    self.Main:RefreshAll(self.SelectedSquadIdx)
  end
  if self.Right and self.Right.RefreshContent then
    self.Right:RefreshContent()
  end
end

function M:GetAutoChessData()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.AutoChess then
    return Avatar.AutoChess
  end
  return nil
end

function M:GetSharedSquad(SquadIdx)
  local AutoChess = self:GetAutoChessData()
  if not AutoChess or not AutoChess.SharedSquads then
    return nil
  end
  return AutoChess.SharedSquads[SquadIdx]
end

function M:GetCurrentSquad()
  return self:GetSharedSquad(self.SelectedSquadIdx)
end

function M:ImportByShareCode(ShareCode)
  if not ShareCode or "" == ShareCode then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  UIManager(self):ShowLoading(true)
  Avatar:AutoChessGetSharedSquadByShareCode(function(Squad)
    UIManager(self):ShowLoading(false)
    if not Squad then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_ImportFailed"))
      return
    end
    local TargetIdx = self.SelectedSquadIdx
    if Avatar.AutoChess and Avatar.AutoChess.SharedSquads then
      Avatar.AutoChess.SharedSquads[TargetIdx] = Squad
    end
    Avatar:AutoChessSetSharedSquad(function()
      self:RefreshAll()
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_ImportSuccess"))
    end, TargetIdx, Squad.Squad, Squad.Buffs, Squad.Equips)
  end, ShareCode)
end

function M:OnSquadTabChanged(SquadIdx)
  if self.SelectedSquadIdx == SquadIdx then
    return
  end
  self.SelectedSquadIdx = SquadIdx
  self:RefreshAll()
end

return M

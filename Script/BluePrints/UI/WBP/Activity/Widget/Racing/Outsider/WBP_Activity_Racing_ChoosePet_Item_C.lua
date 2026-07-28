require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

function M:OnListItemObjectSet(Content)
  Content.SelfWidget = self
  self.Content = Content
  self:Init(Content)
end

function M:Init(Content)
  self:InitView(Content)
  self:BindButtonEvent()
end

function M:InitView(Content)
  self:SetIsEmpty()
  self:SetWinSign()
  if self.Content.bIsEmpty then
    return
  end
  self:SetNumber()
  self:SetPetIcon()
  self:SetPetName()
  self:SetBaseSpeed()
  self:SetRumorStatus()
  self:SetRank()
end

function M:BindButtonEvent()
  if self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Click:SetForbidden(RacingOutsiderModel.CurActivityStage ~= RacingActivityConst.RacingActivityStage.SelectPlayer)
end

function M:OnBtnClicked()
  local EventData = self.Content and self.Content.OnMouseButtonDownEvents or nil
  if not EventData then
    return
  end
  local Obj = EventData.Obj
  local Callback = EventData.Callback
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    Callback(Obj, self.Content.PlayerId)
  end
end

function M:SetRank()
  if not RacingOutsiderModel.IsShowRankInfo or RacingOutsiderModel.CurActivityStage ~= RacingActivityConst.RacingActivityStage.GetReward then
    self.WS_Index:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.WS_Index:SetVisibility(UIConst.VisibilityOp.Visible)
  if self.bIsShowWinSign then
    self.WS_Index:SetActiveWidgetIndex(1)
    self.Text_IndexWin:SetText(string.format(GText(RacingActivityConst.RankText), self.Rank))
  else
    self.WS_Index:SetActiveWidgetIndex(0)
    self.Text_IndexNormal:SetText(string.format(GText(RacingActivityConst.RankText), self.Rank))
  end
end

function M:SetRumorStatus()
  local RumorContentList
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    RumorContentList = RacingOutsiderModel:GetAllRumorInfoByPlayerId(self.Content.PlayerId)
  else
    RumorContentList = RacingOutsiderModel:GetRumorContentListByPlayerId(self.Content.PlayerId)
  end
  self.List_Negative:ClearListItems()
  self.List_Positive:ClearListItems()
  self.Content.RumorList = {}
  if RumorContentList then
    for _, RumorContent in pairs(RumorContentList) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      if RumorContent then
        Content.BuffMap = RumorContent.BuffMap
        Content.BuffSymbol = RumorContent.BuffSymbol
        Content.MaxStake = RumorContent.MaxStake
        Content.BuffCount = RumorContent.BuffCount
        if RumorContent.BuffSymbol == "+" then
          self.List_Positive:AddItem(Content)
        else
          self.List_Negative:AddItem(Content)
        end
        table.insert(self.Content.RumorList, {
          BuffMap = RumorContent.BuffMap,
          BuffSymbol = RumorContent.BuffSymbol,
          MaxStake = RumorContent.MaxStake,
          BuffCount = RumorContent.BuffCount
        })
      end
    end
  end
end

function M:SetWinSign()
  self.Rank = RacingOutsiderModel:GetRankByPlayerId(self.Content.PlayerId)
  self.bIsShowWinSign = self.Rank and self.Rank <= tonumber(DataMgr.RaceLotteryConstant.ShortListedPlayerNum.ConstantValue)
  self.Image_WinSign:SetVisibility(self.bIsShowWinSign and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:SetNumber()
  self.Text_Num:SetText(string.format("%02d", self.Content.Index))
end

function M:SetBaseSpeed()
  self.Text_Speed:SetText(string.format("%.2f", self.Content.BaseSpeed))
end

function M:SetPetName()
  self.Text_PetName:SetText(GText(self.Content.PlayerName))
end

function M:SetPetIcon()
  if not self.Content.Icon then
    return
  end
  local IconDice = LoadObject(self.Content.Icon)
  self.Image_Pet:SetBrushFromTexture(IconDice)
end

function M:SetIsEmpty()
  if self.Content.bIsEmpty then
    self.WS_Item:SetActiveWidgetIndex(1)
  else
    self.WS_Item:SetActiveWidgetIndex(0)
  end
end

function M:Destruct()
end

return M

require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
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

function M:BindButtonEvent()
  if self.Btn_Click.OnClicked then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  if self.Btn_Choose.OnClicked then
    self.Btn_Choose.OnClicked:Remove(self, self.OnChooseBtnClicked)
  end
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Choose.OnClicked:Add(self, self.OnChooseBtnClicked)
  if self.Btn_Choose.OnHovered then
    self.Btn_Choose.OnHovered:Remove(self, self.OnChooseBtnHovered)
  end
  if self.Btn_Choose.OnUnhovered then
    self.Btn_Choose.OnUnhovered:Remove(self, self.OnChooseBtnUnhovered)
  end
  self.Btn_Choose.OnHovered:Add(self, self.OnChooseBtnHovered)
  self.Btn_Choose.OnUnhovered:Add(self, self.OnChooseBtnUnhovered)
end

function M:OnChooseBtnHovered()
  self:PlayAnimation(self.Tick_Hover)
end

function M:OnChooseBtnUnhovered()
  if self.Content.IsChoosed then
    return
  end
  self:StopAnimation(self.Tick_Hover)
  self:PlayAnimation(self.Tick_Normal)
end

function M:OnBtnClicked()
  local EventData = self.Content and self.Content.OnMouseButtonDownDetailEvents or nil
  if not EventData or self.Content.IsSelected then
    return
  end
  local Obj = EventData.Obj
  local Callback = EventData.Callback
  local Params = EventData.Params
  if Params then
    Callback(Obj, table.unpack(Params))
  else
    Callback(Obj)
  end
  if not self.Content.IsSelected then
    self.Content.IsSelected = true
  end
  self:SetIsSelected()
end

function M:OnChooseBtnClicked()
  local EventData = self.Content and self.Content.OnMouseButtonDownChooseEvents or nil
  if not EventData then
    return
  end
  DebugPrint("Yihan@ OnChooseBtnClicked", RacingOutsiderModel:IsChoosePetEnough())
  if RacingOutsiderModel:IsChoosePetEnough() and not self.Content.IsChoosed then
    return
  end
  local Obj = EventData.Obj
  local Callback = EventData.Callback
  local Params = EventData.Params
  if Params then
    Callback(Obj, table.unpack(Params))
  else
    Callback(Obj)
  end
  self:SetIsChoosed()
end

function M:InitView(Content)
  self.Text_No:SetText(GText("UI_RaceLottery_PlayerNum"))
  self:SetNumber()
  self:SetPetIcon()
  self:SetBaseSpeed()
  self:SetIsChoosed()
  self:SetIsSelected()
  self:SetRumorStatus()
end

function M:SetRumorStatus()
  local RumorIdList = RacingOutsiderModel:GetRumorIdListByPlayerId(self.Content.PlayerId)
  self.List_Negative:ClearListItems()
  self.List_Positive:ClearListItems()
  self.Content.RumorList = {}
  if RumorIdList then
    for _, RumorId in pairs(RumorIdList) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      local RumorInfo = DataMgr.RaceLotteryBuffMap[RumorId]
      if RumorInfo then
        Content.BuffMap = RumorInfo.BuffMap
        Content.BuffSymbol = RumorInfo.PValueEffect > 1 and "+" or "-"
        Content.MaxStake = RumorInfo.MaxStake
        Content.BuffCount = #RumorInfo.BuffMap
        if RumorInfo.PValueEffect > 1 then
          self.List_Positive:AddItem(Content)
        else
          self.List_Negative:AddItem(Content)
        end
        table.insert(self.Content.RumorList, {
          BuffMap = RumorInfo.BuffMap,
          BuffSymbol = Content.BuffSymbol,
          MaxStake = Content.MaxStake,
          BuffCount = Content.BuffCount
        })
      end
    end
  end
end

function M:SetNumber()
  self.Text_Num:SetText(string.format("%02d", self.Content.Index))
end

function M:SetPetIcon()
  if not self.Content.Icon then
    return
  end
  local IconDice = LoadObject(self.Content.Icon)
  self.Image_Pet:SetBrushFromTexture(IconDice)
end

function M:SetBaseSpeed()
  self.Text_Speed:SetText(string.format("%.2f", self.Content.BaseSpeed))
end

function M:SetIsChoosed()
  if self.Content.IsChoosed then
    self:StopAllAnimations()
    self:PlayAnimation(self.Select)
    self.IsInChoosedStatus = true
  elseif not self.Content.IsChoosed and self.IsInChoosedStatus then
    self:StopAllAnimations()
    self:PlayAnimation(self.Unselect)
    self.IsInChoosedStatus = false
  end
end

function M:SetIsSelected()
  if self.Content.IsSelected then
    self:PlayAnimation(self.Hover)
  else
    self:PlayAnimation(self.Normal)
  end
end

function M:OnMouseEnter(MyGeometry, MouseEvent)
  if self.Content.IsSelected then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  if self.Content.IsSelected then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  DebugPrint("Yihan@ OnMouseButtonDown: ")
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Click)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    RacingOutsiderModel.CurrentFocusWidget = self
    self.Content.Parent:OnPetItemSelected(self.Content)
  end
  return UIUtils.Handled
end

function M:OnFocusLost(InFocusEvent)
  if UIUtils.IsGamepadInput() then
  end
  return UIUtils.Handled
end

return M

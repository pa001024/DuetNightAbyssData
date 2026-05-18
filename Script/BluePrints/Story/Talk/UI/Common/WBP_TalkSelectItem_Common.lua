require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local FirstInitTime = 0.25

local function ParseInitParams(Params)
  local InitParams = Params or {}
  return {
    SelectUI = InitParams.SelectUI,
    OptionText = InitParams.OptionText or InitParams.Text,
    OptionIdx = InitParams.OptionIdx or InitParams.Index,
    ListIdx = InitParams.ListIdx,
    bIsSelected = InitParams.bIsSelected == true,
    bCanReselect = true == InitParams.bCanReselect,
    OnItemClickedDelegate = InitParams.OnItemClickedDelegate,
    OnItemClickStartDelegate = InitParams.OnItemClickStartDelegate
  }
end

function M:Init(Params)
  local InitParams = ParseInitParams(Params)
  self.SelectUI = InitParams.SelectUI
  self.OutAnimFinishedInfo = nil
  self.OptionIdx = InitParams.OptionIdx
  self.ListIdx = InitParams.ListIdx
  self.bCanReselect = InitParams.bCanReselect
  self.OnItemClickedDelegate = InitParams.OnItemClickedDelegate
  self.OnItemClickStartDelegate = InitParams.OnItemClickStartDelegate
  self:InitPlatform()
  self:InitKey()
  self:InitText(InitParams.OptionText)
  self:SwitchPlayInAnimation(InitParams.bIsSelected)
  self:BindAnimationEvents()
  self:AddTimer(FirstInitTime, function()
    self:BindMouseTriggerEvents()
  end, false, 0, "BindMouseTriggerEvents", true)
end

function M:FireDelegate(Delegate, ...)
  if Delegate and Delegate[1] and Delegate[2] then
    Delegate[2](Delegate[1], ...)
    return true
  end
  return false
end

function M:InitText(OptionText)
  self.Text_Talk:SetText(OptionText)
end

function M:InitPlatform()
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  self.bInMobile = "Mobile" == Platform
end

function M:InitKey()
  self.Key_Talk:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetActionMappingKeyName("TalkOption")
      }
    }
  })
  self.Key_Talk_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("TalkOption", true))
      }
    }
  })
  if self.bInMobile then
    self.Key:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Key:SetVisibility(ESlateVisibility.Hidden)
  end
end

function M:ShowKey(bShow)
  if self.bInMobile then
    return
  end
  if bShow then
    self.Key:SetVisibility(ESlateVisibility.Visible)
  else
    self.Key:SetVisibility(ESlateVisibility.Hidden)
  end
end

function M:BindMouseTriggerEvents()
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
  self.Button_Area.OnHovered:Add(self, self.OnHovered)
  self.Button_Area.OnUnhovered:Add(self, self.OnUnhovered)
  self.Button_Area.OnPressed:Add(self, self.OnPressed)
  self.Button_Area.OnReleased:Add(self, self.OnReleased)
end

function M:UnBindAllEvents()
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnHovered:Clear()
  self.Button_Area.OnUnhovered:Clear()
  self.Button_Area.OnPressed:Clear()
  self.Button_Area.OnReleased:Clear()
end

function M:Clear()
  self:UnBindAllEvents()
  self:CleanTimer()
end

function M:SwitchPlayInAnimation(bIsSelected)
  if bIsSelected then
    self.bIsSelected = true
    self:PlayAnimation(self.Read)
  else
    self.bIsSelected = false
    self:PlayAnimation(self.In)
  end
end

function M:BindAnimationEvents()
  self:BindToAnimationFinished(self.Click, {
    self,
    self.OnClickAnimationFinished
  })
end

function M:OnClickAnimationFinished()
  if self.bIsSelected and not self.bCanReselect then
    return
  end
  self:FireDelegate(self.OnItemClickedDelegate, self.OptionIdx)
end

function M:OnClicked()
  if self.bIsSelected and not self.bCanReselect then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", "", nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.Read_Click)
    local TalkContext = GWorld.GameInstance:GetTalkContext()
    TalkContext:TalkShowUITip("CommonToastMain", "Impression_UI_Read")
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", "", nil)
    self:StopAllAnimations()
    self:PlayAnimation(self.Click)
    self:UnBindAllEvents()
    self:FireDelegate(self.OnItemClickStartDelegate)
  end
end

function M:OnHovered()
  self.SelectUI:SelectNewItem(self.ListIdx)
end

function M:OnUnhovered()
  if self.bInMobile then
    return
  end
  if self.ListIdx == self.SelectUI.CurrentSelectItemIdx then
    self:PlayAnimationReverse(self.Hover)
    self:StopAnimation(self.Hover)
  else
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnPressed()
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
end

function M:OnReleased()
end

function M:OnSelectItem(bIsDefault)
  DebugPrint("OnSelectItem", self, bIsDefault)
  if not self.bInMobile then
    self:PlayAnimation(self.Hover)
  end
  self:ShowKey(true)
end

function M:OnUnselectItem()
  DebugPrint("OnUnselectItem", self)
  if not self.bInMobile then
    self:PlayAnimation(self.UnHover)
  end
  self:ShowKey(false)
end

function M:UpdateKeyImg(IsGamePad)
  if IsGamePad then
    self.WidgetSwitcher_Key:SetActiveWidgetIndex(1)
  else
    self.WidgetSwitcher_Key:SetActiveWidgetIndex(0)
  end
end

return M

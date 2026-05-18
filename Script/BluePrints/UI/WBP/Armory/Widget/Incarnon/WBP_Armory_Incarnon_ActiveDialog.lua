require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  self.Parent = Params.RightCallbackObj
  self.WeaponId = Params.WeaponId
  self.CardLevel = Params.CardLevel
  self.TargetTalentId = Params.TargetTalentId
  local Talents = HyperWeaponUtils.GetTalents(self.WeaponId, self.CardLevel)
  local LeftWidgetItem = self.Incarnon_ActiveItem
  local RightWidgetItem = self.Incarnon_ActiveItem_1
  LeftWidgetItem:InitContent({
    TalentId = Talents[1],
    CallbackObj = self,
    Callback = self.OnSubWidgetClicked
  })
  RightWidgetItem:InitContent({
    TalentId = Talents[2],
    CallbackObj = self,
    Callback = self.OnSubWidgetClicked
  })
  if self.TargetTalentId == Talents[1] then
    LeftWidgetItem:OnButtonClicked()
  else
    RightWidgetItem:OnButtonClicked()
  end
end

function M:OnSubWidgetClicked(SubWidget, TalentId)
  self:RefreshTitleText(TalentId)
  if self.LastClickItem then
    self.LastClickItem:PlayNormalAnimation()
  end
  self.LastClickItem = SubWidget
  self.Parent.TargetTalentId = TalentId
end

function M:RefreshTitleText(TalentId)
  local TalentName = HyperWeaponUtils.GetTalentName(TalentId)
  local Text = string.format(GText("UI_HyperWeapon_ResourceFreePopUpText"), TalentName)
  self.Text_Active:SetText(Text)
end

return M

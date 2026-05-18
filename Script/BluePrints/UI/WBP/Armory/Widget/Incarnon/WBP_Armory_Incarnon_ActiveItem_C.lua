require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
end

function M:Destruct()
end

function M:InitContent(Content)
  self.TalentId = Content.TalentId
  self.CallbackObj = Content.CallbackObj
  self.Callback = Content.Callback
  self:InitPage()
  self:SetFreeState(false)
  self:PlayNormalAnimation()
end

function M:InitPage()
  local TalentInfo = DataMgr.HyperWeaponSkillTree[self.TalentId]
  if not TalentInfo then
    return
  end
  if TalentInfo.SkillIcon then
    local Texture = LoadObject(TalentInfo.SkillIcon)
    self.Icon_Talent:SetBrushFromTexture(Texture)
  end
  self.TalentName = HyperWeaponUtils.GetTalentName(self.TalentId)
  self.TalentDesc = HyperWeaponUtils.GetSkillDesc(self.TalentId)
  self.Text_Talent:SetText(self.TalentName)
  self.Text_TalentDesc:SetText(self.TalentDesc)
  self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Consume:SetText(GText("Draft_Resource_Consume"))
  local Contents = {}
  for i, Id in pairs(TalentInfo.ResourceId) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UnitId = Id
    Content.Count = TalentInfo.ResourceNum[i]
    Content.IsShowDetails = true
    Content.IsSelect = false
    Content.ItemType = "Resource"
    Content.Icon = ItemUtils.GetItemIconPath(Id, Content.ItemType)
    Content.UIName = "ArmoryIncarnonDetail"
    table.insert(Contents, Content)
  end
  local Panel = self.WB_Item
  local WidgetCount = 0
  local self = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(self)
  for _, Content in ipairs(Contents) do
    self = Panel:GetChildAt(WidgetCount)
    if not self then
      self = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(self)
    end
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self:Init(Content)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    self = Panel:GetChildAt(i)
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetFreeState(IsFree)
  if IsFree then
    self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_FreeHint:SetText(GText("UI_HyperWeapon_ResourceFree"))
    local Params = {
      OwnerWidget = self,
      TextContent = GText("UI_HyperWeapon_ResourceFreeTips"),
      SoundFunc = function(Obj)
        AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
      end,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
    }
    self.Com_BtnQa:Init(Params)
  else
    self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:IsStopProcessEvent()
  return self.StopProcess
end

function M:PlayNormalAnimation()
  self.StopProcess = false
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
  self:SetFreeState(false)
end

function M:OnButtonClicked()
  if self:IsStopProcessEvent() then
    return
  end
  if self.CallbackObj and self.Callback and type(self.Callback) == "function" then
    self.Callback(self.CallbackObj, self, self.TalentId)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  self:SetFreeState(true)
  self.StopProcess = true
end

function M:OnButonHovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.UnHover)
  self:PlayAnimation(self.Hover)
end

function M:OnButonUnhovered()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnButonPressed()
  if self:IsStopProcessEvent() then
    return
  end
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

return M

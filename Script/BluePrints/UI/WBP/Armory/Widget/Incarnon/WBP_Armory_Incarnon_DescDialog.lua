require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.WeaponUuid = Params.WeaponUuid
  self.WeaponId = Params.WeaponId
  if not self.WeaponUuid then
    return
  end
  local Contents = self:GetItemContents()
  local Panel = self.WB_TalentDesc
  local Widget = Panel:GetChildAt(0)
  if not Widget then
    return
  end
  local WidgetCount = 0
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for _, Content in ipairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:InitContent(Content)
    WidgetCount = WidgetCount + 1
  end
  if WidgetCount > 0 then
    Panel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
    for i = Start, End do
      Panel:RemoveChildAt(i)
    end
  else
    Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:ShowGamepadScrollBtn(self.ScrollBox:GetScrollOffsetOfEnd() > 0)
end

function M:GetItemContents()
  if self.ItemContents then
    return self.ItemContents
  end
  self.ItemContents = {}
  local Avatar = GWorld:GetAvatar()
  local WeaponInfo = Avatar.Weapons[self.WeaponUuid]
  local HyperTalent = WeaponInfo and WeaponInfo.HyperTalent
  for TalentId, Info in pairs(DataMgr.HyperWeaponSkillTree) do
    if Info.WeaponId == self.WeaponId then
      local Content = {}
      Content.WeaponCardLevel = Info.WeaponCardLevel
      Content.SkillIndex = Info.SkillIndex or 0
      Content.IsLocked = true
      local CardTaltents = HyperTalent and HyperTalent[Info.WeaponCardLevel]
      if CardTaltents and CardTaltents[TalentId] then
        Content.IsLocked = false
      end
      Content.Name = HyperWeaponUtils.GetTalentName(TalentId)
      Content.Desc = HyperWeaponUtils.GetSkillDesc(TalentId)
      table.insert(self.ItemContents, Content)
    end
  end
  table.sort(self.ItemContents, function(ContentA, ContentB)
    if ContentA.WeaponCardLevel ~= ContentB.WeaponCardLevel then
      return ContentA.WeaponCardLevel < ContentB.WeaponCardLevel
    else
      return ContentA.SkillIndex < ContentB.SkillIndex
    end
  end)
  return self.ItemContents
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.ScrollBox:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.ScrollBox:GetScrollOffsetOfEnd())
    self.ScrollBox:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M

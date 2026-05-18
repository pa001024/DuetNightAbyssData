require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = Class({
  "BluePrints.UI.WBP.Armory.Widget.Appearance.WBP_Armory_AppearanceCell_Base_C"
})

function M:OnListItemObjectSet(Content)
  M.Super.OnListItemObjectSet(self, Content)
  self:InitSkinLevel()
end

function M:SetReddot(RedDotType, IsNew)
  if RedDotType == UIConst.RedDotType.CommonRedDot then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif RedDotType == UIConst.RedDotType.NewRedDot and IsNew then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitSkinLevel()
  self.Panel_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local Content = self.Content
  local Condition1 = Content.Type == "Char" and Content.ItemId
  local Condition2 = Content.CharId and Content.SkinId
  local SkinId = Condition1 or Condition2
  if not SkinId then
    return
  end
  local CharId = DataMgr.Skin[SkinId] and DataMgr.Skin[SkinId].CharId
  if not CharId then
    return
  end
  local SKinUpData = DataMgr.SkinUpgrade[SkinId]
  if not SKinUpData then
    return
  end
  self:UpdateSKinLevel(1)
  local Avatar = ArmoryUtils:GetAvatar()
  if not Avatar or not Avatar.CommonChars then
    return
  end
  local CommonChar = Avatar.CommonChars[CharId]
  local SkinData = CommonChar and CommonChar.OwnedSkins[SkinId]
  if not SkinData then
    return
  end
  self:UpdateSKinLevel(SkinData.SelectedLevel or SkinData.Level)
end

function M:UpdateSKinLevel(Level)
  if Level < 1 then
    self.Panel_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Panel_Level:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Text_Level:SetText(Level)
end

function M:SetReddot(RedDotType)
  if RedDotType == UIConst.RedDotType.CommonRedDot then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif RedDotType == UIConst.RedDotType.NewRedDot then
    self.New:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M

require("UnLua")
local M = Class("BluePrints.UI.Shop.SkinPreview.WBP_Shop_SkinPreview_Base_C")

function M:Construct()
  M.Super.Construct(self)
  self.Btn_HideUI.Btn_Click.OnClicked:Add(self, self.OnHideUIKeyDown)
  self.Btn_HideUI.Text_Btn:SetText(GText("UI_CameraSystem_HideUI"))
  local DyeIconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Dye.T_Tab_Dye'"
  local ReplayIconPath = "Texture2D'/Game/UI/Texture/Static/Atlas/Shop/T_Shop_Refresh.T_Shop_Refresh'"
  self.IconCache = {}
  self.IconCache.Dye = LoadObject(DyeIconPath)
  self.IconCache.Replay = LoadObject(ReplayIconPath)
end

function M:InitKeySetting()
  M.Super.InitKeySetting(self)
  self.KeyDownEvents = {}
  self.RepeatKeyDownEvents = {}
end

function M:UpdateUI()
  M.Super.UpdateUI(self)
  self.Tab_Skin.Panel_Tab:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:UpdateReplayTips()
  if self.ShopItemData.ItemType == "Resource" then
    self:SetDyeIcon(false)
    self.Text_Color:SetText(GText("UI_Replay"))
    self.Btn_Selective.OnClicked:Add(self, self.OnReplayGesture)
    self.Btn_Dye:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  elseif self.ShopItemData.ItemType == "WeaponAccessory" or self.ShopItemData.ItemType == "CharAccessory" then
    self.Btn_Dye:SetVisibility(ESlateVisibility.Collapsed)
  else
    self:SetDyeIcon(true)
    self.Text_Color:SetText(GText("UI_SkinPreview_Dye"))
    self.Btn_Selective.OnClicked:Add(self, self.OnClickDyeingPreview)
    self.Btn_Dye:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:SetDyeIcon(IsDyeIcon)
  local IconObject = IsDyeIcon and self.IconCache.Dye or self.IconCache.Replay
  if IconObject and self.Img_Dye then
    self.Img_Dye:SetBrushResourceObject(IconObject)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputDevice, CurGamepadName)
end

function M:Destruct()
  self.IconCache = nil
  M.Super.Destruct(self)
end

return M

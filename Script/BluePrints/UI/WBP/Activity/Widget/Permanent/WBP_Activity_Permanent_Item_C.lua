require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M.EModuleState = {
  Normal = 1,
  Locked = 2,
  Finished = 3
}

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self.BigRewardData = nil
  self.MenuAnchorContent = nil
  self.bOpenItemDetailsMenu = false
  self.Content = Content
  self.Content.SelfWidget = self
  self.DisplayIndex = self.Content.DisplayIndex
  self.Parent = Content.Parent
  self.UIName = "ActivityPermanentItem"
  self:RefreshTitleArea()
  self:RefreshDetailArea()
  self:RefreshBigRewardArea()
  self:RefreshRewardArea()
  self:RefreshState()
  self:InitKeyHints()
end

function M:RefreshTitleArea()
  if self.Text_Title then
    self.Text_Title:SetText(GText(self.Content and self.Content.EventTitle or ""))
  end
  if self.Text_TitleNum then
    self.Text_TitleNum:SetText(string.format("%02d", self.DisplayIndex))
  end
end

function M:RefreshDetailArea()
  if self.Text_Detail then
    self.Text_Detail:SetText(GText(self.Content and self.Content.DesText or ""))
  end
end

function M:RefreshBigRewardArea()
  if not self.Content then
    return
  end
  if not self.MenuAnchorContent then
    local BigRewardInfo = RewardUtils:GetRewardViewInfoById(self.Content.BigRewardView)
    if BigRewardInfo then
      self.BigRewardData = BigRewardInfo[1]
      if self.BigRewardData then
        self.MenuAnchorContent = {
          ItemType = self.BigRewardData.Type,
          ItemId = self.BigRewardData.Id,
          UIName = self.UIName
        }
      end
    end
  end
  if self.BigRewardData then
    local Icon = ItemUtils.GetItemIconPath(self.BigRewardData.Id, self.BigRewardData.Type)
    if Icon then
      self:SetBrushByPath(self.Image_Icon, Icon)
    end
    local RewardNumStrTable = {
      "x",
      self.BigRewardData.Quantity and self.BigRewardData.Quantity[1] or 1
    }
    local RewardNumStr = table.concat(RewardNumStrTable)
    self.Text_RewardNum:SetText(RewardNumStr)
  end
  self.ItemDetails_MenuAnchor.ParentWidget = self
  self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor.OnMenuOpenChanged:Add(self, self.OnItemDetailsMenuOpenChanged)
  self.Btn_ItemDetails.OnClicked:Clear()
  self.Btn_ItemDetails.OnHovered:Clear()
  self.Btn_ItemDetails.OnUnhovered:Clear()
  self.Btn_ItemDetails.OnPressed:Clear()
  self.Btn_ItemDetails.OnClicked:Add(self, self.OnBigRewardClicked)
  self.Btn_ItemDetails.OnHovered:Add(self, self.OnBigRewardHovered)
  self.Btn_ItemDetails.OnUnhovered:Add(self, self.OnBigRewardUnhovered)
  self.Btn_ItemDetails.OnPressed:Add(self, self.OnBigRewardPressed)
end

function M:OnItemDetailsMenuOpenChanged(bOpen)
  if bOpen then
    self.bOpenItemDetailsMenu = true
  else
    self.bOpenItemDetailsMenu = false
    self:PlayAnimation(self.Icon_Normal)
  end
  if self.Parent and self.Parent.OnCoreRewardTipsChanged then
    self.Parent:OnCoreRewardTipsChanged(bOpen)
  end
end

function M:OnQaMenuOpenChanged(_, bOpen)
  if self.Parent and self.Parent.OnQaMenuOpenChanged then
    self.Parent:OnQaMenuOpenChanged(bOpen)
  end
end

function M:OnBigRewardClicked()
  self:StopAnimation(self.Icon_Press)
  self:StopAnimation(self.Icon_Click)
  self:PlayAnimation(self.Icon_Click)
  if self.BigRewardData and self.BigRewardData.Id then
    local TableName = self.BigRewardData.Type
    AudioManager(self):PlayItemSound(self, self.BigRewardData.Id, "Click", TableName)
  end
  if not self.MenuAnchorContent then
    return
  end
  self.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, self.MenuAnchorContent)
end

function M:OnBigRewardHovered()
  self:StopAnimation(self.Icon_Hover)
  self:StopAnimation(self.Icon_UnHover)
  self:PlayAnimation(self.Icon_Hover)
end

function M:OnBigRewardUnhovered()
  if self.bOpenItemDetailsMenu then
    return
  end
  self:StopAnimation(self.Icon_Hover)
  self:StopAnimation(self.Icon_Press)
  self:StopAnimation(self.Icon_Click)
  self:StopAnimation(self.Icon_UnHover)
  self:PlayAnimation(self.Icon_UnHover)
end

function M:OnBigRewardPressed()
  if UIUtils.IsMobileInput() then
    return
  end
  self:PlayAnimation(self.Icon_Press)
end

function M:RefreshRewardArea()
  if not self.Content then
    return
  end
  self.List_ItemRewards:ClearListItems()
  local RewardViewInfoList = RewardUtils:GetRewardViewInfoById(self.Content.RewardView)
  if not RewardViewInfoList or not next(RewardViewInfoList) then
    return
  end
  local RewardList = {}
  for _, v in ipairs(RewardViewInfoList) do
    table.insert(RewardList, v)
  end
  for _, ItemData in ipairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = true
    Content.UIName = self.UIName
    Content.bHasGot = self:IsModuleFinished()
    if ItemData.bFirst then
      Content.BonusType = 2
    end
    local BaseCount = ItemData.ItemCount or nil
    if ItemData.Quantity then
      if #ItemData.Quantity > 1 then
        Content.MaxCount = ItemData.Quantity[2]
      end
      BaseCount = ItemData.Quantity[1] or nil
    end
    Content.Count = BaseCount
    self.List_ItemRewards:AddItem(Content)
  end
end

function M:IsModuleFinished()
  if not self.Content then
    return false
  end
  local StateEnum = M.EModuleState or nil
  if StateEnum then
    return self.Content.State == StateEnum.Finished
  end
  return 3 == self.Content.State
end

function M:RefreshState()
  if not self.Content then
    return
  end
  local ActiveIndex = 1
  local ModuleState = self.Content.State
  local StateEnum = M.EModuleState or nil
  if ModuleState == StateEnum.Locked then
    ActiveIndex = 0
  elseif ModuleState == StateEnum.Finished then
    ActiveIndex = 2
  end
  if self.WS_State then
    self.WS_State:SetActiveWidgetIndex(ActiveIndex)
    if 0 == ActiveIndex then
      self:RefreshBtnQa()
      self.Text_Lock:SetText(GText("UI_GameEvent_TobeUnlock"))
    elseif 1 == ActiveIndex then
      self:RefreshJumpButton()
    elseif 2 == ActiveIndex then
      self.Text_Complete:SetText(GText("UI_Finished"))
    end
  end
  if 2 == ActiveIndex then
    self:PlayAnimation(self.Item_Foridden)
  else
    self:PlayAnimation(self.Item_Normal)
  end
end

function M:RefreshJumpButton()
  if not self.Btn_Jump then
    return
  end
  if self.Btn_Jump.UnBindEventOnClickedByObj then
    self.Btn_Jump:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_Jump.BindEventOnClicked then
    self.Btn_Jump:BindEventOnClicked(self, self.OnJumpClicked)
  end
  self.Btn_Jump:SetText(GText("UI_Event_Btn_Goto"))
end

function M:RefreshBtnQa()
  local ConfigData = {
    OwnerWidget = self,
    TextContent = GText(self.Content.LockDes or ""),
    OnMenuOpenChangedCallBack = self.OnQaMenuOpenChanged
  }
  self.Btn_Qa:Init(ConfigData)
end

function M:OnJumpClicked()
  if not self.Parent or not self.Content then
    return
  end
  self.Parent:OnGotoClick(self.Content.KeyId)
end

function M:SetBrushByPath(ImageWidget, IconPath)
  if not ImageWidget or not IconPath then
    return
  end
  local IconObj = LoadObject(IconPath)
  if type(IconObj) == "string" then
    self:LoadTextureAsync(IconObj, function(Texture)
      if Texture and ImageWidget then
        ImageWidget:SetBrushResourceObject(Texture)
      end
    end, "LoadPermanentItemIcon")
  elseif IconObj then
    ImageWidget:SetBrushResourceObject(IconObj)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Parent and self.Parent.OnItemFocused and UIUtils.IsGamepadInput() then
    self.Parent:OnItemFocused(self)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
  if self.Parent and self.Parent.OnItemFocused and UIUtils.IsGamepadInput() then
    self.Parent:OnItemFocused(nil)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:InitKeyHints()
  if self.Key_ItemRewards then
    self.Key_ItemRewards:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  end
  if self.Key_ItemDetails then
    self.Key_ItemDetails:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
  end
  if self.Key_Qa then
    self.Key_Qa:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  end
  self:ResetKeyHints()
end

function M:ResetKeyHints()
  local Collapsed = UIConst.VisibilityOp.Collapsed
  if self.Key_ItemDetails then
    self.Key_ItemDetails:SetVisibility(Collapsed)
  end
  if self.Key_ItemRewards then
    self.Key_ItemRewards:SetVisibility(Collapsed)
  end
  if self.Key_Qa then
    self.QaSwitcher:SetActiveWidgetIndex(0)
    self.Key_Qa:SetVisibility(Collapsed)
  end
  if self.Btn_Jump and self.Btn_Jump.WS_Key then
    self.Btn_Jump.WS_Key:SetVisibility(Collapsed)
  end
end

function M:SetKeyHintsVisible(bShowRewards, bShowDetails, bShowJumpHint, bShowQaHint)
  local Vis = UIConst.VisibilityOp
  local Show = Vis.SelfHitTestInvisible
  local Hide = Vis.Collapsed
  if self.Key_ItemRewards then
    self.Key_ItemRewards:SetVisibility(bShowRewards and Show or Hide)
  end
  if self.Key_ItemDetails then
    self.Key_ItemDetails:SetVisibility(bShowDetails and Show or Hide)
  end
  if self.Key_Qa then
    if bShowQaHint then
      self.QaSwitcher:SetActiveWidgetIndex(1)
    else
      self.QaSwitcher:SetActiveWidgetIndex(0)
    end
    self.Key_Qa:SetVisibility(bShowQaHint and Show or Hide)
  end
  if self.Btn_Jump and self.Btn_Jump.WS_Key then
    self.Btn_Jump.WS_Key:SetVisibility(bShowJumpHint and Show or Hide)
  end
end

function M:FocusRewardGrid()
  if self.List_ItemRewards then
    self.List_ItemRewards:SetFocus()
  end
end

function M:TriggerCoreRewardTips()
  self:OnBigRewardClicked()
end

function M:TriggerQaTips()
  if self.Btn_Qa then
    self.Btn_Qa:SetChecked(true)
  end
end

function M:CloseQaTips()
  if self.Btn_Qa then
    self.Btn_Qa:CloseMenuAnchor()
  end
end

function M:FocusQaMenu()
  if self.Btn_Qa and self.Btn_Qa.Tips_MenuAnchor then
    self.Btn_Qa.Tips_MenuAnchor:SetFocus()
  end
end

function M:IsQaMenuOpen()
  return self.Btn_Qa and self.Btn_Qa.IsMenuAnchorOpen and self.Btn_Qa:IsMenuAnchorOpen()
end

function M:SetSelected(bSelected)
  if bSelected then
    self:StopAnimation(self.UnHover)
    self:PlayAnimation(self.Hover)
  else
    self:StopAnimation(self.Hover)
    self:PlayAnimation(self.UnHover)
  end
end

function M:CloseCoreRewardTips()
  if self.ItemDetails_MenuAnchor and self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor then
    self.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:CloseMenu()
  end
end

return M

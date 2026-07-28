require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.SelfWidget = self
  local CommonQuestConfig = DataMgr.CommonQuestDetail[Content.QuestId]
  self.RichTextTitle:SetText(GText(CommonQuestConfig.StarterQuestDes))
  self.TextNumNum:SetText(Content.Progress .. "/")
  self.TextNumTotal:SetText(Content.Target)
  local JumpId = CommonQuestConfig.JumpUIId
  self.JumpId = JumpId
  self:PlayAnimation(self.Normal)
  if Content.RewardsGot then
    self.BtnArea:SetForbidden(true)
    self:PlayAnimation(self.Foribidden)
  else
    self:PlayAnimation(self.Normal)
    if self.JumpId then
      self.BtnArea:SetForbidden(false)
      self.Text_Btn:SetVisibility(UIConst.VisibilityOp.Visible)
      self.BtnArea:SetVisibility(UIConst.VisibilityOp.Visible)
    else
      self.BtnArea:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Text_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  local CommonQuestConfig = DataMgr.CommonQuestDetail[self.Content.QuestId]
  local RewardId = CommonQuestConfig.QuestReward[1]
  local RewardConfig = DataMgr.Reward[RewardId]
  local ResourceId = RewardConfig.Id[1]
  local ResourceCount = RewardConfig.Count[1][1]
  local ItemData = DataMgr.Resource[ResourceId]
  if ItemData then
    local IconPath = ItemData.Icon
    self.Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Item:Init({
      Id = ResourceId,
      Count = ResourceCount,
      Icon = IconPath,
      ItemType = "Resource",
      UIName = "AccessoryDropPahseTwo",
      IsShowDetails = true,
      HandleMouseDown = true,
      MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft,
      bHasGot = Content.RewardsGot
    })
  else
    self.Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.KeyImg:CreateGamepadKey("A")
  self.WBP_Com_KeyImg:CreateGamepadKey("LS")
  self:SetGoGamepadIconVisible(false)
end

function M:Construct()
  self.BtnArea.OnClicked:Add(self, self.GoToSystem)
  self.Text_Btn:SetText(GText("UI_GameEvent_Goto"))
  self.Item.Item.ItemDetails_MenuAnchor:SetLastFocusWidget(self)
end

function M:GoToSystem()
  PageJumpUtils:JumpToTargetPageByJumpId(self.JumpId)
end

function M:OnResourceClick()
  local Icon_Coin = self.Item
  if Icon_Coin.NotInteractive or Icon_Coin.IsShowDetails and Icon_Coin.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() or Icon_Coin:IsInAnimationPlaying() then
    return true
  end
  if Icon_Coin.Item.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
    return true
  end
  local Content = {
    ItemType = Icon_Coin.ItemType,
    ItemId = Icon_Coin.Id,
    Uuid = Icon_Coin.Uuid,
    MenuPlacement = Icon_Coin.MenuPlacement,
    IsShowDetails = true,
    UIName = Icon_Coin.UIName,
    HandleKeyDown = Icon_Coin.HandleKeyDown,
    OnItemRemovedFromFocusPathEvent = function()
      self:SetFocus()
    end
  }
  Icon_Coin.Item.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
  Icon_Coin.Content.IsShowTips = true
  Icon_Coin.Content.IsSelect = true
  return true
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self:SetGoGamepadIconVisible(true)
  end
  self:SetFocus()
end

function M:OnFocusLost(MyGeometry, InFocusEvent)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandle = false
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    IsHandle = self:OnResourceClick()
    self:SetGoGamepadIconVisible(false)
  else
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.JumpId then
      self:GoToSystem()
      IsHandle = true
    else
    end
  end
  if IsHandle then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:SetGoGamepadIconVisible(bVisible)
  if bVisible and UIUtils.IsGamepadInput() then
    if self.JumpId then
      self.KeyImg:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnInputTypeChange()
  if UIUtils.IsGamepadInput() then
    self:SetGoGamepadIconVisible(true)
  else
    self:SetGoGamepadIconVisible(false)
  end
end

return M

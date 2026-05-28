require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bGamepadIconVisible = true
  self.Btn_Area.OnClicked:Add(self, self.OnClick)
  self.Btn_Area:SetVisibility(UIConst.VisibilityOp.Visable)
  self:BindInputMethodChangedDelegate()
  self:OnInputMethodChanged(UIUtils.UtilsGetCurrentInputType())
  self.Key_Consume:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    bLongPress = false
  })
  self.Key_Unlock:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    },
    bLongPress = false
  })
  self.VX_Forbbiden:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:SetData(Params)
  self.Params = Params
  local ResourceId = GuildCommon.GuildCreateItemId
  self.Icon_Piece:Init({
    Id = ResourceId,
    Icon = ItemUtils.GetItemIcon(ResourceId, "Resource"),
    ItemType = "Resource",
    UIName = "GuildCreate",
    IsShowDetails = true,
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
  })
  self.Text_Unlock:SetText(GText("UI_CreateGuild"))
  self:UpdatePrice()
end

function M:UpdatePrice()
  local OwnedCurrency = GWorld:GetAvatar().Resources[GuildCommon.GuildCreateItemId]
  local OwnedCurrencyAmount = OwnedCurrency and OwnedCurrency.Count or 0
  self.Num_Hold:SetText(OwnedCurrencyAmount)
  self.Num_Need:SetText(1)
  local IsEnough = OwnedCurrencyAmount >= 1
  self.IsEnough = IsEnough
  if not IsEnough then
    self.Num_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("DA2A4A"))
  else
    self.Num_Hold:SetColorAndOpacity(UE4.UUIFunctionLibrary.StringToSlateColor("FFFFFFFF"))
  end
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
end

function M:SetClickCallback(CallbackInfo)
  self.CallbackInfo = CallbackInfo
end

function M:OnClick()
  self.CallbackInfo.Func(self.CallbackInfo.Obj)
end

function M:SetState(State)
  if State and self.IsEnough then
    self:PlayAnimation(self.Normal)
    self.Btn_Area:SetForbidden(false)
  else
    self:PlayAnimation(self.Forbbiden)
    self.Btn_Area:SetForbidden(true)
  end
end

function M:OnResourceClick()
  local Icon_Coin = self.Icon_Piece
  if Icon_Coin.NotInteractive or Icon_Coin.IsShowDetails and Icon_Coin.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() or Icon_Coin:IsInAnimationPlaying() then
    return true
  end
  if Icon_Coin.ItemDetails_MenuAnchor.ItemDetailsMenuAnchor:IsOpen() then
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
    OnItemRemovedFromFocusPathEvent = self.Params.ItemDetailCloseCallback
  }
  Icon_Coin.ItemDetails_MenuAnchor:OpenItemDetailsWidget(false, Content)
  Icon_Coin.Content.IsShowTips = true
  Icon_Coin.Content.IsSelect = true
  return true
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:SetGamepadIconVisibility(bShow)
  self.bGamepadIconVisible = bShow
  self:OnInputMethodChanged(UIUtils.UtilsGetCurrentInputType())
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad and self.bGamepadIconVisible then
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Key_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M

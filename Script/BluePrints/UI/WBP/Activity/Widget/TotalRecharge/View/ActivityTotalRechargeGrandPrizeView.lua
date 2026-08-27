require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:FillWithData(Content)
  self.Content = Content
  self.ParentWidget = Content.ParentWidget
  self.ItemType = Content.LastRewardTypeId
  self.Id = Content.LastRewardId
  self.Icon = Content.LastRewardIcon
  self.Index = Content.Index
  self.Count = Content.Count
  self.StuffClickCallback = Content.StuffClickCallback
  if self.ItemType == nil or self.Id == nil then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self:UpdateView(Content)
  self:UnBindButtonPerformances()
  self:BindButtonPerformances()
end

function M:GetRewardStuffIndex()
  return self.Index
end

local function GetHairFallbackName(HairConfig)
  if type(HairConfig) ~= "table" or not HairConfig.CharId then
    return nil
  end
  local CharConfig = DataMgr.CharacterData and DataMgr.CharacterData[HairConfig.CharId]
  return CharConfig and (CharConfig.CharName or CharConfig.Name)
end

function M:UpdateView(Content)
  local Type = Content.LastRewardTypeId
  local Id = Content.LastRewardId
  local ItemData = DataMgr[Type][Id]
  if not ItemData then
    return
  end
  local Name = ItemData.ResourceName or ItemData.Name or ItemData.SkinName or ItemData.MountName or ItemData.HairName or ItemData.ItemName or GetHairFallbackName(ItemData)
  self.Text_Num:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Text_Title:SetText(string.format(GText("UI_Event_CumulativeTopUpEvent_FinalRewardDes"), Content.NeedPoint))
  self.TextReName:SetText(GText(Name))
  self.Com_Key_View:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  if self.Content.LastRewardIcon then
    local Texture = LoadObject(self.Content.LastRewardIcon)
    if IsValid(Texture) then
      self.Img_Icon:SetBrushFromTexture(Texture)
    end
  end
end

function M:BindButtonPerformances()
  self.BtnView:BindEventOnClicked(self, self.OnBtnClicked)
  self.BtnView:TryOverrideSoundFunc(function()
  end)
end

function M:UnBindButtonPerformances()
  self.BtnView:UnBindEventOnClickedByObj(self)
end

function M:OnStuffDetailViewOpenChanged(IsOpened)
  if type(self.StuffClickCallback) == "function" then
    self.StuffClickCallback(self.ParentWidget, IsOpened, self.Index)
  end
end

function M:OnBtnClicked()
  if self.Content == nil then
    return
  end
  if nil == self.Content.LastRewardId then
    return
  end
  if self.Content.LastRewardTypeId == "Char" or self.Content.LastRewardTypeId == "Character" then
    self:TryOpenCharacterPreview(self.Content.LastRewardId)
  elseif self.Content.LastRewardTypeId == "Weapon" then
    self:TryOpenWeaponPreview(self.Content.LastRewardId)
  else
    local Content = {}
    Content.TypeId = self.Content.LastRewardId
    Content.ItemType = self.Content.LastRewardTypeId
    Content.SinglePreview = true
    Content.HidePurchase = true
    PageJumpUtils:JumpToSkinPreview(Content, self.ParentWidget)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  end
end

function M:TryOpenCharacterPreview(CharId)
  if not CharId then
    return
  end
  UIManager(self):LoadUINew("ArmoryDetail", {
    PreviewCharIds = {CharId},
    bHideCharAppearance = true,
    bHideWeaponAppearance = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
  })
end

function M:TryOpenWeaponPreview(WeaponId)
  if not WeaponId then
    return
  end
  UIManager(self):LoadUINew("ArmoryDetail", {
    PreviewWeaponIds = {WeaponId},
    bHideCharAppearance = true,
    bHideWeaponAppearance = true,
    bHideBoxBtn = true,
    bNoEndCamera = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
  })
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
  if IsUseGamePad then
    self.WS_Btn:SetActiveWidgetIndex(1)
  else
    self.WS_Btn:SetActiveWidgetIndex(0)
  end
end

return M

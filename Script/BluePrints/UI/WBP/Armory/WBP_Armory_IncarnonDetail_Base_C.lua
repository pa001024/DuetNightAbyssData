require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local StateEnum = HyperWeaponUtils.ActiveState

function M:Construct()
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.OnBackgroundClicked)
  self.Text_Consume:SetText(GText("Draft_Resource_Consume"))
  self.Tip_Unlock:SetText(GText("UI_HyperWeapon_ResourceFreeReminder"))
  self.Text_FreeHint:SetText(GText("UI_HyperWeapon_ResourceFree"))
  self.Text_SmeltLevel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Armory_Incarnon.Panel_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local Params = {
    OwnerWidget = self,
    TextContent = GText("UI_HyperWeapon_ResourceFreeTips"),
    SoundFunc = function(Obj)
      AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
    end,
    MenuPlacement = EMenuPlacement.MenuPlacement_MenuRight
  }
  self.Com_BtnQa:Init(Params)
  self:AddDispatcher(EventID.OnHyperWeaponForgeLevelUp, self, self.OnHyperWeaponForgeLevelUp)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self.Params = (...)
  self.Parent = self.Params.Parent
  self.Target = self.Params.Target
  self:PlayAnimation(self.Detail_In)
  self.Params.Parent = self
  self.Params.CallbackObj = self
  self.Params.CardCallback = self.OnCardLevelClicked
  self.Params.TalentCallback = self.OnTalentPointClicked
  self.Params.OnAddedToFocusPath = self.OnIncarnonPageAddtoFocusPath
  self.Params.OnRemovedFromFocusPath = self.OnIncarnonPageRemovedFromFocusPath
  self.Params.OnLevelWidgetAddToFocusPath = self.OnLevelWidgetAddToFocusPath
  self.Params.OnTalentWidgetAddToFocusPath = self.OnTalentWidgetAddToFocusPath
  self.Armory_Incarnon:Init(self.Params)
  self.Avatar = GWorld:GetAvatar()
  self.WeaponId = self.Target.WeaponId
  self.WeaponUuid = self.Target.Uuid
  self.HasGotWeapon = self.Avatar.Weapons[self.WeaponUuid] ~= nil
  self.MaxCardLevel = HyperWeaponUtils.GetMaxForgeLevel(self.WeaponId)
  self:InitWeaponIconAndName()
  self:SelectCardOrTalent(self.Params)
end

function M:OnHyperWeaponForgeLevelUp()
  local function IsTalentWisget(Widget)
    return Widget and Widget.TalentId
  end
  
  local Widget = self.LastSelecedItem
  if IsTalentWisget(Widget) then
    self:RefreshTalentDetailPanel(Widget, Widget.TalentId)
  else
    self:RefreshCardDetailPanel(Widget, Widget.CardLevel)
  end
end

function M:InitWeaponIconAndName()
  local MeleeTags, MeleeTagNames, RangedTags, RangedTagNames = UIUtils.GetAllWeaponTags()
  local WeaponTags, WeaponTagNames, WeaponTag
  if self.Target:HasTag("Melee") then
    WeaponTags, WeaponTagNames = MeleeTags, MeleeTagNames
  else
    WeaponTags, WeaponTagNames = RangedTags, RangedTagNames
  end
  for _, value in ipairs(WeaponTags) do
    if self.Target:HasTag(value) then
      WeaponTag = value
      break
    end
  end
  local WeaponTagData = DataMgr.WeaponTag[WeaponTag]
  if WeaponTagData then
    local Texture = LoadObject(WeaponTagData.Icon)
    self.Icon_Type:SetBrushFromTexture(Texture)
  end
  local WeaponInfo = DataMgr.Weapon[self.WeaponId]
  local WeaponName = WeaponInfo and WeaponInfo.WeaponName
  self.Text_Weapon:SetText(GText(WeaponName))
end

function M:SelectCardOrTalent(Params)
  if not Params then
    return
  end
  local CardLevel = Params.FocusCardLevel
  local TalentId = Params.FocusTalentId
  if CardLevel then
    self.Armory_Incarnon:CallCardClickEvent(CardLevel)
  elseif TalentId then
    self.Armory_Incarnon:CallTalentClickEvent(TalentId)
  end
end

function M:OnCardLevelClicked(Widget, CardLevel)
  if not self:ProcessSelectedAnimation(Widget) then
    return
  end
  self:RefreshCardDetailPanel(Widget, CardLevel)
end

function M:RefreshCardDetailPanel(Widget, CardLevel)
  local WeaponCardInfo = DataMgr.HyperWeaponCardLevel[self.WeaponId]
  local CurLevelInfo = WeaponCardInfo and WeaponCardInfo[CardLevel] or {}
  local CardState = HyperWeaponUtils.GetCardState(self.Avatar, self.WeaponUuid, CardLevel)
  self.WS_Title:SetActiveWidgetIndex(0)
  self.Text_SmeltLevel:SetText(CardLevel)
  self.Text_Smelt:SetText(GText("UI_WeaponStrength_Level") .. CardLevel)
  self.WS_Page:SetActiveWidgetIndex(0)
  if CardState ~= StateEnum.Activated then
    self.Text_Unlock:SetText(GText("UI_HyperWeapon_CardLevelUnlockTalent"))
    self.Text_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Tip_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Text_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Tip_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitCardDetailTalents(Widget)
  local NeedResource = CurLevelInfo.ResourceId ~= nil
  if self.HasGotWeapon and CardState ~= StateEnum.Activated and NeedResource then
    self.HB_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitItems(CurLevelInfo)
  else
    self.HB_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local Exp = CurLevelInfo.CollectRewardExp
  if self.HasGotWeapon and CardState ~= StateEnum.Activated and Exp then
    self.Panel_ExpHint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local ExpHintText = string.format(GText("UI_Armory_WeaponBreakExp"), 1, Exp)
    self.Text_ExpHint:SetText(ExpHintText)
  else
    self.Panel_ExpHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitCardDetailButtonState(CardLevel)
end

function M:OnTalentPointClicked(Widget, TalentId)
  if not self:ProcessSelectedAnimation(Widget) then
    return
  end
  self:RefreshTalentDetailPanel(Widget, TalentId)
end

function M:RefreshTalentDetailPanel(Widget, TalentId)
  local TalentInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  local TalentState = HyperWeaponUtils.GetTalentState(self.Avatar, self.WeaponUuid, TalentId)
  local CardLevel = TalentInfo.WeaponCardLevel
  self.WS_Title:SetActiveWidgetIndex(1)
  local IconPath = TalentInfo and TalentInfo.SkillIcon
  if IconPath then
    local Texture = LoadObject(IconPath)
    local DynamicMaterial = self.Icon_Talent:GetDynamicMaterial()
    DynamicMaterial:SetTextureParameterValue("IconTex", Texture)
  end
  self.Text_Talent:SetText(HyperWeaponUtils.GetTalentName(TalentId))
  self.Text_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Tip_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WS_Page:SetActiveWidgetIndex(1)
  self.Text_TalentDesc:SetText(HyperWeaponUtils.GetSkillDesc(TalentId))
  self.Panel_ExpHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.HasGotWeapon and TalentState ~= StateEnum.Activated and 0 ~= CardLevel and CardLevel ~= self.MaxCardLevel then
    self.HB_Consume:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.HB_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:InitItems(TalentInfo)
    local ServerWeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
    if CardLevel > ServerWeaponInfo.HyperCardLevel then
      self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      local ServerTalents = ServerWeaponInfo.HyperTalent[CardLevel]
      local bCanActivateForFree = nil == ServerTalents or ServerTalents:IsEmpty()
      if bCanActivateForFree then
        self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      else
        self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  else
    self.HB_Consume:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_FreeHint:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.HB_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:InitTalentDetailButtonState(TalentId)
end

function M:InitCardDetailTalents(CardWidget)
  local TalentMap = CardWidget.TalentsMap
  local CardLevel = CardWidget.CardLevel
  local WeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
  local HyperTalent = WeaponInfo and WeaponInfo.HyperTalent
  local WidgetCount = 0
  for TalentId, _ in pairs(TalentMap) do
    local WidgetIndex = WidgetCount + 1
    local Widget = self["Incarnon_Desc_" .. WidgetIndex]
    Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Content = {}
    Content.IsLocked = true
    local CardTaltents = HyperTalent and HyperTalent[CardLevel]
    if CardTaltents and CardTaltents[TalentId] then
      Content.IsLocked = false
    end
    Content.Name = HyperWeaponUtils.GetTalentName(TalentId)
    Content.Desc = HyperWeaponUtils.GetSkillDesc(TalentId)
    Widget:InitContent(Content)
    WidgetCount = WidgetCount + 1
  end
  if WidgetCount < 2 then
    self.Incarnon_Desc_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:ProcessSelectedAnimation(Widget)
  if self.LastSelecedItem == Widget then
    return false
  end
  if self.LastSelecedItem then
    self.LastSelecedItem:PlayNormalAnimation()
  end
  Widget:PlaySelectedAnimation()
  self.LastSelecedItem = Widget
  return true
end

function M:InitItems(ResourceInfo)
  local Panel = self.HB_Item
  if not ResourceInfo or not ResourceInfo.ResourceId then
    Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local Contents = {}
  for i, Id in pairs(ResourceInfo.ResourceId) do
    local Info = DataMgr.Resource[Id]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UnitId = Id
    Content.Count = self.Avatar:GetResourceNum(Id) or 0
    Content.NeedCount = ResourceInfo.ResourceNum[i]
    Content.IsShowDetails = true
    Content.IsSelect = false
    Content.ItemType = "Resource"
    Content.Rarity = Info and Info.Rarity or 1
    Content.Icon = ItemUtils.GetItemIconPath(Id, Content.ItemType)
    Content.UIName = "ArmoryIncarnonDetail"
    table.insert(Contents, Content)
    self:OnStuffItemContentCreated(Content)
  end
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for _, Content in ipairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:Init(Content)
    WidgetCount = WidgetCount + 1
  end
  if WidgetCount > 0 then
    Panel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
    for i = Start, End do
      Widget = Panel:GetChildAt(i)
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    Panel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnStuffItemContentCreated(Content)
  rawset(Content, "OnFocusReceivedEvent", {
    Obj = self,
    Callback = self.OnStuffItemFocusReceived,
    Params = Content
  })
  rawset(Content, "OnMouseButtonUpEvents", {
    Obj = self,
    Callback = self.OnStuffItemClicked,
    Params = Content
  })
  rawset(Content, "OnRemovedFromFocusPathEvent", {
    Obj = self,
    Callback = self.OnStuffItemRemovedFromFFocusPath,
    Params = Content
  })
end

function M:InitCardDetailButtonState(CardLevel)
  if not self.HasGotWeapon then
    self.Panel_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Panel_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local CardState = HyperWeaponUtils.GetCardState(self.Avatar, self.WeaponUuid, CardLevel)
  if CardState == StateEnum.UnlockedActivatable then
    local function ActivePopupUI()
      local Params = {
        RightCallbackObj = self,
        
        RightCallbackFunction = function()
          self:UnlockCardLevel(CardLevel)
        end,
        LeftCallbackObj = self,
        LeftCallbackFunction = function()
        end,
        CloseBtnCallbackObj = self,
        CloseBtnCallbackFunction = function()
        end,
        ShortText = "UI_HyperWeapon_ResourceConsumePopUpText",
        ShortTextParams = {
          GText("UI_WeaponStrength_Level") .. CardLevel
        }
      }
      Params.ItemList = self:GetPopupItemList(CardLevel)
      UIManager(self):ShowCommonPopupUI(100359, Params, self)
    end
    
    self.WS_Btn:SetActiveWidget(self.Btn_Unlock)
    self.Btn_Unlock:SetText(GText("UI_HyperWeapon_UnlockTalent"))
    self.Btn_Unlock:BindSingleEventOnClicked(self, ActivePopupUI)
  else
    self.WS_Btn:SetActiveWidget(self.Com_Hint)
    self.Com_Hint.WS_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_Hint.WS_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    local LockedTextWidget = self.Com_Hint.Text_Hint_Locked
    if CardState == StateEnum.UnlockedInactive then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
      LockedTextWidget:SetText(GText("UI_Prop_Notenough"))
    elseif CardState == StateEnum.Locked then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
      local ServerWeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
      local ServerCardLevel = ServerWeaponInfo.HyperCardLevel
      local LastCardLevel = math.clamp(CardLevel - 1, 0, CardLevel)
      if ServerCardLevel < LastCardLevel then
        LockedTextWidget:SetText(GText("UI_HyperWeapon_PreviousCardLevelLocked"))
        return
      end
      local WeaponCardInfo = DataMgr.HyperWeaponCardLevel[self.WeaponId]
      local CurLevelInfo = WeaponCardInfo and WeaponCardInfo[CardLevel] or {}
      LockedTextWidget:SetText(GText(CurLevelInfo.UnlockConditionDes))
    elseif CardState == StateEnum.Activated then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(1)
      self.Com_Hint.Text_Hint_Positive:SetText(GText("UI_HyperWeapon_TalentHasUnlocked"))
    end
  end
end

function M:InitTalentDetailButtonState(TalentId)
  local TalentInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  if not TalentInfo then
    return
  end
  if not self.HasGotWeapon then
    self.Panel_Unlock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Panel_Unlock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local CardLevel = TalentInfo.WeaponCardLevel
  local TalentState = HyperWeaponUtils.GetTalentState(self.Avatar, self.WeaponUuid, TalentId)
  local TalentName = HyperWeaponUtils.GetTalentName(TalentId)
  if TalentState == StateEnum.UnlockedActivatable then
    local ServerWeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
    local ServerTalents = ServerWeaponInfo.HyperTalent[CardLevel]
    local bCanActivateForFree = nil == ServerTalents or ServerTalents:IsEmpty()
    if bCanActivateForFree then
      self.WS_Btn:SetActiveWidget(self.Btn_Unlock_Free)
      
      local function FreeActivePopUI()
        local Talents = HyperWeaponUtils.GetTalents(self.WeaponId, CardLevel)
        local TalentCount = Talents and #Talents or 0
        if TalentCount < 2 then
          self:UnlockHyperTalent(TalentId)
          return
        end
        self.TargetTalentId = nil
        local Params = {
          TargetTalentId = TalentId,
          WeaponId = self.WeaponId,
          CardLevel = CardLevel,
          RightCallbackObj = self,
          RightCallbackFunction = function()
            self:UnlockHyperTalent(self.TargetTalentId or TalentId)
          end,
          LeftCallbackObj = self,
          LeftCallbackFunction = function()
          end,
          CloseBtnCallbackObj = self,
          CloseBtnCallbackFunction = function()
          end
        }
        UIManager(self):ShowCommonPopupUI(100358, Params, self)
      end
      
      self.Btn_Unlock_Free:SetText(GText("UI_HyperWeapon_UnlockTalentForFree"))
      self.Btn_Unlock_Free:BindSingleEventOnClicked(self, FreeActivePopUI)
    else
      local function ActivePopupUI()
        local Params = {
          RightCallbackObj = self,
          
          RightCallbackFunction = function()
            self:UnlockHyperTalent(TalentId)
          end,
          LeftCallbackObj = self,
          LeftCallbackFunction = function()
          end,
          CloseBtnCallbackObj = self,
          CloseBtnCallbackFunction = function()
          end,
          ShortText = "UI_HyperWeapon_ResourceConsumePopUpText",
          ShortTextParams = {TalentName}
        }
        Params.ItemList = self:GetPopupItemList(nil, TalentId)
        UIManager(self):ShowCommonPopupUI(100359, Params, self)
      end
      
      self.WS_Btn:SetActiveWidget(self.Btn_Unlock)
      self.Btn_Unlock:SetText(GText("UI_HyperWeapon_UnlockTalent"))
      self.Btn_Unlock:BindSingleEventOnClicked(self, ActivePopupUI)
    end
  else
    self.WS_Btn:SetActiveWidget(self.Com_Hint)
    self.Com_Hint.WS_Normal:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_Hint.WS_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if TalentState == StateEnum.UnlockedInactive then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
      local TextWidget = self.Com_Hint.Text_Hint_Locked
      TextWidget:SetText(GText("UI_Prop_Notenough"))
    elseif TalentState == StateEnum.Locked then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(2)
      local TextWidget = self.Com_Hint.Text_Hint_Locked
      local ServerWeaponInfo = self.Avatar.Weapons[self.WeaponUuid]
      local ServerCardLevel = ServerWeaponInfo.HyperCardLevel
      if CardLevel > ServerCardLevel then
        TextWidget:SetText(GText("UI_HyperWeapon_TalentCardLevelLocked"))
        return
      end
      local LastCardLevel = CardLevel - 1
      LastCardLevel = math.clamp(LastCardLevel, 0, CardLevel)
      local LastTalents = HyperWeaponUtils.GetTalents(self.WeaponId, LastCardLevel)
      if not LastTalents then
        return
      end
      TextWidget:SetText(GText("UI_HyperWeapon_PreviousTalentLocked"))
    elseif TalentState == StateEnum.Activated then
      self.Com_Hint.WidgetSwitcher_State:SetActiveWidgetIndex(1)
      self.Com_Hint.Text_Hint_Positive:SetText(GText("UI_HyperWeapon_TalentHasUnlocked"))
    end
  end
end

function M:GetPopupItemList(CardLevel, TalentId)
  local ResourceInfo
  if CardLevel then
    local WeaponCardInfo = DataMgr.HyperWeaponCardLevel[self.WeaponId]
    ResourceInfo = WeaponCardInfo[CardLevel]
  else
    ResourceInfo = DataMgr.HyperWeaponSkillTree[TalentId]
  end
  local ItemList = {}
  for i, Id in pairs(ResourceInfo.ResourceId) do
    local Content = {}
    Content.ItemId = Id
    Content.ItemType = "Resource"
    Content.ItemNum = ResourceInfo.ResourceNum[i]
    table.insert(ItemList, Content)
  end
  return ItemList
end

function M:UnlockCardLevel(CardLevel)
  local function OnAnimationFinished()
    for _, Widget in pairs(self.LastSelecedItem.TalentsMap) do
      Widget:InitAnimationState()
    end
    local NextWidget = self.Armory_Incarnon:GetCardLevelWidget(CardLevel + 1)
    if NextWidget then
      NextWidget:InitAnimationState()
    end
  end
  
  local function Callback(Ret)
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
      return
    end
    local Widget = self.LastSelecedItem
    if Widget then
      Widget:UnlockCardLevel(self, OnAnimationFinished)
      self:RefreshCardDetailPanel(Widget, CardLevel)
      self.Armory_Incarnon:RefreshProgressUI()
    end
  end
  
  self:BlockAllUIInput(true)
  self.Avatar:WeaponHyperLevelUp(Callback, self.WeaponUuid)
end

function M:UnlockHyperTalent(TalentId)
  local function OnAnimationFinished()
    local CardWidget = self.LastSelecedItem.Parent
    
    local CardLevel = CardWidget.CardLevel
    local NextWidget = self.Armory_Incarnon:GetCardLevelWidget(CardLevel + 1)
    if NextWidget then
      for _, Widget in pairs(NextWidget.TalentsMap) do
        Widget:InitAnimationState()
      end
    end
  end
  
  local function Callback(Ret)
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(Ret) then
      return
    end
    local CardWidget = self.LastSelecedItem.Parent
    local TalentWidget = CardWidget.TalentsMap[TalentId]
    if TalentWidget then
      TalentWidget:UnlockTalent(self, OnAnimationFinished)
    end
    self:RefreshTalentDetailPanel(self.LastSelecedItem, self.LastSelecedItem.TalentId)
    self.Armory_Incarnon:RefreshProgressUI()
  end
  
  self:BlockAllUIInput(true)
  self.Avatar:WeaponUnlockHyperTalent(Callback, self.WeaponUuid, TalentId)
end

function M:OnBackgroundClicked()
  self:OnCloseBtnClicked()
  return UIUtils.Handled
end

function M:OnCloseBtnClicked()
  self:StopAllAnimations()
  if self.LastSelecedItem then
    self.LastSelecedItem:PlayNormalAnimation()
  end
  self.IsInOutAnim = true
  self:BindToAnimationFinished(self.Detail_Out, {
    self,
    self.OnOutAnimFinished
  })
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:PlayAnimation(self.Detail_Out)
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain then
    ArmoryMain:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    ArmoryMain.Panel_SubUI:SetVisibility(UIConst.VisibilityOp.Hidden)
    ArmoryMain:PlayAnimation(ArmoryMain.RoleList_In)
    ArmoryMain:PlayAnimation(ArmoryMain.BG_BackFirst)
    if ArmoryMain.BackgroundBlurWithMask_39 then
      ArmoryMain.BackgroundBlurWithMask_39:SetVisibility(ESlateVisibility.Collapsed)
    end
    ArmoryMain.Tab_Arm:PlayInAnim()
    ArmoryMain.ReceiveEnterStateNoAnim = true
    ArmoryMain:UpdateMontageAndCamera()
  end
end

function M:OnOutAnimFinished()
  self.IsInOutAnim = false
  self:BlockAllUIInput(false)
  local Params = {SkipAnimationIn = true}
  self.Parent:OnDetailsPanelColsed(Params)
  local ArmoryMain = UIManager(self):GetArmoryUIObj()
  if ArmoryMain and ArmoryMain.BackgroundBlurWithMask_39 then
    ArmoryMain.BackgroundBlurWithMask_39:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    ArmoryMain.CurrentSubUI:SetFocusWidget(self.LastSelecedItem.CardLevel, self.LastSelecedItem.TalentId)
  end
  self:Close()
end

return M

require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local EquipState = {
  Locked = 0,
  UnEquip = 1,
  Equiping = 2
}
local EquipRarity = {
  Blue = 3,
  Purple = 4,
  Gold = 5
}

function M:Construct()
  M.Super.Construct(self)
  self.WBP_Activity_AutoChess_MonsterInfoDetails.DisableGamepadKey = true
  self.Equipment_01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Equipment_02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.WBP_Activity_AutoChess_MonsterInfoDetails.WS_Type:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Lock:SetGamepadIconVisibility(false)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  self.Text_Equipment:SetText(GText("UI_AutoChess_Equip2"))
  self.TextTips:SetText(GText("UI_Disptach_Chosen"))
  if GameState and GameState:IsInDungeon() then
    self.IsInDungeon = true
    self.Panel_Chess:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.IsInDungeon = false
    self.Panel_Chess:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self.Btn_Equip.Button_Area.OnClicked:Add(self, self.AddEquip)
  self.Btn_Takeoff.Button_Area.OnClicked:Add(self, self.RemoveEquip)
  self.Btn_Lock.Button_Area.OnClicked:Add(self, self.OnClickFull)
  self.Btn_Close.OnClicked:Add(self, self.OnClickReturn)
  self.WBP_Com_BtnImg01:BindEventOnClicked(self, self.OnOpenMonsterTipsClicked)
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.WBP_Activity_AutoChess_MonsterInfoDetails:InitView(self)
end

function M:Destruct()
  self.Btn_Equip.Button_Area.OnClicked:Remove(self, self.AddEquip)
  self.Btn_Takeoff.Button_Area.OnClicked:Remove(self, self.RemoveEquip)
  self.Btn_Lock.Button_Area.OnClicked:Remove(self, self.OnClickFull)
  self.Btn_Close.OnClicked:Remove(self, self.OnClickReturn)
  self.WBP_Com_BtnImg01:UnBindEventOnClicked(self, self.OnOpenMonsterTipsClicked)
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "Open", nil)
  self.IsOpenMonsterTips = false
  self:UpdateTipsVisibility(false)
  self:PlayAnimation(self.In)
  local Avatar = GWorld:GetAvatar()
  self.ChessData, self.ParentWidget = ...
  self.CurChess = nil
  self.CurEquip = nil
  self.MonsterContentMap = {}
  self.Text_Title:SetText(GText("UI_AutoChess_EquipTitle"))
  self.List_Chess:ClearListItems()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    CommonUtils:CloseGuideTouchIfExist(self)
  end
  for key, value in pairs(Model:GetChessData()) do
    if value.Locked ~= true then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      local EquipInfo = Model:GetMonsterEquipInfo(value.Id)
      Content.EquipCount = #EquipInfo
      Content.Id = value.Id
      Content.Parent = self
      Content.Selected = false
      if Content.Id == self.ChessData.Id then
        Content.Selected = true
        if self.IsInDungeon then
          self.List_Chess:AddItem(Content)
          self.MonsterContentMap[Content.Id] = Content
          break
        end
      end
      if not self.IsInDungeon then
        self.List_Chess:AddItem(Content)
        self.MonsterContentMap[Content.Id] = Content
      end
    end
  end
  self:InitNavigation()
  self:UpdateEquipTipsVisibility(false)
  self:FindFirstChess()
  self:InitTab()
  local DefaultRarity = self:GetDefaultTabRarity()
  self:RefreshEquip(DefaultRarity)
  self:RefreshMonsterInfoDetails()
  self:RefreshEquipPreview()
  self.Btn_Equip:SetGamePadImg("A")
  self.Btn_Takeoff:SetGamePadImg("A")
  self.Btn_Lock:SetGamePadImg("A")
  self:InitGamePadKeys()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:InitNavigation()
  self.List_Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Chess:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Chess:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Chess:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  if self.IsInDungeon then
    self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  else
    self.List_Item:SetNavigationRuleExplicit(EUINavigation.Right, self.List_Chess)
  end
  self.List_Chess:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function(_self)
      if self.CurEquip and self.CurEquip.ParentWidget then
        return self.CurEquip.ParentWidget
      else
        return self.List_Item
      end
    end
  })
end

function M:OnClickChess()
  local NextTab = self.SubTab:GetCurrentTabIndex()
  local Result = 6 - NextTab
  self:RefreshEquip(Result)
  self:RefreshMonsterInfoDetails()
  self:RefreshEquipPreview()
end

function M:FindFirstChess()
  for _, Content in pairs(self.List_Chess:GetListItems()) do
    if Content.Id == self.ChessData.Id then
      self.CurChess = Content
      if not self.IsInDungeon then
        self.List_Chess:BP_NavigateToItem(Content)
      end
      self.List_Chess:BP_SetSelectedItem(Content)
      return
    end
  end
end

function M:RefreshEquip(Rarity)
  self:PlayAnimation(self.Change)
  self:UpdateEquipTipsVisibility(false)
  self.List_Item:ClearListItems()
  self.EquipContentMap = {}
  self.CurEquipList = {}
  self.CurEquip = nil
  for _, key in ipairs(DataMgr.AutoChessConstant[AutoChessConst.ActiveId].EventEquipId) do
    local value = DataMgr.RobotEquip[key]
    if value.EquipRarity == Rarity then
      table.insert(self.CurEquipList, value)
    end
  end
  table.sort(self.CurEquipList, function(EquipA, EquipB)
    local StateA = self:GetEquipState(EquipA.EquipId, self.CurChess.Id)
    local StateB = self:GetEquipState(EquipB.EquipId, self.CurChess.Id)
    if StateA ~= StateB then
      return StateA > StateB
    end
    local DeployCostA = EquipA.DeployCost or 0
    local DeployCostB = EquipB.DeployCost or 0
    if EquipA.DeployCost == EquipB.DeployCost then
      return EquipA.EquipId > EquipB.EquipId
    else
      return DeployCostA > DeployCostB
    end
  end)
  for key, value in pairs(self.CurEquipList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = value.EquipId
    Content.ItemType = "RobotEquip"
    Content.Icon = value.EquipIcon
    Content.Rarity = value.EquipRarity
    Content.State = self:GetEquipState(value.EquipId, self.CurChess.Id)
    Content.CurrencyIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost'"
    Content.CurrencyNum = value.DeployCost
    if Content.State == EquipState.Locked then
      Content.LockType = 2
    elseif Content.State == EquipState.Equiping then
      Content.bSelectTag = true
    end
    local New = Model:CheckEquipIsNew(value.EquipId)
    if New and Content.State ~= EquipState.Locked then
      Content.RedDotType = UIConst.RedDotType.NewRedDot
    end
    Content.OnMouseButtonDownEvent = {
      Obj = self,
      Callback = function()
        self:OnClickEquip(Content)
        if self.UsingGamepad and not CommonUtils:IfExistSystemGuideUI(self) then
          local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
          if Content.State == EquipState.UnEquip and 2 ~= #Equips then
            self:AddEquip()
          elseif Content.State == EquipState.Equiping then
            self:RemoveEquip()
          elseif 2 == #Equips then
          else
            UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_UnlockToast"))
          end
        end
        CommonUtils:CloseGuideTouchIfExist(self)
      end
    }
    Content.OnFocusReceivedEvent = {
      Obj = self,
      Callback = function()
        if self.UsingGamepad then
          self:OnClickEquip(Content)
        end
      end
    }
    self.List_Item:AddItem(Content)
    self.EquipContentMap[Content.Id] = Content
    if self.IsInDungeon then
      self.List_Item:NavigateToIndex(0)
    end
  end
  self.List_Item:RequestFillEmptyContent()
  self:RefreshBtn()
end

function M:OnClickEquip(Content)
  local New = Model:CheckEquipIsNew(Content.Id)
  if New then
    Content.SelfWidget:SetRedDot(nil)
    Model:DecreaseEquipReddotById(Content.Id)
  end
  if Content.State == EquipState.Locked then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_UnlockToast"))
    return
  end
  if self.CurEquip then
    self.CurEquip.SelfWidget:SetSelected(false)
  end
  Content.SelfWidget:SetSelected(true, false)
  self.CurEquip = Content
  self:RefreshDetail()
  self:RefreshBtn()
  self:PlayMonsterInfoAnim()
  self:RefreshMonsterInfoPreview(Content)
end

function M:RefreshMonsterInfoPreview(EquipContent, bAnim)
  if nil == bAnim then
    bAnim = true
  end
  local Content = EquipContent
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  local Count = #Equips
  local bPositive = Content.State == EquipState.UnEquip
  if Count < 2 then
    self.WBP_Activity_AutoChess_MonsterInfoDetails:RefreshPreview(Content.Id, bPositive, bAnim)
  elseif false == bPositive then
    self.WBP_Activity_AutoChess_MonsterInfoDetails:RefreshPreview(Content.Id, bPositive, bAnim)
  else
    self:RefreshMonsterInfoDetails()
  end
end

function M:RefreshDetail()
  self:UpdateEquipTipsVisibility(true)
  local Info = DataMgr.RobotEquip[self.CurEquip.Id]
  self.Tips_Equipment:Show(Info)
end

function M:RefreshMonsterInfoDetails()
  if not self.CurChess then
    return
  end
  local ChessData = Model:GetMonsterInfoByCombatId(self.CurChess.Id)
  if not ChessData then
    return
  end
  self.WBP_Activity_AutoChess_MonsterInfoDetails:RefreshDetails(ChessData, self.IsInDungeon)
end

function M:RefreshEquipPreview()
  if not self.CurChess then
    return
  end
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  local Count = #Equips
  self.TextNumNow:SetText(tostring(Count))
  self.TextNumTotal:SetText("/2")
  local EmptyContent = {bAdd = true}
  self.Equipment_01:Init(EmptyContent)
  self.Equipment_02:Init(EmptyContent)
  for Index, EquipId in ipairs(Equips) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData then
      local Content = {}
      Content.Id = EquipId
      Content.Rarity = EquipData.EquipRarity
      Content.ItemType = "RobotEquip"
      Content.Icon = EquipData.EquipIcon
      if 1 == Index then
        self.Equipment_01:Init(Content)
      elseif 2 == Index then
        self.Equipment_02:Init(Content)
      end
    end
  end
end

function M:InitTab()
  local Tabs = {}
  for i = 1, 3 do
    if 1 == i then
      local Tab = {
        Text = GText("UI_AutoChess_EquipRarity3"),
        Idx = 5
      }
      table.insert(Tabs, Tab)
    elseif 2 == i then
      local Tab = {
        Text = GText("UI_AutoChess_EquipRarity2"),
        Idx = 4
      }
      table.insert(Tabs, Tab)
    else
      local Tab = {
        Text = GText("UI_AutoChess_EquipRarity1"),
        Idx = 3
      }
      table.insert(Tabs, Tab)
    end
  end
  local ConfigData = {
    Owner = self,
    ChildWidgetName = "TabSubTextItem",
    Tabs = Tabs
  }
  self.SubTab:Init(ConfigData)
  self.SubTab:BindEventOnTabSelected(self, self.OnTabSelected)
  local DefaultRarity = self:GetDefaultTabRarity()
  local TabIndex = 6 - DefaultRarity
  self.SubTab:SelectTab(TabIndex)
  self.TabNum = #Tabs
end

function M:GetDefaultTabRarity()
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  if #Equips > 0 then
    local MaxRarity = 0
    for _, EquipId in ipairs(Equips) do
      local EquipData = DataMgr.RobotEquip[EquipId]
      if EquipData and MaxRarity < EquipData.EquipRarity then
        MaxRarity = EquipData.EquipRarity
      end
    end
    if MaxRarity > 0 then
      return MaxRarity
    end
  end
  local Avatar = GWorld:GetAvatar()
  local MaxRarity = 0
  for _, EquipId in ipairs(Avatar.AutoChess.UnlockedEquips or {}) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData and MaxRarity < EquipData.EquipRarity then
      MaxRarity = EquipData.EquipRarity
    end
  end
  if MaxRarity > 0 then
    return MaxRarity
  end
  return EquipRarity.Blue
end

function M:OnTabSelected()
  local NextTab = self.SubTab:GetCurrentTabIndex()
  local Res = 6 - NextTab
  self:PlayAnimation(self.MonsterInfoDetails_Out)
  self:RefreshEquip(Res)
end

function M:AddEquip()
  if not self.CurChess or not self.CurChess.Id then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  
  local function cb()
    AudioManager(self):PlayUISound(self, "event:/ui/common/equip_jewelry", nil, nil)
    for _, Content in pairs(self.List_Chess:GetListItems()) do
      if Content.Id == self.CurChess.Id and Content.UI then
        Content.UI:AddEquip(self.CurEquip.Id)
        break
      end
    end
    for _, Content in pairs(self.List_Item:GetListItems()) do
      if Content.Id == self.CurEquip.Id and Content.SelfWidget then
        Content.State = EquipState.Equiping
        Content.SelfWidget:SetItemSelect(true)
        break
      end
    end
    self:RefreshMonsterInfoDetails()
    self:RefreshEquipPreview()
    self:RefreshBtn()
    self:OnChessEquipChanged(self.CurChess.Id, self.CurEquip.Id)
  end
  
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  Avatar:AutoChessAddEquip(cb, self.CurChess.Id, self.CurEquip.Id, nil)
end

function M:RemoveEquip()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  local Index = 0
  for key, value in pairs(Equips) do
    if self.CurEquip.Id == value then
      Index = key
    end
  end
  local OldData = Model:GetMonsterInfoByCombatId(self.CurChess.Id)
  
  local function cb()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_brush_unlock", nil, nil)
    local Equip = Model:GetMonsterEquipInfo(self.CurChess.Id)
    for _, Content in pairs(self.List_Chess:GetListItems()) do
      if Content.Id == self.CurChess.Id and Content.UI then
        Content.UI:RemoveEquip(#Equip, self.CurEquip.Id)
        break
      end
    end
    for _, Content in pairs(self.List_Item:GetListItems()) do
      if Content.Id == self.CurEquip.Id and Content.SelfWidget then
        Content.State = EquipState.UnEquip
        Content.SelfWidget:SetItemSelect(false)
        break
      end
    end
    self:RefreshMonsterInfoDetails()
    self:RefreshEquipPreview()
    self:RefreshBtn()
    self:OnChessEquipChanged(self.CurChess.Id, self.CurEquip.Id)
    self.ChessData.EquipItems = Equip
  end
  
  Avatar:AutoChessRemoveEquip(cb, self.CurChess.Id, Index)
end

function M:OnChessEquipChanged(ChessId, EquipId)
  if self.ChessData.Id == ChessId then
    self.ChessData = Model:GetMonsterInfoByCombatId(ChessId)
  end
  self:RefreshMonsterInfoPreview(self.EquipContentMap[EquipId], false)
end

function M:GetEquipState(EquipId, MonsterId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Res = Avatar.AutoChess:IsEquipUnlocked(EquipId)
  if false == Res then
    return EquipState.Locked
  end
  local Equips = Model:GetMonsterEquipInfo(MonsterId)
  if #Equips > 0 and CommonUtils.HasValue(Equips, EquipId) then
    return EquipState.Equiping
  else
    return EquipState.UnEquip
  end
end

function M:RefreshBtn()
  if not self.CurEquip then
    self.Switch_Button:SetActiveWidgetIndex(0)
    self.Btn_Equip:SetText(GText("UI_AutoChess_Equip"))
    self.Btn_Equip:ForbidBtn(true)
    return
  end
  local State = self:GetEquipState(self.CurEquip.Id, self.CurChess.Id)
  local Equips = Model:GetMonsterEquipInfo(self.CurChess.Id)
  if State == EquipState.Equiping then
    self.Switch_Button:SetActiveWidgetIndex(1)
    self.Btn_Takeoff:SetText(GText("UI_AutoChess_RemoveEquip"))
  elseif 2 == #Equips then
    self.Switch_Button:SetActiveWidgetIndex(2)
    self.Btn_Lock:SetText(GText("UI_AutoChess_FullEquip"))
  elseif State == EquipState.UnEquip then
    self.Switch_Button:SetActiveWidgetIndex(0)
    self.Btn_Equip:SetText(GText("UI_AutoChess_Equip"))
    self.Btn_Equip:ForbidBtn(false)
  end
end

function M:OnClickFull()
end

function M:OnClickReturn()
  AudioManager(self):SetEventSoundParam(self, "Open", {ToEnd = 1})
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      Model:DecreaseEquipReddotById()
      M.Super.Close(self)
    end
  })
  self:PlayAnimation(self.Out)
  local BattlePageUI = UIManager(self):GetUIObj("AutoChessBattlePage")
  if BattlePageUI then
    BattlePageUI:ExitEquipment()
  end
end

function M:OnOpenMonsterTipsClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/sell_panel_expand", nil, nil)
  self.IsOpenMonsterTips = not self.IsOpenMonsterTips
  self:UpdateTipsVisibility(true)
end

function M:UpdateTipsVisibility(bPlayAnimation)
  if self.IsOpenMonsterTips then
    self.WBP_Activity_AutoChess_MonsterInfoDetails:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    if bPlayAnimation then
      self:PlayAnimation(self.MonsterInfoDetails_In)
    end
  elseif bPlayAnimation then
    self:PlayAnimation(self.MonsterInfoDetails_Out)
  else
    self.WBP_Activity_AutoChess_MonsterInfoDetails:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.MonsterInfoDetails_Out then
    self.WBP_Activity_AutoChess_MonsterInfoDetails:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:UpdateEquipTipsVisibility(Visible)
  if Visible then
    self.Tips_Equipment:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.WBP_Com_BtnImg01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Tips_Equipment:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Com_BtnImg01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.IsOpenMonsterTips = false
    self:UpdateTipsVisibility(false)
  end
end

function M:PlayMonsterInfoAnim()
  if self.CurEquip.State == EquipState.Equiping or #self.ChessData.EquipItems >= 2 then
    return
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftTrigger" == InKeyName then
    self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
    self.CurEquip = nil
    if self.List_Item:HasFocusedDescendants() or self.List_Item:HasAnyUserFocus() then
      self.List_Item:NavigateToIndex(0)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_RightTrigger" == InKeyName then
    self.SubTab:Handle_KeyEventOnGamePad(InKeyName)
    self.CurEquip = nil
    if self.List_Item:HasFocusedDescendants() or self.List_Item:HasAnyUserFocus() then
      self.List_Item:NavigateToIndex(0)
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "A" == InKeyName then
    self.SubTab:Handle_KeyEventOnPC(InKeyName)
    self.CurEquip = nil
    self:RefreshBtn()
    self:UpdateEquipTipsVisibility(false)
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "D" == InKeyName then
    self.SubTab:Handle_KeyEventOnPC(InKeyName)
    self.CurEquip = nil
    self:RefreshBtn()
    self:UpdateEquipTipsVisibility(false)
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self.Tips_Equipment:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
      self:OnOpenMonsterTipsClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Escape" == InKeyName then
    self:OnClickReturn()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    self:OnClickReturn()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnGamePadScrollInput(InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.RightAnalogY then
    return false
  end
  if self.IsOpenMonsterTips then
    local ScrollBox = self.WBP_Activity_AutoChess_MonsterInfoDetails.EMScrollBox
    if UIUtils.CheckScrollBoxCanScroll(ScrollBox) then
      UIUtils.ScrollBoxByGamepad(ScrollBox, InAnalogInputEvent)
      return true
    end
  elseif self.Tips_Equipment:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
    local ScrollBox = self.Tips_Equipment.EMScrollBox_1
    if UIUtils.CheckScrollBoxCanScroll(ScrollBox) then
      UIUtils.ScrollBoxByGamepad(ScrollBox, InAnalogInputEvent)
      return true
    end
  end
  return false
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self:OnGamePadScrollInput(InAnalogInputEvent) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return
  end
  if self.IsInDungeon then
    self.List_Item:SetFocus()
  else
    self.List_Chess:SetFocus()
  end
  return UIUtils.Handled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
  else
    self.UsingGamepad = true
    if self.CurEquip and self.CurEquip.ParentWidget then
      return self.CurEquip.ParentWidget:SetFocus()
    elseif self.IsInDungeon then
      self.List_Item:SetFocus()
    else
      self.List_Chess:SetFocus()
    end
  end
  self:UpdateInfoGamePad()
end

function M:OnEndClose()
  if self.ParentWidget and not CommonUtils:IfExistSystemGuideUI(self) then
    self.ParentWidget:SetFocus()
  end
end

function M:InitGamePadKeys()
  self.Tips_Equipment.Key02:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
      }
    },
    Desc = GText("UI_Controller_Slide")
  })
  self.Tips_Equipment.Key01:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
      }
    },
    Desc = GText("UI_CTL_Squad_Expand")
  })
  self.WBP_Activity_AutoChess_MonsterInfoDetails.Key_MonsterInfo_1:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
      }
    },
    Desc = GText("UI_Controller_Slide")
  })
end

function M:UpdateInfoGamePad()
  if UIUtils.IsGamepadInput() then
    self:AddTimer(0.1, function()
      if self.IsOpenMonsterTips then
        if UIUtils.CheckScrollBoxCanScroll(self.WBP_Activity_AutoChess_MonsterInfoDetails.EMScrollBox) then
          self.WBP_Activity_AutoChess_MonsterInfoDetails.Key_MonsterInfo_1:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        else
          self.WBP_Activity_AutoChess_MonsterInfoDetails.Key_MonsterInfo_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        self.Tips_Equipment.Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)
      elseif UIUtils.CheckScrollBoxCanScroll(self.Tips_Equipment.EMScrollBox_1) then
        self.Tips_Equipment.Key02:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      else
        self.Tips_Equipment.Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
      self.Tips_Equipment.Key01:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end)
  else
    self.Tips_Equipment.Key01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tips_Equipment.Key02:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Activity_AutoChess_MonsterInfoDetails.Key_MonsterInfo_1:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

return M

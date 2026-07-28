require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_UIState_C")
local TypeSort = {
  Char = 1,
  Weapon = 2,
  Mod = 3,
  Draft = 4,
  Reward = 5,
  Resource = 6
}

function M:Initialize(Initializer)
  self.Super.Initialize(self)
  self.ItemID = nil
  self.ItemType = nil
  self.ConfigData = nil
  self.OpenKey = "Tab"
  self.IsCanCloseByHotKey = nil
  self.ParentWidget = nil
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.ConfigData, self.ItemType, self.ParentWidget, self.IsCanCloseByHotKey, self.AutoOpenDetectiveGameUI = ...
  self.IsOpenItemMenu = false
  self.IsInRewardFocusMode = false
  self.Cur_RewardFocusIndex = 0
  self:InitRewardListGamepad()
  self:FillWithData()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.PC then
    self.Key_Close:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.Close,
          Owner = self
        }
      },
      bLongPress = false,
      Desc = GText("UI_BACK")
    })
    self.Key_Close:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_Close:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self.Text_Close:SetText(GText("UI_TRAIN_CLOSE"))
  self.Btn_Close.OnClicked:Add(self, self.PlayOutAnim)
  self.ScrollBox_Content:ScrollToStart()
  self:PlayInAnim()
  self:AddTimer(0.1, function()
    self:_SetUpScrollBoxRStickInput(self.ScrollBox_Content)
    self:InitGamepadAfterOpen()
  end)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self.WS:SetActiveWidgetIndex(1)
    self:InitGamepadAfterOpen()
  else
    self.WS:SetActiveWidgetIndex(0)
    self.IsOpenItemMenu = false
    self.IsInRewardFocusMode = false
  end
  self:UpdateStoryKeyTips()
end

function M:FillWithData()
  if self.ItemType == "Read" then
    self.ItemID = self.ConfigData
    local StuffConfigData = DataMgr.Resource[self.ItemID]
    if nil ~= StuffConfigData then
      self.Text_Title:SetText(GText(StuffConfigData.ResourceName))
      self.Text_Content:SetText(GText(StuffConfigData.IpDes))
    end
  elseif self.ItemType == "DetectiveAnswer" then
    local DetectiveMinigameTipsUI = UIManager(self):GetUIObj("DetectiveMinigameTips")
    if DetectiveMinigameTipsUI then
      DetectiveMinigameTipsUI:Close()
    end
    self.AnswerId = self.ConfigData
    local DetectiveAnswerConfigData = DataMgr.DetectiveAnswer[self.AnswerId]
    if nil ~= DetectiveAnswerConfigData then
      self.Text_Title:SetText(GText(DetectiveAnswerConfigData.Name))
      self.Text_Content:SetText(GText(DetectiveAnswerConfigData.Detail))
    end
  else
    self.Text_Title:SetText(GText(self.ConfigData.Name))
    self.Text_Content:SetText(GText(self.ConfigData.Desc))
    self:RefreshRewardGroup()
  end
end

function M:RefreshRewardGroup()
  if not self.Group_Reward then
    return
  end
  local RewardViewId = self.ConfigData and self.ConfigData.RewardViewId
  if not RewardViewId then
    self.Group_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.List_Reward then
      self.List_Reward:ClearListItems()
    end
    return
  end
  self.Group_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Text_Reward then
    self.Text_Reward:SetText(GText("DropTypeText_Fixed"))
  end
  self:RefreshRewardList(RewardViewId)
end

function M:RefreshRewardList(RewardViewId)
  if not self.List_Reward then
    return
  end
  self.List_Reward:ClearListItems()
  local RewardList = RewardUtils:GetRewardViewInfoById(RewardViewId)
  table.sort(RewardList, function(A, B)
    if A.Rarity ~= B.Rarity then
      return A.Rarity > B.Rarity
    end
    if TypeSort[A.Type] and TypeSort[B.Type] and TypeSort[A.Type] ~= TypeSort[B.Type] then
      return TypeSort[A.Type] < TypeSort[B.Type]
    end
    return A.Id < B.Id
  end)
  for _, ItemData in ipairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = true
    Content.UIName = "ItemInformation"
    Content.bIsResetFocus = true
    Content.MenuPlacement = EMenuPlacement.MenuPlacement_MenuLeft
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnRewardItemMenuOpenChanged
    }
    if ItemData.Quantity then
      if #ItemData.Quantity > 1 then
        Content.Count = ItemData.Quantity[1]
        Content.MaxCount = ItemData.Quantity[2]
      else
        Content.Count = ItemData.Quantity[1]
      end
    end
    self.List_Reward:AddItem(Content)
  end
  if self.List_Reward.RequestFillEmptyContent then
    self.List_Reward:RequestFillEmptyContent()
  end
  self:InitRewardListGamepad()
end

function M:IsEmptyRewardItem(Item)
  if not Item or Item.IsEmpty then
    return true
  end
  if Item.StuffType == "EmptyGrid" or "EmptyGrid" == Item.ItemType then
    return true
  end
  return not Item.Id or 0 == Item.Id
end

function M:ResolveRewardFocusIndex(Index)
  if not self.List_Reward then
    return 0
  end
  local ItemCount = self.List_Reward:GetNumItems()
  if ItemCount <= 0 then
    return 0
  end
  local TargetIndex = math.max(0, math.min(Index or self.Cur_RewardFocusIndex or 0, ItemCount - 1))
  if not self:IsEmptyRewardItem(self.List_Reward:GetItemAt(TargetIndex)) then
    return TargetIndex
  end
  for i = 0, ItemCount - 1 do
    if not self:IsEmptyRewardItem(self.List_Reward:GetItemAt(i)) then
      return i
    end
  end
  return TargetIndex
end

function M:HasRewardList()
  if not self.List_Reward or self.List_Reward:GetNumItems() <= 0 then
    return false
  end
  if not self.Group_Reward then
    return false
  end
  local Visibility = self.Group_Reward:GetVisibility()
  return Visibility ~= UIConst.VisibilityOp.Collapsed and Visibility ~= UE4.ESlateVisibility.Collapsed
end

function M:ShouldHandleRewardGamepadInput()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self:HasRewardList()
end

function M:EnterRewardFocusMode()
  if not self:HasRewardList() or self.IsInRewardFocusMode then
    return
  end
  self.IsInRewardFocusMode = true
  self:FocusRewardList(self.Cur_RewardFocusIndex)
  self:UpdateStoryKeyTips()
end

function M:LeaveRewardFocusMode()
  if not self.IsInRewardFocusMode then
    return
  end
  self.IsInRewardFocusMode = false
  if self.List_Reward and self.List_Reward.BP_ClearSelection then
    self.List_Reward:BP_ClearSelection()
  end
  self:RestoreGamepadDefaultFocus()
  self:UpdateStoryKeyTips()
end

function M:RestoreGamepadDefaultFocus()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self.SetFocus then
    self:SetFocus()
  end
end

function M:InitRewardListGamepad()
  if not self.List_Reward then
    return
  end
  if self.List_Reward.BP_OnEntryGenerated and not self.bRewardListGamepadEventsBound then
    self.List_Reward.BP_OnEntryGenerated:Clear()
    self.List_Reward.BP_OnEntryGenerated:Add(self, self.OnRewardEntryGenerated)
    self.List_Reward.BP_OnItemSelectionChanged:Clear()
    self.List_Reward.BP_OnItemSelectionChanged:Add(self, self.OnRewardItemSelectionChanged)
    self.bRewardListGamepadEventsBound = true
  end
  if not self.List_Reward.SetNavigationRuleBase then
    return
  end
  self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
end

function M:OnRewardEntryGenerated(Widget)
  if Widget and Widget.SetNavigationRuleCustom then
    Widget:SetNavigationRuleCustom(UE4.EUINavigation.Up, {
      self,
      self.OnRewardEntryNavigateStop
    })
    Widget:SetNavigationRuleCustom(UE4.EUINavigation.Down, {
      self,
      self.OnRewardEntryNavigateStop
    })
  end
end

function M:OnRewardEntryNavigateStop()
  return self:GetFocusedRewardEntry()
end

function M:OnRewardItemSelectionChanged(Item, bIsSelected)
  if not (bIsSelected and Item and self.List_Reward) or self:IsEmptyRewardItem(Item) then
    return
  end
  local Index = self.List_Reward:GetIndexForItem(Item)
  if nil ~= Index and Index >= 0 then
    self.Cur_RewardFocusIndex = Index
  end
end

function M:OnRewardItemMenuOpenChanged(Obj, bIsOpen)
  self.IsOpenItemMenu = true == bIsOpen
  self:UpdateStoryKeyTips()
  if not self.IsOpenItemMenu and self.IsInRewardFocusMode and self.List_Reward then
    self.List_Reward:SetFocus()
  end
end

function M:FocusRewardList(Index)
  if not self:HasRewardList() then
    return
  end
  local TargetIndex = self:ResolveRewardFocusIndex(Index)
  self.Cur_RewardFocusIndex = TargetIndex
  local Item = self.List_Reward:GetItemAt(TargetIndex)
  if self.List_Reward.SetFocus then
    self.List_Reward:SetFocus()
  end
  if Item and not self:IsEmptyRewardItem(Item) then
    if self.List_Reward.SetSelectedIndex then
      self.List_Reward:SetSelectedIndex(TargetIndex)
    elseif self.List_Reward.BP_SetSelectedItem then
      self.List_Reward:BP_SetSelectedItem(Item)
    end
    if self.List_Reward.BP_NavigateToItem then
      self.List_Reward:BP_NavigateToItem(Item)
    elseif self.List_Reward.NavigateToIndex then
      self.List_Reward:NavigateToIndex(TargetIndex)
    end
  elseif self.List_Reward.NavigateToIndex then
    self.List_Reward:NavigateToIndex(TargetIndex)
  end
end

function M:GetFocusedRewardEntry()
  if not self:HasRewardList() then
    return nil
  end
  return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, self.Cur_RewardFocusIndex or 0)
end

function M:InitGamepadAfterOpen()
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    self:UpdateStoryKeyTips()
    return
  end
  self.WS:SetActiveWidgetIndex(1)
  self.IsInRewardFocusMode = false
  self.IsOpenItemMenu = false
  if self:HasRewardList() and self.List_Reward.BP_ClearSelection then
    self.List_Reward:BP_ClearSelection()
  end
  self:RestoreGamepadDefaultFocus()
  self:UpdateStoryKeyTips()
end

function M:PlayInAnim()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/reading_hud", "ItemInformation", nil)
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  AudioManager(self):SetEventSoundParam(self, "ItemInformation", {ToEnd = 1})
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimationForward(self.Out)
end

function M:UpdateStoryKeyTips()
  if not self.Key_Tips or not self.Key_Tips.UpdateKeyInfo then
    return
  end
  local BottomKeyInfo = {}
  if self:ShouldHandleRewardGamepadInput() then
    if self.IsOpenItemMenu then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "B"}
          },
          Desc = GText("UI_Tips_Close")
        }
      }
    elseif self.IsInRewardFocusMode then
      BottomKeyInfo[#BottomKeyInfo + 1] = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails")
      }
      if UIUtils.CheckScrollBoxCanScroll(self.ScrollBox_Content) then
        BottomKeyInfo[#BottomKeyInfo + 1] = {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_Controller_Slide")
        }
      end
      BottomKeyInfo[#BottomKeyInfo + 1] = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    else
      BottomKeyInfo[#BottomKeyInfo + 1] = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        },
        Desc = GText("UI_Controller_CheckReward")
      }
      if UIUtils.CheckScrollBoxCanScroll(self.ScrollBox_Content) then
        BottomKeyInfo[#BottomKeyInfo + 1] = {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_Controller_Slide")
        }
      end
      BottomKeyInfo[#BottomKeyInfo + 1] = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Controller_Close")
      }
    end
  elseif UIUtils.CheckScrollBoxCanScroll(self.ScrollBox_Content) then
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "RV"}
        },
        Desc = GText("UI_Controller_Slide")
      },
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Controller_Close")
      }
    }
  else
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Controller_Close")
      }
    }
  end
  self.Key_Tips:UpdateKeyInfo(BottomKeyInfo)
end

function M:Close()
  self.Super.Close(self)
  if IsValid(self.ParentWidget) then
    if self.ParentWidget.FocusGamepadSceneList then
      if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
        self.ParentWidget:FocusGamepadSceneList()
      end
    elseif type(self.ParentWidget.SetFocus_Lua) == "function" then
      self.ParentWidget:SetFocus_Lua()
    elseif self.ParentWidget.SetFocus then
      self.ParentWidget:SetFocus()
    end
  end
  if self.ItemType == "DetectiveAnswer" then
    if self.AutoOpenDetectiveGameUI then
      UIManager(self):LoadUINew("DetectiveMinigame", self.AnswerId)
    else
      local DetectiveMinigameUI = UIManager(self):GetUIObj("DetectiveMinigame")
      if not DetectiveMinigameUI then
        UIManager(self):LoadUINew("DetectiveMinigameTips", self.AnswerId)
      end
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self.IsOpenItemMenu then
      if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        return UE4.UWidgetBlueprintLibrary.UnHandled()
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if InKeyName == UIConst.GamePadKey.LeftThumb then
      if not self.IsInRewardFocusMode and self:HasRewardList() then
        self:EnterRewardFocusMode()
        IsEventHandled = true
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      if self.IsInRewardFocusMode then
        self:LeaveRewardFocusMode()
      else
        self:PlayOutAnim()
      end
      IsEventHandled = true
    end
  elseif InKeyName == self.OpenKey and self.IsCanCloseByHotKey or "Escape" == InKeyName then
    self:PlayOutAnim()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if InKeyName == self.OpenKey then
    self.IsCanCloseByHotKey = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY and self.TargetScrollBoxWithRStickInput ~= nil then
    local DeltaOffset = self.bReserveSBoxScrollDir * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    local CurrentOffset = self.TargetScrollBoxWithRStickInput:GetScrollOffset()
    local NextOffset = math.max(0, math.min(self.ScrollOffsetOfEndOfSBox, CurrentOffset + DeltaOffset * self.ScrollSpeedRStickOfSBox))
    self.TargetScrollBoxWithRStickInput:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M

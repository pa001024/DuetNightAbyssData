require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.NameCard.WBP_NameCard_Base_GamepadComp"
}
AssembleComponents(M)

function M:Initialize(Initializer)
  M.Super.Initialize(self)
  self.WidgetMenu = nil
  self.WidgetPersonalInfo = nil
  self.WidgetFriend = nil
  self.CurrentWidget = nil
  self.TabConfig = {}
end

function M:Construct()
  M.Super.Construct(self)
  if self.Anchor then
    local childCount = self.Anchor:GetChildrenCount()
    if childCount > 0 then
      self.Anchor:ClearChildren()
    end
  end
  self.WidgetMenu = self:CreateWidgetNew("NameCard_Menu")
  self.WidgetPersonalInfo = self:CreateWidgetNew("NameCard_PersonalInfo")
  self.WidgetFriend = self:CreateWidgetNew("NameCard_Friend")
  if self.WidgetMenu then
    self.WidgetMenu.ParentWidget = self
  end
  if self.WidgetPersonalInfo then
    self.WidgetPersonalInfo.ParentWidget = self
  end
  if self.WidgetFriend then
    self.WidgetFriend.ParentWidget = self
  end
  if self.WidgetMenu then
    local Slot = self.Anchor:AddChild(self.WidgetMenu)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(UE4.EVerticalAlignment.VAlign_Fill)
  end
  if self.WidgetPersonalInfo then
    local Slot = self.Anchor:AddChild(self.WidgetPersonalInfo)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(UE4.EVerticalAlignment.VAlign_Fill)
  end
  if self.WidgetFriend then
    local Slot = self.Anchor:AddChild(self.WidgetFriend)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(UE4.EVerticalAlignment.VAlign_Fill)
  end
  self:InitTabConfig()
end

function M:InitTabConfig()
  local tabMapping = {
    [1] = {
      WidgetName = "Menu",
      Widget = self.WidgetMenu,
      BgType = CommonConst.PersonalInfoBgType.Esc
    },
    [2] = {
      WidgetName = "PersonalInfo",
      Widget = self.WidgetPersonalInfo,
      BgType = CommonConst.PersonalInfoBgType.PersonalInfo
    },
    [3] = {
      WidgetName = "Friend",
      Widget = self.WidgetFriend,
      BgType = CommonConst.PersonalInfoBgType.Friend
    }
  }
  local tabs = {}
  for tabId, tabConfig in pairs(DataMgr.BackgroundTab or {}) do
    local mapping = tabMapping[tabConfig.TabId]
    if mapping and mapping.Widget then
      local widget = tabMapping[tabConfig.TabId].Widget
      if widget then
        table.insert(tabs, {
          TabId = tabConfig.TabId,
          Text = GText(tabConfig.TabName),
          IconPath = tabConfig.Icon,
          Widget = widget,
          BgType = mapping.BgType
        })
      end
    end
  end
  table.sort(tabs, function(a, b)
    return a.TabId < b.TabId
  end)
  self.TabConfig = {
    TitleName = GText("UI_Background_ChangeCard"),
    LeftKey = "Q",
    RightKey = "E",
    Tabs = tabs,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.OnClickBack,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  }
end

function M:OnLoaded(...)
  self.IsPersonInfoPage, self.ParentWidget = ...
  if self.IsPersonInfoPage then
    self.WS_BG:SetActiveWidgetIndex(1)
  else
    self.WS_BG:SetActiveWidgetIndex(0)
  end
  self.Other_Bg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Com_Tab:Init(self.TabConfig)
  self.Com_Tab:BindEventOnTabSelected(self, self.OnTabSelected)
  if self.WidgetMenu then
    self.WidgetMenu:Init({
      BgType = CommonConst.PersonalInfoBgType.Esc
    })
  end
  if self.WidgetPersonalInfo then
    self.WidgetPersonalInfo:Init({
      BgType = CommonConst.PersonalInfoBgType.PersonalInfo
    })
    self.WidgetPersonalInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.WidgetFriend then
    self.WidgetFriend:Init({
      BgType = CommonConst.PersonalInfoBgType.Friend
    })
    self.WidgetFriend:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.CurrentWidget = self.WidgetMenu
  self.Com_Tab:SelectTab(1)
  self.WidgetMenu.List_NameCard:SetRenderOpacity(0)
  self.WidgetMenu:SetGamepadDefaultFocus(function()
    if self.WidgetMenu == self.CurrentWidget then
      self.WidgetMenu.List_NameCard:RequestPlayEntriesAnim()
    end
  end)
  self.WidgetMenu:PlayAnimation(self.WidgetMenu.In)
  self:InitGamepadComp()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "NameCardIn", nil)
end

function M:OnTabSelected(TabWidget, TabContent)
  if not (TabContent and TabContent.Widget) or TabContent.Widget == self.CurrentWidget then
    return
  end
  self:ShowWidget(TabContent.Widget)
end

function M:ShowWidget(TargetWidget)
  self.CurrentWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if TargetWidget then
    self.CurrentWidget = TargetWidget
    if TargetWidget.RefreshList then
      TargetWidget:RefreshList()
    end
    TargetWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    TargetWidget.List_NameCard:SetRenderOpacity(0)
    TargetWidget:SetGamepadDefaultFocus(function()
      if TargetWidget == self.CurrentWidget then
        TargetWidget.List_NameCard:RequestPlayEntriesAnim()
      end
    end)
    TargetWidget:PlayAnimation(TargetWidget.In)
    AudioManager(TargetWidget):PlayUISound(self, "event:/ui/common/sub_task_panel_show", nil, nil)
  end
end

function M:UpdateTabReddot(BgType, hasReddot)
  if not self.Com_Tab or not self.Com_Tab.EMScrollBox_TabItem then
    return
  end
  local TabIndex
  if BgType == CommonConst.PersonalInfoBgType.Esc then
    TabIndex = 1
  elseif BgType == CommonConst.PersonalInfoBgType.PersonalInfo then
    TabIndex = 2
  elseif BgType == CommonConst.PersonalInfoBgType.Friend then
    TabIndex = 3
  end
  if not TabIndex then
    return
  end
  local TabItem = self.Com_Tab.EMScrollBox_TabItem:GetChildAt(TabIndex - 1)
  if not TabItem then
    return
  end
  if TabItem.New then
    if hasReddot then
      TabItem.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      TabItem.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:OnClickBack()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:PlayOutAnim()
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "NameCardIn", {ToEnd = 1})
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimationForward(self.Out)
end

function M:Close()
  M.Super.Close(self)
  if self.IsPersonInfoPage then
    if self.ParentWidget then
      if self.ParentWidget.SetOriginFocus and type(self.ParentWidget.SetOriginFocus) == "function" then
        self.ParentWidget:SetOriginFocus()
      end
      if self.ParentWidget.ActorController and "function" == type(self.ParentWidget.ActorController.HideAllCharacterActors) then
        self.ParentWidget.ActorController:HideAllCharacterActors("OpenChangeNameCard", false)
      end
    end
  elseif self.ParentWidget and self.ParentWidget.SetFocus_Lua and "function" == type(self.ParentWidget.SetFocus_Lua) then
    self.ParentWidget:SetFocus_Lua()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:HandleGamepadInput(InKeyName)
  end
  M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:OnDestroyed()
  if self.OnDestroyedGamepadComp then
    self:OnDestroyedGamepadComp()
  end
  if self.Com_Tab and self.Com_Tab.OnTabSelected then
    self.Com_Tab.OnTabSelected:Remove(self, self.OnTabSelected)
  end
  if self.Anchor then
    self.Anchor:ClearChildren()
  end
  self.WidgetMenu = nil
  self.WidgetPersonalInfo = nil
  self.WidgetFriend = nil
  self.CurrentWidget = nil
  M.Super.OnDestroyed(self)
end

return M

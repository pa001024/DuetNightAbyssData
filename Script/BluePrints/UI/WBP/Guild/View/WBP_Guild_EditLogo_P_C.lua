require("UnLua")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  AudioManager(self):PlayUISound(self, "event:/ui/common/association_flag_in", nil, nil)
  self:BindToAnimationFinished(self.Tab_Refresh, {
    self,
    function()
      self.IsTabRefreshing = false
      self:BlockAllUIInput(false)
    end
  })
  local GuildLogoInfo = GuildController:GetModel():GetGuildEditLogoInfo()
  self.EditLogoFlagInfo = {
    [1] = {
      GuildLogoInfo.LogoColor,
      GuildLogoInfo.LogoMat,
      GuildLogoInfo.LogoIcon
    },
    [2] = {
      GuildLogoInfo.BgColor,
      GuildLogoInfo.BgMat,
      GuildLogoInfo.BgIcon
    }
  }
  self.BeginLogoFlagInfo = {
    [1] = {
      GuildLogoInfo.LogoColor,
      GuildLogoInfo.LogoMat,
      GuildLogoInfo.LogoIcon
    },
    [2] = {
      GuildLogoInfo.BgColor,
      GuildLogoInfo.BgMat,
      GuildLogoInfo.BgIcon
    }
  }
  self.Logo:Init(self:CurGuildLogoInfo())
  self.Logo:PlayIn()
  self.Btn_Back:SetGamePadImg("B")
  self.Btn_Back:SetText(GText("UI_BACK"))
  self.Btn_Back:BindEventOnClicked(self, self.Close)
  self.Btn_Confirm:SetGamePadImg("Y")
  self.Btn_Confirm:SetText(GText("UI_GuildFlagConfirmEdit"))
  self.Btn_Confirm:BindEventOnClicked(self, self.Confirm)
  self.Btn_Confirm:BindForbidStateExecuteEvent(self, self.NotChangeTips)
  self.Text_Icon:SetText(GText("UI_GuildFlagGraphic"))
  self.Text_Color:SetText(GText("UI_GuildFlagColor"))
  self.Text_Material:SetText(GText("UI_GuildFlagMaterial"))
  self:InitTabInfo()
  self.List_Icon:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Icon:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Icon:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Color:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Color:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Material:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Material:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Material:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self:SetFocus()
  self.Panel_Material:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  local ConfirmCallbackInfo = (...)
  self.ConfirmCallbackInfo = ConfirmCallbackInfo
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self.SelectDefault = true
  self.Tab_Switch:SelectTab(1)
  self:CheckConfirmState(true)
  self:PlayAnimation(self.In)
end

function M:InitTabInfo()
  local TabConfigData = {
    TitleName = GText("UI_EditGuildBanner"),
    LeftKey = "Q",
    RightKey = "E",
    StyleName = "TextImage",
    DynamicNode = {"Back", "BottomKey"},
    BackCallback = self.Close,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnPressESC,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnPressESC,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = self
  }
  self.Tab:Init(TabConfigData)
  self.Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
  local Tabs = {}
  local Tab1 = {
    Text = GText("UI_BannerPattern"),
    Idx = 1
  }
  table.insert(Tabs, Tab1)
  local Tab2 = {
    Text = GText("UI_BannerBackground"),
    Idx = 2
  }
  table.insert(Tabs, Tab2)
  local SubTabConfigData = {
    Owner = self,
    Tabs = Tabs,
    LeftKey = "A",
    RightKey = "D",
    LeftGamePadKey = "LeftShoulder",
    RightGamePadKey = "RightShoulder"
  }
  self.Tab_Switch:Init(SubTabConfigData)
  self.Tab_Switch:BindEventOnTabSelected(self, self.OnTabSelected)
end

function M:OnTabSelected()
  self.ResetFocus = true
  if self.SelectDefault then
    self.SelectDefault = false
  else
    self.IsTabRefreshing = true
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:PlayAnimation(self.Tab_Refresh)
  end
  local NextTab = self.Tab_Switch:GetCurrentTabIndex()
  self.CurTabIndex = NextTab
  if 1 == NextTab then
    self:ShowIcon(DataMgr.GuildLogo)
    self:ShowColor(DataMgr.GuildColor)
  else
    self:ShowIcon(DataMgr.GuildFlag)
    self:ShowColor(DataMgr.GuildFlagColor)
  end
end

function M:RefreshEquip(NextTab)
end

function M:ShowIcon(DataList)
  self.List_Icon:ClearListItems()
  local SortDataList = {}
  for _, Data in pairs(DataList) do
    table.insert(SortDataList, Data)
  end
  table.sort(SortDataList, function(a, b)
    local A_Id, B_Id
    if 1 == self.CurTabIndex then
      A_Id = a.LogoID
      B_Id = b.LogoID
    else
      A_Id = a.FlagID
      B_Id = b.FlagID
    end
    return A_Id < B_Id
  end)
  for Index = 1, #SortDataList do
    local Data = SortDataList[Index]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.Parent = self
    Content.CurTabIndex = self.CurTabIndex
    Content.EditCallbackInfo = {
      Obj = self,
      Func = self.OnEdit
    }
    if 1 == self.CurTabIndex then
      Content.LogoID = Data.LogoID
      Content.Icon = Data.Icon
      if Content.LogoID == self.EditLogoFlagInfo[1][3] then
        Content.bSelected = true
        self.CurrentIconSelectedContent = Content
      else
        Content.bSelected = false
      end
    else
      Content.FlagID = Data.FlagID
      Content.FlagIcon = Data.FlagIcon
      if Content.FlagID == self.EditLogoFlagInfo[2][3] then
        Content.bSelected = true
        self.CurrentIconSelectedContent = Content
      else
        Content.bSelected = false
      end
    end
    self.List_Icon:AddItem(Content)
  end
  self.List_Icon.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    Obj.Parent = self
    return Obj
  end)
  self.List_Icon:RequestFillEmptyContent()
  if self.ResetFocus then
    self:SetListFocus(self.List_Icon, self.CurrentIconSelectedContent.Index, false)
  end
end

function M:OnIconSelected(Content)
  local PreSelectedContent = self.CurrentIconSelectedContent
  self.CurrentIconSelectedContent = Content
  if PreSelectedContent and PreSelectedContent ~= Content then
    PreSelectedContent.bSelected = false
    if PreSelectedContent.CurrentEntry then
      PreSelectedContent.CurrentEntry:SetSelected(false)
    end
  end
end

function M:ShowColor(DataList)
  self.List_Color:ClearListItems()
  local SortDataList = {}
  for _, Data in pairs(DataList) do
    table.insert(SortDataList, Data)
  end
  table.sort(SortDataList, function(a, b)
    local A_Id, B_Id
    if 1 == self.CurTabIndex then
      A_Id = a.ColorID
      B_Id = b.ColorID
    else
      A_Id = a.FlagColorID
      B_Id = b.FlagColorID
    end
    return A_Id < B_Id
  end)
  for Index = 1, #SortDataList do
    local Data = SortDataList[Index]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.Parent = self
    Content.CurTabIndex = self.CurTabIndex
    Content.EditCallbackInfo = {
      Obj = self,
      Func = self.OnEdit
    }
    if 1 == self.CurTabIndex then
      Content.ColorID = Data.ColorID
      Content.ColorIcon = Data.ColorIcon
      if Content.ColorID == self.EditLogoFlagInfo[1][1] then
        Content.bSelected = true
        self.CurrentColorSelectedContent = Content
      else
        Content.bSelected = false
      end
    else
      Content.FlagColorID = Data.FlagColorID
      Content.FlagColorIcon = Data.FlagColorIcon
      if Content.FlagColorID == self.EditLogoFlagInfo[2][1] then
        Content.bSelected = true
        self.CurrentColorSelectedContent = Content
      else
        Content.bSelected = false
      end
    end
    self.List_Color:AddItem(Content)
  end
  self.List_Color.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    Obj.Parent = self
    return Obj
  end)
  self.List_Color:RequestFillEmptyContent()
  if self.ResetFocus then
    self.ResetFocus = false
    self:SetListFocus(self.List_Color, self.CurrentColorSelectedContent.Index, true)
  end
end

function M:OnColorSelected(Content)
  local PreSelectedContent = self.CurrentColorSelectedContent
  self.CurrentColorSelectedContent = Content
  if PreSelectedContent and PreSelectedContent ~= Content then
    PreSelectedContent.bSelected = false
    if PreSelectedContent.CurrentEntry then
      PreSelectedContent.CurrentEntry:SetSelected(false)
    end
  end
end

function M:ShowMaterial(DataList)
  self.List_Material:ClearListItems()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Index = 1
  Content.Parent = self
  Content.CurTabIndex = self.CurTabIndex
  Content.IsDefault = true
  Content.EditCallbackInfo = {
    Obj = self,
    Func = self.OnEdit
  }
  if 1 == self.CurTabIndex then
    Content.MaterialID = 0
    if Content.MaterialID == self.EditLogoFlagInfo[1][2] then
      Content.bSelected = true
      self.CurrentMaterialSelectedContent = Content
    else
      Content.bSelected = false
    end
  else
    Content.FlagMaterialID = 0
    if Content.FlagMaterialID == self.EditLogoFlagInfo[2][2] then
      Content.bSelected = true
      self.CurrentMaterialSelectedContent = Content
    else
      Content.bSelected = false
    end
  end
  self.List_Material:AddItem(Content)
  local SortDataList = {}
  for _, Data in pairs(DataList) do
    table.insert(SortDataList, Data)
  end
  table.sort(SortDataList, function(a, b)
    local A_Id, B_Id
    if 1 == self.CurTabIndex then
      A_Id = a.MaterialID
      B_Id = b.MaterialID
    else
      A_Id = a.FlagMaterialID
      B_Id = b.FlagMaterialID
    end
    return A_Id < B_Id
  end)
  for Index = 1, #SortDataList do
    local Data = SortDataList[Index]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index + 1
    Content.Parent = self
    Content.CurTabIndex = self.CurTabIndex
    Content.EditCallbackInfo = {
      Obj = self,
      Func = self.OnEdit
    }
    if 1 == self.CurTabIndex then
      Content.MaterialID = Data.MaterialID
      Content.MaterialIcon = Data.MaterialIcon
      if Content.MaterialID == self.EditLogoFlagInfo[1][2] then
        Content.bSelected = true
        self.CurrentMaterialSelectedContent = Content
      else
        Content.bSelected = false
      end
    else
      Content.FlagMaterialID = Data.FlagMaterialID
      Content.MaterialIcon = Data.MaterialIcon
      if Content.FlagMaterialID == self.EditLogoFlagInfo[2][2] then
        Content.bSelected = true
        self.CurrentMaterialSelectedContent = Content
      else
        Content.bSelected = false
      end
    end
    self.List_Material:AddItem(Content)
  end
  self.List_Material.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    Obj.Parent = self
    return Obj
  end)
  self.List_Material:RequestFillEmptyContent()
  if self.ResetFocus then
    self:SetListFocus(self.List_Material, self.CurrentMaterialSelectedContent.Index, false)
  end
end

function M:OnMaterialSelected(Content)
  local PreSelectedContent = self.CurrentMaterialSelectedContent
  self.CurrentMaterialSelectedContent = Content
  if PreSelectedContent and PreSelectedContent ~= Content then
    PreSelectedContent.bSelected = false
    if PreSelectedContent.CurrentEntry then
      PreSelectedContent.CurrentEntry:SetSelected(false)
    end
  end
end

function M:OnEdit(Pos, Value)
  local EditLogoFlagInfo = self.EditLogoFlagInfo
  if EditLogoFlagInfo[self.CurTabIndex][Pos] == Value then
    return
  end
  EditLogoFlagInfo[self.CurTabIndex][Pos] = Value
  self:CheckConfirmState(true)
  self.Logo:Init(self:CurGuildLogoInfo())
end

function M:CheckConfirmState(IsPlayAnim)
  local Info1 = self.EditLogoFlagInfo[1]
  local Info2 = self.EditLogoFlagInfo[2]
  local BeginInfo1 = self.BeginLogoFlagInfo[1]
  local BeginInfo2 = self.BeginLogoFlagInfo[2]
  local Change = true
  if Info1[1] == BeginInfo1[1] and Info1[2] == BeginInfo1[2] and Info1[3] == BeginInfo1[3] and Info2[1] == BeginInfo2[1] and Info2[2] == BeginInfo2[2] and Info2[3] == BeginInfo2[3] then
    Change = false
  end
  if IsPlayAnim then
    if Change then
      self.Btn_Confirm:ForbidBtn(false)
    else
      self.Btn_Confirm:ForbidBtn(true)
    end
  end
  return Change
end

function M:CurGuildLogoInfo()
  local EditLogoFlagInfo = self.EditLogoFlagInfo
  local CurGuildLogoInfo = GuildLogoInfo.BuildGuildLogoInfo(EditLogoFlagInfo[1][1], EditLogoFlagInfo[1][2], EditLogoFlagInfo[1][3], EditLogoFlagInfo[2][1], EditLogoFlagInfo[2][2], EditLogoFlagInfo[2][3])
  return CurGuildLogoInfo
end

function M:Confirm()
  if not self:CheckConfirmState() then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoChangesMade"))
    return
  end
  GuildController:GetModel():SetGuildEditLogoInfo(self:CurGuildLogoInfo())
  if self.ConfirmCallbackInfo then
    self.ConfirmCallbackInfo.Func(self.ConfirmCallbackInfo.Obj)
  end
  self:Close()
end

function M:NotChangeTips()
  if not self:CheckConfirmState() then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_NoChangesMade"))
  end
end

function M:Close()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  local Anim = self.Out
  self:BindToAnimationFinished(Anim, {
    self,
    function()
      M.Super.Close(self)
      self:BlockAllUIInput(false)
    end
  })
  self:PlayAnimation(Anim)
end

function M:OnPressESC()
  self:Close()
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if not UIUtils.IsGamepadInput() or InKeyName == UIConst.GamePadKey.FaceButtonLeft then
  else
  end
  return IsHandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self:OnPressESC()
      IsHandled = true
    elseif InKeyName == UIConst.GamePadKey.LeftShoulder then
      self.Tab_Switch:TabToLeft()
      IsHandled = true
    elseif InKeyName == UIConst.GamePadKey.RightShoulder then
      self.Tab_Switch:TabToRight()
      IsHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
      if self.Btn_Confirm:IsBtnForbidden() then
        self:NotChangeTips()
      else
        self:Confirm()
      end
      IsHandled = true
    elseif InKeyName == UIConst.GamePadKey.DPadDown then
      if self.List_Color:HasAnyUserFocus() then
        local a = 1
      end
      local a = 1
    elseif InKeyName == UIConst.GamePadKey.DPadUp then
      local a = 1
    end
  elseif "Escape" == InKeyName then
    self:OnPressESC()
    IsHandled = true
  elseif "A" == InKeyName then
    self.Tab_Switch:TabToLeft(1)
    self.Tab_Switch:PlayClickSound()
    IsHandled = true
  elseif "D" == InKeyName then
    self.Tab_Switch:TabToRight(2)
    self.Tab_Switch:PlayClickSound()
    IsHandled = true
  end
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:OnFocusReceived()
  if self.CurrentIconSelectedContent then
    self:SetListFocus(self.List_Color, self.CurrentIconSelectedContent.Index, true)
  end
  return UIUtils.UnHandled
end

function M:SetListFocus(List, Index, IsFocus)
  local Item = List:GetItemAt(Index - 1)
  if Item then
    List:NavigateToIndex(Index - 1)
    if Item.SelfWidget then
      if IsFocus then
        self:AddTimer(0.02, function()
          Item.SelfWidget:SetFocus()
        end)
      else
        Item.SelfWidget:SetFocus()
      end
    end
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == UE4.ECommonInputType.Gamepad then
    self:SetFocus()
  else
  end
end

return M

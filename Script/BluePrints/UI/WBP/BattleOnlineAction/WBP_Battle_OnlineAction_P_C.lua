require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.BattleOnlineAction.WBP_Battle_OnlineActionBaseView"
}
local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")
local RefreshKey = OnlineActionCommon.RefreshAllKey
local RefuseKey = OnlineActionCommon.RejectAllKey

function M:InitKeyInfos()
  self.RefreshKeyInfo = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = RefreshKey,
        ClickCallback = function()
          self:OnRefreshAllKeyDown()
        end
      }
    },
    Desc = GText("UI_RegionOnline_Refresh")
  }
  self.GamePadRefreshKeyInfo = {
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "LS",
        ClickCallback = function()
          self:OnRefreshAllKeyDown()
        end
      }
    },
    Desc = GText("UI_RegionOnline_Refresh")
  }
  self.RefuseKeyInfo = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = RefuseKey,
        ClickCallback = function()
          self:OnRejectAllKeyDown()
        end
      },
      GamepadKey = "FaceButtonRight"
    },
    Desc = GText("UI_RegionOnline_RefruseAll")
  }
  self.GamePadRefuseKeyInfo = {
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "RS",
        ClickCallback = function()
          self:OnRejectAllKeyDown()
        end
      }
    },
    Desc = GText("UI_RegionOnline_RefruseAll")
  }
  self.CloseKeyInfo = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Esc",
        ClickCallback = function()
          self:OnReturnKeyDown()
        end
      }
    },
    Desc = GText("UI_BACK")
  }
  self.GamePadCloseKeyInfo = {
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        ClickCallback = function()
          self:OnReturnKeyDown()
        end
      }
    },
    Desc = GText("UI_BACK")
  }
end

function M:Construct()
  self.M = M
  self:InitKeyInfos()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:StaticInit()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  DebugPrint("BattleOnlineAction_P_C Received OnKeyDown" .. InKeyName)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self.Tab_OnlineAction:Handle_KeyEventOnGamePad(InKeyName)
    IsEventHandled = IsEventHandled or self:OnGamePadDown(InKeyName)
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    self.IsGamePad = false
    if "Escape" == InKeyName then
      self:OnReturnKeyDown()
    elseif "Q" == InKeyName then
      self:OnLeftTabKeyDown()
    elseif "E" == InKeyName then
      self:OnRightTabKeyDown()
    elseif InKeyName == OnlineActionCommon.RefreshAllKey then
      if self.IsInRefreshCD then
      else
        self:OnRefreshAllKeyDown()
        self.IsInRefreshCD = true
        self:AddTimer(OnlineActionCommon.RefreshAllCD or 1, function()
          self.IsInRefreshCD = false
        end)
      end
    elseif InKeyName == OnlineActionCommon.RejectAllKey and 2 ~= self.Tab_OnlineAction.CurrentTab then
      self:OnRejectAllKeyDown()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnGamePadDown(InKeyName)
  if not self.GamePadInputMap then
    self.GamePadInputMap = {
      [UIConst.GamePadKey.FaceButtonRight] = self.OnGamePadReturnKeyDown,
      [UIConst.GamePadKey.LeftThumb] = self.OnRefreshAllKeyDown,
      [UIConst.GamePadKey.RightThumb] = self.OnRejectAllKeyDown,
      [UIConst.GamePadKey.LeftShoulder] = self.OnLeftTabKeyDown,
      [UIConst.GamePadKey.RightShoulder] = self.OnRightTabKeyDown
    }
  end
  if self.GamePadInputMap[InKeyName] then
    self.GamePadInputMap[InKeyName](self)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
end

function M:OnGamePadReturnKeyDown()
  local FocusItem = self.List_Invite:BP_GetSelectedItem()
  if FocusItem and 1 ~= FocusItem.UI.WS_Btn:GetActiveWidgetIndex() then
    FocusItem.UI:HidePositionUI()
    FocusItem.UI.Option_1.Btn_Area:SetFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  self:OnReturnKeyDown()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  DebugPrint("BattleOnlineAction_P_C OnUpdateUIStyleByInputTypeChange CurInputType:" .. CurInputType)
  if CurInputType == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardUI()
  elseif CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadUI()
  end
end

function M:InitKeyboardUI()
  if not self.RefreshKeyInfo then
    self:InitKeyInfos()
  end
  self.Key_Refresh:CreateCommonKey(self.RefreshKeyInfo)
  self.Key_Refuse:CreateCommonKey(self.RefuseKeyInfo)
  self.Key_Close:CreateCommonKey(self.CloseKeyInfo)
  self.IsGamePad = false
end

function M:InitGamepadUI()
  if not self.GamePadRefreshKeyInfo then
    self:InitKeyInfos()
  end
  self.IsGamePad = true
  self.Key_Refresh:CreateCommonKey(self.GamePadRefreshKeyInfo)
  self.Key_Refuse:CreateCommonKey(self.GamePadRefuseKeyInfo)
  self.Key_Close:CreateCommonKey(self.GamePadCloseKeyInfo)
  if self:HasAnyFocus() and self:IsListHaveItem() then
    self.List_Invite:BP_ClearSelection()
    self:FocusFirstItem()
    return
  end
end

function M:SwitchEmptyBG()
  self:SetFocus()
end

function M:FocusNextItem(NowItem)
  local Index = self.List_Invite:GetIndexForItem(NowItem)
  local ItemNum = self.List_Invite:GetNumItems()
  if ItemNum > Index + 1 then
    Index = Index + 1
    DebugPrint("联机动作Focus FocusNextItem:Next Item Index:" .. Index)
  elseif Index - 1 >= 0 then
    Index = Index - 1
    DebugPrint("联机动作Focus FocusNextItem:Pre Item Index:" .. Index)
  else
    self:SwitchEmptyBG(self.TabKind)
    self:SetFocus()
    DebugPrint("联机动作Focus FocusNextItem:No Item")
    return
  end
  local NewItem = self.List_Invite:GetItemAt(Index)
  self.List_Invite:BP_NavigateToItem(NewItem)
end

AssembleComponents(M)
return M

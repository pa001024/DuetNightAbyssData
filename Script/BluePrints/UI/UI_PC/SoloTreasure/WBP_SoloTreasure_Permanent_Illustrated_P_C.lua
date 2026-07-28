require("UnLua")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local M = Class({
  "BluePrints.UI.UI_PC.SoloTreasure.WBP_SoloTreasure_Permanent_Illustrated_Base"
})
local SCROLLBOX_GAMEPAD_SCROLL_SPEED = 10
local LIST_GAMEPAD_DEAD_ZONE = 0.2

function M:Initialize(Initializer)
  M.Super.Initialize(self, Initializer)
  self.bIsFocusable = true
end

function M:InitTabInfo()
  self.AllTabInfo = {}
  table.insert(self.AllTabInfo, {
    Text = GText("UI_ALL"),
    TabId = SoloTreasurePermanentDataModel.ALL_TAB_ID
  })
  for Id, ExtractionTreasureType in pairs(DataMgr.ExtractionTreasureType) do
    table.insert(self.AllTabInfo, {
      Text = GText(ExtractionTreasureType.Name),
      IconPath = ExtractionTreasureType.Icon,
      TabId = Id
    })
  end
  local BottomKeyInfo = {
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "RH"}
      },
      Desc = GText("UI_Controller_Slide")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.Tab:Init({
    LeftKey = "Q",
    RightKey = "E",
    Tabs = self.AllTabInfo,
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    BottomKeyInfo = BottomKeyInfo,
    StyleName = "Text",
    OwnerPanel = self,
    LastFocusWidget = self.Tab,
    TitleName = GText("UI_Play_TreasureHunt_TreasureArchive"),
    BackCallback = self.OnReturnKeyDown
  })
  self.Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
  self.Tab:SelectTabById(SoloTreasurePermanentDataModel.ALL_TAB_ID)
  self:InitListGamePadScroll()
  self:RestorePanelFocus(true)
end

function M:GetGameInputModeSubsystem()
  if not IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  return self.GameInputModeSubsystem
end

function M:InitListGamePadScroll()
  local ScrollBox = self:GetTreasureScrollBox()
  if nil == ScrollBox then
    return
  end
  if ScrollBox.SetControlScrollbarInside then
    ScrollBox:SetControlScrollbarInside(true)
  end
  self:RefreshListScrollBarByInputType()
  self:RefreshGamePadNavigateWidgetOpacity()
end

function M:RefreshGamePadNavigateWidgetOpacity(CurInputType)
  local GameInputModeSubsystem = self:GetGameInputModeSubsystem()
  if not IsValid(GameInputModeSubsystem) then
    return
  end
  CurInputType = CurInputType or GameInputModeSubsystem:GetCurrentInputType() or self:GetDefaultInputType()
  GameInputModeSubsystem:SetNavigateWidgetOpacity(CurInputType == ECommonInputType.Gamepad and 0 or 1)
end

function M:RefreshListScrollBarByInputType(CurInputType)
  local ScrollBox = self:GetTreasureScrollBox()
  if nil == ScrollBox or nil == ScrollBox.SetAlwaysShowScrollbar then
    return
  end
  CurInputType = CurInputType or IsValid(self:GetGameInputModeSubsystem()) and self.GameInputModeSubsystem:GetCurrentInputType() or self:GetDefaultInputType()
  local MaxScrollOffset = ScrollBox.GetScrollOffsetOfEnd and ScrollBox:GetScrollOffsetOfEnd() or 0
  ScrollBox:SetAlwaysShowScrollbar(CurInputType == ECommonInputType.Gamepad and MaxScrollOffset > 0)
end

function M:OnTabItemSelected(TabWidget, TabData)
  M.Super.OnTabItemSelected(self, TabWidget, TabData)
  self:AddTimer(0.05, function()
    self:RefreshListScrollBarByInputType()
  end, false, 0, "IllustratedRefreshScrollBar", true)
end

function M:BP_GetDesiredFocusTarget()
  return self
end

function M:RestorePanelFocus(bDelay)
  local function DoRestore()
    if not IsValid(self) then
      return
    end
    self.bIsFocusable = true
    local FocusWidget = self:BP_GetDesiredFocusTarget() or self
    if IsValid(FocusWidget) and FocusWidget.SetFocus then
      FocusWidget:SetFocus()
    end
    local GameInputModeSubsystem = self:GetGameInputModeSubsystem()
    if IsValid(GameInputModeSubsystem) and GameInputModeSubsystem.SetTargetUIFocusWidget then
      GameInputModeSubsystem:SetTargetUIFocusWidget(FocusWidget)
    end
  end
  
  if bDelay then
    self:AddTimer(0.05, DoRestore, false, 0, "IllustratedRestorePanelFocus", true)
  else
    DoRestore()
  end
end

function M:SetFocus_Lua()
  self:RestorePanelFocus(false)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:RefreshRewardControllerByInputType(CurInputType)
  self:RefreshListScrollBarByInputType(CurInputType)
  self:RefreshGamePadNavigateWidgetOpacity(CurInputType)
  if self:HasAnyFocus() then
    self:RestorePanelFocus(true)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:RefreshGamePadNavigateWidgetOpacity()
  local Result = M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
  self:RestorePanelFocus(true)
  return Result
end

function M:OnRewardPopupClosed()
  M.Super.OnRewardPopupClosed(self)
  self.bRestoreFocusToRewardBtn = false
  self:RestorePanelFocus(true)
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  self:RestorePanelFocus(true)
end

function M:Destruct()
  self:RemoveTimer("IllustratedRestorePanelFocus")
  local GameInputModeSubsystem = self:GetGameInputModeSubsystem()
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
  M.Super.Destruct(self)
end

function M:GetDefaultInputType()
  return ECommonInputType.MouseAndKeyboard
end

function M:RefreshRewardControllerByInputType(CurInputType)
  if not self.Btn_Reward then
    return
  end
  CurInputType = CurInputType or IsValid(self:GetGameInputModeSubsystem()) and self.GameInputModeSubsystem:GetCurrentInputType() or self:GetDefaultInputType()
  if CurInputType == ECommonInputType.Gamepad then
    self.Btn_Reward:SetControllerVisible(true)
  else
    self.Btn_Reward:SetControllerVisible(false)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local ScrollBox = self:GetTreasureScrollBox()
  if nil == ScrollBox or not UIUtils.CheckScrollBoxCanScroll(ScrollBox) then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.RightAnalogX then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local AnalogValue = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  if math.abs(AnalogValue) < LIST_GAMEPAD_DEAD_ZONE then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local MaxScrollOffset = ScrollBox:GetScrollOffsetOfEnd()
  local AddOffset = AnalogValue * SCROLLBOX_GAMEPAD_SCROLL_SPEED
  local CurScrollOffset = ScrollBox:GetScrollOffset()
  local ScrollOffset = math.clamp(CurScrollOffset + AddOffset, 0, MaxScrollOffset)
  ScrollBox:SetScrollOffset(ScrollOffset)
  self:NotifyTreasureScrollChanged()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self.Tab:Handle_KeyEventOnGamePad(InKeyName) or self.Btn_Reward:Handle_KeyEventOnGamePad_KeyDown(InKeyName)
  else
    IsEventHandled = self.Tab:Handle_KeyEventOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M

require("UnLua")
local SidePopState = {
  Main = 1,
  Item = 2,
  Head = 3
}
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self:RegisterEvent()
  self.Com_BtnClose.Btn_Close.OnClicked:Add(self, self.CloseSelf)
  self.Btn_RefuseAll.Button_Area.OnClicked:Add(self, self.RefuseAll)
  self.IMG_Click.OnMouseButtonDownEvent:Bind(self, self.On_IMG_Click_MouseButtonDown)
  EventManager:AddEvent(EventID.LoadUI, self, self.LoadOtherUI)
  self.Text_Title:SetText(GText("UI_TeamjoinRequest"))
  self.Text_Empty:SetText(GText("UI_NoGuildApply"))
  self.Btn_RefuseAll.Text_Button:SetText(GText("UI_TeamRejectAllRequests"))
  self.Btn_RefuseAll.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  self.List_Apply:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Apply:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Apply:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Apply:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.State = SidePopState.Main
  self.IsEmpty = true
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/preset_team_panel_expand", "preset_team_panel_expand", nil)
  self:Init()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.IsGamepadInput = self.CurInputDeviceType == ECommonInputType.Gamepad
  self.State = SidePopState.Main
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if self.IsGamepadInput then
    if not self.IsEmpty then
      self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if self.SelectApply ~= nil then
      local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
      if TargetWidget then
        TargetWidget:SetFocus(true)
      end
    else
      self:SetFocus(true)
    end
  end
  self:RefeshBottonKey()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self:RefuseAll()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self:HandleItem(false)
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == UIConst.GamePadKey.LeftThumb then
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
    if TargetWidget then
      TargetWidget:SelectItem()
      self.State = SidePopState.Item
    end
    self:RefeshBottonKey()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnGamePadFaceButtonRight()
    self:RefeshBottonKey()
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:HandleItem(IsAgree)
  if self.State ~= SidePopState.Main then
    return
  end
  local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
  if TargetWidget then
    TargetWidget:HandleItem(IsAgree)
  end
end

function M:RefeshBottonKey()
  if self.IsGamepadInput and not self.IsEmpty then
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.State == SidePopState.Main then
    self.Com_KeyTips:UpdateKeyInfo({
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        },
        Desc = GText("UI_TeamRoleCard")
      },
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    })
  elseif self.State == SidePopState.Item then
    self.Com_KeyTips:UpdateKeyInfo({
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_Tips_Close")
      }
    })
  elseif self.State == SidePopState.Head then
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
end

function M:OnGamePadFaceButtonBottom(IsOpen)
  if IsOpen then
    self.State = SidePopState.Head
  else
    self.State = SidePopState.Item
  end
  self:RefeshBottonKey()
end

function M:OnGamePadFaceButtonRight()
  if self.State == SidePopState.Main then
    self:CloseSelf()
  elseif self.State == SidePopState.Item then
    self.State = SidePopState.Main
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
    if TargetWidget then
      TargetWidget:SetFocus(true)
    end
  elseif self.State == SidePopState.Head then
    self.State = SidePopState.Main
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
    if TargetWidget then
      TargetWidget:SelectItem()
    end
  end
end

function M:Init()
  self.SelectApply = nil
  self.ApplyList = {}
  self.ApplyWidget = {}
  self.List_Apply:ClearListItems()
  local CurTeamRequestList = TeamHallController:GetTeamRequestList()
  self.IsEmpty = true
  for _, TeamRequestInfo in pairs(CurTeamRequestList) do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.Uid = TeamRequestInfo.Uid
    Obj.HeadIconId = TeamRequestInfo.HeadIconId
    Obj.HeadFrameId = TeamRequestInfo.HeadFrameId
    Obj.Level = TeamRequestInfo.Level
    Obj.Nickname = TeamRequestInfo.Nickname
    Obj.ParentWidget = self
    self.List_Apply:AddItem(Obj)
    table.insert(self.ApplyList, TeamRequestInfo.Uid)
    self.ApplyWidget[TeamRequestInfo.Uid] = Obj
    self.IsEmpty = false
  end
  if not self.IsEmpty then
    self.WS_List:SetActiveWidgetIndex(0)
    self.Btn_RefuseAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.WS_List:SetActiveWidgetIndex(1)
    self.Btn_RefuseAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if next(self.ApplyList) then
    self.SelectApply = self.ApplyList[1]
  end
  self:AddTimer(0.1, self.DelaySelectItem, false, 0.1, self.TimeHandleName, true)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.SelectApply ~= nil then
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
    if TargetWidget then
      TargetWidget:SetFocus(true)
    end
  else
    self:SetFocus(true)
  end
  self:RefeshBottonKey()
  return UIUtils.Handled
end

function M:LoadOtherUI(OtherUI)
  if "PersonInfoPageMain" == OtherUI then
    self:CloseSelf()
  end
end

function M:DelaySelectItem()
  if self.SelectApply ~= nil then
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(self.ApplyWidget[self.SelectApply]))
    if TargetWidget then
      TargetWidget:SetFocus(true)
    end
  else
    self:SetFocus(true)
  end
  self:RemoveTimer(self.TimeHandleName)
end

function M:RegisterEvent()
  TeamHallController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == TeamHallCommon.EventId.TeamRequestListChanged then
      self:Init()
    end
  end)
end

function M:RefuseAll()
  local Avatar = GWorld:GetAvatar()
  for _, ApplyWidget in pairs(self.ApplyWidget) do
    local TargetWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Apply, self.List_Apply:GetIndexForItem(ApplyWidget))
    if TargetWidget then
      TargetWidget:SendTeamRefuseInvite()
    end
  end
end

function M:On_IMG_Click_MouseButtonDown(MyGeometry, MouseEvent)
  self:CloseSelf()
end

function M:CloseSelf()
  TeamHallController:OnTeamRequestPanelClosed()
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:Close()
      AudioManager(self):SetEventSoundParam(self, "preset_team_panel_expand", {ToEnd = 1})
    end
  })
  self:PlayAnimation(self.Out)
end

function M:Destruct()
  TeamHallController:UnRegisterEvent(self)
end

return M

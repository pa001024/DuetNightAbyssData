require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.BtnAccept.Button_Area.OnClicked:Add(self, self.OnSubmitBtnClicked)
end

function M:OnListItemObjectSet(Content)
  rawset(self, "Content", Content)
  rawset(self, "TaskID", Content.TaskID)
  rawset(self, "Index", Content.Index)
  rawset(self, "TaskRegionID", Content.TaskRegionID)
  rawset(self, "TaskState", Content.TaskState)
  rawset(self, "TaskNPCIcon", Content.TaskNPCIcon)
  rawset(self, "TaskTitle", Content.TaskTitle)
  rawset(self, "TaskNPCName", Content.NPCName)
  rawset(self, "TaskContent", Content.TaskContent)
  rawset(self, "TaskReward", Content.TaskReward)
  rawset(self, "TaskSubmissions", Content.TaskSubmissions)
  rawset(self, "SubmitTaskCallback", Content.SubmitTaskCallback)
  rawset(self, "TaskModel", Content.TaskModel)
  rawset(self, "OnMenuOpenChanged", Content.OnMenuOpenChanged)
  rawset(self, "Parent", Content.Parent)
  Content.SelfWidget = self
  self.TaskNPCIcon = self.TaskNPCIcon or "空（临时）"
  self.TaskTitle = self.TaskTitle or "空（临时）"
  self.TaskNPCName = self.TaskNPCName or "空（临时）"
  local TempStr = {
    [1] = "委托任务描述1（临时）\n委托任务描述2（临时）\n委托任务描述3（临时）\n委托任务描述4（临时）\n委托任务描述5（临时）\n委托任务描述6（临时）\n委托任务描述7（临时）\n委托任务描述8（临时）\n委托任务描述9（临时）\n委托任务描述10（临时）",
    [2] = "委托任务描述（临时）"
  }
  self.TaskContent = self.TaskContent or TempStr[math.random(1, 2)]
  self:InitNormalInfo()
  self:InitRewardInfo()
  self:InitSubmissionInfo()
  self:RefreshButtonState()
  self:UpdateGamePadStyle()
end

function M:RefreshButtonState()
  local ActiveBtnIndex = 0
  if 0 == self.TaskState then
    self.Done:SetVisibility(UIConst.VisibilityOp.Collapsed)
    if self.bCanSubmit then
      self.BtnAccept:ForbidBtn(false)
    else
      self.BtnAccept:ForbidBtn(true)
    end
    self.BtnAccept:SetText(GText("ReputationEntrust_Submit"))
  else
    ActiveBtnIndex = 3
    self.Done:SetVisibility(UIConst.VisibilityOp.Visible)
    self.HintDone:SetText(GText("UI_Entrust_Complete"))
  end
  self.WidgetSwitcher_1:SetActiveWidgetIndex(ActiveBtnIndex)
  self:AddDelayFrameFunc(function()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.In)
  end, 1, "FillWithRegionInfo")
end

function M:InitNormalInfo()
  self:SetHeadIcon()
  self.TextTask:SetText(GText(self.TaskTitle))
  self.TextName:SetText(GText(self.TaskNPCName))
  self.TextTaskDetails:SetText(GText(self.TaskContent))
end

function M:SetHeadIcon()
  local IconPath = self.TaskNPCIcon
  local Icon = LoadObject(IconPath)
  if not Icon then
    Icon = LoadObject("Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'")
    DebugPrint(ErrorTag, string.format("用错图标路径了！！！这里用默认的图标顶一下\n 错误的路径是：%s", IconPath))
  end
  local DynamicMaterial = self.Image_Head:GetDynamicMaterial()
  if not IsValid(DynamicMaterial) then
    DebugPrint("ZDX_DynamicMaterial不合法")
  end
  DynamicMaterial:SetTextureParameterValue("IconTex", Icon)
end

function M:InitRewardInfo()
  self.TextReward:SetText(GText("ReputationEntrust_Reward"))
  self.List_Reward:ClearListItems()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = self.TaskReward.RewardResourceID
  local ResourceInfo = DataMgr.Resource[self.TaskReward.RewardResourceID]
  Content.Icon = ResourceInfo.Icon
  Content.ItemType = "Resource"
  Content.Count = self.TaskReward.RewardCount
  Content.IsShowDetails = true
  Content.OnMenuOpenChangedEvents = {
    Obj = self.Parent,
    Callback = self.OnMenuOpenChanged
  }
  self.List_Reward:AddItem(Content)
end

function M:InitSubmissionInfo()
  self.TextItem:SetText(GText("ReputationEntrust_Required"))
  local bCanSubmit = true
  local PlayerAvatar = GWorld:GetAvatar()
  self.List_Submit:ClearListItems()
  for key, TaskSubmission in pairs(self.TaskSubmissions) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemType = TaskSubmission.Type
    Content.Id = TaskSubmission.Id
    local ResourceInfo = DataMgr[Content.ItemType][Content.Id]
    Content.Icon = ResourceInfo.Icon
    Content.NeedCount = TaskSubmission.Count
    Content.IsShowDetails = true
    Content.Rarity = TaskSubmission.Rarity
    if TaskSubmission.Type == "Mod" then
      if PlayerAvatar then
        Content.Count = self.TaskModel:GetOriginalModCount(TaskSubmission.Id)
      end
    elseif TaskSubmission.Type == "Resource" then
      if PlayerAvatar then
        Content.Count = PlayerAvatar:GetResourceNum(TaskSubmission.Id)
      end
    else
      Content.Count = 0
    end
    if not Content.Count then
      DebugPrint("Content.Count is nil. TaskSubmission.Type = ", TaskSubmission.Type)
      Content.Count = 0
    end
    if Content.Count < Content.NeedCount then
      bCanSubmit = false
    end
    Content.OnMenuOpenChangedEvents = {
      Obj = self.Parent,
      Callback = self.OnMenuOpenChanged
    }
    self.List_Submit:AddItem(Content)
  end
  rawset(self, "bCanSubmit", bCanSubmit)
end

function M:OnSubmitBtnClicked()
  if self.BtnAccept.IsForbidden then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:CompleteEntrustQuest(self.TaskRegionID, self.TaskID, self.SubmitTaskCallback)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
    rawset(self, "bFocused", true)
    self:PlayAnimation(self.Hover)
    self:UpdateGamePadStyle()
    self:SetFocus()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusLost(InFocusEvent)
  rawset(self, "bFocusReward", false)
  rawset(self, "bFocusSubmit", false)
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
    if self.bFocused then
      self:PlayAnimation(self.UnHover)
    end
    rawset(self, "bFocused", false)
    self:UpdateGamePadStyle()
  end
end

function M:HandleGamePadPressA()
  if 0 == self.TaskState then
    self:OnSubmitBtnClicked()
  end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:HandleGamePadPressA()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.DPadUp then
    self.List_Reward:SetSelectedIndex(0)
    self.List_Reward:GetItemAt(0).SelfWidget:SetFocus()
    self:SetIsDealWithVirtualAccept(false)
    rawset(self, "bFocusReward", true)
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    self.List_Submit:SetSelectedIndex(0)
    self.List_Submit:GetItemAt(0).SelfWidget:SetFocus()
    self:SetIsDealWithVirtualAccept(false)
    rawset(self, "bFocusSubmit", true)
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and (self.bFocusReward or self.bFocusSubmit) then
    self:SetFocus()
    rawset(self, "bFocusReward", false)
    rawset(self, "bFocusSubmit", false)
    self:SetIsDealWithVirtualAccept(true)
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:Handle_OnPCButtonDown(InKeyName)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
  else
    IsEventHandled = self:Handle_OnPCButtonDown(InKeyName)
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
  local Speed = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
  if "Gamepad_RightY" == InKeyName then
    local TargetList = self.ScrollBox
    local CurScrollOffset = TargetList:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - Speed, 0, TargetList:GetScrollOffsetOfEnd())
    TargetList:SetScrollOffset(ScrollOffset)
  end
  return self.Unhandle
end

function M:SetAllBtnPCVisibility(IsShow)
  self:AddDelayFrameFunc(function()
    self.BtnAccept:SetPCVisibility(IsShow)
    self.BtnAbandon:SetPCVisibility(IsShow)
    self.BtnReward:SetGamePadVisibility(IsShow and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
  end, 1, "SetAllBtnPCVisibility")
end

function M:UpdateGamePadeSwipeTip()
  local TargetList = self.ScrollBox
  local TextOverflow = 0 ~= TargetList:GetScrollOffsetOfEnd()
  if TextOverflow then
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:UpdateGamePadStyle()
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad and self.bFocused then
    self:UpdateMouseGamePadImage()
    self:UpdateGamePadeSwipeTip()
    self.WBP_Com_KeyImg_24:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_Com_KeyImg_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:SetAllBtnPCVisibility(false)
  else
    if self.bFocused then
      self:PlayAnimation(self.UnHover)
    end
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Com_KeyImg_24:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_Com_KeyImg_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:SetAllBtnPCVisibility(true)
  end
end

function M:UpdateMouseGamePadImage()
  if self.InitedGamePadKey then
    return
  end
  local CurGamepadName = self.Parent.CurGamepadName
  self.WBP_Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RV", CurGamepadName)
      }
    }
  })
  self.WBP_Com_KeyImg_24:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("Up", CurGamepadName)
      }
    }
  })
  self.WBP_Com_KeyImg_1:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("Down", CurGamepadName)
      }
    }
  })
  rawset(self, "InitedGamePadKey", true)
end

return M

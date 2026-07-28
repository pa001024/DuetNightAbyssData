require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")

function M:Construct()
  self.Text_SubTitle:SetText(GText(RacingActivityConst.PlayerTodayStatusText))
  self.Text_CostTitle:SetText(GText(RacingActivityConst.RumorCostText))
  self.WBP_Activity_Racing_Pet_Today.Text_Title:SetText(GText(RacingActivityConst.RumorResultPlayerTodayStatusText))
  self.WBP_Activity_Racing_Pet_Today.Text_Tip:SetText(GText(RacingActivityConst.RumorResultClickText))
  self.WBP_Activity_Racing_Pet_Today.Text_Tip:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Cancel.Text_Btn:SetText(GText(RacingActivityConst.RumorCancelText))
  self.Btn_Cancel.Btn_Click.OnClicked:Add(self, self.OnCancelBtnClicked)
  self.Btn_Cancel.Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonRight)
  self.Btn_Confirm.Text_Btn:SetText(GText(RacingActivityConst.RumorConfirmText))
  self.Btn_Confirm.Btn_Click.OnClicked:Add(self, self.OnConfirmBtnClicked)
  self.Btn_Confirm.Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
  self.WBP_Activity_Racing_Pet_Today.Btn_Close.OnClicked:Add(self, self.OnCloseBtnClicked)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.CloseSelf
  })
  self:BindToAnimationFinished(self.Confirm, {
    self,
    self.ConfirmAnimationFinished
  })
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Destruct()
  self.Btn_Cancel.Btn_Click.OnClicked:Remove(self, self.OnCancelBtnClicked)
  self.Btn_Confirm.Btn_Click.OnClicked:Remove(self, self.OnConfirmBtnClicked)
  self.WBP_Activity_Racing_Pet_Today.Btn_Close.OnClicked:Remove(self, self.OnCloseBtnClicked)
  self:UnbindAllFromAnimationFinished(self.Out)
  self:UnbindAllFromAnimationFinished(self.Confirm)
  self.IsClickConfirmBtn = nil
  self.IsConfirmAnimationFinished = nil
  self.IsInConfirmAnimation = nil
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local Params = (...) or {}
  self.PlayerId = Params.PlayerId
  self.RumorCount = Params.RumorCount
  self.DisplayRumorIndex = Params.DisplayRumorIndex or self.RumorCount
  self.RealRumorIndex = self.RumorCount
  self.CloseCallback = Params.CloseCallback
  self.CancelCallback = Params.CancelCallback
  self.LastFocusWidget = Params.LastFocusWidget
  self.NeedExecuteCloseCallback = false
  self.IsClickConfirmBtn = false
  self.IsConfirmAnimationFinished = false
  self.ParentWidget = Params.ParentWidget
  self.Avatar = GWorld:GetAvatar()
  self:InitView()
  self:InitResourceBar()
  self:PlayInAnimation()
  self:SetFocus()
  AudioManager(self):PlayUISound(self, "event:/ui/common/common_panel_normal_expand", "RacingRumorPop", nil)
end

function M:InitView()
  local PlayerInfo = DataMgr.RaceLotteryPlayer[self.PlayerId]
  local IconPath = PlayerInfo.PlayerIcon or ""
  local IconDice = LoadObject(IconPath)
  self.Image_Pet:SetBrushFromTexture(IconDice)
  self.Text_PetTitle:SetText(GText(PlayerInfo.PlayerName))
  local IconResourceId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local IconPath = DataMgr.Resource[IconResourceId].Icon
  local IconDice = LoadObject(IconPath)
  self.Com_ItemIcon_Cost.Img_Icon:SetBrushResourceObject(IconDice)
  local RumorCount = RacingOutsiderModel:GetCurrentRumorInquireCount()
  local CostNum = DataMgr.RaceLotteryRumorFee[RumorCount].RumorInquireFee
  self.Text_CostNum:SetText(CostNum)
  local CoinId = tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  local HaveCoinNum = self.Avatar:GetResourceNum(CoinId)
  if CostNum > HaveCoinNum then
    self.Btn_Confirm:ForbidBtn(true)
  else
    self.Btn_Confirm:ForbidBtn(false)
  end
  self.Text_Desc:SetText(string.format(GText(RacingActivityConst.RumorDescText), tostring(self.RumorCount)) .. "???")
end

function M:InitResourceBar()
  self.TopResourcePanel:SetVisibility(UE4.ESlateVisibility.Visible)
  self.WBP_Com_Tab_Node_ResourceBar.HostCommonDialog = self
  self.WBP_Com_Tab_Node_ResourceBar:InitResourceBar({
    tonumber(DataMgr.RaceLotteryConstant.RaceLotteryCurrency.ConstantValue)
  })
  local ResourceBarIcon = UIUtils.UtilsGetKeyIconPathInGamepad("RS", "Generic")
  self.WBP_Com_Tab_Node_ResourceBar:SetGamePadKeyImgByPath(ResourceBarIcon)
end

function M:OnCloseBtnClicked()
  DebugPrint("Yihan@ OnCloseBtnClicked: xuanshou jintian zhuangtai")
  if self.IsInConfirmAnimation then
    return
  end
  self.NeedExecuteCloseCallback = true
  self:PlayOutAnimation()
  AudioManager(self):SetEventSoundParam(self, "RacingStatusUnlock", {ToEnd = 1})
end

function M:OnCancelBtnClicked()
  if self.IsInConfirmAnimation then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  self:PlayOutAnimation()
end

function M:OnConfirmBtnClicked()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  if self.IsClickConfirmBtn then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  self.IsClickConfirmBtn = true
  self.Avatar:RaceLotteryQueryPlayerRumor(self.PlayerId, function(Ret)
    if ErrorCode:Check(Ret) then
      RacingOutsiderModel:RefreshRumorContentListByPlayerId(self.PlayerId)
      local RumorContentList = RacingOutsiderModel:GetRumorContentListByPlayerId(self.PlayerId)
      self.RealRumorIndex = #RumorContentList
      local RumorContent = RumorContentList[self.RealRumorIndex]
      if RumorContent then
        self.WBP_Activity_Racing_Pet_Today.Text_Desc:SetText(string.format(GText(RacingActivityConst.RumorResultDescText), tostring(self.DisplayRumorIndex)) .. GText(RumorContent.MaxStake))
        self.NeedExecuteCloseCallback = true
        self:PlayConfirmAnimation(RumorContent)
      else
        DebugPrint("Yihan@ OnConfirmBtnClicked rumor content not found", self.PlayerId, self.RumorCount, self.RealRumorIndex)
      end
    else
      if self.Btn_Confirm.IsForbidden then
        return
      end
      local ActivityRacingRumorPage = UIManager(self):GetUIObj("ActivityRacingRumor")
      if ActivityRacingRumorPage then
        self:PlayOutAnimation()
      end
      if self.ParentWidget then
        self.ParentWidget:Close()
      end
    end
    self.IsClickConfirmBtn = false
  end)
end

function M:PlayInAnimation()
  self:StopAllAnimations()
  self.Group_PetTodayPopup:SetVisibility(UIConst.VisibilityOp.Visible)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "RacingRumorPop", {ToEnd = 1})
end

function M:PlayConfirmAnimation(RumorContent)
  self:StopAllAnimations()
  self.IsInConfirmAnimation = true
  self.Group_PetTodayPopup:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:PlayAnimation(self.Confirm)
  AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_challenger_state_show", "RacingStatusUnlock", nil)
  self:AddTimer(1.45, function()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PetData = DataMgr.Pet[self.PlayerId]
    local PetNameTag = PetData and PetData.PetNameTag
    if RumorContent.BuffSymbol == "+" then
      AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_happy", "PetVoice")
    elseif RumorContent.BuffSymbol == "-" then
      AudioManager(self):PlayUISound(self, "event:/sfx/pet/Bailao/vo_upset", nil, nil)
    end
  end)
end

function M:ConfirmAnimationFinished()
  self.IsInConfirmAnimation = false
  self.IsConfirmAnimationFinished = true
end

function M:CloseSelf()
  if self.NeedExecuteCloseCallback and self.CloseCallback then
    self.CloseCallback(self.DisplayRumorIndex, self.PlayerId, self.RealRumorIndex)
  elseif self.CancelCallback then
    self.CancelCallback()
  end
  self.NeedExecuteCloseCallback = false
  self:Close()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamepadInput then
    local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
    self.Btn_Confirm.Com_KeyImg:SetVisibility(Visible)
    self.Btn_Cancel.Com_KeyImg:SetVisibility(Visible)
  else
    local Collapsed = UIConst.VisibilityOp.Collapsed
    self.Btn_Confirm.Com_KeyImg:SetVisibility(Collapsed)
    self.Btn_Cancel.Com_KeyImg:SetVisibility(Collapsed)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if self.IsConfirmAnimationFinished then
      self:OnCloseBtnClicked()
      IsEventHandled = true
    else
      IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    end
  else
    IsEventHandled = self:Handle_KeyDownOnPC(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyDownOnPC(InKeyName)
  if "Escape" == InKeyName then
    self:OnCancelBtnClicked()
    return true
  end
  return false
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnCancelBtnClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:OnConfirmBtnClicked()
    return true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    self.WBP_Com_Tab_Node_ResourceBar:SetLastFocusWidget(self)
    self.WBP_Com_Tab_Node_ResourceBar:SetFocus()
    self.WBP_Com_Tab_Node_ResourceBar:FocusToResource()
    return true
  end
  return false
end

return M

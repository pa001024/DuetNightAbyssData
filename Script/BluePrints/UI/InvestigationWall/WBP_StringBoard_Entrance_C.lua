require("UnLua")
local StringBoardReddotHelper = require("BluePrints.UI.InvestigationWall.StringBoardReddotHelper")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Initialize(Initializer)
  self.bReddotBound = false
  self.bInputListenBound = false
  self.bHostAllowGamePadKey = true
  self.bHasFocus = false
end

function M:Construct()
end

function M:Init()
  if self.Text then
    self.Text:SetText(GText("UI_StringBoard"))
  end
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  end
  self:InitGamePadKey()
  self:BindInputMethodChanged()
  self:RefreshGamePadKeyByInputType()
  self:BindReddot()
end

function M:Destruct()
  self:CleanupEntrance()
end

function M:CleanupEntrance()
  self.bHasFocus = false
  self:UnbindReddot()
  self:UnbindInputMethodChanged()
end

function M:InitGamePadKey()
  if not self.Key_GamePad then
    return
  end
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
end

function M:OnAddedToFocusPath(InFocusEvent)
  self.bHasFocus = true
  self:RefreshGamePadKeyByInputType()
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self.bHasFocus = false
  self:RefreshGamePadKeyByInputType()
end

function M:BindInputMethodChanged()
  if self.bInputListenBound then
    return
  end
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
    self.bInputListenBound = true
  end
end

function M:UnbindInputMethodChanged()
  if not self.bInputListenBound then
    return
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
  self.bInputListenBound = false
end

function M:OnInputMethodChanged(CurInputType, CurGamepadName)
  self:RefreshGamePadKeyByInputType(CurInputType)
end

function M:RefreshGamePadKeyByInputType(CurInputType)
  if nil == CurInputType and IsValid(self.GameInputModeSubsystem) then
    CurInputType = self.GameInputModeSubsystem:GetCurrentInputType()
  end
  local bGamepad = CurInputType == ECommonInputType.Gamepad
  self:SetGamePadKeyVisible(bGamepad and self.bHostAllowGamePadKey and self.bHasFocus)
end

function M:SetHostAllowGamePadKey(bAllow)
  self.bHostAllowGamePadKey = bAllow and true or false
  self:RefreshGamePadKeyByInputType()
end

function M:SetGamePadKeyVisible(bVisible)
  if not self.Key_GamePad then
    return
  end
  self.Key_GamePad:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  UIManager(self):LoadUINew("StringBoardMain")
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.OwnerEntrancePanel and self.OwnerEntrancePanel.OnChildPreviewKeyDown then
    local Reply = self.OwnerEntrancePanel:OnChildPreviewKeyDown(self, MyGeometry, InKeyEvent)
    if nil ~= Reply then
      return Reply
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:BindReddot()
  if self.bReddotBound then
    return
  end
  StringBoardReddotHelper.EnsureNodes()
  ReddotManager.AddListenerEx(StringBoardReddotHelper.NodeName.Root, self, self.OnReddotChanged)
  self.bReddotBound = true
end

function M:UnbindReddot()
  if not self.bReddotBound then
    return
  end
  ReddotManager.RemoveListener(StringBoardReddotHelper.NodeName.Root, self)
  self.bReddotBound = false
end

function M:OnReddotChanged(Count, RdType, Name)
  local bShow = Count and Count > 0
  local ShowRdType = RdType or EReddotType.New
  if self.EMShowReddot then
    self:EMShowReddot(bShow, ShowRdType)
    return
  end
  local bShowNew = bShow and ShowRdType == EReddotType.New
  local bShowNormal = bShow and ShowRdType == EReddotType.Normal
  if self.New and self.New.SetVisibility then
    self.New:SetVisibility(bShowNew and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Reddot and self.Reddot.SetVisibility then
    self.Reddot:SetVisibility(bShowNormal and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

return M

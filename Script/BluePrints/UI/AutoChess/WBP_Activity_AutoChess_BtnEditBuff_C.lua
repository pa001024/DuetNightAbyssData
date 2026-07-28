require("UnLua")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local WS_BUTTON_CHECK = 0
local WS_BUTTON_EDIT = 1
local WS_BUTTON_GAMEPAD = 2
local WS_LIST_CONTENT = 0
local WS_LIST_EMPTY = 1

function M:Construct()
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
  EventManager:AddEvent(EventID.OnAutoChessChallengeBuffChanged, self, self.OnChallengeBuffChanged)
  EventManager:AddEvent(EventID.OnAutoChessSquadChanged, self, self.OnChallengeBuffChanged)
end

function M:Destruct()
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    self.GameInputModeSubsystem = nil
  end
  EventManager:RemoveEvent(EventID.OnAutoChessChallengeBuffChanged, self)
  EventManager:RemoveEvent(EventID.OnAutoChessSquadChanged, self)
end

function M:Init(MissionId, bEditMode, Parent)
  self.MissionId = MissionId
  self.bEditMode = bEditMode and true or false
  self.Parent = Parent
  self:RefreshBuffIcons()
  self:RefreshOpInfoByInputDevice()
end

function M:RefreshOpInfoByInputDevice(CurInputType)
  if nil == CurInputType then
    CurInputType = UIUtils.UtilsGetCurrentInputType()
  end
  if not self.WS_Button then
    return
  end
  if CurInputType == ECommonInputType.Gamepad then
    if self.Key_Controller and self.Key_Controller.CreateCommonKey then
      self.Key_Controller:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialLeft
          }
        }
      })
    end
    self.WS_Button:SetActiveWidgetIndex(WS_BUTTON_GAMEPAD)
  else
    self.WS_Button:SetActiveWidgetIndex(self.bEditMode and WS_BUTTON_EDIT or WS_BUTTON_CHECK)
  end
end

function M:GetShareChallengeBuffIds()
  local Parent = self.Parent
  if not Parent or not Parent.GameMode then
    return nil
  end
  local bShareChallenge = Parent.GameMode:TriggerDungeonComponentFun("GetIsShareChallenge")
  if not bShareChallenge then
    return nil
  end
  return Parent.GameMode:TriggerDungeonComponentFun("GetActiveChallengeBuffIdList")
end

function M:RefreshBuffIcons()
  local DisplayBuffs = Model:GetDisplayBuffs(self.MissionId, self:GetShareChallengeBuffIds())
  local BuffImages = {
    self.Image_Buff,
    self.Image_Buff_1,
    self.Image_Buff_2,
    self.Image_Buff_3
  }
  local MaxDisplay = #BuffImages
  for _, Image in ipairs(BuffImages) do
    Image:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Image_More then
    self.Image_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Image_Buff_4 then
    self.Image_Buff_4:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if 0 == #DisplayBuffs then
    if self.WS_List then
      self.WS_List:SetActiveWidgetIndex(WS_LIST_EMPTY)
    end
    if self.TextEmpty then
      self.TextEmpty:SetText(GText("UI_AutoChess_NeedChooseBuff"))
    end
    return
  end
  if self.WS_List then
    self.WS_List:SetActiveWidgetIndex(WS_LIST_CONTENT)
  end
  local DisplayCount = #DisplayBuffs
  if MaxDisplay < DisplayCount then
    DisplayCount = MaxDisplay
    if self.Image_More then
      self.Image_More:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  for i = 1, DisplayCount do
    local Image = BuffImages[i]
    if Image then
      local IconObj = LoadObject(DisplayBuffs[i].BuffIcon)
      if IconObj then
        Image:SetBrushResourceObject(IconObj)
      end
      Image:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:OnInputMethodChanged()
  self:RefreshOpInfoByInputDevice()
end

function M:OnChallengeBuffChanged()
  if not IsValid(self) then
    return
  end
  self:RefreshBuffIcons()
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:TriggerAction()
end

function M:TriggerAction()
  if self.bEditMode then
    local InitParams = {bSkipConfirmSave = false, bShowTitleTips = false}
    local SquadIdx
    if Model:IsShareEditMode(self.MissionId) then
      SquadIdx = Model:GetEditingSuqadIndex() or 1
    end
    UIManager(self):LoadUINew("AutoChessShareBuff", InitParams, SquadIdx, self.OnChallengeBuffChanged)
  else
    self:OpenBuffDetail()
  end
end

function M:OpenBuffDetail()
  if not self.MissionId then
    return
  end
  local UIMgr = UIManager(self)
  local ActiveBuffIds = self:GetShareChallengeBuffIds()
  local BuffDetailUI = UIMgr:GetUIObj("AutoChessBuffDetail")
  BuffDetailUI = BuffDetailUI or UIMgr:LoadUINew("AutoChessBuffDetail", self.MissionId, ActiveBuffIds)
  if BuffDetailUI then
    BuffDetailUI:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

return M

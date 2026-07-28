require("UnLua")
local UIUtils = require("Utils.UIUtils")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function View:Construct()
  self.Key_Left_1:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    }
  })
  self.Key_Right_1:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    }
  })
  self.Ws_Key:SetVisibility(ESlateVisibility.HitTestInvisible)
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitTab(self.TabState01, DataMgr.CombatChessPosition[999].PositionId, DataMgr.CombatChessPosition[999].PositionIcon)
  self:InitTab(self.TabState02, DataMgr.CombatChessPosition[1].PositionId, DataMgr.CombatChessPosition[1].PositionIcon)
  self:InitTab(self.TabState03, DataMgr.CombatChessPosition[2].PositionId, DataMgr.CombatChessPosition[2].PositionIcon)
  self:InitTab(self.TabState04, DataMgr.CombatChessPosition[3].PositionId, DataMgr.CombatChessPosition[3].PositionIcon)
  self:InitTab(self.TabState05, DataMgr.CombatChessPosition[4].PositionId, DataMgr.CombatChessPosition[4].PositionIcon)
  self.tabs = {
    self.TabState01,
    self.TabState02,
    self.TabState03,
    self.TabState04,
    self.TabState05
  }
  self.SelectedAttributeTab = self.tabs[1]
  for i = 1, #self.tabs do
    self.tabs[i]:SetSelected(self.tabs[i] == self.TabState01)
  end
  self.tabs[1]:PlayAnimation(self.tabs[1].Click)
end

function View:InitInfo(ParentWidget)
  self.ParentWidget = ParentWidget
end

function View:MoveTab(Direction)
  if -1 ~= Direction and 1 ~= Direction then
    return
  end
  if not self.tabs or 0 == #self.tabs then
    return
  end
  local currentIndex = 1
  local found = false
  for i = 1, #self.tabs do
    if self.SelectedAttributeTab == self.tabs[i] then
      currentIndex = i
      found = true
      break
    end
  end
  if not found then
    currentIndex = 1
  end
  local newIndex = currentIndex + Direction
  if newIndex < 1 then
    newIndex = 1
  end
  if newIndex > #self.tabs then
    newIndex = #self.tabs
  end
  if newIndex == currentIndex then
    return
  end
  local newTab = self.tabs[newIndex]
  if newTab then
    self:OnAttributeTabClicked(newTab)
    if newTab.PlayAnimation and newTab.Click then
      newTab:PlayAnimation(newTab.Click)
    end
  end
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Gamepad then
    self.Ws_Key:SetActiveWidgetIndex(0)
  else
    self.Ws_Key:SetActiveWidgetIndex(1)
  end
end

function View:InitTab(Tab, PositionId, ImagePath)
  Tab:InitInfo(self, PositionId)
  local Image = UStoryFunctionLibrary.LoadResourceWithGender(self, ImagePath, self)
  if not Image then
    DebugPrint("WBP_Activity_AutoChess_HudState: ", ImagePath, "is missing")
  end
  local MatPath = "MaterialInstanceConstant'/Game/UI/WBP/Common/VX/Activity/AutoChess/MI_Activity_AutoChess_AttributeStatusTab_01.MI_Activity_AutoChess_AttributeStatusTab_01'"
  local Mat = LoadObject(MatPath)
  if Mat then
    local MaterialInstance = UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(self, Mat, "None")
    if MaterialInstance then
      MaterialInstance:SetTextureParameterValue("Mask", Image)
      Tab.Image_Icon:SetBrushFromMaterial(MaterialInstance)
    else
      DebugPrint("WBP_Activity_AutoChess_HudState: MaterialInstance is nil")
    end
  else
    DebugPrint("WBP_Activity_AutoChess_HudState: ", MatPath, " is missing")
  end
end

function View:OnAttributeTabClicked(clickedTab)
  if self.SelectedAttributeTab == clickedTab then
    return
  end
  self.SelectedAttributeTab = clickedTab
  for _, t in ipairs(self.tabs) do
    if t and t.SetSelected then
      local shouldSelect = t == clickedTab
      t:SetSelected(shouldSelect)
    end
  end
  if self.ParentWidget then
    self.ParentWidget:UpdateListChess(clickedTab.PositionId)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
  DebugPrint("HudState: Tab clicked, PositionId: ", clickedTab.PositionId)
end

return View

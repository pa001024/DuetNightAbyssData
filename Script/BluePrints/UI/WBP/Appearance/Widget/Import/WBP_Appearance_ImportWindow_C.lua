require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local DyePopupId = 100379

local function ImportWindowScreenPrint(Message)
  ScreenPrint("[AppearanceImportWindow] " .. tostring(Message))
end

function M:Construct()
  self.ImportItems = {}
  self.bWindowVisible = false
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self.Btn_Close:Init("Close", self, self.OnCloseClicked)
  self.Btn_Import:BindEventOnClicked(self, self.OnImportClicked)
end

function M:GetPlanItemWidgets()
  return {
    self.WBP_Appearance_ImportItem_1,
    self.WBP_Appearance_ImportItem_2,
    self.WBP_Appearance_ImportItem_3
  }
end

function M:Destruct()
  self:ClearImportItems()
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.Model = Params.Model
  if not self.Model then
    ImportWindowScreenPrint("init failed: model is nil")
  end
  self:InitWindowView()
  self:HideWindow(true)
end

function M:IsWindowOpen()
  return self.bWindowVisible == true
end

function M:ShowWindow()
  if not self.Model then
    ImportWindowScreenPrint("show window failed: model is nil")
    return
  end
  self.bWindowVisible = true
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:RefreshByModel()
  self:PlayInAnim()
end

function M:RequestClose()
  if not self:IsWindowOpen() then
    return
  end
  self.bWindowVisible = false
  self:PlayOutAnim()
end

function M:HideWindow(IsImmediate)
  self.bWindowVisible = false
  if IsImmediate then
    self:StopAnimation(self.Out)
    self:StopAnimation(self.In)
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnOutAnimationFinished()
  if not self.bWindowVisible then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshByModel()
  if not self.Model then
    ImportWindowScreenPrint("refresh failed: model is nil")
    return
  end
  self.Text_Avatar:SetText(self.Model:GetAvatarDisplayName())
  self:RefreshAvatarImage()
  self:RefreshPlanItems()
  self:RefreshWarning()
  self:RefreshConfirmButtonState()
end

function M:InitWindowView()
  self.Text_Import:SetText(GText("UI_AppearanceScore_Import"))
  self.Text_Plan:SetText(GText("UI_AppearanceScore_CoverPlan"))
  self.Btn_Import:SetText(GText("UI_AppearanceScore_Import"))
end

function M:InitImportWindowGamepadWidgets()
  if self.bImportWindowGamepadInited then
    return
  end
  self.bImportWindowGamepadInited = true
  if self.Key_Gamepad then
    if self.Key_Gamepad.CreateCommonKey then
      self.Key_Gamepad:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Up"}
        }
      })
    end
    self.Key_Gamepad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshImportWindowGamepadVisible(bVisible, StateType)
  if not self.Key_Gamepad then
    return
  end
  local IsPC = self.Parent and self.Parent.IsPC
  local NeedShow = true == bVisible and true == IsPC and "ImportWindow" == StateType
  self.Key_Gamepad:SetVisibility(NeedShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshAvatarImage()
  local ImagePath = self.Model and self.Model:GetAvatarSilhouettePath() or nil
  if not ImagePath or "" == ImagePath then
    ImportWindowScreenPrint("refresh avatar image skipped: missing image path")
    return
  end
  local Image = LoadObject(ImagePath)
  if not Image then
    ImportWindowScreenPrint("refresh avatar image failed: cannot load " .. tostring(ImagePath))
    return
  end
  local DynamicMaterial = self.Img_Avatar:GetDynamicMaterial()
  DynamicMaterial:SetTextureParameterValue("MainTex", Image)
end

function M:RefreshPlanItems()
  self:ClearImportItemsByPrefix("Plan_")
  local PlanWidgets = self:GetPlanItemWidgets()
  local PlanItems = self.Model:GetTargetPlanItems()
  for _, Widget in ipairs(PlanWidgets) do
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  for Index, ItemData in ipairs(PlanItems) do
    local ItemWidget = PlanWidgets[Index]
    if not IsValid(ItemWidget) then
      ImportWindowScreenPrint("refresh plan items warning: missing child widget at index " .. tostring(Index))
    else
      ItemWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self:InitPlanItemWidget(ItemWidget, ItemData)
      self.ImportItems[ItemData.Key] = ItemWidget
    end
  end
  self:RefreshPlanSelectionState()
end

function M:RefreshWarning()
  if self.Panel_Warning then
    self.Panel_Warning:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Text_Warning then
    self.Text_Warning:SetText(GText("UI_AppearanceScore_CoverDes"))
  end
end

function M:RefreshConfirmButtonState()
  self.Btn_Import:SetIsEnabled(self.Model and self.Model:CanStartImport() or false)
end

function M:InitPlanItemWidget(ItemWidget, ItemData)
  self:ClearPlanItemEvents(ItemWidget)
  ItemWidget.PlanItemKey = ItemData.Key
  ItemWidget.bIsFocusable = true
  if ItemWidget.Com_List then
    ItemWidget.Com_List.bIsFocusable = true
  end
  ItemWidget.Text_Plan:SetText(ItemData.Text or "")
  ItemWidget.WS_Usage:SetActiveWidgetIndex(0)
  ItemWidget.Com_List:BindEventOnClicked(self, self.OnPlanItemClicked, ItemWidget, ItemData.Key)
  ItemWidget.Com_List:SetCanCancelSelection(false)
  ItemWidget.Com_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  ItemWidget.Com_List.Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
  ItemWidget.Com_List.Button_Area:SetIsEnabled(true)
  ItemWidget.CheckBox.ButtonArea:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:RefreshPlanItemSelectedState(ItemWidget, false)
end

function M:RefreshPlanSelectionState()
  local SelectedPlanIndex = self.Model and self.Model:GetSelectedTargetPlanIndex() or nil
  local SelectedPlanKey = SelectedPlanIndex and "Plan_" .. tostring(SelectedPlanIndex) or nil
  for _, Widget in ipairs(self:GetPlanItemWidgets()) do
    if IsValid(Widget) and Widget:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      local IsSelected = nil ~= SelectedPlanKey and Widget.PlanItemKey == SelectedPlanKey
      self:RefreshPlanItemSelectedState(Widget, IsSelected)
    end
  end
end

function M:ClearImportItemsByPrefix(Prefix)
  for Key, Widget in pairs(self.ImportItems) do
    if string.sub(Key, 1, #Prefix) == Prefix and IsValid(Widget) then
      self:ClearPlanItemEvents(Widget)
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.ImportItems[Key] = nil
    end
  end
end

function M:ClearImportItems()
  for Key, Widget in pairs(self.ImportItems) do
    if IsValid(Widget) then
      self:ClearPlanItemEvents(Widget)
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.ImportItems[Key] = nil
  end
end

function M:ClearPlanItemEvents(ItemWidget)
  ItemWidget.Com_List.Obj = nil
  ItemWidget.Com_List.Func = nil
  ItemWidget.Com_List.Params = nil
end

function M:RefreshPlanItemSelectedState(ItemWidget, IsSelected)
  local bSelected = true == IsSelected
  ItemWidget.Img_Point_Select:SetVisibility(bSelected and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if bSelected then
    ItemWidget.Com_List:SelectCell()
  else
    ItemWidget.Com_List:OnCellUnSelect()
  end
end

function M:OnPlanItemClicked(ItemWidget, ItemKey)
  if not self.Model then
    ImportWindowScreenPrint("switch plan failed: model is nil")
    return
  end
  local PlanIndex = tonumber(string.match(ItemKey or "", "^Plan_(%d+)$"))
  if not PlanIndex then
    return
  end
  if self.Model:GetSelectedTargetPlanIndex() == PlanIndex then
    self:RefreshPlanItemSelectedState(ItemWidget, true)
    return
  end
  self.Model:SetSelectedTargetPlanIndex(PlanIndex)
  for _, Widget in ipairs(self:GetPlanItemWidgets()) do
    if IsValid(Widget) and Widget:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      self:RefreshPlanItemSelectedState(Widget, Widget == ItemWidget)
    end
  end
  self:RefreshWarning()
  self:RefreshConfirmButtonState()
end

function M:OnImportCostItemTipsOpenChanged(bIsOpen, Content)
  if self.Parent and self.Parent.OnImportCostItemTipsOpenChanged then
    self.Parent:OnImportCostItemTipsOpenChanged(bIsOpen, Content)
  end
end

function M:OpenDyeDialog(OnConfirmCallback)
  if not self.Model then
    ImportWindowScreenPrint("open confirm dialog failed: model is nil")
    return
  end
  UIManager(self):ShowCommonPopupUI(DyePopupId, {
    Parent = self,
    Title = GText("UI_AppearanceScore_ConfirmTitle"),
    ShortText = self.Model:GetDyeImportConfirmText(),
    DyeDialogData = self.Model:GetDyeDialogData(),
    AppearanceScoreChangeText = self.Model:GetAppearanceScoreChangeText(),
    CurrentAppearanceTotalScore = self.Model:GetCurrentAppearanceTotalScore(),
    FinalImportAppearanceTotalScore = self.Model:GetFinalImportAppearanceTotalScore(),
    RightCallbackFunction = function()
      if OnConfirmCallback then
        OnConfirmCallback()
      end
    end
  }, self)
end

function M:OnCloseClicked()
  self.Parent:CloseImportWindow()
end

function M:OnImportClicked()
  self.Parent:OnImportClicked()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

return M

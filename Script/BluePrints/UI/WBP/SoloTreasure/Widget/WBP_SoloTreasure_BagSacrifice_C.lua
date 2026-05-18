require("UnLua")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")
local EMCache = require("EMCache.EMCache")
local SACRIFICE_CONFIRM_POPUP_ID = 100341
local SACRIFICE_SKIP_CONFIRM_KEY = "SoloTreasureSacrificeSkipConfirm"
local GAMBLE_MECH_STATE_TRIBUTE_CANCLE = 1310693
local GAMBLE_MECH_STATE_TRIBUTE_SUCCESS = 1310694
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr",
  "BluePrints.Common.DelayFrameComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Init(InitParams)
  self.Parent = InitParams.Parent
  self.ServerUniqueId = InitParams.ServerUniqueId
  self.TributeId = InitParams.TributeId
  self.BPGambleMech = InitParams.BPGambleMech
  self:PlayInAnim()
  if not (self.Parent and InventoryController) or not InventoryController.bInit then
    return
  end
  if not self.TributeId or not self.ServerUniqueId then
    return
  end
  local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
  local ServerEntity = GWorld:GetServerEntity()
  if not ServerEntity then
    return
  end
  self.Dungeonobject = ServerEntity:GetGameModeDungeonObject()
  if not self.Dungeonobject then
    return
  end
  local TributeInfo = DataMgr.ExtractionTreasureTribute[self.TributeId]
  if not TributeInfo then
    return
  end
  local Size = FVector2D(TributeInfo.Shape[1], TributeInfo.Shape[2])
  local PocketData
  if not InventoryController.InventoryModel.Pockets[PocketName] then
    PocketData = {
      Name = PocketName,
      Size = Size,
      Parent = InventoryController.MainWidget,
      Inventory = InventoryCommonConst.PocketType.Mechanism,
      MechanismUid = self.ServerUniqueId
    }
    InventoryController.InventoryModel.Pockets[PocketName] = PocketData
    InventoryController:InitGridsData(PocketData)
  end
  self.PocketWidget = self.WBP_Search_Bag
  if not self.PocketWidget then
    return
  end
  self.PocketWidget:Init({
    Name = PocketName,
    Size = Size,
    Inventory = InventoryCommonConst.PocketType.Mechanism,
    MechanismUid = self.ServerUniqueId,
    Parent = self,
    PocketData = PocketData or InventoryController.InventoryModel.Pockets[PocketName]
  })
  self:InitEvents()
  self.EMScrollBox:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_Search:SetText(GText("UI_Extraction_TM_10"))
  self.Btn_Scrifice.Text_Button:SetText(GText("UI_Extraction_TM_13"))
  self.Text_Value:SetText(GText("UI_Extraction_TM_12"))
  self.Btn_Qa:Init({
    OwnerWidget = self,
    TextContent = GText("UI_Extraction_TM_11"),
    OnMenuOpenChangedCallBack = function(_, bOpen)
      self:OnSacrificeOverlayOpen(bOpen)
    end
  })
  local DungeonId = self.Dungeonobject.DungeonId
  local SoloTreasureInfo = DataMgr.SoloTreasure[DungeonId]
  if not SoloTreasureInfo then
    return
  end
  self.GamePlayIds = SoloTreasureInfo.GamePlayId or {}
  for _, GamePlayId in pairs(self.GamePlayIds) do
    local GamePlayInfo = DataMgr.SoloTreasureGamePlay[GamePlayId]
    if GamePlayInfo and 2 == GamePlayInfo.type then
      self.GameplayId = GamePlayId
    end
  end
  local GamePlayInfo = DataMgr.SoloTreasureGamePlay[self.GameplayId]
  if not GamePlayInfo then
    return
  end
  self.Thresholds = {}
  self.Thresholds[1] = 1
  for i = 1, 3 do
    self.Thresholds[i + 1] = GamePlayInfo["Gear" .. i] or 9999
  end
  self.SacrificeItemWidgets = {
    self.SacrificeItem,
    self.SacrificeItem_1,
    self.SacrificeItem_2,
    self.SacrificeItem_3
  }
  for i, Item in ipairs(self.SacrificeItemWidgets) do
    if Item and IsValid(Item) then
      Item:Init(self.Thresholds[i])
    end
  end
  self:InitSacrificeBtn()
  self:InitGamepadKeys()
  self.CurTotalValue = 0
  self.CurPercent = 0
  self:UpdateProgress()
  self.EMScrollBox:SetControlScrollbarInside(true)
end

function M:InitSacrificeBtn()
  local Btn = self.Btn_Scrifice
  if not Btn then
    return
  end
  Btn.Btn_Click.OnHovered:Clear()
  Btn.Btn_Click.OnHovered:Add(self, function()
    if not self.bSacrificeBtnEnabled then
      return
    end
    Btn:StopAnimation(Btn.UnHover)
    Btn:PlayAnimation(Btn.Hover)
  end)
  Btn.Btn_Click.OnUnHovered:Clear()
  Btn.Btn_Click.OnUnHovered:Add(self, function()
    if not self.bSacrificeBtnEnabled then
      return
    end
    Btn:StopAnimation(Btn.Hover)
    Btn:PlayAnimation(Btn.UnHover)
  end)
  Btn.Btn_Click.OnPressed:Clear()
  Btn.Btn_Click.OnPressed:Add(self, function()
    if not self.bSacrificeBtnEnabled then
      return
    end
    Btn:PlayAnimation(Btn.Press)
    if UIUtils.IsMobileInput() then
      self:TryConfirmSacrifice()
    end
  end)
  Btn.Btn_Click.OnClicked:Clear()
  Btn.Btn_Click.OnClicked:Add(self, function()
    if UIUtils.IsMobileInput() then
      return
    end
    self:TryConfirmSacrifice()
  end)
end

function M:SetSacrificeBtnEnabled(bEnabled)
  if self.bSacrificeBtnEnabled == bEnabled then
    return
  end
  self.bSacrificeBtnEnabled = bEnabled
  local Btn = self.Btn_Scrifice
  if not Btn then
    return
  end
  Btn:StopAllAnimations()
  Btn.Btn_Click:SetForbidden(not bEnabled)
end

function M:TryConfirmSacrifice()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_confirm", nil, nil)
  if not self.bSacrificeBtnEnabled then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Extraction_TM_10"))
    return
  end
  if EMCache:Get(SACRIFICE_SKIP_CONFIRM_KEY) then
    self:OnSacrificeConfirm()
    return
  end
  self:OnSacrificeOverlayOpen(true)
  local Params = {
    RightCallbackFunction = function(_, Data)
      self:OnSacrificeOverlayOpen(false)
      if Data and Data.SelectHint and Data.SelectHint.IsSelected then
        EMCache:Set(SACRIFICE_SKIP_CONFIRM_KEY, true)
      end
      self:OnSacrificeConfirm()
    end,
    LeftCallbackFunction = function()
      self:OnSacrificeOverlayOpen(false)
    end
  }
  UIManager(self):ShowCommonPopupUI(SACRIFICE_CONFIRM_POPUP_ID, Params)
end

function M:OnSacrificeConfirm()
  if not self.BPGambleMech or not IsValid(self.BPGambleMech) then
    return
  end
  local Btn = self.Btn_Scrifice
  if Btn then
    Btn:PlayAnimation(Btn.Click)
  end
  self.BPGambleMech:TributeSuccess()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_gongfeng_succeed", nil, nil)
  if self.Parent and self.Parent.CloseSelf then
    self.Parent:CloseSelf()
  end
end

function M:InitEvents()
  self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
    self:UpdateProgress()
  end)
end

function M:UpdateProgress()
  if not self.ServerUniqueId or not self.Thresholds then
    return
  end
  local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
  local ValueInfo = SoloTreasureUtils:GetPocketTreasureValueInfo(PocketName)
  local TotalValue = ValueInfo.TotalValue
  local PrevValue = self.CurTotalValue or 0
  self.CurTotalValue = TotalValue
  self.Num_Value:SetText(Utils.FormatNumber(TotalValue, false))
  UIUtils.RollingNumberEffect(self, self.Num_Value, PrevValue, TotalValue - PrevValue, 0.5)
  self:AnimateProgressTo(self:CalcBarPercent(TotalValue))
  self:SetSacrificeBtnEnabled(TotalValue > 0)
end

local PROGRESS_ANIM_DURATION = 0.5
local PROGRESS_ANIM_INTERVAL = 0.016

function M:AnimateProgressTo(TargetPercent)
  self:RemoveTimer("ProgressAnim")
  local StartPercent = self.CurPercent or 0
  if StartPercent == TargetPercent then
    self.ProgressBar:SetPercent(TargetPercent)
    return
  end
  local Elapsed = 0
  self:AddTimer(PROGRESS_ANIM_INTERVAL, function()
    Elapsed = Elapsed + PROGRESS_ANIM_INTERVAL
    local t = math.min(Elapsed / PROGRESS_ANIM_DURATION, 1)
    local New = StartPercent + (TargetPercent - StartPercent) * t
    self.CurPercent = New
    self.ProgressBar:SetPercent(New)
    local LerpedValue = self:CalcValueFromPercent(New)
    for _, Item in ipairs(self.SacrificeItemWidgets or {}) do
      if Item and IsValid(Item) then
        Item:UpdateProgressNum(LerpedValue)
      end
    end
    if t >= 1 then
      self:RemoveTimer("ProgressAnim")
    end
  end, true, 0, "ProgressAnim")
end

function M:CalcValueFromPercent(Percent)
  local T = self.Thresholds
  if not T or #T < 2 then
    return 0
  end
  local NumSegs = #T - 1
  local SegWidth = 1.0 / NumSegs
  if Percent <= 0 then
    return T[1] - 1
  end
  if Percent >= 1 then
    return T[#T]
  end
  local SegIdx = math.min(math.floor(Percent / SegWidth) + 1, NumSegs)
  local SegStart = T[SegIdx]
  local SegEnd = T[SegIdx + 1]
  local SegPercent = (Percent - (SegIdx - 1) * SegWidth) / SegWidth
  return SegStart + SegPercent * (SegEnd - SegStart)
end

function M:CalcBarPercent(Value)
  local T = self.Thresholds
  if not T or #T < 2 then
    return 0
  end
  local NumSegs = #T - 1
  local SegWidth = 1.0 / NumSegs
  if Value <= T[1] then
    return 0
  end
  for i = 1, NumSegs do
    local SegStart = T[i]
    local SegEnd = T[i + 1]
    if Value < SegEnd then
      return (i - 1) * SegWidth + (Value - SegStart) / (SegEnd - SegStart) * SegWidth
    end
  end
  return 1.0
end

function M:RemoveEvents()
  self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
end

function M:PlayInAnim()
  if not self.In then
    return
  end
  self:PlayAnimation(self.In)
end

function M:Tick(MyGeometry, InDeltaTime)
  if not self.ServerUniqueId then
    return
  end
  if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox) then
    local TriggerParams = {
      DeltaTime = InDeltaTime,
      ScrollBox = self.EMScrollBox,
      TriggerScrollUp = self.DragScrollTip_Up,
      TriggerScrollDown = self.DragScrollTip_Bottom,
      ShowPocketsScrollUpArrow = self.ShowSearchScrollUpArrow,
      ShowPocketsScrollDownArrow = self.ShowSearchScrollDownArrow,
      CurTouchPos = InventoryController.MainWidget and InventoryController.MainWidget.ScreenSpacePositionTouchPos or nil
    }
    SoloTreasureUtils:TickTriggerScrollSizeBox(TriggerParams)
  end
end

function M:InitGamepadKeys()
  local Controller = self.Btn_Scrifice and self.Btn_Scrifice.Controller
  if Controller and Controller.CreateCommonKey then
    Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LT"}
      }
    })
  end
  self.QAController:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Right"}
    }
  })
end

function M:OnLTKey()
  self:TryConfirmSacrifice()
end

function M:OnDPadRightKey()
  local QaBtn = self.Btn_Qa
  if not QaBtn then
    return
  end
  if QaBtn:IsMenuAnchorOpen() then
    QaBtn:CloseMenuAnchor()
    QaBtn:ResetStyle()
  else
    QaBtn:SetChecked(true)
    QaBtn:OpenMenuAnchor()
  end
end

function M:OnCloseSacrificeOverlay()
  local QaBtn = self.Btn_Qa
  if QaBtn and QaBtn:IsMenuAnchorOpen() then
    QaBtn:CloseMenuAnchor()
    QaBtn:ResetStyle()
  end
end

function M:OnSacrificeOverlayOpen(bOpen)
  self.bSacrificeOverlayOpen = bOpen
  InventoryController.bOpenSacrificePopup = bOpen
  if bOpen and self.ServerUniqueId then
    InventoryController._SacrificePocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
  elseif not bOpen then
    InventoryController._SacrificePocketName = nil
  end
  if UIUtils.IsGamepadInput() then
    local MainWidget = InventoryController.MainWidget
    if MainWidget and MainWidget.BagSelect_Controller then
      local Vis = bOpen and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible
      MainWidget.BagSelect_Controller:SetVisibility(Vis)
    end
    if not bOpen and self.Parent and self.Parent.GamepadDetailHideKey then
      self.Parent:GamepadDetailHideKey(false)
    end
  end
  if bOpen and self.Parent and self.Parent.GamepadDetailHideKey then
    self.Parent:GamepadDetailHideKey(true)
  end
  if self.Parent and self.Parent.UpdateComTab then
    self.Parent:UpdateComTab(bOpen and "SacrificePopup" or "Normal")
  end
end

function M:CloseSelf()
  self:OnSacrificeOverlayOpen(false)
  if self.BPGambleMech and IsValid(self.BPGambleMech) and self.BPGambleMech.StateId ~= GAMBLE_MECH_STATE_TRIBUTE_SUCCESS then
    self.BPGambleMech:TributeCancle()
  end
  self:RemoveEvents()
  if not self:IsVisible() then
    return
  end
  if self.PocketWidget and IsValid(self.PocketWidget) then
    self.PocketWidget:Close()
  end
  local PocketName = InventoryCommonConst.SearchPocketNamePrefix .. self.ServerUniqueId
  local PocketData = InventoryController.InventoryModel.Pockets[PocketName]
  if PocketData then
    InventoryController:ClearPocketView(PocketName)
    PocketData.Pocket = nil
  end
  if not self.Out then
    return
  end
  self:PlayAnimation(self.Out)
  for _, Item in ipairs(self.SacrificeItemWidgets or {}) do
    if Item and IsValid(Item) then
      Item:CloseSelf()
    end
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.Collapsed)
    self.QAController:SetVisibility(ESlateVisibility.Collapsed)
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.QAController:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

return M

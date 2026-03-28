require("UnLua")
require("DataMgr")
local InventoryCommonConst = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryCommonConst")
local InventoryController = require("BluePrints.UI.WBP.SoloTreasure.Widget.Inventory.InventoryController")
local M = Class("BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Bag")
local ComTabStatePriority = {Normal = 1, Draging = 3}

function M:Construct()
  self.Super.Construct(self)
  self.GamepadCursorMoveSpeed = 30
  self.GamepadCursorLerpAlpha = 0.85
  self.GamepadCursorTargetPosition = UE4.FVector2D(0, 0)
  self.bGamepadInput = false
  self._CursorParentLocalSize = nil
  self.GamepadChangeDragItemDirectionTable = {}
  self._PendingComTabState = nil
  self._PendingComTabPriority = nil
  self.CurBottomKeyState = nil
  self.CurBottomKeyInfo = nil
  self.CurInputDevice = nil
  self._PendingBagDetailState = nil
  self._BagDetailStateScheduled = false
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self._BagDetailStateScheduled = nil
  self._PendingBagDetailState = nil
  self._PendingComTabState = nil
  self._PendingComTabPriority = nil
  self:UpdateComTab("Normal")
  self.Key_Search_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.SpecialLeft
      }
    }
  })
  self.OpenKey = CommonUtils:GetActionMappingKeyName("OpenBag")
  self:AddDelayFrameFunc(function()
    self:SetFocus()
    self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  end, 10, "PCSetFocus")
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem:SetNavigateWidgetVisibility(false)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    local NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget(false)
    if NavigateWidget then
      self._NavigateWidgetAudioEventPath = NavigateWidget.AudioEventPath
      NavigateWidget.AudioEventPath = ""
    end
  end
  self.ScrollBoxPockets:ScrollToStart()
end

function M:InitPCEvents()
  self:AddDispatcher(EventID.OnTreasureItemDragDetected, self, function()
    self:UpdateComTab("Draging")
  end)
  self:AddDispatcher(EventID.OnTreasureItemDrop, self, function()
    self.InventoryController:RequestUnSelected(self.InventoryController.SelectedItemWidget)
    self.InventoryController.bForbidAdsorption = true
    self:AddTimer(0.2, function()
      self.InventoryController.bForbidAdsorption = false
    end)
    self:UpdateComTab("Normal")
    if self.InventoryController.SelectedGridWidget and self.InventoryController.SelectedGridWidget:IsHovered() then
      self.InventoryController.SelectedGridWidget:OnHovered()
    end
  end)
  self:AddDispatcher(EventID.OnTreasureItemDragCancelled, self, function()
    self:UpdateComTab("Normal")
  end)
  self:AddDispatcher(EventID.GameViewportInputKeyReleased, self, function(_, Key)
    local InventoryController = self.InventoryController
    if not InventoryController then
      return
    end
    if Key.KeyName == "LeftMouseButton" then
      if InventoryController.DragWidget and InventoryController.bDraging then
        if self.Btn_Recycle and self.Btn_Recycle.CurState == InventoryCommonConst.RecycleBtnState.DragingOver then
          return
        end
        InventoryController:CustomOnDragCancelled()
      end
    elseif Key.KeyName == Const.GamepadFaceButtonDown then
      DebugPrint("lgc@InventoryController GameViewportInputKeyReleased  Key.KeyName =", Key.KeyName)
    end
    InventoryController.bDetectDrag = false
    InventoryController.StartDetectDragPos = nil
    InventoryController.StartDetectDragGrid = nil
  end)
end

function M:RemovePCEvents()
  self:RemoveDispatcher(EventID.OnTreasureItemDragDetected, self)
  self:RemoveDispatcher(EventID.OnTreasureItemDrop, self)
  self:RemoveDispatcher(EventID.OnTreasureItemDragCancelled, self)
  self:RemoveDispatcher(EventID.GameViewportInputKeyReleased, self)
  if self.GameInputModeSubsystem and self._NavigateWidgetAudioEventPath ~= nil then
    local NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget(false)
    if NavigateWidget then
      NavigateWidget.AudioEventPath = self._NavigateWidgetAudioEventPath
    end
    self._NavigateWidgetAudioEventPath = nil
  end
end

function M:OnReturnKeyDown()
  if InventoryController.bDraging then
    if InventoryController.CurDragEnterGridData then
      local Grid = InventoryController.CurDragEnterGridData.Grid
      if IsValid(Grid) then
        Grid:CustomOnDrop()
      end
    end
  elseif self.bInBagDetailState then
    self:LeaveBagDetailState()
  elseif self.Btn_Recycle and self.Btn_Recycle.bOpenRecycle then
    self.Btn_Recycle:OnClickBtnRecycle()
  else
    self:CloseSelf()
  end
end

local StateKeyHandlers = {
  Normal = {
    [Const.GamepadFaceButtonRight] = function(self)
      if self.Btn_Recycle and self.Btn_Recycle.bOpenRecycle then
        self.Btn_Recycle:OnClickBtnRecycle()
      else
        self:CloseSelf()
      end
      return true
    end,
    [Const.GamepadFaceButtonLeft] = function(self)
      local Grid = InventoryController.SelectedGridWidget
      if Grid and not Grid.bRecycle then
        local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
        return InventoryController:QuickTransferFromGrid(GridData, InventoryCommonConst.QuickTransferType.RightClick)
      end
    end,
    [Const.GamepadLeftThumbstick] = function(self)
      local Grid = InventoryController.SelectedGridWidget
      if not Grid then
        return
      end
      local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
      local TransferType = Grid.bRecycle and InventoryCommonConst.QuickTransferType.RightClick or InventoryCommonConst.QuickTransferType.AltAndRightClick
      return InventoryController:QuickTransferFromGrid(GridData, TransferType)
    end,
    [Const.GamepadFaceButtonUp] = function(self)
      local Grid = InventoryController.SelectedGridWidget
      if not Grid then
        return
      end
      local GridData = InventoryController:GetGridData(Grid.PocketData.Name, Grid.Position)
      if GridData and GridData.TreasureData and IsValid(GridData.TreasureData.Treasure) then
        GridData.TreasureData.Treasure:OpenItemDetailsWidget()
      end
      return true
    end,
    [Const.GamepadSpecialLeft] = function(self)
      self:OnBtnSearchPressed()
      return true
    end,
    [Const.GamepadLeftTrigger] = function(self)
      if self.Bag_Sacrifice and self.Bag_Sacrifice:IsVisible() then
        self.Bag_Sacrifice:OnLTKey()
      end
      return true
    end,
    [Const.GamepadLeftShoulder] = function(self)
      if self.CurBottomKeyState == "SacrificePopup" then
        return false
      end
      self.Btn_Recycle:OnClickBtnRecycle()
      return true
    end,
    [Const.GamepadFaceButtonRight] = function(self)
      if self.CurBottomKeyState == "SacrificePopup" then
        return false
      end
      if self.Btn_Recycle.bOpenSortDetail and self.Btn_Recycle.bOpenRecycle then
        self.Btn_Recycle:EnterSortDetail(false)
        return true
      end
    end
  },
  BagDetail = {
    [Const.GamepadFaceButtonRight] = function(self)
      self:LeaveBagDetailState()
      return true
    end
  },
  Draging = {
    [Const.GamepadFaceButtonRight] = function(self)
      if InventoryController.CurDragEnterGridData then
        local Grid = InventoryController.CurDragEnterGridData.Grid
        if IsValid(Grid) then
          Grid:CustomOnDrop()
        end
      end
      return true
    end,
    [Const.GamepadRightThumbstick] = function(self)
      InventoryController:GamepadChangeDragWidgetDirection()
      return true
    end
  },
  RecycleSort = {},
  SacrificePopup = {
    [Const.GamepadFaceButtonRight] = function(self)
      if self.Bag_Sacrifice and self.Bag_Sacrifice:IsVisible() then
        self.Bag_Sacrifice:OnCloseSacrificeOverlay()
      end
      return true
    end
  }
}

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self._BagDetailStateScheduled = nil
  self._PendingBagDetailState = nil
  if self.InventoryController.bDetectDrag then
    self.InventoryController.bDetectDrag = false
    self.InventoryController.bDetectDragIsMouse = false
    self.InventoryController.StartDetectDragGrid = nil
    self.InventoryController.StartDetectDragPos = nil
  end
  if self.InventoryController.bDraging then
    self.InventoryController:CustomOnDragCancelled(false)
  end
  if self.bInBagDetailState then
    self.bInBagDetailState = false
    self.Bag_Detail:PlayOutAnim()
    self.Btn_Search:SetHoldUp(false)
    self.Btn_Search:UnbindFromAnimationFinished(self.Btn_Search.Unhover)
    self.Btn_Search:PlayAnimation(self.Btn_Search.Normal)
    self.Com_KeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self.BagSelect_Controller:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.InventoryController._Adsorption = nil
    self.InventoryController.ForceAdsorption = false
    self.InventoryController.bForbidAdsorption = false
    self.InventoryController._MouseIdleTime = 0
    self.InventoryController._AdsorptionMoveDist = 0
  elseif CurInputDevice == ECommonInputType.Gamepad then
    local CursorSize = UE4.FVector2D(0, 0)
    self.BagSelect_Controller.Slot:SetSize(CursorSize)
    self.InventoryController._Adsorption = nil
    self.InventoryController.ForceAdsorption = false
    self.InventoryController.bForbidAdsorption = false
    self.InventoryController.bOpenItemDetails = false
    self.InventoryController._MouseIdleTime = 0
    self.InventoryController._AdsorptionMoveDist = 0
    self:AddDelayFrameFunc(function()
      if self and IsValid(self) and not self.InventoryController.bOpenItemDetails and not self.InventoryController.bOpenRecycleSortDetail and not self.bInBagDetailState then
        self.BagSelect_Controller:SetFocus()
        self.BagSelect_Controller:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:ResetCursorToCenter()
        self.InventoryController:RequestAdsorptionToFirstTreasure()
      end
    end, 10, "ShowBagSelect_Controller")
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.BagSelect_Controller.Slot.ZOrder <= 0 then
      self.BagSelect_Controller.Slot:SetZOrder(5)
    end
  end
  if self.InventoryController.SelectedItemWidget then
    self.InventoryController.SelectedItemWidget.HoverGrids = {}
    self.InventoryController:RequestUnSelected(self.InventoryController.SelectedItemWidget)
  end
  self:UpdateComTab("Normal")
  if self.Btn_Recycle and self.Btn_Recycle.RefreshOpInfoByInputDevice then
    self.Btn_Recycle:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  end
  if self.Bag_Sacrifice and self.Bag_Sacrifice:IsVisible() and self.Bag_Sacrifice.RefreshOpInfoByInputDevice then
    self.Bag_Sacrifice:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  end
end

function M:ResetCursorToCenter()
  if not self.BagSelect_Controller then
    return
  end
  local CursorParentGeometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
  local CursorParentLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorParentGeometry)
  if 0 == CursorParentLocalSize.X and 0 == CursorParentLocalSize.Y then
    return
  end
  self._CursorParentLocalSize = CursorParentLocalSize
  local CursorGeo = self.BagSelect_Controller:GetCachedGeometry()
  local CursorLocalSize = UE4.USlateBlueprintLibrary.GetLocalSize(CursorGeo)
  self.GamepadCursorTargetPosition = UE4.FVector2D(CursorParentLocalSize.X / 2 - CursorLocalSize.X / 2, CursorParentLocalSize.Y / 2 - CursorLocalSize.Y / 2)
  self.BagSelect_Controller:SetRenderTranslation(self.GamepadCursorTargetPosition)
end

function M:UpdateComTab(TargetState)
  local priority = ComTabStatePriority[TargetState] or 2
  if not self._PendingComTabPriority or priority >= self._PendingComTabPriority then
    self._PendingComTabState = TargetState
    self._PendingComTabPriority = priority
  end
end

function M:_DoUpdateComTab(TargetState)
  DebugPrint("lgc@_DoUpdateComTab", TargetState)
  local BottomKeyInfo = {}
  if "Normal" == TargetState then
    if UIUtils.IsKeyboardInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {
              Type = "Text",
              ImgShortPath = "LeftMouseButton"
            }
          },
          Desc = GText("UI_Keyboard_Map_ItemDetail")
        }
      }
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "RightMouseButton"
          }
        },
        Desc = GText("UI_Extraction_TM_3")
      })
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {Type = "Text", ImgShortPath = "LeftAlt"},
          {
            Type = "Text",
            ImgShortPath = "RightMouseButton"
          }
        },
        Desc = GText("UI_Extraction_PutItIntoRecycling"),
        Type = "Add"
      })
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "Escape",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      })
    elseif UIUtils.IsGamepadInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "A"}
          },
          Desc = GText("UI_CTL_Move")
        }
      }
      if self.InventoryController.SelectedItemWidget then
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "Y"}
          },
          Desc = GText("UI_Controller_CheckDetails")
        })
      end
      if self.InventoryController.SelectedItemWidget and not self.InventoryController.SelectedItemWidget.bInRecycleGrid then
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "X"}
          },
          Desc = GText("UI_Extraction_TM_3")
        })
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "LS"}
          },
          Desc = GText("UI_Extraction_PutItIntoRecycling")
        })
      end
      if self.InventoryController.SelectedItemWidget and self.InventoryController.SelectedItemWidget.bInRecycleGrid then
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "LS"}
          },
          Desc = GText("UI_Extraction_PutItIntoBackpack")
        })
      end
      if UIUtils.CheckScrollBoxCanScroll(self.ScrollBoxPockets) then
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "RV"}
          },
          Desc = GText("UI_Controller_Slide")
        })
      end
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK")
      })
      self:AddGamepadCursorOffset({X = 0.01, Y = 0.01}, true)
    end
  elseif "BagDetail" == TargetState then
    if UIUtils.IsKeyboardInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {
              Type = "Text",
              ImgShortPath = "LeftMouseButton"
            }
          },
          Desc = GText("UI_Keyboard_Map_ItemDetail")
        }
      }
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "RightMouseButton"
          }
        },
        Desc = GText("UI_Extraction_TM_3")
      })
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {Type = "Text", ImgShortPath = "LeftAlt"},
          {
            Type = "Text",
            ImgShortPath = "RightMouseButton"
          }
        },
        Desc = GText("UI_Extraction_PutItIntoRecycling"),
        Type = "Add"
      })
      table.insert(BottomKeyInfo, {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "Escape",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      })
    elseif UIUtils.IsGamepadInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "B"}
          },
          Desc = GText("UI_BACK")
        }
      }
    end
  elseif "Draging" == TargetState then
    if UIUtils.IsKeyboardInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {
              Type = "Text",
              ImgShortPath = "LeftMouseButton"
            }
          },
          Desc = GText("UI_Tips_Ensure")
        }
      }
    elseif UIUtils.IsGamepadInput() then
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "A"}
          },
          Desc = GText("UI_Tips_Ensure")
        }
      }
      local DragTreasureSize = InventoryController.StartDragGridData.TreasureData.Size
      if DragTreasureSize and DragTreasureSize.X ~= DragTreasureSize.Y then
        table.insert(BottomKeyInfo, {
          KeyInfoList = {
            {Type = "Img", ImgShortPath = "RS"}
          },
          Desc = GText("UI_Accessory_Custom_Rotation")
        })
      end
    end
  elseif "RecycleSort" == TargetState then
    if UIUtils.IsKeyboardInput() then
      BottomKeyInfo = {}
    elseif UIUtils.IsGamepadInput() then
      BottomKeyInfo = {
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
          Desc = GText("UI_BACK")
        }
      }
    end
  elseif "SacrificePopup" == TargetState and UIUtils.IsGamepadInput() then
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK")
      }
    }
  end
  if "RecycleSort" == TargetState or "BagDetail" == TargetState or "SacrificePopup" == TargetState then
    self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
  elseif not self.Btn_Recycle.bOpenSortDetail and not self.InventoryController.bOpenItemDetails and UIUtils.IsGamepadInput() then
    self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:AddGamepadCursorOffset({X = 0.01, Y = 0.01}, true)
  end
  local TargetInputDevice
  if UIUtils.IsKeyboardInput() then
    TargetInputDevice = "Keyboard"
  elseif UIUtils.IsGamepadInput() then
    TargetInputDevice = "Gamepad"
  end
  local bEqual = true
  if bEqual and self.CurBottomKeyInfo and #BottomKeyInfo ~= #self.CurBottomKeyInfo then
    bEqual = false
  end
  if bEqual then
    for Index, KeyInfo in ipairs(BottomKeyInfo) do
      if self.CurBottomKeyInfo and (KeyInfo.KeyInfoList[1].ImgShortPath ~= self.CurBottomKeyInfo[Index].KeyInfoList[1].ImgShortPath or KeyInfo.Desc ~= self.CurBottomKeyInfo[Index].Desc) then
        bEqual = false
        break
      end
    end
  end
  if not self.CurBottomKeyInfo then
    bEqual = false
  end
  if not bEqual then
    self.Com_KeyTips:UpdateKeyInfo(BottomKeyInfo)
  end
  self.CurBottomKeyInfo = BottomKeyInfo
  self.CurBottomKeyState = TargetState
  self.CurInputDevice = TargetInputDevice
end

function M:EnterTreasureDetailState(bEnter, bNotHideKeyTips)
  if bEnter then
    if not bNotHideKeyTips then
      self.Com_KeyTips:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.Btn_Recycle.Sort.Controller:SetVisibility(ESlateVisibility.Collapsed)
    self.BagSelect_Controller:SetVisibility(ESlateVisibility.Collapsed)
  elseif not bEnter then
    self.Com_KeyTips:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:UpdateComTab("Normal")
    if UIUtils.IsGamepadInput() then
      self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.Btn_Recycle.Sort.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.BagSelect_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
end

function M:EnterBagDetailState()
  self._PendingBagDetailState = true
  if self._BagDetailStateScheduled then
    return
  end
  self._BagDetailStateScheduled = true
  self:AddDelayFrameFunc(function()
    self._BagDetailStateScheduled = nil
    local TargetState = self._PendingBagDetailState
    self._PendingBagDetailState = nil
    if nil == TargetState then
      return
    end
    if TargetState then
      self:ApplyBagDetailState(true)
    else
      self:ApplyBagDetailState(false)
    end
  end, 1, "ApplyBagDetailState")
end

function M:LeaveBagDetailState()
  self._PendingBagDetailState = false
  if self._BagDetailStateScheduled then
    return
  end
  self._BagDetailStateScheduled = true
  self:AddDelayFrameFunc(function()
    self._BagDetailStateScheduled = nil
    local TargetState = self._PendingBagDetailState
    self._PendingBagDetailState = nil
    if nil == TargetState then
      return
    end
    if TargetState then
      self:ApplyBagDetailState(true)
    else
      self:ApplyBagDetailState(false)
    end
  end, 1, "ApplyBagDetailState")
end

function M:ApplyBagDetailState(bEnter)
  if bEnter then
    self.Super.EnterBagDetailState(self)
    self:EnterTreasureDetailState(true, true)
  else
    self.Super.LeaveBagDetailState(self)
    if not UIUtils.IsGamepadInput() then
      return
    end
    self:EnterTreasureDetailState(false)
  end
end

function M:GamepadDetailHideKey(bHide)
  if bHide then
    self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.Collapsed)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.Collapsed)
    self.Bag_Sacrifice.QAController:SetVisibility(ESlateVisibility.Collapsed)
    self.Bag_Sacrifice.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Btn_Recycle.Key_Recycle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Key_Search_GamePad:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Bag_Sacrifice.QAController:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Bag_Sacrifice.Btn_Scrifice.Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == Const.GamepadDPadUp then
      if self.Btn_Recycle and self.CurBottomKeyState == "Normal" then
        self.Btn_Recycle:OnDPadUpKey()
        IsEventHandled = true
      end
    elseif InKeyName == Const.GamepadDPadRight and self.CurBottomKeyState == "Normal" and self.Bag_Sacrifice and self.Bag_Sacrifice:IsVisible() then
      self.Bag_Sacrifice:OnDPadRightKey()
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    local CurState = self.CurBottomKeyState or "Normal"
    local Handlers = StateKeyHandlers[CurState]
    if Handlers and Handlers[InKeyName] then
      IsEventHandled = Handlers[InKeyName](self) or false
    end
    if not IsEventHandled and InKeyName == Const.GamepadFaceButtonRight then
      self:OnReturnKeyDown()
      IsEventHandled = true
    end
  elseif not IsEventHandled and "Escape" == InKeyName or InKeyName == self.OpenKey then
    self:OnReturnKeyDown()
    IsEventHandled = true
  end
  return IsEventHandled and UE4.UWidgetBlueprintLibrary.Handled() or UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == Const.GamepadFaceButtonDown then
    if InventoryController.SelectedGridWidget then
      DebugPrint("lgc@InventoryController OnKeyUp", InKeyName)
      InventoryController.SelectedGridWidget:OnMouseButtonUp(MyGeometry, InKeyEvent)
      IsEventHandled = true
    else
      DebugPrint("lgc@InventoryController not SelectedGridWidget", InKeyName)
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  if KeyName == UIConst.GamePadKey.LeftAnalogX then
    if InventoryController.ForceAdsorption then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local InputX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    local Deadzone = InventoryCommonConst.GamepadAnalogDeadzone or 0
    DebugPrint("lgc@LeftAnalogX", InputX, Deadzone)
    if Deadzone < math.abs(InputX) then
      local MoveX = InputX * self.GamepadCursorMoveSpeed
      self:AddGamepadCursorOffset({X = MoveX, Y = 0}, true)
    end
  elseif KeyName == UIConst.GamePadKey.LeftAnalogY then
    if InventoryController.ForceAdsorption then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    local InputY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    local Deadzone = InventoryCommonConst.GamepadAnalogDeadzone or 0
    if Deadzone < math.abs(InputY) then
      local MoveY = InputY * self.GamepadCursorMoveSpeed
      self:AddGamepadCursorOffset({X = 0, Y = MoveY}, true)
    end
  elseif KeyName == UIConst.GamePadKey.RightAnalogY then
    local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 21
    local CurScrollOffset = self.ScrollBoxPockets:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.ScrollBoxPockets:GetScrollOffsetOfEnd())
    self.ScrollBoxPockets:SetScrollOffset(ScrollOffset)
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:AddGamepadCursorOffset(Offset, bGamepadInput)
  if not self.BagSelect_Controller then
    return
  end
  local MaxLocal = self._CursorParentLocalSize
  if not MaxLocal then
    local Geometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
    MaxLocal = UE4.USlateBlueprintLibrary.GetLocalSize(Geometry)
    self._CursorParentLocalSize = MaxLocal
  end
  local CursorTargetPosition = self.GamepadCursorTargetPosition
  CursorTargetPosition.X = math.clamp(CursorTargetPosition.X + Offset.X, 0, MaxLocal.X)
  CursorTargetPosition.Y = math.clamp(CursorTargetPosition.Y - Offset.Y, 0, MaxLocal.Y)
  self.bGamepadInput = bGamepadInput
  if bGamepadInput and self.InventoryController then
    local dx = Offset.X or 0
    local dy = Offset.Y or 0
    local dist = math.sqrt(dx * dx + dy * dy)
    self.InventoryController._AdsorptionMoveDist = (self.InventoryController._AdsorptionMoveDist or 0) + dist
  end
end

function M:CalculateGamepadCursorAbsoluteLimitPosition()
  local Geometry = self.BagSelect_Controller:GetParent():GetCachedGeometry()
  local MinAbsolutePosition = UE4.UUIFunctionLibrary.GetGeometryAbsolutePosition(Geometry)
  local AbsoluteSize = UE4.USlateBlueprintLibrary.GetAbsoluteSize(Geometry)
  local MaxAbsolutePosition = UE4.FVector2D(MinAbsolutePosition.X + AbsoluteSize.X, MinAbsolutePosition.Y + AbsoluteSize.Y)
  return MinAbsolutePosition, MaxAbsolutePosition
end

function M:UpdateGamepadCursorPosition()
  if not UIUtils.IsGamepadInput() then
    return
  end
  if InventoryController.bOpenItemDetails or InventoryController.bOpenRecycleSortDetail or InventoryController.bOpenSacrificePopup then
    return
  end
  local Current = self.BagSelect_Controller.RenderTransform.Translation
  local Target = self.GamepadCursorTargetPosition
  if Current.X == Target.X and Current.Y == Target.Y then
    return
  end
  self.BagSelect_Controller:SetFocus()
  local Alpha = self.GamepadCursorLerpAlpha
  local New = UE4.FVector2D(Current.X + (Target.X - Current.X) * Alpha, Current.Y + (Target.Y - Current.Y) * Alpha)
  self.BagSelect_Controller:SetRenderTranslation(New)
end

return M

require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local WalnutBagController = require("BluePrints.UI.WBP.Walnut.WalnutBag.WalnutBagController")
local WalnutBagModel = WalnutBagController:GetModel()
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self:AddDispatcher(EventID.OnDungeonsUpdate, self, self.OnDungeonsUpdate)
  self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self:AddInputMethodChangedListen()
end

function M:OnDungeonsUpdate()
  self:InitContent()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  self.WBP_Com_BtnExplanation:UpdateUIStyleInPlatform(not IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    return
  else
    local WalnutRewardDialog = UIManager(self):GetUI("WalnutRewardDialog")
    if WalnutRewardDialog then
      return
    end
    local CommonDialog = UIManager(self):GetUI("CommonDialog")
    if CommonDialog then
      CommonDialog:SetFocus()
    else
      self:FocusList_WalnutItem()
    end
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:FocusList_WalnutItem()
  self:UpdatKeyDisplay()
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:FocusList_WalnutItem()
  local ItemData = self.List_Walnut:GetItemAt(0)
  if ItemData.SelfWidget then
    ItemData.SelfWidget:SetFocus()
  else
    self.List_Walnut:NavigateToIndex(0)
  end
end

function M:UpdateTimeCountDown()
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.LeftTimeDict)
  self.Text_WalnutTime:SetText(GText("UI_Walnut_Dungeon_Refresh"))
  self.Com_Time:SetTimeText(GText("UI_Walnut_Dungeon_Refresh"), RemainTimeDict)
end

function M:InitContent(Parent)
  self.List_Walnut:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  if Parent then
    self.Parent = Parent
  end
  local WalnutSelectDungeonData = {}
  local DungeonIdMap = {}
  self.ValidWalnutDungeons = Avatar.Walnuts.ValidWalnutDungeons
  self.LeftTimeDict = WalnutBagModel:GetDungeonNextRefreshTime()
  if self:IsExistTimer("UpdateTimeContent") then
    self:RemoveTimer("UpdateTimeContent")
  end
  self:UpdateTimeCountDown()
  self:AddTimer(1.0, self.UpdateTimeCountDown, true, 0, "UpdateTimeContent", true)
  for WalnutType, DungeonIds in pairs(self.ValidWalnutDungeons) do
    local DungeonData = DataMgr.WalnutSelectDungeon[WalnutType]
    if DungeonData then
      table.insert(WalnutSelectDungeonData, DungeonData)
      DungeonIdMap[WalnutType] = DungeonIds
    end
  end
  table.sort(WalnutSelectDungeonData, function(A, B)
    return A.Sequence < B.Sequence
  end)
  for i, DungeonData in ipairs(WalnutSelectDungeonData) do
    local Content = NewObject(self.LevelCellContentClass)
    Content.DungeonData = DungeonData
    Content.DungeonIds = DungeonIdMap[DungeonData.WalnutType]
    Content.Parent = self
    self.List_Walnut:AddItem(Content)
  end
  self:FocusList_WalnutItem()
  self:UpdatKeyDisplay()
  self:InitBtnExplanation()
end

function M:InitBtnExplanation()
  local BtnExplanationConfigData = {}
  BtnExplanationConfigData.ClickCallback = self.OnBtnExplanationClickCallback
  BtnExplanationConfigData.OwnerWidget = self
  BtnExplanationConfigData.PopupId = 100224
  BtnExplanationConfigData.Desc = "UI_Walnut_Gacha_Des"
  self.WBP_Com_BtnExplanation:Init(BtnExplanationConfigData)
  self.WBP_Com_BtnExplanation.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
end

function M:OnBtnExplanationClickCallback()
  print("lgc@ OnBtnExplanationClickCallback")
end

function M:UpdatKeyDisplay()
  local Item = UIManager(self):GetUIObj("StyleOfPlay")
  if not Item then
    return
  end
  local BottomKeyInfo = {}
  local ItemUIs = self.List_Walnut:GetDisplayedEntryWidgets()
  local RestCount = UIUtils.GetListViewContentMaxCount(self.List_Walnut, ItemUIs, false) - self.List_Walnut:GetNumItems()
  if RestCount >= 0 then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Parent.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  else
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "RH",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_Slide"),
        bLongPress = false
      },
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Parent.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  end
  Item:UpdateOtherPageTab(BottomKeyInfo)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 2
    local CurScrollOffset = self.List_Walnut:GetScrollOffset()
    self.List_Walnut:SetScrollOffset(CurScrollOffset + a)
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    local CommonDialog = UIManager(self):GetUI("CommonDialog")
    if not CommonDialog then
      self.WBP_Com_BtnExplanation:OnBtnClick()
    else
      CommonDialog:SetFocus()
    end
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

return M

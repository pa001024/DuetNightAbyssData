require("UnLua")
local UIUtils = require("Utils.UIUtils")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local View = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function View:Construct()
  self.List_Equipment:Disablescroll(true)
  
  function self.OpenEquipmentCallbackFunction()
    AudioManager(self):PlayUISound(self, "event:/ui/common/combat_bag_cell_place_common", nil, nil)
    local EquipmentUI = UIManager(self):LoadUINew("AutoChessChooseEquip", self.ChessData, self.ParentWidget)
    if EquipmentUI then
      EquipmentUI:SetFocus()
    end
    if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
      CommonUtils:CloseGuideTouchIfExist(self)
    end
  end
  
  if self.EMScrollBox then
    self.EMScrollBox:SetControlScrollbarInside(true)
  end
end

function View:InitView(ParentWidget)
  self.ParentWidget = ParentWidget
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
end

function View:InitInfo(Item_01, Item_02)
  self.Equipment_01 = Item_01
  self.Equipment_02 = Item_02
end

function View:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function View:InitGamepadView()
  if self.EMScrollBox then
    self.EMScrollBox:SetControlScrollbarInside(false)
    self.EMScrollBox:SetScrollBarVisibility(ESlateVisibility.Visible)
  end
end

function View:InitKeyboardView()
  if self.EMScrollBox then
    self.EMScrollBox:SetScrollBarVisibility(ESlateVisibility.Collapsed)
    self.EMScrollBox:SetControlScrollbarInside(true)
  end
end

function View:RefreshDetails(AutoChessData, OverrideEquips, bIsEnemy)
  self.ChessData = AutoChessData
  local CombatChessData = DataMgr.CombatChessInfo[AutoChessData.Id]
  self.Text_Name:SetText(GText(CombatChessData.CombatChessName))
  if CombatChessData.PositionIcon then
    local ImgType = LoadObject(CombatChessData.PositionIcon)
    self.Icon_Type.Icon:SetBrushFromTexture(ImgType)
  end
  self.Text_CostDesc:SetText(GText("UI_AutoChess_MonsterCost"))
  self.Text_Cost:SetText(CombatChessData.DeployCost)
  self.TextTipsName:SetText(GText("UI_AutoChess_MonsterType"))
  self.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), AutoChessData.Atk)
  self.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), AutoChessData.MaxHp)
  self.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), AutoChessData.Def)
  self.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), AutoChessData.MaxEs)
  self.List_Equipment:ClearListItems()
  self:RefreshPassiveEffects(CombatChessData)
  local EquipInfos = OverrideEquips or AutoChessData.EquipItems
  for Index, EquipId in ipairs(EquipInfos) do
    local EquipData = DataMgr.RobotEquip[EquipId]
    if EquipData then
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      Obj.EffectText = AutoChessDataModel:CalcEquipExtraDesc(EquipId)
      self.List_Equipment:AddItem(Obj)
    end
  end
  self:UpdateEquipInfo(EquipInfos, bIsEnemy)
  if self.EMScrollBox then
    self.EMScrollBox:ScrollToStart()
  end
end

function View:OpenEquipment()
  self.OpenEquipmentCallbackFunction()
end

function View:UpdateEquipInfo(EquipItems, bIsEnemy)
  local function _UpdateSingleEquipInfo(EquipId, EquipIndex)
    local Widget = self:GetEquipWidgetByIndex(EquipIndex)
    
    if Widget then
      local AutoChessEquipData = DataMgr.RobotEquip[EquipId]
      if AutoChessEquipData then
        local Content = {}
        Content.Id = EquipId
        Content.Rarity = AutoChessEquipData.EquipRarity
        Content.ItemType = "RobotEquip"
        Content.Icon = AutoChessEquipData.EquipIcon
        Content.CurrencyIcon = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Activity/AutoChess/T_Activity_AutoChess_IconCost.T_Activity_AutoChess_IconCost'"
        Content.CurrencyNum = AutoChessEquipData.DeployCost
        if not bIsEnemy then
          Content.OnMouseButtonDownEvent = {
            Obj = self,
            Callback = self.OpenEquipmentCallbackFunction
          }
        else
          Content.NotInteractive = true
        end
        Widget:Init(Content)
      end
    end
  end
  
  for Index, Equip in ipairs(EquipItems) do
    _UpdateSingleEquipInfo(Equip, Index)
  end
  for i = #EquipItems + 1, 2 do
    local Widget = self:GetEquipWidgetByIndex(i)
    if Widget then
      local Content = {
        bAdd = true,
        OnMouseButtonDownEvent = {
          Obj = self,
          Callback = function()
            if bIsEnemy then
              return
            end
            AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
            UIManager(self):LoadUINew("AutoChessChooseEquip", self.ChessData, self)
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
              CommonUtils:CloseGuideTouchIfExist(self)
            end
          end
        }
      }
      Widget:Init(Content)
    end
  end
end

function View:GetEquipWidgetByIndex(EquipIndex)
  if 1 == EquipIndex then
    return self.Equipment_01
  elseif 2 == EquipIndex then
    return self.Equipment_02
  end
  return nil
end

function View:RefreshPassiveEffects(CombatChessData)
  local BuffDescKey = CombatChessData.MonsterExtraBuffDesc
  if not BuffDescKey or "" == BuffDescKey then
    return
  end
  local EffectText = GText(BuffDescKey)
  if not EffectText or "" == EffectText then
    return
  end
  EffectText = AutoChessDataModel:CalcDescCommom(CombatChessData, EffectText)
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.EffectText = EffectText
  Obj.bGreen = true
  self.List_Equipment:AddItem(Obj)
end

function View:ScrollEquipmentList(AddOffset)
  if not self.EMScrollBox then
    return
  end
  local CurScrollOffset = self.EMScrollBox:GetScrollOffset()
  local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.EMScrollBox:GetScrollOffsetOfEnd())
  self.EMScrollBox:SetScrollOffset(ScrollOffset)
end

function View:AdjustScrollable()
  local ContentHeight = self.List_Equipment:GetDesiredSize().Y
  local VisibleHeight = USlateBlueprintLibrary.GetLocalSize(self.List_Equipment:GetTickSpaceGeometry()).Y
  self.LastVisibleHeight = self.LastVisibleHeight or VisibleHeight
  if 0 == VisibleHeight then
    self:AddTimer(0.001, self.AdjustScrollable, false, 0, "WBP_AutoChessMonsterDetails2_AdjustScrollable", true)
    return nil
  elseif math.abs(VisibleHeight - self.LastVisibleHeight) > 0.001 then
    self.LastVisibleHeight = VisibleHeight
    self:AddTimer(0.001, self.AdjustScrollable, false, 0, "WBP_AutoChessMonsterDetails2_AdjustScrollable", true)
    return nil
  end
  if ContentHeight - VisibleHeight > 0.001 then
    self.List_Equipment:DisableScroll(false)
    return true
  else
    self.List_Equipment:DisableScroll(true)
    return false
  end
end

return View

require("UnLua")
local MonsterUtils = require("Utils.MonsterUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.Super.Construct(self)
  self:AddInputMethodChangedListen()
  if self.Button_Area then
    self.Button_Area.OnClicked:Add(self, self.OnClicked)
  end
  self.List_EliteProp.OnCreateEmptyContent:Bind(self, self.CreateAndAddEmptyItem)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.IsEmpty = Content.IsEmpty
  if not self.IsEmpty then
    self.Root = Content.Root
    self.Parent = Content.Parent
    self.DungeonData = Content.DungeonData
    self.MonRewardData = Content.MonRewardData
  end
  self:InitItemContent()
end

function M:InitItemContent()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  self.IsEnter = false
  if self.IsEmpty then
    self.WS_Item:SetActiveWidgetIndex(1)
    self:PlayAnimation(self.In)
    self.bIsFocusable = false
    self:SetVisibility(ESlateVisibility.HitTestInvisible)
    return
  end
  self.bIsFocusable = true
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.List_EliteProp:ClearListItems()
  local InputType = UIUtils.UtilsGetCurrentInputType()
  local IsGamepad = InputType == ECommonInputType.Gamepad
  self.List_EliteProp:SetVisibility(IsGamepad and ESlateVisibility.HitTestInvisible or ESlateVisibility.SelfHitTestInvisible)
  if self.MonRewardData then
    self:PlayAnimation(self.In)
    local IsLocked = not PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition)
    self.IsUnLocked = IsLocked
    self:PlayAnimation(IsLocked and self.Locked or self.Normal)
    local MonsterData = DataMgr.Monster[self.MonRewardData.MonsterUnitId]
    local MonsterInfo = {
      WeaknessIcon = self:GetMonsterWeaknessIcon(self.MonRewardData.MonsterUnitId)
    }
    self.Monster_Elite:SetBasicData(self.MonRewardData.MonsterUnitId, MonsterInfo)
    self.Monster_Elite:SetVisibility(ESlateVisibility.HitTestInvisible)
    self:RefreshRewardInfoList(self.MonRewardData.DungeonRewardView)
  end
end

function M:GetMonsterWeaknessIcon(MonsterId)
  local MonsterWeaknessIcon = self.MonsterWeaknessIconCache or {}
  self.MonsterWeaknessIconCache = MonsterWeaknessIcon
  if MonsterWeaknessIcon[MonsterId] then
    return MonsterWeaknessIcon[MonsterId]
  end
  local AllBuffs = MonsterUtils.GetRealMonsterBuffs(self.MonRewardData.DungeonList[1], MonsterId)
  for _, BuffId in ipairs(AllBuffs) do
    local BuffInfo = DataMgr.Buff[BuffId]
    if BuffInfo and BuffInfo.WeaknessType then
      local WeaknessIcon = DataMgr.DamageType[BuffInfo.WeaknessType] and DataMgr.DamageType[BuffInfo.WeaknessType].WeaknessIcon
      if WeaknessIcon then
        MonsterWeaknessIcon[MonsterId] = MonsterWeaknessIcon[MonsterId] or {}
        MonsterWeaknessIcon[MonsterId][WeaknessIcon] = true
      end
    end
  end
  return MonsterWeaknessIcon[MonsterId]
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    if self.Com_Reward then
      self.Com_Reward:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.List_EliteProp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.IsEnter then
      self:PlayAnimation(self.Unhover)
    else
    end
  end
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:OnClicked()
  if self.IsUnLocked or self:IsAnimationPlaying(self.In) then
    PageJumpUtils:CheckDungeonCondition(self.MonRewardData.Condition, true)
    return
  end
  local Item = UIManager(self):GetUIObj("StyleOfPlay")
  Item.IsOpenSelectLevel = false
  local SelectLevel = Item:OpenSubUI("DungeonSelect")
  local DungeonList = self.MonRewardData.DungeonList
  SelectLevel:SetNightFlightManualRewardView(self.MonRewardData.DungeonRewardView)
  SelectLevel:InitLevelList(DungeonList, nil, Const.DeputeType.NightFlightManualDepute, nil)
  Item:InitOtherPageTab({
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Add"},
          GamePadSubKeyInfoList = {
            {
              Type = "Img",
              ImgShortPath = "Up",
              Owner = SelectLevel
            },
            {
              Type = "Img",
              ImgShortPath = "Y",
              Owner = SelectLevel
            }
          }
        },
        Desc = GText("UI_CTL_DeputeInfo"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = SelectLevel.OnReturnKeyDown,
            Owner = SelectLevel
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = SelectLevel
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = SelectLevel,
    BackCallback = SelectLevel.OnReturnKeyDown,
    StyleName = "Text",
    TitleName = GText("UI_Dungeon_Tab_ModDungeon")
  }, nil, true)
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.IsEmpty then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:OnClicked()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:RefreshRewardInfoList(DungeonReward)
  if not DungeonReward then
    return
  end
  local RewardList = RewardUtils:GetRewardViewInfoById(DungeonReward)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  for _, ItemData in pairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, ItemData.Type)
    Content.ParentWidget = self
    Content.ItemType = ItemData.Type
    Content.Rarity = ItemData.Rarity or 1
    Content.IsShowDetails = true
    Content.UIName = "StyleOfPlay"
    if ItemData.DropType then
      Content.bRare = DataMgr.DropProbType[ItemData.DropType].IsRareItem
    end
    if ItemData.Quantity then
      Content.Count = ItemData.Quantity[1]
      Content.MaxCount = ItemData.Quantity[2] or nil
    end
    Content.bShadow = false
    if Content.ItemType == "Mod" then
      local ModModel = ModController:GetModel()
      Content.bShadow = ModModel:GetModCountById(Content.Id) <= 0
    elseif Content.ItemType == "Walnut" then
      local WalnutsInBag = Avatar.Walnuts.WalnutBag
      Content.bShadow = (WalnutsInBag[Content.Id] or 0) <= 0
    end
    Content.List = self.List_EliteProp
    Content.OnAddedToFocusPathEvent = {
      Obj = Content,
      Callback = function(Content)
        self.ParentPage:OnItemFocus(Content)
      end
    }
    self.List_EliteProp:AddItem(Content)
  end
  if self:IsExistTimer(self.NextFrameListEmpty) then
    self:RemoveTimer(self.NextFrameListEmpty)
  end
  self.NextFrameListEmpty = self:AddTimer(0.01, function()
    self.List_EliteProp:RequestFillEmptyContent()
  end, false, 0, "DeputeDetailListView")
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Id = 0
  return Content
end

function M:OnStuffMenuOpenChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if bIsOpen then
    self:UpdatKeyDisplay("")
  else
    self:UpdatKeyDisplay("RewardWidget")
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In and self.IsEnter then
    if self.IsUnLocked or self.Mobile or self.IsEmpty or UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
      return
    end
    self:StopAllAnimations()
    self:PlayAnimation(self.Hover)
  end
end

return M

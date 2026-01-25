require("UnLua")
local GachaCommon = require("BluePrints.UI.WBP.Gacha.GachaCommon")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})

function M:Construct()
end

function M:OnListItemObjectSet(Content)
  local ProbabilityText = "Probability"
  local Probability
  if 5 == Content.GachaItemRarity then
    ProbabilityText = ProbabilityText .. "Gold"
    Probability = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText] or 0
  elseif 4 == Content.GachaItemRarity then
    ProbabilityText = ProbabilityText .. "Purple"
    Probability = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText] or 0
  else
    local Probability5 = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText .. "Gold"] or 0
    local Probability4 = DataMgr.GachaProbability[DataMgr.SkinGacha[Content.GachaId].ProbabilityId][ProbabilityText .. "Purple"] or 0
    Probability = GachaCommon.GACHA_PROBABILITY_BASE - Probability5 - Probability4
  end
  local Rate = math.min(math.max(Probability / GachaCommon.GACHA_PROBABILITY_BASE, 0), 1) * 100
  if 5 == Content.GachaItemRarity then
    self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Gold"), Rate))
  elseif 4 == Content.GachaItemRarity then
    self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Purple"), Rate))
  elseif 3 == Content.GachaItemRarity then
    self.Text_Title:SetText(string.format(GText("UI_SkinGacha_Blue"), Rate))
  end
  self.List_Probability:ClearChildren()
  for _, ItemData in ipairs(Content.ItemLst) do
    local Probability = math.min(math.max(ItemData.Probability / GachaCommon.GACHA_PROBABILITY_BASE, 0), 1) * 100
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local Type = GachaCommon.GachaItemTypeMap[ItemData.Type]
    Content.Id = ItemData.Id
    Content.Icon = ItemUtils.GetItemIconPath(ItemData.Id, Type)
    Content.ParentWidget = self
    Content.ItemType = Type
    if "Skin" == Type or "CharAccessory" == Type or "WeaponSkin" == Type or "WeaponAccessory" == Type or "Resource" == Type and DataMgr.Resource[ItemData.Id].ResourceSType == "GestureItem" then
    else
      Content.Count = ItemData.Count
    end
    Content.Rarity = DataMgr[Type][ItemData.Id].Rarity or 1
    Content.IsShowDetails = true
    Content.bDisableCommonClick = true
    Content.OnMouseButtonUpEvents = {
      Obj = self,
      Callback = function()
        if Content.ItemType == "Skin" then
          PageJumpUtils:CloseFrontDialog()
          UIManager(self):LoadUINew("ArmorySkin", {
            Type = "Char",
            SkinId = Content.Id,
            OnCloseCallback = function()
              local GachaMain = UIManager(self):GetUIObj("GachaMain")
              if GachaMain then
                GachaMain:OnClickBtnDetails()
              end
            end
          })
        elseif Content.ItemType == "WeaponSkin" then
          PageJumpUtils:CloseFrontDialog()
          UIManager(self):LoadUINew("ArmorySkin", {
            Type = "Weapon",
            SkinId = Content.Id,
            OnCloseCallback = function()
              local GachaMain = UIManager(self):GetUIObj("GachaMain")
              if GachaMain then
                GachaMain:OnClickBtnDetails()
              end
            end
          })
        end
      end
    }
    Content.JumpReturnCallBack = {
      CallBack = function()
        local GachaMain = UIManager(self):GetUIObj("GachaMain")
        if GachaMain then
          GachaMain:OnClickBtnDetails()
        end
      end
    }
    Content.HandleMouseDown = true
    Content.UIName = "GachaMain"
    local Widget = UIManager(self):_CreateWidgetNew("ComItemUniversalM")
    self.List_Probability:AddChild(Widget)
    Widget:Init(Content)
  end
  self:AddDelayFrameFunc(function()
    self:SetupLazyNavigation()
  end, 1)
end

function M:GetWrapBoxItemsPerRow(WrapBox)
  if not WrapBox then
    return 0
  end
  local ChildCount = WrapBox:GetChildrenCount()
  if 0 == ChildCount then
    return 0
  end
  local FirstChild = WrapBox:GetChildAt(0)
  local FirstGeo = FirstChild:GetCachedGeometry()
  local FirstPos = UE4.USlateBlueprintLibrary.GetLocalTopLeft(FirstGeo)
  local FirstY = FirstPos.Y
  local Count = 1
  for i = 1, ChildCount - 1 do
    local Child = WrapBox:GetChildAt(i)
    local ChildGeo = Child:GetCachedGeometry()
    local CurrentPos = UE4.USlateBlueprintLibrary.GetLocalTopLeft(ChildGeo)
    local CurrentY = CurrentPos.Y
    if math.abs(CurrentY - FirstY) > 5.0 then
      break
    end
    Count = Count + 1
  end
  return Count
end

function M:HandleNavigation(ChildIndex, Direction)
  local WrapBox = self.List_Probability
  if not WrapBox or not UE4.UKismetSystemLibrary.IsValid(WrapBox) then
    return nil
  end
  local ItemsPerRow = self:GetWrapBoxItemsPerRow(WrapBox)
  if ItemsPerRow <= 0 then
    return nil
  end
  local ChildCount = WrapBox:GetChildrenCount()
  if "Down" == Direction then
    local TargetIndex = ChildIndex + ItemsPerRow
    if ChildCount > TargetIndex then
      return WrapBox:GetChildAt(TargetIndex)
    end
  elseif "Up" == Direction then
    local TargetIndex = ChildIndex - ItemsPerRow
    if TargetIndex >= 0 then
      return WrapBox:GetChildAt(TargetIndex)
    end
  elseif "Left" == Direction then
    local bIsRowStart = 0 == ChildIndex % ItemsPerRow
    local TargetIndex = ChildIndex - 1
    if not bIsRowStart and TargetIndex >= 0 then
      return WrapBox:GetChildAt(TargetIndex)
    end
  elseif "Right" == Direction then
    local bIsRowEnd = 0 == (ChildIndex + 1) % ItemsPerRow
    local TargetIndex = ChildIndex + 1
    if not bIsRowEnd and ChildCount > TargetIndex then
      return WrapBox:GetChildAt(TargetIndex)
    end
  end
  return nil
end

function M:SetupLazyNavigation()
  local WrapBox = self.List_Probability
  if not WrapBox or not UE4.UKismetSystemLibrary.IsValid(WrapBox) then
    return
  end
  local ChildCount = WrapBox:GetChildrenCount()
  if 0 == ChildCount then
    return
  end
  local ItemsPerRow = self:GetWrapBoxItemsPerRow(WrapBox)
  if ItemsPerRow <= 0 then
    return
  end
  for i = 0, ChildCount - 1 do
    local Child = WrapBox:GetChildAt(i)
    local DownIndex = i + ItemsPerRow
    if ChildCount > DownIndex then
      Child:SetNavigationRuleCustom(UE4.EUINavigation.Down, function()
        return self:HandleNavigation(i, "Down")
      end)
    end
    local UpIndex = i - ItemsPerRow
    if UpIndex >= 0 then
      Child:SetNavigationRuleCustom(UE4.EUINavigation.Up, function()
        return self:HandleNavigation(i, "Up")
      end)
    end
    Child:SetNavigationRuleCustom(UE4.EUINavigation.Left, function()
      return self:HandleNavigation(i, "Left")
    end)
    Child:SetNavigationRuleCustom(UE4.EUINavigation.Right, function()
      return self:HandleNavigation(i, "Right")
    end)
  end
end

function M:BP_GetDesiredFocusTarget()
  return self.List_Probability:GetChildAt(0)
end

return M

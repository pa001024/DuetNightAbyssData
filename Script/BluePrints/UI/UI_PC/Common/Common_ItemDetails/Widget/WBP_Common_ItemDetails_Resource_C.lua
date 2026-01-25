require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:InitItemInfo(ItemType, ItemId, UnitId, Content)
  Content = Content or {}
  self.JumpReturnCallBack = Content and Content.JumpReturnCallBack
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Collapsed)
  if "Tips" == ItemType then
    self:InitTipsInfo(self.ParentWidget.Content)
    return
  end
  self:SetFocus()
  if "TreasureGroup" == ItemType then
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    local TreasureGroupInfo = DataMgr[ItemType][ItemId]
    if not self.ParentWidget.Content.bGuide then
      if self.ParentWidget.Content.bActive then
        self.Text_Describe:SetText(GText("已激活"))
      else
        self.Text_Describe:SetText(GText("未激活"))
      end
    else
      self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_LongDescribe:SetText(GText(TreasureGroupInfo.GroupEffectDesc))
    return
  end
  if "CharPartMesh" == ItemType or "Skin" == ItemType or "WeaponSkin" == ItemType or "Title" == ItemType or "TitleFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应CharPartMesh信息：", ItemType, ItemId)
    local CharPartMeshInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if "WeaponSkin" == ItemType then
      self.Text_Describe:SetText(GText(CharPartMeshInfo.Dec))
    else
      self.Text_Describe:SetText(GText(CharPartMeshInfo.Des))
    end
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  if "CharAccessory" == ItemType or "WeaponAccessory" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local CharAccessoryInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if CharAccessoryInfo.AccessoryType then
      assert(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType], "未知的配饰部位：" .. CharAccessoryInfo.AccessoryType)
      self.Text_Describe:SetText(GText(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType]))
      self.Text_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_LongDescribe:SetText(GText(CharAccessoryInfo.Des))
    if not self.ParentWidget.Content.bCustomStype then
      local CallBack = {
        ButtonClickCallBack = function()
          if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
          else
            PageJumpUtils:CloseFrontDialog()
            UIManager(self):LoadUINew("ArmorySkin", {
              Type = string.sub(ItemType, 1, string.find(ItemType, "Accessory") - 1),
              AccessoryId = ItemId,
              OnCloseCallback = self.JumpReturnCallBack and self.JumpReturnCallBack.CallBack
            })
          end
        end,
        ButtonClickText = "UI_Preview_Title",
        ButtonIcon = 1
      }
      self.ParentWidget:InitButtonEvent(CallBack)
    end
    return
  end
  if "HeadSculpture" == ItemType or "HeadFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local HeadInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if "HeadSculpture" == ItemType then
      self.Text_Describe:SetText(GText("UI_HeadFrame_Head"))
    else
      self.Text_Describe:SetText(GText("UI_HeadFrame_Frame"))
    end
    self.Text_LongDescribe:SetText(GText(HeadInfo.Des))
    return
  end
  if "RougeLikeBlessing" == ItemType or "RougeLikeTreasure" == ItemType then
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    local Desc
    if "RougeLikeBlessing" == ItemType then
      if ItemId then
        local RougeLikeManager = GWorld.RougeLikeManager
        local Level = math.max(RougeLikeManager:GetBlessingLevel(ItemId) - 1, 0)
        Desc = UIUtils.GenRougeBlessingDesc(ItemId, Level)
      else
        Desc = "RLBlessingGroup_Desc_unknown"
      end
    elseif "RougeLikeTreasure" == ItemType then
      if ItemId then
        Desc = UIUtils.GenRougeTreasureDesc(ItemId)
      else
        Desc = "RLTreasure_Desc_Unknown"
      end
    end
    self.Text_Describe:SetText(GText(Desc))
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  if "Resource" == ItemType and DataMgr.LimitedTimeResource[ItemId] then
    local LimitedData = ItemUtils.GetItemLimitedInfo(ItemId)
    if LimitedData then
      local diff = os.difftime(LimitedData.EndTime, TimeUtils.NowTime())
      if diff < 86400 then
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
      else
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
      end
      self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Visible)
      local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime, TimeUtils.NowTime())
      self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
      self.Text_Expiration:SetText(GText("UI_Date_End"))
      self.Time_Expiration:SetTimeText(LimitedData.EndTime, UIConst.EnumTimeStyleType.YMDAndHMS)
    end
  end
  if Content.ResourceSType == "MountItem" then
    self:FreshMountInfo(ItemId)
  end
  local ResourceInfo = DataMgr.Resource[ItemId]
  if ResourceInfo.Type == "Read" then
    local Content = {
      ButtonClickCallBack = function()
        local CommonDialog = UIManager(self):GetUI("CommonDialog")
        if CommonDialog then
          CommonDialog:Close()
        end
        UIManager(self):LoadUINew("ItemInformation", ItemId, "Read", self)
      end,
      ButtonClickText = "UI_BAG_Read",
      ButtonIcon = 1
    }
    self.ParentWidget:InitButtonEvent(Content)
  end
  if ResourceInfo.HoldDisplayRule == "Hide" then
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Visible)
  end
  local PlayerAvatar = GWorld:GetAvatar()
  if type(ItemId) == "string" then
    ItemId = math.tointeger(ItemId)
  end
  local ResourceServerData = PlayerAvatar.Resources[ItemId]
  self.Text_Describe:SetVisibility(ResourceInfo.FunctionDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.Text_LongDescribe:SetVisibility(nil == ResourceInfo.DetailDes and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.Text_Describe:SetText(GText(ResourceInfo.FunctionDes))
  self.Text_LongDescribe:SetText(GText(ResourceInfo.DetailDes))
  local Count = 0
  if ResourceServerData then
    Count = ResourceServerData.Count
  end
  if ResourceInfo.HoldDisplayRule == "ActionPoint" then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    Count = Avatar.ActionPoint
  end
  self.ParentWidget.Text_Hold02:SetText(Count)
end

function M:InitTipsInfo(ItemInfo)
  local Itemdata = DataMgr[ItemInfo.Type][ItemInfo.ItemId]
  self.ParentWidget:InitItemBaseInfo(Itemdata)
  self.Text_Describe:SetText(GText(self.ParentWidget.Content.Tips))
  self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
  local PlayerAvatar = GWorld:GetAvatar()
  local Count = 0
  if self.ParentWidget.Content.Type == "Mod" then
    for _, Mod in pairs(PlayerAvatar.Mods) do
      if Mod.ModId == ItemInfo.ItemId and Mod.IsOriginal then
        Count = Count + Mod.Count
      end
    end
    local ModName = GText(Itemdata.TypeName) .. GText(Itemdata.Name)
    self.ParentWidget.Text_ItemName:SetText(ModName)
  elseif self.ParentWidget.Content.Type == "Weapon" then
    for _, Weapon in pairs(PlayerAvatar.Weapons) do
      if Weapon.WeaponId == ItemInfo.ItemId then
        Count = Count + 1
      end
    end
  else
    local ResourceServerData = PlayerAvatar.Resources[ItemInfo.ItemId]
    if ResourceServerData then
      Count = ResourceServerData.Count
    end
  end
  self.ParentWidget.Text_Hold02:SetText(Count)
end

function M:FreshMountInfo(ItemId)
  local ItemInfo = DataMgr.Resource[ItemId]
  if not ItemInfo then
    ScreenPrint("没找到对应坐骑物品 ItemId:" .. tostring(ItemId))
    return
  end
  local MountId = DataMgr.Resource[5].FunctionVars and DataMgr.Resource[5].FunctionVars.Id
  if not MountId then
    ScreenPrint("没找到坐骑物品对应的坐骑Id,检查FunctionVars是否填入的ID这一项 ItemId:" .. tostring(ItemId) .. "  FunctionVars:" .. CommonUtils:ToStringEx(DataMgr.Resource[5].FunctionVars))
  end
  local MountInfo = DataMgr.Mount[MountId]
  if not MountInfo then
    ScreenPrint("没找到对应坐骑信息 MountId:" .. tostring(MountId))
    return
  end
  local MountText = MountInfo.UseLimitDes
  if MountText then
    self.Panel_Message:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Text_Message:SetText(GText(MountText))
  else
    DebugPrint("没找到对应坐骑信息的使用限制描述UseLimitDes   --- MountId:" .. tostring(MountId))
  end
end

return M

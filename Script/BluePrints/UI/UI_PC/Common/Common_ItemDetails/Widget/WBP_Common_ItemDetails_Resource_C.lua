require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:InitItemInfo(ItemType, ItemId, UnitId, Content)
  Content = Content or {}
  self.JumpReturnCallBack = Content and Content.JumpReturnCallBack
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Collapsed)
  self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
  self.Text_Describe:SetVisibility(ESlateVisibility.Collapsed)
  self.ParentWidget.WBox_AnglingTag:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if "Tips" == ItemType then
    self:InitTipsInfo(self.ParentWidget.Content)
    return
  end
  self:SetFocus()
  self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if "CharPartMesh" == ItemType or "Skin" == ItemType or "WeaponSkin" == ItemType or "Title" == ItemType or "TitleFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应CharPartMesh信息：", ItemType, ItemId)
    local CharPartMeshInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if "WeaponSkin" == ItemType then
      self.ParentWidget.Text_ItemDescribe:SetText(GText(CharPartMeshInfo.Dec))
    else
      self.ParentWidget.Text_ItemDescribe:SetText(GText(CharPartMeshInfo.Des))
    end
    if "TitleFrame" == ItemType then
      self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Visible)
      self.ParentWidget.Switch_Show:SetActiveWidgetIndex(4)
      local Widget = UIManager(self):LoadTitleFrameWidget(ItemId)
      if Widget then
        self.Pos_Title:AddChild(Widget)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
          return
        end
        local TitleBefore = Avatar.TitleBefore
        local TitleAfter = Avatar.TitleAfter
        local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
        local TitleFrameData = {}
        TitleFrameData[ItemId] = 1
        if Avatar:CheckTitleFrameEnough(TitleFrameData) then
          self.ParentWidget.Text_Describe:SetText(GText("UI_PersonInfo_Held"))
        else
          self.ParentWidget.Text_Describe:SetText(GText("UI_PersonInfo_NotHeld"))
        end
        Widget.Text_Title:SetText(TitleText)
      end
    end
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  local FishId = DataMgr.ResourceId2FishId[ItemId]
  local FishData = DataMgr.Fish[FishId]
  if FishData and FishData.FishAppearPeriod then
    local Result = {}
    for i, v in pairs(FishData.FishAppearPeriod) do
      if 1 == v then
        Result.IsMorn = true
      elseif 2 == v then
        Result.IsNoon = true
      elseif 3 == v then
        Result.IsNight = true
      end
    end
    if Result.IsMorn then
      self.ParentWidget.Morn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.ParentWidget.Morn.WS_DayAndNight:SetActiveWidgetIndex(0)
    else
      self.ParentWidget.Morn:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Result.IsNoon then
      self.ParentWidget.Noon:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.ParentWidget.Noon.WS_DayAndNight:SetActiveWidgetIndex(1)
    else
      self.ParentWidget.Noon:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if Result.IsNight then
      self.ParentWidget.Night:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.ParentWidget.Night.WS_DayAndNight:SetActiveWidgetIndex(2)
    else
      self.ParentWidget.Night:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self.ParentWidget.WBox_AnglingTag:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if "IronTicket" == ItemType then
    local ironTicketData = DataMgr.IronTicket[ItemId]
    if not ironTicketData then
      return
    end
    self.ParentWidget.Panel_Describe:SetVisibility(ironTicketData.FunctionDes ~= nil and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    self.Text_LongDescribe:SetVisibility(nil ~= ironTicketData.DetailDes and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
    if ironTicketData.FunctionDes then
      self.ParentWidget.Text_ItemDescribe:SetText(GText(ironTicketData.FunctionDes))
    end
    if ironTicketData.DetailDes then
      self.Text_LongDescribe:SetText(GText(ironTicketData.DetailDes))
    end
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Visible)
    self.ParentWidget.Text_Hold01:SetText(GText("UI_LEVEL_NAME"))
    local level = ironTicketData.Level or 0
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.IronSurvivalTicket then
      for _, ticket in pairs(Avatar.IronSurvivalTicket) do
        if ticket.Uid == UnitId then
          level = ticket.Level or ironTicketData.Level
          break
        end
      end
    end
    self.ParentWidget.Text_Hold02:SetText(level)
    local MaxLevel = ironTicketData.MaxLevel or 9999
    if level >= MaxLevel then
      self.ParentWidget.Text_ItemName:SetText(GText(ironTicketData.MaxName or ""))
      self.ParentWidget.Text_ItemDescribe:SetText(GText(ironTicketData.MaxFunctionDes or ""))
      self.Text_LongDescribe:SetText(GText(ironTicketData.MaxDetailDes or ""))
    end
    return
  end
  if "CharAccessory" == ItemType or "WeaponAccessory" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local CharAccessoryInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if CharAccessoryInfo.AccessoryType then
      assert(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType], "未知的配饰部位：" .. CharAccessoryInfo.AccessoryType)
      self.ParentWidget.Text_ItemDescribe:SetText(GText(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType]))
      self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_LongDescribe:SetText(GText(CharAccessoryInfo.Des))
    if not self.ParentWidget.Content.bCustomStype then
      local CallBack = {
        ButtonClickCallBack = function()
          if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName] and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
          else
            PageJumpUtils:CloseFrontDialog()
            if "WeaponAccessory" == ItemType and CharAccessoryInfo and CharAccessoryInfo.StanceFXType ~= "Accessory" then
              local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo", {
                Path = CharAccessoryInfo.Video,
                SoundPath = CharAccessoryInfo.GetSoundPath,
                DestructCB = function()
                end
              })
              if SkinVideo then
                SkinVideo:SetFocus()
              end
            else
              UIManager(self):LoadUINew("ArmorySkin", {
                IsPreviewMode = true,
                Type = string.sub(ItemType, 1, string.find(ItemType, "Accessory") - 1),
                AccessoryId = ItemId,
                OnCloseCallback = self.JumpReturnCallBack and self.JumpReturnCallBack.CallBack
              })
            end
          end
        end,
        ButtonClickText = "UI_Preview_Title",
        ButtonIcon = 1
      }
      self.ParentWidget:InitButtonEvent(CallBack)
    end
    return
  end
  if DataMgr[ItemType][ItemId] and 7 == DataMgr[ItemType][ItemId].MaterialClassify then
    local OptInfo = DataMgr[ItemType][ItemId]
    local UseEffectType = DataMgr[ItemType][ItemId].UseEffectType
    local CharSkinPreview = UIManager(self):GetUI("CharSkinPreview")
    local UIName = self.ParentWidget.Content and self.ParentWidget.Content.UIName or ""
    local IsBanAccess = false
    if DataMgr.SystemUI[UIName] and DataMgr.SystemUI[UIName].IsBanAccess then
      IsBanAccess = true
    end
    if self.ParentWidget.Content.bNotShowAccess then
      IsBanAccess = true
    end
    if not CharSkinPreview and not IsBanAccess and UseEffectType ~= CommonConst.ResUseEffectType.SelectWeapon and UseEffectType ~= CommonConst.ResUseEffectType.SelectCharacter and UseEffectType ~= CommonConst.ResUseEffectType.SelectSkin and UseEffectType ~= CommonConst.ResUseEffectType.SelectPet and UseEffectType ~= CommonConst.ResUseEffectType.SelectResource and UseEffectType ~= CommonConst.ResUseEffectType.ResourcePack then
      self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
      local CallBack = {
        ButtonClickCallBack = function()
          if "RandomSelectPack" == UseEffectType then
            local ResourceConfig = DataMgr[ItemType][ItemId]
            local CommonDialogParams = {}
            CommonDialogParams.Title = GText(ResourceConfig.ResourceName)
            CommonDialogParams.AutoFocus = true
            CommonDialogParams.ParentWidget = self
            CommonDialogParams.ResourceId = ResourceConfig.ResourceId
            CommonDialogParams.UseParam = ResourceConfig.UseParam
            local CommonDialog = GWorld.GameInstance:GetGameUIManager():GetUIObj("CommonDialog")
            if CommonDialog then
              CommonDialog:OnCloseBtnClicked()
            end
            local CommonDialog = GWorld.GameInstance:GetGameUIManager():GetUIObj("CommonDialog")
            if CommonDialog then
              CommonDialog:OnCloseBtnClicked()
            end
            UIManager(self):ShowCommonPopupUI(100344, CommonDialogParams, self, nil, 102)
          else
            PageJumpUtils:CloseFrontDialog()
            UIManager(self):LoadUINew("CharSkinPreview", {
              Type = UseEffectType,
              OptRewardId = OptInfo.UseParam,
              ResourceId = ItemId,
              Mode = "Preview"
            })
          end
        end,
        ButtonClickText = "UI_Preview_Title",
        ButtonIcon = 1
      }
      self.ParentWidget:InitButtonEvent(CallBack)
    end
  end
  if "Mount" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应坐骑信息：", ItemType, ItemId)
    local MountInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_LongDescribe:SetText(GText(MountInfo.MountDes))
    return
  end
  if "HeadSculpture" == ItemType or "HeadFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local HeadInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Collapsed)
    if "HeadSculpture" == ItemType then
      self.ParentWidget.Text_ItemDescribe:SetText(GText("UI_HeadFrame_Head"))
    else
      self.ParentWidget.Text_ItemDescribe:SetText(GText("UI_HeadFrame_Frame"))
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
    self.ParentWidget.Text_ItemDescribe:SetText(GText(Desc))
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  if "Background" == ItemType then
    self:RefreshBackgroundInfo(ItemId)
    return
  end
  if "Resource" == ItemType and DataMgr.LimitedTimeResource[ItemId] then
    local LimitedData = ItemUtils.GetItemLimitedInfo(ItemId)
    if LimitedData then
      local diff = os.difftime(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
      if diff < 86400 then
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
      else
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
      end
      self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Visible)
      local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
      self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
      self.Text_Expiration:SetText(GText("UI_Date_End"))
      self.Time_Expiration:SetTimeText(LimitedData.EndTime.GetTime(), UIConst.EnumTimeStyleType.YMDAndHMS)
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
  if ResourceInfo.ResourceSType == "GestureItem" and not UIConst.LimitPreviewResource[ResourceInfo.ResourceId] then
    local Content = {
      ButtonClickCallBack = function()
        if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName] and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
          UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
        else
          local CommonDialog = UIManager(self):GetUI("CommonDialog")
          if CommonDialog then
            CommonDialog:Close()
          end
          local ItemData = {}
          ItemData.ItemType = "Resource"
          ItemData.TypeId = ItemId
          ItemData.SinglePreview = true
          ItemData.HidePurchase = true
          PageJumpUtils:JumpToSkinPreview(ItemData, self)
        end
      end,
      ButtonClickText = "UI_Preview_Title",
      ButtonIcon = 0
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
  self.ParentWidget.Panel_Describe:SetVisibility(ResourceInfo.FunctionDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.Text_LongDescribe:SetVisibility(nil == ResourceInfo.DetailDes and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.ParentWidget.Text_ItemDescribe:SetText(GText(ResourceInfo.FunctionDes))
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

function M:InitItemInfoInBag(ItemType, ItemId, UnitId, Content)
  Content = Content or {}
  self.JumpReturnCallBack = Content and Content.JumpReturnCallBack
  self.GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Collapsed)
  self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
  if "Tips" == ItemType then
    self:InitTipsInfo(Content)
    return
  end
  if "TreasureGroup" == ItemType then
    local TreasureGroupInfo = DataMgr[ItemType][ItemId]
    if not Content.bGuide then
      if Content.bActive then
        self.ParentWidget.Text_ItemDescribe:SetText(GText("已激活"))
      else
        self.ParentWidget.Text_ItemDescribe:SetText(GText("未激活"))
      end
    else
      self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_LongDescribe:SetText(GText(TreasureGroupInfo.GroupEffectDesc))
    return
  end
  if "CharPartMesh" == ItemType or "Skin" == ItemType or "WeaponSkin" == ItemType or "Title" == ItemType or "TitleFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应CharPartMesh信息：", ItemType, ItemId)
    local CharPartMeshInfo = DataMgr[ItemType][ItemId]
    if "WeaponSkin" == ItemType then
      self.ParentWidget.Text_ItemDescribe:SetText(GText(CharPartMeshInfo.Dec))
    else
      self.ParentWidget.Text_ItemDescribe:SetText(GText(CharPartMeshInfo.Des))
    end
    if "TitleFrame" == ItemType then
      self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      local Widget = UIManager(self):LoadTitleFrameWidget(ItemId)
      if Widget then
        self.Pos_Title:AddChild(Widget)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
          return
        end
        local TitleBefore = Avatar.TitleBefore
        local TitleAfter = Avatar.TitleAfter
        local TitleText = UIUtils.CalculateHoleTitle(TitleBefore, TitleAfter)
        Widget.Text_Title:SetText(TitleText)
      end
    end
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  if "CharAccessory" == ItemType or "WeaponAccessory" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local CharAccessoryInfo = DataMgr[ItemType][ItemId]
    if CharAccessoryInfo.AccessoryType then
      assert(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType], "未知的配饰部位：" .. CharAccessoryInfo.AccessoryType)
      self.ParentWidget.Text_ItemDescribe:SetText(GText(UIConst.AccessoryTypeTextMap[CharAccessoryInfo.AccessoryType]))
      self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.Text_LongDescribe:SetText(GText(CharAccessoryInfo.Des))
    if not Content.bCustomStype then
      local CallBack = {
        ButtonClickCallBack = function()
          if self.ParentWidget and Content.UIName and DataMgr.SystemUI[Content.UIName].IsBanAccess then
            UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
          else
            PageJumpUtils:CloseFrontDialog()
            if "WeaponAccessory" == ItemType and CharAccessoryInfo and CharAccessoryInfo.StanceFXType ~= "Accessory" then
              local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo", {
                Path = CharAccessoryInfo.Video,
                SoundPath = CharAccessoryInfo.GetSoundPath,
                DestructCB = function()
                end
              })
              if SkinVideo then
                SkinVideo:SetFocus()
              end
            else
              UIManager(self):LoadUINew("ArmorySkin", {
                IsPreviewMode = true,
                Type = string.sub(ItemType, 1, string.find(ItemType, "Accessory") - 1),
                AccessoryId = ItemId,
                OnCloseCallback = self.JumpReturnCallBack and self.JumpReturnCallBack.CallBack
              })
            end
          end
        end,
        ButtonClickText = "UI_Preview_Title",
        ButtonIcon = 1
      }
    end
    return
  end
  if "Mount" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应坐骑信息：", ItemType, ItemId)
    local MountInfo = DataMgr[ItemType][ItemId]
    self.ParentWidget.Panel_Describe:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_LongDescribe:SetText(GText(MountInfo.MountDes))
    return
  end
  if "HeadSculpture" == ItemType or "HeadFrame" == ItemType then
    assert(DataMgr[ItemType][ItemId], "未找到对应配饰信息：", ItemType, ItemId)
    local HeadInfo = DataMgr[ItemType][ItemId]
    if "HeadSculpture" == ItemType then
      self.ParentWidget.Text_ItemDescribe:SetText(GText("UI_HeadFrame_Head"))
    else
      self.ParentWidget.Text_ItemDescribe:SetText(GText("UI_HeadFrame_Frame"))
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
    self.ParentWidget.Text_ItemDescribe:SetText(GText(Desc))
    self.Text_LongDescribe:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  if "Background" == ItemType then
    self:RefreshBackgroundInfo(ItemId)
    return
  end
  if "Resource" == ItemType and DataMgr.LimitedTimeResource[ItemId] then
    local LimitedData = ItemUtils.GetItemLimitedInfo(ItemId)
    if LimitedData then
      local diff = os.difftime(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
      if diff < 86400 then
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Red)
      else
        self.BG_TimeLimit:SetColorAndOpacity(self.Color_Orange)
      end
      self.Panel_TimeLimit:SetVisibility(ESlateVisibility.Visible)
      local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(LimitedData.EndTime.GetTime(), TimeUtils.NowTime())
      self.Time_CountDown:SetTimeText(nil, RemainTimeDict)
      self.Text_Expiration:SetText(GText("UI_Date_End"))
      self.Time_Expiration:SetTimeText(LimitedData.EndTime.GetTime(), UIConst.EnumTimeStyleType.YMDAndHMS)
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
  end
  if ResourceInfo.ResourceSType == "GestureItem" and not UIConst.LimitPreviewResource[ResourceInfo.ResourceId] then
    local Content = {
      ButtonClickCallBack = function()
        if self.ParentWidget and self.ParentWidget.Content and self.ParentWidget.Content.UIName and DataMgr.SystemUI[self.ParentWidget.Content.UIName].IsBanAccess then
          UIManager(self):ShowUITip("CommonToastMain", GText("UI_COMMONPOP_TITLE_100059"))
        else
          local CommonDialog = UIManager(self):GetUI("CommonDialog")
          if CommonDialog then
            CommonDialog:Close()
          end
          local ItemData = {}
          ItemData.ItemType = "Resource"
          ItemData.TypeId = ItemId
          ItemData.SinglePreview = true
          ItemData.HidePurchase = true
          PageJumpUtils:JumpToSkinPreview(ItemData, self)
        end
      end,
      ButtonClickText = "UI_Preview_Title",
      ButtonIcon = 0
    }
  end
  local PlayerAvatar = GWorld:GetAvatar()
  if type(ItemId) == "string" then
    ItemId = math.tointeger(ItemId)
  end
  local ResourceServerData = PlayerAvatar.Resources[ItemId]
  self.ParentWidget.Panel_Describe:SetVisibility(ResourceInfo.FunctionDes == nil and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.Text_LongDescribe:SetVisibility(nil == ResourceInfo.DetailDes and ESlateVisibility.Collapsed or ESlateVisibility.Visible)
  self.ParentWidget.Text_ItemDescribe:SetText(GText(ResourceInfo.FunctionDes))
  self.Text_LongDescribe:SetText(GText(ResourceInfo.DetailDes))
end

function M:InitTipsInfo(ItemInfo)
  local Itemdata = DataMgr[ItemInfo.Type][ItemInfo.ItemId]
  self.ParentWidget:InitItemBaseInfo(Itemdata)
  self.ParentWidget.Text_ItemDescribe:SetText(GText(self.ParentWidget.Content.Tips))
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
  local MountId = DataMgr.Resource[ItemId].FunctionVars and DataMgr.Resource[ItemId].FunctionVars.Id
  if not MountId then
    ScreenPrint("没找到坐骑物品对应的坐骑Id,检查FunctionVars是否填入的ID这一项 ItemId:" .. tostring(ItemId) .. "  FunctionVars:" .. CommonUtils:ToStringEx(DataMgr.Resource[ItemId].FunctionVars))
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

function M:RefreshBackgroundInfo(ItemId)
  local BackgroundInfo = DataMgr.Background[ItemId]
  if not BackgroundInfo then
    ScreenPrint("没找到对应名片背景信息 ItemId:" .. tostring(ItemId))
    return
  end
  self.ParentWidget.Panel_Hold:SetVisibility(ESlateVisibility.Visible)
  self.ParentWidget.Switch_Show:SetActiveWidgetIndex(3)
  local HasBackground = ItemUtils.HasBackground(ItemId)
  if HasBackground then
    self.ParentWidget.Text_Describe:SetText(GText("UI_Background_Owned"))
  else
    self.ParentWidget.Text_Describe:SetText(GText("UI_Background_Unowned"))
  end
  self.ParentWidget.Text_ItemDescribe:SetText(GText("UI_Background_CardStyle"))
  self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Widget = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/NameCard/Widget/WBP_NameCard_TipsItem.WBP_NameCard_TipsItem'", false)
  if Widget then
    self.Pos_Title:ClearChildren()
    self.Pos_Title:AddChild(Widget)
    if BackgroundInfo.BigIcon then
      local IconImage = LoadObject(BackgroundInfo.BigIcon)
      if IconImage and Widget.Image_ItemIcon then
        Widget.Image_ItemIcon:SetBrushFromTexture(IconImage)
      end
    end
  end
  self.Text_LongDescribe:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_LongDescribe:SetText(GText(BackgroundInfo.Des) or "")
end

return M

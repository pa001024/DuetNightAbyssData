require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local RarityBG = {
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Grey.T_Angling_Quality_Grey",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Green.T_Angling_Quality_Green",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Blue.T_Angling_Quality_Blue",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Purple.T_Angling_Quality_Purple",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Yellow.T_Angling_Quality_Yellow"
}
local RarityAnim = {
  "Grey",
  "Green",
  "Blue",
  "Purple",
  "Yellow"
}

function M:OnListItemObjectSet(Content)
  self.New:SetVisibility(ESlateVisibility.Collapsed)
  self.FishId = Content.FishId
  self:InitWidget()
  self.IsNotLocked = self:SetIsNotLocked()
  if self.IsNotLocked then
    self:InitUnLockWidget()
  else
    self:InitLockWidget()
  end
  self:PlayAnimation(self.In)
end

function M:SetIsNotLocked()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return true
  end
  print(_G.LogTag, "LXZ SetIsNotLocked", self.FishId, Avatar:GetFishCountByFishId(self.FishId))
  local Res = Avatar:GetFishCountByFishId(self.FishId) >= 1
  return Res
end

function M:InitWidget()
  self.Text_Title02:SetText(GText("UI_Fishing_FishType_2"))
end

function M:InitUnLockWidget()
  print(_G.LogTag, "LXZ InitUnLockWidget", self.FishId)
  self.Switcher:SetActiveWidgetIndex(0)
  self.Icon_Fish:SetColorAndOpacity(FLinearColor(1, 1, 1, 1))
  local IconPath = DataMgr.Fish[self.FishId].IconPath
  if IconPath then
    local Icon = LoadObject(IconPath)
    self.Icon_Fish:SetBrushResourceObject(Icon)
  end
  local Data = DataMgr.Fish[self.FishId]
  if not Data or not Data.ResourceId then
    GWorld.logger.error("鱼" .. self.FishId .. "没有数据或资源id")
    return
  end
  local ResourceData = DataMgr.Resource[Data.ResourceId]
  if not ResourceData then
    GWorld.logger.error("鱼资源" .. Data.ResourceId .. "没有资源数据")
    return
  end
  if 3 == Data.FishType then
    local Icon = LoadObject("/Game/UI/WBP/Common/VX/Angling/MI_Angling_FishMap_Tag_King.MI_Angling_FishMap_Tag_King")
    self.RB_Bg:SetEffectMaterial(Icon)
    self.VX_TagGlow:SetColorAndOpacity(self.Tag_Glow_King)
    self.Text_Title:SetText(GText("UI_Fishing_FishType_3"))
  else
    self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
  end
  local Rarity = ResourceData.Rarity
  local Icon = LoadObject(RarityBG[Rarity])
  self.Img_Quality:GetDynamicMaterial():SetTextureParameterValue("MainTex", Icon)
  self:PlayAnimation(self[RarityAnim[Rarity]])
  self.Text_FishName:SetText(GText(ResourceData.ResourceName))
  self.Text_Describe:SetText(GText(ResourceData.DetailDes))
  self.Text_Lv:SetText(Data.FishLevel)
  self.List_Text:ClearListItems()
  local Weight = self:GetWeight()
  local WeightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Size.T_Angling_Size", Weight)
  self.List_Text:AddItem(WeightContent)
  local Place = self:GetPlace()
  local PlaceContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Location.T_Angling_Location", Place)
  self.List_Text:AddItem(PlaceContent)
  local Text, FishAppearPeriod = self:GetDayNight()
  print(_G.LogTag, "LXZ GetDayNight222", FishAppearPeriod)
  local DayNightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Time.T_Angling_Time", Text, FishAppearPeriod)
  self.List_Text:AddItem(DayNightContent)
  local IsFishNew = self:CheckIsFishNew(self.FishId)
  if IsFishNew then
    self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.New:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:InitVariationFish(Data.VariationFishId)
end

function M:InitLockWidget()
  local Data = DataMgr.Fish[self.FishId]
  if not Data or not Data.ResourceId then
    GWorld.logger.error("鱼" .. self.FishId .. "没有数据或资源id")
    return
  end
  print(_G.LogTag, "LXZ InitLockWidget", self.FishId)
  self.Icon_Fish:SetColorAndOpacity(FLinearColor(0, 0, 0, 1))
  local IconPath = DataMgr.Fish[self.FishId].IconPath
  if IconPath then
    local FishIcon = LoadObject(IconPath)
    self.Icon_Fish:SetBrushResourceObject(FishIcon)
  end
  local Icon = LoadObject(RarityBG[1])
  self.Img_Quality:GetDynamicMaterial():SetTextureParameterValue("MainTex", Icon)
  self:PlayAnimation(self[RarityAnim[1]])
  local bHasUnlockVariationFish, FishId = self:InitVariationFish(Data.VariationFishId)
  if not bHasUnlockVariationFish then
    self.Switcher:SetActiveWidgetIndex(1)
    self.Text_FishName_Lock:SetText(GText("UI_BookArchive_SeriesLockedTitle"))
    self.Text_Describe_Lock:SetText(GText("UI_Fishing_FishingNote_Empty"))
  else
    self.Switcher:SetActiveWidgetIndex(0)
    local Data = DataMgr.Fish[self.FishId]
    if not Data or not Data.ResourceId then
      GWorld.logger.error("鱼" .. self.FishId .. "没有数据或资源id")
      return
    end
    local ResourceData = DataMgr.Resource[Data.ResourceId]
    if not ResourceData then
      GWorld.logger.error("鱼资源" .. Data.ResourceId .. "没有资源数据")
      return
    end
    if 3 == Data.FishType then
      local Icon = LoadObject("/Game/UI/WBP/Common/VX/Angling/MI_Angling_FishMap_Tag_King.MI_Angling_FishMap_Tag_King")
      self.RB_Bg:SetEffectMaterial(Icon)
      self.VX_TagGlow:SetColorAndOpacity(self.Tag_Glow_King)
      self.Text_Title:SetText(GText("UI_Fishing_FishType_3"))
    else
      self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
    end
    local Icon = LoadObject(RarityBG[1])
    self.Img_Quality:GetDynamicMaterial():SetTextureParameterValue("MainTex", Icon)
    self:PlayAnimation(self[RarityAnim[1]])
    self.Text_FishName:SetText(GText(ResourceData.ResourceName))
    self.Text_Describe:SetText(GText(ResourceData.DetailDes))
    self.Text_Lv:SetText(Data.FishLevel)
    self.List_Text:ClearListItems()
    local Weight = self:GetWeight()
    local WeightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Size.T_Angling_Size", Weight)
    self.List_Text:AddItem(WeightContent)
    local Place = self:GetPlace()
    local PlaceContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Location.T_Angling_Location", Place)
    self.List_Text:AddItem(PlaceContent)
    local Text, FishAppearPeriod = self:GetDayNight()
    local DayNightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Time.T_Angling_Time", Text, FishAppearPeriod)
    self.List_Text:AddItem(DayNightContent)
  end
end

function M:InitVariationFish(VariationFishId)
  local Res = false
  if VariationFishId then
    local VariationIdx = 1
    for i, v in pairs(VariationFishId) do
      local Avatar = GWorld:GetAvatar()
      local VariationIconPath = DataMgr.Fish[v].IconPath
      if not Avatar then
        self["FishSwitch0" .. VariationIdx].Switcher_0:SetActiveWidgetIndex(0)
        if VariationIconPath then
          local FishIcon = LoadObject(VariationIconPath)
          self["FishSwitch0" .. VariationIdx].Icon_Fish:SetBrushResourceObject(FishIcon)
        end
      elseif Avatar:GetFishCountByFishId(v) > 0 then
        self["FishSwitch0" .. VariationIdx].Switcher_0:SetActiveWidgetIndex(0)
        if VariationIconPath then
          local FishIcon = LoadObject(VariationIconPath)
          self["FishSwitch0" .. VariationIdx].Icon_Fish:SetBrushResourceObject(FishIcon)
        end
        local IsFishNew = self:CheckIsFishNew(v)
        if IsFishNew then
          self["FishSwitch0" .. VariationIdx].New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        else
          self["FishSwitch0" .. VariationIdx].New:SetVisibility(ESlateVisibility.Collapsed)
        end
        Res = true
      elseif VariationIconPath then
        self["FishSwitch0" .. VariationIdx].Switcher_0:SetActiveWidgetIndex(1)
        self["FishSwitch0" .. VariationIdx].New:SetVisibility(ESlateVisibility.Collapsed)
        local FishIcon = LoadObject(VariationIconPath)
        local Material = self["FishSwitch0" .. VariationIdx].Icon_Fish_Black:GetDynamicMaterial()
        Material:SetTextureParameterValue("Mask", FishIcon)
      end
      VariationIdx = VariationIdx + 1
    end
    for i = VariationIdx, 2 do
      self["FishSwitch0" .. i]:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  return Res
end

function M:GetWeight()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return "10" .. "cm"
  end
  print(_G.LogTag, "LXZ GetWeight", self.FishId, Avatar:GetFishMaxSize(self.FishId))
  return Avatar:GetFishMaxSize(self.FishId) .. "cm"
end

function M:CheckIsFishNew(FishId)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if 0 == Avatar:GetFishCountByFishId(FishId) then
      return false
    end
    local UnLockData = EMCache:Get("FishMapUnLockData", true)
    if not UnLockData then
      UnLockData = {}
      UnLockData[FishId] = 1
      if ReddotManager.GetTreeNode("AnglingMap") and ReddotManager.GetTreeNode("AnglingMap").Count > 0 then
        ReddotManager.DecreaseLeafNodeCount("AnglingMap", 1)
      end
    elseif not UnLockData[FishId] or 0 == UnLockData[FishId] then
      UnLockData[FishId] = 1
      if ReddotManager.GetTreeNode("AnglingMap") and ReddotManager.GetTreeNode("AnglingMap").Count > 0 then
        ReddotManager.DecreaseLeafNodeCount("AnglingMap", 1)
      end
    elseif 1 == UnLockData[FishId] then
      UnLockData[FishId] = 2
    end
    EMCache:Set("FishMapUnLockData", UnLockData, true)
    return 1 == UnLockData[FishId]
  else
    return true
  end
end

function M:GetPlace()
  local Data = DataMgr.FishingBook[self.FishId]
  if not Data or not Data.FishingSpot then
    return "没有在钓鱼手册内指定钓鱼点"
  end
  local SpotData = DataMgr.FishingSpot[Data.FishingSpot]
  if SpotData and SpotData.FishingSpotName then
    local Name = SpotData.FishingSpotName
    return Name
  end
  return "钓鱼点没有名字"
end

function M:GetDayNight()
  print(_G.LogTag, "LXZ GetDayNight")
  local Data = DataMgr.Fish[self.FishId]
  if not Data then
    return "找不到鱼数据", nil
  end
  local FishAppearPeriod = Data.FishAppearPeriod
  if not FishAppearPeriod then
    return "找不到鱼活跃时段", nil
  end
  print(_G.LogTag, "LXZ GetDayNight111", FishAppearPeriod)
  return nil, FishAppearPeriod
end

function M:NewTextContent(IconPath, Text, FishAppearPeriod)
  local Class = LoadClass("/Game/UI/WBP/Angling/Widget/Angling_TextItem_Content.Angling_TextItem_Content")
  local Obj = NewObject(Class)
  Obj.IconPath = IconPath
  Obj.Text = Text
  if FishAppearPeriod then
    Obj.IsTime = true
    for i, v in pairs(FishAppearPeriod) do
      if 1 == v then
        Obj.IsMorn = true
      elseif 2 == v then
        Obj.IsNoon = true
      elseif 3 == v then
        Obj.IsNight = true
      end
    end
  end
  print(_G.LogTag, "LXZ GetDayNight333", FishAppearPeriod)
  return Obj
end

function M:BP_OnItemSelectionChanged(IsSelected)
  if not IsSelected then
  else
    local FishMapUI = UIManager(self):GetUIObj("AnglingMap")
    FishMapUI:OnItemSelectionChanged(self)
  end
end

return M

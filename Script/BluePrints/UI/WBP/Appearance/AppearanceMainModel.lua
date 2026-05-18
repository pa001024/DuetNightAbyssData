local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local M = {}
M._components = {
  "BluePrints.UI.WBP.Appearance.AppearanceCharMainModel",
  "BluePrints.UI.WBP.Appearance.AppearanceWeaponMainModel"
}
local View2Model = {}

function M:New(View, Params)
  Params = Params or {}
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  self.View = View
  View2Model[View] = Obj
  Obj:Init(Params)
  return Obj
end

function M:Destroy()
  View2Model[self.View] = nil
end

function M:GetModelByView(View)
  return View2Model[View]
end

function M:Init(Params)
  self.Params = Params
  self.NoRedDot = self.IsPreviewMode or self.IsCharacterTrialMode
  self.CurrentMainTabName = AppearanceUtils.AppearanceMainTabNames.Char
  self:CreateCharContents(Params)
  local Avatar = self:GetAvatar()
  self.SelectedCharContent = self.CharItemContentsMap[Avatar.CurrentChar]
  self:SortCharContents()
  if self.SelectedCharContent then
    self.SelectedCharContent.bInGear = true
  else
    self.SelectedCharContent = self.CharItemContentsArray[1]
  end
  ArmoryUtils:SetItemIsSelected(self.SelectedCharContent, true)
end

function M:GetAvatar()
  return ArmoryUtils:GetAvatar()
end

function M:GetCurrentTabAllContents()
  if self[self.CurrentMainTabName .. "ItemContentsArray"] then
    return self[self.CurrentMainTabName .. "ItemContentsArray"]
  end
end

function M:GetCurrentTabSelectedContent()
  if self["Selected" .. self.CurrentMainTabName .. "Content"] then
    return self["Selected" .. self.CurrentMainTabName .. "Content"]
  end
end

local function CreateTabContent(self, Tab, TabId, Params)
  local Obj = {}
  Obj.Owner = self
  Obj.TabId = TabId
  Obj.Name = Tab.Name
  Obj.Type = Tab.Type
  Obj.Tag = Tab.Tag
  Obj.Text = Tab.Text
  Obj.IconPath = Tab.IconPath
  Obj.WidgetPath = Tab.WidgetPath
  if not Params.NoRedDot then
    Obj.CheckReddot = Tab.CheckReddot
    if Tab.CheckReddot then
      Obj.IsNew, Obj.Upgradeable = Tab.CheckReddot(Params)
    end
  end
  Obj.TabData = Tab
  return Obj
end

function M:CreateMainTabConfig(Params)
  rawset(self, "TabConfig", {
    TitleName = GText("UI_Armory_Appearance"),
    LeftKey = self.TabLeftKey,
    RightKey = self.TabRightKey,
    Tabs = {},
    StyleName = self.TabStyleName,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {},
    BackCallback = self.View.OnBackKeyDown,
    OwnerPanel = self.View
  })
  local Avatar = self:GetAvatar()
  Params = Params or {}
  Params.Avatar = Avatar
  Params.NoRedDot = self.NoRedDot
  local ConstTabConfig = self:GetConstTabConfig()
  rawset(self, "MainTabName2Idx", {})
  local TabIndex = 1
  for index, value in ipairs(ConstTabConfig.TabIndexes) do
    local TabConfig = ConstTabConfig.Tabs[value]
    if TabConfig.CheckIsUnlocked(self, Params) then
      table.insert(self.TabConfig.Tabs, CreateTabContent(self, TabConfig, index, Params))
      self.MainTabName2Idx[TabConfig.Name] = TabIndex
      TabIndex = TabIndex + 1
    end
  end
end

function M:GetMainTabConfig()
  return self.TabConfig
end

function M:GetMainTabContentByIdx(Idx)
  return self.TabConfig.Tabs[Idx]
end

function M:GetMainTabContentByName(TabName)
  if not self.MainTabName2Idx[TabName] then
    return nil
  end
  return self.TabConfig.Tabs[self.MainTabName2Idx[TabName]]
end

function M:GetMainTabIdxByName(TabName)
  return self.MainTabName2Idx[TabName]
end

function M:GetMainTabNameByIdx(Idx)
  if not self.TabConfig.Tabs[Idx] then
    return nil
  end
  return self.TabConfig.Tabs[Idx].Name
end

function M:GetCurrentMainTabName()
  return self.CurrentMainTabName
end

function M:SetCurrentMainTabName(MainTabName)
  self.CurrentMainTabName = MainTabName
end

function M:GetCurrentMainTab()
  return self:GetMainTabContentByName(self.CurrentMainTabName)
end

function M:GetCurrentMainTabIdx()
  return self.MainTabName2Idx[self.CurrentMainTabName]
end

local ConstTabsConfig = {
  Tabs = {
    [AppearanceUtils.AppearanceMainTabNames.Char] = {
      WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Appearance/Widget/WBP_Appearance_AvatarPart.WBP_Appearance_AvatarPart'",
      Name = AppearanceUtils.AppearanceMainTabNames.Char,
      Type = CommonConst.DataType.Char,
      Text = GText(DataMgr.AppearanceMainTab[1].Text),
      IconPath = DataMgr.AppearanceMainTab[1].IconPath,
      CheckIsUnlocked = function(self, Params)
        return not self.Params.bHideCharTab
      end,
      CheckReddot = function(Params)
        local IsNew, IsCommon = AppearanceUtils.GetCharTabReddot()
        return IsNew, IsCommon
      end
    },
    [AppearanceUtils.AppearanceMainTabNames.Melee] = {
      WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Appearance/Widget/WBP_Appearance_WeaponPart.WBP_Appearance_WeaponPart'",
      Name = AppearanceUtils.AppearanceMainTabNames.Melee,
      Type = CommonConst.DataType.Weapon,
      Tag = ArmoryUtils.ArmoryMainTabNames.Melee,
      Text = GText(DataMgr.AppearanceMainTab[2].Text),
      IconPath = DataMgr.AppearanceMainTab[2].IconPath,
      CheckIsUnlocked = function(self, Params)
        if self.Params.bHideMeleeTab then
          return false
        end
        if self.IsPreviewMode then
          return false
        else
          local Avatar = Params.Avatar
          local Uuid = Avatar.MeleeWeapon
          local Weapon = Uuid and Avatar.Weapons[Uuid]
          if Weapon then
            return true
          end
          for _, value in pairs(Avatar.Weapons) do
            if value:HasTag("Melee") then
              return true
            end
          end
          return false
        end
      end,
      CheckReddot = function(Params)
        local IsNew = AppearanceUtils.GetWeaponTabReddot("Melee")
        return IsNew, false
      end
    },
    [AppearanceUtils.AppearanceMainTabNames.Ranged] = {
      WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Appearance/Widget/WBP_Appearance_WeaponPart.WBP_Appearance_WeaponPart'",
      Name = AppearanceUtils.AppearanceMainTabNames.Ranged,
      Type = CommonConst.DataType.Weapon,
      Tag = AppearanceUtils.AppearanceMainTabNames.Ranged,
      Text = GText(DataMgr.AppearanceMainTab[3].Text),
      IconPath = DataMgr.AppearanceMainTab[3].IconPath,
      CheckIsUnlocked = function(self, Params)
        if self.Params.bHideRangedTab then
          return false
        end
        if self.IsPreviewMode then
          return false
        else
          local Avatar = Params.Avatar
          local Uuid = Avatar.RangedWeapon
          local Weapon = Uuid and Avatar.Weapons[Uuid]
          if Weapon then
            return true
          end
          for _, value in pairs(Avatar.Weapons) do
            if value:HasTag("Ranged") then
              return true
            end
          end
          return false
        end
      end,
      CheckReddot = function(Params)
        local IsNew = AppearanceUtils.GetWeaponTabReddot("Ranged")
        return IsNew, false
      end
    },
    [AppearanceUtils.AppearanceMainTabNames.Mount] = {
      WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Appearance/Widget/WBP_Appearance_MountsPart.WBP_Appearance_MountsPart'",
      Name = AppearanceUtils.AppearanceMainTabNames.Mount,
      Type = CommonConst.DataType.Mount,
      Tag = CommonConst.DataType.Mount,
      Text = GText(DataMgr.AppearanceMainTab[4].Text),
      IconPath = DataMgr.AppearanceMainTab[4].IconPath,
      CheckIsUnlocked = function(self, Params)
        if self.Params.bHideMountTab then
          return false
        end
        return true
      end
    },
    [AppearanceUtils.AppearanceMainTabNames.Gesture] = {
      WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Appearance/Widget/WBP_Appearance_GeaturePart.WBP_Appearance_GeaturePart'",
      Name = AppearanceUtils.AppearanceMainTabNames.Gesture,
      Text = GText(DataMgr.AppearanceMainTab[5].Text),
      IconPath = DataMgr.AppearanceMainTab[5].IconPath,
      CheckIsUnlocked = function(self, Params)
        if self.IsPreviewMode or self.Params.bHideGestureTab then
          return false, ""
        end
        return true
      end
    }
  },
  TabIndexes = {
    AppearanceUtils.AppearanceMainTabNames.Char,
    AppearanceUtils.AppearanceMainTabNames.Melee,
    AppearanceUtils.AppearanceMainTabNames.Ranged,
    AppearanceUtils.AppearanceMainTabNames.Mount
  }
}

function M:GetConstTabConfig()
  return ConstTabsConfig
end

AssembleComponents(M)
return M

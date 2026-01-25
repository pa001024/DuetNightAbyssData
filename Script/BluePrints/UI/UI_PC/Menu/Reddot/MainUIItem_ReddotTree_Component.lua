require("UnLua")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local AnnouncementUtils = require("BluePrints.UI.WBP.Announcement.AnnounceUtils")
local Component = {}
local BattleMainMenu = DataMgr.ReddotNode.BattleMainMenu.Name

function Component:ReddotTreePlugIn(BtnConf, Type)
  self._UnlockRuleNames = {}
  if nil == Type then
    Type = ""
  end
  self._Avatar = GWorld:GetAvatar()
  if not self._Avatar then
    return
  end
  self.bForceInvisible = false
  self._ReddotNode = BtnConf.ReddotNode
  if not self._ReddotNode then
    return
  end
  if self._ReddotNode == BattleMainMenu then
    local function Callback()
      if not UIUtils.IsMenuWorld() then
        DebugPrint(LXYTag, "副本和boss战中，强制不显示esc红点")
        
        self.bForceInvisible = true
        self:EMShowReddot(false, EReddotType.New, 0)
      end
    end
    
    EventManager:AddEvent(EventID.CloseLoading, self, Callback)
    Callback()
  end
  local UnlockRuleNames = {}
  
  local function ReadBtnConfFunc(TempBtnConf, TempType)
    if self["InitReddotData_" .. TempBtnConf.SystemUIName] then
      self["InitReddotData_" .. TempBtnConf.SystemUIName](self, Type)
    end
    local ShowCondition = TempBtnConf[TempType .. "ShowCondition"]
    if not ShowCondition or ConditionUtils.CheckCondition(self._Avatar, ShowCondition) then
      local UnlockRuleName = TempBtnConf.UIUnlockRuleName
      if UnlockRuleName then
        UnlockRuleNames[UnlockRuleName] = TempBtnConf.EnterId
      end
    end
  end
  
  if self._ReddotNode == BattleMainMenu then
    local MainUIReddotNames = {}
    for _, _BtnConf in pairs(DataMgr.MainUI) do
      local ReddotNode = _BtnConf.ReddotNode
      if not ReddotNode then
      elseif ReddotNode == BattleMainMenu then
      else
        MainUIReddotNames[ReddotNode] = 1
        ReadBtnConfFunc(_BtnConf, "Esc")
      end
    end
    local ChildNodes = {}
    for _, NodeName in ipairs(DataMgr.ReddotNode[BattleMainMenu].Childs) do
      if not MainUIReddotNames[NodeName] then
        local NodeConf = DataMgr.ReddotNode[NodeName]
        ChildNodes[NodeName] = NodeConf.IsCommonCache and 0 or 1
      end
    end
    if not table.isempty(ChildNodes) then
      self:_AddReddotListener(ChildNodes)
    end
  else
    ReadBtnConfFunc(BtnConf, Type)
  end
  if table.isempty(UnlockRuleNames) then
    local ChildNodes = self:_TrySeekChildNodesOfBattleMainMenu(BtnConf.EnterId)
    self:_AddReddotListener(ChildNodes)
    return
  end
  for UnlockRuleName, EnterId in pairs(UnlockRuleNames) do
    local bUnlocked = self._Avatar:CheckUIUnlocked(UnlockRuleName)
    local ChildNodes = self:_TrySeekChildNodesOfBattleMainMenu(EnterId)
    if not ChildNodes then
    elseif bUnlocked then
      if "Shop" == UnlockRuleName and not EMCache:Get("ShopUnlockTime", true) then
        EMCache:Set("ShopUnlockTime", TimeUtils.NowTime(), true)
      end
      self:_AddReddotListener(ChildNodes)
    else
      self._UnlockRuleNames[UnlockRuleName] = self._Avatar:BindOnUIFirstTimeUnlock(UnlockRuleName, function()
        if not self._UnlockRuleNames[UnlockRuleName] then
          return
        end
        if "Shop" == UnlockRuleName then
          EMCache:Set("ShopUnlockTime", TimeUtils.NowTime(), true)
        end
        self:_AddReddotListener(ChildNodes)
      end)
    end
  end
end

function Component:_TrySeekChildNodesOfBattleMainMenu(EnterId)
  local MainUIConf = DataMgr.MainUI[EnterId]
  local ReddotNode = MainUIConf.ReddotNode
  local ChildNodes = {}
  if self._ReddotNode == BattleMainMenu and ReddotNode ~= BattleMainMenu then
    if not self:_IsChildOfBattleMain(ReddotNode) then
      return nil
    end
    local NodeConf = DataMgr.ReddotNode[ReddotNode]
    if not NodeConf then
      return
    end
    ChildNodes[ReddotNode] = NodeConf.IsCommonCache and 0 or 1
  end
  return ChildNodes
end

function Component:ReddotTreePlugOut()
  if not self._Avatar then
    return
  end
  if self._Avatar:IsInDungeon() or self._Avatar:IsInHardBoss() then
    return
  end
  if self._ReddotNode == BattleMainMenu then
    EventManager:RemoveEvent(EventID.CloseLoading, self)
  end
  if not self._ReddotNode then
    return
  end
  for Key, Value in pairs(self._UnlockRuleNames) do
    self._Avatar:UnBindOnUIFirstTimeUnlock(Key, Value)
  end
  self._UnlockRuleNames = {}
  self.bForceInvisible = false
  self:_RemoveReddotListener()
end

function Component:_IsChildOfBattleMain(InNodeName)
  for _, NodeName in ipairs(DataMgr.ReddotNode[BattleMainMenu].Childs) do
    if InNodeName == NodeName then
      return true
    end
  end
  return false
end

function Component:_AddReddotListener(ChildNodes)
  if not self._Avatar then
    return
  end
  if not self._ReddotNode then
    return
  end
  if self._ListenedReddot and self._ReddotNode == BattleMainMenu then
    PrintTable(ChildNodes, 3, WarningTag .. LXYTag .. "BattleMainMenu到底加了哪些子节点")
    ReddotManager.AddNode(BattleMainMenu, ChildNodes)
    return
  end
  self:_RemoveReddotListener()
  if not self._ListenedReddot then
    ReddotManager.AddListener(self._ReddotNode, self, self._OnReddotNodeUpdate, ChildNodes)
    self._ListenedReddot = true
  end
end

function Component:_RemoveReddotListener()
  if self._ListenedReddot then
    ReddotManager.RemoveListener(self._ReddotNode, self)
    self._ListenedReddot = false
  end
end

function Component:_OnReddotNodeUpdate(Count, ReddotType, NodeName)
  if self["OnReddotUpdate_" .. self._ReddotNode] then
    self["OnReddotUpdate_" .. self._ReddotNode](self, ReddotType, Count)
  else
    self:EMShowReddot(Count > 0, ReddotType, Count)
  end
end

function Component:InitReddotData_ActivityMain()
  ActivityReddotHelper.InitReddot(ActivityUtils)
  ActivityUtils.RefreshActivityReddotNode()
end

function Component:InitReddotData_DayAndNight()
  local ReddotNode = ReddotManager.GetTreeNode("DayAndNight") or ReddotManager.AddNodeEx("DayAndNight")
  local ReddotNodeDetailed = ReddotManager.GetLeafNodeCacheDetail("DayAndNight")
  if ReddotNodeDetailed then
    if ReddotNodeDetailed.HasCreated == nil then
      ReddotNodeDetailed.HasCreated = true
      ReddotManager.ClearLeafNodeCount("DayAndNight")
      ReddotManager.IncreaseLeafNodeCount("DayAndNight")
      if self.Button_Area and self.Button_Area.OnClicked then
        self.Button_Area.OnClicked:Add(self, function()
          ReddotManager.ClearLeafNodeCount("DayAndNight")
        end)
      end
    elseif ReddotNodeDetailed.HasCreated == true and ReddotNode.Count > 0 and self.Button_Area and self.Button_Area.OnClicked then
      self.Button_Area.OnClicked:Add(self, function()
        ReddotManager.ClearLeafNodeCount("DayAndNight")
      end)
    end
  end
end

function Component:InitReddotData_AnnouncementMain()
  local ret = AnnouncementUtils:UpdateAnnouncementDataInGame()
  if ret then
    self:EMShowReddot(true, EReddotType.New, 1)
  else
    self:EMShowReddot(false, EReddotType.New, 0)
  end
end

function Component:OnReddotUpdate_BattleMainMenu(ReddotType, Count)
  if self.bForceInvisible then
    self:EMShowReddot(false, EReddotType.New, 0)
    return
  end
  self:EMShowReddot(Count > 0, ReddotType, Count)
end

function Component:OnReddotUpdate_ChatMainMenu(ReddotType, Count)
  local ChatNode = ReddotManager.GetTreeNode(ChatCommon.ReddotName)
  local NewCount
  if ChatNode.Count > ChatCommon.ReddotMaxCount then
    NewCount = ChatCommon.ReddotMaxCount .. "+"
  end
  self:EMShowReddot(Count > 0, ReddotType, Count)
  self.Reddot_Num:SetNum(NewCount or Count)
end

return Component

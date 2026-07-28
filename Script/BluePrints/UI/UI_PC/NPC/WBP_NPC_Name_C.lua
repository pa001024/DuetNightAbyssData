require("UnLua")
local OnlineActionCommon = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionCommon")
local WBP_NPC_Name_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function WBP_NPC_Name_C:Initialize(Initializer)
  self.ParentHeadWidget = nil
  self.bIsEnabled_Name = false
  self.PosInitialized = false
  self.Style = nil
  self.PlayerNumber = nil
  self.AutoOnlineActionTag = nil
end

function WBP_NPC_Name_C:Construct()
  DebugPrint("Construct", self)
end

function WBP_NPC_Name_C:Destruct()
  DebugPrint("Destruct", self)
end

function WBP_NPC_Name_C:Init(ParentHeadWidget)
  DebugPrint("Init", self, ParentHeadWidget)
  self:SetRenderOpacity(0)
  if not self.PosInitialized then
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.PosInitialized = true
  end
  self.ParentHeadWidget = ParentHeadWidget
  self.bIsEnabled_Name = false
  self:SetAutoOnlineActionTagVisible(false)
end

function WBP_NPC_Name_C:OnEnabled(Name, Style, PlayerNumber)
  if self.bIsEnabled_Name then
    DebugPrint("OnEnabled skip already enabled", self, Name)
    return
  end
  Style = Style or "Default"
  self:SwitchStyle(Style)
  self:SetPlayerNumber(PlayerNumber)
  self.bIsEnabled_Name = true
  self.NameTxt:SetText(Name)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  EMUIAnimationSubsystem:EMStopAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_Out)
  EMUIAnimationSubsystem:EMPlayAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_In)
  self:SetAutoOnlineActionTagVisible(false)
  DebugPrint("OnEnabled", self, Name, Style, PlayerNumber)
end

function WBP_NPC_Name_C:SwitchStyle(Style)
  self.Style = Style
  local LoadMaterial
  if "Phantom" == Style then
    LoadMaterial = self.PlayerMaterial
  elseif "Player" == Style then
    LoadMaterial = self.DefaultMaterial
  else
    local Font = self.NameTxt.Font
    Font.FontMaterial = nil
    self.NameTxt:SetFont(Font)
    return
  end
  UResourceLibrary.LoadObjectAsync(self, tostring(LoadMaterial), {
    self,
    function(obj, Material)
      if not IsValid(obj) then
        return
      end
      if Style ~= self.Style then
        return
      end
      local Font = self.NameTxt.Font
      Font.FontMaterial = Material
      self.NameTxt:SetFont(Font)
    end
  })
end

function WBP_NPC_Name_C:SetPlayerNumber(PlayerNumber)
  if 0 == PlayerNumber then
    PlayerNumber = nil
  end
  self.PlayerNumber = PlayerNumber
  if not PlayerNumber then
    self.Group_TeamSign:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Group_TeamSign:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  
  local function UpdateTeamTag(TeamTag)
    if not IsValid(TeamTag) then
      return
    end
    if not self.PlayerNumber then
      return
    end
    local Number = self.PlayerNumber
    TeamTag:Init(false, Number, nil)
  end
  
  if self.Group_TeamSign:HasAnyChildren() then
    local TeamTag = self.Group_TeamSign:GetChildAt(0)
    if IsValid(TeamTag) then
      UpdateTeamTag(TeamTag)
      return
    end
    self.Group_TeamSign:ClearChildren()
  end
  UIManager(self):CreateWidgetAsync("WBP_NPC_Name_Tag", function(TeamTag)
    if not IsValid(self) then
      return
    end
    if TeamTag then
      self.Group_TeamSign:AddChild(TeamTag)
      UpdateTeamTag(TeamTag)
    end
  end, tostring(self.NameTagReference))
end

function WBP_NPC_Name_C:OnDisabled()
  if not self.bIsEnabled_Name then
    DebugPrint("OnDisabled skip already disabled", self)
    return
  end
  self.bIsEnabled_Name = false
  DebugPrint("OnDisabled hide", self)
  self:SetAutoOnlineActionTagVisible(false)
  EMUIAnimationSubsystem:EMStopAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_In)
  EMUIAnimationSubsystem:EMPlayAnimation(self.ParentHeadWidget, self.ParentHeadWidget.Name_Out)
end

function WBP_NPC_Name_C:CreateAutoOnlineActionTag(Callback)
  if IsValid(self.AutoOnlineActionTag) then
    DebugPrint("CreateAutoOnlineActionTag reuse", self, self.AutoOnlineActionTag)
    if Callback then
      Callback()
    end
    return
  end
  if not self.Pos_AutoOnlineAction then
    DebugPrint("CreateAutoOnlineActionTag no Pos_AutoOnlineAction", self)
    return
  end
  DebugPrint("CreateAutoOnlineActionTag create begin", self, OnlineActionCommon.OnlineActionAutoTagBPPath)
  UIManager(self):CreateWidgetAsync("WBP_Battle_OnlineAction_AutoTag", function(Widget)
    DebugPrint("CreateAutoOnlineActionTag callback", self, Widget)
    if not IsValid(self) or not IsValid(Widget) then
      DebugPrint("CreateAutoOnlineActionTag callback invalid", self, Widget)
      return
    end
    self.AutoOnlineActionTag = Widget
    self.Pos_AutoOnlineAction:AddChild(Widget)
    self:SetAutoOnlineActionTagVisible(false)
    if Callback then
      Callback()
    end
  end, OnlineActionCommon.OnlineActionAutoTagBPPath)
end

function WBP_NPC_Name_C:SetAutoOnlineActionTagVisible(IsVisible)
  DebugPrint("SetAutoOnlineActionTagVisible", self, IsVisible, self.AutoOnlineActionTag, self.Pos_AutoOnlineAction)
  if IsValid(self.AutoOnlineActionTag) then
    self.AutoOnlineActionTag:SetVisibility(IsVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Pos_AutoOnlineAction then
    self.Pos_AutoOnlineAction:SetVisibility(IsVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_NPC_Name_C:PlayAutoOnlineActionTagIn()
  self.AutoOnlineActionTag:PlayAnimation(self.AutoOnlineActionTag.In)
end

function WBP_NPC_Name_C:RefreshAutoOnlineActionTagVisible(IsVisible)
  DebugPrint("RefreshAutoOnlineActionTagVisible", self, IsVisible)
  if not IsVisible then
    self:SetAutoOnlineActionTagVisible(false)
    return
  end
  local bWasVisible = IsValid(self.AutoOnlineActionTag) and self.AutoOnlineActionTag:IsVisible()
  self:CreateAutoOnlineActionTag(function()
    DebugPrint("RefreshAutoOnlineActionTagVisible show callback", self)
    self:SetAutoOnlineActionTagVisible(true)
    if not bWasVisible then
      self:PlayAutoOnlineActionTagIn()
    end
  end)
end

return WBP_NPC_Name_C

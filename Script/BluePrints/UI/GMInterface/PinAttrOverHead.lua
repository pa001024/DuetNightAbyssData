require("UnLua")
local PinAttrOverHead = {}
local ATTR_PREFIX = "PinAttr_"
local TIMER_NAME = "PinAttrOverHeadTimer"
local DEBUG_COMP_BP_PATH = "/Game/BluePrints/ScreenDebug/BP_GMScreenDebugComponent.BP_GMScreenDebugComponent"

local function GetState(Player)
  if not Player.__PinAttrOverHeadState then
    Player.__PinAttrOverHeadState = {
      AttrMap = {},
      MainPlayerPanel = nil
    }
  end
  return Player.__PinAttrOverHeadState
end

local function IsMainPlayerEntity(Target)
  return Target.IsMainPlayer and Target:IsMainPlayer()
end

local function GetOrCreateMainPlayerPanel(Player, State)
  if State.MainPlayerPanel and IsValid(State.MainPlayerPanel) then
    return State.MainPlayerPanel
  end
  local Panel = UIManager(Player):LoadUI(UIConst.ATTRDEBUGPANEL, "PinAttrMainPlayer", UIConst.ZORDER_ABOVE_ALL)
  if Panel then
    Panel:RemoveTimer("RefreshPanel")
    Panel.AttrWatcher = {}
    State.MainPlayerPanel = Panel
  end
  return Panel
end

local function DestroyMainPlayerPanel(Player, State)
  if State.MainPlayerPanel and IsValid(State.MainPlayerPanel) then
    State.MainPlayerPanel.TextInfo:SetText("")
    UIManager(Player):UnLoadUI("PinAttrMainPlayer", "PinAttrMainPlayer")
    State.MainPlayerPanel = nil
  end
end

local function GetDebugComp(Target)
  if not Target then
    return nil
  end
  local BPClass = LoadClass(DEBUG_COMP_BP_PATH)
  if not BPClass then
    return nil
  end
  return Target:GetComponentByClass(BPClass)
end

local function GetOrCreateDebugComp(Target)
  if not Target then
    return nil
  end
  local Comp = GetDebugComp(Target)
  if not Comp then
    local BPClass = LoadClass(DEBUG_COMP_BP_PATH)
    if BPClass then
      Comp = Target:AddComponentByClass(BPClass, false, UE4.FTransform(), false)
    end
  end
  if not Comp then
    return nil
  end
  local RootComp = Target:K2_GetRootComponent()
  if RootComp then
    Comp:K2_AttachTo(RootComp, "None", EAttachLocation.SnapToTargetIncludingScale, false)
  end
  Comp:K2_SetRelativeLocation(FVector(0, 0, 150), false, nil, false)
  Comp:SetWidgetSpace(UE4.EWidgetSpace.Screen)
  Comp:SetHiddenInGame(false)
  return Comp
end

local function GetAttrValue(Target, AttrName)
  if not Target or not AttrName then
    return nil
  end
  if Target.GetAttr then
    return Target:GetAttr(AttrName)
  end
  return nil
end

local function BuildDebugText(AttrName, Value)
  if nil == Value then
    return nil
  end
  if type(Value) == "number" then
    return string.format("%s:%.2f", tostring(AttrName), Value)
  end
  return tostring(AttrName) .. ":" .. tostring(Value)
end

local function RemoveAttrText(Player, AttrName)
  if not Player or not AttrName then
    return
  end
  local BattleInst = Battle(Player)
  if not BattleInst or not BattleInst.Entities then
    return
  end
  local TextKey = ATTR_PREFIX .. tostring(AttrName)
  for _, Target in pairs(BattleInst.Entities) do
    if Target and Target.IsCharacter and Target:IsCharacter() then
      local Comp = GetDebugComp(Target)
      if Comp then
        Comp:RemoveDebugText(TextKey)
      end
    end
  end
end

local function RemoveAllAttrTexts(Player)
  if not Player then
    return
  end
  local State = GetState(Player)
  if not State or not State.AttrMap then
    return
  end
  for AttrName, _ in pairs(State.AttrMap) do
    RemoveAttrText(Player, AttrName)
  end
end

local function RefreshMainPlayerPanel(Player, State, MainPlayerTexts)
  if #MainPlayerTexts > 0 then
    local Panel = GetOrCreateMainPlayerPanel(Player, State)
    if Panel then
      Panel.TextInfo:SetText(table.concat(MainPlayerTexts, "\n"))
    end
  else
    DestroyMainPlayerPanel(Player, State)
  end
end

local function Refresh(Player)
  if not Player then
    return
  end
  local State = GetState(Player)
  if not State or not next(State.AttrMap) then
    return
  end
  local BattleInst = Battle(Player)
  if not BattleInst or not BattleInst.Entities then
    return
  end
  local PlayerLoc = Player:K2_GetActorLocation()
  local MainPlayerTexts = {}
  for _, Target in pairs(BattleInst.Entities) do
    if Target and Target.IsCharacter and Target:IsCharacter() then
      if IsMainPlayerEntity(Target) then
        for AttrName, _ in pairs(State.AttrMap) do
          local Value = GetAttrValue(Target, AttrName)
          local DebugText = BuildDebugText(AttrName, Value)
          if DebugText then
            table.insert(MainPlayerTexts, DebugText)
          end
        end
      else
        local TargetLoc = Target:K2_GetActorLocation()
        local Dis = FVector.Dist(PlayerLoc, TargetLoc)
        if Dis < 1000 then
          local Comp = GetOrCreateDebugComp(Target)
          if Comp then
            for AttrName, _ in pairs(State.AttrMap) do
              local TextKey = ATTR_PREFIX .. tostring(AttrName)
              local Value = GetAttrValue(Target, AttrName)
              local DebugText = BuildDebugText(AttrName, Value)
              Comp:RemoveDebugText(TextKey)
              if DebugText then
                Comp:AddDebugTEXT(TextKey, DebugText)
              end
            end
          end
        else
          local Comp = GetDebugComp(Target)
          if Comp then
            for AttrName, _ in pairs(State.AttrMap) do
              local TextKey = ATTR_PREFIX .. tostring(AttrName)
              Comp:RemoveDebugText(TextKey)
            end
          end
        end
      end
    end
  end
  RefreshMainPlayerPanel(Player, State, MainPlayerTexts)
end

function PinAttrOverHead.Toggle(Player, AttrName)
  if not Player then
    return
  end
  if not AttrName or "" == AttrName or "clear" == AttrName then
    PinAttrOverHead.Clear(Player)
    return
  end
  local State = GetState(Player)
  local RealAttrName = tostring(AttrName)
  if State.AttrMap[RealAttrName] then
    State.AttrMap[RealAttrName] = nil
    RemoveAttrText(Player, RealAttrName)
  else
    State.AttrMap[RealAttrName] = true
  end
  if next(State.AttrMap) then
    Refresh(Player)
    Player:RemoveTimer(TIMER_NAME)
    Player:AddTimer(0.1, function()
      Refresh(Player)
    end, true, 0, TIMER_NAME)
  else
    Player:RemoveTimer(TIMER_NAME)
  end
end

function PinAttrOverHead.Clear(Player)
  if not Player then
    return
  end
  Player:RemoveTimer(TIMER_NAME)
  RemoveAllAttrTexts(Player)
  local State = GetState(Player)
  DestroyMainPlayerPanel(Player, State)
  State.AttrMap = {}
end

return PinAttrOverHead

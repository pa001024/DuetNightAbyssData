require("UnLua")
require("DataMgr")
local M = Class("BluePrints.Combat.Skill.BP_SkillCreature_C")
local CFG = {
  MaxTraceRadSpeed = 12,
  TraceDelay = 0.3,
  AimHeightOffset = 0,
  RelockInterval = 0.15,
  ShareTargetFilter = true,
  FilterCacheTTL = 0.2,
  RelockFilterKeys = {
    "Saiqi_Skill01_Search_S",
    "Saiqi_Skill01_Search_M",
    "Saiqi_Skill01_Search_L"
  },
  ConvergeRatio = 2,
  ConvergeMaxDist = 3500,
  AimPointLengthFallback = 3500,
  PathCtrlPoints = {
    {
      0.05,
      0.2,
      1500
    },
    {
      0.25,
      0.45,
      1000
    },
    {
      0.5,
      0.7,
      800
    },
    {
      0.99,
      1.0,
      100
    }
  },
  PathSpreadScale = 1.0,
  PathLookahead = 250,
  PathTurnRate = 5,
  PathConvergeFix = false,
  PathDurScale = 1.15,
  HomingAimJitter = 80,
  UniqueSeedPerSpawn = true,
  PostConvergeKeep = 1.0,
  NoTargetKeep = 1.0,
  ForceSpeed = nil
}
local CLOSE_DIST_FACTOR = 2.0
local TARGET_CAPSULE_EST = 50
local DEFAULT_SHAPE_RADIUS = 20

local function GetSelfRadius(self)
  local R = self._SelfRadius
  if R then
    return R
  end
  local SI = self._Row and self._Row.ShapeInfo
  R = SI and SI.Radius
  if type(R) ~= "number" or R <= 0 then
    R = DEFAULT_SHAPE_RADIUS
  end
  self._SelfRadius = R
  return R
end

local function Clamp(v, lo, hi)
  if v < lo then
    return lo
  end
  if hi < v then
    return hi
  end
  return v
end

local function Len3(x, y, z)
  return math.sqrt(x * x + y * y + z * z)
end

local function Norm3(x, y, z)
  local L = Len3(x, y, z)
  if L < 1.0E-4 then
    return nil
  end
  return x / L, y / L, z / L
end

local function RotateAxis3(vx, vy, vz, ax, ay, az, Rad)
  local C, S = math.cos(Rad), math.sin(Rad)
  local cx, cy, cz = ay * vz - az * vy, az * vx - ax * vz, ax * vy - ay * vx
  local D = (ax * vx + ay * vy + az * vz) * (1 - C)
  return vx * C + cx * S + ax * D, vy * C + cy * S + ay * D, vz * C + cz * S + az * D
end

local function TurnToward(cx, cy, cz, dx, dy, dz, MaxRad)
  local Dot = Clamp(cx * dx + cy * dy + cz * dz, -1, 1)
  local Ang = math.acos(Dot)
  if MaxRad >= Ang then
    return dx, dy, dz
  end
  local ax, ay, az = cy * dz - cz * dy, cz * dx - cx * dz, cx * dy - cy * dx
  local AL = Len3(ax, ay, az)
  if AL < 1.0E-4 then
    ax, ay, az = 0, 0, 1
    if math.abs(cz) > 0.9 then
      ax, ay, az = 1, 0, 0
    end
  else
    ax, ay, az = ax / AL, ay / AL, az / AL
  end
  return RotateAxis3(cx, cy, cz, ax, ay, az, MaxRad)
end

local RAND_MOD = 2147483647
local SpawnSeq = 0

function M:_InitRand()
  SpawnSeq = SpawnSeq + 1
  local Seed = (self.CreatureId or 0) * 73856093 + (self.Eid or 0) * 19349663 + 12345
  if (self.C or CFG).UniqueSeedPerSpawn then
    Seed = Seed + SpawnSeq * 4068001
  end
  Seed = Seed % (RAND_MOD - 1)
  if Seed <= 0 then
    Seed = 1
  end
  self._RandState = Seed
end

function M:_Rand01()
  local S = self._RandState
  if not S then
    self:_InitRand()
    S = self._RandState
  end
  S = 16807 * S % RAND_MOD
  if S <= 0 then
    S = 1
  end
  self._RandState = S
  return S / RAND_MOD
end

function M:_RandIn(Lo, Hi)
  return Lo + self:_Rand01() * (Hi - Lo)
end

function M:InitBeginPlay()
  self.TraceEnabled = false
  self.AliveTime = 0
  self.FlySpeed = nil
  self.Path = nil
  self.AimJitter = nil
  self.PathT = 0
  self.PathDone = false
  self.PostConvergeTime = 0
  self.HomingEver = false
  self.TraceTargetEid = nil
  self.VarsLoaded = nil
  self:ResetSharedTargetQuery()
  self._InitOK = nil
  self._Row = nil
  self._SelfRadius = nil
  self._CloseDist = nil
  self._CloseRadius = nil
  self.NoTargetTime = 0
end

function M:_LoadConfigIfNeeded()
  if self.VarsLoaded then
    return
  end
  self.VarsLoaded = true
  local C = {}
  for k, v in pairs(CFG) do
    C[k] = v
  end
  self.C = C
  local Row = DataMgr and DataMgr.SkillCreature and DataMgr.SkillCreature[self.CreatureId]
  self._Row = Row
  local Vars = Row and Row.Vars
  if Vars then
    if Vars.TraceBeginDelay ~= nil and nil == Vars.TraceDelay then
      C.TraceDelay = Vars.TraceBeginDelay
    end
    for k, v in pairs(Vars) do
      if nil ~= C[k] then
        C[k] = v
      end
    end
  end
  self:_InitRand()
end

function M:_Battle()
  local B = self._BattleObj
  if B and IsValid(B) then
    return B
  end
  B = Battle(self)
  self._BattleObj = B
  return B
end

function M:_GetEntity(Eid)
  if not Eid or Eid <= 0 then
    return nil
  end
  local B = self:_Battle()
  if not B then
    return nil
  end
  return B:GetEntity(Eid)
end

function M:_TargetUsable(Entity)
  if not IsValid(Entity) then
    return false
  end
  local Fn = Entity.IsDead
  if Fn then
    local Ok, Dead = pcall(Fn, Entity)
    if Ok and Dead then
      return false
    end
  end
  return true
end

function M:_GetTarget()
  local C = self.C or CFG
  local Eid = self.TraceTargetEid
  if nil == Eid and self.TargetEid and self.TargetEid > 0 then
    Eid = self.TargetEid
    self.TraceTargetEid = Eid
  end
  if Eid and Eid > 0 then
    local Entity = self:_GetEntity(Eid)
    if self:_TargetUsable(Entity) then
      return Entity
    end
  end
  self.TraceTargetEid = -1
  local Interval = C.RelockInterval
  if Interval and Interval > 0 then
    local Entity = self:AcquireSharedTarget(C.RelockFilterKeys, {
      Interval = Interval,
      TTL = C.FilterCacheTTL,
      Share = C.ShareTargetFilter
    })
    if Entity then
      self.TraceTargetEid = Entity.Eid
      return Entity
    end
  end
  return nil
end

function M:ReceiveTick(DeltaSeconds)
  if not self._InitOK then
    if not self.InitSuccess then
      return
    end
    self._InitOK = true
  end
  if self.IsDestroy then
    return
  end
  self.AliveTime = (self.AliveTime or 0) + DeltaSeconds
  if not self.FlySpeed then
    self:_LoadConfigIfNeeded()
    self:_InitFlight()
  end
  local C = self.C or CFG
  if not self.TraceEnabled then
    if self.AliveTime < C.TraceDelay then
      self:_AdvancePath(DeltaSeconds)
      return
    end
    self.TraceEnabled = true
  end
  local Target = self:_GetTarget()
  if Target then
    self.NoTargetTime = 0
    self.HomingEver = true
    self:UpdateHoming(Target, DeltaSeconds)
  else
    self.NoTargetTime = (self.NoTargetTime or 0) + DeltaSeconds
    if not self.HomingEver then
      if not self.PathDone then
        self:_AdvancePath(DeltaSeconds)
      else
        self.PostConvergeTime = (self.PostConvergeTime or 0) + DeltaSeconds
        if self.PostConvergeTime >= C.PostConvergeKeep then
          self:_DestroyNoTarget()
        end
      end
    elseif self.NoTargetTime >= C.NoTargetKeep then
      self:_DestroyNoTarget()
    end
  end
end

function M:_InitFlight()
  local C = self.C or CFG
  local Row = self._Row
  local Speed = 0
  local RowSpeed = Row and Row.Speed or 0
  if C.ForceSpeed then
    Speed = C.ForceSpeed
  elseif RowSpeed >= 100 then
    Speed = RowSpeed
  else
    local V = self.CurrentVelocity
    Speed = V and Len3(V.X, V.Y, V.Z) or 0
    if Speed < 100 then
      Speed = 1200
    end
  end
  self.FlySpeed = Speed
  self:_ResolveCloseTurn()
  self:_BuildPath()
end

function M:_ResolveCloseTurn()
  local Rad = (self.C or CFG).MaxTraceRadSpeed
  local RFar = Rad and Rad > 0 and self.FlySpeed / Rad or 0
  self._CloseDist = RFar * CLOSE_DIST_FACTOR
  self._CloseRadius = GetSelfRadius(self) + TARGET_CAPSULE_EST
end

function M:_ApplyDir(dx, dy, dz)
  local S = self.FlySpeed
  self.CurrentVelocity = FVector(dx * S, dy * S, dz * S)
  self.MoveSpeed = S
end

function M:UpdateHoming(Target, DeltaSeconds)
  local C = self.C or CFG
  local V = self.CurrentVelocity
  if not V then
    return
  end
  local cx, cy, cz = Norm3(V.X, V.Y, V.Z)
  if not cx then
    return
  end
  local ax, ay, az
  if Target.GetHitCapsulePosition then
    local Ok, Pos = pcall(Target.GetHitCapsulePosition, Target)
    if Ok and Pos then
      ax, ay, az = Pos.X, Pos.Y, Pos.Z
    else
      local P2 = Target:K2_GetActorLocation()
      ax, ay, az = P2.X, P2.Y, P2.Z
    end
  else
    local P2 = Target:K2_GetActorLocation()
    ax, ay, az = P2.X, P2.Y, P2.Z
  end
  az = az + C.AimHeightOffset
  if self.AimJitter then
    ax, ay, az = ax + self.AimJitter.X, ay + self.AimJitter.Y, az + self.AimJitter.Z
  end
  local Pos = self:K2_GetActorLocation()
  local dx, dy, dz = Norm3(ax - Pos.X, ay - Pos.Y, az - Pos.Z)
  if not dx then
    return
  end
  local Dist = Len3(ax - Pos.X, ay - Pos.Y, az - Pos.Z)
  local RadSpeed = C.MaxTraceRadSpeed
  local CloseDist, CloseRadius = self._CloseDist, self._CloseRadius
  if CloseDist and CloseRadius and Dist < CloseDist then
    local Need = self.FlySpeed / CloseRadius
    if RadSpeed < Need then
      RadSpeed = Need
    end
  end
  local nx, ny, nz = TurnToward(cx, cy, cz, dx, dy, dz, RadSpeed * DeltaSeconds)
  self:_ApplyDir(nx, ny, nz)
end

function M:_BuildPath()
  local C = self.C or CFG
  local P0 = self:K2_GetActorLocation()
  local dx, dy, dz
  local V = self.CurrentVelocity
  if V then
    dx, dy, dz = Norm3(V.X, V.Y, V.Z)
  end
  if not dx then
    local F = self:GetActorForwardVector()
    if F then
      dx, dy, dz = Norm3(F.X, F.Y, F.Z)
    end
  end
  if not dx then
    dx, dy, dz = 1, 0, 0
  end
  local ux, uy, uz
  local U = self:GetActorUpVector()
  if U then
    ux, uy, uz = Norm3(U.X, U.Y, U.Z)
  end
  if not ux then
    ux, uy, uz = 0, 0, 1
  end
  local rx, ry, rz = Norm3(dy * uz - dz * uy, dz * ux - dx * uz, dx * uy - dy * ux)
  if not rx then
    rx, ry, rz = Norm3(dy * 1 - dz * 0, dz * 0 - dx * 1, 0)
    if not rx then
      rx, ry, rz = 0, 1, 0
    end
    ux, uy, uz = Norm3(ry * dz - rz * dy, rz * dx - rx * dz, rx * dy - ry * dx)
    if not ux then
      ux, uy, uz = 0, 0, 1
    end
  end
  local TimeLife = self._Row and self._Row.TimeLife or 0
  local AimDist
  if TimeLife and TimeLife > 0 then
    AimDist = self.FlySpeed * TimeLife / C.ConvergeRatio
  else
    AimDist = C.AimPointLengthFallback
  end
  if C.ConvergeMaxDist and C.ConvergeMaxDist > 0 and AimDist > C.ConvergeMaxDist then
    AimDist = C.ConvergeMaxDist
  end
  if AimDist < 100 then
    AimDist = 100
  end
  local Pts = {P0}
  local Last = #C.PathCtrlPoints
  for Idx, Ctrl in ipairs(C.PathCtrlPoints) do
    local L = AimDist * self:_RandIn(Ctrl[1], Ctrl[2])
    local VV = Ctrl[3] * C.PathSpreadScale
    if C.PathConvergeFix and Idx == Last then
      VV = 0
    end
    local OffU = self:_RandIn(-VV, VV)
    local OffR = self:_RandIn(-VV, VV)
    Pts[#Pts + 1] = FVector(P0.X + dx * L + ux * OffU + rx * OffR, P0.Y + dy * L + uy * OffU + ry * OffR, P0.Z + dz * L + uz * OffU + rz * OffR)
  end
  local Dur = AimDist / self.FlySpeed * C.PathDurScale
  if Dur < 0.05 then
    Dur = 0.05
  end
  self.Path = {
    Pts = Pts,
    Len = AimDist,
    Dur = Dur
  }
  self.PathT = 0
  self.PathDone = false
  if 0 ~= C.HomingAimJitter then
    local JX = self:_RandIn(-C.HomingAimJitter, C.HomingAimJitter)
    local JY = self:_RandIn(-C.HomingAimJitter, C.HomingAimJitter)
    self.AimJitter = FVector(rx * JX + ux * JY, ry * JX + uy * JY, rz * JX + uz * JY)
  else
    self.AimJitter = nil
  end
end

function M:_PathPosXYZ(T)
  local Path = self.Path
  if not Path or not Path.Pts then
    return nil
  end
  T = Clamp(T, 0, 1)
  local Pts = Path.Pts
  local n = #Pts
  if n < 2 then
    return nil
  end
  local WX, WY, WZ = self._WX, self._WY, self._WZ
  if not WX or #WX ~= n then
    WX, WY, WZ = {}, {}, {}
    self._WX, self._WY, self._WZ = WX, WY, WZ
  end
  for i = 1, n do
    local p = Pts[i]
    WX[i], WY[i], WZ[i] = p.X, p.Y, p.Z
  end
  for k = 1, n - 1 do
    for i = 1, n - k do
      local j = i + 1
      WX[i] = WX[i] + (WX[j] - WX[i]) * T
      WY[i] = WY[i] + (WY[j] - WY[i]) * T
      WZ[i] = WZ[i] + (WZ[j] - WZ[i]) * T
    end
  end
  return WX[1], WY[1], WZ[1]
end

function M:_AdvancePath(DeltaSeconds)
  local C = self.C or CFG
  local Path = self.Path
  if not Path or Path.Dur <= 0 then
    return
  end
  self.PathT = (self.PathT or 0) + DeltaSeconds / Path.Dur
  if self.PathT >= 1 then
    self.PathT = 1
    self.PathDone = true
    return
  end
  local T = self.PathT
  local Look = C.PathLookahead or 0
  if Look > 0 and Path.Len > 0 then
    T = math.min(1, T + Look / Path.Len)
  end
  local tx, ty, tz = self:_PathPosXYZ(T)
  if not tx then
    return
  end
  local Pos = self:K2_GetActorLocation()
  local dx, dy, dz = Norm3(tx - Pos.X, ty - Pos.Y, tz - Pos.Z)
  if not dx then
    return
  end
  local MaxRad = C.PathTurnRate and C.PathTurnRate * DeltaSeconds or nil
  local cx, cy, cz
  local V = self.CurrentVelocity
  if V then
    cx, cy, cz = Norm3(V.X, V.Y, V.Z)
  end
  if not MaxRad or not cx then
    self:_ApplyDir(dx, dy, dz)
    return
  end
  local nx, ny, nz = TurnToward(cx, cy, cz, dx, dy, dz, MaxRad)
  self:_ApplyDir(nx, ny, nz)
end

function M:_DestroyNoTarget()
  self:DestroyCreature()
end

return M

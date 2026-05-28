local BattleDumpUtils = require("BluePrints.Client.BattleDumpUtils")
local HitResult = FHitResult()
local M = {}

function M:Init()
  self.WeaponCoroutineMap = {}
  self.WeaponCoroutineArray = {}
  EventManager:AddEvent(EventID.OnWeaponGradeLevelUp, self, self.OnWeaponGradeLevelUp)
end

local function MakeUncalculatedTrans(self)
  return UE4.UKismetMathLibrary.MakeTransform(self.UncalculatedTrans.Translation, self.UncalculatedTrans.Rotation:ToRotator(), FVector(1, 1, 1))
end

local WeaponHelperZOffset = 90

local function _InitWeaponHelperTrans(self)
  local TargetTrans = MakeUncalculatedTrans(self)
  if self.bPreviewSceneLoaded then
    TargetTrans.Translation.Z = TargetTrans.Translation.Z + WeaponHelperZOffset
  end
  local OriginalRotation = FRotator(0, 0, 0)
  self.ArmoryHelper:SetOriginalRotation(OriginalRotation)
  TargetTrans.Rotation = OriginalRotation:ToQuat()
  self.ArmoryHelper.OriginalRootTrans = TargetTrans
  local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
  WeaponHelper:K2_SetActorTransform(TargetTrans, false, HitResult, false)
  self.ArmoryHelper:SetViewActor(WeaponHelper)
  if self.bEnableReflection then
    local WeaponReflectionHelper = self.ArmoryHelper:CreateOrGetWeaponReflectionHelper()
    local ReflectionTrans = UE4.UKismetMathLibrary.MakeTransform(TargetTrans.Translation, TargetTrans.Rotation:ToRotator(), TargetTrans.Scale3D)
    ReflectionTrans.Translation.Z = ReflectionTrans.Translation.Z - WeaponHelperZOffset * 2
    ReflectionTrans.Scale3D.Z = ReflectionTrans.Scale3D.Z * -1
    WeaponReflectionHelper:K2_SetActorTransform(ReflectionTrans, false, HitResult, false)
  end
end

local function _RemoveWeaponCoroutine(self, CoroutineName)
  local Idx = self.WeaponCoroutineMap[CoroutineName]
  if Idx then
    table.remove(self.WeaponCoroutineArray, Idx)
    self.WeaponCoroutineMap[CoroutineName] = nil
    for name, index in pairs(self.WeaponCoroutineMap) do
      if index > Idx then
        self.WeaponCoroutineMap[name] = index - 1
      end
    end
  end
end

local function _AddWeaponCoroutine(self, CoroutineName, Co)
  _RemoveWeaponCoroutine(self, CoroutineName)
  table.insert(self.WeaponCoroutineArray, Co)
  self.WeaponCoroutineMap[CoroutineName] = #self.WeaponCoroutineArray
end

local function _FindWeaponCoroutine(self, CoroutineName)
  local Idx = self.WeaponCoroutineMap[CoroutineName]
  if Idx then
    return self.WeaponCoroutineArray[Idx]
  end
end

function M:DoSomethingWithWeapon(BehaviorName, Func, ...)
  local Co = _FindWeaponCoroutine(self, BehaviorName)
  if Co then
    local Status = coroutine.status(Co)
    if "running" == Status or "suspended" == Status then
      coroutine.close(Co)
      _RemoveWeaponCoroutine(self, BehaviorName)
    end
  end
  Co = coroutine.create(Func)
  _AddWeaponCoroutine(self, BehaviorName, Co)
  coroutine.resume(Co, ...)
end

function M:DoDeferedWeaponBehavior()
  local WeaponCoroutineArray = {}
  for _, value in ipairs(self.WeaponCoroutineArray) do
    table.insert(WeaponCoroutineArray, value)
  end
  self.WeaponCoroutineArray = {}
  self.WeaponCoroutineMap = {}
  for _, Co in ipairs(WeaponCoroutineArray) do
    coroutine.resume(Co)
  end
end

function M:IsWeaponActorLoading()
  return self.IsArmoryWeaponLoading
end

function M:ChangeWeaponModel(WeaponData, bIfNoDelay, bForceChange)
  self:ResetActorRotation()
  local PlayCharacter = self:GetPlayerActor()
  if self.CurrentWeaponInfo == WeaponData and PlayCharacter then
    local WeaponTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
    local PlayerWeapon = PlayCharacter[WeaponTag .. "Weapon"]
    if PlayerWeapon and not bForceChange then
      return
    end
  end
  local OldWeaponData = self.CurrentWeaponInfo
  if self.IsPreviewMode and (not PlayCharacter or PlayCharacter.bHidden) and self.ViewActorType == self.ViewActorTypes.SingleWeapon then
    if OldWeaponData == WeaponData and not bForceChange then
      return
    end
    return self:ChangeSingleWeapon(WeaponData, bIfNoDelay)
  end
  self.bPlaySameMontage = true
  return self:ChangePlayerWeapon(WeaponData, PlayCharacter)
end

function M:OnWeaponGradeLevelUp(Ret, WeaponUuid, CurrentGradeLevel, ConsumeWeaponUuids)
  local Avatar = self:GetAvatar()
  local Weapon = Avatar.Weapons[WeaponUuid]
  if not Weapon then
    return
  end
  self:ChangeWeaponFashion(Weapon)
end

function M:ChangeWeaponFashion(WeaponData, bIfNoDelay, bForceChange)
  self:ResetActorRotation()
  local PlayCharacter = self:GetPlayerActor()
  return self:ChangePlayerWeaponFashion(WeaponData, PlayCharacter)
end

function M:ChangePlayerWeaponFashion(WeaponData, Player)
  self.CurrentWeaponInfo = WeaponData
  self.CurrentWeaponAppearanceInfo = WeaponData:DumpAppearanceInfo()
  local WeaponTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
  
  local function ChangePlayerWeaponFashionInternal(PlayCharacter)
    if nil == PlayCharacter then
      return
    end
    local Avatar = self:GetAvatar()
    if not Avatar then
      return
    end
    local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, WeaponData)
    WeaponInfos = WeaponInfos and WeaponInfos[WeaponTag .. "Weapon"]
    local Weapon = PlayCharacter:GetWeapon(WeaponData.WeaponId)
    if WeaponInfos.GradeLevel > 0 then
      Weapon.WeaponFashion:ApplyHyperWeaponMaterialEffect(WeaponInfos.GradeLevel)
    end
  end
  
  ChangePlayerWeaponFashionInternal(Player)
  local PlayerReflection = self:GetReflectionActor(Player)
  ChangePlayerWeaponFashionInternal(PlayerReflection)
end

function M:PlayWeaponAppearFX()
  local function _PlayWeaponAppearFX(...)
    local WeaponActor = self:GetWeaponActor()
    
    if WeaponActor then
      self:PlayAppearFX(WeaponActor.FXComponent)
    end
  end
  
  self:DoSomethingWithWeapon("PlayWeaponAppearFX", _PlayWeaponAppearFX)
end

function M:ChangePlayerWeapon(WeaponData, Player)
  self.CurrentWeaponInfo = WeaponData
  self.CurrentWeaponAppearanceInfo = WeaponData:DumpAppearanceInfo()
  local WeaponTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
  
  local function ChangePlayerWeaponInternal(PlayCharacter)
    if nil == PlayCharacter then
      return
    end
    self:DestroyPlayerWeapon(PlayCharacter, WeaponTag)
    local Avatar = self:GetAvatar()
    if not Avatar then
      return
    end
    local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, WeaponData)
    WeaponInfos = WeaponInfos and WeaponInfos[WeaponTag .. "Weapon"]
    local Weapon = PlayCharacter:AddWeapon(WeaponData.WeaponId, WeaponInfos)
    Weapon:InitWeaponAppearance(WeaponData:DumpAppearanceInfo())
    PlayCharacter.UsingWeapon = Weapon
    Weapon:SetWeaponTypeChanged(true)
    Weapon:SetActorHiddenInGame(true)
    Weapon:OnWeaponReady()
  end
  
  ChangePlayerWeaponInternal(Player)
  local PlayerReflection = self:GetReflectionActor(Player)
  ChangePlayerWeaponInternal(PlayerReflection)
end

function M:DestroyPlayerMeleeWeapon(PlayCharacter)
  self:DestroyPlayerWeapon(PlayCharacter, "Melee")
end

function M:DestroyPlayerRangedWeapon(PlayCharacter)
  self:DestroyPlayerWeapon(PlayCharacter, "Ranged")
end

function M:DestroyPlayerWeapon(PlayCharacter, WeaponTag)
  WeaponTag = WeaponTag or "Melee"
  PlayCharacter = PlayCharacter or self.ArmoryPlayer
  
  local function DestroyPlayerWeaponInternal(PlayCharacter)
    if nil == PlayCharacter then
      return
    end
    local PlayerWeapon = PlayCharacter[WeaponTag .. "Weapon"]
    if PlayerWeapon then
      PlayCharacter.Weapons:Remove(PlayerWeapon.WeaponId)
      PlayerWeapon:Destroy()
    end
    PlayCharacter[WeaponTag .. "Weapon"] = nil
  end
  
  DestroyPlayerWeaponInternal(PlayCharacter)
  local PlayerReflection = self:GetReflectionActor(PlayCharacter)
  DestroyPlayerWeaponInternal(PlayerReflection)
end

function M:DestroyAllPlayerWeapons()
  local PlayCharacter = self:GetPlayerActor()
  self:DestroyPlayerMeleeWeapon(PlayCharacter)
  self:DestroyPlayerRangedWeapon(PlayCharacter)
end

function M:AddPlayerUltraWeapons(Player)
  local Avatar = self.CurrentCharFromAvatar or self:GetAvatar()
  local UltraWeapons = BattleDumpUtils:GetDefaultUltraWeaponInfo(Avatar, self.CurrentCharInfo)
  for Index, value in ipairs(UltraWeapons) do
    local WeaponInfos = AvatarUtils:GetWeaponBattleInfo(Avatar, value.UltraWeapon)
    local WeaponInfo
    if WeaponInfos.MeleeWeapon.WeaponId then
      WeaponInfo = WeaponInfos.MeleeWeapon
    elseif WeaponInfos.RangedWeapon.WeaponId then
      WeaponInfo = WeaponInfos.RangedWeapon
    end
    Player:AddWeapon(WeaponInfo.WeaponId, WeaponInfo, Index)
  end
end

function M:ChangePlayerWeaponByType(WeaponType, Player)
  Player = Player or self.ArmoryPlayer
  Player:ChangeUsingWeaponByType(nil)
  if nil == WeaponType then
    return
  end
  local Weapon = Player:GetWeaponByWeaponTag(self.LastMontageAndCameraTag, 1)
  local Avatar = self:GetAvatar()
  if not Avatar then
    return
  end
  if nil == Weapon then
    local WeaponData
    if "Melee" == WeaponType then
      WeaponData = Avatar.Weapons[Avatar.MeleeWeapon]
    elseif "Ranged" == WeaponType then
      WeaponData = Avatar.Weapons[Avatar.RangedWeapon]
    else
      return
    end
    self:ChangePlayerWeapon(WeaponData, Player)
  end
  Player:ChangeUsingWeaponByType(self.LastMontageAndCameraTag)
  if Player.UsingWeapon then
    Player.UsingWeapon:SetWeaponTypeChanged(true)
  end
end

function M:ChangeSingleWeapon(WeaponData, bNoFX)
  self.ViewActorType = self.ViewActorTypes.SingleWeapon
  self.CurrentWeaponInfo = WeaponData
  self.CurrentWeaponAppearanceInfo = WeaponData:DumpAppearanceInfo()
  self:BeforeViewActorChanged()
  self:SetSingleWeaponCamera(WeaponData)
  if self.IsArmoryWeaponLoading then
    self.NextWeaponDataToLoad = WeaponData
    return
  end
  self.NextWeaponDataToLoad = nil
  self.IsArmoryWeaponLoading = true
  local FXComponent
  if IsValid(self.ArmoryWeapon) then
    FXComponent = self.ArmoryWeapon.FXComponent
  end
  FXComponent = FXComponent or self.ArmoryPlayer and self.ArmoryPlayer.FXComponent
  local UIManager = UIManager(self.ViewUI)
  UIManager:CreateShowWeapon(self, {
    WeaponId = WeaponData.WeaponId,
    AppearanceInfo = WeaponData:DumpAppearanceInfo(),
    bEnableReflection = self.bEnableReflection
  }, function(WeaponActor, WeaponReflection)
    self:OnArmoryWeaponLoaded(WeaponActor, WeaponReflection)
    self:SetWeaponActorEnhanceLevel(WeaponData.EnhanceLevel)
  end)
  if bNoFX then
    return true
  end
  self:HideWeaponActor("WeaponDisappearFX", true)
  self.DelayFrame = 30
  self:PlayDisappearFX(FXComponent, function()
    self:HideWeaponActor("WeaponDisappearFX", false)
    self:PlayWeaponAppearFX()
  end)
  return true
end

function M:GetSingleWeaponTag(WeaponData)
  local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
  if not WeaponHelper then
    return
  end
  WeaponData = WeaponData or self.CurrentWeaponInfo
  if self.SingleWeaponTagFrom == WeaponData then
    return self.SingleWeaponTag
  end
  local Tags = WeaponData:GetTags()
  local Tag2Distance = WeaponHelper.CamDistance:ToTable()
  for key, value in pairs(Tags) do
    if Tag2Distance[key] then
      self.SingleWeaponTag = key
      self.SingleWeaponTagFrom = WeaponData
      return self.SingleWeaponTag
    end
  end
end

function M:SetSingleWeaponCameraStartInfo(WeaponData)
  _InitWeaponHelperTrans(self)
  local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
  local WeaponTag = self:GetSingleWeaponTag(WeaponData)
  local Distance = WeaponHelper.CamDistance:ToTable()[WeaponTag] or 0
  local ViewActorLocation = self.ArmoryHelper:K2_GetActorLocation()
  local Rotation = UKismetMathLibrary.FindLookAtRotation(ViewActorLocation + WeaponHelper:GetActorRightVector(), ViewActorLocation)
  local Offset = UKismetMathLibrary.GetForwardVector(Rotation) * -Distance
  local Location = ViewActorLocation + Offset
  self.ArmoryHelper:SetCameraStartInfo(Location, Rotation)
end

function M:SetSingleWeaponCamera(WeaponData, bKeepTransform)
  if not bKeepTransform then
    _InitWeaponHelperTrans(self)
  end
  local WeaponHelper = self.ArmoryHelper:CreateOrGetWeaponHelper()
  local WeaponTag = self:GetSingleWeaponTag(WeaponData)
  local Distance = WeaponHelper.CamDistance:ToTable()[WeaponTag] or 0
  local ViewActorLocation = self.ArmoryHelper:K2_GetActorLocation()
  local CalcRightVector
  if bKeepTransform then
    CalcRightVector = UKismetMathLibrary.GetRightVector(FRotator(0, 0, 0))
  else
    CalcRightVector = WeaponHelper:GetActorRightVector()
  end
  local Rotation = UKismetMathLibrary.FindLookAtRotation(ViewActorLocation + CalcRightVector, ViewActorLocation)
  local Offset = UKismetMathLibrary.GetForwardVector(Rotation) * -Distance
  if self.ExCameraOffset then
    Offset = Offset + self.ExCameraOffset
  end
  self.ArmoryHelper:TransformCamera(Offset, Rotation, 0.5)
  local FOV = 70
  if WeaponHelper.CamFOV then
    FOV = WeaponHelper.CamFOV:ToTable()[WeaponTag] or 70
  end
  self.ArmoryHelper:StartFOVAnim(FOV, 0.5, 14)
  local MinDistance = WeaponHelper.CamDistance_Min:ToTable()[WeaponTag] or 0
  local MinLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MinDistance
  local MaxDistance = WeaponHelper.CamDistance_Max:ToTable()[WeaponTag] or 0
  local MaxLocation = UKismetMathLibrary.GetForwardVector(Rotation) * -MaxDistance
  if self.ExCameraOffset then
    MaxLocation = MaxLocation + self.ExCameraOffset
    self.ExCameraOffset = nil
  end
  self.ArmoryHelper:SetCameraScrollRange(MinLocation, MaxLocation, 0.5)
  if 0 ~= MinDistance or 0 ~= MaxDistance then
    self.ArmoryHelper.EnableCameraScrolling = true
  end
end

function M:OnArmoryWeaponLoaded(WeaponActor, WeaponReflection)
  self.IsArmoryWeaponLoading = false
  if self.bDestructed then
    DebugPrint("Error: 预览武器加载完成回调错误，可能是ActorController没有正确销毁")
    return
  end
  if self.NextWeaponDataToLoad then
    self:ChangeSingleWeapon(self.NextWeaponDataToLoad)
    return
  end
  self.ArmoryWeapon = WeaponActor
  self:SetReflectionActor(WeaponActor, WeaponReflection)
  self:SetReflectionActor(self.ArmoryHelper:CreateOrGetWeaponHelper(), self.ArmoryHelper:CreateOrGetWeaponReflectionHelper())
  CommonUtils:SetActorTickableWhenPaused(WeaponActor, true)
  self:SetAccessoriesTickableWhenPaused(WeaponActor.Accessories)
  self.ArmoryHelper:SetWeapon(self.ArmoryWeapon, self:GetReflectionActor(self.ArmoryWeapon))
  if self.ViewActorType == self.ViewActorTypes.SingleWeapon then
    self.ArmoryHelper:SetViewActor(self.ArmoryWeapon)
  end
  if WeaponReflection then
    CommonUtils:SetActorTickableWhenPaused(WeaponReflection, true)
    self:SetAccessoriesTickableWhenPaused(WeaponReflection.Accessories)
  end
  self:ResetActorRotation()
  self:DoDeferedWeaponBehavior()
  if self.ViewActorType ~= self.ViewActorTypes.SingleWeapon then
    self:HideWeaponActor(self.UIName, true)
  end
end

function M:GetWeaponActor()
  if self.IsArmoryWeaponLoading then
    if coroutine.isyieldable() then
      coroutine.yield()
    else
      return
    end
  end
  if IsValid(self.ArmoryWeapon) then
    return self.ArmoryWeapon
  end
  if not self.ArmoryPlayer or not self.CurrentWeaponInfo then
    return
  end
  if self.CurrentWeaponInfo:HasTag("Melee") then
    return self.ArmoryPlayer.MeleeWeapon
  else
    return self.ArmoryPlayer.RangedWeapon
  end
end

function M:GetWeaponActorAsync(Callback, Owner)
  local function _GetWeaponActorAsync(Callback, Owner)
    local WeaponActor = self:GetWeaponActor()
    
    if Callback then
      Callback(Owner, WeaponActor)
    end
  end
  
  self:DoSomethingWithWeapon("GetWeaponActorAsync", _GetWeaponActorAsync, Callback, Owner)
end

function M:GetSingleWeaponActor()
  if self.IsArmoryWeaponLoading then
    if coroutine.isyieldable() then
      coroutine.yield()
    else
      return
    end
  end
  if IsValid(self.ArmoryWeapon) then
    return self.ArmoryWeapon
  end
end

function M:GetSingleWeaponReflection()
end

function M:GetPlayerWeaponActor()
  if self.IsArmoryWeaponLoading then
    if coroutine.isyieldable() then
      coroutine.yield()
    else
      return
    end
  end
  if not self.ArmoryPlayer or not self.CurrentWeaponInfo then
    return
  end
  if self.CurrentWeaponInfo:HasTag("Melee") then
    return self.ArmoryPlayer.MeleeWeapon
  else
    return self.ArmoryPlayer.RangedWeapon
  end
end

function M:HideWeaponActor(Tag, IsHidden)
  local function _HideWeaponActor(...)
    local WeaponActor = self:GetWeaponActor()
    
    local function func(Actor)
      if Actor then
        if Tag then
          Actor:SetActorHideTag(Tag, IsHidden)
        else
          Actor:SetActorHiddenInGame(IsHidden)
        end
      end
    end
    
    func(WeaponActor)
    func(self:GetReflectionActor(WeaponActor))
  end
  
  self:DoSomethingWithWeapon("HideWeaponActor", _HideWeaponActor)
end

function M:BeforeViewActorChanged()
  if self.ViewActorType == self.ViewActorTypes.SingleWeapon then
    self:HideWeaponActor(self.UIName, true)
  end
end

function M:AfterViewActorChanged()
  self:HideWeaponActor(self.UIName, false)
end

function M:WeaponLvUpOrBreakUp()
  local function WeaponLvUpOrBreakUpInternal(WeaponActor)
    if nil == WeaponActor then
      return
    end
    WeaponActor.FXComponent:PlayEffectByIDParams(304, {bTickEvenWhenPaused = true, NotAttached = true})
  end
  
  WeaponLvUpOrBreakUpInternal(self.ArmoryPlayer.UsingWeapon)
  WeaponLvUpOrBreakUpInternal(self:GetReflectionActor(self.ArmoryPlayer.UsingWeapon))
end

function M:Component_DestroyActors()
  self.CurrentWeaponInfo = nil
  local UIManager = UIManager(self.ViewUI)
  if IsValid(self.ArmoryWeapon) then
    self.ArmoryWeapon:SetActorHideTag(self.UIName, false)
  end
  UIManager:DestroyShowWeapon(self)
end

function M:Component_OnDestruct()
  EventManager:RemoveEvent(EventID.OnWeaponGradeLevelUp, self)
end

return M

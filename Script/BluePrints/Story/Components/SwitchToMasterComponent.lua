local FSwitchToMasterComponent = {}
local ClassPath = "/Game/BluePrints/Common/EMNiagaraFunctionLibrary"

function FSwitchToMasterComponent:New(MasterType, TalkTaskData)
  DebugPrint("FSwitchToMasterComponent@ New")
  local SwitchToMasterComponent = setmetatable({}, {__index = FSwitchToMasterComponent})
  SwitchToMasterComponent.TalkTaskData = TalkTaskData
  SwitchToMasterComponent.MasterType = MasterType
  return SwitchToMasterComponent
end

function FSwitchToMasterComponent:Execute()
  DebugPrint("FSwitchToMasterComponent@ 切换为主角")
  local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not IsValid(Player) then
    local Message = "FSwitchToMasterComponent:Execute(), 对话节点切换主角时，玩家PlayerCharacter无效\n"
    local Title = "PlayerCharacter无效"
    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
    DebugPrint("lhr@玩家PlayerCharacter无效\n")
    return
  end
  if Player.ChangeRoleTimer then
    Player:RemoveTimer(Player.ChangeRoleTimer)
    Player.ChangeRoleTimer = nil
  end
  if -1 == self.TalkTaskData.BlendInTime then
    return
  end
  if self.MasterType == "None" then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    GWorld.logger.error("FSwitchToMasterComponent@没有正常登录")
    Avatar = {
      Sex = 0,
      WeitaSex = 1,
      CharacterAttributeSwitch = {}
    }
  end
  local RealMasterType, MasterGender, MasterRoleId
  if self.MasterType == "Player" then
    MasterGender = Avatar.Sex
    MasterRoleId = Avatar.CharacterAttributeSwitch[MasterGender]
    RealMasterType = "PlayerLight"
  else
    MasterGender = Avatar.WeitaSex
  end
  if not MasterRoleId then
    RealMasterType = RealMasterType or self.MasterType
    local MasterInfo = DataMgr.Player2RoleId[RealMasterType]
    if not MasterInfo then
      GWorld.logger.error("FSwitchToMasterComponent@没有找到对应的主角信息，请检查导表" .. RealMasterType)
      return
    end
    local GenderInfo = MasterInfo[MasterGender]
    if not GenderInfo then
      GWorld.logger.error("FSwitchToMasterComponent@对应性别没有角色，请检查导表")
      return
    end
    MasterRoleId = GenderInfo
  end
  print(_G.LogTag, "FSwitchToMasterComponent@ChangeToMaster", MasterRoleId, MasterGender)
  Player.HeroTempInfo = {
    QuestRoleID = Player.AvatarQuestRoleID,
    RoleInfo = {
      PlayerHp = Player:GetAttr("Hp"),
      PlayerSp = Player:GetAttr("Sp"),
      PlayerES = Player:GetAttr("ES")
    },
    RangedWeapon = {
      BulletNum = Player.RangedWeapon and Player.RangedWeapon:GetAttr("BulletNum") or 0,
      MagazineBulletNum = Player.RangedWeapon and Player.RangedWeapon:GetAttr("MagazineBulletNum") or 0
    }
  }
  Avatar.HeroTempInfo = Player.HeroTempInfo
  if Player:GetController():GetClass():GetName() == "TalkAIController" then
    self.TalkAIController = Player:GetController()
    self.PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
    self.TalkPawn = self.PlayerController.Pawn
    self.TalkAIController:UnPossess(Player)
    self.PlayerController:Possess(Player)
  end
  Player:EnableRimLightModel(false)
  local bUseSkin = GWorld.GameInstance.IsAutoFashionSwitch
  if nil == bUseSkin then
    bUseSkin = EMCache:Get("AutoFashion") or false
  end
  DebugPrint("FSwitchToMasterComponent@Execute: bUseSkin is", bUseSkin, ", Cache is", EMCache:Get("AutoFashion"))
  local DefaultAppearanceSuit = {
    AccessorySuit = Player.CharacterFashion:GetDefaultAccessorySuit()
  }
  local AvatarInfo = {
    AppearanceSuit = bUseSkin and self:GetServerAppearanceSuitByCharId(MasterRoleId) or DefaultAppearanceSuit
  }
  Player:ChangeRole(MasterRoleId, AvatarInfo)
  Player:RealChangeUsingWeapon(nil)
  Player:BanSkills()
  Player:ChangeRoleEffect()
  local BodyType = Player:GetBattleCharBodyType()
  Player.FXComponent:PlayEffectByIDParams(401, {
    NotAttached = true,
    scale = Const.BattleCharTagVXScaleTable[BodyType]
  })
  if self.TalkAIController then
    self.PlayerController:Possess(self.TalkPawn)
    self.TalkAIController:Possess(Player)
    self.TalkAIController, self.PlayerController, self.TalkPawn = nil, nil, nil
  end
end

function FSwitchToMasterComponent:GetServerAppearanceSuitByCharId(CharId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  for key, Char in pairs(Avatar.Chars) do
    if Char.CharId == CharId then
      local AppearanceSuit = Char:DumpAppearanceSuit(Avatar)
      return AppearanceSuit
    end
  end
  return nil
end

function FSwitchToMasterComponent:Resume()
  DebugPrint("FSwitchToMasterComponent@FSwitchToMasterComponent 解除切换主角")
  if -1 == self.TalkTaskData.BlendOutTime then
    return
  end
  local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if not Player.HeroTempInfo then
    return
  end
  if not IsValid(Player) then
    local Message = "FSwitchToMasterComponent:Resume(), 对话节点切换主角时，玩家PlayerCharacter无效\n"
    local Title = "PlayerCharacter无效"
    UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Talk, Title, Message)
    DebugPrint("FSwitchToMasterComponent:Resume(), 玩家PlayerCharacter无效\n")
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("FSwitchToMasterComponent:Resume(), Avatar无效\n")
    return
  end
  local PlayerController = UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  if Player:GetController():GetClass():GetName() == "TalkAIController" and not self.SeamlessBlendOut then
    self.TalkAIController = Player:GetController()
    self.PlayerController = PlayerController
    self.TalkPawn = self.PlayerController.Pawn
    self.TalkAIController:UnPossess(Player)
    self.PlayerController:Possess(Player)
  end
  Player:UnBanSkills()
  Player:RecoverHeroInfo()
  Player:ChangeRole(nil, PlayerController and PlayerController:GetAvatarInfo() or AvatarUtils:GetDefaultBattleInfo(Avatar))
  if Player.RangedWeapon and 0 == Player.RangedWeapon:GetAttr("MagazineBulletNum") then
    Player.RangedWeapon:SetWeaponState("NoBullet", true)
  end
  Player.ChangeRoleTimer = Player:AddTimer(0.1, function()
    Player:ChangeRoleEffect()
    local BodyType = Player:GetBattleCharBodyType()
    Player.FXComponent:PlayEffectByIDParams(401, {
      NotAttached = true,
      scale = Const.BattleCharTagVXScaleTable[BodyType]
    })
    Player.ChangeRoleTimer = nil
  end)
  if self.TalkAIController then
    self.PlayerController:Possess(self.TalkPawn)
    self.TalkAIController:Possess(Player)
    self.TalkAIController, self.PlayerController, self.TalkPawn = nil, nil, nil
  end
end

return FSwitchToMasterComponent

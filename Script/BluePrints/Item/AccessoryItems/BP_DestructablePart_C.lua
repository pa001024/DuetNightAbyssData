require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local UIUtils = require("Utils.UIUtils")
local GMVariable = require("BluePrints.UI.GMInterface.GMVariable")
local BP_DestructablePart_C = Class("BluePrints.Combat.Skill.BP_MechanismSummon_C")
local ConstInitCompleteNum = 2

function BP_DestructablePart_C:ReceiveBeginPlay()
  self.Overridden.ReceiveBeginPlay(self)
  self.AlreadyReplicatedNum = 0
end

function BP_DestructablePart_C:InitInfoFromComponent(Owner, InfoSceneComp)
  if IsAuthority(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self.Eid = GameMode:GetBattleEid()
  end
  if not Battle(self) then
    return
  end
  Battle(self):AddEntity(self.Eid, self)
  self.LastEid = self.Eid
  self.PartId = InfoSceneComp.PartId
  self.AttachmentName = InfoSceneComp.SocketName
  self:AttachWhenReady(Owner)
  self.InitSuccess = true
  self.ServerInitSuccess = true
  self.IsDestructablePart = true
  self:SetBool("IsDestructPart", true)
end

function BP_DestructablePart_C:GetBattleInfo()
  self.BattleCharInfo = DataMgr.BattleMonster[self.InfoId]
end

function BP_DestructablePart_C:InitInfo(Owner, AttachmentName, TableInfo)
  if IsAuthority(self) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    self.Eid = GameMode:GetBattleEid()
  end
  if not Battle(self) then
    return
  end
  Battle(self):AddEntity(self.Eid, self)
  self.LastEid = self.Eid
  self.PartId = TableInfo.PartId
  self.AttachmentName = AttachmentName
  self.InitSuccess = true
  self.ServerInitSuccess = true
  self:AttachWhenReady(Owner)
  self.IsDestructablePart = true
  self:SetBool("IsDestructPart", true)
end

function BP_DestructablePart_C:OnDamaged(DamageEvent)
  if not self.TransferDamage or not IsAuthority(self) then
    return
  end
  self:TryTransferDamage(self:GetDirectSource(), DamageEvent)
end

function BP_DestructablePart_C:OnRep_ServerInitSuccess()
  self.IsDestructablePart = true
  self:SetBool("IsDestructPart", true)
end

function BP_DestructablePart_C:Destroy()
  if not IsValid(self) then
    return
  end
  Battle(self):RemoveEntity(self.Eid)
  self:K2_DestroyActor()
end

return BP_DestructablePart_C

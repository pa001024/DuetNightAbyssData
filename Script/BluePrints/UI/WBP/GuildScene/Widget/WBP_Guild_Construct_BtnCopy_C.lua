require("UnLua")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.CopyActor)
end

function M:RefreshData()
  self:InitOperation()
end

function M:InitOperation()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.ActorId = self.GuildManager:GetSelectedActorGuild()
end

function M:CopyActor()
  local ModifiedState = FGuildConstructActorState()
  local Ret = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  if not Ret then
    ScreenPrint("请先选中后复制")
    return
  end
  local Operator = UE4.UGuildConstructFunctionLibrary.CopyActor(self.GuildManager, ModifiedState)
  UE4.UGuildConstructFunctionLibrary.CreateActorExec(self.GuildManager, Operator)
end

return M

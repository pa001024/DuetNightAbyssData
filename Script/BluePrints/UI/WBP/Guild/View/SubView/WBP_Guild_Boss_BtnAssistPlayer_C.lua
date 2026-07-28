require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")

local function ResolveTargetGuildId(Self)
  local TargetGuildId = tonumber(Self.TargetGuildId) or 0
  if TargetGuildId > 0 then
    return TargetGuildId
  end
  if Self.Parent and tonumber(Self.Parent.TargetGuildId) and tonumber(Self.Parent.TargetGuildId) > 0 then
    return tonumber(Self.Parent.TargetGuildId)
  end
  if Self.Parent and Self.Parent.Params and tonumber(Self.Parent.Params.TargetGuildId) and tonumber(Self.Parent.Params.TargetGuildId) > 0 then
    return tonumber(Self.Parent.Params.TargetGuildId)
  end
  return GuildModel:ResolveGuildBossDisplayGuildId(nil)
end

local function GetAssistRecordCount(GuildBossData)
  if not GuildBossData or not GuildBossData.GetAssistRecords then
    return 0
  end
  local AssistRecords = GuildBossData:GetAssistRecords()
  if AssistRecords and AssistRecords.Values then
    AssistRecords = AssistRecords:Values()
  end
  if type(AssistRecords) ~= "table" then
    return 0
  end
  if type(AssistRecords.Length) == "function" then
    return AssistRecords:Length()
  end
  return #AssistRecords
end

local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  self.Text_Desc:SetText(GText("UI_GuildBoss_Assisters") .. ": ")
  self.Key_Controller:CreateGamepadKey(UIConst.GamePadImgKey.SpecialRight)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClick)
end

function M:Init(Params)
  Params = Params or {}
  self.Parent = Params.Parent
  self.GuildBossData = Params.GuildBossData
  self.TargetGuildId = Params.TargetGuildId
  if not self.GuildBossData and self.Parent and self.Parent.Params then
    self.GuildBossData = self.Parent.Params.GuildBossData
  end
  if not self.TargetGuildId and self.Parent then
    self.TargetGuildId = self.Parent.TargetGuildId
  end
  self.PlayerCount = 0
  self:InitAssistPlayerCount()
  self.Btn_Click:SetForbidden(0 == self.PlayerCount)
end

function M:InitAssistPlayerCount()
  self.PlayerCount = GetAssistRecordCount(self.GuildBossData)
  self.Text_Num:SetText(self.PlayerCount)
end

function M:RefreshAssistPlayerData(Callback)
  local TargetGuildId = ResolveTargetGuildId(self)
  GuildModel:GetGuildBossDataByGuildId(TargetGuildId, function(GuildBossData)
    if not IsValid(self) then
      return
    end
    self.GuildBossData = GuildBossData
    self:InitAssistPlayerCount()
    self.Btn_Click:SetForbidden(0 == self.PlayerCount)
    if Callback then
      Callback()
    end
  end)
end

function M:OnBtnClick()
  self:OpenDialog()
end

function M:OpenDialog()
  self:RefreshAssistPlayerData(function()
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
    if 0 == self.PlayerCount then
      UIManager(self):ShowUITip("CommonTopTips", GText("UI_GuildBoss_NoAssisters"))
      return
    end
    local Params = {
      GuildBossData = self.GuildBossData
    }
    UIManager(self):ShowCommonPopupUI(100395, Params, self)
  end)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  local Visibility = self.IsGamepadInput and Visible or Collapsed
  self.Key_Controller:SetVisibility(Visibility)
end

function M:Handle_OnGamePadDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    self:OpenDialog()
  end
end

AssembleComponents(M)
return M

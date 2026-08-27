require("UnLua")
local GMObjectUtils = require("BluePrints.UI.GMInterface.GMObjectUtils")
local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
local WBP_GM_Tips_Common_C = Class("BluePrints.UI.GMInterface.WBP_GM_Menu_Base_C")

function WBP_GM_Tips_Common_C:InitMenu(Command)
  self.Super.InitMenu(self, Command)
  GMFunctionLibrary.RefreshTeamHallRecruitmentMenu(Command)
  self.List:ClearListItems()
  for i = 1, Command.Commands:Length() do
    Command.Commands[i].ParentWidget = self
    self.List:AddItem(Command.Commands[i])
  end
  if not Command.Initialized then
    if Command.DataFunc and GMObjectUtils[Command.DataFunc] then
      local Objs = GMObjectUtils[Command.DataFunc]()
      for index, obj in ipairs(Objs) do
        obj.ParentWidget = self
        Command.Commands:Add(obj)
        self.List:AddItem(obj)
      end
    end
    Command.Initialized = true
  end
end

function WBP_GM_Tips_Common_C:OnOpen()
  self:_BindTeamHallRecruitmentStateEvent()
  self:_RefreshTeamHallRecruitmentMenu()
end

function WBP_GM_Tips_Common_C:OnClose()
  self:_UnBindTeamHallRecruitmentStateEvent()
end

function WBP_GM_Tips_Common_C:Destruct()
  self:_UnBindTeamHallRecruitmentStateEvent()
end

function WBP_GM_Tips_Common_C:OnAvatarStatusUpdate()
  self:_RefreshTeamHallRecruitmentMenu()
end

function WBP_GM_Tips_Common_C:_RefreshTeamHallRecruitmentMenu()
  if not self:_IsTeamHallMenu() then
    return
  end
  GMFunctionLibrary.RefreshTeamHallRecruitmentMenu(self.Command)
  self:RefreshItems()
end

function WBP_GM_Tips_Common_C:_BindTeamHallRecruitmentStateEvent()
  if self.bTeamHallRecruitmentStateEventBound or not self:_IsTeamHallMenu() then
    return
  end
  EventManager:AddEvent(EventID.OnAvatarStatusUpdate, self, self.OnAvatarStatusUpdate)
  self.bTeamHallRecruitmentStateEventBound = true
end

function WBP_GM_Tips_Common_C:_UnBindTeamHallRecruitmentStateEvent()
  if not self.bTeamHallRecruitmentStateEventBound then
    return
  end
  EventManager:RemoveEvent(EventID.OnAvatarStatusUpdate, self)
  self.bTeamHallRecruitmentStateEventBound = false
end

function WBP_GM_Tips_Common_C:_IsTeamHallMenu()
  return self.Command and self.Command.Text == "联机大厅"
end

return WBP_GM_Tips_Common_C

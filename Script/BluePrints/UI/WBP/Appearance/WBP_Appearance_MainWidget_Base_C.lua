require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
end

function M:ReceiveEnterState(StackAction)
end

function M:ReceiveExitState(StackAction)
end

function M:Init(Params)
end

function M:OnTabChangeToOther()
end

function M:OnTabChangeToSelf()
end

function M:JumpLogic(JumpParams)
end

function M:OnClose()
end

function M:OnBackgroundClicked()
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
end

function M:OnParentRepeatKeyDown(MyGeometry, InKeyEvent)
end

function M:OnParentKeyUp(MyGeometry, InKeyEvent)
end

function M:UpdateBottomKeyInfo(BottomKeyInfo)
  if not (BottomKeyInfo and self.Parent) or not self.Parent.IsPC then
    return
  end
  self.Parent.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:CopyParentBottomKeyInfo()
  if not self.Parent.BottomKeyInfoList then
    return
  end
  local NewBottomKeyInfoList = {}
  for _, v in ipairs(self.Parent.BottomKeyInfoList) do
    table.insert(NewBottomKeyInfoList, v)
  end
  return NewBottomKeyInfoList
end

AssembleComponents(M)
return M

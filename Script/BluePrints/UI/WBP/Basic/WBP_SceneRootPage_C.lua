require("UnLua")
local StrLib = require("BluePrints.Common.DataStructure")
local Deque = StrLib.Deque
local Stack = StrLib.Stack
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Basic.HierarchicalLayerUtils"
}

function M:Initialize(Initializer)
  self.WidgetInHUD_Deque = Deque.New()
  self.HUDWidget = nil
end

function M:Construct()
  self:InitHUDLayer()
  self:InitListenEvent()
end

function M:Destruct()
  self:RemoveListenEvent()
  for index, value in ipairs(UIConst.HierarchicalLayer) do
    local LayerNode = self[value .. "_Overlay"]
    if LayerNode then
      LayerNode:ClearChildren()
    end
  end
end

function M:ReInit()
  self:ReInitHUDLayer()
end

function M:AddWidgetToHUD(ChildWidget, ParentNodeName, bAddToDeque)
  if not ChildWidget then
    DebugPrint("WBP_SceneStart_C:AddWidgetToHUD ChildWidget 为空")
    return
  end
  if not self.HUDWidget then
    self.HUDWidget = UIManager(self):GetUIObj("BattleMain")
    if not self.HUDWidget then
      DebugPrint("WBP_SceneStart_C:AddWidgetToHUD 找不到 BattleMain 界面")
      return
    end
  end
  local PanretNode = self.HUDWidget[ParentNodeName]
  local ParentSlot = PanretNode:AddChildToOverlay(ChildWidget)
  ParentSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  ParentSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
end

function M:InitListenEvent()
  self:AddDispatcher(EventID.LoadUI, self, self.OnSystemUILoad)
  self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
  self:ListenForInputAction("OpenGM", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenGMPanel
  })
end

function M:RemoveListenEvent()
  self:StopListeningForInputAction("OpenGM", EInputEvent.IE_Pressed)
end

function M:InitHUDLayer()
  self.HUDWidget = UIManager(self):LoadUINew("BattleMain")
end

function M:ReInitHUDLayer()
  if self.HUDWidget then
    self.HUDWidget:Close()
    self.HUDWidget = nil
  end
  if self.GMWidget then
    self.GMWidget:Close()
    self.GMWidget = nil
  end
  self:AddTimer(0.5, self.InitHUDLayer)
end

function M:OpenGMPanel()
  self.GMWidget = UIManager(self):LoadUI(nil, "GMCommandPanel", UIConst.ZORDER_FOR_GM_PANEL)
end

AssembleComponents(M)
return M

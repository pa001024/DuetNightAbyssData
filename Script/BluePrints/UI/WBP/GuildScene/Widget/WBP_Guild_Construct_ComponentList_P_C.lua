require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local Handle = UE4.UWidgetBlueprintLibrary.Handled()
local Unhandle = UE4.UWidgetBlueprintLibrary.Unhandled()

function M:Construct()
  self.bIsFocusable = true
end

function M:OnMouseButtonDown()
  Utils.ScreenPrint("OnKeyDown WBP_Guild_Construct_ComponentList_P_C")
end

function M:OnKeyDown()
end

return M

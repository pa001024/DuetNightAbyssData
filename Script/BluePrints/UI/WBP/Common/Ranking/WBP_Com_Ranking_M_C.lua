require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Common.Ranking.WBP_Com_Ranking_Base_C"
})

function M:Construct()
  self.Super.Construct(self)
end

function M:Destruct()
  self.Super.Destruct(self)
end

function M:InitMainTab()
  self.Super.InitMainTab(self)
  self.TabConfigData = {
    TitleName = GText(self.MainTab.TitleName),
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    Tabs = self.AllTabInfo,
    StyleName = "TextImage",
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  }
  self.Tab:Init(self.TabConfigData, true)
end

function M:InitBackgroundImage()
  local BgParams = self.Params.BgParams
  local BgWidgetPath = BgParams and BgParams.BgWidgetPath
  if not BgWidgetPath then
    return
  end
  local BgWidget = UIManager(self):CreateWidget(BgWidgetPath)
  if not BgWidget then
    return
  end
  self.Bg:ClearChildren()
  self.Bg:AddChild(BgWidget)
  local OffsetParams = BgParams.MobileSoltOffset
  if not OffsetParams then
    return
  end
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Bg)
  if CanvasSlot then
    local Offset = FMargin()
    Offset.Left = OffsetParams[1]
    Offset.Top = OffsetParams[2]
    Offset.Right = OffsetParams[3]
    Offset.Bottom = OffsetParams[4]
    CanvasSlot:SetOffsets(Offset)
  end
end

return M

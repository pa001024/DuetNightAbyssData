require("UnLua")
local ItemUtils = require("Utils.ItemUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_Title:SetText(GText("UI_IronSurvival_DirectionalRareDrop"))
  self.Text_Hold01:SetText(GText("UI_Consumable_HasGot"))
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Change.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
end

function M:SetData(ResourceIdList, defaultResId)
  if not ResourceIdList or 0 == #ResourceIdList then
    return
  end
  self.ResourceIdList = ResourceIdList
  self:RefreshItemDisplay(defaultResId or ResourceIdList[1])
end

function M:RefreshItemDisplay(resId)
  self.CurrentResId = resId
  local ResourceInfo = DataMgr.Resource[resId]
  if not ResourceInfo then
    return
  end
  local Content = {}
  Content.Id = resId
  Content.Icon = ItemUtils.GetItemIconPath(resId, "Resource")
  Content.ParentWidget = self
  Content.ItemType = "Resource"
  Content.Rarity = ResourceInfo.Rarity or 1
  Content.IsShowDetails = true
  Content.UIName = "StyleOfPlay"
  self.Com_Item:Init(Content)
  self.Text_ItemName:SetText(GText(ResourceInfo.ResourceName))
  local Avatar = GWorld:GetAvatar()
  local holdCount = Avatar and Avatar.Resources[resId] and Avatar.Resources[resId].Count or 0
  self.Text_Hold02:SetText(holdCount)
end

function M:OnBtnClicked()
  if self.CurrentResId then
    AudioManager(self):PlayItemSound(self, self.CurrentResId, "Click", "Resource")
  end
  if not self.ResourceIdList or 0 == #self.ResourceIdList then
    return
  end
  local OptionalItems = {}
  for _, resId in ipairs(self.ResourceIdList) do
    local info = DataMgr.Resource[resId]
    if info then
      table.insert(OptionalItems, {
        StuffId = resId,
        StuffIcon = ItemUtils.GetItemIconPath(resId, "Resource"),
        StuffName = GText(info.ResourceName),
        StuffType = "IronSurvival",
        Rarity = info.Rarity or 1,
        HaveCountNumber = 0
      })
    end
  end
  if 0 == #OptionalItems then
    return
  end
  local titleItem = self
  UIManager(self):ShowCommonPopupUI(100348, {
    Title = "UI_IronSurvival_DropSelectTitle",
    Tips = {
      "UI_IronSurvival_DropSelectDesc"
    },
    OptionalItemsList = OptionalItems,
    ParentWidget = self,
    AutoFocus = true,
    RightCallbackFunction = function(_, Data)
      local selectedId = Data and Data.OptionalAvatar and Data.OptionalAvatar.SelectedId
      if selectedId then
        titleItem:OnPopupConfirm(selectedId)
      end
    end,
    CloseBtnCallbackFunction = function()
      if type(titleItem.OnPopupClosed) == "function" then
        titleItem.OnPopupClosed()
      end
    end
  }, self)
end

function M:OnPopupConfirm(selectedId)
  if not selectedId then
    return
  end
  self:RefreshItemDisplay(selectedId)
  if type(self.OnItemSelected) == "function" then
    self.OnItemSelected(selectedId)
  end
end

return M

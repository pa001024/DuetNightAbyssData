require("UnLua")
local Common_Dialog_LuaModel_CommitItem = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_LuaModel.Common_Dialog_LuaModel_Base")

function Common_Dialog_LuaModel_CommitItem:Initialize()
  local SubmitId = self.Params.SubmitId
  local Ret = self:InitItemList(SubmitId)
  self.DialogWidget:ForbidRightBtn(not Ret)
  self:BindOnSubmitConfirmed(SubmitId)
end

function Common_Dialog_LuaModel_CommitItem:InitItemList(SubmitId)
  if not SubmitId then
    DebugPrint("Common_Dialog_LuaModel_CommitItem: SubmitId is nil")
    return
  end
  local SubmitData = DataMgr.QuestTurnInItem[SubmitId]
  if not SubmitData then
    DebugPrint("Common_Dialog_LuaModel_CommitItem: SubmitData not found for SubmitId", SubmitId)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local bAllEnough = true
  local Params = setmetatable({}, {
    __index = self.Params
  })
  Params.ItemList = {}
  if SubmitData.ItemIds then
    for i, ItemId in ipairs(SubmitData.ItemIds) do
      local Count = SubmitData.ItemCounts[i] or 1
      local HasCount = Avatar:GetResourceNum(ItemId)
      if Count > HasCount then
        bAllEnough = false
      end
      table.insert(Params.ItemList, {
        ItemId = ItemId,
        ItemType = "Resource",
        ItemNum = HasCount,
        ItemNeed = Count
      })
    end
  end
  self:HideAllGamepadShortcut()
  self.ItemSubsize:UpdateView(Params)
  return bAllEnough
end

function Common_Dialog_LuaModel_CommitItem:BindOnSubmitConfirmed(SubmitId)
  local SubmitCallback = self.Params.OnSubmitConfirmed
  local OriginalCallback = self.RightBtnClickedCallback
  local OriginalPopupData = self.PopupData
  
  function self.DialogWidget.RightBtnClickedCallback()
    local Data = self.DialogWidget:PackageResult()
    if OriginalCallback then
      OriginalCallback(self.RightBtnCallbackObj, Data, self.DialogWidget)
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_NetDelay"))
      return
    end
    self.DialogWidget.PopupData = setmetatable({}, {
      __index = self.PopupData
    })
    self.DialogWidget.PopupData.YesButtonForbiddenToast = nil
    self.DialogWidget:ForbidRightBtn(true)
    Avatar:SubmitQuestItems(SubmitId, function(Ret)
      if SubmitCallback then
        SubmitCallback(Ret)
      end
      if true == Ret then
        DebugPrint("Common_Dialog_LuaModel_CommitItem: SubmitSuccess")
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_SubmitItem_Success"))
        self.DialogWidget:OnClose()
      else
      end
      self.DialogWidget.PopupData = OriginalPopupData
    end)
  end
end

return Common_Dialog_LuaModel_CommitItem

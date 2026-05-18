require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")
local TaskUtil = require("BluePrints.UI.TaskPanel.TaskUtils")

function M:Construct()
  self.Text_ContentDesc:SetText(GText("UI_Quest_ChapterSelect_Content"))
  EventManager:AddEvent(EventID.OnBlockQuestSelect, self, self.OnBlockQuestSelect)
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.QuestList = Params.QuestList
  self.Owner = Owner
  self.List = {}
  self:InitCommonUI()
end

function M:InitCommonUI()
  if not self.QuestList then
    return
  end
  for ChapId, QuestChainId in pairs(self.QuestList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.QuestChainId = QuestChainId
    Content.ChapId = ChapId
    self.List_Item:AddItem(Content)
    table.insert(self.List, ChapId)
  end
end

function M:SetUserWidgetFocus(Widget)
  if not UIUtils.IsGamepadInput() then
    return
  end
  Widget:SetFocus()
end

function M:Destruct()
  if IsValid(self.Owner) then
    self.Owner.bShoulFocusToLastFocusedWidget = true
  end
  EventManager:RemoveEvent(EventID.OnBlockQuestSelect, self)
end

function M:OnBlockQuestSelect(SelectChapId)
  if SelectChapId then
    self.Owner:ForbidRightBtn(false)
  else
    self.Owner:ForbidRightBtn(true)
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.SelectType == "Search" then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.NUMBER, {
        ConfirmCB = {
          Obj = self,
          Func = self.ExecOnTextAfterNumInput
        },
        TextLimit = 2
      })
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
      self:ExecOnTextAfterNumInput("")
      self:SetUserWidgetFocus(self.Owner)
    end
  end
end

function M:InitGamepadView()
  if self.List_Item:GetNumItems() > 0 and self.List then
    self:NavigateToItem()
  else
    self:SetUserWidgetFocus(self.Owner)
  end
end

function M:InitKeyboardView()
  EventManager:FireEvent(EventID.OnBlockQuestSelect, TaskUtil:GetChooseCharId())
end

function M:NavigateToItem()
  local SelectChapId = TaskUtil:GetChooseCharId()
  TaskUtil:SetBlockQuestToStart()
  local Index
  for i, Data in ipairs(self.List) do
    if Data == SelectChapId then
      Index = i
      break
    else
      Index = Index or i
    end
  end
  self.List_Item:NavigateToIndex(Index - 1)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    return false
  end
end

return M

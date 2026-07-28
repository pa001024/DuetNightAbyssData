require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.CurrentIdx = 1
  self.PetNum = 0
  self.IsDefaultType = true
end

function M:Construct()
  self.TotalCount = 0
  self.PetItemMap = {}
  self.bPetSlotInitialized = false
  self.PetItems = {
    self.PetItem_1,
    self.PetItem_2,
    self.PetItem_3,
    self.PetItem_4,
    self.PetItem_5,
    self.PetItem_6
  }
  for _, Item in ipairs(self.PetItems) do
    Item:BindOnClicked(self, self.ClickItemAtIdx)
  end
  self:SetRaceViewText()
end

function M:SetTotalCount(TotalCount)
  local Count = tonumber(TotalCount) or 0
  self.TotalCount = Count
end

function M:SetPetTitleText(Text)
  self.Text_PetTitle:SetText(Text)
end

function M:UpdateInputStyle(IsUseKeyAndMouse)
  local PetKeyLeft = self.Key_Left
  local PetKeyRight = self.Key_Right
  if UIUtils.IsMobileInput() then
    PetKeyLeft:SetVisibility(ESlateVisibility.Collapsed)
    PetKeyRight:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  PetKeyLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  PetKeyRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if IsUseKeyAndMouse then
    PetKeyLeft:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "Q"}
      }
    })
    PetKeyRight:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "E"}
      }
    })
    return
  end
  PetKeyLeft:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    }
  })
  PetKeyRight:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    }
  })
end

function M:RefreshPetList(PetDataList)
  if not self.bPetSlotInitialized then
    self:InitPetSlots(PetDataList)
    return
  end
  self:UpdatePetRanks(PetDataList)
end

function M:InitPetSlots(PetDataList)
  local OrderedPetList = {}
  if type(PetDataList) == "table" then
    self.PetNum = 0
    for PetId, Data in pairs(PetDataList) do
      table.insert(OrderedPetList, Data)
      self.PetNum = self.PetNum + 1
    end
    table.sort(OrderedPetList, function(A, B)
      local ARank = A and tonumber(A.Ranking) or math.huge
      local BRank = B and tonumber(B.Ranking) or math.huge
      if ARank == BRank then
        local APetId = A and tonumber(A.PetId) or math.huge
        local BPetId = B and tonumber(B.PetId) or math.huge
        return APetId < BPetId
      end
      return ARank < BRank
    end)
  end
  for Index = 1, 6 do
    local Item = self.PetItems[Index]
    local Data = OrderedPetList[Index]
    Item:SetPetData(Data, Index, self.TotalCount)
    if Data and Data.PetId ~= nil then
      self.PetItemMap[Data.PetId] = Item
    end
  end
  self.bPetSlotInitialized = true
end

function M:UpdatePetRanks(PetDataList)
  if type(PetDataList) ~= "table" then
    return
  end
  for _, Data in pairs(PetDataList) do
    local Item = self.PetItemMap[Data.PetId]
    if Item then
      Item:UpdateRuntimeData(Data)
    end
  end
end

function M:MarkSelectedPet(PlayerId)
  for _, Item in ipairs(self.PetItems) do
    Item:SetSelectedState(Item.PetId ~= nil and Item.PetId == PlayerId)
  end
end

function M:ChooseLeft()
  if self.IsDefaultType then
    self.CurrentIdx = self.PetNum + 1
  end
  if self.CurrentIdx - 1 >= 1 then
    local Item = self.PetItems[self.CurrentIdx - 1]
    Item:OnBtnClicked()
  end
end

function M:ChooseRight()
  if self.IsDefaultType then
    self.CurrentIdx = 0
  end
  if self.CurrentIdx + 1 <= self.PetNum then
    local Item = self.PetItems[self.CurrentIdx + 1]
    Item:OnBtnClicked()
  end
end

function M:Reset2DefaultType()
  if self.IsDefaultType then
    return
  end
  self.IsDefaultType = true
  self.ParentWidget:SetCameraUpdateType(nil, false)
  self:SetRaceViewText()
  self:ResetState(0)
end

function M:ClickItemAtIdx(Widget)
  if Widget and Widget.PetId then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_select_pet", nil, nil)
    self.IsDefaultType = false
    local SlotIndex = Widget.SlotIndex
    self:ResetState(SlotIndex)
    self.CurrentIdx = SlotIndex
    self.ParentWidget:SetCameraUpdateType(Widget.PetId, true)
    self:SetRaceViewText()
  end
end

function M:ResetState(CurrentIdx)
  for i = 1, 6 do
    if i ~= CurrentIdx then
      self.PetItems[i]:SetSelectState(false)
    end
  end
end

function M:SetParentWidget(ParentWidget)
  self.ParentWidget = ParentWidget
end

function M:SetRaceViewText()
  if self.IsDefaultType then
    self.Text_PetTitle:SetText(GText("UI_RaceLottery_DefaultView"))
  else
    local ShowText = string.format(GText("UI_RaceLottery_NumXPlayerView"), self.CurrentIdx)
    self.Text_PetTitle:SetText(ShowText)
  end
end

return M

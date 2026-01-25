require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  self.PanelHeight = 340
  self.ListView_Value:SetScrollBarVisibility(ESlateVisibility.Hidden)
  self.ListView_Value:SetControlScrollbarInside(true)
  self.Avatar = GWorld:GetAvatar()
  self.Text_ExpNow:SetText(GText("PlayerLevel_ExpNow"))
  self.Text_LV:SetText(self.Avatar.Level)
  local CurrentExp = self.Avatar.Exp
  if CurrentExp then
    self.Exp_Now:SetText(tostring(CurrentExp))
  end
  local LevelInfo = DataMgr.PlayerLevelUp[self.Avatar.Level]
  local MaxExp
  if LevelInfo then
    MaxExp = LevelInfo.PlayerLevelMaxExp
  end
  if MaxExp then
    self.Exp_Total:SetText(tostring(MaxExp))
  end
  if MaxExp and CurrentExp then
    local Percent = CurrentExp / MaxExp
    if Percent > 1 then
      Percent = 1
    end
    self.Progress_Exp:SetPercent(Percent)
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:Destruct()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:InitContent(Params, PopupData, Owner)
  self.Owner = Owner
  self.Parent = Params.Parent
  self:Init()
end

function M:Init()
  self:InitList()
end

function M:InitList()
  self.ListView_Value:ClearListItems()
  local PlayerExpSource = {}
  local PlayerExpSubSource = {}
  for _, SourceInfo in pairs(DataMgr.PlayerExpSource) do
    table.insert(PlayerExpSource, SourceInfo)
  end
  table.sort(PlayerExpSource, function(a, b)
    return a.Sequence > b.Sequence
  end)
  for _, SubSourceInfo in pairs(DataMgr.PlayerExpSubSource) do
    table.insert(PlayerExpSubSource, SubSourceInfo)
  end
  table.sort(PlayerExpSubSource, function(a, b)
    return a.Sequence > b.Sequence
  end)
  local CollectRewardExpRecord = self:CollectRewardExp()
  self.AllContentInfo = {}
  local SumCollectRewardExp_ExcpetQuestFake = 0
  for Index, SourceInfo in ipairs(PlayerExpSource) do
    self:SetContentInfo(SourceInfo, CollectRewardExpRecord)
    if 5 ~= SourceInfo.ID then
      SumCollectRewardExp_ExcpetQuestFake = SumCollectRewardExp_ExcpetQuestFake + (self.AllContentInfo[SourceInfo.ID].SumCollectRewardExp or 0)
    end
  end
  for Index, SourceInfo in ipairs(PlayerExpSource) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local TargetContentInfo = self.AllContentInfo[SourceInfo.ID]
    Content.ID = TargetContentInfo.ID
    Content.SourceName = TargetContentInfo.SourceName
    Content.AllSubContentInfo = TargetContentInfo.AllSubContentInfo
    Content.SumCanGetRewardExp = TargetContentInfo.SumCanGetRewardExp
    Content.SumCollectRewardExp = TargetContentInfo.SumCollectRewardExp
    if 5 == SourceInfo.ID then
      Content.SumCollectRewardExp = Content.SumCollectRewardExp - SumCollectRewardExp_ExcpetQuestFake
      for _, SubContentInfo in pairs(Content.AllSubContentInfo) do
        if SubContentInfo.Key == "Quest" then
          SubContentInfo.CollectRewardExp = SubContentInfo.CollectRewardExp - SumCollectRewardExp_ExcpetQuestFake
        end
      end
    end
    self.ListView_Value:AddItem(Content)
  end
  self:AddTimer(0.1, function()
    self.ListView_Value:ScrollToTop()
    local AllEntryHeight = 0
    local DisplayedEntries = self.ListView_Value:GetDisplayedEntryWidgets()
    for i = 1, DisplayedEntries:Length() do
      local Entry = DisplayedEntries:GetRef(i)
      local EntryHeight = Entry:GetDesiredSize().Y
      AllEntryHeight = AllEntryHeight + EntryHeight
    end
    if AllEntryHeight > self.PanelHeight then
      self.NeedShowTip = true
    else
      self.NeedShowTip = false
    end
    self:ShowGamepadScrollBtn(self.NeedShowTip)
  end)
end

function M:CollectRewardExp()
  local result = {}
  local record = self.Avatar.CollectRewardExpRecord
  if type(record) ~= "table" then
    return result
  end
  for path, _ in pairs(record) do
    local excelName, rest = tostring(path):match("^([^.]+)%.?(.*)$")
    if excelName and "" ~= excelName then
      local excel = DataMgr and DataMgr[excelName]
      if rest and "" ~= rest then
        for key in rest:gmatch("[^.]+") do
          if type(excel) ~= "table" then
            excel = nil
            break
          end
          local v = excel[key]
          if nil == v then
            local n = tonumber(key)
            if n then
              v = excel[n]
            end
            if "WeaponCardLevel" == excelName and nil == v then
              break
            end
          end
          excel = v
        end
      end
      if type(excel) == "table" then
        local exp = tonumber(excel.CollectRewardExp)
        if exp and exp > 0 then
          local bucket = result[excelName]
          if not bucket then
            bucket = {Count = 0, Exp = 0}
            result[excelName] = bucket
          end
          bucket.Count = bucket.Count + 1
          bucket.Exp = bucket.Exp + exp
        end
      end
    end
  end
  local PlayerExpRecord = self.Avatar.PlayerExpRecord
  if PlayerExpRecord[2000] then
    result.Daily = {}
    result.Daily.Exp = PlayerExpRecord[2000]
  end
  if PlayerExpRecord[2001] then
    result.Quest = {}
    result.Quest.Exp = PlayerExpRecord[2001]
  end
  return result
end

function M:ShowGamepadScrollBtn(bShow)
  if bShow then
    if self.GamepadScrollBtnIndex then
      return
    end
    self.GamepadScrollBtnIndex = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RV"}
      },
      Desc = GText("UI_Controller_Slide")
    })
  elseif self.GamepadScrollBtnIndex then
    self:HideGamepadShortcut(self.GamepadScrollBtnIndex)
    self.GamepadScrollBtnIndex = nil
  end
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    local CurrentOffset = self.ListView_Value:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset - DeltaOffset, 0, UIUtils.GetMaxScrollOffsetOfListView(self.ListView_Value))
    self.ListView_Value:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:InitKeyBoardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  self:SetFocus()
end

function M:InitKeyBoardView()
  self:SetFocus()
end

function M:SetContentInfo(SourceInfo, CollectRewardExpRecord)
  if self.AllContentInfo and self.AllContentInfo[SourceInfo.Id] then
    return
  end
  local Id = SourceInfo.ID
  self.AllContentInfo[SourceInfo.ID] = {
    ID = SourceInfo.ID,
    SourceName = SourceInfo.SourceName,
    AllSubContentInfo = {}
  }
  self.MainPlayerChar = 0
  local IdTable = {}
  if 1 == Id then
    for _, CharInfo in pairs(DataMgr.Char) do
      if not CharInfo.IsNotOpen and CharInfo.CollectRewardExp then
        if CharInfo.GenderTag then
          if CharInfo.GenderTag == self.Avatar.Sex then
            table.insert(IdTable, CharInfo.CharId)
            self.MainPlayerChar = self.MainPlayerChar + 1
          end
        else
          table.insert(IdTable, CharInfo.CharId)
        end
      end
    end
  elseif 2 == Id then
    for _, WeaponInfo in pairs(DataMgr.Weapon) do
      if not WeaponInfo.IsNotOpen and WeaponInfo.CollectRewardExp then
        table.insert(IdTable, WeaponInfo.WeaponId)
      end
    end
  elseif 3 == Id then
    local GUIDTable = {}
    for _, PetInfo in pairs(DataMgr.Pet) do
      if PetInfo.GUID and PetInfo.CollectRewardExp then
        GUIDTable[PetInfo.GUID] = 1
      end
    end
    for GUID, _ in pairs(GUIDTable) do
      table.insert(IdTable, GUID)
    end
  elseif 4 == Id then
    for _, ModInfo in pairs(DataMgr.Mod) do
      if not ModInfo.IsNotOpen and ModInfo.CollectRewardExp then
        table.insert(IdTable, ModInfo.Id)
      end
    end
  elseif 5 == Id then
  end
  local PlayerExpSubSource = {}
  for _, SubSourceInfo in pairs(DataMgr.PlayerExpSubSource) do
    if SubSourceInfo.Source == Id then
      table.insert(PlayerExpSubSource, SubSourceInfo)
    end
  end
  table.sort(PlayerExpSubSource, function(a, b)
    return a.Sequence > b.Sequence
  end)
  local SumCollectRewardExp = 0
  local SumCanGetRewardExp = 0
  for Index, SubSourceInfo in pairs(PlayerExpSubSource) do
    local SubContent = {}
    if 5 ~= SubSourceInfo.Source then
      local CanGetRewardExp = 0
      if SubSourceInfo.Key ~= "ModGuideBookTask" then
        local Data = DataMgr[SubSourceInfo.Key]
        for _, Id in pairs(IdTable) do
          local Info = Data[Id]
          if Info then
            CanGetRewardExp = CanGetRewardExp + self:GetCanGetRewardExp(Info, SubSourceInfo.Key)
          end
        end
      else
        local Data = DataMgr[SubSourceInfo.Key]
        for _, Info in pairs(Data) do
          CanGetRewardExp = CanGetRewardExp + self:GetRewardExp_ModGuideBookTask(Info)
        end
      end
      SumCanGetRewardExp = SumCanGetRewardExp + CanGetRewardExp
      SubContent.CanGetRewardExp = CanGetRewardExp
    else
      SubContent.CanGetRewardExp = nil
      SumCanGetRewardExp = nil
    end
    local CollectRewardExp = 0
    if SubSourceInfo.Key ~= "ModGuideBookTask" then
      if CollectRewardExpRecord[SubSourceInfo.Key] then
        CollectRewardExp = CollectRewardExpRecord[SubSourceInfo.Key].Exp
      end
    else
      local Data = DataMgr[SubSourceInfo.Key]
      for TaskId, ModBookQuestInfo in pairs(self.Avatar.ModBookQuests) do
        if ModBookQuestInfo.RewardsGot then
          local ModGuideBookTaskInfo = Data[TaskId]
          CollectRewardExp = CollectRewardExp + self:GetRewardExp_ModGuideBookTask(ModGuideBookTaskInfo)
        end
      end
    end
    SumCollectRewardExp = SumCollectRewardExp + CollectRewardExp
    SubContent.CollectRewardExp = CollectRewardExp
    SubContent.ID = SubSourceInfo.ID
    SubContent.Key = SubSourceInfo.Key
    SubContent.SubSourceName = SubSourceInfo.SubSourceName
    if "Char" == SubSourceInfo.Key or "Weapon" == SubSourceInfo.Key or "Pet" == SubSourceInfo.Key or "Mod" == SubSourceInfo.Key then
      SubContent.TotalNum = #IdTable
      SubContent.CurNum = 0
      if CollectRewardExpRecord[SubSourceInfo.Key] then
        SubContent.CurNum = CollectRewardExpRecord[SubSourceInfo.Key].Count
      end
      if "Char" == SubSourceInfo.Key then
        SubContent.TotalNum = SubContent.TotalNum - (self.MainPlayerChar or 0)
      end
    else
      SubContent.TotalNum = nil
      SubContent.CurNum = nil
    end
    self.AllContentInfo[Id].AllSubContentInfo[SubContent.ID] = SubContent
  end
  self.AllContentInfo[Id].SumCanGetRewardExp = SumCanGetRewardExp
  self.AllContentInfo[Id].SumCollectRewardExp = SumCollectRewardExp
end

function M:GetCanGetRewardExp(Info, Key)
  local CollectRewardExp = 0
  if type(Info) == "table" then
    if Info.CollectRewardExp then
      if "WeaponCardLevel" == Key then
        if Info.CardLevelMax then
          return Info.CollectRewardExp * Info.CardLevelMax
        else
          return Info.CollectRewardExp
        end
      else
        return Info.CollectRewardExp
      end
    else
      for _, SubInfo in pairs(Info) do
        CollectRewardExp = CollectRewardExp + self:GetCanGetRewardExp(SubInfo, Key)
      end
    end
  end
  return CollectRewardExp
end

function M:GetRewardExp_ModGuideBookTask(ModGuideBookTaskInfo)
  local RewardExp = 0
  if ModGuideBookTaskInfo.TaskReward then
    for i = 1, #ModGuideBookTaskInfo.TaskReward do
      local Reward = DataMgr.Reward[ModGuideBookTaskInfo.TaskReward[i]]
      for j, ResourceId in ipairs(Reward.Id) do
        if 2001 == ResourceId then
          RewardExp = RewardExp + Reward.Count[j][1]
        end
      end
    end
  end
  return RewardExp
end

return M

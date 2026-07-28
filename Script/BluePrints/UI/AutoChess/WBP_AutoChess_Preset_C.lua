require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitContent(Params)
  self.GameInputModeSubsystem = self.GameInputModeSubsystem or UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self.Params = Params
  self.IsSharedSquad = Params.IsSharedSquad
  self.IsEditing = Params.IsEditing
  if Params.IsSet then
    self.WS_Type:SetActiveWidgetIndex(0)
  elseif not self.IsSharedSquad then
    self.WS_Type:SetActiveWidgetIndex(1)
  end
  self.Owner = Params.Owner
  self.IsSelected = false
  self.PresetIndex = Params.PresetIndex
  self.Text_Cost_Desc:SetText(GText("UI_AutoChess_Cost"))
  self.Text_Num_Desc:SetText(GText("UI_AutoChess_MonsterCount"))
  if self.IsSharedSquad then
    self.Text_Name:SetText(GText(string.format("UI_AutoChess_Lineup%s", self.PresetIndex)))
  else
    self.Text_Name:SetText(GText(Params.GroupText))
  end
  self.Text_Add:SetText(GText("UI_AutoChess_SaveLineup"))
  self.TextEdit:SetText(GText("UI_AutoChess_Editing"))
  self:PlayAnimation(self.Normal)
  self:InitButton()
  self:InitButtonGamepadView()
  self:InitSquad()
  self:InitBuffList()
end

function M:InitSquad()
  self:RequestCachedSquadInfo()
  if not (not self.CachedSquadInfo or self:IsEmptySquadInfo(self.CachedSquadInfo[self.PresetIndex])) or self.IsSharedSquad then
    self.WS_Type:SetActiveWidgetIndex(0)
    self:RefreshList(self.CachedSquadInfo[self.PresetIndex], 1)
    if self.IsSharedSquad then
      if self.IsEditing then
        self.WS_Btn:SetActiveWidgetIndex(2)
      else
        self.WS_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    else
      self.WS_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:IsEmptySquadInfo(SquadInfo)
  if not SquadInfo then
    return true
  end
  for _, value in pairs(SquadInfo) do
    if value then
      return false
    end
  end
  return true
end

function M:RefreshList(SquadInfo, Offset)
  if not SquadInfo then
    return
  end
  self.List_Gird:ClearListItems()
  self.WS_Type:SetActiveWidgetIndex(0)
  local Num = 0
  local Cost = 0
  for ChessIndex = 0, 23 do
    local ClassPath = UIUtils.GetCommonItemContentClass()
    local Item = NewObject(ClassPath)
    if SquadInfo[ChessIndex + Offset] then
      if type(SquadInfo[ChessIndex + Offset]) == "table" and SquadInfo[ChessIndex + Offset].CombatChessId then
        Item.CombatChessId = SquadInfo[ChessIndex + Offset].CombatChessId
      else
        Item.CombatChessId = SquadInfo[ChessIndex + Offset]
      end
      Num = Num + 1
      if DataMgr.CombatChessInfo[Item.CombatChessId] then
        Cost = Cost + DataMgr.CombatChessInfo[Item.CombatChessId].DeployCost
      end
    else
      Item.IsEmpty = true
    end
    Item.ChessIndex = ChessIndex
    if Item then
      self.List_Gird:AddItem(Item)
    end
  end
  self:InitCost(Cost, Num)
end

function M:RequestCachedSquadInfo()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self.IsSharedSquad then
    if Avatar.AutoChess and Avatar.AutoChess.Squads == nil then
      DebugPrint("@@@AutoChessPreset no AutoChess GetSquadInfo")
      return
    end
    self.CachedSquadInfo = Avatar.AutoChess.Squads
  else
    if Avatar.AutoChess and nil == Avatar.AutoChess.SharedSquads then
      DebugPrint("@@@AutoChessPreset no AutoChess GetSharedSquadInfo")
      return
    end
    self.CachedSquadInfo = {}
    self.CachedBuffInfo = {}
    for index, Info in pairs(Avatar.AutoChess.SharedSquads) do
      self.CachedSquadInfo[index] = Info.Props.Squad
      self.CachedBuffInfo[index] = Info.Props.Buffs
    end
  end
end

function M:InitButton()
  self.Btn_Add.OnClicked:Clear()
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Enter:UnBindEventOnClickedByObj(self)
  self.Btn_Apply:UnBindEventOnClickedByObj(self)
  self.Btn_Rewrite:UnBindEventOnClickedByObj(self)
  self.Btn_Erase.Button_Area.OnClicked:Clear()
  if self.IsSharedSquad then
    self.Btn_Enter.Text_Button:SetText(GText("UI_AutoChess_Edit"))
  else
    self.Btn_Enter.Text_Button:SetText(GText("UI_CustomLayout_Save"))
  end
  self.Btn_Rewrite.Text_Button:SetText(GText("UI_AutoChess_CoverLineup"))
  self.Btn_Apply.Text_Button:SetText(GText("UI_AutoChess_LoadLineup"))
  self.Btn_Add.OnClicked:Add(self, self.OnClickAdd)
  self.Btn_Click.OnClicked:Add(self, function()
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_team_preset_click", "AutoChessPreset_BtnClick", nil)
    self:OnClickPreset()
  end)
  self.Btn_Enter:BindEventOnClicked(self, self.OnClickEnter)
  self.Btn_Apply:BindEventOnClicked(self, self.OnClickApply)
  self.Btn_Rewrite:BindEventOnClicked(self, self.OnClickRewrite)
  self.Btn_Erase.Button_Area.OnClicked:Add(self, function()
    self:OnClickErase()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", "AutoChessPreset_EraseSound", nil)
  end)
  self.Btn_Rewrite.AudioEventPath = "event:/ui/activity/auto_chess_normal_btn_click"
  self.Btn_Apply.AudioEventPath = "event:/ui/activity/auto_chess_normal_btn_click"
  self.Btn_Enter.AudioEventPath = "event:/ui/activity/auto_chess_normal_btn_click"
end

function M:OnClickAdd()
  if self.IsSharedSquad then
    self:RefreshList({}, 0)
    self.WS_Type:SetActiveWidgetIndex(0)
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Owner:RefreshSelect(self.PresetIndex)
    self:EditSharedSquad()
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_team_preset_click", "AutoChessPreset_BtnAdd", nil)
  else
    local Res = self:ShowCurrentSquad()
    AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_team_preset_click", "AutoChessPreset_BtnAdd", nil)
    if Res then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_Click)
    end
    return Res
  end
end

function M:InitCost(Cost, Num)
  self.Text_Num:SetText(tostring(Num))
  self.Text_Cost:SetText(tostring(Cost))
end

function M:OnClickErase()
  if self.IsSharedSquad then
    return
  end
  local Params = {}
  Params.RightCallbackObj = self
  Params.RightCallbackFunction = self.ClearSquad
  Params.OnCloseCallbackObj = self
  Params.OnCloseCallbackFunction = self.OnClearSquadResetFocus
  Params.Owner = self.Btn_Add
  UIManager(self):ShowCommonPopupUI(100296, Params, self)
end

function M:OnClickApply()
  if self.IsSharedSquad then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self:RequestCachedSquadInfo()
  if self.CachedSquadInfo then
    if self.Owner and self.Owner.Owner then
      self.Owner.Owner:SetLineup(self.CachedSquadInfo[self.PresetIndex])
    else
      DebugPrint("@@@AutoChessPreset no BattlePage")
    end
    self.Btn_Rewrite:ForbidBtn(true)
    self.Btn_Apply:ForbidBtn(true)
  else
    DebugPrint("@@@AutoChessPreset no CachedSquadInfo")
  end
end

function M:ClearSquad()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AutoChessRemoveSquad(function()
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.WS_Type:SetActiveWidgetIndex(1)
  end, self.PresetIndex)
end

function M:OnClearSquadResetFocus()
  self.CurrentInputType = UIUtils.UtilsGetCurrentInputType()
  if self.CurrentInputType == ECommonInputType.Gamepad then
    self:AddTimer(0.1, function()
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_Add)
    end)
  end
end

function M:OnClickRewrite()
  if self.IsSharedSquad then
    return
  end
  local CurrentSquadInfo = {}
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    CurrentSquadInfo = GameMode:TriggerDungeonComponentFun("GetCurrentChessMonsterInfo")
    if nil == CurrentSquadInfo then
      DebugPrint("@@@AutoChessPreset no SquadInfo")
      return
    end
  end
  local SavedSquadInfo = {}
  for Index, value in pairs(CurrentSquadInfo) do
    SavedSquadInfo[Index + 1] = value.CombatChessId
  end
  local Params = {}
  Params.RightCallbackObj = self
  
  function Params.RightCallbackFunction()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    Avatar:AutoChessAddSquad(function()
      self.WS_Btn:SetActiveWidgetIndex(1)
      self:RefreshList(SavedSquadInfo, 1)
      self.Btn_Rewrite:StopAllAnimations()
      self.Btn_Rewrite:PlayAnimation(self.Btn_Rewrite.Normal)
      self:RefreshButtonState()
    end, SavedSquadInfo, self.PresetIndex)
  end
  
  UIManager(self):ShowCommonPopupUI(100316, Params, self)
end

function M:OnClickEnter()
  if self.IsSharedSquad then
    self:EditSharedSquad()
  else
    self:SaveSquad()
  end
end

function M:SaveSquad()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local SavedSquadInfo = {}
  local CurrentSquadInfo = {}
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    CurrentSquadInfo = GameMode:TriggerDungeonComponentFun("GetCurrentChessMonsterInfo")
    if nil == CurrentSquadInfo then
      DebugPrint("@@@AutoChessPreset no SquadInfo")
      return
    end
  end
  for Index, value in pairs(CurrentSquadInfo) do
    SavedSquadInfo[Index + 1] = value.CombatChessId
  end
  Avatar:AutoChessAddSquad(function()
    self.WS_Btn:SetActiveWidgetIndex(1)
    self.Btn_Rewrite:ForbidBtn(true)
    self.Btn_Apply:ForbidBtn(true)
  end, SavedSquadInfo, self.PresetIndex)
end

function M:OnClickPreset()
  self:PlayAnimation(self.Click)
  if self.IsSharedSquad then
    if self.IsSelected then
      self.CurrentInputType = UIUtils.UtilsGetCurrentInputType()
      if self.CurrentInputType == ECommonInputType.Gamepad and 0 == self.WS_Btn:GetActiveWidgetIndex() then
        self.Btn_Enter:OnBtnClicked()
      end
      return
    end
  else
    if self.IsSelected then
      self.CurrentInputType = UIUtils.UtilsGetCurrentInputType()
      if self.CurrentInputType == ECommonInputType.Gamepad then
        if 0 == self.WS_Btn:GetActiveWidgetIndex() then
          self.Btn_Enter:OnBtnClicked()
        else
          self.Btn_Rewrite:OnBtnClicked()
        end
      end
      return
    end
    self:RefreshButtonState()
  end
  self.Owner:RefreshSelect(self.PresetIndex)
end

function M:RefreshSelect(PresetIndex)
  if PresetIndex == self.PresetIndex then
    self.IsSelected = true
    self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    if not self.IsSharedSquad then
      self:RequestCachedSquadInfo()
      if self.CachedSquadInfo and self:IsEmptySquadInfo(self.CachedSquadInfo[self.PresetIndex]) then
        self.WS_Type:SetActiveWidgetIndex(1)
      end
    end
    self.IsSelected = false
    self:PlayAnimation(self.Normal)
    if self.IsSharedSquad then
      if not self.IsEditing then
        self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    else
      self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:RefreshButtonState()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    local SquadInfo = GameMode:TriggerDungeonComponentFun("GetCurrentChessMonsterInfo")
    self:RequestCachedSquadInfo()
    if not self.CachedSquadInfo or self:IsEmptySquadInfo(self.CachedSquadInfo[self.PresetIndex]) then
      self.WS_Btn:SetActiveWidgetIndex(0)
      return
    end
    if self.CachedSquadInfo and self:IsSameSuqad(SquadInfo, self.CachedSquadInfo) then
      self.WS_Btn:SetActiveWidgetIndex(1)
      self.Btn_Rewrite:ForbidBtn(true)
      self.Btn_Apply:ForbidBtn(true)
    else
      if self:IsEmptySquadInfo(SquadInfo) then
        self.Btn_Rewrite:ForbidBtn(true)
      else
        self.Btn_Rewrite:ForbidBtn(false)
      end
      self.WS_Btn:SetActiveWidgetIndex(1)
      self.Btn_Apply:ForbidBtn(false)
    end
  end
end

function M:IsSameSuqad(CurrentSquadInfo, CachedSquadInfo)
  local HasChecked = false
  for CubeIndex, CombatChessId in pairs(CachedSquadInfo[self.PresetIndex]) do
    HasChecked = true
    if nil == CurrentSquadInfo[CubeIndex - 1] or CurrentSquadInfo[CubeIndex - 1].CombatChessId ~= CombatChessId then
      return false
    end
  end
  for CubeIndex, Value in pairs(CurrentSquadInfo) do
    HasChecked = true
    if CachedSquadInfo[self.PresetIndex][CubeIndex + 1] == nil or CachedSquadInfo[self.PresetIndex][CubeIndex + 1] ~= Value.CombatChessId then
      return false
    end
  end
  if not HasChecked then
    return false
  end
  return true
end

function M:HasDeployedSquad()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    local SquadInfo = GameMode:TriggerDungeonComponentFun("GetCurrentChessMonsterInfo")
    if SquadInfo and not table.isempty(SquadInfo) then
      return true
    end
  end
  return false
end

function M:ShowCurrentSquad()
  if not self:HasDeployedSquad() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AutoChess_EmptyLineup"))
    return false
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    local SquadInfo = GameMode:TriggerDungeonComponentFun("GetCurrentChessMonsterInfo")
    if nil == SquadInfo then
      DebugPrint("@@@AutoChessPreset no SquadInfo")
      return false
    end
    self:RefreshList(SquadInfo, 0)
    self.WS_Type:SetActiveWidgetIndex(0)
    self.WS_Btn:SetActiveWidgetIndex(0)
    self.Owner:RefreshSelect(self.PresetIndex)
  else
    DebugPrint("@@@AutoChessPreset no GameMode")
  end
  return true
end

function M:InitGamepadView()
  if self.Owner and self.Owner.GameInputModeSubsystem then
    self.CurrentInputType = self.Owner.GameInputModeSubsystem:GetCurrentInputType()
  end
  if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
    if 0 == self.WS_Type:GetActiveWidgetIndex() then
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_Click)
      self:OnClickPreset()
    else
      self.GameInputModeSubsystem:SetTargetUIFocusWidget(self.Btn_Add)
      self:OnClickAdd()
    end
  end
  self:ShowButtonGamepadIcon()
end

function M:InitButtonGamepadView()
  self.Btn_Enter:SetGamePadImg("A")
  self.Btn_Rewrite:SetGamePadImg("A")
  self.Btn_Apply:SetGamePadImg("X")
  self.Controller_Erase:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
      }
    }
  })
end

function M:InitKeyboardView()
  if self.Owner and self.Owner.GameInputModeSubsystem then
    self.CurrentInputType = self.Owner.GameInputModeSubsystem:GetCurrentInputType()
  end
  self:HideButtonGamepadIcon()
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self:InitGamepadView()
  elseif CurInputType == ECommonInputType.MouseAndKeyboard then
    self:InitKeyboardView()
  end
end

function M:HideButtonGamepadIcon()
  self.Btn_Enter:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Rewrite:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Apply:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.Controller_Erase:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowButtonGamepadIcon()
  self.Btn_Enter:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Rewrite:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Apply:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Controller_Erase:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.WS_Btn:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      if 0 == self.WS_Btn:GetActiveWidgetIndex() then
        self.Btn_Enter:OnBtnClicked()
      else
        self.Btn_Rewrite:OnBtnClicked()
      end
      IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      if 1 == self.WS_Btn:GetActiveWidgetIndex() then
        self.Btn_Apply:OnBtnClicked()
        IsEventHandled = true
      end
    elseif InKeyName == UIConst.GamePadKey.LeftThumb and 0 == self.WS_Type:GetActiveWidgetIndex() and 1 == self.WS_Btn:GetActiveWidgetIndex() then
      self:OnClickErase()
      AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", "AutoChessPreset_EraseSound", nil)
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:InitBuffList()
  if not self.IsSharedSquad then
    self.HorizontalBox_Buff:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.HorizontalBox_Buff:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:RequestCachedSquadInfo()
  if not self.CachedBuffInfo then
    return
  end
  local RawBuffList = self.CachedBuffInfo[self.PresetIndex] or {}
  local BuffIds = {}
  local WeatherBuffId = 0
  for _, BuffId in pairs(RawBuffList) do
    if DataMgr.ChallengeBuff[BuffId] then
      if DataMgr.ChallengeBuff[BuffId].DailyChallengeId and DataMgr.ChallengeBuff[BuffId].DailyChallengeId > 0 then
        WeatherBuffId = BuffId
      else
        table.insert(BuffIds, BuffId)
      end
    end
  end
  self:SetWeatherBuff(WeatherBuffId)
  self:SetBuffList(BuffIds)
end

function M:SetWeatherBuff(BuffId)
  if 0 == BuffId then
    self.TextWeatherEmpty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.TextWeatherEmpty:SetText(GText("UI_AutoChess_NeedChooseWeather"))
    self.Image_Weather:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  else
    self.TextWeatherEmpty:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Image_Weather:SetVisibility(UE4.ESlateVisibility.Visible)
    local BuffInfo = DataMgr.ChallengeBuff[BuffId]
    UE4.UResourceLibrary.LoadObjectAsync(self, BuffInfo.BuffIcon, {
      self,
      function(_, Texture)
        self.Image_Weather:SetBrushFromTexture(Texture)
      end
    })
  end
end

function M:SetBuffList(BuffIds)
  local ParentHorizontalBox = self.Image_Buff:GetParent()
  local TotalCount = ParentHorizontalBox:GetChildrenCount()
  local MaxBuffDisplayCount = TotalCount - 2
  for i = 0, TotalCount - 1 do
    local Image = ParentHorizontalBox:GetChildAt(i)
    if Image then
      Image:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  if CommonUtils.IsEmpty(BuffIds) then
    self.TextBuffEmpty:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.TextBuffEmpty:SetText(GText("UI_AutoChess_NeedChooseBuff"))
  else
    local BuffCount = #BuffIds
    if MaxBuffDisplayCount < BuffCount then
      BuffCount = MaxBuffDisplayCount
      self.Image_More:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    for i = 1, BuffCount do
      local Image = ParentHorizontalBox:GetChildAt(i)
      if Image then
        local BuffInfo = DataMgr.ChallengeBuff[BuffIds[i]]
        UE4.UResourceLibrary.LoadObjectAsync(self, BuffInfo.BuffIcon, {
          self,
          function(_, Texture)
            Image:SetBrushFromTexture(Texture)
          end
        })
        Image:SetVisibility(UE4.ESlateVisibility.Visible)
      end
    end
  end
end

function M:EditSharedSquad()
  self.Owner:RefreshEdit(self.PresetIndex)
  self:RequestCachedSquadInfo()
  if self.CachedSquadInfo then
    if self.Owner and self.Owner.Owner then
      self.Owner.Owner:SetLineup(self.CachedSquadInfo[self.PresetIndex] or {})
    else
      DebugPrint("@@@AutoChessPreset no BattlePage")
    end
  end
end

function M:RefreshEdit(EditIndex)
  if EditIndex == self.PresetIndex then
    self.IsEditing = true
    self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Visible)
    self.WS_Btn:SetActiveWidgetIndex(2)
  else
    self:RequestCachedSquadInfo()
    self.IsEditing = false
    self.WS_Btn:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WS_Btn:SetActiveWidgetIndex(0)
  end
end

return M

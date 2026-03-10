require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local EWalnutChoiceGamepadState = {
  WalnutList = 0,
  TeamList = 1,
  PlayerBubble = 2,
  WalnutReward = 3,
  WalnutRewardPercent = 4,
  WalnutRewardDetail = 5,
  Access = 6
}
local WalnutUtils = require("BluePrints.UI.WBP.Walnut.WalnutChoice.WalnutUtils")
local EMCache = require("EMCache.EMCache")

function M:Construct()
  self:CommonConstruct()
  self.UIName = "WalnutChoice"
  self.List_WalnutItem.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = nil
    return Content
  end)
end

function M:Destruct()
  TeamController:UnRegisterEvent(self)
  self.List_WalnutItem.OnCreateEmptyContent:Unbind()
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:Init(...)
  self:AddTimer(0.3, function()
    self.List_WalnutItem:SetFocus()
  end, false, 0, "NextFrameFocus")
end

function M:Init(User, ...)
  self.User = User
  if not User or "" == User then
    return
  end
  if not self._components then
    if User == CommonConst.WalnutUser.Depute then
      self._components = {
        "BluePrints.UI.WBP.Walnut.WalnutChoice.WBP_Depute_Walnut_ChoiceComp_C"
      }
    elseif User == CommonConst.WalnutUser.Dungeon then
      self._components = {
        "BluePrints.UI.WBP.Walnut.WalnutChoice.WBP_Dungeon_Walnut_ChoiceComp_C"
      }
    elseif User == CommonConst.WalnutUser.Settlement then
      self._components = {
        "BluePrints.UI.WBP.Walnut.WalnutChoice.WBP_Settlement_Walnut_ChoiceComp_C"
      }
    end
    AssembleComponents(self)
  end
  self:InitComp(...)
end

function M:CommonConstruct()
  AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_before_choose_show", "WalnutChoiceShow", nil)
  self.Btn_No:SetText(GText("UI_Walnut_Giveup"))
  self.Btn_Yes:SetText(GText("UI_CONFIRM_SELECTION"))
  self.Text_Choose_Single:SetText(GText("UI_Walnut_Choice"))
  self.Text_Choose_Multi:SetText(GText("UI_Walnut_Choice"))
  self.Text_Selected:SetText(GText("UI_Walnut_Select"))
  self.State_Mine.Text_State:SetText(GText("UI_Walnut_Selecting"))
  self.WBP_Walnut_PlayerState_1.Text_State:SetText(GText("UI_Walnut_Selecting"))
  self.WBP_Walnut_PlayerState_2.Text_State:SetText(GText("UI_Walnut_Selecting"))
  self.WBP_Walnut_PlayerState.Text_State:SetText(GText("UI_Walnut_Selecting"))
  self.GameState = UE4.UGameplayStatics.GetGameState(self)
  if self.GameState:IsInDungeon() then
    self.IsInDungeon = true
    self.Panel_No:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.IsInDungeon = false
    self.Panel_No:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if GWorld.GameInstance:IsInTempScene() then
    self.IsInSettlement = true
    self.Panel_No:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  self.HasSelect = false
  self.WalnutPlate:SetNoWalnut(false)
  self.CurrentSelectContent = nil
  self.RealChoice = nil
  self.List_WalnutItem:ClearListItems()
  self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  self.Panel_Multi:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Panel_Yes:SetVisibility(ESlateVisibility.Visible)
  self.State = 0
  self:InitCommonKey()
  self.WalnutChoiceFinish = 0
  TeamController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == TeamCommon.EventId.TeamOnInit or EventId == TeamCommon.EventId.TeamLeave then
      self:Close()
    end
  end)
  self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
  self:CheckIsAutoMode()
end

function M:StandaloneConstruct()
  self.Panel_Multi:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Text_Choose_Single:SetText(GText("UI_Walnut_Choice"))
  self.Panel_Text_Single:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function M:MultiConstruct()
  self.Panel_Multi:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Panel_Text_Single:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:ShowTimerPanel(IsShow)
  if IsShow then
    self.Panel_Text_Multi:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Panel_Text_Multi:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:InitWalnuts()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  self:CreateAndAddForbidItem()
  local CurrentCount = 1
  local WalnutItemsToAdd = {}
  self.WalnutsInBag = Avatar.Walnuts.WalnutBag
  for WalnutId, WalnutData in pairs(DataMgr.Walnut) do
    if WalnutData then
      local WalnutSelectDungeonData = DataMgr.WalnutSelectDungeon[WalnutData.WalnutType]
      if WalnutSelectDungeonData then
        local CanSelectDungeonId = WalnutSelectDungeonData.DungeonId
        local IsMatchDungeon = false
        for _, DungeonId in pairs(CanSelectDungeonId) do
          if DungeonId == self.CurrentDungeonId then
            IsMatchDungeon = true
            break
          end
        end
        if IsMatchDungeon then
          local Number = self.WalnutsInBag[WalnutId] or 0
          table.insert(WalnutItemsToAdd, {
            WalnutId = WalnutId,
            Number = Number,
            WalnutData = WalnutData
          })
        end
      end
    end
  end
  table.sort(WalnutItemsToAdd, function(A, B)
    local AHasNumber = A.Number and A.Number > 0 and 1 or 0
    local BHasNumber = B.Number and B.Number > 0 and 1 or 0
    if AHasNumber ~= BHasNumber then
      return AHasNumber > BHasNumber
    end
    return A.WalnutId < B.WalnutId
  end)
  for _, WalnutInfo in ipairs(WalnutItemsToAdd) do
    self:CreateAndAddWalnutItem(WalnutInfo.WalnutId, WalnutInfo.Number)
  end
  self.List_WalnutItem:RequestFillEmptyContent()
end

function M:ShowChooseSuccessToast(SelectContent)
  DebugPrint("ShowChooseSuccessToast")
  if self.HasSelect then
  else
    self.HasSelect = true
  end
  self:SetWalnutContentRealChoice(self.RealChoice, false)
  self:SetWalnutContentRealChoice(SelectContent, true)
  self.RealChoice = SelectContent
  self.Btn_Yes:SetText(GText("UI_CONFIRM_SELECTION"))
  if self.RealChoice == self.CurrentSelectContent then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  end
end

function M:SetWalnutContentRealChoice(Content, IsRealChoice)
  if Content then
    local SelectNeedCount
    if IsRealChoice then
      SelectNeedCount = GText("UI_Walnut_Select")
    end
    Content.SelectNeedCount = SelectNeedCount
    if Content.SelfWidget then
      Content.SelfWidget:SetSelectNum(SelectNeedCount)
    end
  end
end

function M:OnPurchaseShopItem(Ret, ShopItemId, Count)
  if 0 == Ret then
    self.List_WalnutItem:ClearListItems()
    self:InitWalnuts()
    local WalnutId = WalnutUtils:GetWalnutCacheIdByDungeonId(self.CurrentDungeonId)
    self:SelectWalnutById(WalnutId)
  end
end

function M:OnListItemClicked(Content)
  if 1 == self.WalnutChoiceFinish then
    return
  end
  if self.CheckIsAutoModeTimer and self.CurrentSelectContent and self.CurrentSelectContent.Id ~= Content.Id then
    self:RemoveTimer(self.CheckIsAutoModeTimer)
    self.CheckIsAutoModeTimer = nil
    self.Btn_Yes:SetText(GText("UI_CONFIRM_SELECTION"))
    DebugPrint("ayff test interrupt auto mode because of manual click")
  end
  if Content.IsEmpty or not Content.Id then
    return
  end
  if self.RealChoice == Content and self.HasSelect then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  else
    local GameState = UGameplayStatics.GetGameState(self)
    if self.HasSelect and GameState:IsInDungeon() then
    else
      self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    end
  end
  if self.CurrentSelectContent == Content then
    return
  end
  if self.CurrentSelectContent then
    self.CurrentSelectContent.IsSelect = false
    if self.CurrentSelectContent.SelfWidget then
      self.CurrentSelectContent.SelfWidget:SetSelected(false, true)
    end
  end
  if Content then
    Content.IsSelect = true
    if Content.SelfWidget then
      Content.SelfWidget:SetSelected(true, true)
      if Content.IsForbid then
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_before_choose_select_none", nil, nil)
      else
        AudioManager(self):PlayUISound(self, "event:/ui/common/mihan_level_before_choose_select", nil, nil)
      end
    end
  end
  self.CurrentSelectContent = Content
  if not Content.Id then
    self.WalnutPlate:SetNoWalnut(true)
  else
    self.WalnutPlate:SetWalnutContent(Content.Id, true)
    local WalnutType = self.WalnutType
    if WalnutType then
      local CacheKey = "WalnutIDType" .. WalnutType
      EMCache:Set(CacheKey, Content.Id, true)
    end
  end
  if 0 == Content.Count then
    local CanPurchase, ShopType = WalnutUtils:CheckWalnutCanPurchase(Content.Id)
    if CanPurchase then
      self.Btn_Yes:SetText(GText("UI_SHOP_PURCHASE"))
      Content.ActionType = "Purchase"
      Content.ShopType = ShopType
      self.Btn_Yes:ForbidBtn(false)
    else
      self.Btn_Yes:SetText(GText("UI_Access_Goto"))
      Content.ActionType = "Jump"
      local WalnutData = DataMgr.Walnut[Content.Id]
      local bCanJump = false
      if WalnutData and WalnutData.AccessKey then
        for _, AccessKey in pairs(WalnutData.AccessKey) do
          if PageJumpUtils:CanJumpByAccessKey(Content.Id, "Walnut", AccessKey, self.UIName) then
            bCanJump = true
            break
          end
        end
      end
      self.Btn_Yes:ForbidBtn(not bCanJump)
      if self.User == CommonConst.WalnutUser.Dungeon or self.User == CommonConst.WalnutUser.Settlement then
        self.Btn_Yes:ForbidBtn(true)
      end
    end
  else
    self.Btn_Yes:SetText(GText("UI_CONFIRM_SELECTION"))
    Content.ActionType = "Select"
    self.Btn_Yes:ForbidBtn(false)
  end
end

function M:BindEvents()
  self.Btn_Yes.Button_Area.OnClicked:Clear()
  self.Btn_No.Button_Area.OnClicked:Clear()
  self.Btn_Yes.Button_Area.OnClicked:Add(self, self.OnClickButtonYes)
  self.Btn_No.Button_Area.OnClicked:Add(self, self.OnClickButtonNo)
  self.List_WalnutItem.BP_OnItemClicked:Add(self, self.OnListItemClicked)
  self.WalnutPlate.Ordinal_1st.MainUI = self
  self.WalnutPlate.Ordinal_2nd.MainUI = self
  self.WalnutPlate.Ordinal_3rd.MainUI = self
  self.WalnutPlate.MainUI = self
  self.WalnutPlate.Reward_1st.MainUI = self
  self.WalnutPlate.Reward_2nd.MainUI = self
  self.WalnutPlate.Reward_2nd_2.MainUI = self
  self.WalnutPlate.Reward_3rd_1.MainUI = self
  self.WalnutPlate.Reward_3rd_2.MainUI = self
  self.WalnutPlate.Reward_3rd_3.MainUI = self
  self:AddDispatcher(EventID.InterruptWalnutSelect, self, self.OnInterruptWalnutSelect)
end

function M:CreateAndAddForbidItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Icon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_Forbid.T_Armory_Forbid"
  Content.Id = -1
  Content.ItemName = GText("UI_Walnut_Not_Select")
  Content.IsForbid = true
  Content.bDisableCommonClick = true
  self.List_WalnutItem:AddItem(Content)
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.IsEmpty = true
  self.List_WalnutItem:AddItem(Content)
end

function M:CreateAndAddWalnutItem(WalnutId, Number)
  DebugPrint("CreateAndAddWalnutItem WalnutId: ", WalnutId, "Number: ", Number)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  local WalnutData = DataMgr.Walnut[WalnutId]
  local WalnutType = WalnutData.WalnutType
  local WalnutTypeData = DataMgr.WalnutType[WalnutType]
  local ReleaseVersion = WalnutData.ReleaseVersion
  local CurrentVersion = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
  if ReleaseVersion and CurrentVersion and ReleaseVersion > CurrentVersion then
    DebugPrint("WalnutId: ", WalnutId, " is not released yet. ReleaseVersion: ", ReleaseVersion, " CurrentVersion: ", CurrentVersion)
    return
  end
  Content.Rarity = WalnutData.Rarity or 1
  Content.Icon = WalnutTypeData.Icon
  Content.Parent = self
  Content.Count = Number
  Content.Id = WalnutId
  Content.ItemType = "Walnut"
  Content.bDisableCommonClick = true
  self.WalnutType = WalnutTypeData.WalnutType
  self.List_WalnutItem:AddItem(Content)
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Auto_Out then
    if not self.IsInDungeon and self.IsStandAlone and self.SelectYes then
      EventManager:FireEvent(EventID.SelectedWalnut)
    elseif self.IsInSettlement and self.IsStandAlone and self.SelectYes then
      EventManager:FireEvent(EventID.SelectedWalnut)
    end
  end
end

function M:ChangeStateIcon(Widget, IsNone, ImgPath)
  if IsNone then
    Widget.Panel_Img:SetActiveWidgetIndex(4)
  else
    local WalnutImg = LoadObject(ImgPath)
    Widget.Img_Item:GetDynamicMaterial():SetTextureParameterValue("IconMap", WalnutImg)
    Widget.Panel_Img:SetActiveWidgetIndex(0)
  end
end

function M:OnItemWalnutClicked(ItemWalnut)
  local WalnutId = ItemWalnut.WalnutId
  if not WalnutId or WalnutId <= 0 then
    return
  end
  if not UIManager(self):GetUIObj("WalnutRewardDialog") then
    self.DetailWidget = UIManager(self):LoadUINew("WalnutRewardDialog", WalnutId, "WalnutChoice")
    self.DetailWidget.WalnutChoice = true
  end
end

function M:ChangeSelectedHead(TeamHead)
  if TeamHead == self.SelectedHead then
    return
  end
  if self.SelectedHead then
    self.SelectedHead:OnReleaseSelected(true)
  end
  self.SelectedHead = TeamHead
end

function M:InitComp(...)
end

function M:InitTeamHeads(...)
end

function M:ReceiveTeammateChoose(...)
end

function M:PlayWalnutReady()
end

function M:OnClickButtonNo()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_cancel", nil, nil)
end

function M:OnClickButtonYes()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  local WalnutId = self.CurrentSelectContent.Id
  if nil == WalnutId then
    WalnutId = -1
  end
  local Content = self.CurrentSelectContent
  if Content and 0 == Content.Count and Content.ActionType then
    if Content.ActionType == "Purchase" then
      local ShopType = Content.ShopType or "Shop"
      ShopUtils:ShowPurchaseDialog("Walnut", WalnutId, ShopType, self.UIName)
      return
    elseif Content.ActionType == "Jump" then
      if self.Btn_Yes.IsForbidden then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Walnut_Toast_CanNotGet"))
        return
      end
      local WalnutData = DataMgr.Walnut[WalnutId]
      if WalnutData and WalnutData.AccessKey then
        for _, AccessKey in pairs(WalnutData.AccessKey) do
          if PageJumpUtils:ExecuteJumpByAccessKey(WalnutId, "Walnut", AccessKey, self.UIName) then
            return
          end
        end
      end
      return
    end
  end
  local Avatar = GWorld:GetAvatar()
  Avatar:SelectWalnut(self:ShowChooseSuccessToast(self.CurrentSelectContent), self.CurrentDungeonId, WalnutId)
end

function M:SelectWalnutById(WalnutId)
  local WalnutItems = self.List_WalnutItem:GetListItems()
  if not WalnutId then
    local Content = WalnutItems:Get(1)
    self:OnListItemClicked(Content)
    self.List_WalnutItem:ScrollIndexIntoView(0)
    return false
  end
  for i = 1, WalnutItems:Length() do
    local Content = WalnutItems:Get(i)
    if Content and Content.Id and Content.Id == WalnutId then
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return
      end
      local DungeonId = self.CurrentDungeonId
      if not DungeonId then
        return
      end
      local IsAutoMode = Avatar.Dungeons[DungeonId] and Avatar.Dungeons[DungeonId].AutoProgress
      if IsAutoMode and 0 == Content.Count then
        local FirstWalnutContent = WalnutItems:Get(2)
        if FirstWalnutContent and FirstWalnutContent.Count > 0 then
          self.List_WalnutItem:SetSelectedIndex(1)
          self:OnListItemClicked(FirstWalnutContent)
          self.List_WalnutItem:ScrollIndexIntoView(1)
          return true
        else
          self.List_WalnutItem:SetSelectedIndex(0)
          local WalnutContent = WalnutItems:Get(1)
          self:OnListItemClicked(WalnutContent)
          self.List_WalnutItem:ScrollIndexIntoView(0)
          return true
        end
      else
        self.List_WalnutItem:SetSelectedIndex(i - 1)
        self:OnListItemClicked(Content)
        self.List_WalnutItem:ScrollIndexIntoView(i - 1)
        return true
      end
    end
  end
  return false
end

function M:OnInterruptWalnutSelect()
  self:Close()
end

function M:InitGameInputMode()
  DebugPrint("InitGameInputMode")
  if not self.Panel_Key_GamePad then
    return
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.IsFocusInit = false
  if IsValid(self.GameInputModeSubsystem) then
    self:InitCommonKey()
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  DebugPrint("RefreshOpInfoByInputDevice", CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:GamePadToPC()
    if self._ItemSelectionChangeBound then
      self.List_WalnutItem.BP_OnItemSelectionChanged:Remove(self, self.OnListItemClicked)
      self._ItemSelectionChangeBound = false
    end
  else
    self:PCToGamepad()
    if not self._ItemSelectionChangeBound or self._ItemSelectionChangeBound == false then
      self.List_WalnutItem.BP_OnItemSelectionChanged:Add(self, self.OnListItemClicked)
      self._ItemSelectionChangeBound = true
    end
  end
  self.CurInputDeviceType = CurInputDevice
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:InitCommonKey()
  if not self.Panel_Key_GamePad then
    return
  end
  self.Panel_Key_GamePad:ClearChildren()
  for i = 1, 3 do
    local MenuKeyWidget = self:CreateWidgetNew("ComKeyTextDesc")
    self.Panel_Key_GamePad:AddChild(MenuKeyWidget)
  end
end

function M:UpdateCommonKeys(...)
  if not self.Panel_Key_GamePad then
    return
  end
  local Param = {
    ...
  }
  for i = 0, 2 do
    local CurerentKey = self.Panel_Key_GamePad:GetChildAt(i)
    if Param[i * 2 + 1] ~= nil and Param[i * 2 + 2] ~= nil then
      CurerentKey:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      CurerentKey:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = Param[i * 2 + 1]
          }
        },
        Desc = Param[i * 2 + 2]
      })
    else
      CurerentKey:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:GamePadToPC()
  if not self.Panel_Key_GamePad then
    return
  end
  self.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:PCToGamepad()
  if not self.Panel_Key_GamePad then
    return
  end
  self.Panel_Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.DetailWidget and self.DetailWidget.WalnutChoice == true then
    self.DetailWidget.State = 0
    self.DetailWidget:PCToGamepad()
    self.DetailWidget:SetFocus()
  else
    self.State = 0
    self.List_WalnutItem:SetFocus()
  end
  if 0 == self.State then
    if self.IsStandAlone then
      if self.CurrentSelectContent and -1 == self.CurrentSelectContent.Id then
        self:UpdateCommonKeys()
      else
        self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"))
      end
    elseif self.CurrentSelectContent and -1 == self.CurrentSelectContent.Id then
      self:UpdateCommonKeys("RS", GText("UI_Controller_CheckTeam"))
    else
      self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"), "RS", GText("UI_Controller_CheckTeam"))
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if 1 == self.WalnutChoiceFinish then
      if "Gamepad_RightThumbstick" == InKeyName then
        self.NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget()
        self.NavigateWidget:SetRenderOpacity(1)
        if not self.IsStandAlone and 0 == self.State then
          self.State_Mine.Team_Head.Head_Team.Button_Area:SetFocus()
          self.State = 7
          self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"))
          IsEventHandled = true
        end
      elseif "Gamepad_FaceButton_Right" == InKeyName then
        IsEventHandled = true
      end
    elseif "Gamepad_Special_Right" == InKeyName then
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      if 0 == self.State then
        if self.CurrentSelectContent.Id ~= nil and -1 ~= self.CurrentSelectContent.Id then
          self.WalnutPlate.Reward_1st.Button_Area:SetFocus()
          self.State = 2
          self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
        end
        IsEventHandled = true
      end
    elseif "Gamepad_RightThumbstick" == InKeyName then
      if not self.IsStandAlone and 0 == self.State then
        self.State_Mine.Team_Head.Head_Team.Button_Area:SetFocus()
        self.State = 7
        self.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        self.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.Collapsed)
        self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
        IsEventHandled = true
      end
      IsEventHandled = true
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      if 2 == self.State or 7 == self.State then
        self.State = 0
        self.List_WalnutItem:SetFocus()
        self.Btn_No:SetGamePadVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self.Btn_Yes:SetGamePadVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        if self.IsStandAlone then
          self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"))
        else
          self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"), "RS", GText("UI_Controller_CheckTeam"))
        end
      elseif 4 == self.State then
        self.State = 7
        self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
        if self.State_Mine.Team_Head.Head_Anchor:HasFocusedDescendants() then
          self.State_Mine.Team_Head.Head_Team.Button_Area:SetFocus()
        elseif self.WBP_Walnut_PlayerState_1.Team_Head.Head_Anchor:HasFocusedDescendants() then
          self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:SetFocus()
        elseif self.WBP_Walnut_PlayerState_2.Team_Head.Head_Anchor:HasFocusedDescendants() then
          self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:SetFocus()
        elseif self.WBP_Walnut_PlayerState.Team_Head.Head_Anchor:HasFocusedDescendants() then
          self.WBP_Walnut_PlayerState.Team_Head.Head_Team.Button_Area:SetFocus()
        end
      elseif 1 == self.State then
        if self.WalnutPlate.Ordinal_1st.Tips_MenuAnchor:HasFocusedDescendants() then
          self.WalnutPlate.Ordinal_1st:SetFocus()
        elseif self.WalnutPlate.Ordinal_2nd.Tips_MenuAnchor:HasFocusedDescendants() then
          self.WalnutPlate.Ordinal_2nd:SetFocus()
        elseif self.WalnutPlate.Ordinal_3rd.Tips_MenuAnchor:HasFocusedDescendants() then
          self.WalnutPlate.Ordinal_3rd:SetFocus()
        else
          self.State = 0
          self.List_WalnutItem:SetFocus()
          if self.IsStandAlone then
            self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"))
          else
            self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"), "RS", GText("UI_Controller_CheckTeam"))
          end
        end
      elseif 0 == self.State then
        self:OnClickButtonNo()
      end
      IsEventHandled = true
    end
  elseif "Escape" == InKeyName and self.CloseByEscape and self:CloseByEscape() then
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Close()
  if self.DetailWidget and self.DetailWidget.WalnutChoice then
    self.DetailWidget:Close()
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    self.NavigateWidget = self.GameInputModeSubsystem:GetNavigateWidget()
    self.NavigateWidget:SetRenderOpacity(1)
  end
  AudioManager(self):SetEventSoundParam(self, "WalnutChoiceShow", {ToEnd = 1})
  self.Super.Close(self)
end

function M:OnClickYes()
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and 0 == self.State then
    self:OnClickButtonYes()
  end
end

function M:FocusOnWalnut()
  local Walnut = self.List_WalnutItem:GetDisplayedEntryWidgets()[1]
  if self.List_WalnutItem:HasFocusedDescendants() then
    if Walnut:HasAnyUserFocus() then
      if self.IsStandAlone == true then
        self:UpdateCommonKeys()
      else
        self:UpdateCommonKeys("RS", GText("UI_Controller_CheckTeam"))
      end
    else
      if self.IsStandAlone == true then
        self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"))
      else
        self:UpdateCommonKeys("LS", GText("UI_Controller_CheckReward"), "RS", GText("UI_Controller_CheckTeam"))
      end
      self.State = 0
    end
  end
end

function M:NavigateP1Right()
  if self.State_Mine.Team_Head.Head_Team.Button_Area:HasAnyUserFocus() then
    if self.State_Mine.Item_Walnut.State ~= nil and 1 == self.State_Mine.Item_Walnut.State then
      self.State_Mine.Item_Walnut.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
    else
      self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
    end
  else
    self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:NavigateP2Right()
  if self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:HasAnyUserFocus() then
    if self.WBP_Walnut_PlayerState_1.Item_Walnut.State ~= nil and 1 == self.WBP_Walnut_PlayerState_1.Item_Walnut.State then
      self.WBP_Walnut_PlayerState_1.Item_Walnut.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
    else
      self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
    end
  else
    self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:NavigateP2Left()
  if self.WBP_Walnut_PlayerState_1.Item_Walnut.Button_Area:HasAnyUserFocus() then
    self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  elseif self.State_Mine.Item_Walnut.State ~= nil and 1 == self.State_Mine.Item_Walnut.State then
    self.State_Mine.Item_Walnut.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
  else
    self.State_Mine.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:NavigateP3Right()
  if self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:HasAnyUserFocus() then
    if self.WBP_Walnut_PlayerState_2.Item_Walnut.State ~= nil and 1 == self.WBP_Walnut_PlayerState_2.Item_Walnut.State then
      self.WBP_Walnut_PlayerState_2.Item_Walnut.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
    else
      self.WBP_Walnut_PlayerState.Team_Head.Head_Team.Button_Area:SetFocus()
      self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
    end
  else
    self.WBP_Walnut_PlayerState.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:NavigateP3Left()
  if self.WBP_Walnut_PlayerState_2.Item_Walnut.Button_Area:HasAnyUserFocus() then
    self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  elseif self.WBP_Walnut_PlayerState_1.Item_Walnut.State ~= nil and 1 == self.WBP_Walnut_PlayerState_1.Item_Walnut.State then
    self.WBP_Walnut_PlayerState_1.Item_Walnut.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
  else
    self.WBP_Walnut_PlayerState_1.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:NavigateP4Left()
  if self.WBP_Walnut_PlayerState.Item_Walnut.Button_Area:HasAnyUserFocus() then
    self.WBP_Walnut_PlayerState.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  elseif self.WBP_Walnut_PlayerState_2.Item_Walnut.State ~= nil and 1 == self.WBP_Walnut_PlayerState_2.Item_Walnut.State then
    self.WBP_Walnut_PlayerState_2.Item_Walnut.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckDetails"), "B", GText("UI_Tips_Close"))
  else
    self.WBP_Walnut_PlayerState_2.Team_Head.Head_Team.Button_Area:SetFocus()
    self:UpdateCommonKeys("A", GText("UI_Controller_CheckPlayer"), "B", GText("UI_Tips_Close"))
  end
  return true
end

function M:CheckIsAutoMode()
  local Avatar = GWorld:GetAvatar()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not Avatar then
    return
  end
  local DungeonId = GWorld.GameInstance:GetCurrentDungeonId()
  if not DungeonId then
    return
  end
  local IsInSettlement = GWorld.GameInstance:IsInTempScene()
  local IsAutoMode = not IsInSettlement and Avatar.Dungeons[DungeonId] and Avatar.Dungeons[DungeonId].AutoProgress
  local Progress = GameState.DungeonProgress or 0
  if IsAutoMode and Progress <= IsAutoMode + 1 and 0 ~= IsAutoMode then
    self.CheckIsAutoModeTimer = nil
    local AutoCheckTime
    if DataMgr.GlobalConstant.AutoRoundsCheckTime then
      AutoCheckTime = DataMgr.GlobalConstant.AutoRoundsCheckTime.ConstantValue
    else
      AutoCheckTime = 5
    end
    self.CheckIsAutoModeTimer = self:AddTimer(1, function()
      self.Btn_Yes:SetText(string.format(GText("UI_Auto_Round_TicketConfirm_Time"), AutoCheckTime))
      if AutoCheckTime <= 0 then
        self:RemoveTimer(self.CheckIsAutoModeTimer)
        self:OnClickButtonYes()
        return
      end
      AutoCheckTime = AutoCheckTime - 1
    end, true, 0, "CheckIsAutoModeTimer")
  end
end

return M

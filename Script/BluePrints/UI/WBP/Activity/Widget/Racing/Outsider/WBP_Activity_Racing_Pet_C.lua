require("UnLua")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:RestoreTempSelectionFromServer()
  if RacingOutsiderModel:IsServerChoosePetEnough() then
    RacingOutsiderController:SetServerChoosePetList(RacingOutsiderModel:GetServerChoosePetList())
  end
end

function M:Construct()
  self:RestoreTempSelectionFromServer()
  self:InitCompView()
  self:BindButtonEvent()
  self:PlayAnimationIn()
  self:SetPosition()
end

function M:InitCompView()
  self.Btn_Confirm:Init()
  self:InitTextMap()
  self:UpdateAllPetList()
  self:UpdateButtonState()
  self:InitCheckBox()
  local TimerOwner = GWorld.GameInstance:GetGameUIManager()
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.2, function()
      if self.DefaultSelectedContent then
        self:OnPetItemSelected(self.DefaultSelectedContent, true)
      end
    end)
  end
  self.Btn_Cancel.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    }
  })
  self.Btn_Confirm.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Btn_Reset.Com_KeyImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Key_Qa:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
end

function M:SetPosition()
  local PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self)
  local bPCCloudGame = UE4.UUCloudGameInstanceSubsystem.IsPCCloudGame()
  DebugPrint("Yihan@ Racing:SetPosition", PlatformName, bPCCloudGame)
  if bPCCloudGame or "PC" == PlatformName then
    self.Condition = false
  else
    self.Condition = true
  end
  self:SetUIPosition()
end

function M:InitTextMap()
  self.Text_Tips:SetText(string.format(GText(RacingActivityConst.RumorInquireCountText), tostring(RacingOutsiderModel:GetRumorInquireCount()), tostring(RacingOutsiderModel:GetMaxRumorInquireCount())))
  self.Text_TipsTitle:SetText(GText(RacingActivityConst.TodayRumorText))
  self.Btn_Cancel.Text_Btn:SetText(GText(RacingActivityConst.CancelText))
  self.Btn_Confirm.Text_Btn:SetText(GText(RacingActivityConst.ConfirmText))
  self.Text_BottomTitle:SetText(string.format(GText(RacingActivityConst.NeedChoosePetCountText), tostring(RacingOutsiderModel:GetChoosePetListCount()), "6"))
  self.Text_No:SetText(GText("UI_RaceLottery_PlayerNum"))
  self.Text_PetSpeedTitle:SetText(GText(RacingActivityConst.PetBaseSpeedText))
end

function M:InitCheckBox()
  local ConfigData = {
    OwnerWidget = self,
    TextContent = GText(RacingActivityConst.CheckBoxText)
  }
  self.Com_CheckBoxQa:Init(ConfigData)
end

function M:UpdateAllPetList()
  self.List_Pet:ClearListItems()
  local PetsData = RacingOutsiderModel:GetTodayPlayerList()
  self.PetContentMap = {}
  local Index = 1
  DebugPrint("Yihan@ UpdateAllPetList", PetsData)
  for PlayerId, Data in pairs(PetsData) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local Pet = DataMgr.RaceLotteryPlayer[PlayerId]
    Content.Index = Index
    Content.PlayerId = PlayerId
    Content.PlayerName = Pet.PlayerName
    Content.Icon = Pet.PlayerIcon
    Content.BaseSpeed = Data.InitSpeed
    Content.Parent = self
    if 1 == Index then
      Content.IsSelected = true
      self.DefaultSelectedContent = Content
    else
      Content.IsSelected = false
    end
    Content.IsChoosed = RacingOutsiderModel:IsChoosePetById(Content.PlayerId) and true or false
    Content.OnMouseButtonDownDetailEvents = {
      Obj = self,
      Callback = self.OnPetItemSelected,
      Params = {Content}
    }
    Content.OnMouseButtonDownChooseEvents = {
      Obj = self,
      Callback = self.OnPetItemChoosed,
      Params = {Content}
    }
    self.PetContentMap[Content.PlayerId] = Content
    Index = Index + 1
    self.List_Pet:AddItem(Content)
  end
  self.List_Pet:RequestPlayEntriesAnim()
end

function M:OnPetItemSelected(Content, IsDefault)
  local PreSelectedContent = self.CurrentSelectedContent
  if self.CurrentSelectedContent == Content then
    return
  end
  if PreSelectedContent then
    PreSelectedContent.IsSelected = false
    local PreWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Pet, self.List_Pet:GetIndexForItem(PreSelectedContent))
    if PreWidget then
      PreWidget:SetIsSelected()
    end
  end
  if not IsDefault then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local PetData = DataMgr.Pet[Content.PlayerId]
    local PetNameTag = PetData and PetData.PetNameTag
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_hello", "PetVoice")
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_select_pet", nil, nil)
  end
  self.CurrentSelectedContent = Content
  self.CurrentDetailPlayerId = Content.PlayerId
  Content.RumorList = RacingOutsiderModel:GetRumorContentListByPlayerId(Content.PlayerId)
  if Content.Icon then
    local IconDice = LoadObject(Content.Icon)
    self.Image_Pet:SetBrushFromTexture(IconDice)
  end
  self.Text_PetName:SetText(GText(Content.PlayerName))
  self.Text_Speed:SetText(string.format("%.2f", Content.BaseSpeed))
  self.Text_Num:SetText(string.format("%02d", Content.Index))
  for Index = 1, 3 do
    local DetailItemWidget = self["DetailItem0" .. Index]
    if DetailItemWidget then
      DetailItemWidget:Init(Index, RacingOutsiderModel:GetRumorContentByPlayerIdAndIndex(Content.PlayerId, Index), Content.PlayerId, self)
    end
  end
  self:PlayAnimation(self.Change)
end

function M:OnRumorPopupClosed(RumorIndex, PlayerId, RealRumorIndex)
  if PlayerId and self.CurrentDetailPlayerId and PlayerId ~= self.CurrentDetailPlayerId then
    return
  end
  local DetailItemWidget = self["DetailItem0" .. RumorIndex]
  if not DetailItemWidget then
    return
  end
  local TargetRumorIndex = RealRumorIndex or RumorIndex
  local RumorContent = RacingOutsiderModel:GetRumorContentByPlayerIdAndIndex(PlayerId, TargetRumorIndex)
  if self.CurrentSelectedContent and self.CurrentSelectedContent.PlayerId == PlayerId then
    self.CurrentSelectedContent.RumorList = RacingOutsiderModel:GetRumorContentListByPlayerId(PlayerId)
  end
  DetailItemWidget:Init(RumorIndex, RumorContent, PlayerId, self)
  DetailItemWidget:PlayPopupCloseAnim()
  self.Text_Tips:SetText(string.format(GText(RacingActivityConst.RumorInquireCountText), tostring(RacingOutsiderModel:GetRumorInquireCount()), tostring(RacingOutsiderModel:GetMaxRumorInquireCount())))
  if self.CurrentSelectedContent and self.CurrentSelectedContent.SelfWidget then
    self.CurrentSelectedContent.SelfWidget:InitView()
  end
  self.ParentWidget.bIsInRumorStatus = false
end

function M:OnRumorPopupCancel()
  self.ParentWidget.bIsInRumorStatus = false
end

function M:OnPetItemChoosed(Content)
  DebugPrint("Yihan@ OnPetItemChoosed", not Content.IsChoosed, RacingOutsiderModel:IsChoosePetEnough())
  if not Content.IsChoosed and RacingOutsiderModel:IsChoosePetEnough() then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PetData = DataMgr.Pet[Content.PetId]
  local PetNameTag = PetData and PetData.PetNameTag
  if Content.IsChoosed then
    Content.IsChoosed = false
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_upset", "PetVoice")
    RacingOutsiderController:RemoveSelectedPetFromList(Content)
  else
    Content.IsChoosed = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
    RacingOutsiderController:AddSelectedPetToList(Content)
  end
  self.Text_BottomTitle:SetText(string.format(GText(RacingActivityConst.NeedChoosePetCountText), tostring(RacingOutsiderModel:GetChoosePetListCount()), "6"))
  self:UpdateButtonState()
end

function M:UpdateButtonState()
  local IsEnough = RacingOutsiderModel:IsChoosePetEnough()
  if not IsEnough then
    self.Btn_Confirm:ForbidBtn(true)
  else
    self.Btn_Confirm:ForbidBtn(false)
  end
end

function M:BindButtonEvent()
  if self.Btn_Reset.Btn_Click.OnClicked then
    self.Btn_Reset.Btn_Click.OnClicked:Remove(self, self.OnResetBtnClicked)
  end
  if self.Btn_Cancel.Btn_Click.OnClicked then
    self.Btn_Cancel.Btn_Click.OnClicked:Remove(self, self.OnCancelBtnClicked)
  end
  if self.Btn_Confirm.Btn_Click.OnClicked then
    self.Btn_Confirm.Btn_Click.OnClicked:Remove(self, self.OnConfirmBtnClicked)
  end
  self.Btn_Reset.Btn_Click.OnClicked:Add(self, self.OnResetBtnClicked)
  self.Btn_Cancel.Btn_Click.OnClicked:Add(self, self.OnCancelBtnClicked)
  self.Btn_Confirm.Btn_Click.OnClicked:Add(self, self.OnConfirmBtnClicked)
end

function M:OnResetBtnClicked()
  DebugPrint("Yihan@ OnResetBtnClicked")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  local Params = {}
  
  function Params.RightCallbackFunction()
    for PlayerId, Content in pairs(self.PetContentMap or {}) do
      if Content.IsChoosed or RacingOutsiderModel:IsChoosePetById(PlayerId) then
        local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Pet, self.List_Pet:GetIndexForItem(Content))
        Content.IsChoosed = false
        if CurWidget then
          CurWidget:SetIsChoosed()
        end
      end
    end
    RacingOutsiderController:ClearSelectedPetList()
    self.Text_BottomTitle:SetText(string.format(GText(RacingActivityConst.NeedChoosePetCountText), tostring(RacingOutsiderModel:GetChoosePetListCount()), "6"))
    self:UpdateButtonState()
  end
  
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowCommonPopupUI(100388, Params, self.Parent)
end

function M:OnCancelBtnClicked()
  DebugPrint("Yihan@ OnCancelBtnClicked")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  self:RestoreTempSelectionFromServer()
  local Owner = self.ParentWidget
  if Owner and Owner.bShowPetPage and Owner.WBP_Activity_Racing_Choose_P then
    Owner:bShowPetPage(false)
    Owner.WBP_Activity_Racing_Choose_P:RefreshHomeView()
  end
end

function M:OnConfirmBtnClicked()
  DebugPrint("Yihan@ OnConfirmBtnClicked")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  if self.Btn_Confirm.IsForbidden then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(RacingActivityConst.NeedSixPetText))
    return
  end
  local PlayerIdList = {}
  for PlayerId, IsSelected in pairs(RacingOutsiderModel:GetChoosePetList()) do
    if IsSelected then
      table.insert(PlayerIdList, PlayerId)
    end
  end
  local RandomIndex = math.random(1, #PlayerIdList)
  local RandomPlayerId = PlayerIdList[RandomIndex]
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PetData = DataMgr.Pet[RandomPlayerId]
  local PetNameTag = PetData and PetData.PetNameTag
  AudioManager(self):PlayPetVoice(Player, PetNameTag, "vo_hello", "PetVoice")
  local Params = {
    PlayerList = PlayerIdList,
    PageOwner = self.ParentWidget
  }
  if 0 ~= RacingOutsiderModel:GetNowBetCount() then
    local Owner = self.ParentWidget
    if Owner and Owner.bShowPetPage then
      Owner:bShowPetPage(false)
    end
    if #PlayerIdList > 0 then
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:RaceLotterySelectPlayer(PlayerIdList, function(ErrCode)
          ErrorCode:Check(ErrCode)
          if self.ParentWidget and self.ParentWidget.WBP_Activity_Racing_Choose_P then
            self.ParentWidget.WBP_Activity_Racing_Choose_P:RefreshHomeView()
          end
        end)
      end
    end
    return
  end
  if RacingOutsiderModel:IsChoosePetEnough() then
    DebugPrint("Yihan@ OnConfirmBtnClicked", RacingOutsiderModel:IsChoosePetEnough())
    UIManager(self):LoadUINew("ActivityRacingChooseGuess", Params)
  end
end

function M:PlayAnimationIn()
  self:PlayAnimation(self.In)
  self:PlayAnimation(self.Change)
  self.IsInAnimation = true
end

function M:PlayAnimationOut()
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self.IsInAnimation = false
    self:SetVisibility(UIConst.VisibilityOp.Visible)
  elseif InAnimation == self.Out then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M

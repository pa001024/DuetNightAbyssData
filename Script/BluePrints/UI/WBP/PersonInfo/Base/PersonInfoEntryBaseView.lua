require("UnLua")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local PreviewLevelHandoffMask = require("BluePrints.UI.Common.Preview.PreviewLevelHandoffMask")
local M = {}
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}

function M:Construct()
  self:RefreshBaseInfo()
  if self.HideBegin and not self:IsAnimationPlaying(self.Bg_In) then
    self:SetRenderOpacity(0)
  end
  self:AddTimer(0.231, function()
    DebugPrint("PersonInfoEntryBaseView: delayed ModelViewIni tick")
    self.PersonInfoMainPage:ModelViewIni()
  end)
end

function M:ReceiveExitState(StackAction)
  if self.Super and self.Super.ReceiveExitState then
    self.Super.ReceiveExitState(self, StackAction)
  end
  if 0 ~= StackAction then
    return
  end
  local Page = self.PersonInfoMainPage
  if not Page then
    return
  end
  local Manager = UIManager(self)
  local IncomingName
  if Manager and Manager.CurrentUIList then
    local UINameList = Manager.CurrentUIList:ToTable()
    IncomingName = UINameList[#UINameList]
  end
  if "CommonRanking" ~= IncomingName and "AppearanceMain" ~= IncomingName then
    return
  end
  Page.bStackCovered = true
  PreviewLevelHandoffMask.Show(self)
  local Controller = Page.ActorController
  local Service = Controller and Controller.SceneService
  if Service and Service.UnloadScene then
    Service:UnloadScene(true)
  end
end

function M:ReceiveEnterState(StackAction)
  if self.Super and self.Super.ReceiveEnterState then
    self.Super.ReceiveEnterState(self, StackAction)
  end
  if 1 ~= StackAction then
    return
  end
  local Page = self.PersonInfoMainPage
  if not Page or not Page.bStackCovered then
    return
  end
  PreviewLevelHandoffMask.Show(self)
  Page.bStackCovered = nil
  if Page.ApplyDisplayPreviewDraft then
    Page:ApplyDisplayPreviewDraft()
  end
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  if self.PersonInfoMainPage then
    self.PersonInfoMainPage.bStackCovered = nil
  end
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  self:AddTimer(self.StartDelay or 0, function()
    if self.HideBegin then
      self:SetRenderOpacity(1)
    end
    DebugPrint("开始播动画")
    self.WBP_Com_BgSwitch:PlayAnimationForward(self.WBP_Com_BgSwitch.In, self.AniSpeed or 1)
    self:PlayInAnim()
  end)
end

function M:Close()
  DebugPrint("开始关闭")
  if self.PersonInfoMainPage then
    self.PersonInfoMainPage:OnClose()
  end
  self.Content:ClearChildren()
  self.PersonInfoMainPage = nil
  PersonInfoController:OnClose()
end

function M:PlayInAnim()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "PersonInfoPageMain", nil)
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  AudioManager(self):SetEventSoundParam(self, "PersonInfoPageMain", {ToEnd = 1})
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self.PersonInfoMainPage:PlayAnimationForward(self.PersonInfoMainPage.Out)
  self:PlayAnimationForward(self.Out)
end

function M:CheckIsCanCloseSelf()
  if self.PersonInfoMainPage.IsEditOpen then
    self.PersonInfoMainPage.IsEditOpen = false
    self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.Edit_List_Out)
    self.PersonInfoMainPage:ResetCameraRoamInput()
    return false
  end
  if self:IsAnimationPlaying(self.In) then
    return false
  end
  return true
end

function M:CreatePersonInfoMainPage(ConfigData)
  PersonInfoController.MainPage = self
  local PageMain
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    PageMain = UIManager(self):CreateWidget(ConfigData.PCBluePrint)
  else
    PageMain = UIManager(self):CreateWidget(ConfigData.MobileBluePrint or ConfigData.PCBluePrint)
  end
  if nil == PageMain then
    return
  end
  self.Content:AddChildToOverlay(PageMain)
  local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(PageMain)
  ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  return PageMain
end

function M:HideUIInstant()
  PersonInfoController:SetMainPageUIHidden(true)
  local Page = self.PersonInfoMainPage
  if Page and Page.MainPanel then
    Page.MainPanel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:SetMainPageBlurVisible(false)
  if self.MainPageItem then
    self.MainPageItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local Tab = self.Com_Tab or self.Com_Tab_M
  if Tab then
    Tab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if GameInputModeSubsystem then
    GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
  end
  self:SetFocus()
end

function M:SetMainPageBlurVisible(bVisible)
  local Page = self.PersonInfoMainPage
  local Blur = Page and Page.BackgroundBlurWithMask_Main
  if not Blur then
    return
  end
  local Visibility = UIConst.VisibilityOp.Collapsed
  if bVisible then
    Visibility = UIConst.VisibilityOp.SelfHitTestInvisible
  end
  Blur:SetVisibility(Visibility)
end

function M:PlayAnimation(Animation)
  DebugPrint("PlayAnimation", Animation)
  self.Overridden.PlayAnimation(self, Animation)
end

return M

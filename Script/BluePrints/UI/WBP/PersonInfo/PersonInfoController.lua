local PersonInfoModel = require("BluePrints.UI.WBP.PersonInfo.PersonInfoModel")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local PersonInfoEditModel = require("BluePrints.UI.WBP.PersonInfo.Edit.PersonInfoEditModel")
local PersonInfoDataModel = require("BluePrints.UI.WBP.PersonInfo.Data.PersonInfoDataModel")
local GuildBaseInfo = require("BluePrints.UI.WBP.Guild.Common.GuildBaseInfo")
local M = Class("BluePrints.Common.MVC.Controller")
M.PageEnum = {
  MainPage = 1,
  EditPage = 2,
  DataPage = 3
}

function M:GetPageEnum()
  return M.PageEnum
end

function M:Init()
  M.Super.Init(self)
  PersonInfoEditModel:Init()
  self.CurPage = nil
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetModel()
  return PersonInfoModel
end

function M:GetEdirModel()
  return PersonInfoEditModel
end

function M:GetEventName()
  return EventID.PersonInfoControllerEvent
end

function M:OpenView(PlayerInfo, ForceServerData)
  if PlayerInfo and PlayerInfo.Uuid == PersonInfoModel._Avatar.Uid and true ~= ForceServerData then
    PlayerInfo = nil
  end
  if PlayerInfo then
    PersonInfoModel:SetPersonID(PlayerInfo.Uid)
  end
  self.CurPage = M.PageEnum.MainPage
  PersonInfoModel:InitData(PlayerInfo)
  self.bReturnMain = false
  self.MainPage = M.Super.OpenView(self, nil, PersonInfoCommon.UIName)
  self.MainPage:SetFocus()
  self.CurPage = M.PageEnum.MainPage
  return self.MainPage
end

function M:RefreshMainPageGuildInfo()
  if not self.MainPage or not self.MainPage.PersonInfoMainPage then
    return
  end
  local PersonInfoMainPage = self.MainPage.PersonInfoMainPage
  if PersonInfoMainPage.RefreshGuildInfo then
    PersonInfoMainPage:RefreshGuildInfo()
  else
    PersonInfoMainPage:InitGuildInfo(PersonInfoModel:GetPersonalBaseInfo())
  end
end

function M:IsViewingOtherPlayer(PlayerUuid)
  if nil == PlayerUuid or PersonInfoModel:IsOwener() then
    return false
  end
  local OtherPersonInfo = PersonInfoModel.OtherPersonInfo
  if type(OtherPersonInfo) ~= "table" then
    return false
  end
  return tostring(OtherPersonInfo.Uuid) == tostring(PlayerUuid)
end

function M:HandleOtherPlayerGuildSimpleInfo(PlayerUuid, GuildSimpleInfo)
  if not self:IsViewingOtherPlayer(PlayerUuid) or type(GuildSimpleInfo) ~= "table" then
    return
  end
  local Info = GuildSimpleInfo
  if Info.LogoInfo == nil and nil ~= Info.Logo then
    Info = GuildBaseInfo.New(GuildSimpleInfo)
  end
  if not Info or not PersonInfoModel:ApplyOtherGuildSimpleInfo(Info) then
    return
  end
  self:RefreshMainPageGuildInfo()
end

function M:HandleOpenOtherPlayerView(PlayerInfo, ForceServerData)
  if type(PlayerInfo) ~= "table" then
    return
  end
  self:OpenView(PlayerInfo, ForceServerData)
end

function M:OpenEditView(TabName, BoxIndex)
  if self.CurPage == M.PageEnum.EditPage then
    return
  end
  self.CurPage = M.PageEnum.EditPage
  self:ExitMainPage()
  if self.MainPage.PersonInfoMainPage.ActorController and self.MainPage.PersonInfoMainPage.ActorController.ArmoryPlayer then
    self.MainPage.PersonInfoMainPage.ActorController:HidePlayerActor("PersonInfoEdit", true)
  end
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  local PCBluePrint
  if "PC" == Platform then
    PCBluePrint = " WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Edit_P.WBP_PersonalInfo_Edit_P'"
  else
    PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Edit_M.WBP_PersonalInfo_Edit_M'"
  end
  self.EditPage = UIManager(self):CreateWidget(PCBluePrint)
  if self.EditPage == nil then
    return
  end
  self.EditPage.Root = self.MainPage
  self.MainPage.Content:AddChildToOverlay(self.EditPage)
  local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.EditPage)
  ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  self.EditPage:InitBaseView(TabName, BoxIndex)
  self.EditPage:SetFocus()
  self.EditPage:PlayAnimation(self.EditPage.In)
end

function M:OpenDataView()
  if self.DataPage and self.DataPage.IsClosing then
    DebugPrint("数据统计界面正在关闭中")
    return
  end
  self.CurPage = M.PageEnum.DataPage
  self:ExitMainPageWithoutTab()
  PersonInfoDataModel:Init(PersonInfoModel.OtherPersonInfo)
  self:CreatDataPage()
  self.DataPage.Root = self.MainPage
  self.DataPage:InitBaseView()
  local ActorController = self.MainPage.PersonInfoMainPage.ActorController
  if -1 ~= self.MainPage.PersonInfoMainPage.SelectCharIndex then
    ActorController:SetMontageAndCamera("Char", nil, "Personal", "Data")
  end
end

function M:CreatDataPage()
  local Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  local PCBluePrint
  if "PC" == Platform then
    PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_Data_P.WBP_PersonalInfo_Data_P'"
  else
    PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Data_M.WBP_PersonalInfo_Data_M'"
  end
  self.DataPage = UIManager(self):CreateWidget(PCBluePrint)
  if self.DataPage == nil then
    ScreenPrint("--------------数据统计界面加载失败-----------------")
    return
  end
  self.MainPage.Content:AddChildToOverlay(self.DataPage)
  local ContentOverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(self.DataPage)
  ContentOverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
  ContentOverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  self.DataPage:SetFocus()
  self.DataPage.IsClosing = false
end

function M:OnCloseDateView()
  self.CurPage = M.PageEnum.MainPage
  self.MainPage.PersonInfoMainPage:FreshCamera()
  self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.MainPage:InitTabInfo()
  self.MainPage.PersonInfoMainPage:PlayAnimation(self.MainPage.PersonInfoMainPage.In)
  self.DataPage:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.DataPage.IsClosing = true
  self.MainPage.PersonInfoMainPage:SetOriginFocus()
  if self.MainPage.Com_BtnVisible then
    self.MainPage.PersonInfoMainPage:FreshHideButton()
  end
end

function M:ReallyCloseDateView(Page)
  if not self.DataPage or not self.DataPage.IsClosing then
    DebugPrint("没有数据统计界面，应该是打开时失败")
    return
  end
  if Page then
    Page:RemovefromParent()
  else
    DebugPrint("没有编辑界面，应该是打开时失败")
  end
  self.DataPage = nil
end

function M:CloseEditView()
  PersonInfoEditModel.Handler = nil
  if self.EditPage then
    self.EditPage:RemovefromParent()
    self.EditPage:PlayAnimation(self.EditPage.Out)
  else
    DebugPrint("没有编辑界面，应该是打开时失败")
  end
  self.bReturnMain = true
  self:ReturnMainPage()
  self.CurPage = M.PageEnum.MainPage
end

function M:ExitMainPage()
  self.MainPage.MainPageItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ExitMainPageWithoutTab()
  self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ReturnMainPage()
  self.CurPage = M.PageEnum.MainPage
  self.MainPage.MainPageItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.MainPage.PersonInfoMainPage.ActorController and self.MainPage.PersonInfoMainPage.ActorController.ArmoryPlayer then
    self.MainPage.PersonInfoMainPage.ActorController:HidePlayerActor("PersonInfoEdit", false)
  end
  self.MainPage.PersonInfoMainPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.MainPage.PersonInfoMainPage:InitDisplayBoxView(true)
  self.MainPage.PersonInfoMainPage:SetOriginFocus()
end

function M:GetView(WorldContex)
  return M.Super.GetView(self, WorldContex, PersonInfoCommon.UIName)
end

function M:GetPersonInfo(PlayerInfo)
  UIManager(self):ShowUITip("CommonToastMain", GText("TOAST_DUNGEON_CANCEL_LEAVETEAM"), 1.5)
  self:OpenView(PlayerInfo.Uid)
end

function M:RestoreHistoryRankTab()
  if self.DataPage then
    if self.DataPage.InitNormalBottonKey then
      self.DataPage:InitNormalBottonKey()
    elseif self.DataPage.InitTab then
      self.DataPage:InitTab()
    end
  elseif self.MainPage and self.MainPage.InitTabInfo then
    self.MainPage:InitTabInfo()
  end
end

function M:OnCloseGuildWarHistoryRank()
  if not self.HistoryRankPage then
    return
  end
  if self.DataPage then
    self.DataPage:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.DataPage.IsClosing = false
  end
  self:RestoreHistoryRankTab()
  if self.DataPage and self.DataPage.SetFocus then
    self.DataPage:SetFocus()
  end
  self.HistoryRankPage.IsClosing = true
end

function M:ReallyCloseGuildWarHistoryRank(Page)
  if not self.HistoryRankPage or not self.HistoryRankPage.IsClosing then
    return
  end
  if Page then
    Page:RemovefromParent()
  end
  self.HistoryRankPage = nil
end

function M:CloseGuildWarHistoryRank()
  self:OnCloseGuildWarHistoryRank()
  self:ReallyCloseGuildWarHistoryRank(self.HistoryRankPage)
end

function M:OpenGuildWarHistoryRank()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local BaseInfo = PersonInfoModel:GetGuildWarHistoryBaseInfo()
  
  local function OpenWithRecord(RankRecord)
    local TopNInfo = PersonInfoModel:BuildGuildWarHistoryTopN(BaseInfo, RankRecord or {})
    local SelfRankInfo = PersonInfoModel:BuildGuildWarHistorySelfRank(TopNInfo)
    local HistoryContext = {HistoryMode = true, BaseInfo = BaseInfo}
    UIManager(self):LoadUINew("PersonalInfoDataRanking", SelfRankInfo, TopNInfo, HistoryContext)
  end
  
  if PersonInfoModel.DebugCachedRankData then
    OpenWithRecord(PersonInfoModel.DebugCachedRankData)
    return
  end
  if PersonInfoModel:IsOwener() then
    Avatar:GetRaidSeasonRankRecord(function(ErrCode, Ret)
      if ErrorCode:Check(ErrCode) then
        OpenWithRecord(Ret)
      else
        OpenWithRecord({})
      end
    end)
    return
  end
  OpenWithRecord(PersonInfoModel.OtherRaidSeasonRankRecord or {})
end

function M:OnClose()
  local FocusWidget = UIManager(self):GetLastestAndFocusableUIWidgetObj()
  if FocusWidget and FocusWidget.SetFocus_Lua and type(FocusWidget.SetFocus_Lua) == "function" then
    FocusWidget:SetFocus_Lua()
  end
  self.CurPage = nil
  self.MainPage = nil
  self.EditPage = nil
  self.DataPage = nil
  if self.HistoryRankPage then
    self.HistoryRankPage:RemovefromParent()
    self.HistoryRankPage = nil
  end
  PersonInfoModel:ClearModel()
  PersonInfoDataModel:ClearModel()
end

_G.PersonInfoController = M
return M

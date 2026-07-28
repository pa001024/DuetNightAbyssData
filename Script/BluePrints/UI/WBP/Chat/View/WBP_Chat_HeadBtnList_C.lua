require("UnLua")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local FriendModel = FriendController:GetModel()
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local PageJumpUtils = require("Utils.PageJumpUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function SetDefaultMenuFocus(SelfWidget)
  if not TeamController:IsGamepad() then
    return
  end
  local FocusWidget = SelfWidget.List_Btn
  if SelfWidget.List_Btn:GetNumItems() > 0 then
    local FirstItem = SelfWidget.List_Btn:GetItemAt(0)
    if FirstItem and SelfWidget.List_Btn.GetEntryWidgetFromItem then
      local EntryWidget = SelfWidget.List_Btn:GetEntryWidgetFromItem(FirstItem)
      if EntryWidget then
        if EntryWidget.Button_Area then
          FocusWidget = EntryWidget.Button_Area
        else
          FocusWidget = EntryWidget
        end
      end
    end
  end
  FocusWidget:SetFocus()
end

local function InitControllerKeys(SelfWidget)
  SelfWidget.Key_Confirm:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
      }
    },
    Desc = GText("UI_Tips_Ensure")
  })
  SelfWidget.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight
      }
    },
    Desc = GText("UI_BACK")
  })
  SelfWidget.Controller_Guild:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
      }
    }
  })
end

local function InitBtnControllerKey(BtnWidget, GamePadKey)
  BtnWidget.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = DataMgr.KeyboardText[GamePadKey] and DataMgr.KeyboardText[GamePadKey].KeyText or CommonUtils:GetKeyText(GamePadKey)
      }
    }
  })
end

local function RefreshActionBtnStyle(BtnWidget, IsGamepad, GamePadKey)
  local Switcher = BtnWidget.WS_Controller
  Switcher:SetActiveWidgetIndex(IsGamepad and 1 or 0)
  if IsGamepad and GamePadKey then
    InitBtnControllerKey(BtnWidget, GamePadKey)
  end
end

local function RefreshControllerVisibility(SelfWidget)
  local IsGamepad = TeamController:IsGamepad()
  SelfWidget.Group_Controller:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  SelfWidget.Group_Bottom:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  SelfWidget.Key_Confirm:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  SelfWidget.Key_Back:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if IsGamepad then
    SelfWidget.Controller_Guild:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
        }
      },
      Desc = SelfWidget.bCanOpenGuildDetail and GText("UI_Guild_Detail") or GText("UI_Chat_ShowRecord")
    })
  end
  SelfWidget.Controller_Guild:SetVisibility(IsGamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  RefreshActionBtnStyle(SelfWidget.Btn_Block, IsGamepad, UIConst.GamePadKey.SpecialLeft)
  RefreshActionBtnStyle(SelfWidget.Btn_Report, IsGamepad, UIConst.GamePadKey.SpecialRight)
end

function M:Construct()
  InitControllerKeys(self)
  UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self, self.OnInputDeviceChange)
  self:OnInputDeviceChange()
  ChatController:NotifyEvent(ChatCommon.EventID.OnChatBtnListOpen, true)
end

function M:OnInputDeviceChange()
  RefreshControllerVisibility(self)
  if TeamController:IsGamepad() then
    self.bIsFocusable = true
  elseif not TeamController:IsMobile() then
    self.bIsFocusable = false
  end
end

function M:DontShowBottom()
  self.Group_Bottom:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Remove(self, self.OnInputDeviceChange)
  ChatController:NotifyEvent(ChatCommon.EventID.OnChatBtnListOpen, false)
end

local function CloseHeadAnchor(Owner)
  if Owner and IsValid(Owner) and Owner.HeadAnchor then
    Owner.HeadAnchor:Close()
    return
  end
  if Owner and IsValid(Owner) and Owner.Head_Anchor then
    Owner.Head_Anchor:Close()
  end
end

local function GetStableWorldContext(SelfWidget)
  return SelfWidget.Owner or SelfWidget
end

local function BindHeadBtnAction(BtnWidget, SelfWidget, Action)
  if not BtnWidget or not Action then
    return
  end
  if BtnWidget.Button_Area then
    BtnWidget.Button_Area.OnClicked:Clear()
    BtnWidget.Button_Area.OnClicked:Add(SelfWidget, Action)
  elseif BtnWidget.BindSingleEventOnClicked then
    BtnWidget:BindSingleEventOnClicked(SelfWidget, Action)
  elseif BtnWidget.BindEventOnClicked then
    BtnWidget:UnBindEventOnClickedByObj(SelfWidget)
    BtnWidget:BindEventOnClicked(SelfWidget, Action)
  end
end

local function BindGuildButton(SelfWidget)
  local GuildDelegate = SelfWidget.Btn_Guild.OnClicked
  GuildDelegate:Clear()
  GuildDelegate:Add(SelfWidget, function()
    if SelfWidget.bCanOpenGuildDetail then
      SelfWidget:OpenGuildDetailPopup()
    end
  end)
end

local function InitGuildInfo(SelfWidget, AvatarInfo, GuildFullInfo)
  local GuildSimpleInfo = type(AvatarInfo.GuildSimpleInfo) == "table" and AvatarInfo.GuildSimpleInfo or nil
  if GuildFullInfo then
    GuildSimpleInfo = GuildFullInfo
  end
  local LocalAvatar = GWorld:GetAvatar()
  local IsYourSelf = LocalAvatar and AvatarInfo and AvatarInfo.Uid == LocalAvatar.Uid
  if IsYourSelf then
    local CurrGuild = GuildController:GetModel():GetCurrGuild()
    if type(CurrGuild) == "table" then
      local HasGuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or AvatarInfo.GuildName
      local HasGuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or GuildSimpleInfo.GuildLogoInfo or GuildSimpleInfo.GuildLogo) or AvatarInfo.GuildLogoInfo or AvatarInfo.GuildLogo
      GuildSimpleInfo = GuildSimpleInfo or CurrGuild
      if not AvatarInfo.GuildSimpleInfo then
        AvatarInfo.GuildSimpleInfo = CurrGuild
      end
      if (AvatarInfo.GuildName == nil or AvatarInfo.GuildName == "") and not HasGuildName then
        AvatarInfo.GuildName = CurrGuild.Name
      end
      if AvatarInfo.GuildLogoInfo == nil and AvatarInfo.GuildLogo == nil and not HasGuildLogo then
        AvatarInfo.GuildLogoInfo = CurrGuild.LogoInfo
        AvatarInfo.GuildLogo = CurrGuild.LogoInfo
      end
      if tonumber(AvatarInfo.GuildId or 0) <= 0 and tonumber(CurrGuild.GuildId or 0) > 0 then
        AvatarInfo.GuildId = CurrGuild.GuildId
      end
    end
  end
  local GuildId = tonumber(GuildSimpleInfo and (GuildSimpleInfo.GuildId or GuildSimpleInfo.GuildID or GuildSimpleInfo.Id) or AvatarInfo.GuildId or AvatarInfo.GuildID or 0) or 0
  local GuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or AvatarInfo.GuildName or ""
  local GuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo) or AvatarInfo.GuildLogoInfo or AvatarInfo.GuildLogo
  local ParsedGuildLogo = GuildLogoInfo.Parse(GuildLogo)
  local HasGuild = GuildId > 0 or "" ~= GuildName or nil ~= ParsedGuildLogo
  local HasGuildLogo = nil ~= ParsedGuildLogo
  SelfWidget.bCanOpenGuildDetail = HasGuild
  SelfWidget.GuildDetailGuildId = GuildId
  if not HasGuild then
    SelfWidget.WS_Text:SetActiveWidgetIndex(1)
    SelfWidget.Text_Empty:SetText(GText("RoleDisplay_Guild_1"))
    SelfWidget.Text_Empty:SetVisibility(UIConst.VisibilityOp.Visible)
    SelfWidget.Text_GuildName:SetVisibility(UIConst.VisibilityOp.Collapsed)
    SelfWidget.Logo_Guild:SetVisibility(UIConst.VisibilityOp.Collapsed)
    SelfWidget.Btn_Guild:SetVisibility(UIConst.VisibilityOp.Collapsed)
    SelfWidget.Controller_Guild:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  SelfWidget.Text_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  SelfWidget.WS_Text:SetActiveWidgetIndex(0)
  SelfWidget.Text_GuildName:SetVisibility(UIConst.VisibilityOp.Visible)
  if "" ~= GuildName then
    SelfWidget.Text_GuildName:SetText(GuildName)
  else
    SelfWidget.Text_GuildName:SetText(GText("RoleDisplay_Guild_1"))
  end
  SelfWidget.Btn_Guild:SetVisibility(UIConst.VisibilityOp.Visible)
  if HasGuildLogo then
    SelfWidget.Logo_Guild:Init(ParsedGuildLogo)
    SelfWidget.Logo_Guild:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    SelfWidget.Logo_Guild:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  BindGuildButton(SelfWidget)
end

local function BindBlockButton(SelfWidget, AvatarInfo)
  local RawUid = AvatarInfo and (AvatarInfo.Uid or AvatarInfo.Uuid) or nil
  local TargetUid = FriendController:GetSocialUid(RawUid, AvatarInfo)
  
  function SelfWidget.DoBlockAction()
    local WorldContext = GetStableWorldContext(SelfWidget)
    if FriendModel:GetBlackListDict()[TargetUid] then
      FriendController:SendCancelBlackList(TargetUid, AvatarInfo)
    else
      FriendController:OpenAddBlacklistDialog(WorldContext, AvatarInfo)
    end
    CloseHeadAnchor(SelfWidget.Owner)
  end
  
  BindHeadBtnAction(SelfWidget.Btn_Block, SelfWidget, function()
    SelfWidget.DoBlockAction()
  end)
end

local function RefreshBlockButtonText(SelfWidget, AvatarInfo)
  local RawUid = AvatarInfo and (AvatarInfo.Uid or AvatarInfo.Uuid) or nil
  local TargetUid = FriendController:GetSocialUid(RawUid, AvatarInfo)
  local IsInBlackList = FriendModel:GetBlackListDict()[TargetUid] ~= nil
  local TextMapId = IsInBlackList and "UnblockMember" or "BlockMember"
  SelfWidget.Btn_Block.Text_Desc:SetText(GText(TextMapId))
end

local function InitBlockButton(SelfWidget, AvatarInfo, BtnOption)
  local ShowBlockBtn = BtnOption.ShowBlockBtn
  if nil == ShowBlockBtn then
    ShowBlockBtn = true
  end
  if not ShowBlockBtn then
    SelfWidget.Btn_Block:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  SelfWidget.Btn_Block:SetVisibility(UIConst.VisibilityOp.Visible)
  RefreshBlockButtonText(SelfWidget, AvatarInfo)
  InitBtnControllerKey(SelfWidget.Btn_Block, UIConst.GamePadKey.SpecialLeft)
  BindBlockButton(SelfWidget, AvatarInfo)
end

local function BuildReportParams(SelfWidget, AvatarInfo, AllowNegative)
  local Params = {
    Nickname = AvatarInfo.Nickname,
    UID = AvatarInfo.Uid or AvatarInfo.Uuid,
    RealUID = AvatarInfo.RealUID,
    Level = AvatarInfo.Level,
    TextLenMax = 50,
    ChatMessage = SelfWidget.Owner and SelfWidget.Owner._MessageContent or nil,
    ForbidRightBtn = true,
    DontCloseWhenRightBtnClicked = true,
    InGameOnly = SelfWidget.InGameOnly,
    AllowNegativeAttitude = AllowNegative
  }
  if SelfWidget.Owner and SelfWidget.Owner.HeadAnchor then
    Params.EditTextConfig = {
      Owner = SelfWidget.Owner,
      TextLimit = 50,
      Events = {
        OnTextChanged = SelfWidget.Owner.OnTextChange,
        OnTextComposing = SelfWidget.Owner.OnTextComposing,
        OnEditTextFocusReceived = function()
          if SelfWidget.Owner.bTipsShowed then
            SelfWidget.Owner:HideDialogTip(2, false)
            SelfWidget.Owner.bTipsShowed = false
          end
        end
      }
    }
  end
  return Params
end

local function BindReportButton(SelfWidget, AvatarInfo, AllowNegative)
  function SelfWidget.DoReportAction()
    ChatController:OpenChatReportDialog(BuildReportParams(SelfWidget, AvatarInfo, AllowNegative))
    
    CloseHeadAnchor(SelfWidget.Owner)
  end
  
  BindHeadBtnAction(SelfWidget.Btn_Report, SelfWidget, function()
    SelfWidget.DoReportAction()
  end)
end

local function InitReportButton(SelfWidget, AvatarInfo, BtnOption)
  local ShowReportBtn = BtnOption.ShowReportBtn
  local AllowReportInNonChatContext = BtnOption.AllowReportInNonChatContext == true
  if nil == ShowReportBtn then
    ShowReportBtn = true
  end
  if not ShowReportBtn then
    SelfWidget.Btn_Report:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  SelfWidget.Btn_Report.Text_Desc:SetText(GText("RoleMenu_Report"))
  local InBounsScene = GWorld.GameInstance.IsInTempScene and GWorld.GameInstance:IsInTempScene()
  local IsInDungeon = GWorld:GetAvatar():IsInDungeon()
  local Channel = ChatController:GetModel():GetCurrentChannel()
  local ShowNegativeAttitudeOption = Channel == ChatCommon.ChannelDef.InTeam
  local AllowNegative = BtnOption.AllowNegativeAttitude
  if nil == AllowNegative then
    AllowNegative = FriendController:GetAllowNegativeAttitude(ShowNegativeAttitudeOption)
  end
  local HasMessageContent = SelfWidget.Owner and nil ~= SelfWidget.Owner._MessageContent
  local AllowReport = false
  if GWorld:GetAvatar():IsInHardBoss() then
    AllowReport = not InBounsScene and HasMessageContent
  elseif InBounsScene or IsInDungeon then
    AllowReport = true
  else
    AllowReport = HasMessageContent or AllowReportInNonChatContext
  end
  if not AllowReport then
    SelfWidget.Btn_Report:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  SelfWidget.Btn_Report:SetVisibility(UIConst.VisibilityOp.Visible)
  InitBtnControllerKey(SelfWidget.Btn_Report, UIConst.GamePadKey.SpecialRight)
  BindReportButton(SelfWidget, AvatarInfo, AllowNegative)
end

local function InitOtherButtons(SelfWidget, AvatarInfo, BtnOption)
  local Avatar = ChatController:GetAvatar()
  local RawUid = AvatarInfo and (AvatarInfo.Uid or AvatarInfo.Uuid) or 0
  local TargetUid = tonumber(FriendController:GetSocialUid(RawUid, AvatarInfo) or 0) or 0
  local MyUid = tonumber(Avatar and Avatar.Uid or 0) or 0
  local IsYourSelf = TargetUid > 0 and MyUid > 0 and TargetUid == MyUid
  if IsYourSelf then
    SelfWidget.Group_OtherBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  SelfWidget.Group_OtherBtn:SetVisibility(UIConst.VisibilityOp.Visible)
  InitBlockButton(SelfWidget, AvatarInfo, BtnOption)
  InitReportButton(SelfWidget, AvatarInfo, BtnOption)
end

local function InitMenuList(SelfWidget, FuncList, AvatarInfo, GuildInfo)
  for _, Func in ipairs(FuncList or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Owner = SelfWidget
    Content.ForceHideGamepadKey = true
    Func(Content, AvatarInfo, GuildInfo, function()
      CloseHeadAnchor(SelfWidget.Owner)
    end)
    SelfWidget.List_Btn:AddItem(Content)
  end
end

function M:Init(AvatarInfo, GuildInfo, FuncList, BtnOption)
  self.AvatarInfo = AvatarInfo
  self.BtnOption = BtnOption or {}
  
  function self.DoBlockAction()
  end
  
  function self.DoReportAction()
  end
  
  self.Text_PlayerName:SetText(AvatarInfo.Nickname)
  InitGuildInfo(self, AvatarInfo, GuildInfo)
  InitOtherButtons(self, AvatarInfo, self.BtnOption)
  InitMenuList(self, FuncList, AvatarInfo, GuildInfo)
  RefreshControllerVisibility(self)
  SetDefaultMenuFocus(self)
end

function M:BP_GetDesiredFocusTarget()
  return self.List_Btn or self
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.SpecialLeft or "Gamepad_Special_Left" == InKeyName then
      self.DoBlockAction()
      return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.SpecialRight or "Gamepad_Special_Right" == InKeyName then
      self.DoReportAction()
      return UWidgetBlueprintLibrary.Handled()
    end
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_FaceButton_Right" == InKeyName then
      CloseHeadAnchor(self.Owner)
      return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      if self.bCanOpenGuildDetail then
        self:OpenGuildDetailPopup()
        return UWidgetBlueprintLibrary.Handled()
      else
        return self:TriggerFirstMenuAction()
      end
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft or "Gamepad_Special_Left" == InKeyName then
      self.DoBlockAction()
      return UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.SpecialRight or "Gamepad_Special_Right" == InKeyName then
      self.DoReportAction()
      return UWidgetBlueprintLibrary.Handled()
    end
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.SpecialLeft or InKeyName == UIConst.GamePadKey.SpecialRight then
    return UWidgetBlueprintLibrary.Handled()
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:TriggerFirstMenuAction()
  if self.List_Btn:GetNumItems() > 0 then
    local FirstItem = self.List_Btn:GetItemAt(0)
    if FirstItem and FirstItem.Callback then
      FirstItem.Callback()
      return UWidgetBlueprintLibrary.Handled()
    end
  end
  return UWidgetBlueprintLibrary.UnHandled()
end

function M:OpenGuildDetailPopup()
  PageJumpUtils:CloseFrontDialog()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
  GuildController:OpenGuildDetailPopup(self, self.GuildDetailGuildId)
  CloseHeadAnchor(self.Owner)
end

return M

require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PageJumpUtils = require("Utils.PageJumpUtils")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local FriendModel = FriendController:GetModel()

function M:Construct()
  if self.Head_Player then
    self.Head_Player:BindOnClickEvent(function()
      if self.OnHeadClicked then
        self.OnHeadClicked()
      end
      if self.OpenHeadMenuDeferred then
        self.OpenHeadMenuDeferred()
      elseif self.Head_Anchor then
        self.Head_Anchor:Open(true)
      end
    end)
  end
  if self.Head_Anchor then
    self.Head_Anchor.OnGetMenuContentEvent:Bind(self, self.OnAnchorGetUserMenuContent)
    self.Head_Anchor.OnMenuOpenChanged:Add(self, self.HeadMenuOpenChanged)
  end
end

function M:Destruct()
  if self.Head_Anchor then
    self.Head_Anchor.OnGetMenuContentEvent:Unbind()
    self.Head_Anchor.OnMenuOpenChanged:Remove(self, self.HeadMenuOpenChanged)
  end
end

function M:Init(Data)
  Data = Data or {}
  local RankInfo = Data.RankInfo
  local MenuOpenCallback = Data.MenuOpenCallback
  self.RankInfo = RankInfo
  self.MenuOpenCallback = MenuOpenCallback
  self.OnHeadClicked = Data.OnHeadClicked
  self.OpenHeadMenuDeferred = Data.OpenHeadMenuDeferred
  if not RankInfo or not RankInfo.HeadIconId then
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    return
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  if self.Head_Player then
    self.Head_Player:SetHeadIconById(RankInfo.HeadIconId)
    local HeadFrameId = RankInfo.HeadFrameId
    if not HeadFrameId or 0 == HeadFrameId then
      HeadFrameId = CommonConst.DefaultNoHeadFrame
    end
    self.Head_Player:SetHeadFrame(HeadFrameId)
  end
  if self.Text_Level then
    self.Text_Level:SetText(tostring(RankInfo.Level or ""))
  end
  if self.Text_Name then
    self.Text_Name:SetText(RankInfo.Nickname or "")
  end
  local HasNoTitle = RankInfo.TitleBefore == nil and nil == RankInfo.TitleAfter
  local HasEmptyTitle = RankInfo.TitleBefore and RankInfo.TitleBefore < 0 and RankInfo.TitleAfter and RankInfo.TitleAfter < 0
  if HasNoTitle or HasEmptyTitle then
    if self.WS_Title then
      self.WS_Title:SetActiveWidgetIndex(1)
    end
    return
  end
  if self.WS_Title then
    self.WS_Title:SetActiveWidgetIndex(0)
  end
  local TitleFrame = RankInfo.TitleFrame
  if not TitleFrame or TitleFrame < 0 then
    TitleFrame = 10001
  end
  if self.Overlay_Title then
    self.Overlay_Title:ClearChildren()
    local TitleFrameWidget = UIManager(self):LoadTitleFrameWidget(TitleFrame)
    if TitleFrameWidget then
      self.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
      TitleFrameWidget:SetTitleContent(RankInfo.TitleBefore, RankInfo.TitleAfter)
    end
  end
end

function M:OnAnchorGetUserMenuContent()
  if not self.RankInfo then
    return {}
  end
  local SelfAvatar = GWorld:GetAvatar()
  
  local function AddFriend(Content, AvatarInfo)
    if not ComRankingUtils.LookupByUid(FriendModel:GetFriendDict(), AvatarInfo.Uid) then
      Content.Text = GText("UI_Friend_AddFriend")
      
      function Content.Callback()
        if self.Head_Anchor then
          self.Head_Anchor:Close()
        end
        FriendController:OpenAddFriendDialog(self, AvatarInfo)
      end
    end
  end
  
  local function InitShowRecordBtn(Content, AvatarInfo)
    Content.Text = GText("UI_Chat_ShowRecord")
    
    function Content.Callback()
      if self.Head_Anchor then
        self.Head_Anchor:Close()
      end
      PageJumpUtils:CloseFrontDialog()
      if ComRankingUtils.IsSameUid(AvatarInfo.Uid, SelfAvatar.Uid) then
        PersonInfoController:OpenView()
      else
        GWorld:GetAvatar():CheckOtherPlayerPersonallInfo(AvatarInfo.Uid, nil, AvatarInfo)
      end
    end
  end
  
  local Switch = {AddFriend, InitShowRecordBtn}
  if ComRankingUtils.IsSameUid(self.RankInfo.Uid, SelfAvatar.Uid) or ComRankingUtils.LookupByUid(FriendModel:GetFriendDict(), self.RankInfo.Uid) then
    Switch = {InitShowRecordBtn}
  end
  self.HeadMenuWidget = ChatController:OpenPlayerBtnList(self, self.RankInfo, Switch)
  return self.HeadMenuWidget
end

function M:HeadMenuOpenChanged(bOpen)
  self.bHeadMenuOpen = true == bOpen
  if self.MenuOpenCallback then
    self.MenuOpenCallback(bOpen)
  end
  if false == bOpen then
    self.HeadMenuWidget = nil
    self:SetFocus()
  end
end

function M:OpenHeadMenu()
  if not self.RankInfo or not self.Head_Anchor then
    return false
  end
  self.Head_Anchor:Open(true)
  return true
end

function M:IsHeadMenuOpen()
  return self.Head_Anchor and self.Head_Anchor:IsOpen()
end

function M:CloseHeadMenu()
  if self.Head_Anchor then
    self.Head_Anchor:Close()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bHeadMenuOpen then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.Head_Anchor then
      self.Head_Anchor:Close()
      self:SetFocus()
      return UE4.UWidgetBlueprintLibrary.Handled()
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft or "Gamepad_Special_Left" == InKeyName then
      if self.HeadMenuWidget and self.HeadMenuWidget.DoBlockAction then
        self.HeadMenuWidget:DoBlockAction()
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
    elseif (InKeyName == UIConst.GamePadKey.SpecialRight or "Gamepad_Special_Right" == InKeyName) and self.HeadMenuWidget and self.HeadMenuWidget.DoReportAction then
      self.HeadMenuWidget:DoReportAction()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self:OpenHeadMenu() then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M

require("UnLua")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local ActorController = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayController")
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local DisplayTypes = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayTypes")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local PersonInfoModel = PersonInfoController:GetModel()
local M = Class({})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.PersonInfoEditListCompoment",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoCameraRoamComponent",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfo_ShowcaseSelectionComponent"
}
local DATA_PAGE_CAMERA_OFFSET_TIMER_KEY = "PersonInfo_DataPageCameraOffset"

local function IsValidDisplayContentId(ContentId)
  return nil ~= ContentId and 0 ~= ContentId and -1 ~= ContentId
end

local function RefreshShowcaseEmptyVisual(ItemWidget, bIsEmpty, bIsWeapon)
  if not ItemWidget then
    return
  end
  if ItemWidget.Empty then
    ItemWidget.Empty:SetRenderOpacity(bIsEmpty and 1 or 0)
  end
  if ItemWidget.Com_Item then
    ItemWidget.Com_Item:SetRenderOpacity(bIsEmpty and 0 or 1)
  end
  if bIsEmpty and ItemWidget.WS_EmptySign then
    ItemWidget.WS_EmptySign:SetActiveWidgetIndex(bIsWeapon and 1 or 0)
  end
end

local function ApplyWeaponPreviewPoseWithoutCamera(View, WeaponData)
  if not (View and View.ActorController) or not WeaponData then
    return
  end
  local PoseTag = WeaponData:HasTag("Melee") and "Melee" or "Ranged"
  View.ActorController:SetArmoryMontageTag(PoseTag)
end

function M:Initialize()
  self.IsPersonInfoPage = true
  self.SelectCharIndex = -1
  self.SelectWeaponIndex = -1
  self.Events_BeforeClose = {}
  self.DataPageCameraOffsetState = nil
  self:_ResetGamepadCameraInputState()
  self:InitCameraRoam()
end

function M:IsMainPagePreviewInteractionEnabled()
  return false
end

function M:ApplyMainPageReadOnlyPreviewInputPolicy()
  self.EnableDrag = false
  self.EnableMouseWheel = false
end

local function ContainsValue(Values, TargetValue)
  for _, Value in ipairs(Values or {}) do
    if Value == TargetValue then
      return true
    end
  end
  return false
end

local function ReleaseDisplayController(self, Reason)
  if not self.ActorController then
    DebugPrint(string.format("PersonInfoMainPage: ReleaseDisplayController skipped reason=%s actorController=nil", tostring(Reason)))
    return
  end
  DebugPrint(string.format("PersonInfoMainPage: ReleaseDisplayController reason=%s actorController=%s", tostring(Reason), tostring(self.ActorController)))
  self.ActorController:OnClosed()
  self.ActorController:OnDestruct()
  self.ActorController = nil
end

local function SetPersonInfoDataButtonText(ButtonWidget, Text)
  if not ButtonWidget then
    return
  end
  ButtonWidget:SetText(Text or "")
end

local function SetPersonInfoDataButtonForbidden(ButtonWidget, bForbidden)
  if not ButtonWidget then
    return
  end
  ButtonWidget:SetForbidden(bForbidden)
end

function M:InitBaseView(Personid)
  self.isfirst = true
  self:ApplyMainPageReadOnlyPreviewInputPolicy()
  local PersonalBaseInfo = PersonInfoModel:GetPersonalBaseInfo()
  local PlayerName = PersonalBaseInfo.PlayerName
  local PlayerSignature = PersonalBaseInfo.PlayerSignature
  local CurrentLevel = PersonalBaseInfo.CurrentLevel
  local HeadIconId = PersonalBaseInfo.HeadIconId
  local HeadFrameId = PersonalBaseInfo.HeadFrameId
  local Uid = PersonalBaseInfo.Uid
  local TitleBefore = PersonalBaseInfo.TitleBefore or -1
  local TitleAfter = PersonalBaseInfo.TitleAfter or -1
  local TitleFrame = PersonalBaseInfo.TitleFrame or -1
  self.Text_LevelName:SetText(GText("UI_Player_Level"))
  self.Text_UIDTitle:SetText(GText("UI_UID"))
  self.Text_Copy:SetText(GText("UI_Menu_Option_CopyUID"))
  self.Text_BrithdayTitle:SetText(GText("UI_Chardata_Char_Brithday"))
  self.Text_ShowTitle:SetText(GText("UI_PersonalPage_Showcase"))
  local Avatar = GWorld:GetAvatar()
  local Month, Day = Avatar:GetAvatarBirthday()
  self.Text_Birth:SetText(GDate("Date_MD", {Month = Month, Day = Day}))
  if PlayerName then
    self.Text_PlayerName:SetText(GText(PlayerName))
  end
  if Uid then
    self.Text_UID:SetText(tostring(Uid))
  end
  if CurrentLevel then
    self.Text_Level:SetText(CurrentLevel)
  end
  self.Text_Empty:SetText(GText("UI_Menu_Sign_None"))
  self.Com_ItemHead:SetHeadIconById(HeadIconId, false)
  self.Com_ItemHead:SetHeadFrame(HeadFrameId)
  self:InitGuildInfo(PersonalBaseInfo)
  if "" ~= PlayerSignature then
    self.Switcher_Input:SetActiveWidgetIndex(1)
    self.Text_Input:SetText(PlayerSignature)
  else
    self.Switcher_Input:SetActiveWidgetIndex(0)
  end
  self.Text_EmptyDesc:SetText(GText("UI_PersonInfo_NoChar"))
  self.TitleSetting:Init(PersonInfoModel:IsOwener())
  self.TitleSetting:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
  self.Btn_UID.OnClicked:Add(self, function()
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
    self:StopPress()
    self:OnCopyUID()
  end)
  if PersonInfoModel:IsOwener() then
    self.Com_ItemHead.Button_Area.OnClicked:Add(self, self.OnClickChangePortrait)
    if self.OnClickChangeSignature then
      self.Btn_EditSign.OnClicked:Add(self, self.OnClickChangeSignature)
    end
    self.Btn_EditShow:SetText(GText("UI_PersonalPage_Customize"))
    self.Btn_EditShow.Button_Area.OnClicked:Add(self, self.OnClickOpenCustomEditPage)
    self.Btn_EditShow:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_ItemHead:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Com_ItemHead:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Btn_EditSign:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Button_Edit:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_EditShow:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Text_EmptyDesc:SetText(GText("UI_PersonInfo_NoChar"))
  self:InitDisplayBoxView()
  self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_AvatarTitle:SetText(GText("UI_PersonInfo_ShowCase_Char"))
  self.Text_WeaponTitle:SetText(GText("UI_PersonInfo_ShowCase_Weapon"))
  self.Btn_Data:BindEventOnClicked(self, self.OnClickOpenDataPage)
  self.Btn_Data:BindForbidStateExecuteEvent(self, self.OnClickOpenDataPage)
  if PersonInfoModel:IsOwener() then
    SetPersonInfoDataButtonForbidden(self.Btn_Data, false)
  else
    local Visible = PersonInfoModel:GetDataPageVisibility()
    if Visible then
      SetPersonInfoDataButtonForbidden(self.Btn_Data, false)
    else
      SetPersonInfoDataButtonForbidden(self.Btn_Data, true)
    end
  end
  SetPersonInfoDataButtonText(self.Btn_Data, GText("UI_PersonalPage_Recount_Name"))
  self:RefreshNameCardBackground()
  EventManager:AddEvent(EventID.OnPersonalInfoBgChanged, self, self.OnPersonalInfoBgChanged)
  self:AddReddotListener("EditBtn", self.OnPortraitReddotChange)
  self:AddReddotListener("PersonalInfoCustomizeEntry", self.OnCustomizeEntryReddotChange)
end

function M:InitDisplayBoxView(IsChanegeModel)
  DebugPrint(string.format("PersonInfoMainPage: InitDisplayBoxView changeModel=%s actorController=%s selectChar=%s selectWeapon=%s", tostring(IsChanegeModel), tostring(self.ActorController ~= nil), tostring(self.SelectCharIndex), tostring(self.SelectWeaponIndex)))
  if PersonInfoModel:IsOwener() then
    if self.Group_Setting then
      self.Group_Setting:SetVisibility(UIConst.VisibilityOp.Visible)
    elseif self.Btn_Setting then
      self.Btn_Setting:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if not self.bShowcaseEditEntryBound then
      self.bShowcaseEditEntryBound = true
      self.Btn_Setting.OnClicked:Add(self, self.OnClickOpenEditPage)
    end
  else
    self.Group_Setting:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Setting:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_EditShow:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local DisplayContent = PersonInfoModel:GetDisplayContent()
  local Birthday = DisplayContent.Birthday
  if Birthday then
    self.Text_Birth:SetText(GDate("Date_MD", {
      Month = Birthday[1],
      Day = Birthday[2]
    }))
  end
  local strings = {"Char", "Weapon"}
  local ItemNames = {
    "AvatarItem_",
    "WeaponItem_"
  }
  local Contents = {
    DisplayContent.CharContent,
    DisplayContent.WeaponContent
  }
  local indexes = {
    "SelectCharIndex",
    "SelectWeaponIndex"
  }
  local ChangeSelectfuncnames = {
    "OnClickChangeSelectChar",
    "OnClickChangeSelectWeapon"
  }
  if -1 ~= self.SelectCharIndex then
    self["AvatarItem_" .. self.SelectCharIndex]:Playanimation(self["AvatarItem_" .. self.SelectCharIndex].Hover)
    self:CancelSelectChar(self.SelectCharIndex)
  end
  if -1 ~= self.SelectWeaponIndex then
    self:CancelSelectWeapon(self.SelectWeaponIndex)
  end
  self.SelectCharIndex = -1
  self.SelectWeaponIndex = -1
  for j = 1, 2 do
    local string = strings[j]
    local ItemName = ItemNames[j]
    local Content = Contents[j]
    local index = indexes[j]
    local ChangeSelectfuncname = ChangeSelectfuncnames[j]
    if -1 ~= self[index] then
      self["CancelSelect" .. string](self, self[index])
    end
    for i = 1, 3 do
      local bIsWeapon = 2 == j
      local ItemWidget = self[ItemName .. i]
      local bIsEmptySlot = -1 == Content[i].Id or 0 == Content[i].Id
      RefreshShowcaseEmptyVisual(ItemWidget, bIsEmptySlot, bIsWeapon)
      ItemWidget.Com_Item:SetVisibility(not PersonInfoModel:IsOwener() and bIsEmptySlot and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Visible)
      Content[i].OnAddedToFocusPathEvent = {
        Obj = ItemWidget.Com_Item,
        Callback = self.OnItemFocusForGamePad,
        Params = ItemWidget.Com_Item
      }
      if -1 == Content[i].Id then
        Content[i].Id = 0
      end
      Content[i].HandleMouseDown = true
      if bIsEmptySlot then
        Content[i].OnMouseEnterEvent = {
          Obj = self,
          Callback = function(ItemWidget)
            ItemWidget:PlayAnimation(ItemWidget.Hover)
          end,
          Params = ItemWidget
        }
        Content[i].OnMouseLeaveEvent = {
          Obj = self,
          Callback = function(_, ItemWidget)
            ItemWidget:StopAllAnimations()
            ItemWidget:PlayAnimation(ItemWidget.UnHover)
          end,
          Params = ItemWidget
        }
        Content[i].OnMouseButtonDownEvent = {
          Obj = self,
          Callback = function(_, ItemWidget)
            if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
              return
            end
            ItemWidget:PlayAnimation(ItemWidget.Press)
          end,
          Params = ItemWidget
        }
      else
        Content[i].OnMouseEnterEvent = nil
        Content[i].OnMouseLeaveEvent = nil
        Content[i].OnMouseButtonDownEvent = nil
      end
      ItemWidget.Com_Item:OnListItemObjectSet(Content[i])
      if not bIsEmptySlot then
        if -1 == self[index] then
          self[index] = self[index]
        end
        ItemWidget:PlayAnimation(ItemWidget.Normal)
        ItemWidget.Com_Item:SetAdd(false)
      else
        ItemWidget:PlayAnimation(ItemWidget.Forbidden)
        ItemWidget:StopAllAnimations()
        ItemWidget.Com_Item:SetAdd(PersonInfoModel:IsOwener())
      end
    end
    if -1 ~= self.SelectCharIndex and -1 ~= self[index] then
      self[ItemName .. self[index]]:PlayAnimation(self[ItemName .. self[index]].Click)
    end
    for i = 1, 3 do
      local Item = self[ItemName .. i]
      local bIsEmptySlot = 0 == Content[i].Id or -1 == Content[i].Id
      local bIsWeapon = 2 == j
      local OnMouseButtonUpEvent
      if 0 ~= Content[i].Id and -1 ~= Content[i].Id then
        OnMouseButtonUpEvent = self:GetDetialPageClickFunc(Item, i, string, bIsWeapon)
      else
        OnMouseButtonUpEvent = self:GetEditPageClickFunc(ItemName, i, string)
      end
      Item.Com_Item:ClearEventOnMouseButtonUp(self)
      if OnMouseButtonUpEvent and OnMouseButtonUpEvent.Callback then
        Item.Com_Item:BindEventOnMouseButtonUp(OnMouseButtonUpEvent.Obj, OnMouseButtonUpEvent.Callback, OnMouseButtonUpEvent.Params)
      end
    end
  end
  if self.ActorController == nil then
    self:ModelViewIni()
  end
end

function M:GetEditPageClickFunc(ItemName, i, string)
  if PersonInfoModel:IsOwener() then
    local OnMouseButtonUpEvent = {
      Obj = self,
      Callback = function()
        local ItemWidget = self[ItemName .. i]
        if ItemWidget and ItemWidget.Click then
          ItemWidget:StopAllAnimations()
          ItemWidget:PlayAnimation(ItemWidget.Click)
        end
        self:_RestoreDisplayItemTransientSelection(ItemWidget)
        AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
        PersonInfoController:OpenEditView(string, i)
      end,
      Params = nil
    }
    return OnMouseButtonUpEvent
  end
end

function M:GetDetialPageClickFunc(Item, i, string, bIsWeapon)
  if nil == bIsWeapon then
    bIsWeapon = false
  end
  local OnMouseButtonUpEvent = {
    Obj = self,
    Callback = function()
      self:_RestoreDisplayItemTransientSelection(Item)
      local CharInfos = {}
      local WeaponInfos = {}
      local WeaponForgeLevel = 0
      local SelectedTargetIndex = i
      if false == bIsWeapon then
        CharInfos = PersonInfoModel:GetDisplayCharInfos()
      else
        WeaponInfos = PersonInfoModel:GetDisplayWeaponInfos()
        WeaponForgeLevel = PersonInfoModel:GetAvatarForgeLevel()
      end
      if nil == CharInfos and nil == WeaponInfos then
        return
      end
      if not bIsWeapon then
        AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_role", nil, nil)
      else
        AudioManager(self):PlayUISound(nil, "event:/ui/armory/click_select_weapon", nil, nil)
      end
      local AppearanceIndex, ModSuitIndex = PersonInfoModel:GetAppearanceAndModPlan(bIsWeapon, i)
      if self.ActorController then
        self.ActorController:SuspendPreviewControl()
      end
      UIManager(self):LoadUINew("ArmoryDetail", {
        PreviewCharInfos = CharInfos,
        PreviewWeaponInfos = WeaponInfos,
        WeaponForgeLevel = WeaponForgeLevel,
        EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
        bHideCharFiles = true,
        bHideBoxBtn = true,
        bHideUltraTab = true,
        Title = GText("UI_PersonInfo_Detail_" .. string),
        SelectedTargetIndex = SelectedTargetIndex,
        DoNotSort = true,
        bNoEndCamera = true,
        bFormPersonalPage = true,
        AppearanceIndex = AppearanceIndex,
        OnCloseDelegate = {
          self,
          self.OnArmoryDetailClosed
        }
      })
    end
  }
  return OnMouseButtonUpEvent
end

function M:_RestoreDisplayItemTransientSelection(ItemWidget)
  if not ItemWidget or not ItemWidget.Com_Item then
    return
  end
  local ComItem = ItemWidget.Com_Item
  if ComItem.Content then
    ComItem.Content.IsSelect = false
  end
  if ComItem.SetSelected then
    ComItem:SetSelected(false)
  elseif ItemWidget.Normal then
    ItemWidget:PlayAnimation(ItemWidget.Normal)
  end
end

function M:OnArmoryDetailClosed()
  if self.ActorController then
    self.ActorController:ResumePreviewControl()
  end
  self:SetOriginFocus()
end

function M:_DeprecatedArmoryModelViewIni()
  if -1 == self.SelectCharIndex then
    local Avatar = GWorld:GetAvatar()
    self:OnPersonalInfoOpened(Avatar.Chars[Avatar.CurrentChar])
  end
  if -1 ~= self.SelectCharIndex then
    local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
    self:ChanegeCharInfo(CharBaseInfo, nil, false)
    self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    PersonInfoController.MainPage.bHideCharTab = false
    PersonInfoController.MainPage:InitTabInfo()
    self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if PersonInfoModel:IsOwener() then
      local CharData = PersonInfoModel:GetShowCharData(self.SelectCharIndex)
      if self.ActorController == nil then
        self:OnPersonalInfoOpened(CharData)
      else
        self.ActorController:ChangeCharModel(CharData)
      end
      local uuid, AppearanceSuit = PersonInfoModel:GetCharSuitIndex(self.SelectCharIndex)
      if self.ActorController then
        self.ActorController:ApplyAppearanceSuit(PersonInfoModel._Avatar.Chars[uuid]:DumpAppearanceSuit(PersonInfoModel._Avatar, AppearanceSuit))
      end
      self:AddTimer(0.01, function()
        if -1 ~= self.SelectWeaponIndex then
          self:ChangeWeaponView()
        end
      end, nil, nil, nil, true)
    else
      local FakeAvatar = PersonInfoModel:GetFakeAvatar()
      self:OnPersonalInfoOpened(FakeAvatar.Chars[self.SelectCharIndex])
      if -1 ~= self.SelectWeaponIndex then
        self:ChangeWeaponView()
      end
    end
    self.ActorController:HidePlayerActor("PersonInfo", false)
  else
    self:ForbidenWeaponBox()
    PersonInfoController.MainPage.bHideCharTab = true
    PersonInfoController.MainPage:InitTabInfo()
    self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if true == PersonInfoController.bReturnMain then
    else
      PersonInfoController.bReturnMain = false
    end
    self.ActorController:HidePlayerActor("PersonInfo", true)
  end
end

function M:FreshCamera()
  return
end

function M:GetDataPageCameraOffsetConfig()
  return {
    Horizontal = 0,
    Duration = 0,
    TickInterval = 0.016
  }
end

function M:_StopDataPageCameraOffsetTransition()
  self.DataPageCameraOffsetState = nil
end

function M:_GetActorControllerCameraLocalTransform()
  return nil, nil
end

function M:_BuildDataPageOffsetTargetLocalPosition(BaseLocalPosition)
  return BaseLocalPosition
end

function M:_LerpDataPageCameraLocalTransform(StartLocalPosition, StartLocalRotation, TargetLocalPosition, TargetLocalRotation, Alpha)
  Alpha = math.clamp(Alpha or 0, 0, 1)
  local EaseAlpha = Alpha * Alpha * (3 - 2 * Alpha)
  local StartPosition = StartLocalPosition or FVector(0, 0, 0)
  local TargetPosition = TargetLocalPosition or FVector(0, 0, 0)
  local StartRotation = StartLocalRotation or FRotator(0, 0, 0)
  local TargetRotation = TargetLocalRotation or FRotator(0, 0, 0)
  local LocalPosition = FVector((StartPosition.X or 0) + ((TargetPosition.X or 0) - (StartPosition.X or 0)) * EaseAlpha, (StartPosition.Y or 0) + ((TargetPosition.Y or 0) - (StartPosition.Y or 0)) * EaseAlpha, (StartPosition.Z or 0) + ((TargetPosition.Z or 0) - (StartPosition.Z or 0)) * EaseAlpha)
  local LocalRotation = FRotator((StartRotation.Pitch or 0) + ((TargetRotation.Pitch or 0) - (StartRotation.Pitch or 0)) * EaseAlpha, (StartRotation.Yaw or 0) + ((TargetRotation.Yaw or 0) - (StartRotation.Yaw or 0)) * EaseAlpha, (StartRotation.Roll or 0) + ((TargetRotation.Roll or 0) - (StartRotation.Roll or 0)) * EaseAlpha)
  return LocalPosition, LocalRotation
end

function M:_TickDataPageCameraOffsetTransition()
  self:_StopDataPageCameraOffsetTransition()
end

function M:_BeginDataPageCameraOffsetTransition(TargetLocalPosition, TargetLocalRotation)
  self:_StopDataPageCameraOffsetTransition()
  return false
end

function M:PlayEnterDataPageCameraOffset()
  return false
end

function M:PlayReturnFromDataPageCameraOffset()
  return false
end

function M:ForbidenWeaponBox()
  for i = 1, 3 do
    self["WeaponItem_" .. i].Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self["WeaponItem_" .. i]:StopAllAnimations()
    self["WeaponItem_" .. i]:PlayAnimation(self["WeaponItem_" .. i].Forbidden)
  end
end

function M:_DeprecatedArmorySingleCharacterOnPersonalInfoOpened(CharData)
  if self.ActorController == nil then
    self.ActorController = ActorController:New({
      ViewUI = PersonInfoController.MainPage,
      Char = CharData,
      Avatar = PersonInfoModel:IsOwener() and PersonInfoModel._Avatar or PersonInfoModel:GetFakeAvatar(),
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    self.ActorController:OnOpened()
  end
end

function M:GetValidDisplayCharIndices()
  local DisplayContent = PersonInfoModel:GetDisplayContent()
  local ValidIndices = {}
  local CharContent = DisplayContent and DisplayContent.CharContent or nil
  for Index = 1, 3 do
    local Content = CharContent and CharContent[Index] or nil
    if Content and Content.Id and 0 ~= Content.Id and -1 ~= Content.Id then
      table.insert(ValidIndices, Index)
    end
  end
  return ValidIndices
end

function M:_DeprecatedArmoryBuildMultiCharacterPreviewDraft()
  local CustomDraft = PersonInfoModel.GetCustomDisplayDraft and PersonInfoModel:GetCustomDisplayDraft() or nil
  if CustomDraft then
    local ValidIndices = {}
    for SlotIndex, Slot in ipairs(CustomDraft.CharacterSlots or {}) do
      if Slot and Slot.CharData then
        table.insert(ValidIndices, SlotIndex)
      end
    end
    if #ValidIndices > 0 then
      return CustomDraft, ValidIndices, true
    end
  end
  local SceneId = PersonInfoModel:GetCustomDisplaySceneId()
  local Draft = DisplayDraft:CreateEmpty(SceneId)
  return Draft, {}, false
end

function M:_DeprecatedArmoryApplyDisplayPreviewDraft()
  if not self.ActorController then
    return false
  end
  local Draft, ValidIndices, bUsingCustomDisplayDraft = self:BuildMultiCharacterPreviewDraft()
  if 0 == #ValidIndices then
    self.bUsingCustomDisplayDraft = false
    return false
  end
  if not ContainsValue(ValidIndices, self.SelectCharIndex) then
    self.SelectCharIndex = ValidIndices[1]
  end
  local Editor = self.ActorController:GetEditor()
  if not Editor then
    self.bUsingCustomDisplayDraft = false
    return false
  end
  self.bUsingCustomDisplayDraft = true == bUsingCustomDisplayDraft
  Editor:SetDraft(Draft)
  return true
end

function M:IsUsingCustomDisplayDraft()
  return self.bUsingCustomDisplayDraft == true
end

function M:SaveCurrentDisplayDraftForDebug()
  if not self.ActorController then
    ScreenPrint("个人主页调试保存失败：展示控制器不存在")
    return false
  end
  local Editor = self.ActorController.GetEditor and self.ActorController:GetEditor() or nil
  if not Editor then
    ScreenPrint("个人主页调试保存失败：展示编辑器不存在")
    return false
  end
  local SaveData = Editor.ExportSaveData and Editor:ExportSaveData() or nil
  if not SaveData then
    ScreenPrint("个人主页调试保存失败：导出数据为空")
    return false
  end
  local bStarted = PersonInfoModel:SaveCustomDisplayDraft(Editor, function(ret)
    ScreenPrint("个人主页调试保存完成 ret=" .. tostring(ret))
  end)
  if not bStarted then
    ScreenPrint("个人主页调试保存发起失败")
    return false
  end
  local CameraParam = SaveData.CameraParam or {}
  local Position = CameraParam.Position or {}
  local Rotation = CameraParam.Rotation or {}
  ScreenPrint(string.format("个人主页调试保存已发起 SceneId=%s Pos=(%s,%s,%s) Rot=(%s,%s,%s)", tostring(SaveData.SceneId), tostring(Position[1] or 0), tostring(Position[2] or 0), tostring(Position[3] or 0), tostring(Rotation[1] or 0), tostring(Rotation[2] or 0), tostring(Rotation[3] or 0)))
  return true
end

function M:OnPersonalInfoClosed()
  DebugPrint(string.format("PersonInfoMainPage: OnPersonalInfoClosed actorController=%s", tostring(self.ActorController ~= nil)))
  ReleaseDisplayController(self, "OnPersonalInfoClosed")
  self:_ResetGamepadCameraInputState()
end

function M:RebuildDisplayPreviewAfterExternalPreviewClosed()
  if self.ActorController and self.ActorController.RefreshAfterExternalPreviewClosed then
    self.ActorController:RefreshAfterExternalPreviewClosed()
    return
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnPersonalInfoBgChanged, self)
  self:RemoveReddotListener("EscPortrait", self.OnPortraitFrameReddotChange)
  self:RemoveReddotListener("EditBtn")
  self:RemoveReddotListener("PersonalInfoCustomizeEntry")
  self:_StopDataPageCameraOffsetTransition()
  self:ResetCameraRoamInput()
  self:_ResetGamepadCameraInputState()
  ReleaseDisplayController(self, "Destruct")
end

function M:ChangeWeaponView()
  if self.ActorController == nil then
    return
  end
  self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local WeaponData = PersonInfoModel:GetShowWeaponData(self.SelectWeaponIndex)
  if WeaponData then
    self.ActorController:ChangeWeaponModel(WeaponData)
    ApplyWeaponPreviewPoseWithoutCamera(self, WeaponData)
  end
end

function M:_DeprecatedArmoryOnClickChangeSelectChar(index)
  RedPrint("OnClickChangeSelectChar")
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetForbidden(false)
  self:CancelSelectChar(self.SelectCharIndex)
  self.SelectCharIndex = index
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local CharData
  CharData = PersonInfoModel:GetShowCharData(self.SelectCharIndex)
  self.ActorController:ChangeCharModel(CharData)
  if self.SelectWeaponIndex > 0 then
    self:ChangeWeaponView()
  end
  if PersonInfoModel:IsOwener() then
    local uuid, AppearanceSuit = PersonInfoModel:GetCharSuitIndex(self.SelectCharIndex)
    self.ActorController:ApplyAppearanceSuit(PersonInfoModel._Avatar.Chars[uuid]:DumpAppearanceSuit(PersonInfoModel._Avatar, AppearanceSuit))
  end
  local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
  self:ChanegeCharInfo(CharBaseInfo)
end

function M:_DeprecatedArmoryOnClickChangeSelectWeapon(index)
  self:CancelSelectWeapon(self.SelectWeaponIndex)
  self.SelectWeaponIndex = index
  self:ChangeWeaponView()
end

function M:_DeprecatedArmoryChanegeCharInfo(CharData)
  self.Image_CharType:SetBrushResourceObject(CharData.AttributeIcon)
  self.Text_CharName:SetText(GText(CharData.Name))
  if 5 == CharData.Rarity then
    self.Gacha_Star_5:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Gacha_Star_5:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:CancelSelectChar(index)
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetChecked(false)
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:CancelSelectWeapon(index)
  self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetChecked(false)
  self["WeaponItem_" .. self.SelectWeaponIndex].Button_Area:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:FreshHeadAndFrames(IsFrame, HeadOrFrameId)
  if true == IsFrame then
    self.Com_ItemHead:SetHeadFrame(HeadOrFrameId)
  else
    self.Com_ItemHead:SetHeadIconById(HeadOrFrameId, false)
  end
end

function M:RefreshNameCardBackground()
  local bgPath = PersonInfoModel:GetPersonalInfoBackground()
  if bgPath then
    local Image = LoadObject(bgPath)
    if Image then
      local DynamicMaterial = self.Img_Color:GetDynamicMaterial()
      if DynamicMaterial then
        DynamicMaterial:SetTextureParameterValue("MainTex", Image)
      end
    end
    self.WS_Img:SetActiveWidgetIndex(1)
    self.Group_NameCardBG:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Group_NameCardBG:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnPersonalInfoBgChanged(BgType, BgId)
  if BgType ~= CommonConst.PersonalInfoBgType.PersonalInfo then
    return
  end
  self:RefreshNameCardBackground()
end

function M:OnClose()
  PersonInfoModel:DeleteFakeAvatar()
  self:_StopDataPageCameraOffsetTransition()
  for _, Events in pairs(self.Events_BeforeClose) do
    if Events then
      Events(self)
    end
  end
  self:OnPersonalInfoClosed()
end

function M:OnClickOpenEditPage()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
  PersonInfoController:OpenEditView("Char", nil)
end

function M:OnClickOpenCustomEditPage()
  UIManager(self):LoadUINew("PersonalEdit", {TabName = "Char", PersonInfoMainPage = self})
end

function M:OnClickOpenDataPage()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
  if PersonInfoModel:IsOwener() then
    PersonInfoController:OpenDataView()
  else
    local Visible = PersonInfoModel:GetDataPageVisibility()
    if Visible then
      PersonInfoController:OpenDataView()
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PersonalPage_Recount_Hidden"))
    end
  end
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  if PersonInfoController:IsMainPageUIHidden() then
    local RootPage = self.RootPage or PersonInfoController.MainPage
    if RootPage and RootPage.Recoverui then
      RootPage:Recoverui()
      return UE4.UWidgetBlueprintLibrary.Handled()
    elseif self.Recoverui then
      self:Recoverui()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  if self.IsEditOpen then
    self.IsEditOpen = false
    self:PlayAnimation(self.Edit_List_Out)
    self:ResetCameraRoamInput()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_DeprecatedArmoryOnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:_DeprecatedArmoryOnMouseMove(MyGeometry, MouseEvent)
  if self.IsDragging and UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    return UWidgetBlueprintLibrary.Unhandled()
  end
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnMouseCaptureLost()
  self:_ResetGamepadCameraInputState()
  self:OnPointerCaptureLost()
end

function M:TickCameraRoamInput(InDeltaTime)
  return false
end

function M:_ResetGamepadCameraInputState()
  self.GamepadCameraInputState = nil
end

local function GetFirstValidDisplayFocusWidget(View)
  local ItemPrefixes = {
    "AvatarItem_",
    "WeaponItem_"
  }
  for _, Prefix in ipairs(ItemPrefixes) do
    for Index = 1, 3 do
      local Item = View[Prefix .. Index]
      local ComItem = Item and Item.Com_Item
      local Content = ComItem and ComItem.Content
      if ComItem and Content and 0 ~= Content.Id and -1 ~= Content.Id then
        return ComItem
      end
    end
  end
  return nil
end

function M:SetOriginFocus()
  local FocusWidget
  if -1 ~= self.SelectCharIndex then
    local AvatarWidget = self["AvatarItem_" .. tostring(self.SelectCharIndex)]
    FocusWidget = AvatarWidget.Com_Item
  else
    local AvatarWidget = self.AvatarItem_1
    FocusWidget = AvatarWidget.Com_Item
  end
  DebugPrint("聚焦到起点")
  if not PersonInfoModel:IsOwener() then
    FocusWidget = GetFirstValidDisplayFocusWidget(self)
    PersonInfoController.MainPage:SetFocus()
    if FocusWidget then
      FocusWidget:SetFocus()
    end
    return
  end
  if self.IsEditOpen then
    local FirstEditItem = self:GetFisrtEditItem()
    if FirstEditItem then
      FirstEditItem:SetFocus()
    end
    if self.FreshFocusOnEditListView then
      self:FreshFocusOnEditListView()
    end
  else
    if self.FreshFocusLeaveEditListView then
      self:FreshFocusLeaveEditListView()
    end
    if FocusWidget then
      FocusWidget:SetFocus()
    else
      PersonInfoController.MainPage:SetFocus()
    end
  end
end

function M:_DeprecatedArmoryRotateActorForGamePad(MoveDeltaX, MoveDeltaY)
  return
end

function M:_DeprecatedArmoryUpdateGamepadZoomInput(InputKey, AxisValue)
  return
end

function M:ZoomCamare(Dalta)
  return
end

function M:OnItemFocusForGamePad(ItemObj)
  if PersonInfoController.MainPage.CurInputDeviceType == ECommonInputType.Gamepad then
    if 0 ~= ItemObj.Content.Id then
      PersonInfoController.MainPage:UpdataGamePadBottomAInfo(2)
    elseif PersonInfoModel:IsOwener() then
      PersonInfoController.MainPage:UpdataGamePadBottomAInfo(1)
    else
      PersonInfoController.MainPage:UpdataGamePadBottomAInfo()
    end
  end
end

function M:OnPortraitReddotChange(Count)
  self.Button_Edit.New:SetEnable(Count > 0)
end

function M:AddReddotListener(ReddotNodeName, func)
  self:RemoveReddotListener(ReddotNodeName)
  ReddotManager.AddListenerEx(ReddotNodeName, self, func)
  self.ListenedReddot = self.ListenedReddot or {}
  self.ListenedReddot[ReddotNodeName] = true
end

function M:RemoveReddotListener(ReddotNodeName)
  if self.ListenedReddot and self.ListenedReddot[ReddotNodeName] then
    ReddotManager.RemoveListener(ReddotNodeName, self)
    self.ListenedReddot[ReddotNodeName] = false
  end
end

function M:OnCustomizeEntryReddotChange(Count)
  self.Btn_EditShow.New:SetEnable(Count > 0)
end

local function SetGuildDisplayVisibility(View, bVisible)
  local LogoVisibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  local TextVisibility = bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  View.GuildInfo:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.HitTestInvisible)
  View.GuildInfo.WS_Type:SetActiveWidgetIndex(bVisible and 0 or 1)
  View.GuildInfo.Text_Empty:SetText(GText("RoleDisplay_Guild_1"))
  View.GuildInfo.Logo:SetVisibility(LogoVisibility)
  View.GuildInfo.Text_GuildName:SetVisibility(TextVisibility)
end

function M:_DeprecatedInteractiveRefreshGuildGamepadKeyVisibility()
  local RootPage = PersonInfoController.MainPage
  local bIsGamepad = RootPage and RootPage.CurInputDeviceType == ECommonInputType.Gamepad
  local bCanOpenGuildDetail = (tonumber(self.GuildDetailGuildId) or 0) > 0
  self.GuildInfo.Key_Controller:SetVisibility(bIsGamepad and bCanOpenGuildDetail and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:_DeprecatedInteractiveCanOpenGuildDetailByGamepad()
  return (tonumber(self.GuildDetailGuildId) or 0) > 0
end

function M:_DeprecatedInteractiveTryOpenGuildDetailByGamepad()
  if not self:CanOpenGuildDetailByGamepad() then
    return false
  end
  GuildController:OpenGuildDetailPopup(self, self.GuildDetailGuildId)
  return true
end

function M:_DeprecatedInteractiveInitGuildInfo(PersonalBaseInfo)
  local GuildSimpleInfo = type(PersonalBaseInfo.GuildSimpleInfo) == "table" and PersonalBaseInfo.GuildSimpleInfo or nil
  local GuildId = tonumber(GuildSimpleInfo and (GuildSimpleInfo.GuildId or GuildSimpleInfo.GuildID or GuildSimpleInfo.Id) or PersonalBaseInfo.GuildId or PersonalBaseInfo.GuildID or 0) or 0
  local GuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or PersonalBaseInfo.GuildName or ""
  local GuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or GuildSimpleInfo.GuildLogoInfo or GuildSimpleInfo.GuildLogo) or PersonalBaseInfo.GuildLogoInfo or PersonalBaseInfo.GuildLogo
  local ParsedGuildLogo = GuildLogoInfo.Parse(GuildLogo)
  if GuildId <= 0 or not ParsedGuildLogo then
    self.GuildDetailGuildId = 0
    SetGuildDisplayVisibility(self, false)
    self:RefreshGuildGamepadKeyVisibility()
    return
  end
  self.GuildInfo.Text_GuildName:SetText("" ~= GuildName and GuildName or GText("RoleDisplay_Guild_1"))
  self.GuildInfo.Logo:Init(ParsedGuildLogo)
  self.GuildInfo.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.RightThumb
      }
    }
  })
  self.GuildDetailGuildId = GuildId
  if not self.bGuildEntryBound then
    self.bGuildEntryBound = true
    self.GuildInfo.Btn_Guild.OnClicked:Add(self, function()
      AudioManager(self):PlayUISound(nil, "event:/ui/common/special_content_01_click", nil, nil)
      GuildController:OpenGuildDetailPopup(self, self.GuildDetailGuildId)
    end)
  end
  SetGuildDisplayVisibility(self, true)
  self:RefreshGuildGamepadKeyVisibility()
end

function M:_DeprecatedInteractiveRefreshGuildInfo()
  self:InitGuildInfo(PersonInfoModel:GetPersonalBaseInfo())
end

function M:_DeprecatedDraftModelViewIni()
  if -1 == self.SelectCharIndex then
    local ValidIndices = self:GetValidDisplayCharIndices()
    if #ValidIndices > 0 then
      self.SelectCharIndex = ValidIndices[1]
    else
      self:OnPersonalInfoOpened()
    end
  end
  if -1 ~= self.SelectCharIndex then
    local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
    self:ChanegeCharInfo(CharBaseInfo, nil, false)
    self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    PersonInfoController.MainPage.bHideCharTab = false
    PersonInfoController.MainPage:InitTabInfo()
    self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.ActorController == nil then
      self:OnPersonalInfoOpened()
    end
    if self:ApplyDisplayPreviewDraft() then
      self:AddTimer(0.01, function()
        self.ActorController:FixedCameraTransTimeOnce(0)
        if -1 ~= self.SelectWeaponIndex then
          self:ChangeWeaponView()
        end
      end, nil, nil, nil, true)
    end
    self.ActorController:HidePlayerActor("PersonInfo", false)
    return
  end
  self:ForbidenWeaponBox()
  PersonInfoController.MainPage.bHideCharTab = true
  PersonInfoController.MainPage:InitTabInfo()
  self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  if self.ActorController and true ~= PersonInfoController.bReturnMain then
    PersonInfoController.bReturnMain = false
  end
  if self.ActorController then
    self.ActorController:HidePlayerActor("PersonInfo", true)
  end
end

function M:_DeprecatedDraftOnPersonalInfoOpened(CharData)
  if self.ActorController ~= nil then
    return
  end
  local InitialCharData = CharData
  if not InitialCharData then
    local ValidIndices = self:GetValidDisplayCharIndices()
    if #ValidIndices > 0 then
      self.SelectCharIndex = -1 ~= self.SelectCharIndex and self.SelectCharIndex or ValidIndices[1]
      InitialCharData = PersonInfoModel:GetShowCharData(self.SelectCharIndex)
    else
      local Avatar = GWorld:GetAvatar()
      InitialCharData = Avatar and Avatar.Chars and Avatar.Chars[Avatar.CurrentChar] or nil
    end
  end
  self.ActorController = ActorController:New({
    ViewUI = PersonInfoController.MainPage,
    Char = InitialCharData,
    Avatar = PersonInfoModel:IsOwener() and PersonInfoModel._Avatar or PersonInfoModel:GetFakeAvatar(),
    SceneId = PersonInfoModel:GetCustomDisplaySceneId(),
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    PreviewInstanceKey = "PersonInfoPageMain"
  })
  self.ActorController:OnOpened()
  self:ApplyDisplayPreviewDraft()
end

function M:_DeprecatedDraftOnClickChangeSelectChar(index)
  RedPrint("OnClickChangeSelectChar")
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetForbidden(false)
  self:CancelSelectChar(self.SelectCharIndex)
  self.SelectCharIndex = index
  self["AvatarItem_" .. self.SelectCharIndex].Button_Area:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:ApplyDisplayPreviewDraft()
  if self.SelectWeaponIndex > 0 then
    self:ChangeWeaponView()
  end
  local CharBaseInfo = PersonInfoModel:GetShowCharBaseInfo(self.SelectCharIndex)
  self:ChanegeCharInfo(CharBaseInfo)
end

function M:BuildMultiCharacterPreviewDraft()
  local CustomDraft = PersonInfoModel.GetCustomDisplayDraft and PersonInfoModel:GetCustomDisplayDraft() or nil
  if CustomDraft then
    local ValidIndices = {}
    for SlotIndex, Slot in ipairs(CustomDraft.CharacterSlots or {}) do
      if Slot and Slot.CharData then
        table.insert(ValidIndices, SlotIndex)
      end
    end
    DebugPrint(string.format("PersonInfoMainPage: BuildMultiCharacterPreviewDraft useCustomDraft=true validCount=%s sceneId=%s", tostring(#ValidIndices), tostring(CustomDraft.Scene and CustomDraft.Scene.SceneId or nil)))
    return CustomDraft, ValidIndices, true
  end
  local SceneId = PersonInfoModel:GetCustomDisplaySceneId()
  local Draft = DisplayDraft:CreateEmpty(SceneId)
  DebugPrint(string.format("PersonInfoMainPage: BuildMultiCharacterPreviewDraft useCustomDraft=false validCount=0 sceneId=%s", tostring(SceneId)))
  return Draft, {}, false
end

function M:ApplyDisplayPreviewDraft()
  if not self.ActorController then
    DebugPrint("PersonInfoMainPage: ApplyDisplayPreviewDraft skipped because ActorController is nil")
    return false
  end
  local Draft, ValidIndices, bUsingCustomDisplayDraft = self:BuildMultiCharacterPreviewDraft()
  if not self.ActorController.ApplyPreviewDraft then
    self.bUsingCustomDisplayDraft = false
    DebugPrint(string.format("PersonInfoMainPage: ApplyDisplayPreviewDraft failed because controller apply method is nil validCount=%s usingCustomDraft=%s", tostring(#ValidIndices), tostring(true == bUsingCustomDisplayDraft)))
    return false
  end
  self.bUsingCustomDisplayDraft = true == bUsingCustomDisplayDraft
  DebugPrint(string.format("PersonInfoMainPage: ApplyDisplayPreviewDraft setDraft validCount=%s usingCustomDraft=%s sceneId=%s", tostring(#ValidIndices), tostring(self.bUsingCustomDisplayDraft), tostring(Draft and Draft.Scene and Draft.Scene.SceneId or nil)))
  return self.ActorController:ApplyPreviewDraft(Draft) == true
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  if not self:IsMainPagePreviewInteractionEnabled() then
    return UWidgetBlueprintLibrary.Unhandled()
  end
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:RotateActorForGamePad(MoveDeltaX, MoveDeltaY)
  return
end

function M:UpdateGamepadZoomInput(InputKey, AxisValue)
  return
end

local function SetGuildDisplayVisibility_ReadOnly(View, bVisible)
  local TextVisibility = UIConst.VisibilityOp.HitTestInvisible
  local ArrowVisibility = bVisible and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed
  View.Text_Guild:SetVisibility(TextVisibility)
  View.Image_FlagIcon:SetVisibility(ArrowVisibility)
  View.Image_Arrow:SetVisibility(ArrowVisibility)
  View.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
end

local function RefreshGuildEntryAnimationState(View, bHasGuild)
  if View.StopAnimation then
    View:StopAnimation(View.Guild_Lock)
    View:StopAnimation(View.Guild_UnLock)
  end
  View:PlayAnimation(bHasGuild and View.Guild_UnLock or View.Guild_Lock)
end

function M:RefreshGuildGamepadKeyVisibility()
  if self.GuildInfo then
    self.GuildInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:CanOpenGuildDetailByGamepad()
  return (tonumber(self.GuildDetailGuildId) or 0) > 0
end

function M:TryOpenGuildDetailByGamepad()
  if not self:CanOpenGuildDetailByGamepad() then
    return false
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/special_content_01_click", nil, nil)
  GuildController:OpenGuildDetailPopup(self, self.GuildDetailGuildId)
  return true
end

function M:InitGuildInfo(PersonalBaseInfo)
  if self.GuildInfo then
    self.GuildInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local GuildSimpleInfo = type(PersonalBaseInfo.GuildSimpleInfo) == "table" and PersonalBaseInfo.GuildSimpleInfo or nil
  local GuildId = tonumber(GuildSimpleInfo and (GuildSimpleInfo.GuildId or GuildSimpleInfo.GuildID or GuildSimpleInfo.Id) or PersonalBaseInfo.GuildId or PersonalBaseInfo.GuildID or 0) or 0
  local GuildName = GuildSimpleInfo and (GuildSimpleInfo.Name or GuildSimpleInfo.GuildName) or PersonalBaseInfo.GuildName or ""
  local GuildLogo = GuildSimpleInfo and (GuildSimpleInfo.LogoInfo or GuildSimpleInfo.Logo or GuildSimpleInfo.GuildLogoInfo or GuildSimpleInfo.GuildLogo) or PersonalBaseInfo.GuildLogoInfo or PersonalBaseInfo.GuildLogo
  local ParsedGuildLogo = GuildLogoInfo.Parse(GuildLogo)
  local LogoId = ParsedGuildLogo and (tonumber(ParsedGuildLogo.LogoIcon) or tonumber(ParsedGuildLogo.T_LogoType) or 0) or 0
  local LogoData = DataMgr.GuildLogo and DataMgr.GuildLogo[LogoId] or nil
  local LogoPath = LogoData and (LogoData.Icon or LogoData.LogoPath) or nil
  local LogoTexture = LogoPath and LoadObject(LogoPath) or nil
  if GuildId <= 0 or "" == GuildName then
    self.GuildDetailGuildId = 0
    self.Text_Guild:SetText(GText("RoleDisplay_Guild_1"))
    self.Image_FlagIcon:SetBrushResourceObject(nil)
    self.Btn_Click:SetForbidden(true)
    SetGuildDisplayVisibility_ReadOnly(self, false)
    RefreshGuildEntryAnimationState(self, false)
    self:RefreshGuildGamepadKeyVisibility()
    return
  end
  self.GuildInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Guild:SetText(GuildName)
  self.Image_FlagIcon:SetBrushResourceObject(LogoTexture)
  self.Btn_Click:SetForbidden(false)
  self.GuildDetailGuildId = GuildId
  if not self.bGuildEntryBound then
    self.bGuildEntryBound = true
    self.Btn_Click.OnClicked:Clear()
    self.Btn_Click.OnClicked:Add(self, function()
      AudioManager(self):PlayUISound(nil, "event:/ui/common/special_content_01_click", nil, nil)
      GuildController:OpenGuildDetailPopup(self, self.GuildDetailGuildId)
    end)
  end
  SetGuildDisplayVisibility_ReadOnly(self, true)
  RefreshGuildEntryAnimationState(self, true)
  self:RefreshGuildGamepadKeyVisibility()
end

function M:RefreshGuildInfo()
  self:InitGuildInfo(PersonInfoModel:GetPersonalBaseInfo())
end

function M:ModelViewIni()
  local Draft, ValidIndices, bUsingCustomDisplayDraft = self:BuildMultiCharacterPreviewDraft()
  DebugPrint(string.format("PersonInfoMainPage: ModelViewIni actorController=%s validCount=%s draftSceneId=%s", tostring(self.ActorController ~= nil), tostring(#ValidIndices), tostring(Draft and Draft.Scene and Draft.Scene.SceneId or nil)))
  self.Com_EmptyBg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  PersonInfoController.MainPage.bHideCharTab = #ValidIndices <= 0
  PersonInfoController.MainPage:InitTabInfo()
  self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.bUsingCustomDisplayDraft = true == bUsingCustomDisplayDraft
  if self.ActorController == nil then
    DebugPrint("PersonInfoMainPage: ModelViewIni will create ActorController")
    self:OnPersonalInfoOpened()
  end
  local bPreviewReady = false
  if self:ApplyDisplayPreviewDraft() then
    DebugPrint("PersonInfoMainPage: ModelViewIni ApplyDisplayPreviewDraft success")
    bPreviewReady = true
  else
    DebugPrint("PersonInfoMainPage: ModelViewIni ApplyDisplayPreviewDraft failed")
  end
  if bPreviewReady then
    self:AddTimer(0.01, function()
      self.ActorController:FixedCameraTransTimeOnce(0)
      if #ValidIndices > 0 and -1 ~= self.SelectWeaponIndex then
        self:ChangeWeaponView()
      elseif self:IsUsingCustomDisplayDraft() and #ValidIndices > 0 then
        for _, SlotIndex in ipairs(ValidIndices) do
          self.ActorController:FinalizeCharacterWeaponPose(SlotIndex, Draft)
        end
      end
    end, nil, nil, nil, true)
  end
  if self.ActorController then
    DebugPrint(string.format("PersonInfoMainPage: ModelViewIni hidePlayerActor empty=%s", tostring(#ValidIndices <= 0)))
    self.ActorController:HidePlayerActor("PersonInfo", #ValidIndices <= 0)
  end
end

function M:OnPersonalInfoOpened(CharData)
  if self.ActorController ~= nil then
    DebugPrint("PersonInfoMainPage: OnPersonalInfoOpened skipped because ActorController already exists")
    return
  end
  local InitialCharData = CharData
  local Draft, ValidIndices = self:BuildMultiCharacterPreviewDraft()
  if not InitialCharData then
    if #ValidIndices > 0 then
      local InitialDisplayIndex = ContainsValue(ValidIndices, self.SelectCharIndex) and self.SelectCharIndex or ValidIndices[1]
      local InitialSlot = Draft and Draft.CharacterSlots and Draft.CharacterSlots[InitialDisplayIndex] or nil
      InitialCharData = InitialSlot and InitialSlot.CharData or PersonInfoModel:GetShowCharData(InitialDisplayIndex)
    else
      local FirstSlot = Draft and Draft.CharacterSlots and Draft.CharacterSlots[1] or nil
      InitialCharData = FirstSlot and FirstSlot.CharData or nil
    end
  end
  DebugPrint(string.format("PersonInfoMainPage: OnPersonalInfoOpened create ActorController initialChar=%s sceneId=%s", tostring(InitialCharData and InitialCharData.CharId or nil), tostring(PersonInfoModel:GetCustomDisplaySceneId())))
  self.ActorController = ActorController:New({
    ViewUI = PersonInfoController.MainPage,
    Char = InitialCharData,
    Avatar = PersonInfoModel:IsOwener() and PersonInfoModel._Avatar or PersonInfoModel:GetFakeAvatar(),
    SceneId = PersonInfoModel:GetCustomDisplaySceneId(),
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    PreviewInstanceKey = "PersonInfoPageMain",
    SkipInitialDraftLoad = true
  })
  self.ActorController:OnOpened()
  DebugPrint("PersonInfoMainPage: OnPersonalInfoOpened ActorController OnOpened done")
end

function M:OnClickChangeSelectChar(index)
  self.SelectCharIndex = index
end

function M:OnClickChangeSelectWeapon(index)
  self.SelectWeaponIndex = index
end

function M:ChanegeCharInfo(CharData)
  if self.Group_AvatarInfo then
    self.Group_AvatarInfo:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

AssembleComponents(M)
return M

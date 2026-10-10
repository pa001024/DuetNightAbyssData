require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  self.Super.Construct(self)
  self.MainPageWidget = nil
  self.TreePageWidget = nil
  self.CommonTabWidget = nil
  self.CurSubWidget = nil
end

function M:OnLoaded(QuestChainId)
  self.Super.OnLoaded(self, QuestChainId)
  self:RenameWidget()
  self:InitMainPage(QuestChainId)
  self:SwitchAnchorPage(self.MainPageWidget)
  self:InitMainPageTab()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitListenEvent()
  self:PlayAnimation(self.In)
end

function M:RenameWidget()
  self.CommonTabWidget = self.Tab
end

function M:InitMainPageTab()
  if not self.CommonTabWidget then
    return
  end
  self.CommonTabWidget:Init({
    TitleName = GText("UI_QuestReview_01"),
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = {},
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = self:GetMainPageBottomKeyInfo(),
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown
  })
end

function M:InitTreePageTab()
  if not self.CommonTabWidget then
    return
  end
  self.CommonTabWidget:Init({
    TitleName = GText("UI_QuestReview_01"),
    LeftKey = "NotShow",
    RightKey = "NotShow",
    Tabs = {},
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = self:GetTreePageBottomKeyInfo(),
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.BackToMainPage
  })
end

function M:GetMainPageBottomKeyInfo()
  return {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    },
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumbNormal,
          Owner = self
        }
      },
      Desc = GText("UI_Controller_Switch")
    },
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom,
          Owner = self
        }
      },
      Desc = GText("UI_Controller_Go")
    }
  }
end

function M:GetTreePageBottomKeyInfo()
  return {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.BackToMainPage,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
end

function M:InitMainPage(QuestChainId)
  local MainPage = self:CreateWidgetNew("QuestReviewMainPage")
  if not MainPage then
    return
  end
  local Slot = self.Anchor:AddChild(MainPage)
  Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Fill)
  Slot:SetVerticalAlignment(UE4.EVerticalAlignment.VAlign_Fill)
  MainPage:Init(self, QuestChainId)
  self.MainPageWidget = MainPage
end

function M:OnChapterClicked(QuestReviewId)
  if not self.TreePageWidget then
    local TreePage = self:CreateWidgetNew("QuestReviewTreePage")
    if not TreePage then
      return
    end
    local Slot = self.Anchor:AddChild(TreePage)
    Slot:SetHorizontalAlignment(UE4.EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(UE4.EVerticalAlignment.VAlign_Fill)
    self.TreePageWidget = TreePage
  end
  self.TreePageWidget:Init(self, QuestReviewId)
  self:SwitchAnchorPage(self.TreePageWidget)
  self:InitTreePageTab()
end

function M:SwitchAnchorPage(ShowWidget)
  if not self.Anchor then
    return
  end
  local Count = self.Anchor:GetChildrenCount()
  for Index = 0, Count - 1 do
    local Child = self.Anchor:GetChildAt(Index)
    if Child == ShowWidget then
      self.CurSubWidget = Child
      if Child.SwitchIn then
        Child:SwitchIn()
      else
        Child:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
    else
      local Visibility = Child:GetVisibility()
      if Visibility ~= UIConst.VisibilityOp.Collapsed and Visibility ~= UIConst.VisibilityOp.Hidden then
        if Child.SwitchOut then
          Child:SwitchOut()
        else
          Child:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
      end
    end
  end
end

function M:OnReturnKeyDown()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:BackToMainPage()
  if self.MainPageWidget then
    self:SwitchAnchorPage(self.MainPageWidget)
    self:InitMainPageTab()
  else
    self:OnReturnKeyDown()
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    self:InitKeyboardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  if self.CurSubWidget and self.CurSubWidget.InitGamepadView then
    self.CurSubWidget:InitGamepadView()
  end
end

function M:InitKeyboardView()
  if self.CurSubWidget and self.CurSubWidget.InitKeyboardView then
    self.CurSubWidget:InitKeyboardView()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  if self.CurSubWidget and self.CurSubWidget.HandleKeyDown then
    IsEventHandled = self.CurSubWidget:HandleKeyDown(MyGeometry, InKeyEvent)
  end
  if not IsEventHandled then
    local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
    local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
    if "Escape" == KeyName then
      self:OnReturnKeyDown()
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Destruct()
  self.MainPageWidget = nil
  self.TreePageWidget = nil
  self.CommonTabWidget = nil
  self.CurSubWidget = nil
  self:UnbindAllFromAnimationFinished(self.Out)
  self.Super.Destruct(self)
end

function M:OnDestroyed()
  self.Super.OnDestroyed(self)
  self:ClearListenEvent()
end

return M

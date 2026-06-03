require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
M._components = {
  "BluePrints.UI.WBP.Chat.View.HeadAnchorComp"
}
local Handled = UWidgetBlueprintLibrary.Handled()

function M:BindOnClickEvent(Func)
  self.ClickFunc = Func
end

function M:BindOnMouseHover(Func)
  self.HoverFunc = Func
end

function M:SetHoldUp(bHoldUp)
  self.bHoldUp = bHoldUp
end

function M:Construct()
  self.Button_Area.OnHovered:Add(self, self.BtnAreaOnHovered)
  self.Button_Area.OnUnhovered:Add(self, self.BtnAreaOnUnhovered)
  self.Button_Area.OnClicked:Add(self, self.BtnAreaOnClicked)
  self.Button_Area.OnPressed:Add(self, self.BtnAreaOnPressed)
end

function M:Destruct()
  self.ClickFunc = nil
  self.HoverFunc = nil
  self.bHoldUp = nil
  self.bSelected = nil
  self.Button_Area.OnHovered:Remove(self, self.BtnAreaOnHovered)
  self.Button_Area.OnUnhovered:Remove(self, self.BtnAreaOnUnhovered)
  self.Button_Area.OnClicked:Remove(self, self.BtnAreaOnClicked)
  self.Button_Area.OnPressed:Remove(self, self.BtnAreaOnPressed)
end

function M:BtnAreaOnPressed()
  DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnPressed")
  if self.bDisableAction then
    return
  end
  if self.bSelected then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Press)
  return
end

function M:SetHeadFrame(HeadFrameId)
  self.DynamicFrame:ClearChildren()
  self.DynamicFrame:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.HeadFrameId = HeadFrameId
  if not HeadFrameId or HeadFrameId == CommonConst.DefaultNoHeadFrame then
    if not HeadFrameId then
      DebugPrint(LXYTag, "服务端没有同步头像框数据，暂时不显示头像框")
    end
    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local Conf = DataMgr.HeadFrame[HeadFrameId]
  if not Conf then
    DebugPrint(LXYTag, "无效的头像框id")
    return
  end
  if Conf.SmallIcon then
    UResourceLibrary.LoadObjectAsync(self, Conf.SmallIcon, {
      self,
      function(_, IconRes)
        self.Head_Frame:SetBrushResourceObject(IconRes)
      end
    })
    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  elseif Conf.DynamicPath then
    UIManager(self):CreateWidgetAsync(string.format("HeadFrame_%s", HeadFrameId), function(Widget)
      if self.DynamicFrame:GetChildrenCount() > 0 then
        return
      end
      self.DynamicFrame:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.DynamicFrame:AddChild(Widget)
      local Slot = UWidgetLayoutLibrary.SlotAsBorderSlot(Widget)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    end, Conf.DynamicPath)
  end
end

function M:BtnAreaOnClicked()
  DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnClicked")
  if self.bDisableAction then
    return
  end
  if self.bHead then
    AudioManager(self):PlayUISound(self, "event:/ui/common/team_avatar_click", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  self.bSelected = true
  if self.ClickFunc then
    self.ClickFunc()
  end
end

function M:SetHeadIcon(HeadIcon, bUseBigHead)
  if bUseBigHead then
    self.Panel_Img:SetActiveWidgetIndex(2)
    local Material = self.Img_Head:GetDynamicMaterial()
    Material:SetTextureParameterValue("IconMap", HeadIcon)
    self.bUseBigHead = true
    return
  end
  self.bUseBigHead = false
  self.Panel_Img:SetActiveWidgetIndex(0)
  local Material = self.Img_Item:GetDynamicMaterial()
  Material:SetTextureParameterValue("IconMap", HeadIcon)
  self.bHead = true
end

function M:SetHeadIconById(HeadIconId, bUseBigHead)
  if not HeadIconId then
    return
  end
  self.DynamicHead:ClearChildren()
  self.DynamicHead:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local HeadData = DataMgr.HeadSculpture[HeadIconId]
  if not HeadData then
    return
  end
  if HeadData.HeadPath then
    UResourceLibrary.LoadObjectAsync(self, HeadData.HeadPath, {
      self,
      function(_, HeadIcon)
        self:SetHeadIcon(HeadIcon, bUseBigHead)
      end
    })
  elseif HeadData.DynamicPath then
    UIManager(self):CreateWidgetAsync(string.format("HeadIcon_%s", HeadIconId), function(Widget)
      if self.DynamicHead:GetChildrenCount() > 0 then
        return
      end
      self.Panel_Img:SetActiveWidgetIndex(5)
      self.DynamicHead:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.DynamicHead:AddChild(Widget)
      local Slot = UWidgetLayoutLibrary.SlotAsBorderSlot(Widget)
      Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      if self:IsPlayingAnimation(self.Add) then
        local Delegate
        Delegate = {
          self,
          function()
            self.Panel_Img:SetActiveWidgetIndex(5)
            self:UnbindFromAnimationFinished(self.Add, Delegate)
          end
        }
        self:BindToAnimationFinished(self.Add, Delegate)
      end
    end, HeadData.DynamicPath)
  end
end

function M:SetHeadIconEmpty(bIsEmpty)
  self.bHead = false
  self:StopAllAnimations()
  if bIsEmpty then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.Panel_Img:SetActiveWidgetIndex(3)
    self:PlayAnimation(self.Empty)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
    if self.bUseBigHead then
      self.Panel_Img:SetActiveWidgetIndex(2)
    else
      self.Panel_Img:SetActiveWidgetIndex(0)
    end
    self:PlayAnimation(self.Normal)
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    if self.HeadFrameId then
      self.Head_Frame:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:BtnAreaOnHovered()
  DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnHovered")
  if self.bDisableAction then
    return
  end
  if self.bHoldUp and self.bSelected then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.Hover)
  if self.HoverFunc then
    self.HoverFunc(true)
  end
end

function M:BtnAreaOnUnhovered()
  DebugPrint(LXYTag, "Common_Head_Small_C:BtnAreaOnUnhovered")
  if self.bDisableAction then
    return
  end
  if self.bHoldUp and self.bSelected then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(self.UnHover)
  if self.HoverFunc then
    self.HoverFunc(false)
  end
end

function M:PlayNormal()
  self:StopAllAnimations()
  self:PlayAnimation(self.Normal)
  self.bSelected = false
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Click and not self.bHoldUp then
    self:PlayAnimation(self.Normal)
  elseif Animation == self.UnHover then
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:SetGamepadCursor()
  self.Button_Area:SetNavigatePosAngle(0)
  self.Button_Area:SetNavigatePosOffsetPercent(FVector2D(0.5, -0.5))
  self.Button_Area:SetNavigatePosOffsetAlignment(FVector2D(0.5, 0.5))
end

function M:SetDisableAction(bDisable)
  self.bDisableAction = bDisable
end

function M:HeadIconSetupAnchor(Head_Anchor, PlayerInfo, GuildInfo, NotShowOpreationBtn, NotShowGuildSendPrivateChat)
  self:SetHoldUp(true)
  self:BindOnClickEvent(function()
    Head_Anchor:Open(true)
  end)
  self:SetGuildFullInfo(GuildInfo, NotShowOpreationBtn, NotShowGuildSendPrivateChat)
  self:SetupAnchor(Head_Anchor, self, PlayerInfo, true)
end

AssembleComponents(M)
return M

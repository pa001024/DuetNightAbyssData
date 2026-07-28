require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(ItemObj)
  if not ItemObj then
    return
  end
  self.FuncId = ItemObj.FuncId
  self.OwnerPanel = ItemObj.OwnerPanel
  if not self.FuncId then
    self.Ws_State:SetActiveWidgetIndex(1)
    if self.Check then
      self.Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Btn.OnClicked:Remove(self, self.OnBtnClicked)
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    return
  end
  if ItemObj.IconPath then
    local Resource = LoadObject(ItemObj.IconPath)
    if Resource then
      if string.find(ItemObj.IconPath, "/Materials/", 1, true) then
        self.Icon:SetBrushFromMaterial(Resource)
      else
        self.Icon:SetBrushFromTexture(Resource)
      end
    end
  end
  self.TextTitle:SetText(ItemObj.Name)
  self.Ws_State:SetActiveWidgetIndex(0)
  ItemObj.EntryWidget = self
  self:RefreshState(ItemObj.IsInSlot, ItemObj.EditCheckState)
  self.Btn.OnClicked:Remove(self, self.OnBtnClicked)
  self.Btn.OnClicked:Add(self, self.OnBtnClicked)
end

function M:RefreshState(IsInSlot, EditCheckState)
  self.Ws_State:SetActiveWidgetIndex(0)
  if nil == EditCheckState then
    if self.Check then
      self.Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if IsInSlot then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Using)
    else
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
    end
  elseif "selected" == EditCheckState then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.SetChoose)
  elseif "other_slot" == EditCheckState then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.SetChoose_Other)
  else
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  end
end

function M:OnBtnClicked()
  if self.OwnerPanel and type(self.OwnerPanel.OnItemClicked) == "function" then
    self.OwnerPanel:OnItemClicked(self.FuncId)
  end
end

function M:Destruct()
end

AssembleComponents(M)
return M

require("UnLua")
require("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")
local M = Class("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")

function M:SetPlayerBasicInfo(Avatar)
  if self.Text_Name and Avatar.Nickname then
    self.Text_Name:SetText(GText(Avatar.Nickname))
  end
  if self.Text_Level and Avatar.Level then
    self.Text_Level:SetText(tostring(Avatar.Level))
  end
  local HeadIconId = Avatar.HeadIconId
  local HeadFrameId = Avatar.HeadFrameId
  if self.Head_Player and HeadIconId then
    self.Head_Player:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Head_Player:SetHeadIconById(HeadIconId)
    self.Head_Player:SetHeadFrame(HeadFrameId)
  end
  if self.WBP_PersonalInfo_TitleSetting then
    local TitleBefore = Avatar.TitleBefore or -1
    local TitleAfter = Avatar.TitleAfter or -1
    local TitleFrame = Avatar.TitleFrame or -1
    self.WBP_PersonalInfo_TitleSetting:Init(false)
    self.WBP_PersonalInfo_TitleSetting:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
  end
  local Char = Avatar.Chars[Avatar.CurrentChar]
  local CharIconPath = DataMgr.Char[Char.CharId].EscMenuBg
  local Image = LoadObject(CharIconPath)
  if Image then
    local DynamicMaterial = self.Img_Avatar:GetDynamicMaterial()
    DynamicMaterial:SetTextureParameterValue("MainTex", Image)
  end
end

function M:SetHeadIconById(HeadIconId, bUseBigHead)
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
    end, HeadData.DynamicPath)
  end
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

return M

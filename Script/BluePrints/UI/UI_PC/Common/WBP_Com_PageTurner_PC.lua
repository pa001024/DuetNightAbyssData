require("UnLua")
local WBP_Com_PageTurner_PC = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})

function WBP_Com_PageTurner_PC:InitPageTurner(GuideMessageNum, UserWidget, HandleIndexFunc, BeginIndex)
  self.StartPageIndex = 1
  self.EndPageIndex = GuideMessageNum
  self.PrePageIndex = BeginIndex or 1
  self.CurrentPageIndex = BeginIndex or 1
  self.UserWidget = UserWidget
  self.Callback = HandleIndexFunc
  self:InitPagePoint()
end

function WBP_Com_PageTurner_PC:SwtichPagePointAnimation(CurrentPageIndex)
  self.PrePageIndex = self.CurrentPageIndex
  self.CurrentPageIndex = CurrentPageIndex
  local PagePoint = self.Root:GetChildAt(self.PrePageIndex - 1)
  if not PagePoint then
    Utils.ScreenPrintScreenPirnt("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
    return
  end
  PagePoint:StopAllAnimations()
  PagePoint:PlayAnimation(PagePoint.Normal)
  PagePoint = self.Root:GetChildAt(self.CurrentPageIndex - 1)
  if not PagePoint then
    Utils.ScreenPrintScreenPirnt("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
    return
  end
  PagePoint:StopAllAnimations()
  PagePoint:PlayAnimation(PagePoint.Click, 0, 1, 0, 1, true)
end

function WBP_Com_PageTurner_PC:PageLeft(IsNeedLoop)
  local CurrentPageIndex = 1
  if IsNeedLoop then
    CurrentPageIndex = (self.CurrentPageIndex - 1 > 1 or 1 == self.CurrentPageIndex - 1) and self.CurrentPageIndex - 1 or self.EndPageIndex
  else
    CurrentPageIndex = self.CurrentPageIndex - 1 > 1 and self.CurrentPageIndex - 1 or 1
  end
  self:SwtichPagePointAnimation(CurrentPageIndex)
  self.Callback(self.UserWidget, self.CurrentPageIndex, true)
end

function WBP_Com_PageTurner_PC:PageRight(IsNeedLoop)
  local CurrentPageIndex = 1
  if IsNeedLoop then
    CurrentPageIndex = (self.CurrentPageIndex + 1 < self.EndPageIndex or self.CurrentPageIndex + 1 == self.EndPageIndex) and self.CurrentPageIndex + 1 or 1
  else
    CurrentPageIndex = self.CurrentPageIndex + 1 < self.EndPageIndex and self.CurrentPageIndex + 1 or self.EndPageIndex
  end
  self:SwtichPagePointAnimation(CurrentPageIndex)
  self.Callback(self.UserWidget, self.CurrentPageIndex)
end

function WBP_Com_PageTurner_PC:PageStart()
  self:SwtichPagePointAnimation(self.StartPageIndex)
  self.Callback(self.UserWidget, self.CurrentPageIndex)
end

function WBP_Com_PageTurner_PC:PageEnd()
  self:SwtichPagePointAnimation(self.EndPageIndex)
  self.Callback(self.UserWidget, self.CurrentPageIndex)
end

function WBP_Com_PageTurner_PC:CheckCurDeviceIsPC()
  return CommonUtils.GetDeviceTypeByPlatformName(self) == "PC"
end

function WBP_Com_PageTurner_PC:HandleClickPointIndex(PagePoint)
  local index = self.Root:GetChildIndex(PagePoint)
  self:SwtichPagePointAnimation(index + 1)
  self.Callback(self.UserWidget, self.CurrentPageIndex)
end

function WBP_Com_PageTurner_PC:CheckIsCurrentPage(PagePoint)
  return self.Root:GetChildIndex(PagePoint) + 1 == self.CurrentPageIndex
end

function WBP_Com_PageTurner_PC:OnPagePointClicked(PagePoint)
  if not self:CheckCurDeviceIsPC() then
    return
  end
  if not self:CheckIsCurrentPage(PagePoint) then
    self:HandleClickPointIndex(PagePoint)
  end
end

function WBP_Com_PageTurner_PC:OnPagePointPressed(PagePoint)
  if not self:CheckCurDeviceIsPC() then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_small", nil, nil)
  if not self:CheckIsCurrentPage(PagePoint) then
    PagePoint:PlayAnimation(PagePoint.Press)
  end
end

function WBP_Com_PageTurner_PC:OnPagePointHovered(PagePoint)
  if not self:CheckCurDeviceIsPC() then
    return
  end
  if not self:CheckIsCurrentPage(PagePoint) then
    PagePoint:PlayAnimation(PagePoint.Hover)
  end
end

function WBP_Com_PageTurner_PC:OnPagePointUnhovered(PagePoint)
  if not self:CheckCurDeviceIsPC() then
    return
  end
  if not self:CheckIsCurrentPage(PagePoint) then
    PagePoint:PlayAnimation(PagePoint.UnHover)
  end
end

function WBP_Com_PageTurner_PC:InitPagePoint()
  self.Root:ClearChildren()
  for i = 1, self.EndPageIndex do
    local NowPoint = UIManager(self):_CreateWidgetNew("PagePoint")
    if not NowPoint then
      Utils.ScreenPrintScreenPirnt("翻页点创建异常，请检查WidgetUI配置表中的PagePoint的配置信息是否正确")
      return
    end
    NowPoint.Button_Area.OnClicked:Add(self, function()
      self:OnPagePointClicked(NowPoint)
    end)
    NowPoint.Button_Area.OnPressed:Add(self, function()
      self:OnPagePointPressed(NowPoint)
    end)
    NowPoint.Button_Area.OnHovered:Add(self, function()
      self:OnPagePointHovered(NowPoint)
    end)
    NowPoint.Button_Area.OnUnhovered:Add(self, function()
      self:OnPagePointUnhovered(NowPoint)
    end)
    self.Root:AddChildToWrapBox(NowPoint)
    NowPoint:PlayAnimation(NowPoint.Normal)
  end
  local CurPoint = self.Root:GetChildAt(self.CurrentPageIndex - 1)
  if not CurPoint then
    Utils.ScreenPrint("翻页器索引获取PagePoint异常，建议检查下方法InitPageTurner传入的参数GuideMessageNum，或者检查下调用组件显示信息的Excel配置表")
    return
  end
  self:AddDelayFrameFunc(function()
    CurPoint:PlayAnimation(CurPoint.Click)
  end, 3, "DelayClick")
end

function WBP_Com_PageTurner_PC:ReBindClickEvent(PageIndex, Func)
  if not Func then
    return
  end
  local Point = self.Root:GetChildAt(PageIndex - 1)
  if not Point then
    return
  end
  Point.Button_Area.OnClicked:Clear()
  Point.Button_Area.OnClicked:Add(self, Func)
end

return WBP_Com_PageTurner_PC

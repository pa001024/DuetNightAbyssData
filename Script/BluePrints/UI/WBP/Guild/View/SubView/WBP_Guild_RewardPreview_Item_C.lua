require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnListItemObjectSet(Content)
  self.Parent = Content.Parent
  self.Index = Content.Index
  self.GroupTitle = Content.GroupTitle
  self.RewardId = Content.RewardId
  self:InitRewardView()
end

function M:InitRewardView()
  self.HB_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Text_TitleNum:SetText(self.GroupTitle)
  local RewardContentList = {}
  
  local function FillWithRewardData(RewardInfo)
    if not RewardInfo then
      return
    end
    local RewardObject = {}
    RewardObject.Id = RewardInfo.Id
    RewardObject.Icon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
    RewardObject.ParentWidget = self
    RewardObject.ItemType = RewardInfo.Type
    RewardObject.Rarity = RewardInfo.Rarity or 1
    RewardObject.IsShowDetails = true
    RewardObject.UIName = "GuildRewardPreview"
    RewardObject.HandleMouseDown = true
    if self.Parent then
      RewardObject.OnMenuOpenChangedEvents = {
        Obj = self.Parent,
        Callback = self.Parent.OnMenuOpenChanged
      }
    end
    if RewardInfo.Quantity then
      if #RewardInfo.Quantity > 1 then
        RewardObject.Count = RewardInfo.Quantity[1]
        RewardObject.MaxCount = RewardInfo.Quantity[2]
      else
        RewardObject.Count = RewardInfo.Quantity[1]
      end
    end
    table.insert(RewardContentList, RewardObject)
  end
  
  local AllRewardList = RewardUtils:GetRewardViewInfoById(self.RewardId)
  if type(AllRewardList) == "table" then
    for _, v in ipairs(AllRewardList) do
      FillWithRewardData(v)
    end
  else
    FillWithRewardData(AllRewardList)
  end
  if 0 == #RewardContentList then
    self.Wrap_RewardBox:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Wrap_RewardBox:ClearChildren()
    for _, v in ipairs(RewardContentList) do
      local Widget = UIManager(self):_CreateWidgetNew("ComItemUniversalS")
      if Widget then
        self.Wrap_RewardBox:AddChild(Widget)
        Widget:Init(v)
      end
    end
    self.Wrap_RewardBox:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  local FocusWidget = self.Wrap_RewardBox:GetChildAt(0)
  if FocusWidget then
    FocusWidget:SetFocus()
    return UIUtils.Handle
  end
  return UIUtils.Unhandled
end

return M

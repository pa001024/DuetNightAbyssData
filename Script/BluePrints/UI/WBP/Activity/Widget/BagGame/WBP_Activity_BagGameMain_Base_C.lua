local TemplateContainItems = {
  {
    1,
    3,
    1
  },
  {
    1,
    4,
    1
  },
  {
    1,
    5,
    1
  },
  {
    1,
    6,
    1
  },
  {
    1,
    7,
    1
  },
  {
    1,
    10,
    1
  },
  {
    2,
    2,
    1
  },
  {
    2,
    3,
    2
  },
  {
    2,
    4,
    1
  },
  {
    2,
    5,
    2
  },
  {
    2,
    6,
    1
  },
  {
    2,
    7,
    2
  },
  {
    2,
    8,
    1
  },
  {
    3,
    1,
    1
  },
  {
    3,
    2,
    1
  },
  {
    3,
    3,
    1
  },
  {
    3,
    4,
    1
  },
  {
    3,
    5,
    1
  },
  {
    3,
    6,
    1
  },
  {
    3,
    7,
    1
  },
  {
    3,
    8,
    1
  },
  {
    3,
    9,
    1
  },
  {
    4,
    1,
    1
  },
  {
    4,
    2,
    -1
  },
  {
    4,
    3,
    1
  },
  {
    4,
    4,
    1
  },
  {
    4,
    5,
    1
  },
  {
    4,
    6,
    1
  },
  {
    4,
    7,
    1
  },
  {
    4,
    8,
    -1
  },
  {
    4,
    9,
    1
  },
  {
    5,
    1,
    1
  },
  {
    5,
    2,
    2
  },
  {
    5,
    3,
    1
  },
  {
    5,
    4,
    2
  },
  {
    5,
    5,
    1
  },
  {
    5,
    6,
    2
  },
  {
    5,
    7,
    1
  },
  {
    5,
    8,
    2
  },
  {
    6,
    1,
    1
  },
  {
    6,
    2,
    1
  },
  {
    6,
    3,
    1
  },
  {
    6,
    4,
    1
  },
  {
    6,
    5,
    1
  },
  {
    6,
    6,
    1
  },
  {
    6,
    7,
    1
  },
  {
    6,
    9,
    1
  },
  {
    6,
    10,
    1
  },
  {
    7,
    1,
    1
  },
  {
    7,
    9,
    1
  },
  {
    7,
    10,
    1
  },
  {
    8,
    1,
    2
  },
  {
    8,
    2,
    1
  },
  {
    8,
    3,
    2
  },
  {
    8,
    8,
    2
  },
  {
    8,
    9,
    1
  },
  {
    8,
    10,
    2
  }
}
require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local BagGamePlayBPPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/BagGame/WBP_Activity_BagGame_Play.WBP_Activity_BagGame_Play'"

function M:Construct()
  M.Super.Construct(self)
  self.WBP_Btn_Begin.Btn_Begin.OnClicked:Add(self, self.OnBeginBtnClicked)
  self.Wrap_Normal_L.OnListViewScrolled:Add(self, self._OnListItemScrolled)
  self.Wrap_Normal_L.OnMouseButtonUp:Add(self, self.OnListItemReleased)
  self.Wrap_Normal_L.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Conf = nil
    Content.IsSelected = false
    Content.Parent = self
    return Content
  end)
  self.CurrentSelectedContent = nil
  self.CurrentSelectedIndex = nil
  self.CurrentRealDataIndex = nil
  self.LastSelectedEntry = nil
  self.LastSelectedIndex = nil
  self.LastSelectedContentId = nil
  self.OriginalDataList = {}
  self.OriginalDataCount = 0
  self.bIsResettingScroll = false
  self.MiddleStartIndex = 0
  self.bIsScrollingToTarget = false
end

function M:Destruct()
  self.Wrap_Normal_L.OnCreateEmptyContent:Unbind()
  self.Wrap_Normal_L.OnListViewScrolled:Remove(self, self._OnListItemScrolled)
  self.Wrap_Normal_L.OnMouseButtonUp:Remove(self, self.OnListItemReleased)
  M.Super.Destruct(self)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self:InitMainTab()
  self.Btn_Arward:Init()
  self:InitLevelList()
  self:PlayAnimation(self.In)
  self:SetFocus()
  self:InitScrollEffect()
end

function M:OnBeginBtnClicked()
  print("OnBeginBtnClicked")
  if not self.CurrentSelectedContent then
    print("警告：未选中任何关卡")
    return
  end
  print("开始游戏 - 关卡ID:", self.CurrentSelectedContent.Id, ", 标题:", self.CurrentSelectedContent.Title, ", 最高分:", self.CurrentSelectedContent.MaxScore)
  local Params = {
    Owner = self,
    Content = self.CurrentSelectedContent
  }
  UIManager(self):LoadUINew("BagGamePlay", Params)
end

function M:OnCenterLBtnClicked()
  self:ScrollToPreviousItem()
end

function M:OnCenterRBtnClicked()
  self:ScrollToNextItem()
end

function M:ScrollToPreviousItem()
  if self.bIsScrollingToTarget then
    return
  end
  local CurrentOffset = self.Wrap_Normal_L:GetScrollOffset()
  local TargetOffset = CurrentOffset - 1
  self:ScrollToOffset(TargetOffset)
end

function M:ScrollToNextItem()
  if self.bIsScrollingToTarget then
    return
  end
  local CurrentOffset = self.Wrap_Normal_L:GetScrollOffset()
  local TargetOffset = CurrentOffset + 1
  self:ScrollToOffset(TargetOffset)
end

function M:ScrollToOffset(TargetOffset)
  self.bIsScrollingToTarget = true
  local TotalItems = self.Wrap_Normal_L:GetNumItems()
  if TargetOffset < 0 then
    TargetOffset = 0
  elseif TotalItems <= TargetOffset then
    TargetOffset = TotalItems - 1
  end
  print("开始滚动，目标偏移:", TargetOffset)
  self.Wrap_Normal_L:SetScrollOffset(TargetOffset)
  self:AddTimer(0.05, function()
    self.bIsScrollingToTarget = false
    local DidReset = self:CheckAndResetScrollPosition()
    if not DidReset then
      self:UpdateSelectedItem()
    end
  end, false)
end

function M:InitMainTab()
  self.Tab:Init({
    Tabs = self.Tabs,
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    },
    OwnerPanel = self,
    BackCallback = self.CloseSelf,
    StyleName = "TextImage",
    TitleName = GText("Event_Title_103030")
  })
end

function M:UpdateInfoTips(Content)
  self.Text_Title01:SetText(GText(Content.Title))
  self.Text_Num:SetText(Content.Id)
  self.Text_Message01:SetText(GText(Content.Rule))
  self.Text_Score_Num:SetText(Content.MaxScore)
  for i, state in ipairs(Content.StarState) do
    if state then
      if 1 == state.IsFinish then
        self["ScoreItem0" .. i].WS_Type:SetActiveWidgetIndex(1)
        self["ScoreItem0" .. i].Text_ScoreInfo_Star:SetText("Text_ScoreInfo_Star")
      else
        self["ScoreItem0" .. i].WS_Type:SetActiveWidgetIndex(0)
        self["ScoreItem0" .. i].Text_ScoreInfo_Empty:SetText("Text_ScoreInfo_Empty")
      end
    end
  end
end

function M:InitLevelList()
  self.LevelList = {}
  local BackpackPuzzleLevel = {
    {
      Id = 1,
      Title = "Level1",
      Rule = "Level1_Rule",
      MaxScore = 1000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 1},
        {IsFinish = 1}
      },
      Reward = {
        1001,
        1002,
        1003
      },
      DisPlayItems = {
        {
          Id = 1,
          Title = "DisPlayItem1",
          Type = 1,
          IconPath = "Icon_1",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        },
        {
          Id = 2,
          Title = "DisPlayItem2",
          Type = 2,
          IconPath = "Icon_2",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        },
        {
          Id = 3,
          Title = "DisPlayItem3",
          Type = 3,
          IconPath = "Icon_3",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        },
        {
          Id = 4,
          Title = "DisPlayItem4",
          Type = 4,
          IconPath = "Icon_4",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        },
        {
          Id = 5,
          Title = "DisPlayItem5",
          Type = 5,
          IconPath = "Icon_5",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        },
        {
          Id = 6,
          Title = "DisPlayItem6",
          Type = 6,
          IconPath = "Icon_6",
          ShapeOffsets = {
            {-1, -1},
            {-1, 0},
            {-1, 1},
            {0, -1},
            {0, 0},
            {0, 1},
            {1, -1},
            {1, 0},
            {1, 1},
            {2, -1},
            {2, 0},
            {2, 1}
          }
        }
      },
      ContainItems = TemplateContainItems
    },
    {
      Id = 2,
      Title = "Level2",
      Rule = "Level2_Rule",
      MaxScore = 2000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1004,
        1005,
        1006
      }
    },
    {
      Id = 3,
      Title = "Level3",
      Rule = "Level3_Rule",
      MaxScore = 3000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1007,
        1008,
        1009
      }
    },
    {
      Id = 4,
      Title = "Level4",
      Rule = "Level4_Rule",
      MaxScore = 4000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1010,
        1011,
        1012
      }
    },
    {
      Id = 5,
      Title = "Level5",
      Rule = "Level5_Rule",
      MaxScore = 5000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1013,
        1014,
        1015
      }
    },
    {
      Id = 6,
      Title = "Level6",
      Rule = "Level6_Rule",
      MaxScore = 6000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1016,
        1017,
        1018
      }
    },
    {
      Id = 7,
      Title = "Level7",
      Rule = "Level7_Rule",
      MaxScore = 7000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1019,
        1020,
        1021
      }
    },
    {
      Id = 8,
      Title = "Level8",
      Rule = "Level8_Rule",
      MaxScore = 8000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1022,
        1023,
        1024
      }
    },
    {
      Id = 9,
      Title = "Level9",
      Rule = "Level9_Rule",
      MaxScore = 9000,
      StarState = {
        {IsFinish = 1},
        {IsFinish = 0},
        {IsFinish = 0}
      },
      Reward = {
        1025,
        1026,
        1027
      }
    }
  }
  self.OriginalDataList = BackpackPuzzleLevel
  self.OriginalDataCount = #BackpackPuzzleLevel
  self.Wrap_Normal_L:ClearListItems()
  local RepeatCount = 5
  local MiddleIndex = math.floor(RepeatCount / 2)
  for RepeatIndex = 0, RepeatCount - 1 do
    for DataIndex, Info in ipairs(BackpackPuzzleLevel) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Owner = self
      Content.Id = Info.Id
      Content.Title = Info.Title
      Content.Rule = Info.Rule
      Content.MaxScore = Info.MaxScore
      Content.StarState = Info.StarState
      Content.Reward = Info.Reward
      Content.DisPlayItems = Info.DisPlayItems
      Content.ContainItems = Info.ContainItems
      Content.Star = 3
      local VirtualIndex = RepeatIndex * self.OriginalDataCount + (DataIndex - 1)
      Content.Index = VirtualIndex
      Content.RealDataIndex = DataIndex - 1
      self.Wrap_Normal_L:AddItem(Content)
    end
  end
  self.Wrap_Normal_L:RequestFillEmptyContent()
  self.MiddleStartIndex = MiddleIndex * self.OriginalDataCount
end

local FIXED_SELECT_POSITION = 4

function M:InitScrollEffect()
  self:AddTimer(0.1, function()
    local InitialScrollOffset = self.MiddleStartIndex - FIXED_SELECT_POSITION
    if InitialScrollOffset < 0 then
      InitialScrollOffset = 0
    end
    print("初始化滚动位置:", InitialScrollOffset, ", 中间段起始:", self.MiddleStartIndex)
    self.Wrap_Normal_L:SetScrollOffset(InitialScrollOffset)
    self:AddTimer(0.05, function()
      self.CurrentRealDataIndex = nil
      self.CurrentSelectedIndex = nil
      self.LastSelectedEntry = nil
      self.LastSelectedIndex = nil
      self.LastSelectedContentId = nil
      self.Wrap_Normal_L:ForceLayoutPrepass()
      self:UpdateSelectedItem()
      if not self.CurrentSelectedContent then
        local ItemIndex = self:GetItemIndexAtSelectPosition()
        local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, ItemIndex)
        if CurWidget then
          if CurWidget.PlaySelected then
            CurWidget:PlaySelected()
          end
          self.LastSelectedEntry = CurWidget
          self.LastSelectedIndex = ItemIndex
          if CurWidget.Content then
            self.CurrentSelectedContent = CurWidget.Content
            self.CurrentRealDataIndex = ItemIndex % self.OriginalDataCount
            self.CurrentSelectedIndex = ItemIndex
            self.LastSelectedContentId = CurWidget.Content.Id
            print("初始化选中 Item - 虚拟索引:", ItemIndex, ", Content ID:", CurWidget.Content.Id)
            self:UpdateInfoTips(self.CurrentSelectedContent)
          end
        end
      end
    end)
  end)
end

function M:OnListItemReleased()
  local RealDataIndex = self:GetRealDataIndexAtSelectPosition()
  if nil ~= RealDataIndex then
    print("确认选中 Item (真实索引):", RealDataIndex)
    if self.CurrentSelectedContent then
      print("当前选中Content - ID:", self.CurrentSelectedContent.Id, ", 标题:", self.CurrentSelectedContent.Title)
    end
  end
end

function M:GetItemIndexAtSelectPosition()
  local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
  local ItemIndex = math.floor(ScrollOffset + FIXED_SELECT_POSITION + 0.5)
  local TotalItems = self.Wrap_Normal_L:GetNumItems()
  if ItemIndex < 0 then
    ItemIndex = 0
  elseif TotalItems <= ItemIndex then
    ItemIndex = TotalItems - 1
  end
  return ItemIndex
end

function M:GetRealDataIndexAtSelectPosition()
  local VirtualIndex = self:GetItemIndexAtSelectPosition()
  if nil == VirtualIndex then
    return nil
  end
  local RealDataIndex = VirtualIndex % self.OriginalDataCount
  return RealDataIndex
end

function M:GetCurrentSelectedContent()
  return self.CurrentSelectedContent
end

function M:HasSelectedContent()
  return self.CurrentSelectedContent ~= nil
end

function M:UpdateSelectedItem()
  if self.bIsScrollingToTarget or self.bIsResettingScroll then
    return
  end
  local NewSelectedIndex = self:GetItemIndexAtSelectPosition()
  if nil == NewSelectedIndex then
    return
  end
  local RealDataIndex = NewSelectedIndex % self.OriginalDataCount
  if self.CurrentRealDataIndex ~= RealDataIndex then
    local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.Wrap_Normal_L, NewSelectedIndex)
    if self.LastSelectedEntry and self.LastSelectedEntry.PlayUnselected and self.LastSelectedContentId and self.LastSelectedEntry.Content and self.LastSelectedEntry.Content.Id == self.LastSelectedContentId and self.LastSelectedEntry ~= CurWidget then
      self.LastSelectedEntry:PlayUnselected()
    end
    self.CurrentRealDataIndex = RealDataIndex
    self.CurrentSelectedIndex = NewSelectedIndex
    if CurWidget then
      if CurWidget.PlaySelected then
        CurWidget:PlaySelected()
      end
      self.LastSelectedEntry = CurWidget
      self.LastSelectedIndex = NewSelectedIndex
      if CurWidget.Content then
        self.CurrentSelectedContent = CurWidget.Content
        self.LastSelectedContentId = CurWidget.Content.Id
        print("选中 Item - 虚拟索引:", NewSelectedIndex, ", 真实索引:", RealDataIndex, ", Content ID:", CurWidget.Content.Id)
        self:UpdateInfoTips(self.CurrentSelectedContent)
      else
        self.CurrentSelectedContent = nil
        self.LastSelectedContentId = nil
        print("选中 Item - 虚拟索引:", NewSelectedIndex, ", 真实索引:", RealDataIndex)
      end
    else
      self.CurrentSelectedContent = nil
      self.LastSelectedContentId = nil
    end
  end
end

function M:CheckAndResetScrollPosition()
  if self.bIsResettingScroll then
    return
  end
  if self.bIsScrollingToTarget then
    return
  end
  if 0 == self.OriginalDataCount then
    return
  end
  local ScrollOffset = self.Wrap_Normal_L:GetScrollOffset()
  local GroupSize = self.OriginalDataCount
  local FirstGroupBoundary = GroupSize * 1
  local LastGroupBoundary = GroupSize * 3
  local NeedReset = false
  local NewScrollOffset = ScrollOffset
  if ScrollOffset < FirstGroupBoundary then
    NewScrollOffset = ScrollOffset + GroupSize * 2
    NeedReset = true
    print(string.format("循环列表：向前滚动到边界 [%.2f < %.2f]，跳转 %.2f -> %.2f", ScrollOffset, FirstGroupBoundary, ScrollOffset, NewScrollOffset))
  elseif ScrollOffset >= LastGroupBoundary then
    NewScrollOffset = ScrollOffset - GroupSize * 2
    NeedReset = true
    print(string.format("循环列表：向后滚动到边界 [%.2f >= %.2f]，跳转 %.2f -> %.2f", ScrollOffset, LastGroupBoundary, ScrollOffset, NewScrollOffset))
  end
  if NeedReset then
    self.bIsResettingScroll = true
    self.Wrap_Normal_L:SetScrollOffset(NewScrollOffset)
    self:AddTimer(0.01, function()
      self.bIsResettingScroll = false
      self:UpdateSelectedItem()
    end, false)
    return true
  end
  return false
end

function M:_OnListItemScrolled(ItemOffset, DistanceRemaining)
  self:CheckAndResetScrollPosition()
  self:UpdateSelectedItem()
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  EventManager:FireEvent(EventID.OnReturnToActivityEntry)
  self:PlayAnimation(self.Out)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    self:CloseSelf()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

return M

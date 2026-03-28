require("UnLua")
local SoloTreasureTaskProgressBoard = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")
SoloTreasureTaskProgressBoard.BoardStateTextMap = {
  [1] = "UI_SoloTreasure_NextProgress",
  [2] = "UI_SoloTreasure_HaveStoryToFinish",
  [3] = "UI_SoloTreasure_FinalProgress",
  [4] = "UI_SoloTreasure_ProgressFinished"
}

function SoloTreasureTaskProgressBoard:LoadDataToBoard(EventId, OldResult, NewResult)
  self.EventId = EventId
  self.OldResult = OldResult
  self.NewResult = NewResult
end

function SoloTreasureTaskProgressBoard:RefreshProgressBoard(Result)
  if not Result then
    return
  end
  if self.Text_TaskProgress then
    self.Text_TaskProgress:SetText(GText("UI_SoloTreasure_EventProgress"))
  end
  if self.Text_Contest and Result.CurRow then
    self.Text_Contest:SetText(GText(Result.CurRow.EventProgressText))
  end
  if self.Num_Now then
    self.Num_Now:SetText(tostring(Result.CurStageIndex or 1))
  end
  if self.Num_Total then
    self.Num_Total:SetText(tostring(Result.TotalStageCount or 0))
  end
  local ResourceId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  local CoinIconPath = DataMgr.Resource[ResourceId].Icon
  local CoinObj = LoadObject(CoinIconPath)
  if CoinObj then
    self.Icon_Coin:SetBrushFromTexture(CoinObj)
  end
  local IDX_SCORE = 0
  local IDX_TEXT = 1
  if self.WS_Type then
    if 1 == Result.BoardState then
      self.WS_Type:SetActiveWidgetIndex(IDX_SCORE)
    else
      self.WS_Type:SetActiveWidgetIndex(IDX_TEXT)
    end
  end
  local TextKey = self.BoardStateTextMap and self.BoardStateTextMap[Result.BoardState] or nil
  if 1 == Result.BoardState then
    if self.Num_Coin_Now then
      self.Num_Coin_Now:SetText(tostring(Result.CurScore or 0))
    end
    if self.Num_Coin_Total then
      self.Num_Coin_Total:SetText(tostring(Result.NextNeedScore or 0))
    end
    if self.Text_Hint and TextKey then
      self.Text_Hint:SetText(GText(TextKey))
    end
  elseif self.Text_Desc and TextKey then
    self.Text_Desc:SetText(GText(TextKey))
  end
end

function SoloTreasureTaskProgressBoard:PlayScoreAnim()
  if not self.Score_Add then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_score_add", nil, nil)
  self:PlayAnimation(self.Score_Add)
end

function SoloTreasureTaskProgressBoard:PlayStageAnim()
  if not self.Text_Refresh then
    return
  end
  self:PlayAnimation(self.Text_Refresh)
end

function SoloTreasureTaskProgressBoard:SequenceEvent_0()
  if not self.NewResult then
    return
  end
  if self.Num_Coin_Now then
    self.Num_Coin_Now:SetText(tostring(self.NewResult.CurScore or 0))
  end
  if self.Num_Coin_Total then
    self.Num_Coin_Total:SetText(tostring(self.NewResult.NextNeedScore or 0))
  end
  if self.bPendingPlayStage then
    return
  end
  SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.NewResult)
end

function SoloTreasureTaskProgressBoard:SequenceEvent_1()
  if not self.NewResult then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_stage_update", nil, nil)
  if self.Text_Contest and self.NewResult.CurRow then
    self.Text_Contest:SetText(GText(self.NewResult.CurRow.EventProgressText))
  end
  if self.Num_Now then
    self.Num_Now:SetText(tostring(self.NewResult.CurStageIndex or 1))
  end
  SoloTreasureDataModel:CommitBoardSnapshotByResult(self.EventId, self.NewResult)
end

function SoloTreasureTaskProgressBoard:OnAnimationFinished(Animation)
  if Animation == self.Score_Add then
    local IDX_SCORE = 0
    local IDX_TEXT = 1
    if self.WS_Type then
      if 1 == self.NewResult.BoardState then
        self.WS_Type:SetActiveWidgetIndex(IDX_SCORE)
        DebugPrint("----------------显示积分面板！")
      else
        self.WS_Type:SetActiveWidgetIndex(IDX_TEXT)
        local TextKey = self.BoardStateTextMap and self.BoardStateTextMap[self.NewResult.BoardState]
        if self.Text_Desc and TextKey then
          self.Text_Desc:SetText(GText(TextKey))
        end
        DebugPrint("----------------显示文字面板！")
      end
    end
    if self.bPendingPlayStage then
      self.bPendingPlayStage = false
      if self.PlayStageAnim then
        self:PlayStageAnim()
      end
    end
  end
end

return SoloTreasureTaskProgressBoard

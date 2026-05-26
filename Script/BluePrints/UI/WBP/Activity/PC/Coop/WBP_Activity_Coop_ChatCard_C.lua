require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatModel = ChatController:GetModel()
local CoopModel = require("BluePrints.UI.WBP.Activity.PC.Coop.Model.CoopModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Initialize()
end

function M:Construct()
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
end

function M:InitCoopChatCard(AsyncCombatRoomInfo, bSelfMsg)
  if not AsyncCombatRoomInfo or type(AsyncCombatRoomInfo) == "userdata" then
    return
  end
  self.RoomConfId = AsyncCombatRoomInfo.RoomConfId
  if self.RoomConfId then
    self.Level = DataMgr.AsyncCombat[self.RoomConfId].Level
    self.Text_Avatar:SetText(string.format(GText("UI_AsyncCombat_StageName"), self.Level))
    self.ResourceId = DataMgr.AsyncCombat[self.RoomConfId].ID
    if self.ResourceId then
      local ResourceData = DataMgr.Resource[self.ResourceId]
      if ResourceData.Icon then
        UResourceLibrary.LoadObjectAsync(self, ResourceData.Icon, {
          self,
          function(_, Icon)
            self.Img_Avatar:SetBrushResourceObject(Icon)
          end
        })
      end
    end
  end
  self.RoomUniqueId = AsyncCombatRoomInfo.RoomUniqueId
  self.RateResId = AsyncCombatRoomInfo.RateResId
  if self.RateResId then
    local RateRes = DataMgr.Resource[self.RateResId]
    local Percent = RateRes.UseParam and RateRes.UseParam / 100 or 100
    self.Text_Plan:SetText(GText("UI_AsyncCombat_RateBonus_Chat"))
    self.Tag_Reward.TextNum:SetText("+" .. string.format("%d", Percent) .. "%")
  end
end

function M:OnClicked()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState:IsInDungeon() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  
  local function JumpToDetailPage(ErrCode, RoomData)
    if ErrCode == ErrorCode.RET_SUCCESS then
      local RoomCapacityLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomCapacityLimit.ConstantValue
      local bReachedMaximum = RoomCapacityLimit == RoomData.MemberCount
      if bReachedMaximum then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_AsyncCombat_RoomFull")
        return
      else
        local AsyncCombat = UIManager(self):GetUIObj("AsyncCombat")
        if not AsyncCombat then
          AsyncCombat = UIManager(self):LoadUINew("AsyncCombat")
          local Detail = UIManager(self):LoadUINew("CoopDetails", RoomData, true)
          if Detail then
            Detail:InitPageTab()
            Detail:Init(RoomData)
          end
        else
          local Detail = UIManager(self):LoadUINew("CoopDetails", RoomData, true)
          if Detail then
            Detail:InitPageTab()
            Detail:Init(RoomData)
          end
        end
      end
      local ChatMain = ChatController:GetView()
      if ChatMain then
        ChatMain:Close()
      end
    elseif ErrCode == ErrorCode.RET_ASYNCCOMBAT_NOT_OPEN then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_GameEvent_EventEnd")
    end
  end
  
  CoopModel:AsyncGetMemberRoomInfo(JumpToDetailPage, self.RoomUniqueId)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
end

AssembleComponents(M)
return M

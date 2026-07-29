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
  self.bInitialized = false
end

function M:Construct()
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnClicked:Add(self, self.OnClicked)
end

function M:InitCoopChatCard(AsyncCombatRoomInfo, bSelfMsg)
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: AsyncCombatRoomInfo: " .. tostring(AsyncCombatRoomInfo))
  if not AsyncCombatRoomInfo or type(AsyncCombatRoomInfo) == "userdata" then
    return
  end
  self.RoomConfId = AsyncCombatRoomInfo.RoomConfId
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: self.RoomConfId: " .. tostring(self.RoomConfId))
  if not self.RoomConfId then
    return
  end
  local AsyncCombatData = DataMgr.AsyncCombat[self.RoomConfId]
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: AsyncCombatData: " .. tostring(AsyncCombatData))
  if not AsyncCombatData then
    return
  end
  self.Level = AsyncCombatData.Level
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: self.Level: " .. tostring(self.Level))
  if not self.Level then
    return
  end
  self.ResourceId = AsyncCombatData.ID
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: self.ResourceId: " .. tostring(self.ResourceId))
  if not self.ResourceId then
    return
  end
  local ResourceData = DataMgr.Resource[self.ResourceId]
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: ResourceData: " .. tostring(ResourceData))
  if not ResourceData then
    return
  end
  local ResourceDataIcon = ResourceData.Icon
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: ResourceDataIcon: " .. tostring(ResourceDataIcon))
  if not ResourceDataIcon then
    return
  end
  self.RoomUniqueId = AsyncCombatRoomInfo.RoomUniqueId
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: self.RoomUniqueId: " .. tostring(self.RoomUniqueId))
  if not self.RoomUniqueId then
    return
  end
  self.RateResId = AsyncCombatRoomInfo.RateResId
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: self.RateResId: " .. tostring(self.RateResId))
  if not self.RateResId then
    return
  end
  local RateRes = DataMgr.Resource[self.RateResId]
  DebugPrint("WBP_Activity_Coop_ChatCard_C:InitCoopChatCard: RateRes: " .. tostring(RateRes))
  if not RateRes then
    return
  end
  local Percent = RateRes.UseParam and RateRes.UseParam / 100 or 100
  self.Text_Avatar:SetText(string.format(GText("UI_AsyncCombat_StageName"), self.Level))
  UResourceLibrary.LoadObjectAsync(self, ResourceDataIcon, {
    self,
    function(_, Icon)
      self.Img_Avatar:SetBrushResourceObject(Icon)
    end
  })
  self.Text_Plan:SetText(GText("UI_AsyncCombat_RateBonus_Chat"))
  self.Tag_Reward.TextNum:SetText("+" .. string.format("%d", Percent) .. "%")
  self.bInitialized = true
end

function M:OnClicked()
  if not self.bInitialized then
    DebugPrint("WBP_Activity_Coop_ChatCard_C:OnClicked 卡片未初始化")
    return
  end
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

require("UnLua")
local ImpressionItemUIPath = "/Game/UI/WBP/Impression/Mobile/WBP_Impression_Item_M.WBP_Impression_Item_M"
local WBP_SimpleTalk_Mobile = Class("BluePrints.Story.Talk.UI.Common.WBP_SimpleTalk_Portrait_Base")

function WBP_SimpleTalk_Mobile:GetImpressionItemUIPath()
  return ImpressionItemUIPath
end

function WBP_SimpleTalk_Mobile:InitPlayKey()
  self.bAutoPlay = GWorld.GameInstance.bGlobalAutoPlay
  self.Story_PlayBtn:InitPlayKey()
end

function WBP_SimpleTalk_Mobile:ChangeAutoPlay()
  self.Story_PlayBtn.bAutoPlay = not self.Story_PlayBtn.bAutoPlay
  self:SwitchAutoPlay()
end

function WBP_SimpleTalk_Mobile:ChangeAutoPlayUI()
  self.Story_PlayBtn:ChangeAutoPlayUI()
end

function WBP_SimpleTalk_Mobile:AdaptPlatform()
  self.OptionComp:Event_AdaptPlatform(true)
  self.DimensionComp:Event_AdaptPlatform(true)
end

function WBP_SimpleTalk_Mobile:InitAutoPlay()
  self:ChangeAutoPlayUI()
end

return WBP_SimpleTalk_Mobile

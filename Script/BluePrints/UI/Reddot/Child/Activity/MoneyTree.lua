local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local ReddotTreeNode_MoneyTree = Class("BluePrints.UI.Reddot.Child.Activity.ActivityBase")

function ReddotTreeNode_MoneyTree:_Judge(EventId)
  return MoneyTreeMgr.ShouldShowEntryReddot() == true
end

return ReddotTreeNode_MoneyTree

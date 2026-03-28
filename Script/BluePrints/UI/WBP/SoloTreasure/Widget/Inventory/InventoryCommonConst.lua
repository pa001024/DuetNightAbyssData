local InventoryCommonConst = {
  PocketType = {
    Default = 0,
    Bag = 1,
    Mechanism = 2,
    Recycle = 3
  },
  AdsorptionPriority = {
    LOW = 1,
    HIGH = 2,
    FORCE = 3
  },
  DefaultDragWidgetPath = "/Game/UI/WBP/SoloTreasure/Widget/WBP_Treasure_Item_Drag.WBP_Treasure_Item_Drag",
  Direction = {Horizontal = 0, Vertical = 1},
  MaxTreasureLoadCountInSingleFrame = 1,
  DragDetectedThreshold = 10,
  GamepadAnalogDeadzone = 0.5,
  AdsorptionCancelThreshold = 15,
  IdleTimeToTryAdsorption = 0.1,
  RecycleListEmptyNum = 8,
  RecyclePocketNamePrefix = "Recycle",
  SearchPocketNamePrefix = "WBP_Search_Bag",
  RecycleBtnState = {
    Normal = 1,
    DragingOver = 2,
    Draging = 3
  },
  QuickTransferType = {RightClick = 1, AltAndRightClick = 2}
}
return InventoryCommonConst

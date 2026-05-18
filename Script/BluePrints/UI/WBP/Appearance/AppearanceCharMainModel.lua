local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local M = {}

function M:Destroy()
  self.View.CharContents:Clear()
end

function M:OnCharContentCreated(Obj)
  if self.Params.OnCharContentCreated then
    self.Params.OnCharContentCreated(self.View, Obj)
  end
end

function M:GetCharContentByUuid(Uuid)
  return self.CharItemContentsMap[Uuid]
end

function M:GetCharContentByCharId(CharId)
  return self.CharId2Content[CharId]
end

function M:GetUnownedCharContentByCharId(CharId)
  return self.UnownedCharContentMap[CharId]
end

function M:SetSelectedCharContent(Content)
  local OldSelectedContent = self:GetSelectedCharContent()
  if OldSelectedContent then
    ArmoryUtils:SetItemIsSelected(OldSelectedContent, false)
  end
  self.SelectedCharContent = Content
  ArmoryUtils:SetItemIsSelected(Content, true)
end

function M:GetSelectedCharContent()
  return self.SelectedCharContent
end

function M:GetSelectedChar()
  local SelectedCharContent = self.SelectedCharContent
  if not SelectedCharContent then
    return nil
  end
  if SelectedCharContent.IsOwned then
    local Avatar = ArmoryUtils:GetAvatar()
    return Avatar and Avatar.Chars and Avatar.Chars[SelectedCharContent.Uuid] or nil
  end
  return SelectedCharContent.Target
end

function M:IsSelectedCharOwned()
  local SelectedCharContent = self:GetSelectedCharContent()
  return SelectedCharContent and SelectedCharContent.IsOwned or false
end

function M:GetSelectedCharAppearanceIndex()
  local SelectedChar = self:GetSelectedChar()
  return SelectedChar and SelectedChar.CurrentAppearanceIndex or 1
end

function M:GetAllCharContent()
  return self.CharItemContentsArray
end

local function AddContent(self, Char)
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
  Obj.IsOwned = true
  self.View.CharContents:Add(Obj)
  self.CharItemContentsMap[Char.Uuid] = Obj
  self.CharId2Content[Char.CharId] = Obj
  local Avatar = ArmoryUtils:GetAvatar()
  local GroupData = DataMgr.CharacterAttributeSwitch[Char.CharId]
  if GroupData then
    local GroupCurrentCharId = AvatarUtils:GetCurrentCharIdByGroupId(Avatar, GroupData.CharGroupId)
    if GroupCurrentCharId == Char.CharId then
      table.insert(self.CharItemContentsArray, Obj)
    end
  else
    table.insert(self.CharItemContentsArray, Obj)
  end
  self:OnCharContentCreated(Obj)
  return Obj
end

local function AddUnownedContent(self, Char)
  local CharId = Char.CharId
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true)
  Obj.bHideItemLevel = true
  Obj.IsOwned = false
  Obj.LockType = 2
  Obj.Level = nil
  self.View.CharContents:Add(Obj)
  self.CharItemContentsMap[Char.Uuid] = Obj
  self.UnownedCharContentMap[CharId] = Obj
  if not DataMgr.CharacterAttributeSwitch[CharId] then
    table.insert(self.CharItemContentsArray, Obj)
  end
  self:OnCharContentCreated(Obj)
  return Obj
end

local function UnownedContent2Content(self, UnownedContent, Char)
  self.CharItemContentsMap[UnownedContent.Uuid] = nil
  if self.UnownedCharContentMap[UnownedContent.UnitId] then
    self.UnownedCharContentMap[UnownedContent.UnitId] = nil
  end
  local Obj = ArmoryUtils:NewCharOrWeaponItemContent(Char, CommonConst.ArmoryType.Char, CommonConst.ArmoryTag.Char, true, self.ReddotFrom)
  UnownedContent.Uuid = Obj.Uuid
  self.CharItemContentsMap[UnownedContent.Uuid] = UnownedContent
  self.CharId2Content[UnownedContent.UnitId] = UnownedContent
  UnownedContent.IsOwned = true
  UnownedContent.LockType = Obj.LockType
  UnownedContent.Level = Obj.Level
  UnownedContent.IsNew = Obj.IsNew
  UnownedContent.Upgradeable = Obj.Upgradeable
  UnownedContent.RedDotType = Obj.RedDotType
  UnownedContent.Target = nil
end

function M:CreateCharContents(Params)
  local Avatar = ArmoryUtils:GetAvatar()
  rawset(self, "CharItemContentsMap", {})
  rawset(self, "CharItemContentsArray", {})
  rawset(self, "UnownedCharContentMap", {})
  rawset(self, "CharId2Content", {})
  local OwnedChars = {}
  local RealAvatar = GWorld:GetAvatar()
  if RealAvatar then
    for _, value in pairs(RealAvatar.Chars) do
      OwnedChars[value.CharId] = value
    end
  end
  
  local function InsertLogic(Char)
    if OwnedChars[Char.CharId] or Params.IsPreviewMode then
      return AddContent(self, Char)
    else
      return AddUnownedContent(self, Char)
    end
  end
  
  local Chars = Avatar.Chars
  if Params.CharUuids then
    Chars = {}
    for _, Uuid in ipairs(Params.CharUuids) do
      if Avatar.Chars[Uuid] then
        table.insert(Chars, Avatar.Chars[Uuid])
      end
    end
  end
  if Params.DoNotSort and Params.IsPreviewMode then
    local CharArray = {}
    if Params.InitialOrderCharUuids then
      for index, value in ipairs(Params.InitialOrderCharUuids) do
        table.insert(CharArray, Chars[value])
      end
    else
      CharArray = Chars
    end
    for _, Char in ipairs(CharArray) do
      InsertLogic(Char)
    end
  else
    for Uuid, Char in pairs(Chars) do
      InsertLogic(Char)
    end
    if Params.IsPreviewMode or Params.CharUuids then
      return
    end
    try({
      exec = function()
        ArmoryUtils:DontResetUuid(true)
        local Gender2RoleIds = Const.DefaultAttributeMaster
        local ExcludeCharId = Gender2RoleIds[1 - RealAvatar.Sex]
        for CharId, value in pairs(DataMgr.Char) do
          if not value.IsNotOpen and ExcludeCharId ~= CharId and not OwnedChars[CharId] and CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.Char, CharId) then
            local DummyAvatar = ArmoryUtils:CreateNewDummyAvatar(ArmoryUtils.PreviewTargetStates.Prime, {
              CharIds = {CharId}
            })
            local _, Char = next(DummyAvatar.Chars)
            local Content = InsertLogic(Char)
            Content.Target = Char
            Content.AvatarPrime = DummyAvatar
          end
        end
        ArmoryUtils:DontResetUuid(false)
      end,
      catch = function(err)
        local trace = debug.traceback()
        err = err or ""
        DebugPrint("Error: CY@ 未解锁角色信息创建失败!\n" .. err .. "\n" .. trace)
      end
    })
  end
end

function M:SortCharContents(Params)
  local AttrNames = {
    "Level",
    "SortPriority",
    "UnitId"
  }
  ArmoryUtils:SortItemContents(self.CharItemContentsArray, AttrNames, CommonConst.DESC, self.SelectedCharContent, function(a, b)
    if a.IsOwned or b.IsOwned then
      return ArmoryUtils.IsOwnedCmpFunc(a, b)
    end
    if a.Unlockable ~= b.Unlockable then
      if a.Unlockable then
        return true
      else
        return false
      end
    end
  end)
end

return M

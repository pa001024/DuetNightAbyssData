local FTypingTextBlock = require("Blueprints.Story.Talk.Typing.TypingTextBlock")
local MiscUtils = require("Utils.MiscUtils")
local M = {}

function M:New(Page)
  local TypingLine = {}
  for k, v in pairs(self) do
    TypingLine[k] = v
  end
  TypingLine.Page = Page
  TypingLine.Size = UE4.FVector2D(0, 0)
  TypingLine.TextSize = UE4.FVector2D(0, 0)
  TypingLine.SuperscriptSize = UE4.FVector2D(0, 0)
  TypingLine.Blocks = {}
  TypingLine.SuperscriptBlocks = {}
  return TypingLine
end

function M:GetMaxSize()
  return self.Page:GetMaxSize()
end

function M:GetRemainSize()
  return FVector2D(self:GetMaxSize().X - self.Size.X, self.Page:GetRemainHeight())
end

function M:GetSize()
  return self.Size
end

function M:GetTextSize()
  return self.TextSize
end

function M:GetSuperscriptSize()
  return self.SuperscriptSize
end

function M:GetSuperscriptCount()
  return #self.SuperscriptBlocks
end

function M:GetSuperscript(Num)
  return self.SuperscriptBlocks[Num]
end

function M:CanInsertBlock(Block)
  local RemainSize = self:GetRemainSize()
  local SBlock = Block:GetAttr("superscript_block")
  local MaxTY = math.max(self.TextSize.Y, Block:GetSize().Y)
  local MaxSY = self.SuperscriptSize.Y
  if SBlock then
    local SSize = SBlock:GetSize()
    MaxSY = math.max(self.SuperscriptSize.Y, SSize.Y)
  end
  return RemainSize.Y > MaxTY + MaxSY
end

function M:AddBlock(Block, TypingUserWidget)
  if not self:CanInsertBlock(Block) then
    return Block
  end
  local LBlock, RBlock
  local RemainSize = self:GetRemainSize()
  local BlockSize = Block:GetSize()
  if RemainSize.X >= BlockSize.X then
    LBlock = Block
  else
    if Block:GetAttr("superscript_block") then
      return Block
    end
    RBlock = Block
    local BlockType = Block:GetType()
    if "img" == BlockType then
    elseif "text" == BlockType then
      if 0 == #Block.Text or BlockSize.X <= 0 then
        print(_G.LogTag, "Block 内容为空或大小为0，被丢弃。", "Block 大小：", BlockSize, "Block 内容：", Block:GetRichText())
        return
      end
      local LText, RText = self:SplitText(Block, RemainSize, TypingUserWidget)
      LText = string.sub(LText, 1, #LText - 1)
      LBlock = FTypingTextBlock:New(LText, Block.RichTag, Block.Attrs)
      local LTextSize = TypingUserWidget.CalcRichTextBlockSize(LBlock:GetRichText())
      LBlock:SetSize(LTextSize)
      if RText and RText ~= Block.Text then
        RBlock = FTypingTextBlock:New(RText, Block.RichTag, Block.Attrs)
        local RTextSize = TypingUserWidget.CalcRichTextBlockSize(RBlock:GetRichText())
        RBlock:SetSize(RTextSize)
      elseif LText and LText == Block.Text then
        RBlock = nil
      end
    end
  end
  if LBlock then
    local LSize = LBlock:GetSize()
    self.TextSize.X = self.TextSize.X + LSize.X
    self.TextSize.Y = math.max(self.TextSize.Y, LSize.Y)
    table.insert(self.Blocks, LBlock)
    local SuperscriptBlock = Block:GetAttr("superscript_block")
    LBlock:SetAttr("superscript_block", nil)
    if SuperscriptBlock then
      local SSize = SuperscriptBlock:GetSize()
      self.SuperscriptSize.Y = math.max(self.SuperscriptSize.Y, SSize.Y)
      SuperscriptBlock.RelativePosX = self.TextSize.X - LSize.X / 2 - SSize.X / 2
      table.insert(self.SuperscriptBlocks, SuperscriptBlock)
    end
    self.Size.X = self.TextSize.X
    self.Size.Y = self.TextSize.Y + self.SuperscriptSize.Y
  end
  return RBlock
end

function M:SplitText(Block, RemainSize, TypingUserWidget)
  local Words = Utils.Split(Block.Text, " ")
  local RemainWidth = RemainSize.X
  local LText = ""
  local RText
  local SpaceWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. "> </>").X
  for _, Word in ipairs(Words) do
    local WordWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. ">" .. Word .. "</>").X
    if RemainWidth >= WordWidth then
      RemainWidth = RemainWidth - WordWidth - SpaceWidth
      LText = LText .. Word .. " "
    else
      if not MiscUtils.IsSingleByteWord(Word) and (CommonConst.SystemLanguage == CommonConst.SystemLanguages.CN or CommonConst.SystemLanguage == CommonConst.SystemLanguages.JP or CommonConst.SystemLanguage == CommonConst.SystemLanguages.TC) then
        do
          local WordLen = UE4.UKismetStringLibrary.Len(Word)
          local Left = 0
          local Mid = 0
          local Right = WordLen
          local LWord = ""
          while Left < Right do
            local t = math.floor((Right - Left) / 2) + Left
            if t == Mid then
              break
            end
            Mid = t
            LWord = UE4.UKismetStringLibrary.GetSubstring(Word, 0, Mid)
            local LWordWidth = TypingUserWidget.CalcRichTextBlockSize("<" .. Block.RichTag .. ">" .. LWord .. "</>").X
            if RemainWidth > LWordWidth then
              Left = Mid
            else
              Right = Mid
            end
          end
          LText = LText .. LWord
          RText = string.sub(Block.Text, #LText + 1, #Block.Text)
          LText, RText = self:AssignPunctuation(LText, RText)
          LText = LText .. " "
          if "" == RText then
            RText = nil
          end
        end
        break
      end
      RText = string.sub(Block.Text, #LText + 1, #Block.Text)
      break
    end
  end
  return LText, RText
end

function M:AssignPunctuation(LText, RText)
  local RLen = UE4.UKismetStringLibrary.Len(RText)
  if RLen <= 0 then
    return LText, RText
  end
  local LLen = UE4.UKismetStringLibrary.Len(LText)
  local LLastChar = UE4.UKismetStringLibrary.GetSubstring(LText, LLen - 1, 1)
  if string.find("([{〈《「『【〔〖（“‘", LLastChar, 1, true) then
    LText = UE4.UKismetStringLibrary.GetSubstring(LText, 0, LLen - 1)
    RText = LLastChar .. RText
    return LText, RText
  end
  local RFirtChar = UE4.UKismetStringLibrary.GetSubstring(RText, 0, 1)
  local NoBreakLinePunctuations = ",.?;~!%，、。；：？！·)]}〉》」』】〕〗）”’"
  local EllipsisAndDash = "—…"
  if string.find(EllipsisAndDash, RFirtChar, 1, true) then
    for i = LLen - 1, 1, -1 do
      local LChar = UE4.UKismetStringLibrary.GetSubstring(LText, i, 1)
      if not string.find(EllipsisAndDash, LChar, 1, true) and not string.find(NoBreakLinePunctuations, LChar, 1, true) then
        RText = UE4.UKismetStringLibrary.GetSubstring(LText, i, LLen) .. RText
        LText = UE4.UKismetStringLibrary.GetSubstring(LText, 0, i)
        break
      end
    end
  else
    local RPunctuations = ""
    local RChar = RFirtChar
    local RPunctuationsEnd = 0
    repeat
      if not ("" ~= RChar and string.find(NoBreakLinePunctuations, RChar, 1, true)) then
        break
      end
      RPunctuationsEnd = RPunctuationsEnd + 1
      RPunctuations = RPunctuations .. RChar
      if not (RPunctuationsEnd > 2) then
        RChar = UE4.UKismetStringLibrary.GetSubstring(RText, RPunctuationsEnd, 1)
      else
        break
      end
    until RLen < RPunctuationsEnd
    if RPunctuationsEnd > 2 then
      local LLen = UE4.UKismetStringLibrary.Len(LText)
      for i = LLen, 1, -1 do
        local LChar = UE4.UKismetStringLibrary.GetSubstring(LText, i, 1)
        if not string.find(NoBreakLinePunctuations, LChar, 1, true) then
          RText = UE4.UKismetStringLibrary.GetSubstring(LText, i, LLen) .. RText
          LText = UE4.UKismetStringLibrary.GetSubstring(LText, 0, i)
          return LText, RText
        end
      end
    end
    LText = LText .. RPunctuations
    RText = UE4.UKismetStringLibrary.GetSubstring(RText, RPunctuationsEnd, RLen)
  end
  return LText, RText
end

function M:GetRichText()
  local Text = ""
  for _, Block in ipairs(self.Blocks) do
    Text = Text .. Block:GetRichText()
  end
  return Text
end

return M

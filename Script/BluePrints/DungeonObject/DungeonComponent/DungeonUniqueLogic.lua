local DungeonUniqueLogic = DungeonClass.Class()
DungeonUniqueLogic.__Component__ = {}

function DungeonUniqueLogic:BeginPlay()
  self.chars = "0123456789abcdefghijklmnopqrstuvwxyz"
  math.randomseed(os.time())
end

function DungeonUniqueLogic:GenUniqueId()
  local timestamp = os.time()
  local random_perturb = math.random(0, 1295)
  local mixed = timestamp * 1000 + random_perturb
  local time_part = ""
  for i = 1, 4 do
    local remainder = mixed % 36 + 1
    time_part = self.chars:sub(remainder, remainder) .. time_part
    mixed = math.floor(mixed / 36)
  end
  local random_part = ""
  for i = 1, 6 do
    local random_index = math.random(1, #self.chars)
    random_part = random_part .. self.chars:sub(random_index, random_index)
  end
  return time_part .. random_part
end

DungeonClass.AssembleComponents(DungeonUniqueLogic)
return DungeonUniqueLogic

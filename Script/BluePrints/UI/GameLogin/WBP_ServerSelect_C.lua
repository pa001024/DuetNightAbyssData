require("UnLua")
require("DataMgr")
local DevServerList = require("BluePrints/UI/GameLogin/DevServerList")
local WBP_ServerSelect_C = Class("BluePrints.UI.BP_UIState_C")
local AllServers
local AllDynamicPrivateServers = {}
local ServerList, CurrentServerList, CurrentSelectObj

function WBP_ServerSelect_C:Construct()
  self.Super.Construct(self)
end

function WBP_ServerSelect_C:CloseUI()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  self:Show(UIConst.VisibilityOp.Collapsed)
  self:Close()
end

function WBP_ServerSelect_C:Show(VisibilityOp)
  self:SetVisibility(VisibilityOp)
  if VisibilityOp == UIConst.VisibilityOp.Visible then
    self:PlayAnim("HideOrShow_Panel_Server")
    if nil == ServerList then
      self:RefreshSeverList()
    else
      self:RefreshDynamicPrivateServerList(function()
        if not IsValid(CurrentSelectObj) then
          self:VerifyListViewCallBack()
        else
          self.ListView_Area:BP_SetSelectedItem(CurrentSelectObj)
        end
      end)
    end
  end
end

function WBP_ServerSelect_C:RefreshSeverList()
  self.CircularThrobber_1:SetVisibility(UIConst.VisibilityOp.Visible)
  self:TryToGetServerList()
end

function WBP_ServerSelect_C:TryToGetServerList()
  AllServers = {}
  for k, v in pairs(DevServerList) do
    if k < 1000 or k >= 7000 and k <= 7100 or k >= 8000 and k <= 8100 then
      AllServers[k] = v
    end
  end
  self:RefreshDynamicPrivateServerList(function()
    self:VerifyListViewCallBack()
  end)
end

function WBP_ServerSelect_C:RefreshDynamicPrivateServerList(Callback)
  UE.URuntimeCommonFunctionLibrary.HttpGet("http://10.18.200.237:2379/v2/keys/ps/?recursive=true", {
    GWorld.GameInstance,
    function(_, Content)
      local Json = require("rapidjson")
      
      local function ParseServer()
        local InServers = Json.decode(Content).node.nodes
        for i = 1, #InServers do
          local value = InServers[i].value
          local value_t = Json.decode(value)
          AllDynamicPrivateServers[i] = {
            hostnum = 399,
            ip = value_t.Ip,
            name = value_t.Name,
            port = 18000
          }
        end
      end
      
      local ok, error = pcall(ParseServer)
      if not ok then
        DebugPrint(ErrorTag, error)
      end
      if Callback then
        Callback()
      end
    end
  })
end

function WBP_ServerSelect_C:VerifyListViewCallBack()
  if AllServers then
    self.ListView_Area:ClearListItems()
    local obj = self:NewAreaItemContent(nil)
    obj.Area = "Recommend"
    obj.Name = "推荐"
    self.ListView_Area:AddItem(obj)
    CurrentSelectObj = obj
    ServerList = {}
    for k, v in pairs(AllServers) do
      if ServerList[v.area] == nil then
        ServerList[v.area] = {
          area = v.area,
          name = v.area,
          servers = nil
        }
      end
      if nil == ServerList[v.area].servers then
        ServerList[v.area].servers = {}
      end
      ServerList[v.area].servers[k] = v
    end
    for k, v in pairs(ServerList) do
      if v.servers then
        local AreaContent = {
          area = v.area,
          name = v.name
        }
        self.ListView_Area:AddItem(self:NewAreaItemContent(AreaContent))
      end
    end
    self.ListView_Area:AddItem(self:NewAreaItemContent({area = "Private", name = "私服"}))
    self.ListView_Area:BP_SetSelectedItem(obj)
    self:RemoveTimer("VerifyListView")
    self.CircularThrobber_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    print(_G.LogTag, "Failed to get server list, error code:")
  end
end

function WBP_ServerSelect_C:NewAreaItemContent(content)
  if nil == content then
    return NewObject(self.AreaItemContentClass, self.ListView_Area)
  end
  local obj = NewObject(self.AreaItemContentClass, self.ListView_Area)
  obj.Area = content.area
  obj.Name = content.name
  obj.IsSelected = false
  return obj
end

function WBP_ServerSelect_C:NewServerItemContent(content)
  if nil == content then
    return NewObject(self.ServerItemContentClass, self.List)
  end
  local obj = NewObject(self.ServerItemContentClass, self.List)
  obj.HostId = content.hostnum
  obj.Area = content.area
  obj.Name = content.name
  obj.IP = content.ip
  obj.Port = content.port
  obj.IsSelected = false
  return obj
end

function WBP_ServerSelect_C:SwitchArea(area)
  if not GWorld.IsDev then
    return
  end
  if CurrentSelectObj and area ~= CurrentSelectObj.Area then
    UIUtils.PlayCommonBtnSe(self)
  end
  if nil ~= ServerList then
    self.SelectedArea = self.ListView_Area:BP_GetSelectedItem()
    CurrentSelectObj = self.SelectedArea
    print(_G.LogTag, "SwitchArea:", self.SelectedArea.Name)
    self.List:ClearListItems()
    CurrentServerList = {}
    if "Recommend" == area then
      for k, v in pairs(AllServers) do
        table.insert(CurrentServerList, v)
      end
    elseif "Private" == area then
      for k, v in pairs(AllDynamicPrivateServers) do
        table.insert(CurrentServerList, v)
      end
    else
      for k, v in pairs(ServerList) do
        if v.area == area and v.servers then
          for k, v in pairs(v.servers) do
            if v.area and v.area == area then
              table.insert(CurrentServerList, v)
            end
          end
          break
        end
      end
    end
    table.sort(CurrentServerList, function(a, b)
      if a.hostnum == b.hostnum then
        return a.name < b.name
      end
      return a.hostnum < b.hostnum
    end)
    self:SearchServer(self.Input_Search_Server:GetText())
  end
end

function WBP_ServerSelect_C:SearchServer(text)
  if nil ~= CurrentServerList then
    self.List:ClearListItems()
    if nil ~= text then
      for k, v in pairs(CurrentServerList) do
        if nil ~= string.find(v.name, text) or nil ~= string.find(v.hostnum, text) then
          self.List:AddItem(self:NewServerItemContent(v))
        end
      end
    else
      for k, v in pairs(CurrentServerList) do
        self.List:AddItem(self:NewServerItemContent(v))
      end
    end
    self.List:RequestPlayEntriesAnim()
  end
end

function WBP_ServerSelect_C:Confirm()
  local item = self.List:BP_GetSelectedItem()
  if nil ~= item and self.SelectedServer ~= item then
    self.SelectedServer = item
    self.IsSelectionChanged = true
  else
    self.IsSelectionChanged = false
  end
end

function WBP_ServerSelect_C:PlayUISound(EventPath)
  AudioManager(self):PlayUISound(self, EventPath, nil, nil)
end

return WBP_ServerSelect_C

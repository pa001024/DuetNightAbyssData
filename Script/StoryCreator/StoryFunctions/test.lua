return {
  templateName = "函数节点测试1",
  ports = {
    {
      name = "In",
      type = "Trigger",
      internalNodeType = "FunctionInNode",
      internalNodeId = "1784100122253323",
      internalPortName = "Out",
      inOut = true
    },
    {
      name = "Out",
      type = "Trigger",
      internalNodeType = "FunctionOutNode",
      internalNodeId = "1784100122253327",
      internalPortName = "In",
      inOut = false
    }
  },
  nodeData = {
    ["1784100122253323"] = {
      key = "1784100122253323",
      type = "FunctionInNode",
      name = "In",
      pos = {x = 800, y = 300},
      propsData = {PortName = "In"}
    },
    ["1784100122253327"] = {
      key = "1784100122253327",
      type = "FunctionOutNode",
      name = "Out",
      pos = {x = 2800, y = 300},
      propsData = {PortName = "Out"}
    },
    ["1784100128724445"] = {
      key = "1784100128724445",
      type = "CalculateVarCountNode",
      name = "变量计数节点",
      pos = {x = 1716, y = 304},
      propsData = {
        VarName = "",
        VarValue = 0,
        IsOpen = true
      }
    }
  },
  lineData = {
    {
      startQuest = "1784100122253323",
      startPort = "Out",
      endQuest = "1784100128724445",
      endPort = "In"
    },
    {
      startQuest = "1784100128724445",
      startPort = "Out",
      endQuest = "1784100122253327",
      endPort = "In"
    }
  }
}

return {
  templateName = "函数节点测试2",
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
      name = "TestStop",
      type = "Trigger",
      internalNodeType = "FunctionTestStopNode",
      internalNodeId = "17841002686692447",
      internalPortName = "TestStop",
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
    },
    ["17841002686692447"] = {
      key = "17841002686692447",
      type = "FunctionTestStopNode",
      name = "TestStop",
      pos = {x = 800, y = 660},
      propsData = {PortName = "TestStop"}
    },
    ["17841005779892205554"] = {
      key = "17841005779892205554",
      type = "CalculateVarCountNode",
      name = "变量计数节点",
      pos = {x = 2080, y = 498},
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
    },
    {
      startQuest = "17841002686692447",
      startPort = "TestStop",
      endQuest = "1784100128724445",
      endPort = "In"
    },
    {
      startQuest = "1784100128724445",
      startPort = "Out",
      endQuest = "17841005779892205554",
      endPort = "In"
    },
    {
      startQuest = "17841005779892205554",
      startPort = "Out",
      endQuest = "1784100122253327",
      endPort = "In"
    }
  }
}

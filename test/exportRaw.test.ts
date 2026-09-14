/**
 * export-raw 回归：Script/Datas 下的 Lua 表 → out/<相对路径>.json。
 * 覆盖：键深度排序、连续整数键转数组、__pairs 代理表展开、子目录保持结构，
 * 以及编译失败 / 无返回值两类跳过（不静默吞成空文件）。
 */
import { mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs"
import { tmpdir } from "node:os"
import { join } from "node:path"
import { afterAll, describe, expect, test } from "bun:test"
import { LuaDataManager } from "../src/lua/LuaDataManager.ts"
import { exportRawDatas, listDatasLuaFiles, rawJsonText } from "../src/tools/exportRaw.ts"

const root = mkdtempSync(join(tmpdir(), "dna-export-raw-"))
const datasDir = join(root, "Script", "Datas")
mkdirSync(join(datasDir, "sub"), { recursive: true })

/** 分区懒加载表：内容只在 pairs()（__pairs）时 rawset 进代理表，lua_next 读回来是空表。 */
const PROXY_LUA = `local Data = {
  {
    MinKey = 1,
    MaxKey = 3,
    Loader = function()
      return {
        [1] = { Name = "a" },
        [2] = { Name = "b" }
      }
    end
  }
}
local Proxy = setmetatable({}, {
  __index = function(t, key)
    local Partition = DataMgr.GetPartitionData(key, Data)
    if Partition then return Partition[key] end
    return nil
  end,
  __pairs = function(t)
    for _, partDef in ipairs(Data) do
      local Partition = DataMgr.GetPartitionData(partDef.MinKey, Data)
      if Partition then
        for k, v in pairs(Partition) do
          if rawget(t, k) == nil then rawset(t, k, v) end
        end
      end
    end
    return next, t, nil
  end
})
return Proxy
`

const FILES: Record<string, string> = {
    "Plain.lua": `return ReadOnly("Plain", { [2] = "two", b = 1, ["10"] = "ten", a = 2, [1] = "one" })`,
    "Proxy.lua": PROXY_LUA,
    "Scalar.lua": "return 42",
    "sub/Deep.lua": `return ReadOnly("Deep", { Keep = true })`,
    "Broken.lua": "return ReadOnly(",
    "NoReturn.lua": "local unused = 1",
}

for (const [rel, code] of Object.entries(FILES)) {
    const file = join(datasDir, rel)
    mkdirSync(join(file, ".."), { recursive: true })
    writeFileSync(file, code, "utf8")
}

const outDir = join(root, "out")
const dm = new LuaDataManager(root)
const result = exportRawDatas({ dm, outDir })

const read = (rel: string) => readFileSync(join(outDir, rel), "utf8")

afterAll(() => rmSync(root, { recursive: true, force: true }))

describe("listDatasLuaFiles", () => {
    test("递归列出 Lua 文件，按字典序并用 / 分隔", () => {
        expect(listDatasLuaFiles(datasDir)).toEqual([
            "Broken.lua",
            "NoReturn.lua",
            "Plain.lua",
            "Proxy.lua",
            "Scalar.lua",
            "sub/Deep.lua",
        ])
    })
})

describe("rawJsonText", () => {
    test("数字键按数值序、数字字符串次之、其余按字典序", () => {
        expect(rawJsonText({ b: 1, ["10"]: "ten", a: 2, ["2"]: "t2", ["1"]: "t1" } as never)).toBe(
            `${JSON.stringify({ "1": "t1", "2": "t2", "10": "ten", a: 2, b: 1 }, null, 2)}\n`
        )
    })
})

describe("exportRawDatas", () => {
    test("保持 Datas 相对目录结构，只跳过失败文件", () => {
        expect(result.written).toEqual(["Plain.json", "Proxy.json", "Scalar.json", "sub/Deep.json"])
        expect(result.failed.map(f => f.file)).toEqual(["Broken.lua", "NoReturn.lua"])
        expect(result.failed[0]!.error).toContain("编译失败")
        expect(result.failed[1]!.error).toBe("文件未返回值")
    })

    test("普通表按深度排序写盘", () => {
        expect(read("Plain.json")).toBe(`${JSON.stringify({ "1": "one", "2": "two", "10": "ten", a: 2, b: 1 }, null, 2)}\n`)
    })

    test("__pairs 代理表按 pairs 展开，连续整数键转数组", () => {
        expect(read("Proxy.json")).toBe(`${JSON.stringify([{ Name: "a" }, { Name: "b" }], null, 2)}\n`)
    })

    test("子目录输出到同名子目录；非表返回值原样导出", () => {
        expect(read("sub/Deep.json")).toBe(`${JSON.stringify({ Keep: true }, null, 2)}\n`)
        expect(read("Scalar.json")).toBe("42\n")
    })
})

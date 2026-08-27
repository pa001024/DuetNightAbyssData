# DuetNightAbyssData

Repository containing the data for the game Duet Night Abyss.

## Usage

```sh
# ./lua Examples/2001_Mod.lua
python step1_convert.py
python step2_convert_dialog.py
python step3_output.py
```

## 地图导出（Map Splice / RegionMap 合图）

地图导出脚本默认以 **UAssetCLI server 模式** 直接解析 `.uasset`（不再依赖 FModel
预导出的静态 JSON），并支持通过 `.env` 设置解包目录：

```sh
python export_all_maps.py      # 导出 Map_Splice 各子图 -> out/map_splice
python export_region_maps.py   # 合成 RegionMap 全图 -> out/region_map_merged
```

- 解包目录解析顺序：环境变量 `DNA_UNPACK_DIR` → 仓库根 `.env` 的 `DNA_UNPACK_DIR`
  → 仓库同级 `../dna-unpack`。
- `.env`（gitignored）示例：
  ```
  DNA_UNPACK_DIR=D:/dev/dna-unpack
  ```
- 无 uasset / 无 exe 时自动回退到静态 JSON（FModel `Output/Exports` 下的 `.json`）；
  用 `--force-static-json` 可强制回退。
- 依赖：`.NET 10` 运行时（`tools/UAssetCLI/UAssetCLI.exe`）、`Pillow`。
- 单张小图：`python stitch_map_tiles.py <切图目录> --layout-json <布局.json>`。

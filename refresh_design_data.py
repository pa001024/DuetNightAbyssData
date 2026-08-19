"""刷新 FModel 导出的地图设计数据。

通过 fmodel-cli 的 export-raw 把当前 pak 内最新的
Maps/**/*_Design* 包重新导出到 Exports 目录，覆盖旧版/不完整导出，
供 Resource 处理器拾取最新拾取点坐标。

用法:
    python refresh_design_data.py [--dry-run] [--package 前缀匹配]

前置要求:
    1. fmodel-cli 已构建（fmodel-mcp Cli/bin/publish/fmodel-cli.exe）
    2. fmodel-cli 旁有 config.json（PaksDir/OutputDir/UeVersion/MappingsFile/AesKey）
    3. oodle-data-shared.dll 已放置于 fmodel-cli.exe 同目录

可用环境变量:
    FMODEL_CLI_BIN   fmodel-cli.exe 的绝对路径（默认自动探测）
"""
import argparse
import json
import os
import subprocess
import sys
from pathlib import Path
from typing import List, Optional


def _find_cli() -> Optional[Path]:
    """定位 fmodel-cli.exe。"""
    env_bin = os.getenv("FMODEL_CLI_BIN")
    if env_bin and Path(env_bin).is_file():
        return Path(env_bin)
    candidates = [
        Path(__file__).resolve().parent / "dna-unpack" / "fmodel-cli.exe",
        Path("D:/dev/fmodel-mcp/fmodel-mcp-main/Cli/bin/publish/fmodel-cli.exe"),
        Path("D:/dev/dna-unpack/fmodel-cli.exe"),
    ]
    for candidate in candidates:
        if candidate.is_file():
            return candidate
    return None


def _run_cli(cli: Path, args: List[str], timeout: int = 300) -> dict:
    """调用 fmodel-cli 并解析 JSON 输出。"""
    completed = subprocess.run(
        [str(cli), *args],
        capture_output=True,
        text=True,
        encoding="utf-8",
        errors="replace",
        timeout=timeout,
    )
    output = completed.stdout.strip()
    try:
        result = json.loads(output)
    except json.JSONDecodeError:
        result = {
            "ok": False,
            "error": output or completed.stderr.strip() or "invalid output",
        }
    return result


def _list_design_packages(cli: Path) -> List[str]:
    """列出所有设计包（含扩展名，便于过滤）。"""
    result = _run_cli(cli, ["search", "**/Maps/**/*_Design*", "2000"])
    matches = result.get("matches") or []
    return [m for m in matches if m.endswith(".umap")]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="只列出待刷新包，不实际导出")
    parser.add_argument(
        "--package", default="", help="只刷新包路径包含该前缀的包（如 Huaxu_Yanjindu）"
    )
    args = parser.parse_args()

    cli = _find_cli()
    if cli is None:
        print("Error: 找不到 fmodel-cli.exe，请设置 FMODEL_CLI_BIN", file=sys.stderr)
        return 1
    print(f"fmodel-cli: {cli}", flush=True)

    packages = _list_design_packages(cli)
    if not packages:
        print("Error: 未找到任何设计包（请检查 fmodel config.json）", file=sys.stderr)
        return 1
    if args.package:
        packages = [p for p in packages if args.package in p]
    print(f"设计包数量: {len(packages)}", flush=True)

    if args.dry_run:
        for package in packages:
            print("  " + package, flush=True)
        return 0

    ok_count = 0
    error_count = 0
    for index, package in enumerate(packages, start=1):
        package_path = package[: -len(".umap")]
        try:
            result = _run_cli(cli, ["export-raw", package_path])
        except subprocess.TimeoutExpired:
            print(f"[{index}/{len(packages)}] TIMEOUT: {package_path}", flush=True)
            error_count += 1
            continue
        if result.get("ok"):
            ok_count += 1
        else:
            print(
                f"[{index}/{len(packages)}] FAIL: {package_path}: {result.get('error')}",
                flush=True,
            )
            error_count += 1
        if index % 10 == 0:
            print(
                f"  进度 {index}/{len(packages)}，成功 {ok_count}，失败 {error_count}",
                flush=True,
            )

    print(f"完成：成功 {ok_count}，失败 {error_count}，共 {len(packages)}", flush=True)
    return 0 if error_count == 0 else 2


if __name__ == "__main__":
    sys.exit(main())

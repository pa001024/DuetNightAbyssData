"""UAssetCLI server 客户端 + 解包目录(.env) 解析，供地图导出脚本复用。

把地图导出的数据源从"FModel 预导出的静态 JSON"切换为"UAssetCLI server 模式直接解析
uasset"：启动一次 UAssetCLI server，通过 stdio JSON 行协议请求 `fmodel` 命令，返回与
FModel Output/Exports 同构的 JSON 数组（Type/Name/Class/Outer/Properties 等），
由调用方在内存中继续解析。

解包目录（包目录）解析顺序：
    1. 环境变量 DNA_UNPACK_DIR
    2. 仓库根 .env 中的 DNA_UNPACK_DIR
    3. 仓库同级目录 ../dna-unpack

找不到 uasset / exe 时，调用方回退到静态 JSON。
"""
import json
import os
import subprocess
import time
from pathlib import Path
from typing import Dict, List, Optional

PROJECT_ROOT = Path(__file__).resolve().parent

_loaded_dotenv = False


def load_dotenv(env_path: Optional[Path] = None) -> None:
    """加载仓库根 .env（不覆盖已存在的环境变量）。

    .env 中允许设置:
        DNA_UNPACK_DIR=<解包目录>   # 例如 D:/dev/dna-unpack
    """
    global _loaded_dotenv
    if _loaded_dotenv:
        return
    _loaded_dotenv = True
    if env_path is None:
        env_path = PROJECT_ROOT / ".env"
    try:
        text = env_path.read_text(encoding="utf-8")
    except Exception:
        return
    for line in text.splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, _, value = line.partition("=")
        key = key.strip()
        value = value.strip().strip("\"'")
        if key and key not in os.environ:
            os.environ[key] = value


def get_unpack_dir() -> Optional[Path]:
    """解析解包目录（包目录），未找到返回 None。"""
    load_dotenv()
    raw = os.environ.get("DNA_UNPACK_DIR", "").strip()
    if raw:
        p = Path(raw)
        if p.is_dir():
            return p
    sibling = PROJECT_ROOT.parent / "dna-unpack"
    if sibling.is_dir():
        return sibling
    return None


def get_exports_root() -> Optional[Path]:
    """FModel 导出根目录：<解包目录>/Fmodel/Output/Exports。"""
    unpack = get_unpack_dir()
    if not unpack:
        return None
    exports = unpack / "Fmodel" / "Output" / "Exports"
    return exports if exports.is_dir() else None


def get_uasset_exe() -> Optional[Path]:
    """定位 UAssetCLI 可执行文件。"""
    exe = PROJECT_ROOT / "tools" / "UAssetCLI" / "UAssetCLI.exe"
    return exe if exe.is_file() else None


def unpack_path(*parts: str) -> str:
    """返回 <解包目录>/<parts> 的绝对路径；解包目录未找到时返回空字符串。"""
    unpack = get_unpack_dir()
    if not unpack:
        return ""
    return str(unpack.joinpath(*parts))


def map_widget_dir(name: str) -> Optional[Path]:
    """EM/Content/UI/WBP/Map/Widget/<name> 目录（基于解包目录）。"""
    exports_root = get_exports_root()
    if not exports_root:
        return None
    p = exports_root / "EM" / "Content" / "UI" / "WBP" / "Map" / "Widget" / name
    return p if p.is_dir() else None


def texture_static_dir() -> Optional[Path]:
    """EM/Content/UI/Texture/Static 目录（基于解包目录）。"""
    exports_root = get_exports_root()
    if not exports_root:
        return None
    p = exports_root / "EM" / "Content" / "UI" / "Texture" / "Static"
    return p if p.is_dir() else None


def package_path_for(uasset_file: Path, exports_root: Path) -> str:
    """uasset 绝对路径 -> FModel 包路径（相对 Exports 根、正斜杠、去 .uasset）。"""
    try:
        rel = uasset_file.resolve().relative_to(exports_root.resolve())
    except ValueError:
        rel = Path(uasset_file.name)
    return str(rel.with_suffix("")).replace("\\", "/")


def load_widget_json(
    server: Optional["UAssetServer"],
    exports_root: Path,
    widget_pkg_rel: str,
    mount: str = "EM/Content",
) -> tuple:
    """按包路径读取 Widget JSON 数据，优先 UAssetCLI server（uasset），回退静态 JSON。

    widget_pkg_rel 例: EM/Content/UI/WBP/Map/Widget/Map_Splice/Chapter01/WBP_Map_Chapter01_Bg
    返回 (data_list, source_path)；两者皆为 None 表示不可用。
    """
    rel = Path(widget_pkg_rel)
    if server is not None:
        ua = exports_root / rel.with_suffix(".uasset")
        if ua.is_file():
            data = server.fmodel(ua, exports_root, mount=mount)
            if data is not None:
                return data, ua
    js = exports_root / rel.with_suffix(".json")
    if js.is_file():
        try:
            return json.loads(js.read_text(encoding="utf-8")), js
        except Exception:
            return None, None
    return None, None


class UAssetServer:
    """UAssetCLI server 客户端：启动一次、多次请求、结束时 shutdown。"""

    def __init__(self, exe: Optional[Path] = None, mount: str = "EM/Content"):
        exe = exe or get_uasset_exe()
        if exe is None:
            raise RuntimeError("找不到 UAssetCLI.exe（tools/UAssetCLI/UAssetCLI.exe）")
        self.exe = str(exe)
        self.mount = mount
        self.proc: Optional[subprocess.Popen] = None

    def __enter__(self):
        self.start()
        return self

    def __exit__(self, *exc):
        self.close()

    def start(self) -> None:
        """启动 server 子进程。"""
        self.proc = subprocess.Popen(
            [self.exe, "server"],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.DEVNULL,
            text=True,
            encoding="utf-8",
            bufsize=1,
        )

    def request(self, cmd: dict) -> dict:
        """发送一行 JSON 命令，读取一行 JSON 响应。"""
        if self.proc is None or self.proc.poll() is not None:
            raise RuntimeError("UAssetCLI server 未运行")
        self.proc.stdin.write(json.dumps(cmd, ensure_ascii=False) + "\n")
        self.proc.stdin.flush()
        line = self.proc.stdout.readline()
        if not line:
            raise RuntimeError("UAssetCLI server 意外退出")
        return json.loads(line)

    def _request_with_retry(self, cmd: dict, retries: int = 4) -> dict:
        """发送命令并读取响应；对 server 返回 ok=false 的瞬时失败（如 Windows 下
        多进程并发解析同一 uasset 的文件占用冲突）做指数退避重试。"""
        for attempt in range(retries):
            resp = self.request(cmd)
            if resp.get("ok"):
                return resp
            if attempt >= retries - 1:
                return resp
            time.sleep(0.05 * (2 ** attempt))
        return {"ok": False, "error": "unknown"}

    def fmodel(
        self,
        uasset_file: Path,
        exports_root: Path,
        mount: Optional[str] = None,
    ) -> Optional[List[dict]]:
        """按 FModel Output/Exports 数组格式导出单个 uasset；失败返回 None。"""
        resp = self._request_with_retry(
            {
                "cmd": "fmodel",
                "path": str(uasset_file.resolve()),
                "package": package_path_for(uasset_file, exports_root),
                "mount": mount or self.mount,
            }
        )
        if not resp.get("ok"):
            return None
        result = resp.get("result")
        return result if isinstance(result, list) else None

    def fmodel_dir(
        self,
        uasset_dir: Path,
        exports_root: Path,
        mount: Optional[str] = None,
    ) -> Dict[str, List[dict]]:
        """递归导出目录下所有 uasset，返回 {包路径: [数组]}；失败返回 {}。"""
        resp = self._request_with_retry(
            {
                "cmd": "fmodel_dir",
                "path": str(uasset_dir.resolve()),
                "root": str(exports_root.resolve()),
                "mount": mount or self.mount,
            }
        )
        if not resp.get("ok"):
            return {}
        files = (resp.get("result") or {}).get("Files") or {}
        return {k: v for k, v in files.items() if isinstance(v, list)}

    def close(self) -> None:
        """发送 shutdown 并回收子进程。"""
        if self.proc is None:
            return
        try:
            self.request({"cmd": "shutdown"})
        except Exception:
            pass
        try:
            self.proc.stdin.close()
            self.proc.wait(timeout=5)
        except Exception:
            try:
                self.proc.kill()
            except Exception:
                pass
        self.proc = None

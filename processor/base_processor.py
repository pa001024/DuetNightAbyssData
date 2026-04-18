import json
import re
from pathlib import Path
from collections import OrderedDict
from threading import Lock
from typing import Any, Dict, List, Optional, Tuple


class BaseProcessor:
    _shared_items_cache = {}
    _shared_items_cache_lock = Lock()
    _shared_i18n_cn_alt_cache = {}
    _shared_guide_point_loc_cache = {}
    _shared_guide_point_loc_cache_lock = Lock()
    _shared_guide_point_loc_index_cache = {}
    _shared_guide_point_loc_index_cache_lock = Lock()

    def __init__(self, data_loader):
        self.data_loader = data_loader
        self.file_type = "Base"
        self.i18n_data = data_loader.load_json("TextMap_I18n.json")
        self.i18n_data_cn_alt = self._load_shared_i18n_cn_alt(data_loader)
        self.condition_data = data_loader.load_json("Condition.json")
        self.impression_check_data = data_loader.load_json("ImpressionCheck.json")
        # 预加载所有语言的对话数据
        self.dialogue_data_cache = {}

    @staticmethod
    def _ref_outer_and_name(object_name: Optional[str]) -> Tuple[Optional[str], Optional[str]]:
        """解析对象引用的 Outer 与短名。"""
        if not object_name:
            return None, None
        raw = object_name.strip("'")
        if ":" in raw:
            raw = raw.split(":", 1)[1]
        parts = raw.split(".")
        if len(parts) >= 2:
            return parts[-2], parts[-1]
        if len(parts) == 1:
            return None, parts[0]
        return None, None

    @staticmethod
    def _build_object_maps(
        arr: List[dict],
    ) -> Tuple[Dict[Tuple[str, str], dict], Dict[str, List[dict]], Dict[str, dict]]:
        """构建对象索引，便于从 ObjectRef 快速反查对象。"""
        by_outer_name: Dict[Tuple[str, str], dict] = {}
        by_name: Dict[str, List[dict]] = {}
        by_path: Dict[str, dict] = {}
        for obj in arr:
            if not isinstance(obj, dict):
                continue
            name = obj.get("Name")
            outer = obj.get("Outer")
            outer_name = outer.get("ObjectName") if isinstance(outer, dict) else outer
            outer_short_name = None
            if isinstance(outer_name, str):
                _, outer_short_name = BaseProcessor._ref_outer_and_name(outer_name)
            if isinstance(name, str):
                by_name.setdefault(name, []).append(obj)
                if isinstance(outer_name, str):
                    by_outer_name[(outer_name, name)] = obj
                if isinstance(outer_short_name, str):
                    by_outer_name[(outer_short_name, name)] = obj
            if isinstance(object_path := obj.get("ObjectPath"), str):
                by_path[object_path] = obj
        return by_outer_name, by_name, by_path

    @staticmethod
    def _resolve_ref_object(
        ref_obj: Optional[dict],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
    ) -> Optional[dict]:
        """从引用对象中反查真实对象。"""
        if not isinstance(ref_obj, dict):
            return None
        object_name = ref_obj.get("ObjectName")
        object_path = ref_obj.get("ObjectPath")
        outer_name, short_name = BaseProcessor._ref_outer_and_name(object_name)
        if by_path is not None and isinstance(object_path, str) and object_path in by_path:
            return by_path[object_path]
        if outer_name and short_name:
            found = by_outer_name.get((outer_name, short_name))
            if found is not None:
                return found
        if short_name:
            candidates = by_name.get(short_name, [])
            if len(candidates) == 1:
                return candidates[0]
        return None

    @classmethod
    def _get_guide_point_loc_data(cls) -> Dict[str, Any]:
        """加载 QuestGuidePointLocData.lua 并缓存。"""
        cache_key = "Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua"
        with cls._shared_guide_point_loc_cache_lock:
            cached = cls._shared_guide_point_loc_cache.get(cache_key)
            if cached is not None:
                return cached

        lua_path = (
            Path(__file__).resolve().parents[1]
            / "Script"
            / "BluePrints"
            / "UI"
            / "TaskPanel"
            / "QuestGuidePointLocData.lua"
        )
        guide_point_data: Dict[str, Any] = {}
        if lua_path.exists():
            try:
                from step1_convert import parse_lua_file

                loaded = parse_lua_file(str(lua_path))
                if isinstance(loaded, dict):
                    guide_point_data = loaded
            except Exception:
                guide_point_data = {}

        with cls._shared_guide_point_loc_cache_lock:
            existing = cls._shared_guide_point_loc_cache.get(cache_key)
            if existing is not None:
                return existing
            cls._shared_guide_point_loc_cache[cache_key] = guide_point_data
        return guide_point_data

    @classmethod
    def _get_guide_point_loc_index(cls) -> Dict[str, Dict[str, List[str]]]:
        """加载 QuestGuidePointLocData.lua 的索引缓存。"""
        cache_key = "Script/BluePrints/UI/TaskPanel/QuestGuidePointLocData.lua"
        with cls._shared_guide_point_loc_index_cache_lock:
            cached = cls._shared_guide_point_loc_index_cache.get(cache_key)
            if cached is not None:
                return cached

        guide_point_data = cls._get_guide_point_loc_data()
        index = cls._build_guide_point_loc_index(guide_point_data)

        with cls._shared_guide_point_loc_index_cache_lock:
            existing = cls._shared_guide_point_loc_index_cache.get(cache_key)
            if existing is not None:
                return existing
            cls._shared_guide_point_loc_index_cache[cache_key] = index
        return index

    @classmethod
    def _build_guide_point_loc_index(cls, guide_point_data: Dict[str, Any]) -> Dict[str, Dict[str, List[str]]]:
        """构建导引点索引，避免每次查找全表扫描。"""
        by_normalized_name: Dict[str, List[str]] = {}
        by_token: Dict[str, List[str]] = {}
        if not isinstance(guide_point_data, dict):
            return {"by_normalized_name": by_normalized_name, "by_token": by_token}

        for guide_point_name in guide_point_data.keys():
            if not isinstance(guide_point_name, str) or not guide_point_name:
                continue
            normalized_name = cls._normalize_guide_point_token(guide_point_name)
            if not normalized_name:
                continue
            by_normalized_name.setdefault(normalized_name, []).append(guide_point_name)

            for token in cls._extract_guide_point_name_tokens(guide_point_name):
                by_token.setdefault(token, []).append(guide_point_name)

        return {"by_normalized_name": by_normalized_name, "by_token": by_token}

    @staticmethod
    def _extract_guide_point_pos(guide_point_data: Optional[dict]) -> Tuple[Optional[int], Optional[List[float]]]:
        """将导引点数据收敛为 srId 与二维整数坐标。"""
        if not isinstance(guide_point_data, dict):
            return None, None

        x = guide_point_data.get("X")
        y = guide_point_data.get("Y")
        if x is None or y is None:
            return None, None

        try:
            pos = [int(round(float(x))), int(round(float(y)))]
        except Exception:
            return None, None

        try:
            sr_id = int(guide_point_data.get("SubRegionId"))
        except Exception:
            sr_id = None

        if sr_id is None or sr_id <= 0:
            return None, None

        return sr_id, pos

    def _resolve_guide_point_pos(self, guide_point_name: Optional[str]) -> Tuple[Optional[int], Optional[List[float]]]:
        """按导引点名称读取真实坐标。"""
        if not isinstance(guide_point_name, str) or not guide_point_name:
            return None, None

        guide_point_data = self._get_guide_point_loc_data().get(guide_point_name)
        return self._extract_guide_point_pos(guide_point_data)

    @classmethod
    def _normalize_guide_point_token(cls, value: Optional[str]) -> str:
        """将导引点相关名称标准化用于模糊匹配。"""
        if not isinstance(value, str):
            return ""
        return re.sub(r"[^0-9A-Za-z]+", "", value).lower()

    @classmethod
    def _extract_guide_point_name_tokens(cls, guide_point_name: Optional[str]) -> List[str]:
        """提取导引点名可用于检索的 token。"""
        if not isinstance(guide_point_name, str) or not guide_point_name:
            return []

        tokens = []
        seen = set()
        for part in re.split(r"[^0-9A-Za-z]+", guide_point_name):
            if not part:
                continue
            normalized_part = cls._normalize_guide_point_token(part)
            if normalized_part and normalized_part not in seen:
                seen.add(normalized_part)
                tokens.append(normalized_part)

            for chunk in re.findall(r"[0-9]+|[A-Za-z]+", part):
                normalized_chunk = cls._normalize_guide_point_token(chunk)
                if not normalized_chunk:
                    continue
                if not normalized_chunk.isdigit() and len(normalized_chunk) < 3:
                    continue
                if normalized_chunk in seen:
                    continue
                seen.add(normalized_chunk)
                tokens.append(normalized_chunk)

        normalized_name = cls._normalize_guide_point_token(guide_point_name)
        if normalized_name and normalized_name not in seen:
            tokens.append(normalized_name)
        return tokens

    @classmethod
    def _pick_guide_point_name_from_candidates(
        cls, normalized_token: str, candidates: List[str]
    ) -> Optional[str]:
        """从候选导引点名中挑出唯一命中项。"""
        if not candidates:
            return None
        if len(candidates) == 1:
            return candidates[0]

        normalized_candidates = [
            (name, cls._normalize_guide_point_token(name))
            for name in candidates
        ]
        exact = [name for name, normalized_name in normalized_candidates if normalized_name == normalized_token]
        if len(exact) == 1:
            return exact[0]

        suffix = [name for name, normalized_name in normalized_candidates if normalized_name.endswith(normalized_token)]
        if len(suffix) == 1:
            return suffix[0]

        contains = [name for name, normalized_name in normalized_candidates if normalized_token in normalized_name]
        if len(contains) == 1:
            return contains[0]

        return None

    @classmethod
    def _find_guide_point_name_by_token(cls, token: Optional[str]) -> Optional[str]:
        """按名称 token 在 QuestGuidePointLocData 中查找真实导引点名。"""
        normalized_token = cls._normalize_guide_point_token(token)
        if not normalized_token:
            return None

        guide_point_index = cls._get_guide_point_loc_index()
        by_normalized_name = guide_point_index.get("by_normalized_name", {})
        by_token = guide_point_index.get("by_token", {})

        exact_matches = by_normalized_name.get(normalized_token, [])
        if len(exact_matches) == 1:
            return exact_matches[0]
        if len(exact_matches) > 1:
            picked = cls._pick_guide_point_name_from_candidates(normalized_token, exact_matches)
            if picked:
                return picked

        token_matches = by_token.get(normalized_token, [])
        picked = cls._pick_guide_point_name_from_candidates(normalized_token, token_matches)
        if picked:
            return picked

        return None

    @staticmethod
    def _extract_path_token(path_value: Optional[str]) -> str:
        """从路径或对象名中提取最后一个语义 token。"""
        if not isinstance(path_value, str) or not path_value:
            return ""
        token = path_value.replace("\\", "/").split("/")[-1]
        token = token.split(".")[0]
        if "_" in token:
            token = token.split("_")[-1]
        return token

    @staticmethod
    def _to_vector3(value) -> Optional[List[float]]:
        """将向量数据转为三元坐标。"""
        if not isinstance(value, dict):
            return None
        x = value.get("X")
        y = value.get("Y")
        z = value.get("Z")
        if x is None or y is None:
            return None
        try:
            return [float(x), float(y), float(z if z is not None else 0.0)]
        except Exception:
            return None

    def _extract_ref_location(
        self,
        ref_obj: Optional[dict],
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
        prefer_root_first: bool = False,
        accumulate_attach_parent: bool = False,
    ) -> Optional[List[float]]:
        """从引用对象中直接解析坐标。"""
        resolved_obj = BaseProcessor._resolve_ref_object(ref_obj, by_outer_name, by_name, by_path)
        if not isinstance(resolved_obj, dict):
            return None

        props = resolved_obj.get("Properties", {})
        if not isinstance(props, dict):
            return None

        if prefer_root_first:
            root_ref = props.get("RootComponent") or props.get("DefaultSceneRoot")
            if root_ref is not None:
                loc = BaseProcessor._extract_ref_location(
                    self,
                    root_ref,
                    by_outer_name,
                    by_name,
                    by_path,
                    prefer_root_first=False,
                )
                if loc is not None:
                    return loc

        local_loc = None
        for key in ("RelativeLocation", "Location"):
            local_loc = BaseProcessor._to_vector3(props.get(key))
            if local_loc is not None:
                break

        transform = props.get("RelativeTransform")
        if isinstance(transform, dict):
            transform_loc = BaseProcessor._to_vector3(transform.get("Translation"))
            if transform_loc is not None:
                local_loc = transform_loc

        if local_loc is not None:
            if accumulate_attach_parent:
                attach_parent = props.get("AttachParent")
                if isinstance(attach_parent, dict):
                    parent_loc = BaseProcessor._extract_ref_location(
                        self,
                        attach_parent,
                        by_outer_name,
                        by_name,
                        by_path,
                        prefer_root_first=False,
                        accumulate_attach_parent=True,
                        )
                    if parent_loc is not None:
                        return [
                            local_loc[0] + parent_loc[0],
                            local_loc[1] + parent_loc[1],
                            local_loc[2] + parent_loc[2],
                        ]
                outer_ref = resolved_obj.get("Outer")
                if isinstance(outer_ref, dict):
                    outer_loc = BaseProcessor._extract_ref_location(
                        self,
                        outer_ref,
                        by_outer_name,
                        by_name,
                        by_path,
                        prefer_root_first=True,
                        accumulate_attach_parent=False,
                    )
                    if outer_loc is not None:
                        return outer_loc
            return local_loc

        attach_parent = props.get("AttachParent")
        if isinstance(attach_parent, dict):
            loc = self._extract_ref_location(
                attach_parent,
                by_outer_name,
                by_name,
                by_path,
                prefer_root_first=False,
                accumulate_attach_parent=accumulate_attach_parent,
            )
            if loc is not None:
                return loc

        return None

    def _extract_object_location(
        self,
        obj: dict,
        by_outer_name: Dict[Tuple[str, str], dict],
        by_name: Dict[str, List[dict]],
        by_path: Optional[Dict[str, dict]] = None,
        prefer_root_first: bool = False,
    ) -> Optional[List[float]]:
        """提取对象自身或其根组件的位置。"""
        if not isinstance(obj, dict):
            return None

        props = obj.get("Properties", {})
        if not isinstance(props, dict):
            return None

        def resolve_root_related() -> Optional[List[float]]:
            root_ref = props.get("RootComponent") or props.get("DefaultSceneRoot")
            if root_ref is not None:
                loc = self._extract_ref_location(root_ref, by_outer_name, by_name, by_path)
                if loc is not None:
                    return loc

            attach_parent = props.get("AttachParent")
            if attach_parent is not None:
                loc = self._extract_ref_location(
                    attach_parent, by_outer_name, by_name, by_path
                )
                if loc is not None:
                    return loc

            for component_key in ("Sphere", "SceneComponent", "CollisionComponent"):
                component_ref = props.get(component_key)
                if component_ref is None:
                    continue
                loc = self._extract_ref_location(
                    component_ref, by_outer_name, by_name, by_path
                )
                if loc is not None:
                    return loc

            blueprint_components = props.get("BlueprintCreatedComponents")
            if isinstance(blueprint_components, list):
                for component_ref in blueprint_components:
                    loc = self._extract_ref_location(
                        component_ref, by_outer_name, by_name, by_path
                    )
                    if loc is not None:
                        return loc
            return None

        def resolve_direct_fields() -> Optional[List[float]]:
            for key in ("RelativeLocation", "Location"):
                loc = BaseProcessor._to_vector3(props.get(key))
                if loc is not None:
                    return loc

            transform = props.get("RelativeTransform")
            if isinstance(transform, dict):
                loc = BaseProcessor._to_vector3(transform.get("Translation"))
                if loc is not None:
                    return loc
            return None

        if prefer_root_first:
            loc = resolve_root_related()
            if loc is not None:
                return loc
            return resolve_direct_fields()

        loc = resolve_direct_fields()
        if loc is not None:
            return loc
        return resolve_root_related()

    @classmethod
    def _load_shared_i18n_cn_alt(cls, data_loader):
        """共享加载中文补充翻译表。"""
        base_dir = getattr(data_loader, "base_dir", None)
        cache_key = str(base_dir) if base_dir is not None else "__none__"
        with cls._shared_items_cache_lock:
            cached = cls._shared_i18n_cn_alt_cache.get(cache_key)
            if cached is not None:
                return cached

        i18n_data_cn_alt = {}
        for item in data_loader.load_json("TextMap_TextMapContent.json"):
            if not isinstance(item, dict):
                continue
            loader_data = item.get("Loader")
            if isinstance(loader_data, dict):
                i18n_data_cn_alt.update(loader_data)

        with cls._shared_items_cache_lock:
            cached = cls._shared_i18n_cn_alt_cache.get(cache_key)
            if cached is not None:
                return cached
            cls._shared_i18n_cn_alt_cache[cache_key] = i18n_data_cn_alt
        return i18n_data_cn_alt

    def _load_all_dialogue_data(self):
        """预加载所有语言的对话数据到缓存中"""
        language_files = {
            "cn": "Dialogue_TextMapContent.json",
            "en": "Dialogue_ContentEN.json",
            "jp": "Dialogue_ContentJP.json",
            "kr": "Dialogue_ContentKR.json",
            "fr": "Dialogue_ContentFR.json",
            "es": "Dialogue_ContentES.json",
            "tc": "Dialogue_ContentTC.json",
            "de": "Dialogue_ContentDE.json",
        }

        for lang, filename in language_files.items():
            try:
                dialogue_file_data = self.data_loader.load_json(filename)
                # 对话文件是一个数组，包含多个对象
                # 每个对象都有一个 Loader 字段，里面才是实际的对话数据
                # 参考 i18n_data_cn_alt 的处理方式，将所有 Loader 字段合并
                lang_cache = {}
                if isinstance(dialogue_file_data, list):
                    for item in dialogue_file_data:
                        if isinstance(item, dict) and "Loader" in item:
                            loader_data = item.get("Loader")
                            if loader_data:
                                lang_cache.update(loader_data)
                elif isinstance(dialogue_file_data, dict):
                    lang_cache.update(dialogue_file_data)
                self.dialogue_data_cache[lang] = lang_cache
            except Exception as e:
                print(f"加载对话数据失败 {filename}: {e}", flush=True)

    def get_dialogue_data(self, dialogue_id, language=""):
        """获取对话数据

        Args:
            dialogue_id: 对话ID
            language: 语言类型

        Returns:
            dict: 对话数据，如果未找到返回 None
        """
        if not self.dialogue_data_cache:
            self._load_all_dialogue_data()
        language = language if language else self.data_loader.language
        lang_cache = self.dialogue_data_cache.get(language, {})
        return lang_cache.get(str(dialogue_id))

    def _simplify_voice_name(self, voice_name):
        """精简 VoiceName 路径，去掉语言前缀。"""
        if not isinstance(voice_name, str):
            return ""

        normalized = voice_name.strip().replace("\\", "/")
        if not normalized:
            return ""

        prefix_list = [
            "voice/$Locale$/",
            "voice/ch/",
            "voice/en/",
            "voice/jp/",
            "voice/kr/",
            "voice/fr/",
            "voice/es/",
            "voice/tc/",
            "voice/de/",
        ]
        for prefix in prefix_list:
            if normalized.startswith(prefix):
                return normalized[len(prefix) :]

        match = re.match(r"^voice/[^/]+/(.+)$", normalized)
        if match:
            return match.group(1)

        return normalized.lstrip("/")

    def get_dialogue_voice_name(self, dialogue_id, language=""):
        """获取对话语音路径（精简后）。"""
        dialogue_data = self.get_dialogue_data(dialogue_id, language)
        if not isinstance(dialogue_data, dict):
            return ""

        return self._simplify_voice_name(dialogue_data.get("VoiceName", ""))

    def get_dialogue_content(self, dialogue_id, language=""):
        """获取对话内容

        Args:
            dialogue_id: 对话ID
            language: 语言类型

        Returns:
            str: 对话内容，如果未找到返回空字符串
        """
        dialogue_data = self.get_dialogue_data(dialogue_id, language)
        if dialogue_data:
            # 根据语言获取对应字段
            # 语言映射：cn->Content, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, es->ContentES, tc->ContentTC, de->ContentDE
            language_field_map = {
                "cn": "Content",
                "en": "ContentEN",
                "jp": "ContentJP",
                "kr": "ContentKR",
                "fr": "ContentFR",
                "es": "ContentES",
                "tc": "ContentTC",
                "de": "ContentDE",
            }

            language = language if language else self.data_loader.language
            field = language_field_map.get(language, "Content")
            content = dialogue_data.get(field, "")

            # 如果对应语言字段为空，尝试使用其他可用字段
            if not content:
                for fallback_field in [
                    "Content",
                    "ContentEN",
                    "ContentJP",
                    "ContentKR",
                    "ContentFR",
                    "ContentES",
                    "ContentTC",
                    "ContentDE",
                ]:
                    if (
                        fallback_field in dialogue_data
                        and dialogue_data[fallback_field]
                    ):
                        content = dialogue_data[fallback_field]
                        break

            # 部分对话没有 Content，使用 OptionTopic 作为回退文本
            if not content:
                option_topic = dialogue_data.get("OptionTopic", "")
                if option_topic:
                    content = option_topic

            return content
        return ""

    def get_dialogue_chain(self, first_dialogue_id, language=""):
        """获取对话链（支持分支）

        Args:
            first_dialogue_id: 第一个对话ID
            language: 语言类型

        Returns:
            list: 对话链列表，包含所有分支
        """
        dialogue_chain = []
        visited = set()  # 用于去重
        queue = [(str(first_dialogue_id), None)]  # (对话ID, 父对话ID)

        while queue:
            current_dialogue_id, parent_id = queue.pop(0)

            # 跳过已处理的对话
            if current_dialogue_id in visited:
                continue
            visited.add(current_dialogue_id)

            dialogue_data = self.get_dialogue_data(current_dialogue_id, language)
            if not dialogue_data:
                continue

            # 获取对话内容
            dialogue_text = self.get_dialogue_content(current_dialogue_id, language)
            if not dialogue_text:
                continue

            dialogue_item = {"id": int(current_dialogue_id), "content": dialogue_text}
            voice_name = self.get_dialogue_voice_name(current_dialogue_id, language)
            if voice_name:
                dialogue_item["voice"] = voice_name

            # 只在有 SpeakNpcId 字段时才添加
            if "SpeakNpcId" in dialogue_data and dialogue_data["SpeakNpcId"]:
                dialogue_item["npc"] = dialogue_data["SpeakNpcId"]

            has_next_options = bool(dialogue_data.get("NextOptions"))

            # NextOptions 与 NextDialogue 互斥：有选项时不走 NextDialogue 分支
            if not has_next_options:
                next_dialogue_id = dialogue_data.get("NextDialogue")
                if next_dialogue_id:
                    dialogue_item["next"] = int(next_dialogue_id)
                    # 将下一个对话加入队列
                    queue.append((str(next_dialogue_id), current_dialogue_id))

            if dialogue_data.get("ImprCheckId"):
                dialogue_item["imprCheck"] = self._inline_impr_check(
                    dialogue_data.get("ImprCheckId")
                )

            if dialogue_data.get("ImprPlusId"):
                impression_plus_data = self.data_loader.load_json("ImpressionPlus.json")
                impr_data = impression_plus_data.get(
                    str(dialogue_data.get("ImprPlusId"))
                )
                if impr_data:
                    impr = self._inline_impr_plus(impr_data)
                    if impr:
                        dialogue_item["impr"] = impr

            # 添加options字段（如果有NextOptions）
            if has_next_options:
                next_options = dialogue_data["NextOptions"]
                options = []
                # 加载ImpressionPlus数据
                impression_plus_data = self.data_loader.load_json("ImpressionPlus.json")
                for option_id in next_options:
                    option_data = self.get_dialogue_data(str(option_id), language)
                    if option_data:
                        option_content = self.get_dialogue_content(
                            str(option_id), language
                        )
                        if option_content:
                            option_item = {
                                "id": int(option_id),
                                "content": option_content,
                            }
                            option_voice_name = self.get_dialogue_voice_name(
                                option_id, language
                            )
                            if option_voice_name:
                                option_item["voice"] = option_voice_name
                            # 添加next字段（只在有下一个对话时）
                            option_next = option_data.get("NextDialogue")
                            if option_next and not option_data.get("NextOptions"):
                                option_item["next"] = int(option_next)
                                # 将选项的下一个对话加入队列
                                queue.append((str(option_next), str(option_id)))
                            # 处理ImprPlusId
                            impr_plus_id = option_data.get("ImprPlusId")
                            if impr_plus_id and impression_plus_data:
                                impr_data = impression_plus_data.get(str(impr_plus_id))
                                if impr_data:
                                    impr = self._inline_impr_plus(impr_data)
                                    if impr:
                                        option_item["impr"] = impr

                            if option_data.get("ImprCheckId"):
                                impr_check = self._inline_impr_check(
                                    option_data.get("ImprCheckId")
                                )
                                if impr_check:
                                    option_item["imprCheck"] = impr_check

                            options.append(option_item)
                if options:
                    dialogue_item["options"] = options

            dialogue_chain.append(dialogue_item)

        return dialogue_chain

    def _process_talk_trigger(self, talk_trigger_data, language=""):
        """处理对话触发数据

        Args:
            talk_trigger_data: 对话触发数据
            language: 语言类型

        Returns:
            dict: 处理后的对话触发数据
        """
        if not talk_trigger_data:
            return {}

        processed_trigger = {
            "id": talk_trigger_data.get("Id", 0),
            "type": talk_trigger_data.get("Type", ""),
        }

        # 处理对话ID
        if "DialogueId" in talk_trigger_data:
            dialogue_id = talk_trigger_data.get("DialogueId")
            processed_trigger["dialogueId"] = dialogue_id

            # 获取对话内容
            dialogue_content = self.get_dialogue_content(dialogue_id, language)
            if dialogue_content:
                processed_trigger["content"] = dialogue_content

            # 获取说话NPC ID
            dialogue_data = self.get_dialogue_data(dialogue_id, language)
            if dialogue_data and "SpeakNpcId" in dialogue_data:
                processed_trigger["speakNpcId"] = dialogue_data["SpeakNpcId"]

            voice_name = self.get_dialogue_voice_name(dialogue_id, language)
            if voice_name:
                processed_trigger["voice"] = voice_name

        # 处理其他字段
        if "Condition" in talk_trigger_data:
            processed_trigger["condition"] = talk_trigger_data.get("Condition")

        if "Action" in talk_trigger_data:
            processed_trigger["action"] = talk_trigger_data.get("Action")

        if "Params" in talk_trigger_data:
            processed_trigger["params"] = talk_trigger_data.get("Params")

        return processed_trigger

    def get_file_type(self):
        return self.file_type

    def process_item(self, item_data, language):
        """处理单个项目，子类必须实现"""
        raise NotImplementedError("Subclasses must implement process_item method")

    def load_items(self, file_path):
        """加载项目数据"""
        shared_key = str(file_path)
        cached = self._shared_items_cache.get(shared_key)
        if cached is not None:
            return cached

        with open(file_path, "r", encoding="utf-8") as f:
            data = json.load(f, object_pairs_hook=OrderedDict)

        # Convert map to array if needed
        if isinstance(data, dict):
            data = list(data.values())

        with self._shared_items_cache_lock:
            cached = self._shared_items_cache.get(shared_key)
            if cached is not None:
                return cached
            self._shared_items_cache[shared_key] = data

        return data

    def process_all_items(self, items, language):
        """处理所有项目"""
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if not processed:
                continue
            processed_items.append(processed)
        return processed_items

    def save_processed_items(self, processed_items, output_path, file_name):
        """保存处理后的项目"""
        import os
        from pathlib import Path

        # Create output directory if it doesn't exist
        Path(output_path).mkdir(parents=True, exist_ok=True)

        # Write processed data to file
        output_file = os.path.join(output_path, file_name)
        with open(output_file, "w", encoding="utf-8") as f:
            import json

            json.dump(processed_items, f, ensure_ascii=False, indent=2, sort_keys=False)

        return output_file

    def process_release(self, release_version):
        """处理角色版本数据 100->1.3"""
        if not release_version:
            return ""
        return (
            f"{release_version // 100}.{release_version % 100 // 10}"
            if release_version
            else "1.0"
        )

    def process_tags(self, tags):
        """处理武器标签"""
        if not tags or not isinstance(tags, list):
            return []
        Positioning = self.data_loader.load_json("Positioning.json")
        rst = []
        tag_map = {
            "Ultra": "同律",
            "Melee": "近战",
            "Ranged": "远程",
            "Bow": self.get_translated_text("WeaponType_Bow", "cn"),
            "Bow01": self.get_translated_text("WeaponType_Bow01", "cn"),
            "Bow02": self.get_translated_text("WeaponType_Bow02", "cn"),
            "Cannon": self.get_translated_text("WeaponType_Cannon", "cn"),
            "Claymore": self.get_translated_text("WeaponType_Claymore", "cn"),
            "Crossbow": self.get_translated_text("WeaponType_Crossbow", "cn"),
            "Dualblade": self.get_translated_text("WeaponType_Dualblade", "cn"),
            "Katana": self.get_translated_text("WeaponType_Katana", "cn"),
            "Machinegun": self.get_translated_text("WeaponType_Machinegun", "cn"),
            "Pistol": self.get_translated_text("WeaponType_Pistol", "cn"),
            "Polearm": self.get_translated_text("WeaponType_Polearm", "cn"),
            "Shotgun": self.get_translated_text("WeaponType_Shotgun", "cn"),
            "Sword": self.get_translated_text("WeaponType_Sword", "cn"),
            "Swordwhip": self.get_translated_text("WeaponType_Swordwhip", "cn"),
        }
        for tag in tags:
            t = tag_map.get(tag, "")
            if t:
                rst.append(t)
            elif tag in Positioning:
                t = Positioning[tag]
                rst.append(self.get_translated_text(t["Name"]))
        return rst

    def _inline_impr_check(self, condition_id):
        """将ImprCheckId转换为印象检定数组。"""
        check_data = self.impression_check_data.get(str(condition_id), {})
        if not isinstance(check_data, dict):
            return []

        region_id = self._to_int(check_data.get("RegionId"))
        if region_id is None:
            return []

        check_fields = [
            ("BenefitCheck", "Benefit"),
            ("MoralityCheck", "Morality"),
            ("WisdomCheck", "Wisdom"),
            ("EmpathyCheck", "Empathy"),
            ("ChaosCheck", "Chaos"),
        ]
        for field, name in check_fields:
            value = self._to_int(check_data.get(field))
            if value and value > 0:
                return [region_id, name, value]

        return []

    def _inline_impr_plus(self, impr_data):
        """将ImprPlus配置转换为 [RegionId, 属性名, 值]"""
        if not impr_data:
            return []

        region_id = impr_data.get("RegionId", 0)
        plus_fields = [
            ("BenefitPlus", "Benefit"),
            ("MoralityPlus", "Morality"),
            ("WisdomPlus", "Wisdom"),
            ("EmpathyPlus", "Empathy"),
            ("ChaosPlus", "Chaos"),
        ]

        for field, name in plus_fields:
            value = impr_data.get(field, 0)
            if value > 0:
                return [region_id, name, value]

        return []

    def get_access_text(self, access_key, language=""):
        """获取访问文本"""
        if "access_data" not in self.__dict__ or not self.access_data:
            self.access_data = self.data_loader.load_json("Access.json")
        access = self.access_data.get(access_key, {})
        return self.get_translated_text(access.get("AccessText", access_key), language)

    def get_translated_text(self, text_key, language=""):
        """从i18n数据中获取翻译文本"""
        # 从i18n_data中查找
        text_entry = self.i18n_data.get(text_key, {})
        if not text_entry:
            return self.i18n_data_cn_alt.get(text_key, {}).get(
                "TextMapContent", text_key
            )

        # 获取当前语言
        language = language if language else self.data_loader.language

        if language == "cn":
            cn_alt = self.i18n_data_cn_alt.get(text_key, {}).get("TextMapContent", "")
            if cn_alt:
                return cn_alt
        # 根据当前语言获取对应字段
        # 语言映射：cn->TextMapContent, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, tc->ContentTC
        language_field_map = {
            "cn": "TextMapContent",
            "en": "ContentEN",
            "jp": "ContentJP",
            "kr": "ContentKR",
            "fr": "ContentFR",
            "es": "ContentES",
            "tc": "ContentTC",
        }

        # 获取对应语言字段
        field = language_field_map.get(language, "TextMapContent")
        content = text_entry.get(field, "")

        # 如果对应语言字段为空，尝试使用其他可用字段
        if not content:
            # 优先顺序：TextMapContent > ContentEN > ContentJP > ContentKR > ContentFR > ContentTC
            for fallback_field in [
                "TextMapContent",
                "ContentEN",
                "ContentJP",
                "ContentKR",
                "ContentFR",
                "ContentES",
                "ContentTC",
            ]:
                if fallback_field in text_entry and text_entry[fallback_field]:
                    content = text_entry[fallback_field]
                    break
        if "{空格}" in content:
            content = content.replace("{空格}", " ")
        return content or text_key

    def get_translated_dialogue(self, dialogue_key, language=""):
        """获取翻译后的对话文本

        Args:
            dialogue_key: 对话键
            language: 语言类型

        Returns:
            str: 翻译后的对话文本
        """
        # 获取当前语言
        language = language if language else self.data_loader.language

        # 语言映射：cn->TextMapContent, en->ContentEN, jp->ContentJP, kr->ContentKR, fr->ContentFR, tc->ContentTC
        language_field_map = {
            "cn": "TextMapContent",
            "en": "ContentEN",
            "jp": "ContentJP",
            "kr": "ContentKR",
            "fr": "ContentFR",
            "es": "ContentES",
            "tc": "ContentTC",
        }

        # 获取对应语言字段
        field = language_field_map.get(language, "TextMapContent")

        # 构建文件名
        filename = f"Dialogue_{field}.json"

        try:
            # 加载对话数据
            dialogue_data = self.data_loader.load_json(filename)
            # 查找对话键
            if dialogue_key in dialogue_data:
                return dialogue_data[dialogue_key]
            else:
                return dialogue_key
        except Exception as e:
            print(f"加载对话数据失败: {e}")
            return dialogue_key

    def round_value(self, value):
        """四舍五入到最多3位小数，等效于JS的 +num.toFixed(3)"""
        # 先四舍五入到3位小数
        rounded = round(value * 10000) / 10000
        # 如果结果是整数（如 3.0），返回整数
        if abs(rounded - round(rounded)) < 0.00001:
            return int(round(rounded))
        # 否则返回浮点数（自动去除末尾的0）
        return rounded

    def preprocess_expression(self, desc_value):
        """预处理表达式，将 $GText("...")$ 替换为翻译后的文本"""
        import re

        if not isinstance(desc_value, str):
            return desc_value

        result = desc_value

        # 替换所有 $GText("...")$ 为翻译后的文本
        def replace_gtext(match):
            text_key = match.group(1)
            translated = self.get_translated_text(text_key)
            return translated if translated else text_key

        result = re.sub(r'\$GText\("([^"]+)"\)\$', replace_gtext, result)

        return result

    def _calculate_expr_value(self, expr, table_id, level, table_type):
        """计算表达式值，使用AST解析和上下文跟踪

        Args:
            expr: 表达式字符串
            table_id: 当前项目ID（技能ID/武器ID/角色ID）
            level: 当前等级
            table_type: 表类型（用于SkillGrow查找）

        Returns:
            计算后的数值
        """
        from ast_parser import parse_ast

        try:
            ast = parse_ast(expr)
            # 初始化上下文
            context = {}
            if table_type:
                context["table_type"] = table_type
            if table_id:
                context["table_id"] = table_id

            result = self._evaluate_ast_node_with_context(ast, table_id, level, context)

            return float(result)
        except Exception as e:
            print(f"计算表达式 '{expr}' 失败: {e}", flush=True)
            import traceback

            traceback.print_exc()
            return 0.0

    def _evaluate_ast_node_with_context(
        self, node, table_id=None, level=1, context=None
    ):
        """使用上下文信息评估AST节点

        Args:
            node: AST节点
            table_id: 当前项目的ID
            level: 当前等级
            context: 上下文信息字典，包含 table_type 和 table_id

        Returns:
            评估后的值
        """
        from ast_parser import NodeType

        if context is None:
            context = {}

        if node.type == NodeType.LITERAL:
            # 字面量直接返回值
            return node.value

        elif node.type == NodeType.IDENTIFIER:
            # 标识符，返回其值
            return node.value

        elif node.type == NodeType.BINARY_EXPR:
            # 二元表达式

            # 评估左侧表达式（保留上下文）
            left_value = self._evaluate_ast_node_with_context(
                node.left, table_id, level, context
            )

            # 评估右侧表达式（同样使用相同上下文）
            right_value = self._evaluate_ast_node_with_context(
                node.right, table_id, level, context
            )

            # 如果左侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(left_value, str) and left_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": left_value,
                }

                left_value = self._calc_attr_by_level(attr, context_table_id, level)

            # 如果右侧是字符串且以#开头，使用SkillGrow查找
            if isinstance(right_value, str) and right_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": right_value,
                }

                right_value = self._calc_attr_by_level(attr, context_table_id, level)

            op = node.value
            if op == "+":
                return left_value + right_value
            elif op == "-":
                return left_value - right_value
            elif op == "*":
                return left_value * right_value
            elif op == "/":
                return left_value / right_value if right_value != 0 else 0.0
            elif op == "%":
                return left_value % right_value
            else:
                raise ValueError(f"未知的运算符: {op}")

        elif node.type == NodeType.UNARY_EXPR:
            # 一元表达式：如 -x
            operand_value = self._evaluate_ast_node_with_context(
                node.operand, table_id, level, context
            )

            # 如果操作数是字符串且以#开头，使用SkillGrow查找
            if isinstance(operand_value, str) and operand_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": operand_value,
                }

                operand_value = self._calc_attr_by_level(attr, context_table_id, level)

            op = node.value
            if op == "-":
                # 一元减号
                return -operand_value
            elif op == "+":
                # 一元加号，直接返回操作数
                return operand_value
            else:
                raise ValueError(f"未知的一元运算符: {op}")

        elif node.type == NodeType.MEMBER_ACCESS:
            # 成员访问: object.property

            try:
                object_value = self._evaluate_ast_node_with_context(
                    node.object, table_id, level, context
                )
            except Exception as e:
                print(f"DEBUG MEMBER_ACCESS: Exception evaluating object: {e}")
                raise e

            property_name = node.property.value

            # 如果object_value是字典，访问属性
            if isinstance(object_value, dict):
                if property_name in object_value:
                    value = object_value[property_name]

                    # 如果值是字符串且以#开头，使用SkillGrow查找
                    if isinstance(value, str) and value.startswith("#"):
                        # 使用上下文信息进行SkillGrow查找
                        table_type = context.get("table_type", "Skill")
                        context_table_id = context.get("table_id", table_id)

                        # 构建attr对象用于SkillGrow查找
                        # 检查attr中是否有Rate字段，如果有则使用Rate，否则使用Value
                        attr_key = None
                        if hasattr(object_value, "get"):
                            # 检查object的父级是否有Rate或Value字段
                            for key in object_value.keys():
                                if key == "Rate":
                                    attr_key = "Rate"
                                    break
                                elif key == "Value" and attr_key != "Rate":
                                    attr_key = "Value"
                        if not attr_key:
                            attr_key = "Rate" if "Rate" in property_name else "Value"

                        attr = {
                            "Type": table_type,
                            attr_key: value,
                        }
                        # 调用_calc_attr_by_level获取实际值
                        result = self._calc_attr_by_level(attr, context_table_id, level)
                        return result
                    else:
                        return value
                else:
                    # 属性不存在时返回 0
                    return 0.0
            else:
                return 0.0

        elif node.type == NodeType.INDEX_ACCESS:
            # 索引访问: object[index]
            object_value = self._evaluate_ast_node_with_context(
                node.object, table_id, level, context
            )
            index_value = self._evaluate_ast_node_with_context(
                node.index, table_id, level, context
            )

            # 如果object_value是字符串，可能是表名
            if isinstance(object_value, str):
                # 移除#前缀（如果有）
                table_name = object_value.lstrip("#")
                table_data = self.data_loader.load_json(f"{table_name}.json")
                if not table_data:
                    raise ValueError(f"无法找到表 '{table_name}'")

                # 使用index_value作为ID获取数据
                item_id = str(index_value)
                if item_id in table_data:
                    item_data = table_data[item_id]
                    # 更新上下文，记录表类型和ID
                    context["table_type"] = table_name
                    context["table_id"] = index_value
                    return item_data
                else:
                    # 尝试使用整数ID
                    int_id = int(index_value)
                    if str(int_id) in table_data:
                        item_data = table_data[str(int_id)]
                        context["table_type"] = table_name
                        context["table_id"] = int_id
                        return item_data
                    else:
                        raise ValueError(f"表 '{table_name}' 中找不到ID '{item_id}'")

            # 如果object_value是字典，可能是访问嵌套字段
            elif isinstance(object_value, dict):
                # 尝试作为数组索引（转换为0-based）
                if isinstance(index_value, int):
                    adjusted_index = index_value - 1
                    keys = list(object_value.keys())
                    if 0 <= adjusted_index < len(keys):
                        key = keys[adjusted_index]
                        return object_value[key]
                    # else:
                    #     raise ValueError(f"数组索引超出范围: {index_value}")
                # 尝试作为键直接访问
                index_str = str(index_value)
                if index_str in object_value:
                    return object_value[index_str]
                else:
                    raise ValueError(f"字典中找不到键: {index_str}")

            elif isinstance(object_value, list):
                # 列表索引（转换为0-based）
                if isinstance(index_value, int):
                    adjusted_index = max(0, index_value - 1)
                    if 0 <= adjusted_index < len(object_value):
                        return object_value[adjusted_index]
                    else:
                        raise ValueError(f"列表索引超出范围: {index_value}")
                else:
                    raise ValueError(f"列表索引必须是整数: {index_value}")

            else:
                raise ValueError(f"无法对类型 {type(object_value)} 进行索引访问")

        elif node.type == NodeType.UNARY_EXPR:
            # 一元表达式：如 -x
            operand_value = self._evaluate_ast_node_with_context(
                node.operand, table_id, level, context
            )

            # 如果操作数是字符串且以#开头，使用SkillGrow查找
            if isinstance(operand_value, str) and operand_value.startswith("#"):
                table_type = context.get("table_type", "Skill")
                context_table_id = context.get("table_id", table_id)

                attr = {
                    "Type": table_type,
                    "Value": operand_value,
                }

                operand_value = self._calc_attr_by_level(attr, context_table_id, level)

            op = node.value
            if op == "-":
                # 一元减号
                return -operand_value
            elif op == "+":
                # 一元加号，直接返回操作数
                return operand_value
            else:
                raise ValueError(f"未知的一元运算符: {op}")

        elif node.type == NodeType.FUNCTION_CALL:
            # 函数调用: func(args)
            func_name = None

            # 获取函数名
            if node.object.type == NodeType.IDENTIFIER:
                func_name = node.object.value
            elif node.object.type == NodeType.MEMBER_ACCESS:
                # 处理 math.abs 这样的函数调用
                module_obj = self._evaluate_ast_node_with_context(
                    node.object.object, table_id, level, context
                )
                func_name = node.object.property.value
                # 如果是 math 模块
                if isinstance(module_obj, str) and module_obj == "math":
                    func_name = f"math.{func_name}"
                else:
                    func_name = node.object.property.value

            # 计算所有参数的值
            args = []
            if node.arguments:
                for arg_node in node.arguments:
                    arg_value = self._evaluate_ast_node_with_context(
                        arg_node, table_id, level, context
                    )
                    args.append(arg_value)

            # 执行函数调用
            return self._execute_function(func_name, args)

        else:
            raise ValueError(f"未知的节点类型: {node.type}")

    def _execute_function(self, func_name, args):
        """执行函数调用"""
        import math

        try:
            # 数学函数
            if func_name == "math.abs":
                if len(args) >= 1:
                    return abs(float(args[0]))
            elif func_name == "math.floor":
                if len(args) >= 1:
                    return math.floor(float(args[0]))
            elif func_name == "math.ceil":
                if len(args) >= 1:
                    return math.ceil(float(args[0]))
            elif func_name == "math.sqrt":
                if len(args) >= 1:
                    return math.sqrt(float(args[0]))
            elif func_name == "math.max":
                if len(args) >= 2:
                    return max(float(args[0]), float(args[1]))
            elif func_name == "math.min":
                if len(args) >= 2:
                    return min(float(args[0]), float(args[1]))
            elif func_name == "max":
                if len(args) >= 2:
                    return max(float(args[0]), float(args[1]))
            elif func_name == "min":
                if len(args) >= 2:
                    return min(float(args[0]), float(args[1]))
            elif func_name == "abs":
                if len(args) >= 1:
                    return abs(float(args[0]))
        except (ValueError, TypeError):
            return 0.0

        return 0.0

    def _get_attr_value_from_dict(self, data, attr_path, table_id, level, table_type):
        """从字典中根据属性路径获取值"""
        import re

        # 处理计算部分
        calc_value = 1.0
        calc_operation = None

        # 检查是否包含乘法或除法
        if "*" in attr_path:
            attr_part, calc_part = attr_path.split("*", 1)
            calc_part = calc_part.replace("%", "")
            try:
                calc_value = float(calc_part)
                calc_operation = "*"
            except ValueError:
                return "0.0"
        elif "/" in attr_path:
            attr_part, calc_part = attr_path.split("/", 1)
            calc_part = calc_part.replace("%", "")
            try:
                calc_value = float(calc_part)
                calc_operation = "/"
            except ValueError:
                return "0.0"
        else:
            attr_part = attr_path

        # 解析属性路径
        parts = attr_part.split(".")
        value = data

        for part in parts:
            if value is None:
                return "0.0"

            # 检查是否包含数组索引
            array_match = re.match(r"(\w+)\[(.*?)\]", part)
            if array_match:
                array_name = array_match.group(1)
                array_content = array_match.group(2)

                # 获取数组
                if isinstance(value, dict) and array_name in value:
                    array = value[array_name]
                    if isinstance(array, list):
                        # 计算索引
                        try:
                            # 尝试解析索引
                            if array_content.isdigit():
                                array_index = int(array_content) - 1
                            else:
                                # 可能是表达式，递归计算
                                array_index = int(
                                    self._calculate_expr_value(
                                        array_content,
                                        table_id,
                                        level,
                                        table_type,
                                    )
                                )

                            if 0 <= array_index < len(array):
                                value = array[array_index]
                            else:
                                return "0.0"
                        except (ValueError, TypeError):
                            return "0.0"
                    else:
                        return "0.0"
                else:
                    return "0.0"
            else:
                # 普通属性访问
                if isinstance(value, dict) and part in value:
                    value = value[part]
                elif isinstance(value, list):
                    # 尝试在列表中查找
                    found = False
                    for item in value:
                        if isinstance(item, dict) and part in item:
                            value = item[part]
                            found = True
                            break
                    if not found:
                        return "0.0"
                else:
                    return "0.0"

        # 应用计算操作
        if calc_operation and value is not None:
            try:
                value_val = float(value)
                if calc_operation == "*":
                    value = value_val * calc_value
                elif calc_operation == "/":
                    value = value_val / calc_value if calc_value != 0 else 0.0
            except ValueError:
                return "0.0"

        return value

    def get_translated_dialogue(self, dialogue_key, language=""):
        """获取翻译后的对话文本

        Args:
            dialogue_key: 对话键值
            language: 语言代码，如 "cn", "en", "jp", "kr", "fr", "es", "tc"

        Returns:
            翻译后的对话文本，如果未找到则返回原键值
        """
        # 获取当前语言
        language = language if language else self.data_loader.language

        # 从预加载的缓存中获取对话数据
        lang_cache = self.dialogue_data_cache.get(language, {})
        dialogue_content = lang_cache.get(str(dialogue_key))

        if dialogue_content:
            # 如果是对话对象，返回 Content 字段
            if isinstance(dialogue_content, dict) and "Content" in dialogue_content:
                return dialogue_content["Content"]
            # 如果是字符串，直接返回
            elif isinstance(dialogue_content, str):
                return dialogue_content

        # 如果当前语言未找到，尝试使用中文作为 fallback
        if language != "cn":
            cn_cache = self.dialogue_data_cache.get("cn", {})
            cn_content = cn_cache.get(str(dialogue_key))
            if cn_content:
                if isinstance(cn_content, dict) and "Content" in cn_content:
                    return cn_content["Content"]
                elif isinstance(cn_content, str):
                    return cn_content

        return dialogue_key

    def _calc_attr_by_level(self, attr, table_id, level):
        """根据等级计算属性值（基类方法，子类可以覆盖）"""
        # 检查是否是Rate属性
        is_rate = "Rate" in attr
        base = attr.get("Rate" if is_rate else "Value")

        # 处理LevelGrow
        level_grow = attr.get("LevelGrow")
        if level_grow is None:
            level_grow = 0

        try:
            # 尝试将base转换为数值
            if isinstance(base, str):
                if base.startswith("#"):
                    # 对于字符串类型的数值，如"#1"，使用SkillGrow配置来计算
                    grow_index = int(base.strip("#"))
                    grow_type = attr.get("Type", "Skill")

                    # 获取skill_grow_data - 子类需要提供此属性
                    if not hasattr(self, "skill_grow_data"):
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_data = self.skill_grow_data

                    # 检查grow_type是否存在于skill_grow_data中
                    if grow_type not in skill_grow_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    skill_grow_type_data = skill_grow_data[grow_type]
                    id_key = str(table_id)

                    # 检查id_key是否存在于skill_grow_type_data中
                    if id_key not in skill_grow_type_data:
                        try:
                            base_num = float(base)
                            level_grow_num = float(level_grow)
                            value = base_num + level_grow_num * (level - 1)
                            return value
                        except (ValueError, TypeError):
                            return 0.0

                    id_data = skill_grow_type_data[id_key]
                    level_index = level - 1

                    if level_index < 0 or level_index >= len(id_data):
                        level_index = len(id_data) - 1

                    level_data = id_data[level_index]

                    # 查找匹配的Index
                    found_value = None

                    if isinstance(level_data, list):
                        for attr_entry in level_data:
                            if isinstance(attr_entry, dict):
                                # Check if grow_index (as string) is a key in dict (actual format)
                                # or if Index property equals grow_index (old format)
                                if str(grow_index) in attr_entry:
                                    found_value = attr_entry[str(grow_index)].get(
                                        "Value"
                                    )
                                    break
                                elif (
                                    "Index" in attr_entry
                                    and attr_entry["Index"] == grow_index
                                ):
                                    found_value = attr_entry["Value"]
                                    break
                                # Also check if grow_index (as string) is a key in the dict
                                elif str(grow_index) in attr_entry:
                                    found_value = attr_entry[str(grow_index)].get(
                                        "Value"
                                    )
                                    break
                    elif isinstance(level_data, dict):
                        if "Index" in level_data and level_data["Index"] == grow_index:
                            found_value = level_data["Value"]
                        elif str(grow_index) in level_data:
                            found_value = level_data[str(grow_index)].get("Value")

                    if found_value is not None:
                        return found_value
                    else:
                        return 0.0
                else:
                    # 对于其他字符串类型的数值，直接转换为float
                    base_num = float(base)
                    level_grow_num = float(level_grow)
                    value = base_num + level_grow_num * (level - 1)
                    return value

            # 处理数值类型的base
            base_num = float(base)
            level_grow_num = float(level_grow)
            value = base_num + level_grow_num * (level - 1)

            return value
        except (ValueError, TypeError, KeyError, AttributeError, IndexError) as e:
            return 0.0

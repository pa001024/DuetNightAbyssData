from processor.base_processor import BaseProcessor

v100ids = set(
    [
        20101,
        20102,
        20103,
        20104,
        20105,
        100101,
        100102,
        100103,
        101001,
        101002,
        101003,
        101101,
        101102,
        101103,
        101201,
        101202,
        101203,
        101301,
        101302,
        101303,
        101401,
        101402,
        101403,
        101501,
        101502,
        101503,
        101601,
        101602,
        101603,
        101701,
        101702,
        101703,
        101801,
        101802,
        101803,
        102101,
        102102,
        102103,
        102201,
        102202,
        102203,
        102301,
        102302,
        102303,
        200101,
        200102,
        200103,
        200201,
        200202,
        200203,
        200301,
        200302,
        200303,
        200401,
        200402,
        200403,
        200501,
        200502,
        200503,
        200601,
        200602,
        200603,
        200701,
        200702,
        200703,
        200801,
        200802,
        200803,
        201101,
        201102,
        201103,
        201201,
        201202,
        201203,
        201301,
        201302,
        201303,
        201401,
        201402,
        201403,
        201501,
        201502,
        201503,
        201601,
        201602,
        201603,
        201701,
        201702,
        201703,
        201801,
        201802,
        201803,
        201804,
        201805,
        201806,
        201807,
        201808,
        201809,
        201810,
        201811,
        201812,
        201813,
        201814,
        201901,
        201902,
        201903,
        202101,
        202102,
        202103,
        202201,
        202202,
        202203,
        202301,
        202302,
        202303,
        202401,
        202402,
        202403,
        203101,
        203102,
        203103,
        203201,
        203202,
        203203,
        203301,
        203302,
        203303,
        300101,
        300102,
        300103,
        301101,
        301102,
        301103,
        301201,
        301202,
        301203,
        302101,
        302102,
        302103,
        303101,
        303102,
        303103,
        303201,
        303202,
        303203,
        303301,
        303302,
        303303,
        303401,
        303402,
        303403,
        303501,
        303502,
        303503,
        303601,
        303602,
        303603,
        304101,
        304102,
        304103,
        304201,
        304202,
        304203,
        304301,
        304302,
        304303,
        500101,
        500102,
        500103,
        500201,
        500202,
        500203,
        500301,
        500302,
        500303,
        500401,
        500402,
        500403,
        500501,
        500502,
        500503,
        501101,
        501201,
        501301,
        501401,
        501501,
        502201,
        502401,
        502501,
        502601,
        503101,
        503102,
        503103,
        503201,
        503202,
        503203,
        504101,
        504201,
        504301,
        504401,
        504501,
        505101,
        505201,
        505301,
        505401,
        505501,
        506201,
        506202,
        506203,
        506301,
        506302,
        506303,
        506401,
        506402,
        506403,
        507101,
        507201,
        507301,
        900001,
        900101,
        900201,
        900301,
        900401,
        910001,
        910101,
        910102,
        910201,
        910202,
        910301,
        910302,
        910401,
        910402,
        911101,
        911102,
        911201,
        911202,
        912101,
        912201,
        912301,
        920101,
        920102,
        920201,
        920202,
        920301,
        920302,
        920401,
        920402,
        920501,
        920502,
        920601,
        920602,
        920701,
        920702,
        930001,
        930002,
        940001,
        940101,
        940201,
        940301,
        940401,
        940501,
        940601,
        941101,
        941201,
        941301,
        941401,
        941501,
        941601,
        942101,
        942201,
        1010101,
        1010102,
        1010103,
        1010201,
        1010202,
        1010203,
        1010304,
        1010305,
        1010306,
        1010601,
        1010701,
        1010801,
        1012501,
        1012601,
        1020101,
        1020102,
        1020103,
        1020201,
        1020202,
        1020203,
        1021001,
        1021002,
        1030101,
        1030102,
        1030103,
        1035101,
        1035102,
        1035103,
        1035201,
        1035202,
        1035203,
        3010101,
        3010102,
        3010103,
        3010104,
        3010105,
        3030101,
        3030201,
        3030301,
        3030401,
        3040101,
        3040102,
        3050101,
        3050201,
        4010101,
        4010102,
        4010103,
        4020101,
        4020102,
        4020103,
        4030101,
        4030102,
        4030103,
        4060101,
        4060102,
        4060103,
        5011901,
        5012001,
        5012101,
        5012401,
        5012402,
        5012403,
        5013401,
        5040101,
        5090101,
        5090201,
        5090301,
        5090401,
        5090501,
        5090601,
        5090701,
        5090801,
        5090901,
        5091001,
        5092001,
        5092101,
        5092201,
        5092301,
        5092401,
        5092501,
        5092601,
        5092701,
        5092801,
        5092901,
        5093001,
        5093101,
        5130101,
        5150101,
        5160101,
        5170101,
        5180101,
        5190101,
        5200101,
        5210101,
        5220101,
        5230101,
        5250101,
        5260101,
        5270101,
        6010101,
        6010102,
        6010103,
        6020101,
        6020201,
        6020202,
        6040101,
        6040102,
        6040103,
        6050101,
        6060101,
        6060102,
        6060103,
        6070101,
        6080101,
        6080102,
        6080103,
        7010101,
        7010201,
        7010501,
        7010601,
        7010701,
        7010801,
        7010901,
        7011001,
        7011101,
        7011201,
        7011301,
        7011401,
        7011501,
        7011601,
        7011701,
        7011801,
        7011901,
        7012001,
        7012101,
        7012201,
        7012301,
        7012401,
        7012501,
        7012601,
        7013101,
        7013201,
        7013301,
        7013401,
        7013501,
        7013601,
        7013701,
        7013801,
        7013901,
        7014001,
        7014101,
        8010101,
        8010102,
        9010401,
        9010402,
        9010403,
        9010501,
        9010502,
        9010503,
        9910101,
        9910201,
        9910301,
        9910401,
        9910501,
        9910601,
        10010101,
        10010102,
        10010103,
        10100101,
        10100201,
        10100301,
        20010101,
        20010102,
        20010103,
        20030101,
        20030102,
        20030103,
        20030104,
        20030105,
        20030106,
        20030107,
        30010101,
        30010102,
        30010103,
        50100101,
        50100201,
        50100301,
        50100401,
        50130101,
        50130102,
        50130103,
        50130104,
        50131701,
        50131702,
        50131703,
        50131901,
        50131902,
        50131903,
        50510101,
        50510102,
        50510103,
        52000101,
        52000201,
        52000301,
        52000401,
        52000501,
        52010001,
        107030501,
        140010101,
        140010102,
        140010103,
        140020101,
        140020102,
        140020103,
        140030101,
        140030201,
        140030301,
        150010101,
        150010201,
        150010202,
        150010203,
        150010301,
        150010401,
        150010501,
        150010601,
        150010701,
        150010801,
        160010101,
        160010102,
        160010103,
        170010101,
        170010102,
        170010103,
        200010101,
        200010102,
        200010103,
        210010101,
        519001001,
        519001002,
        519001003,
        521001001,
        521002001,
        521003001,
        521004001,
        1005160101,
        1005160102,
        1005160103,
        1005160104,
        1005170101,
        1005170201,
    ]
)


class AchievementProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Achievement"

    def process_item(self, achievement_data, language):
        id = achievement_data.get("AchievementId", 0)
        processed = {
            "id": id,
            "名称": self.get_translated_text(
                achievement_data.get("AchievementName", "")
            ),
            "分类": self.data_loader.get_achievement_type_name(
                achievement_data.get("AchievementType", 0)
            ),
            "品质": achievement_data.get("AchievementRarity", 0),
            "描述": self._process_description(achievement_data),
            "版本": "1.0" if id in v100ids else "1.1",
            "奖励": self._process_reward(achievement_data, language),
        }
        return processed

    def _process_description(self, achievement_data):
        describe = self.get_translated_text(
            achievement_data.get("AchievementDescribe", "")
        )

        # 优先使用CompletionValue，如果不存在则使用TargetProgress，再不存在则使用1
        completion_value = achievement_data.get("CompletionValue")
        if completion_value is None:
            completion_value = achievement_data.get("TargetProgress", 1)

        # Replace <highlight>#1</> with the determined value
        processed = describe.replace("<highlight>#1</>", str(completion_value))
        processed = describe.replace("#1", str(completion_value))

        # 去除所有<highlight>标签
        processed = processed.replace("<highlight>", "").replace("</>", "")

        return processed

    def _process_reward(self, achievement_data, language):
        reward_id = achievement_data.get("AchievementReward", 0)

        if not reward_id:
            return {}

        # Get reward info from Reward.json
        reward = self.data_loader.load_json("Reward.json")

        # Check if reward_id exists in reward data
        if str(reward_id) not in reward:
            return {}

        reward_info = reward[str(reward_id)]

        # Initialize reward dictionary
        rewards = {}

        # Get all reward items from Id array
        reward_ids = reward_info.get("Id", [])
        reward_types = reward_info.get("Type", [])
        reward_counts = reward_info.get("Count", [])

        # Iterate through all reward items (using index)
        for i in range(len(reward_ids)):
            # Check if index is valid for all arrays
            if i >= len(reward_types) or i >= len(reward_counts):
                continue

            # Get item values using index
            item_id = reward_ids[i]
            item_type = reward_types[i]
            # 从二维数组中提取实际数量值
            item_count = reward_counts[i]
            if isinstance(item_count, list):
                # 如果是嵌套数组，获取第一个元素
                if item_count and isinstance(item_count[0], list):
                    # 如果是二维数组，获取第一个元素的第一个值
                    item_count = item_count[0][0] if item_count[0] else 1
                else:
                    # 如果是一维数组，获取第一个值
                    item_count = item_count[0] if item_count else 1
            # 确保数量是数值类型
            item_count = (
                int(item_count)
                if isinstance(item_count, (int, float, str)) and item_count
                else 1
            )

            # Skip if item_id or item_type is empty
            if not item_id or not item_type:
                continue

            # Process based on item type
            if item_type == "Resource":
                # Get resource name
                resource_name = self.data_loader.get_resource_name(item_id)
                if resource_name:
                    rewards[resource_name] = item_count
                else:
                    rewards[str(item_id)] = item_count
            elif item_type == "Draft":
                # Get draft info
                draft_info = self.data_loader.get_draft_info(item_id)
                product_type = draft_info.get("ProductType", "")
                product_id = draft_info.get("ProductId", 0)

                # 根据不同语言使用不同的图纸格式
                if language in ["cn", "tc"]:
                    # 中文/繁体中文：图纸: [名称]
                    if product_type == "Mod":
                        mod_name = self.data_loader.get_mod_name(product_id)
                        if mod_name:
                            rewards[f"图纸: {mod_name}"] = item_count
                    elif product_type == "Char":
                        char_name = self.data_loader.get_char_name(product_id)
                        if char_name:
                            rewards[f"图纸: {char_name}"] = item_count
                    elif product_type == "Weapon":
                        weapon_name = self.data_loader.get_weapon_name(product_id)
                        if weapon_name:
                            rewards[f"图纸: {weapon_name}"] = item_count
                    else:
                        rewards[f"图纸: {product_type}{product_id}"] = item_count
                else:
                    # 其他语言：Draft: [名称]
                    if product_type == "Mod":
                        mod_name = self.data_loader.get_mod_name(product_id)
                        if mod_name:
                            rewards[f"Draft: {mod_name}"] = item_count
                    elif product_type == "Char":
                        char_name = self.data_loader.get_char_name(product_id)
                        if char_name:
                            rewards[f"Draft: {char_name}"] = item_count
                    elif product_type == "Weapon":
                        weapon_name = self.data_loader.get_weapon_name(product_id)
                        if weapon_name:
                            rewards[f"Draft: {weapon_name}"] = item_count
                    else:
                        rewards[f"Draft: {product_type}{product_id}"] = item_count
            elif item_type == "Title":
                # Get title name
                title_name = self.data_loader.get_title_name(item_id)
                if title_name:
                    # 根据不同语言使用不同的称号格式
                    if language in ["cn", "tc"]:
                        # 中文/繁体中文：“称号名”称号
                        rewards[f"“{title_name}”称号"] = item_count
                    elif language == "jp":
                        # 日文：「称号名」称号
                        rewards[f"「{title_name}」称号"] = item_count
                    elif language == "kr":
                        # 韩文：[称号名] 칭호
                        rewards[f"{title_name} 칭호"] = item_count
                    else:
                        # 英文、德文、西班牙文、法文：Title: [称号名]
                        rewards[f"Title: {title_name}"] = item_count
                else:
                    # 称号名不存在时的默认格式
                    if language in ["cn", "tc", "jp", "kr"]:
                        rewards[f"称号-{item_id}"] = item_count
                    else:
                        rewards[f"Title-{item_id}"] = item_count
            elif item_type == "TitleFrame":
                # Get titleframe name
                titleframe_name = self.data_loader.get_titleframe_name(item_id)
                if titleframe_name:
                    # 根据不同语言使用不同的称号框格式
                    if language in ["cn", "tc"]:
                        # 中文/繁体中文："称号框名"样式
                        rewards[f"“{titleframe_name}”样式"] = item_count
                    elif language == "jp":
                        # 日文：「称号框名」スタイル
                        rewards[f"「{titleframe_name}」スタイル"] = item_count
                    elif language == "kr":
                        # 韩文：[称号框名] 스타일
                        rewards[f"{titleframe_name} 스타일"] = item_count
                    else:
                        # 英文、德文、西班牙文、法文：Title Frame: [称号框名] Style
                        rewards[f"Title Frame: {titleframe_name} Style"] = item_count
                else:
                    # 称号框名不存在时的默认格式
                    if language in ["cn", "tc", "jp", "kr"]:
                        rewards[f"样式-{item_id}"] = item_count
                    else:
                        rewards[f"Style-{item_id}"] = item_count
            elif item_type == "Reward":
                # Recursive processing for Reward type
                sub_rewards = self._process_reward(
                    {"AchievementReward": item_id}, language
                )
                rewards.update(sub_rewards)
            else:
                # 其他类型奖励的默认格式
                rewards[f"{item_type}-{item_id}"] = item_count

        return rewards

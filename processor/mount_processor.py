from processor.base_processor import BaseProcessor


class MountProcessor(BaseProcessor):
    def __init__(self, data_loader):
        super().__init__(data_loader)
        self.file_type = "Mount"

        # 加载相关数据表
        self.mount_data = data_loader.load_json("Mount.json")

    def process_item(self, mount_data, language):
        """处理单个 Mount 数据

        Args:
            mount_data: 原始 Mount 数据
            language: 语言类型

        Returns:
            处理后的 Mount 数据
        """
        mount_id = mount_data.get("MountId")
        name_key = mount_data.get("MountName")
        des_key = mount_data.get("MountDes")
        mount_icon = mount_data.get("MountIcon")
        resource_icon = mount_data.get("ResourceIcon")
        mount_rarity = mount_data.get("MountRarity")
        fly_license = mount_data.get("FlyLicense")
        sort_priority = mount_data.get("SortPriority")
        resource_id = mount_data.get("ResourceId")
        access_key = mount_data.get("AccessKey", [])

        # 获取翻译
        name = self.get_translated_text(name_key, language) if name_key else ""
        des = self.get_translated_text(des_key, language) if des_key else ""

        # 提取图标名称
        mount_icon_name = self._extract_icon_name(mount_icon)
        resource_icon_name = self._extract_icon_name(resource_icon)

        processed_mount = {
            "id": mount_id,
            "name": name,
            "des": des,
            "icon": mount_icon_name,
            "resourceIcon": resource_icon_name,
            "rarity": mount_rarity,
            "sort": sort_priority,
            "resourceId": resource_id
        }

        # 只添加非 null 值的字段
        if fly_license is not None:
            processed_mount["fly"] = fly_license
        if access_key:
            processed_mount["access"] = access_key

        return processed_mount

    def _extract_icon_name(self, icon_path):
        """提取图标路径中的图标名称

        Args:
            icon_path: 图标路径

        Returns:
            提取后的图标名称
        """
        if not icon_path:
            return ""

        # 提取图标名称
        import re
        match = re.search(r'T_([^.]+)\.', icon_path)
        if match:
            return match.group(1)
        return ""

    def process_all_items(self, items, language):
        """处理所有 Mount 数据

        Args:
            items: Mount 数据列表
            language: 语言类型

        Returns:
            处理后的 Mount 数据列表
        """
        processed_items = []
        for item in items:
            processed = self.process_item(item, language)
            if processed:
                processed_items.append(processed)

        # 按 SortPriority 排序
        processed_items.sort(key=lambda x: x.get("sort", 0))

        return processed_items
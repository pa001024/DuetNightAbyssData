import argparse
import json
import math
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Tuple

from PIL import Image, ImageDraw


@dataclass
class PointItem:
    point_id: int
    sub_region: int
    region_id: int
    world_x: float
    world_y: float


@dataclass
class RegionImageTask:
    region_id: int
    region_name: str
    image_path: Path
    points: List[PointItem]
    center_x: float
    center_y: float
    rotation_deg: float
    fit_world_points: List[Tuple[float, float]]


def _load_json_dict(path: Path) -> Dict:
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise SystemExit(f"JSON 顶层不是对象: {path}")
    return data


def _extract_map_image_rel(region_item: dict) -> Optional[Path]:
    """
    解析 RegionMapImage 路径到 out/region_map_merged 相对路径。
    例如:
    /Game/UI/WBP/Map/Widget/RegionMap/East/WBP_Map_Reg_East_Yanjindu.WBP_Map_Reg_East_Yanjindu
    -> East/WBP_Map_Reg_East_Yanjindu.png
    """
    raw = region_item.get("RegionMapImage")
    if not isinstance(raw, str) or not raw:
        return None
    marker = "/Game/UI/WBP/Map/Widget/RegionMap/"
    if marker not in raw:
        return None
    rel = raw.split(marker, 1)[1]
    rel = rel.split(".", 1)[0]
    return Path(rel).with_suffix(".png")


def _build_tasks(
    region_point_data: Dict,
    sub_region_data: Dict,
    region_data: Dict,
    map_root: Path,
    region_door_data: Optional[Dict] = None,
) -> List[RegionImageTask]:
    points_by_region: Dict[int, List[PointItem]] = {}
    for point_key, point_value in region_point_data.items():
        if not isinstance(point_value, dict):
            continue
        pos = point_value.get("Pos")
        sub_region_id = point_value.get("SubRegion")
        point_id = point_value.get("Id")
        if (
            not isinstance(pos, list)
            or len(pos) < 2
            or not isinstance(sub_region_id, int)
            or not isinstance(point_id, int)
        ):
            continue

        sub_item = sub_region_data.get(str(sub_region_id))
        if not isinstance(sub_item, dict):
            continue
        region_id = sub_item.get("RegionId")
        if not isinstance(region_id, int):
            continue

        item = PointItem(
            point_id=point_id,
            sub_region=sub_region_id,
            region_id=region_id,
            world_x=float(pos[0]),
            world_y=float(pos[1]),
        )
        points_by_region.setdefault(region_id, []).append(item)

    fit_points_by_region: Dict[int, List[Tuple[float, float]]] = {}
    for region_id, points in points_by_region.items():
        fit_points_by_region[region_id] = [(p.world_x, p.world_y) for p in points]

    if isinstance(region_door_data, dict):
        for _, door_value in region_door_data.items():
            if not isinstance(door_value, dict):
                continue
            sub_region_id = door_value.get("DoorSubRegion")
            door_pos = door_value.get("DoorPos")
            if (
                not isinstance(sub_region_id, int)
                or not isinstance(door_pos, list)
                or len(door_pos) < 2
            ):
                continue
            sub_item = sub_region_data.get(str(sub_region_id))
            if not isinstance(sub_item, dict):
                continue
            region_id = sub_item.get("RegionId")
            if not isinstance(region_id, int):
                continue
            fit_points_by_region.setdefault(region_id, []).append((float(door_pos[0]), float(door_pos[1])))

    tasks: List[RegionImageTask] = []
    for region_id, points in points_by_region.items():
        region_item = region_data.get(str(region_id))
        if not isinstance(region_item, dict):
            continue
        image_rel = _extract_map_image_rel(region_item)
        if image_rel is None:
            continue
        image_path = map_root / image_rel
        if not image_path.is_file():
            continue

        center = region_item.get("RegionMapImageCenter")
        if isinstance(center, list) and len(center) >= 2:
            center_x = float(center[0])
            center_y = float(center[1])
        else:
            center_x = sum(p.world_x for p in points) / max(1, len(points))
            center_y = sum(p.world_y for p in points) / max(1, len(points))

        rotation_deg = float(region_item.get("RegionRotation", 0.0) or 0.0)
        region_name = str(region_item.get("RegionName", region_id))

        tasks.append(
            RegionImageTask(
                region_id=region_id,
                region_name=region_name,
                image_path=image_path,
                points=points,
                center_x=center_x,
                center_y=center_y,
                rotation_deg=rotation_deg,
                fit_world_points=fit_points_by_region.get(region_id, [(p.world_x, p.world_y) for p in points]),
            )
        )
    return tasks


def _rotate_xy(x: float, y: float, deg: float) -> Tuple[float, float]:
    rad = math.radians(deg)
    cs = math.cos(rad)
    sn = math.sin(rad)
    return cs * x - sn * y, sn * x + cs * y


def _project_points(
    points: List[PointItem],
    fit_world_points: List[Tuple[float, float]],
    center_x: float,
    center_y: float,
    point_rotation_deg: float,
    image_size: Tuple[int, int],
    margin: int,
    units_per_pixel: Optional[float],
    fit_fill_ratio: float,
    invert_y: bool,
) -> Tuple[List[Tuple[PointItem, float, float]], float]:
    theta = point_rotation_deg

    rotated: List[Tuple[PointItem, float, float]] = []
    for point in points:
        dx = point.world_x - center_x
        dy = point.world_y - center_y
        rx, ry = _rotate_xy(dx, dy, theta)
        rotated.append((point, rx, ry))

    fit_rotated: List[Tuple[float, float]] = []
    for wx, wy in fit_world_points:
        dx = float(wx) - center_x
        dy = float(wy) - center_y
        rx, ry = _rotate_xy(dx, dy, theta)
        fit_rotated.append((rx, ry))

    width, height = image_size
    avail_w = max(1.0, float(width - 2 * margin))
    avail_h = max(1.0, float(height - 2 * margin))

    if units_per_pixel is None:
        if len(fit_rotated) <= 1:
            upp = 100.0
        else:
            xs = [p[0] for p in fit_rotated]
            ys = [p[1] for p in fit_rotated]
            span_x = max(xs) - min(xs)
            span_y = max(ys) - min(ys)
            ratio = max(1e-3, min(float(fit_fill_ratio), 1.0))
            upp_x = span_x / (avail_w * ratio) if span_x > 0 else 1.0
            upp_y = span_y / (avail_h * ratio) if span_y > 0 else 1.0
            upp = max(upp_x, upp_y, 1e-6)
    else:
        upp = max(float(units_per_pixel), 1e-6)

    cx = width / 2.0
    cy = height / 2.0
    projected: List[Tuple[PointItem, float, float]] = []
    for point, rx, ry in rotated:
        px = cx + rx / upp
        py = cy - ry / upp if invert_y else cy + ry / upp
        projected.append((point, px, py))
    return projected, upp


def _rotate_points_in_image_space(
    points: List[Tuple[PointItem, float, float]],
    src_size: Tuple[int, int],
    dst_size: Tuple[int, int],
    angle_deg: float,
) -> List[Tuple[PointItem, float, float]]:
    src_cx = src_size[0] / 2.0
    src_cy = src_size[1] / 2.0
    dst_cx = dst_size[0] / 2.0
    dst_cy = dst_size[1] / 2.0
    cs = math.cos(math.radians(angle_deg))
    sn = math.sin(math.radians(angle_deg))

    result: List[Tuple[PointItem, float, float]] = []
    for item, px, py in points:
        dx = px - src_cx
        dy = py - src_cy
        rx = cs * dx - sn * dy
        ry = sn * dx + cs * dy
        result.append((item, dst_cx + rx, dst_cy + ry))
    return result


def _draw_region(
    task: RegionImageTask,
    output_path: Path,
    margin: int,
    box_size: int,
    units_per_pixel: Optional[float],
    point_rotation_deg: float,
    render_map_rotation: bool,
    map_rotation_deg: float,
    fit_fill_ratio: float,
    invert_y: bool,
) -> Dict:
    with Image.open(task.image_path).convert("RGBA") as image:
        projected, upp = _project_points(
            points=task.points,
            fit_world_points=task.fit_world_points,
            center_x=task.center_x,
            center_y=task.center_y,
            point_rotation_deg=point_rotation_deg,
            image_size=image.size,
            margin=margin,
            units_per_pixel=units_per_pixel,
            fit_fill_ratio=fit_fill_ratio,
            invert_y=invert_y,
        )

        src_size = image.size
        if render_map_rotation and abs(map_rotation_deg) > 1e-6:
            rotated_image = image.rotate(map_rotation_deg, expand=True, resample=Image.Resampling.BILINEAR)
            # projected 已经包含 point_rotation_deg。把“地图实际旋转”与“点位已应用旋转”做差，避免双重旋转。
            extra_point_rotation = map_rotation_deg - point_rotation_deg
            projected = _rotate_points_in_image_space(
                points=projected,
                src_size=src_size,
                dst_size=rotated_image.size,
                angle_deg=extra_point_rotation,
            )
            image = rotated_image

        draw = ImageDraw.Draw(image)

        half = box_size / 2.0
        color = (255, 64, 64, 230)
        text_color = (255, 240, 120, 255)
        point_items = []
        for point, px, py in projected:
            draw.rectangle(
                (px - half, py - half, px + half, py + half),
                outline=color,
                width=2,
            )
            draw.text((px + half + 2, py - half), str(point.point_id), fill=text_color)
            point_items.append(
                {
                    "point_id": point.point_id,
                    "sub_region": point.sub_region,
                    "world_pos": [point.world_x, point.world_y],
                    "image_pos": [round(px, 2), round(py, 2)],
                }
            )

        output_path.parent.mkdir(parents=True, exist_ok=True)
        image.save(output_path)

        return {
            "region_id": task.region_id,
            "region_name": task.region_name,
            "image": str(task.image_path),
            "output": str(output_path),
            "rotation_deg": task.rotation_deg,
            "map_rotation_deg": map_rotation_deg,
            "point_rotation_deg": point_rotation_deg,
            "center": [task.center_x, task.center_y],
            "units_per_pixel": upp,
            "point_count": len(point_items),
            "points": point_items,
        }


def main() -> None:
    parser = argparse.ArgumentParser(description="测试 RegionPoint 坐标映射到地图图片坐标并绘制方框")
    parser.add_argument("--region-point", default="out/RegionPoint.json", help="RegionPoint.json 路径")
    parser.add_argument("--sub-region", default="out/SubRegion.json", help="SubRegion.json 路径")
    parser.add_argument("--region", default="out/Region.json", help="Region.json 路径")
    parser.add_argument("--map-root", default="out/region_map_merged", help="已合成地图图片目录")
    parser.add_argument("--output-root", default="out/region_point_overlay", help="输出图片目录")
    parser.add_argument("--meta-out", default="out/region_point_overlay/projection_meta.json", help="输出投影元数据")
    parser.add_argument("--margin", type=int, default=64, help="自动拟合时的边距像素")
    parser.add_argument("--box-size", type=int, default=22, help="方框边长像素")
    parser.add_argument(
        "--units-per-pixel",
        type=float,
        default=30.0,
        help="固定世界坐标到像素比例（世界单位/像素）。默认 30（对应 Scale=1/30）",
    )
    parser.add_argument("--fit-fill-ratio", type=float, default=0.55, help="自动拟合时点集占据画布可用区域比例（0~1）")
    parser.add_argument("--region-door", default="out/RegionDoor.json", help="可选：RegionDoor.json，用于增强自动缩放拟合")
    parser.add_argument(
        "--render-map-rotation",
        action=argparse.BooleanOptionalAction,
        default=True,
        help="直接旋转地图图像后再绘制点位（默认开启，可用 --no-render-map-rotation 关闭）",
    )
    parser.add_argument(
        "--map-rotation-sign",
        choices=["neg", "pos"],
        default="pos",
        help="地图旋转方向：pos=+RegionRotation, neg=-RegionRotation",
    )
    parser.add_argument(
        "--point-rotation-mode",
        choices=["none", "same_as_map", "neg_map"],
        default="same_as_map",
        help="点位旋转模式：none, same_as_map(默认), neg_map",
    )
    parser.add_argument(
        "--invert-y",
        action=argparse.BooleanOptionalAction,
        default=False,
        help="世界坐标Y轴是否映射为屏幕向上（默认关闭，可用 --invert-y 开启）",
    )
    parser.add_argument("--region-id", type=int, default=0, help="只绘制指定 RegionId（0 表示全部）")

    args = parser.parse_args()

    region_point_path = Path(args.region_point)
    sub_region_path = Path(args.sub_region)
    region_path = Path(args.region)
    map_root = Path(args.map_root)
    output_root = Path(args.output_root)
    meta_out = Path(args.meta_out)

    if not region_point_path.is_file():
        raise SystemExit(f"文件不存在: {region_point_path}")
    if not sub_region_path.is_file():
        raise SystemExit(f"文件不存在: {sub_region_path}")
    if not region_path.is_file():
        raise SystemExit(f"文件不存在: {region_path}")
    if not map_root.is_dir():
        raise SystemExit(f"地图目录不存在: {map_root}")

    region_point_data = _load_json_dict(region_point_path)
    sub_region_data = _load_json_dict(sub_region_path)
    region_data = _load_json_dict(region_path)
    region_door_data = None
    region_door_path = Path(args.region_door)
    if region_door_path.is_file():
        region_door_data = _load_json_dict(region_door_path)

    tasks = _build_tasks(
        region_point_data=region_point_data,
        sub_region_data=sub_region_data,
        region_data=region_data,
        map_root=map_root,
        region_door_data=region_door_data,
    )
    if args.region_id > 0:
        tasks = [task for task in tasks if task.region_id == args.region_id]

    if not tasks:
        raise SystemExit("未找到可处理的 RegionMap 任务（请检查输入数据和地图图片输出）")

    meta_items = []
    for task in sorted(tasks, key=lambda item: item.region_id):
        map_sign = -1.0 if args.map_rotation_sign == "neg" else 1.0
        map_rotation_deg = map_sign * task.rotation_deg
        if args.point_rotation_mode == "none":
            point_rotation_deg = 0.0
        elif args.point_rotation_mode == "same_as_map":
            point_rotation_deg = map_rotation_deg
        else:
            point_rotation_deg = -map_rotation_deg

        out_name = f"{task.image_path.stem}_points.png"
        out_path = output_root / out_name
        meta = _draw_region(
            task=task,
            output_path=out_path,
            margin=args.margin,
            box_size=args.box_size,
            units_per_pixel=args.units_per_pixel,
            point_rotation_deg=point_rotation_deg,
            render_map_rotation=args.render_map_rotation,
            map_rotation_deg=map_rotation_deg,
            fit_fill_ratio=args.fit_fill_ratio,
            invert_y=args.invert_y,
        )
        meta_items.append(meta)
        print(
            f"[ OK ] region={task.region_id}  points={meta['point_count']}  scale={meta['units_per_pixel']:.4f}  out={out_path}",
            flush=True,
        )

    meta_out.parent.mkdir(parents=True, exist_ok=True)
    meta_out.write_text(
        json.dumps({"items": meta_items}, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )
    print(f"[INFO] 元数据已写入: {meta_out}", flush=True)


if __name__ == "__main__":
    main()

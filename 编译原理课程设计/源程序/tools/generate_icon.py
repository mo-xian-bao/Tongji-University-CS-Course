"""Generate the application PNG and multi-resolution ICO using only stdlib."""

from __future__ import annotations

from pathlib import Path
import struct
import zlib


MASTER_SIZE = 768
ICON_SIZES = (16, 24, 32, 48, 64, 128, 256)
PROJECT_ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = PROJECT_ROOT / "assets"


def blend_pixel(
    pixels: bytearray,
    size: int,
    x: int,
    y: int,
    color: tuple[int, int, int, int],
) -> None:
    if not (0 <= x < size and 0 <= y < size):
        return

    index = (y * size + x) * 4
    red, green, blue, alpha = color
    dst_alpha = pixels[index + 3]
    out_alpha = alpha + (dst_alpha * (255 - alpha) + 127) // 255
    if out_alpha == 0:
        return

    for offset, source in enumerate((red, green, blue)):
        dst = pixels[index + offset]
        numerator = source * alpha * 255 + dst * dst_alpha * (255 - alpha)
        pixels[index + offset] = (numerator + out_alpha * 127) // (out_alpha * 255)
    pixels[index + 3] = out_alpha


def rounded_contains(
    x: float,
    y: float,
    left: int,
    top: int,
    right: int,
    bottom: int,
    radius: int,
) -> bool:
    nearest_x = min(max(x, left + radius), right - radius)
    nearest_y = min(max(y, top + radius), bottom - radius)
    return (x - nearest_x) ** 2 + (y - nearest_y) ** 2 <= radius**2


def draw_capsule(
    pixels: bytearray,
    size: int,
    start: tuple[float, float],
    end: tuple[float, float],
    width: float,
    color: tuple[int, int, int, int],
) -> None:
    x1, y1 = start
    x2, y2 = end
    radius = width / 2
    min_x = max(0, int(min(x1, x2) - radius - 1))
    max_x = min(size - 1, int(max(x1, x2) + radius + 1))
    min_y = max(0, int(min(y1, y2) - radius - 1))
    max_y = min(size - 1, int(max(y1, y2) + radius + 1))
    dx = x2 - x1
    dy = y2 - y1
    length_squared = dx * dx + dy * dy

    for y in range(min_y, max_y + 1):
        for x in range(min_x, max_x + 1):
            projection = ((x - x1) * dx + (y - y1) * dy) / length_squared
            projection = min(1.0, max(0.0, projection))
            closest_x = x1 + projection * dx
            closest_y = y1 + projection * dy
            if (x - closest_x) ** 2 + (y - closest_y) ** 2 <= radius**2:
                blend_pixel(pixels, size, x, y, color)


def render_master() -> bytes:
    size = MASTER_SIZE
    pixels = bytearray(size * size * 4)
    outer = (34, 34, size - 35, size - 35, 150)
    inner = (44, 44, size - 45, size - 45, 140)

    for y in range(size):
        for x in range(size):
            if not rounded_contains(x + 0.5, y + 0.5, *outer):
                continue
            if not rounded_contains(x + 0.5, y + 0.5, *inner):
                blend_pixel(pixels, size, x, y, (222, 240, 255, 255))
                continue

            gradient = (0.40 * x + 0.60 * y) / (size - 1)
            red = round(77 + (6 - 77) * gradient)
            green = round(180 + (76 - 180) * gradient)
            blue = round(255 + (207 - 255) * gradient)
            highlight = max(0.0, 1.0 - ((x - 180) ** 2 + (y - 140) ** 2) ** 0.5 / 500)
            red = round(red + (255 - red) * 0.12 * highlight)
            green = round(green + (255 - green) * 0.12 * highlight)
            blue = round(blue + (255 - blue) * 0.12 * highlight)
            blend_pixel(pixels, size, x, y, (red, green, blue, 255))

    scale = size / 768
    strokes = (
        ((318 * scale, 264 * scale), (205 * scale, 384 * scale)),
        ((205 * scale, 384 * scale), (318 * scale, 504 * scale)),
        ((450 * scale, 264 * scale), (563 * scale, 384 * scale)),
        ((563 * scale, 384 * scale), (450 * scale, 504 * scale)),
        ((438 * scale, 220 * scale), (330 * scale, 548 * scale)),
    )
    width = 52 * scale

    for start, end in strokes:
        shadow_start = (start[0], start[1] + 10 * scale)
        shadow_end = (end[0], end[1] + 10 * scale)
        draw_capsule(pixels, size, shadow_start, shadow_end, width, (0, 42, 118, 86))
    for index, (start, end) in enumerate(strokes):
        color = (224, 246, 255, 255) if index == 4 else (255, 255, 255, 255)
        draw_capsule(pixels, size, start, end, width, color)

    return bytes(pixels)


def downsample_rgba(source: bytes, source_size: int, target_size: int) -> bytes:
    factor = source_size // target_size
    if factor * target_size != source_size:
        raise ValueError(f"{source_size} is not divisible by {target_size}")

    target = bytearray(target_size * target_size * 4)
    sample_count = factor * factor
    for target_y in range(target_size):
        for target_x in range(target_size):
            color_totals = [0, 0, 0]
            alpha_total = 0
            for source_y in range(target_y * factor, (target_y + 1) * factor):
                row_start = (source_y * source_size + target_x * factor) * 4
                for source_x in range(factor):
                    index = row_start + source_x * 4
                    alpha = source[index + 3]
                    alpha_total += alpha
                    for channel in range(3):
                        color_totals[channel] += source[index + channel] * alpha
            target_index = (target_y * target_size + target_x) * 4
            if alpha_total:
                for channel, total in enumerate(color_totals):
                    target[target_index + channel] = (total + alpha_total // 2) // alpha_total
            target[target_index + 3] = (alpha_total + sample_count // 2) // sample_count
    return bytes(target)


def png_chunk(kind: bytes, data: bytes) -> bytes:
    checksum = zlib.crc32(kind)
    checksum = zlib.crc32(data, checksum) & 0xFFFFFFFF
    return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", checksum)


def encode_png(pixels: bytes, size: int) -> bytes:
    stride = size * 4
    raw = b"".join(b"\x00" + pixels[row : row + stride] for row in range(0, len(pixels), stride))
    header = struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0)
    return (
        b"\x89PNG\r\n\x1a\n"
        + png_chunk(b"IHDR", header)
        + png_chunk(b"IDAT", zlib.compress(raw, level=9))
        + png_chunk(b"IEND", b"")
    )


def encode_ico(images: list[tuple[int, bytes]]) -> bytes:
    header = struct.pack("<HHH", 0, 1, len(images))
    offset = len(header) + 16 * len(images)
    entries = []
    payloads = []
    for size, payload in images:
        dimension = 0 if size == 256 else size
        entries.append(
            struct.pack("<BBBBHHII", dimension, dimension, 0, 0, 1, 32, len(payload), offset)
        )
        payloads.append(payload)
        offset += len(payload)
    return header + b"".join(entries) + b"".join(payloads)


def main() -> None:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    master = render_master()
    encoded = []
    for size in ICON_SIZES:
        rgba = downsample_rgba(master, MASTER_SIZE, size)
        encoded.append((size, encode_png(rgba, size)))

    png_path = ASSET_DIR / "compiler.png"
    ico_path = ASSET_DIR / "compiler.ico"
    png_path.write_bytes(dict(encoded)[256])
    ico_path.write_bytes(encode_ico(encoded))
    print(f"Generated {png_path} ({png_path.stat().st_size} bytes)")
    print(f"Generated {ico_path} ({ico_path.stat().st_size} bytes, {len(encoded)} sizes)")


if __name__ == "__main__":
    main()

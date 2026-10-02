#!/usr/bin/env python3
import os
from PIL import Image, ImageDraw

SRC_IMG = "/home/vboxuser/.gemini/antigravity-ide/brain/775b6fda-fc92-42de-a508-02bf7630bcc7/heaven_chrome_icon_1790974513001.jpg"

if not os.path.exists(SRC_IMG):
    print("Source image not found:", SRC_IMG)
    exit(1)

base_img = Image.open(SRC_IMG).convert("RGBA")

# Ensure directories
os.makedirs("assets", exist_ok=True)
os.makedirs("web", exist_ok=True)
os.makedirs("linux/assets", exist_ok=True)

# 1. Master Icon
master_512 = base_img.resize((512, 512), Image.Resampling.LANCZOS)
master_512.save("assets/icon.png", "PNG")
print("Saved assets/icon.png (512x512)")

# 2. Web Icons
base_img.resize((192, 192), Image.Resampling.LANCZOS).save("web/icon.png", "PNG")
base_img.resize((64, 64), Image.Resampling.LANCZOS).save("web/favicon.png", "PNG")
print("Saved web icons")

# 3. Linux & Steam Icon
base_img.resize((256, 256), Image.Resampling.LANCZOS).save("linux/assets/icon.png", "PNG")
print("Saved linux/assets/icon.png (256x256)")

# 4. Android Mipmap Icons
android_res = "android/app/src/main/res"
densities = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192
}

for folder, size in densities.items():
    dir_path = os.path.join(android_res, folder)
    os.makedirs(dir_path, exist_ok=True)
    
    # Standard square/rounded icon
    icon = base_img.resize((size, size), Image.Resampling.LANCZOS)
    icon.save(os.path.join(dir_path, "ic_launcher.png"), "PNG")
    
    # Circular round icon
    mask = Image.new("L", (size, size), 0)
    draw = ImageDraw.Draw(mask)
    draw.ellipse((0, 0, size - 1, size - 1), fill=255)
    round_icon = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    round_icon.paste(icon, (0, 0), mask)
    round_icon.save(os.path.join(dir_path, "ic_launcher_round.png"), "PNG")
    
    # Adaptive foreground icon (centered within adaptive bounds)
    fg_size = int(size * 0.72)
    fg_scaled = base_img.resize((fg_size, fg_size), Image.Resampling.LANCZOS)
    fg_icon = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    offset = (size - fg_size) // 2
    fg_icon.paste(fg_scaled, (offset, offset))
    fg_icon.save(os.path.join(dir_path, "ic_launcher_foreground.png"), "PNG")
    
    print(f"Generated Android {folder} ({size}x{size})")

print("All Android, Web, and Linux icons generated successfully!")

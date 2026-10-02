#!/usr/bin/env python3
import json

with open("tools/levels_data.json", "r") as f:
    all_20 = json.load(f)

# 1. Update src/game/levels.h
levels_h_content = """/* levels.h - Level data and management */

#ifndef LEVELS_H
#define LEVELS_H

#include <stdint.h>

#define LEVEL_COUNT    20
#define LEVEL_WIDTH    32
#define LEVEL_HEIGHT   24

/* Tile types */
#define TILE_EMPTY      0
#define TILE_WALL       1
#define TILE_PLATFORM   2
#define TILE_HAZARD     3
#define TILE_EXIT       4
#define TILE_PICKUP     5

void    level_load(uint8_t level_num);
void    level_draw(uint8_t level_num);
uint8_t level_check_collision(uint8_t x, uint8_t y);
uint8_t level_check_exit(uint8_t x, uint8_t y);
uint8_t level_get_tile(uint8_t x, uint8_t y);

#endif /* LEVELS_H */
"""

with open("src/game/levels.h", "w") as f:
    f.write(levels_h_content)
print("Updated src/game/levels.h with LEVEL_COUNT = 20")

# 2. Generate RLE data for each level
def rle_compress(grid):
    flat = []
    for row in grid:
        flat.extend(row)
    
    rle = []
    current_val = flat[0]
    count = 1
    for val in flat[1:]:
        if val == current_val and count < 255:
            count += 1
        else:
            rle.append((count, current_val))
            current_val = val
            count = 1
    rle.append((count, current_val))
    return rle

c_levels_code = []
c_level_pointers = []

for idx, lvl in enumerate(all_20):
    rle = rle_compress(lvl)
    bytes_list = []
    for (count, val) in rle:
        bytes_list.append(f"{count},{val}")
    bytes_list.append("0,0") # terminator
    
    # Format lines of ~16 entries
    lines = []
    chunk_size = 8
    for i in range(0, len(bytes_list), chunk_size):
        lines.append("    " + ", ".join(bytes_list[i:i+chunk_size]))
    
    body = ",\n".join(lines)
    c_levels_code.append(f"/* Level {idx+1} RLE Data */\nstatic const uint8_t level{idx+1}_rle[] = {{\n{body}\n}};\n")
    c_level_pointers.append(f"    level{idx+1}_rle")

c_source = f"""/* levels.c - Level data and management (20 Levels, RLE Compressed)
 *
 * Levels are stored as RLE compressed tile streams and decompressed
 * into a single 768-byte screen buffer on load to fit within 48K RAM.
 */

#include <stdint.h>
#include <arch/zx.h>
#include "levels.h"

extern void video_print_at(uint8_t row, uint8_t col, const char *str);
extern void sprite_draw(uint8_t x, uint8_t y, const uint8_t *data);

/* Wall tile graphic */
static const uint8_t tile_wall_gfx[] = {{
    0xFF, 0x81, 0xBD, 0xA5, 0xA5, 0xBD, 0x81, 0xFF
}};

/* Platform tile graphic (Cloud) */
static const uint8_t tile_platform_gfx[] = {{
    0x3C, 0x7E, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00
}};

/* Hazard tile graphic (Christian cross) */
static const uint8_t tile_hazard_gfx[] = {{
    0x18, 0x18, 0x7E, 0x7E, 0x18, 0x18, 0x18, 0x18
}};

/* Exit tile graphic (door) */
static const uint8_t tile_exit_gfx[] = {{
    0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E
}};

{"".join(c_levels_code)}
/* Array of level RLE data pointers */
static const uint8_t * const levels[LEVEL_COUNT] = {{
{",\n".join(c_level_pointers)}
}};

/* Active decompressed level map buffer (32 x 24 = 768 bytes) */
static uint8_t current_level_map[LEVEL_HEIGHT * LEVEL_WIDTH];

void level_load(uint8_t level_num)
{{
    const uint8_t *p;
    uint16_t idx = 0;

    if (level_num >= LEVEL_COUNT) {{
        return;
    }}

    p = levels[level_num];

    while (p[0] != 0 && idx < (LEVEL_HEIGHT * LEVEL_WIDTH)) {{
        uint8_t count = p[0];
        uint8_t tile = p[1];
        while (count > 0 && idx < (LEVEL_HEIGHT * LEVEL_WIDTH)) {{
            current_level_map[idx++] = tile;
            count--;
        }}
        p += 2;
    }}
}}

uint8_t level_get_tile(uint8_t x, uint8_t y)
{{
    if (x >= LEVEL_WIDTH || y >= LEVEL_HEIGHT) return TILE_WALL;
    return current_level_map[y * LEVEL_WIDTH + x];
}}

void level_draw(uint8_t level_num)
{{
    uint8_t x, y, tile;

    level_load(level_num);

    for (y = 0; y < LEVEL_HEIGHT; y++) {{
        for (x = 0; x < LEVEL_WIDTH; x++) {{
            tile = level_get_tile(x, y);
            switch (tile) {{
                case TILE_WALL:
                    sprite_draw(x, y, tile_wall_gfx);
                    break;
                case TILE_PLATFORM:
                    sprite_draw(x, y, tile_platform_gfx);
                    break;
                case TILE_HAZARD:
                    sprite_draw(x, y, tile_hazard_gfx);
                    break;
                case TILE_EXIT:
                    sprite_draw(x, y, tile_exit_gfx);
                    break;
                default:
                    break;
            }}
        }}
    }}
}}

uint8_t level_check_collision(uint8_t x, uint8_t y)
{{
    uint8_t tile = level_get_tile(x, y);
    return (tile == TILE_WALL || tile == TILE_HAZARD) ? 1 : 0;
}}

uint8_t level_check_exit(uint8_t x, uint8_t y)
{{
    return (level_get_tile(x, y) == TILE_EXIT) ? 1 : 0;
}}
"""

with open("src/game/levels.c", "w") as f:
    f.write(c_source)
print("Updated src/game/levels.c with 20 levels")

# 3. Update web/script.js
with open("web/script.js", "r") as f:
    js_content = f.read()

# Replace level data section in web/script.js
js_levels_str = "const levels = [\n"
for idx, lvl in enumerate(all_20):
    rows_str = ",\n    ".join([json.dumps(row) for row in lvl])
    js_levels_str += f"    // Level {idx+1}\n    [\n    {rows_str}\n    ]" + (",\n" if idx < len(all_20)-1 else "\n")
js_levels_str += "];\n"

# Find level data start and end in script.js
start_marker = "// Levels (32x24) - Matching original C code"
end_marker = "// Game State Enum"

start_pos = js_content.find(start_marker)
end_pos = js_content.find(end_marker)

if start_pos != -1 and end_pos != -1:
    new_js = js_content[:start_pos] + start_marker + "\n" + js_levels_str + "\n" + js_content[end_pos:]
    with open("web/script.js", "w") as f:
        f.write(new_js)
    print("Updated web/script.js with all 20 levels")
else:
    print("Could not find markers in web/script.js, please check manually.")

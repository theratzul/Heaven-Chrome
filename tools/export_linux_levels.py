#!/usr/bin/env python3
import json, os

os.makedirs('linux/src', exist_ok=True)
with open('tools/levels_data.json', 'r') as f:
    levels = json.load(f)

header = '''/* levels_data.h - All 20 Heavenly Realms for Linux C */
#ifndef LEVELS_DATA_H
#define LEVELS_DATA_H

#include <stdint.h>

#define LEVEL_COUNT   20
#define LEVEL_WIDTH   32
#define LEVEL_HEIGHT  24

#define TILE_EMPTY    0
#define TILE_WALL     1
#define TILE_PLATFORM 2
#define TILE_HAZARD   3
#define TILE_EXIT     4
#define TILE_ANGEL    5

static const uint8_t g_levels[LEVEL_COUNT][LEVEL_HEIGHT][LEVEL_WIDTH] = {
'''

for idx, lvl in enumerate(levels):
    header += f'    /* Realm {idx + 1} */\n    {{\n'
    for row in lvl:
        header += '        {' + ', '.join(str(c) for c in row) + '},\n'
    header += '    },\n'

header += '''};

#endif /* LEVELS_DATA_H */
'''

with open('linux/src/levels_data.h', 'w') as f:
    f.write(header)
print('Generated linux/src/levels_data.h successfully, size:', os.path.getsize('linux/src/levels_data.h'))

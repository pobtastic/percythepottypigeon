#!/usr/bin/env python3
import sys
import os
import argparse
from collections import OrderedDict

try:
    from skoolkit.snapshot import get_snapshot
    from skoolkit import tap2sna, sna2skool
except ImportError:
    SKOOLKIT_HOME = os.environ.get('SKOOLKIT_HOME')
    if not SKOOLKIT_HOME:
        sys.stderr.write('SKOOLKIT_HOME is not set; aborting\n')
        sys.exit(1)
    if not os.path.isdir(SKOOLKIT_HOME):
        sys.stderr.write('SKOOLKIT_HOME={}; directory not found\n'.format(SKOOLKIT_HOME))
        sys.exit(1)
    sys.path.insert(0, SKOOLKIT_HOME)
    from skoolkit.snapshot import get_snapshot
    from skoolkit import tap2sna, sna2skool

PERCY_HOME = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BUILD_DIR = '{}/sources'.format(PERCY_HOME)
PERCY_Z80 = '{}/PercythePottyPigeon.z80'.format(PERCY_HOME)

# Room 1 (and room 0 in game logic) both use data starting at $83A9; FindRoomData
# returns immediately for room 1, so the first block is at $83A9. No separate room 0 block.
ROOM_DATA_START = 0x83A9
MAX_ROOMS = 16  # Rooms 1..16 (room 0 uses same data as room 1, not a separate block)
DEFAULT_TILE_SET_BASE = 0x9BAA
BYTES_PER_TILE = 8

ROOM_TITLES = {
    1: 'Room #N$01',
    2: 'Room #N$02',
    3: 'Room #N$03',
    4: 'Room #N$04',
    5: 'Room #N$05',
    6: 'Room #N$06',
    7: 'Room #N$07',
    8: 'Room #N$08',
    9: 'Room #N$09',
    10: 'Room #N$0A',
    11: 'Room #N$0B',
    12: 'Room #N$0C: Title Screen',
    13: 'Room #N$0D: Level 2',
    14: 'Room #N$0E: Level 3',
    15: 'Room #N$0F: Level 4',
    16: 'Room #N$10: Level 5',
}

ROOM_LABELS = {
    12: 'Room12_TitleScreen',
    13: 'Room13_Level2',
    14: 'Room14_Level3',
    15: 'Room15_Level4',
    16: 'Room16_Level5',
}


def _label(room_id):
    return ROOM_LABELS.get(room_id, 'Room{:02d}'.format(room_id))


class Percy:
    def __init__(self, snapshot):
        self.snapshot = snapshot

    def _byte(self, addr):
        return self.snapshot[addr]

    def _tile_ref(self, addr):
        """Format Tile ID with link to tile graphic in default set (#R$base + (id-8)*8)."""
        tile_id = self._byte(addr)
        if tile_id >= 0x08:
            graphic_addr = DEFAULT_TILE_SET_BASE + (tile_id - BYTES_PER_TILE) * BYTES_PER_TILE
            return 'Tile ID: #R${:04X}(#N${:02X}).'.format(graphic_addr, tile_id)
        return 'Tile ID: #N(#PEEK(#PC)).'

    def _parse_room_block(self, start_addr, lines, room_id):
        """Parse room command stream."""
        addr = start_addr
        while True:
            cmd = self._byte(addr)
            if cmd == 0x00:
                lines.append('  ${:04X},$01 Terminator.'.format(addr))
                return addr + 1
            elif cmd == 0x01:
                # Skip tiles: next byte = skip count
                lines.append('N ${:04X} Command #N$01: Skip tiles.'.format(addr))
                lines.append('  ${:04X},$01 Command (#N$01).'.format(addr))
                lines.append('  ${:04X},$01 Skip count: #N(#PEEK(#PC)).'.format(addr + 1))
                addr += 2
            elif cmd == 0x02:
                # Draw repeated tile: next byte = repeat count, then tile ID
                lines.append('N ${:04X} Command #N$02: Draw repeated tile.'.format(addr))
                lines.append('  ${:04X},$01 Command (#N$02).'.format(addr))
                lines.append('  ${:04X},$01 Repeat count: #N(#PEEK(#PC)).'.format(addr + 1))
                lines.append('  ${:04X},$01 {}'.format(addr + 2, self._tile_ref(addr + 2)))
                addr += 3
            elif cmd == 0x03:
                # Fill attribute buffer: next byte = base colour, then overlay until $24
                lines.append('N ${:04X} Command #N$03: Fill attribute buffer.'.format(addr))
                lines.append('  ${:04X},$01 Command (#N$03).'.format(addr))
                lines.append('  ${:04X},$01 Base fill colour: #COLOUR(#PEEK(#PC)).'.format(addr + 1))
                addr += 2
                addr = self._parse_attribute_overlay(addr, lines)
            elif cmd == 0x04:
                # Switch tile set: next byte = tile set id (1=default, 2=alternate)
                lines.append('N ${:04X} Command #N$04: Switch tile set.'.format(addr))
                lines.append('  ${:04X},$01 Command (#N$04).'.format(addr))
                lines.append('  ${:04X},$01 Tile set: #N(#PEEK(#PC)) (#N$01=default, #N$02=alternate).'.format(addr + 1))
                addr += 2
            elif cmd >= 0x08:
                # Single tile: command byte is tile ID
                lines.append('  ${:04X},$01 {}'.format(addr, self._tile_ref(addr)))
                addr += 1
            else:
                # $05, $06, $07 undefined; treat as single byte
                lines.append('  ${:04X},$01 Command/ value: #N(#PEEK(#PC)).'.format(addr))
                addr += 1

    def _parse_attribute_overlay(self, addr, lines):
        """Parse attribute overlay until $24. Return address after $24."""
        while True:
            b = self._byte(addr)
            if b == 0x12:
                lines.append('N ${:04X} Attribute overlay: skip.'.format(addr))
                lines.append('  ${:04X},$01 Opcode (#N$12).'.format(addr))
                lines.append('  ${:04X},$01 Skip count: #N(#PEEK(#PC)).'.format(addr + 1))
                addr += 2
            elif b == 0x1B:
                lines.append('N ${:04X} Attribute overlay: repeat colour.'.format(addr))
                lines.append('  ${:04X},$01 Opcode (#N$1B).'.format(addr))
                lines.append('  ${:04X},$01 Repeat count: #N(#PEEK(#PC)).'.format(addr + 1))
                lines.append('  ${:04X},$01 Colour: #COLOUR(#PEEK(#PC)).'.format(addr + 2))
                addr += 3
            elif b == 0x24:
                lines.append('  ${:04X},$01 End of attribute overlay.'.format(addr))
                addr += 1
                return addr
            else:
                lines.append('  ${:04X},$01 Attribute cell: #COLOUR(#PEEK(#PC)).'.format(addr))
                addr += 1

    def get_room_data(self):
        lines = []

        block_start = ROOM_DATA_START
        for room_id in range(1, MAX_ROOMS + 1):
            title = ROOM_TITLES.get(room_id, 'Room #N${:02X}'.format(room_id))
            lines.append('b ${:04X} {}'.format(block_start, title))
            lines.append('@ ${:04X} label={}'.format(block_start, _label(room_id)))
            lines.append('D ${:04X} #ROOM${:02X}'.format(block_start, room_id))
            next_start = self._parse_room_block(block_start, lines, room_id)
            lines.append('')
            block_start = next_start

        return '\n'.join(lines)


def run(subcommand):
    if not os.path.isdir(BUILD_DIR):
        os.mkdir(BUILD_DIR)
    if not os.path.isfile(PERCY_Z80):
        tap2sna.main(('-d', BUILD_DIR, '@{}/percythepottypigeon.t2s'.format(PERCY_HOME)))
    percy = Percy(get_snapshot(PERCY_Z80))
    ctlfile = '{}/{}.ctl'.format(BUILD_DIR, subcommand)
    with open(ctlfile, 'wt') as f:
        f.write(getattr(percy, methods[subcommand][0])())


###############################################################################
# Begin
###############################################################################
methods = OrderedDict((
    ('room_data', ('get_room_data', 'Room data (annotated instructions from $83A9)')),
))
subcommands = '\n'.join('  {} - {}'.format(k, v[1]) for k, v in methods.items())
parser = argparse.ArgumentParser(
    usage='%(prog)s SUBCOMMAND',
    description='Produce a skool control file snippet for Percy the Potty Pigeon. '
                'SUBCOMMAND must be one of:\n\n{}'.format(subcommands),
    formatter_class=argparse.RawTextHelpFormatter,
    add_help=False
)
parser.add_argument('subcommand', help=argparse.SUPPRESS, nargs='?')
namespace, unknown_args = parser.parse_known_args()
if unknown_args or namespace.subcommand not in methods:
    parser.exit(2, parser.format_help())
run(namespace.subcommand)

; Copyright 1984 Gremlin Graphics Software Ltd, 2026 Urbanscan, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @rom
> $4000 @start
> $4000 @expand=#DEF(#POKE #LINK:Pokes)
> $4000 @expand=#DEF(#ANIMATE(delay,count=$50)(name=$a)*$name-1,$delay;#FOR$02,$count||x|$name-x|;||($name-animation))
> $4000 @expand=#DEF(#ROOM(id)#SIM(start=$5DD0,stop=$5DDD)#UDGTABLE { #POKES$5FC5,$id;$5FA1,$01#SIM(start=$65A3,stop=$65A6,sp=$5BFE)#SCR$02(room-$id) } TABLE#)
> $4000 @set-handle-unsupported-macros=1
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Percy the Potty Pigeon Loading Screen. } { #SCR$02(loading) } TABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

i $5B00

g $5BFE Stack
@ $5BFE label=Stack
D $5BFE Top of the stack (so, pushes below this point).
B $5BFE,$01

i $5BFF

c $5DC0 Game Initialise
@ $5DC0 label=Game_Initialise
  $5DC0,$01 Disable interrupts.
  $5DC1,$01 Set #REGa to #N$00 for clearing the flags below.
N $5DC2 Put the stack pointer somewhere safe.
  $5DC2,$03 #REGsp=#R$5BFE.
  $5DC5,$06 Write #N$00 to; #LIST
. { *#R$5FBC }
. { *#R$5FAA }
. LIST#
  $5DCB,$02 Set border to: #INK$00.
N $5DCD #HTML(Open channel #N$02 (upper screen) via <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>.)
  $5DCD,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>.)
N $5DD0 Clear the screen.
  $5DD0,$0D Clear the screen and attribute buffers by filling #N$1AFF bytes
. from #N$5AFE downwards with #N$00.
N $5DDD #HTML(Sets the border colour to use when calling
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0D6B.html">CLS</a>.)
  $5DDD,$05 #HTML(Write #INK$0F to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C48.html">BORDCR</a>.)
  $5DE2,$04 #REGix=#R$DAC0.
  $5DE6,$04 Write #N$00 to *#REGix+#N$23.
  $5DEA,$04 Write #INK$07 to *#REGix+#N$02 (#R$DAC2).
  $5DEE,$04 Write #N$FF to *#REGix+#N$22.
  $5DF2,$03 Call #R$653D.
  $5DF5,$05 Write #N$FF to *#R$5FBC.
N $5DFA Game pause input loop.
@ $5DFA label=Pause_InputLoop
  $5DFA,$03 Call #R$5FE9.
  $5DFD,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
  $5E01,$02,b$01 Keep only the bit which relates to the "S" key (bit 1).
  $5E03,$03 Call #R$6966 if the "S" key was pressed.
  $5E06,$03 Call #R$6992.
  $5E09,$02 No operation.
  $5E0B,$07 Write #N$00 to; #LIST
. { *#R$5FBB }
. { *#R$5FBD }
. LIST#
  $5E12,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$7F | SPACE | FULL-STOP | M | N | B }
. TABLE#
  $5E17,$03 Jump back to #R$5DFA if "SPACE" was not pressed.
N $5E1A The "SPACE" key has been pressed.
  $5E1A,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FE | SHIFT | Z | X | C | V }
. TABLE#
  $5E1E,$03 Jump back to #R$5DFA if "CAPS SHIFT" was not pressed.
N $5E21 Both "SPACE" and "CAPS SHIFT" were held down, so reset the game.
  $5E21,$01 Enable interrupts.
  $5E22,$02 Jump to #R$5DC0.

c $5E24 Populate Room Buffer
@ $5E24 label=PopulateRoomBuffer
D $5E24 Fetch the current room number and set up the default tile and attribute
. data pointers.
  $5E24,$03 Load #REGa with *#R$5FC5.
N $5E27 Initialise the room pointer/ default tile set.
  $5E27,$06 Write #R$83A9 to *#R$5FC3.
  $5E2D,$06 Write #R$9BAA to *#R$5FC1.
N $5E33 If this is not room #N$00, look up the correct room data pointer.
  $5E33,$04 Call #R$5FC6 if this is not room #N$00.
N $5E37 Clear the screen buffer at #R$C000.
  $5E37,$0D Clear #N$17FF bytes from #R$C000 onwards.
N $5E44 Initialise drawing state variables.
  $5E44,$05 Write #N$FF to *#R$5FBB.
  $5E49,$06 Write #N($00FF,$04,$04) to *#R$5FB9.
  $5E4F,$03 #REGde=#N$02C1.
N $5E52 The main room data parsing loop. Reads a command byte from the room
. data and dispatches to the appropriate handler based on its value.
  $5E52,$03 Fetch the *#R$5FC3 and store it in #REGhl.
@ $5E55 label=PopulateRoomBuffer_ParseByte
  $5E55,$01 Fetch the room data byte from the pointer.
  $5E56,$03 Jump to #R$5E6F if the room data byte is #N$00.
  $5E59,$04 Jump to #R$5E92 if the room data byte is #N$01.
  $5E5D,$04 Jump to #R$5EAA if the room data byte is #N$02.
  $5E61,$04 Jump to #R$5EDB if the room data byte is #N$03.
  $5E65,$04 Jump to #R$5E72 if the room data byte is #N$04.
  $5E69,$04 Jump to #R$5EC8 if the room data byte is #N$08 or higher.
N $5E6D If none of the above matched, trigger an error (with an arbitary error
. code).
@ $5E6D label=PopulateRoomBuffer_Error
  $5E6D,$01 #HTML(Run the ERROR_1 routine:
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0008.html">RST #N$08</a>.)
B $5E6E,$01 Error code: #N$04 ("Out of memory").
N $5E6F Command #N$00: no-op. Skip this byte and continue parsing.
@ $5E6F label=Command00_Skip
  $5E6F,$01 Increment the room data pointer by one.
  $5E70,$02 Jump to #R$5E55.

c $5E72 Command #N$04: Switch Tile Set
@ $5E72 label=Command04_SwitchTileSet
D $5E72 Command #N$04: Switch the tile set.
.
. The following byte selects which tile set to use; #N$01 for the default set
. at #R$9BAA, #N$02 for the alternate set at #R$A36A.
R $5E72 DE Tile counter
R $5E72 HL The room data pointer
  $5E72,$01 Increment the room data pointer by one.
  $5E73,$01 Fetch the tile set byte.
  $5E74,$01 Increment the room data pointer by one to move past the command
. byte.
  $5E75,$04 Jump to #R$5E88 if the tile set byte is equal to #N$01.
  $5E79,$05 Jump to #R$5FE7 if the tile set byte is not equal to #N$02.
N $5E7E Tile set #N$02: switch to the alternate tile set.
  $5E7E,$01 Stash the room data pointer on the stack temporarily.
  $5E7F,$06 Write #R$A36A to *#R$5FC1.
  $5E85,$01 Restore the room data pointer from the stack.
  $5E86,$02 Jump back to #R$5E55 to continue parsing.
N $5E88 Tile set #N$01: switch back to the default tile set.
@ $5E88 label=Set_DefaultTileSet
  $5E88,$01 Stash the room data pointer on the stack temporarily.
  $5E89,$06 Write #R$9BAA to *#R$5FC1.
  $5E8F,$01 Restore the room data pointer from the stack.
  $5E90,$02 Jump back to #R$5E55 to continue parsing.

c $5E92 Command #N$01: Skip Tiles
@ $5E92 label=Command01_SkipTiles
D $5E92 Command #N$01: skip over a number of tile positions without drawing.
. The following byte specifies how many positions to skip.
R $5E92 DE Tile counter
R $5E92 HL The room data pointer
  $5E92,$01 Increment the room data pointer by one.
  $5E93,$01 Fetch the skip count.
  $5E94,$01 Increment the room data pointer past the skip count byte.
  $5E95,$01 Set the skip counter in #REGb.
@ $5E96 label=SkipTiles_Loop
  $5E96,$03 Stash the room data pointer, tile counter and skip counter on the
. stack.
  $5E99,$02 #REGd=#N$01 (flag: advance position only, don't draw).
  $5E9B,$03 Call #R$5F35.
  $5E9E,$03 Restore the skip counter, tile counter and room data pointer from
. the stack.
  $5EA1,$01 Decrease the tile counter by one.
  $5EA2,$04 Jump to #R$5E6D if the tile counter is zero.
  $5EA6,$02 Decrease the skip counter by one and loop back to #R$5E96 until all
. positions are skipped.
  $5EA8,$02 Jump to #R$5E55 to continue parsing.

c $5EAA Command #N$02: Draw Repeated Tile
@ $5EAA label=Command02_RepeatedTile
D $5EAA Command #N$02: draw the same tile repeatedly. The following two bytes
. specify the repeat count and the tile ID to draw.
R $5EAA DE Tile counter
R $5EAA HL Pointer to the room data
  $5EAA,$01 Increment the room data pointer by one.
  $5EAB,$02 Fetch the repeat count from *#REGhl and store it in #REGb.
  $5EAD,$01 Increment the room data pointer by one.
  $5EAE,$01 Fetch the tile ID from *#REGhl.
  $5EAF,$01 Increment the room data pointer past the command bytes.
@ $5EB0 label=RepeatedTile_Loop
  $5EB0,$04 Stash the tile ID, repeat counter, tile counter and room data
. pointer on the stack.
  $5EB4,$02 #REGd=#N$00 (flag: draw tile to room buffer).
  $5EB6,$03 Call #R$5F35.
  $5EB9,$04 Restore the room data pointer, tile counter, repeat counter and tile
. ID from the stack.
  $5EBD,$01 Switch to shadow #REGaf to preserve the tile ID.
  $5EBE,$01 Decrease the tile counter by one.
  $5EBF,$04 Jump back to #R$5E6D if the tile counter is zero.
  $5EC3,$01 Switch back to main #REGaf to retrieve the tile ID.
  $5EC4,$02 Decrease the repeat counter by one and loop back to #R$5EB0 until
. all tiles are drawn.
  $5EC6,$02 Jump to #R$5E55 to continue parsing.

c $5EC8 Command #N$08 (Or Higher): Single Tile
@ $5EC8 label=Command08Plus_SingleTile
D $5EC8 Command #N$08+: draw a single tile. The command byte itself is the tile
. ID to draw.
R $5EC8 DE Tile counter
R $5EC8 HL Pointer to the room data
  $5EC8,$01 Fetch the tile ID from *#REGhl.
  $5EC9,$01 Increment the room data pointer past the tile ID byte.
  $5ECA,$02 Stash the room data pointer and tile counter on the stack.
  $5ECC,$02 #REGd=#N$00 (flag: draw tile to room buffer).
  $5ECE,$03 Call #R$5F35.
  $5ED1,$02 Restore the tile counter and room data pointer from the stack.
  $5ED3,$01 Decrease the tile counter by one.
  $5ED4,$04 Jump to #R$5E6D if the tile counter is zero.
  $5ED8,$03 Jump to #R$5E55 to continue parsing.

c $5EDB Command #N$03: Fill Attribute Buffer With Single Colour
@ $5EDB label=Command03_FillAttributes
D $5EDB Command #N$03: fill the attribute buffer with a single colour, then
. parse an overlay map to apply per-cell colour changes. The overlay uses a
. simple encoding: #LIST
. { #N$12 + count: skip N attribute cells }
. { #N$1B + count + colour: repeat a colour N times }
. { #N$24: end of attribute data }
. { Any other value: set a single attribute cell directly }
. LIST#
R $5EDB DE Tile counter
R $5EDB HL Pointer to the room data
  $5EDB,$01 Increment the room data pointer by one.
  $5EDC,$01 Fetch the base fill colour into #REGc.
N $5EDD Fill #N$02C0 attribute cells at #R$D800 with the base colour.
  $5EDD,$04 #REGix=#R$D800.
  $5EE1,$03 #REGde=#N($02C0,$04,$04).
@ $5EE4 label=FillAttributes_Loop
  $5EE4,$03 Write #REGc to *#REGix+#N$00.
  $5EE7,$02 Increment #REGix by one.
  $5EE9,$01 Decrease #REGde by one.
  $5EEA,$04 Jump back to #R$5EE4 until #REGde is zero.
N $5EEE Now parse the attribute overlay data to apply per-cell changes on top
. of the base fill colour.
@ $5EEE label=FillAttributes_Overlay
  $5EEE,$01 Increment #REGhl by one.
  $5EEF,$03 #REGde=#N($02C1,$04,$04).
  $5EF2,$04 #REGix=#R$D800.
@ $5EF6 label=FillAttributes_Overlay_Loop
  $5EF6,$01 #REGa=*#REGhl.
  $5EF7,$04 Jump to #R$5F12 if #REGa is #N$12 (skip command).
  $5EFB,$04 Jump to #R$5F21 if #REGa is #N$1B (repeat command).
  $5EFF,$04 Jump to #R$5F74 if #REGa is #N$24 (end of attribute data).
N $5F03 Otherwise, write this byte directly as a single attribute value.
  $5F03,$01 #REGc=*#REGhl.
  $5F04,$03 Write #REGc to *#REGix+#N$00.
  $5F07,$01 Decrease #REGde by one.
  $5F08,$02 Increment #REGix by one.
  $5F0A,$05 Jump to #R$5E6D if #REGde is zero.
  $5F0F,$01 Increment #REGhl by one.
  $5F10,$02 Jump to #R$5EF6.
N $5F12 Attribute overlay command #N$12: skip over a number of attribute cells.
N $5F12 The following byte gives the skip count.
@ $5F12 label=FillAttributes_Skip
  $5F12,$01 Increment #REGhl by one.
  $5F13,$01 Fetch the skip count into #REGb.
@ $5F14 label=FillAttributes_Skip_Loop
  $5F14,$02 Increment #REGix by one.
  $5F16,$01 Decrease #REGde by one.
  $5F17,$05 Jump to #R$5E6D if #REGde is zero.
  $5F1C,$02 Decrease the skip counter by one and loop back to #R$5F14 until
. done.
  $5F1E,$01 Increment #REGhl by one.
  $5F1F,$02 Jump to #R$5EF6.
N $5F21 Attribute overlay command #N$1B: repeat a colour value a number of
. times. The following two bytes give the repeat count and colour value.
@ $5F21 label=FillAttributes_Repeat
  $5F21,$01 Increment #REGhl by one.
  $5F22,$01 Fetch the repeat count into #REGb.
  $5F23,$01 Increment #REGhl by one.
  $5F24,$01 Fetch the colour value into #REGc.
  $5F25,$01 Increment #REGhl past the colour value byte.
@ $5F26 label=FillAttributes_Repeat_Loop
  $5F26,$03 Write #REGc to *#REGix+#N$00.
  $5F29,$02 Increment #REGix by one.
  $5F2B,$01 Decrease #REGde by one.
  $5F2C,$05 Jump to #R$5E6D if #REGde is zero.
  $5F31,$02 Decrease the repeat counter by one and loop back to #R$5F26 until
. done.
  $5F33,$02 Jump to #R$5EF6.

c $5F35 Draw Room Tile
@ $5F35 label=DrawRoomTile
D $5F35 Draws a single tile to the room buffer at the current drawing
. position stored in *#R$5FB9. The position is advanced after each call. If
. #REGd bit 0 is set, the position is advanced but no tile is drawn (used for
. blank/ skip tiles in command #N$01).
R $5F35 A Tile character to draw
R $5F35 D Bit 0: #N$01=advance position only, #N$00=draw and advance
N $5F35 Load and advance the current column/row drawing position.
  $5F35,$04 #REGbc=*#R$5FB9.
  $5F39,$01 Increment the column in #REGc.
  $5F3A,$01 Stash the tile character in shadow #REGaf.
N $5F3B If the column has reached #N$20 (past the right edge), wrap to the next
. row.
  $5F3B,$04 Jump to #R$5F41 if bit 5 of #REGc is set.
  $5F3F,$02 Jump to #R$5F44.
@ $5F41 label=DrawRoomTile_NextRow
  $5F41,$01 Increment the row in #REGb.
  $5F42,$02 Reset the column to #N$00.
@ $5F44 label=DrawRoomTile_StorePosition
  $5F44,$04 Write #REGbc to *#R$5FB9.
  $5F48,$03 Return if this is a position-advance-only call (bit 0 of #REGd is
. set).
N $5F4B Calculate the room buffer address from the column (#REGc) and row
. (#REGb) drawing position. This converts the character cell co-ordinates into
. a pixel address within the room buffer at #R$C000.
  $5F4B,$01 #REGl=#REGc.
  $5F4C,$01 #REGa=#REGb.
  $5F4D,$02,b$01 Keep only bits 0-2.
  $5F4F,$03 Rotate right three positions to move bits 0-2 into bits 5-7.
  $5F52,$01 Merge in the column bits from #REGl.
  $5F53,$01 #REGl=#REGa.
  $5F54,$01 #REGa=#REGb.
  $5F55,$02,b$01 Keep only bits 3-4.
  $5F57,$02,b$01 Set bits 6-7 for the room buffer base at #R$C000.
  $5F59,$01 #REGh=#REGa.
N $5F5A Look up the tile graphic data from the active tile set and copy all
. #N$08 pixel rows to the room buffer.
  $5F5A,$01 Stash the room buffer address on the stack.
  $5F5B,$04 #REGde=*#R$5FC1 (active tile set base address).
  $5F5F,$01 Retrieve the tile character from shadow #REGaf.
  $5F60,$02 #REGa-=#N$08.
  $5F62,$03 Transfer the tile index to #REGhl.
  $5F65,$03 Multiply by #N$08 (bytes per tile).
  $5F68,$01 Add the tile set base address.
  $5F69,$01 Exchange so #REGde=tile graphic data.
  $5F6A,$01 Restore the room buffer address from the stack.
  $5F6B,$02 Set a line counter in #REGb of #N$08.
@ $5F6D label=DrawRoomTile_CopyLoop
  $5F6D,$02 Copy the tile graphic data byte to the room buffer.
  $5F6F,$01 Advance the tile graphic data pointer.
  $5F70,$01 Move down one pixel row in the room buffer.
  $5F71,$02 Decrease the line counter by one and loop back to #R$5F6D until all
. #N$08 rows are drawn.
  $5F73,$01 Return.
N $5F74 Attribute overlay command #N$24: end of attribute data. Finalises the
. room setup by resetting game flags and calculating the base address for this
. room's colour attribute lookup table.
@ $5F74 label=FillAttributes_End
  $5F74,$06 Jump to #R$5F83 if *#R$5FA9 is zero.
  $5F7A,$04 Write #N$00 to *#R$5FA9.
  $5F7E,$01 No operation.
  $5F7F,$01 No operation.
  $5F80,$03 Write #N$00 to *#R$DAE3.
N $5F83 Calculate the base address for this room's colour attributes. Each room
. has #N$20 bytes of attribute data stored sequentially from #R$DE9E, so
. multiply the zero-indexed room number by #N$20 and add the base.
@ $5F83 label=FillAttributes_SetAttributeBase
  $5F83,$03 #REGa=*#R$5FC5.
  $5F86,$01 Decrease by one to make zero-indexed.
  $5F87,$03 #REGde=#R$DE9E.
  $5F8A,$03 Transfer the room index to #REGhl.
  $5F8D,$05 Multiply by #N$20.
  $5F92,$01 Add the base address.
  $5F93,$03 Write the result to *#R$5FB5.
N $5F96 Wait for the next interrupt frame, then transfer the completed room
. buffer to the display.
  $5F96,$01 Enable interrupts.
  $5F97,$01 Halt operation (suspend CPU until the next interrupt).
  $5F98,$01 Disable interrupts.
N $5F99 Set up printing the room to the screen buffer.
  $5F99,$02 Set a counter in #REGb for #N$16 rows to print.
  $5F9B,$03 Point #REGhl at #R$C000.
  $5F9E,$03 Jump to #R$6438.

g $5FA1 Game State Flag
@ $5FA1 label=GameStateFlag
B $5FA1,$01

g $5FA2 Input State
@ $5FA2 label=InputState
D $5FA2 Bitmask representing the current directional input. #N$1F means no
. input. Each bit represents a direction when reset:
. #TABLE(default,centre,centre)
. { =h Bit | =h State }
. { 0 | Fire }
. { 1 | Up }
. { 2 | Down }
. { 3 | Right }
. { 4 | Left }
. TABLE#
B $5FA2,$01

g $5FA4 Previous Input State
@ $5FA4 label=PreviousInputState
D $5FA4 Stores the last directional input for animation and speed purposes.
B $5FA4,$01

g $5FA5 Percy Facing Direction
@ $5FA5 label=PercyFacingDirection
D $5FA5 #N$00=facing right, #N$01=facing left.
B $5FA5,$01

g $5FA6 Input Mode
@ $5FA6 label=InputMode
D $5FA6 Controls which input device is active: #TABLE(default,centre,centre)
. { =h Byte | =h State }
. { #N$00 | Not yet detected }
. { #N$1F | Kempston joystick }
. { #N$80 | Keyboard }
. TABLE#
B $5FA6,$01

g $5FA7 Falling State
@ $5FA7 label=FallingState
D $5FA7 Tracks whether Percy is falling: #TABLE(default,centre,centre)
. { =h Byte | =h State }
. { #N$00 | Not falling }
. { #N$FE | Falling (active) }
. { #N$FF | Falling (impact) }
. TABLE#
B $5FA7,$01

g $5FA8 Collision Flag
@ $5FA8 label=CollisionFlag
D $5FA8 Set to #N$01 when Percy has collided with scenery and the move was
. rejected.
B $5FA8,$01

g $5FA9 Egg State
@ $5FA9 label=EggDropState
D $5FA9 Set to #N$FF when Percy is dropping an egg, and cleared to #N$00 when
. the egg routine is complete.
B $5FA9,$01

g $5FAA Game Mode Flag
@ $5FAA label=GameModeFlag
B $5FAA,$01

g $5FAD Landed On Platform Flag
@ $5FAD label=LandedOnPlatformFlag
D $5FAD Set to #N$FF when Percy has landed on a platform. Cleared to #N$00
. when no platform is beneath.
B $5FAD,$01

g $5FAE Movement Speed
@ $5FAE label=MovementSpeed
D $5FAE Percy's current movement speed in pixels per frame. Ranges from #N$01
. (minimum) to #N$04 (maximum). Accelerates while a direction is held,
. decelerates when input changes or is released.
B $5FAE,$01

g $5FAF Percy Flap Counter
@ $5FAF label=PercyFlapCounter
D $5FAF Animation frame counter for Percy's wing flap cycle. Increments each
. frame Percy moves horizontally, cycling from #N$01 to #N$04.
B $5FAF,$01

g $5FB0 Percy Animation Counter
@ $5FB0 label=PercyAnimationCounter
D $5FB0 Controls the animation frame cycle. Counts up from #N$01 to #N$04
. (first half), then bit 7 is set and it counts back down (second half).
. Bits 0-2 hold the frame index, bit 7 indicates the second half.
B $5FB0,$01

g $5FB1 Current Level
@ $5FB1 label=CurrentLevel
D $5FB1 The current level number. E.g. #N$01 for the first level.
B $5FB1,$01

g $5FB2 Lives Remaining
@ $5FB2 label=LivesRemaining
D $5FB2 Number of lives Percy has remaining for the current phase.
B $5FB2,$01

g $5FB3 Lives Display Character
@ $5FB3 label=LivesDisplayCharacter
D $5FB3 The ASCII character displayed on screen to represent the current
. lives count.
B $5FB3,$01

g $5FB4 Chick Animation States
@ $5FB4 label=ChickAnimationStates
D $5FB4 A rotating bit pattern used to animate the nest chicks. Each bit
. controls the animation frame for one chick, rotated each frame so
. they animate independently.
B $5FB4,$01

g $5FB5 Room Attribute Pointer
@ $5FB5 label=RoomAttributePointer
D $5FB5 Pointer to the current room's colour attribute data, calculated from
. the room number and the base at #R$DE9E.
W $5FB5,$02

g $5FB7 Beep Pitch
@ $5FB7 label=BeepPitch
D $5FB7 Current pitch value used for sound effects (item collection, falling).
. Adjusted each frame during the sound.
W $5FB7,$02

g $5FB9 Room Drawing Position
@ $5FB9 label=RoomDrawPosition
D $5FB9 The two-byte drawing position used by #R$5F35 to track where the next
. tile should be placed.
.
. The low byte is the column and the high byte is the row.
B $5FB9,$02

g $5FBB Room Buffer Flag
@ $5FBB label=RoomBufferFlag
D $5FBB Set to #N$FF at the start of #R$5E24 when the room buffer is being
. populated. Used to trigger initialisation of room objects.
B $5FBB,$01

g $5FBC Pause Flag
@ $5FBC label=Pause_Flag
D $5FBC #N$00=not paused, #N$FF=paused; set at #R$5DF5.
B $5FBC,$01

g $5FBD Border Colour
@ $5FBD label=BorderColour
B $5FBD,$01

g $5FBE Lives Backup?
@ $5FBE label=Lives_Backup
D $5FBE Copy of #R$5FB3 for compare/display; synced at #R$654C/#R$69EC.
B $5FBE,$03

g $5FC1 Active Tile Set Pointer
@ $5FC1 label=PointerActiveTileSet
D $5FC1 Holds the pointer to the currently active tile set.
W $5FC1,$02

g $5FC3 Room Data Pointer
@ $5FC3 label=PointerRoomData
D $5FC3 Points to the tile data for the current room.
W $5FC3,$02

g $5FC5 Current Room
@ $5FC5 label=CurrentRoom
D $5FC5 The ID of the current Room (#N$00-#N$0B).
B $5FC5,$01

c $5FC6 Set Room Data Pointer
@ $5FC6 label=FindRoomData
D $5FC6 Sets the room data pointer for the current room.
.
. The room data is stored as a series of blocks from #R$83AA, separated by
. #N$00 terminators. This routine scans through the data to find the block
. matching the *#R$5FC5.
  $5FC6,$04 #REGd=*#R$5FC5.
  $5FCA,$02 #REGe=#N$01 (start searching from room #N$01).
  $5FCC,$02 Return if the current room is #N$01 (the data pointer already
. defaults to the first room).
N $5FCE Scan through the room data blocks. Each block is terminated by #N$00,
. so count terminators to find the Nth room.
  $5FCE,$03 #REGhl=#R$83AA (start of room data).
@ $5FD1 label=FindRoomData_ScanLoop
  $5FD1,$01 #REGa=*#REGhl.
  $5FD2,$01 Advance the data pointer.
  $5FD3,$03 Jump to #R$5FD8 if a #N$00 terminator was found.
  $5FD6,$02 Jump to #R$5FD1 to keep scanning.
N $5FD8 Found a block terminator so check if we've reached the target room.
@ $5FD8 label=FindRoomData_FoundTerminator
  $5FD8,$01 Increment the room counter in #REGe.
  $5FD9,$05 Jump to #R$5FE7 if the room counter has exceeded #N$11 (maximum
. number of rooms/room not found).
  $5FDE,$03 Jump to #R$5FE3 if the room counter matches the target room number.
  $5FE1,$02 Otherwise, jump to #R$5FD1 to keep scanning.
N $5FE3 The target room was found so store the pointer to its data.
@ $5FE3 label=FindRoomData_Found
  $5FE3,$03 Write #REGhl to *#R$5FC3.
  $5FE6,$01 Return.

c $5FE7 Raise Table Error
@ $5FE7 label=Raise_Table_Error
D $5FE7 #HTML(<code>RST #N$08</code> with the "Invalid argument" error code.)
.
. Used when the table index >= #N$11 in #R$5FC6, and when an invalid tile set
. is requested in #R$5E72.
  $5FE7,$01 #HTML(Run the ERROR_1 routine:
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0008.html">RST #N$08</a>.)
B $5FE8,$01 Error code: #N$0A ("Invalid argument").

c $5FE9 Main Game Loop
@ $5FE9 label=MainGameLoop
D $5FE9 Main game loop handler. Reads player input (either from Kempston
. joystick or keyboard), moves Percy, checks for collisions with the room
. scenery, handles room transitions, item collection and updates Percy's
. animation frame.
  $5FE9,$07 If *#R$5FA7 is unset, call #R$653D.
N $5FF0 Seed the chick animation states and introduce a short random delay
. using the Memory Refresh Register.
  $5FF0,$03 #REGl=the contents of the Memory Refresh Register.
  $5FF3,$02 Set the low byte in #REGh to #N$00 so only low memory is accessed.
  $5FF5,$04 Fetch a byte from low memory and write it to *#R$5FB4.
  $5FF9,$02,b$01 Keep only bits 0-2.
  $5FFB,$01 Set the same byte value as a delay counter in #REGb.
@ $5FFC label=MainGameLoop_RandomDelay
  $5FFC,$01 No operation.
  $5FFD,$02 Decrease the delay counter by one and loop back to #R$5FFC until
. done.
N $5FFF Read the Kempston joystick port to check for input.
@ $5FFF label=MainGameLoop_ReadInput
  $5FFF,$03 #REGbc=#N$EFFE.
  $6002,$04 #REGix=#R$DAC0.
  $6006,$05 Write #N$1F to *#R$5FA2 (default: no direction pressed).
  $600B,$02 Read from the Kempston joystick port.
  $600D,$02,b$01 Keep only bits 0-4.
  $600F,$04 Jump to #R$6015 if any joystick direction was detected.
  $6013,$02 Jump to #R$601B.
@ $6015 label=MainGameLoop_JoystickInput
  $6015,$03 Write #REGa to *#R$5FA2.
  $6018,$03 Jump to #R$60A8.

N $601B Check whether to read from Kempston joystick or keyboard. Bit 7 of
. *#R$5FA6 indicates keyboard mode.
@ $601B label=MainGameLoop_CheckInputMode
  $601B,$03 #REGa=*#R$5FA6.
  $601E,$04 Jump to #R$606B if keyboard mode is active (bit 7 is set).
  $6022,$03 #REGbc=#N($001F,$04,$04).
  $6025,$03 Jump to #R$6043 if #REGa is non-zero.
N $6028 Auto-detect input method. Poll the joystick port repeatedly and if any
. input is detected, switch to joystick mode; otherwise switch to keyboard.
  $6028,$02 #REGe=#N$F0 (poll retry counter).
@ $602A label=MainGameLoop_AutoDetect_Loop
  $602A,$02 Read from the joystick port.
  $602C,$02,b$01 Keep only bits 0-4.
  $602E,$04 Jump to #R$603C if no joystick was input detected.
  $6032,$01 Decrease the retry counter.
  $6033,$02 Jump to #R$602A until all the retries have been used.
N $6035 Joystick input was detected so set joystick mode.
  $6035,$05 Write #N$1F to *#R$5FA6 (joystick mode).
  $603A,$02 Jump to #R$6043.
N $603C No joystick was detected so set keyboard mode.
@ $603C label=MainGameLoop_SetKeyboardMode
  $603C,$05 Write #N$80 to *#R$5FA6 (keyboard mode).
  $6041,$02 Jump to #R$606B.

N $6043 Read the Kempston joystick and remap the direction bits into the
. game's internal input format stored in *#R$5FA2.
N $6043 #TABLE(default,centre,centre,centre)
. { =h Joystick Bit | =h Direction | =h Game Bit }
. { 4 | Fire | 0 }
. { 0 | Right | 3 }
. { 1 | Left | 4 }
. { 2 | Down | 2 }
. { 3 | Up | 1 }
. TABLE#
@ $6043 label=MainGameLoop_ReadJoystick
  $6043,$02 Read from the joystick port.
  $6045,$02 #REGe=#N$1F (all directions inactive).
@ $6047 label=MainGameLoop_Joystick_TestFire
  $6047,$04 Jump to #R$604D if fire is not being pressed.
  $604B,$02 Reset bit 0 of #REGe (fire active).
@ $604D label=MainGameLoop_Joystick_TestRight
  $604D,$04 Jump to #R$6053 if right is not being pressed.
  $6051,$02 Reset bit 3 of #REGe (right active).
@ $6053 label=MainGameLoop_Joystick_TestLeft
  $6053,$04 Jump to #R$6059 if left is not being pressed.
  $6057,$02 Reset bit 4 of #REGe (left active).
@ $6059 label=MainGameLoop_Joystick_TestDown
  $6059,$04 Jump to #R$605F if down is not being pressed.
  $605D,$02 Reset bit 2 of #REGe (down active).
@ $605F label=MainGameLoop_Joystick_TestUp
  $605F,$04 Jump to #R$6065 if up is not being pressed.
  $6063,$02 Reset bit 1 of #REGe (up active).
@ $6065 label=MainGameLoop_Joystick_Store
  $6065,$04 Write #REGe to *#R$5FA2.
  $6069,$02 Jump to #R$60A8.

N $606B Read keyboard input. Scans multiple keyboard half-rows and maps them
. into the same internal input format.
N $606B #TABLE(default,centre,centre,centre)
. { =h Port | =h Keys | =h Game Bit }
. { #N$7FFE | SPACE..B | 0 (fire) }
. { #N$BFFE | ENTER..H | 2 (down) }
. { #N$DFFE | P..Y | 1 (up) }
. { #N$FBFE | Q (bit 0) | 4 (left) }
. { #N$FBFE | W (bit 1) | 3 (right) }
. TABLE#
@ $606B label=MainGameLoop_ReadKeyboard
  $606B,$03 #REGbc=#N$7FFE.
  $606E,$02 #REGe=#N$1F (all directions inactive).
N $6070 Read SPACE-B row for fire.
  $6070,$02 Read from the keyboard port.
  $6072,$02,b$01 Keep only bits 0-4.
  $6074,$04 Jump to #R$607A if no key was being pressed.
  $6078,$02 Reset bit 0 of #REGe (fire active).
N $607A Read ENTER-H row for down.
@ $607A label=MainGameLoop_Keyboard_TestDown
  $607A,$02 #REGb=#N$BF.
  $607C,$02 Read from the keyboard port.
  $607E,$02,b$01 Keep only bits 0-4.
M $607E,$06 Jump to #R$6086 if no key was being pressed.
  $6084,$02 Reset bit 2 of #REGe (down active).
N $6086 Read P-Y row for up.
@ $6086 label=MainGameLoop_Keyboard_TestUp
  $6086,$02 #REGb=#N$DF.
  $6088,$02 Read from the keyboard port.
  $608A,$02,b$01 Keep only bits 0-4.
M $608A,$06 Jump to #R$6092 if no key was being pressed.
  $6090,$02 Reset bit 1 of #REGe (up active).
N $6092 Read Q-T row for left (Q, bit 0) and right (W, bit 1).
@ $6092 label=MainGameLoop_Keyboard_TestLeftRight
  $6092,$02 #REGb=#N$FB.
  $6094,$02 Read from the keyboard port.
  $6096,$02,b$01 Keep only bit 0 (Q key).
M $6096,$04 Jump to #R$609C if Q is not being pressed.
  $609A,$02 Reset bit 4 of #REGe (left active).
@ $609C label=MainGameLoop_Keyboard_TestRight
  $609C,$02 Read from the keyboard port again.
  $609E,$02,b$01 Keep only bit 1 (W key).
M $609E,$04 Jump to #R$60A4 if W is not being pressed.
  $60A2,$02 Reset bit 3 of #REGe (right active).
@ $60A4 label=MainGameLoop_Keyboard_Store
  $60A4,$04 Write #REGe to *#R$5FA2.
N $60A8 Handle Percy's egg drop state. If *#R$5FA9 is set, Percy has dropped
. an egg and it is currently in flight.
@ $60A8 label=MainGameLoop_HandleEggDrop
  $60A8,$06 Jump to #R$60D9 if *#R$5FA9 is unset (no egg active).
N $60AE Egg is in flight — advance its Y position.
  $60AE,$03 #REGa=*#REGix+#N$21.
  $60B1,$02 #REGa+=#N$04.
  $60B3,$02 Has the egg reached Y position #N$A8?
  $60B5,$02 Jump to #R$60BF if not yet reached.
N $60B7 Egg has reached its target — end the egg drop state.
  $60B7,$04 Write #N$00 to *#REGix+#N$23.
  $60BB,$04 Write #N$00 to *#R$5FA9 (egg drop complete).
@ $60BF label=MainGameLoop_UpdateEggY
  $60BF,$03 Write #REGa to *#REGix+#N$21.
N $60C2 Play a rising sound effect while the egg is in flight.
  $60C2,$02 Stash #REGix on the stack.
  $60C4,$03 #REGhl=*#R$5FB7.
  $60C7,$04 #REGhl+=#N$0010.
  $60CB,$03 Write #REGhl to *#R$5FB7.
  $60CE,$03 #REGde=#N($0004,$04,$04).
  $60D1,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>.)
  $60D4,$01 Disable interrupts.
  $60D5,$02 Restore #REGix from the stack.
  $60D7,$02 Jump to #R$610E.
N $60D9 Check if fire is pressed and conditions are met to drop an egg.
@ $60D9 label=MainGameLoop_TestFirePressed
  $60D9,$07 Jump to #R$610E if *#R$5FA2 states that fire has not been pressed.
  $60E0,$06 Jump to #R$610E if *#R$5FAD is set.
N $60E6 Percy must be below Y position #N$84 to drop an egg.
  $60E6,$07 Jump to #R$610E if Percy's Y position (*#REGix+#N$01) is greater
. than or equal to #N$84 (too high to drop an egg).
N $60ED Start the egg drop sequence — set the egg's target position and
. activate the egg state.
  $60ED,$02 #REGa+=#N$10.
  $60EF,$01 Stash #REGaf on the stack.
  $60F0,$03 Call #R$679C.
  $60F3,$01 Restore #REGaf from the stack.
  $60F4,$03 Write #REGa to *#REGix+#N$21 (egg target Y).
  $60F7,$04 Write #N$0F to *#REGix+#N$23.
  $60FB,$03 #REGa=*#REGix+#N$00 (Percy's X position).
  $60FE,$02 #REGa+=#N$05.
  $6100,$03 Write #REGa to *#REGix+#N$20 (egg target X).
  $6103,$02,b$01 #REGa=#N$FF.
  $6105,$03 Write #N$FF to *#R$5FA9 (egg drop in progress).
  $6108,$06 Write #N($0064,$04,$04) to *#R$5FB7 (initial beep pitch).
N $610E Apply the direction input to Percy's movement. First ensure fire
. is flagged as released, then dispatch to the appropriate movement handler for
. each direction.
@ $610E label=MainGameLoop_ApplyMovement
  $610E,$03 #REGa=*#R$5FA2.
  $6111,$02 Set bit 0 of #REGa (mark fire as handled).
  $6113,$03 Write #REGa to *#R$5FA2.
N $6116 If Percy is falling (*#R$5FA7 is non-zero), handle the falling state.
  $6116,$06 Jump to #R$6152 if *#R$5FA7 is unset.
  $611C,$04 Jump to #R$612B if #REGa is #N$FE.
N $6120 Start falling and set the fall state and initial beep pitch.
  $6120,$05 Write #N$FE to *#R$5FA7.
  $6125,$06 Write #N$0082 to *#R$5FB7.
N $612B Percy is falling so play a descending beep and move downward.
@ $612B label=MainGameLoop_Falling
  $612B,$0A Write *#R$5FB7 + #N($0010,$04,$04) back to *#R$5FB7.
  $6135,$03 #REGde=#N($0004,$04,$04).
  $6138,$02 Stash #REGix on the stack.
  $613A,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>.)
  $613D,$02 Restore #REGix from the stack.
  $613F,$04 Write #N$FF to *#REGix+#N$02.
N $6143 Override input and force all directions inactive and only allow down.
  $6143,$05 Write #N$1F to *#R$5FA2.
N $6148 If Percy has fallen below Y position #N$8D, lose a life.
  $6148,$03 #REGa=*#REGix+#N$01 (Percy's Y position).
  $614B,$05 Jump to #R$68B8 if Percy has fallen off the screen (Percy's Y
. position is greater than #N$8D).
  $6150,$02 Reset bit 2 of *#REGhl (force downward movement).
N $6152 Apply directional movement. Each handler moves Percy in the
. corresponding direction, checking screen boundaries.
@ $6152 label=MainGameLoop_MovePercy
  $6152,$03 #REGc=*#REGix+#N$00 (Percy's X position).
  $6155,$03 #REGb=*#REGix+#N$01 (Percy's Y position).
  $6158,$01 Stash Percy's position on the stack.
  $6159,$04 #REGe=*#R$5FA2.
N $615D If no direction is pressed, decelerate.
  $615D,$05 Call #R$62F8 if no direction has been pressed.
  $6162,$04 #REGd=*#R$5FAE.
N $6166 Dispatch to each direction handler if active.
  $6166,$05 Call #R$6280 if left is active.
  $616B,$05 Call #R$62A2 if right is active.
  $6170,$05 Call #R$62C2 if up is active.
  $6175,$05 Call #R$62D0 if down is active.
N $617A Update the movement speed.
  $617A,$03 Call #R$62D8.
N $617D If any direction was pressed, store it for animation purposes.
  $617D,$03 #REGa=*#R$5FA2.
  $6180,$04 Jump to #R$6187 if there was no input.
  $6184,$03 Write #REGa to *#R$5FA4.
N $6187 Collision detection with room scenery. Converts Percy's position to a
. room attribute buffer address and checks if Percy overlaps any solid tiles.
@ $6187 label=MainGameLoop_CollisionDetection
  $6187,$02 #REGd=#N$00.
  $6189,$05 Write #N$00 to *#R$5FA8.
  $618E,$02 #REGe=#N$07.
N $6190 Load Percy's current position.
  $6190,$03 #REGc=*#REGix+#N$00 (Percy's X position).
  $6193,$03 #REGb=*#REGix+#N$01 (Percy's Y position).
N $6196 Check if Percy's X position is on a pixel boundary.
  $6196,$01 #REGa=#REGc.
  $6197,$02,b$01 Keep only bits 0-2 (sub-character X offset).
  $6199,$03 Jump to #R$619E if #REGa is zero (aligned to character).
  $619C,$02 Set bit 0 of #REGd (not X-aligned).
N $619E Calculate the room attribute buffer address from Percy's position.
@ $619E label=MainGameLoop_CalcAttributeAddress
  $619E,$01 #REGa=#REGc.
  $619F,$03 Rotate right three positions (divide X by #N$08).
  $61A2,$02,b$01 Keep only bits 0-4 (character column).
  $61A4,$01 #REGl=#REGa.
  $61A5,$03 #REGa=#REGb, keep only bits 0-2 (sub-character Y offset).
  $61A8,$03 Jump to #R$61AD if #REGa is zero (aligned to character row).
  $61AB,$02 Set bit 1 of #REGd (not Y-aligned).
@ $61AD label=MainGameLoop_CalcAttributeAddress_2
  $61AD,$01 #REGa=#REGb.
  $61AE,$02 Rotate left two positions.
  $61B0,$02,b$01 Keep only bits 5-7.
  $61B2,$01 Merge in the column from #REGl.
  $61B3,$01 #REGl=#REGa.
  $61B4,$01 #REGa=#REGb.
  $61B5,$02 Rotate left two positions.
  $61B7,$02,b$01 Keep only bits 0-1.
  $61B9,$02,b$01 Set bits 3-4 and 6-7 for room attribute buffer at #R$D800.
  $61BB,$01 #REGh=#REGa.
N $61BC Check a vertical strip of attribute cells for solid tiles. The height
. of the strip depends on whether Percy is Y-aligned.
  $61BC,$02 #REGb=#N$02 (rows to check).
  $61BE,$04 Jump to #R$61C3 if Y-aligned.
  $61C2,$01 Check an extra row if not Y-aligned.
@ $61C3 label=MainGameLoop_CollisionCheck_Loop
  $61C3,$01 Stash the row counter on the stack.
N $61C4 Check the current attribute cell and the one to its right.
  $61C4,$01 #REGa=*#REGhl.
  $61C5,$01 Mask with #REGe.
  $61C6,$03 Jump to #R$6244 if a collision was detected (not all bits set).
  $61C9,$01 Move to the next column.
  $61CA,$01 #REGa=*#REGhl.
  $61CB,$01 Mask with #REGe.
  $61CC,$03 Jump to #R$6244 if a collision was detected.
  $61CF,$01 Move back to the original column.
N $61D0 If Percy is not X-aligned, also check the cell two columns right.
  $61D0,$04 Jump to #R$61DD if X-aligned.
  $61D4,$02 Move two columns right.
  $61D6,$01 #REGa=*#REGhl.
  $61D7,$01 Mask with #REGe.
  $61D8,$03 Jump to #R$6244 if a collision was detected.
  $61DB,$02 Move back two columns.
N $61DD Move down one row in the attribute buffer and continue.
@ $61DD label=MainGameLoop_CollisionCheck_NextRow
  $61DD,$04 #REGhl+=#N($0020,$04,$04).
  $61E1,$01 Restore the row counter from the stack.
  $61E2,$02 Decrease the row counter by one and loop back to #R$61C3 until all
. rows are checked.
N $61E4 No collision detected so Percy can move freely. Restore the position
. from the stack and update the sprite frame.
@ $61E4 label=MainGameLoop_NoCollision
  $61E4,$01 Restore Percy's previous position from the stack.
  $61E5,$04 Write #N$07 to *#REGix+#N$02.
N $61E9 If Percy is not falling, check for ground beneath.
  $61E9,$06 Jump to #R$623D if Percy is falling (*#R$5FA7 is set).
N $61EF Check if there is ground below Percy's feet. Calculate the attribute
. address one character row below Percy's position.
@ $61EF label=MainGameLoop_CheckGround
  $61EF,$03 #REGc=*#REGix+#N$00 (Percy's X position).
  $61F2,$03 #REGb=*#REGix+#N$01 (Percy's Y position)..
  $61F5,$01 #REGa=#REGc.
  $61F6,$02,b$01 Keep only bits 0-2 (sub-character X offset).
  $61F8,$01 Stash the X offset on the stack.
  $61F9,$01 #REGa=#REGc.
  $61FA,$03 Rotate right three positions (divide X by #N$08).
  $61FD,$02,b$01 Keep only bits 0-4 (character column).
  $61FF,$01 #REGl=#REGa.
N $6200 Add #N$10 pixels to the Y position to check below Percy's feet.
  $6200,$01 #REGa=#REGb.
  $6201,$03 #REGb=#REGa + #N$10.
  $6204,$02 Rotate left two positions.
  $6206,$02,b$01 Keep only bits 5-7.
  $6208,$01 Merge in the column.
  $6209,$01 #REGl=#REGa.
  $620A,$01 #REGa=#REGb.
  $620B,$02,b$01 Keep only bits 6-7.
  $620D,$03 Rotate right three positions.
  $6210,$02,b$01 Set bits 6-7 for the room attribute buffer at #R$C000.
  $6212,$01 #REGh=#REGa.
  $6213,$01 Restore the X offset from the stack.
N $6214 If Percy is X-aligned, skip the extra column check.
  $6214,$03 Jump to #R$621D if the X offset is non-zero.
  $6217,$06 Jump to #R$621E if *#R$5FA5 is zero (Percy is facing right).
@ $621D label=MainGameLoop_CheckGround_ExtraCol
  $621D,$01 Move one column right.
N $621E Check if the tile below is a platform (attribute #N$AA).
@ $621E label=MainGameLoop_CheckGround_Test
  $621E,$05 Jump to #R$623D if there's no platform below Percy (by checking if
. the attribute is #N$AA/ #COLOUR$AA).
N $6223 Platform detected so check if Percy should land.
  $6223,$07 Jump to #R$6239 if *#R$5FA2 states that down is not being pressed.
N $622A Down is pressed while on a platform so snap Percy's Y to the platform.
  $622A,$03 #REGa=*#REGix+#N$01.
  $622D,$02,b$01 Keep only bits 3-7 (snap to character row).
  $622F,$03 Write #REGa to *#REGix+#N$01.
  $6232,$02,b$01 #REGa=#N$FF.
M $6232,$05 Write #N$FF to *#R$5FAD (landed on platform flag).
  $6237,$02 Jump to #R$6241.
N $6239 Check if up is pressed while on a platform.
@ $6239 label=MainGameLoop_CheckGround_TestUp
  $6239,$04 Jump to #R$6241 if up is not pressed.
N $623D No platform below so clear the landed flag.
@ $623D label=MainGameLoop_ClearLandedFlag
  $623D,$04 Write #N$00 to *#R$5FAD.
@ $6241 label=MainGameLoop_UpdateAnimation
  $6241,$03 Jump to #R$6338.

N $6244 Collision with solid scenery detected so reject the move and restore
. Percy's previous position.
@ $6244 label=MainGameLoop_CollisionDetected
  $6244,$02 Restore the row counter and overwrite it with Percy's previous
. position from the stack.
N $6246 If Percy is falling, handle the impact.
  $6246,$06 Jump to #R$625F if Percy is falling (*#R$5FA7 is set).
N $624C Check if Percy has hit the bottom of the screen.
  $624C,$07 Jump to #R$626F if Percy's Y position (*#REGix+#N$01) is greater
. than or equal to #N$91 and Percy is at the bottom of the screen.
N $6253 Special case; if in room #N$06, treat collision differently.
  $6253,$07 Jump to #R$626F if *#R$5FC5 is room #N$06.
N $625A Check if the collision cell is empty.
  $625A,$01 #REGa=*#REGhl.
  $625B,$01 Mask with #REGe.
  $625C,$03 Jump to #R$626F if the cell is empty.
N $625F Handle Percy falling and hitting something.
@ $625F label=MainGameLoop_FallImpact
  $625F,$04 Jump to #R$626C if #REGa is #N$FE.
  $6263,$02,b$01 #REGa=#N$FF.
M $6263,$05 Write #N$FF to *#R$5FA7.
  $6268,$04 Write #N$FF to *#REGix+#N$02.
@ $626C label=MainGameLoop_FallImpact_Done
  $626C,$03 Jump to #R$6338.

N $626F Percy has moved past a screen boundary so trigger a room transition.
. The direction determines which room to move to.
@ $626F label=MainGameLoop_SnapPosition
  $626F,$08 Write #N$01 to; #LIST
. { *#R$5FAE }
. { *#R$5FA8 }
. LIST#
N $6277 Restore Percy's position from before the rejected move.
  $6277,$03 Write #REGc to *#REGix+#N$00 (Percy's X position).
  $627A,$03 Write #REGb to *#REGix+#N$01 (Percy's Y position).
  $627D,$03 Jump to #R$6338.

c $6280 Move Percy Left
@ $6280 label=MovePercyLeft
D $6280 Move Percy left. Checks screen boundary and handles room transitions.
R $6280 IX Pointer to Percys state data
R $6280 D Number of pixels to move
  $6280,$05 Write #N$01 to *#R$5FA5 (Percy is facing left).
N $6285 If *#R$5FAA is non-zero, apply an extra boundary check.
  $6285,$06 Jump to #R$6297 if *#R$5FAA is set.
  $628B,$03 Load #REGa with Percy's X position (*#REGix+#N$00) - #N$05.
N $6290 If Percy has gone past the left edge transition into the previous room.
  $6290,$03 Jump to #R$631F if Percy's new position is less than #N$00
. (transition to the previous room).
  $6293,$01 Subtract the movement speed from Percy's X position.
  $6294,$03 Jump to #R$631F if Percy's new position is less than #N$00
. (transition to the previous room).
@ $6297 label=MovePercyLeft_Apply
  $6297,$04 Load #REGa with Percy's X position (*#REGix+#N$00) - the number of
. pixels to move (from #REGd).
N $629B If Percy has gone past the left edge transition into the previous room.
  $629B,$03 Jump to #R$631F if Percy's new position is less than #N$00
. (transition to the previous room).
  $629E,$03 Write Percy's updated X screen position back to *#REGix+#N$00.
  $62A1,$01 Return.

c $62A2 Move Percy Right
@ $62A2 label=MovePercyRight
D $62A2 Move Percy right. Checks screen boundary and handles room transitions.
R $62A2 IX Pointer to Percys state data
R $62A2 D Number of pixels to move
  $62A2,$04 Write #N$00 to *#R$5FA5 (Percy is facing right).
N $62A6 If *#R$5FAA is non-zero, apply an extra boundary check.
  $62A6,$06 Jump to #R$62B6 if *#R$5FAA is unset.
  $62AC,$06 Load #REGa with Percy's X position (*#REGix+#N$00) + the number of
. pixels to move (from #REGd) + #N$04.
N $62B2 If Percy has gone past the right edge transition into the next room.
  $62B2,$04 Jump to #R$6307 if Percy's new position is greater than or equal to
. #N$EF.
@ $62B6 label=MovePercyRight_Apply
  $62B6,$04 Load #REGa with Percy's X position (*#REGix+#N$00) + the number of
. pixels to move (from #REGd).
N $62BA If Percy has gone past the right edge transition into the next room.
  $62BA,$04 Jump to #R$6307 if Percy's new position is greater than or equal to
. #N$EF (transition to next room).
  $62BE,$03 Write Percy's updated X screen position back to *#REGix+#N$00.
  $62C1,$01 Return.

c $62C2 Move Percy Up
@ $62C2 label=MovePercyUp
D $62C2 Move Percy up. Clamps to Y position #N$00 at the top of the screen.
R $62C2 IX Pointer to Percys state data
R $62C2 D Number of pixels to move
  $62C2,$04 Load #REGa with Percy's Y position (*#REGix+#N$01) - the number of
. pixels to move (from #REGd).
  $62C6,$04 Jump to #R$62CC if Percy's new position is less than #N$A0 (is
. Percy within the screen boundaries).
N $62CA Percy is outside of the screen boundaries!
  $62CA,$02 Clamp Percy to Y position #N$00 (the top of screen).
@ $62CC label=MovePercyUp_Store
  $62CC,$03 Write Percy's updated Y screen position back to *#REGix+#N$01.
  $62CF,$01 Return.

c $62D0 Move Percy Down
@ $62D0 label=MovePercyDown
R $62D0 IX Pointer to Percys state data
R $62D0 D Number of pixels to move
  $62D0,$03 Load #REGa with Percy's Y position (*#REGix+#N$01).
  $62D3,$04 Write #REGa + the number of pixels to move (from #REGd) back to
. *#REGix+#N$01.
  $62D7,$01 Return.

c $62D8 Update Movement Speed
@ $62D8 label=UpdateMovementSpeed
D $62D8 Update Percy's movement speed.
.
. If the current input matches the previous input, accelerate up to a maximum
. of #N$04. If the input has changed, decelerate down to a minimum of #N$01.
  $62D8,$0A Jump to #R$62ED if *#R$5FA4 is the same as *#R$5FA2.
N $62E2 Input changed so decelerate.
  $62E2,$03 #REGa=*#R$5FAE.
  $62E5,$03 Return if already at minimum speed (#N$01).
  $62E8,$01 Decrease speed by one.
  $62E9,$03 Write #REGa to *#R$5FAE.
  $62EC,$01 Return.

N $62ED Input is the same so accelerate.
@ $62ED label=UpdateMovementSpeed_Accelerate
  $62ED,$03 #REGa=*#R$5FAE.
  $62F0,$03 Return if already at maximum speed (#N$04).
  $62F3,$01 Increase speed by one.
  $62F4,$03 Write #REGa to *#R$5FAE.
  $62F7,$01 Return.

N $62F8 No input so decelerate movement speed towards minimum.
@ $62F8 label=UpdateMovementSpeed_Decelerate
  $62F8,$03 #REGa=*#R$5FAE.
  $62FB,$03 Return if already at minimum speed (#N$01).
  $62FE,$01 Decrease speed by one.
  $62FF,$03 Write #REGa to *#R$5FAE.
  $6302,$04 #REGe=*#R$5FA4 (use the previous direction for animation).
  $6306,$01 Return.

c $6307 Transition Room Right
@ $6307 label=TransitionRoomRight
D $6307 Percy has gone past the right edge so transition into the next room.
  $6307,$01 Stash #REGaf on the stack.
  $6308,$03 #REGa=*#R$5FC5.
N $630B If the current room is #N$0B (the last room), wrap to room #N$01.
  $630B,$04 Jump to #R$6310 if this isn't room #N$0B.
  $630F,$01 #REGa=#N$00 (will become #N$01 after increment).
@ $6310 label=TransitionRoomRight_SetRoom
  $6310,$04 Write #N$00 to *#REGix+#N$00 (reset Percy's X to left edge).
  $6314,$01 Increment room number.
  $6315,$03 Write #REGa to *#R$5FC5.
  $6318,$03 Call #R$5E24 to draw the new room.
  $631B,$01 Restore #REGaf from the stack.
  $631C,$02 Discard two stack values.
  $631E,$01 Return.

c $631F Transition Room Left
@ $631F label=TransitionRoomLeft
D $631F Percy has gone past the left edge so transition into the previous room.
  $631F,$01 Stash #REGaf on the stack.
  $6320,$03 #REGa=*#R$5FC5.
N $6323 If the current room is room #N$01 wrap around to room #N$0B.
  $6323,$04 Jump to #R$6329 if this isn't room #N$01.
  $6327,$02 Set #REGa to room #N$0C (will become #N$0B after decrement).
@ $6329 label=TransitionRoomLeft_SetRoom
  $6329,$04 Write #N$EE to *#REGix+#N$00 (reset Percy's X to right edge).
  $632D,$01 Decrement room number.
  $632E,$03 Write #REGa to *#R$5FC5.
  $6331,$01 Restore #REGaf from the stack.
  $6332,$03 Call #R$5E24 to draw the new room.
  $6335,$02 Discard two stack values.
  $6337,$01 Return.

c $6338 Update Percy Animation
@ $6338 label=UpdatePercyAnimation
D $6338 Update Percy's animation frame based on the current movement state and
. direction. The animation counter at *#R$5FB0 cycles through frames, with bit
. 7 indicating the second half of the cycle.
c $6338 Update Percy Animation
@ $6338 label=UpdatePercyAnimation
  $6338,$03 #REGa=*#R$5FB0.
  $633B,$04 Jump to #R$6349 if in the second half of the cycle.
N $633F First half so increment the counter.
  $633F,$01 Increment #REGa.
  $6340,$04 Jump to #R$6356 if the counter has reached #N$05 (switch to second
. half).
  $6344,$03 Write #REGa to *#R$5FB0.
  $6347,$02 Jump to #R$6362.

N $6349 Second half so decrement the counter.
@ $6349 label=UpdatePercyAnimation_SecondHalf
  $6349,$02,b$01 Keep only bits 0-2 (frame index).
  $634B,$01 Decrement the frame index.
  $634C,$03 Jump to #R$635D if the frame index has reached zero.
  $634F,$05 Write #REGa + #N$80 (keep bit 7 set) to *#R$5FB0.
  $6354,$02 Jump to #R$6362.

N $6356 Switch to the second half of the animation cycle.
@ $6356 label=UpdatePercyAnimation_SwitchToSecondHalf
  $6356,$05 Write #N$84 to *#R$5FB0.
  $635B,$02 Jump to #R$6362.

N $635D Switch back to the first half of the animation cycle.
@ $635D label=UpdatePercyAnimation_SwitchToFirstHalf
  $635D,$05 Write #N$01 to *#R$5FB0.
N $6362 Select Percy's sprite frame based on direction and animation state.
. Frames are arranged in groups: #TABLE(default,centre,centre)
. { =h Byte Range | =h State }
. { #N$01-#N$04 | Flying right }
. { #N$05-#N$08 | Flying left }
. { #N$09-#N$0C | Walking/ Standing right }
. { #N$0D-#N$10 | Walking/ Standing left }
. TABLE#
@ $6362 label=UpdatePercyAnimation_SetFrame
  $6362,$06 Jump to #R$6377 if Percy's current X position (*#REGix+#N$00) is the
. same as his previous X position (*#REGix+#N$40).
N $636A Percy has moved horizontally so cycle the wing flap counter between
N $636A #N$01 and #N$04.
  $636A,$03 #REGa=*#R$5FAF.
  $636D,$01 Increment the flap counter.
  $636E,$04 Jump to #R$6374 if it hasn't reached #N$05 yet.
  $6372,$02 Reset the flap counter to #N$01.
@ $6374 label=UpdatePercyAnimation_StoreFlap
  $6374,$03 Write #REGa to *#R$5FAF.
N $6377 Determine whether Percy is airborne or grounded, and facing left or
. right.
@ $6377 label=UpdatePercyAnimation_ChooseFrame
  $6377,$0D Jump to #R$639E if Percy's Y position (*#REGix+#N$01) is on the
. ground, or if *#R$5FAD is set (and percy has landed on a platform).
N $6384 Percy is airborne so select flying frame based on direction.
  $6384,$06 Jump to #R$6393 if *#R$5FA5 is unset (Percy is facing right).
N $638A Flying left: frame = flap counter + #N$00.
  $638A,$03 #REGa=*#R$5FB0.
  $638D,$02,b$01 Keep only bits 0-2 (animation frame index).
  $638F,$03 Write #REGa to *#REGix+#N$03.
  $6392,$01 Return.

N $6393 Flying right: frame = flap counter + #N$04.
@ $6393 label=UpdatePercyAnimation_FlyingRight
  $6393,$03 #REGa=*#R$5FB0.
  $6396,$02,b$01 Keep only bits 0-2.
  $6398,$05 Write #REGa + #N$04 to *#REGix+#N$03.
  $639D,$01 Return.

N $639E Percy is on the ground or landed so select grounded frame.
@ $639E label=UpdatePercyAnimation_Grounded
  $639E,$05 Write #N$01 to *#R$5FAE (reset movement speed).
  $63A3,$06 Jump to #R$63B2 if *#R$5FA5 is unset (Percy is facing right).
N $63A9 Grounded left: frame = flap counter + #N$08.
  $63A9,$08 Write *#R$5FAF + #N$08 to *#REGix+#N$03.
  $63B1,$01 Return.

N $63B2 Grounded right: frame = flap counter + #N$0C.
@ $63B2 label=UpdatePercyAnimation_GroundedRight
  $63B2,$08 Write *#R$5FAF + #N$0C to *#REGix+#N$03.
  $63BA,$01 Return.

c $63BB Print HUD Header
@ $63BB label=Print_HUD_Header
D $63BB Set header-drawn flag, open channel #N$02, print Energy/Lives/Score
. string at #R$63E9. Then #R$63CB colours bottom rows.
  $63BB,$05 Write #N$01 to *#R$5FA1.
N $63C0 Open channel #N$02 (upper screen).
  $63C0,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>.)
  $63C3,$03 #REGhl=#R$63E9.
  $63C6,$02 Set a counter in #REGb for the length of the string to print (#N$4F
. characters).
  $63C8,$03 Call #R$6621.
N $63CB Use the Memory Refresh Register as a pointer offset into memory to
. source pseudo-random values.
  $63CB,$03 #REGe=the contents of the Memory Refresh Register.
  $63CE,$02 #REGd=#N$00.
  $63D0,$02 Set a counter in #REGb for #N$20 attribute cells.
N $63D2 Point to the bottom two rows of the attribute buffer.
  $63D2,$03 #REGhl=#N$5AC0 (attribute buffer location).
@ $63D5 label=Colour_Loop
  $63D5,$01 #REGa=*#REGde.
  $63D6,$02,b$01 Keep only bits 0-2.
  $63D8,$01 Increment #REGde by one.
  $63D9,$04 Jump to #R$63D5 if #REGa is less than #N$03.
  $63DD,$01 Stash #REGde on the stack.
  $63DE,$01 #REGe=#REGa.
  $63DF,$01 #REGa=*#REGhl.
  $63E0,$02,b$01 Keep only bits 0-2, 4-7.
  $63E2,$01 Set the bits from #REGe.
  $63E3,$01 Write #REGe to *#REGhl.
  $63E4,$01 Restore #REGde from the stack.
  $63E5,$01 Increment #REGhl by one.
  $63E6,$02 Decrease counter by one and loop back to #R$63D5 until counter is zero.
  $63E8,$01 Return.

t $63E9 Messaging: Header
@ $63E9 label=Messaging_Header
  $63E9,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
  $63EC,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
  $63EE,$02 BRIGHT "#MAP(#PEEK(#PC+$01))(?,0:OFF,1:ON)".
  $63F0,$01
  $63F1,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $63F3,$20
  $6413,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $6415,$02
  $6417,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $6419,$0A
  $6423,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $6425,$01
  $6426,$12

c $6438 Draw Room Rows
@ $6438 label=DrawRows_Room
D $6438 Loop B times: call #R$6456 (draw row), advance #REGhl. Then call #R$63BB
. if header not drawn, and #R$63CB to colour bottom rows.
R $6438 B Number of rows to draw
R $6438 HL Buffer to use
  $6438,$02 Stash the row counter and room buffer on the stack.
  $643A,$03 Call #R$6456.
  $643D,$02 Restore the room buffer and row countr from the stack.
N $643F Advance the room buffer pointer to the next character row. Each row is
. #N$20 bytes wide; if adding #N$20 to #REGl overflows, carry into #REGh by
. adding #N$08 (into the next screen third).
  $643F,$04 #REGl+=#N$20.
  $6443,$03 Jump to #R$644A if there was no overflow.
  $6446,$04 #REGh+=#N$08.
@ $644A label=DrawRoomRows_Next
  $644A,$02 Decrease the row counter by one and loop back to #R$6438 until all
. of the rows have been drawn to the screen buffer.
  $644C,$07 Call #R$63BB if *#R$5FA1 is zero.
  $6453,$03 Jump to #R$63CB.

c $6456 Draw Room Row
@ $6456 label=DrawRow_Room
R $6456 HL Pointer to the room buffer row
  $6456,$02 Set a counter in #REGb for #N$08 pixel lines.
  $6458,$01 Stash the room buffer pointer on the stack.
@ $6459 label=DrawRoomRow_PixelLoop
  $6459,$02 Stash the line counter and room buffer pointer on the stack.
  $645B,$02 Copy the room buffer pointer to #REGde.
  $645D,$02 Reset bit 7 of #REGd to convert from a room buffer address to a
. screen buffer address.
  $645F,$05 Copy #N($0020,$04,$04) bytes of data from the room buffer to the
. screen buffer.
  $6464,$02 Restore the room buffer pointer and line counter from the stack.
  $6466,$01 Move down one pixel line in the room buffer.
  $6467,$02 Decrease the line counter by one and loop back to #R$6459 until all
. #N$08 pixel lines are copied.
  $6469,$01 Restore the original room buffer pointer from the stack.
  $646A,$01 #REGa=#REGh.
  $646B,$03 Rotate right three positions to extract the character row.
  $646E,$02,b$01 Keep only bits 0-1.
  $6470,$02,b$01 Set bits 3-4, 6-7 to form the attribute buffer high byte.
  $6472,$01 #REGh=#REGa.
  $6473,$01 #REGe=#REGl.
  $6474,$01 #REGa=#REGh.
  $6475,$02,b$01 Keep only bits 0-1.
  $6477,$02,b$01 Set bits 3-4, 6 to form the destination attribute buffer high
. byte.
  $6479,$01 #REGd=#REGa.
  $647A,$05 Copy #N($0020,$04,$04) bytes to the attribute buffer.
  $647F,$01 Return.

c $6480 Update Energy Bar
@ $6480 label=UpdateEnergyBar
  $6480,$03 #REGhl=#N$52EC (screen buffer location for the energy bar).
D $6480 Animates Percy's energy bar at the bottom of the screen. The bar
. depletes when Percy is airborne and refills when Percy is on the ground. If
. the bar fully depletes, Percy enters the falling state.
N $6483 If *#R$5FA7 is non-zero, it's acting as a cooldown timer — decrement
. it and return.
  $6483,$03 #REGa=*#R$5FA7.
  $6486,$03 Jump to #R$648E if *#R$5FA7 is zero (Percy isn't falling).
  $6489,$01 Decrement the cooldown timer.
  $648A,$03 Write #REGa to *#R$5FA7.
  $648D,$01 Return.
N $648E Check if Percy is on the ground (Y >= #N$90). If so, the energy bar
N $648E refills. Otherwise it depletes.
@ $648E label=UpdateEnergyBar_CheckPosition
  $648E,$03 Load #REGa with Percy's Y position (from *#REGix+#N$01).
  $6491,$04 Jump to #R$64BE if Percy is at, or below the ground level (#N$90).
N $6495 Percy is airborne — deplete the energy bar. Uses a slower frame delay
. of #N$07 frames between each step.
  $6495,$03 #REGa=*#R$5FAB.
  $6498,$01 Increment the frame delay counter.
  $6499,$03 Write #REGa back to *#R$5FAB.
  $649C,$03 Return if it's not yet time to update the energy bar.
N $649F Reset the frame counter and check if Percy is on a platform (energy
. doesn't deplete while landed).
  $649F,$04 Write #N$00 to *#R$5FAB.
  $64A3,$05 Return if *#R$5FAD is set, indicating Percy is landed on a platform.
N $64A8 Deplete the energy bar by shifting pixels left. Scans rightward from
. the current position to find the rightmost filled byte, then shifts it left
. by one pixel.
@ $64A8 label=UpdateEnergyBar_Deplete_FindByte
  $64A8,$04 Jump to #R$64B6 if *#REGhl is zero (no pixels here).
  $64AC,$02 Shift *#REGhl left one pixel (remove one pixel of energy).
N $64AE Copy the updated byte to the three pixel rows below to give the
. energy bar its height.
@ $64AE label=UpdateEnergyBar_CopyRows
  $64AE,$01 #REGa=*#REGhl.
  $64AF,$02 Copy to the first row below.
  $64B1,$02 Copy to the second row below.
  $64B3,$02 Copy to the third row below.
  $64B5,$01 Return.
N $64B6 Current byte is empty — scan leftward for the next filled byte.
@ $64B6 label=UpdateEnergyBar_Deplete_ScanLeft
  $64B6,$01 Move one byte to the left.
  $64B7,$05 Jump to #R$64E1 if the energy bar is fully depleted (reached #N$E0,
. the left edge of the bar).
  $64BC,$02 Jump to #R$64A8 to check this byte.
N $64BE Percy is on the ground — refill the energy bar. Uses a faster frame
. delay of #N$03 frames between each step.
@ $64BE label=UpdateEnergyBar_Refill
  $64BE,$03 #REGa=*#R$5FAB.
  $64C1,$01 Increment the frame delay counter.
  $64C2,$03 Write #REGa back to *#R$5FAB.
  $64C5,$03 Return if not yet time to update the bar.
  $64C8,$04 Write #N$00 to *#R$5FAB.
N $64CC Refill the energy bar by shifting pixels right (filling from the left).
. Scans leftward to find the first non-full byte and fills it one pixel at a
. time.
@ $64CC label=UpdateEnergyBar_Refill_Shift
  $64CC,$03 #REGhl=#N$52E1 (left edge of the energy bar).
@ $64CF label=UpdateEnergyBar_Refill_FindByte
  $64CF,$01 #REGa=*#REGhl.
  $64D0,$04 Jump to #R$64DA if this byte is full (scan next byte).
  $64D4,$02 Shift *#REGhl right one pixel.
  $64D6,$02 Set bit 7 of *#REGhl (fill from the left).
  $64D8,$02 Jump to #R$64AE to copy the result to the rows below.
N $64DA Current byte is fully filled — scan rightward for the next byte to
. fill.
@ $64DA label=UpdateEnergyBar_Refill_ScanRight
  $64DA,$01 Move one byte to the right.
  $64DB,$04 Return if the bar is fully refilled (the scan reached #N$ED which
. is the right edge of the bar).
  $64DF,$02 Jump to #R$64CF to check this byte.
N $64E1 Energy bar has fully depleted — set Percy to the falling state.
@ $64E1 label=UpdateEnergyBar_Depleted
  $64E1,$05 Write #N$FF to *#R$5FA7.
  $64E6,$01 Return.

c $64E7 Lose Life
@ $64E7 label=LoseLife
E $64E7 Continue on to #R$653D.
  $64E7,$05 Write #N$90 to *#R$DAC1.
  $64EC,$04 Write #N$11 to *#R$DAC3.
  $64F0,$02 Stash #REGix on the stack.
  $64F2,$03 Call #R$6992.
N $64F5 Play the "lose a life" sound effect.
N $64F5 #HTML(#AUDIO(lose-life.wav)(#INCLUDE(LoseLife)))
  $64F5,$03 #REGhl=#N($0000,$04,$04).
  $64F8,$02 #REGa=#N$01.
  $64FA,$02 #REGb=#N$00.
  $64FC,$01 Stash #REGbc on the stack.
  $64FD,$01 #REGd=#REGb.
  $64FE,$02 Rotate #REGb right.
  $6500,$02 Send to the speaker.
  $6502,$01 No operation.
  $6503,$01 No operation.
  $6504,$01 No operation.
  $6505,$01 No operation.
  $6506,$02 Decrease counter by one and loop back to #R$6500 until counter is zero.
  $6508,$01 Restore #REGbc from the stack.
  $6509,$02,b$01 Flip bits 3-4.
  $650B,$01 Set the bits from #REGd.
  $650C,$01 Merge the bits from *#REGhl.
  $650D,$02,b$01 Keep only bits 3-7.
  $650F,$02,b$01 Set bit 0.
  $6511,$01 Increment #REGhl by one.
  $6512,$02 Decrease counter by one and loop back to #R$64FC until counter is zero.
  $6514,$02 Restore #REGix from the stack.
  $6516,$03 #REGhl=#R$DE9E.
  $6519,$03 #REGbc=#N($0160,$04,$04).
  $651C,$05 Jump to #R$6523 if *#REGhl is not equal to #N$1E.
  $6521,$02 Write #N$00 to *#REGhl.
  $6523,$01 Decrease #REGbc by one.
  $6524,$01 Increment #REGhl by one.
  $6525,$04 Jump to #R$651C until #REGbc is zero.
  $6529,$03 Call #R$6791.
N $652C See #POKE#infinite_lives(Infinite Lives).
N $652C Decrease the lives counter by one.
  $652C,$03 #REGhl=#R$5FB3.
  $652F,$01 Decrease *#REGhl by one.
  $6530,$05 Jump to #R$655C if *#R$5FB3 is not yet equal to ASCII #N$30
. ("#CHR$30").
  $6535,$02 Load #REGa with ASCII #N$30 ("#CHR$30").
  $6537,$03 #REGhl=#N$50F0 (screen buffer location).
  $653A,$03 Call #R$6581.

c $653D Initialise Lives
@ $653D label=Initialise_Lives
N $654A See #POKE#255_lives(255 Lives).
  $654A,$08 Write ASCII #N$33 ("#CHR$33") to; #LIST
. { *#R$5FBE }
. { *#R$5FB3 }
. LIST#
  $6552,$04 Write #N$00 to *#R$5FB1.
  $6556,$03 Call #R$68F7.
  $6559,$03 Jump to #R$659B.

c $655C Start Level
@ $655C label=Start_Level
  $655C,$03 #REGhl=#N$50F0 (screen buffer location).
  $655F,$03 Call #R$6581.
@ $6562 label=SetUpNewLevel
  $6562,$05 Write #N$06 to *#R$5FC5.
  $6567,$03 Call #R$5E24.
  $656A,$02 Set a counter in #REGb for #N$60 loops (enough to fill the energy
. bar completely).
@ $656C label=FillEnergyBar_Loop
  $656C,$03 Call #R$64CC.
  $656F,$02 Decrease the energy bar loop counter by one and loop back to
. #R$656C until the energy bar is completely full.
N $6571 Initialise Percy's starting position and INK colour.
  $6571,$05 Write #N$38 to *#R$DAC0.
  $6576,$03 Write #N$9E to *#R$DAC1.
  $6579,$03 Write #INK$07 to *#R$DAC2.
  $657C,$04 Write #N$00 to *#R$5FA7.
  $6580,$01 Return.

c $6581 Print Character
@ $6581 label=PrintCharacter
R $6581 A ASCII character
R $6581 HL Target screen buffer location
  $6581,$01 Stash the screen buffer pointer on the stack.
  $6582,$04 #HTML(#REGde=*<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C36.html">CHARS</a>.)
N $6586 Font data starts at character #N$20 (ASCII "SPACE"), so this allows us
. to reference the data from a zero index.
  $6586,$02 Subtract #N$20 from the ASCII character input.
N $6588 #HTML(<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C36.html">CHARS</a>
. points #N$0100 bytes before the actual font data, so incrementing #REGd adds
. #N$0100 to compensate.)
  $6588,$01 Increment #REGd by one (add #N$0100 to #REGde).
  $6589,$03 Set the ASCII character to print in #REGhl.
N $658C Each ASCII character is #N$08 bytes of data, so this translates the
. character ID into the offset.
  $658C,$04 Multiply #REGhl by #N$08 and add the base font address.
  $6590,$01 #REGde now points to the character font data.
  $6591,$01 Restore the screen buffer pointer from the stack into #REGhl.
  $6592,$02 Set a line counter in #REGb (#N$08 lines in a UDG).
@ $6594 label=PrintCharacter_LineLoop
  $6594,$02 Copy the UDG data to the screen buffer.
  $6596,$01 Move down one pixel line in the screen buffer.
  $6597,$01 Move to the next UDG graphic data byte.
  $6598,$02 Decrease the line counter by one and loop back to #R$6594 until all
. #N$08 lines of the UDG character have been drawn.
  $659A,$01 Return.

c $659B Main Menu
@ $659B label=MainMenu
D $659B Displays the pre-game title screen.
N $659B Room #N$0C is the title page.
  $659B,$08 Write #N$0C to; #LIST
. { *#R$5FC5 }
. { *#R$5FA1 }
. LIST#
  $65A3,$03 Call #R$5E24.
  $65A6,$04 Write #N$00 to *#R$5FA1.
  $65AA,$03 #REGhl=#N$4896 (screen buffer location).
  $65AD,$02 Set a counter in #REGb for #N$04 rows of text data.
  $65AF,$03 Point #REGde to #R$660D.
  $65B2,$02 Stash the row counter and screen buffer pointer on the stack.
  $65B4,$02 Set a counter in #REGb for #N$05 characters to print in each row.
  $65B6,$03 Stash the screen buffer pointer, message pointer and the character
. counter on the stack.
  $65B9,$01 Fetch a character from the message string and store it in #REGa.
  $65BA,$03 Call #R$6581.
  $65BD,$03 Restore the character counter, message pointer and the screen
. buffer pointer from the stack.
  $65C0,$01 Increment #REGl by one.
  $65C1,$01 Increment #REGde by one.
  $65C2,$02 Decrease counter by one and loop back to #R$65B6 until counter is zero.
  $65C4,$01 Restore #REGhl from the stack.
  $65C5,$04 #REGhl+=#N($0020,$04,$04).
  $65C9,$01 Restore #REGbc from the stack.
  $65CA,$02 Decrease counter by one and loop back to #R$65B2 until counter is zero.
  $65CC,$02 #REGb=#N$3D.
  $65CE,$03 Call #R$FC1B.
  $65D1,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
@ $65D4 label=WaitForEnterToStart_Loop
  $65D6,$03 Jump to #R$65D4 if "ENTER" is not being pressed.
  $65D9,$04 Set the border to #INK$01.
  $65DD,$02 #REGb=#N$0A.
  $65DF,$03 #REGhl=#R$5FA1.
  $65E2,$02 Write #N$00 to *#REGhl.
  $65E4,$01 Increment #REGhl by one.
  $65E5,$02 Decrease counter by one and loop back to #R$65E2 until counter is zero.
  $65E7,$03 Jump to #R$6562.

c $65EA Draw Chicks In The Nest
@ $65EA label=DrawNestChicks
  $65EA,$03 #REGhl=#R$E000(#N$E08A) (sprite buffer position for the first
. chick).
  $65ED,$02 Set a chick counter in #REGb for #N$03 chicks.
@ $65EF label=DrawNestChicks_Loop
  $65EF,$01 Stash the chick counter on the stack.
  $65F0,$01 Stash the screen position on the stack.
  $65F1,$03 #REGhl=#R$A763 (base address of the chick animation frames).
  $65F4,$03 #REGbc=#N$0008 (bytes per frame).
N $65F7 Use the rotating bit pattern at #R$5FB4 to select which animation frame
. to use for this chick. The pattern is rotated each time, so each chick picks
. up a different bit and animates independently.
  $65F7,$07 Update *#R$5FB4 by rotating the frame selection bits.
  $65FE,$02 Jump to #R$6601 if carry is set (use first frame at #R$A763).
  $6600,$01 #REGhl+=#REGbc (use second frame at #R$A76B).
@ $6601 label=DrawNestChicks_DrawFrame
  $6601,$01 Transfer the frame graphic address to #REGde.
  $6602,$01 Restore the screen position from the stack.
  $6603,$01 Keep a copy of the screen position on the stack.
  $6604,$03 Call #R$6692 to draw the chick frame to the screen.
  $6607,$02 Restore the screen position and chick counter from the stack.
  $6609,$01 Move one character column to the right for the next chick.
  $660A,$02 Decrease the chick counter by one and loop back to #R$65EF until all
. #N$03 chicks are drawn.
  $660C,$01 Return.

t $660D Messaging: Press ENTER to Start
@ $660D label=Messaging_PressEnterToStart
  $660D,$14 #UDGTABLE
. { #STR($660D,$04,$05) }
. { #STR($6612,$04,$05) }
. { #STR($6617,$04,$05) }
. { #STR($661C,$04,$05) }
. TABLE#

c $6621 Print String
@ $6621 label=PrintString
R $6621 HL Pointer to text
R $6621 BC The length of the text to print
  $6621,$01 #REGa=*#REGhl.
  $6622,$02 Stash #REGhl and #REGbc on the stack temporarily.
  $6624,$01 #HTML(Print to the screen using
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0010.html">RST #N$10</a>.)
  $6625,$02 Restore #REGbc and #REGhl from the stack.
  $6627,$01 Increment #REGhl by one.
  $6628,$02 Decrease the string length counter by one and loop back to #R$6621
. until the whole string has been printed to the screen.
  $662A,$01 Return.

c $662B Compute Sprite Position?
@ $662B label=Compute_Sprite_Position

c $679C Collect Item?
@ $679C label=CollectItem
  $679C,$03 #REGbc=#N$0160 (number of attribute cells to search).
  $679F,$03 #REGhl=#R$DE9E.
@ $67A2 label=CollectItem_SearchLoop
  $67A2,$02 #REGa=#N$1E (collectible item attribute).
  $67A4,$03 Jump to #R$67AE if *#REGhl matches.
  $67A7,$01 Advance to the next attribute cell.
  $67A8,$01 Decrease the search counter.
  $67A9,$02 Jump to #R$67A2 if there are more cells to search.
  $67AD,$01 Return (no collectible found).
@ $67AE label=CollectItem_Found
  $67AE,$02 Write #N$00 to *#REGhl to remove the collectible.
  $67B0,$02 Jump to #R$6791.

c $67B2 Add To Score
@ $67B2 label=AddToScore
D $67B2 Converts a binary score value in #REGa into three decimal digits and
. adds them to the current score. The digits are stored in the score buffer at
. #R$6825. The updated score is then printed to the screen.
R $67B2 A Score value to add
N $67B2 Convert the binary value in #REGa into three decimal digits (hundreds,
. tens, units) stored at #N$682B-#N$6831.
N $67B2 Extract the hundreds digit.
  $67B2,$03 Point #REGhl at #R$682C(#N$6831) (the end of #R$682C).
  $67B5,$02 Initialise #REGe to #N$00 to count "hundreds".
@ $67B7 label=AddToScore_Hundreds_Loop
  $67B7,$02 Jump to #R$67C0 if the score to add is less than a hundred.
  $67BB,$02 Subtract one hundred from the score to add.
  $67BD,$01 Increment the hundreds digit.
  $67BE,$02 Jump back to #R$67B7.
N $67C0 Store the hundreds digit and extract the tens digit.
@ $67C0 label=AddToScore_Tens
  $67C0,$01 Write the hundreds digit to the hundreds digit of the score buffer.
  $67C1,$02 Reset #REGe back to #N$00 to now count "tens".
  $67C3,$01 Move to the tens digit position.
@ $67C4 label=AddToScore_Tens_Loop
  $67C4,$02 Jump to #R$67CD if the score to add is less than ten.
  $67C8,$02 Subtract ten from the score to add.
  $67CA,$01 Increment the tens digit.
  $67CB,$02 Jump back to #R$67C4.
N $67CD Store the tens digit and extract the units digit.
@ $67CD label=AddToScore_Units
  $67CD,$01 Write the tens digit to the tens digit of the score buffer.
  $67CE,$02 Reset #REGe back to #N$00 to now count "units".
  $67D0,$01 Move to the units digit position.
@ $67D1 label=AddToScore_Units_Loop
  $67D1,$03 Jump to #R$67D8 if the score to add is now zero.
  $67D4,$01 Increment the units digit.
  $67D5,$01 Decrement the score to add by one.
  $67D6,$02 Jump back to #R$67D1.
N $67D8 Store the units digit.
@ $67D8 label=AddToScore_StoreUnits
  $67D8,$01 Write the units digit to *#REGhl.
N $67D9 Add the three expanded digits to the current score stored at #R$6825.
  $67D9,$03 #REGde=#R$6825.
  $67DC,$02 Set a counter in #REGb for #N$03 digits to add.
@ $67DE label=AddToScore_AddLoop
  $67DE,$01 Fetch the current score digit.
  $67DF,$01 Add the converted digit from *#REGhl.
  $67E0,$02 Is the result #N$0A or greater/ is there any decimal carry?
  $67E2,$02 Stash the score and conversion pointers on the stack.
  $67E4,$02 Jump to #R$67EF if a decimal carry is needed.
N $67E6 There is no carry so store the result and move to the next digit.
  $67E6,$02 Restore the score and conversion pointers from the stack.
  $67E8,$01 Write the updated digit back to the current score.
@ $67E9 label=AddToScore_NextDigit
  $67E9,$02 Advance both pointers to the next digit.
  $67EB,$02 Decrease the counter by one and loop back to #R$67DE until all
. #N$03 digits are added.
  $67ED,$02 Jump to #R$6802.
N $67EF Handle decimal carry so subtract #N$0A from the current digit and
. propagate the carry to higher digits.
@ $67EF label=AddToScore_Carry
  $67EF,$01 Exchange #REGde and #REGhl so #REGhl points to the score digit.
  $67F0,$02 Subtract #N$0A from the digit.
  $67F2,$01 Store the wrapped digit.
@ $67F3 label=AddToScore_CarryPropagate
  $67F3,$01 Move to the next higher score digit.
  $67F4,$01 Increment it by one.
  $67F5,$01 #REGa=the incremented digit.
  $67F6,$02 Has this digit also reached #N$0A?
  $67F8,$02 Jump to #R$67FE if no further carry is needed.
N $67FA This digit also overflowed so wrap it to #N$00 and continue propagating.
  $67FA,$02 Write #N$00 to *#REGhl.
  $67FC,$02 Jump to #R$67F3 to propagate carry to the next digit.
@ $67FE label=AddToScore_CarryDone
  $67FE,$02 Restore the conversion and score pointers from the stack.
  $6800,$02 Jump to #R$67E9 to continue with the next digit.
N $6802 Print the updated score to the screen.
@ $6802 label=AddToScore_Print
  $6802,$03 #REGhl=#N$50FD (screen buffer location).
  $6805,$02 Stash #REGix on the stack temporarily.
  $6807,$04 #REGix=#R$6825.
  $680B,$03 Call #R$6811.
  $680E,$02 Restore #REGix from the stack.
  $6810,$01 Return.

c $6811 Print Score
@ $6811 label=PrintScore
D $6811 Prints the current score to the screen buffer. Each digit is stored as
. a value #N$00-#N$09 and is converted to an ASCII character by adding #N$30.
R $6811 HL Screen buffer target location
R $6811 IX Pointer to the current score
  $6811,$02 Set a digit counter in #REGb of #N$07 digits.
@ $6813 label=PrintScore_Loop
  $6813,$02 Stash the screen buffer pointer and digit counter on the stack.
  $6815,$03 Fetch the current score digit value and store it in #REGa.
  $6818,$02 Add #N$30 to convert it to an ASCII character.
  $681A,$03 Call #R$6581.
  $681D,$02 Restore the digit counter and screen buffer pointer from the stack.
  $681F,$02 Advance to the next current score digit.
  $6821,$01 Move one character to the left in the screen buffer.
  $6822,$02 Decrease the digit counter by one and loop back to #R$6813 until all
. #N$07 digits have been printed.
  $6824,$01 Return.

g $6825 Current Score
@ $6825 label=CurrentScore
B $6825,$07

g $682C Score Buffer
@ $682C label=ScoreBuffer
D $682C Workspace for scoring calculations.
B $682C,$06

c $6832 Animate Snapdragons
@ $6832 label=AnimateSnapdragons
D $6832 Animates the snapdragons in the current room. Each snapdragon has a
. 3-frame snapping animation and faces toward Percy based on his horizontal
. position.
.
. Snapdragon definitions are stored in a table at #R$689F.
  $6832,$03 #REGhl=#R$689F.
  $6835,$04 #REGb=*#R$5FC5.
@ $6839 label=AnimateSnapdragons_Loop
  $6839,$01 Fetch the room number for this snapdragon.
  $683A,$02 Return if the terminator has been reached (this is the end of the
. table).
  $683D,$04 Call #R$6847 if this snapdragon is in the current room.
N $6841 Advance to the next table entry (#N$04 bytes per snapdragon).
  $6841,$04 Advance #REGhl by four.
  $6845,$02 Jump to #R$6839 to process the next entry.

N $6847 Processes a single snapdragon. Cycles the animation frame, determines
. whether the snapdragon should face left or right based on Percy's position,
. looks up the graphic data and draws the snapdragon to the screen.
@ $6847 label=AnimateSnapdragon
  $6847,$01 Stash the snapdragon table pointer on the stack.
N $6848 Advance to the animation counter and cycle it through #N$00-#N$02.
  $6848,$01 Advance to the animation counter byte.
  $6849,$01 Increment the animation counter.
  $684A,$01 #REGa=*#REGhl.
  $684B,$04 Jump to #R$6851 if the animation counter hasn't reached #N$03 yet.
  $684F,$02 Reset the animation counter back to #N$00.
N $6851 Determine whether the snapdragon should face toward Percy based on his
. character column position. If Percy is to the right, #N$03 is added to the
. frame index to use the right-facing set.
@ $6851 label=AnimateSnapdragon_CheckDirection
  $6851,$01 Stash the animation frame on the stack.
N $6852 Calculate Percy's character column (X position / 8).
  $6852,$03 #REGa=*#R$DAC0 (Percy's X position).
  $6855,$03 Rotate right three positions (divide by #N$08).
  $6858,$02,b$01 Keep only bits 0-4 (character column #N$00-#N$1F).
  $685A,$01 Store the result in #REGc.
N $685B Compare Percy's column with the snapdragon's column from the table.
  $685B,$01 Advance to the snapdragon's position byte.
  $685C,$01 #REGa=*#REGhl.
  $685D,$02,b$01 Keep only bits 0-4 (snapdragon's character column).
  $685F,$03 Jump to #R$6867 if Percy is to the left of the snapdragon.
N $6862 Percy is to the right — add #N$03 to use the right-facing frames.
  $6862,$01 Restore the animation frame from the stack.
  $6863,$02 #REGa+=#N$03.
  $6865,$02 Jump to #R$6868.
@ $6867 label=AnimateSnapdragon_FacingLeft
  $6867,$01 Restore the animation frame from the stack.
N $6868 Look up the graphic data for the current frame. Each frame is #N$20
. bytes, stored from #R$AD5B onwards. Frames #N$00-#N$02 face left, frames
. #N$03-#N$05 face right.
@ $6868 label=AnimateSnapdragon_LookupGraphic
  $6868,$03 #REGde=#R$AD5B (snapdragon graphic data).
  $686B,$02 #REGh=#N$00.
  $686D,$01 #REGl=#REGa.
  $686E,$05 Multiply #REGhl by #N$20 (bytes per frame).
  $6873,$01 Add the graphic data base address.
  $6874,$01 Exchange so #REGde points to the graphic data.
N $6875 Retrieve the snapdragon's screen position from the table and draw it as
. a 2x2 character cell graphic.
  $6875,$01 Restore the snapdragon table pointer from the stack.
  $6876,$01 Keep a copy of the snapdragons table pointer on the stack.
  $6877,$02 Advance to the screen position bytes.
  $6879,$05 Load the screen position into #REGhl (using the stack).
N $687E Draw the top-left and bottom-left cells.
  $687E,$02 Stash the screen position twice on the stack.
  $6880,$03 Call #R$6692 to draw the top-left cell.
  $6883,$01 Restore the screen position from the stack.
  $6884,$04 Add #N($0020,$04,$04) to move down one character row.
  $6888,$03 Call #R$6692 to draw the bottom-left cell.
N $688B Draw the top-right and bottom-right cells.
  $688B,$01 Restore the screen position from the stack.
  $688C,$01 Move one character column to the right.
  $688D,$01 Stash the adjusted position on the stack.
  $688E,$03 Call #R$6692 to draw the top-right cell.
  $6891,$01 Restore the position from the stack.
  $6892,$04 Add #N($0020,$04,$04) to move down one character row.
  $6896,$03 Call #R$6692 to draw the bottom-right cell.
N $6899 Restore the snapdragon table pointer and reload the current room number.
  $6899,$01 Restore the snapdragon table pointer from the stack.
  $689A,$04 #REGb=*#R$5FC5.
  $689E,$01 Return.

g $689F Table: Snapdragon Definition
@ $689F label=Table_SnapdragonDefinition
N $689F Snapdragon #N($01+(#PC-$689F)/$04):
  $689F,$01 Room #N(#PEEK(#PC)).
  $68A0,$01 Snapdragon frame #N(#PEEK(#PC)).
  $68A1,$02 Screen position: #N(#PEEK(#PC)) x #N(#PEEK(#PC+$01)).
L $689F,$04,$06
  $68B7,$01 Terminator.

c $68B8 Handle Life Lost
@ $68B8 label=Handle_Life_Lost
  $68B8,$04 Decrease *#R$5FB2 by one.
  $68BC,$01 Return if *#REGhl is not equal to #N$00.
  $68BD,$02 Stash #REGix on the stack.
  $68BF,$02 Set a sound step counter in #REGb of #N$28 steps.
  $68C1,$03 #REGhl=#N$0320 (initial sound pitch).
  $68C4,$03 #REGde=#N($0008,$04,$04) (pitch step per iteration).
N $68C7 Play one step of the death sound.
@ $68C7 label=HandleLifeLost_SoundLoop
  $68C7,$03 Call #R$693B.
  $68CA,$02 Decrease the step counter by one and loop back to #R$68C7 until the
. sound is complete.
  $68CC,$08 #HTML(Write #N$0F to; #LIST
. { *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C48.html">BORDCR</a> }
. { *#R$5FBD }
. LIST#)
  $68D4,$04 Set border to #INK$01.
  $68D8,$02 Restore #REGix from the stack.
  $68DA,$03 Call #R$68F7.
  $68DD,$03 #REGa=*#R$5FB1.
  $68E0,$02 #REGa+=#N$0B.
  $68E2,$03 Write #REGa to *#R$5FC5.
  $68E5,$03 Call #R$5E24.
N $68E8 #HTML(#AUDIO(lose-life.wav)(#INCLUDE(LoseLife)))
  $68E8,$03 #REGhl=#R$FBF9.
  $68EB,$03 Call #R$FAC4.
  $68EE,$01 Disable interrupts.
  $68EF,$03 Call #R$6562.
  $68F2,$04 Write #N$00 to *#R$5FA5 (Percy is facing right).
  $68F6,$01 Return.

c $68F7 Update Lives Display
@ $68F7 label=UpdateLivesDisplay
D $68F7 Updates the lives display after losing a life.
  $68F7,$03 #REGa=*#R$5FB1.
  $68FA,$03 #REGhl=#R$5FB3.
  $68FD,$04 Jump to #R$6911 if *#R$5FB1 is equal to #N$05.
  $6901,$01 Increment #REGa by one.
  $6902,$03 Write #REGa to *#R$5FB1.
  $6905,$04 Jump to #R$6911 if #REGa is not equal to #N$04.
  $6909,$01 Increment *#REGhl by one.
  $690A,$01 #REGa=*#REGhl.
  $690B,$03 #REGhl=#N$50F0 (screen buffer location).
  $690E,$03 Call #R$6581.
  $6911,$03 #REGa=*#R$5FB1.
  $6914,$02 #REGb=#N$00.
  $6916,$01 #REGc=#REGa.
  $6917,$01 Decrease #REGc by one.
  $6918,$03 #REGhl=#R$6961.
  $691B,$01 #REGhl+=#REGbc.
  $691C,$01 #REGa=*#REGhl.
  $691D,$03 #REGhl=#R$5FB2.
  $6920,$01 Write #REGa to *#REGhl.
  $6921,$03 #REGhl=#R$DE9E.
  $6924,$03 #REGbc=#N$0160.
  $6927,$05 Jump to #R$692E if *#REGhl is not equal to #N$1F.
  $692C,$02 Write #N$00 to *#REGhl.
  $692E,$04 Jump to #R$6934 if #REGa is not equal to #N$1E.
  $6932,$02 Write #N$00 to *#REGhl.
  $6934,$01 Increment #REGhl by one.
  $6935,$01 Decrease #REGbc by one.
  $6936,$04 Jump back to #R$6927 until #REGbc is zero.
  $693A,$01 Return.

c $693B Death Sound Step
@ $693B label=DeathSoundStep
R $693B B Sound step counter
R $693B HL Current pitch
R $693B DE Pitch adjustment per step
  $693B,$03 Stash the step counter, pitch and pitch adjustment on the stack.
N $693E Add #N$19 to the score during the death sequence.
  $693E,$02 #REGa=#N$19.
  $6940,$03 Call #R$67B2.
N $6943 Pick a random border colour using the Memory Refresh Register.
  $6943,$03 #REGl=the contents of the Memory Refresh Register.
  $6946,$02 Set the low byte in #REGh to #N$00 so only low memory is accessed.
  $6948,$01 #REGa=*#REGhl.
  $6949,$03 Write #REGa to *#R$5FB4.
  $694C,$02,b$01 Keep only bits 3-5.
  $694E,$03 #HTML(Write #REGa to *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C48.html">BORDCR</a>.)
N $6951 Play a beep at the current pitch.
  $6951,$02 Restore pitch adjustment and pitch from the stack.
  $6953,$02 Stash the pitch and pitch adjustment on the stack.
  $6955,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>.)
  $6958,$02 Restore the pitch adjustment and pitch from the stack.
N $695A Lower the pitch for the next step by subtracting the pitch adjustment.
  $695A,$03 #REGbc=#N($000F,$04,$04).
  $695D,$02 #REGhl-=#REGde (with carry).
  $695F,$01 Restore the step counter from the stack.
  $6960,$01 Return.

b $6961
  $6961,$05

c $6966 Pause Border Effect
@ $6966 label=Pause_BorderEffect
D $6966 Displays a rainbow-like cycling colour border while waiting for the
. player to press "S" to unpause the game.
  $6966,$01 Enable interrupts.
  $6967,$05 Pause for #N$14 frames to give the player a moment before the
. effect begins.
@ $6969 label=Pause_BorderEffect_ShortLoop
@ $696C label=Pause_BorderEffect_ColourCycle
  $696C,$02 Set a frame counter in #REGb of #N$0E frames.
  $696E,$01 Halt operation (suspend CPU until the next interrupt).
N $696F Derive a border colour (#N$00-#N$07) from the current frame loop
. counter.
@ $696F label=Pause_BorderEffect_ColourLoop
  $696F,$01 Copy the frame counter value into #REGa.
  $6970,$02,b$01 Keep only bits 0-2.
M $696F,$03 Load #REGa with bits 0-2 of the current frame counter value. This
. limits the value to be between #N$00-#N$07 (i.e. the colour palette).
  $6972,$01 Stash the frame counter on the stack.
@ $6973 label=Pause_Border_PauseLoop_01
  $6973,$02 Decrease the frame counter by one and loop until the counter is
. zero.
  $6975,$01 Restore the frame counter from the stack.
  $6976,$01 But keep a copy of it back on the stack.
  $6977,$02 Set #REGb to #N$00 which increases the size of the counter.
@ $6979 label=Pause_Border_PauseLoop_02
  $6979,$02 Decrease the frame counter by one and loop again until the counter
. is zero.
  $697B,$01 Restore the frame counter from the stack.
  $697C,$02 Set border to the colour held by #REGa.
  $697E,$02 Decrease counter by one and loop back to #R$696F until counter is zero.
  $6980,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
  $6984,$02,b$01 Keep only the bit which relates to the "S" key (bit 1).
  $6986,$02 Jump back to #R$696C if the "S" key was not pressed.
  $6988,$04 Read from the keyboard again;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$FD | A | S | D | F | G }
. TABLE#
@ $698A label=StartKey_Debounce
  $698C,$02,b$01 Keep only the bit which relates to the "S" key (bit 1).
  $698E,$02 Jump to #R$698A until the "S" key has been released.
  $6990,$01 Disable interrupts.
  $6991,$01 Return.

c $6992 Run Game Frame
@ $6992 label=Run_Game_Frame
  $6992,$03 Call #R$662B.
  $6995,$03 Call #R$6832.
N $6998 Handle room #N$06 special case; the chicks in the nest.
  $6998,$08 Call #R$65EA if *#R$5FC5 is equal to #N$06.
  $69A0,$03 Call #R$69A7.
  $69A3,$03 Call #R$BB1C.
  $69A6,$01 Return.

c $69A7 Run Main Loop Body
@ $69A7 label=Run_Main_Loop_Body
  $69A7,$01 Disable interrupts.
  $69A8,$04 Stash #REGix and #REGiy on the stack.
N $69AC Clear the frame IDs for: #FOR$00,$07||n|#R($DAC7+(n*$04))|, | and ||.
  $69AC,$02 #REGb=#N$07.
  $69AE,$03 #REGhl=#R$DAC7.
  $69B1,$02 #REGc=#N$00.
  $69B3,$01 Write #REGc to *#REGhl.
  $69B4,$04 Increment #REGhl by four.
  $69B8,$02 Decrease counter by one and loop back to #R$69B3 until counter is zero.
  $69BA,$03 #REGhl=#R$DAEB.
  $69BD,$02 #REGb=#N$06.
  $69BF,$01 Write #REGc to *#REGhl.
  $69C0,$04 Increment #REGhl by four.
  $69C4,$02 Decrease counter by one and loop back to #R$69BF until counter is zero.
  $69C6,$07 Call #R$6CA5 if *#R$5FBE is non-zero.
  $69CD,$03 Call #R$69F7.
  $69D0,$03 Call #R$6DAB.
  $69D3,$03 Call #R$720F.
  $69D6,$08 Call #R$7082 if *#R$5FC5 is equal to #N$04.
  $69DE,$07 Call #R$64BE if *#R$5FAD is set.
  $69E5,$06 Write *#R$5FB3 to *#R$6CC3.
  $69EB,$04 Write #N$00 to *#R$5FBE.
  $69EF,$03 Set border to #INK$01.
  $69F2,$04 Restore #REGiy and #REGix from the stack.
  $69F6,$01 Return.

c $69F7 Handler: Red Bird
@ $69F7 label=Handler_RedBird
D $69F7 Handles the red bird — a thief that steals worms Percy is carrying.
. Percy can stun the red bird by hitting it with an egg. The red bird's
. flight path data is stored at #R$BE00 with entries separated by #N$00
. terminators for each room.
  $69F7,$06 Jump to #R$6A1C if *#R$5FBB is not set.
N $69FD Initialise the red bird for the current room. Scan through the flight
. path data at #R$BE00, skipping past #N$00 terminators until the entry for the
. current room is found.
  $69FD,$03 Point #REGhl at #R$BE00.
  $6A00,$04 Load #REGa and #REGe with *#R$5FC5.
  $6A04,$02 Set a room counter in #REGb starting at #N$01.
  $6A06,$03 Jump to #R$6A14 if this is room #N$01 (data starts here).
N $6A09 Scan through the flightpath data to find the current room.
@ $6A09 label=HandleRedBird_ScanLoop
  $6A09,$01 #REGa=*#REGhl.
  $6A0A,$01 Advance the data pointer.
  $6A0B,$04 Jump back to #R$6A09 if this byte isn't the terminator (#N$00).
N $6A0F Found a #N$00 terminator so move to the data for the next room.
  $6A0F,$01 Increment the room counter.
  $6A10,$04 Jump back to #R$6A09 if this isn't at the target room yet.
N $6A14 Found the correct room's data — store the flight path pointer.
@ $6A14 label=HandleRedBird_InitPath
  $6A14,$03 Write #REGhl to *#R$6CBB (current flight path pointer).
N $6A17 Seed the random animation state from the Memory Refresh Register.
  $6A17,$05 Write the contents of the Memory Refresh Register to *#R$6CB7.
N $6A1C Update the red bird's position and check for collisions.
@ $6A1C label=HandleRedBird_Update
  $6A1C,$03 Call #R$6AF6.
N $6A1F Check if the red bird has stolen Percy's worm.
  $6A1F,$06 Jump to #R$6A60 if *#R$6CB4 is set so the red bird is already
. stunned/ caught.
  $6A25,$06 Jump to #R$6A60 if *#R$5FAA is unset.
N $6A2B Check collision between Percy and the red bird.
  $6A2B,$04 #REGix=#R$DAC0 (Percy's sprite data).
  $6A2F,$04 #REGiy=#R$DAC4 (red bird sprite data).
  $6A33,$03 Call #R$6C53.
  $6A36,$02 Jump to #R$6A60 if no collision.
N $6A38 Check the red bird has a valid frame (is visible).
  $6A38,$06 Jump to #R$6A60 if *#REGiy+#N$03 is unset, so the red bird frame is
. #N$00 (i.e. not visible).
N $6A3E Red bird stole Percy's worm — return the worm to the room and play a
. sound.
  $6A3E,$03 Call #R$679C.
  $6A41,$03 #REGde=#N($0003,$04,$04).
  $6A44,$03 #REGhl=#N($00C8,$04,$04) (initial beep pitch).
  $6A47,$02 Set a sound step counter in #REGb of #N$0A steps.
@ $6A49 label=HandleRedBird_StolenSound
  $6A49,$03 Stash the step counter, pitch and duration on the stack.
  $6A4C,$04 #HTML(#REGiy=<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C3D.html">ERR_SP</a>.)
  $6A50,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>.)
  $6A53,$01 Disable interrupts.
  $6A54,$02 Restore the duration and pitch from the stack.
  $6A56,$04 #REGhl=#N($0012,$04,$04) (raise the pitch for the next step).
  $6A5A,$01 Restore the step counter from the stack.
  $6A5B,$02 Decrease the step counter by one and loop back to #R$6A49 until the
. sound is complete.
  $6A5D,$03 No operation.
N $6A60 Check if Percy's egg has hit the red bird.
@ $6A60 label=HandleRedBird_CheckEgg
  $6A60,$03 #REGa=*#R$5FA9.
  $6A63,$03 Jump to #R$6A9D if no egg is active.
  $6A66,$04 #REGiy=#R$DAE0.
  $6A6A,$04 #REGix=#R$DAC4.
N $6A6E Only check collision if the red bird is in the same room as the egg.
  $6A6E,$04 #REGb=*#R$6CB6.
  $6A72,$03 #REGa=*#R$5FC5.
  $6A75,$03 Jump to #R$6A9D if the red bird is not in the same room.
  $6A78,$03 Call #R$6C85.
  $6A7B,$02 Jump to #R$6A9D if no collision.
N $6A7D Egg hit the red bird — check if already stunned.
  $6A7D,$06 Jump to #R$6A9A if *#R$6CB4 is set so the red bird is already
. stunned.
N $6A83 Stun the red bird — set a random stun timer and award points.
  $6A83,$03 Call #R$6C39.
  $6A86,$02,b$01 Set bit 6 (ensure a minimum stun duration).
  $6A88,$03 Write #REGa to *#R$6CB4.
  $6A8B,$03 Write #REGa to *#R$6CB5.
  $6A8E,$04 Write #N$01 to *#REGix+#N$02 (stunned colour: blue).
  $6A92,$05 Call #R$67B2 to add #N$14 points to the score.
  $6A97,$03 Call #R$6F7A.
N $6A9A Cancel the egg.
@ $6A9A label=HandleRedBird_CancelEgg
  $6A9A,$03 Call #R$71E1.
@ $6A9D label=HandleRedBird_Done
  $6A9D,$03 Call #R$6CDF.
  $6AA0,$01 Return.

N $6AA1 Calculates the red bird's next room and flight direction when it crosses
. a room boundary. Also looks up the flight speed for the current level and
. finds a valid starting position.
@ $6AA1 label=HandleRedBird_SetupFlight
  $6AA1,$04 #REGb=*#R$5FC5.
  $6AA5,$03 #REGa=*#R$6CB6.
N $6AA8 Check if the combined value wraps past room #N$0B.
  $6AA8,$01 #REGa+=#REGb.
  $6AA9,$04 Jump to #R$6AB5 if the combined value doesn't wrap past room #N$0B.
N $6AAD Wrap point reached — flip the red bird's flight direction.
  $6AAD,$03 #REGa=*#R$6CB3.
  $6AB0,$02,b$01 Toggle bit 0 (flip direction).
  $6AB2,$03 Write #REGa to *#R$6CB3.
N $6AB5 Look up the flight speed for the current level from the table at
. #R$6CBE.
@ $6AB5 label=HandleRedBird_LookupSpeed
  $6AB5,$03 #REGhl=#R$6CBE.
  $6AB8,$03 #REGa=*#R$5FB1 (current level).
  $6ABB,$01 Decrement to make zero-indexed.
  $6ABC,$01 #REGe=#REGa.
  $6ABD,$02 #REGd=#N$00.
  $6ABF,$01 #REGhl+=#REGde.
  $6AC0,$01 #REGa=*#REGhl (flight speed for this level).
  $6AC1,$03 Write #REGa to *#R$6CB9.
N $6AC4 Set up the starting position based on the flight direction.
  $6AC4,$03 #REGa=*#R$6CB3.
  $6AC7,$02 #REGc=#N$E6 (starting X for rightward flight).
  $6AC9,$02 #REGb=#N$06 (starting Y).
  $6ACB,$03 Jump to #R$6AD0 if flying right (direction is non-zero).
  $6ACE,$02 #REGc=#N$06 (starting X for leftward flight).
N $6AD0 Search for a valid Y position that doesn't collide with scenery.
@ $6AD0 label=HandleRedBird_FindPosition
  $6AD0,$03 Call #R$6C0C.
  $6AD3,$01 Return if no collision (valid position found).
N $6AD4 Position blocked — try the next row down.
  $6AD4,$04 Increment #REGb by #N$04.
  $6AD8,$01 #REGa=#REGb.
  $6AD9,$04 Jump back to #R$6AD0 until the bottom of search area is reached.
N $6ADD Reached the bottom — wrap back to the top and shift X inward.
  $6ADD,$02 #REGb=#N$04 (reset Y to the top).
  $6ADF,$03 #REGa=*#R$6CB3 (flight direction).
  $6AE2,$03 Jump to #R$6AED if flying right.
N $6AE5 Flying left — shift the starting X position rightward.
  $6AE5,$06 Increment #REGc by #N$06.
  $6AEB,$02 Jump to #R$6AD0 to try again.
N $6AED Flying right — shift the starting X position leftward.
@ $6AED label=HandleRedBird_ShiftLeft
  $6AED,$06 Decrement #REGc by #N$06.
  $6AF3,$02 Jump to #R$6AD0 to try again.
  $6AF5,$01 Return.

c $6AF6 Update Red Bird Movement
@ $6AF6 label=UpdateRedBirdMovement
D $6AF6 Updates the red bird's position and animation. Handles the red bird's
. movement along its flight path, stun recovery, room transitions, and wing
. animation.
  $6AF6,$04 #REGix=#R$DAC4 (red bird sprite data).
N $6AFA Reset the red bird's frame and colour to defaults.
  $6AFA,$04 Write #N$00 to *#REGix+#N$03 (clear frame — invisible).
  $6AFE,$04 Write #INK$02 to *#REGix+#N$02.
N $6B02 If the red bird is stunned, handle stun recovery instead.
  $6B02,$07 Jump to #R$6B9B if *#R$6CB4 is set indicating the red bird is
. stunned.
N $6B09 If the room is being initialised, set a random appearance delay.
  $6B09,$06 Jump to #R$6B19 if *#R$5FBB is unset.
  $6B0F,$03 Call #R$6C39.
  $6B12,$02,b$01 Set bit 0 (ensure an odd value).
  $6B14,$02,b$01 Keep only bits 0-5 (cap at #N$3F).
  $6B16,$03 Write #REGa to *#R$6CBD.
N $6B19 If an appearance delay is active, the red bird is waiting to enter the
. current room — count down and handle the transition.
@ $6B19 label=UpdateRedBirdMovement_CheckDelay
  $6B19,$06 Jump to #R$6B6E if *#R$6CBD is active.
N $6B1F Red bird is active in the current room — update its flight path.
  $6B1F,$06 Write *#R$5FC5 to *#R$6CB6 (store the red bird's current room).
N $6B25 Decrement the direction change timer.
  $6B25,$03 #REGhl=#R$6CB2.
  $6B28,$01 Decrement *#REGhl.
  $6B29,$02 Jump to #R$6B4A if the timer hasn't expired.
N $6B2B Timer expired — choose a new flight direction.
  $6B2B,$04 Write #N$00 to *#R$6CBA.
  $6B2F,$03 #REGhl=#R$6CBA.
  $6B32,$01 Decrement *#REGhl.
  $6B33,$03 Call #R$6AA1 if *#REGhl reached zero (find a new flight path).
N $6B36 Pick a new random direction and duration.
  $6B36,$03 Call #R$6C39.
  $6B39,$01 Stash #REGaf on the stack.
  $6B3A,$02,b$01 Keep only bits 0-2 (random direction #N$00-#N$07).
  $6B3C,$03 Write #REGa to *#R$6CB8.
  $6B3F,$01 Restore #REGaf from the stack.
N $6B40 Calculate the direction change timer from the random value.
  $6B40,$03 Rotate right three positions.
  $6B43,$02,b$01 Keep only bit 6.
  $6B45,$02,b$01 Set bit 2.
  $6B47,$03 Write #REGa to *#R$6CB2.
N $6B4A Move the red bird in its current direction. The direction is doubled
. and self-modified into the jump table at #R$6BC8.
@ $6B4A label=UpdateRedBirdMovement_Move
  $6B4A,$03 Load #REGa with *#R$6CB8.
  $6B4D,$01 Double it (each jump table entry is #N$02 bytes).
  $6B4E,$03 Write #REGa to *#R$6BC8(#N$6BC9) (self-modify the jump offset).
  $6B51,$03 #REGc=*#REGix+#N$00 (red bird's X position).
  $6B54,$03 #REGb=*#REGix+#N$01 (red bird's Y position).
  $6B57,$03 #REGhl=#R$6CB9.
  $6B5A,$03 Call #R$6BC8.
  $6B5D,$02 Jump to #R$6B2F if the carry flag is set (red bird left the valid
. area).
N $6B5F Update the red bird's wing animation frame.
@ $6B5F label=UpdateRedBirdMovement_Animate
  $6B5F,$03 #REGhl=#R$6CC4.
  $6B62,$01 #REGa=*#REGhl.
  $6B63,$01 Increment the animation counter.
  $6B64,$02,b$01 Keep only bits 0-2 (cycle through #N$00-#N$07).
  $6B66,$01 Write back to *#REGhl.
  $6B67,$01 Rotate right (divide by #N$02).
  $6B68,$02 #REGa+=#N$18 (red bird animation frame base).
  $6B6A,$03 Write #REGa to *#R$DAC7 (red bird frame).
  $6B6D,$01 Return.
N $6B6E Red bird is waiting to appear. Count down the delay timer and handle
. the room transition when it expires.
@ $6B6E label=UpdateRedBirdMovement_WaitToAppear
  $6B6E,$04 #REGb=*#R$5FC5.
  $6B72,$03 #REGa=*#R$6CB6 (red bird's current room).
  $6B75,$01 Is the red bird in the same room as Percy?
  $6B76,$02 Jump to #R$6B7E if not.
N $6B78 Red bird has arrived in Percy's room — clear the delay and animate.
  $6B78,$04 Write #N$00 to *#R$6CBD.
  $6B7C,$02 Jump to #R$6B5F.
N $6B7E Still waiting — decrement the appearance delay.
@ $6B7E label=UpdateRedBirdMovement_Countdown
  $6B7E,$03 #REGhl=#R$6CBD.
  $6B81,$01 Decrement *#REGhl.
  $6B82,$01 Return if the delay hasn't expired yet.
N $6B83 Delay expired — determine which direction the red bird should enter from
. based on which room it's coming from relative to Percy's room.
  $6B83,$04 Write #N$00 to *#R$6CB3 (default: flying left).
  $6B87,$04 #REGb=*#R$5FC5.
  $6B8B,$03 #REGa=*#R$6CB6.
  $6B8E,$03 Jump to #R$6B96 if the red bird is coming from a lower numbered room.
N $6B91 Red bird is coming from a higher room — enter flying right.
  $6B91,$05 Write #N$01 to *#R$6CB3 (flying right).
@ $6B96 label=UpdateRedBirdMovement_EnterRoom
  $6B96,$03 Call #R$6AA1.
  $6B99,$02 Jump to #R$6B5F.
N $6B9B Handle the red bird's stun recovery. The stun timer counts down, and
. the red bird flashes blue while stunned. When the timer expires, the red bird
. becomes active again with a short appearance delay.
@ $6B9B label=UpdateRedBirdMovement_StunRecovery
  $6B9B,$03 #REGhl=#R$6CB4 (stun timer).
  $6B9E,$05 Write #INK$01 to *#R$DAC6.
  $6BA3,$01 Decrement the stun timer.
  $6BA4,$01 #REGa=*#REGhl.
  $6BA5,$04 Jump to #R$6BC0 if the stun is about to end.
N $6BA9 Still stunned — only draw if the red bird is in the current room.
  $6BA9,$04 #REGb=*#R$6CB6.
  $6BAD,$03 #REGa=*#R$5FC5.
  $6BB0,$02 Return if the red bird is not in the same room as Percy.
N $6BB2 Red bird is stunned and visible — move it downward slowly (falling).
  $6BB2,$03 #REGc=*#REGix+#N$00 (red bird's X position).
  $6BB5,$03 #REGa=*#REGix+#N$01 (red bird's Y position).
  $6BB8,$02 #REGa+=#N$03 (drift downward).
  $6BBA,$01 Store the result in #REGb.
  $6BBB,$03 Call #R$6C0C.
  $6BBE,$02 Jump to #R$6B5F.
N $6BC0 Stun ending — clear the timer and set a short reappearance delay.
@ $6BC0 label=UpdateRedBirdMovement_StunEnd
  $6BC0,$01 Clear the stun timer to #N$00.
N $6BC1 Set a short reappearance delay.
  $6BC1,$05 Write #N$04 to *#R$6CBD.
  $6BC6,$02 Jump to #R$6B6E.

c $6BC8 Red Bird Direction Jump Table
@ $6BC8 label=RedBirdDirectionJumpTable
D $6BC8 Movement direction jump table. The entry point is self-modified at
. #R$6BC8(#N$6BC9) to jump to one of 8 directional movement handlers. Each
. handler adjusts #REGb (Y) and/or #REGc (X) by the flight speed value at
. *#REGhl, then falls through to #R$6C0C to validate the position.
. #TABLE(default,centre,centre,centre,centre)
. { =h Direction | =h Index | =h X | =h Y }
. { Up | 0 | — | −speed }
. { Up-right | 1 | +speed | −speed }
. { Right | 2 | +speed | — }
. { Down-right | 3 | +speed | +speed }
. { Down | 4 | — | +speed }
. { Down-left | 5 | −speed | +speed }
. { Left | 6 | −speed | — }
. { Up-left | 7 | −speed | −speed }
. TABLE#
E $6BC8 Continue on to #R$6C0C.
  $6BC8,$02 Self-modified jump — offset written by #R$6B4E.
@ $6BCA label=RedBirdDirection_Up
  $6BCA,$02 Jump to #R$6BDA (up).
@ $6BCC label=RedBirdDirection_UpRight
  $6BCC,$02 Jump to #R$6BDF (up-right).
@ $6BCE label=RedBirdDirection_Right
  $6BCE,$02 Jump to #R$6BE7 (right).
@ $6BD0 label=RedBirdDirection_DownRight
  $6BD0,$02 Jump to #R$6BEC (down-right).
@ $6BD2 label=RedBirdDirection_Down
  $6BD2,$02 Jump to #R$6BF4 (down).
@ $6BD4 label=RedBirdDirection_DownLeft
  $6BD4,$02 Jump to #R$6BF9 (down-left).
@ $6BD6 label=RedBirdDirection_Left
  $6BD6,$02 Jump to #R$6C01 (left).
@ $6BD8 label=RedBirdDirection_UpLeft
  $6BD8,$02 Jump to #R$6C06 (up-left).
N $6BDA Movement handlers. Each adjusts #REGb and/or #REGc by the speed
. value at *#REGhl, then falls through to #R$6C0C.
@ $6BDA label=RedBirdMove_Up
  $6BDA,$03 #REGb-=*#REGhl (subtract speed from Y).
  $6BDD,$02 Jump to #R$6C0C.
@ $6BDF label=RedBirdMove_UpRight
  $6BDF,$03 #REGb-=*#REGhl (Y − speed).
  $6BE2,$03 #REGc+=*#REGhl (X + speed).
  $6BE5,$02 Jump to #R$6C0C.
@ $6BE7 label=RedBirdMove_Right
  $6BE7,$03 #REGc+=*#REGhl (X + speed).
  $6BEA,$02 Jump to #R$6C0C.
@ $6BEC label=RedBirdMove_DownRight
  $6BEC,$03 #REGc+=*#REGhl (X + speed).
  $6BEF,$03 #REGb+=*#REGhl (Y + speed).
  $6BF2,$02 Jump to #R$6C0C.
@ $6BF4 label=RedBirdMove_Down
  $6BF4,$03 #REGb+=*#REGhl (Y + speed).
  $6BF7,$02 Jump to #R$6C0C.
@ $6BF9 label=RedBirdMove_DownLeft
  $6BF9,$03 #REGb+=*#REGhl (Y + speed).
  $6BFC,$03 #REGc-=*#REGhl (X − speed).
  $6BFF,$02 Jump to #R$6C0C.
@ $6C01 label=RedBirdMove_Left
  $6C01,$03 #REGc-=*#REGhl (X − speed).
  $6C04,$02 Jump to #R$6C0C.
@ $6C06 label=RedBirdMove_UpLeft
  $6C06,$03 #REGb-=*#REGhl (Y − speed).
  $6C09,$03 #REGc-=*#REGhl (X − speed).

c $6C0C Validate Red Bird Position
@ $6C0C label=ValidateRedBirdPosition
D $6C0C Validates the red bird's proposed position (#REGb=Y, #REGc=X) against
. the room's flight path boundary data. Scans through the boundary table at
. *#R$6CBB looking for a region that contains the position.
.
. Each entry is #N$04 bytes: Y-min, Y-max, X-min, X-max. If a valid region is
. found, the position is stored and carry is clear. If no valid region is found
. (entry is #N$00), carry is set.
R $6C0C B Proposed Y position
R $6C0C C Proposed X position
R $6C0C IX Pointer to red bird sprite data
R $6C0C O:F Carry clear = valid, carry set = out of bounds
  $6C0C,$03 #REGhl=*#R$6CBB (flight path boundary pointer).
@ $6C0F label=ValidateRedBirdPosition_Loop
  $6C0F,$01 Stash the boundary pointer on the stack.
  $6C10,$01 #REGa=*#REGhl (Y-min for this region).
  $6C11,$03 Jump to #R$6C36 if #REGa is #N$00 (end of boundary data).
N $6C14 Check Y-min <= B.
  $6C14,$03 Jump to #R$6C2F if #REGb is less than Y-min.
N $6C17 Check B <= Y-max.
  $6C17,$01 Advance to Y-max.
  $6C18,$01 #REGa=*#REGhl.
  $6C19,$03 Jump to #R$6C2F if #REGb is greater than Y-max.
N $6C1C Check X-min <= C.
  $6C1C,$01 Advance to X-min.
  $6C1D,$01 #REGa=*#REGhl.
  $6C1E,$03 Jump to #R$6C2F if #REGc is less than X-min.
N $6C21 Check C <= X-max.
  $6C21,$01 Advance to X-max.
  $6C22,$01 #REGa=*#REGhl.
  $6C23,$03 Jump to #R$6C2F if #REGc is greater than X-max.
N $6C26 Position is within this region — store it and return success.
  $6C26,$03 Write #REGc to *#REGix+#N$00 (X position).
  $6C29,$03 Write #REGb to *#REGix+#N$01 (Y position).
  $6C2C,$01 Restore the boundary pointer from the stack.
  $6C2D,$01 Clear carry (valid position).
  $6C2E,$01 Return.
N $6C2F Position is outside this region — try the next one.
@ $6C2F label=ValidateRedBirdPosition_Next
  $6C2F,$01 Restore the boundary pointer from the stack.
  $6C30,$04 Advance #REGhl by #N$04 (next boundary entry).
  $6C34,$02 Jump to #R$6C0F.
N $6C36 End of boundary data — no valid region found.
@ $6C36 label=ValidateRedBirdPosition_OutOfBounds
  $6C36,$01 Restore the boundary pointer from the stack.
  $6C37,$01 Set carry (out of bounds).
  $6C38,$01 Return.

c $6C39

c $6C53 Check Sprite Collision
D $6C53 Checks if two sprites overlap by comparing their X and Y positions.
. Each sprite is assumed to be #N$10 pixels wide and #N$0C pixels tall.
@ $6C53 label=CheckSpriteCollision
R $6C53 IX Pointer to first sprite data
R $6C53 IY Pointer to second sprite data
R $6C53 O:F Carry set = no collision, carry clear = collision
N $6C53 First check horizontal overlap. The two sprites overlap in X if
. neither sprite's left edge is beyond the other's right edge.
  $6C53,$03 Load #REGa with the first sprite's X position (from *#REGix+#N$00).
  $6C56,$05 Jump to #R$6C63 if the first sprite is to the right of the second
. sprite (checking against *#REGiy+#N$00/ the second sprites X position).
N $6C5B First sprite is to the left so check if its right edge reaches the
. second sprite.
  $6C5B,$02 Add #N$10 to the first sprite's X position (add assumed sprite
. width).
  $6C5D,$05 Jump to #R$6C6E if the two sprites overlap horizontally.
  $6C62,$01 Return (there's no horizontal overlap; carry is set).
N $6C63 First sprite is to the right so check if the second sprite's right
. edge reaches the first sprite.
@ $6C63 label=CheckSpriteCollision_TestRight
  $6C63,$05 Load #REGa with the second sprite's X position (from *#REGiy+#N$00)
. + #N$10 (adding the sprite width).
  $6C68,$05 Jump to #R$6C6E if the two sprites overlap horizontally.
  $6C6D,$01 Return (there's no horizontal overlap; carry is set).
N $6C6E The two sprites overlap horizontally; now check if there's any vertical
. overlap.
@ $6C6E label=CheckSpriteCollision_TestVertical
  $6C6E,$03 Load #REGa with the first sprite's Y position (*#REGix+#N$01).
  $6C71,$05 Jump to #R$6C7C if the first sprite is below the second sprite
. (checking against *#REGiy+#N$01/ the second sprites Y position).
N $6C76 First sprite is above so check if its bottom edge reaches the second
. sprite.
  $6C76,$02 Add #N$0C to the first sprite's Y position (add assumed sprite
. height).
  $6C78,$04 Return (with; carry clear meaning a collision, and carry set
. meaning no collision).
N $6C7C First sprite is below so check if the second sprite's bottom edge
. reaches the first sprite.
@ $6C7C label=CheckSpriteCollision_TestBelow
  $6C7C,$05 Load #REGa with the second sprite's Y position (from *#REGiy+#N$01)
. + #N$0C (adding the sprite height).
  $6C81,$04 Return (with; carry clear meaning a collision, and carry set
. meaning no collision).

c $6C85 Check Egg Collision
@ $6C85 label=CheckEggCollision
D $6C85 Checks if an egg overlaps with a sprite by comparing their positions.
. The egg is assumed to be #N$10 pixels wide and #N$10 pixels tall, while
. the target point is offset by #N$04 pixels in X and #N$06 pixels in Y
. to check against the centre of the target sprite.
R $6C85 IX Pointer to sprite data
R $6C85 IY Pointer to egg sprite data
R $6C85 O:F Carry set = no collision, carry clear = collision
N $6C85 First check horizontal overlap. The egg's centre point (X + #N$04)
. is compared against the sprite's horizontal range.
  $6C85,$06 Load #REGb with the egg's X position (from *#REGiy+#N$00) + #N$04
. (offset to the egg's centre).
  $6C8B,$03 Load #REGa with the sprite's X position (from *#REGix+#N$00).
  $6C8E,$01 Compare with the egg's centre X position.
  $6C8F,$01 Complement the carry flag.
  $6C90,$01 Return if the sprite is to the right of the egg (no overlap; carry
. is set).
N $6C91 Sprite is to the left so check if its right edge reaches the egg's
. centre.
  $6C91,$02 Add #N$10 to the sprite's X position (add sprite width).
  $6C93,$01 Compare this with the egg's centre X position.
  $6C94,$01 Return (with; carry clear meaning a collision, and carry set meaning
. no collision).
N $6C95 The two overlap horizontally; now check vertical overlap. The egg's
. centre point (Y + #N$06) is compared against the sprite's vertical
. range.
  $6C95,$06 Load #REGb with the egg's Y position (from *#REGiy+#N$01) + #N$06
. (offset to the egg's centre).
  $6C9B,$03 Load #REGa with the sprite's Y position (from *#REGix+#N$01).
  $6C9E,$01 Compare this with the egg's centre Y position.
  $6C9F,$01 Complement the carry flag.
  $6CA0,$01 Return if the sprite is below the egg (no overlap; carry is set).
N $6CA1 Sprite is above so check if its bottom edge reaches the egg's centre.
  $6CA1,$02 Add #N$10 to the sprite's Y position (add sprite height).
  $6CA3,$01 Compare this with the egg's centre Y position.
  $6CA4,$01 Return (with; carry clear meaning a collision, and carry set meaning
. no collision).

c $6CA5
  $6CA5,$06 Write #N$FF to *#R$6CB3.
  $6CAB,$02 Write #N$FF to *#R$6CB4.
  $6CAD,$02 Write #N$FF to *#R$6CB5.
  $6CAF,$02 Write #N$FF to *#R$6CB6.
  $6CB1,$01 Return.

g $6CB2 Red Bird Direction Change Timer
@ $6CB2 label=RedBirdDirectionChangeTimer
D $6CB2 Counts down each frame. When it reaches zero, the red bird picks a new
. random flight direction.
B $6CB2,$01

g $6CB3 Red Bird Traversal Direction
@ $6CB3 label=RedBirdTraversalDirection
D $6CB3 Controls which direction the red bird traverses across rooms.
. #N$00=moving left (entering from the right), #N$01=moving right
. (entering from the left). Toggled when the red bird wraps past the
. room boundary.
B $6CB3,$01

g $6CB4 Red Bird Stun Timer
@ $6CB4 label=RedBirdStunTimer
D $6CB4 When non-zero, the red bird is stunned. Counts down each frame until
. it reaches #N$01, then the stun ends and a short reappearance delay
. begins.
B $6CB4,$01

g $6CB5 Red Bird Stun Timer Copy
@ $6CB5 label=RedBirdStunTimerCopy
D $6CB5 Copy of the initial stun timer value, stored when the red bird is
. first stunned.
B $6CB5,$01

g $6CB6 Red Bird Current Room
@ $6CB6 label=RedBirdCurrentRoom
D $6CB6 The room number the red bird is currently in. May differ from
. *#R$5FC5 when the red bird is transitioning between rooms.
B $6CB6,$01

g $6CB7 Red Bird Animation Seed
@ $6CB7 label=RedBirdAnimationSeed
D $6CB7 Seeded from the Memory Refresh Register when the red bird is
. initialised for each room.
B $6CB7,$01

g $6CB8 Red Bird Movement Direction
@ $6CB8 label=RedBirdMovementDirection
D $6CB8 The red bird's current movement direction within a room (#N$00-#N$07),
. indexing into the direction jump table at #R$6BC8. Changes randomly
. each time the direction change timer at #R$6CB2 expires.
B $6CB8,$01

g $6CB9 Red Bird Flight Speed
@ $6CB9 label=RedBirdFlightSpeed
D $6CB9 The red bird's current flight speed, looked up from the per-level speed
. table at #R$6CBE based on the current level number.
B $6CB9,$01

g $6CBA Red Bird Path Counter
@ $6CBA label=RedBirdPathCounter
D $6CBA Counts down to trigger a new flight path setup via #R$6AA1.
B $6CBA,$01

g $6CBB Pointer: Red Bird Flightpath Data
@ $6CBB label=Pointer_RedBirdFlightpathData
D $6CBB Pointer to the current room's flight path boundary data at #R$BE00.
. Each boundary entry is #N$04 bytes: Y-min, Y-max, X-min, X-max.
W $6CBB,$02

g $6CBD Red Bird Appearance Delay
@ $6CBD label=RedBirdAppearanceDelay
D $6CBD Counts down each frame while the red bird is waiting to enter the
. current room. When it reaches zero, the red bird appears.
B $6CBD,$01

g $6CBE Red Bird Speed Table
@ $6CBE label=RedBirdSpeedTable
D $6CBE Flight speed for each level. Indexed by zero-based level number.
B $6CBE,$01 Speed: #N(#PEEK(#PC)).
L $6CBE,$01,$05

  $6CC3

g $6CC4 Red Bird Wing Animation Counter
@ $6CC4 label=RedBirdWingAnimationCounter
D $6CC4 Cycles through #N$00-#N$07 to animate the red bird's wings. Divided
. by #N$02 and added to the frame base of #N$18 to select the sprite
. frame.
B $6CC4,$01

  $6CDF

c $6DAB Dispatch Game State
@ $6DAB label=Dispatch_Game_State

c $6E2F

c $6E5D

c $7082 Handler: Frogs
@ $7082 label=Handler_Frogs
D $7082 Handles the frog enemies. Each frog sits on the ground and periodically
. jumps upward in an arc, making a croaking sound.
N $7082 Set up the first frog.
  $7082,$04 #REGix=#R$DAC8.
  $7086,$06 Jump to #R$7093 if *#R$5FBB is zero.
  $708C,$07 Write #N$00; #LIST
. { *#R$71E9 }
. { *#R$71EC }
. LIST#
N $7093 Update the first frog.
@ $7093 label=Handler_Frog01
  $7093,$03 Point #REGhl at #R$71E9.
  $7096,$02 Load #REGb with the first frogs ground Y position (#N$88).
  $7098,$02 Load #REGc with the first frogs ground X position (#N$3C).
  $709A,$03 Call #R$70DB.
  $709D,$0B Call #R$6C53 with first sprite: #R$DAC0 against second sprite:
. #R$DAC8.
  $70A8,$02 Jump to #R$70AF if Percy isn't colliding with the second sprite.
N $70AA Percy has collided with the first frog.
  $70AA,$05 Write #N$FF to *#R$5FA7.
N $70AF The first level only has a single frog and subsequent levels have two.
@ $70AF label=Handler_Frog02
  $70AF,$08 Jump to #R$7190 if *#R$5FB1 is equal to #N$01.
N $70B7 Update the second frog.
  $70B7,$03 Point #REGhl at #R$71EC.
  $70BA,$04 #REGix=#R$DACC.
  $70BE,$02 Load #REGb with the second frogs ground Y position (#N$78).
  $70C0,$02 Load #REGc with the second frogs ground X position (#N$48).
  $70C2,$03 Call #R$70DB.
  $70C5,$0B Call #R$6C53 with first sprite: #R$DAC0 against second sprite:
. #R$DACC.
  $70D0,$03 Jump to #R$7190 if Percy isn't colliding with the second sprite.
N $70D3 Percy has collided with the second frog.
  $70D3,$05 Write #N$FF to *#R$5FA7.
  $70D8,$03 Jump to #R$7190.

c $70DB Update Frog
@ $70DB label=UpdateFrog
D $70DB Updates a single frog's behaviour through the jump cycle.
R $70DB BC Ground position
R $70DB HL Pointer to frog state data
R $70DB IX Pointer to frog sprite data
  $70DB,$01 Fetch the timer value for the frog.
  $70DC,$03 Jump to #R$70ED if the timer is zero (the frog is idle).
  $70DF,$01 Decrement the timer by one.
  $70E0,$02 Jump to #R$70ED if the timer has now reached zero.
N $70E2 This Frog is mid-jump, cycle through the animation frames.
  $70E2,$03 #REGa=*#REGix+#N$02.
  $70E5,$01 Increment #REGa.
  $70E6,$02,b$01 Keep only bits 0-1 (cycle through #N$00-#N$03).
  $70E8,$03 Write #REGa to *#REGix+#N$02.
  $70EB,$02 Jump to #R$70F1.
@ $70ED label=UpdateFrog_SetIdle
  $70ED,$04 Write #N$06 to *#REGix+#N$02.

c $7190 Handler: Frogs Check Egg Collision
@ $7190 label=HandlerFrog01_CheckEggCollision
N $7190 Return if an egg isn't being dropped at this point.
  $7190,$05 Return if *#R$5FA9 is unset.
N $7195 Check the first frog.
  $7195,$03 #REGhl=#R$71E9.
  $7198,$04 #REGiy=#R$DAE0.
  $719C,$04 #REGix=#R$DAC8.
  $71A0,$03 Call #R$6C85.
  $71A3,$02 Jump to #R$71B9 if the egg isn't colliding with the first frog.
N $71A5 Item hit the first frog.
  $71A5,$04 Jump to #R$71B6 if the frog is already stunned.
N $71A9 Stun the frog — set a random stun timer and award points.
  $71A9,$02 #REGa=the contents of the Memory Refresh Register.
  $71AB,$02,b$01 Set bit 6 (ensure a minimum stun duration).
  $71AD,$01 Write the stun duration to the first frogs stun countdown.
  $71AE,$05 Call #R$67B2 to add #N$0A points to the score.
  $71B3,$03 Call #R$6F7A.
@ $71B6 label=HandlerEggCollision_Destroy01
  $71B6,$03 Call #R$71E1.
N $71B9 Check if the second frog is active (level above #N$01).
@ $71B9 label=HandlerFrog02_CheckEggCollision
  $71B9,$06 Return if *#R$5FB1 is equal to #N$01.
N $71BF Check the second frog.
  $71BF,$04 #REGix=#R$DACC.
  $71C3,$03 #REGhl=#R$71EC.
  $71C6,$03 Call #R$6C85.
  $71C9,$01 Return if the egg isn't colliding with the second frog.
N $71CA Item hit the second frog.
  $71CA,$04 Jump to #R$71DA if the frog is already stunned.
N $71CE Stun the second frog and award points.
  $71CE,$02 #REGa=the contents of the Memory Refresh Register.
  $71D0,$02,b$01 Set bits 0-4 (ensure minimum stun duration).
  $71D2,$02,b$01 Clear bit 7 (cap the maximum duration).
  $71D4,$01 Write the stun duration to the second frogs stun countdown.
  $71D5,$05 Call #R$67B2 to add #N$0A points to the score.
@ $71DA label=HandlerEggCollision_Destroy02
  $71DA,$03 Call #R$71E1.
  $71DD,$03 Call #R$6F7A.
  $71E0,$01 Return.

c $71E1 Cancel Egg Drop
@ $71E1 label=CancelEggDrop
  $71E1,$07 Write #N$00 to; #LIST
. { *#R$DAE3 }
. { *#R$5FA9 }
. LIST#
  $71E8,$01 Return.

g $71E9 Frog 1 State Data
@ $71E9 label=Frog1_StateData
  $71E9,$01 Stun countdown.
  $71EA,$02

g $71EC Frog 2 State Data
@ $71EC label=Frog2_StateData
  $71EC,$01 Stun countdown.
  $71ED,$02

g $71EF Table: Frog Jump Height
@ $71EF label=Table_FrogJumpHeight
D $71EF Jump height lookup table. Each entry is the Y offset from ground level
. for one step of the frog's jump arc. The values rise to a peak of #N$22 at
. the midpoint then fall back to #N$00, forming a smooth parabolic arc over
. #N$18 steps.
  $71EF,$19,$0C,$01,$0C

g $7208

c $720F Room Handler Dispatch
@ $720F label=RoomHandlerDispatch
N $720F This is a self-modified instruction so the immediate value is patched at
. runtime. If it is non-zero, store it in *#R$5FB1.
  $720F,$02 #REGa=#N$00.
  $7211,$03 Jump to #R$7217 if #REGa is zero.
  $7214,$03 Write #REGa to *#R$5FB1.
N $7217 If *#R$5FBB is non-zero, clear #N$07FF bytes of the sprite attribute
. buffer at #R$E800.
@ $7217 label=RoomHandlerDispatch_TestSpriteAttributes
  $7217,$03 #REGa=*#R$5FBB.
  $721A,$03 Jump to #R$722A if #REGa is zero.
  $721D,$0D Clear #N$07FF bytes from #R$E800 onwards.
N $722A Look up the handler address for the current room from the jump table at
. #R$7B2E. Each entry is a two-byte address; the room number (one-indexed) is
. decremented to form a zero-based index.
@ $722A label=RoomHandlerDispatch_Lookup
  $722A,$04 #REGb=*#R$5FB1.
  $722E,$03 #REGa=*#R$5FC5.
  $7231,$01 Decrement to make the room ID zero-indexed.
  $7232,$03 #REGde=#R$7B2E.
  $7235,$03 Transfer the room index to #REGhl.
  $7238,$01 Multiply by #N$02 (two bytes per table entry).
  $7239,$01 Add the jump table base address.
  $723A,$03 Read the two-byte handler address from the table into #REGde.
  $723D,$01 Transfer the handler address to #REGhl. 
  $723E,$01 Jump to the room handler.

c $723F Handler: Room #N$01
@ $723F label=Handler_Room01
D $723F Handles room #N$01 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $723F B Room phase counter (from *#R$5FB1)
  $723F,$01 #REGa=#REGb.
  $7240,$02 Return if the phase counter is #N$01.
N $7243 Set up the first object.
  $7243,$04 #REGix=#R$DAD8.
  $7247,$04 #REGiy=#R$7508.
  $724B,$01 Stash the phase counter on the stack.
  $724C,$03 Call #R$7439.
  $724F,$01 Restore the phase counter from the stack.
N $7250 Set up the second object; only processed during phase #N$03.
  $7250,$04 #REGix=#R$DADC.
  $7254,$04 #REGiy=#R$750D.
  $7258,$02 Is the phase counter equal to #N$03?
  $725A,$01 Stash the phase counter on the stack.
  $725B,$03 Call #R$743D if the phase counter is #N$03.
  $725E,$01 Restore the phase counter from the stack.
N $725F From phase #N$04 onwards, call #R$77B9.
  $725F,$05 Call #R$77B9 if the phase counter is #N$04 or greater.
  $7264,$01 Return.

c $7265 Handler: Room #N$02
@ $7265 label=Handler_Room02
D $7265 Handles room #N$02 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $7265 B Room phase counter (from *#R$5FB1)
  $7265,$01 #REGa=#REGb.
  $7266,$04 #REGix=#R$DAD0.
  $726A,$02 Compare #REGa with #N$02.
  $726C,$01 Stash the phase counter on the stack.
  $726D,$03 Call #R$7512 if the phase counter is not equal to #N$02.
  $7270,$01 Restore the phase counter from the stack.
  $7271,$04 #REGix=#R$DAD8.
  $7275,$01 Stash the phase counter on the stack.
  $7276,$02 Compare the phase counter with #N$04.
  $7278,$03 Call #R$79D2 if the phase counter is greater than #N$04.
  $727B,$01 Restore the phase counter from the stack.
  $727C,$04 #REGix=#R$DAD4.
  $7280,$05 Call #R$7439 if the phase counter is greater than #N$03.
  $7285,$01 Return.

c $7286 Handler: Room #N$03
@ $7286 label=Handler_Room03

c $72BD Handler: Room #N$04
@ $72BD label=Handler_Room04

c $72E1 Handler: Room #N$05
@ $72E1 label=Handler_Room05

c $730E Handler: Room #N$06
@ $730E label=Handler_Room06
D $730E Handles room #N$06 logic (the starting screen). The phase counter in
. #REGb controls which objects are initialised or activated on each pass,
. progressively setting up more objects as the phase increases.
R $730E B Room phase counter (from *#R$5FB1)
  $730E,$01 #REGa=#REGb.
N $730F First object; initialised during phases #N$01, #N$03 and #N$04.
  $730F,$04 #REGix=#R$DAC8.
  $7313,$01 Stash the phase counter on the stack.
  $7314,$0F Call #R$794A if the phase counter is #N$01#RAW(,) #N$03 or #N$04.
  $7323,$01 Restore the phase counter from the stack.
N $7324 Second object; return early if still in phase #N$01.
  $7324,$04 #REGix=#R$DACC.
  $7328,$03 Return if the phase counter is #N$01.
  $732B,$01 Stash the phase counter on the stack.
  $732C,$03 Call #R$7512.
  $732F,$01 Restore the phase counter from the stack.
N $7330 Third object; initialised during phase #N$02, then handled every phase
. after.
  $7330,$04 #REGix=#R$DAD0.
  $7334,$02 Is the phase counter #N$02?
  $7336,$01 Stash the phase counter on the stack.
  $7337,$03 Call #R$759A if the phase counter is #N$02.
  $733A,$01 Restore the phase counter from the stack.
  $733B,$01 Return if the phase counter was #N$02.
  $733C,$01 Stash the phase counter on the stack.
  $733D,$03 Call #R$7439.
  $7340,$01 Restore the phase counter from the stack.
  $7341,$02 Return if the phase counter is #N$03.
  $7343,$01 Return.
N $7344 Fourth object; initialised during phase #N$04.
  $7344,$04 #REGix=#R$DAD4.
  $7348,$01 Stash the phase counter on the stack.
  $7349,$04 #REGiy=#R$750D.
  $734D,$05 Call #R$743D if the phase counter is #N$04.
  $7352,$01 Restore the phase counter from the stack.
  $7353,$02 Return if the phase counter is #N$04.
  $7355,$01 Return.
N $7356 Fifth object; active from phase #N$05 onwards.
  $7356,$04 #REGix=#R$DAD8.
  $735A,$01 Stash the phase counter on the stack.
  $735B,$03 Call #R$7893.
  $735E,$01 Restore the phase counter from the stack.
N $735F Update the fourth object.
  $735F,$04 #REGix=#R$DAD4.
  $7363,$03 Call #R$7680.
  $7366,$01 Return.

c $7367 Handler: Room #N$07
@ $7367 label=Handler_Room07

c $73A4 Handler: Room #N$08
@ $73A4 label=Handler_Room08

c $73E1 Handler: Room #N$09
@ $73E1 label=Handler_Room09

c $73FA Handler: Room #N$0A
@ $73FA label=Handler_Room10

c $7413 Handler: Room #N$0B
@ $7413 label=Handler_Room11

c $7439

c $74A7

c $74B9

c $74D6

g $7508
B $7508,$0A,$01

c $7512
  $7512,$04 #REGiy=#R$7AC8.
  $7516,$03 #REGhl=#R$7589.
  $7519,$03 #REGbc=#N$0739.
  $751C,$07 #REGe=(*#R$5FC5 - #N$01) * #N$04.
  $7523,$02 #REGd=#N$00.
  $7525,$02 #REGiy+=#REGde.
  $7527,$07 Call #R$7574 if *#R$5FBB is non-zero.
  $752E,$04 Test bit 7 of *#REGiy+#N$00.
  $7532,$02 Jump to #R$74B9 if #REGa is not equal to #REGa.
  $7534,$01 #REGa=*#REGhl.
  $7535,$02 Test bit 7 of #REGa.
  $7537,$01 Increment #REGhl by one.
  $7538,$02 Jump to #R$754E if #REGhl is not equal to #REGa.
  $753A,$03 #REGa=*#REGix+#N$00.
  $753D,$01 #REGa+=*#REGhl.
  $753E,$03 Compare #REGa with *#REGiy+#N$03.
  $7541,$01 Decrease #REGhl by one.
  $7542,$02 Jump to #R$7549 if #REGhl is less than #REGa.
  $7544,$03 Write #N$80 to *#REGhl.
  $7547,$02 Jump to #R$755F.

g $7679
B $7679,$07

c $7680 Handler: Plane
@ $7680 label=Handler_Plane
R $7680 A Phase counter
R $7680 IX Pointer to plane sprite data
  $7680,$01 Stash the phase counter on the stack.
  $7681,$03 Call #R$768C.
  $7684,$01 Restore the phase counter from the stack.
N $7685 The plane can only deploy paratroopers from phase #N$04 onwards.
  $7685,$03 Return if the phase counter is less than #N$04.
  $7688,$03 Call #R$7713.
  $768B,$01 Return.

c $768C Update Plane FlightPath
@ $768C label=UpdatePlaneFlightPath
R $768C IX Pointer to plane sprite data
  $768C,$04 #REGiy=#R$77AF.
  $7690,$02 #REGc=#N$04.
  $7692,$02 #REGb=#N$38.
  $7694,$07 Jump to #R$769E if *#R$5FC5 is not equal to #N$03.
  $769B,$02 #REGc=#N$40.
  $769D,$01 #REGb=#REGc.
  $769E,$07 Jump to #R$76E5 if *#R$5FBB is set.
  $76A5,$06 Jump to #R$76DE if *#REGiy+#N$02 is zero.
  $76AB,$07 Jump to #R$74B9 if  bit 7 of *#REGiy+#N$00 is set.
  $76B2,$03 #REGhl=#R$77B3.
  $76B5,$03 #REGa=*#REGix+#N$00.
  $76B8,$04 Test bit 7 of *#REGiy+#N$01.
  $76BC,$02 Jump to #R$76C8 if #REGa is not equal to #REGa.
  $76BE,$01 #REGa+=*#REGhl.
  $76BF,$04 Jump to #R$770D if #REGa is greater than or equal to #N$EE.
  $76C3,$03 Write #REGa to *#REGix+#N$00.
  $76C6,$02 Jump to #R$76CF.

  $76C8,$01 #REGa-=*#REGhl.
  $76C9,$03 Jump to #R$770D if #REGa is less than #REGc.
  $76CC,$03 Write #REGa to *#REGix+#N$00.
  $76CF,$02 #REGa=#N$4D.
  $76D1,$06 Jump to #R$76D8 if bit 7 of *#REGiy+#N$01 is set.
  $76D7,$01 Increment #REGa by one.
  $76D8,$03 Write #REGa to *#REGix+#N$03.
  $76DB,$03 Jump to #R$74D6.

  $76DE,$02 #REGa=the contents of the Memory Refresh Register.
  $76E0,$02,b$01 Keep only bits 0-6.
  $76E2,$03 Return if #REGa is not equal to #N$7F.
  $76E5,$04 Set bit 7 of *#REGiy+#N$02.
  $76E9,$16 Write #N$00 to; #LIST
. { *#R$77AE }
. { *#REGiy+#N$03 }
. { *#REGiy+#N$01 }
. { *#REGix+#N$00 }
. { *#REGix+#N$02 }
. { *#REGix+#N$01 }
. { *#REGiy+#N$00 }
. LIST#
  $76FF,$02 #REGa=the contents of the Memory Refresh Register.
  $7701,$02,b$01 Keep only bit 0.
  $7703,$01 Return if #REGa is equal to #N$7F.
  $7704,$04 Write #N$EE to *#REGix+#N$00.
  $7708,$04 Set bit 7 of *#REGiy+#N$01.
  $770C,$01 Return.

  $770D,$04 Write #N$00 to *#REGiy+#N$02.
  $7711,$02 Jump to #R$76DE.

  $7713,$03 #REGa=*#R$77AE.
  $7716,$03 Jump to #R$774D if #REGa is non-zero.
  $7719,$06 Jump to #R$776F if bit 7 of *#REGiy+#N$03 not set.
  $771F,$04 #REGix=#R$DAF0.
  $7723,$04 Write #N$14 to *#REGix+#N$03.
  $7727,$03 #REGa=*#REGix+#N$01.
  $772A,$02 #REGa+=#N$03.
  $772C,$04 Jump to #R$776A if #REGa is greater than or equal to #N$A0.
  $7730,$03 Write #REGa to *#REGix+#N$01.
  $7733,$02 Stash #REGiy on the stack.
  $7735,$04 #REGix=#R$DAC0.
  $7739,$04 #REGiy=#R$DAF0.
  $773D,$03 Call #R$6C85.
  $7740,$02 Restore #REGiy from the stack.
  $7742,$01 Return if #REGa is less than #N$A0.
  $7743,$04 Write #N$00 to *#REGiy+#N$03.
  $7747,$05 Write #N$07 to *#R$77AE.
  $774C,$01 Return.

  $774D,$01 Decrease #REGa by one.
  $774E,$03 Write #REGa to *#R$77AE.
  $7751,$03 Jump to #R$7764 if #REGa is zero.
  $7754,$01 RRA.
  $7755,$02 #REGa+=#N$36.
  $7757,$03 Write #REGa to *#R$DAC3.
  $775A,$02 #REGa=the contents of the Memory Refresh Register.
  $775C,$02,b$01 Keep only bits 0-2.
  $775E,$03 Write #REGa to *#R$DAC2.
  $7761,$03 Jump to #R$6F7A.

  $7764,$05 Write #N$FF to *#R$5FA7.
  $7769,$01 Return.

  $776A,$04 Write #N$00 to *#REGiy+#N$03.
  $776E,$01 Return.

  $776F,$02 #REGa=the contents of the Memory Refresh Register.
  $7771,$02,b$01 Keep only bits 0.
  $7773,$01 Return if #REGa is not equal to #REGa.
  $7774,$03 #REGa=*#R$DAC1.
  $7777,$02 #REGa+=#N$0A.
  $7779,$03 Compare #REGa with *#REGix+#N$01.
  $777C,$01 Return if #REGa is less than #REGa.
  $777D,$03 #REGa=*#R$DAC0.
  $7780,$02,b$01 Keep only bits 2-7.
  $7782,$01 #REGb=#REGa.
  $7783,$03 #REGa=*#REGix+#N$00.
  $7786,$02,b$01 Keep only bits 2-7.
  $7788,$02 Return if #REGa is not equal to #REGb.
  $778A,$04 Test bit 7 of *#REGiy+#N$02.
  $778E,$01 Return if #REGa is equal to #REGb.
  $778F,$04 Test bit 7 of *#REGiy+#N$00.
  $7793,$01 Return if #REGa is not equal to #REGb.
  $7794,$03 #REGa=*#REGix+#N$01.
  $7797,$02 #REGa+=#N$0A.
  $7799,$03 Write #REGa to *#R$DAF1.
  $779C,$03 #REGa=*#REGix+#N$00.
  $779F,$03 Write #REGa to *#R$DAF0.
  $77A2,$02 Write #N$FF to *#R$DAF2.
  $77A7,$04 Set bit 7 of *#REGiy+#N$03.
  $77AB,$03 Jump to #R$6F7A.
B $77AE,$01
N $77AF Plane States.
@ $77AF label=Plane_X_Position
B $77AF,$01 Plane X position.
@ $7780 label=Plane_Y_Position
B $7780,$01 Plane Y position.
@ $7781 label=Plane_Colour
B $7781,$01 Plane INK colour.
@ $7782 label=Plane_Frame_ID
B $7782,$01 Plane frame ID.
B $7783,$01
  $77B4,$04 #REGiy=#R$7B04.
  $77B8,$01 Return.

  $77B9,$07 Jump to #R$784F if *#R$5FBB is non-zero.
  $77C0,$03 #REGhl=#R$7891.
  $77C3,$07 Jump to #R$7855 if *#R$7892 is non-zero.
  $77CA,$02 #REGa=the contents of the Memory Refresh Register.
  $77CC,$02,b$01 Keep only bits 0-6.
  $77CE,$04 Jump to #R$77D5 if #REGa is not equal to #N$7F.
  $77D2,$01 #REGa=*#REGhl.
  $77D3,$01 Invert the bits in #REGa.
  $77D4,$01 Write #REGa to *#REGhl.
  $77D5,$04 Jump to #R$77E7 if *#REGhl is non-zero.
  $77D9,$03 #REGa=*#REGix+#N$00.
  $77DC,$02 #REGa+=#N$01.
  $77DE,$04 Jump to #R$7847 if #REGa is greater than or equal to #N$EE.
  $77E2,$03 Write #REGa to *#REGix+#N$00.
  $77E5,$02 Jump to #R$77F3.

  $77E7,$03 #REGa=*#REGix+#N$00.
  $77EA,$02 #REGa-=#N$01.
  $77EC,$04 Jump to #R$784B if #REGa is less than #N$04.
  $77F0,$03 Write #REGa to *#REGix+#N$00.
  $77F3,$03 Call #R$7930.
  $77F6,$02,b$01 Keep only bits 0-1.
  $77F8,$04 Jump to #R$7821 if #REGa is not equal to #N$03.
  $77FC,$02 #REGa=the contents of the Memory Refresh Register.
  $77FE,$01 #REGb=#REGa.
  $77FF,$04 Jump to #R$7812 if bit 6 of #REGa is set.
  $7803,$01 #REGa=#REGb.
  $7804,$02,b$01 Keep only bit 0.
  $7806,$03 #REGa+=*#REGix+#N$01.
  $7809,$04 Jump to #R$7821 if #REGa is greater than or equal to #N$70.
  $780D,$03 Write #REGa to *#REGix+#N$01.
  $7810,$02 Jump to #R$7821.

  $7812,$01 #REGa=#REGb.
  $7813,$02,b$01 Keep only bit 0.
  $7815,$01 #REGb=#REGa.
  $7816,$03 #REGa=*#REGix+#N$01.
  $7819,$01 #REGa-=#REGb.
  $781A,$04 Jump to #R$7821 if #REGa is less than #N$18.
  $781E,$03 Write #REGa to *#REGix+#N$01.
  $7821,$04 Write #N$49 to *#REGix+#N$03.
  $7825,$04 #REGiy=#R$DAC0.
  $7829,$03 Call #R$6C53.
  $782C,$02 Jump to #R$7831 if #REGa is less than #N$18.
  $782E,$03 Jump to #R$74E3.

  $7831,$05 Return if *#R$5FA9 is unset.
  $7836,$04 #REGiy=#R$DAE0.
  $783A,$03 Call #R$6C85.
  $783D,$01 Return if #REGa is less than #REGa.
  $783E,$05 Write #N$01 to *#R$7892.
  $7843,$03 Jump to #R$74FF.
  $7846,$01 Return.

  $7847,$02 Write #N$FF to *#REGhl.
  $7849,$02 Jump to #R$7821.

  $784B,$02 Write #N$00 to *#REGhl.
  $784D,$02 Jump to #R$7821.

  $784F,$05 Write #N$B9 to *#R$7892.
  $7854,$01 Return.

  $7855,$03 #REGhl=#R$7892.
  $7858,$01 #REGa=*#REGhl.
  $7859,$04 Jump to #R$7870 if #REGa is greater than or equal to #N$04.
  $785D,$01 Increment #REGa by one.
  $785E,$01 Write #REGa to *#REGhl.
  $785F,$02 #REGa+=#N$48.
  $7861,$03 Write #REGa to *#REGix+#N$03.
  $7864,$03 Call #R$7930.
  $7867,$02,b$01 Keep only bits 0-2.
  $7869,$03 Write #REGa to *#REGix+#N$02.
  $786C,$03 Call #R$6F7A.
  $786F,$01 Return.

  $7870,$01 Increment #REGa by one.
  $7871,$01 Write #REGa to *#REGhl.
  $7872,$03 Return if #REGa is not equal to #N$C8.
  $7875,$04 Write #N$38 to *#REGix+#N$01.
  $7879,$04 Write #N$07 to *#REGix+#N$02.
  $787D,$03 #REGhl=#R$7892.
  $7880,$02 Write #N$00 to *#REGhl.
  $7882,$04 Write #N$EE to *#REGix+#N$00.
  $7886,$03 Call #R$7930.
  $7889,$03 Return if bit 0 of #REGa is not set.
  $788C,$04 Write #N$04 to *#REGix+#N$00.
  $7890,$01 Return.
B $7891,$01
B $7892,$01

c $7893

g $7924

c $7930

c $794A Handler: Spider
@ $794A label=Handler_Spider
R $794A IX Pointer to the spider object state
  $794A,$07 Call #R$79C0 if *#R$5FBB is non-zero.
  $7951,$03 #REGhl=#R$D800(#N$D90A).
  $7954,$03 #REGbc=#N$0020 (one attribute row width).
  $7957,$03 Write #N$68 to the first row.
  $795A,$02 Write #REGa to the second row.
  $795C,$02 Write #REGa to the third row.
  $795E,$03 #REGhl=#N$480A (screen buffer address).
  $7961,$01 #REGd=#REGh (save the screen third base).
  $7962,$02 #REGc=#N$3F (base Y position of the thread).
  $7964,$03 #REGb=*#REGix+#N$01 (current height).
  $7967,$02 Subtract the base position to get the number of rows to draw.
  $7969,$01 #REGb=#REGa.

  $79D0,$01 Return.

g $79D1
B $79D1,$01

c $79D2

b $7AC3
  $7AC8
  $7B04

g $7B2E Jump Table: Room Handlers
@ $7B2E label=JumpTable_RoomHandler
W $7B2E,$02 Handler for room #N($01+(#PC-$7B2E)/$02).
L $7B2E,$02,$0B

b $7B44

b $83A9 Room #N$00
@ $83A9 label=Room00
D $83A9 #ROOM$00
  $83A9,$01

b $83AA Room #N$01
@ $83AA label=Room01
D $83AA #ROOM$01
  $84B3,$01 Terminator.

b $84B4 Room #N$02
@ $84B4 label=Room02
D $84B4 #ROOM$02
  $8756,$01 Terminator.

b $8757 Room #N$03
@ $8757 label=Room03
D $8757 #ROOM$03
  $897E,$01 Terminator.

b $897F Room #N$04
@ $897F label=Room04
D $897F #ROOM$04
  $8B06,$01 Terminator.

b $8B07 Room #N$05
@ $8B07 label=Room05
D $8B07 #ROOM$05
  $8C57,$01 Terminator.

b $8C58 Room #N$06
@ $8C58 label=Room06
D $8C58 #ROOM$06
  $8E0F,$01 Terminator.

b $8E10 Room #N$07
@ $8E10 label=Room07
D $8E10 #ROOM$07
  $8F62,$01 Terminator.

b $8F63 Room #N$08
@ $8F63 label=Room08
D $8F63 #ROOM$08
  $9177,$01 Terminator.

b $9178 Room #N$09
@ $9178 label=Room09
D $9178 #ROOM$09
  $9354,$01 Terminator.

b $9355 Room #N$0A
@ $9355 label=Room10
D $9355 #ROOM$0A
  $9459,$01 Terminator.

b $945A Room #N$0B
@ $945A label=Room11
D $945A #ROOM$0B
  $95A4,$01 Terminator.

b $95A5 Room #N$0C: Title Screen.
@ $95A5 label=Room12_TitleScreen
D $95A5 #ROOM$0C
  $9746,$01 Terminator.

b $9747

b $9BAA Graphics: Default Tile Set
@ $9BAA label=TileSet_Default
  $9BAA,$08 #UDG(#PC)
L $9BAA,$08,$F8

b $A36A Graphics: Alternate Tile Set?
@ $A36A label=TileSet_Alternate
  $A36A,$08

b $A763 Graphics: Chick Frames
@ $A763 label=Graphics_ChickFrame_01
@ $A76B label=Graphics_ChickFrame_02
  $A763,$08 #UDG(#PC,attr=$6F)
L $A763,$08,$02

b $A773 Graphics: Mayfly Frames
@ $A773 label=Graphics_MayflyFrame_01
@ $A77B label=Graphics_MayflyFrame_02
@ $A783 label=Graphics_MayflyFrame_03
@ $A78B label=Graphics_MayflyFrame_04
  $A773,$08 #UDG(#PC,attr=$68)
L $A773,$08,$04

b $A793
  $A793,$08 #UDG(#PC)
L $A793,$08,$0E

b $AB3B Graphics: Sprite Sheet
N $AB3B Percy: flying left.
@ $AB3B label=Sprite_01
@ $AB5B label=Sprite_02
@ $AB7B label=Sprite_03
@ $AB9B label=Sprite_04
N $ABBB Percy: flying right.
@ $ABBB label=Sprite_05
@ $ABDB label=Sprite_06
@ $ABFB label=Sprite_07
@ $AC1B label=Sprite_08
N $AC3B Percy: walking left.
@ $AC3B label=Sprite_09
@ $AC5B label=Sprite_0A
@ $AC7B label=Sprite_0B
@ $AC9B label=Sprite_0C
N $ACBB Percy: walking right.
@ $ACBB label=Sprite_0D
@ $ACDB label=Sprite_0E
@ $ACFB label=Sprite_0F
@ $AD1B label=Sprite_10
N $AD3B Percy: DEAD!
@ $AD3B label=Sprite_11
N $AD5B Killer Venus Snap Dragons.
@ $AD5B label=Sprite_12
@ $AD7B label=Sprite_13
@ $AD9B label=Sprite_14
@ $ADBB label=Sprite_15
@ $ADDB label=Sprite_16
@ $ADFB label=Sprite_17
N $AE1B Red Bird.
@ $AE1B label=Sprite_18
@ $AE3B label=Sprite_19
@ $AE5B label=Sprite_1A
@ $AE7B label=Sprite_1B
N $AE9B Car 1: driving right.
@ $AE9B label=Sprite_1C
@ $AEBB label=Sprite_1D
N $AEDB Car 1: driving left.
@ $AEDB label=Sprite_1E
@ $AEFB label=Sprite_1F
N $AF1B Car 2: driving right.
@ $AF1B label=Sprite_20
@ $AF3B label=Sprite_21
N $AF5B Car 2: driving left.
@ $AF5B label=Sprite_22
@ $AF7B label=Sprite_23
N $AF9B Car 3: driving right.
@ $AF9B label=Sprite_24
@ $AFBB label=Sprite_25
N $AFDB Car 3: driving left.
@ $AFDB label=Sprite_26
@ $AFFB label=Sprite_27
N $B01B Frog: jumping right.
@ $B01B label=Sprite_28
N $B03B Frog: jumping left.
@ $B03B label=Sprite_29
N $B05B Frog: sitting left.
@ $B05B label=Sprite_2A
@ $B07B label=Sprite_2B
N $B09B Frog: sitting right.
@ $B09B label=Sprite_2C
@ $B0BB label=Sprite_2D
N $B0DB Helicopter: flying left.
@ $B0DB label=Sprite_2E
@ $B0FB label=Sprite_2F
@ $B11B label=Sprite_30
@ $B13B label=Sprite_31
N $B15B Helicopter: flying right.
@ $B15B label=Sprite_32
@ $B17B label=Sprite_33
@ $B19B label=Sprite_34
@ $B1BB label=Sprite_35
N $B1DB ???
@ $B1DB label=Sprite_36
@ $B1FB label=Sprite_37
@ $B21B label=Sprite_38
N $B23B Cat: walking right.
@ $B23B label=Sprite_39
@ $B25B label=Sprite_3A
@ $B27B label=Sprite_3B
@ $B29B label=Sprite_3C
N $B2BB Cat: walking left.
@ $B2BB label=Sprite_3D
@ $B2DB label=Sprite_3E
@ $B2FB label=Sprite_3F
@ $B31B label=Sprite_40
N $B33B Dog: walking right.
@ $B33B label=Sprite_41
@ $B35B label=Sprite_42
@ $B37B label=Sprite_43
@ $B39B label=Sprite_44
N $B3BB Dog: walking left.
@ $B3BB label=Sprite_45
@ $B3DB label=Sprite_46
@ $B3FB label=Sprite_47
@ $B41B label=Sprite_48
N $B43B Paratrooper.
@ $B43B label=Sprite_49
@ $B45B label=Sprite_4A
@ $B47B label=Sprite_4B
@ $B49B label=Sprite_4C
N $B43B Plane: flying left.
@ $B4DB label=Sprite_4D
N $B4DB Plane: flying right.
@ $B4DB label=Sprite_4E
N $B4FB UFO.
@ $B4FB label=Sprite_4F
@ $B51B label=Sprite_50
@ $B53B label=Sprite_51
N $B55B Paratrooper.
@ $B55B label=Sprite_52
@ $B57B label=Sprite_53
@ $B59B label=Sprite_54
@ $B5BB label=Sprite_55
@ $B5DB label=Sprite_56
@ $B5FB label=Sprite_57
@ $B61B label=Sprite_58
@ $B63B label=Sprite_59
@ $B65B label=Sprite_5A
@ $B67B label=Sprite_5B
@ $B69B label=Sprite_5C
@ $B6BB label=Sprite_5D
@ $B6DB label=Sprite_5E
N $B6FB Spider.
@ $B6FB label=Sprite_5F
@ $B71B label=Sprite_60
  $AB3B,$20,$08 #UDGTABLE { =h Sprite ID: #N($01+(#PC-$AB3B)/$20) }
. { #UDGS$02,$02(udg#PC-56x4)(
.   #UDG(#PC+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
L $AB3B,$20,$60,$02

b $B73B

c $BB1C
  $BB1C,$04 #REGix=#R$DAC0.
  $BB20,$06 Jump to #R$BB33 if *#R$5FBE is zero.
  $BB26,$0C Copy #N$00 across #N$02BF bytes from #R$F800 onwards.
  $BB32,$01 Return.

  $BB33,$04 #REGix=#R$DAC0.
  $BB37,$05 Write #N$FF to *#R$FAC0.
  $BB3C,$02 #REGb=#N$08.
  $BB3E,$01 Stash #REGbc on the stack.
  $BB3F,$07 Jump to #R$BB4A if *#REGix+#N$01 is less than #N$A1.
  $BB46,$04 Write #N$A0 to *#REGix+#N$01.
  $BB4A,$07 Jump to #R$BDE4 if *#REGix+#N$03 is zero.
  $BB51,$03 Call #R$BC0E.
  $BB54,$01 Stash #REGhl on the stack.
  $BB55,$03 Call #R$BD5E.
  $BB58,$01 Restore #REGhl from the stack.
  $BB59,$03 Call #R$BC52.
  $BB5C,$08 Increment #REGix by four.
  $BB64,$01 Restore #REGbc from the stack.
  $BB65,$02 Decrease counter by one and loop back to #R$BB3E until counter is zero.
  $BB67,$02 #REGb=#N$08.
  $BB69,$01 Stash #REGbc on the stack.
  $BB6A,$07 Jump to #R$BB75 if *#REGix+#N$01 is less than #N$A9.
  $BB71,$04 Write #N$A8 to *#REGix+#N$01.
  $BB75,$06 Jump to #R$BB86 if *#REGix+#N$03 is zero.
  $BB7B,$03 Call #R$BC0E.
  $BB7E,$01 Stash #REGhl on the stack.
  $BB7F,$03 Call #R$BDA6.
  $BB82,$01 Restore #REGhl from the stack.
  $BB83,$03 Call #R$BCF7.
  $BB86,$08 Increment #REGix by four.
  $BB8E,$01 Restore #REGbc from the stack.
  $BB8F,$02 Decrease counter by one and loop back to #R$BB69 until counter is zero.
  $BB91,$0B Copy #N($0040,$04,$04) bytes from *#R$DAC0 to #R$DB00.
  $BB9C,$03 #REGhl=#N$F7FF.
  $BB9F,$01 #REGa=#N$00.
  $BBA0,$01 Increment #REGhl by one.
  $BBA1,$04 Jump to #R$BBA0 if *#REGhl is zero.
  $BBA5,$03 Return if #REGa is equal to #N$FF.
  $BBA8,$01 Decrease *#REGhl by one.
  $BBA9,$05 Jump to #R$BBBB if #REGa is equal to #N$02.
  $BBAE,$01 Stash #REGhl on the stack.
  $BBAF,$01 #REGa=#REGh.
  $BBB0,$02 #REGa-=#N$20.
  $BBB2,$01 #REGd=#REGa.
  $BBB3,$01 #REGe=#REGl.
  $BBB4,$01 #REGa=#REGh.
  $BBB5,$02 #REGa-=#N$A0.
  $BBB7,$01 #REGh=#REGa.
  $BBB8,$01 #REGa=*#REGde.
  $BBB9,$01 Write #REGa to *#REGhl.
  $BBBA,$01 Restore #REGhl from the stack.
  $BBBB,$01 Stash #REGhl on the stack.
  $BBBC,$01 #REGa=#REGh.
  $BBBD,$02,b$01 Keep only bits 0-1.
  $BBBF,$03 RLCA three positions.
  $BBC2,$02,b$01 Set bits 6-7.
  $BBC4,$01 #REGh=#REGa.
  $BBC5,$01 #REGb=#REGh.
  $BBC6,$01 #REGd=#REGh.
  $BBC7,$02 Set bit 5 of #REGb.
  $BBC9,$02 Reset bit 7 of #REGd.
  $BBCB,$01 #REGc=#REGl.
  $BBCC,$01 #REGe=#REGl.
  $BBCD,$01 #REGa=*#REGbc.
  $BBCE,$01 Set the bits from *#REGhl.
  $BBCF,$01 Write #REGa to *#REGde.
  $BBD0,$02 Write #N$00 to *#REGbc.
  $BBD2,$01 Increment #REGb by one.
  $BBD3,$01 Increment #REGd by one.
  $BBD4,$01 Increment #REGh by one.
  $BBD5,$01 #REGa=*#REGbc.
  $BBD6,$01 Set the bits from *#REGhl.
  $BBD7,$01 Write #REGa to *#REGde.
  $BBD8,$02 Write #N$00 to *#REGbc.
  $BBDA,$01 Increment #REGb by one.
  $BBDB,$01 Increment #REGd by one.
  $BBDC,$01 Increment #REGh by one.
  $BBDD,$01 #REGa=*#REGbc.
  $BBDE,$01 Set the bits from *#REGhl.
  $BBDF,$01 Write #REGa to *#REGde.
  $BBE0,$02 Write #N$00 to *#REGbc.
  $BBE2,$01 Increment #REGb by one.
  $BBE3,$01 Increment #REGd by one.
  $BBE4,$01 Increment #REGh by one.
  $BBE5,$01 #REGa=*#REGbc.
  $BBE6,$01 Set the bits from *#REGhl.
  $BBE7,$01 Write #REGa to *#REGde.
  $BBE8,$02 #N$00 to *#REGbc.
  $BBEA,$01 Increment #REGb by one.
  $BBEB,$01 Increment #REGd by one.
  $BBEC,$01 Increment #REGh by one.
  $BBED,$01 #REGa=*#REGbc.
  $BBEE,$01 Set the bits from *#REGhl.
  $BBEF,$01 Write #REGa to *#REGde.
  $BBF0,$02 Write #N$00 to *#REGbc.
  $BBF2,$01 Increment #REGb by one.
  $BBF3,$01 Increment #REGd by one.
  $BBF4,$01 Increment #REGh by one.
  $BBF5,$01 #REGa=*#REGbc.
  $BBF6,$01 Set the bits from *#REGhl.
  $BBF7,$01 Write #REGa to *#REGde.
  $BBF8,$02 Write #N$00 to *#REGbc.
  $BBFA,$01 Increment #REGd by one.
  $BBFB,$01 Increment #REGh by one.
  $BBFC,$01 Increment #REGb by one.
  $BBFD,$01 #REGa=*#REGbc.
  $BBFE,$01 Set the bits from *#REGhl.
  $BBFF,$01 Write #REGa to *#REGde.
  $BC00,$01 #REGa=#N$00.
  $BC01,$01 Write #REGa to *#REGbc.
  $BC02,$01 Increment #REGb by one.
  $BC03,$01 Increment #REGh by one.
  $BC04,$01 Increment #REGd by one.
  $BC05,$01 #REGa=*#REGbc.
  $BC06,$01 Set the bits from *#REGhl.
  $BC07,$01 Write #REGa to *#REGde.
  $BC08,$02 Write #N$00 to *#REGbc.
  $BC0A,$01 Restore #REGhl from the stack.
  $BC0B,$03 Jump to #R$BBA0.

c $BC0E Calculate Screen Buffer Address
@ $BC0E label=CalculateScreenBufferAddress
D $BC0E Converts a screen coordinate stored at #REGix into a screen buffer
. address and pixel offset. The coordinate is stored as a two-byte value where
. #REGix+#N$00 holds the X position and #REGix+#N$01 holds the Y position.
. Returns with #REGhl pointing to the screen buffer address, #REGa (shadow)
. holding the row within the character cell (bits 0-2 of Y), and #REGa holding
. the pixel offset within the byte (bits 0-2 of X).
R $BC0E IX Pointer to a two-byte screen coordinate (X, Y)
R $BC0E O:HL Screen buffer address
R $BC0E O:A Pixel X offset within the byte (bits 0-2)
R $BC0E O:AF' Row within the character cell (bits 0-2 of Y)
  $BC0E,$03 #REGc=*#REGix+#N$00.
  $BC11,$03 #REGb=*#REGix+#N$01.
  $BC14,$01 #REGa=#REGc.
  $BC15,$02,b$01 Keep only bits 0-2.
  $BC17,$01 Stash the pixel X offset on the stack.
N $BC18 Calculate the low byte of the screen buffer address. This combines the
. character column (X / 8) with the Y pixel row bits.
  $BC18,$01 #REGa=#REGc.
  $BC19,$03 Rotate right three positions to divide X by #N$08.
  $BC1C,$02,b$01 Keep only bits 0-4 (character column, #N$00-#N$1F).
  $BC1E,$01 #REGl=#REGa.
  $BC1F,$01 #REGa=#REGb.
  $BC20,$02 Rotate left two positions.
  $BC22,$02,b$01 Keep only bits 5-7 (low bits of Y row).
  $BC24,$01 Merge the column and row bits together.
  $BC25,$01 #REGl=#REGa.
  $BC26,$01 #REGa=#REGb.
N $BC26 Calculate the high byte of the screen buffer address. This encodes the
. character row and third-of-screen into the high byte, with the base address
. of #N$E000 (bits 5-7 set).
  $BC27,$02,b$01 Keep only bits 0-2 (pixel row within character cell).
  $BC29,$01 #REGh=#REGa.
  $BC2A,$01 #REGa=#REGb.
  $BC2B,$02,b$01 Keep only bits 6-7 (screen third selector).
  $BC2D,$03 Rotate right three positions to move bits 6-7 into bits 3-4.
  $BC30,$01 Merge with the pixel row bits in #REGh.
  $BC31,$02,b$01 Set bits 5-7 for the screen buffer base address (#N$E000).
  $BC33,$01 #REGh=#REGa.
N $BC34 Store the Y pixel row (character cell row) in shadow #REGaf and restore
. the pixel X offset as the return value in #REGa.
  $BC34,$01 Store the row-within-character in shadow #REGaf.
  $BC35,$01 Restore the pixel X offset from the stack.
  $BC36,$01 Return.

c $BC37

c $BC52 Apply Sprite Attributes (3-Wide)
@ $BC52 label=ApplySpriteAttributes3Wide
D $BC52 Applies colour attributes to a sprite's screen position. First writes
. the sprite's own colour attribute, then writes the background colour (#N$02,
. #INK$02 ink) on top. The sprite occupies a 3x2 or 3x3 character cell area
. depending on alignment.
R $BC52 HL Screen buffer address of the sprite
R $BC52 IX Pointer to the sprite state data
  $BC52,$02 Set the attribute base to #N$58 (i.e. the attribute buffer at
. #N$5800).
  $BC54,$02 #REGd=#N$00.
N $BC56 Check if the sprite's X position is on a character boundary. If not,
. set bit 0 of #REGd to indicate an extra column is needed.
  $BC56,$03 Load #REGa with the sprite X position from *#REGix+#N$00.
  $BC59,$02,b$01 Keep only bits 0-2 (sub-character X offset).
  $BC5B,$02 Jump to #R$BC5F if X-aligned.
  $BC5D,$02 Set bit 0 of #REGd (not X-aligned, need extra column).
N $BC5F First pass: write the sprite's own colour attribute to the attribute
. file. Skip if the attribute is #N$FF (transparent).
@ $BC5F label=ApplySpriteAttributes3Wide_SpriteColour
  $BC5F,$03 Load #REGe with the sprite colour attribute from *#REGix+#N$02.
  $BC62,$05 Jump to #R$BC6C if the attribute byte is transparent (#N$FF).
  $BC67,$01 Stash the screen buffer address on the stack.
  $BC68,$03 Call #R$BC74 to write the sprite attribute.
  $BC6B,$01 Restore the screen buffer address from the stack.
N $BC6C Second pass: write the background attribute (#N$02, #INK$02 ink) over
. the sprite area using the room attribute base (#N$F8 maps to #R$D800).
@ $BC6C label=ApplySpriteAttributes3Wide_Background
  $BC6C,$02 #REGc=#N$F8.
  $BC6E,$02 #REGe=#INK$02.
  $BC70,$03 Call #R$BC74 to write the background attribute.
  $BC73,$01 Return.

c $BC74 Write Attribute Block (3-Wide)
@ $BC74 label=WriteAttributeBlock3Wide
D $BC74 Writes a colour attribute to a 3-wide block of attribute cells at the
. position derived from the screen buffer address in #REGhl. The height is 2
. rows if Y-aligned, or 3 rows if not. The width is 2 or 3 columns depending on
. bit 0 of #REGd (X alignment).
R $BC74 C Attribute base high byte (#N$58 for screen, #N$F8 for room)
R $BC74 D Bit 0: extra column needed, Bit 1: extra row needed
R $BC74 E Attribute value to write (ink bits 0-2)
R $BC74 HL Screen buffer address
N $BC74 Check if the Y position crosses a character boundary; if so, an extra
. row of attributes is needed.
  $BC74,$01 #REGa=#REGh.
  $BC75,$02,b$01 Keep only bits 0-2 (sub-character Y offset).
  $BC77,$03 Jump to #R$BC7C if Y-aligned.
  $BC7A,$02 Set bit 1 of #REGd (extra row needed).
N $BC7C Convert the screen buffer address to the corresponding attribute address.
@ $BC7C label=WriteAttributeBlock3Wide_CalcAddress
  $BC7C,$01 #REGa=#REGh.
  $BC7D,$03 Rotate right three positions.
  $BC80,$02,b$01 Keep only bits 0-1.
  $BC82,$01 Merge with the attribute base in #REGc.
  $BC83,$01 #REGh=#REGa.
N $BC84 Branch based on whether an extra column is needed.
  $BC84,$02 Test bit 0 of #REGd.
  $BC86,$02 Jump to #R$BCC8 if X-aligned (2 columns wide).

N $BC88 Not X-aligned: write attributes across 3 columns.
@ $BC88 label=WriteAttributeBlock3Wide_3Columns
N $BC88 Write attribute to the first row (3 cells).
M $BC88,$05 Write the ink bits to *#REGhl (preserve paper/brightness).
  $BC89,$02,b$01 Keep only bits 3-7.
  $BC8D,$01 Move to the next column.
  $BC8E,$01 Write the ink bits to *#REGhl.
  $BC8F,$02,b$01 Keep only bits 3-7.
  $BC93,$01 Move to the next column.
M $BC94,$05 Write the ink bits to *#REGhl.
  $BC95,$02,b$01 Keep only bits 3-7.
N $BC99 Move back to the first column and down one attribute row.
  $BC99,$02 Move back two columns.
  $BC9B,$04 #REGhl+=#N($0020,$04,$04) (move down one row).
N $BC9F Write attribute to the second row (3 cells).
M $BC9F,$05 Write the ink bits to *#REGhl.
  $BCA0,$02,b$01 Keep only bits 3-7.
  $BCA4,$01 Move to the next column.
M $BCA5,$05 Write the ink bits to *#REGhl.
  $BCA6,$02,b$01 Keep only bits 3-7.
  $BCAA,$01 Move to the next column.
M $BCAB,$05 Write the ink bits to *#REGhl.
  $BCAC,$02,b$01 Keep only bits 3-7.
N $BCB0 If Y-aligned, we're done. Otherwise write a third row.
  $BCB0,$02 Test bit 1 of #REGd.
  $BCB2,$01 Return if Y-aligned (no extra row needed).
N $BCB3 Move back and down to the third row.
  $BCB3,$02 Move back two columns.
  $BCB5,$01 #REGhl+=#REGbc (move down one row).
N $BCB6 Write attribute to the third row (3 cells).
M $BCB6,$05 Write the ink bits to *#REGhl.
  $BCB7,$02,b$01 Keep only bits 3-7.
  $BCBB,$01 Move to the next column.
M $BCBC,$05 Write the ink bits to *#REGhl.
  $BCBD,$02,b$01 Keep only bits 3-7.
  $BCC1,$01 Move to the next column.
M $BCC2,$05 Write the ink bits to *#REGhl.
  $BCC3,$02,b$01 Keep only bits 3-7.
  $BCC7,$01 Return.

N $BCC8 X-aligned: write attributes across 2 columns only.
@ $BCC8 label=WriteAttributeBlock3Wide_2Columns
N $BCC8 Write attribute to the first row (2 cells).
M $BCC8,$05 Write the ink bits to *#REGhl.
  $BCC9,$02,b$01 Keep only bits 3-7.
  $BCCD,$01 Move to the next column.
M $BCCE,$05 Write the ink bits to *#REGhl.
  $BCCF,$02,b$01 Keep only bits 3-7.
N $BCD3 Move back and down one attribute row.
  $BCD3,$01 Move back one column.
  $BCD4,$04 #REGhl+=#N($0020,$04,$04) (move down one row).
N $BCD8 Write attribute to the second row (2 cells).
M $BCD8,$05 Write the ink bits to *#REGhl.
  $BCD9,$02,b$01 Keep only bits 3-7.
  $BCDD,$01 Move to the next column.
M $BCDE,$05 Write the ink bits to *#REGhl.
  $BCDF,$02,b$01 Keep only bits 3-7.
N $BCE3 If Y-aligned, we're done. Otherwise write a third row.
  $BCE3,$02 Test bit 1 of #REGd.
  $BCE5,$01 Return if Y-aligned.
N $BCE6 Move back and down to the third row.
  $BCE6,$01 Move back one column.
  $BCE7,$01 #REGhl+=#REGbc (move down one row).
N $BCE8 Write attribute to the third row (2 cells).
M $BCE8,$05 Write the ink bits to *#REGhl.
  $BCE9,$02,b$01 Keep only bits 3-7.
  $BCED,$01 Move to the next column.
M $BCEE,$05 Write the ink bits to *#REGhl.
  $BCEF,$02,b$01 Keep only bits 3-7.
  $BCF3,$01 Return.

b $BCF4
  $BCF4,$03

c $BCF7 Apply Sprite Attributes (2-Wide)
@ $BCF7 label=ApplySpriteAttributes2Wide
D $BCF7 Applies colour attributes to a smaller (2-wide) sprite's screen
. position. Works the same as #R$BC52 but for sprites that are only 2 character
. cells wide.
R $BCF7 HL Screen buffer address of the sprite
R $BCF7 IX Pointer to the sprite state data
  $BCF7,$02 Set the attribute base to #N$58 (i.e. the attribute buffer at
. #N$5800).
  $BCF9,$02 #REGd=#N$00.
N $BCFB Check if the sprite's X position is on a character boundary.
  $BCFB,$03 Load #REGa with the sprite X position from *#REGix+#N$00.
  $BCFE,$02,b$01 Keep only bits 0-2 (sub-character X offset).
  $BD00,$02 Jump to #R$BD04 if X-aligned.
  $BD02,$02 Set bit 0 of #REGd (not X-aligned, need extra column).
N $BD04 First pass: write the sprite's own colour attribute. Skip if the
. attribute byte is #N$FF (transparent).
@ $BD04 label=ApplySpriteAttributes2Wide_SpriteColour
  $BD04,$03 Load #REGe with the sprite colour attribute from *#REGix+#N$02.
  $BD07,$05 Jump to #R$BD11 if the attribute byte is transparent (#N$FF).
  $BD0C,$01 Stash the screen buffer address on the stack.
  $BD0D,$03 Call #R$BD19 to write the sprite attribute.
  $BD10,$01 Restore the screen buffer address from the stack.
N $BD11 Second pass: write the background attribute (#N$02, #INK$02 ink) over
. the sprite area using the room attribute base (#N$F8 maps to #R$D800).
@ $BD11 label=ApplySpriteAttributes2Wide_Background
  $BD11,$02 #REGc=#N$F8.
  $BD13,$02 #REGe=#INK$02.
  $BD15,$03 Call #R$BD19 to write the background attribute.
  $BD18,$01 Return.

c $BD19 Write Attribute Block (2-Wide)
@ $BD19 label=WriteAttributeBlock2Wide
D $BD19 Writes a colour attribute to a 2-wide block of attribute cells. The
. height is 1-2 rows if Y-aligned, or 2-3 rows if not. The width is 1 or 2
. columns depending on X alignment.

R $BD19 C Attribute base high byte (#N$58 for screen, #N$F8 for room)
R $BD19 D Bit 0: extra column needed, Bit 1: extra row needed
R $BD19 E Attribute value to write (ink bits 0-2)
R $BD19 HL Screen buffer address
N $BD19 Check if the Y position crosses a character boundary.
  $BD19,$01 #REGa=#REGh.
  $BD1A,$02,b$01 Keep only bits 0-2.
  $BD1C,$03 Jump to #R$BD21 if Y-aligned.
  $BD1F,$02 Set bit 1 of #REGd (extra row needed).
N $BD21 Convert the screen buffer address to the attribute address.
@ $BD21 label=WriteAttributeBlock2Wide_CalcAddress
  $BD21,$01 #REGa=#REGh.
  $BD22,$03 Rotate right three positions.
  $BD25,$02,b$01 Keep only bits 0-1.
  $BD27,$01 Merge with the attribute base in #REGc.
  $BD28,$01 #REGh=#REGa.
N $BD29 Branch based on whether an extra column is needed.
  $BD29,$02 Test bit 0 of #REGd.
  $BD2B,$02 Jump to #R$BD4C if X-aligned (1 column wide).

N $BD2D Not X-aligned: write attributes across 2 columns.
@ $BD2D label=WriteAttributeBlock2Wide_2Columns
N $BD2D Write attribute to the first row (2 cells).
  $BD2D,$04 Write the ink bits to *#REGhl.
  $BD32,$01 Move to the next column.
  $BD33,$04 Write the ink bits to *#REGhl.
N $BD38 Return if Y-aligned, otherwise write a second row.
  $BD38,$01 Move back one column.
  $BD39,$02 Test bit 1 of #REGd.
  $BD3B,$01 Return if Y-aligned.
N $BD3C Move down one attribute row.
  $BD3C,$03 #REGbc=#N$0020.
  $BD3F,$01 #REGhl+=#REGbc.
N $BD40 Write attribute to the second row (2 cells).
  $BD40,$04 Write the ink bits to *#REGhl.
  $BD45,$01 Move to the next column.
  $BD46,$04 Write the ink bits to *#REGhl.
  $BD4B,$01 Return.

N $BD4C X-aligned: write attributes across 1 column only.
@ $BD4C label=WriteAttributeBlock2Wide_1Column
N $BD4C Write attribute to the first row (1 cell).
  $BD4C,$04 Write the ink bits to *#REGhl.
N $BD51 Return if Y-aligned, otherwise write a second row.
  $BD51,$02 Test bit 1 of #REGd.
  $BD53,$01 Return if Y-aligned.
N $BD54 Move down one attribute row.
  $BD54,$03 #REGbc=#N$0020.
  $BD57,$01 #REGhl+=#REGbc.
N $BD58 Write attribute to the second row (1 cell).
  $BD58,$04 Write the ink bits to *#REGhl.
  $BD5D,$01 Return.

c $BD5E Draw Sprite Column
@ $BD5E label=DrawSpriteColumn
R $BD5E A Shift amount (self-modified into the code)
R $BD5E HL Screen buffer address
R $BD5E IX Pointer to sprite data (IX+#N$03 = one-indexed frame number)
N $BD5E Self-modify the shift loop counter at #R$BD81(#N$BD82).
  $BD5E,$03 Write #REGa to *#R$BD81(#N$BD82).
N $BD61 Look up the sprite frame graphic data. Each frame is #N$20 bytes, so
. multiply the zero-indexed frame number by #N$20 and add the sprite sheet base
. address.
  $BD61,$01 Stash the screen buffer address on the stack.
  $BD62,$03 #REGde=#R$AB3B (sprite sheet base address).
  $BD65,$03 #REGl=*#REGix+#N$03 (one-indexed frame number).
  $BD68,$01 Decrement to make it zero-indexed.
  $BD69,$03 Create an offset in #REGhl using the frame index.
  $BD6C,$04 Multiply #REGhl by #N$20.
  $BD70,$01 Add the sprite sheet base address.
  $BD71,$01 Exchange so #REGde points to the sprite graphic data.
  $BD72,$01 Restore the screen buffer address from the stack.
N $BD73 Draw #N$02 columns, each #N$10 pixel rows tall. #REGc holds a mask of
. #N$07 used to detect character cell boundaries for screen address adjustment.
  $BD73,$02 Set a column counter in #REGb of #N$02 columns.
@ $BD75 label=DrawSpriteColumn_ColumnLoop
  $BD75,$02 #REGc=#N$07 (pixel row mask for character cell boundary detection).
  $BD77,$02 Stash the column counter and screen buffer address on the stack.
  $BD79,$02 Set a row counter in #REGb of #N$10 pixel rows.
N $BD7B For each row, read a byte of sprite data, shift it left by the
. self-modified amount and OR the resulting two bytes across two adjacent
. screen buffer columns.
@ $BD7B label=DrawSpriteColumn_RowLoop
  $BD7B,$02 Stash the sprite data pointer and screen buffer address on the stack.
N $BD7D Read the sprite data byte and shift it into a 16-bit value in #REGhl.
N $BD7D The shift amount at #R$BD81(#N$BD82) was self-modified on entry to
. control the horizontal pixel alignment.
  $BD7D,$01 #REGa=*#REGde.
  $BD7E,$03 Transfer sprite byte to #REGhl (clearing the high byte).
  $BD81,$02 Jump into the shift loop at #R$BD84.
@ $BD83 label=DrawSpriteColumn_ShiftExtra
  $BD83,$01 Shift #REGhl left one position.
@ $BD84 label=DrawSpriteColumn_ShiftLoop
  $BD84,$06 Shift #REGhl left a further seven positions (eight total from
. #R$BD83, or seven from #R$BD84).
N $BD8B OR the shifted sprite data onto the screen buffer. The high byte goes
N $BD8B into the current column and the low byte into the adjacent column.
  $BD8A,$01 Stash placeholder (last shift).
  $BD8B,$02 Restore the screen buffer address into #REGde, keeping a copy on the
. stack.
  $BD8D,$01 Exchange so #REGhl=screen buffer address, #REGde=shifted sprite data.
  $BD8E,$03 OR the high byte of the sprite data onto *#REGhl.
  $BD91,$03 Move to the next column and OR the low byte of the sprite data onto
. *#REGhl.
  $BD95,$02 Restore the screen buffer address and sprite data pointer from the
. stack.
N $BD97 Move down one pixel row in the screen buffer and check for a character
. cell boundary crossing.
  $BD97,$01 Move down one pixel row in the screen buffer.
  $BD98,$02 Test if we've crossed a character cell boundary (every #N$08 rows).
  $BD9A,$03 Call #R$BC37 to adjust the screen buffer address if a character cell
. boundary was crossed.
N $BD9D Move to the next sprite data byte and loop.
  $BD9D,$01 Advance the sprite data pointer.
  $BD9E,$02 Decrease the row counter by one and loop back to #R$BD7B until all
. #N$10 rows are drawn.
N $BDA0 Move to the next column in the screen buffer and loop.
  $BDA0,$01 Restore the screen buffer address from the stack.
  $BDA1,$01 Restore the column counter from the stack.
  $BDA2,$01 Move one byte to the right in the screen buffer.
  $BDA3,$02 Decrease the column counter by one and loop back to #R$BD75 until
. both columns are drawn.
  $BDA5,$01 Return.

c $BDA6

g $BE00 Table: Red Bird Flight Path Data
@ $BE00 label=Table_RedBirdFlightPath_01
N $BE00 Room #N$01.
  $BE00,$0C
  $BE0C,$01 Terminator.
@ $BE0D label=Table_RedBirdFlightPath_02
N $BE0D Room #N$02.
  $BE0D,$04
  $BE11,$01 Terminator.
@ $BE12 label=Table_RedBirdFlightPath_03
N $BE12 Room #N$03.
  $BE12,$0C
  $BE1E,$01 Terminator.
@ $BE1F label=Table_RedBirdFlightPath_04
N $BE1F Room #N$04.
  $BE1F,$0C
  $BE2B,$01 Terminator.
@ $BE2C label=Table_RedBirdFlightPath_05
N $BE2C Room #N$05.
  $BE2C,$0C
  $BE38,$01 Terminator.
@ $BE39 label=Table_RedBirdFlightPath_06
N $BE39 Room #N$06.
  $BE39,$0C
  $BE45,$01 Terminator.
@ $BE46 label=Table_RedBirdFlightPath_07
N $BE46 Room #N$07.
  $BE46,$0C
  $BE52,$01 Terminator.
@ $BE53 label=Table_RedBirdFlightPath_08
N $BE53 Room #N$08.
  $BE53,$10
  $BE63,$01 Terminator.
@ $BE64 label=Table_RedBirdFlightPath_09
N $BE64 Room #N$09.
  $BE64,$10
  $BE74,$01 Terminator.
@ $BE75 label=Table_RedBirdFlightPath_10
N $BE75 Room #N$0A.
  $BE75,$10
  $BE85,$01 Terminator.
@ $BE86 label=Table_RedBirdFlightPath_11
N $BE86 Room #N$0B.
  $BE86,$0C
  $BE92,$01 Terminator.

g $C000 Room Buffer
@ $C000 label=RoomBuffer
B $C000,$1800,$20
@ $D800 label=RoomAttributeBuffer
B $D800,$02C0,$20

g $DAC0 Percy States
@ $DAC0 label=Percy_X_Position
B $DAC0,$01 Percy X position.
@ $DAC1 label=Percy_Y_Position
B $DAC1,$01 Percy Y position.
@ $DAC2 label=Percy_Colour
B $DAC2,$01 Percy INK colour.
@ $DAC3 label=Percy_Frame_ID
B $DAC3,$01 Percy frame ID.

g $DAC4 Sprite 1 Data States
@ $DAC4 label=Sprite01_X_Position
D $DAC4 Used by the Red Bird.
B $DAC4,$01 Sprite 1 X position.
@ $DAC5 label=Sprite01_Y_Position
B $DAC5,$01 Sprite 1 Y position.
@ $DAC6 label=Sprite01_Colour
B $DAC6,$01 Sprite 1 INK colour.
@ $DAC7 label=Sprite01_Frame_ID
B $DAC7,$01 Sprite 1 frame ID.

g $DAC8 Sprite 2 Data States
@ $DAC8 label=Sprite02_X_Position
D $DAC8 Used by Frog 1.
B $DAC8,$01 Sprite 2 X position.
@ $DAC9 label=Sprite02_Y_Position
B $DAC9,$01 Sprite 2 Y position.
@ $DACA label=Sprite02_Colour
B $DACA,$01 Sprite 2 INK colour.
@ $DACB label=Sprite02_Frame_ID
B $DACB,$01 Sprite 2 frame ID.

g $DACC Sprite 3 Data States
@ $DACC label=Sprite03_X_Position
D $DACC Used by Frog 2.
B $DACC,$01 Sprite 3 X position.
@ $DACD label=Sprite03_Y_Position
B $DACD,$01 Sprite 3 Y position.
@ $DACE label=Sprite03_Colour
B $DACE,$01 Sprite 3 INK colour.
@ $DACF label=Sprite03_Frame_ID
B $DACF,$01 Sprite 3 frame ID.

g $DAD0 Car 2 States
@ $DAD0 label=Car02_X_Position
B $DAD0,$01 Car 2 X position.
@ $DAD1 label=Car02_Y_Position
B $DAD1,$01 Car 2 Y position.
@ $DAD2 label=Car02_Colour
B $DAD2,$01 Car 2 INK colour.
@ $DAD3 label=Car02_Frame_ID
B $DAD3,$01 Car 2 frame ID.

g $DAD4 Car 3 States
@ $DAD4 label=Car03_X_Position
B $DAD4,$01 Car 3 X position.
@ $DAD5 label=Car03_Y_Position
B $DAD5,$01 Car 3 Y position.
@ $DAD6 label=Car03_Colour
B $DAD6,$01 Car 3 INK colour.
@ $DAD7 label=Car03_Frame_ID
B $DAD7,$01 Car 3 frame ID.

g $DAD8
B $DAD8,$01
B $DAD9,$01
B $DADA,$01
B $DADB,$01

g $DADC
B $DADC,$01
B $DADD,$01
B $DADE,$01
B $DADF,$01

g $DAE0 Egg States?
@ $DAE0 label=Egg_States
B $DAE0,$01
B $DAE1,$01
B $DAE2,$01
B $DAE3,$01

g $DAE4
B $DAE4,$01
B $DAE5,$01
B $DAE6,$01
B $DAE7,$01

g $DAE8
B $DAE8,$01
B $DAE9,$01
B $DAEA,$01
B $DAEB,$01

g $DAEC
B $DAEC,$01
B $DAED,$01
B $DAEE,$01
B $DAEF,$01

g $DAF0
B $DAF0,$01
B $DAF1,$01
B $DAF2,$01
B $DAF3,$01

g $DAF4
B $DAF4,$01
B $DAF5,$01
B $DAF6,$01
B $DAF7,$01

g $DAF8
B $DAF8,$01
B $DAF9,$01
B $DAFA,$01
B $DAFB,$01

g $DAFC
B $DAFC,$01
B $DAFD,$01
B $DAFE,$01
B $DAFF,$01

g $DB00 Percy Previous X Position
@ $DB00 label=PercyPreviousXPosition
D $DB00 Stores Percy's X position from the previous frame, used to detect
. horizontal movement for the wing flap animation.
B $DB00,$01

g $DB0C

b $DE9E

g $E000 Sprite Buffer
@ $E000 label=SpriteBuffer
B $E000,$1800,$20

b $F800

g $FAC0
B $FAC0,$01

c $FAC1 Play Next Level Jingle
@ $FAC1 label=PlaySound_NextLevelJingle
N $FAC1 #HTML(#AUDIO(next-level.wav)(#INCLUDE(NextLevel)))
  $FAC1,$03 Load #REGhl with a pointer to #R$FAF9.
@ $FAC4 label=PlaySound
  $FAC4,$01 No operation.
@ $FAC5 label=PlaySound_Loop
  $FAC5,$01 Fetch the music data from *#REGhl.
  $FAC6,$03 Return if this is the terminator (#N$FF).
  $FAC9,$03 Jump to #R$FAEA if this is a rest.
  $FACC,$03 Set the speaker port to off.
  $FACF,$02 Load the pitch period into both #REGe (reset value) and #REGd
. (countdown).
  $FAD1,$02 Load the note duration into #REGc.
@ $FAD3 label=PlaySound_NoteLoop
  $FAD3,$02 Send to the speaker to play the note.
  $FAD5,$01 Decrease the period counter by one.
  $FAD6,$02 Jump to #R$FADB if the period hasn't elapsed yet.
  $FAD8,$01 Reset the period counter from #REGe.
  $FAD9,$02,b$01 Toggle the speaker and MIC outputs.
@ $FADB label=PlaySound_NoteInnerLoop
  $FADB,$02 Decrease counter by one and loop back to #R$FAD3 until counter is zero.
  $FADD,$01 Decrease the duration counter.
  $FADE,$02 Jump back to #R$FAD3 until the full duration has elapsed.
  $FAE0,$01 Advance to the next sound data entry.
  $FAE1,$04 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
  $FAE5,$02,b$01 Keep only bit 0.
  $FAE7,$01 Return if the result is zero.
M $FAE5,$03 Return if "ENTER" has been pressed.
  $FAE8,$02 Jump back to #R$FAC5.
@ $FAEA label=PlaySound_Rest
  $FAEA,$01 Increment #REGhl by one.
  $FAEB,$01 #REGc=*#REGhl.
@ $FAEC label=PlaySound_RestOuterLoop
  $FAEC,$01 No operation.
@ $FAED label=PlaySound_RestInnerLoop
  $FAED,$01 No operation.
  $FAEE,$01 No operation.
  $FAEF,$01 No operation.
  $FAF0,$01 No operation.
  $FAF1,$02 Decrease the counter by one and loop back to #R$FAED until counter is zero.
  $FAF3,$01 Decrease the rest duration counter.
  $FAF4,$02 Jump back to #R$FAEC until the full rest duration has elapsed.
  $FAF6,$01 Advance to the next sound data entry.
  $FAF7,$02 Jump back to #R$FAC5.

b $FAF9 Audio: Next Level Jingle
@ $FAF9 label=Audio_NextLevelJingle
@ $FBF9 label=Audio_LoseLifeJingle
  $FAF9,$0120
  $FC19,$02 Terminator.

c $FC1B Print Author Byline
@ $FC1B label=Print_AuthorByline
D $FC1B Prints the Author Byline messaging to the screen buffer.
  $FC1B,$06 Jump to #R$FC52 if *#R$5FBC is set.
  $FC21,$03 Point #REGde at #R$FC3D.
  $FC24,$03 Load #REGhl with #N$50A6 (screen buffer location to print).
  $FC27,$02 Set a counter in #REGb for #N$15 characters to print to the screen
. buffer.
  $FC29,$03 Call #R$FC2E.
  $FC2C,$02 Jump to #R$FC89.

c $FC2E Print Message
@ $FC2E label=PrintMessage_Loop
R $FC2E B Number of characters to print
R $FC2E DE Pointer to message string
R $FC2E HL Screen buffer target address for printing
  $FC2E,$01 Fetch the character to print from *#REGde.
  $FC2F,$03 Stash the message pointer, screen buffer location and character
. counter on the stack.
  $FC32,$03 Call #R$6581.
  $FC35,$02 Restore the character counter and screen buffer location from the
. stack.
  $FC37,$01 Restore the message pointer from the stack.
  $FC38,$01 Move to the next position in the screen buffer.
  $FC39,$01 Move to the next character in the message.
  $FC3A,$02 Decrease the character counter by one and loop back to #R$FC2E
. until the entire message has been printed to the screen buffer.
  $FC3C,$01 Return.

t $FC3D Messaging: Author Byline
@ $FC3D label=Messaging_AuthorByline
  $FC3D,$15 "#STR(#PC,$04,$15)".

c $FC52 Print High Score
@ $FC52 label=Print_HighScore
D $FC52 Checks if the current score is a new high score, and if so, copies it
. to the high score storage.
. Then prints the high score label and value to the screen.
N $FC52 Compare the current score with the stored high score, byte by byte
. (most significant digit first).
  $FC52,$03 Point #REGhl at #R$6825(#N$682C) (the last digit of the current
. score).
@ $FC55 label=PrintHighScore_Compare
  $FC55,$02 Set a counter in #REGb for #N$07 digits to compare.
@ $FC57 label=PrintHighScore_ComparePointer
  $FC57,$03 Point #REGde at #R$FCA6(#N$FCAD) (the last digit of the stored high
. score).
@ $FC5A label=PrintHighScore_CompareLoop
  $FC5A,$01 Fetch a digit from the stored high score.
@ $FC5B label=PrintHighScore_CompareDigit
  $FC5B,$03 Jump to #R$FC62 if the high score digit is equal to the same digit
. of the current score.
  $FC5E,$02 Jump to #R$FC73 if the high score digit is greater than or equal to
. the same digit of the current score.
  $FC60,$02 Jump to #R$FC68 if the high score digit is less than the same digit
. of the current score.
@ $FC62 label=PrintHighScore_NextDigit
  $FC62,$01 Move to the next digit in the current score.
@ $FC63 label=PrintHighScore_NextScoreDigit
  $FC63,$01 Move to the next digit in the high score.
  $FC64,$02 Decrease the digit counter by one and loop back to #R$FC5A until
. all #N$07 digits have been compared.
N $FC66 All digits matched so scores are equal, so no update needed.
  $FC66,$02 Jump to #R$FC73.
N $FC68 New high score so copy the current score over the stored high score.
@ $FC68 label=PrintHighScore_NewHighScore
  $FC68,$0B Copy #N($0007,$04,$04) bytes of data from *#R$6825 to *#R$FCA6.
N $FC73 Print the high score label and value to the screen buffer.
@ $FC73 label=PrintHighScore_Display
  $FC73,$03 #REGhl=#N$50A7 (screen buffer location).
  $FC76,$02 Set a counter in #REGb for #N$0C characters to print to the screen
. buffer.
  $FC78,$03 #REGde=#R$FC99.
  $FC7B,$03 Call #R$FC2E.
  $FC7E,$04 #REGix=#R$FCA6.
  $FC82,$04 #REGhl+=#N($0007,$04,$04).
  $FC86,$03 Call #R$6811.
N $FC89 Reset the current score to zero and return to the game flow.
@ $FC89 label=PrintHighScore_ResetScore
  $FC89,$0D Clear #N($000A,$04,$04) bytes of data from *#R$6825 onwards.
  $FC96,$03 Jump to #R$FAC1.

t $FC99 Messaging: High Score
@ $FC99 label=Messaging_HighScore
  $FC99,$0D "#STR(#PC,$04,$0D)".

g $FCA6 High Score
@ $FCA6 label=HighScore
B $FCA6,$08

b $FF58 Graphics: Custom UDGs
@ $FF58 label=Graphics_CustomUDGs
  $FF58,$08 #N((#PC-$FF58)/$08): #UDG(#PC)
L $FF58,$08,$15

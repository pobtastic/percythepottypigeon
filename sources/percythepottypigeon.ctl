; Copyright 1984 Gremlin Graphics Software Ltd, 2026 Urbanscan, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @rom
> $4000 @start
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

> $5DC0 @expand=#DEF(#POKE #LINK:Pokes)
> $5DC0 @expand=#DEF(#ANIMATE(delay,count=$50)(name=$a)*$name-1,$delay;#FOR$02,$count||x|$name-x|;||($name-animation))
> $5DC0 @expand=#DEF(#COLOUR(id)#LET(ink=$id&$07)#IF({ink}>=$00)(INK:#MAP({ink})(UNKNOWN,0:BLACK,1:BLUE,2:RED,3:MAGENTA,4:GREEN,5:CYAN,6:YELLOW,7:WHITE)), #LET(paper=$id>>$03&$07)#IF({paper}>=$00)(PAPER:#MAP({paper})(UNKNOWN,0:BLACK,1:BLUE,2:RED,3:MAGENTA,4:GREEN,5:CYAN,6:YELLOW,7:WHITE))#LET(bright=$id&$40)#IF({bright}>$00)( (BRIGHT))#LET(flash=$id&$80)#IF({flash}>$00)( (FLASH: ON)))
> $5DC0 @expand=#DEF(#INK(id)#LET(bright=$id&$40)#LET(flash=$id&$80)#LET(ink=$id&$07)#IF({ink}>=$00)(#MAP({ink})(UNKNOWN,0:BLACK,1:BLUE,2:RED,3:MAGENTA,4:GREEN,5:CYAN,6:YELLOW,7:WHITE))#IF({bright}>$00)( (BRIGHT))#IF({flash}>$00)( (FLASH: ON)))
> $5DC0 @expand=#DEF(#ROOM(id)#SIM(start=$5DD0,stop=$5DDD)#UDGTABLE { #POKES$5FC5,$id;$5FA1,$01#SIM(start=$65A3,stop=$65A6,sp=$5BFE)#SCR$02(room-$id) } TABLE#)
> $5DC0 @set-handle-unsupported-macros=1
> $5DC0 @org
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
  $5DE6,$04 Write #N$00 to *#REGix+#N$23 (#R$DAE3).
  $5DEA,$04 Write #INK$07 to *#REGix+#N$02 (#R$DAC2).
  $5DEE,$04 Write #N$FF to *#REGix+#N$22 (#R$DAE2).
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
N $5E6D If none of the above matched, trigger an error (with an arbitrary error
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
@ $5F35 label=Draw_Room_Tile
D $5F35 Draws a single tile to the room buffer at the current drawing position
. stored in *#R$5FB9. The position is advanced after each call. If bit 0 of
. #REGd is set, the position is advanced but no tile is drawn (used for skip
. tiles in command #N$01).
R $5F35 A Tile character to draw
R $5F35 D Bit 0: #N$01=advance position only, #N$00=draw and advance
N $5F35 Load and advance the current column/row drawing position.
  $5F35,$04 Load the current drawing position from *#R$5FB9 into #REGbc.
  $5F39,$01 Increment the column in #REGc.
  $5F3A,$01 Stash the tile character in shadow #REGaf.
N $5F3B If the column has reached #N$20 (past the right edge), wrap to the
. start of the next row.
  $5F3B,$04 Jump to #R$5F41 if bit 5 of #REGc is set (column has wrapped).
  $5F3F,$02 Jump to #R$5F44.
@ $5F41 label=Draw_Room_Tile_Next_Row
  $5F41,$01 Increment the row in #REGb.
  $5F42,$02 Reset the column to #N$00.
@ $5F44 label=Draw_Room_Tile_Store_Position
  $5F44,$04 Write the updated drawing position back to *#R$5FB9.
  $5F48,$03 Return if this is a position-advance-only call (bit 0 of #REGd is
. set).
N $5F4B Calculate the room buffer address from the column (#REGc) and row
. (#REGb). Converts the character cell coordinates into a pixel address within
. the room buffer at #R$C000.
  $5F4B,$01 Copy the column to #REGl.
M $5F4C,$03 Mask #REGb to get the row within the current screen third.
  $5F4D,$02,b$01 Keep only bits 0-2.
  $5F4F,$03 Rotate right three positions to move into bits 5-7.
  $5F52,$01 Merge in the column bits from #REGl.
  $5F53,$01 Store the combined low byte in #REGl.
M $5F54,$03 Mask #REGb to get the screen third index.
  $5F55,$02,b$01 Keep only bits 3-4.
  $5F57,$02,b$01 Set bits 6-7 for the room buffer base at #R$C000.
  $5F59,$01 Store the high byte in #REGh.
N $5F5A Look up the tile graphic data from the active tile set and copy all
. #N$08 pixel rows to the room buffer.
  $5F5A,$01 Stash the room buffer address on the stack.
  $5F5B,$04 Load the active tile set base address from *#R$5FC1 into #REGde.
  $5F5F,$01 Retrieve the tile character from shadow #REGaf.
  $5F60,$02 Subtract #N$08 to convert from the tile character to a zero-based
. tile index.
  $5F62,$03 Transfer the tile index to #REGhl.
  $5F65,$03 Multiply by #N$08 (bytes per tile graphic).
  $5F68,$01 Add the tile set base address to get the graphic data pointer.
  $5F69,$01 Exchange so #REGde points to the tile graphic data.
  $5F6A,$01 Restore the room buffer address from the stack.
  $5F6B,$02 Set the pixel row counter to #N$08 in #REGb.
@ $5F6D label=Draw_Room_Tile_Copy_Loop
  $5F6D,$02 Copy one byte of tile graphic data to the room buffer.
  $5F6F,$01 Advance the tile graphic data pointer.
  $5F70,$01 Move down one pixel row in the room buffer.
  $5F71,$02 Decrease the row counter and loop back to #R$5F6D until all #N$08
. rows are drawn.
  $5F73,$01 Return.
N $5F74 End of room attribute data. Finalises the room setup by resetting game
. flags and calculating the room's object data base address.
@ $5F74 label=Room_Attributes_End
  $5F74,$06 Jump to #R$5F83 if *#R$5FA9 (egg drop flag) is zero.
  $5F7A,$04 Write #N$00 to *#R$5FA9 (cancel any active egg drop).
  $5F7E,$02 Two NOPs (unused?)
  $5F80,$03 Write #N$00 to *#R$DAE3 (clear the egg sprite frame).
N $5F83 Calculate the base address for this room's object data. Each room has
. #N$20 bytes of object data stored sequentially from #R$DE9E, so multiply the
. zero-indexed room number by #N$20 and add the base.
@ $5F83 label=Calculate_Room_Object_Base
  $5F83,$03 Fetch the current room number from *#R$5FC5.
  $5F86,$01 Decrement to make it zero-indexed.
  $5F87,$03 Point #REGde at #R$DE9E (room object data base).
  $5F8A,$03 Transfer the room index to #REGhl.
  $5F8D,$05 Multiply by #N$20 to calculate the offset for this room.
  $5F92,$01 Add the base address.
  $5F93,$03 Write the result to *#R$5FB5 (room object data pointer for this
. room).
N $5F96 Wait for the next interrupt frame, then transfer the completed room
. buffer to the display.
  $5F96,$01 Enable interrupts.
  $5F97,$01 Halt (wait for the next interrupt).
  $5F98,$01 Disable interrupts.
N $5F99 Draw the room buffer to the screen.
  $5F99,$02 Set the row counter to #N$16 in #REGb.
  $5F9B,$03 Point #REGhl at #R$C000 (room buffer).
  $5F9E,$03 Jump to #R$6438.

g $5FA1 Screen Initialised Flag
@ $5FA1 label=Screen_Initialised_Flag
D $5FA1 Tracks whether the current screen has been fully initialised. Set to
. #N$01 after the HUD header is drawn, and cleared to #N$00 when a fresh
. screen setup is needed.
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

u $5FA3
B $5FA3,$01

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

g $5FA9 Flag: Egg State
@ $5FA9 label=EggDropFlag
D $5FA9 Set to #N$FF when Percy is dropping an egg, and cleared to #N$00 when
. the egg routine is complete.
B $5FA9,$01

g $5FAA Flag: Carrying A Worm
@ $5FAA label=CarryingWormFlag
D $5FAA Set to #N$FF when Percy is carrying a worm, and cleared to #N$00 when
. he's not.
B $5FAA,$01

g $5FAB Energy Bar Delay Counter
@ $5FAB label=EnergyBarDelayCounter
D $5FAB A delay so Percy's energy bar doesn't deplete too quickly while he's
. flying.
B $5FAB,$01

g $5FAC Flag: Worm Drop
@ $5FAC label=WormDropFlag
D $5FAC Set to #N$FF when a worm has been dropped. Cleared to #N$00 when
. there's no worm being processed.
B $5FAC,$01

g $5FAD Flag: Landed On Platform Flag
@ $5FAD label=LandedOnPlatformFlag
D $5FAD Set to #N$FF when Percy has landed on a platform. Cleared to #N$00
. when no platform is beneath him.
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

g $5FB2 Worms Remaining
@ $5FB2 label=WormsRemaining
D $5FB2 Number of worms Percy has remaining to collect for the current level.
B $5FB2,$01

g $5FB3 Lives Display Character
@ $5FB3 label=LivesDisplayCharacter
D $5FB3 The ASCII character displayed on screen to represent the current
. lives count.
N $5FB3 See #POKE#255_lives(255 Lives).
B $5FB3,$01

g $5FB4 Chick Animation States
@ $5FB4 label=ChickAnimationStates
D $5FB4 A rotating bit pattern used to animate the nest chicks. Each bit
. controls the animation frame for one chick, rotated each frame so
. they animate independently.
B $5FB4,$01

g $5FB5 Room Object Data Pointer
@ $5FB5 label=Room_Object_Data_Pointer
D $5FB5 Pointer to the current room's object data, calculated from the room
. number and the base at #R$DE9E. Used to track the state of collectible worms
. and other interactive elements in the current room.
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

g $5FBB Respawn Flag
@ $5FBB label=RespawnFlag
D $5FBB Set to #N$FF when entering a new room. Checked by hazard handlers to
. reset their positions and state when the room is repopulated.
B $5FBB,$01

g $5FBC Pause Flag
@ $5FBC label=Pause_Flag
D $5FBC #N$00=not paused, #N$FF=paused; set at #R$5DF5.
B $5FBC,$01

g $5FBD Border Colour
@ $5FBD label=BorderColour
B $5FBD,$01

g $5FBE Lives Backup
@ $5FBE label=Lives_Backup
D $5FBE Copy of #R$5FB3. Set when lives are initialised, cleared at end of each
. frame. When non-zero the main game handlers run; when zero the full sprite
. draw runs.
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
N $60AE Egg is in flight so advance its Y position.
  $60AE,$03 #REGa=*#REGix+#N$21 (#R$DAE1).
  $60B1,$02 #REGa+=#N$04.
  $60B3,$02 Has the egg reached Y position #N$A8?
  $60B5,$02 Jump to #R$60BF if not yet reached.
N $60B7 Egg has reached its target so end the egg drop state.
  $60B7,$04 Write #N$00 to *#REGix+#N$23 (#R$DAE3).
  $60BB,$04 Write #N$00 to *#R$5FA9 (egg drop complete).
@ $60BF label=MainGameLoop_UpdateEggY
  $60BF,$03 Write #REGa to *#REGix+#N$21 (#R$DAE1).
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
N $60ED Start the egg drop sequence and set the egg's target position/
. activate the egg state.
  $60ED,$02 #REGa+=#N$10.
  $60EF,$01 Stash #REGaf on the stack.
  $60F0,$03 Call #R$679C.
  $60F3,$01 Restore #REGaf from the stack.
  $60F4,$03 Write #REGa to *#REGix+#N$21 (egg target Y).
  $60F7,$04 Write #N$0F to *#REGix+#N$23 (#R$DAE3).
  $60FB,$03 #REGa=*#REGix+#N$00 (Percy's X position).
  $60FE,$02 #REGa+=#N$05.
  $6100,$03 Write #REGa to *#REGix+#N$20 (egg target X).
  $6103,$02,b$01 #REGa=#N$FF.
M $6103,$05 Write #N$FF to *#R$5FA9 (egg drop in progress).
  $6108,$06 Write #N($0064,$04,$04) to *#R$5FB7 (initial beep pitch).
N $610E Apply the direction input to Percy's movement. First ensure fire
. is flagged as released, then dispatch to the appropriate movement handler for
. each direction.
@ $610E label=MainGameLoop_ApplyMovement
  $610E,$08 Set bit 0 of *#R$5FA2 (mark fire as handled).
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
  $61A5,$01 #REGa=#REGb.
  $61A6,$02,b$01 Keep only bits 0-2 (sub-character Y offset).
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
  $623D,$04 Write #N$00 to clear *#R$5FAD.
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
R $6280 IX Pointer to Percy's state data
R $6280 D Number of pixels to move
  $6280,$05 Write #N$01 to *#R$5FA5 (Percy is facing left).
N $6285 If *#R$5FAA is set, apply an extra boundary check.
  $6285,$06 Jump to #R$6297 if *#R$5FAA is set.
  $628B,$05 Load #REGa with Percy's X position (*#REGix+#N$00) - #N$05.
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
R $62A2 IX Pointer to Percy's state data
R $62A2 D Number of pixels to move
  $62A2,$04 Write #N$00 to *#R$5FA5 (Percy is facing right).
N $62A6 If *#R$5FAA is set, apply an extra boundary check.
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
R $62C2 IX Pointer to Percy's state data
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
R $62D0 IX Pointer to Percy's state data
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
R $6307 IX Pointer to Percy's state data
  $6307,$01 Stash #REGaf on the stack.
  $6308,$03 #REGa=*#R$5FC5.
N $630B If the current room is #N$0B (the last room), wrap to room #N$01.
  $630B,$04 Jump to #R$6310 if this isn't room #N$0B.
  $630F,$01 #REGa=#N$00 (will become #N$01 after increment).
@ $6310 label=TransitionRoomRight_SetRoom
  $6310,$04 Write #N$00 to reset *#REGix+#N$00 (Percy's X to left edge).
  $6314,$01 Increment room number.
  $6315,$03 Write #REGa to *#R$5FC5.
  $6318,$03 Call #R$5E24 to draw the new room.
  $631B,$01 Restore #REGaf from the stack.
  $631C,$02 Discard two stack values.
  $631E,$01 Return.

c $631F Transition Room Left
@ $631F label=TransitionRoomLeft
D $631F Percy has gone past the left edge so transition into the previous room.
R $631F IX Pointer to Percy's state data
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
R $6338 IX Pointer to Percy's state data
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
  $6362,$08 Jump to #R$6377 if Percy's current X position (*#REGix+#N$00) is the
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
D $63BB Prints the heads-up display header showing Energy, Lives and Score, then
. applies random colours to the bottom two rows of the screen attributes to
. create a colourful ground strip.
  $63BB,$05 Write #N$01 to *#R$5FA1.
N $63C0 Print the HUD string to the upper screen.
  $63C0,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>
. to open channel #N$02 (upper screen).)
  $63C3,$03 Point #REGhl at #R$63E9.
  $63C6,$02 Set a counter in #REGb for the length of the string (#N$4F
. characters).
  $63C8,$03 Call #R$6621.
N $63CB Apply pseudo-random colours to the bottom two rows of screen attributes
. to create a colourful ground strip. Uses the Memory Refresh Register as a
. seed to pick unpredictable colour values.
@ $63CB label=Colour_Ground_Strip
  $63CB,$03 Load the Memory Refresh Register into #REGe as a pointer offset.
  $63CE,$02 Set #REGd to #N$00 so #REGde is an offset into low memory.
  $63D0,$02 Set a counter in #REGb for #N$20 attribute cells.
  $63D2,$03 Point #REGhl at #N$5AC0 (start of the bottom two attribute rows).
@ $63D5 label=Colour_Ground_Loop
  $63D5,$01 Fetch a pseudo-random byte from *#REGde.
  $63D6,$02,b$01 Keep only bits 0-2 (INK colour).
  $63D8,$01 Advance the source pointer.
  $63D9,$04 Jump back to #R$63D5 if the colour is less than #N$03 (reject
. dark colours to keep the ground strip bright).
  $63DD,$01 Stash the source pointer on the stack.
  $63DE,$01 Copy the chosen colour into #REGe.
  $63DF,$01 Fetch the current attribute byte from *#REGhl.
  $63E0,$02,b$01 Mask off the existing INK bits (keep PAPER, BRIGHT, FLASH).
  $63E2,$01 OR in the new INK colour from #REGe.
  $63E3,$01 Write the updated attribute byte to *#REGhl.
  $63E4,$01 Restore the source pointer from the stack.
  $63E5,$01 Advance to the next attribute cell.
  $63E6,$02 Decrease the counter and loop back to #R$63D5 until all #N$20
. cells are coloured.
  $63E8,$01 Return.

t $63E9 Messaging: Header
@ $63E9 label=Messaging_Header
B $63E9,$03 PRINT AT: #N(#PEEK(#PC+$01)), #N(#PEEK(#PC+$02)).
B $63EC,$02 Set PAPER: #INK(#PEEK(#PC+$01)).
B $63EE,$02 BRIGHT "#MAP(#PEEK(#PC+$01))(?,0:OFF,1:ON)".
  $63F0,$01 #FONT#(:(#STR(#PC,$04,$01)))$3D00,attr=$47(header-01)
B $63F1,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $63F3,$20 #FONT#(:(#STR(#PC,$04,$20)))$3D00,attr=$47(header-02)
N $6413 Forms the energy bar:
B $6413,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $6415,$02 #FONT#(:(#STR(#PC,$04,$02)))$FBD8,attr=$42(header-03)
B $6417,$02 Set INK: #INK(#PEEK(#PC+$01)).
  $6419,$0A #FONT#(:(#STR(#PC,$04,$0A)))$FBD8,attr=$46(header-04)
B $6423,$02 Set INK: #INK(#PEEK(#PC+$01)).
B $6425,$01 #FONT#(:(#STR(#PC,$04,$01)))$FBD8,attr=$47(header-06)
N $6426 Prints lives and score:
  $6426,$12 #FONT#(:(#STR(#PC,$04,$12)))$3D00,attr=$47(header-07)

c $6438 Draw Room Rows
@ $6438 label=Draw_Room_Rows
D $6438 Draws multiple character rows from the room buffer to the screen buffer.
. After all rows are drawn, prints the HUD header if it hasn't been drawn yet,
. and applies random colours to the bottom ground strip.
R $6438 B Number of rows to draw
R $6438 HL Pointer to the room buffer
@ $6438 label=Draw_Room_Rows_Loop
  $6438,$02 Stash the row counter and room buffer pointer on the stack.
  $643A,$03 Call #R$6456 to draw a single character row.
  $643D,$02 Restore the room buffer pointer and row counter from the stack.
N $643F Advance the room buffer pointer to the next character row. Each row is
. #N$20 bytes wide; if adding #N$20 to #REGl overflows, advance #REGh by
. #N$08 to move into the next screen third.
  $643F,$04 Add #N$20 to #REGl.
  $6443,$03 Jump to #R$644A if there was no overflow.
  $6446,$04 Add #N$08 to #REGh.
@ $644A label=Draw_Room_Rows_Next
  $644A,$02 Decrease the row counter by one and loop back to #R$6438 until all
. rows have been drawn.
N $644C Print the HUD header if the screen hasn't been fully initialised yet.
  $644C,$07 Call #R$63BB if *#R$5FA1 is unset (HUD header not yet drawn).
  $6453,$03 Jump to #R$63CB.

c $6456 Draw Room Row
@ $6456 label=Draw_Room_Row
D $6456 Copies a single character row (#N$08 pixel lines) from the room buffer
. to the screen buffer, then copies the corresponding colour attributes.
R $6456 HL Pointer to the room buffer row
N $6456 Copy eight pixel lines from the room buffer to the screen buffer.
  $6456,$02 Set the pixel line counter to #N$08 in #REGb.
  $6458,$01 Stash the room buffer pointer on the stack.
@ $6459 label=Draw_Room_Row_Pixel_Loop
  $6459,$02 Stash the pixel line counter and room buffer pointer on the stack.
  $645B,$02 Copy the room buffer pointer to #REGde.
  $645D,$02 Reset bit 7 of #REGd to convert from a room buffer address to the
. corresponding screen buffer address.
  $645F,$05 Copy #N$20 bytes from the room buffer to the screen buffer.
  $6464,$02 Restore the room buffer pointer and pixel line counter from the
. stack.
  $6466,$01 Advance to the next pixel line in the room buffer.
  $6467,$02 Decrease the pixel line counter and loop back to #R$6459 until all
. #N$08 lines are copied.
N $6469 Copy the colour attributes for this character row. Convert the room
. buffer address to the source and destination attribute buffer addresses.
  $6469,$01 Restore the original room buffer pointer from the stack.
  $646A,$04 Rotate the high byte right three positions.
M $646E,$02 Mask to extract the character row index.
  $646E,$02,b$01 Keep only bits 0-1.
  $6470,$02,b$01 Set bits 3-4 and 6-7 to form the source attribute buffer high
. byte.
  $6472,$02 Set #REGh to the source high byte and copy #REGl to #REGe.
M $6474,$03 Mask the high byte again.
  $6475,$02,b$01 Keep only bits 0-1.
  $6477,$02,b$01 Set bits 3-4 and 6 to form the destination attribute buffer
. high byte.
  $6479,$01 Set #REGd to the destination high byte.
  $647A,$05 Copy #N($0020,$04,$04) attribute bytes to the screen attribute
. buffer.
  $647F,$01 Return.

c $6480 Update Energy Bar
@ $6480 label=UpdateEnergyBar
D $6480 Animates Percy's energy bar at the bottom of the screen. The bar
. depletes when Percy is airborne and refills when Percy is on the ground. If
. the bar fully depletes, Percy enters the falling state.
R $6480 IX Pointer to Percy's state data
  $6480,$03 #REGhl=#N$52EC (screen buffer location for the energy bar).
N $6483 If *#R$5FA7 is non-zero, it's acting as a cooldown timer so decrement
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
N $6495 Percy is airborne so deplete the energy bar. Uses a slower frame delay
. of #N$07 frames between each step.
  $6495,$07 Increment the *#R$5FAB.
  $649C,$03 Return if it's not yet time to update the energy bar.
N $649F Reset the frame counter and check if Percy is on a platform (energy
. doesn't deplete while landed).
  $649F,$04 Write #N$00 to reset *#R$5FAB.
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
N $64B6 Current byte is empty so scan leftward for the next filled byte.
@ $64B6 label=UpdateEnergyBar_Deplete_ScanLeft
  $64B6,$01 Move one byte to the left.
  $64B7,$05 Jump to #R$64E1 if the energy bar is fully depleted (reached #N$E0,
. the left edge of the bar).
  $64BC,$02 Jump to #R$64A8 to check this byte.
N $64BE Percy is on the ground so refill the energy bar. Uses a faster frame
. delay of #N$03 frames between each step.
@ $64BE label=UpdateEnergyBar_Refill
  $64BE,$07 Increment the *#R$5FAB.
  $64C5,$03 Return if not yet time to update the bar.
  $64C8,$04 Write #N$00 to reset *#R$5FAB.
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
N $64DA Current byte is fully filled so scan rightward for the next byte to
. fill.
@ $64DA label=UpdateEnergyBar_Refill_ScanRight
  $64DA,$01 Move one byte to the right.
  $64DB,$04 Return if the bar is fully refilled (the scan reached #N$ED which
. is the right edge of the bar).
  $64DF,$02 Jump to #R$64CF to check this byte.
N $64E1 Energy bar has fully depleted so set Percy to the falling state.
@ $64E1 label=UpdateEnergyBar_Depleted
  $64E1,$05 Write #N$FF to *#R$5FA7.
  $64E6,$01 Return.

c $64E7 Lose Life
@ $64E7 label=Lose_Life
D $64E7 Handles Percy losing a life. Plays the lose-a-life sound effect, resets
. any collected worm markers in the room attribute data, decrements the lives
. counter and updates the display.
E $64E7 Continue on to #R$653D.
N $64E7 Set Percy's position and frame for the death animation.
  $64E7,$05 Write #N$90 to *#R$DAC1 (set Percy's Y position to the ground).
N $64EC Set Percy's sprite frame to the death frame:
. #UDGTABLE { #UDGS$02,$02(udg44347-56x4)(
.   #UDG($AD3B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $64EC,$04 Write sprite ID #N$11 to *#R$DAC3.
  $64F0,$02 Stash #REGix on the stack.
  $64F2,$03 Call #R$6992.
N $64F5 Play the "lose a life" sound effect.
N $64F5 #HTML(#AUDIO(lose-life.wav)(#INCLUDE(LoseLife)))
  $64F5,$03 Set #REGhl to #N($0000,$04,$04) (sound data pointer).
  $64F8,$02 Set #REGa to #N$01 (initial speaker state).
  $64FA,$02 Set #REGb to #N$00 (outer loop counter, #N$100 iterations).
@ $64FC label=Lose_Life_Sound_Outer
  $64FC,$01 Stash the outer counter on the stack.
  $64FD,$01 Copy #REGb to #REGd (inner delay length).
  $64FE,$02 Rotate #REGb right to vary the pitch.
@ $6500 label=Lose_Life_Sound_Inner
  $6500,$02 Output to the speaker port.
  $6502,$04 Four NOPs as a timing delay.
  $6506,$02 Decrease the inner counter and loop back to #R$6500.
  $6508,$01 Restore the outer counter from the stack.
  $6509,$02,b$01 Toggle the speaker bits by flipping bits 3-4.
  $650B,$01 Merge in the delay value from #REGd.
  $650C,$01 OR with the sound data byte at *#REGhl.
  $650D,$02,b$01 Mask with #N$F8 to keep only the upper bits.
  $650F,$02,b$01 Set bit 0 for the border colour.
  $6511,$01 Advance the sound data pointer.
  $6512,$02 Decrease the outer counter and loop back to #R$64FC until all
. #N$100 iterations are complete.
  $6514,$02 Restore #REGix from the stack.
N $6516 Reset any collected worm markers in the room object data back to
. #N$00.
  $6516,$03 Point #REGhl at #R$DE9E.
  $6519,$03 Set the byte counter to #N$0160 in #REGbc.
@ $651C label=Reset_Worm_Markers
  $651C,$05 Jump to #R$6523 if *#REGhl is not equal to #N$1E (not a collected
. worm marker).
  $6521,$02 Write #N$00 to *#REGhl to reset the marker.
@ $6523 label=Reset_Worm_Markers_Next
  $6523,$01 Decrement the byte counter by one.
  $6524,$01 Advance #REGhl to the next byte.
  $6525,$04 Loop back to #R$651C until all #N$0160 bytes are processed.
  $6529,$03 Call #R$6791 to reset the worm-carrying state.
N $652C Decrease the lives counter by one.
N $652C See #POKE#infinite_lives(Infinite Lives).
  $652C,$03 Point #REGhl at #R$5FB3.
  $652F,$01 Decrement the lives counter at *#REGhl.
  $6530,$05 Jump to #R$655C if *#R$5FB3 has not reached ASCII "#CHR$30"
. (#N$30).
  $6535,$02 Load #REGa with ASCII "#CHR$30" (#N$30).
  $6537,$03 Point #REGhl at #N$50F0 (screen buffer position for the lives
. display).
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
D $659B Displays the pre-game title screen and waits for the player to press
. ENTER to start the game. The title screen is stored as room #N$0C.
N $659B Load and display the title screen.
  $659B,$08 Write #N$0C to; #LIST
. { *#R$5FC5 }
. { *#R$5FA1 }
. LIST#
  $65A3,$03 Call #R$5E24.
  $65A6,$04 Write #N$00 to *#R$5FA1.
N $65AA Print the credits text onto the title screen.
  $65AA,$03 Point #REGhl at #N$4896 (screen buffer position for the credits).
  $65AD,$02 Set the row counter to #N$04 in #REGb.
  $65AF,$03 Point #REGde to #R$660D.
@ $65B2 label=Print_Credits_Row_Loop
  $65B2,$02 Stash the row counter and screen buffer pointer on the stack.
  $65B4,$02 Set a counter in #REGb for #N$05 characters to print in each row.
@ $65B6 label=Print_Credits_Char_Loop
  $65B6,$03 Stash the screen buffer pointer, message pointer and the character
. counter on the stack.
  $65B9,$01 Fetch the next character from the text data.
  $65BA,$03 Call #R$6581.
  $65BD,$03 Restore the character counter, message pointer and the screen
. buffer pointer from the stack.
  $65C0,$01 Advance to the next screen column.
  $65C1,$01 Advance to the next character in the text data.
  $65C2,$02 Decrease the character counter and loop back to #R$65B6 until all
. #N$05 characters in the row are printed.
  $65C4,$01 Restore the screen buffer pointer from the stack.
  $65C5,$04 Advance #REGhl by #N($0020,$04,$04) to move to the next character row.
  $65C9,$01 Restore the row counter from the stack.
  $65CA,$02 Decrease the row counter and loop back to #R$65B2 until all #N$04
. rows are printed.
N $65CC Play the title screen music.
  $65CC,$02 #REGb=#N$3D.
  $65CE,$03 Call #R$FC1B.
N $65D1 Wait for the player to press ENTER to start the game.
  $65D1,$05 Read from the keyboard;
. #TABLE(default,centre,centre,centre,centre,centre,centre)
. { =h,r2 Port Number | =h,c5 Bit }
. { =h 0 | =h 1 | =h 2 | =h 3 | =h 4 }
. { #N$BF | ENTER | L | K | J | H }
. TABLE#
@ $65D4 label=WaitForEnterToStart_Loop
  $65D6,$03 Jump to #R$65D4 if "ENTER" is not being pressed.
N $65D9 ENTER pressed; initialise the game state and start the game.
  $65D9,$04 Set the border to #INK$01.
  $65DD,$02 Set the clear counter to #N$0A in #REGb.
  $65DF,$03 Point #REGhl at #R$5FA1.
@ $65E2 label=Clear_Game_State_Loop
  $65E2,$02 Write #N$00 to *#REGhl.
  $65E4,$01 Increment #REGhl by one.
  $65E5,$02 Decrease the counter and loop back to #R$65E2 until #N$0A bytes
. from #R$5FA1 onwards are cleared.
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

c $662B Handler: Worm Collection and Delivery
@ $662B label=Handler_Worms
D $662B Manages the worm collectibles in each room. Scans the room attribute data
. to find active worm tiles, animates them with a wiggling effect, and checks if
. Percy is at the correct position to pick one up. When Percy is carrying a worm,
. the worm-in-beak sprite is positioned relative to Percy. On level #N$06, checks
. if Percy is at the nest to deliver the worm to the baby chicks for bonus points.
N $662B Calculate Percy's tile map position from his pixel coordinates.
  $662B,$04 Point #REGix at #R$DAC0.
  $662F,$02 Set #REGb to #N$08.
M $6631,$09 Calculate the tile row from Percy's Y position: add #N$08, rotate
. left twice and mask with #N$E0 to get the row component in #REGe.
  $6637,$02,b$01 Keep only bits 5-7.
M $663A,$0C Calculate the tile column from Percy's X position: add #N$02, rotate
. right three times and mask with #N$1F, then OR with the row component to
. form the full tile map offset in #REGe.
  $6642,$02,b$01 Keep only bits 0-4.
  $6646,$06 If *#R$5FA5 (facing direction) is zero (facing right), increment
. #REGe by one to adjust the lookup position.
  $664C,$01 Increment the map offset by one.
N $664D Scan the room attribute entries to find active worm tiles.
@ $664D label=Scan_Worms
  $664D,$03 Load the room attribute pointer from *#R$5FB5 into #REGhl.
  $6650,$05 Load the worm count from *#R$5FB1, increment it by one and store it
. in #REGc.
@ $6655 label=Scan_Worms_Loop
  $6655,$05 Jump to #R$667B if the current entry is #N$1E (worm already
. collected).
  $665A,$01 Advance past the type byte.
  $665B,$05 Jump to #R$667C if the next byte is #N$1F (the slot is disabled).
  $6660,$01 Advance.
  $6661,$05 Compare the entry index against #REGc; jump to #R$667E if it is
. greater or equal (not a valid worm).
  $6666,$04 Jump to #R$66A8 if the tile position matches #REGe (worm found at
. Percy's location).
N $666A No match at this entry; draw the worm wiggle animation at this tile
. position and move to the next entry.
@ $666A label=Animate_Worm
  $666A,$03 Stash the room attribute pointer, worm counter and position on the
. stack.
  $666D,$03 Load the tile screen address low byte from *#REGhl; set high byte to
. #N$F0 to form a screen buffer address.
  $6670,$03 Call #R$6683 to draw the worm wiggle animation frame.
  $6673,$03 Restore the position, worm counter and room attribute pointer from
. the stack.
@ $6676 label=Next_Worm_Entry
  $6676,$03 Advance to the next entry and loop back to #R$6655 until all #N$08
. entries are checked.
  $6679,$02 Jump to #R$66E1.
N $667B Skip entries that are marked as collected or disabled.
@ $667B label=Skip_Collected_Worm
  $667B,$01 Skip one extra byte for collected entries.
@ $667C label=Skip_Disabled_Worm
  $667C,$02 Skip the remaining bytes of this entry.
@ $667E label=Skip_Invalid_Entry
  $667E,$03 Advance past this entry and loop back to #R$6655 until all entries
. are checked.
  $6681,$02 Jump to #R$66E1.

c $6683 Handler: Draw Worm Animation Frame
@ $6683 label=Handler_DrawWorm
D $6683 Draws an #N$08-pixel-row worm wiggle animation frame at the screen
. address in #REGhl. Alternates between two graphic frames at #N$A7C3 and
. #N$A7CB based on the animation toggle at #R$5FB4.
R $6683 HL Screen buffer address for the worm graphic
  $6683,$03 Default animation frame pointer: #REGde=#N$A7C3 (worm frame 1).
  $6686,$09 Rotate *#R$5FB4 right through carry; if the carry flag is set, keep
. worm frame 1 and skip over the alternative frame (worm frame 2).
  $668F,$03 Else the carry flag is unset so set the alternative animation frame
. pointer: #REGde=#N$A7CB (worm frame 2).
@ $6692 label=Handler_DrawWorm_Frame
  $6692,$02 Set a line counter in #REGb (#N$08 lines in a UDG).
  $6694,$01 Stash the screen buffer address on the stack.
@ $6695 label=Handler_DrawWorm_FrameLoop
  $6695,$02 Copy the UDG data to the screen buffer.
  $6697,$01 Move down one pixel line in the screen buffer.
  $6698,$01 Move to the next UDG graphic data byte.
  $6699,$02 Decrease the line counter by one and loop back to #R$6695 until all
. #N$08 lines of the UDG character have been drawn.
  $669B,$01 Restore the screen buffer address from the stack.
M $669C,$0A Convert the screen buffer address to the corresponding attribute address
. and write #N$03 (magenta on black) as the worm colour attribute.
  $66A0,$02,b$01 Keep only bits 0-1.
  $66A2,$02,b$01 Set bits 3-7.
  $66A7,$01 Return.

c $66A8 Handler: Worm Found
@ $66A8 label=Handler_Worm_Found
D $66A8 A worm was found at Percy's position; check if Percy is low enough to
. collect it and not already carrying one.
R $66A8 IX Pointer to Percy's state data
  $66A8,$07 Jump to #R$666A if Percy's Y position is less than #N$79 (not low
. enough to pick up the worm).
  $66AF,$06 Jump to #R$666A if *#R$5FAA is set (so Percy is already carrying a
. worm).
N $66B5 Percy is in position and not carrying; collect the worm.
M $66B5,$05 Set *#R$5FAA to #N$FF (mark Percy as carrying a worm).
  $66B5,$02,b$01 Set bits 0-7.
  $66BA,$03 Stash the position, worm counter and room attribute pointer on the
. stack.
  $66BD,$05 Move back three bytes in the room attribute data and write #N$1E to
. mark this worm as collected.
  $66C2,$02 Stash #REGix on the stack.
N $66C4 #HTML(#AUDIO(collect-worm.wav)(#INCLUDE(CollectWorm)))
  $66C4,$12 #HTML(Play a two-part collection sound effect by calling
. <a rel="noopener nofollow" href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>
. with durations of #N($0064,$04,$04)/ #N($00C8,$04,$04) then
. #N($0064,$04,$04)/ #N($0064,$04,$04).)
  $66D6,$05 Restore #REGix, the room attribute pointer, worm counter and
. position from the stack.
  $66DB,$04 Write #N$00 to clear *#R$5FA9.
  $66DF,$02 Jump to #R$6676 to continue scanning.

c $66E1 Percy Carrying Worm
@ $66E1 label=Position_Worm_In_Beak
D $66E1 After scanning all entries, check if Percy is carrying a worm and
. handle the worm-in-beak sprite positioning.
R $66E1 IX Pointer to Percy's state data (and worm sprite at +#N$20)
  $66E1,$05 Return if *#R$5FAA (worm carrying flag) is zero.
  $66E6,$07 Jump to #R$66F4 if Percy's Y position is less than #N$8F.
  $66ED,$07 Jump to #R$6A17 if *#R$5FAC is set (a worm is being dropped to a
. chick).
@ $66F4 label=Update_Worm_In_Beak
  $66F4,$07 Jump to #R$6700 if Percy's Y position is not less than #N$8D.
M $66FB,$05 Set *#R$5FAC to #N$FF (enable worm drop).
  $66FB,$02,b$01 Set bits 0-7.
@ $6700 label=Set_Worm_Sprite_X
  $6700,$0A Calculate the worm-in-beak X position: if *#R$5FA5 (facing
. direction) is zero (facing right), add #N$0C to Percy's X, otherwise add
. #N$FB (offset left).
  $670A,$02 #REGa=#N$FB.
  $670C,$03 Add the offset to Percy's X position.
  $670F,$03 Write the result to *#REGix+#N$20 (worm sprite X position).
  $6712,$08 Set the worm sprite Y position to Percy's Y plus #N$04.
  $671A,$0C Set the worm sprite frame: start with #N$0D, rotate *#R$5FB4 and if
. carry is not set, increment to #N$0E for the alternate wiggle frame.
@ $6726 label=Set_Worm_Sprite_Frame
  $6726,$03 Write the worm sprite frame index to *#REGix+#N$23.
  $6729,$06 Jump to #R$6736 if *#R$5FAD (worm Y adjustment flag) is non-zero.
  $672F,$07 Jump to #R$673E if Percy's Y position is not less than #N$90.
@ $6736 label=Adjust_Worm_Y_Up
  $6736,$08 Subtract #N$04 from the worm Y position to adjust it upward.
N $673E Check if Percy is at the nest to deliver the worm to the baby chicks
. (only on level #N$06).
@ $673E label=Check_Nest_Delivery
  $673E,$06 Return if *#R$5FC5 (current level) is not equal to #N$06.
  $6744,$06 Return if Percy's Y position is less than #N$11.
  $674A,$03 Return if Percy's Y position is #N$21 or more.
  $674D,$06 Return if Percy's X position is #N$6B or more.
  $6753,$05 Return if *#R$5FA5 (facing direction) is zero (Percy must be facing
. left).
N $6758 Scan the room object data for a collected worm marker to convert into
. a nest delivery.
  $6758,$03 Set the search counter to #N$0160 in #REGbc.
  $675B,$03 Point #REGhl at #R$DE9E.
@ $675E label=Search_Nest_Slot_Loop
  $675E,$05 Jump to #R$676A if *#REGhl equals #N$1E (found a collected worm
. marker to convert).
  $6763,$06 Otherwise advance and loop back to #R$675E, decrementing #REGbc
. until zero.
  $6769,$01 Return (no available slot found).
@ $676A label=Deliver_Worm_To_Nest
  $676A,$05 Write #N$00 then #N$1F to convert the collected marker into a
. delivered/disabled entry.
  $676F,$04 Deactivate the worm-in-beak sprite by writing #N$00 to
. *#REGix+#N$23.
  $6773,$05 Call #R$67B2 to add #N$C8 to the score.
N $6778 Play a delivery sound effect.
N $6778 #HTML(#AUDIO(fed-chicks.wav)(#INCLUDE(FedChicks)))
  $6778,$02 Set the sound duration in #REGe to #N$32.
  $677A,$02 Set the initial speaker state to #N$01.
@ $677C label=Delivery_Sound_Outer
  $677C,$01 Copy duration to #REGb.
@ $677D label=Delivery_Sound_Inner
  $677D,$02 Send to the speaker port.
  $677F,$02 Loop the inner delay for #REGb iterations.
M $6781,$09 Toggle the speaker bit pattern using XOR #N$18, mixed with duration
. bits for a warbling effect.
  $6783,$02,b$01 Keep only bits 3-4.
  $6787,$02,b$01 Flip bits 3-4.
  $678A,$04 Advance the frequency and loop back to #R$677C until #REGe wraps to
. zero.
  $678E,$03 Call #R$68B8.
N $6791 Reset the worm-carrying state.
@ $6791 label=Reset_Worm_State
  $6791,$0A Write #N$00 to clear; #LIST
. { *#R$5FAA }
. { *#R$5FAC }
. { *#REGix+#N$23 (worm-in-beak sprite frame) }
. LIST#
  $679B,$01 Return.

c $679C Drop Worm
@ $679C label=DropWorm
D $679C Drops the worm Percy is carrying.
.
. Scans the room data for the collected worm marker (#N$1E) and clears it back
. to #N$00, so the worm will reappear when the room is next redrawn.
  $679C,$03 Set the search counter to #N$0160 in #REGbc.
  $679F,$03 Point #REGhl at #R$DE9E.
@ $67A2 label=DropWorm_SearchLoop
  $67A2,$05 Jump to #R$67AE if *#REGhl equals #N$1E (found the collected worm
. marker).
  $67A7,$01 Advance to the next byte.
  $67A8,$05 Decrement #REGbc and loop back to #R$67A2 until all #N$0160 bytes
. are searched.
  $67AD,$01 Return (no collected worm marker found).
@ $67AE label=DropWorm_Found
  $67AE,$02 Write #N$00 to *#REGhl to clear the collected marker.
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
N $6862 Percy is to the right so add #N$03 to use the right-facing frames.
  $6862,$01 Restore the animation frame from the stack.
  $6863,$02 #REGa+=#N$03.
  $6865,$02 Jump to #R$6868.
@ $6867 label=AnimateSnapdragon_FacingLeft
  $6867,$01 Restore the animation frame from the stack.
N $6868 Look up the graphic data for the current frame. Each frame is #N$20
. bytes, stored from #R$AD5B onwards. Frames #N$00-#N$02 face left, frames
. #N$03-#N$05 face right.
N $6868 #UDGTABLE(default,centre,centre,centre,centre,centre,centre)
. { =h Frame | =h Sprite ID | =h Sprite | =h Frame | =h Sprite ID | =h Sprite }
. { =h,c3 Left | =h,c3 Right }
. { #N$00 | #N$12 | #UDGS$02,$02(udg44379-56x4)(
.   #UDG($AD5B+$08*($02*$x+$y))(*udg)
.   udg
. ) |
.   #N$03 | #N$15 | #UDGS$02,$02(udg44475-56x4)(
.   #UDG($ADBB+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. { #N$01 | #N$13 | #UDGS$02,$02(udg44411-56x4)(
.   #UDG($AD7B+$08*($02*$x+$y))(*udg)
.   udg
. ) |
.   #N$04 | #N$16 | #UDGS$02,$02(udg44507-56x4)(
.   #UDG($ADDB+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. { #N$02 | #N$14 | #UDGS$02,$02(udg44443-56x4)(
.   #UDG($AD9B+$08*($02*$x+$y))(*udg)
.   udg
. ) |
.   #N$05 | #N$17 | #UDGS$02,$02(udg44539-56x4)(
.   #UDG($ADFB+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. TABLE#
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

c $68B8 Handle Level Complete
@ $68B8 label=Handle_Level_Complete
D $68B8 Called after a worm is delivered to check if all worms have been
. collected. Decrements the worms remaining counter and if zero, plays a
. completion jingle, advances to the next room and sets up the new level.
  $68B8,$04 Decrease *#R$5FB2 by one.
  $68BC,$01 Return if the worms remaining counter is not zero.
  $68BD,$02 Stash #REGix on the stack.
  $68BF,$02 Set a sound step counter in #REGb of #N$28 steps.
  $68C1,$03 #REGhl=#N$0320 (initial sound pitch).
  $68C4,$03 #REGde=#N$0008 (pitch step per iteration).
N $68C7 Play the level complete sound effect.
@ $68C7 label=Level_Complete_Sound_Loop
  $68C7,$03 Call #R$693B.
  $68CA,$02 Decrease the step counter by one and loop back to
. #R$68C7 until the sound is complete.
  $68CC,$08 #HTML(Write #N$0F to; #LIST
. { *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C48.html">BORDCR</a> }
. { *#R$5FBD }
. LIST#)
  $68D4,$04 Set border to #INK$01.
  $68D8,$02 Restore #REGix from the stack.
  $68DA,$03 Call #R$68F7.
N $68DD Locate the level splash screen.
  $68DD,$03 Fetch the current level from *#R$5FB1.
  $68E0,$02 Add #N$0B (the total number of rooms) to calculate the pointer to
. the level splash screen.
  $68E2,$03 Write the result to *#R$5FC5.
  $68E5,$03 Call #R$5E24.
N $68E8 #HTML(#AUDIO(lose-life.wav)(#INCLUDE(LoseLife)))
  $68E8,$03 #REGhl=#R$FBF9.
  $68EB,$03 Call #R$FAC4.
  $68EE,$01 Disable interrupts.
  $68EF,$03 Call #R$6562.
  $68F2,$04 Write #N$00 to *#R$5FA5 (Percy is facing right).
  $68F6,$01 Return.

c $68F7 Set Up Next Level
@ $68F7 label=SetUp_NextLevel
D $68F7 Prepares the game state for the next level. Increments the current
. level number, awards an extra life on level #N$04, loads the worm collection
. target for the new level from the lookup table, and resets all collected and
. disabled worm markers in the room attribute data.
N $68F7 Increment the level counter and check for extra life award.
  $68F7,$03 Fetch the current level from *#R$5FB1.
  $68FA,$03 Point #REGhl at #R$5FB3.
  $68FD,$04 Jump to #R$6911 if the current level is equal to #N$05 (don't
. increment past the maximum).
  $6901,$04 Increment the level number and write it back to *#R$5FB1.
  $6905,$04 Jump to #R$6911 if the new level is not equal to #N$04.
N $6909 Award an extra life on level #N$04.
  $6909,$02 Increment the lives display character at *#REGhl.
  $690B,$03 Point #REGhl at #N$50F0 (screen buffer position for the lives
. display).
  $690E,$03 Call #R$6581.
N $6911 Load the worm collection target for the new level.
@ $6911 label=SetWorm_Target
  $6911,$03 Fetch the current level from *#R$5FB1.
  $6914,$04 Set #REGbc to the level number minus one as a table index.
  $6918,$03 Point #REGhl at #R$6961.
  $691B,$01 Add the index to get the table entry address.
  $691C,$05 Write the worm collection count for this level to *#R$5FB2.
N $6921 Reset all collected and disabled worm markers in the room object data
. back to #N$00.
  $6921,$03 Point #REGhl at #R$DE9E.
  $6924,$03 Set the byte counter to #N$0160 in #REGbc.
@ $6927 label=ResetWorm_Markers_Loop
  $6927,$07 If *#REGhl equals #N$1F (delivered marker), write #N$00 to *#REGhl.
@ $692E label=ResetWorm_Test_Collected
  $692E,$06 If *#REGhl equals #N$1E (collected marker), write #N$00 to *#REGhl.
@ $6934 label=ResetWorm_Markers_Next
  $6934,$01 Move to the next data byte.
  $6935,$01 Decrease the byte counter by one.
  $6936,$04 Jump back to #R$6927 until all #N$0160 bytes are processed.
  $693A,$01 Return.

c $693B Level Complete Sound Step
@ $693B label=LevelCompleteSoundStep
R $693B B Sound step counter
R $693B HL Current pitch
R $693B DE Pitch adjustment per step
  $693B,$03 Stash the step counter, pitch and pitch adjustment on the stack.
  $693E,$05 Call #R$67B2 to add #N$19 points to the score.
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

g $6961 Table: Worm Collection Count
@ $6961 label=Table_WormCollectionCount
B $6961,$01 Level #N($01+(#PC-$6961)): #N(#PEEK(#PC)) worms to collect.
L $6961,$01,$05

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
D $69A7 Processes one frame of the main game loop. Clears all sprite frame IDs,
. then calls the various game handlers for Percy, hazards and level-specific
. logic. Resets the lives backup flag and restores the border colour before
. returning.
  $69A7,$01 Disable interrupts.
  $69A8,$04 Stash #REGix and #REGiy on the stack.
N $69AC Clear the sprite frame IDs for:
. #FOR$00,$06||n|#R($DAC7+(n*$04))|, | and || (the eight 3-wide sprites).
  $69AC,$02 Set the sprite counter to #N$07 in #REGb.
  $69AE,$03 Point #REGhl at #R$DAC7 (first 3-wide sprite frame ID).
  $69B1,$02 Set the clear value in #REGc to #N$00.
@ $69B3 label=Clear_3Wide_Frames_Loop
  $69B3,$01 Write #N$00 to the sprite frame ID at *#REGhl.
  $69B4,$04 Advance #REGhl by four bytes to the next sprite entry.
  $69B8,$02 Decrease the counter and loop back to #R$69B3 until all seven
. 3-wide sprite frame IDs are cleared.
N $69BA Clear the sprite frame IDs for:
. #FOR$00,$05||n|#R($DAEB+(n*$04))|, | and || (the six 2-wide sprites).
  $69BA,$03 Point #REGhl at #R$DAEB (first 2-wide sprite frame ID).
  $69BD,$02 Set the sprite counter to #N$06 in #REGb.
@ $69BF label=Clear_2Wide_Frames_Loop
  $69BF,$01 Write #N$00 to the sprite frame ID at *#REGhl.
  $69C0,$04 Advance #REGhl by four bytes to the next sprite entry.
  $69C4,$02 Decrease the counter and loop back to #R$69BF until all six
. 2-wide sprite frame IDs are cleared.
N $69C6 Call the game handlers.
  $69C6,$07 Call #R$6CA5 if *#R$5FBE is non-zero.
  $69CD,$03 Call #R$69F7.
  $69D0,$03 Call #R$6DAB.
  $69D3,$03 Call #R$720F.
  $69D6,$08 Call #R$7082 if *#R$5FC5 is equal to #N$04.
  $69DE,$07 Call #R$64BE if *#R$5FAD (worm Y adjustment flag) is set.
N $69E5 Tidy up at end of frame.
  $69E5,$06 Copy *#R$5FB3 to *#R$6CC3.
  $69EB,$04 Write #N$00 to *#R$5FBE.
  $69EF,$03 Set border to #INK$01.
  $69F2,$04 Restore #REGiy and #REGix from the stack.
  $69F6,$01 Return.

c $69F7 Handler: Red Bird
@ $69F7 label=Handler_RedBird
D $69F7 Handles the red bird who is a thief that steals worms Percy is
. carrying.
.
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
N $6A14 Found the correct room's data so store the flight path pointer.
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
N $6A3E Red bird stole Percy's worm so return the worm to the room and play a
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
  $6A60,$06 Jump to #R$6A9D if *#R$5FA9 is unset/ no egg is active.
  $6A66,$04 #REGiy=#R$DAE0.
  $6A6A,$04 #REGix=#R$DAC4.
N $6A6E Only check collision if the red bird is in the same room as the egg.
  $6A6E,$04 #REGb=*#R$6CB6.
  $6A72,$03 #REGa=*#R$5FC5.
  $6A75,$03 Jump to #R$6A9D if the red bird is not in the current room.
N $6A78 The red bird is in the current room.
  $6A78,$03 Call #R$6C85.
  $6A7B,$02 Jump to #R$6A9D if no collision.
N $6A7D Egg hit the red bird so check if already stunned.
  $6A7D,$06 Jump to #R$6A9A if *#R$6CB4 is set so the red bird is already
. stunned.
N $6A83 Stun the red bird so set a random stun timer and award points.
  $6A83,$03 Call #R$6C39.
  $6A86,$02,b$01 Set bit 6 (ensure a minimum stun duration).
  $6A88,$03 Write #REGa to *#R$6CB4.
  $6A8B,$03 Write #REGa to *#R$6CB5.
  $6A8E,$04 Write #N$01 to *#REGix+#N$02 (stunned colour: #INK$01).
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
N $6AAD Wrap point reached so flip the red bird's flight direction.
  $6AAD,$03 #REGa=*#R$6CB3.
  $6AB0,$02,b$01 Toggle bit 0 (flip direction).
  $6AB2,$03 Write #REGa to *#R$6CB3.
N $6AB5 Look up the flight speed for the current level from the table at
. #R$6CBE.
@ $6AB5 label=HandleRedBird_LookupSpeed
  $6AB5,$03 #REGhl=#R$6CBE.
  $6AB8,$03 #REGa=*#R$5FB1.
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
N $6AD4 Position blocked so try the next row down.
  $6AD4,$04 Increment #REGb by #N$04.
  $6AD8,$01 #REGa=#REGb.
  $6AD9,$04 Jump back to #R$6AD0 until the bottom of search area is reached.
N $6ADD Reached the bottom so wrap back to the top and shift X inward.
  $6ADD,$02 #REGb=#N$04 (reset Y to the top).
  $6ADF,$03 #REGa=*#R$6CB3 (flight direction).
  $6AE2,$03 Jump to #R$6AED if flying right.
N $6AE5 Flying left so shift the starting X position rightward.
  $6AE5,$06 Increment #REGc by #N$06.
  $6AEB,$02 Jump to #R$6AD0 to try again.
N $6AED Flying right so shift the starting X position leftward.
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
  $6AFA,$04 Write #N$00 to *#REGix+#N$03 (clear frame/ set to invisible).
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
. current room so count down and handle the transition.
@ $6B19 label=UpdateRedBirdMovement_CheckDelay
  $6B19,$06 Jump to #R$6B6E if *#R$6CBD is active.
N $6B1F Red bird is active in the current room so update its flight path.
  $6B1F,$06 Write *#R$5FC5 to *#R$6CB6 (store the red bird's current room).
N $6B25 Decrement the direction change timer.
  $6B25,$03 #REGhl=#R$6CB2.
  $6B28,$01 Decrement *#REGhl.
  $6B29,$02 Jump to #R$6B4A if the timer hasn't expired.
N $6B2B Timer expired so choose a new flight direction.
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
N $6B78 Red bird has arrived in Percy's room so clear the delay and animate.
  $6B78,$04 Write #N$00 to *#R$6CBD.
  $6B7C,$02 Jump to #R$6B5F.
N $6B7E Still waiting so decrement the appearance delay.
@ $6B7E label=UpdateRedBirdMovement_Countdown
  $6B7E,$03 #REGhl=#R$6CBD.
  $6B81,$01 Decrement *#REGhl.
  $6B82,$01 Return if the delay hasn't expired yet.
N $6B83 Delay expired; determine which direction the red bird should enter from
. based on which room it's coming from relative to Percy's room.
  $6B83,$04 Write #N$00 to *#R$6CB3 (default: flying left).
  $6B87,$04 #REGb=*#R$5FC5.
  $6B8B,$03 #REGa=*#R$6CB6.
  $6B8E,$03 Jump to #R$6B96 if the red bird is coming from a lower numbered room.
N $6B91 Red bird is coming from a higher room so enter flying right.
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
N $6BA9 Still stunned so only draw if the red bird is in the current room.
  $6BA9,$04 #REGb=*#R$6CB6.
  $6BAD,$03 #REGa=*#R$5FC5.
  $6BB0,$02 Return if the red bird is not in the same room as Percy.
N $6BB2 Red bird is stunned and visible so move it downward slowly (falling).
  $6BB2,$03 #REGc=*#REGix+#N$00 (red bird's X position).
  $6BB5,$03 #REGa=*#REGix+#N$01 (red bird's Y position).
  $6BB8,$02 #REGa+=#N$03 (drift downward).
  $6BBA,$01 Store the result in #REGb.
  $6BBB,$03 Call #R$6C0C.
  $6BBE,$02 Jump to #R$6B5F.
N $6BC0 Stun ending so clear the timer and set a short reappearance delay.
@ $6BC0 label=UpdateRedBirdMovement_StunEnd
  $6BC0,$01 Clear the stun timer to #N$00.
N $6BC1 Set a short reappearance delay.
  $6BC1,$05 Write #N$04 to *#R$6CBD.
  $6BC6,$02 Jump to #R$6B6E.

c $6BC8 8-Direction Movement Jump Table
@ $6BC8 label=Direction_Jump_Table
D $6BC8 Shared 8-direction movement jump table. Used by the red bird (#R$6AF6),
. helicopter (#R$7439) and UFO (#R$759A). The entry point is self-modified at
. #R$6BC8(#N$6BC9) to jump to one of 8 directional movement handlers. Each
. handler adjusts #REGb (Y) and/or #REGc (X) by the speed value at *#REGhl,
. then falls through to #R$6C0C to validate the position.
. #TABLE(default,centre,centre,centre,centre)
. { =h Direction | =h Index | =h X | =h Y }
. { Up | 0 | - | −speed }
. { Up-right | 1 | +speed | −speed }
. { Right | 2 | +speed | - }
. { Down-right | 3 | +speed | +speed }
. { Down | 4 | - | +speed }
. { Down-left | 5 | −speed | +speed }
. { Left | 6 | −speed | - }
. { Up-left | 7 | −speed | −speed }
. TABLE#
E $6BC8 Continue on to #R$6C0C.
  $6BC8,$02 Self-modified jump; offset written by caller (e.g. #R$6B4E, #R$746C, #R$75CE).
@ $6BCA label=Direction_Up
  $6BCA,$02 Jump to #R$6BDA (up).
@ $6BCC label=Direction_UpRight
  $6BCC,$02 Jump to #R$6BDF (up-right).
@ $6BCE label=Direction_Right
  $6BCE,$02 Jump to #R$6BE7 (right).
@ $6BD0 label=Direction_DownRight
  $6BD0,$02 Jump to #R$6BEC (down-right).
@ $6BD2 label=Direction_Down
  $6BD2,$02 Jump to #R$6BF4 (down).
@ $6BD4 label=Direction_DownLeft
  $6BD4,$02 Jump to #R$6BF9 (down-left).
@ $6BD6 label=Direction_Left
  $6BD6,$02 Jump to #R$6C01 (left).
@ $6BD8 label=Direction_UpLeft
  $6BD8,$02 Jump to #R$6C06 (up-left).
N $6BDA Movement handlers. Each adjusts #REGb and/or #REGc by the speed
. value at *#REGhl, then falls through to #R$6C0C.
@ $6BDA label=Move_Up
  $6BDA,$03 #REGb-=*#REGhl (subtract speed from Y).
  $6BDD,$02 Jump to #R$6C0C.
@ $6BDF label=Move_UpRight
  $6BDF,$03 #REGb-=*#REGhl (Y − speed).
  $6BE2,$03 #REGc+=*#REGhl (X + speed).
  $6BE5,$02 Jump to #R$6C0C.
@ $6BE7 label=Move_Right
  $6BE7,$03 #REGc+=*#REGhl (X + speed).
  $6BEA,$02 Jump to #R$6C0C.
@ $6BEC label=Move_DownRight
  $6BEC,$03 #REGc+=*#REGhl (X + speed).
  $6BEF,$03 #REGb+=*#REGhl (Y + speed).
  $6BF2,$02 Jump to #R$6C0C.
@ $6BF4 label=Move_Down
  $6BF4,$03 #REGb+=*#REGhl (Y + speed).
  $6BF7,$02 Jump to #R$6C0C.
@ $6BF9 label=Move_DownLeft
  $6BF9,$03 #REGb+=*#REGhl (Y + speed).
  $6BFC,$03 #REGc-=*#REGhl (X − speed).
  $6BFF,$02 Jump to #R$6C0C.
@ $6C01 label=Move_Left
  $6C01,$03 #REGc-=*#REGhl (X − speed).
  $6C04,$02 Jump to #R$6C0C.
@ $6C06 label=Move_UpLeft
  $6C06,$03 #REGb-=*#REGhl (Y − speed).
  $6C09,$03 #REGc-=*#REGhl (X − speed).

c $6C0C Validate Position
@ $6C0C label=Validate_Position
D $6C0C Validates a proposed position (#REGb=Y, #REGc=X) against the boundary
. table pointed to by *#R$6CBB. Used by the red bird (#R$6AF6), helicopter
. (#R$7439) and UFO (#R$759A); each caller ensures #R$6CBB points to the
. appropriate boundary data. Scans through the table for a region containing
. the position.
.
. Each entry is #N$04 bytes: Y-min, Y-max, X-min, X-max. If a valid region is
. found, the position is stored to *#REGix and carry is clear. If no valid
. region is found (entry is #N$00), carry is set.
R $6C0C B Proposed Y position
R $6C0C C Proposed X position
R $6C0C IX Pointer to sprite data (red bird, helicopter or UFO)
R $6C0C O:F Carry clear = valid, carry set = out of bounds
  $6C0C,$03 #REGhl=*#R$6CBB (boundary table pointer).
@ $6C0F label=Validate_Position_Loop
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
N $6C26 Position is within this region so store it and return success.
  $6C26,$03 Write #REGc to *#REGix+#N$00 (X position).
  $6C29,$03 Write #REGb to *#REGix+#N$01 (Y position).
  $6C2C,$01 Restore the boundary pointer from the stack.
  $6C2D,$01 Clear carry (valid position).
  $6C2E,$01 Return.
N $6C2F Position is outside this region so try the next one.
@ $6C2F label=Validate_Position_Next
  $6C2F,$01 Restore the boundary pointer from the stack.
  $6C30,$04 Advance #REGhl by #N$04 (next boundary entry).
  $6C34,$02 Jump to #R$6C0F.
N $6C36 End of boundary data. No valid region found.
@ $6C36 label=Validate_Position_OutOfBounds
  $6C36,$01 Restore the boundary pointer from the stack.
  $6C37,$01 Set carry (out of bounds).
  $6C38,$01 Return.

c $6C39 Generate Random Number
@ $6C39 label=GenerateRandomNumber
D $6C39 Generates a pseudo-random number using the seed stored at *#R$6CB7.
. The algorithm scrambles the seed value through a series of arithmetic
. operations and stores the result back as the new seed. Returns the random
. value in #REGa.
R $6C39 O:A Pseudo-random value
  $6C39,$04 #REGh=*#R$6CB7.
  $6C3D,$03 Load both #REGl and #REGd with #N$00.
  $6C40,$01 Copy *#R$6CB7 into #REGe.
N $6C41 #REGhl = seed × #N$100, #REGde = seed. Subtract #REGde twice.
  $6C41,$01 Clear carry.
  $6C42,$02 #REGhl-=#REGde.
  $6C44,$02 #REGhl-=#REGde.
  $6C46,$04 #REGhl+=#N($00FE,$04,$04).
N $6C4A Combine the high and low bytes.
  $6C4A,$01 #REGa=#REGl.
  $6C4B,$01 #REGa-=#REGh.
  $6C4C,$02 Jump to #R$6C4F if carry set.
  $6C4E,$01 Decrement #REGa.
@ $6C4F label=GenerateRandomNumber_Store
  $6C4F,$03 Write the new seed to *#R$6CB7.
  $6C52,$01 Return.

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

c $6CA5 Reset Red Bird
@ $6CA5 label=ResetRedBird
D $6CA5 Resets the red bird to an inactive state by writing #N$FF to its
. traversal direction, stun timers and current room. This effectively disables
. the red bird until it is reinitialised.
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
D $6CB6 The room number the red bird is currently in.
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
B $6CBE,$01 Speed for level #N($01+(#PC-$6CBE)): #N(#PEEK(#PC)).
L $6CBE,$01,$05

g $6CC3 Lives Display Previous
@ $6CC3 label=Lives_Display_Previous
B $6CC3,$01

g $6CC4 Red Bird Wing Animation Counter
@ $6CC4 label=RedBirdWingAnimationCounter
D $6CC4 Cycles through #N$00-#N$07 to animate the red bird's wings. Divided
. by #N$02 and added to the frame base of #N$18 to select the sprite
. frame.
B $6CC4,$01

g $6CC5 Butterfly Movement Boundary
@ $6CC5 label=Butterfly_Movement_Boundary
D $6CC5 Boundary data for the butterfly's movement, used by the direction jump
. table at #R$6BC8.
B $6CC5,$01

g $6CC6 Butterfly Room Table
@ $6CC6 label=Butterfly_Room_Table
D $6CC6 Table of room/level pairs where butterflies appear. Each entry is two
. bytes: the room number followed by the level number. Bit 7 of the level byte
. is set when the butterfly has been collected. The table is terminated by #N$FF.
B $6CC6,$02 Room #N(#PEEK(#PC))/ Level #N(#PEEK(#PC+$01)).
L $6CC6,$02,$0A
B $6CDA,$02 Terminator.

g $6CDC Butterfly Wing Flap Toggle
@ $6CDC label=Butterfly_Wing_Toggle
D $6CDC Toggled each frame to alternate the butterfly's wing animation between
. two frames.
B $6CDC,$01

g $6CDD Butterfly Movement Delay
@ $6CDD label=Butterfly_Movement_Delay
D $6CDD Countdown timer for the butterfly's current movement direction. When it
. reaches zero, a new random direction and delay are generated.
B $6CDD,$01

g $6CDE Butterfly Direction
@ $6CDE label=Butterfly_Direction
D $6CDE Current movement direction for the butterfly, in the range #N$00-#N$07.
B $6CDE,$01

c $6CDF Handle Butterfly
@ $6CDF label=Handle_Butterfly
D $6CDF Controls the bonus butterfly collectible. Butterflies flutter around
. specific rooms and can be collected by Percy for #N$02 bonus points. They
. appear only on certain room/level combinations defined in the table at
. #R$6CC6. When collected, bit 7 of the table entry is set to prevent
. recollection until the lives counter changes or Percy respawns.
R $6CDF IX Pointer to the butterfly sprite data at #R$DAE4
N $6CDF Set up the butterfly sprite and check if any collected butterflies
. need resetting.
  $6CDF,$04 Point #REGix at #R$DAE4 (butterfly sprite data).
  $6CE3,$04 Write #N$00 to *#REGix+#N$03 (clear the butterfly sprite frame).
  $6CE7,$07 Call #R$6D9E to reset collected flags if *#R$5FBE (lives backup)
. is unset.
  $6CEE,$04 Fetch the lives display character from *#R$5FB3 into #REGb.
  $6CF2,$07 Call #R$6D9E to reset collected flags if *#R$6CC3 (previous lives
. count) does not equal #REGb (lives count has changed).
N $6CF9 Search the butterfly table for an entry matching the current room and
. level.
  $6CF9,$04 Load the current room from *#R$5FC5 into #REGc.
  $6CFD,$04 Load the current level from *#R$5FB1 into #REGb.
  $6D01,$03 Point #REGhl at #R$6CC6 (butterfly room/level table).
@ $6D04 label=Search_Butterfly_Table
  $6D04,$01 Fetch the room number from *#REGhl.
  $6D05,$03 Return if the terminator byte has been found (end of table).
  $6D08,$03 Jump to #R$6D16 if the room number does not match #REGc.
  $6D0B,$01 Advance to the level byte.
  $6D0C,$01 Fetch the level number from *#REGhl.
  $6D0D,$03 Jump to #R$6D17 if the level does not match #REGb.
  $6D10,$04 Jump to #R$6D17 if bit 7 of *#REGhl is set (butterfly already
. collected).
  $6D14,$02 Jump to #R$6D1A (matching entry found).
@ $6D16 label=Skip_Butterfly_Entry_02
  $6D16,$01 Advance #REGhl by two bytes to skip this entry.
@ $6D17 label=Skip_Butterfly_Entry_01
  $6D17,$01 Advance #REGhl to skip this entry.
  $6D18,$02 Jump back to #R$6D04.
N $6D1A Matching butterfly found; animate and move it.
@ $6D1A label=Animate_Butterfly
  $6D1A,$01 Stash the table entry pointer on the stack.
  $6D1B,$04 Set the border to yellow (#N$19 output to port #N$FE).
  $6D1F,$07 Call #R$6D90 to randomise the butterfly position if *#R$5FBB
. (respawn flag) is non-zero.
N $6D26 Update the butterfly animation frame with a wing-flapping effect.
  $6D26,$04 Fetch the butterfly colour from *#R$6CDE into #REGb.
  $6D2A,$08 Toggle bit 0 of *#R$6CDC (wing flap toggle) and write back.
  $6D32,$02 Add #N$03 to get the base butterfly frame.
  $6D34,$04 If bit 2 of #REGb is set, jump to #R$6D3A; otherwise add #N$02
. for the alternate colour variant.
@ $6D3A label=Set_Butterfly_Frame
  $6D3A,$03 Write the frame to *#REGix+#N$03.
N $6D3D Decrement the movement delay and pick a new direction when it expires.
  $6D3D,$03 Point #REGhl at #R$6CDD (butterfly movement delay).
  $6D40,$01 Decrement the delay counter.
  $6D41,$02 Jump to #R$6D58 if the delay has not reached zero.
  $6D43,$03 Call #R$6C39 to generate a random number.
  $6D46,$01 Stash the random value on the stack.
  $6D47,$02,b$01 Mask with #N$07 to get a direction.
  $6D49,$03 Write the direction to *#R$6CDE.
  $6D4C,$01 Restore the random value from the stack.
  $6D4D,$03 Point #REGhl at #R$6CDD (butterfly movement delay).
  $6D50,$03 Rotate right three times.
  $6D53,$02,b$01 Mask with #N$0F.
  $6D55,$02,b$01 Set bit 0 to ensure a minimum delay of #N$01.
  $6D57,$01 Write the new delay to *#REGhl.
N $6D58 Move the butterfly in its current direction.
@ $6D58 label=Move_Butterfly
  $6D58,$03 Fetch the direction from *#R$6CDE.
  $6D5B,$01 Double it to form a jump table index.
  $6D5C,$03 Write the direction index to *#R$6BC8(#N$6BC9).
  $6D5F,$03 Point #REGhl at #R$6CC5 (butterfly movement boundary data).
  $6D62,$06 Load the butterfly's X position into #REGc and Y position into
. #REGb from *#REGix+#N$00 and *#REGix+#N$01.
  $6D68,$03 Call #R$6BC8 to move the butterfly in the current direction.
  $6D6B,$02 Jump to #R$6D43 if the move was invalid (carry set) and pick a new
. direction.
N $6D6D Check if the butterfly has collided with Percy.
  $6D6D,$04 Point #REGiy at #R$DAE4 (butterfly sprite data).
  $6D71,$04 Point #REGix at #R$DAC0 (Percy sprite data).
  $6D75,$03 Call #R$6C85 to check for collision with Percy.
  $6D78,$02 Jump to #R$6D8E if carry is set (no collision).
N $6D7A Butterfly collected by Percy.
@ $6D7A label=Butterfly_Collected
  $6D7A,$01 Restore the table entry pointer from the stack.
  $6D7B,$02 Set bit 7 of *#REGhl to mark this butterfly as collected.
  $6D7D,$02 Set the sound loop counter to #N$60 in #REGb.
@ $6D7F label=Butterfly_Sound_Loop
  $6D7F,$01 Stash the sound counter on the stack.
  $6D80,$03 Call #R$64CC to play one step of the collection sound.
  $6D83,$01 Restore the sound counter from the stack.
  $6D84,$02 Decrease the counter and loop back to #R$6D7F until the sound is
. complete.
  $6D86,$05 Call #R$67B2 to add #N$02 points to the score.
  $6D8B,$02 Set #REGb to #N$09.
  $6D8D,$01 Return.
@ $6D8E label=Butterfly_No_Collision
  $6D8E,$01 Restore the table entry pointer from the stack.
  $6D8F,$01 Return.

c $6D90 Randomise Butterfly Position
@ $6D90 label=Randomise_Butterfly_Position
D $6D90 Generates a valid random position for the butterfly by repeatedly
. generating coordinates until one passes the boundary check.
  $6D90,$03 Call #R$6C39.
  $6D93,$01 Copy to #REGc (X position).
  $6D94,$03 Call #R$6C39.
  $6D97,$01 Copy to #REGb (Y position).
  $6D98,$03 Call #R$6C0C to validate the position.
  $6D9B,$02 Jump back to #R$6D90 if the position is invalid (carry set).
  $6D9D,$01 Return.

c $6D9E Reset Butterfly Collected Flags
@ $6D9E label=Reset_Butterfly_Flags
D $6D9E Scans the butterfly table at #R$6CC6 and clears bit 7 of each level
. byte, marking all butterflies as available for collection.
  $6D9E,$03 Point #REGhl at #R$6CC6 (butterfly room/level table).
@ $6DA1 label=Reset_Butterfly_Loop
  $6DA1,$01 Fetch the room byte from *#REGhl.
  $6DA2,$03 Return if the terminator byte has been found.
  $6DA5,$02 Clear bit 7 of the level byte at *#REGhl (mark as uncollected).
  $6DA7,$01 Advance to the next entry.
  $6DA8,$02 Jump back to #R$6DA1.
  $6DAA,$01 Return.

c $6DAB Handler: Cars
@ $6DAB label=Handler_Cars
D $6DAB Dispatches to the appropriate car handler based on the current room, then
. manages the car movement and crash animation. Cars move left across the screen
. and are randomised when they go off-screen. When hit by Percy's egg, a crash
. animation plays using frames #N$24-#N$27 before the car resets.
N $6DAB Check if respawning; if so, reset the car state.
  $6DAB,$06 Jump to #R$6DB8 if *#R$5FBB is unset.
  $6DB1,$07 Write #N$00 to; #LIST { *#R$7208 } { *#R$7209 } LIST#
N $6DB8 Dispatch to the correct car handler based on the current room.
@ $6DB8 label=Dispatch_Car_Handler
  $6DB8,$08 Jump to #R$7028 if *#R$5FC5 is equal to #N$02.
  $6DC0,$06 Jump to #R$6DCE if the current room is equal to #N$01#RAW(,) else
. jump to #R$6DC6.
@ $6DC6 label=Check_Room_09
  $6DC6,$03 Return if the current room is less than #N$09.
  $6DC9,$05 Jump to #R$6F8D if the current room is equal to #N$09.
@ $6DCE label=Handle_Car_Movement
  $6DCE,$03 Call #R$6E5D.
  $6DD1,$04 Point #REGix at #R$DAD0 (car sprite data).
  $6DD5,$07 Call #R$6E2F if *#R$5FBB is set to randomise the car.
N $6DDC Check if the car is in the crash animation.
  $6DDC,$06 Jump to #R$6DFD if *#R$7209 is zero, indicating there's been no
. crash.
  $6DE2,$04 Jump to #R$6DF7 if the crash counter is equal to #N$01 (crash
. animation complete).
N $6DE6 Crash animation is playing; update the explosion frames.
  $6DE6,$04 Decrement the crash counter and write it back to *#R$7209.
M $6DEA,$04 Mask and add #N$24 to select the front crash frame.
  $6DEA,$02,b$01 Keep only bit 1.
  $6DEE,$03 Write the frame to *#REGix+#N$03 (front sprite).
  $6DF1,$04 Increment by one for the rear crash frame and write to
. *#REGix+#N$07.
  $6DF5,$02 Jump to #R$6E24.
N $6DF7 Crash animation complete; reset the crash counter.
@ $6DF7 label=Crash_Animation_Done
  $6DF7,$04 Write #N$00 to *#R$7209 to clear it.
  $6DFB,$02 Jump to #R$6E24.
N $6DFD No crash; move the car left across the screen.
@ $6DFD label=Move_Car
  $6DFD,$03 Point #REGhl at #R$720B.
  $6E00,$03 Load the car's X position from *#REGix+#N$00.
  $6E03,$04 Subtract the car speed; if the car has gone off-screen (carry set),
. call #R$6E2F to randomise a new car.
  $6E07,$03 Write the updated X position to *#REGix+#N$00 (front X).
  $6E0A,$05 Set the rear X position to the front X plus #N$10.
N $6E0F #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1E | #UDGS$02,$02(udg44763-56x4)(
.   #UDG($AEDB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6E0F,$04 Set the front sprite frame to #N$1E (car front).
N $6E13 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1F | #UDGS$02,$02(udg44795-56x4)(
.   #UDG($AEFB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6E13,$04 Set the rear sprite frame to #N$1F (car rear).
N $6E17 Check if Percy's egg has hit the car.
  $6E17,$06 Point #REGbc at #R$7209 and #REGhl at #R$DAD0.
  $6E1D,$07 Call #R$6F5A if *#R$5FA9 is non-zero to check for an egg collision
. with the car.
N $6E24 Check if the car has collided with Percy.
@ $6E24 label=Check_Car_Percy_Collision
  $6E24,$04 Point #REGix at #R$DAC0.
  $6E28,$04 Point #REGiy at #R$DAD0 (car sprite data).
  $6E2C,$03 Jump to #R$6EF7 to check if the car has collided with Percy.

c $6E2F Randomise Car Position
@ $6E2F label=Randomise_Car_Position
D $6E2F Generates random parameters for a new car entering from the right side
. of the screen. Sets a random movement speed, random sprite active flags, and
. resets the car to the bottom of the screen. Clamps the X position to a maximum
. of #N$DE.
R $6E2F IX Pointer to car sprite data
M $6E2F,$09 Generate a random car speed of #N$01-#N$04 and write to *#R$720B.
  $6E32,$02,b$01 Keep only bits 0-1.
M $6E38,$0D Generate a random sprite active value of #N$04-#N$07 and write to
. both *#REGix+#N$02 and *#REGix+#N$06.
  $6E3B,$02,b$01 Keep only bits 0-1.
  $6E45,$08 Set both Y positions (*#REGix+#N$01 and *#REGix+#N$05) to #N$A0
. (bottom of screen).
  $6E4D,$04 Write #N$00 to *#R$7209 to clear it.
  $6E51,$03 Load the car X position from *#REGix+#N$00.
  $6E54,$05 Return if the car X position is less than #N$DE.
  $6E59,$04 Otherwise clamp the X position to #N$DE and return.

c $6E5D Handler: Car Type 1 (Driving Right)
@ $6E5D label=Handler_Car_Type1
D $6E5D Handles a car driving right across the screen. The car is made up of
. two sprites (#N$10 pixels apart) representing the front and back.
.
. When the car reaches the right edge it is reinitialised from a random
. position.
  $6E5D,$04 #REGix=#R$DAC8.
  $6E61,$07 Call #R$6F13 if *#R$5FBB is set/ the room is being initialised.
N $6E68 If the car crash timer is active, handle the crash animation.
  $6E68,$03 #REGa=*#R$7208.
  $6E6B,$03 Jump to #R$6E97 if the crash timer is zero (car is driving
. normally).
  $6E6E,$04 Jump to #R$6E91 if the crash timer has reached #N$01 (crash
. ending).
N $6E72 Car is crashing — decrement the timer and cycle through crash
. animation frames.
  $6E72,$01 Decrement the crash timer.
  $6E73,$03 Write #REGa to *#R$7208.
  $6E76,$02,b$01 Keep only bit 1 (alternates between #N$00 and #N$02).
  $6E78,$02 #REGa+=#N$20 (crash frame base).
  $6E7A,$01 Stash the frame in shadow #REGaf.
N $6E7B If the car is on the lower road (Y=#N$A0), use a different frame set.
  $6E7B,$03 Load #REGa with the car's Y position (from *#REGix+#N$01).
  $6E7E,$04 Jump to #R$6E87 if the car is not on the lower road.
  $6E82,$01 Retrieve the crash frame from shadow #REGaf.
  $6E83,$02 #REGa+=#N$02 (offset to left-facing crash frames).
  $6E85,$02 Jump to #R$6E88.
@ $6E87 label=Handler_CarType1_SetCrashFrame
  $6E87,$01 Retrieve the crash frame from shadow #REGaf.
@ $6E88 label=Handler_CarType1_StoreCrashFrame
  $6E88,$03 Write #REGa to *#REGix+#N$03 (front sprite frame).
  $6E8B,$01 Increment #REGa for the rear sprite.
  $6E8C,$03 Write #REGa to *#REGix+#N$07 (rear sprite frame).
  $6E8F,$02 Jump to #R$6EEF.
N $6E91 Crash animation finished — clear the timer.
@ $6E91 label=Handler_CarType1_CrashEnd
  $6E91,$04 Write #N$00 to *#R$7208.
  $6E95,$02 Jump to #R$6EEF.
N $6E97 Car is driving normally — move it to the right.
@ $6E97 label=Handler_CarType1_Drive
  $6E97,$03 #REGhl=#R$720C (car speed).
  $6E9A,$03 #REGa=*#REGix+#N$00 (car X position).
  $6E9D,$01 #REGa+=*#REGhl (add speed).
  $6E9E,$05 Call #R$6F13 to reinitialise the car if it's at the right edge.
N $6EA3 Update both sprite X positions (#N$10 apart).
  $6EA3,$03 Write #REGa to *#REGix+#N$00 (front X).
  $6EA6,$02 #REGa+=#N$10.
  $6EA8,$03 Write #REGa to *#REGix+#N$04 (rear X).
N $6EAB Set the driving right frames.
  $6EAB,$04 Write #N$1C to *#REGix+#N$03 (front frame: driving right).
  $6EAF,$04 Write #N$1D to *#REGix+#N$07 (rear frame: driving right).
N $6EB3 Set the car colour for both sprites.
  $6EB3,$09 Write *#R$720A to; #LIST
. { *#REGix+#N$02 (front colour) }
. { *#REGix+#N$06 (rear colour) }
. LIST#
N $6EBC Set the Y positions for the wheels/underside sprites.
  $6EBC,$04 Write #N$A0 to *#REGix+#N$21 (front underside Y).
  $6EC0,$04 Write #N$A0 to *#REGix+#N$25 (rear underside Y).
N $6EC4 Set the X positions for the underside sprites (offset by #N$03 and
. #N$18 from the car's X).
  $6EC4,$03 #REGa=*#REGix+#N$00.
  $6EC7,$02 #REGa+=#N$03.
  $6EC9,$03 Write #REGa to *#REGix+#N$20 (front underside X).
  $6ECC,$02 #REGa+=#N$15.
  $6ECE,$03 Write #REGa to *#REGix+#N$24 (rear underside X).
N $6ED1 Animate the wheels — cycle through frames #N$10-#N$13.
  $6ED1,$03 #REGhl=#R$720D (wheel animation counter).
  $6ED4,$01 #REGa=*#REGhl.
  $6ED5,$01 Increment the counter.
  $6ED6,$02,b$01 Keep only bits 0-1 (cycle #N$00-#N$03).
  $6ED8,$01 Write back to *#REGhl.
  $6ED9,$02 #REGa+=#N$10 (wheel frame base).
  $6EDB,$03 Write #REGa to *#REGix+#N$23 (front wheel frame).
N $6EDE Offset the rear wheel animation by #N$02 for visual variety.
  $6EDE,$01 #REGa=*#REGhl.
  $6EDF,$02 #REGa+=#N$02.
  $6EE1,$02,b$01 Keep only bits 0-1.
  $6EE3,$02 #REGa+=#N$10 (wheel frame base).
  $6EE5,$03 Write #REGa to *#REGix+#N$27 (rear wheel frame).
N $6EE8 Check if Percy's egg has hit the car.
  $6EE8,$03 #REGa=*#R$5FA9.
  $6EEB,$04 Call #R$6F54 if the egg is active.
N $6EEF Check if the car has collided with Percy.
@ $6EEF label=Handler_CarCheckPercyCollision
  $6EEF,$04 #REGix=#R$DAC0.
  $6EF3,$04 #REGiy=#R$DACC.
@ $6EF7 label=Handler_CarCheckPercyCollision_Test
  $6EF7,$03 Call #R$6C53.
  $6EFA,$01 Return if no collision.
N $6EFB Car hit Percy — knock him backward.
@ $6EFB label=Handler_CarKnockBackPercy
  $6EFB,$03 #REGhl=#R$DAC0 (Percy's X position).
  $6EFE,$01 #REGa=*#REGhl.
  $6EFF,$02 #REGa-=#N$14 (knock back distance).
  $6F01,$02 Jump to #R$6F0B if the result underflowed (Percy at the left edge).
  $6F03,$01 Write the new X position to *#REGhl.
  $6F04,$01 Advance to Percy's Y position.
  $6F05,$02 Write #N$78 to *#REGhl (set Percy's Y position after knockback).
  $6F07,$03 Write #REGa to *#R$5FA7 (set the falling state).
  $6F0A,$01 Return.
N $6F0B Percy was too close to the left edge — adjust position rightward.
@ $6F0B label=Handler_CarKnockBackPercy_LeftEdge
  $6F0B,$01 #REGa=*#REGhl.
  $6F0C,$02 #REGa+=#N$0A.
  $6F0E,$02 Jump to #R$6F03.

N $6F10 Alternate entry point for car initialisation.
@ $6F10 label=InitialiseCar_Alternate
  $6F10,$03 Call #R$6F13.

c $6F13 Initialise Car
@ $6F13 label=InitialiseCar
D $6F13 Initialises a car with random speed, colour and position. The car
. starts at Y=#N$90 (upper road) with the possibility of appearing at different
. X positions.
R $6F13 IX Pointer to car sprite data
  $6F13,$03 Call #R$6C39.
  $6F16,$02,b$01 Keep only bits 0-1 (random speed #N$00-#N$03).
  $6F18,$01 Increment (speed #N$01-#N$04).
  $6F19,$03 Write #REGa to *#R$720C.
N $6F1C Set a random appearance delay if the room is valid.
  $6F1C,$03 #REGa=*#R$5FC5.
  $6F1F,$03 Jump to #R$6F2C if the room number is zero.
  $6F22,$03 Call #R$6C39.
  $6F25,$02,b$01 Keep only bits 0-4.
  $6F27,$02,b$01 Set bit 0 (ensure odd value).
  $6F29,$03 Write #REGa to *#R$720E.
N $6F2C Pick a random colour, but reject colour #N$01 (blue).
@ $6F2C label=InitialiseCar_PickColour
  $6F2C,$03 Call #R$6C39.
  $6F2F,$02,b$01 Keep only bits 0-1 (random colour #N$00-#N$03).
  $6F31,$04 Jump to #R$6F2C if the colour is #INK$01 (pick again).
  $6F35,$03 Write #REGa to *#R$720A.
N $6F38 Clear the crash timer and set the car on the upper road.
  $6F38,$04 Write #N$00 to *#R$7208.
  $6F3C,$04 Write #N$90 to *#REGix+#N$01 (front Y: upper road).
  $6F40,$04 Write #N$90 to *#REGix+#N$05 (rear Y: upper road).
  $6F44,$04 Write #N$07 to *#REGix+#N$22 (front wheel colour: white).
  $6F48,$04 Write #N$07 to *#REGix+#N$26 (rear wheel colour: white).
N $6F4C If the car's X position is past #N$64, reset it to the left.
  $6F4C,$03 Load #REGa with the car's X position (from *#REGix+#N$00).
  $6F4F,$03 Return if the car's X position is less than #N$64 (position is
. valid).
  $6F52,$01 #REGa=#N$00 (reset X position to the left edge).
  $6F53,$01 Return.

c $6F54 Check Car Egg Collision
@ $6F54 label=CheckCarEggCollision
D $6F54 Checks if Percy's egg has hit the car. If so, starts the crash
. animation and awards points.
R $6F54 IX Pointer to car sprite data
  $6F54,$03 #REGhl=#R$DAC8.
  $6F57,$03 #REGbc=#R$7208 (crash timer).
@ $6F5A label=CheckCarEggCollision_Test
  $6F5A,$01 #REGa=*#REGhl.
  $6F5B,$01 Stash the original X position on the stack.
  $6F5C,$02 #REGa+=#N$05 (offset to centre of car).
  $6F5E,$01 Write the adjusted position to *#REGhl.
  $6F5F,$03 Copy #REGhl to #REGix.
  $6F62,$04 #REGiy=#R$DAE0 (egg sprite data).
  $6F66,$01 Stash #REGbc on the stack.
  $6F67,$03 Call #R$6C85.
  $6F6A,$01 Restore #REGbc from the stack.
  $6F6B,$02 Jump to #R$6F8A if no collision.
N $6F6D Egg hit the car — restore the original X position and start the crash.
  $6F6D,$01 Restore the original X position from the stack.
  $6F6E,$01 Write it back to *#REGhl.
  $6F6F,$03 Call #R$6C39.
  $6F72,$02,b$01 Set bit 4 (ensure a minimum crash duration).
  $6F74,$01 Write #REGa to *#REGbc (crash timer).
  $6F75,$05 Call #R$67B2 to add #N$0F points to the score.
N $6F7A Play a short random sound burst — used as a hit sound effect by
. multiple routines.
@ $6F7A label=PlayHitSound
  $6F7A,$02 #REGb=#N$00 (loop #N$100 times).
@ $6F7C label=PlayHitSound_Loop
  $6F7C,$03 Call #R$6C39.
  $6F7F,$02,b$01 Keep only bits 3-4.
  $6F81,$02,b$01 Set bit 0 (border colour: blue).
  $6F83,$02 Send to the speaker.
  $6F85,$02 No operation.
  $6F87,$02 Decrease #REGb by one and loop back to #R$6F7C until done.
  $6F89,$01 Return.
N $6F8A No collision — restore the original X position and return.
@ $6F8A label=CheckCarEggCollision_Miss
  $6F8A,$01 Restore the original X position from the stack.
  $6F8B,$01 Write it back to *#REGhl.
  $6F8C,$01 Return.

c $6F8D Handler: Car Type 2 (Driving Left)
@ $6F8D label=Handler_CarType2
D $6F8D Handles a car driving left across the screen. When it reaches the left
. boundary it turns around and drives right at ground level until reaching the
. right edge, then reinitialises.
  $6F8D,$04 #REGix=#R$DAC8.
  $6F91,$03 #REGhl=#R$720B (car speed).
N $6F94 If the room is being initialised, set up the car.
  $6F94,$06 Jump to #R$700C if *#R$5FBB is set.
N $6F9A If the car crash timer is active, handle the crash animation.
  $6F9A,$07 Jump to #R$6E6E if *#R$7208 is active.
N $6FA1 Check which road the car is on.
  $6FA1,$03 #REGa=*#REGix+#N$01 (car Y position).
  $6FA4,$04 Jump to #R$6FCB if on the upper road.
N $6FA8 Car is on the lower road (Y=#N$A0) — driving left.
  $6FA8,$03 #REGa=*#REGix+#N$00 (car X position).
  $6FAB,$01 #REGa-=*#REGhl (subtract speed).
  $6FAC,$04 Jump to #R$6FEE if at the left boundary (turn around).
N $6FB0 Update positions and set driving left frames.
@ $6FB0 label=Handler_CarType2_UpdateLeft
  $6FB0,$03 Write #REGa to *#REGix+#N$00 (front X).
  $6FB3,$02 #REGa+=#N$10.
  $6FB5,$03 Write #REGa to *#REGix+#N$04 (rear X).
  $6FB8,$04 Write #N$A0 to *#REGix+#N$01 (front Y: lower road).
  $6FBC,$04 Write #N$A0 to *#REGix+#N$05 (rear Y: lower road).
N $6FC0 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1E | #UDGS$02,$02(udg44763-56x4)(
.   #UDG($AEDB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6FC0,$04 Write #N$1E to *#REGix+#N$03 (front frame: driving left).
N $6FC4 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1F | #UDGS$02,$02(udg44795-56x4)(
.   #UDG($AEFB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6FC4,$04 Write #N$1F to *#REGix+#N$07 (rear frame: driving left).
  $6FC8,$03 Jump to #R$6EE8.
N $6FCB Car is on the upper road (Y=#N$90) — driving right.
@ $6FCB label=Handler_CarType2_DriveRight
  $6FCB,$03 #REGa=*#REGix+#N$00 (car X position).
  $6FCE,$01 #REGa+=*#REGhl (add speed).
  $6FCF,$04 Jump to #R$700C if at the right edge (reinitialise).
N $6FD3 Update positions and set driving right frames.
@ $6FD3 label=Handler_CarType2_UpdateRight
  $6FD3,$03 Write #REGa to *#REGix+#N$00 (front X).
  $6FD6,$02 #REGa+=#N$10.
  $6FD8,$03 Write #REGa to *#REGix+#N$04 (rear X).
  $6FDB,$04 Write #N$90 to *#REGix+#N$01 (front Y: upper road).
  $6FDF,$04 Write #N$90 to *#REGix+#N$05 (rear Y: upper road).
N $6FE3 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1C | #UDGS$02,$02(udg44699-56x4)(
.   #UDG($AE9B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6FE3,$04 Write #N$1C to *#REGix+#N$03 (front frame: driving right).
N $6FE7 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$1D | #UDGS$02,$02(udg44731-56x4)(
.   #UDG($AEBB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $6FE7,$04 Write #N$1D to *#REGix+#N$07 (rear frame: driving right).
  $6FEB,$03 Jump to #R$6EBC.
N $6FEE Car reached the left boundary — turn around. Pick a new random speed
. and colour, then start driving right from the left boundary.
@ $6FEE label=Handler_CarType2_TurnAround
  $6FEE,$01 Stash #REGhl on the stack.
  $6FEF,$03 Call #R$6C39.
  $6FF2,$01 Restore #REGhl from the stack.
  $6FF3,$02,b$01 Keep only bits 0-1 (random speed #N$00-#N$03).
  $6FF5,$01 Increment the random number by one (speed #N$01-#N$04).
  $6FF6,$01 Write the new speed to *#REGhl.
N $6FF7 Pick a new colour, rejecting #INK$01.
@ $6FF7 label=PickCarColour
  $6FF7,$01 Stash #REGhl on the stack.
  $6FF8,$03 Call #R$6C39.
  $6FFB,$01 Restore #REGhl from the stack.
  $6FFC,$02,b$01 Keep only bits 0-1 (random colour from #FOR$00,$03,,$01(n,#INKn)).
  $6FFE,$04 Jump to #R$6FF7 if the colour is #INK$01 (pick again).
  $7002,$03 Write #REGa to *#REGix+#N$02 (front colour).
  $7005,$03 Write #REGa to *#REGix+#N$06 (rear colour).
  $7008,$02 #REGa=#N$68 (left boundary X position).
  $700A,$02 Jump to #R$6FD3.
N $700C Initialise car type 2 — start from the right edge driving left with
. a random speed and colour.
@ $700C label=Handler_CarType2_Initialise
  $700C,$01 Stash #REGhl on the stack.
  $700D,$03 Call #R$6C39.
  $7010,$01 Restore #REGhl from the stack.
  $7011,$02,b$01 Keep only bits 0-1 (random speed #N$00-#N$03).
  $7013,$01 Increment the random speed by one (speed #N$01-#N$04).
  $7014,$01 Write the new speed to *#REGhl.
N $7015 Pick a colour, using the range #N$04-#N$07 (bright colours).
  $7015,$01 Stash #REGhl on the stack.
  $7016,$03 Call #R$6C39.
  $7019,$01 Restore #REGhl from the stack.
  $701A,$02,b$01 Keep only bits 0-1.
  $701C,$02 #REGa+=#N$04 (bright colour range).
  $701E,$03 Write #REGa to *#REGix+#N$02 (front colour).
  $7021,$03 Write #REGa to *#REGix+#N$06 (rear colour).
  $7024,$02 #REGa=#N$DE (right edge X position).
  $7026,$02 Jump to #R$6FB0.

c $7028 Handler: Car Type 3 (Driving Left, Fixed Speed)
@ $7028 label=Handler_CarType3
D $7028 Handles a car driving left across the screen. When it reaches the left
. boundary it reinitialises from the right edge. Speed is fixed at #N$01.
  $7028,$04 #REGix=#R$DAC8.
  $702C,$03 #REGhl=#R$720B.
  $702F,$02 Write #N$01 to *#REGhl (fixed speed of #N$01).
N $7031 If the room is being initialised, set up the car.
  $7031,$06 Jump to #R$704E if *#R$5FBB is set.
N $7037 If the car crash timer is active, handle the crash animation.
  $7037,$07 Jump to #R$6E6E if *#R$7208 is active.
N $703E Check which road the car is on.
  $703E,$03 #REGa=*#REGix+#N$01 (car Y position).
  $7041,$04 Jump to #R$7063 if the car is on the upper road.
N $7045 Car is on the lower road — driving left.
  $7045,$03 #REGa=*#REGix+#N$00 (car X position).
  $7048,$01 #REGa-=*#REGhl (subtract speed).
  $7049,$02 Jump to #R$704E if the result underflowed (reinitialise).
  $704B,$03 Jump to #R$6FB0.
N $704E Initialise car type 3 — pick a random colour (rejecting #N$01) and
. start from the right edge.
@ $704E label=Handler_CarType3_Initialise
  $704E,$01 Stash #REGhl on the stack.
  $704F,$03 Call #R$6C39.
  $7052,$01 Restore #REGhl from the stack.
  $7053,$02,b$01 Keep only bits 0-1 (random colour from #FOR$00,$03,,$01(n,#INKn)).
  $7055,$04 Jump to #R$704E if the colour is #INK$01 (pick again).
  $7059,$03 Write #REGa to *#REGix+#N$02 (front colour).
  $705C,$03 Write #REGa to *#REGix+#N$06 (rear colour).
  $705F,$01 #REGa=#N$00 (start from the left edge).
  $7060,$03 Jump to #R$6FD3.
N $7063 Car is on the upper road — driving right.
@ $7063 label=Handler_CarType3_DriveRight
  $7063,$03 #REGa=*#REGix+#N$00 (car X position).
  $7066,$01 #REGa+=*#REGhl (add speed).
  $7067,$04 Jump to #R$706E if past the boundary.
  $706B,$03 Jump to #R$6FD3.
N $706E Pick a new bright colour and restart from #N$28.
@ $706E label=Handler_CarType3_Restart
  $706E,$01 Stash #REGhl on the stack.
  $706F,$03 Call #R$6C39.
  $7072,$01 Restore #REGhl from the stack.
  $7073,$02,b$01 Keep only bits 0-1.
  $7075,$02 #REGa+=#N$04 (bright colour range).
  $7077,$03 Write #REGa to *#REGix+#N$02 (front colour).
  $707A,$03 Write #REGa to *#REGix+#N$06 (rear colour).
  $707D,$02 #REGa=#N$28.
  $707F,$03 Jump to #R$6FB0.

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
@ $70DB label=Update_Frog
D $70DB Updates a single frog's animation and sound state. Frogs sit idle on
. their platform, then randomly jump upward through a series of animation frames.
. A croaking sound effect plays during the jump, rising in pitch on the way up
. and falling on the way down.
R $70DB B Platform Y position
R $70DB C Platform X position (left frog)
R $70DB HL Pointer to the frog's state data (jump timer, sound counters)
R $70DB IX Pointer to the frog's sprite data
N $70DB Check the jump timer to determine if the frog is mid-jump or idle.
  $70DB,$02 Fetch the jump timer value from *#REGhl.
  $70DD,$02 Jump to #R$70ED if the timer is zero (frog is idle).
  $70DF,$01 Decrement the jump timer by one.
  $70E0,$02 Jump to #R$70ED if the timer has now reached zero (jump complete).
N $70E2 Frog is mid-jump; cycle through animation frames #N$00-#N$03.
M $70E2,$09 Increment the animation frame at *#REGix+#N$02, wrapping at #N$03.
  $70E6,$02,b$01 Keep only bits 0-1.
  $70EB,$02 Jump to #R$70F1.
N $70ED Frog is idle; set the idle frame.
@ $70ED label=Set_Frog_Idle
  $70ED,$04 Write #N$06 to *#REGix+#N$02 (idle animation frame).
N $70F1 Handle the frog's croak sound effect. The sound has two phases:
. ascending pitch (counter rises from #N$01 to #N$18), then descending pitch
. (counter falls back to #N$00).
@ $70F1 label=Handle_Frog_Sound
  $70F1,$02 Advance to the ascending sound counter.
  $70F3,$03 Jump to #R$7129 if the sound counter is zero (no sound playing).
  $70F6,$01 Advance to the descending flag.
  $70F7,$04 Jump to #R$7117 if the descending flag is non-zero (sound is
. descending).
N $70FB Ascending phase: increment the pitch and output to the speaker.
  $70FB,$01 Move back to the ascending counter.
M $70FC,$08 Calculate the speaker output from the counter: add #N$03, rotate
. left, mask and set bit 0 for the border.
  $7100,$02,b$01 Keep only bits 3-4.
  $7102,$02,b$01 Set bit 0.
  $7104,$02 Output to the speaker port.
  $7106,$02 Fetch the ascending counter and increment it.
  $7108,$04 Jump to #R$7114 if the ascending counter has not reached #N$19.
N $710C Ascending phase complete; switch to descending.
  $710C,$02 Write #N$00 to clear the ascending counter.
  $710E,$03 Set the descending flag to #N$FF.
  $7111,$01 Move the pointer back to the ascending counter.
  $7112,$02 Jump to #R$7144.
@ $7114 label=Store_Ascending_Counter
  $7114,$01 Write the updated ascending counter back.
  $7115,$02 Jump to #R$7144.
N $7117 Descending phase: decrement the pitch and output to the speaker.
@ $7117 label=Frog_Sound_Descending
  $7117,$01 Move back to the ascending counter (used as pitch value).
M $7118,$06 Calculate the speaker output from the counter: rotate left, mask
. and set bit 0 for the border.
  $711A,$02,b$01 Keep only bits 3-4.
  $711C,$02,b$01 Set bit 0.
  $711E,$02 Output to the speaker port.
  $7120,$03 Decrement the counter; jump to #R$7144 if it is non-zero.
  $7123,$04 Counter has reached zero; clear the descending flag and move back.
  $7127,$02 Jump to #R$7144.
N $7129 No sound playing; randomly trigger a new croak if the frog is idle.
@ $7129 label=Check_Random_Croak
M $7129,$06 Read the R register and mask; jump to #R$7144 if it does
. not equal #N$0F (random chance to croak).
  $712B,$02,b$01 Keep only bits 0-5.
  $7131,$07 Jump to #R$7144 if the animation frame at *#REGix+#N$02 is not
. #N$06 (frog must be idle to start a croak).
  $7138,$04 Advance to the descending flag; check if it is non-zero and move
. back.
  $713C,$02 Jump to #R$7142 if the descending flag is non-zero.
  $713E,$02 Write #N$01 to start the ascending sound counter.
  $7140,$02 Jump to #R$7144.
@ $7142 label=Start_Descending_Croak
  $7142,$02 Write #N$19 to the ascending counter (start from maximum pitch).
N $7144 Calculate the frog's screen position based on its jump state and
. facing direction.
@ $7144 label=Position_Frog_Sprite
  $7144,$03 Load the ascending counter into #REGe and descending flag into
. #REGd.
  $7147,$04 Jump to #R$716C if the ascending counter is zero (frog is on the
. platform).
N $714B Frog is mid-jump; calculate the Y position from the jump height table.
  $714B,$01 Decrement the counter to form a zero-based table index.
  $714C,$01 Stash #REGde on the stack.
  $714D,$07 Look up the jump height from the table at #R$71EF.
  $7154,$01 Restore #REGde from the stack.
  $7155,$02 Subtract from the platform Y position in #REGb.
  $7157,$03 Write it to *#REGix+#N$01.
  $715A,$04 Calculate the X position: ascending counter * #N$04 + platform X.
  $715E,$03 Write it to *#REGix+#N$00.
N $7161 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$28 | #UDGS$02,$02(udg45083-56x4)(
.   #UDG($B01B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $7161,$04 Set the sprite frame to #R$B01B(#N$28) (frog jumping right).
  $7165,$03 Return if bit 7 of #REGd is not set (facing right).
N $7168 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$29 | #UDGS$02,$02(udg45115-56x4)(
.   #UDG($B03B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $7168,$03 Increment the sprite frame to #R$B03B(#N$29) (frog jumping left).
  $716B,$01 Return.
N $716C Frog is on the platform; set its resting position.
@ $716C label=Frog_On_Platform
  $716C,$03 Set the Y position to the platform Y from #REGb.
  $716F,$04 Jump to #R$7184 if bit 7 of #REGd is set (frog faces left).
  $7173,$03 Set the X position to the platform X from #REGc.
N $7176 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$2A | #UDGS$02,$02(udg45147-56x4)(
.   #UDG($B05B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $7176,$04 Set the sprite frame to #R$B05B(#N$2A) (frog sitting right).
@ $717A label=Random_Tongue_Flick
M $717A,$04 Read the R register and mask.
  $717C,$02,b$01 Keep only bits 0-4.
  $717E,$02 Return if the result is non-zero (random chance to flick tongue).
N $7180 #UDGTABLE(default,centre,centre,centre,centre)
. { =h Sprite ID | =h Sprite |  =h Sprite ID | =h Sprite }
. { =h,c2 Right | =h,c2 Left }
. { #N$2B | #UDGS$02,$02(udg45179-56x4)(
.   #UDG($B07B+$08*($02*$x+$y))(*udg)
.   udg
. ) |
.   #N$2D | #UDGS$02,$02(udg45243-56x4)(
.   #UDG($B0BB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $7180,$03 Increment the sprite frame by one (tongue-out variant).
  $7183,$01 Return.
N $7184 Left-facing frog on platform.
@ $7184 label=Frog_Facing_Left
  $7184,$06 Set the X position to platform X plus #N$68.
N $718A #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$2C | #UDGS$02,$02(udg45211-56x4)(
.   #UDG($B09B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $718A,$04 Set the sprite frame to #R$B09B(#N$2C) (frog sitting left).
  $718E,$02 Jump to #R$717A.

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
N $71A9 Stun the frog and set a random stun timer/ award points.
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
@ $71E9 label=Frog1_StunCountdown
  $71E9,$01 Stun countdown.
@ $71EA label=Frog1_SoundCounter
  $71EA,$01 Ascending sound counter for frog 1. Also used as the horizontal jump
. offset when positioning the frog sprite (multiplied by #N$04 and added to the
. platform X position).
@ $71EB label=Frog1_Descending_Flag
  $71EB,$01 Descending sound flag for frog 1. Also determines the frog's facing
. direction: bit 7 set = facing left, bit 7 clear = facing right.

g $71EC Frog 2 State Data
@ $71EC label=Frog2_StunCountdown
  $71EC,$01 Stun countdown.
@ $71ED label=Frog2_SoundCounter
  $71ED,$01 Ascending sound counter for frog 2. Also used as the horizontal jump
. offset when positioning the frog sprite (multiplied by #N$04 and added to the
. platform X position).
@ $71EE label=Frog2_Descending_Flag
  $71EE,$01 Descending sound flag for frog 2. Also determines the frog's facing
. direction: bit 7 set = facing left, bit 7 clear = facing right.

g $71EF Table: Frog Jump Height
@ $71EF label=Table_FrogJumpHeight
D $71EF Jump height lookup table. Each entry is the Y offset from ground level
. for one step of the frog's jump arc. The values rise to a peak of #N$22 at
. the midpoint then fall back to #N$00, forming a smooth parabolic arc over
. #N$18 steps.
  $71EF,$19,$0C,$01,$0C

g $7208 Car State Data
@ $7208 label=CarCrashTimer
D $7208 Crash animation timer. When non-zero, the car cycles through crash
. frames. Counts down to #N$01, then clears.
B $7208,$01
@ $7209 label=CarCrashCounter
B $7209,$01 Car crash counter.
@ $720A label=CarColour
B $720A,$01 The car's current body colour.
@ $720B label=CarSpeed
B $720B,$01 Car speed for the left-driving variants (types 2 and 3).
@ $720C label=CarSpeed2
B $720C,$01 Car speed for the right-driving variant (type 1).
@ $720D label=CarWheelAnimation
B $720D,$01 Wheel animation counter. Cycles through #N$00-#N$03 to animate the
. wheel rotation frames #N$10-#N$13.
@ $720E label=CarAppearanceDelay
B $720E,$01 Random delay before the car appears after initialisation.

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
  $723F,$01 Copy the phase counter into #REGa.
  $7240,$03 Return if the phase counter is #N$01.
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
  $7265,$01 Copy the phase counter into #REGa.
  $7266,$04 #REGix=#R$DAD0.
  $726A,$02 Is the phase counter equal to #N$02?
  $726C,$01 Stash the phase counter on the stack.
  $726D,$03 Call #R$7512 if the phase counter is not equal to #N$02.
  $7270,$01 Restore the phase counter from the stack.
  $7271,$04 #REGix=#R$DAD8.
  $7275,$01 Stash the phase counter on the stack.
  $7276,$02 Is the phase counter equal to #N$04?
  $7278,$03 Call #R$79D2 if the phase counter is greater than #N$04.
  $727B,$01 Restore the phase counter from the stack.
  $727C,$04 #REGix=#R$DAD4.
  $7280,$05 Call #R$7439 if the phase counter is greater than #N$03.
  $7285,$01 Return.

c $7286 Handler: Room #N$03
@ $7286 label=Handler_Room03
D $7286 Handles room #N$03 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $7286 B Room phase counter (from *#R$5FB1)
  $7286,$01 Copy the phase counter into #REGa.
  $7287,$04 #REGix=#R$DAC8.
  $728B,$01 Stash the phase counter on the stack.
  $728C,$05 Call #R$7439 if the phase counter is not equal to #N$02.
  $7291,$01 Restore the phase counter from the stack.
  $7292,$04 #REGix=#R$DACC.
  $7296,$02 Is the phase counter equal to #N$01?
  $7298,$01 Stash the phase counter on the stack.
  $7299,$03 Call #R$7512 if the phase counter is not equal to #N$01.
  $729C,$01 Restore the phase counter from the stack.
  $729D,$04 #REGix=#R$DAD0.
  $72A1,$01 Stash the phase counter on the stack.
  $72A2,$05 Call #R$758B if the phase counter is not equal to #N$01.
  $72A7,$01 Restore the phase counter from the stack.
  $72A8,$04 #REGix=#R$DAD8.
  $72AC,$02 Is the phase counter equal to #N$04?
  $72AE,$01 Stash the phase counter on the stack.
  $72AF,$03 Call #R$7680 if the phase counter is greater than #N$04.
  $72B2,$01 Restore the phase counter from the stack.
  $72B3,$04 #REGix=#R$DADC.
  $72B7,$05 Call #R$759A if the phase counter is equal to #N$05.
  $72BC,$01 Return.

c $72BD Handler: Room #N$04
@ $72BD label=Handler_Room04
D $72BD Handles room #N$04 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $72BD B Room phase counter (from *#R$5FB1)
  $72BD,$01 Copy the phase counter into #REGa.
  $72BE,$03 Return if #REGa is equal to #N$01.
  $72C1,$01 Stash the phase counter on the stack.
  $72C2,$04 #REGix=#R$DAD0.
  $72C6,$05 Call #R$7439 if the phase counter is not equal to #N$05.
  $72CB,$01 Restore the phase counter from the stack.
  $72CC,$04 #REGix=#R$DAD4.
  $72D0,$01 Stash the phase counter on the stack.
  $72D1,$05 Call #R$7680 if the phase counter is greater than #N$03.
  $72D6,$01 Restore the phase counter from the stack.
  $72D7,$04 #REGix=#R$DAD8.
  $72DB,$05 Call #R$77B9 if the phase counter is equal to #N$04.
  $72E0,$01 Return.

c $72E1 Handler: Room #N$05
@ $72E1 label=Handler_Room05
D $72E1 Handles room #N$05 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $72E1 B Room phase counter (from *#R$5FB1)
  $72E1,$01 Copy the phase counter into #REGa.
  $72E2,$04 #REGix=#R$DAC8.
  $72E6,$01 Stash the phase counter on the stack.
  $72E7,$03 Call #R$7439.
  $72EA,$01 Restore the phase counter from the stack.
  $72EB,$03 Return if the phase counter is equal to #N$01.
  $72EE,$01 Stash the phase counter on the stack.
  $72EF,$04 #REGix=#R$DACC.
  $72F3,$03 Call #R$7512.
  $72F6,$01 Restore the phase counter from the stack.
  $72F7,$03 Return if the phase counter is equal to #N$02.
  $72FA,$04 #REGix=#R$DAD0.
  $72FE,$01 Stash the phase counter on the stack.
  $72FF,$03 Call #R$7680.
  $7302,$01 Restore the phase counter from the stack.
  $7303,$03 Return if the phase counter is equal to #N$03.
  $7306,$04 #REGix=#R$DAD4.
  $730A,$03 Call #R$7893.
  $730D,$01 Return.

c $730E Handler: Room #N$06
@ $730E label=Handler_Room06
D $730E Handles room #N$06 logic (the starting screen). The phase counter in
. #REGb controls which objects are initialised or activated on each pass,
. progressively setting up more objects as the phase increases.
R $730E B Room phase counter (from *#R$5FB1)
  $730E,$01 Copy the phase counter into #REGa.
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
D $7367 Handles room #N$07 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $7367 B Room phase counter (from *#R$5FB1)
  $7367,$01 Copy the phase counter into #REGa.
  $7368,$04 #REGix=#R$DAC8.
  $736C,$01 Stash the phase counter on the stack.
  $736D,$03 Call #R$7439.
  $7370,$01 Restore the phase counter from the stack.
  $7371,$04 #REGix=#R$DACC.
  $7375,$01 Stash the phase counter on the stack.
  $7376,$0A Call #R$7512 if the phase counter is equal to either #N$02 or #N$05.
  $7380,$01 Restore the phase counter from the stack.
  $7381,$06 Return if the phase counter is equal to #N$01 or less than #N$04.
  $7387,$04 #REGix=#R$DAD0.
  $738B,$01 Stash the phase counter on the stack.
  $738C,$03 Call #R$77B9.
  $738F,$01 Restore the phase counter from the stack.
  $7390,$03 Return if the phase counter is equal to #N$04.
  $7393,$04 #REGix=#R$DAD8.
  $7397,$01 Stash the phase counter on the stack.
  $7398,$03 Call #R$758B.
  $739B,$01 Restore the phase counter from the stack.
  $739C,$04 #REGix=#R$DADC.
  $73A0,$03 Call #R$759A.
  $73A3,$01 Return.

c $73A4 Handler: Room #N$08
@ $73A4 label=Handler_Room08
D $73A4 Handles room #N$08 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $73A4 B Room phase counter (from *#R$5FB1)
  $73A4,$01 Copy the phase counter into #REGa.
  $73A5,$04 #REGix=#R$DAC8.
  $73A9,$01 Stash the phase counter on the stack.
  $73AA,$03 Call #R$7439.
  $73AD,$01 Restore the phase counter from the stack.
  $73AE,$04 #REGix=#R$DACC.
  $73B2,$03 Return if the phase counter is equal to #N$01.
  $73B5,$01 Stash the phase counter on the stack.
  $73B6,$05 Call #R$7512 if the phase counter is not equal to #N$03.
  $73BB,$01 Restore the phase counter from the stack.
  $73BC,$06 Return if the phase counter is equal to either #N$02 or #N$03.
  $73C2,$01 Stash the phase counter on the stack.
  $73C3,$04 #REGix=#R$DAD0.
  $73C7,$03 Call #R$77B9.
  $73CA,$01 Restore the phase counter from the stack.
  $73CB,$01 Stash the phase counter on the stack.
  $73CC,$04 #REGix=#R$DAD8.
  $73D0,$05 Call #R$79D2 if the phase counter is greater than #N$03.
  $73D5,$01 Restore the phase counter from the stack.
  $73D6,$03 Return if the phase counter is equal to #N$04.
  $73D9,$04 #REGix=#R$DAD4.
  $73DD,$03 Call #R$7893.
  $73E0,$01 Return.

c $73E1 Handler: Room #N$09
@ $73E1 label=Handler_Room09
D $73E1 Handles room #N$09 logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $73E1 B Room phase counter (from *#R$5FB1)
  $73E1,$01 Copy the phase counter into #REGa.
  $73E2,$03 Return if the phase counter is equal to #N$01.
  $73E5,$04 #REGix=#R$DAD0.
  $73E9,$01 Stash the phase counter on the stack.
  $73EA,$05 Call #R$7439 if the phase counter is not equal to #N$03.
  $73EF,$01 Restore the phase counter from the stack.
  $73F0,$04 #REGix=#R$DAD8.
  $73F4,$05 Call #R$79D2 if the phase counter is greater than #N$03.
  $73F9,$01 Return.

c $73FA Handler: Room #N$0A
@ $73FA label=Handler_Room10
D $73FA Handles room #N$0A logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $73FA B Room phase counter (from *#R$5FB1)
  $73FA,$01 Copy the phase counter into #REGa.
  $73FB,$03 Return if the phase counter is less than #N$03.
  $73FE,$04 #REGix=#R$DAD8.
  $7402,$01 Stash the phase counter on the stack.
  $7403,$05 Call #R$7439 if the phase counter is not equal to #N$04.
  $7408,$01 Restore the phase counter from the stack.
  $7409,$04 #REGix=#R$DADC.
  $740D,$05 Call #R$77B9 if the phase counter is not equal to #N$03.
  $7412,$01 Return.

c $7413 Handler: Room #N$0B
@ $7413 label=Handler_Room11
D $7413 Handles room #N$0B logic. The phase counter in #REGb controls which
. objects are initialised or updated on each pass.
R $7413 B Room phase counter (from *#R$5FB1)
  $7413,$01 Copy the phase counter into #REGa.
  $7414,$03 Return if the phase counter is less than #N$03.
  $7417,$04 #REGix=#R$DAD8.
  $741B,$01 Stash the phase counter on the stack.
  $741C,$05 Call #R$7439 if the phase counter is not equal to #N$05.
  $7421,$01 Restore the phase counter from the stack.
  $7422,$03 Return if the phase counter is equal to #N$03.
  $7425,$04 #REGix=#R$DADC.
  $7429,$01 Stash the phase counter on the stack.
  $742A,$03 Call #R$77B9.
  $742D,$01 Restore the phase counter from the stack.
  $742E,$03 Return if the phase counter is equal to #N$04.
  $7431,$04 #REGix=#R$DAD8.
  $7435,$03 Call #R$759A.
  $7438,$01 Return.

c $7439 Handler: Helicopter
@ $7439 label=Handler_Helicopter
D $7439 Controls the helicopter hazard movement and animation. Generates random
. direction changes and movement delays, moves the helicopter according to its current
. direction, and updates the animation frame. Used by all room handlers.
R $7439 IX Pointer to helicopter sprite data
N $7439 Set up the helicopter data pointer and check if respawning is needed.
  $7439,$04 Point #REGiy at #R$7508.
@ $743D label=Handler_Helicopter_Entry
  $743D,$07 Call #R$74A7 if *#R$5FBB is set to randomise the helicopter's
. position.
  $7444,$07 Jump to #R$74B9 if bit 7 of *#REGiy+#N$00 is set (helicopter is
. spawning/inactive).
N $744B Decrement the movement delay timer; if it hasn't expired, skip ahead
. to move the helicopter in its current direction.
  $744B,$03 Decrement the movement delay at *#REGiy+#N$01.
  $744E,$02 Jump to #R$7466 if the delay has not reached zero.
N $7450 Movement delay has expired; generate a new random direction and delay.
@ $7450 label=New_Random_Direction
  $7450,$03 Call #R$7930.
  $7453,$01 Stash the random number on the stack.
M $7454,$04 Mask and clear bit 0 to get an even direction value in the range
. #N$00-#N$06.
  $7454,$02,b$01 Keep only bits 0-2.
  $7458,$03 Write the result to *#REGiy+#N$00.
  $745B,$01 Restore the random number from the stack.
M $745C,$07 Rotate right three times, mask and set bit 0 to produce a delay of
. #N$01-#N$3F.
  $745F,$02,b$01 Keep only bits 0-5.
  $7461,$02,b$01 Set bit 0.
  $7463,$03 Write the result to *#REGiy+#N$01.
N $7466 Move the helicopter in its current direction.
@ $7466 label=Move_Helicopter
M $7466,$05 Fetch the current direction from *#REGiy+#N$00, mask with #N$07
. and double it to form a jump table index.
  $7469,$02,b$01 Keep only bits 0-2.
  $746C,$03 Write the direction index to *#R$6BC8(#N$6BC9).
  $746F,$03 Point #REGhl at #R$7507 (helicopter movement boundary data).
  $7472,$06 Load the helicopter's X position into #REGc and Y position into
. #REGb from *#REGix+#N$00 and *#REGix+#N$01.
  $7478,$03 Call #R$6BC8 to move the helicopter in the current direction.
  $747B,$02 Jump to #R$7450 if the move was invalid (carry set) and pick a new
. random direction.
N $747D Determine the facing direction based on the helicopter's position relative to
. Percy.
  $747D,$08 Jump to #R$748F if the helicopter's X position with Percy's previous
. X position is equal.
  $7485,$06 Set *#REGiy+#N$03 to #N$00 (facing left) if the helicopter is to the left
. of Percy; jump to #R$748F.
  $748B,$04 Set *#REGiy+#N$03 to #N$04 (facing right) if the helicopter is to the
. right of Percy.
N $748F Update the helicopter's animation frame.
@ $748F label=Update_Helicopter_Frame
M $748F,$06 Increment the animation counter at *#REGiy+#N$04, wrapping at
. #N$03 to cycle through four frames.
  $7493,$02,b$01 Keep only bits 0-1.
  $7495,$03 Write the result to *#REGiy+#N$04.
  $7498,$05 Calculate the sprite frame ID: add the immediate value (#N$2E) to
. the animation counter and the facing offset from *#REGiy+#N$03.
  $749D,$03 Write the sprite frame ID to *#REGix+#N$03.
  $74A0,$04 Set the sprite active flag at *#REGix+#N$02 to #N$01.
  $74A4,$03 Jump to #R$74D6.

c $74A7 Randomise Helicopter Position
@ $74A7 label=Randomise_Helicopter_Position
D $74A7 Generates a random position for the helicopter and validates it. Keeps
. generating new coordinates until a valid position is found, then clears the
. spawning flag.
R $74A7 IX Pointer to helicopter sprite data
R $74A7 IY Pointer to helicopter state data
@ $74A7 label=Randomise_Position_Loop
  $74A7,$08 Generate a random X coordinate in #REGc and a random Y coordinate
. in #REGb by calling #R$7930 twice.
  $74AF,$05 Call #R$6C0C and jump back to #R$74A7 if the position is invalid.
  $74B4,$04 Clear bit 7 of *#REGiy+#N$00 (mark the helicopter as active/no longer
. spawning).
  $74B8,$01 Return.

c $74B9 Animate Stunned Hazard
@ $74B9 label=Animate_Stunned_Hazard
D $74B9 Animates the stunned hazard sequence. Used by the helicopter, cat,
. paratrooper, canopy and other hazards when hit by Percy's egg. Increments
. the animation counter until it reaches #N$85, cycling through animation
. frames. Assigns a random colour attribute and plays a hit sound each frame.
R $74B9 IX Pointer to hazard sprite data
R $74B9 IY Pointer to hazard state data
  $74B9,$06 Return if the animation counter at *#REGiy+#N$00 has reached #N$85
. (animation complete).
  $74BF,$04 Increment the animation counter and write it back to
. *#REGiy+#N$00.
M $74C3,$05 Mask off bit 7, rotate right and add #N$36 to calculate the
. animation frame ID.
  $74C3,$02,b$01 Keep only bits 0-6.
  $74C8,$03 Write the frame ID to *#REGix+#N$03.
M $74CB,$05 Generate a random number and mask with #N$07 to produce a random
. colour attribute.
  $74CE,$02,b$01 Keep only bits 0-2.
  $74D0,$03 Write the colour attribute to *#REGix+#N$02.
  $74D3,$03 Jump to #R$6F7A.

c $74D6
c $74D6 Check Hazard Collision
@ $74D6 label=Check_Hazard_Collision
D $74D6 Checks if a hazard sprite has collided with Percy or Percy's egg. If the
. hazard hits Percy, the hit is recorded and a sound is played. If Percy has an
. active egg and the egg hits the hazard, the hazard is stunned, the egg is
. cancelled and points are awarded.
R $74D6 IX Pointer to the hazard sprite data
R $74D6 IY Pointer to the hazard state data
  $74D6,$02 Stash the hazard state pointer on the stack.
  $74D8,$04 Point #REGiy at #R$DAC0 (Percy's sprite data).
  $74DC,$03 Call #R$6C53 to check if the hazard collides with Percy.
  $74DF,$02 Restore the hazard state pointer from the stack.
  $74E1,$02 Jump to #R$74EA if there's been no collision with Percy.
N $74E3 The hazard has hit Percy.
@ $74E3 label=Hazard_Hit_Percy
  $74E3,$03 Write the collision result to *#R$5FA7.
  $74E6,$03 Call #R$6F7A.
  $74E9,$01 Return.
N $74EA No collision with Percy; check if Percy's egg is active and whether
. it hits the hazard.
@ $74EA label=Check_Egg_Hit
  $74EA,$05 Return if *#R$5FA9 is zero (no egg active).
  $74EF,$02 Stash the hazard state pointer on the stack.
  $74F1,$04 Point #REGiy at #R$DAE0.
  $74F5,$03 Call #R$6C85.
  $74F8,$02 Restore the hazard state pointer from the stack.
  $74FA,$01 Return if there's been no collision with the egg.
N $74FB The egg has hit the hazard; stun it and award points.
@ $74FB label=Egg_Stuns_Hazard
  $74FB,$04 Write #N$80 to *#REGiy+#N$00 to set bit 7 (mark the hazard as
. stunned).
@ $74FF label=Stun_Hazard_And_Score
  $74FF,$03 Call #R$71E1.
  $7502,$05 Jump to #R$67B2 to add #N$14 points to the score.

g $7507 Helicopter Movement Boundary
@ $7507 label=Helicopter_MovementBoundary
D $7507 Single byte used as movement boundary data; read at #R$746F.
B $7507,$01

g $7508 Helicopter State Data
@ $7508 label=Helicopter_State_Data_1
D $7508 State variables for the helicopter hazard. Two five-byte state blocks:
. #R$7508 (first) and #R$750D (second).
.
. Referenced by room handlers at #R$723F and #R$730E.
N $7508 Helicopter #1
B $7508,$01 Direction / active flag (bit 7 set = spawning/inactive).
B $7509,$01 Movement delay.
B $750A,$01 Unused.
B $750B,$01 Facing (#N$00=left, #N$04=right).
B $750C,$01 Animation counter.
N $750D Helicopter #2
@ $750D label=Helicopter_State_Data_2
B $750D,$01 Direction / active flag (bit 7 set = spawning/inactive).
B $750E,$01 Movement delay.
B $750F,$01 Unused.
B $7510,$01 Facing (#N$00=left, #N$04=right).
B $7511,$01 Animation counter.

c $7512 Handler: Cat
@ $7512 label=Handler_Cat
D $7512 Controls the cat hazard that patrols horizontally along a platform. The
. cat bounces between left and right boundaries, animates through walking frames,
. and checks for collision with Percy and Percy's egg. The cat parameters vary
. per room, looked up from state data indexed by the current room number.
R $7512 IX Pointer to the cat sprite data
N $7512 Set up the cat state pointer and movement parameters.
  $7512,$04 Point #REGiy at #R$7AC8.
  $7516,$03 Point #REGhl at #R$7589.
N $7519 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$39 | #UDGS$02,$02(udg45627-56x4)(
.   #UDG($B23B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $7519,$03 Set #REGb=#N$07 (sprite active value) and #REGc=#R$B23B(#N$39)
. (base cat frame).
@ $751C label=Calculate_Hazard_Room_Offset
  $751C,$0B Calculate the state data offset: (*#R$5FC5 - #N$01) * #N$04, and
. add to #REGiy to point at this room's cat state entry.
@ $7527 label=Cat_Entry
  $7527,$07 Call #R$7574 if *#R$5FBB is set to reset the cat position.
  $752E,$06 Jump to #R$74B9 if bit 7 of *#REGiy+#N$00 is set (cat is stunned
. by egg).
N $7534 Determine movement direction and update X position.
  $7534,$03 Load the direction byte from *#REGhl; test bit 7.
  $7537,$01 Advance #REGhl to the step size byte.
  $7538,$02 Jump to #R$754E if bit 7 is set (moving left).
N $753A Moving right: add the step size to the X position.
  $753A,$03 Load the cat X position from *#REGix+#N$00.
  $753D,$01 Add the step size from *#REGhl.
  $753E,$03 Compare with the right boundary at *#REGiy+#N$03.
  $7541,$01 Move #REGhl back to the direction byte.
  $7542,$02 Jump to #R$7549 if the X position hasn't reached the right boundary.
  $7544,$03 Write #N$80 to *#REGhl to switch direction to moving left.
  $7547,$02 Jump to #R$755F.
@ $7549 label=Cat_Update_X_Right
  $7549,$03 Write the updated X position to *#REGix+#N$00.
  $754C,$02 Jump to #R$755F.
N $754E Moving left: subtract the step size from the X position.
@ $754E label=Cat_Moving_Left
  $754E,$03 Load the cat X position from *#REGix+#N$00.
  $7551,$01 Subtract the step size from *#REGhl.
  $7552,$03 Compare with the left boundary at *#REGiy+#N$02.
  $7555,$01 Move #REGhl back to the direction byte.
  $7556,$02 Jump to #R$755C if the X position hasn't reached the left boundary.
  $7558,$02 Write #N$00 to *#REGhl to switch direction to moving right.
  $755A,$02 Jump to #R$755F.
@ $755C label=Cat_Update_X_Left
  $755C,$03 Write the updated X position to *#REGix+#N$00.
N $755F Update the cat's walking animation frame and check for collisions.
@ $755F label=Update_Cat_Frame
  $755F,$01 Move #REGhl back to the animation counter.
M $7560,$05 Increment the animation counter, wrapping at #N$07.
  $7562,$02,b$01 Keep only bits 0-2.
  $7565,$01 Divide by two.
  $7566,$01 Add the base frame from #REGc.
  $7567,$01 Advance #REGhl to the direction byte.
  $7568,$04 Skip to #R$756E if bit 7 of *#REGhl is unset (moving right).
  $756C,$02 Add #N$04 for the left-facing frame set.
@ $756E label=Set_Hazard_Frame
  $756E,$03 Write the sprite frame to *#REGix+#N$03.
  $7571,$03 Jump to #R$74D6 to check for collision with Percy or egg.

c $7574 Reset Cat Position
@ $7574 label=Reset_Cat_Position
D $7574 Resets the cat to its starting position and clears the stunned flag.
R $7574 B Sprite active value
  $7574,$06 Set the Y position from *#REGiy+#N$01.
  $757A,$06 Set the X position from *#REGiy+#N$02.
  $7580,$04 Write #N$00 to *#REGiy+#N$00 (clear the stunned flag).
  $7584,$03 Set the sprite active value from #REGb.
  $7587,$01 Return.

g $7588 Cat Direction Data
@ $7588 label=Cat_Animation_Counter
D $7588 Animation counter, direction flag and step size for the cat.
B $7588,$01
@ $7589 label=Cat_Direction_Flag
B $7589,$01
@ $758A label=Cat_Step_Size
B $758A,$01

c $758B Handler: Dog
@ $758B label=Handler_Dog
D $758B Controls the dog hazard that patrols horizontally along a platform. Uses
. the same movement logic as the cat but with different state data, boundaries
. and sprite frames.
R $758B IX Pointer to the dog sprite data
  $758B,$04 Point #REGiy at #R$7AE8.
N $758F #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$41 | #UDGS$02,$02(udg45883-56x4)(
.   #UDG($B33B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $758F,$03 Set #REGb=#N$00 (sprite active value) and #REGc=#R$B33B(#N$41)
. (base dog frame).
  $7592,$03 Point #REGhl at #R$7598.
  $7595,$02 Jump to #R$751C.

g $7597 Dog Direction Data
@ $7597 label=Dog_Animation_Counter
D $7597 Animation counter, direction flag and step size for the dog.
B $7597,$01
@ $7598 label=Dog_Direction_Flag
B $7598,$01
@ $7599 label=Dog_Step_Size
B $7599,$01

c $759A Handler: UFO
@ $759A label=Handler_UFO
D $759A Controls the UFO hazard. The UFO wanders randomly around the screen and
. attempts to abduct Percy. When it catches Percy, it teleports him to the UFO's
. position, plays a tractor beam sound effect, then drops him downward. The UFO
. cannot be stunned by Percy's egg, but a hit will cancel the egg.
R $759A IX Pointer to the UFO sprite data
N $759A Check for respawn.
  $759A,$07 Call #R$7628 if *#R$5FBB is set to reset the UFO.
N $75A1 Decrement the movement delay timer.
  $75A1,$04 Decrement *#R$7679.
  $75A5,$02 Jump to #R$75C9 if *#R$7679 hasn't reached zero.
N $75A7 Movement delay expired; generate new random direction and delay.
@ $75A7 label=New_UFO_Direction
  $75A7,$03 Call #R$7930 to generate a random number.
  $75AA,$03 Point #REGhl at #R$7679 (UFO movement delay).
  $75AD,$01 Stash the random value on the stack.
  $75AE,$02,b$01 Keep only bits 0-2.
  $75B0,$01 Increment #REGhl by one to #R$767A.
  $75B1,$01 Write #REGa to *#REGhl to set the new direction.
  $75B2,$01 Move #REGhl back to #R$7679.
  $75B3,$01 Restore the random value from the stack.
  $75B4,$03 Rotate the random value right three times.
  $75B7,$02,b$01 Keep only bits 0-4.
  $75B9,$02,b$01 Set bit 2 to produce a delay.
  $75BB,$01 Write #REGa to *#R$7679.
  $75BC,$01 Stash the UFO state data pointer on the stack.
N $75BD Set a random value for the UFO speed between #N$01-#N$03.
@ $75BD label=Generate_UFO_Speed
  $75BD,$03 Call #R$7930.
  $75C0,$02,b$01 Keep only bits 0-1 to limit the random number to between
. #N$00-#N$03.
  $75C2,$03 Jump back to #R$75BD to try again if the speed is zero.
  $75C5,$03 Write the random speed to *#R$767B.
  $75C8,$01 Restore the UFO state data pointer from the stack.
N $75C9 Move the UFO in its current direction.
@ $75C9 label=Move_UFO
M $75C9,$05 Load the direction from *#REGhl+#N$01, mask and double to form a
. jump table index.
  $75CB,$02,b$01 Keep only bits 0-2.
  $75CE,$03 Write the direction index to *#R$6BC8(#N$6BC9).
  $75D1,$03 Point #REGhl at #R$767B.
  $75D4,$06 Load the UFO's X position into #REGc and Y position into #REGb from
. *#REGix+#N$00 and *#REGix+#N$01.
  $75DA,$03 Call #R$6BA0 to move the UFO in the current direction.
  $75DD,$02 Jump to #R$75A7 if the move was invalid (carry set) and pick a new
. direction.
N $75DF Update the UFO's animation frame, wrapping at #N$03.
  $75DF,$03 Point #REGhl at #R$767C.
  $75E2,$06 Increment the animation counter, skip to #R$75E9 if it's not yet at
. frame #N$03.
  $75E8,$01 Reset the frame back to #N$00.
@ $75E9 label=Set_UFO_Frame
  $75E9,$01 Write the UFO frame to *#R$767C.
N $75EA #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$4F | #UDGS$02,$02(udg46331-56x4)(
.   #UDG($B4FB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $75EA,$05 Add #R$B4FB(#N$4F) as the base UFO frame and write it to
. *#REGix+#N$03.
M $75EF,$09 Toggle the sprite flicker flag at *#R$767D between #N$00 and
. #N$01.
  $75F3,$02,b$01 Keep only bit 0.
  $75F8,$04 Write #N$01 to *#REGix+#N$02 (sprite active value).
N $75FC Check if the UFO has recently abducted Percy.
  $75FC,$06 Jump to #R$7608 if *#R$767E is zero.
  $7602,$04 Decrement the abduction timer and write it back to *#R$767E.
  $7606,$02 Jump to #R$7633.
N $7608 Check for collision with Percy.
@ $7608 label=Check_UFO_Percy
  $7608,$04 Point #REGiy at #R$DAC0 (Percy sprite data).
  $760C,$03 Call #R$6C53 to check for collision with Percy.
  $760F,$02 Jump to #R$7617 if carry is set (no collision).
N $7611 UFO has caught Percy; set the abduction timer.
  $7611,$05 Set #N$64 as the *#R$767E value.
  $7616,$01 Return.
N $7617 No collision with Percy; check if Percy's egg hits the UFO.
@ $7617 label=Check_UFO_Egg
  $7617,$05 Return if *#R$5FA9 is unset.
  $761C,$04 Point #REGiy at #R$DAE0 (egg sprite data).
  $7620,$03 Call #R$6C85 to check for egg collision with the UFO.
  $7623,$01 Return if carry is set (no collision).
  $7624,$03 Call #R$71E1.
  $7627,$01 Return.

c $7628 Reset UFO Position
@ $7628 label=Reset_UFO_Position
D $7628 Resets the UFO to a random position and clears the abduction timer.
R $7628 IX Pointer to UFO sprite data
  $7628,$04 Point #REGiy at #N($0000,$04,$04).
  $762C,$04 Write #N$00 to clear *#R$767E.
  $7630,$03 Jump to #R$74A7 to generate a random valid position.

c $7633 UFO Abduct Percy
@ $7633 label=UFO_Abduct_Percy
D $7633 Handles the UFO's abduction of Percy. Teleports Percy to the UFO's
. position while playing a tractor beam sound effect, then on the final frame
. drops Percy downward.
R $7633 IX Pointer to UFO sprite data
  $7633,$04 Jump to #R$7669 if the abduction timer is equal to #N$01 (final
. frame of abduction).
N $7637 Play the tractor beam sound effect.
  $7637,$03 Point #REGhl at #R$767F (tractor beam sound pitch).
  $763A,$02 Load the pitch into #REGe and #REGc.
@ $763C label=Tractor_Beam_SoundStep_Loop
  $763C,$01 Copy to #REGb.
  $763D,$02 Set initial speaker state to #N$01.
@ $763F label=Tractor_Beam_Sound_Inner
  $763F,$03 Action a delay loop.
M $7642,$04 Toggle the speaker bits and output to the speaker port.
  $7642,$02,b$01 Flip bits 3-4.
  $7646,$03 Decrement #REGc and loop back to #R$763C until the sound step is
. complete.
M $7649,$04 Complement and mask the pitch value.
  $764B,$02,b$01 Keep only bits 0-5.
  $764D,$01 Write back to *#REGhl.
N $764E Teleport Percy to the UFO's position.
  $764E,$06 Copy the UFO's X position to Percy's X at *#R$DAC0.
  $7654,$08 Copy the UFO's Y position plus #N$0A to Percy's Y at *#R$DAC1.
  $765C,$06 Copy the UFO's sprite active value to Percy's at *#R$DAC2.
  $7662,$04 Write #N$00 to clear *#R$5FA7.
  $7666,$03 Jump to #R$71E1.
N $7669 Final frame of abduction; drop Percy downward.
@ $7669 label=UFO_Drop_Percy
  $7669,$08 Add #N$14 to Percy's Y position at *#R$DAC1.
  $7671,$03 Write the result to *#R$5FA7 (set collision flag).
  $7674,$04 Write #N$00 to clear *#R$767E.
  $7678,$01 Return.

g $7679 UFO State Data
@ $7679 label=UFO_Movement_Delay
D $7679 State variables for the UFO hazard.
B $7679,$01
@ $767A label=UFO_Direction
B $767A,$01
@ $767B label=UFO_Speed
B $767B,$01
@ $767C label=UFO_Animation_Counter
B $767C,$01
@ $767D label=UFO_Flicker_Flag
B $767D,$01
@ $767E label=UFO_Abduction_Timer
B $767E,$01
@ $767F label=UFO_Tractor_Beam_Pitch
B $767F,$01

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

c $768C Handle Plane
@ $768C label=Handle_Plane
D $768C Controls the plane hazard. The plane flies horizontally across the screen
. and can drop a bomb on Percy when directly above. The plane has two flight
. directions and its speed varies by room. On room #N$03 the boundaries are
. adjusted. When the plane reaches the screen edge it deactivates and waits for
. a random trigger to respawn from the opposite side.
R $768C IX Pointer to the plane sprite data
N $768C Set up the plane state pointer and room-specific parameters.
  $768C,$04 Point #REGiy at #R$77AF.
  $7690,$02 Set the left boundary to #N$04 in #REGc.
  $7692,$02 Set the right boundary to #N$38 in #REGb.
  $7694,$07 Jump to #R$769E if *#R$5FC5 is not equal to #N$03.
  $769B,$02 Set the left boundary to #N$40 in #REGc.
  $769D,$01 Copy to #REGb (both boundaries are #N$40 on room #N$03).
@ $769E label=Plane_Check_Respawn
  $769E,$07 Jump to #R$76E5 if *#R$5FBB is set.
  $76A5,$06 Jump to #R$76DE if *#REGiy+#N$02 (plane active flag) is zero
. (waiting to spawn).
  $76AB,$07 Jump to #R$74B9 if bit 7 of *#REGiy+#N$00 is set (plane is stunned
. by egg).
N $76B2 Plane is active; move it horizontally based on flight direction.
  $76B2,$03 Point #REGhl at #R$77B3.
  $76B5,$03 Fetch the plane X position from *#REGix+#N$00.
  $76B8,$04 Test bit 7 of *#REGiy+#N$01 (flight direction); jump to #R$76C8
. if set (flying left).
N $76BE Flying right: add the speed to the X position.
  $76BE,$01 Add the speed from *#REGhl.
  $76BF,$04 Jump to #R$770D if the X position has reached #N$EE (off-screen
. right).
  $76C3,$03 Write the updated X position to *#REGix+#N$00.
  $76C6,$02 Jump to #R$76CF.
N $76C8 Flying left: subtract the speed from the X position.
@ $76C8 label=Plane_Flying_Left
  $76C8,$01 Subtract the speed from *#REGhl.
  $76C9,$03 Jump to #R$770D if the X position has dropped below #REGc (off-screen
. left).
  $76CC,$03 Write the updated X position to *#REGix+#N$00.
N $76CF Set the plane's sprite frame based on flight direction.
N $76CF #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$4D | #UDGS$02,$02(udg46267-56x4)(
.   #UDG($B4BB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
@ $76CF label=Set_Plane_Frame
  $76CF,$02 Set #REGa to #R$B4BB(#N$4D) (plane flying left frame).
  $76D1,$06 Jump to #R$76D8 if bit 7 of *#REGiy+#N$01 is set (flying left).
N $76D7 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$4E | #UDGS$02,$02(udg46299-56x4)(
.   #UDG($B4DB+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $76D7,$01 Increment to #R$B4DB(#N$4E) (plane flying right frame).
@ $76D8 label=Store_Plane_Frame
  $76D8,$03 Write the frame to *#REGix+#N$03.
  $76DB,$03 Jump to #R$74D6 to check for collision with Percy or egg.
N $76DE Plane is inactive; randomly trigger a respawn.
@ $76DE label=Plane_Wait_To_Spawn
M $76DE,$04 Use the Memory Refresh Register masked as a random value.
  $76E0,$02,b$01 Keep only bits 0-6.
  $76E2,$03 Return if the value is not equal to #N$7F (wait for random trigger).
N $76E5 Spawn the plane: reset all state and pick a random starting side.
@ $76E5 label=Spawn_Plane
  $76E5,$04 Set bit 7 of *#REGiy+#N$02 (mark plane as active).
  $76E9,$16 Write #N$00 to; #LIST
. { *#R$77AE }
. { *#REGiy+#N$03 (bomb active flag) }
. { *#REGiy+#N$01 (flight direction) }
. { *#REGix+#N$00 (X position) }
. { *#REGix+#N$02 (sprite active flag) }
. { *#REGix+#N$01 (Y position) }
. { *#REGiy+#N$00 (stunned flag) }
. LIST#
M $76FF,$04 Use the Memory Refresh Register masked to randomly pick a starting
. side.
  $7701,$02,b$01 Keep only bit 0.
  $7703,$01 Return if bit 0 is not set (spawn from the left at X=#N$00).
  $7704,$04 Write #N$EE to *#REGix+#N$00 (spawn from the right).
  $7708,$04 Set bit 7 of *#REGiy+#N$01 (set flight direction to left).
  $770C,$01 Return.
N $770D Plane has flown off-screen; deactivate and return to waiting state.
@ $770D label=Plane_Off_Screen
  $770D,$04 Write #N$00 to *#REGiy+#N$02 (mark plane as inactive).
  $7711,$02 Jump to #R$76DE.

c $7713 Handle Plane Bomb
@ $7713 label=Handle_Plane_Bomb
D $7713 Manages the plane's bomb. When the plane is above Percy, a bomb is
. dropped which falls downward. When the bomb hits or the explosion timer
. expires, Percy is damaged. The explosion cycles through animation frames
. before clearing.
N $7713 Check the bomb explosion counter.
  $7713,$03 Fetch the bomb explosion counter from *#R$77AE.
  $7716,$03 Jump to #R$774D if the counter is non-zero (explosion in progress).
  $7719,$06 Jump to #R$776F if bit 7 of *#REGiy+#N$03 is not set (no bomb
. active).
N $771F Bomb is falling; update its position.
  $771F,$04 Point #REGix at #R$DAF0 (bomb sprite data).
  $7723,$04 Set the bomb sprite frame to #N$14.
  $7727,$05 Add #N$03 to the bomb Y position.
  $772C,$04 Jump to #R$776A if the Y position has reached #N$A0 (hit the
. ground).
  $7730,$03 Write the updated Y position to *#REGix+#N$01.
  $7733,$02 Stash #REGiy on the stack.
  $7735,$04 Point #REGix at #R$DAC0 (Percy sprite data).
  $7739,$04 Point #REGiy at #R$DAF0 (bomb sprite data).
  $773D,$03 Call #R$6C85 to check for collision between the bomb and Percy.
  $7740,$02 Restore #REGiy from the stack.
  $7742,$01 Return if there was no collision (carry set).
  $7743,$04 Write #N$00 to *#REGiy+#N$03 (deactivate the bomb).
  $7747,$05 Write #N$07 to *#R$77AE (start the explosion counter).
  $774C,$01 Return.
N $774D Bomb explosion animation is in progress.
@ $774D label=Bomb_Explosion
  $774D,$01 Decrement the explosion counter.
  $774E,$03 Write the updated counter to *#R$77AE.
  $7751,$03 Jump to #R$7764 if the counter has reached zero (explosion
. finished).
  $7754,$03 Divide by two and add #N$36 to select the explosion animation
. frame.
  $7757,$03 Write the frame to *#R$DAC3 (Percy's sprite frame, showing the
. explosion on Percy).
M $775A,$04 Use the Memory Refresh Register masked with #N$07 as a random
. flicker value.
  $775C,$02,b$01 Keep only bits 0-2.
  $775E,$03 Write to *#R$DAC2 (Percy's sprite active flag, for flicker effect).
  $7761,$03 Jump to #R$6F7A.
N $7764 Explosion complete; register the hit on Percy.
@ $7764 label=Bomb_Explosion_Done
  $7764,$05 Write #N$FF to *#R$5FA7 (set collision flag to damage Percy).
  $7769,$01 Return.
N $776A Bomb hit the ground without hitting Percy; deactivate the bomb.
@ $776A label=Bomb_Hit_Ground
  $776A,$04 Write #N$00 to *#REGiy+#N$03 (deactivate the bomb).
  $776E,$01 Return.
N $776F No bomb active; check if the plane should drop one.
@ $776F label=Check_Bomb_Drop
M $776F,$04 Use the Memory Refresh Register masked for a random check.
  $7771,$02,b$01 Keep only bits 0.
  $7773,$01 Return if the random bit is not set (don't drop this frame).
  $7774,$08 Check if Percy's Y position plus #N$0A is greater than or equal to
. the plane's Y position.
  $777C,$01 Return if Percy is above the plane (carry set).
M $777D,$06 Mask Percy's X position and store in #REGb.
  $7780,$02,b$01 Keep only bits 2-7.
M $7783,$05 Mask the plane's X position with #N$FC and compare with #REGb.
  $7786,$02,b$01 Keep only bits 2-7.
  $7788,$02 Return if the X positions don't match (plane not above Percy).
  $778A,$04 Return if bit 7 of *#REGiy+#N$02 is not set (plane not active).
  $778F,$04 Return if bit 7 of *#REGiy+#N$00 is set (plane is stunned).
N $7794 Drop the bomb: set the bomb sprite position and activate it.
  $7794,$05 Set the bomb Y position to the plane's Y plus #N$0A.
  $7799,$03 Write to *#R$DAF1 (bomb Y position).
  $779C,$03 Copy the plane's X position to *#R$DAF0 (bomb X position).
  $77A2,$02 Write #N$FF to *#R$DAF2 (bomb sprite active flag).
  $77A7,$04 Set bit 7 of *#REGiy+#N$03 (mark bomb as active).
  $77AB,$03 Jump to #R$6F7A.

g $77AE Bomb Explosion Counter
@ $77AE label=Bomb_Explosion_Counter
D $77AE Countdown for the bomb explosion animation. When non-zero, the explosion
. frames are displayed on Percy.
B $77AE,$01

g $77AF Plane State Data
@ $77AF label=Plane_State_Data
D $77AF State variables for the plane hazard.
B $77AF,$01 Stunned flag (bit 7 set = stunned by egg).
B $77B0,$01 Flight direction (bit 7 set = flying left).
B $77B1,$01 Active flag (bit 7 set = plane is on screen).
B $77B2,$01 Bomb active flag (bit 7 set = bomb is falling).

g $77B3 Plane Speed
@ $77B3 label=Plane_Speed
D $77B3 The horizontal speed of the plane in pixels per frame.
B $77B3,$01

u $77B4 Initialise Parachute X Position
@ $77B4 label=Initialise_Parachute_XPosition
C $77B4,$04 Point #REGiy at #R$7B04.
C $77B8,$01 Return.

c $77B9 Handler: Balloon
@ $77B9 label=Handler_Balloon
D $77B9 Controls the balloon hazard. The balloon floats horizontally across the
. screen, randomly changing direction at the edges and occasionally bobbing up
. and down. When hit by Percy's egg, it pops through a deflating animation
. before respawning.
R $77B9 IX Pointer to the balloon sprite data
  $77B9,$07 Jump to #R$784F if *#R$5FBB is set.
  $77C0,$03 Point #REGhl at #R$7891.
  $77C3,$07 Jump to #R$7855 if *#R$7892 is set.
N $77CA Balloon is active; randomly toggle the float direction.
M $77CA,$04 Use the Memory Refresh Register masked to a number between
. #N$00-#N$80.
  $77CC,$02,b$01 Keep only bits 0-6.
  $77CE,$04 Jump to #R$77D5 if the result is not equal to #N$7F.
  $77D2,$03 Toggle the direction flag at *#REGhl by complementing and writing
. back.
N $77D5 Move the balloon horizontally based on its direction.
@ $77D5 label=Move_Balloon
  $77D5,$04 Jump to #R$77E7 if the direction flag is non-zero (set to floating
. left).
N $77D9 Floating right: increment X position.
  $77D9,$03 Fetch the balloon X position from *#REGix+#N$00.
  $77DC,$02 Add #N$01.
  $77DE,$04 Jump to #R$7847 if the balloon X position has reached #N$EE
. (off-screen right; reverse direction).
  $77E2,$03 Write the updated X position to *#REGix+#N$00.
  $77E5,$02 Jump to #R$77F3.
N $77E7 Floating left: decrement X position.
@ $77E7 label=Balloon_Float_Left
  $77E7,$03 Fetch the balloon X position from *#REGix+#N$00.
  $77EA,$02 Subtract #N$01.
  $77EC,$04 Jump to #R$784B if the balloon X position has dropped below #N$04
. (off-screen left; reverse direction).
  $77F0,$03 Write the updated X position to *#REGix+#N$00.
N $77F3 Randomly adjust the balloon's altitude to create a bobbing effect.
@ $77F3 label=Adjust_Balloon_Altitude
  $77F3,$03 Call #R$7930.
  $77F6,$02,b$01 Keep only bits 0-1.
  $77F8,$02 Jump to #R$7821 if not equal to #N$03 (only adjust altitude on a
. 1-in-4 chance).
  $77FC,$03 Load #REGb with the Memory Refresh Register.
  $77FF,$04 Jump to #R$7812 if bit 6 is set (move upward).
N $7803 Bob downward.
M $7803,$03 Mask #REGb to get a step of #N$00 or #N$01.
  $7804,$02,b$01 Keep only bit 0.
  $7806,$03 Add to the balloon Y position.
  $7809,$04 Jump to #R$7821 if the balloon Y position has reached #N$70
. (maximum altitude, don't go lower).
  $780D,$03 Write the updated balloon Y position back to *#REGix+#N$01.
  $7810,$02 Jump to #R$7821.
N $7812 Bob upward.
@ $7812 label=Balloon_Bob_Up
M $7812,$04 Mask #REGb to get a step of #N$00 or #N$01.
  $7813,$02,b$01 Keep only bit 0.
  $7816,$03 Fetch the balloon Y position from *#REGix+#N$01.
  $7819,$01 Subtract the step.
  $781A,$04 Jump to #R$7821 if the balloon Y position has dropped below #N$18
. (minimum altitude, don't go higher).
  $781E,$03 Write the updated balloon Y position back to *#REGix+#N$01.
N $7821 Set the balloon frame and check for collisions.
N $7821 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$49 | #UDGS$02,$02(udg46139-56x4)(
.   #UDG($B43B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
@ $7821 label=Set_Balloon_Frame
  $7821,$04 Write #R$B43B(#N$49) to *#REGix+#N$03 (balloon frame).
  $7825,$04 Point #REGiy at #R$DAC0 (Percy sprite data).
  $7829,$03 Call #R$6C53 to check for collision with Percy.
  $782C,$02 Jump to #R$7831 if there's been no collision.
  $782E,$03 Jump to #R$74E3 to register the hit on Percy.
N $7831 No collision with Percy; check if Percy's egg hits the balloon.
@ $7831 label=Check_Balloon_Egg
  $7831,$05 Return if *#R$5FA9 is unset.
  $7836,$04 Point #REGiy at #R$DAE0 (egg sprite data).
  $783A,$03 Call #R$6C85 to check for egg collision with the balloon.
  $783D,$01 Return if there's been no collision with the balloon.
  $783E,$05 Write #N$01 to start/ activate *#R$7892.
  $7843,$03 Jump to #R$74FF to stun the balloon and award points.
  $7846,$01 Return.
N $7847 Balloon reached the right edge; reverse direction to float left.
@ $7847 label=Balloon_Reverse_Left
  $7847,$02 Write #N$FF to *#REGhl (set direction to floating left).
  $7849,$02 Jump to #R$7821.
N $784B Balloon reached the left edge; reverse direction to float right.
@ $784B label=Balloon_Reverse_Right
  $784B,$02 Write #N$00 to *#REGhl (set direction to floating right).
  $784D,$02 Jump to #R$7821.
N $784F Respawn the balloon after Percy respawns.
@ $784F label=Respawn_Balloon
  $784F,$05 Write #N$B9 to *#R$7892 (set a long respawn delay).
  $7854,$01 Return.
N $7855 Balloon popping animation is in progress.
@ $7855 label=Balloon_Popping
  $7855,$03 Point #REGhl at #R$7892.
  $7858,$01 Fetch the current counter value.
  $7859,$04 Jump to #R$7870 if the counter is #N$04 or more (still in the
. delay phase).
N $785D Popping animation phase: cycle through deflating frames.
N $785D #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$4A | #UDGS$02,$02(udg46171-56x4)(
.   #UDG($B45B+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. { #N$4B | #UDGS$02,$02(udg46203-56x4)(
.   #UDG($B47B+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. { #N$4C | #UDGS$02,$02(udg46235-56x4)(
.   #UDG($B49B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $785D,$02 Increment the counter and write back.
  $785F,$02 Add #N$48 to calculate the deflating frame.
  $7861,$03 Write the frame to *#REGix+#N$03.
  $7864,$03 Call #R$7930.
  $7867,$02,b$01 Mask for a random flicker value.
  $7869,$03 Write to *#REGix+#N$02 (sprite active flag, for flicker).
  $786C,$03 Call #R$6F7A.
  $786F,$01 Return.
N $7870 Respawn delay phase: wait until the counter reaches #N$C8 before
. respawning.
@ $7870 label=Balloon_Respawn_Delay
  $7870,$02 Increment the counter and write back.
  $7872,$03 Return if the counter has not reached #N$C8 (still waiting).
N $7875 Respawn the balloon at a random horizontal position.
  $7875,$04 Write #N$38 to *#REGix+#N$01 (reset Y position).
  $7879,$04 Write #N$07 to *#REGix+#N$02 (reset sprite active flag).
  $787D,$03 Point #REGhl at #R$7892.
  $7880,$02 Write #N$00 to *#REGhl (clear the counter).
  $7882,$04 Write #N$EE to *#REGix+#N$00 (spawn from the right).
  $7886,$03 Call #R$7930.
  $7889,$03 Return if bit 0 is not set (50% chance to spawn from the right).
  $788C,$04 Write #N$04 to *#REGix+#N$00 (spawn from the left instead).
  $7890,$01 Return.

g $7891 Balloon Direction Flag
@ $7891 label=Balloon_Direction_Flag
D $7891 Direction flag for the balloon. #N$00 = floating right, non-zero =
. floating left.
B $7891,$01

g $7892 Balloon Pop Counter
@ $7892 label=Balloon_Pop_Counter
D $7892 Counter for the balloon popping and respawn sequence. Values #N$01 to
. #N$03 show deflating frames, #N$04 to #N$C7 are the respawn delay, and
. #N$C8 triggers the respawn.
B $7892,$01

c $7893 Handler: Walking Paratrooper
@ $7893 label=Handler_Walking_Paratrooper
D $7893 Controls the paratrooper after landing. The paratrooper walks left and
. right along a platform, and will leap upward to try to catch Percy if he flies
. directly overhead. The paratrooper jumps up by #N$02 pixels per frame to a
. maximum height of #N$10, then drops back down to his platform. Walking speed
. and boundaries vary per room.
R $7893 IX Pointer to the paratrooper sprite data
N $7893 Set up the paratrooper state pointer and movement parameters.
  $7893,$04 Point #REGiy at #R$7B0D (paratrooper state data).
  $7897,$03 Point #REGhl at #R$7928 (per-room walking speed table).
  $789A,$09 Fetch the current room from *#R$5FC5, decrement to form a zero-based
. index and load the walking speed for this room into #REGb.
  $78A3,$03 Point #REGhl at #R$7925 (paratrooper movement boundary data).
N $78A6 #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$53 | #UDGS$02,$02(udg46459-56x4)(
.   #UDG($B57B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $78A6,$02 Set the base sprite frame in #REGc to #R$B57B(#N$53) (paratrooper
. walking right).
  $78A8,$0B Fetch the current room from *#R$5FC5, decrement and multiply by
. #N$04 to index into the state data; add offset to #REGiy.
N $78B3 Check if the paratrooper needs to reset after Percy respawns.
  $78B3,$06 Skip to #R$78BD if *#R$5FBB is unset.
  $78B9,$04 Write #N$00 to reset *#R$7927 (set the leap state to idle).
N $78BD Check the current leap state to determine behaviour.
@ $78BD label=Check_Paratrooper_Leap_State
  $78BD,$06 Jump to #R$78E1 if *#R$7927 (leap state) is non-zero (already
. leaping).
N $78C3 Paratrooper is idle; check if Percy is flying directly overhead to
. trigger a leap.
M $78C3,$0C Compare Percy's X position against the paratrooper's X position.
  $78C6,$02,b$01 Keep only bits 2-7.
  $78CC,$02,b$01 Keep only bits 2-7.
  $78CF,$03 Jump to #R$7527 if they don't match.
  $78D2,$0E Jump to #R$7527 if Percy's Y position is less than #N$28 (too high
. above) or greater than or equal to the paratrooper's Y position (Percy is
. not above the paratrooper).
  $78E0,$01 Set #REGa to #N$00 (begin new leap).
N $78E1 Process the leap movement based on the current state.
@ $78E1 label=Process_Paratrooper_Leap
  $78E1,$04 Jump to #R$78FC if bit 7 of the leap state is set (paratrooper is
. descending back down).
N $78E5 Paratrooper is leaping upward.
  $78E5,$02 Add #N$02 to the leap state.
  $78E7,$04 Skip to #R$78EF if the leap state is still less than the maximum
. height (#N$10).
  $78EB,$04 Else the leap state has reached #N$10 (maximum height), set bit 7
. to begin descending and jump to #R$7917.
@ $78EF label=Continue_Paratrooper_Leap
  $78EF,$03 Write the updated leap state to *#R$7927.
  $78F2,$08 Calculate the paratrooper's new Y position by subtracting the leap
. height from the platform Y position at *#REGiy+#N$01; write to
. *#REGix+#N$01.
  $78FA,$02 Jump to #R$791A.
N $78FC Paratrooper is descending back to his platform.
@ $78FC label=Paratrooper_Descending
  $78FC,$01 Copy the leap state into #REGe.
  $78FD,$02,b$01 Keep only bits 0-6.
  $78FF,$01 Decrease the descent counter by one.
  $7900,$02 Jump to #R$7911 if the descent counter has reached zero (back on platform).
  $7902,$08 Calculate the paratrooper's new Y position by subtracting the
. remaining height from the platform Y position; write to *#REGix+#N$01.
  $790A,$05 Decrement the leap state and write it back to *#R$7927.
  $790F,$02 Jump to #R$791A.
N $7911 Leap is complete; reset to idle.
@ $7911 label=Paratrooper_Leap_Complete
  $7911,$04 Write #N$00 to *#R$7927 (return to idle state).
  $7915,$02 Jump to #R$791A.
@ $7917 label=Store_Paratrooper_Leap_State
  $7917,$03 Write the leap state to *#R$7927.
N $791A Resume the paratrooper's walking animation or handle stunned state.
@ $791A label=Paratrooper_Walk_Or_Stunned
  $791A,$07 Jump to #R$74B9 if bit 7 of *#REGiy+#N$00 is set (paratrooper is
. stunned by egg).
  $7921,$03 Jump to #R$755F to update the walking animation frame and check for
. collisions.

g $7924 Paratrooper Data
@ $7924 label=Paratrooper_Animation_Counter
D $7924 Animation counter, direction flag and boundary data for the walking
. paratrooper.
B $7924,$01
@ $7925 label=Paratrooper_Direction_Flag
B $7925,$01
@ $7926 label=Paratrooper_Step_Size
B $7926,$01
@ $7927 label=Paratrooper_Leap_State
B $7927,$01

g $7928 Table: Paratrooper Walking Speed
@ $7928 label=Table_ParatrooperSpeed
D $7928 Walking speed for the paratrooper, indexed by room number minus one.
. Only rooms #N$05#RAW(,) #N$06 and #N$08 have active paratrooper entries.
B $7928,$01  Room #N($01+#PC-$7928).
L $7928,$01,$08

c $7930 Generate Random Number
@ $7930 label=Generate_Random_Number
D $7930 Generates a pseudo-random number using a linear decay formula. Reads the
. current seed from #R$7AC7, computes (seed + #N$01) * #N$FE, then derives the
. new seed from the difference of the low and high bytes of the result. Returns
. the new value in #REGa.
R $7930 O:A Pseudo-random value
  $7930,$03 Fetch the current random seed from *#R$7AC7.
  $7933,$05 Set #REGhl to seed * #N$100 and copy into #REGde.
  $7938,$05 Subtract #REGde twice from #REGhl (i.e. #REGhl = seed * #N$FE).
  $793D,$04 Add #N$00FE to #REGhl.
  $7941,$05 Subtract #REGh from #REGl; if no borrow occurred, decrement the
. result by one.
@ $7946 label=Store_Random_Seed
  $7946,$03 Write the new random seed to *#R$7AC7.
  $7949,$01 Return.

c $794A Handler: Spider
@ $794A label=Handler_Spider
D $794A Controls the spider hazard. The spider descends and ascends on a silk
. thread, bouncing between a minimum height of #N$43 and a maximum height of
. #N$60. The thread is drawn as a vertical line of pixels from the top of the
. screen down to the spider's current position. The spider randomly alternates
. between two animation frames and checks for collision with Percy.
R $794A IX Pointer to the spider sprite data
N $794A Check for respawn and set the thread colour attributes.
  $794A,$07 Call #R$79C0 to initialise the spider if *#R$5FBB is set.
  $7951,$03 Point #REGhl at #R$D800 (attribute buffer row).
  $7954,$03 Set #REGbc to #N$0020 (one attribute row width).
  $7957,$07 Write #COLOUR$68 (#N$68) to three consecutive attribute rows for
. the thread area.
N $795E Draw the spider's silk thread from the top of the screen down to the
. spider's current position.
  $795E,$03 Point #REGhl at #N$480A (screen buffer address for top of thread).
  $7961,$01 Save the screen third base in #REGd.
  $7962,$02 Set #REGc to #N$3F (base Y position of the thread).
  $7964,$05 Calculate the number of pixel rows to draw by subtracting the
. spider's current height from the base Y position.
  $7969,$01 Set the row counter in #REGb.
@ $796A label=Draw_Thread_Loop
  $796A,$02 Set bit 7 of *#REGhl to draw one pixel of the thread.
  $796C,$01 Stash the screen buffer pointer on the stack.
  $796D,$04 Set bits 7 and 5 of #REGh to convert to the attribute buffer
. address.
  $7971,$02 Set bit 7 of *#REGhl to mark the thread attribute.
  $7973,$01 Restore the screen buffer pointer from the stack.
  $7974,$02 Advance down one pixel row.
  $7976,$02,b$01 Keep only bits 0-2.
M $7976,$04 Jump to #R$797F if the pixel row hasn't crossed a character cell
. boundary.
  $797A,$04 Add #N$20 to #REGl to move to the next character row.
  $797E,$01 Restore #REGh from #REGd to reset the screen third base for the new
. character row.
@ $797F label=Draw_Thread_Next
  $797F,$02 Decrease the row counter and loop back to #R$796A until the thread
. is fully drawn.
N $7981 Update the spider's vertical position based on its current direction.
  $7981,$06 Jump to #R$7994 if *#R$79D1 (direction flag) is non-zero (spider is
. descending).
N $7987 Spider is ascending: increase height until reaching the maximum.
@ $7987 label=Spider_Ascending
  $7987,$03 Fetch the spider's current height from *#REGix+#N$01.
  $798A,$01 Increment the height.
  $798B,$04 Jump to #R$79A1 if it has reached #N$60 (the maximum height, switch
. to descending).
  $798F,$03 Write the new height to *#REGix+#N$01.
  $7992,$02 Jump to #R$79AC.
N $7994 Spider is descending: decrease height until reaching the minimum.
@ $7994 label=Spider_Descending
  $7994,$03 Fetch the spider's current height from *#REGix+#N$01.
  $7997,$01 Decrement the height.
  $7998,$04 Jump to #R$79A8 if it has dropped below #N$43 (minimum height,
. switch to ascending).
  $799C,$03 Write the new height to *#REGix+#N$01.
  $799F,$02 Jump to #R$79AC.
@ $79A1 label=Spider_Switch_To_Descending
  $79A1,$05 Write #N$FF to *#R$79D1 (set direction to descending).
  $79A6,$02 Jump to #R$79AC.
@ $79A8 label=Spider_Switch_To_Ascending
  $79A8,$04 Write #N$00 to *#R$79D1 (set direction to ascending).
N $79AC Pick a random spider animation frame and check for collision with Percy.
N $79AC #UDGTABLE(default,centre,centre) { =h Sprite ID | =h Sprite }
. { #N$5F | #UDGS$02,$02(udg46843-56x4)(
.   #UDG($B6FB+$08*($02*$x+$y))(*udg)
.   udg
. ) }
. { #N$60 | #UDGS$02,$02(udg46875-56x4)(
.   #UDG($B71B+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
@ $79AC label=Set_Spider_Frame
M $79AC,$04 Use the Memory Refresh Register masked with #N$01 to randomly
. select frame #N$5F or #N$60.
  $79AE,$02,b$01 Keep only bit 0.
  $79B0,$02 Add #N$5F to get the final frame ID.
  $79B2,$03 Write the frame to *#REGix+#N$03.
  $79B5,$04 Point #REGiy at #R$DAC0 (Percy sprite data).
  $79B9,$03 Call #R$6C53 to check for collision with Percy.
  $79BC,$01 Return if there was no collision (carry set).
  $79BD,$03 Jump to #R$74E3.

c $79C0 Initialise Spider
@ $79C0 label=Initialise_Spider
D $79C0 Resets the spider to its starting position, height and direction.
R $79C0 IX Pointer to the spider sprite data
  $79C0,$04 Write #N$46 to *#REGix+#N$01 (initial height).
  $79C4,$04 Write #N$48 to *#REGix+#N$00 (X position).
  $79C8,$04 Write #N$00 to clear *#REGix+#N$02 (sprite active flag).
  $79CC,$04 Write #N$00 to *#R$79D1 to set the direction to ascending.
  $79D0,$01 Return.

g $79D1 Spider Direction Flag
@ $79D1 label=Spider_Direction_Flag
D $79D1 Direction flag for the spider. #N$00 = ascending, #N$FF = descending.
B $79D1,$01

c $79D2 Handler: Parachute Descent
@ $79D2 label=Handler_Parachute_Descent
D $79D2 Controls the paratrooper's parachute descent. The paratrooper descends
. under a parachute canopy, and upon reaching the bottom boundary the parachute
. folds up and detaches, drifting sideways while the paratrooper separates. The
. bottom boundary varies by room, and on room #N$08 it is extended to #N$88.
. Uses two sprite entries: the canopy (*#REGix+#N$00 to *#REGix+#N$03) and the
. body (*#REGix+#N$04 to *#REGix+#N$07).
R $79D2 IX Pointer to the parachute sprite data
N $79D2 Set up initial state and check for respawn.
  $79D2,$03 Fetch the respawn flag from *#R$5FBB.
  $79D5,$02 Set the default bottom boundary to #N$70 in #REGb.
  $79D7,$04 Point #REGiy at #R$7AC3.
  $79DB,$04 Jump to #R$7A94 if the respawn flag is non-zero (reset the
. parachute).
  $79DF,$07 If *#R$5FC5 is not equal to #N$08 skip over setting it below.
  $79E6,$02 Set the bottom boundary to #N$88.
N $79E8 Check the parachute's current state.
@ $79E8 label=Check_Parachute_State
  $79E8,$07 Jump to #R$7A80 if bit 7 of *#REGiy+#N$00 is set (parachute is
. stunned by egg).
  $79EF,$06 Jump to #R$7A26 if *#REGiy+#N$01 (landing counter) is non-zero
. (parachute is folding).
  $79F5,$06 Jump to #R$7A41 if *#REGiy+#N$02 (detach flag) is non-zero
. (parachute has detached).
N $79FB Descent phase: move the paratrooper downward by #N$02 pixels per frame.
@ $79FB label=Parachute_Descend
  $79FB,$03 Load #REGa with the canopy Y position from *#REGix+#N$01.
  $79FE,$02 Add #N$02 to the canopy Y position.
  $7A00,$03 Jump to #R$7A21 if the canopy Y position has reached the bottom
. boundary in #REGb.
  $7A03,$03 Write the updated Y position to *#REGix+#N$01 (canopy Y).
  $7A06,$05 Set the body Y position to the canopy Y plus #N$10.
  $7A0B,$04 Set the canopy sprite frame to #N$5B (open parachute).
@ $7A0F label=Set_Body_Frame_And_Check
  $7A0F,$04 Set the body sprite frame to #N$52 (paratrooper under parachute).
  $7A13,$03 Call #R$74D6 to check for collision with Percy or egg (canopy
. sprite).
  $7A16,$08 Advance #REGix by four to the body sprite entry.
  $7A1E,$03 Jump to #R$74D6 to check for collision with Percy or egg (body
. sprite).
N $7A21 Paratrooper has reached the bottom boundary; begin folding the
. parachute.
@ $7A21 label=Begin_Parachute_Fold
  $7A21,$02 Set the landing counter to #N$01.
  $7A23,$03 Write the counter to *#REGiy+#N$01.
@ $7A26 label=Animate_Parachute_Fold
  $7A26,$04 Jump to #R$7A34 if the landing counter has not reached #N$07.
  $7A2A,$08 Reset the landing counter to #N$00 and set the detach flag at
. *#REGiy+#N$02 to #N$01 (parachute fully folded).
  $7A32,$02 Jump to #R$7A41.
@ $7A34 label=Continue_Fold
  $7A34,$04 Increment the landing counter and write it back to *#REGiy+#N$01.
  $7A38,$04 Divide by two and add #N$5B to calculate the folding parachute
. frame.
  $7A3C,$03 Write the frame to *#REGix+#N$03 (canopy sprite).
  $7A3F,$02 Jump to #R$7A0F to set the body frame and check for collisions.
N $7A41 Detach phase: the parachute drifts sideways while the paratrooper
. separates.
@ $7A41 label=Parachute_Detach
M $7A41,$09 Increment the animation counter at *#REGiy+#N$03, wrapping at
. #N$07.
  $7A45,$02,b$01 Keep only bits 0-2.
  $7A4A,$04 Divide by two and add #N$57 to calculate the drifting paratrooper
. walking frame.
  $7A4E,$03 Write the frame to *#REGix+#N$07 (body sprite frame).
  $7A51,$03 Load #REGa with the body X position from *#REGix+#N$04.
  $7A54,$04 If the body X position is less than #N$80, it is drifting left;
. jump to #R$7A64 if drifting right.
N $7A58 Drifting left: subtract #N$02 from the body X position.
@ $7A58 label=Drift_Left
  $7A58,$02 Subtract #N$02 from the X position.
  $7A5A,$04 Jump to #R$7A94 if it has gone below #N$04 (off-screen to the
. left).
  $7A5E,$03 Write the updated X position to *#REGix+#N$04 (body X).
  $7A61,$03 Jump to #R$74D6 to check for collision with Percy or egg.
N $7A64 Drifting right: add #N$02 to the body X position.
@ $7A64 label=Drift_Right
  $7A64,$02 Add #N$02 to the body X position.
  $7A66,$04 Jump to #R$7A94 if the body X position has reached #N$EE
. (off-screen to the right).
  $7A6A,$03 Write the updated X position to *#REGix+#N$04 (body X).
  $7A6D,$08 Subtract #N$04 from the body sprite frame to get the opposite
. facing walking frame.
  $7A75,$08 Advance #REGix by four to the body sprite entry.
  $7A7D,$03 Jump to #R$74D6 to check for collision with Percy or egg.
N $7A80 Parachute has been stunned by Percy's egg; animate the stunned state.
@ $7A80 label=Parachute_Stunned
  $7A80,$06 Jump to #R$7A91 if *#REGiy+#N$03 is non-zero (skip canopy
. animation).
  $7A86,$03 Call #R$74B9 to animate the stunned canopy.
  $7A89,$08 Advance #REGix by four to the body sprite entry.
@ $7A91 label=Animate_Stunned_Body
  $7A91,$03 Jump to #R$74B9 to animate the stunned body.
N $7A94 Reset the parachute to its starting position for this room.
@ $7A94 label=Reset_Parachute
  $7A94,$12 Look up the starting X position for the current room from the table
. at #R$7B04 and write to both the canopy (*#REGix+#N$00) and body
. (*#REGix+#N$04) X positions.
  $7AA6,$0A Set both Y positions: canopy to #N$04, body to #N$14.
  $7AB0,$08 Set both sprite active flags to #N$07.
  $7AB8,$0A Write #N$00 to *#REGiy+#N$00, *#REGiy+#N$01 and *#REGiy+#N$02 to
. clear the stunned flag, landing counter and detach flag.
  $7AC2,$01 Return.

g $7AC3 Parachute State Data
@ $7AC3 label=Parachute_State_Data
D $7AC3 State variables for the parachute hazard.
B $7AC3,$01 Stunned flag (bit 7 set = stunned by egg).
B $7AC4,$01 Landing counter.
B $7AC5,$01 Detach flag.
B $7AC6,$01 Animation counter.

g $7AC7 Random Seed
@ $7AC7 label=RandomSeed
B $7AC7,$01

g $7AC8 Cat State Data
@ $7AC8 label=Cat_State_Data
D $7AC8 State variables for the cat hazard.
. Only rooms #N$02#RAW(,) #N$03#RAW(,) #N$05#RAW(,) #N$06#RAW(,) #N$07 and
. #N$08 have active entries.
N $7AC8 Room #N($01+(#PC-$7AC8)/$04):
B $7AC8,$01 Stunned flag (bit 7 set = stunned by egg).
B $7AC9,$01 Platform Y position.
B $7ACA,$01 Left boundary X position.
B $7ACB,$01 Right boundary X position.
L $7AC8,$04,$08

g $7AE8 Dog State Data
@ $7AE8 label=Dog_State_Data
D $7AE8 State variables for the dog hazard.
. Only rooms #N$03 and #N$07 have active entries.
N $7AE8 Room #N($01+(#PC-$7AE8)/$04):
B $7AE8,$01 Stunned flag (bit 7 set = stunned by egg).
B $7AE9,$01 Platform Y position.
B $7AEA,$01 Left boundary X position.
B $7AEB,$01 Right boundary X position.
L $7AE8,$04,$07

g $7B04 Table: Parachute Starting X Positions
@ $7B04 label=Table_ParachuteXPosition
D $7B04 Lookup table of starting X positions for the parachute, indexed by
. room number minus one.
. Only rooms #N$02#RAW(,) #N$08 and #N$09 have active paratrooper entries.
B $7B04,$01 Room #N($01+#PC-$7B04).
L $7B04,$01,$09

g $7B0D Paratrooper State Data
@ $7B0D label=Paratrooper_State_Data
D $7B0D State variables for the walking paratrooper hazard.
. Only rooms #N$05#RAW(,) #N$06 and #N$08 have active entries.
N $7B0D Room #N($01+(#PC-$7B0D)/$04):
B $7B0D,$01 Stunned flag (bit 7 set = stunned by egg).
B $7B0E,$01 Platform Y position.
B $7B0F,$01 Left boundary X position.
B $7B10,$01 Right boundary X position.
L $7B0D,$04,$08

u $7B2D
B $7B2D,$01

g $7B2E Jump Table: Room Handlers
@ $7B2E label=JumpTable_RoomHandler
W $7B2E,$02 Handler for room #N($01+(#PC-$7B2E)/$02).
L $7B2E,$02,$0B

u $7B44

b $83A9 Room #N$01
@ $83A9 label=Room01
D $83A9 #ROOM$01
N $83A9 Command #N$01: Skip tiles.
  $83A9,$01 Command (#N$01).
  $83AA,$01 Skip count: #N(#PEEK(#PC)).
  $83AB,$01 Tile ID: #R$9BC2(#N$0B).
  $83AC,$01 Tile ID: #R$9BCA(#N$0C).
  $83AD,$01 Tile ID: #R$9BD2(#N$0D).
N $83AE Command #N$01: Skip tiles.
  $83AE,$01 Command (#N$01).
  $83AF,$01 Skip count: #N(#PEEK(#PC)).
  $83B0,$01 Tile ID: #R$9BAA(#N$08).
N $83B1 Command #N$01: Skip tiles.
  $83B1,$01 Command (#N$01).
  $83B2,$01 Skip count: #N(#PEEK(#PC)).
  $83B3,$01 Tile ID: #R$9BDA(#N$0E).
  $83B4,$01 Tile ID: #R$9BD2(#N$0D).
  $83B5,$01 Tile ID: #R$9BC2(#N$0B).
  $83B6,$01 Tile ID: #R$9BCA(#N$0C).
  $83B7,$01 Tile ID: #R$9BD2(#N$0D).
N $83B8 Command #N$01: Skip tiles.
  $83B8,$01 Command (#N$01).
  $83B9,$01 Skip count: #N(#PEEK(#PC)).
  $83BA,$01 Tile ID: #R$9C4A(#N$1C).
N $83BB Command #N$01: Skip tiles.
  $83BB,$01 Command (#N$01).
  $83BC,$01 Skip count: #N(#PEEK(#PC)).
  $83BD,$01 Tile ID: #R$9BDA(#N$0E).
  $83BE,$01 Tile ID: #R$9BE2(#N$0F).
N $83BF Command #N$01: Skip tiles.
  $83BF,$01 Command (#N$01).
  $83C0,$01 Skip count: #N(#PEEK(#PC)).
  $83C1,$01 Tile ID: #R$9C42(#N$1B).
N $83C2 Command #N$01: Skip tiles.
  $83C2,$01 Command (#N$01).
  $83C3,$01 Skip count: #N(#PEEK(#PC)).
  $83C4,$01 Tile ID: #R$9BEA(#N$10).
N $83C5 Command #N$01: Skip tiles.
  $83C5,$01 Command (#N$01).
  $83C6,$01 Skip count: #N(#PEEK(#PC)).
  $83C7,$01 Tile ID: #R$9C3A(#N$1A).
N $83C8 Command #N$01: Skip tiles.
  $83C8,$01 Command (#N$01).
  $83C9,$01 Skip count: #N(#PEEK(#PC)).
  $83CA,$01 Tile ID: #R$9C0A(#N$14).
N $83CB Command #N$01: Skip tiles.
  $83CB,$01 Command (#N$01).
  $83CC,$01 Skip count: #N(#PEEK(#PC)).
  $83CD,$01 Tile ID: #R$9BF2(#N$11).
N $83CE Command #N$01: Skip tiles.
  $83CE,$01 Command (#N$01).
  $83CF,$01 Skip count: #N(#PEEK(#PC)).
  $83D0,$01 Tile ID: #R$9C02(#N$13).
  $83D1,$01 Tile ID: #R$9C2A(#N$18).
  $83D2,$01 Tile ID: #R$9C22(#N$17).
  $83D3,$01 Tile ID: #R$9C1A(#N$16).
  $83D4,$01 Tile ID: #R$9C12(#N$15).
  $83D5,$01 Tile ID: #R$9C2A(#N$18).
  $83D6,$01 Tile ID: #R$9C22(#N$17).
  $83D7,$01 Tile ID: #R$9C32(#N$19).
  $83D8,$01 Tile ID: #R$9BFA(#N$12).
N $83D9 Command #N$01: Skip tiles.
  $83D9,$01 Command (#N$01).
  $83DA,$01 Skip count: #N(#PEEK(#PC)).
  $83DB,$01 Tile ID: #R$A152(#N$BD).
N $83DC Command #N$01: Skip tiles.
  $83DC,$01 Command (#N$01).
  $83DD,$01 Skip count: #N(#PEEK(#PC)).
  $83DE,$01 Tile ID: #R$A14A(#N$BC).
N $83DF Command #N$01: Skip tiles.
  $83DF,$01 Command (#N$01).
  $83E0,$01 Skip count: #N(#PEEK(#PC)).
  $83E1,$01 Tile ID: #R$A19A(#N$C6).
  $83E2,$01 Tile ID: #R$A1A2(#N$C7).
  $83E3,$01 Tile ID: #R$A1AA(#N$C8).
  $83E4,$01 Tile ID: #R$A1B2(#N$C9).
  $83E5,$01 Tile ID: #R$A1BA(#N$CA).
N $83E6 Command #N$01: Skip tiles.
  $83E6,$01 Command (#N$01).
  $83E7,$01 Skip count: #N(#PEEK(#PC)).
N $83E8 Command #N$02: Draw repeated tile.
  $83E8,$01 Command (#N$02).
  $83E9,$01 Repeat count: #N(#PEEK(#PC)).
  $83EA,$01 Tile ID: #R$A00A(#N$94).
N $83EB Command #N$01: Skip tiles.
  $83EB,$01 Command (#N$01).
  $83EC,$01 Skip count: #N(#PEEK(#PC)).
  $83ED,$01 Tile ID: #R$A00A(#N$94).
N $83EE Command #N$01: Skip tiles.
  $83EE,$01 Command (#N$01).
  $83EF,$01 Skip count: #N(#PEEK(#PC)).
  $83F0,$01 Tile ID: #R$A02A(#N$98).
N $83F1 Command #N$01: Skip tiles.
  $83F1,$01 Command (#N$01).
  $83F2,$01 Skip count: #N(#PEEK(#PC)).
  $83F3,$01 Tile ID: #R$A312(#N$F5).
N $83F4 Command #N$01: Skip tiles.
  $83F4,$01 Command (#N$01).
  $83F5,$01 Skip count: #N(#PEEK(#PC)).
  $83F6,$01 Tile ID: #R$A1C2(#N$CB).
N $83F7 Command #N$01: Skip tiles.
  $83F7,$01 Command (#N$01).
  $83F8,$01 Skip count: #N(#PEEK(#PC)).
  $83F9,$01 Tile ID: #R$A25A(#N$DE).
N $83FA Command #N$01: Skip tiles.
  $83FA,$01 Command (#N$01).
  $83FB,$01 Skip count: #N(#PEEK(#PC)).
  $83FC,$01 Tile ID: #R$A02A(#N$98).
  $83FD,$01 Tile ID: #R$A0BA(#N$AA).
  $83FE,$01 Tile ID: #R$9CB2(#N$29).
  $83FF,$01 Tile ID: #R$A0B2(#N$A9).
  $8400,$01 Tile ID: #R$A1C2(#N$CB).
  $8401,$01 Tile ID: #R$A1D2(#N$CD).
  $8402,$01 Tile ID: #R$A25A(#N$DE).
N $8403 Command #N$01: Skip tiles.
  $8403,$01 Command (#N$01).
  $8404,$01 Skip count: #N(#PEEK(#PC)).
  $8405,$01 Tile ID: #R$A0CA(#N$AC).
  $8406,$01 Tile ID: #R$9FFA(#N$92).
  $8407,$01 Tile ID: #R$9FFA(#N$92).
  $8408,$01 Tile ID: #R$A0CA(#N$AC).
  $8409,$01 Tile ID: #R$9FFA(#N$92).
  $840A,$01 Tile ID: #R$9FFA(#N$92).
  $840B,$01 Tile ID: #R$A0CA(#N$AC).
  $840C,$01 Tile ID: #R$9FFA(#N$92).
  $840D,$01 Tile ID: #R$9FFA(#N$92).
  $840E,$01 Tile ID: #R$A0CA(#N$AC).
  $840F,$01 Tile ID: #R$9FFA(#N$92).
  $8410,$01 Tile ID: #R$9FFA(#N$92).
  $8411,$01 Tile ID: #R$A0CA(#N$AC).
N $8412 Command #N$01: Skip tiles.
  $8412,$01 Command (#N$01).
  $8413,$01 Skip count: #N(#PEEK(#PC)).
  $8414,$01 Tile ID: #R$A00A(#N$94).
  $8415,$01 Tile ID: #R$A00A(#N$94).
N $8416 Command #N$02: Draw repeated tile.
  $8416,$01 Command (#N$02).
  $8417,$01 Repeat count: #N(#PEEK(#PC)).
  $8418,$01 Tile ID: #R$A272(#N$E1).
  $8419,$01 Tile ID: #R$A1CA(#N$CC).
  $841A,$01 Tile ID: #R$A00A(#N$94).
  $841B,$01 Tile ID: #R$A002(#N$93).
N $841C Command #N$01: Skip tiles.
  $841C,$01 Command (#N$01).
  $841D,$01 Skip count: #N(#PEEK(#PC)).
  $841E,$01 Tile ID: #R$A0CA(#N$AC).
  $841F,$01 Tile ID: #R$9FFA(#N$92).
  $8420,$01 Tile ID: #R$9FFA(#N$92).
  $8421,$01 Tile ID: #R$A0CA(#N$AC).
  $8422,$01 Tile ID: #R$9FFA(#N$92).
  $8423,$01 Tile ID: #R$9FFA(#N$92).
  $8424,$01 Tile ID: #R$A0CA(#N$AC).
  $8425,$01 Tile ID: #R$9FFA(#N$92).
  $8426,$01 Tile ID: #R$9FFA(#N$92).
  $8427,$01 Tile ID: #R$A0CA(#N$AC).
  $8428,$01 Tile ID: #R$9FFA(#N$92).
  $8429,$01 Tile ID: #R$9FFA(#N$92).
  $842A,$01 Tile ID: #R$A0CA(#N$AC).
N $842B Command #N$01: Skip tiles.
  $842B,$01 Command (#N$01).
  $842C,$01 Skip count: #N(#PEEK(#PC)).
  $842D,$01 Tile ID: #R$A00A(#N$94).
  $842E,$01 Tile ID: #R$A00A(#N$94).
N $842F Command #N$01: Skip tiles.
  $842F,$01 Command (#N$01).
  $8430,$01 Skip count: #N(#PEEK(#PC)).
  $8431,$01 Tile ID: #R$A272(#N$E1).
N $8432 Command #N$02: Draw repeated tile.
  $8432,$01 Command (#N$02).
  $8433,$01 Repeat count: #N(#PEEK(#PC)).
  $8434,$01 Tile ID: #R$A00A(#N$94).
  $8435,$01 Tile ID: #R$A272(#N$E1).
  $8436,$01 Tile ID: #R$A272(#N$E1).
N $8437 Command #N$02: Draw repeated tile.
  $8437,$01 Command (#N$02).
  $8438,$01 Repeat count: #N(#PEEK(#PC)).
  $8439,$01 Tile ID: #R$A00A(#N$94).
  $843A,$01 Tile ID: #R$A272(#N$E1).
  $843B,$01 Tile ID: #R$A272(#N$E1).
N $843C Command #N$02: Draw repeated tile.
  $843C,$01 Command (#N$02).
  $843D,$01 Repeat count: #N(#PEEK(#PC)).
  $843E,$01 Tile ID: #R$A00A(#N$94).
  $843F,$01 Tile ID: #R$A272(#N$E1).
  $8440,$01 Tile ID: #R$A272(#N$E1).
N $8441 Command #N$02: Draw repeated tile.
  $8441,$01 Command (#N$02).
  $8442,$01 Repeat count: #N(#PEEK(#PC)).
  $8443,$01 Tile ID: #R$A00A(#N$94).
  $8444,$01 Tile ID: #R$A272(#N$E1).
  $8445,$01 Tile ID: #R$A272(#N$E1).
N $8446 Command #N$02: Draw repeated tile.
  $8446,$01 Command (#N$02).
  $8447,$01 Repeat count: #N(#PEEK(#PC)).
  $8448,$01 Tile ID: #R$A00A(#N$94).
  $8449,$01 Tile ID: #R$A272(#N$E1).
  $844A,$01 Tile ID: #R$A272(#N$E1).
N $844B Command #N$02: Draw repeated tile.
  $844B,$01 Command (#N$02).
  $844C,$01 Repeat count: #N(#PEEK(#PC)).
  $844D,$01 Tile ID: #R$A00A(#N$94).
  $844E,$01 Tile ID: #R$A272(#N$E1).
  $844F,$01 Tile ID: #R$A272(#N$E1).
  $8450,$01 Tile ID: #R$A00A(#N$94).
N $8451 Command #N$03: Fill attribute buffer.
  $8451,$01 Command (#N$03).
  $8452,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $8453 Attribute overlay: skip.
  $8453,$01 Opcode (#N$12).
  $8454,$01 Skip count: #N(#PEEK(#PC)).
  $8455,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8456,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8457,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8458 Attribute overlay: skip.
  $8458,$01 Opcode (#N$12).
  $8459,$01 Skip count: #N(#PEEK(#PC)).
N $845A Attribute overlay: repeat colour.
  $845A,$01 Opcode (#N$1B).
  $845B,$01 Repeat count: #N(#PEEK(#PC)).
  $845C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $845D Attribute overlay: skip.
  $845D,$01 Opcode (#N$12).
  $845E,$01 Skip count: #N(#PEEK(#PC)).
N $845F Attribute overlay: repeat colour.
  $845F,$01 Opcode (#N$1B).
  $8460,$01 Repeat count: #N(#PEEK(#PC)).
  $8461,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8462 Attribute overlay: skip.
  $8462,$01 Opcode (#N$12).
  $8463,$01 Skip count: #N(#PEEK(#PC)).
N $8464 Attribute overlay: repeat colour.
  $8464,$01 Opcode (#N$1B).
  $8465,$01 Repeat count: #N(#PEEK(#PC)).
  $8466,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8467,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8468 Attribute overlay: repeat colour.
  $8468,$01 Opcode (#N$1B).
  $8469,$01 Repeat count: #N(#PEEK(#PC)).
  $846A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $846B Attribute overlay: skip.
  $846B,$01 Opcode (#N$12).
  $846C,$01 Skip count: #N(#PEEK(#PC)).
N $846D Attribute overlay: repeat colour.
  $846D,$01 Opcode (#N$1B).
  $846E,$01 Repeat count: #N(#PEEK(#PC)).
  $846F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8470 Attribute overlay: skip.
  $8470,$01 Opcode (#N$12).
  $8471,$01 Skip count: #N(#PEEK(#PC)).
  $8472,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8473 Attribute overlay: repeat colour.
  $8473,$01 Opcode (#N$1B).
  $8474,$01 Repeat count: #N(#PEEK(#PC)).
  $8475,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8476,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8477,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8478 Attribute overlay: skip.
  $8478,$01 Opcode (#N$12).
  $8479,$01 Skip count: #N(#PEEK(#PC)).
N $847A Attribute overlay: repeat colour.
  $847A,$01 Opcode (#N$1B).
  $847B,$01 Repeat count: #N(#PEEK(#PC)).
  $847C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $847D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $847E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $847F Attribute overlay: repeat colour.
  $847F,$01 Opcode (#N$1B).
  $8480,$01 Repeat count: #N(#PEEK(#PC)).
  $8481,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8482,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8483,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8484,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8485,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8486,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8487,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8488,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8489,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $848A Attribute overlay: repeat colour.
  $848A,$01 Opcode (#N$1B).
  $848B,$01 Repeat count: #N(#PEEK(#PC)).
  $848C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $848D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $848E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $848F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8490,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8491,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8492,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8493,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8494,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8495 Attribute overlay: repeat colour.
  $8495,$01 Opcode (#N$1B).
  $8496,$01 Repeat count: #N(#PEEK(#PC)).
  $8497,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8498 Attribute overlay: repeat colour.
  $8498,$01 Opcode (#N$1B).
  $8499,$01 Repeat count: #N(#PEEK(#PC)).
  $849A,$01 Colour: #COLOUR(#PEEK(#PC)).
  $849B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $849C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $849D Attribute overlay: repeat colour.
  $849D,$01 Opcode (#N$1B).
  $849E,$01 Repeat count: #N(#PEEK(#PC)).
  $849F,$01 Colour: #COLOUR(#PEEK(#PC)).
  $84A0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $84A1 Attribute overlay: repeat colour.
  $84A1,$01 Opcode (#N$1B).
  $84A2,$01 Repeat count: #N(#PEEK(#PC)).
  $84A3,$01 Colour: #COLOUR(#PEEK(#PC)).
N $84A4 Attribute overlay: repeat colour.
  $84A4,$01 Opcode (#N$1B).
  $84A5,$01 Repeat count: #N(#PEEK(#PC)).
  $84A6,$01 Colour: #COLOUR(#PEEK(#PC)).
N $84A7 Attribute overlay: repeat colour.
  $84A7,$01 Opcode (#N$1B).
  $84A8,$01 Repeat count: #N(#PEEK(#PC)).
  $84A9,$01 Colour: #COLOUR(#PEEK(#PC)).
  $84AA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $84AB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $84AC Attribute overlay: repeat colour.
  $84AC,$01 Opcode (#N$1B).
  $84AD,$01 Repeat count: #N(#PEEK(#PC)).
  $84AE,$01 Colour: #COLOUR(#PEEK(#PC)).
N $84AF Attribute overlay: repeat colour.
  $84AF,$01 Opcode (#N$1B).
  $84B0,$01 Repeat count: #N(#PEEK(#PC)).
  $84B1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $84B2,$01 End of attribute overlay.
  $84B3,$01 Terminator.

b $84B4 Room #N$02
@ $84B4 label=Room02
D $84B4 #ROOM$02
N $84B4 Command #N$01: Skip tiles.
  $84B4,$01 Command (#N$01).
  $84B5,$01 Skip count: #N(#PEEK(#PC)).
  $84B6,$01 Tile ID: #R$A16A(#N$C0).
  $84B7,$01 Tile ID: #R$A16A(#N$C0).
N $84B8 Command #N$01: Skip tiles.
  $84B8,$01 Command (#N$01).
  $84B9,$01 Skip count: #N(#PEEK(#PC)).
  $84BA,$01 Tile ID: #R$A352(#N$FD).
  $84BB,$01 Tile ID: #R$A352(#N$FD).
  $84BC,$01 Tile ID: #R$A35A(#N$FE).
N $84BD Command #N$01: Skip tiles.
  $84BD,$01 Command (#N$01).
  $84BE,$01 Skip count: #N(#PEEK(#PC)).
  $84BF,$01 Tile ID: #R$A35A(#N$FE).
  $84C0,$01 Tile ID: #R$A352(#N$FD).
  $84C1,$01 Tile ID: #R$A352(#N$FD).
  $84C2,$01 Tile ID: #R$A35A(#N$FE).
  $84C3,$01 Tile ID: #R$A352(#N$FD).
  $84C4,$01 Tile ID: #R$A352(#N$FD).
  $84C5,$01 Tile ID: #R$A35A(#N$FE).
  $84C6,$01 Tile ID: #R$A352(#N$FD).
  $84C7,$01 Tile ID: #R$A352(#N$FD).
  $84C8,$01 Tile ID: #R$A35A(#N$FE).
  $84C9,$01 Tile ID: #R$A352(#N$FD).
  $84CA,$01 Tile ID: #R$A352(#N$FD).
  $84CB,$01 Tile ID: #R$A35A(#N$FE).
  $84CC,$01 Tile ID: #R$A352(#N$FD).
N $84CD Command #N$01: Skip tiles.
  $84CD,$01 Command (#N$01).
  $84CE,$01 Skip count: #N(#PEEK(#PC)).
  $84CF,$01 Tile ID: #R$A352(#N$FD).
  $84D0,$01 Tile ID: #R$A35A(#N$FE).
  $84D1,$01 Tile ID: #R$A352(#N$FD).
N $84D2 Command #N$01: Skip tiles.
  $84D2,$01 Command (#N$01).
  $84D3,$01 Skip count: #N(#PEEK(#PC)).
  $84D4,$01 Tile ID: #R$A352(#N$FD).
  $84D5,$01 Tile ID: #R$A352(#N$FD).
  $84D6,$01 Tile ID: #R$A35A(#N$FE).
  $84D7,$01 Tile ID: #R$A352(#N$FD).
  $84D8,$01 Tile ID: #R$A352(#N$FD).
  $84D9,$01 Tile ID: #R$A35A(#N$FE).
  $84DA,$01 Tile ID: #R$A352(#N$FD).
  $84DB,$01 Tile ID: #R$A352(#N$FD).
  $84DC,$01 Tile ID: #R$A35A(#N$FE).
  $84DD,$01 Tile ID: #R$A352(#N$FD).
  $84DE,$01 Tile ID: #R$A352(#N$FD).
  $84DF,$01 Tile ID: #R$A35A(#N$FE).
  $84E0,$01 Tile ID: #R$A352(#N$FD).
  $84E1,$01 Tile ID: #R$A352(#N$FD).
N $84E2 Command #N$01: Skip tiles.
  $84E2,$01 Command (#N$01).
  $84E3,$01 Skip count: #N(#PEEK(#PC)).
  $84E4,$01 Tile ID: #R$A35A(#N$FE).
  $84E5,$01 Tile ID: #R$A352(#N$FD).
  $84E6,$01 Tile ID: #R$A352(#N$FD).
  $84E7,$01 Tile ID: #R$A35A(#N$FE).
  $84E8,$01 Tile ID: #R$A352(#N$FD).
  $84E9,$01 Tile ID: #R$A352(#N$FD).
  $84EA,$01 Tile ID: #R$A35A(#N$FE).
  $84EB,$01 Tile ID: #R$A352(#N$FD).
  $84EC,$01 Tile ID: #R$A352(#N$FD).
  $84ED,$01 Tile ID: #R$A35A(#N$FE).
  $84EE,$01 Tile ID: #R$A352(#N$FD).
  $84EF,$01 Tile ID: #R$A352(#N$FD).
  $84F0,$01 Tile ID: #R$A35A(#N$FE).
  $84F1,$01 Tile ID: #R$A352(#N$FD).
  $84F2,$01 Tile ID: #R$A352(#N$FD).
  $84F3,$01 Tile ID: #R$A35A(#N$FE).
  $84F4,$01 Tile ID: #R$A352(#N$FD).
  $84F5,$01 Tile ID: #R$A352(#N$FD).
  $84F6,$01 Tile ID: #R$A35A(#N$FE).
N $84F7 Command #N$01: Skip tiles.
  $84F7,$01 Command (#N$01).
  $84F8,$01 Skip count: #N(#PEEK(#PC)).
  $84F9,$01 Tile ID: #R$A352(#N$FD).
  $84FA,$01 Tile ID: #R$A352(#N$FD).
  $84FB,$01 Tile ID: #R$A35A(#N$FE).
  $84FC,$01 Tile ID: #R$A352(#N$FD).
  $84FD,$01 Tile ID: #R$A352(#N$FD).
  $84FE,$01 Tile ID: #R$A35A(#N$FE).
  $84FF,$01 Tile ID: #R$A352(#N$FD).
  $8500,$01 Tile ID: #R$A352(#N$FD).
  $8501,$01 Tile ID: #R$A35A(#N$FE).
  $8502,$01 Tile ID: #R$A352(#N$FD).
  $8503,$01 Tile ID: #R$A352(#N$FD).
  $8504,$01 Tile ID: #R$A35A(#N$FE).
  $8505,$01 Tile ID: #R$A352(#N$FD).
  $8506,$01 Tile ID: #R$A352(#N$FD).
  $8507,$01 Tile ID: #R$A35A(#N$FE).
  $8508,$01 Tile ID: #R$A352(#N$FD).
  $8509,$01 Tile ID: #R$A352(#N$FD).
  $850A,$01 Tile ID: #R$A35A(#N$FE).
  $850B,$01 Tile ID: #R$A352(#N$FD).
N $850C Command #N$01: Skip tiles.
  $850C,$01 Command (#N$01).
  $850D,$01 Skip count: #N(#PEEK(#PC)).
N $850E Command #N$02: Draw repeated tile.
  $850E,$01 Command (#N$02).
  $850F,$01 Repeat count: #N(#PEEK(#PC)).
  $8510,$01 Tile ID: #R$A27A(#N$E2).
N $8511 Command #N$01: Skip tiles.
  $8511,$01 Command (#N$01).
  $8512,$01 Skip count: #N(#PEEK(#PC)).
  $8513,$01 Tile ID: #R$A00A(#N$94).
  $8514,$01 Tile ID: #R$A00A(#N$94).
  $8515,$01 Tile ID: #R$A002(#N$93).
  $8516,$01 Tile ID: #R$A00A(#N$94).
  $8517,$01 Tile ID: #R$A002(#N$93).
  $8518,$01 Tile ID: #R$A00A(#N$94).
  $8519,$01 Tile ID: #R$A002(#N$93).
  $851A,$01 Tile ID: #R$A00A(#N$94).
  $851B,$01 Tile ID: #R$A002(#N$93).
  $851C,$01 Tile ID: #R$A00A(#N$94).
  $851D,$01 Tile ID: #R$A002(#N$93).
  $851E,$01 Tile ID: #R$A00A(#N$94).
  $851F,$01 Tile ID: #R$A002(#N$93).
  $8520,$01 Tile ID: #R$A00A(#N$94).
  $8521,$01 Tile ID: #R$A002(#N$93).
  $8522,$01 Tile ID: #R$A00A(#N$94).
  $8523,$01 Tile ID: #R$A002(#N$93).
  $8524,$01 Tile ID: #R$A00A(#N$94).
  $8525,$01 Tile ID: #R$A002(#N$93).
N $8526 Command #N$01: Skip tiles.
  $8526,$01 Command (#N$01).
  $8527,$01 Skip count: #N(#PEEK(#PC)).
  $8528,$01 Tile ID: #R$A00A(#N$94).
  $8529,$01 Tile ID: #R$A002(#N$93).
  $852A,$01 Tile ID: #R$A0DA(#N$AE).
  $852B,$01 Tile ID: #R$9FFA(#N$92).
  $852C,$01 Tile ID: #R$9FFA(#N$92).
  $852D,$01 Tile ID: #R$A0CA(#N$AC).
N $852E Command #N$02: Draw repeated tile.
  $852E,$01 Command (#N$02).
  $852F,$01 Repeat count: #N(#PEEK(#PC)).
  $8530,$01 Tile ID: #R$9FFA(#N$92).
  $8531,$01 Tile ID: #R$A0CA(#N$AC).
  $8532,$01 Tile ID: #R$A00A(#N$94).
  $8533,$01 Tile ID: #R$A002(#N$93).
N $8534 Command #N$02: Draw repeated tile.
  $8534,$01 Command (#N$02).
  $8535,$01 Repeat count: #N(#PEEK(#PC)).
  $8536,$01 Tile ID: #R$9CB2(#N$29).
  $8537,$01 Tile ID: #R$A00A(#N$94).
  $8538,$01 Tile ID: #R$A00A(#N$94).
  $8539,$01 Tile ID: #R$A0DA(#N$AE).
  $853A,$01 Tile ID: #R$9FFA(#N$92).
N $853B Command #N$01: Skip tiles.
  $853B,$01 Command (#N$01).
  $853C,$01 Skip count: #N(#PEEK(#PC)).
  $853D,$01 Tile ID: #R$A00A(#N$94).
  $853E,$01 Tile ID: #R$A00A(#N$94).
  $853F,$01 Tile ID: #R$A0DA(#N$AE).
N $8540 Command #N$02: Draw repeated tile.
  $8540,$01 Command (#N$02).
  $8541,$01 Repeat count: #N(#PEEK(#PC)).
  $8542,$01 Tile ID: #R$9FFA(#N$92).
  $8543,$01 Tile ID: #R$A0CA(#N$AC).
  $8544,$01 Tile ID: #R$A00A(#N$94).
  $8545,$01 Tile ID: #R$A00A(#N$94).
N $8546 Command #N$02: Draw repeated tile.
  $8546,$01 Command (#N$02).
  $8547,$01 Repeat count: #N(#PEEK(#PC)).
  $8548,$01 Tile ID: #R$9CB2(#N$29).
  $8549,$01 Tile ID: #R$A00A(#N$94).
  $854A,$01 Tile ID: #R$A002(#N$93).
  $854B,$01 Tile ID: #R$A0DA(#N$AE).
  $854C,$01 Tile ID: #R$9FFA(#N$92).
N $854D Command #N$01: Skip tiles.
  $854D,$01 Command (#N$01).
  $854E,$01 Skip count: #N(#PEEK(#PC)).
  $854F,$01 Tile ID: #R$A00A(#N$94).
  $8550,$01 Tile ID: #R$A002(#N$93).
  $8551,$01 Tile ID: #R$A0B2(#N$A9).
N $8552 Command #N$01: Skip tiles.
  $8552,$01 Command (#N$01).
  $8553,$01 Skip count: #N(#PEEK(#PC)).
  $8554,$01 Tile ID: #R$9BB2(#N$09).
  $8555,$01 Tile ID: #R$9BBA(#N$0A).
  $8556,$01 Tile ID: #R$9BB2(#N$09).
  $8557,$01 Tile ID: #R$9BBA(#N$0A).
N $8558 Command #N$01: Skip tiles.
  $8558,$01 Command (#N$01).
  $8559,$01 Skip count: #N(#PEEK(#PC)).
  $855A,$01 Tile ID: #R$A0BA(#N$AA).
  $855B,$01 Tile ID: #R$A00A(#N$94).
  $855C,$01 Tile ID: #R$A002(#N$93).
N $855D Command #N$02: Draw repeated tile.
  $855D,$01 Command (#N$02).
  $855E,$01 Repeat count: #N(#PEEK(#PC)).
  $855F,$01 Tile ID: #R$9CB2(#N$29).
  $8560,$01 Tile ID: #R$A00A(#N$94).
  $8561,$01 Tile ID: #R$A00A(#N$94).
  $8562,$01 Tile ID: #R$A0B2(#N$A9).
N $8563 Command #N$01: Skip tiles.
  $8563,$01 Command (#N$01).
  $8564,$01 Skip count: #N(#PEEK(#PC)).
  $8565,$01 Tile ID: #R$A00A(#N$94).
  $8566,$01 Tile ID: #R$A00A(#N$94).
  $8567,$01 Tile ID: #R$A0E2(#N$AF).
  $8568,$01 Tile ID: #R$A33A(#N$FA).
  $8569,$01 Tile ID: #R$A0E2(#N$AF).
  $856A,$01 Tile ID: #R$A032(#N$99).
  $856B,$01 Tile ID: #R$A032(#N$99).
  $856C,$01 Tile ID: #R$A0D2(#N$AD).
  $856D,$01 Tile ID: #R$A33A(#N$FA).
  $856E,$01 Tile ID: #R$A0D2(#N$AD).
  $856F,$01 Tile ID: #R$A00A(#N$94).
  $8570,$01 Tile ID: #R$A00A(#N$94).
N $8571 Command #N$02: Draw repeated tile.
  $8571,$01 Command (#N$02).
  $8572,$01 Repeat count: #N(#PEEK(#PC)).
  $8573,$01 Tile ID: #R$9CB2(#N$29).
  $8574,$01 Tile ID: #R$A00A(#N$94).
  $8575,$01 Tile ID: #R$A002(#N$93).
  $8576,$01 Tile ID: #R$A0E2(#N$AF).
  $8577,$01 Tile ID: #R$A032(#N$99).
N $8578 Command #N$01: Skip tiles.
  $8578,$01 Command (#N$01).
  $8579,$01 Skip count: #N(#PEEK(#PC)).
  $857A,$01 Tile ID: #R$A30A(#N$F4).
N $857B Command #N$01: Skip tiles.
  $857B,$01 Command (#N$01).
  $857C,$01 Skip count: #N(#PEEK(#PC)).
  $857D,$01 Tile ID: #R$A30A(#N$F4).
N $857E Command #N$01: Skip tiles.
  $857E,$01 Command (#N$01).
  $857F,$01 Skip count: #N(#PEEK(#PC)).
  $8580,$01 Tile ID: #R$A30A(#N$F4).
N $8581 Command #N$01: Skip tiles.
  $8581,$01 Command (#N$01).
  $8582,$01 Skip count: #N(#PEEK(#PC)).
  $8583,$01 Tile ID: #R$A00A(#N$94).
  $8584,$01 Tile ID: #R$A002(#N$93).
  $8585,$01 Tile ID: #R$A00A(#N$94).
  $8586,$01 Tile ID: #R$A002(#N$93).
  $8587,$01 Tile ID: #R$A00A(#N$94).
  $8588,$01 Tile ID: #R$A002(#N$93).
  $8589,$01 Tile ID: #R$A00A(#N$94).
  $858A,$01 Tile ID: #R$A002(#N$93).
  $858B,$01 Tile ID: #R$A00A(#N$94).
  $858C,$01 Tile ID: #R$A002(#N$93).
  $858D,$01 Tile ID: #R$A00A(#N$94).
  $858E,$01 Tile ID: #R$A002(#N$93).
  $858F,$01 Tile ID: #R$A00A(#N$94).
  $8590,$01 Tile ID: #R$A002(#N$93).
  $8591,$01 Tile ID: #R$A00A(#N$94).
  $8592,$01 Tile ID: #R$A002(#N$93).
  $8593,$01 Tile ID: #R$A00A(#N$94).
  $8594,$01 Tile ID: #R$A002(#N$93).
  $8595,$01 Tile ID: #R$A00A(#N$94).
N $8596 Command #N$01: Skip tiles.
  $8596,$01 Command (#N$01).
  $8597,$01 Skip count: #N(#PEEK(#PC)).
  $8598,$01 Tile ID: #R$A2FA(#N$F2).
  $8599,$01 Tile ID: #R$A302(#N$F3).
  $859A,$01 Tile ID: #R$A302(#N$F3).
  $859B,$01 Tile ID: #R$A2FA(#N$F2).
  $859C,$01 Tile ID: #R$A302(#N$F3).
  $859D,$01 Tile ID: #R$A302(#N$F3).
  $859E,$01 Tile ID: #R$A2FA(#N$F2).
  $859F,$01 Tile ID: #R$A302(#N$F3).
  $85A0,$01 Tile ID: #R$A302(#N$F3).
  $85A1,$01 Tile ID: #R$A00A(#N$94).
  $85A2,$01 Tile ID: #R$A00A(#N$94).
  $85A3,$01 Tile ID: #R$A002(#N$93).
  $85A4,$01 Tile ID: #R$A00A(#N$94).
  $85A5,$01 Tile ID: #R$A002(#N$93).
  $85A6,$01 Tile ID: #R$A00A(#N$94).
  $85A7,$01 Tile ID: #R$A002(#N$93).
  $85A8,$01 Tile ID: #R$A00A(#N$94).
  $85A9,$01 Tile ID: #R$A002(#N$93).
  $85AA,$01 Tile ID: #R$A00A(#N$94).
  $85AB,$01 Tile ID: #R$A002(#N$93).
  $85AC,$01 Tile ID: #R$A00A(#N$94).
  $85AD,$01 Tile ID: #R$A002(#N$93).
  $85AE,$01 Tile ID: #R$A00A(#N$94).
  $85AF,$01 Tile ID: #R$A002(#N$93).
  $85B0,$01 Tile ID: #R$A00A(#N$94).
  $85B1,$01 Tile ID: #R$A002(#N$93).
  $85B2,$01 Tile ID: #R$A00A(#N$94).
  $85B3,$01 Tile ID: #R$A002(#N$93).
N $85B4 Command #N$01: Skip tiles.
  $85B4,$01 Command (#N$01).
  $85B5,$01 Skip count: #N(#PEEK(#PC)).
  $85B6,$01 Tile ID: #R$A00A(#N$94).
  $85B7,$01 Tile ID: #R$A002(#N$93).
  $85B8,$01 Tile ID: #R$A0DA(#N$AE).
  $85B9,$01 Tile ID: #R$A0CA(#N$AC).
  $85BA,$01 Tile ID: #R$9FFA(#N$92).
  $85BB,$01 Tile ID: #R$A342(#N$FB).
  $85BC,$01 Tile ID: #R$A34A(#N$FC).
  $85BD,$01 Tile ID: #R$9FFA(#N$92).
  $85BE,$01 Tile ID: #R$A0DA(#N$AE).
  $85BF,$01 Tile ID: #R$A0CA(#N$AC).
  $85C0,$01 Tile ID: #R$A00A(#N$94).
  $85C1,$01 Tile ID: #R$A002(#N$93).
N $85C2 Command #N$01: Skip tiles.
  $85C2,$01 Command (#N$01).
  $85C3,$01 Skip count: #N(#PEEK(#PC)).
  $85C4,$01 Tile ID: #R$A00A(#N$94).
  $85C5,$01 Tile ID: #R$A00A(#N$94).
  $85C6,$01 Tile ID: #R$A0DA(#N$AE).
  $85C7,$01 Tile ID: #R$A0CA(#N$AC).
N $85C8 Command #N$01: Skip tiles.
  $85C8,$01 Command (#N$01).
  $85C9,$01 Skip count: #N(#PEEK(#PC)).
  $85CA,$01 Tile ID: #R$A17A(#N$C2).
  $85CB,$01 Tile ID: #R$A18A(#N$C4).
N $85CC Command #N$01: Skip tiles.
  $85CC,$01 Command (#N$01).
  $85CD,$01 Skip count: #N(#PEEK(#PC)).
  $85CE,$01 Tile ID: #R$A00A(#N$94).
  $85CF,$01 Tile ID: #R$A00A(#N$94).
  $85D0,$01 Tile ID: #R$A0B2(#N$A9).
  $85D1,$01 Tile ID: #R$A0BA(#N$AA).
  $85D2,$01 Tile ID: #R$9FFA(#N$92).
  $85D3,$01 Tile ID: #R$9C52(#N$1D).
  $85D4,$01 Tile ID: #R$9CAA(#N$28).
  $85D5,$01 Tile ID: #R$9FFA(#N$92).
  $85D6,$01 Tile ID: #R$A0B2(#N$A9).
  $85D7,$01 Tile ID: #R$A0BA(#N$AA).
  $85D8,$01 Tile ID: #R$A00A(#N$94).
  $85D9,$01 Tile ID: #R$A00A(#N$94).
N $85DA Command #N$01: Skip tiles.
  $85DA,$01 Command (#N$01).
  $85DB,$01 Skip count: #N(#PEEK(#PC)).
  $85DC,$01 Tile ID: #R$A00A(#N$94).
  $85DD,$01 Tile ID: #R$A002(#N$93).
  $85DE,$01 Tile ID: #R$A0B2(#N$A9).
  $85DF,$01 Tile ID: #R$A0BA(#N$AA).
N $85E0 Command #N$01: Skip tiles.
  $85E0,$01 Command (#N$01).
  $85E1,$01 Skip count: #N(#PEEK(#PC)).
  $85E2,$01 Tile ID: #R$A182(#N$C3).
  $85E3,$01 Tile ID: #R$A192(#N$C5).
N $85E4 Command #N$01: Skip tiles.
  $85E4,$01 Command (#N$01).
  $85E5,$01 Skip count: #N(#PEEK(#PC)).
  $85E6,$01 Tile ID: #R$A00A(#N$94).
  $85E7,$01 Tile ID: #R$A002(#N$93).
  $85E8,$01 Tile ID: #R$A0B2(#N$A9).
  $85E9,$01 Tile ID: #R$A0BA(#N$AA).
N $85EA Command #N$01: Skip tiles.
  $85EA,$01 Command (#N$01).
  $85EB,$01 Skip count: #N(#PEEK(#PC)).
  $85EC,$01 Tile ID: #R$A032(#N$99).
  $85ED,$01 Tile ID: #R$A032(#N$99).
N $85EE Command #N$01: Skip tiles.
  $85EE,$01 Command (#N$01).
  $85EF,$01 Skip count: #N(#PEEK(#PC)).
  $85F0,$01 Tile ID: #R$A0B2(#N$A9).
  $85F1,$01 Tile ID: #R$A0BA(#N$AA).
  $85F2,$01 Tile ID: #R$A00A(#N$94).
  $85F3,$01 Tile ID: #R$A002(#N$93).
N $85F4 Command #N$01: Skip tiles.
  $85F4,$01 Command (#N$01).
  $85F5,$01 Skip count: #N(#PEEK(#PC)).
  $85F6,$01 Tile ID: #R$A00A(#N$94).
  $85F7,$01 Tile ID: #R$A00A(#N$94).
  $85F8,$01 Tile ID: #R$A0B2(#N$A9).
  $85F9,$01 Tile ID: #R$A0BA(#N$AA).
N $85FA Command #N$01: Skip tiles.
  $85FA,$01 Command (#N$01).
  $85FB,$01 Skip count: #N(#PEEK(#PC)).
  $85FC,$01 Tile ID: #R$A02A(#N$98).
  $85FD,$01 Tile ID: #R$A25A(#N$DE).
N $85FE Command #N$01: Skip tiles.
  $85FE,$01 Command (#N$01).
  $85FF,$01 Skip count: #N(#PEEK(#PC)).
  $8600,$01 Tile ID: #R$A152(#N$BD).
  $8601,$01 Tile ID: #R$A00A(#N$94).
  $8602,$01 Tile ID: #R$A00A(#N$94).
  $8603,$01 Tile ID: #R$A0E2(#N$AF).
  $8604,$01 Tile ID: #R$A0D2(#N$AD).
  $8605,$01 Tile ID: #R$A032(#N$99).
  $8606,$01 Tile ID: #R$A362(#N$FF).
  $8607,$01 Tile ID: #R$A362(#N$FF).
  $8608,$01 Tile ID: #R$A032(#N$99).
  $8609,$01 Tile ID: #R$A0E2(#N$AF).
  $860A,$01 Tile ID: #R$A0D2(#N$AD).
  $860B,$01 Tile ID: #R$A00A(#N$94).
  $860C,$01 Tile ID: #R$A00A(#N$94).
  $860D,$01 Tile ID: #R$9F22(#N$77).
N $860E Command #N$01: Skip tiles.
  $860E,$01 Command (#N$01).
  $860F,$01 Skip count: #N(#PEEK(#PC)).
  $8610,$01 Tile ID: #R$A00A(#N$94).
  $8611,$01 Tile ID: #R$A002(#N$93).
  $8612,$01 Tile ID: #R$A0E2(#N$AF).
  $8613,$01 Tile ID: #R$A0D2(#N$AD).
N $8614 Command #N$01: Skip tiles.
  $8614,$01 Command (#N$01).
  $8615,$01 Skip count: #N(#PEEK(#PC)).
  $8616,$01 Tile ID: #R$A02A(#N$98).
  $8617,$01 Tile ID: #R$A25A(#N$DE).
  $8618,$01 Tile ID: #R$A152(#N$BD).
  $8619,$01 Tile ID: #R$A162(#N$BF).
  $861A,$01 Tile ID: #R$A00A(#N$94).
  $861B,$01 Tile ID: #R$A002(#N$93).
  $861C,$01 Tile ID: #R$A00A(#N$94).
  $861D,$01 Tile ID: #R$A002(#N$93).
  $861E,$01 Tile ID: #R$A00A(#N$94).
  $861F,$01 Tile ID: #R$A002(#N$93).
  $8620,$01 Tile ID: #R$A00A(#N$94).
  $8621,$01 Tile ID: #R$A002(#N$93).
  $8622,$01 Tile ID: #R$A00A(#N$94).
  $8623,$01 Tile ID: #R$A002(#N$93).
  $8624,$01 Tile ID: #R$A00A(#N$94).
  $8625,$01 Tile ID: #R$A002(#N$93).
N $8626 Command #N$01: Skip tiles.
  $8626,$01 Command (#N$01).
  $8627,$01 Skip count: #N(#PEEK(#PC)).
  $8628,$01 Tile ID: #R$A00A(#N$94).
  $8629,$01 Tile ID: #R$A00A(#N$94).
  $862A,$01 Tile ID: #R$A002(#N$93).
  $862B,$01 Tile ID: #R$A00A(#N$94).
N $862C Command #N$01: Skip tiles.
  $862C,$01 Command (#N$01).
  $862D,$01 Skip count: #N(#PEEK(#PC)).
  $862E,$01 Tile ID: #R$A02A(#N$98).
  $862F,$01 Tile ID: #R$A172(#N$C1).
  $8630,$01 Tile ID: #R$A162(#N$BF).
N $8631 Command #N$01: Skip tiles.
  $8631,$01 Command (#N$01).
  $8632,$01 Skip count: #N(#PEEK(#PC)).
  $8633,$01 Tile ID: #R$A00A(#N$94).
  $8634,$01 Tile ID: #R$A00A(#N$94).
  $8635,$01 Tile ID: #R$A002(#N$93).
  $8636,$01 Tile ID: #R$A00A(#N$94).
  $8637,$01 Tile ID: #R$A002(#N$93).
  $8638,$01 Tile ID: #R$A00A(#N$94).
  $8639,$01 Tile ID: #R$A002(#N$93).
  $863A,$01 Tile ID: #R$A00A(#N$94).
  $863B,$01 Tile ID: #R$A002(#N$93).
  $863C,$01 Tile ID: #R$A00A(#N$94).
  $863D,$01 Tile ID: #R$A002(#N$93).
  $863E,$01 Tile ID: #R$A00A(#N$94).
N $863F Command #N$01: Skip tiles.
  $863F,$01 Command (#N$01).
  $8640,$01 Skip count: #N(#PEEK(#PC)).
  $8641,$01 Tile ID: #R$A00A(#N$94).
  $8642,$01 Tile ID: #R$A002(#N$93).
  $8643,$01 Tile ID: #R$A00A(#N$94).
  $8644,$01 Tile ID: #R$A002(#N$93).
N $8645 Command #N$01: Skip tiles.
  $8645,$01 Command (#N$01).
  $8646,$01 Skip count: #N(#PEEK(#PC)).
N $8647 Command #N$02: Draw repeated tile.
  $8647,$01 Command (#N$02).
  $8648,$01 Repeat count: #N(#PEEK(#PC)).
  $8649,$01 Tile ID: #R$A00A(#N$94).
  $864A,$01 Tile ID: #R$A272(#N$E1).
  $864B,$01 Tile ID: #R$A272(#N$E1).
N $864C Command #N$02: Draw repeated tile.
  $864C,$01 Command (#N$02).
  $864D,$01 Repeat count: #N(#PEEK(#PC)).
  $864E,$01 Tile ID: #R$A00A(#N$94).
  $864F,$01 Tile ID: #R$A25A(#N$DE).
N $8650 Command #N$01: Skip tiles.
  $8650,$01 Command (#N$01).
  $8651,$01 Skip count: #N(#PEEK(#PC)).
N $8652 Command #N$03: Fill attribute buffer.
  $8652,$01 Command (#N$03).
  $8653,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $8654 Attribute overlay: skip.
  $8654,$01 Opcode (#N$12).
  $8655,$01 Skip count: #N(#PEEK(#PC)).
  $8656,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8657,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8658 Attribute overlay: skip.
  $8658,$01 Opcode (#N$12).
  $8659,$01 Skip count: #N(#PEEK(#PC)).
  $865A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $865B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $865C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $865D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $865E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $865F Attribute overlay: repeat colour.
  $865F,$01 Opcode (#N$1B).
  $8660,$01 Repeat count: #N(#PEEK(#PC)).
  $8661,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8662 Attribute overlay: skip.
  $8662,$01 Opcode (#N$12).
  $8663,$01 Skip count: #N(#PEEK(#PC)).
  $8664,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8665,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8666,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8667,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8668,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8669 Attribute overlay: repeat colour.
  $8669,$01 Opcode (#N$1B).
  $866A,$01 Repeat count: #N(#PEEK(#PC)).
  $866B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $866C Attribute overlay: skip.
  $866C,$01 Opcode (#N$12).
  $866D,$01 Skip count: #N(#PEEK(#PC)).
N $866E Attribute overlay: repeat colour.
  $866E,$01 Opcode (#N$1B).
  $866F,$01 Repeat count: #N(#PEEK(#PC)).
  $8670,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8671 Attribute overlay: skip.
  $8671,$01 Opcode (#N$12).
  $8672,$01 Skip count: #N(#PEEK(#PC)).
N $8673 Attribute overlay: repeat colour.
  $8673,$01 Opcode (#N$1B).
  $8674,$01 Repeat count: #N(#PEEK(#PC)).
  $8675,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8676 Attribute overlay: skip.
  $8676,$01 Opcode (#N$12).
  $8677,$01 Skip count: #N(#PEEK(#PC)).
N $8678 Attribute overlay: repeat colour.
  $8678,$01 Opcode (#N$1B).
  $8679,$01 Repeat count: #N(#PEEK(#PC)).
  $867A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $867B Attribute overlay: skip.
  $867B,$01 Opcode (#N$12).
  $867C,$01 Skip count: #N(#PEEK(#PC)).
N $867D Attribute overlay: repeat colour.
  $867D,$01 Opcode (#N$1B).
  $867E,$01 Repeat count: #N(#PEEK(#PC)).
  $867F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8680 Attribute overlay: skip.
  $8680,$01 Opcode (#N$12).
  $8681,$01 Skip count: #N(#PEEK(#PC)).
  $8682,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8683,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8684,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8685 Attribute overlay: repeat colour.
  $8685,$01 Opcode (#N$1B).
  $8686,$01 Repeat count: #N(#PEEK(#PC)).
  $8687,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8688,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8689,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $868F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8690,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8691,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8692 Attribute overlay: skip.
  $8692,$01 Opcode (#N$12).
  $8693,$01 Skip count: #N(#PEEK(#PC)).
  $8694,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8695,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8696,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8697 Attribute overlay: repeat colour.
  $8697,$01 Opcode (#N$1B).
  $8698,$01 Repeat count: #N(#PEEK(#PC)).
  $8699,$01 Colour: #COLOUR(#PEEK(#PC)).
  $869A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $869B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $869C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $869D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $869E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $869F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86A4 Attribute overlay: skip.
  $86A4,$01 Opcode (#N$12).
  $86A5,$01 Skip count: #N(#PEEK(#PC)).
  $86A6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86A8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86A9 Attribute overlay: repeat colour.
  $86A9,$01 Opcode (#N$1B).
  $86AA,$01 Repeat count: #N(#PEEK(#PC)).
  $86AB,$01 Colour: #COLOUR(#PEEK(#PC)).
  $86AC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86AD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86AE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86AF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86B6 Attribute overlay: skip.
  $86B6,$01 Opcode (#N$12).
  $86B7,$01 Skip count: #N(#PEEK(#PC)).
  $86B8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86B9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86BA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86BB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86BC Attribute overlay: repeat colour.
  $86BC,$01 Opcode (#N$1B).
  $86BD,$01 Repeat count: #N(#PEEK(#PC)).
  $86BE,$01 Colour: #COLOUR(#PEEK(#PC)).
  $86BF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86C9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86CA Attribute overlay: skip.
  $86CA,$01 Opcode (#N$12).
  $86CB,$01 Skip count: #N(#PEEK(#PC)).
N $86CC Attribute overlay: repeat colour.
  $86CC,$01 Opcode (#N$1B).
  $86CD,$01 Repeat count: #N(#PEEK(#PC)).
  $86CE,$01 Colour: #COLOUR(#PEEK(#PC)).
N $86CF Attribute overlay: skip.
  $86CF,$01 Opcode (#N$12).
  $86D0,$01 Skip count: #N(#PEEK(#PC)).
N $86D1 Attribute overlay: repeat colour.
  $86D1,$01 Opcode (#N$1B).
  $86D2,$01 Repeat count: #N(#PEEK(#PC)).
  $86D3,$01 Colour: #COLOUR(#PEEK(#PC)).
N $86D4 Attribute overlay: repeat colour.
  $86D4,$01 Opcode (#N$1B).
  $86D5,$01 Repeat count: #N(#PEEK(#PC)).
  $86D6,$01 Colour: #COLOUR(#PEEK(#PC)).
  $86D7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86D8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86D9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86DA Attribute overlay: repeat colour.
  $86DA,$01 Opcode (#N$1B).
  $86DB,$01 Repeat count: #N(#PEEK(#PC)).
  $86DC,$01 Colour: #COLOUR(#PEEK(#PC)).
  $86DD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86DE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86DF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86E6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $86E7 Attribute overlay: repeat colour.
  $86E7,$01 Opcode (#N$1B).
  $86E8,$01 Repeat count: #N(#PEEK(#PC)).
  $86E9,$01 Colour: #COLOUR(#PEEK(#PC)).
  $86EA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86EB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86EC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86ED,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86EF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86F9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $86FF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8700,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8701 Attribute overlay: repeat colour.
  $8701,$01 Opcode (#N$1B).
  $8702,$01 Repeat count: #N(#PEEK(#PC)).
  $8703,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8704,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8705,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8706,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8707,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8708,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8709,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $870A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $870B Attribute overlay: repeat colour.
  $870B,$01 Opcode (#N$1B).
  $870C,$01 Repeat count: #N(#PEEK(#PC)).
  $870D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $870E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $870F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8710,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8711,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8712,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8713,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8714,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8715,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8716,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8717,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8718 Attribute overlay: repeat colour.
  $8718,$01 Opcode (#N$1B).
  $8719,$01 Repeat count: #N(#PEEK(#PC)).
  $871A,$01 Colour: #COLOUR(#PEEK(#PC)).
  $871B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $871C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $871D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $871E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $871F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8720,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8721,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8722,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8723,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8724,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8725,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8726,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8727,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8728,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8729,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $872A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $872B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $872C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $872D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $872E Attribute overlay: repeat colour.
  $872E,$01 Opcode (#N$1B).
  $872F,$01 Repeat count: #N(#PEEK(#PC)).
  $8730,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8731,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8732 Attribute overlay: repeat colour.
  $8732,$01 Opcode (#N$1B).
  $8733,$01 Repeat count: #N(#PEEK(#PC)).
  $8734,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8735,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8736,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8737,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8738 Attribute overlay: repeat colour.
  $8738,$01 Opcode (#N$1B).
  $8739,$01 Repeat count: #N(#PEEK(#PC)).
  $873A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $873B Attribute overlay: repeat colour.
  $873B,$01 Opcode (#N$1B).
  $873C,$01 Repeat count: #N(#PEEK(#PC)).
  $873D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $873E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $873F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8740 Attribute overlay: repeat colour.
  $8740,$01 Opcode (#N$1B).
  $8741,$01 Repeat count: #N(#PEEK(#PC)).
  $8742,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8743,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8744,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8745,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8746 Attribute overlay: repeat colour.
  $8746,$01 Opcode (#N$1B).
  $8747,$01 Repeat count: #N(#PEEK(#PC)).
  $8748,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8749 Attribute overlay: repeat colour.
  $8749,$01 Opcode (#N$1B).
  $874A,$01 Repeat count: #N(#PEEK(#PC)).
  $874B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $874C Attribute overlay: repeat colour.
  $874C,$01 Opcode (#N$1B).
  $874D,$01 Repeat count: #N(#PEEK(#PC)).
  $874E,$01 Colour: #COLOUR(#PEEK(#PC)).
N $874F Attribute overlay: repeat colour.
  $874F,$01 Opcode (#N$1B).
  $8750,$01 Repeat count: #N(#PEEK(#PC)).
  $8751,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8752 Attribute overlay: repeat colour.
  $8752,$01 Opcode (#N$1B).
  $8753,$01 Repeat count: #N(#PEEK(#PC)).
  $8754,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8755,$01 End of attribute overlay.
  $8756,$01 Terminator.

b $8757 Room #N$03
@ $8757 label=Room03
D $8757 #ROOM$03
N $8757 Command #N$01: Skip tiles.
  $8757,$01 Command (#N$01).
  $8758,$01 Skip count: #N(#PEEK(#PC)).
  $8759,$01 Tile ID: #R$A352(#N$FD).
  $875A,$01 Tile ID: #R$A35A(#N$FE).
  $875B,$01 Tile ID: #R$A352(#N$FD).
  $875C,$01 Tile ID: #R$A352(#N$FD).
  $875D,$01 Tile ID: #R$A35A(#N$FE).
  $875E,$01 Tile ID: #R$A352(#N$FD).
  $875F,$01 Tile ID: #R$A352(#N$FD).
  $8760,$01 Tile ID: #R$A35A(#N$FE).
N $8761 Command #N$01: Skip tiles.
  $8761,$01 Command (#N$01).
  $8762,$01 Skip count: #N(#PEEK(#PC)).
  $8763,$01 Tile ID: #R$9BC2(#N$0B).
  $8764,$01 Tile ID: #R$9BCA(#N$0C).
  $8765,$01 Tile ID: #R$9BE2(#N$0F).
N $8766 Command #N$01: Skip tiles.
  $8766,$01 Command (#N$01).
  $8767,$01 Skip count: #N(#PEEK(#PC)).
  $8768,$01 Tile ID: #R$A35A(#N$FE).
  $8769,$01 Tile ID: #R$A352(#N$FD).
  $876A,$01 Tile ID: #R$A352(#N$FD).
  $876B,$01 Tile ID: #R$A35A(#N$FE).
  $876C,$01 Tile ID: #R$A352(#N$FD).
  $876D,$01 Tile ID: #R$A352(#N$FD).
  $876E,$01 Tile ID: #R$A35A(#N$FE).
  $876F,$01 Tile ID: #R$A352(#N$FD).
N $8770 Command #N$01: Skip tiles.
  $8770,$01 Command (#N$01).
  $8771,$01 Skip count: #N(#PEEK(#PC)).
  $8772,$01 Tile ID: #R$9BB2(#N$09).
  $8773,$01 Tile ID: #R$9BBA(#N$0A).
N $8774 Command #N$01: Skip tiles.
  $8774,$01 Command (#N$01).
  $8775,$01 Skip count: #N(#PEEK(#PC)).
  $8776,$01 Tile ID: #R$9BAA(#N$08).
N $8777 Command #N$01: Skip tiles.
  $8777,$01 Command (#N$01).
  $8778,$01 Skip count: #N(#PEEK(#PC)).
  $8779,$01 Tile ID: #R$9BEA(#N$10).
N $877A Command #N$01: Skip tiles.
  $877A,$01 Command (#N$01).
  $877B,$01 Skip count: #N(#PEEK(#PC)).
  $877C,$01 Tile ID: #R$A352(#N$FD).
  $877D,$01 Tile ID: #R$A352(#N$FD).
  $877E,$01 Tile ID: #R$A35A(#N$FE).
  $877F,$01 Tile ID: #R$A352(#N$FD).
  $8780,$01 Tile ID: #R$A352(#N$FD).
  $8781,$01 Tile ID: #R$A35A(#N$FE).
  $8782,$01 Tile ID: #R$A352(#N$FD).
  $8783,$01 Tile ID: #R$A352(#N$FD).
N $8784 Command #N$01: Skip tiles.
  $8784,$01 Command (#N$01).
  $8785,$01 Skip count: #N(#PEEK(#PC)).
  $8786,$01 Tile ID: #R$9C42(#N$1B).
N $8787 Command #N$01: Skip tiles.
  $8787,$01 Command (#N$01).
  $8788,$01 Skip count: #N(#PEEK(#PC)).
  $8789,$01 Tile ID: #R$9BDA(#N$0E).
  $878A,$01 Tile ID: #R$9BD2(#N$0D).
  $878B,$01 Tile ID: #R$9C4A(#N$1C).
N $878C Command #N$01: Skip tiles.
  $878C,$01 Command (#N$01).
  $878D,$01 Skip count: #N(#PEEK(#PC)).
  $878E,$01 Tile ID: #R$9BEA(#N$10).
N $878F Command #N$01: Skip tiles.
  $878F,$01 Command (#N$01).
  $8790,$01 Skip count: #N(#PEEK(#PC)).
  $8791,$01 Tile ID: #R$A352(#N$FD).
  $8792,$01 Tile ID: #R$A35A(#N$FE).
  $8793,$01 Tile ID: #R$A352(#N$FD).
  $8794,$01 Tile ID: #R$A352(#N$FD).
  $8795,$01 Tile ID: #R$A35A(#N$FE).
  $8796,$01 Tile ID: #R$A352(#N$FD).
  $8797,$01 Tile ID: #R$A352(#N$FD).
  $8798,$01 Tile ID: #R$A35A(#N$FE).
N $8799 Command #N$01: Skip tiles.
  $8799,$01 Command (#N$01).
  $879A,$01 Skip count: #N(#PEEK(#PC)).
  $879B,$01 Tile ID: #R$9C3A(#N$1A).
N $879C Command #N$01: Skip tiles.
  $879C,$01 Command (#N$01).
  $879D,$01 Skip count: #N(#PEEK(#PC)).
  $879E,$01 Tile ID: #R$9BF2(#N$11).
N $879F Command #N$01: Skip tiles.
  $879F,$01 Command (#N$01).
  $87A0,$01 Skip count: #N(#PEEK(#PC)).
N $87A1 Command #N$02: Draw repeated tile.
  $87A1,$01 Command (#N$02).
  $87A2,$01 Repeat count: #N(#PEEK(#PC)).
  $87A3,$01 Tile ID: #R$A27A(#N$E2).
N $87A4 Command #N$01: Skip tiles.
  $87A4,$01 Command (#N$01).
  $87A5,$01 Skip count: #N(#PEEK(#PC)).
  $87A6,$01 Tile ID: #R$9C2A(#N$18).
  $87A7,$01 Tile ID: #R$9C22(#N$17).
  $87A8,$01 Tile ID: #R$9C32(#N$19).
N $87A9 Command #N$01: Skip tiles.
  $87A9,$01 Command (#N$01).
  $87AA,$01 Skip count: #N(#PEEK(#PC)).
  $87AB,$01 Tile ID: #R$9BFA(#N$12).
N $87AC Command #N$01: Skip tiles.
  $87AC,$01 Command (#N$01).
  $87AD,$01 Skip count: #N(#PEEK(#PC)).
  $87AE,$01 Tile ID: #R$A00A(#N$94).
  $87AF,$01 Tile ID: #R$A002(#N$93).
  $87B0,$01 Tile ID: #R$A00A(#N$94).
  $87B1,$01 Tile ID: #R$A002(#N$93).
  $87B2,$01 Tile ID: #R$A00A(#N$94).
  $87B3,$01 Tile ID: #R$A002(#N$93).
  $87B4,$01 Tile ID: #R$A00A(#N$94).
  $87B5,$01 Tile ID: #R$A002(#N$93).
N $87B6 Command #N$01: Skip tiles.
  $87B6,$01 Command (#N$01).
  $87B7,$01 Skip count: #N(#PEEK(#PC)).
  $87B8,$01 Tile ID: #R$9C02(#N$13).
  $87B9,$01 Tile ID: #R$9C02(#N$13).
N $87BA Command #N$01: Skip tiles.
  $87BA,$01 Command (#N$01).
  $87BB,$01 Skip count: #N(#PEEK(#PC)).
  $87BC,$01 Tile ID: #R$9FFA(#N$92).
  $87BD,$01 Tile ID: #R$A0CA(#N$AC).
N $87BE Command #N$02: Draw repeated tile.
  $87BE,$01 Command (#N$02).
  $87BF,$01 Repeat count: #N(#PEEK(#PC)).
  $87C0,$01 Tile ID: #R$9FFA(#N$92).
  $87C1,$01 Tile ID: #R$A0CA(#N$AC).
  $87C2,$01 Tile ID: #R$A002(#N$93).
  $87C3,$01 Tile ID: #R$A00A(#N$94).
N $87C4 Command #N$01: Skip tiles.
  $87C4,$01 Command (#N$01).
  $87C5,$01 Skip count: #N(#PEEK(#PC)).
N $87C6 Command #N$02: Draw repeated tile.
  $87C6,$01 Command (#N$02).
  $87C7,$01 Repeat count: #N(#PEEK(#PC)).
  $87C8,$01 Tile ID: #R$9FFA(#N$92).
  $87C9,$01 Tile ID: #R$A0CA(#N$AC).
  $87CA,$01 Tile ID: #R$A002(#N$93).
  $87CB,$01 Tile ID: #R$A002(#N$93).
N $87CC Command #N$01: Skip tiles.
  $87CC,$01 Command (#N$01).
  $87CD,$01 Skip count: #N(#PEEK(#PC)).
  $87CE,$01 Tile ID: #R$9BB2(#N$09).
  $87CF,$01 Tile ID: #R$9BBA(#N$0A).
N $87D0 Command #N$01: Skip tiles.
  $87D0,$01 Command (#N$01).
  $87D1,$01 Skip count: #N(#PEEK(#PC)).
  $87D2,$01 Tile ID: #R$A0BA(#N$AA).
  $87D3,$01 Tile ID: #R$A002(#N$93).
  $87D4,$01 Tile ID: #R$A00A(#N$94).
N $87D5 Command #N$01: Skip tiles.
  $87D5,$01 Command (#N$01).
  $87D6,$01 Skip count: #N(#PEEK(#PC)).
  $87D7,$01 Tile ID: #R$A032(#N$99).
  $87D8,$01 Tile ID: #R$A0E2(#N$AF).
  $87D9,$01 Tile ID: #R$A0D2(#N$AD).
  $87DA,$01 Tile ID: #R$A33A(#N$FA).
  $87DB,$01 Tile ID: #R$A032(#N$99).
  $87DC,$01 Tile ID: #R$A0D2(#N$AD).
  $87DD,$01 Tile ID: #R$A002(#N$93).
  $87DE,$01 Tile ID: #R$A002(#N$93).
N $87DF Command #N$01: Skip tiles.
  $87DF,$01 Command (#N$01).
  $87E0,$01 Skip count: #N(#PEEK(#PC)).
  $87E1,$01 Tile ID: #R$A002(#N$93).
  $87E2,$01 Tile ID: #R$A00A(#N$94).
  $87E3,$01 Tile ID: #R$A002(#N$93).
  $87E4,$01 Tile ID: #R$A00A(#N$94).
  $87E5,$01 Tile ID: #R$A002(#N$93).
  $87E6,$01 Tile ID: #R$A00A(#N$94).
  $87E7,$01 Tile ID: #R$A002(#N$93).
  $87E8,$01 Tile ID: #R$A00A(#N$94).
N $87E9 Command #N$01: Skip tiles.
  $87E9,$01 Command (#N$01).
  $87EA,$01 Skip count: #N(#PEEK(#PC)).
  $87EB,$01 Tile ID: #R$A30A(#N$F4).
N $87EC Command #N$01: Skip tiles.
  $87EC,$01 Command (#N$01).
  $87ED,$01 Skip count: #N(#PEEK(#PC)).
  $87EE,$01 Tile ID: #R$A30A(#N$F4).
N $87EF Command #N$01: Skip tiles.
  $87EF,$01 Command (#N$01).
  $87F0,$01 Skip count: #N(#PEEK(#PC)).
  $87F1,$01 Tile ID: #R$A30A(#N$F4).
N $87F2 Command #N$01: Skip tiles.
  $87F2,$01 Command (#N$01).
  $87F3,$01 Skip count: #N(#PEEK(#PC)).
  $87F4,$01 Tile ID: #R$A30A(#N$F4).
N $87F5 Command #N$01: Skip tiles.
  $87F5,$01 Command (#N$01).
  $87F6,$01 Skip count: #N(#PEEK(#PC)).
  $87F7,$01 Tile ID: #R$A30A(#N$F4).
N $87F8 Command #N$01: Skip tiles.
  $87F8,$01 Command (#N$01).
  $87F9,$01 Skip count: #N(#PEEK(#PC)).
  $87FA,$01 Tile ID: #R$A102(#N$B3).
  $87FB,$01 Tile ID: #R$A10A(#N$B4).
  $87FC,$01 Tile ID: #R$A112(#N$B5).
N $87FD Command #N$01: Skip tiles.
  $87FD,$01 Command (#N$01).
  $87FE,$01 Skip count: #N(#PEEK(#PC)).
  $87FF,$01 Tile ID: #R$A30A(#N$F4).
N $8800 Command #N$01: Skip tiles.
  $8800,$01 Command (#N$01).
  $8801,$01 Skip count: #N(#PEEK(#PC)).
  $8802,$01 Tile ID: #R$A00A(#N$94).
  $8803,$01 Tile ID: #R$A002(#N$93).
  $8804,$01 Tile ID: #R$A00A(#N$94).
  $8805,$01 Tile ID: #R$A002(#N$93).
  $8806,$01 Tile ID: #R$A00A(#N$94).
  $8807,$01 Tile ID: #R$A002(#N$93).
  $8808,$01 Tile ID: #R$A00A(#N$94).
  $8809,$01 Tile ID: #R$A002(#N$93).
  $880A,$01 Tile ID: #R$A302(#N$F3).
  $880B,$01 Tile ID: #R$A2FA(#N$F2).
  $880C,$01 Tile ID: #R$A302(#N$F3).
  $880D,$01 Tile ID: #R$A302(#N$F3).
  $880E,$01 Tile ID: #R$A2FA(#N$F2).
  $880F,$01 Tile ID: #R$A302(#N$F3).
  $8810,$01 Tile ID: #R$A302(#N$F3).
  $8811,$01 Tile ID: #R$A2FA(#N$F2).
  $8812,$01 Tile ID: #R$A302(#N$F3).
  $8813,$01 Tile ID: #R$A302(#N$F3).
  $8814,$01 Tile ID: #R$A2FA(#N$F2).
  $8815,$01 Tile ID: #R$A302(#N$F3).
  $8816,$01 Tile ID: #R$A302(#N$F3).
  $8817,$01 Tile ID: #R$A2FA(#N$F2).
  $8818,$01 Tile ID: #R$A302(#N$F3).
  $8819,$01 Tile ID: #R$A302(#N$F3).
  $881A,$01 Tile ID: #R$A11A(#N$B6).
  $881B,$01 Tile ID: #R$A122(#N$B7).
  $881C,$01 Tile ID: #R$A12A(#N$B8).
N $881D Command #N$02: Draw repeated tile.
  $881D,$01 Command (#N$02).
  $881E,$01 Repeat count: #N(#PEEK(#PC)).
  $881F,$01 Tile ID: #R$A302(#N$F3).
  $8820,$01 Tile ID: #R$A2FA(#N$F2).
  $8821,$01 Tile ID: #R$A302(#N$F3).
N $8822 Command #N$02: Draw repeated tile.
  $8822,$01 Command (#N$02).
  $8823,$01 Repeat count: #N(#PEEK(#PC)).
  $8824,$01 Tile ID: #R$9FFA(#N$92).
  $8825,$01 Tile ID: #R$A0DA(#N$AE).
  $8826,$01 Tile ID: #R$A0CA(#N$AC).
  $8827,$01 Tile ID: #R$A002(#N$93).
  $8828,$01 Tile ID: #R$A00A(#N$94).
N $8829 Command #N$01: Skip tiles.
  $8829,$01 Command (#N$01).
  $882A,$01 Skip count: #N(#PEEK(#PC)).
  $882B,$01 Tile ID: #R$A32A(#N$F8).
  $882C,$01 Tile ID: #R$9C62(#N$1F).
N $882D Command #N$02: Draw repeated tile.
  $882D,$01 Command (#N$02).
  $882E,$01 Repeat count: #N(#PEEK(#PC)).
  $882F,$01 Tile ID: #R$A142(#N$BB).
N $8830 Command #N$02: Draw repeated tile.
  $8830,$01 Command (#N$02).
  $8831,$01 Repeat count: #N(#PEEK(#PC)).
  $8832,$01 Tile ID: #R$9FFA(#N$92).
  $8833,$01 Tile ID: #R$A0B2(#N$A9).
  $8834,$01 Tile ID: #R$A0BA(#N$AA).
  $8835,$01 Tile ID: #R$A002(#N$93).
  $8836,$01 Tile ID: #R$A002(#N$93).
N $8837 Command #N$01: Skip tiles.
  $8837,$01 Command (#N$01).
  $8838,$01 Skip count: #N(#PEEK(#PC)).
  $8839,$01 Tile ID: #R$A032(#N$99).
  $883A,$01 Tile ID: #R$A032(#N$99).
  $883B,$01 Tile ID: #R$A16A(#N$C0).
N $883C Command #N$01: Skip tiles.
  $883C,$01 Command (#N$01).
  $883D,$01 Skip count: #N(#PEEK(#PC)).
  $883E,$01 Tile ID: #R$A0B2(#N$A9).
  $883F,$01 Tile ID: #R$A0BA(#N$AA).
  $8840,$01 Tile ID: #R$A002(#N$93).
  $8841,$01 Tile ID: #R$A00A(#N$94).
N $8842 Command #N$01: Skip tiles.
  $8842,$01 Command (#N$01).
  $8843,$01 Skip count: #N(#PEEK(#PC)).
  $8844,$01 Tile ID: #R$A262(#N$DF).
  $8845,$01 Tile ID: #R$A25A(#N$DE).
N $8846 Command #N$01: Skip tiles.
  $8846,$01 Command (#N$01).
  $8847,$01 Skip count: #N(#PEEK(#PC)).
  $8848,$01 Tile ID: #R$A362(#N$FF).
  $8849,$01 Tile ID: #R$A032(#N$99).
  $884A,$01 Tile ID: #R$A362(#N$FF).
  $884B,$01 Tile ID: #R$A032(#N$99).
  $884C,$01 Tile ID: #R$A0E2(#N$AF).
  $884D,$01 Tile ID: #R$A0D2(#N$AD).
  $884E,$01 Tile ID: #R$A002(#N$93).
  $884F,$01 Tile ID: #R$A002(#N$93).
  $8850,$01 Tile ID: #R$A14A(#N$BC).
N $8851 Command #N$01: Skip tiles.
  $8851,$01 Command (#N$01).
  $8852,$01 Skip count: #N(#PEEK(#PC)).
  $8853,$01 Tile ID: #R$A02A(#N$98).
  $8854,$01 Tile ID: #R$A26A(#N$E0).
N $8855 Command #N$01: Skip tiles.
  $8855,$01 Command (#N$01).
  $8856,$01 Skip count: #N(#PEEK(#PC)).
  $8857,$01 Tile ID: #R$A002(#N$93).
  $8858,$01 Tile ID: #R$A00A(#N$94).
  $8859,$01 Tile ID: #R$A002(#N$93).
  $885A,$01 Tile ID: #R$A00A(#N$94).
  $885B,$01 Tile ID: #R$A002(#N$93).
  $885C,$01 Tile ID: #R$A00A(#N$94).
  $885D,$01 Tile ID: #R$A002(#N$93).
  $885E,$01 Tile ID: #R$A00A(#N$94).
  $885F,$01 Tile ID: #R$A15A(#N$BE).
  $8860,$01 Tile ID: #R$A14A(#N$BC).
N $8861 Command #N$01: Skip tiles.
  $8861,$01 Command (#N$01).
  $8862,$01 Skip count: #N(#PEEK(#PC)).
  $8863,$01 Tile ID: #R$A262(#N$DF).
  $8864,$01 Tile ID: #R$A25A(#N$DE).
N $8865 Command #N$01: Skip tiles.
  $8865,$01 Command (#N$01).
  $8866,$01 Skip count: #N(#PEEK(#PC)).
  $8867,$01 Tile ID: #R$A00A(#N$94).
  $8868,$01 Tile ID: #R$A002(#N$93).
  $8869,$01 Tile ID: #R$A00A(#N$94).
  $886A,$01 Tile ID: #R$A002(#N$93).
  $886B,$01 Tile ID: #R$A00A(#N$94).
  $886C,$01 Tile ID: #R$A002(#N$93).
  $886D,$01 Tile ID: #R$A00A(#N$94).
  $886E,$01 Tile ID: #R$A002(#N$93).
N $886F Command #N$01: Skip tiles.
  $886F,$01 Command (#N$01).
  $8870,$01 Skip count: #N(#PEEK(#PC)).
  $8871,$01 Tile ID: #R$A15A(#N$BE).
  $8872,$01 Tile ID: #R$A14A(#N$BC).
N $8873 Command #N$01: Skip tiles.
  $8873,$01 Command (#N$01).
  $8874,$01 Skip count: #N(#PEEK(#PC)).
  $8875,$01 Tile ID: #R$A02A(#N$98).
  $8876,$01 Tile ID: #R$A26A(#N$E0).
N $8877 Command #N$01: Skip tiles.
  $8877,$01 Command (#N$01).
  $8878,$01 Skip count: #N(#PEEK(#PC)).
N $8879 Command #N$02: Draw repeated tile.
  $8879,$01 Command (#N$02).
  $887A,$01 Repeat count: #N(#PEEK(#PC)).
  $887B,$01 Tile ID: #R$A00A(#N$94).
  $887C,$01 Tile ID: #R$A01A(#N$96).
  $887D,$01 Tile ID: #R$A14A(#N$BC).
N $887E Command #N$01: Skip tiles.
  $887E,$01 Command (#N$01).
  $887F,$01 Skip count: #N(#PEEK(#PC)).
  $8880,$01 Tile ID: #R$9C82(#N$23).
N $8881 Command #N$01: Skip tiles.
  $8881,$01 Command (#N$01).
  $8882,$01 Skip count: #N(#PEEK(#PC)).
N $8883 Command #N$02: Draw repeated tile.
  $8883,$01 Command (#N$02).
  $8884,$01 Repeat count: #N(#PEEK(#PC)).
  $8885,$01 Tile ID: #R$9C82(#N$23).
N $8886 Command #N$01: Skip tiles.
  $8886,$01 Command (#N$01).
  $8887,$01 Skip count: #N(#PEEK(#PC)).
  $8888,$01 Tile ID: #R$9C82(#N$23).
  $8889,$01 Tile ID: #R$9C82(#N$23).
N $888A Command #N$01: Skip tiles.
  $888A,$01 Command (#N$01).
  $888B,$01 Skip count: #N(#PEEK(#PC)).
  $888C,$01 Tile ID: #R$9C82(#N$23).
  $888D,$01 Tile ID: #R$9C82(#N$23).
N $888E Command #N$01: Skip tiles.
  $888E,$01 Command (#N$01).
  $888F,$01 Skip count: #N(#PEEK(#PC)).
  $8890,$01 Tile ID: #R$9C8A(#N$24).
  $8891,$01 Tile ID: #R$9C92(#N$25).
  $8892,$01 Tile ID: #R$9C9A(#N$26).
N $8893 Command #N$02: Draw repeated tile.
  $8893,$01 Command (#N$02).
  $8894,$01 Repeat count: #N(#PEEK(#PC)).
  $8895,$01 Tile ID: #R$9C92(#N$25).
  $8896,$01 Tile ID: #R$9CA2(#N$27).
  $8897,$01 Tile ID: #R$9C8A(#N$24).
  $8898,$01 Tile ID: #R$9C92(#N$25).
  $8899,$01 Tile ID: #R$9C92(#N$25).
  $889A,$01 Tile ID: #R$9CA2(#N$27).
N $889B Command #N$01: Skip tiles.
  $889B,$01 Command (#N$01).
  $889C,$01 Skip count: #N(#PEEK(#PC)).
  $889D,$01 Tile ID: #R$9C8A(#N$24).
  $889E,$01 Tile ID: #R$9C92(#N$25).
  $889F,$01 Tile ID: #R$9C92(#N$25).
  $88A0,$01 Tile ID: #R$9CA2(#N$27).
N $88A1 Command #N$01: Skip tiles.
  $88A1,$01 Command (#N$01).
  $88A2,$01 Skip count: #N(#PEEK(#PC)).
N $88A3 Command #N$03: Fill attribute buffer.
  $88A3,$01 Command (#N$03).
  $88A4,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $88A5 Attribute overlay: skip.
  $88A5,$01 Opcode (#N$12).
  $88A6,$01 Skip count: #N(#PEEK(#PC)).
N $88A7 Attribute overlay: repeat colour.
  $88A7,$01 Opcode (#N$1B).
  $88A8,$01 Repeat count: #N(#PEEK(#PC)).
  $88A9,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88AA Attribute overlay: skip.
  $88AA,$01 Opcode (#N$12).
  $88AB,$01 Skip count: #N(#PEEK(#PC)).
N $88AC Attribute overlay: repeat colour.
  $88AC,$01 Opcode (#N$1B).
  $88AD,$01 Repeat count: #N(#PEEK(#PC)).
  $88AE,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88AF Attribute overlay: skip.
  $88AF,$01 Opcode (#N$12).
  $88B0,$01 Skip count: #N(#PEEK(#PC)).
  $88B1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88B2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88B3 Attribute overlay: skip.
  $88B3,$01 Opcode (#N$12).
  $88B4,$01 Skip count: #N(#PEEK(#PC)).
N $88B5 Attribute overlay: repeat colour.
  $88B5,$01 Opcode (#N$1B).
  $88B6,$01 Repeat count: #N(#PEEK(#PC)).
  $88B7,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88B8 Attribute overlay: skip.
  $88B8,$01 Opcode (#N$12).
  $88B9,$01 Skip count: #N(#PEEK(#PC)).
  $88BA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88BB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88BC Attribute overlay: skip.
  $88BC,$01 Opcode (#N$12).
  $88BD,$01 Skip count: #N(#PEEK(#PC)).
  $88BE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88BF Attribute overlay: skip.
  $88BF,$01 Opcode (#N$12).
  $88C0,$01 Skip count: #N(#PEEK(#PC)).
N $88C1 Attribute overlay: repeat colour.
  $88C1,$01 Opcode (#N$1B).
  $88C2,$01 Repeat count: #N(#PEEK(#PC)).
  $88C3,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88C4 Attribute overlay: skip.
  $88C4,$01 Opcode (#N$12).
  $88C5,$01 Skip count: #N(#PEEK(#PC)).
N $88C6 Attribute overlay: repeat colour.
  $88C6,$01 Opcode (#N$1B).
  $88C7,$01 Repeat count: #N(#PEEK(#PC)).
  $88C8,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88C9 Attribute overlay: skip.
  $88C9,$01 Opcode (#N$12).
  $88CA,$01 Skip count: #N(#PEEK(#PC)).
N $88CB Attribute overlay: repeat colour.
  $88CB,$01 Opcode (#N$1B).
  $88CC,$01 Repeat count: #N(#PEEK(#PC)).
  $88CD,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88CE Attribute overlay: skip.
  $88CE,$01 Opcode (#N$12).
  $88CF,$01 Skip count: #N(#PEEK(#PC)).
  $88D0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88D1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88D2 Attribute overlay: skip.
  $88D2,$01 Opcode (#N$12).
  $88D3,$01 Skip count: #N(#PEEK(#PC)).
N $88D4 Attribute overlay: repeat colour.
  $88D4,$01 Opcode (#N$1B).
  $88D5,$01 Repeat count: #N(#PEEK(#PC)).
  $88D6,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88D7 Attribute overlay: skip.
  $88D7,$01 Opcode (#N$12).
  $88D8,$01 Skip count: #N(#PEEK(#PC)).
N $88D9 Attribute overlay: repeat colour.
  $88D9,$01 Opcode (#N$1B).
  $88DA,$01 Repeat count: #N(#PEEK(#PC)).
  $88DB,$01 Colour: #COLOUR(#PEEK(#PC)).
  $88DC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88DD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88DE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88DF Attribute overlay: skip.
  $88DF,$01 Opcode (#N$12).
  $88E0,$01 Skip count: #N(#PEEK(#PC)).
N $88E1 Attribute overlay: repeat colour.
  $88E1,$01 Opcode (#N$1B).
  $88E2,$01 Repeat count: #N(#PEEK(#PC)).
  $88E3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $88E4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88E5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88E6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88E7 Attribute overlay: skip.
  $88E7,$01 Opcode (#N$12).
  $88E8,$01 Skip count: #N(#PEEK(#PC)).
N $88E9 Attribute overlay: repeat colour.
  $88E9,$01 Opcode (#N$1B).
  $88EA,$01 Repeat count: #N(#PEEK(#PC)).
  $88EB,$01 Colour: #COLOUR(#PEEK(#PC)).
  $88EC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88ED,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88EF Attribute overlay: skip.
  $88EF,$01 Opcode (#N$12).
  $88F0,$01 Skip count: #N(#PEEK(#PC)).
  $88F1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $88F8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $88F9 Attribute overlay: skip.
  $88F9,$01 Opcode (#N$12).
  $88FA,$01 Skip count: #N(#PEEK(#PC)).
N $88FB Attribute overlay: repeat colour.
  $88FB,$01 Opcode (#N$1B).
  $88FC,$01 Repeat count: #N(#PEEK(#PC)).
  $88FD,$01 Colour: #COLOUR(#PEEK(#PC)).
N $88FE Attribute overlay: skip.
  $88FE,$01 Opcode (#N$12).
  $88FF,$01 Skip count: #N(#PEEK(#PC)).
N $8900 Attribute overlay: repeat colour.
  $8900,$01 Opcode (#N$1B).
  $8901,$01 Repeat count: #N(#PEEK(#PC)).
  $8902,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8903 Attribute overlay: skip.
  $8903,$01 Opcode (#N$12).
  $8904,$01 Skip count: #N(#PEEK(#PC)).
N $8905 Attribute overlay: repeat colour.
  $8905,$01 Opcode (#N$1B).
  $8906,$01 Repeat count: #N(#PEEK(#PC)).
  $8907,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8908,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8909,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $890A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $890B Attribute overlay: repeat colour.
  $890B,$01 Opcode (#N$1B).
  $890C,$01 Repeat count: #N(#PEEK(#PC)).
  $890D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $890E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $890F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8910 Attribute overlay: repeat colour.
  $8910,$01 Opcode (#N$1B).
  $8911,$01 Repeat count: #N(#PEEK(#PC)).
  $8912,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8913 Attribute overlay: repeat colour.
  $8913,$01 Opcode (#N$1B).
  $8914,$01 Repeat count: #N(#PEEK(#PC)).
  $8915,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8916 Attribute overlay: repeat colour.
  $8916,$01 Opcode (#N$1B).
  $8917,$01 Repeat count: #N(#PEEK(#PC)).
  $8918,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8919,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $891A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $891B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $891C Attribute overlay: repeat colour.
  $891C,$01 Opcode (#N$1B).
  $891D,$01 Repeat count: #N(#PEEK(#PC)).
  $891E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $891F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8920,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8921 Attribute overlay: repeat colour.
  $8921,$01 Opcode (#N$1B).
  $8922,$01 Repeat count: #N(#PEEK(#PC)).
  $8923,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8924,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8925,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8926,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8927,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8928,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8929,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $892A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $892B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $892C Attribute overlay: repeat colour.
  $892C,$01 Opcode (#N$1B).
  $892D,$01 Repeat count: #N(#PEEK(#PC)).
  $892E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $892F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8930,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8931 Attribute overlay: repeat colour.
  $8931,$01 Opcode (#N$1B).
  $8932,$01 Repeat count: #N(#PEEK(#PC)).
  $8933,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8934,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8935,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8936,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8937,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8938,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8939,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $893A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $893B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $893C Attribute overlay: repeat colour.
  $893C,$01 Opcode (#N$1B).
  $893D,$01 Repeat count: #N(#PEEK(#PC)).
  $893E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $893F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8940,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8941 Attribute overlay: repeat colour.
  $8941,$01 Opcode (#N$1B).
  $8942,$01 Repeat count: #N(#PEEK(#PC)).
  $8943,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8944 Attribute overlay: repeat colour.
  $8944,$01 Opcode (#N$1B).
  $8945,$01 Repeat count: #N(#PEEK(#PC)).
  $8946,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8947,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8948,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8949,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $894A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $894B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $894C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $894D Attribute overlay: repeat colour.
  $894D,$01 Opcode (#N$1B).
  $894E,$01 Repeat count: #N(#PEEK(#PC)).
  $894F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8950 Attribute overlay: repeat colour.
  $8950,$01 Opcode (#N$1B).
  $8951,$01 Repeat count: #N(#PEEK(#PC)).
  $8952,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8953,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8954,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8955,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8956,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8957,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8958,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8959 Attribute overlay: repeat colour.
  $8959,$01 Opcode (#N$1B).
  $895A,$01 Repeat count: #N(#PEEK(#PC)).
  $895B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $895C Attribute overlay: repeat colour.
  $895C,$01 Opcode (#N$1B).
  $895D,$01 Repeat count: #N(#PEEK(#PC)).
  $895E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $895F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8960,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8961,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8962,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8963,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8964,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8965,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8966,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8967,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8968,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8969,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $896F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8970 Attribute overlay: repeat colour.
  $8970,$01 Opcode (#N$1B).
  $8971,$01 Repeat count: #N(#PEEK(#PC)).
  $8972,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8973 Attribute overlay: repeat colour.
  $8973,$01 Opcode (#N$1B).
  $8974,$01 Repeat count: #N(#PEEK(#PC)).
  $8975,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8976,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8977 Attribute overlay: repeat colour.
  $8977,$01 Opcode (#N$1B).
  $8978,$01 Repeat count: #N(#PEEK(#PC)).
  $8979,$01 Colour: #COLOUR(#PEEK(#PC)).
  $897A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $897B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $897C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $897D,$01 End of attribute overlay.
  $897E,$01 Terminator.

b $897F Room #N$04
@ $897F label=Room04
D $897F #ROOM$04
N $897F Command #N$01: Skip tiles.
  $897F,$01 Command (#N$01).
  $8980,$01 Skip count: #N(#PEEK(#PC)).
  $8981,$01 Tile ID: #R$9BC2(#N$0B).
  $8982,$01 Tile ID: #R$9BCA(#N$0C).
  $8983,$01 Tile ID: #R$9BD2(#N$0D).
  $8984,$01 Tile ID: #R$9BB2(#N$09).
  $8985,$01 Tile ID: #R$9BBA(#N$0A).
N $8986 Command #N$01: Skip tiles.
  $8986,$01 Command (#N$01).
  $8987,$01 Skip count: #N(#PEEK(#PC)).
  $8988,$01 Tile ID: #R$9BB2(#N$09).
  $8989,$01 Tile ID: #R$9BBA(#N$0A).
  $898A,$01 Tile ID: #R$9BC2(#N$0B).
  $898B,$01 Tile ID: #R$9BCA(#N$0C).
  $898C,$01 Tile ID: #R$9BD2(#N$0D).
N $898D Command #N$01: Skip tiles.
  $898D,$01 Command (#N$01).
  $898E,$01 Skip count: #N(#PEEK(#PC)).
  $898F,$01 Tile ID: #R$9BAA(#N$08).
N $8990 Command #N$01: Skip tiles.
  $8990,$01 Command (#N$01).
  $8991,$01 Skip count: #N(#PEEK(#PC)).
  $8992,$01 Tile ID: #R$9BDA(#N$0E).
  $8993,$01 Tile ID: #R$9BCA(#N$0C).
  $8994,$01 Tile ID: #R$9BCA(#N$0C).
  $8995,$01 Tile ID: #R$9BE2(#N$0F).
N $8996 Command #N$01: Skip tiles.
  $8996,$01 Command (#N$01).
  $8997,$01 Skip count: #N(#PEEK(#PC)).
  $8998,$01 Tile ID: #R$9BAA(#N$08).
N $8999 Command #N$01: Skip tiles.
  $8999,$01 Command (#N$01).
  $899A,$01 Skip count: #N(#PEEK(#PC)).
  $899B,$01 Tile ID: #R$9BDA(#N$0E).
  $899C,$01 Tile ID: #R$9BD2(#N$0D).
  $899D,$01 Tile ID: #R$9C4A(#N$1C).
N $899E Command #N$01: Skip tiles.
  $899E,$01 Command (#N$01).
  $899F,$01 Skip count: #N(#PEEK(#PC)).
  $89A0,$01 Tile ID: #R$9BEA(#N$10).
N $89A1 Command #N$01: Skip tiles.
  $89A1,$01 Command (#N$01).
  $89A2,$01 Skip count: #N(#PEEK(#PC)).
  $89A3,$01 Tile ID: #R$9C4A(#N$1C).
N $89A4 Command #N$01: Skip tiles.
  $89A4,$01 Command (#N$01).
  $89A5,$01 Skip count: #N(#PEEK(#PC)).
  $89A6,$01 Tile ID: #R$9BEA(#N$10).
N $89A7 Command #N$01: Skip tiles.
  $89A7,$01 Command (#N$01).
  $89A8,$01 Skip count: #N(#PEEK(#PC)).
  $89A9,$01 Tile ID: #R$9C42(#N$1B).
N $89AA Command #N$01: Skip tiles.
  $89AA,$01 Command (#N$01).
  $89AB,$01 Skip count: #N(#PEEK(#PC)).
  $89AC,$01 Tile ID: #R$9C0A(#N$14).
N $89AD Command #N$01: Skip tiles.
  $89AD,$01 Command (#N$01).
  $89AE,$01 Skip count: #N(#PEEK(#PC)).
  $89AF,$01 Tile ID: #R$9BF2(#N$11).
N $89B0 Command #N$01: Skip tiles.
  $89B0,$01 Command (#N$01).
  $89B1,$01 Skip count: #N(#PEEK(#PC)).
  $89B2,$01 Tile ID: #R$9C3A(#N$1A).
N $89B3 Command #N$01: Skip tiles.
  $89B3,$01 Command (#N$01).
  $89B4,$01 Skip count: #N(#PEEK(#PC)).
  $89B5,$01 Tile ID: #R$9C0A(#N$14).
N $89B6 Command #N$01: Skip tiles.
  $89B6,$01 Command (#N$01).
  $89B7,$01 Skip count: #N(#PEEK(#PC)).
  $89B8,$01 Tile ID: #R$9BEA(#N$10).
  $89B9,$01 Tile ID: #R$9C02(#N$13).
  $89BA,$01 Tile ID: #R$9C2A(#N$18).
  $89BB,$01 Tile ID: #R$9C22(#N$17).
  $89BC,$01 Tile ID: #R$9C32(#N$19).
  $89BD,$01 Tile ID: #R$9BFA(#N$12).
N $89BE Command #N$01: Skip tiles.
  $89BE,$01 Command (#N$01).
  $89BF,$01 Skip count: #N(#PEEK(#PC)).
  $89C0,$01 Tile ID: #R$9C2A(#N$18).
  $89C1,$01 Tile ID: #R$9C22(#N$17).
  $89C2,$01 Tile ID: #R$9C1A(#N$16).
  $89C3,$01 Tile ID: #R$9C12(#N$15).
  $89C4,$01 Tile ID: #R$9C02(#N$13).
  $89C5,$01 Tile ID: #R$9C02(#N$13).
  $89C6,$01 Tile ID: #R$9C2A(#N$18).
  $89C7,$01 Tile ID: #R$9C22(#N$17).
  $89C8,$01 Tile ID: #R$9C1A(#N$16).
  $89C9,$01 Tile ID: #R$9C12(#N$15).
N $89CA Command #N$01: Skip tiles.
  $89CA,$01 Command (#N$01).
  $89CB,$01 Skip count: #N(#PEEK(#PC)).
  $89CC,$01 Tile ID: #R$A30A(#N$F4).
N $89CD Command #N$01: Skip tiles.
  $89CD,$01 Command (#N$01).
  $89CE,$01 Skip count: #N(#PEEK(#PC)).
  $89CF,$01 Tile ID: #R$A30A(#N$F4).
N $89D0 Command #N$01: Skip tiles.
  $89D0,$01 Command (#N$01).
  $89D1,$01 Skip count: #N(#PEEK(#PC)).
  $89D2,$01 Tile ID: #R$A30A(#N$F4).
N $89D3 Command #N$01: Skip tiles.
  $89D3,$01 Command (#N$01).
  $89D4,$01 Skip count: #N(#PEEK(#PC)).
  $89D5,$01 Tile ID: #R$A30A(#N$F4).
N $89D6 Command #N$01: Skip tiles.
  $89D6,$01 Command (#N$01).
  $89D7,$01 Skip count: #N(#PEEK(#PC)).
  $89D8,$01 Tile ID: #R$A302(#N$F3).
  $89D9,$01 Tile ID: #R$A2FA(#N$F2).
  $89DA,$01 Tile ID: #R$A302(#N$F3).
  $89DB,$01 Tile ID: #R$A302(#N$F3).
  $89DC,$01 Tile ID: #R$A2FA(#N$F2).
  $89DD,$01 Tile ID: #R$A302(#N$F3).
  $89DE,$01 Tile ID: #R$A302(#N$F3).
  $89DF,$01 Tile ID: #R$A2FA(#N$F2).
  $89E0,$01 Tile ID: #R$A302(#N$F3).
  $89E1,$01 Tile ID: #R$A302(#N$F3).
  $89E2,$01 Tile ID: #R$A25A(#N$DE).
N $89E3 Command #N$01: Skip tiles.
  $89E3,$01 Command (#N$01).
  $89E4,$01 Skip count: #N(#PEEK(#PC)).
N $89E5 Command #N$02: Draw repeated tile.
  $89E5,$01 Command (#N$02).
  $89E6,$01 Repeat count: #N(#PEEK(#PC)).
  $89E7,$01 Tile ID: #R$A142(#N$BB).
  $89E8,$01 Tile ID: #R$9C5A(#N$1E).
  $89E9,$01 Tile ID: #R$A332(#N$F9).
N $89EA Command #N$01: Skip tiles.
  $89EA,$01 Command (#N$01).
  $89EB,$01 Skip count: #N(#PEEK(#PC)).
  $89EC,$01 Tile ID: #R$A02A(#N$98).
  $89ED,$01 Tile ID: #R$A26A(#N$E0).
N $89EE Command #N$01: Skip tiles.
  $89EE,$01 Command (#N$01).
  $89EF,$01 Skip count: #N(#PEEK(#PC)).
  $89F0,$01 Tile ID: #R$A262(#N$DF).
  $89F1,$01 Tile ID: #R$A25A(#N$DE).
N $89F2 Command #N$01: Skip tiles.
  $89F2,$01 Command (#N$01).
  $89F3,$01 Skip count: #N(#PEEK(#PC)).
  $89F4,$01 Tile ID: #R$A02A(#N$98).
  $89F5,$01 Tile ID: #R$A26A(#N$E0).
N $89F6 Command #N$01: Skip tiles.
  $89F6,$01 Command (#N$01).
  $89F7,$01 Skip count: #N(#PEEK(#PC)).
  $89F8,$01 Tile ID: #R$9BB2(#N$09).
  $89F9,$01 Tile ID: #R$9BBA(#N$0A).
  $89FA,$01 Tile ID: #R$9BB2(#N$09).
  $89FB,$01 Tile ID: #R$9BBA(#N$0A).
N $89FC Command #N$01: Skip tiles.
  $89FC,$01 Command (#N$01).
  $89FD,$01 Skip count: #N(#PEEK(#PC)).
  $89FE,$01 Tile ID: #R$A262(#N$DF).
  $89FF,$01 Tile ID: #R$A25A(#N$DE).
N $8A00 Command #N$01: Skip tiles.
  $8A00,$01 Command (#N$01).
  $8A01,$01 Skip count: #N(#PEEK(#PC)).
  $8A02,$01 Tile ID: #R$A02A(#N$98).
  $8A03,$01 Tile ID: #R$A26A(#N$E0).
N $8A04 Command #N$01: Skip tiles.
  $8A04,$01 Command (#N$01).
  $8A05,$01 Skip count: #N(#PEEK(#PC)).
  $8A06,$01 Tile ID: #R$A0F2(#N$B1).
  $8A07,$01 Tile ID: #R$9C1A(#N$16).
N $8A08 Command #N$02: Draw repeated tile.
  $8A08,$01 Command (#N$02).
  $8A09,$01 Repeat count: #N(#PEEK(#PC)).
  $8A0A,$01 Tile ID: #R$9C22(#N$17).
  $8A0B,$01 Tile ID: #R$9C1A(#N$16).
  $8A0C,$01 Tile ID: #R$9C22(#N$17).
  $8A0D,$01 Tile ID: #R$9C62(#N$1F).
N $8A0E Command #N$01: Skip tiles.
  $8A0E,$01 Command (#N$01).
  $8A0F,$01 Skip count: #N(#PEEK(#PC)).
  $8A10,$01 Tile ID: #R$A02A(#N$98).
  $8A11,$01 Tile ID: #R$A26A(#N$E0).
N $8A12 Command #N$01: Skip tiles.
  $8A12,$01 Command (#N$01).
  $8A13,$01 Skip count: #N(#PEEK(#PC)).
  $8A14,$01 Tile ID: #R$A262(#N$DF).
  $8A15,$01 Tile ID: #R$A25A(#N$DE).
N $8A16 Command #N$01: Skip tiles.
  $8A16,$01 Command (#N$01).
  $8A17,$01 Skip count: #N(#PEEK(#PC)).
  $8A18,$01 Tile ID: #R$9C5A(#N$1E).
  $8A19,$01 Tile ID: #R$9BFA(#N$12).
N $8A1A Command #N$01: Skip tiles.
  $8A1A,$01 Command (#N$01).
  $8A1B,$01 Skip count: #N(#PEEK(#PC)).
  $8A1C,$01 Tile ID: #R$9C2A(#N$18).
  $8A1D,$01 Tile ID: #R$9C22(#N$17).
N $8A1E Command #N$01: Skip tiles.
  $8A1E,$01 Command (#N$01).
  $8A1F,$01 Skip count: #N(#PEEK(#PC)).
  $8A20,$01 Tile ID: #R$9BDA(#N$0E).
  $8A21,$01 Tile ID: #R$9BE2(#N$0F).
N $8A22 Command #N$01: Skip tiles.
  $8A22,$01 Command (#N$01).
  $8A23,$01 Skip count: #N(#PEEK(#PC)).
  $8A24,$01 Tile ID: #R$A262(#N$DF).
  $8A25,$01 Tile ID: #R$A25A(#N$DE).
N $8A26 Command #N$01: Skip tiles.
  $8A26,$01 Command (#N$01).
  $8A27,$01 Skip count: #N(#PEEK(#PC)).
  $8A28,$01 Tile ID: #R$9C82(#N$23).
N $8A29 Command #N$01: Skip tiles.
  $8A29,$01 Command (#N$01).
  $8A2A,$01 Skip count: #N(#PEEK(#PC)).
  $8A2B,$01 Tile ID: #R$A0F2(#N$B1).
N $8A2C Command #N$01: Skip tiles.
  $8A2C,$01 Command (#N$01).
  $8A2D,$01 Skip count: #N(#PEEK(#PC)).
  $8A2E,$01 Tile ID: #R$9BFA(#N$12).
N $8A2F Command #N$01: Skip tiles.
  $8A2F,$01 Command (#N$01).
  $8A30,$01 Skip count: #N(#PEEK(#PC)).
  $8A31,$01 Tile ID: #R$9C92(#N$25).
  $8A32,$01 Tile ID: #R$A132(#N$B9).
  $8A33,$01 Tile ID: #R$A13A(#N$BA).
N $8A34 Command #N$01: Skip tiles.
  $8A34,$01 Command (#N$01).
  $8A35,$01 Skip count: #N(#PEEK(#PC)).
  $8A36,$01 Tile ID: #R$9C2A(#N$18).
  $8A37,$01 Tile ID: #R$9C22(#N$17).
  $8A38,$01 Tile ID: #R$A0FA(#N$B2).
N $8A39 Command #N$01: Skip tiles.
  $8A39,$01 Command (#N$01).
  $8A3A,$01 Skip count: #N(#PEEK(#PC)).
N $8A3B Command #N$02: Draw repeated tile.
  $8A3B,$01 Command (#N$02).
  $8A3C,$01 Repeat count: #N(#PEEK(#PC)).
  $8A3D,$01 Tile ID: #R$9C82(#N$23).
N $8A3E Command #N$01: Skip tiles.
  $8A3E,$01 Command (#N$01).
  $8A3F,$01 Skip count: #N(#PEEK(#PC)).
  $8A40,$01 Tile ID: #R$9C8A(#N$24).
  $8A41,$01 Tile ID: #R$9C92(#N$25).
  $8A42,$01 Tile ID: #R$9CA2(#N$27).
  $8A43,$01 Tile ID: #R$9C5A(#N$1E).
  $8A44,$01 Tile ID: #R$9BFA(#N$12).
N $8A45 Command #N$01: Skip tiles.
  $8A45,$01 Command (#N$01).
  $8A46,$01 Skip count: #N(#PEEK(#PC)).
  $8A47,$01 Tile ID: #R$A132(#N$B9).
  $8A48,$01 Tile ID: #R$A13A(#N$BA).
N $8A49 Command #N$01: Skip tiles.
  $8A49,$01 Command (#N$01).
  $8A4A,$01 Skip count: #N(#PEEK(#PC)).
  $8A4B,$01 Tile ID: #R$A132(#N$B9).
  $8A4C,$01 Tile ID: #R$A13A(#N$BA).
  $8A4D,$01 Tile ID: #R$9C92(#N$25).
N $8A4E Command #N$01: Skip tiles.
  $8A4E,$01 Command (#N$01).
  $8A4F,$01 Skip count: #N(#PEEK(#PC)).
  $8A50,$01 Tile ID: #R$9C8A(#N$24).
N $8A51 Command #N$02: Draw repeated tile.
  $8A51,$01 Command (#N$02).
  $8A52,$01 Repeat count: #N(#PEEK(#PC)).
  $8A53,$01 Tile ID: #R$9C92(#N$25).
  $8A54,$01 Tile ID: #R$9CA2(#N$27).
N $8A55 Command #N$01: Skip tiles.
  $8A55,$01 Command (#N$01).
  $8A56,$01 Skip count: #N(#PEEK(#PC)).
N $8A57 Command #N$03: Fill attribute buffer.
  $8A57,$01 Command (#N$03).
  $8A58,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $8A59 Attribute overlay: skip.
  $8A59,$01 Opcode (#N$12).
  $8A5A,$01 Skip count: #N(#PEEK(#PC)).
N $8A5B Attribute overlay: repeat colour.
  $8A5B,$01 Opcode (#N$1B).
  $8A5C,$01 Repeat count: #N(#PEEK(#PC)).
  $8A5D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A5E Attribute overlay: skip.
  $8A5E,$01 Opcode (#N$12).
  $8A5F,$01 Skip count: #N(#PEEK(#PC)).
N $8A60 Attribute overlay: repeat colour.
  $8A60,$01 Opcode (#N$1B).
  $8A61,$01 Repeat count: #N(#PEEK(#PC)).
  $8A62,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A63 Attribute overlay: skip.
  $8A63,$01 Opcode (#N$12).
  $8A64,$01 Skip count: #N(#PEEK(#PC)).
N $8A65 Attribute overlay: repeat colour.
  $8A65,$01 Opcode (#N$1B).
  $8A66,$01 Repeat count: #N(#PEEK(#PC)).
  $8A67,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A68 Attribute overlay: skip.
  $8A68,$01 Opcode (#N$12).
  $8A69,$01 Skip count: #N(#PEEK(#PC)).
N $8A6A Attribute overlay: repeat colour.
  $8A6A,$01 Opcode (#N$1B).
  $8A6B,$01 Repeat count: #N(#PEEK(#PC)).
  $8A6C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A6D Attribute overlay: skip.
  $8A6D,$01 Opcode (#N$12).
  $8A6E,$01 Skip count: #N(#PEEK(#PC)).
N $8A6F Attribute overlay: repeat colour.
  $8A6F,$01 Opcode (#N$1B).
  $8A70,$01 Repeat count: #N(#PEEK(#PC)).
  $8A71,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8A72,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A73 Attribute overlay: repeat colour.
  $8A73,$01 Opcode (#N$1B).
  $8A74,$01 Repeat count: #N(#PEEK(#PC)).
  $8A75,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A76 Attribute overlay: skip.
  $8A76,$01 Opcode (#N$12).
  $8A77,$01 Skip count: #N(#PEEK(#PC)).
  $8A78,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A79,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A7A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A7B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A7C Attribute overlay: repeat colour.
  $8A7C,$01 Opcode (#N$1B).
  $8A7D,$01 Repeat count: #N(#PEEK(#PC)).
  $8A7E,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A7F Attribute overlay: skip.
  $8A7F,$01 Opcode (#N$12).
  $8A80,$01 Skip count: #N(#PEEK(#PC)).
  $8A81,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A82,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A83 Attribute overlay: skip.
  $8A83,$01 Opcode (#N$12).
  $8A84,$01 Skip count: #N(#PEEK(#PC)).
  $8A85,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A86,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A87 Attribute overlay: skip.
  $8A87,$01 Opcode (#N$12).
  $8A88,$01 Skip count: #N(#PEEK(#PC)).
N $8A89 Attribute overlay: repeat colour.
  $8A89,$01 Opcode (#N$1B).
  $8A8A,$01 Repeat count: #N(#PEEK(#PC)).
  $8A8B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8A8C Attribute overlay: repeat colour.
  $8A8C,$01 Opcode (#N$1B).
  $8A8D,$01 Repeat count: #N(#PEEK(#PC)).
  $8A8E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8A8F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A90,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A91 Attribute overlay: repeat colour.
  $8A91,$01 Opcode (#N$1B).
  $8A92,$01 Repeat count: #N(#PEEK(#PC)).
  $8A93,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8A94,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A95,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A96 Attribute overlay: repeat colour.
  $8A96,$01 Opcode (#N$1B).
  $8A97,$01 Repeat count: #N(#PEEK(#PC)).
  $8A98,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8A99,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A9A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8A9B Attribute overlay: repeat colour.
  $8A9B,$01 Opcode (#N$1B).
  $8A9C,$01 Repeat count: #N(#PEEK(#PC)).
  $8A9D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8A9E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8A9F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AA0 Attribute overlay: repeat colour.
  $8AA0,$01 Opcode (#N$1B).
  $8AA1,$01 Repeat count: #N(#PEEK(#PC)).
  $8AA2,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AA3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AA4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AA5 Attribute overlay: repeat colour.
  $8AA5,$01 Opcode (#N$1B).
  $8AA6,$01 Repeat count: #N(#PEEK(#PC)).
  $8AA7,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AA8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AA9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AAA Attribute overlay: repeat colour.
  $8AAA,$01 Opcode (#N$1B).
  $8AAB,$01 Repeat count: #N(#PEEK(#PC)).
  $8AAC,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AAD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AAE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AAF Attribute overlay: repeat colour.
  $8AAF,$01 Opcode (#N$1B).
  $8AB0,$01 Repeat count: #N(#PEEK(#PC)).
  $8AB1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AB2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AB3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AB4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AB5 Attribute overlay: skip.
  $8AB5,$01 Opcode (#N$12).
  $8AB6,$01 Skip count: #N(#PEEK(#PC)).
  $8AB7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AB8 Attribute overlay: repeat colour.
  $8AB8,$01 Opcode (#N$1B).
  $8AB9,$01 Repeat count: #N(#PEEK(#PC)).
  $8ABA,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8ABB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ABC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8ABD Attribute overlay: repeat colour.
  $8ABD,$01 Opcode (#N$1B).
  $8ABE,$01 Repeat count: #N(#PEEK(#PC)).
  $8ABF,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AC0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AC6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AC7 Attribute overlay: skip.
  $8AC7,$01 Opcode (#N$12).
  $8AC8,$01 Skip count: #N(#PEEK(#PC)).
  $8AC9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ACF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AD3 Attribute overlay: repeat colour.
  $8AD3,$01 Opcode (#N$1B).
  $8AD4,$01 Repeat count: #N(#PEEK(#PC)).
  $8AD5,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AD6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AD9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ADA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ADB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8ADC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8ADD Attribute overlay: skip.
  $8ADD,$01 Opcode (#N$12).
  $8ADE,$01 Skip count: #N(#PEEK(#PC)).
  $8ADF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AE1 Attribute overlay: skip.
  $8AE1,$01 Opcode (#N$12).
  $8AE2,$01 Skip count: #N(#PEEK(#PC)).
  $8AE3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AE9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AEA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AEB Attribute overlay: repeat colour.
  $8AEB,$01 Opcode (#N$1B).
  $8AEC,$01 Repeat count: #N(#PEEK(#PC)).
  $8AED,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8AEE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AEF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AF0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AF1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AF2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AF3 Attribute overlay: skip.
  $8AF3,$01 Opcode (#N$12).
  $8AF4,$01 Skip count: #N(#PEEK(#PC)).
  $8AF5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AF6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AF7 Attribute overlay: skip.
  $8AF7,$01 Opcode (#N$12).
  $8AF8,$01 Skip count: #N(#PEEK(#PC)).
  $8AF9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AFA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AFB Attribute overlay: skip.
  $8AFB,$01 Opcode (#N$12).
  $8AFC,$01 Skip count: #N(#PEEK(#PC)).
  $8AFD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8AFE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8AFF Attribute overlay: repeat colour.
  $8AFF,$01 Opcode (#N$1B).
  $8B00,$01 Repeat count: #N(#PEEK(#PC)).
  $8B01,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8B02,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8B03,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8B04,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8B05,$01 End of attribute overlay.
  $8B06,$01 Terminator.

b $8B07 Room #N$05
@ $8B07 label=Room05
D $8B07 #ROOM$05
N $8B07 Command #N$01: Skip tiles.
  $8B07,$01 Command (#N$01).
  $8B08,$01 Skip count: #N(#PEEK(#PC)).
  $8B09,$01 Tile ID: #R$9F12(#N$75).
  $8B0A,$01 Tile ID: #R$9F1A(#N$76).
N $8B0B Command #N$01: Skip tiles.
  $8B0B,$01 Command (#N$01).
  $8B0C,$01 Skip count: #N(#PEEK(#PC)).
  $8B0D,$01 Tile ID: #R$9BC2(#N$0B).
  $8B0E,$01 Tile ID: #R$9BCA(#N$0C).
  $8B0F,$01 Tile ID: #R$9BD2(#N$0D).
  $8B10,$01 Tile ID: #R$9BB2(#N$09).
  $8B11,$01 Tile ID: #R$9BBA(#N$0A).
N $8B12 Command #N$01: Skip tiles.
  $8B12,$01 Command (#N$01).
  $8B13,$01 Skip count: #N(#PEEK(#PC)).
  $8B14,$01 Tile ID: #R$9F22(#N$77).
  $8B15,$01 Tile ID: #R$9F2A(#N$78).
N $8B16 Command #N$01: Skip tiles.
  $8B16,$01 Command (#N$01).
  $8B17,$01 Skip count: #N(#PEEK(#PC)).
  $8B18,$01 Tile ID: #R$9BB2(#N$09).
  $8B19,$01 Tile ID: #R$9BBA(#N$0A).
  $8B1A,$01 Tile ID: #R$9BC2(#N$0B).
  $8B1B,$01 Tile ID: #R$9BCA(#N$0C).
  $8B1C,$01 Tile ID: #R$9BE2(#N$0F).
  $8B1D,$01 Tile ID: #R$9C42(#N$1B).
N $8B1E Command #N$01: Skip tiles.
  $8B1E,$01 Command (#N$01).
  $8B1F,$01 Skip count: #N(#PEEK(#PC)).
  $8B20,$01 Tile ID: #R$9BDA(#N$0E).
  $8B21,$01 Tile ID: #R$9BE2(#N$0F).
N $8B22 Command #N$01: Skip tiles.
  $8B22,$01 Command (#N$01).
  $8B23,$01 Skip count: #N(#PEEK(#PC)).
  $8B24,$01 Tile ID: #R$9F32(#N$79).
  $8B25,$01 Tile ID: #R$9F3A(#N$7A).
N $8B26 Command #N$01: Skip tiles.
  $8B26,$01 Command (#N$01).
  $8B27,$01 Skip count: #N(#PEEK(#PC)).
  $8B28,$01 Tile ID: #R$9BAA(#N$08).
N $8B29 Command #N$01: Skip tiles.
  $8B29,$01 Command (#N$01).
  $8B2A,$01 Skip count: #N(#PEEK(#PC)).
  $8B2B,$01 Tile ID: #R$9BEA(#N$10).
  $8B2C,$01 Tile ID: #R$9C3A(#N$1A).
N $8B2D Command #N$01: Skip tiles.
  $8B2D,$01 Command (#N$01).
  $8B2E,$01 Skip count: #N(#PEEK(#PC)).
  $8B2F,$01 Tile ID: #R$9C0A(#N$14).
N $8B30 Command #N$01: Skip tiles.
  $8B30,$01 Command (#N$01).
  $8B31,$01 Skip count: #N(#PEEK(#PC)).
  $8B32,$01 Tile ID: #R$9BF2(#N$11).
N $8B33 Command #N$01: Skip tiles.
  $8B33,$01 Command (#N$01).
  $8B34,$01 Skip count: #N(#PEEK(#PC)).
  $8B35,$01 Tile ID: #R$9F42(#N$7B).
  $8B36,$01 Tile ID: #R$9F4A(#N$7C).
N $8B37 Command #N$01: Skip tiles.
  $8B37,$01 Command (#N$01).
  $8B38,$01 Skip count: #N(#PEEK(#PC)).
  $8B39,$01 Tile ID: #R$9C02(#N$13).
  $8B3A,$01 Tile ID: #R$9C2A(#N$18).
  $8B3B,$01 Tile ID: #R$9C22(#N$17).
  $8B3C,$01 Tile ID: #R$9C1A(#N$16).
  $8B3D,$01 Tile ID: #R$9C12(#N$15).
N $8B3E Command #N$01: Skip tiles.
  $8B3E,$01 Command (#N$01).
  $8B3F,$01 Skip count: #N(#PEEK(#PC)).
  $8B40,$01 Tile ID: #R$9C2A(#N$18).
  $8B41,$01 Tile ID: #R$9C22(#N$17).
  $8B42,$01 Tile ID: #R$9C1A(#N$16).
  $8B43,$01 Tile ID: #R$9C12(#N$15).
  $8B44,$01 Tile ID: #R$9C02(#N$13).
  $8B45,$01 Tile ID: #R$9C02(#N$13).
N $8B46 Command #N$01: Skip tiles.
  $8B46,$01 Command (#N$01).
  $8B47,$01 Skip count: #N(#PEEK(#PC)).
  $8B48,$01 Tile ID: #R$9F52(#N$7D).
  $8B49,$01 Tile ID: #R$9F5A(#N$7E).
  $8B4A,$01 Tile ID: #R$9F62(#N$7F).
N $8B4B Command #N$01: Skip tiles.
  $8B4B,$01 Command (#N$01).
  $8B4C,$01 Skip count: #N(#PEEK(#PC)).
  $8B4D,$01 Tile ID: #R$9F6A(#N$80).
  $8B4E,$01 Tile ID: #R$9F72(#N$81).
  $8B4F,$01 Tile ID: #R$9F7A(#N$82).
N $8B50 Command #N$01: Skip tiles.
  $8B50,$01 Command (#N$01).
  $8B51,$01 Skip count: #N(#PEEK(#PC)).
  $8B52,$01 Tile ID: #R$9F82(#N$83).
  $8B53,$01 Tile ID: #R$9F8A(#N$84).
N $8B54 Command #N$01: Skip tiles.
  $8B54,$01 Command (#N$01).
  $8B55,$01 Skip count: #N(#PEEK(#PC)).
  $8B56,$01 Tile ID: #R$9F92(#N$85).
  $8B57,$01 Tile ID: #R$9F9A(#N$86).
N $8B58 Command #N$01: Skip tiles.
  $8B58,$01 Command (#N$01).
  $8B59,$01 Skip count: #N(#PEEK(#PC)).
  $8B5A,$01 Tile ID: #R$9FBA(#N$8A).
  $8B5B,$01 Tile ID: #R$9C82(#N$23).
  $8B5C,$01 Tile ID: #R$9FDA(#N$8E).
N $8B5D Command #N$01: Skip tiles.
  $8B5D,$01 Command (#N$01).
  $8B5E,$01 Skip count: #N(#PEEK(#PC)).
  $8B5F,$01 Tile ID: #R$9FA2(#N$87).
  $8B60,$01 Tile ID: #R$9FEA(#N$90).
  $8B61,$01 Tile ID: #R$9FC2(#N$8B).
N $8B62 Command #N$01: Skip tiles.
  $8B62,$01 Command (#N$01).
  $8B63,$01 Skip count: #N(#PEEK(#PC)).
  $8B64,$01 Tile ID: #R$9FAA(#N$88).
  $8B65,$01 Tile ID: #R$9FEA(#N$90).
  $8B66,$01 Tile ID: #R$9FCA(#N$8C).
N $8B67 Command #N$01: Skip tiles.
  $8B67,$01 Command (#N$01).
  $8B68,$01 Skip count: #N(#PEEK(#PC)).
  $8B69,$01 Tile ID: #R$9FBA(#N$8A).
  $8B6A,$01 Tile ID: #R$9FB2(#N$89).
  $8B6B,$01 Tile ID: #R$9FEA(#N$90).
  $8B6C,$01 Tile ID: #R$9FD2(#N$8D).
  $8B6D,$01 Tile ID: #R$9FDA(#N$8E).
N $8B6E Command #N$01: Skip tiles.
  $8B6E,$01 Command (#N$01).
  $8B6F,$01 Skip count: #N(#PEEK(#PC)).
  $8B70,$01 Tile ID: #R$9C5A(#N$1E).
  $8B71,$01 Tile ID: #R$9C62(#N$1F).
N $8B72 Command #N$01: Skip tiles.
  $8B72,$01 Command (#N$01).
  $8B73,$01 Skip count: #N(#PEEK(#PC)).
  $8B74,$01 Tile ID: #R$9FA2(#N$87).
N $8B75 Command #N$01: Skip tiles.
  $8B75,$01 Command (#N$01).
  $8B76,$01 Skip count: #N(#PEEK(#PC)).
  $8B77,$01 Tile ID: #R$9FEA(#N$90).
N $8B78 Command #N$01: Skip tiles.
  $8B78,$01 Command (#N$01).
  $8B79,$01 Skip count: #N(#PEEK(#PC)).
  $8B7A,$01 Tile ID: #R$9FC2(#N$8B).
N $8B7B Command #N$01: Skip tiles.
  $8B7B,$01 Command (#N$01).
  $8B7C,$01 Skip count: #N(#PEEK(#PC)).
  $8B7D,$01 Tile ID: #R$A312(#N$F5).
  $8B7E,$01 Tile ID: #R$A30A(#N$F4).
N $8B7F Command #N$01: Skip tiles.
  $8B7F,$01 Command (#N$01).
  $8B80,$01 Skip count: #N(#PEEK(#PC)).
  $8B81,$01 Tile ID: #R$A31A(#N$F6).
  $8B82,$01 Tile ID: #R$A31A(#N$F6).
N $8B83 Command #N$01: Skip tiles.
  $8B83,$01 Command (#N$01).
  $8B84,$01 Skip count: #N(#PEEK(#PC)).
  $8B85,$01 Tile ID: #R$9FAA(#N$88).
N $8B86 Command #N$01: Skip tiles.
  $8B86,$01 Command (#N$01).
  $8B87,$01 Skip count: #N(#PEEK(#PC)).
  $8B88,$01 Tile ID: #R$9FEA(#N$90).
N $8B89 Command #N$01: Skip tiles.
  $8B89,$01 Command (#N$01).
  $8B8A,$01 Skip count: #N(#PEEK(#PC)).
  $8B8B,$01 Tile ID: #R$9FCA(#N$8C).
N $8B8C Command #N$01: Skip tiles.
  $8B8C,$01 Command (#N$01).
  $8B8D,$01 Skip count: #N(#PEEK(#PC)).
  $8B8E,$01 Tile ID: #R$A2FA(#N$F2).
  $8B8F,$01 Tile ID: #R$A2FA(#N$F2).
  $8B90,$01 Tile ID: #R$A25A(#N$DE).
N $8B91 Command #N$01: Skip tiles.
  $8B91,$01 Command (#N$01).
  $8B92,$01 Skip count: #N(#PEEK(#PC)).
  $8B93,$01 Tile ID: #R$A31A(#N$F6).
  $8B94,$01 Tile ID: #R$A31A(#N$F6).
N $8B95 Command #N$01: Skip tiles.
  $8B95,$01 Command (#N$01).
  $8B96,$01 Skip count: #N(#PEEK(#PC)).
  $8B97,$01 Tile ID: #R$9FBA(#N$8A).
  $8B98,$01 Tile ID: #R$9FB2(#N$89).
N $8B99 Command #N$01: Skip tiles.
  $8B99,$01 Command (#N$01).
  $8B9A,$01 Skip count: #N(#PEEK(#PC)).
  $8B9B,$01 Tile ID: #R$9FF2(#N$91).
N $8B9C Command #N$01: Skip tiles.
  $8B9C,$01 Command (#N$01).
  $8B9D,$01 Skip count: #N(#PEEK(#PC)).
  $8B9E,$01 Tile ID: #R$9FD2(#N$8D).
N $8B9F Command #N$02: Draw repeated tile.
  $8B9F,$01 Command (#N$02).
  $8BA0,$01 Repeat count: #N(#PEEK(#PC)).
  $8BA1,$01 Tile ID: #R$A27A(#N$E2).
  $8BA2,$01 Tile ID: #R$A0C2(#N$AB).
N $8BA3 Command #N$01: Skip tiles.
  $8BA3,$01 Command (#N$01).
  $8BA4,$01 Skip count: #N(#PEEK(#PC)).
  $8BA5,$01 Tile ID: #R$9FA2(#N$87).
N $8BA6 Command #N$01: Skip tiles.
  $8BA6,$01 Command (#N$01).
  $8BA7,$01 Skip count: #N(#PEEK(#PC)).
  $8BA8,$01 Tile ID: #R$9FFA(#N$92).
N $8BA9 Command #N$01: Skip tiles.
  $8BA9,$01 Command (#N$01).
  $8BAA,$01 Skip count: #N(#PEEK(#PC)).
  $8BAB,$01 Tile ID: #R$A0DA(#N$AE).
N $8BAC Command #N$01: Skip tiles.
  $8BAC,$01 Command (#N$01).
  $8BAD,$01 Skip count: #N(#PEEK(#PC)).
  $8BAE,$01 Tile ID: #R$A02A(#N$98).
  $8BAF,$01 Tile ID: #R$A0C2(#N$AB).
N $8BB0 Command #N$01: Skip tiles.
  $8BB0,$01 Command (#N$01).
  $8BB1,$01 Skip count: #N(#PEEK(#PC)).
  $8BB2,$01 Tile ID: #R$9FAA(#N$88).
N $8BB3 Command #N$01: Skip tiles.
  $8BB3,$01 Command (#N$01).
  $8BB4,$01 Skip count: #N(#PEEK(#PC)).
  $8BB5,$01 Tile ID: #R$A0DA(#N$AE).
N $8BB6 Command #N$01: Skip tiles.
  $8BB6,$01 Command (#N$01).
  $8BB7,$01 Skip count: #N(#PEEK(#PC)).
  $8BB8,$01 Tile ID: #R$A2BA(#N$EA).
  $8BB9,$01 Tile ID: #R$A2CA(#N$EC).
N $8BBA Command #N$01: Skip tiles.
  $8BBA,$01 Command (#N$01).
  $8BBB,$01 Skip count: #N(#PEEK(#PC)).
  $8BBC,$01 Tile ID: #R$A02A(#N$98).
  $8BBD,$01 Tile ID: #R$A02A(#N$98).
  $8BBE,$01 Tile ID: #R$A0C2(#N$AB).
N $8BBF Command #N$01: Skip tiles.
  $8BBF,$01 Command (#N$01).
  $8BC0,$01 Skip count: #N(#PEEK(#PC)).
  $8BC1,$01 Tile ID: #R$A0DA(#N$AE).
N $8BC2 Command #N$01: Skip tiles.
  $8BC2,$01 Command (#N$01).
  $8BC3,$01 Skip count: #N(#PEEK(#PC)).
  $8BC4,$01 Tile ID: #R$A2C2(#N$EB).
  $8BC5,$01 Tile ID: #R$A2D2(#N$ED).
N $8BC6 Command #N$01: Skip tiles.
  $8BC6,$01 Command (#N$01).
  $8BC7,$01 Skip count: #N(#PEEK(#PC)).
N $8BC8 Command #N$02: Draw repeated tile.
  $8BC8,$01 Command (#N$02).
  $8BC9,$01 Repeat count: #N(#PEEK(#PC)).
  $8BCA,$01 Tile ID: #R$A02A(#N$98).
  $8BCB,$01 Tile ID: #R$A0C2(#N$AB).
N $8BCC Command #N$01: Skip tiles.
  $8BCC,$01 Command (#N$01).
  $8BCD,$01 Skip count: #N(#PEEK(#PC)).
  $8BCE,$01 Tile ID: #R$A0DA(#N$AE).
N $8BCF Command #N$01: Skip tiles.
  $8BCF,$01 Command (#N$01).
  $8BD0,$01 Skip count: #N(#PEEK(#PC)).
N $8BD1 Command #N$02: Draw repeated tile.
  $8BD1,$01 Command (#N$02).
  $8BD2,$01 Repeat count: #N(#PEEK(#PC)).
  $8BD3,$01 Tile ID: #R$A02A(#N$98).
  $8BD4,$01 Tile ID: #R$A0EA(#N$B0).
N $8BD5 Command #N$02: Draw repeated tile.
  $8BD5,$01 Command (#N$02).
  $8BD6,$01 Repeat count: #N(#PEEK(#PC)).
  $8BD7,$01 Tile ID: #R$A022(#N$97).
N $8BD8 Command #N$01: Skip tiles.
  $8BD8,$01 Command (#N$01).
  $8BD9,$01 Skip count: #N(#PEEK(#PC)).
N $8BDA Command #N$03: Fill attribute buffer.
  $8BDA,$01 Command (#N$03).
  $8BDB,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $8BDC Attribute overlay: skip.
  $8BDC,$01 Opcode (#N$12).
  $8BDD,$01 Skip count: #N(#PEEK(#PC)).
  $8BDE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BDF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8BE0 Attribute overlay: skip.
  $8BE0,$01 Opcode (#N$12).
  $8BE1,$01 Skip count: #N(#PEEK(#PC)).
  $8BE2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BE3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8BE4 Attribute overlay: skip.
  $8BE4,$01 Opcode (#N$12).
  $8BE5,$01 Skip count: #N(#PEEK(#PC)).
N $8BE6 Attribute overlay: repeat colour.
  $8BE6,$01 Opcode (#N$1B).
  $8BE7,$01 Repeat count: #N(#PEEK(#PC)).
  $8BE8,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8BE9 Attribute overlay: skip.
  $8BE9,$01 Opcode (#N$12).
  $8BEA,$01 Skip count: #N(#PEEK(#PC)).
  $8BEB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BEC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8BED Attribute overlay: skip.
  $8BED,$01 Opcode (#N$12).
  $8BEE,$01 Skip count: #N(#PEEK(#PC)).
N $8BEF Attribute overlay: repeat colour.
  $8BEF,$01 Opcode (#N$1B).
  $8BF0,$01 Repeat count: #N(#PEEK(#PC)).
  $8BF1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8BF2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BF9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8BFA Attribute overlay: skip.
  $8BFA,$01 Opcode (#N$12).
  $8BFB,$01 Skip count: #N(#PEEK(#PC)).
  $8BFC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8BFD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8BFE Attribute overlay: skip.
  $8BFE,$01 Opcode (#N$12).
  $8BFF,$01 Skip count: #N(#PEEK(#PC)).
  $8C00,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C01,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C02,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C03 Attribute overlay: skip.
  $8C03,$01 Opcode (#N$12).
  $8C04,$01 Skip count: #N(#PEEK(#PC)).
  $8C05,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C06,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C07,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C08 Attribute overlay: skip.
  $8C08,$01 Opcode (#N$12).
  $8C09,$01 Skip count: #N(#PEEK(#PC)).
  $8C0A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C0B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C0C Attribute overlay: skip.
  $8C0C,$01 Opcode (#N$12).
  $8C0D,$01 Skip count: #N(#PEEK(#PC)).
  $8C0E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C0F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C10 Attribute overlay: skip.
  $8C10,$01 Opcode (#N$12).
  $8C11,$01 Skip count: #N(#PEEK(#PC)).
  $8C12,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C13,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C14 Attribute overlay: skip.
  $8C14,$01 Opcode (#N$12).
  $8C15,$01 Skip count: #N(#PEEK(#PC)).
N $8C16 Attribute overlay: repeat colour.
  $8C16,$01 Opcode (#N$1B).
  $8C17,$01 Repeat count: #N(#PEEK(#PC)).
  $8C18,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C19,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C1A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C1B Attribute overlay: repeat colour.
  $8C1B,$01 Opcode (#N$1B).
  $8C1C,$01 Repeat count: #N(#PEEK(#PC)).
  $8C1D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8C1E Attribute overlay: repeat colour.
  $8C1E,$01 Opcode (#N$1B).
  $8C1F,$01 Repeat count: #N(#PEEK(#PC)).
  $8C20,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8C21 Attribute overlay: repeat colour.
  $8C21,$01 Opcode (#N$1B).
  $8C22,$01 Repeat count: #N(#PEEK(#PC)).
  $8C23,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C24,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C25 Attribute overlay: repeat colour.
  $8C25,$01 Opcode (#N$1B).
  $8C26,$01 Repeat count: #N(#PEEK(#PC)).
  $8C27,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8C28 Attribute overlay: repeat colour.
  $8C28,$01 Opcode (#N$1B).
  $8C29,$01 Repeat count: #N(#PEEK(#PC)).
  $8C2A,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C2B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C2C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C2D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C2E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C2F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C30,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C31,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C32,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C33,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C34,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C35,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C36 Attribute overlay: repeat colour.
  $8C36,$01 Opcode (#N$1B).
  $8C37,$01 Repeat count: #N(#PEEK(#PC)).
  $8C38,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C39,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C3F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C40,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C41,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C42,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C43,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C44,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C45 Attribute overlay: repeat colour.
  $8C45,$01 Opcode (#N$1B).
  $8C46,$01 Repeat count: #N(#PEEK(#PC)).
  $8C47,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8C48 Attribute overlay: repeat colour.
  $8C48,$01 Opcode (#N$1B).
  $8C49,$01 Repeat count: #N(#PEEK(#PC)).
  $8C4A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8C4B Attribute overlay: repeat colour.
  $8C4B,$01 Opcode (#N$1B).
  $8C4C,$01 Repeat count: #N(#PEEK(#PC)).
  $8C4D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C4E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C4F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C50,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C51,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8C52,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8C53 Attribute overlay: repeat colour.
  $8C53,$01 Opcode (#N$1B).
  $8C54,$01 Repeat count: #N(#PEEK(#PC)).
  $8C55,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8C56,$01 End of attribute overlay.
  $8C57,$01 Terminator.

b $8C58 Room #N$06
@ $8C58 label=Room06
D $8C58 #ROOM$06
N $8C58 Command #N$01: Skip tiles.
  $8C58,$01 Command (#N$01).
  $8C59,$01 Skip count: #N(#PEEK(#PC)).
  $8C5A,$01 Tile ID: #R$9CBA(#N$2A).
N $8C5B Command #N$01: Skip tiles.
  $8C5B,$01 Command (#N$01).
  $8C5C,$01 Skip count: #N(#PEEK(#PC)).
  $8C5D,$01 Tile ID: #R$9CC2(#N$2B).
N $8C5E Command #N$01: Skip tiles.
  $8C5E,$01 Command (#N$01).
  $8C5F,$01 Skip count: #N(#PEEK(#PC)).
  $8C60,$01 Tile ID: #R$9CCA(#N$2C).
N $8C61 Command #N$01: Skip tiles.
  $8C61,$01 Command (#N$01).
  $8C62,$01 Skip count: #N(#PEEK(#PC)).
  $8C63,$01 Tile ID: #R$9CD2(#N$2D).
  $8C64,$01 Tile ID: #R$9CDA(#N$2E).
  $8C65,$01 Tile ID: #R$9CE2(#N$2F).
  $8C66,$01 Tile ID: #R$9CEA(#N$30).
  $8C67,$01 Tile ID: #R$9CF2(#N$31).
N $8C68 Command #N$01: Skip tiles.
  $8C68,$01 Command (#N$01).
  $8C69,$01 Skip count: #N(#PEEK(#PC)).
  $8C6A,$01 Tile ID: #R$9CFA(#N$32).
  $8C6B,$01 Tile ID: #R$9D02(#N$33).
N $8C6C Command #N$01: Skip tiles.
  $8C6C,$01 Command (#N$01).
  $8C6D,$01 Skip count: #N(#PEEK(#PC)).
  $8C6E,$01 Tile ID: #R$9BB2(#N$09).
  $8C6F,$01 Tile ID: #R$9BBA(#N$0A).
  $8C70,$01 Tile ID: #R$9BC2(#N$0B).
  $8C71,$01 Tile ID: #R$9BCA(#N$0C).
  $8C72,$01 Tile ID: #R$9BD2(#N$0D).
N $8C73 Command #N$01: Skip tiles.
  $8C73,$01 Command (#N$01).
  $8C74,$01 Skip count: #N(#PEEK(#PC)).
  $8C75,$01 Tile ID: #R$9D0A(#N$34).
  $8C76,$01 Tile ID: #R$9D12(#N$35).
  $8C77,$01 Tile ID: #R$9D1A(#N$36).
  $8C78,$01 Tile ID: #R$9D22(#N$37).
  $8C79,$01 Tile ID: #R$9CBA(#N$2A).
  $8C7A,$01 Tile ID: #R$9D2A(#N$38).
  $8C7B,$01 Tile ID: #R$9D32(#N$39).
N $8C7C Command #N$01: Skip tiles.
  $8C7C,$01 Command (#N$01).
  $8C7D,$01 Skip count: #N(#PEEK(#PC)).
  $8C7E,$01 Tile ID: #R$9D3A(#N$3A).
  $8C7F,$01 Tile ID: #R$9D42(#N$3B).
  $8C80,$01 Tile ID: #R$9D4A(#N$3C).
N $8C81 Command #N$01: Skip tiles.
  $8C81,$01 Command (#N$01).
  $8C82,$01 Skip count: #N(#PEEK(#PC)).
  $8C83,$01 Tile ID: #R$9BAA(#N$08).
N $8C84 Command #N$01: Skip tiles.
  $8C84,$01 Command (#N$01).
  $8C85,$01 Skip count: #N(#PEEK(#PC)).
  $8C86,$01 Tile ID: #R$9BDA(#N$0E).
  $8C87,$01 Tile ID: #R$9BE2(#N$0F).
N $8C88 Command #N$01: Skip tiles.
  $8C88,$01 Command (#N$01).
  $8C89,$01 Skip count: #N(#PEEK(#PC)).
  $8C8A,$01 Tile ID: #R$9D52(#N$3D).
  $8C8B,$01 Tile ID: #R$9D5A(#N$3E).
N $8C8C Command #N$01: Skip tiles.
  $8C8C,$01 Command (#N$01).
  $8C8D,$01 Skip count: #N(#PEEK(#PC)).
  $8C8E,$01 Tile ID: #R$9D62(#N$3F).
N $8C8F Command #N$01: Skip tiles.
  $8C8F,$01 Command (#N$01).
  $8C90,$01 Skip count: #N(#PEEK(#PC)).
  $8C91,$01 Tile ID: #R$9D6A(#N$40).
N $8C92 Command #N$01: Skip tiles.
  $8C92,$01 Command (#N$01).
  $8C93,$01 Skip count: #N(#PEEK(#PC)).
  $8C94,$01 Tile ID: #R$9D72(#N$41).
  $8C95,$01 Tile ID: #R$9D7A(#N$42).
  $8C96,$01 Tile ID: #R$9D82(#N$43).
N $8C97 Command #N$01: Skip tiles.
  $8C97,$01 Command (#N$01).
  $8C98,$01 Skip count: #N(#PEEK(#PC)).
  $8C99,$01 Tile ID: #R$9C4A(#N$1C).
N $8C9A Command #N$01: Skip tiles.
  $8C9A,$01 Command (#N$01).
  $8C9B,$01 Skip count: #N(#PEEK(#PC)).
  $8C9C,$01 Tile ID: #R$9BEA(#N$10).
N $8C9D Command #N$01: Skip tiles.
  $8C9D,$01 Command (#N$01).
  $8C9E,$01 Skip count: #N(#PEEK(#PC)).
  $8C9F,$01 Tile ID: #R$9D8A(#N$44).
  $8CA0,$01 Tile ID: #R$9D92(#N$45).
  $8CA1,$01 Tile ID: #R$9D9A(#N$46).
  $8CA2,$01 Tile ID: #R$9DA2(#N$47).
  $8CA3,$01 Tile ID: #R$9DAA(#N$48).
  $8CA4,$01 Tile ID: #R$9DB2(#N$49).
  $8CA5,$01 Tile ID: #R$9DBA(#N$4A).
  $8CA6,$01 Tile ID: #R$9DC2(#N$4B).
  $8CA7,$01 Tile ID: #R$9DCA(#N$4C).
  $8CA8,$01 Tile ID: #R$9DD2(#N$4D).
N $8CA9 Command #N$01: Skip tiles.
  $8CA9,$01 Command (#N$01).
  $8CAA,$01 Skip count: #N(#PEEK(#PC)).
  $8CAB,$01 Tile ID: #R$9C42(#N$1B).
N $8CAC Command #N$01: Skip tiles.
  $8CAC,$01 Command (#N$01).
  $8CAD,$01 Skip count: #N(#PEEK(#PC)).
  $8CAE,$01 Tile ID: #R$9BF2(#N$11).
N $8CAF Command #N$01: Skip tiles.
  $8CAF,$01 Command (#N$01).
  $8CB0,$01 Skip count: #N(#PEEK(#PC)).
  $8CB1,$01 Tile ID: #R$9DDA(#N$4E).
  $8CB2,$01 Tile ID: #R$9DE2(#N$4F).
  $8CB3,$01 Tile ID: #R$9DEA(#N$50).
  $8CB4,$01 Tile ID: #R$9DF2(#N$51).
  $8CB5,$01 Tile ID: #R$9DFA(#N$52).
  $8CB6,$01 Tile ID: #R$9E02(#N$53).
  $8CB7,$01 Tile ID: #R$9E0A(#N$54).
  $8CB8,$01 Tile ID: #R$9E12(#N$55).
  $8CB9,$01 Tile ID: #R$9E1A(#N$56).
N $8CBA Command #N$01: Skip tiles.
  $8CBA,$01 Command (#N$01).
  $8CBB,$01 Skip count: #N(#PEEK(#PC)).
  $8CBC,$01 Tile ID: #R$9C6A(#N$20).
  $8CBD,$01 Tile ID: #R$9C72(#N$21).
  $8CBE,$01 Tile ID: #R$9C7A(#N$22).
  $8CBF,$01 Tile ID: #R$9E92(#N$65).
N $8CC0 Command #N$01: Skip tiles.
  $8CC0,$01 Command (#N$01).
  $8CC1,$01 Skip count: #N(#PEEK(#PC)).
  $8CC2,$01 Tile ID: #R$9C3A(#N$1A).
N $8CC3 Command #N$01: Skip tiles.
  $8CC3,$01 Command (#N$01).
  $8CC4,$01 Skip count: #N(#PEEK(#PC)).
  $8CC5,$01 Tile ID: #R$9C0A(#N$14).
N $8CC6 Command #N$01: Skip tiles.
  $8CC6,$01 Command (#N$01).
  $8CC7,$01 Skip count: #N(#PEEK(#PC)).
  $8CC8,$01 Tile ID: #R$9BFA(#N$12).
N $8CC9 Command #N$01: Skip tiles.
  $8CC9,$01 Command (#N$01).
  $8CCA,$01 Skip count: #N(#PEEK(#PC)).
  $8CCB,$01 Tile ID: #R$9E22(#N$57).
  $8CCC,$01 Tile ID: #R$9E2A(#N$58).
  $8CCD,$01 Tile ID: #R$9E32(#N$59).
  $8CCE,$01 Tile ID: #R$9E3A(#N$5A).
  $8CCF,$01 Tile ID: #R$9E42(#N$5B).
  $8CD0,$01 Tile ID: #R$9E4A(#N$5C).
  $8CD1,$01 Tile ID: #R$9E52(#N$5D).
  $8CD2,$01 Tile ID: #R$9E5A(#N$5E).
  $8CD3,$01 Tile ID: #R$9E62(#N$5F).
  $8CD4,$01 Tile ID: #R$9E6A(#N$60).
  $8CD5,$01 Tile ID: #R$9E72(#N$61).
  $8CD6,$01 Tile ID: #R$9E7A(#N$62).
  $8CD7,$01 Tile ID: #R$9E82(#N$63).
  $8CD8,$01 Tile ID: #R$9E8A(#N$64).
N $8CD9 Command #N$01: Skip tiles.
  $8CD9,$01 Command (#N$01).
  $8CDA,$01 Skip count: #N(#PEEK(#PC)).
  $8CDB,$01 Tile ID: #R$9C2A(#N$18).
  $8CDC,$01 Tile ID: #R$9C22(#N$17).
  $8CDD,$01 Tile ID: #R$9C1A(#N$16).
  $8CDE,$01 Tile ID: #R$9C12(#N$15).
  $8CDF,$01 Tile ID: #R$9C02(#N$13).
N $8CE0 Command #N$01: Skip tiles.
  $8CE0,$01 Command (#N$01).
  $8CE1,$01 Skip count: #N(#PEEK(#PC)).
  $8CE2,$01 Tile ID: #R$9E9A(#N$66).
  $8CE3,$01 Tile ID: #R$9EA2(#N$67).
  $8CE4,$01 Tile ID: #R$9EAA(#N$68).
  $8CE5,$01 Tile ID: #R$9EB2(#N$69).
  $8CE6,$01 Tile ID: #R$9EBA(#N$6A).
  $8CE7,$01 Tile ID: #R$9EC2(#N$6B).
  $8CE8,$01 Tile ID: #R$9ECA(#N$6C).
  $8CE9,$01 Tile ID: #R$9ED2(#N$6D).
N $8CEA Command #N$01: Skip tiles.
  $8CEA,$01 Command (#N$01).
  $8CEB,$01 Skip count: #N(#PEEK(#PC)).
  $8CEC,$01 Tile ID: #R$9EDA(#N$6E).
  $8CED,$01 Tile ID: #R$9EE2(#N$6F).
  $8CEE,$01 Tile ID: #R$9EEA(#N$70).
N $8CEF Command #N$01: Skip tiles.
  $8CEF,$01 Command (#N$01).
  $8CF0,$01 Skip count: #N(#PEEK(#PC)).
  $8CF1,$01 Tile ID: #R$9EF2(#N$71).
N $8CF2 Command #N$01: Skip tiles.
  $8CF2,$01 Command (#N$01).
  $8CF3,$01 Skip count: #N(#PEEK(#PC)).
  $8CF4,$01 Tile ID: #R$9EFA(#N$72).
N $8CF5 Command #N$01: Skip tiles.
  $8CF5,$01 Command (#N$01).
  $8CF6,$01 Skip count: #N(#PEEK(#PC)).
  $8CF7,$01 Tile ID: #R$9F02(#N$73).
  $8CF8,$01 Tile ID: #R$9F0A(#N$74).
N $8CF9 Command #N$01: Skip tiles.
  $8CF9,$01 Command (#N$01).
  $8CFA,$01 Skip count: #N(#PEEK(#PC)).
  $8CFB,$01 Tile ID: #R$A30A(#N$F4).
N $8CFC Command #N$01: Skip tiles.
  $8CFC,$01 Command (#N$01).
  $8CFD,$01 Skip count: #N(#PEEK(#PC)).
  $8CFE,$01 Tile ID: #R$A30A(#N$F4).
N $8CFF Command #N$01: Skip tiles.
  $8CFF,$01 Command (#N$01).
  $8D00,$01 Skip count: #N(#PEEK(#PC)).
  $8D01,$01 Tile ID: #R$A30A(#N$F4).
N $8D02 Command #N$01: Skip tiles.
  $8D02,$01 Command (#N$01).
  $8D03,$01 Skip count: #N(#PEEK(#PC)).
  $8D04,$01 Tile ID: #R$A30A(#N$F4).
N $8D05 Command #N$01: Skip tiles.
  $8D05,$01 Command (#N$01).
  $8D06,$01 Skip count: #N(#PEEK(#PC)).
  $8D07,$01 Tile ID: #R$A30A(#N$F4).
N $8D08 Command #N$01: Skip tiles.
  $8D08,$01 Command (#N$01).
  $8D09,$01 Skip count: #N(#PEEK(#PC)).
  $8D0A,$01 Tile ID: #R$A30A(#N$F4).
N $8D0B Command #N$01: Skip tiles.
  $8D0B,$01 Command (#N$01).
  $8D0C,$01 Skip count: #N(#PEEK(#PC)).
  $8D0D,$01 Tile ID: #R$A2FA(#N$F2).
  $8D0E,$01 Tile ID: #R$A302(#N$F3).
  $8D0F,$01 Tile ID: #R$A302(#N$F3).
  $8D10,$01 Tile ID: #R$A2FA(#N$F2).
  $8D11,$01 Tile ID: #R$A302(#N$F3).
  $8D12,$01 Tile ID: #R$A302(#N$F3).
  $8D13,$01 Tile ID: #R$A2FA(#N$F2).
  $8D14,$01 Tile ID: #R$A302(#N$F3).
  $8D15,$01 Tile ID: #R$A302(#N$F3).
  $8D16,$01 Tile ID: #R$A2FA(#N$F2).
  $8D17,$01 Tile ID: #R$A302(#N$F3).
  $8D18,$01 Tile ID: #R$A302(#N$F3).
  $8D19,$01 Tile ID: #R$A2FA(#N$F2).
  $8D1A,$01 Tile ID: #R$A302(#N$F3).
  $8D1B,$01 Tile ID: #R$A302(#N$F3).
  $8D1C,$01 Tile ID: #R$A2FA(#N$F2).
  $8D1D,$01 Tile ID: #R$A302(#N$F3).
N $8D1E Command #N$01: Skip tiles.
  $8D1E,$01 Command (#N$01).
  $8D1F,$01 Skip count: #N(#PEEK(#PC)).
N $8D20 Command #N$02: Draw repeated tile.
  $8D20,$01 Command (#N$02).
  $8D21,$01 Repeat count: #N(#PEEK(#PC)).
  $8D22,$01 Tile ID: #R$A032(#N$99).
N $8D23 Command #N$01: Skip tiles.
  $8D23,$01 Command (#N$01).
  $8D24,$01 Skip count: #N(#PEEK(#PC)).
  $8D25,$01 Tile ID: #R$A292(#N$E5).
  $8D26,$01 Tile ID: #R$A29A(#N$E6).
  $8D27,$01 Tile ID: #R$A2A2(#N$E7).
  $8D28,$01 Tile ID: #R$A2AA(#N$E8).
  $8D29,$01 Tile ID: #R$A2B2(#N$E9).
N $8D2A Command #N$01: Skip tiles.
  $8D2A,$01 Command (#N$01).
  $8D2B,$01 Skip count: #N(#PEEK(#PC)).
  $8D2C,$01 Tile ID: #R$9C5A(#N$1E).
  $8D2D,$01 Tile ID: #R$9C32(#N$19).
  $8D2E,$01 Tile ID: #R$9C0A(#N$14).
  $8D2F,$01 Tile ID: #R$9C62(#N$1F).
N $8D30 Command #N$01: Skip tiles.
  $8D30,$01 Command (#N$01).
  $8D31,$01 Skip count: #N(#PEEK(#PC)).
  $8D32,$01 Tile ID: #R$9C82(#N$23).
N $8D33 Command #N$01: Skip tiles.
  $8D33,$01 Command (#N$01).
  $8D34,$01 Skip count: #N(#PEEK(#PC)).
  $8D35,$01 Tile ID: #R$9C82(#N$23).
N $8D36 Command #N$01: Skip tiles.
  $8D36,$01 Command (#N$01).
  $8D37,$01 Skip count: #N(#PEEK(#PC)).
  $8D38,$01 Tile ID: #R$9C82(#N$23).
N $8D39 Command #N$01: Skip tiles.
  $8D39,$01 Command (#N$01).
  $8D3A,$01 Skip count: #N(#PEEK(#PC)).
  $8D3B,$01 Tile ID: #R$9C82(#N$23).
N $8D3C Command #N$01: Skip tiles.
  $8D3C,$01 Command (#N$01).
  $8D3D,$01 Skip count: #N(#PEEK(#PC)).
  $8D3E,$01 Tile ID: #R$9C82(#N$23).
N $8D3F Command #N$01: Skip tiles.
  $8D3F,$01 Command (#N$01).
  $8D40,$01 Skip count: #N(#PEEK(#PC)).
  $8D41,$01 Tile ID: #R$9C82(#N$23).
  $8D42,$01 Tile ID: #R$9C82(#N$23).
N $8D43 Command #N$01: Skip tiles.
  $8D43,$01 Command (#N$01).
  $8D44,$01 Skip count: #N(#PEEK(#PC)).
  $8D45,$01 Tile ID: #R$9C8A(#N$24).
  $8D46,$01 Tile ID: #R$9C92(#N$25).
  $8D47,$01 Tile ID: #R$9C9A(#N$26).
  $8D48,$01 Tile ID: #R$9C92(#N$25).
  $8D49,$01 Tile ID: #R$9C9A(#N$26).
  $8D4A,$01 Tile ID: #R$9C92(#N$25).
  $8D4B,$01 Tile ID: #R$9CA2(#N$27).
N $8D4C Command #N$01: Skip tiles.
  $8D4C,$01 Command (#N$01).
  $8D4D,$01 Skip count: #N(#PEEK(#PC)).
  $8D4E,$01 Tile ID: #R$9C8A(#N$24).
  $8D4F,$01 Tile ID: #R$9C92(#N$25).
  $8D50,$01 Tile ID: #R$9C9A(#N$26).
  $8D51,$01 Tile ID: #R$9C92(#N$25).
  $8D52,$01 Tile ID: #R$9C9A(#N$26).
  $8D53,$01 Tile ID: #R$9C92(#N$25).
  $8D54,$01 Tile ID: #R$9C92(#N$25).
  $8D55,$01 Tile ID: #R$9CA2(#N$27).
N $8D56 Command #N$03: Fill attribute buffer.
  $8D56,$01 Command (#N$03).
  $8D57,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
  $8D58,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8D59 Attribute overlay: repeat colour.
  $8D59,$01 Opcode (#N$1B).
  $8D5A,$01 Repeat count: #N(#PEEK(#PC)).
  $8D5B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D5C Attribute overlay: skip.
  $8D5C,$01 Opcode (#N$12).
  $8D5D,$01 Skip count: #N(#PEEK(#PC)).
N $8D5E Attribute overlay: repeat colour.
  $8D5E,$01 Opcode (#N$1B).
  $8D5F,$01 Repeat count: #N(#PEEK(#PC)).
  $8D60,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D61 Attribute overlay: skip.
  $8D61,$01 Opcode (#N$12).
  $8D62,$01 Skip count: #N(#PEEK(#PC)).
N $8D63 Attribute overlay: repeat colour.
  $8D63,$01 Opcode (#N$1B).
  $8D64,$01 Repeat count: #N(#PEEK(#PC)).
  $8D65,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D66 Attribute overlay: skip.
  $8D66,$01 Opcode (#N$12).
  $8D67,$01 Skip count: #N(#PEEK(#PC)).
N $8D68 Attribute overlay: repeat colour.
  $8D68,$01 Opcode (#N$1B).
  $8D69,$01 Repeat count: #N(#PEEK(#PC)).
  $8D6A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D6B Attribute overlay: skip.
  $8D6B,$01 Opcode (#N$12).
  $8D6C,$01 Skip count: #N(#PEEK(#PC)).
N $8D6D Attribute overlay: repeat colour.
  $8D6D,$01 Opcode (#N$1B).
  $8D6E,$01 Repeat count: #N(#PEEK(#PC)).
  $8D6F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D70 Attribute overlay: skip.
  $8D70,$01 Opcode (#N$12).
  $8D71,$01 Skip count: #N(#PEEK(#PC)).
N $8D72 Attribute overlay: repeat colour.
  $8D72,$01 Opcode (#N$1B).
  $8D73,$01 Repeat count: #N(#PEEK(#PC)).
  $8D74,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D75 Attribute overlay: skip.
  $8D75,$01 Opcode (#N$12).
  $8D76,$01 Skip count: #N(#PEEK(#PC)).
N $8D77 Attribute overlay: repeat colour.
  $8D77,$01 Opcode (#N$1B).
  $8D78,$01 Repeat count: #N(#PEEK(#PC)).
  $8D79,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D7A Attribute overlay: skip.
  $8D7A,$01 Opcode (#N$12).
  $8D7B,$01 Skip count: #N(#PEEK(#PC)).
N $8D7C Attribute overlay: repeat colour.
  $8D7C,$01 Opcode (#N$1B).
  $8D7D,$01 Repeat count: #N(#PEEK(#PC)).
  $8D7E,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D7F Attribute overlay: skip.
  $8D7F,$01 Opcode (#N$12).
  $8D80,$01 Skip count: #N(#PEEK(#PC)).
N $8D81 Attribute overlay: repeat colour.
  $8D81,$01 Opcode (#N$1B).
  $8D82,$01 Repeat count: #N(#PEEK(#PC)).
  $8D83,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8D84,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D85,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D86,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D87,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8D88 Attribute overlay: skip.
  $8D88,$01 Opcode (#N$12).
  $8D89,$01 Skip count: #N(#PEEK(#PC)).
  $8D8A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D8B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D8C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D8D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D8E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8D8F Attribute overlay: skip.
  $8D8F,$01 Opcode (#N$12).
  $8D90,$01 Skip count: #N(#PEEK(#PC)).
N $8D91 Attribute overlay: repeat colour.
  $8D91,$01 Opcode (#N$1B).
  $8D92,$01 Repeat count: #N(#PEEK(#PC)).
  $8D93,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8D94 Attribute overlay: skip.
  $8D94,$01 Opcode (#N$12).
  $8D95,$01 Skip count: #N(#PEEK(#PC)).
N $8D96 Attribute overlay: repeat colour.
  $8D96,$01 Opcode (#N$1B).
  $8D97,$01 Repeat count: #N(#PEEK(#PC)).
  $8D98,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8D99,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D9A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D9B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8D9C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8D9D Attribute overlay: skip.
  $8D9D,$01 Opcode (#N$12).
  $8D9E,$01 Skip count: #N(#PEEK(#PC)).
  $8D9F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DA6 Attribute overlay: skip.
  $8DA6,$01 Opcode (#N$12).
  $8DA7,$01 Skip count: #N(#PEEK(#PC)).
  $8DA8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DA9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DAA Attribute overlay: skip.
  $8DAA,$01 Opcode (#N$12).
  $8DAB,$01 Skip count: #N(#PEEK(#PC)).
  $8DAC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DAD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DAE Attribute overlay: skip.
  $8DAE,$01 Opcode (#N$12).
  $8DAF,$01 Skip count: #N(#PEEK(#PC)).
  $8DB0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DB1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DB2 Attribute overlay: skip.
  $8DB2,$01 Opcode (#N$12).
  $8DB3,$01 Skip count: #N(#PEEK(#PC)).
  $8DB4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DB5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DB6 Attribute overlay: skip.
  $8DB6,$01 Opcode (#N$12).
  $8DB7,$01 Skip count: #N(#PEEK(#PC)).
  $8DB8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DB9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DBA Attribute overlay: skip.
  $8DBA,$01 Opcode (#N$12).
  $8DBB,$01 Skip count: #N(#PEEK(#PC)).
  $8DBC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DBD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DBE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DBF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DC0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DC1 Attribute overlay: repeat colour.
  $8DC1,$01 Opcode (#N$1B).
  $8DC2,$01 Repeat count: #N(#PEEK(#PC)).
  $8DC3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DC4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DC5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DC6 Attribute overlay: repeat colour.
  $8DC6,$01 Opcode (#N$1B).
  $8DC7,$01 Repeat count: #N(#PEEK(#PC)).
  $8DC8,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DC9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DCA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DCB Attribute overlay: repeat colour.
  $8DCB,$01 Opcode (#N$1B).
  $8DCC,$01 Repeat count: #N(#PEEK(#PC)).
  $8DCD,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DCE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DCF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DD0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DD1 Attribute overlay: repeat colour.
  $8DD1,$01 Opcode (#N$1B).
  $8DD2,$01 Repeat count: #N(#PEEK(#PC)).
  $8DD3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DD4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DD5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DD6 Attribute overlay: repeat colour.
  $8DD6,$01 Opcode (#N$1B).
  $8DD7,$01 Repeat count: #N(#PEEK(#PC)).
  $8DD8,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DD9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DDA Attribute overlay: repeat colour.
  $8DDA,$01 Opcode (#N$1B).
  $8DDB,$01 Repeat count: #N(#PEEK(#PC)).
  $8DDC,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DDD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DDE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DDF Attribute overlay: repeat colour.
  $8DDF,$01 Opcode (#N$1B).
  $8DE0,$01 Repeat count: #N(#PEEK(#PC)).
  $8DE1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DE2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DE3 Attribute overlay: repeat colour.
  $8DE3,$01 Opcode (#N$1B).
  $8DE4,$01 Repeat count: #N(#PEEK(#PC)).
  $8DE5,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8DE6 Attribute overlay: repeat colour.
  $8DE6,$01 Opcode (#N$1B).
  $8DE7,$01 Repeat count: #N(#PEEK(#PC)).
  $8DE8,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8DE9 Attribute overlay: repeat colour.
  $8DE9,$01 Opcode (#N$1B).
  $8DEA,$01 Repeat count: #N(#PEEK(#PC)).
  $8DEB,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DEC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DED Attribute overlay: repeat colour.
  $8DED,$01 Opcode (#N$1B).
  $8DEE,$01 Repeat count: #N(#PEEK(#PC)).
  $8DEF,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DF0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DF1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DF2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DF3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DF4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8DF5 Attribute overlay: repeat colour.
  $8DF5,$01 Opcode (#N$1B).
  $8DF6,$01 Repeat count: #N(#PEEK(#PC)).
  $8DF7,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8DF8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DF9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8DFF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8E00,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8E01,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8E02 Attribute overlay: repeat colour.
  $8E02,$01 Opcode (#N$1B).
  $8E03,$01 Repeat count: #N(#PEEK(#PC)).
  $8E04,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8E05 Attribute overlay: repeat colour.
  $8E05,$01 Opcode (#N$1B).
  $8E06,$01 Repeat count: #N(#PEEK(#PC)).
  $8E07,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8E08 Attribute overlay: repeat colour.
  $8E08,$01 Opcode (#N$1B).
  $8E09,$01 Repeat count: #N(#PEEK(#PC)).
  $8E0A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8E0B Attribute overlay: repeat colour.
  $8E0B,$01 Opcode (#N$1B).
  $8E0C,$01 Repeat count: #N(#PEEK(#PC)).
  $8E0D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8E0E,$01 End of attribute overlay.
  $8E0F,$01 Terminator.

b $8E10 Room #N$07
@ $8E10 label=Room07
D $8E10 #ROOM$07
N $8E10 Command #N$01: Skip tiles.
  $8E10,$01 Command (#N$01).
  $8E11,$01 Skip count: #N(#PEEK(#PC)).
  $8E12,$01 Tile ID: #R$9BC2(#N$0B).
N $8E13 Command #N$01: Skip tiles.
  $8E13,$01 Command (#N$01).
  $8E14,$01 Skip count: #N(#PEEK(#PC)).
  $8E15,$01 Tile ID: #R$9BB2(#N$09).
  $8E16,$01 Tile ID: #R$9BBA(#N$0A).
  $8E17,$01 Tile ID: #R$9BC2(#N$0B).
  $8E18,$01 Tile ID: #R$9BCA(#N$0C).
  $8E19,$01 Tile ID: #R$9BE2(#N$0F).
N $8E1A Command #N$01: Skip tiles.
  $8E1A,$01 Command (#N$01).
  $8E1B,$01 Skip count: #N(#PEEK(#PC)).
  $8E1C,$01 Tile ID: #R$9BB2(#N$09).
  $8E1D,$01 Tile ID: #R$9BBA(#N$0A).
  $8E1E,$01 Tile ID: #R$9BC2(#N$0B).
  $8E1F,$01 Tile ID: #R$9BCA(#N$0C).
  $8E20,$01 Tile ID: #R$9BD2(#N$0D).
N $8E21 Command #N$01: Skip tiles.
  $8E21,$01 Command (#N$01).
  $8E22,$01 Skip count: #N(#PEEK(#PC)).
  $8E23,$01 Tile ID: #R$9BAA(#N$08).
N $8E24 Command #N$01: Skip tiles.
  $8E24,$01 Command (#N$01).
  $8E25,$01 Skip count: #N(#PEEK(#PC)).
  $8E26,$01 Tile ID: #R$9BAA(#N$08).
N $8E27 Command #N$01: Skip tiles.
  $8E27,$01 Command (#N$01).
  $8E28,$01 Skip count: #N(#PEEK(#PC)).
  $8E29,$01 Tile ID: #R$9BEA(#N$10).
N $8E2A Command #N$01: Skip tiles.
  $8E2A,$01 Command (#N$01).
  $8E2B,$01 Skip count: #N(#PEEK(#PC)).
  $8E2C,$01 Tile ID: #R$9BAA(#N$08).
N $8E2D Command #N$01: Skip tiles.
  $8E2D,$01 Command (#N$01).
  $8E2E,$01 Skip count: #N(#PEEK(#PC)).
  $8E2F,$01 Tile ID: #R$9BDA(#N$0E).
  $8E30,$01 Tile ID: #R$9BD2(#N$0D).
  $8E31,$01 Tile ID: #R$9C4A(#N$1C).
N $8E32 Command #N$01: Skip tiles.
  $8E32,$01 Command (#N$01).
  $8E33,$01 Skip count: #N(#PEEK(#PC)).
  $8E34,$01 Tile ID: #R$9C02(#N$13).
  $8E35,$01 Tile ID: #R$9C2A(#N$18).
  $8E36,$01 Tile ID: #R$9C22(#N$17).
  $8E37,$01 Tile ID: #R$9C1A(#N$16).
  $8E38,$01 Tile ID: #R$9C12(#N$15).
N $8E39 Command #N$01: Skip tiles.
  $8E39,$01 Command (#N$01).
  $8E3A,$01 Skip count: #N(#PEEK(#PC)).
  $8E3B,$01 Tile ID: #R$9C4A(#N$1C).
N $8E3C Command #N$01: Skip tiles.
  $8E3C,$01 Command (#N$01).
  $8E3D,$01 Skip count: #N(#PEEK(#PC)).
  $8E3E,$01 Tile ID: #R$9C42(#N$1B).
N $8E3F Command #N$01: Skip tiles.
  $8E3F,$01 Command (#N$01).
  $8E40,$01 Skip count: #N(#PEEK(#PC)).
  $8E41,$01 Tile ID: #R$9C3A(#N$1A).
N $8E42 Command #N$01: Skip tiles.
  $8E42,$01 Command (#N$01).
  $8E43,$01 Skip count: #N(#PEEK(#PC)).
  $8E44,$01 Tile ID: #R$9C0A(#N$14).
N $8E45 Command #N$01: Skip tiles.
  $8E45,$01 Command (#N$01).
  $8E46,$01 Skip count: #N(#PEEK(#PC)).
  $8E47,$01 Tile ID: #R$9C2A(#N$18).
  $8E48,$01 Tile ID: #R$9C22(#N$17).
  $8E49,$01 Tile ID: #R$9C1A(#N$16).
  $8E4A,$01 Tile ID: #R$9C12(#N$15).
  $8E4B,$01 Tile ID: #R$9C02(#N$13).
  $8E4C,$01 Tile ID: #R$9C02(#N$13).
  $8E4D,$01 Tile ID: #R$9C2A(#N$18).
  $8E4E,$01 Tile ID: #R$9C22(#N$17).
N $8E4F Command #N$01: Skip tiles.
  $8E4F,$01 Command (#N$01).
  $8E50,$01 Skip count: #N(#PEEK(#PC)).
N $8E51 Command #N$02: Draw repeated tile.
  $8E51,$01 Command (#N$02).
  $8E52,$01 Repeat count: #N(#PEEK(#PC)).
  $8E53,$01 Tile ID: #R$A27A(#N$E2).
N $8E54 Command #N$01: Skip tiles.
  $8E54,$01 Command (#N$01).
  $8E55,$01 Skip count: #N(#PEEK(#PC)).
  $8E56,$01 Tile ID: #R$A30A(#N$F4).
N $8E57 Command #N$01: Skip tiles.
  $8E57,$01 Command (#N$01).
  $8E58,$01 Skip count: #N(#PEEK(#PC)).
  $8E59,$01 Tile ID: #R$A30A(#N$F4).
N $8E5A Command #N$01: Skip tiles.
  $8E5A,$01 Command (#N$01).
  $8E5B,$01 Skip count: #N(#PEEK(#PC)).
  $8E5C,$01 Tile ID: #R$A30A(#N$F4).
N $8E5D Command #N$01: Skip tiles.
  $8E5D,$01 Command (#N$01).
  $8E5E,$01 Skip count: #N(#PEEK(#PC)).
N $8E5F Command #N$02: Draw repeated tile.
  $8E5F,$01 Command (#N$02).
  $8E60,$01 Repeat count: #N(#PEEK(#PC)).
  $8E61,$01 Tile ID: #R$A27A(#N$E2).
N $8E62 Command #N$01: Skip tiles.
  $8E62,$01 Command (#N$01).
  $8E63,$01 Skip count: #N(#PEEK(#PC)).
  $8E64,$01 Tile ID: #R$A30A(#N$F4).
N $8E65 Command #N$01: Skip tiles.
  $8E65,$01 Command (#N$01).
  $8E66,$01 Skip count: #N(#PEEK(#PC)).
  $8E67,$01 Tile ID: #R$A30A(#N$F4).
N $8E68 Command #N$01: Skip tiles.
  $8E68,$01 Command (#N$01).
  $8E69,$01 Skip count: #N(#PEEK(#PC)).
  $8E6A,$01 Tile ID: #R$A102(#N$B3).
  $8E6B,$01 Tile ID: #R$A10A(#N$B4).
  $8E6C,$01 Tile ID: #R$A112(#N$B5).
N $8E6D Command #N$01: Skip tiles.
  $8E6D,$01 Command (#N$01).
  $8E6E,$01 Skip count: #N(#PEEK(#PC)).
  $8E6F,$01 Tile ID: #R$A30A(#N$F4).
  $8E70,$01 Tile ID: #R$A302(#N$F3).
  $8E71,$01 Tile ID: #R$A2FA(#N$F2).
  $8E72,$01 Tile ID: #R$A302(#N$F3).
  $8E73,$01 Tile ID: #R$A302(#N$F3).
  $8E74,$01 Tile ID: #R$A2FA(#N$F2).
  $8E75,$01 Tile ID: #R$A302(#N$F3).
  $8E76,$01 Tile ID: #R$A302(#N$F3).
  $8E77,$01 Tile ID: #R$A2FA(#N$F2).
  $8E78,$01 Tile ID: #R$A302(#N$F3).
  $8E79,$01 Tile ID: #R$A302(#N$F3).
N $8E7A Command #N$02: Draw repeated tile.
  $8E7A,$01 Command (#N$02).
  $8E7B,$01 Repeat count: #N(#PEEK(#PC)).
  $8E7C,$01 Tile ID: #R$A28A(#N$E4).
  $8E7D,$01 Tile ID: #R$A302(#N$F3).
  $8E7E,$01 Tile ID: #R$A2FA(#N$F2).
  $8E7F,$01 Tile ID: #R$A302(#N$F3).
  $8E80,$01 Tile ID: #R$A302(#N$F3).
  $8E81,$01 Tile ID: #R$A2FA(#N$F2).
  $8E82,$01 Tile ID: #R$A302(#N$F3).
  $8E83,$01 Tile ID: #R$A302(#N$F3).
  $8E84,$01 Tile ID: #R$A11A(#N$B6).
  $8E85,$01 Tile ID: #R$A122(#N$B7).
  $8E86,$01 Tile ID: #R$A12A(#N$B8).
N $8E87 Command #N$02: Draw repeated tile.
  $8E87,$01 Command (#N$02).
  $8E88,$01 Repeat count: #N(#PEEK(#PC)).
  $8E89,$01 Tile ID: #R$A302(#N$F3).
  $8E8A,$01 Tile ID: #R$A2FA(#N$F2).
N $8E8B Command #N$01: Skip tiles.
  $8E8B,$01 Command (#N$01).
  $8E8C,$01 Skip count: #N(#PEEK(#PC)).
  $8E8D,$01 Tile ID: #R$A00A(#N$94).
N $8E8E Command #N$01: Skip tiles.
  $8E8E,$01 Command (#N$01).
  $8E8F,$01 Skip count: #N(#PEEK(#PC)).
  $8E90,$01 Tile ID: #R$A00A(#N$94).
N $8E91 Command #N$01: Skip tiles.
  $8E91,$01 Command (#N$01).
  $8E92,$01 Skip count: #N(#PEEK(#PC)).
  $8E93,$01 Tile ID: #R$A00A(#N$94).
N $8E94 Command #N$01: Skip tiles.
  $8E94,$01 Command (#N$01).
  $8E95,$01 Skip count: #N(#PEEK(#PC)).
  $8E96,$01 Tile ID: #R$A00A(#N$94).
N $8E97 Command #N$01: Skip tiles.
  $8E97,$01 Command (#N$01).
  $8E98,$01 Skip count: #N(#PEEK(#PC)).
  $8E99,$01 Tile ID: #R$A022(#N$97).
N $8E9A Command #N$01: Skip tiles.
  $8E9A,$01 Command (#N$01).
  $8E9B,$01 Skip count: #N(#PEEK(#PC)).
  $8E9C,$01 Tile ID: #R$9FEA(#N$90).
N $8E9D Command #N$01: Skip tiles.
  $8E9D,$01 Command (#N$01).
  $8E9E,$01 Skip count: #N(#PEEK(#PC)).
  $8E9F,$01 Tile ID: #R$A02A(#N$98).
  $8EA0,$01 Tile ID: #R$A032(#N$99).
N $8EA1 Command #N$01: Skip tiles.
  $8EA1,$01 Command (#N$01).
  $8EA2,$01 Skip count: #N(#PEEK(#PC)).
  $8EA3,$01 Tile ID: #R$A28A(#N$E4).
  $8EA4,$01 Tile ID: #R$A28A(#N$E4).
  $8EA5,$01 Tile ID: #R$A282(#N$E3).
  $8EA6,$01 Tile ID: #R$A28A(#N$E4).
  $8EA7,$01 Tile ID: #R$A282(#N$E3).
  $8EA8,$01 Tile ID: #R$A28A(#N$E4).
  $8EA9,$01 Tile ID: #R$A282(#N$E3).
  $8EAA,$01 Tile ID: #R$A28A(#N$E4).
N $8EAB Command #N$01: Skip tiles.
  $8EAB,$01 Command (#N$01).
  $8EAC,$01 Skip count: #N(#PEEK(#PC)).
  $8EAD,$01 Tile ID: #R$A00A(#N$94).
  $8EAE,$01 Tile ID: #R$A002(#N$93).
  $8EAF,$01 Tile ID: #R$A00A(#N$94).
  $8EB0,$01 Tile ID: #R$A002(#N$93).
  $8EB1,$01 Tile ID: #R$A00A(#N$94).
  $8EB2,$01 Tile ID: #R$A002(#N$93).
  $8EB3,$01 Tile ID: #R$A00A(#N$94).
  $8EB4,$01 Tile ID: #R$A002(#N$93).
N $8EB5 Command #N$01: Skip tiles.
  $8EB5,$01 Command (#N$01).
  $8EB6,$01 Skip count: #N(#PEEK(#PC)).
  $8EB7,$01 Tile ID: #R$A25A(#N$DE).
N $8EB8 Command #N$01: Skip tiles.
  $8EB8,$01 Command (#N$01).
  $8EB9,$01 Skip count: #N(#PEEK(#PC)).
  $8EBA,$01 Tile ID: #R$A25A(#N$DE).
N $8EBB Command #N$01: Skip tiles.
  $8EBB,$01 Command (#N$01).
  $8EBC,$01 Skip count: #N(#PEEK(#PC)).
  $8EBD,$01 Tile ID: #R$A25A(#N$DE).
N $8EBE Command #N$01: Skip tiles.
  $8EBE,$01 Command (#N$01).
  $8EBF,$01 Skip count: #N(#PEEK(#PC)).
  $8EC0,$01 Tile ID: #R$9C82(#N$23).
  $8EC1,$01 Tile ID: #R$9C82(#N$23).
N $8EC2 Command #N$01: Skip tiles.
  $8EC2,$01 Command (#N$01).
  $8EC3,$01 Skip count: #N(#PEEK(#PC)).
  $8EC4,$01 Tile ID: #R$9C82(#N$23).
  $8EC5,$01 Tile ID: #R$9C82(#N$23).
N $8EC6 Command #N$01: Skip tiles.
  $8EC6,$01 Command (#N$01).
  $8EC7,$01 Skip count: #N(#PEEK(#PC)).
N $8EC8 Command #N$02: Draw repeated tile.
  $8EC8,$01 Command (#N$02).
  $8EC9,$01 Repeat count: #N(#PEEK(#PC)).
  $8ECA,$01 Tile ID: #R$9C82(#N$23).
N $8ECB Command #N$01: Skip tiles.
  $8ECB,$01 Command (#N$01).
  $8ECC,$01 Skip count: #N(#PEEK(#PC)).
  $8ECD,$01 Tile ID: #R$9C82(#N$23).
N $8ECE Command #N$01: Skip tiles.
  $8ECE,$01 Command (#N$01).
  $8ECF,$01 Skip count: #N(#PEEK(#PC)).
  $8ED0,$01 Tile ID: #R$9C8A(#N$24).
  $8ED1,$01 Tile ID: #R$9C92(#N$25).
  $8ED2,$01 Tile ID: #R$9C92(#N$25).
  $8ED3,$01 Tile ID: #R$9C9A(#N$26).
  $8ED4,$01 Tile ID: #R$9C92(#N$25).
  $8ED5,$01 Tile ID: #R$9C92(#N$25).
  $8ED6,$01 Tile ID: #R$9CA2(#N$27).
N $8ED7 Command #N$01: Skip tiles.
  $8ED7,$01 Command (#N$01).
  $8ED8,$01 Skip count: #N(#PEEK(#PC)).
  $8ED9,$01 Tile ID: #R$9C8A(#N$24).
N $8EDA Command #N$02: Draw repeated tile.
  $8EDA,$01 Command (#N$02).
  $8EDB,$01 Repeat count: #N(#PEEK(#PC)).
  $8EDC,$01 Tile ID: #R$9C92(#N$25).
  $8EDD,$01 Tile ID: #R$9C9A(#N$26).
  $8EDE,$01 Tile ID: #R$9C92(#N$25).
  $8EDF,$01 Tile ID: #R$9CA2(#N$27).
N $8EE0 Command #N$01: Skip tiles.
  $8EE0,$01 Command (#N$01).
  $8EE1,$01 Skip count: #N(#PEEK(#PC)).
N $8EE2 Command #N$03: Fill attribute buffer.
  $8EE2,$01 Command (#N$03).
  $8EE3,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $8EE4 Attribute overlay: skip.
  $8EE4,$01 Opcode (#N$12).
  $8EE5,$01 Skip count: #N(#PEEK(#PC)).
  $8EE6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8EE7 Attribute overlay: skip.
  $8EE7,$01 Opcode (#N$12).
  $8EE8,$01 Skip count: #N(#PEEK(#PC)).
N $8EE9 Attribute overlay: repeat colour.
  $8EE9,$01 Opcode (#N$1B).
  $8EEA,$01 Repeat count: #N(#PEEK(#PC)).
  $8EEB,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8EEC Attribute overlay: skip.
  $8EEC,$01 Opcode (#N$12).
  $8EED,$01 Skip count: #N(#PEEK(#PC)).
N $8EEE Attribute overlay: repeat colour.
  $8EEE,$01 Opcode (#N$1B).
  $8EEF,$01 Repeat count: #N(#PEEK(#PC)).
  $8EF0,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8EF1 Attribute overlay: skip.
  $8EF1,$01 Opcode (#N$12).
  $8EF2,$01 Skip count: #N(#PEEK(#PC)).
N $8EF3 Attribute overlay: repeat colour.
  $8EF3,$01 Opcode (#N$1B).
  $8EF4,$01 Repeat count: #N(#PEEK(#PC)).
  $8EF5,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8EF6 Attribute overlay: skip.
  $8EF6,$01 Opcode (#N$12).
  $8EF7,$01 Skip count: #N(#PEEK(#PC)).
N $8EF8 Attribute overlay: repeat colour.
  $8EF8,$01 Opcode (#N$1B).
  $8EF9,$01 Repeat count: #N(#PEEK(#PC)).
  $8EFA,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8EFB Attribute overlay: skip.
  $8EFB,$01 Opcode (#N$12).
  $8EFC,$01 Skip count: #N(#PEEK(#PC)).
  $8EFD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8EFE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8EFF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F00,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F01 Attribute overlay: repeat colour.
  $8F01,$01 Opcode (#N$1B).
  $8F02,$01 Repeat count: #N(#PEEK(#PC)).
  $8F03,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F04 Attribute overlay: skip.
  $8F04,$01 Opcode (#N$12).
  $8F05,$01 Skip count: #N(#PEEK(#PC)).
N $8F06 Attribute overlay: repeat colour.
  $8F06,$01 Opcode (#N$1B).
  $8F07,$01 Repeat count: #N(#PEEK(#PC)).
  $8F08,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F09 Attribute overlay: skip.
  $8F09,$01 Opcode (#N$12).
  $8F0A,$01 Skip count: #N(#PEEK(#PC)).
N $8F0B Attribute overlay: repeat colour.
  $8F0B,$01 Opcode (#N$1B).
  $8F0C,$01 Repeat count: #N(#PEEK(#PC)).
  $8F0D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F0E Attribute overlay: skip.
  $8F0E,$01 Opcode (#N$12).
  $8F0F,$01 Skip count: #N(#PEEK(#PC)).
N $8F10 Attribute overlay: repeat colour.
  $8F10,$01 Opcode (#N$1B).
  $8F11,$01 Repeat count: #N(#PEEK(#PC)).
  $8F12,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F13 Attribute overlay: skip.
  $8F13,$01 Opcode (#N$12).
  $8F14,$01 Skip count: #N(#PEEK(#PC)).
N $8F15 Attribute overlay: repeat colour.
  $8F15,$01 Opcode (#N$1B).
  $8F16,$01 Repeat count: #N(#PEEK(#PC)).
  $8F17,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F18,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F19 Attribute overlay: repeat colour.
  $8F19,$01 Opcode (#N$1B).
  $8F1A,$01 Repeat count: #N(#PEEK(#PC)).
  $8F1B,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F1C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F1D Attribute overlay: repeat colour.
  $8F1D,$01 Opcode (#N$1B).
  $8F1E,$01 Repeat count: #N(#PEEK(#PC)).
  $8F1F,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F20,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F21,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F22,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F23,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F24,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F25,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F26,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F27,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F28 Attribute overlay: repeat colour.
  $8F28,$01 Opcode (#N$1B).
  $8F29,$01 Repeat count: #N(#PEEK(#PC)).
  $8F2A,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F2B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F2C Attribute overlay: repeat colour.
  $8F2C,$01 Opcode (#N$1B).
  $8F2D,$01 Repeat count: #N(#PEEK(#PC)).
  $8F2E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F2F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F30 Attribute overlay: repeat colour.
  $8F30,$01 Opcode (#N$1B).
  $8F31,$01 Repeat count: #N(#PEEK(#PC)).
  $8F32,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F33 Attribute overlay: repeat colour.
  $8F33,$01 Opcode (#N$1B).
  $8F34,$01 Repeat count: #N(#PEEK(#PC)).
  $8F35,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F36 Attribute overlay: repeat colour.
  $8F36,$01 Opcode (#N$1B).
  $8F37,$01 Repeat count: #N(#PEEK(#PC)).
  $8F38,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F39 Attribute overlay: repeat colour.
  $8F39,$01 Opcode (#N$1B).
  $8F3A,$01 Repeat count: #N(#PEEK(#PC)).
  $8F3B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F3C Attribute overlay: repeat colour.
  $8F3C,$01 Opcode (#N$1B).
  $8F3D,$01 Repeat count: #N(#PEEK(#PC)).
  $8F3E,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F3F Attribute overlay: repeat colour.
  $8F3F,$01 Opcode (#N$1B).
  $8F40,$01 Repeat count: #N(#PEEK(#PC)).
  $8F41,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F42 Attribute overlay: repeat colour.
  $8F42,$01 Opcode (#N$1B).
  $8F43,$01 Repeat count: #N(#PEEK(#PC)).
  $8F44,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F45,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F46,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F47,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F48,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F49,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F4A Attribute overlay: repeat colour.
  $8F4A,$01 Opcode (#N$1B).
  $8F4B,$01 Repeat count: #N(#PEEK(#PC)).
  $8F4C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F4D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F4E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F4F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F50,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F51,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $8F52 Attribute overlay: repeat colour.
  $8F52,$01 Opcode (#N$1B).
  $8F53,$01 Repeat count: #N(#PEEK(#PC)).
  $8F54,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F55 Attribute overlay: repeat colour.
  $8F55,$01 Opcode (#N$1B).
  $8F56,$01 Repeat count: #N(#PEEK(#PC)).
  $8F57,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F58 Attribute overlay: repeat colour.
  $8F58,$01 Opcode (#N$1B).
  $8F59,$01 Repeat count: #N(#PEEK(#PC)).
  $8F5A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $8F5B Attribute overlay: repeat colour.
  $8F5B,$01 Opcode (#N$1B).
  $8F5C,$01 Repeat count: #N(#PEEK(#PC)).
  $8F5D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $8F5E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F5F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F60,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $8F61,$01 End of attribute overlay.
  $8F62,$01 Terminator.

b $8F63 Room #N$08
@ $8F63 label=Room08
D $8F63 #ROOM$08
N $8F63 Command #N$01: Skip tiles.
  $8F63,$01 Command (#N$01).
  $8F64,$01 Skip count: #N(#PEEK(#PC)).
  $8F65,$01 Tile ID: #R$9BCA(#N$0C).
  $8F66,$01 Tile ID: #R$9BD2(#N$0D).
  $8F67,$01 Tile ID: #R$9BB2(#N$09).
  $8F68,$01 Tile ID: #R$9BBA(#N$0A).
N $8F69 Command #N$01: Skip tiles.
  $8F69,$01 Command (#N$01).
  $8F6A,$01 Skip count: #N(#PEEK(#PC)).
  $8F6B,$01 Tile ID: #R$9BDA(#N$0E).
  $8F6C,$01 Tile ID: #R$9BCA(#N$0C).
  $8F6D,$01 Tile ID: #R$9BCA(#N$0C).
  $8F6E,$01 Tile ID: #R$9BE2(#N$0F).
N $8F6F Command #N$01: Skip tiles.
  $8F6F,$01 Command (#N$01).
  $8F70,$01 Skip count: #N(#PEEK(#PC)).
  $8F71,$01 Tile ID: #R$9BB2(#N$09).
  $8F72,$01 Tile ID: #R$9BBA(#N$0A).
  $8F73,$01 Tile ID: #R$9BC2(#N$0B).
  $8F74,$01 Tile ID: #R$9BCA(#N$0C).
  $8F75,$01 Tile ID: #R$9BD2(#N$0D).
N $8F76 Command #N$01: Skip tiles.
  $8F76,$01 Command (#N$01).
  $8F77,$01 Skip count: #N(#PEEK(#PC)).
  $8F78,$01 Tile ID: #R$9BEA(#N$10).
N $8F79 Command #N$01: Skip tiles.
  $8F79,$01 Command (#N$01).
  $8F7A,$01 Skip count: #N(#PEEK(#PC)).
  $8F7B,$01 Tile ID: #R$9BAA(#N$08).
N $8F7C Command #N$01: Skip tiles.
  $8F7C,$01 Command (#N$01).
  $8F7D,$01 Skip count: #N(#PEEK(#PC)).
  $8F7E,$01 Tile ID: #R$9BDA(#N$0E).
  $8F7F,$01 Tile ID: #R$9BE2(#N$0F).
N $8F80 Command #N$01: Skip tiles.
  $8F80,$01 Command (#N$01).
  $8F81,$01 Skip count: #N(#PEEK(#PC)).
  $8F82,$01 Tile ID: #R$9BEA(#N$10).
N $8F83 Command #N$01: Skip tiles.
  $8F83,$01 Command (#N$01).
  $8F84,$01 Skip count: #N(#PEEK(#PC)).
  $8F85,$01 Tile ID: #R$9C4A(#N$1C).
N $8F86 Command #N$01: Skip tiles.
  $8F86,$01 Command (#N$01).
  $8F87,$01 Skip count: #N(#PEEK(#PC)).
  $8F88,$01 Tile ID: #R$9BEA(#N$10).
N $8F89 Command #N$01: Skip tiles.
  $8F89,$01 Command (#N$01).
  $8F8A,$01 Skip count: #N(#PEEK(#PC)).
  $8F8B,$01 Tile ID: #R$9C0A(#N$14).
N $8F8C Command #N$01: Skip tiles.
  $8F8C,$01 Command (#N$01).
  $8F8D,$01 Skip count: #N(#PEEK(#PC)).
  $8F8E,$01 Tile ID: #R$9BF2(#N$11).
N $8F8F Command #N$01: Skip tiles.
  $8F8F,$01 Command (#N$01).
  $8F90,$01 Skip count: #N(#PEEK(#PC)).
  $8F91,$01 Tile ID: #R$9C42(#N$1B).
N $8F92 Command #N$01: Skip tiles.
  $8F92,$01 Command (#N$01).
  $8F93,$01 Skip count: #N(#PEEK(#PC)).
  $8F94,$01 Tile ID: #R$A012(#N$95).
N $8F95 Command #N$02: Draw repeated tile.
  $8F95,$01 Command (#N$02).
  $8F96,$01 Repeat count: #N(#PEEK(#PC)).
  $8F97,$01 Tile ID: #R$A28A(#N$E4).
N $8F98 Command #N$01: Skip tiles.
  $8F98,$01 Command (#N$01).
  $8F99,$01 Skip count: #N(#PEEK(#PC)).
  $8F9A,$01 Tile ID: #R$9BEA(#N$10).
  $8F9B,$01 Tile ID: #R$9C02(#N$13).
  $8F9C,$01 Tile ID: #R$9C2A(#N$18).
  $8F9D,$01 Tile ID: #R$9C22(#N$17).
  $8F9E,$01 Tile ID: #R$9C32(#N$19).
  $8F9F,$01 Tile ID: #R$9BFA(#N$12).
N $8FA0 Command #N$01: Skip tiles.
  $8FA0,$01 Command (#N$01).
  $8FA1,$01 Skip count: #N(#PEEK(#PC)).
  $8FA2,$01 Tile ID: #R$9C3A(#N$1A).
  $8FA3,$01 Tile ID: #R$A012(#N$95).
N $8FA4 Command #N$02: Draw repeated tile.
  $8FA4,$01 Command (#N$02).
  $8FA5,$01 Repeat count: #N(#PEEK(#PC)).
  $8FA6,$01 Tile ID: #R$A00A(#N$94).
  $8FA7,$01 Tile ID: #R$9C1A(#N$16).
  $8FA8,$01 Tile ID: #R$9C12(#N$15).
N $8FA9 Command #N$01: Skip tiles.
  $8FA9,$01 Command (#N$01).
  $8FAA,$01 Skip count: #N(#PEEK(#PC)).
  $8FAB,$01 Tile ID: #R$A00A(#N$94).
  $8FAC,$01 Tile ID: #R$A00A(#N$94).
  $8FAD,$01 Tile ID: #R$A002(#N$93).
  $8FAE,$01 Tile ID: #R$A00A(#N$94).
  $8FAF,$01 Tile ID: #R$A002(#N$93).
  $8FB0,$01 Tile ID: #R$A00A(#N$94).
  $8FB1,$01 Tile ID: #R$A002(#N$93).
  $8FB2,$01 Tile ID: #R$A00A(#N$94).
  $8FB3,$01 Tile ID: #R$A002(#N$93).
  $8FB4,$01 Tile ID: #R$A00A(#N$94).
  $8FB5,$01 Tile ID: #R$A002(#N$93).
  $8FB6,$01 Tile ID: #R$A00A(#N$94).
  $8FB7,$01 Tile ID: #R$A002(#N$93).
  $8FB8,$01 Tile ID: #R$A00A(#N$94).
  $8FB9,$01 Tile ID: #R$A002(#N$93).
  $8FBA,$01 Tile ID: #R$A00A(#N$94).
  $8FBB,$01 Tile ID: #R$A002(#N$93).
N $8FBC Command #N$01: Skip tiles.
  $8FBC,$01 Command (#N$01).
  $8FBD,$01 Skip count: #N(#PEEK(#PC)).
  $8FBE,$01 Tile ID: #R$A00A(#N$94).
  $8FBF,$01 Tile ID: #R$A002(#N$93).
  $8FC0,$01 Tile ID: #R$A00A(#N$94).
N $8FC1 Command #N$01: Skip tiles.
  $8FC1,$01 Command (#N$01).
  $8FC2,$01 Skip count: #N(#PEEK(#PC)).
  $8FC3,$01 Tile ID: #R$A03A(#N$9A).
N $8FC4 Command #N$01: Skip tiles.
  $8FC4,$01 Command (#N$01).
  $8FC5,$01 Skip count: #N(#PEEK(#PC)).
  $8FC6,$01 Tile ID: #R$A05A(#N$9E).
  $8FC7,$01 Tile ID: #R$A06A(#N$A0).
N $8FC8 Command #N$01: Skip tiles.
  $8FC8,$01 Command (#N$01).
  $8FC9,$01 Skip count: #N(#PEEK(#PC)).
  $8FCA,$01 Tile ID: #R$A03A(#N$9A).
N $8FCB Command #N$01: Skip tiles.
  $8FCB,$01 Command (#N$01).
  $8FCC,$01 Skip count: #N(#PEEK(#PC)).
  $8FCD,$01 Tile ID: #R$A05A(#N$9E).
  $8FCE,$01 Tile ID: #R$A06A(#N$A0).
N $8FCF Command #N$01: Skip tiles.
  $8FCF,$01 Command (#N$01).
  $8FD0,$01 Skip count: #N(#PEEK(#PC)).
  $8FD1,$01 Tile ID: #R$A00A(#N$94).
  $8FD2,$01 Tile ID: #R$A00A(#N$94).
  $8FD3,$01 Tile ID: #R$A002(#N$93).
N $8FD4 Command #N$01: Skip tiles.
  $8FD4,$01 Command (#N$01).
  $8FD5,$01 Skip count: #N(#PEEK(#PC)).
  $8FD6,$01 Tile ID: #R$A042(#N$9B).
  $8FD7,$01 Tile ID: #R$A04A(#N$9C).
  $8FD8,$01 Tile ID: #R$A052(#N$9D).
  $8FD9,$01 Tile ID: #R$A062(#N$9F).
  $8FDA,$01 Tile ID: #R$A072(#N$A1).
  $8FDB,$01 Tile ID: #R$A07A(#N$A2).
  $8FDC,$01 Tile ID: #R$A042(#N$9B).
  $8FDD,$01 Tile ID: #R$A082(#N$A3).
  $8FDE,$01 Tile ID: #R$A08A(#N$A4).
  $8FDF,$01 Tile ID: #R$A092(#N$A5).
  $8FE0,$01 Tile ID: #R$A09A(#N$A6).
  $8FE1,$01 Tile ID: #R$A0A2(#N$A7).
  $8FE2,$01 Tile ID: #R$A0AA(#N$A8).
N $8FE3 Command #N$01: Skip tiles.
  $8FE3,$01 Command (#N$01).
  $8FE4,$01 Skip count: #N(#PEEK(#PC)).
  $8FE5,$01 Tile ID: #R$A00A(#N$94).
  $8FE6,$01 Tile ID: #R$A002(#N$93).
  $8FE7,$01 Tile ID: #R$A00A(#N$94).
  $8FE8,$01 Tile ID: #R$A002(#N$93).
  $8FE9,$01 Tile ID: #R$A00A(#N$94).
  $8FEA,$01 Tile ID: #R$A002(#N$93).
  $8FEB,$01 Tile ID: #R$A00A(#N$94).
  $8FEC,$01 Tile ID: #R$A002(#N$93).
  $8FED,$01 Tile ID: #R$A00A(#N$94).
  $8FEE,$01 Tile ID: #R$A002(#N$93).
  $8FEF,$01 Tile ID: #R$A00A(#N$94).
  $8FF0,$01 Tile ID: #R$A002(#N$93).
  $8FF1,$01 Tile ID: #R$A00A(#N$94).
  $8FF2,$01 Tile ID: #R$A002(#N$93).
  $8FF3,$01 Tile ID: #R$A00A(#N$94).
  $8FF4,$01 Tile ID: #R$A002(#N$93).
  $8FF5,$01 Tile ID: #R$A00A(#N$94).
N $8FF6 Command #N$01: Skip tiles.
  $8FF6,$01 Command (#N$01).
  $8FF7,$01 Skip count: #N(#PEEK(#PC)).
  $8FF8,$01 Tile ID: #R$A30A(#N$F4).
N $8FF9 Command #N$01: Skip tiles.
  $8FF9,$01 Command (#N$01).
  $8FFA,$01 Skip count: #N(#PEEK(#PC)).
  $8FFB,$01 Tile ID: #R$A00A(#N$94).
  $8FFC,$01 Tile ID: #R$A00A(#N$94).
  $8FFD,$01 Tile ID: #R$A002(#N$93).
  $8FFE,$01 Tile ID: #R$A00A(#N$94).
  $8FFF,$01 Tile ID: #R$A002(#N$93).
  $9000,$01 Tile ID: #R$A00A(#N$94).
N $9001 Command #N$02: Draw repeated tile.
  $9001,$01 Command (#N$02).
  $9002,$01 Repeat count: #N(#PEEK(#PC)).
  $9003,$01 Tile ID: #R$9CB2(#N$29).
  $9004,$01 Tile ID: #R$A302(#N$F3).
  $9005,$01 Tile ID: #R$A302(#N$F3).
  $9006,$01 Tile ID: #R$A25A(#N$DE).
N $9007 Command #N$01: Skip tiles.
  $9007,$01 Command (#N$01).
  $9008,$01 Skip count: #N(#PEEK(#PC)).
  $9009,$01 Tile ID: #R$A00A(#N$94).
N $900A Command #N$01: Skip tiles.
  $900A,$01 Command (#N$01).
  $900B,$01 Skip count: #N(#PEEK(#PC)).
  $900C,$01 Tile ID: #R$A00A(#N$94).
  $900D,$01 Tile ID: #R$A0B2(#N$A9).
N $900E Command #N$01: Skip tiles.
  $900E,$01 Command (#N$01).
  $900F,$01 Skip count: #N(#PEEK(#PC)).
  $9010,$01 Tile ID: #R$A032(#N$99).
  $9011,$01 Tile ID: #R$A032(#N$99).
N $9012 Command #N$01: Skip tiles.
  $9012,$01 Command (#N$01).
  $9013,$01 Skip count: #N(#PEEK(#PC)).
  $9014,$01 Tile ID: #R$A032(#N$99).
  $9015,$01 Tile ID: #R$A032(#N$99).
N $9016 Command #N$01: Skip tiles.
  $9016,$01 Command (#N$01).
  $9017,$01 Skip count: #N(#PEEK(#PC)).
  $9018,$01 Tile ID: #R$A032(#N$99).
  $9019,$01 Tile ID: #R$A032(#N$99).
N $901A Command #N$01: Skip tiles.
  $901A,$01 Command (#N$01).
  $901B,$01 Skip count: #N(#PEEK(#PC)).
  $901C,$01 Tile ID: #R$A00A(#N$94).
N $901D Command #N$01: Skip tiles.
  $901D,$01 Command (#N$01).
  $901E,$01 Skip count: #N(#PEEK(#PC)).
  $901F,$01 Tile ID: #R$A0DA(#N$AE).
  $9020,$01 Tile ID: #R$A0CA(#N$AC).
N $9021 Command #N$01: Skip tiles.
  $9021,$01 Command (#N$01).
  $9022,$01 Skip count: #N(#PEEK(#PC)).
  $9023,$01 Tile ID: #R$A00A(#N$94).
  $9024,$01 Tile ID: #R$A0B2(#N$A9).
N $9025 Command #N$01: Skip tiles.
  $9025,$01 Command (#N$01).
  $9026,$01 Skip count: #N(#PEEK(#PC)).
  $9027,$01 Tile ID: #R$A2BA(#N$EA).
  $9028,$01 Tile ID: #R$A2CA(#N$EC).
N $9029 Command #N$01: Skip tiles.
  $9029,$01 Command (#N$01).
  $902A,$01 Skip count: #N(#PEEK(#PC)).
  $902B,$01 Tile ID: #R$A2DA(#N$EE).
  $902C,$01 Tile ID: #R$A2EA(#N$F0).
N $902D Command #N$01: Skip tiles.
  $902D,$01 Command (#N$01).
  $902E,$01 Skip count: #N(#PEEK(#PC)).
  $902F,$01 Tile ID: #R$A2BA(#N$EA).
  $9030,$01 Tile ID: #R$A2CA(#N$EC).
N $9031 Command #N$01: Skip tiles.
  $9031,$01 Command (#N$01).
  $9032,$01 Skip count: #N(#PEEK(#PC)).
  $9033,$01 Tile ID: #R$A00A(#N$94).
N $9034 Command #N$01: Skip tiles.
  $9034,$01 Command (#N$01).
  $9035,$01 Skip count: #N(#PEEK(#PC)).
  $9036,$01 Tile ID: #R$A0B2(#N$A9).
  $9037,$01 Tile ID: #R$A0BA(#N$AA).
N $9038 Command #N$01: Skip tiles.
  $9038,$01 Command (#N$01).
  $9039,$01 Skip count: #N(#PEEK(#PC)).
  $903A,$01 Tile ID: #R$A00A(#N$94).
  $903B,$01 Tile ID: #R$A0B2(#N$A9).
N $903C Command #N$01: Skip tiles.
  $903C,$01 Command (#N$01).
  $903D,$01 Skip count: #N(#PEEK(#PC)).
  $903E,$01 Tile ID: #R$A2C2(#N$EB).
  $903F,$01 Tile ID: #R$A2D2(#N$ED).
N $9040 Command #N$01: Skip tiles.
  $9040,$01 Command (#N$01).
  $9041,$01 Skip count: #N(#PEEK(#PC)).
  $9042,$01 Tile ID: #R$A2E2(#N$EF).
  $9043,$01 Tile ID: #R$A2F2(#N$F1).
N $9044 Command #N$01: Skip tiles.
  $9044,$01 Command (#N$01).
  $9045,$01 Skip count: #N(#PEEK(#PC)).
  $9046,$01 Tile ID: #R$A2C2(#N$EB).
  $9047,$01 Tile ID: #R$A2D2(#N$ED).
N $9048 Command #N$01: Skip tiles.
  $9048,$01 Command (#N$01).
  $9049,$01 Skip count: #N(#PEEK(#PC)).
  $904A,$01 Tile ID: #R$A262(#N$DF).
  $904B,$01 Tile ID: #R$A25A(#N$DE).
N $904C Command #N$01: Skip tiles.
  $904C,$01 Command (#N$01).
  $904D,$01 Skip count: #N(#PEEK(#PC)).
  $904E,$01 Tile ID: #R$A00A(#N$94).
N $904F Command #N$01: Skip tiles.
  $904F,$01 Command (#N$01).
  $9050,$01 Skip count: #N(#PEEK(#PC)).
  $9051,$01 Tile ID: #R$A0E2(#N$AF).
  $9052,$01 Tile ID: #R$A0D2(#N$AD).
N $9053 Command #N$01: Skip tiles.
  $9053,$01 Command (#N$01).
  $9054,$01 Skip count: #N(#PEEK(#PC)).
  $9055,$01 Tile ID: #R$A00A(#N$94).
  $9056,$01 Tile ID: #R$A0B2(#N$A9).
N $9057 Command #N$01: Skip tiles.
  $9057,$01 Command (#N$01).
  $9058,$01 Skip count: #N(#PEEK(#PC)).
  $9059,$01 Tile ID: #R$9CB2(#N$29).
  $905A,$01 Tile ID: #R$9CB2(#N$29).
N $905B Command #N$01: Skip tiles.
  $905B,$01 Command (#N$01).
  $905C,$01 Skip count: #N(#PEEK(#PC)).
  $905D,$01 Tile ID: #R$9CB2(#N$29).
  $905E,$01 Tile ID: #R$9CB2(#N$29).
N $905F Command #N$01: Skip tiles.
  $905F,$01 Command (#N$01).
  $9060,$01 Skip count: #N(#PEEK(#PC)).
  $9061,$01 Tile ID: #R$9CB2(#N$29).
  $9062,$01 Tile ID: #R$9CB2(#N$29).
N $9063 Command #N$01: Skip tiles.
  $9063,$01 Command (#N$01).
  $9064,$01 Skip count: #N(#PEEK(#PC)).
  $9065,$01 Tile ID: #R$A02A(#N$98).
  $9066,$01 Tile ID: #R$A26A(#N$E0).
N $9067 Command #N$01: Skip tiles.
  $9067,$01 Command (#N$01).
  $9068,$01 Skip count: #N(#PEEK(#PC)).
  $9069,$01 Tile ID: #R$A00A(#N$94).
  $906A,$01 Tile ID: #R$9F22(#N$77).
N $906B Command #N$01: Skip tiles.
  $906B,$01 Command (#N$01).
  $906C,$01 Skip count: #N(#PEEK(#PC)).
  $906D,$01 Tile ID: #R$A00A(#N$94).
  $906E,$01 Tile ID: #R$A0E2(#N$AF).
N $906F Command #N$02: Draw repeated tile.
  $906F,$01 Command (#N$02).
  $9070,$01 Repeat count: #N(#PEEK(#PC)).
  $9071,$01 Tile ID: #R$A032(#N$99).
N $9072 Command #N$01: Skip tiles.
  $9072,$01 Command (#N$01).
  $9073,$01 Skip count: #N(#PEEK(#PC)).
  $9074,$01 Tile ID: #R$A262(#N$DF).
  $9075,$01 Tile ID: #R$A25A(#N$DE).
N $9076 Command #N$01: Skip tiles.
  $9076,$01 Command (#N$01).
  $9077,$01 Skip count: #N(#PEEK(#PC)).
  $9078,$01 Tile ID: #R$A152(#N$BD).
  $9079,$01 Tile ID: #R$A00A(#N$94).
N $907A Command #N$01: Skip tiles.
  $907A,$01 Command (#N$01).
  $907B,$01 Skip count: #N(#PEEK(#PC)).
  $907C,$01 Tile ID: #R$A00A(#N$94).
  $907D,$01 Tile ID: #R$A002(#N$93).
  $907E,$01 Tile ID: #R$A00A(#N$94).
  $907F,$01 Tile ID: #R$A002(#N$93).
  $9080,$01 Tile ID: #R$A00A(#N$94).
  $9081,$01 Tile ID: #R$A002(#N$93).
  $9082,$01 Tile ID: #R$A00A(#N$94).
  $9083,$01 Tile ID: #R$A002(#N$93).
  $9084,$01 Tile ID: #R$A00A(#N$94).
  $9085,$01 Tile ID: #R$A002(#N$93).
  $9086,$01 Tile ID: #R$A00A(#N$94).
  $9087,$01 Tile ID: #R$A002(#N$93).
N $9088 Command #N$01: Skip tiles.
  $9088,$01 Command (#N$01).
  $9089,$01 Skip count: #N(#PEEK(#PC)).
  $908A,$01 Tile ID: #R$A02A(#N$98).
  $908B,$01 Tile ID: #R$A26A(#N$E0).
N $908C Command #N$01: Skip tiles.
  $908C,$01 Command (#N$01).
  $908D,$01 Skip count: #N(#PEEK(#PC)).
  $908E,$01 Tile ID: #R$A152(#N$BD).
  $908F,$01 Tile ID: #R$A162(#N$BF).
N $9090 Command #N$01: Skip tiles.
  $9090,$01 Command (#N$01).
  $9091,$01 Skip count: #N(#PEEK(#PC)).
  $9092,$01 Tile ID: #R$A152(#N$BD).
  $9093,$01 Tile ID: #R$A012(#N$95).
N $9094 Command #N$02: Draw repeated tile.
  $9094,$01 Command (#N$02).
  $9095,$01 Repeat count: #N(#PEEK(#PC)).
  $9096,$01 Tile ID: #R$A00A(#N$94).
N $9097 Command #N$01: Skip tiles.
  $9097,$01 Command (#N$01).
  $9098,$01 Skip count: #N(#PEEK(#PC)).
N $9099 Command #N$03: Fill attribute buffer.
  $9099,$01 Command (#N$03).
  $909A,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $909B Attribute overlay: skip.
  $909B,$01 Opcode (#N$12).
  $909C,$01 Skip count: #N(#PEEK(#PC)).
N $909D Attribute overlay: repeat colour.
  $909D,$01 Opcode (#N$1B).
  $909E,$01 Repeat count: #N(#PEEK(#PC)).
  $909F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90A0 Attribute overlay: skip.
  $90A0,$01 Opcode (#N$12).
  $90A1,$01 Skip count: #N(#PEEK(#PC)).
N $90A2 Attribute overlay: repeat colour.
  $90A2,$01 Opcode (#N$1B).
  $90A3,$01 Repeat count: #N(#PEEK(#PC)).
  $90A4,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90A5 Attribute overlay: skip.
  $90A5,$01 Opcode (#N$12).
  $90A6,$01 Skip count: #N(#PEEK(#PC)).
N $90A7 Attribute overlay: repeat colour.
  $90A7,$01 Opcode (#N$1B).
  $90A8,$01 Repeat count: #N(#PEEK(#PC)).
  $90A9,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90AA Attribute overlay: skip.
  $90AA,$01 Opcode (#N$12).
  $90AB,$01 Skip count: #N(#PEEK(#PC)).
N $90AC Attribute overlay: repeat colour.
  $90AC,$01 Opcode (#N$1B).
  $90AD,$01 Repeat count: #N(#PEEK(#PC)).
  $90AE,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90AF Attribute overlay: skip.
  $90AF,$01 Opcode (#N$12).
  $90B0,$01 Skip count: #N(#PEEK(#PC)).
N $90B1 Attribute overlay: repeat colour.
  $90B1,$01 Opcode (#N$1B).
  $90B2,$01 Repeat count: #N(#PEEK(#PC)).
  $90B3,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90B4 Attribute overlay: skip.
  $90B4,$01 Opcode (#N$12).
  $90B5,$01 Skip count: #N(#PEEK(#PC)).
  $90B6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90B7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90B8 Attribute overlay: repeat colour.
  $90B8,$01 Opcode (#N$1B).
  $90B9,$01 Repeat count: #N(#PEEK(#PC)).
  $90BA,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90BB Attribute overlay: skip.
  $90BB,$01 Opcode (#N$12).
  $90BC,$01 Skip count: #N(#PEEK(#PC)).
  $90BD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90BE Attribute overlay: repeat colour.
  $90BE,$01 Opcode (#N$1B).
  $90BF,$01 Repeat count: #N(#PEEK(#PC)).
  $90C0,$01 Colour: #COLOUR(#PEEK(#PC)).
  $90C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90C2 Attribute overlay: skip.
  $90C2,$01 Opcode (#N$12).
  $90C3,$01 Skip count: #N(#PEEK(#PC)).
N $90C4 Attribute overlay: repeat colour.
  $90C4,$01 Opcode (#N$1B).
  $90C5,$01 Repeat count: #N(#PEEK(#PC)).
  $90C6,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90C7 Attribute overlay: skip.
  $90C7,$01 Opcode (#N$12).
  $90C8,$01 Skip count: #N(#PEEK(#PC)).
N $90C9 Attribute overlay: repeat colour.
  $90C9,$01 Opcode (#N$1B).
  $90CA,$01 Repeat count: #N(#PEEK(#PC)).
  $90CB,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90CC Attribute overlay: skip.
  $90CC,$01 Opcode (#N$12).
  $90CD,$01 Skip count: #N(#PEEK(#PC)).
  $90CE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90CF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90D0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90D1 Attribute overlay: repeat colour.
  $90D1,$01 Opcode (#N$1B).
  $90D2,$01 Repeat count: #N(#PEEK(#PC)).
  $90D3,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90D4 Attribute overlay: skip.
  $90D4,$01 Opcode (#N$12).
  $90D5,$01 Skip count: #N(#PEEK(#PC)).
  $90D6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90D7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90D8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90D9 Attribute overlay: repeat colour.
  $90D9,$01 Opcode (#N$1B).
  $90DA,$01 Repeat count: #N(#PEEK(#PC)).
  $90DB,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90DC Attribute overlay: skip.
  $90DC,$01 Opcode (#N$12).
  $90DD,$01 Skip count: #N(#PEEK(#PC)).
N $90DE Attribute overlay: repeat colour.
  $90DE,$01 Opcode (#N$1B).
  $90DF,$01 Repeat count: #N(#PEEK(#PC)).
  $90E0,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90E1 Attribute overlay: skip.
  $90E1,$01 Opcode (#N$12).
  $90E2,$01 Skip count: #N(#PEEK(#PC)).
N $90E3 Attribute overlay: repeat colour.
  $90E3,$01 Opcode (#N$1B).
  $90E4,$01 Repeat count: #N(#PEEK(#PC)).
  $90E5,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90E6 Attribute overlay: repeat colour.
  $90E6,$01 Opcode (#N$1B).
  $90E7,$01 Repeat count: #N(#PEEK(#PC)).
  $90E8,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90E9 Attribute overlay: skip.
  $90E9,$01 Opcode (#N$12).
  $90EA,$01 Skip count: #N(#PEEK(#PC)).
  $90EB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90EC Attribute overlay: repeat colour.
  $90EC,$01 Opcode (#N$1B).
  $90ED,$01 Repeat count: #N(#PEEK(#PC)).
  $90EE,$01 Colour: #COLOUR(#PEEK(#PC)).
  $90EF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90F0 Attribute overlay: repeat colour.
  $90F0,$01 Opcode (#N$1B).
  $90F1,$01 Repeat count: #N(#PEEK(#PC)).
  $90F2,$01 Colour: #COLOUR(#PEEK(#PC)).
N $90F3 Attribute overlay: repeat colour.
  $90F3,$01 Opcode (#N$1B).
  $90F4,$01 Repeat count: #N(#PEEK(#PC)).
  $90F5,$01 Colour: #COLOUR(#PEEK(#PC)).
  $90F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $90F8 Attribute overlay: repeat colour.
  $90F8,$01 Opcode (#N$1B).
  $90F9,$01 Repeat count: #N(#PEEK(#PC)).
  $90FA,$01 Colour: #COLOUR(#PEEK(#PC)).
  $90FB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90FC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90FD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90FE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $90FF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9100,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9101,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9102,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9103,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9104,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9105,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9106,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9107,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9108,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9109,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $910A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $910B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $910C Attribute overlay: repeat colour.
  $910C,$01 Opcode (#N$1B).
  $910D,$01 Repeat count: #N(#PEEK(#PC)).
  $910E,$01 Colour: #COLOUR(#PEEK(#PC)).
  $910F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9110,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9111 Attribute overlay: repeat colour.
  $9111,$01 Opcode (#N$1B).
  $9112,$01 Repeat count: #N(#PEEK(#PC)).
  $9113,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9114,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9115,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9116,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9117,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9118,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9119,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $911F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9120,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9121,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9122,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9123,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9124,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9125 Attribute overlay: repeat colour.
  $9125,$01 Opcode (#N$1B).
  $9126,$01 Repeat count: #N(#PEEK(#PC)).
  $9127,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9128,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9129,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $912A Attribute overlay: repeat colour.
  $912A,$01 Opcode (#N$1B).
  $912B,$01 Repeat count: #N(#PEEK(#PC)).
  $912C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $912D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $912E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $912F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9130,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9131,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9132,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9133,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9134,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9135,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9136,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9137,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9138,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9139,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $913A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $913B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $913C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $913D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $913E Attribute overlay: repeat colour.
  $913E,$01 Opcode (#N$1B).
  $913F,$01 Repeat count: #N(#PEEK(#PC)).
  $9140,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9141,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9142,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9143 Attribute overlay: repeat colour.
  $9143,$01 Opcode (#N$1B).
  $9144,$01 Repeat count: #N(#PEEK(#PC)).
  $9145,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9146,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9147 Attribute overlay: repeat colour.
  $9147,$01 Opcode (#N$1B).
  $9148,$01 Repeat count: #N(#PEEK(#PC)).
  $9149,$01 Colour: #COLOUR(#PEEK(#PC)).
  $914A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $914B Attribute overlay: repeat colour.
  $914B,$01 Opcode (#N$1B).
  $914C,$01 Repeat count: #N(#PEEK(#PC)).
  $914D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $914E Attribute overlay: repeat colour.
  $914E,$01 Opcode (#N$1B).
  $914F,$01 Repeat count: #N(#PEEK(#PC)).
  $9150,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9151,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9152,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9153 Attribute overlay: repeat colour.
  $9153,$01 Opcode (#N$1B).
  $9154,$01 Repeat count: #N(#PEEK(#PC)).
  $9155,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9156,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9157 Attribute overlay: repeat colour.
  $9157,$01 Opcode (#N$1B).
  $9158,$01 Repeat count: #N(#PEEK(#PC)).
  $9159,$01 Colour: #COLOUR(#PEEK(#PC)).
N $915A Attribute overlay: repeat colour.
  $915A,$01 Opcode (#N$1B).
  $915B,$01 Repeat count: #N(#PEEK(#PC)).
  $915C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $915D Attribute overlay: repeat colour.
  $915D,$01 Opcode (#N$1B).
  $915E,$01 Repeat count: #N(#PEEK(#PC)).
  $915F,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9160,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9161,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9162 Attribute overlay: repeat colour.
  $9162,$01 Opcode (#N$1B).
  $9163,$01 Repeat count: #N(#PEEK(#PC)).
  $9164,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9165,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9166,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9167 Attribute overlay: repeat colour.
  $9167,$01 Opcode (#N$1B).
  $9168,$01 Repeat count: #N(#PEEK(#PC)).
  $9169,$01 Colour: #COLOUR(#PEEK(#PC)).
N $916A Attribute overlay: repeat colour.
  $916A,$01 Opcode (#N$1B).
  $916B,$01 Repeat count: #N(#PEEK(#PC)).
  $916C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $916D Attribute overlay: repeat colour.
  $916D,$01 Opcode (#N$1B).
  $916E,$01 Repeat count: #N(#PEEK(#PC)).
  $916F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9170 Attribute overlay: repeat colour.
  $9170,$01 Opcode (#N$1B).
  $9171,$01 Repeat count: #N(#PEEK(#PC)).
  $9172,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9173 Attribute overlay: repeat colour.
  $9173,$01 Opcode (#N$1B).
  $9174,$01 Repeat count: #N(#PEEK(#PC)).
  $9175,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9176,$01 End of attribute overlay.
  $9177,$01 Terminator.

b $9178 Room #N$09
@ $9178 label=Room09
D $9178 #ROOM$09
N $9178 Command #N$01: Skip tiles.
  $9178,$01 Command (#N$01).
  $9179,$01 Skip count: #N(#PEEK(#PC)).
  $917A,$01 Tile ID: #R$9BC2(#N$0B).
  $917B,$01 Tile ID: #R$9BCA(#N$0C).
  $917C,$01 Tile ID: #R$9BD2(#N$0D).
  $917D,$01 Tile ID: #R$9BB2(#N$09).
  $917E,$01 Tile ID: #R$9BBA(#N$0A).
N $917F Command #N$01: Skip tiles.
  $917F,$01 Command (#N$01).
  $9180,$01 Skip count: #N(#PEEK(#PC)).
  $9181,$01 Tile ID: #R$9C42(#N$1B).
N $9182 Command #N$01: Skip tiles.
  $9182,$01 Command (#N$01).
  $9183,$01 Skip count: #N(#PEEK(#PC)).
  $9184,$01 Tile ID: #R$9BEA(#N$10).
N $9185 Command #N$01: Skip tiles.
  $9185,$01 Command (#N$01).
  $9186,$01 Skip count: #N(#PEEK(#PC)).
  $9187,$01 Tile ID: #R$9BB2(#N$09).
  $9188,$01 Tile ID: #R$9BBA(#N$0A).
  $9189,$01 Tile ID: #R$9BC2(#N$0B).
  $918A,$01 Tile ID: #R$9BCA(#N$0C).
  $918B,$01 Tile ID: #R$9BE2(#N$0F).
N $918C Command #N$01: Skip tiles.
  $918C,$01 Command (#N$01).
  $918D,$01 Skip count: #N(#PEEK(#PC)).
  $918E,$01 Tile ID: #R$9BB2(#N$09).
  $918F,$01 Tile ID: #R$9BC2(#N$0B).
  $9190,$01 Tile ID: #R$9BCA(#N$0C).
  $9191,$01 Tile ID: #R$9BD2(#N$0D).
  $9192,$01 Tile ID: #R$9BB2(#N$09).
  $9193,$01 Tile ID: #R$9BBA(#N$0A).
N $9194 Command #N$01: Skip tiles.
  $9194,$01 Command (#N$01).
  $9195,$01 Skip count: #N(#PEEK(#PC)).
  $9196,$01 Tile ID: #R$9C3A(#N$1A).
N $9197 Command #N$01: Skip tiles.
  $9197,$01 Command (#N$01).
  $9198,$01 Skip count: #N(#PEEK(#PC)).
  $9199,$01 Tile ID: #R$9BF2(#N$11).
N $919A Command #N$01: Skip tiles.
  $919A,$01 Command (#N$01).
  $919B,$01 Skip count: #N(#PEEK(#PC)).
  $919C,$01 Tile ID: #R$9BAA(#N$08).
N $919D Command #N$01: Skip tiles.
  $919D,$01 Command (#N$01).
  $919E,$01 Skip count: #N(#PEEK(#PC)).
  $919F,$01 Tile ID: #R$9BEA(#N$10).
N $91A0 Command #N$01: Skip tiles.
  $91A0,$01 Command (#N$01).
  $91A1,$01 Skip count: #N(#PEEK(#PC)).
  $91A2,$01 Tile ID: #R$9C42(#N$1B).
N $91A3 Command #N$01: Skip tiles.
  $91A3,$01 Command (#N$01).
  $91A4,$01 Skip count: #N(#PEEK(#PC)).
  $91A5,$01 Tile ID: #R$9BDA(#N$0E).
  $91A6,$01 Tile ID: #R$9BE2(#N$0F).
N $91A7 Command #N$01: Skip tiles.
  $91A7,$01 Command (#N$01).
  $91A8,$01 Skip count: #N(#PEEK(#PC)).
  $91A9,$01 Tile ID: #R$9C02(#N$13).
  $91AA,$01 Tile ID: #R$9C02(#N$13).
  $91AB,$01 Tile ID: #R$9C2A(#N$18).
  $91AC,$01 Tile ID: #R$9C22(#N$17).
  $91AD,$01 Tile ID: #R$9BFA(#N$12).
N $91AE Command #N$01: Skip tiles.
  $91AE,$01 Command (#N$01).
  $91AF,$01 Skip count: #N(#PEEK(#PC)).
  $91B0,$01 Tile ID: #R$9C02(#N$13).
  $91B1,$01 Tile ID: #R$9C2A(#N$18).
  $91B2,$01 Tile ID: #R$9C22(#N$17).
  $91B3,$01 Tile ID: #R$9C1A(#N$16).
  $91B4,$01 Tile ID: #R$9C12(#N$15).
N $91B5 Command #N$01: Skip tiles.
  $91B5,$01 Command (#N$01).
  $91B6,$01 Skip count: #N(#PEEK(#PC)).
  $91B7,$01 Tile ID: #R$A28A(#N$E4).
  $91B8,$01 Tile ID: #R$A01A(#N$96).
N $91B9 Command #N$01: Skip tiles.
  $91B9,$01 Command (#N$01).
  $91BA,$01 Skip count: #N(#PEEK(#PC)).
  $91BB,$01 Tile ID: #R$9BEA(#N$10).
N $91BC Command #N$01: Skip tiles.
  $91BC,$01 Command (#N$01).
  $91BD,$01 Skip count: #N(#PEEK(#PC)).
  $91BE,$01 Tile ID: #R$A00A(#N$94).
  $91BF,$01 Tile ID: #R$A00A(#N$94).
  $91C0,$01 Tile ID: #R$A01A(#N$96).
N $91C1 Command #N$01: Skip tiles.
  $91C1,$01 Command (#N$01).
  $91C2,$01 Skip count: #N(#PEEK(#PC)).
  $91C3,$01 Tile ID: #R$9C0A(#N$14).
N $91C4 Command #N$01: Skip tiles.
  $91C4,$01 Command (#N$01).
  $91C5,$01 Skip count: #N(#PEEK(#PC)).
  $91C6,$01 Tile ID: #R$9BF2(#N$11).
N $91C7 Command #N$01: Skip tiles.
  $91C7,$01 Command (#N$01).
  $91C8,$01 Skip count: #N(#PEEK(#PC)).
  $91C9,$01 Tile ID: #R$A00A(#N$94).
  $91CA,$01 Tile ID: #R$A002(#N$93).
  $91CB,$01 Tile ID: #R$A00A(#N$94).
  $91CC,$01 Tile ID: #R$9C2A(#N$18).
  $91CD,$01 Tile ID: #R$9C22(#N$17).
  $91CE,$01 Tile ID: #R$9C1A(#N$16).
  $91CF,$01 Tile ID: #R$9C12(#N$15).
  $91D0,$01 Tile ID: #R$9C02(#N$13).
N $91D1 Command #N$01: Skip tiles.
  $91D1,$01 Command (#N$01).
  $91D2,$01 Skip count: #N(#PEEK(#PC)).
  $91D3,$01 Tile ID: #R$A002(#N$93).
  $91D4,$01 Tile ID: #R$A002(#N$93).
N $91D5 Command #N$01: Skip tiles.
  $91D5,$01 Command (#N$01).
  $91D6,$01 Skip count: #N(#PEEK(#PC)).
  $91D7,$01 Tile ID: #R$A002(#N$93).
  $91D8,$01 Tile ID: #R$A00A(#N$94).
N $91D9 Command #N$01: Skip tiles.
  $91D9,$01 Command (#N$01).
  $91DA,$01 Skip count: #N(#PEEK(#PC)).
  $91DB,$01 Tile ID: #R$A002(#N$93).
  $91DC,$01 Tile ID: #R$A00A(#N$94).
  $91DD,$01 Tile ID: #R$A002(#N$93).
N $91DE Command #N$01: Skip tiles.
  $91DE,$01 Command (#N$01).
  $91DF,$01 Skip count: #N(#PEEK(#PC)).
  $91E0,$01 Tile ID: #R$9CB2(#N$29).
  $91E1,$01 Tile ID: #R$A002(#N$93).
  $91E2,$01 Tile ID: #R$A00A(#N$94).
N $91E3 Command #N$01: Skip tiles.
  $91E3,$01 Command (#N$01).
  $91E4,$01 Skip count: #N(#PEEK(#PC)).
  $91E5,$01 Tile ID: #R$A31A(#N$F6).
  $91E6,$01 Tile ID: #R$A31A(#N$F6).
N $91E7 Command #N$01: Skip tiles.
  $91E7,$01 Command (#N$01).
  $91E8,$01 Skip count: #N(#PEEK(#PC)).
N $91E9 Command #N$02: Draw repeated tile.
  $91E9,$01 Command (#N$02).
  $91EA,$01 Repeat count: #N(#PEEK(#PC)).
  $91EB,$01 Tile ID: #R$A31A(#N$F6).
N $91EC Command #N$01: Skip tiles.
  $91EC,$01 Command (#N$01).
  $91ED,$01 Skip count: #N(#PEEK(#PC)).
N $91EE Command #N$02: Draw repeated tile.
  $91EE,$01 Command (#N$02).
  $91EF,$01 Repeat count: #N(#PEEK(#PC)).
  $91F0,$01 Tile ID: #R$A322(#N$F7).
  $91F1,$01 Tile ID: #R$A0BA(#N$AA).
  $91F2,$01 Tile ID: #R$A002(#N$93).
  $91F3,$01 Tile ID: #R$A002(#N$93).
N $91F4 Command #N$01: Skip tiles.
  $91F4,$01 Command (#N$01).
  $91F5,$01 Skip count: #N(#PEEK(#PC)).
  $91F6,$01 Tile ID: #R$A31A(#N$F6).
  $91F7,$01 Tile ID: #R$A31A(#N$F6).
N $91F8 Command #N$01: Skip tiles.
  $91F8,$01 Command (#N$01).
  $91F9,$01 Skip count: #N(#PEEK(#PC)).
  $91FA,$01 Tile ID: #R$A31A(#N$F6).
N $91FB Command #N$01: Skip tiles.
  $91FB,$01 Command (#N$01).
  $91FC,$01 Skip count: #N(#PEEK(#PC)).
  $91FD,$01 Tile ID: #R$A322(#N$F7).
N $91FE Command #N$01: Skip tiles.
  $91FE,$01 Command (#N$01).
  $91FF,$01 Skip count: #N(#PEEK(#PC)).
N $9200 Command #N$02: Draw repeated tile.
  $9200,$01 Command (#N$02).
  $9201,$01 Repeat count: #N(#PEEK(#PC)).
  $9202,$01 Tile ID: #R$A322(#N$F7).
  $9203,$01 Tile ID: #R$A0BA(#N$AA).
  $9204,$01 Tile ID: #R$A002(#N$93).
  $9205,$01 Tile ID: #R$A00A(#N$94).
N $9206 Command #N$01: Skip tiles.
  $9206,$01 Command (#N$01).
  $9207,$01 Skip count: #N(#PEEK(#PC)).
  $9208,$01 Tile ID: #R$A262(#N$DF).
  $9209,$01 Tile ID: #R$A25A(#N$DE).
N $920A Command #N$01: Skip tiles.
  $920A,$01 Command (#N$01).
  $920B,$01 Skip count: #N(#PEEK(#PC)).
  $920C,$01 Tile ID: #R$A322(#N$F7).
N $920D Command #N$01: Skip tiles.
  $920D,$01 Command (#N$01).
  $920E,$01 Skip count: #N(#PEEK(#PC)).
  $920F,$01 Tile ID: #R$A312(#N$F5).
N $9210 Command #N$01: Skip tiles.
  $9210,$01 Command (#N$01).
  $9211,$01 Skip count: #N(#PEEK(#PC)).
  $9212,$01 Tile ID: #R$A322(#N$F7).
  $9213,$01 Tile ID: #R$A0BA(#N$AA).
  $9214,$01 Tile ID: #R$A002(#N$93).
  $9215,$01 Tile ID: #R$A002(#N$93).
N $9216 Command #N$01: Skip tiles.
  $9216,$01 Command (#N$01).
  $9217,$01 Skip count: #N(#PEEK(#PC)).
  $9218,$01 Tile ID: #R$A02A(#N$98).
  $9219,$01 Tile ID: #R$A26A(#N$E0).
N $921A Command #N$01: Skip tiles.
  $921A,$01 Command (#N$01).
  $921B,$01 Skip count: #N(#PEEK(#PC)).
  $921C,$01 Tile ID: #R$A17A(#N$C2).
  $921D,$01 Tile ID: #R$A18A(#N$C4).
N $921E Command #N$01: Skip tiles.
  $921E,$01 Command (#N$01).
  $921F,$01 Skip count: #N(#PEEK(#PC)).
  $9220,$01 Tile ID: #R$A0BA(#N$AA).
  $9221,$01 Tile ID: #R$A002(#N$93).
  $9222,$01 Tile ID: #R$A00A(#N$94).
N $9223 Command #N$01: Skip tiles.
  $9223,$01 Command (#N$01).
  $9224,$01 Skip count: #N(#PEEK(#PC)).
  $9225,$01 Tile ID: #R$A262(#N$DF).
  $9226,$01 Tile ID: #R$A25A(#N$DE).
N $9227 Command #N$01: Skip tiles.
  $9227,$01 Command (#N$01).
  $9228,$01 Skip count: #N(#PEEK(#PC)).
  $9229,$01 Tile ID: #R$A262(#N$DF).
  $922A,$01 Tile ID: #R$A25A(#N$DE).
N $922B Command #N$01: Skip tiles.
  $922B,$01 Command (#N$01).
  $922C,$01 Skip count: #N(#PEEK(#PC)).
  $922D,$01 Tile ID: #R$A182(#N$C3).
  $922E,$01 Tile ID: #R$A192(#N$C5).
N $922F Command #N$01: Skip tiles.
  $922F,$01 Command (#N$01).
  $9230,$01 Skip count: #N(#PEEK(#PC)).
  $9231,$01 Tile ID: #R$A0D2(#N$AD).
  $9232,$01 Tile ID: #R$A002(#N$93).
  $9233,$01 Tile ID: #R$A002(#N$93).
N $9234 Command #N$01: Skip tiles.
  $9234,$01 Command (#N$01).
  $9235,$01 Skip count: #N(#PEEK(#PC)).
  $9236,$01 Tile ID: #R$A02A(#N$98).
  $9237,$01 Tile ID: #R$A26A(#N$E0).
N $9238 Command #N$01: Skip tiles.
  $9238,$01 Command (#N$01).
  $9239,$01 Skip count: #N(#PEEK(#PC)).
  $923A,$01 Tile ID: #R$A02A(#N$98).
  $923B,$01 Tile ID: #R$A26A(#N$E0).
N $923C Command #N$01: Skip tiles.
  $923C,$01 Command (#N$01).
  $923D,$01 Skip count: #N(#PEEK(#PC)).
  $923E,$01 Tile ID: #R$A02A(#N$98).
  $923F,$01 Tile ID: #R$A25A(#N$DE).
N $9240 Command #N$01: Skip tiles.
  $9240,$01 Command (#N$01).
  $9241,$01 Skip count: #N(#PEEK(#PC)).
  $9242,$01 Tile ID: #R$A00A(#N$94).
  $9243,$01 Tile ID: #R$A002(#N$93).
  $9244,$01 Tile ID: #R$A00A(#N$94).
N $9245 Command #N$01: Skip tiles.
  $9245,$01 Command (#N$01).
  $9246,$01 Skip count: #N(#PEEK(#PC)).
  $9247,$01 Tile ID: #R$A262(#N$DF).
  $9248,$01 Tile ID: #R$A25A(#N$DE).
N $9249 Command #N$01: Skip tiles.
  $9249,$01 Command (#N$01).
  $924A,$01 Skip count: #N(#PEEK(#PC)).
  $924B,$01 Tile ID: #R$A262(#N$DF).
  $924C,$01 Tile ID: #R$A25A(#N$DE).
N $924D Command #N$01: Skip tiles.
  $924D,$01 Command (#N$01).
  $924E,$01 Skip count: #N(#PEEK(#PC)).
  $924F,$01 Tile ID: #R$A02A(#N$98).
  $9250,$01 Tile ID: #R$A25A(#N$DE).
N $9251 Command #N$01: Skip tiles.
  $9251,$01 Command (#N$01).
  $9252,$01 Skip count: #N(#PEEK(#PC)).
  $9253,$01 Tile ID: #R$A14A(#N$BC).
  $9254,$01 Tile ID: #R$A02A(#N$98).
  $9255,$01 Tile ID: #R$A26A(#N$E0).
N $9256 Command #N$01: Skip tiles.
  $9256,$01 Command (#N$01).
  $9257,$01 Skip count: #N(#PEEK(#PC)).
  $9258,$01 Tile ID: #R$A02A(#N$98).
  $9259,$01 Tile ID: #R$A26A(#N$E0).
N $925A Command #N$01: Skip tiles.
  $925A,$01 Command (#N$01).
  $925B,$01 Skip count: #N(#PEEK(#PC)).
  $925C,$01 Tile ID: #R$A02A(#N$98).
  $925D,$01 Tile ID: #R$A25A(#N$DE).
N $925E Command #N$01: Skip tiles.
  $925E,$01 Command (#N$01).
  $925F,$01 Skip count: #N(#PEEK(#PC)).
N $9260 Command #N$02: Draw repeated tile.
  $9260,$01 Command (#N$02).
  $9261,$01 Repeat count: #N(#PEEK(#PC)).
  $9262,$01 Tile ID: #R$A00A(#N$94).
N $9263 Command #N$01: Skip tiles.
  $9263,$01 Command (#N$01).
  $9264,$01 Skip count: #N(#PEEK(#PC)).
  $9265,$01 Tile ID: #R$A00A(#N$94).
N $9266 Command #N$01: Skip tiles.
  $9266,$01 Command (#N$01).
  $9267,$01 Skip count: #N(#PEEK(#PC)).
N $9268 Command #N$02: Draw repeated tile.
  $9268,$01 Command (#N$02).
  $9269,$01 Repeat count: #N(#PEEK(#PC)).
  $926A,$01 Tile ID: #R$9C82(#N$23).
N $926B Command #N$01: Skip tiles.
  $926B,$01 Command (#N$01).
  $926C,$01 Skip count: #N(#PEEK(#PC)).
  $926D,$01 Tile ID: #R$A002(#N$93).
  $926E,$01 Tile ID: #R$A00A(#N$94).
  $926F,$01 Tile ID: #R$A00A(#N$94).
  $9270,$01 Tile ID: #R$A272(#N$E1).
  $9271,$01 Tile ID: #R$A272(#N$E1).
N $9272 Command #N$02: Draw repeated tile.
  $9272,$01 Command (#N$02).
  $9273,$01 Repeat count: #N(#PEEK(#PC)).
  $9274,$01 Tile ID: #R$A00A(#N$94).
  $9275,$01 Tile ID: #R$A272(#N$E1).
  $9276,$01 Tile ID: #R$A272(#N$E1).
N $9277 Command #N$02: Draw repeated tile.
  $9277,$01 Command (#N$02).
  $9278,$01 Repeat count: #N(#PEEK(#PC)).
  $9279,$01 Tile ID: #R$A00A(#N$94).
  $927A,$01 Tile ID: #R$A272(#N$E1).
  $927B,$01 Tile ID: #R$A272(#N$E1).
N $927C Command #N$02: Draw repeated tile.
  $927C,$01 Command (#N$02).
  $927D,$01 Repeat count: #N(#PEEK(#PC)).
  $927E,$01 Tile ID: #R$A00A(#N$94).
  $927F,$01 Tile ID: #R$A272(#N$E1).
  $9280,$01 Tile ID: #R$A272(#N$E1).
N $9281 Command #N$03: Fill attribute buffer.
  $9281,$01 Command (#N$03).
  $9282,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $9283 Attribute overlay: skip.
  $9283,$01 Opcode (#N$12).
  $9284,$01 Skip count: #N(#PEEK(#PC)).
N $9285 Attribute overlay: repeat colour.
  $9285,$01 Opcode (#N$1B).
  $9286,$01 Repeat count: #N(#PEEK(#PC)).
  $9287,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9288 Attribute overlay: skip.
  $9288,$01 Opcode (#N$12).
  $9289,$01 Skip count: #N(#PEEK(#PC)).
N $928A Attribute overlay: repeat colour.
  $928A,$01 Opcode (#N$1B).
  $928B,$01 Repeat count: #N(#PEEK(#PC)).
  $928C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $928D Attribute overlay: skip.
  $928D,$01 Opcode (#N$12).
  $928E,$01 Skip count: #N(#PEEK(#PC)).
N $928F Attribute overlay: repeat colour.
  $928F,$01 Opcode (#N$1B).
  $9290,$01 Repeat count: #N(#PEEK(#PC)).
  $9291,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9292 Attribute overlay: skip.
  $9292,$01 Opcode (#N$12).
  $9293,$01 Skip count: #N(#PEEK(#PC)).
N $9294 Attribute overlay: repeat colour.
  $9294,$01 Opcode (#N$1B).
  $9295,$01 Repeat count: #N(#PEEK(#PC)).
  $9296,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9297 Attribute overlay: skip.
  $9297,$01 Opcode (#N$12).
  $9298,$01 Skip count: #N(#PEEK(#PC)).
  $9299,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $929A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $929B Attribute overlay: repeat colour.
  $929B,$01 Opcode (#N$1B).
  $929C,$01 Repeat count: #N(#PEEK(#PC)).
  $929D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $929E Attribute overlay: skip.
  $929E,$01 Opcode (#N$12).
  $929F,$01 Skip count: #N(#PEEK(#PC)).
  $92A0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92A7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92A8 Attribute overlay: skip.
  $92A8,$01 Opcode (#N$12).
  $92A9,$01 Skip count: #N(#PEEK(#PC)).
  $92AA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92AB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92AC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92AD Attribute overlay: skip.
  $92AD,$01 Opcode (#N$12).
  $92AE,$01 Skip count: #N(#PEEK(#PC)).
  $92AF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92B0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92B1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92B2 Attribute overlay: skip.
  $92B2,$01 Opcode (#N$12).
  $92B3,$01 Skip count: #N(#PEEK(#PC)).
  $92B4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92B5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92B6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92B7 Attribute overlay: skip.
  $92B7,$01 Opcode (#N$12).
  $92B8,$01 Skip count: #N(#PEEK(#PC)).
  $92B9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92BA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92BB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92BC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92BD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92BE Attribute overlay: skip.
  $92BE,$01 Opcode (#N$12).
  $92BF,$01 Skip count: #N(#PEEK(#PC)).
  $92C0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92C9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92CA Attribute overlay: skip.
  $92CA,$01 Opcode (#N$12).
  $92CB,$01 Skip count: #N(#PEEK(#PC)).
  $92CC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92CD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92CE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92CF Attribute overlay: repeat colour.
  $92CF,$01 Opcode (#N$1B).
  $92D0,$01 Repeat count: #N(#PEEK(#PC)).
  $92D1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $92D2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92D9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92DA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92DB Attribute overlay: skip.
  $92DB,$01 Opcode (#N$12).
  $92DC,$01 Skip count: #N(#PEEK(#PC)).
N $92DD Attribute overlay: repeat colour.
  $92DD,$01 Opcode (#N$1B).
  $92DE,$01 Repeat count: #N(#PEEK(#PC)).
  $92DF,$01 Colour: #COLOUR(#PEEK(#PC)).
  $92E0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92E1 Attribute overlay: repeat colour.
  $92E1,$01 Opcode (#N$1B).
  $92E2,$01 Repeat count: #N(#PEEK(#PC)).
  $92E3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $92E4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92E5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92E6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92E7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92E8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92E9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92EA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92EB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92EC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92ED,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $92EE Attribute overlay: repeat colour.
  $92EE,$01 Opcode (#N$1B).
  $92EF,$01 Repeat count: #N(#PEEK(#PC)).
  $92F0,$01 Colour: #COLOUR(#PEEK(#PC)).
N $92F1 Attribute overlay: repeat colour.
  $92F1,$01 Opcode (#N$1B).
  $92F2,$01 Repeat count: #N(#PEEK(#PC)).
  $92F3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $92F4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92F5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92F8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92F9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $92FF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9300,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9301 Attribute overlay: repeat colour.
  $9301,$01 Opcode (#N$1B).
  $9302,$01 Repeat count: #N(#PEEK(#PC)).
  $9303,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9304,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9305,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9306,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9307,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9308,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9309,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $930F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9310,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9311 Attribute overlay: repeat colour.
  $9311,$01 Opcode (#N$1B).
  $9312,$01 Repeat count: #N(#PEEK(#PC)).
  $9313,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9314,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9315,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9316,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9317,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9318,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9319,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $931A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $931B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $931C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $931D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $931E Attribute overlay: repeat colour.
  $931E,$01 Opcode (#N$1B).
  $931F,$01 Repeat count: #N(#PEEK(#PC)).
  $9320,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9321,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9322,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9323,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9324,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9325,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9326,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9327,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9328,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9329,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $932A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $932B Attribute overlay: repeat colour.
  $932B,$01 Opcode (#N$1B).
  $932C,$01 Repeat count: #N(#PEEK(#PC)).
  $932D,$01 Colour: #COLOUR(#PEEK(#PC)).
  $932E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $932F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9330,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9331,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9332,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9333,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9334,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9335,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9336,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9337,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9338 Attribute overlay: repeat colour.
  $9338,$01 Opcode (#N$1B).
  $9339,$01 Repeat count: #N(#PEEK(#PC)).
  $933A,$01 Colour: #COLOUR(#PEEK(#PC)).
N $933B Attribute overlay: repeat colour.
  $933B,$01 Opcode (#N$1B).
  $933C,$01 Repeat count: #N(#PEEK(#PC)).
  $933D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $933E Attribute overlay: repeat colour.
  $933E,$01 Opcode (#N$1B).
  $933F,$01 Repeat count: #N(#PEEK(#PC)).
  $9340,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9341 Attribute overlay: repeat colour.
  $9341,$01 Opcode (#N$1B).
  $9342,$01 Repeat count: #N(#PEEK(#PC)).
  $9343,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9344,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9345,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9346,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9347,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9348,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9349,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $934F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9350 Attribute overlay: repeat colour.
  $9350,$01 Opcode (#N$1B).
  $9351,$01 Repeat count: #N(#PEEK(#PC)).
  $9352,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9353,$01 End of attribute overlay.
  $9354,$01 Terminator.

b $9355 Room #N$0A
@ $9355 label=Room10
D $9355 #ROOM$0A
N $9355 Command #N$01: Skip tiles.
  $9355,$01 Command (#N$01).
  $9356,$01 Skip count: #N(#PEEK(#PC)).
  $9357,$01 Tile ID: #R$9BC2(#N$0B).
  $9358,$01 Tile ID: #R$9BCA(#N$0C).
  $9359,$01 Tile ID: #R$9BD2(#N$0D).
  $935A,$01 Tile ID: #R$9BC2(#N$0B).
  $935B,$01 Tile ID: #R$9BCA(#N$0C).
  $935C,$01 Tile ID: #R$9BD2(#N$0D).
N $935D Command #N$01: Skip tiles.
  $935D,$01 Command (#N$01).
  $935E,$01 Skip count: #N(#PEEK(#PC)).
  $935F,$01 Tile ID: #R$9BAA(#N$08).
N $9360 Command #N$01: Skip tiles.
  $9360,$01 Command (#N$01).
  $9361,$01 Skip count: #N(#PEEK(#PC)).
  $9362,$01 Tile ID: #R$9BDA(#N$0E).
  $9363,$01 Tile ID: #R$9BE2(#N$0F).
N $9364 Command #N$01: Skip tiles.
  $9364,$01 Command (#N$01).
  $9365,$01 Skip count: #N(#PEEK(#PC)).
  $9366,$01 Tile ID: #R$9C2A(#N$18).
  $9367,$01 Tile ID: #R$9C22(#N$17).
  $9368,$01 Tile ID: #R$9C32(#N$19).
N $9369 Command #N$01: Skip tiles.
  $9369,$01 Command (#N$01).
  $936A,$01 Skip count: #N(#PEEK(#PC)).
  $936B,$01 Tile ID: #R$9BEA(#N$10).
N $936C Command #N$01: Skip tiles.
  $936C,$01 Command (#N$01).
  $936D,$01 Skip count: #N(#PEEK(#PC)).
  $936E,$01 Tile ID: #R$9C02(#N$13).
  $936F,$01 Tile ID: #R$9C2A(#N$18).
  $9370,$01 Tile ID: #R$9C22(#N$17).
  $9371,$01 Tile ID: #R$9C1A(#N$16).
  $9372,$01 Tile ID: #R$9C12(#N$15).
N $9373 Command #N$01: Skip tiles.
  $9373,$01 Command (#N$01).
  $9374,$01 Skip count: #N(#PEEK(#PC)).
  $9375,$01 Tile ID: #R$A25A(#N$DE).
N $9376 Command #N$01: Skip tiles.
  $9376,$01 Command (#N$01).
  $9377,$01 Skip count: #N(#PEEK(#PC)).
  $9378,$01 Tile ID: #R$A25A(#N$DE).
N $9379 Command #N$01: Skip tiles.
  $9379,$01 Command (#N$01).
  $937A,$01 Skip count: #N(#PEEK(#PC)).
  $937B,$01 Tile ID: #R$A25A(#N$DE).
N $937C Command #N$01: Skip tiles.
  $937C,$01 Command (#N$01).
  $937D,$01 Skip count: #N(#PEEK(#PC)).
  $937E,$01 Tile ID: #R$A25A(#N$DE).
N $937F Command #N$01: Skip tiles.
  $937F,$01 Command (#N$01).
  $9380,$01 Skip count: #N(#PEEK(#PC)).
  $9381,$01 Tile ID: #R$A25A(#N$DE).
N $9382 Command #N$01: Skip tiles.
  $9382,$01 Command (#N$01).
  $9383,$01 Skip count: #N(#PEEK(#PC)).
  $9384,$01 Tile ID: #R$A31A(#N$F6).
  $9385,$01 Tile ID: #R$A31A(#N$F6).
N $9386 Command #N$01: Skip tiles.
  $9386,$01 Command (#N$01).
  $9387,$01 Skip count: #N(#PEEK(#PC)).
N $9388 Command #N$02: Draw repeated tile.
  $9388,$01 Command (#N$02).
  $9389,$01 Repeat count: #N(#PEEK(#PC)).
  $938A,$01 Tile ID: #R$A322(#N$F7).
N $938B Command #N$01: Skip tiles.
  $938B,$01 Command (#N$01).
  $938C,$01 Skip count: #N(#PEEK(#PC)).
  $938D,$01 Tile ID: #R$A25A(#N$DE).
N $938E Command #N$01: Skip tiles.
  $938E,$01 Command (#N$01).
  $938F,$01 Skip count: #N(#PEEK(#PC)).
  $9390,$01 Tile ID: #R$A02A(#N$98).
N $9391 Command #N$01: Skip tiles.
  $9391,$01 Command (#N$01).
  $9392,$01 Skip count: #N(#PEEK(#PC)).
  $9393,$01 Tile ID: #R$A31A(#N$F6).
N $9394 Command #N$02: Draw repeated tile.
  $9394,$01 Command (#N$02).
  $9395,$01 Repeat count: #N(#PEEK(#PC)).
  $9396,$01 Tile ID: #R$A322(#N$F7).
  $9397,$01 Tile ID: #R$A312(#N$F5).
  $9398,$01 Tile ID: #R$A322(#N$F7).
  $9399,$01 Tile ID: #R$A322(#N$F7).
N $939A Command #N$01: Skip tiles.
  $939A,$01 Command (#N$01).
  $939B,$01 Skip count: #N(#PEEK(#PC)).
  $939C,$01 Tile ID: #R$A312(#N$F5).
N $939D Command #N$01: Skip tiles.
  $939D,$01 Command (#N$01).
  $939E,$01 Skip count: #N(#PEEK(#PC)).
  $939F,$01 Tile ID: #R$A312(#N$F5).
N $93A0 Command #N$01: Skip tiles.
  $93A0,$01 Command (#N$01).
  $93A1,$01 Skip count: #N(#PEEK(#PC)).
  $93A2,$01 Tile ID: #R$A25A(#N$DE).
  $93A3,$01 Tile ID: #R$A0F2(#N$B1).
  $93A4,$01 Tile ID: #R$A0FA(#N$B2).
  $93A5,$01 Tile ID: #R$A02A(#N$98).
N $93A6 Command #N$01: Skip tiles.
  $93A6,$01 Command (#N$01).
  $93A7,$01 Skip count: #N(#PEEK(#PC)).
  $93A8,$01 Tile ID: #R$A312(#N$F5).
N $93A9 Command #N$01: Skip tiles.
  $93A9,$01 Command (#N$01).
  $93AA,$01 Skip count: #N(#PEEK(#PC)).
  $93AB,$01 Tile ID: #R$A312(#N$F5).
N $93AC Command #N$01: Skip tiles.
  $93AC,$01 Command (#N$01).
  $93AD,$01 Skip count: #N(#PEEK(#PC)).
  $93AE,$01 Tile ID: #R$A25A(#N$DE).
N $93AF Command #N$01: Skip tiles.
  $93AF,$01 Command (#N$01).
  $93B0,$01 Skip count: #N(#PEEK(#PC)).
  $93B1,$01 Tile ID: #R$A02A(#N$98).
N $93B2 Command #N$01: Skip tiles.
  $93B2,$01 Command (#N$01).
  $93B3,$01 Skip count: #N(#PEEK(#PC)).
  $93B4,$01 Tile ID: #R$A25A(#N$DE).
N $93B5 Command #N$01: Skip tiles.
  $93B5,$01 Command (#N$01).
  $93B6,$01 Skip count: #N(#PEEK(#PC)).
  $93B7,$01 Tile ID: #R$A02A(#N$98).
N $93B8 Command #N$01: Skip tiles.
  $93B8,$01 Command (#N$01).
  $93B9,$01 Skip count: #N(#PEEK(#PC)).
N $93BA Command #N$02: Draw repeated tile.
  $93BA,$01 Command (#N$02).
  $93BB,$01 Repeat count: #N(#PEEK(#PC)).
  $93BC,$01 Tile ID: #R$A00A(#N$94).
  $93BD,$01 Tile ID: #R$A272(#N$E1).
  $93BE,$01 Tile ID: #R$A272(#N$E1).
N $93BF Command #N$02: Draw repeated tile.
  $93BF,$01 Command (#N$02).
  $93C0,$01 Repeat count: #N(#PEEK(#PC)).
  $93C1,$01 Tile ID: #R$A00A(#N$94).
  $93C2,$01 Tile ID: #R$A272(#N$E1).
  $93C3,$01 Tile ID: #R$A272(#N$E1).
N $93C4 Command #N$02: Draw repeated tile.
  $93C4,$01 Command (#N$02).
  $93C5,$01 Repeat count: #N(#PEEK(#PC)).
  $93C6,$01 Tile ID: #R$A00A(#N$94).
  $93C7,$01 Tile ID: #R$A272(#N$E1).
  $93C8,$01 Tile ID: #R$A272(#N$E1).
N $93C9 Command #N$02: Draw repeated tile.
  $93C9,$01 Command (#N$02).
  $93CA,$01 Repeat count: #N(#PEEK(#PC)).
  $93CB,$01 Tile ID: #R$A00A(#N$94).
  $93CC,$01 Tile ID: #R$A272(#N$E1).
  $93CD,$01 Tile ID: #R$A272(#N$E1).
N $93CE Command #N$02: Draw repeated tile.
  $93CE,$01 Command (#N$02).
  $93CF,$01 Repeat count: #N(#PEEK(#PC)).
  $93D0,$01 Tile ID: #R$A00A(#N$94).
  $93D1,$01 Tile ID: #R$A272(#N$E1).
  $93D2,$01 Tile ID: #R$A272(#N$E1).
N $93D3 Command #N$02: Draw repeated tile.
  $93D3,$01 Command (#N$02).
  $93D4,$01 Repeat count: #N(#PEEK(#PC)).
  $93D5,$01 Tile ID: #R$A00A(#N$94).
  $93D6,$01 Tile ID: #R$A272(#N$E1).
  $93D7,$01 Tile ID: #R$A272(#N$E1).
  $93D8,$01 Tile ID: #R$A00A(#N$94).
  $93D9,$01 Tile ID: #R$A00A(#N$94).
N $93DA Command #N$03: Fill attribute buffer.
  $93DA,$01 Command (#N$03).
  $93DB,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $93DC Attribute overlay: skip.
  $93DC,$01 Opcode (#N$12).
  $93DD,$01 Skip count: #N(#PEEK(#PC)).
N $93DE Attribute overlay: repeat colour.
  $93DE,$01 Opcode (#N$1B).
  $93DF,$01 Repeat count: #N(#PEEK(#PC)).
  $93E0,$01 Colour: #COLOUR(#PEEK(#PC)).
N $93E1 Attribute overlay: skip.
  $93E1,$01 Opcode (#N$12).
  $93E2,$01 Skip count: #N(#PEEK(#PC)).
N $93E3 Attribute overlay: repeat colour.
  $93E3,$01 Opcode (#N$1B).
  $93E4,$01 Repeat count: #N(#PEEK(#PC)).
  $93E5,$01 Colour: #COLOUR(#PEEK(#PC)).
N $93E6 Attribute overlay: skip.
  $93E6,$01 Opcode (#N$12).
  $93E7,$01 Skip count: #N(#PEEK(#PC)).
  $93E8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $93E9 Attribute overlay: skip.
  $93E9,$01 Opcode (#N$12).
  $93EA,$01 Skip count: #N(#PEEK(#PC)).
  $93EB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $93EC Attribute overlay: skip.
  $93EC,$01 Opcode (#N$12).
  $93ED,$01 Skip count: #N(#PEEK(#PC)).
  $93EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93EF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $93F3 Attribute overlay: skip.
  $93F3,$01 Opcode (#N$12).
  $93F4,$01 Skip count: #N(#PEEK(#PC)).
  $93F5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $93F9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $93FA Attribute overlay: skip.
  $93FA,$01 Opcode (#N$12).
  $93FB,$01 Skip count: #N(#PEEK(#PC)).
  $93FC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $93FD Attribute overlay: skip.
  $93FD,$01 Opcode (#N$12).
  $93FE,$01 Skip count: #N(#PEEK(#PC)).
N $93FF Attribute overlay: repeat colour.
  $93FF,$01 Opcode (#N$1B).
  $9400,$01 Repeat count: #N(#PEEK(#PC)).
  $9401,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9402,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9403,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9404,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9405,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9406 Attribute overlay: repeat colour.
  $9406,$01 Opcode (#N$1B).
  $9407,$01 Repeat count: #N(#PEEK(#PC)).
  $9408,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9409 Attribute overlay: skip.
  $9409,$01 Opcode (#N$12).
  $940A,$01 Skip count: #N(#PEEK(#PC)).
  $940B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $940C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $940D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $940E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $940F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9410,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9411 Attribute overlay: skip.
  $9411,$01 Opcode (#N$12).
  $9412,$01 Skip count: #N(#PEEK(#PC)).
N $9413 Attribute overlay: repeat colour.
  $9413,$01 Opcode (#N$1B).
  $9414,$01 Repeat count: #N(#PEEK(#PC)).
  $9415,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9416 Attribute overlay: skip.
  $9416,$01 Opcode (#N$12).
  $9417,$01 Skip count: #N(#PEEK(#PC)).
  $9418,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9419 Attribute overlay: repeat colour.
  $9419,$01 Opcode (#N$1B).
  $941A,$01 Repeat count: #N(#PEEK(#PC)).
  $941B,$01 Colour: #COLOUR(#PEEK(#PC)).
N $941C Attribute overlay: skip.
  $941C,$01 Opcode (#N$12).
  $941D,$01 Skip count: #N(#PEEK(#PC)).
N $941E Attribute overlay: repeat colour.
  $941E,$01 Opcode (#N$1B).
  $941F,$01 Repeat count: #N(#PEEK(#PC)).
  $9420,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9421 Attribute overlay: skip.
  $9421,$01 Opcode (#N$12).
  $9422,$01 Skip count: #N(#PEEK(#PC)).
N $9423 Attribute overlay: repeat colour.
  $9423,$01 Opcode (#N$1B).
  $9424,$01 Repeat count: #N(#PEEK(#PC)).
  $9425,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9426,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9427,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9428,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9429,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $942F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9430,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9431,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9432,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9433,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9434 Attribute overlay: repeat colour.
  $9434,$01 Opcode (#N$1B).
  $9435,$01 Repeat count: #N(#PEEK(#PC)).
  $9436,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9437 Attribute overlay: repeat colour.
  $9437,$01 Opcode (#N$1B).
  $9438,$01 Repeat count: #N(#PEEK(#PC)).
  $9439,$01 Colour: #COLOUR(#PEEK(#PC)).
  $943A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $943B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $943C Attribute overlay: repeat colour.
  $943C,$01 Opcode (#N$1B).
  $943D,$01 Repeat count: #N(#PEEK(#PC)).
  $943E,$01 Colour: #COLOUR(#PEEK(#PC)).
N $943F Attribute overlay: repeat colour.
  $943F,$01 Opcode (#N$1B).
  $9440,$01 Repeat count: #N(#PEEK(#PC)).
  $9441,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9442,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9443,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9444 Attribute overlay: repeat colour.
  $9444,$01 Opcode (#N$1B).
  $9445,$01 Repeat count: #N(#PEEK(#PC)).
  $9446,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9447 Attribute overlay: repeat colour.
  $9447,$01 Opcode (#N$1B).
  $9448,$01 Repeat count: #N(#PEEK(#PC)).
  $9449,$01 Colour: #COLOUR(#PEEK(#PC)).
N $944A Attribute overlay: repeat colour.
  $944A,$01 Opcode (#N$1B).
  $944B,$01 Repeat count: #N(#PEEK(#PC)).
  $944C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $944D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $944E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $944F Attribute overlay: repeat colour.
  $944F,$01 Opcode (#N$1B).
  $9450,$01 Repeat count: #N(#PEEK(#PC)).
  $9451,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9452,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9453,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9454,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9455 Attribute overlay: repeat colour.
  $9455,$01 Opcode (#N$1B).
  $9456,$01 Repeat count: #N(#PEEK(#PC)).
  $9457,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9458,$01 End of attribute overlay.
  $9459,$01 Terminator.

b $945A Room #N$0B
@ $945A label=Room11
D $945A #ROOM$0B
N $945A Command #N$01: Skip tiles.
  $945A,$01 Command (#N$01).
  $945B,$01 Skip count: #N(#PEEK(#PC)).
  $945C,$01 Tile ID: #R$9BB2(#N$09).
  $945D,$01 Tile ID: #R$9BBA(#N$0A).
N $945E Command #N$01: Skip tiles.
  $945E,$01 Command (#N$01).
  $945F,$01 Skip count: #N(#PEEK(#PC)).
  $9460,$01 Tile ID: #R$9BC2(#N$0B).
  $9461,$01 Tile ID: #R$9BCA(#N$0C).
  $9462,$01 Tile ID: #R$9BD2(#N$0D).
  $9463,$01 Tile ID: #R$9BB2(#N$09).
  $9464,$01 Tile ID: #R$9BBA(#N$0A).
N $9465 Command #N$01: Skip tiles.
  $9465,$01 Command (#N$01).
  $9466,$01 Skip count: #N(#PEEK(#PC)).
  $9467,$01 Tile ID: #R$9BAA(#N$08).
N $9468 Command #N$01: Skip tiles.
  $9468,$01 Command (#N$01).
  $9469,$01 Skip count: #N(#PEEK(#PC)).
  $946A,$01 Tile ID: #R$9BDA(#N$0E).
  $946B,$01 Tile ID: #R$9BD2(#N$0D).
  $946C,$01 Tile ID: #R$9BC2(#N$0B).
  $946D,$01 Tile ID: #R$9BCA(#N$0C).
  $946E,$01 Tile ID: #R$9BE2(#N$0F).
  $946F,$01 Tile ID: #R$9C42(#N$1B).
N $9470 Command #N$01: Skip tiles.
  $9470,$01 Command (#N$01).
  $9471,$01 Skip count: #N(#PEEK(#PC)).
  $9472,$01 Tile ID: #R$9BDA(#N$0E).
  $9473,$01 Tile ID: #R$9BE2(#N$0F).
N $9474 Command #N$01: Skip tiles.
  $9474,$01 Command (#N$01).
  $9475,$01 Skip count: #N(#PEEK(#PC)).
  $9476,$01 Tile ID: #R$9C42(#N$1B).
N $9477 Command #N$01: Skip tiles.
  $9477,$01 Command (#N$01).
  $9478,$01 Skip count: #N(#PEEK(#PC)).
  $9479,$01 Tile ID: #R$9BEA(#N$10).
  $947A,$01 Tile ID: #R$9C3A(#N$1A).
N $947B Command #N$01: Skip tiles.
  $947B,$01 Command (#N$01).
  $947C,$01 Skip count: #N(#PEEK(#PC)).
  $947D,$01 Tile ID: #R$9C0A(#N$14).
N $947E Command #N$01: Skip tiles.
  $947E,$01 Command (#N$01).
  $947F,$01 Skip count: #N(#PEEK(#PC)).
  $9480,$01 Tile ID: #R$9BF2(#N$11).
N $9481 Command #N$01: Skip tiles.
  $9481,$01 Command (#N$01).
  $9482,$01 Skip count: #N(#PEEK(#PC)).
  $9483,$01 Tile ID: #R$9C3A(#N$1A).
N $9484 Command #N$01: Skip tiles.
  $9484,$01 Command (#N$01).
  $9485,$01 Skip count: #N(#PEEK(#PC)).
  $9486,$01 Tile ID: #R$9BF2(#N$11).
N $9487 Command #N$01: Skip tiles.
  $9487,$01 Command (#N$01).
  $9488,$01 Skip count: #N(#PEEK(#PC)).
  $9489,$01 Tile ID: #R$9C2A(#N$18).
  $948A,$01 Tile ID: #R$9C22(#N$17).
  $948B,$01 Tile ID: #R$9C1A(#N$16).
  $948C,$01 Tile ID: #R$9C12(#N$15).
  $948D,$01 Tile ID: #R$9C02(#N$13).
  $948E,$01 Tile ID: #R$9C02(#N$13).
N $948F Command #N$01: Skip tiles.
  $948F,$01 Command (#N$01).
  $9490,$01 Skip count: #N(#PEEK(#PC)).
  $9491,$01 Tile ID: #R$9C02(#N$13).
  $9492,$01 Tile ID: #R$9C2A(#N$18).
  $9493,$01 Tile ID: #R$9C22(#N$17).
  $9494,$01 Tile ID: #R$9C32(#N$19).
  $9495,$01 Tile ID: #R$9C32(#N$19).
  $9496,$01 Tile ID: #R$9BFA(#N$12).
N $9497 Command #N$01: Skip tiles.
  $9497,$01 Command (#N$01).
  $9498,$01 Skip count: #N(#PEEK(#PC)).
  $9499,$01 Tile ID: #R$A312(#N$F5).
N $949A Command #N$01: Skip tiles.
  $949A,$01 Command (#N$01).
  $949B,$01 Skip count: #N(#PEEK(#PC)).
N $949C Command #N$02: Draw repeated tile.
  $949C,$01 Command (#N$02).
  $949D,$01 Repeat count: #N(#PEEK(#PC)).
  $949E,$01 Tile ID: #R$A322(#N$F7).
N $949F Command #N$01: Skip tiles.
  $949F,$01 Command (#N$01).
  $94A0,$01 Skip count: #N(#PEEK(#PC)).
  $94A1,$01 Tile ID: #R$A31A(#N$F6).
  $94A2,$01 Tile ID: #R$A31A(#N$F6).
N $94A3 Command #N$01: Skip tiles.
  $94A3,$01 Command (#N$01).
  $94A4,$01 Skip count: #N(#PEEK(#PC)).
  $94A5,$01 Tile ID: #R$A322(#N$F7).
  $94A6,$01 Tile ID: #R$A31A(#N$F6).
  $94A7,$01 Tile ID: #R$A322(#N$F7).
N $94A8 Command #N$01: Skip tiles.
  $94A8,$01 Command (#N$01).
  $94A9,$01 Skip count: #N(#PEEK(#PC)).
  $94AA,$01 Tile ID: #R$9C5A(#N$1E).
  $94AB,$01 Tile ID: #R$9C62(#N$1F).
N $94AC Command #N$01: Skip tiles.
  $94AC,$01 Command (#N$01).
  $94AD,$01 Skip count: #N(#PEEK(#PC)).
N $94AE Command #N$02: Draw repeated tile.
  $94AE,$01 Command (#N$02).
  $94AF,$01 Repeat count: #N(#PEEK(#PC)).
  $94B0,$01 Tile ID: #R$A322(#N$F7).
N $94B1 Command #N$01: Skip tiles.
  $94B1,$01 Command (#N$01).
  $94B2,$01 Skip count: #N(#PEEK(#PC)).
  $94B3,$01 Tile ID: #R$A31A(#N$F6).
N $94B4 Command #N$01: Skip tiles.
  $94B4,$01 Command (#N$01).
  $94B5,$01 Skip count: #N(#PEEK(#PC)).
  $94B6,$01 Tile ID: #R$A312(#N$F5).
N $94B7 Command #N$01: Skip tiles.
  $94B7,$01 Command (#N$01).
  $94B8,$01 Skip count: #N(#PEEK(#PC)).
  $94B9,$01 Tile ID: #R$A31A(#N$F6).
  $94BA,$01 Tile ID: #R$A322(#N$F7).
  $94BB,$01 Tile ID: #R$A31A(#N$F6).
  $94BC,$01 Tile ID: #R$A322(#N$F7).
N $94BD Command #N$01: Skip tiles.
  $94BD,$01 Command (#N$01).
  $94BE,$01 Skip count: #N(#PEEK(#PC)).
  $94BF,$01 Tile ID: #R$A322(#N$F7).
  $94C0,$01 Tile ID: #R$A322(#N$F7).
  $94C1,$01 Tile ID: #R$A2FA(#N$F2).
  $94C2,$01 Tile ID: #R$A302(#N$F3).
  $94C3,$01 Tile ID: #R$A2FA(#N$F2).
  $94C4,$01 Tile ID: #R$A302(#N$F3).
  $94C5,$01 Tile ID: #R$A2FA(#N$F2).
  $94C6,$01 Tile ID: #R$A302(#N$F3).
  $94C7,$01 Tile ID: #R$A2FA(#N$F2).
  $94C8,$01 Tile ID: #R$A302(#N$F3).
  $94C9,$01 Tile ID: #R$A2FA(#N$F2).
  $94CA,$01 Tile ID: #R$A302(#N$F3).
N $94CB Command #N$01: Skip tiles.
  $94CB,$01 Command (#N$01).
  $94CC,$01 Skip count: #N(#PEEK(#PC)).
N $94CD Command #N$02: Draw repeated tile.
  $94CD,$01 Command (#N$02).
  $94CE,$01 Repeat count: #N(#PEEK(#PC)).
  $94CF,$01 Tile ID: #R$A31A(#N$F6).
  $94D0,$01 Tile ID: #R$A312(#N$F5).
N $94D1 Command #N$01: Skip tiles.
  $94D1,$01 Command (#N$01).
  $94D2,$01 Skip count: #N(#PEEK(#PC)).
  $94D3,$01 Tile ID: #R$A322(#N$F7).
  $94D4,$01 Tile ID: #R$A322(#N$F7).
N $94D5 Command #N$01: Skip tiles.
  $94D5,$01 Command (#N$01).
  $94D6,$01 Skip count: #N(#PEEK(#PC)).
  $94D7,$01 Tile ID: #R$A322(#N$F7).
  $94D8,$01 Tile ID: #R$A322(#N$F7).
N $94D9 Command #N$01: Skip tiles.
  $94D9,$01 Command (#N$01).
  $94DA,$01 Skip count: #N(#PEEK(#PC)).
  $94DB,$01 Tile ID: #R$9FBA(#N$8A).
  $94DC,$01 Tile ID: #R$9FDA(#N$8E).
N $94DD Command #N$01: Skip tiles.
  $94DD,$01 Command (#N$01).
  $94DE,$01 Skip count: #N(#PEEK(#PC)).
  $94DF,$01 Tile ID: #R$A0BA(#N$AA).
  $94E0,$01 Tile ID: #R$9FFA(#N$92).
  $94E1,$01 Tile ID: #R$9FFA(#N$92).
  $94E2,$01 Tile ID: #R$A0CA(#N$AC).
  $94E3,$01 Tile ID: #R$9FFA(#N$92).
  $94E4,$01 Tile ID: #R$9FFA(#N$92).
  $94E5,$01 Tile ID: #R$A0CA(#N$AC).
  $94E6,$01 Tile ID: #R$9FFA(#N$92).
  $94E7,$01 Tile ID: #R$9FFA(#N$92).
  $94E8,$01 Tile ID: #R$A0CA(#N$AC).
  $94E9,$01 Tile ID: #R$9FFA(#N$92).
  $94EA,$01 Tile ID: #R$9FFA(#N$92).
  $94EB,$01 Tile ID: #R$A0CA(#N$AC).
  $94EC,$01 Tile ID: #R$9FFA(#N$92).
  $94ED,$01 Tile ID: #R$9FFA(#N$92).
  $94EE,$01 Tile ID: #R$A0CA(#N$AC).
  $94EF,$01 Tile ID: #R$9FFA(#N$92).
  $94F0,$01 Tile ID: #R$9FFA(#N$92).
  $94F1,$01 Tile ID: #R$A0CA(#N$AC).
  $94F2,$01 Tile ID: #R$9FFA(#N$92).
  $94F3,$01 Tile ID: #R$9FFA(#N$92).
  $94F4,$01 Tile ID: #R$A0CA(#N$AC).
  $94F5,$01 Tile ID: #R$9FFA(#N$92).
  $94F6,$01 Tile ID: #R$9FFA(#N$92).
  $94F7,$01 Tile ID: #R$A0CA(#N$AC).
  $94F8,$01 Tile ID: #R$9FFA(#N$92).
  $94F9,$01 Tile ID: #R$9FFA(#N$92).
N $94FA Command #N$01: Skip tiles.
  $94FA,$01 Command (#N$01).
  $94FB,$01 Skip count: #N(#PEEK(#PC)).
  $94FC,$01 Tile ID: #R$A0BA(#N$AA).
  $94FD,$01 Tile ID: #R$9FFA(#N$92).
  $94FE,$01 Tile ID: #R$9FFA(#N$92).
  $94FF,$01 Tile ID: #R$A0CA(#N$AC).
  $9500,$01 Tile ID: #R$9FFA(#N$92).
  $9501,$01 Tile ID: #R$9FFA(#N$92).
  $9502,$01 Tile ID: #R$A0CA(#N$AC).
  $9503,$01 Tile ID: #R$9FFA(#N$92).
  $9504,$01 Tile ID: #R$9FFA(#N$92).
  $9505,$01 Tile ID: #R$A0CA(#N$AC).
  $9506,$01 Tile ID: #R$9FFA(#N$92).
  $9507,$01 Tile ID: #R$9FFA(#N$92).
  $9508,$01 Tile ID: #R$A0CA(#N$AC).
  $9509,$01 Tile ID: #R$9FFA(#N$92).
  $950A,$01 Tile ID: #R$9FFA(#N$92).
  $950B,$01 Tile ID: #R$A0CA(#N$AC).
  $950C,$01 Tile ID: #R$9FFA(#N$92).
  $950D,$01 Tile ID: #R$9FFA(#N$92).
  $950E,$01 Tile ID: #R$A0CA(#N$AC).
  $950F,$01 Tile ID: #R$9FFA(#N$92).
  $9510,$01 Tile ID: #R$9FFA(#N$92).
  $9511,$01 Tile ID: #R$A0CA(#N$AC).
  $9512,$01 Tile ID: #R$9FFA(#N$92).
  $9513,$01 Tile ID: #R$9FFA(#N$92).
  $9514,$01 Tile ID: #R$A0CA(#N$AC).
  $9515,$01 Tile ID: #R$9FFA(#N$92).
  $9516,$01 Tile ID: #R$9FFA(#N$92).
N $9517 Command #N$01: Skip tiles.
  $9517,$01 Command (#N$01).
  $9518,$01 Skip count: #N(#PEEK(#PC)).
  $9519,$01 Tile ID: #R$A00A(#N$94).
  $951A,$01 Tile ID: #R$A272(#N$E1).
  $951B,$01 Tile ID: #R$A272(#N$E1).
N $951C Command #N$02: Draw repeated tile.
  $951C,$01 Command (#N$02).
  $951D,$01 Repeat count: #N(#PEEK(#PC)).
  $951E,$01 Tile ID: #R$A00A(#N$94).
  $951F,$01 Tile ID: #R$A272(#N$E1).
  $9520,$01 Tile ID: #R$A272(#N$E1).
N $9521 Command #N$02: Draw repeated tile.
  $9521,$01 Command (#N$02).
  $9522,$01 Repeat count: #N(#PEEK(#PC)).
  $9523,$01 Tile ID: #R$A00A(#N$94).
  $9524,$01 Tile ID: #R$A272(#N$E1).
  $9525,$01 Tile ID: #R$A272(#N$E1).
N $9526 Command #N$02: Draw repeated tile.
  $9526,$01 Command (#N$02).
  $9527,$01 Repeat count: #N(#PEEK(#PC)).
  $9528,$01 Tile ID: #R$A00A(#N$94).
  $9529,$01 Tile ID: #R$A272(#N$E1).
  $952A,$01 Tile ID: #R$A272(#N$E1).
N $952B Command #N$02: Draw repeated tile.
  $952B,$01 Command (#N$02).
  $952C,$01 Repeat count: #N(#PEEK(#PC)).
  $952D,$01 Tile ID: #R$A00A(#N$94).
  $952E,$01 Tile ID: #R$A272(#N$E1).
  $952F,$01 Tile ID: #R$A272(#N$E1).
N $9530 Command #N$02: Draw repeated tile.
  $9530,$01 Command (#N$02).
  $9531,$01 Repeat count: #N(#PEEK(#PC)).
  $9532,$01 Tile ID: #R$A00A(#N$94).
  $9533,$01 Tile ID: #R$A272(#N$E1).
  $9534,$01 Tile ID: #R$A272(#N$E1).
N $9535 Command #N$02: Draw repeated tile.
  $9535,$01 Command (#N$02).
  $9536,$01 Repeat count: #N(#PEEK(#PC)).
  $9537,$01 Tile ID: #R$A00A(#N$94).
  $9538,$01 Tile ID: #R$A272(#N$E1).
N $9539 Command #N$03: Fill attribute buffer.
  $9539,$01 Command (#N$03).
  $953A,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $953B Attribute overlay: skip.
  $953B,$01 Opcode (#N$12).
  $953C,$01 Skip count: #N(#PEEK(#PC)).
  $953D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $953E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $953F Attribute overlay: skip.
  $953F,$01 Opcode (#N$12).
  $9540,$01 Skip count: #N(#PEEK(#PC)).
N $9541 Attribute overlay: repeat colour.
  $9541,$01 Opcode (#N$1B).
  $9542,$01 Repeat count: #N(#PEEK(#PC)).
  $9543,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9544 Attribute overlay: skip.
  $9544,$01 Opcode (#N$12).
  $9545,$01 Skip count: #N(#PEEK(#PC)).
N $9546 Attribute overlay: repeat colour.
  $9546,$01 Opcode (#N$1B).
  $9547,$01 Repeat count: #N(#PEEK(#PC)).
  $9548,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9549,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $954F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9550,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9551 Attribute overlay: skip.
  $9551,$01 Opcode (#N$12).
  $9552,$01 Skip count: #N(#PEEK(#PC)).
N $9553 Attribute overlay: repeat colour.
  $9553,$01 Opcode (#N$1B).
  $9554,$01 Repeat count: #N(#PEEK(#PC)).
  $9555,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9556 Attribute overlay: skip.
  $9556,$01 Opcode (#N$12).
  $9557,$01 Skip count: #N(#PEEK(#PC)).
  $9558,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9559 Attribute overlay: skip.
  $9559,$01 Opcode (#N$12).
  $955A,$01 Skip count: #N(#PEEK(#PC)).
  $955B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $955C Attribute overlay: skip.
  $955C,$01 Opcode (#N$12).
  $955D,$01 Skip count: #N(#PEEK(#PC)).
  $955E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $955F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9560,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9561,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9562 Attribute overlay: repeat colour.
  $9562,$01 Opcode (#N$1B).
  $9563,$01 Repeat count: #N(#PEEK(#PC)).
  $9564,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9565,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9566,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9567,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9568,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9569 Attribute overlay: skip.
  $9569,$01 Opcode (#N$12).
  $956A,$01 Skip count: #N(#PEEK(#PC)).
  $956B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $956C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $956D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $956E Attribute overlay: repeat colour.
  $956E,$01 Opcode (#N$1B).
  $956F,$01 Repeat count: #N(#PEEK(#PC)).
  $9570,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9571,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9572,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9573,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9574 Attribute overlay: skip.
  $9574,$01 Opcode (#N$12).
  $9575,$01 Skip count: #N(#PEEK(#PC)).
N $9576 Attribute overlay: repeat colour.
  $9576,$01 Opcode (#N$1B).
  $9577,$01 Repeat count: #N(#PEEK(#PC)).
  $9578,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9579,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $957A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $957B Attribute overlay: repeat colour.
  $957B,$01 Opcode (#N$1B).
  $957C,$01 Repeat count: #N(#PEEK(#PC)).
  $957D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $957E Attribute overlay: repeat colour.
  $957E,$01 Opcode (#N$1B).
  $957F,$01 Repeat count: #N(#PEEK(#PC)).
  $9580,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9581,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9582,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9583,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9584 Attribute overlay: repeat colour.
  $9584,$01 Opcode (#N$1B).
  $9585,$01 Repeat count: #N(#PEEK(#PC)).
  $9586,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9587,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9588 Attribute overlay: repeat colour.
  $9588,$01 Opcode (#N$1B).
  $9589,$01 Repeat count: #N(#PEEK(#PC)).
  $958A,$01 Colour: #COLOUR(#PEEK(#PC)).
  $958B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $958C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $958D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $958E Attribute overlay: repeat colour.
  $958E,$01 Opcode (#N$1B).
  $958F,$01 Repeat count: #N(#PEEK(#PC)).
  $9590,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9591 Attribute overlay: repeat colour.
  $9591,$01 Opcode (#N$1B).
  $9592,$01 Repeat count: #N(#PEEK(#PC)).
  $9593,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9594 Attribute overlay: repeat colour.
  $9594,$01 Opcode (#N$1B).
  $9595,$01 Repeat count: #N(#PEEK(#PC)).
  $9596,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9597 Attribute overlay: repeat colour.
  $9597,$01 Opcode (#N$1B).
  $9598,$01 Repeat count: #N(#PEEK(#PC)).
  $9599,$01 Colour: #COLOUR(#PEEK(#PC)).
N $959A Attribute overlay: repeat colour.
  $959A,$01 Opcode (#N$1B).
  $959B,$01 Repeat count: #N(#PEEK(#PC)).
  $959C,$01 Colour: #COLOUR(#PEEK(#PC)).
N $959D Attribute overlay: repeat colour.
  $959D,$01 Opcode (#N$1B).
  $959E,$01 Repeat count: #N(#PEEK(#PC)).
  $959F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $95A0 Attribute overlay: repeat colour.
  $95A0,$01 Opcode (#N$1B).
  $95A1,$01 Repeat count: #N(#PEEK(#PC)).
  $95A2,$01 Colour: #COLOUR(#PEEK(#PC)).
  $95A3,$01 End of attribute overlay.
  $95A4,$01 Terminator.

b $95A5 Room #N$0C: Title Screen
@ $95A5 label=Room12_TitleScreen
D $95A5 #ROOM$0C
N $95A5 Command #N$01: Skip tiles.
  $95A5,$01 Command (#N$01).
  $95A6,$01 Skip count: #N(#PEEK(#PC)).
  $95A7,$01 Tile ID: #R$A212(#N$D5).
N $95A8 Command #N$01: Skip tiles.
  $95A8,$01 Command (#N$01).
  $95A9,$01 Skip count: #N(#PEEK(#PC)).
  $95AA,$01 Tile ID: #R$A21A(#N$D6).
  $95AB,$01 Tile ID: #R$A222(#N$D7).
  $95AC,$01 Tile ID: #R$A22A(#N$D8).
  $95AD,$01 Tile ID: #R$A232(#N$D9).
N $95AE Command #N$01: Skip tiles.
  $95AE,$01 Command (#N$01).
  $95AF,$01 Skip count: #N(#PEEK(#PC)).
  $95B0,$01 Tile ID: #R$A23A(#N$DA).
N $95B1 Command #N$01: Skip tiles.
  $95B1,$01 Command (#N$01).
  $95B2,$01 Skip count: #N(#PEEK(#PC)).
  $95B3,$01 Tile ID: #R$A0F2(#N$B1).
  $95B4,$01 Tile ID: #R$9C82(#N$23).
  $95B5,$01 Tile ID: #R$9C82(#N$23).
  $95B6,$01 Tile ID: #R$A0FA(#N$B2).
N $95B7 Command #N$01: Skip tiles.
  $95B7,$01 Command (#N$01).
  $95B8,$01 Skip count: #N(#PEEK(#PC)).
  $95B9,$01 Tile ID: #R$A242(#N$DB).
  $95BA,$01 Tile ID: #R$A24A(#N$DC).
  $95BB,$01 Tile ID: #R$A252(#N$DD).
N $95BC Command #N$01: Skip tiles.
  $95BC,$01 Command (#N$01).
  $95BD,$01 Skip count: #N(#PEEK(#PC)).
  $95BE,$01 Tile ID: #R$9C82(#N$23).
N $95BF Command #N$01: Skip tiles.
  $95BF,$01 Command (#N$01).
  $95C0,$01 Skip count: #N(#PEEK(#PC)).
  $95C1,$01 Tile ID: #R$9C82(#N$23).
N $95C2 Command #N$01: Skip tiles.
  $95C2,$01 Command (#N$01).
  $95C3,$01 Skip count: #N(#PEEK(#PC)).
  $95C4,$01 Tile ID: #R$9C82(#N$23).
N $95C5 Command #N$01: Skip tiles.
  $95C5,$01 Command (#N$01).
  $95C6,$01 Skip count: #N(#PEEK(#PC)).
  $95C7,$01 Tile ID: #R$9C82(#N$23).
N $95C8 Command #N$01: Skip tiles.
  $95C8,$01 Command (#N$01).
  $95C9,$01 Skip count: #N(#PEEK(#PC)).
N $95CA Command #N$02: Draw repeated tile.
  $95CA,$01 Command (#N$02).
  $95CB,$01 Repeat count: #N(#PEEK(#PC)).
  $95CC,$01 Tile ID: #R$9C82(#N$23).
  $95CD,$01 Tile ID: #R$A20A(#N$D4).
N $95CE Command #N$01: Skip tiles.
  $95CE,$01 Command (#N$01).
  $95CF,$01 Skip count: #N(#PEEK(#PC)).
  $95D0,$01 Tile ID: #R$9C82(#N$23).
N $95D1 Command #N$01: Skip tiles.
  $95D1,$01 Command (#N$01).
  $95D2,$01 Skip count: #N(#PEEK(#PC)).
  $95D3,$01 Tile ID: #R$A0F2(#N$B1).
  $95D4,$01 Tile ID: #R$9C82(#N$23).
  $95D5,$01 Tile ID: #R$A0FA(#N$B2).
N $95D6 Command #N$01: Skip tiles.
  $95D6,$01 Command (#N$01).
  $95D7,$01 Skip count: #N(#PEEK(#PC)).
N $95D8 Command #N$02: Draw repeated tile.
  $95D8,$01 Command (#N$02).
  $95D9,$01 Repeat count: #N(#PEEK(#PC)).
  $95DA,$01 Tile ID: #R$9C82(#N$23).
N $95DB Command #N$01: Skip tiles.
  $95DB,$01 Command (#N$01).
  $95DC,$01 Skip count: #N(#PEEK(#PC)).
N $95DD Command #N$02: Draw repeated tile.
  $95DD,$01 Command (#N$02).
  $95DE,$01 Repeat count: #N(#PEEK(#PC)).
  $95DF,$01 Tile ID: #R$9C82(#N$23).
N $95E0 Command #N$01: Skip tiles.
  $95E0,$01 Command (#N$01).
  $95E1,$01 Skip count: #N(#PEEK(#PC)).
  $95E2,$01 Tile ID: #R$9C82(#N$23).
  $95E3,$01 Tile ID: #R$A1FA(#N$D2).
  $95E4,$01 Tile ID: #R$9C82(#N$23).
N $95E5 Command #N$01: Skip tiles.
  $95E5,$01 Command (#N$01).
  $95E6,$01 Skip count: #N(#PEEK(#PC)).
  $95E7,$01 Tile ID: #R$9C82(#N$23).
N $95E8 Command #N$01: Skip tiles.
  $95E8,$01 Command (#N$01).
  $95E9,$01 Skip count: #N(#PEEK(#PC)).
  $95EA,$01 Tile ID: #R$9C82(#N$23).
N $95EB Command #N$01: Skip tiles.
  $95EB,$01 Command (#N$01).
  $95EC,$01 Skip count: #N(#PEEK(#PC)).
  $95ED,$01 Tile ID: #R$9C82(#N$23).
N $95EE Command #N$01: Skip tiles.
  $95EE,$01 Command (#N$01).
  $95EF,$01 Skip count: #N(#PEEK(#PC)).
  $95F0,$01 Tile ID: #R$9C82(#N$23).
N $95F1 Command #N$01: Skip tiles.
  $95F1,$01 Command (#N$01).
  $95F2,$01 Skip count: #N(#PEEK(#PC)).
  $95F3,$01 Tile ID: #R$9C82(#N$23).
N $95F4 Command #N$01: Skip tiles.
  $95F4,$01 Command (#N$01).
  $95F5,$01 Skip count: #N(#PEEK(#PC)).
  $95F6,$01 Tile ID: #R$A1EA(#N$D0).
  $95F7,$01 Tile ID: #R$9C82(#N$23).
  $95F8,$01 Tile ID: #R$A1F2(#N$D1).
N $95F9 Command #N$01: Skip tiles.
  $95F9,$01 Command (#N$01).
  $95FA,$01 Skip count: #N(#PEEK(#PC)).
  $95FB,$01 Tile ID: #R$9C82(#N$23).
N $95FC Command #N$01: Skip tiles.
  $95FC,$01 Command (#N$01).
  $95FD,$01 Skip count: #N(#PEEK(#PC)).
  $95FE,$01 Tile ID: #R$A202(#N$D3).
  $95FF,$01 Tile ID: #R$9C82(#N$23).
  $9600,$01 Tile ID: #R$A20A(#N$D4).
N $9601 Command #N$01: Skip tiles.
  $9601,$01 Command (#N$01).
  $9602,$01 Skip count: #N(#PEEK(#PC)).
  $9603,$01 Tile ID: #R$9C82(#N$23).
N $9604 Command #N$01: Skip tiles.
  $9604,$01 Command (#N$01).
  $9605,$01 Skip count: #N(#PEEK(#PC)).
  $9606,$01 Tile ID: #R$9C82(#N$23).
N $9607 Command #N$01: Skip tiles.
  $9607,$01 Command (#N$01).
  $9608,$01 Skip count: #N(#PEEK(#PC)).
  $9609,$01 Tile ID: #R$9C82(#N$23).
N $960A Command #N$01: Skip tiles.
  $960A,$01 Command (#N$01).
  $960B,$01 Skip count: #N(#PEEK(#PC)).
  $960C,$01 Tile ID: #R$A0F2(#N$B1).
  $960D,$01 Tile ID: #R$9C82(#N$23).
  $960E,$01 Tile ID: #R$9C82(#N$23).
  $960F,$01 Tile ID: #R$A0FA(#N$B2).
N $9610 Command #N$01: Skip tiles.
  $9610,$01 Command (#N$01).
  $9611,$01 Skip count: #N(#PEEK(#PC)).
  $9612,$01 Tile ID: #R$9C82(#N$23).
N $9613 Command #N$01: Skip tiles.
  $9613,$01 Command (#N$01).
  $9614,$01 Skip count: #N(#PEEK(#PC)).
  $9615,$01 Tile ID: #R$9C82(#N$23).
N $9616 Command #N$01: Skip tiles.
  $9616,$01 Command (#N$01).
  $9617,$01 Skip count: #N(#PEEK(#PC)).
  $9618,$01 Tile ID: #R$9C82(#N$23).
N $9619 Command #N$01: Skip tiles.
  $9619,$01 Command (#N$01).
  $961A,$01 Skip count: #N(#PEEK(#PC)).
  $961B,$01 Tile ID: #R$9C82(#N$23).
N $961C Command #N$01: Skip tiles.
  $961C,$01 Command (#N$01).
  $961D,$01 Skip count: #N(#PEEK(#PC)).
N $961E Command #N$02: Draw repeated tile.
  $961E,$01 Command (#N$02).
  $961F,$01 Repeat count: #N(#PEEK(#PC)).
  $9620,$01 Tile ID: #R$9C82(#N$23).
  $9621,$01 Tile ID: #R$A20A(#N$D4).
N $9622 Command #N$01: Skip tiles.
  $9622,$01 Command (#N$01).
  $9623,$01 Skip count: #N(#PEEK(#PC)).
  $9624,$01 Tile ID: #R$9C82(#N$23).
N $9625 Command #N$01: Skip tiles.
  $9625,$01 Command (#N$01).
  $9626,$01 Skip count: #N(#PEEK(#PC)).
  $9627,$01 Tile ID: #R$9C82(#N$23).
N $9628 Command #N$01: Skip tiles.
  $9628,$01 Command (#N$01).
  $9629,$01 Skip count: #N(#PEEK(#PC)).
  $962A,$01 Tile ID: #R$A0F2(#N$B1).
  $962B,$01 Tile ID: #R$9C82(#N$23).
  $962C,$01 Tile ID: #R$A0FA(#N$B2).
N $962D Command #N$01: Skip tiles.
  $962D,$01 Command (#N$01).
  $962E,$01 Skip count: #N(#PEEK(#PC)).
N $962F Command #N$02: Draw repeated tile.
  $962F,$01 Command (#N$02).
  $9630,$01 Repeat count: #N(#PEEK(#PC)).
  $9631,$01 Tile ID: #R$9C82(#N$23).
N $9632 Command #N$01: Skip tiles.
  $9632,$01 Command (#N$01).
  $9633,$01 Skip count: #N(#PEEK(#PC)).
  $9634,$01 Tile ID: #R$A0F2(#N$B1).
  $9635,$01 Tile ID: #R$9C82(#N$23).
  $9636,$01 Tile ID: #R$A0FA(#N$B2).
N $9637 Command #N$01: Skip tiles.
  $9637,$01 Command (#N$01).
  $9638,$01 Skip count: #N(#PEEK(#PC)).
  $9639,$01 Tile ID: #R$9C82(#N$23).
  $963A,$01 Tile ID: #R$9C82(#N$23).
  $963B,$01 Tile ID: #R$A0FA(#N$B2).
N $963C Command #N$01: Skip tiles.
  $963C,$01 Command (#N$01).
  $963D,$01 Skip count: #N(#PEEK(#PC)).
  $963E,$01 Tile ID: #R$9C82(#N$23).
N $963F Command #N$01: Skip tiles.
  $963F,$01 Command (#N$01).
  $9640,$01 Skip count: #N(#PEEK(#PC)).
  $9641,$01 Tile ID: #R$9C82(#N$23).
N $9642 Command #N$01: Skip tiles.
  $9642,$01 Command (#N$01).
  $9643,$01 Skip count: #N(#PEEK(#PC)).
  $9644,$01 Tile ID: #R$9C82(#N$23).
N $9645 Command #N$01: Skip tiles.
  $9645,$01 Command (#N$01).
  $9646,$01 Skip count: #N(#PEEK(#PC)).
  $9647,$01 Tile ID: #R$A1DA(#N$CE).
N $9648 Command #N$01: Skip tiles.
  $9648,$01 Command (#N$01).
  $9649,$01 Skip count: #N(#PEEK(#PC)).
  $964A,$01 Tile ID: #R$9C82(#N$23).
  $964B,$01 Tile ID: #R$A1E2(#N$CF).
N $964C Command #N$01: Skip tiles.
  $964C,$01 Command (#N$01).
  $964D,$01 Skip count: #N(#PEEK(#PC)).
  $964E,$01 Tile ID: #R$9C82(#N$23).
N $964F Command #N$01: Skip tiles.
  $964F,$01 Command (#N$01).
  $9650,$01 Skip count: #N(#PEEK(#PC)).
  $9651,$01 Tile ID: #R$9C82(#N$23).
N $9652 Command #N$01: Skip tiles.
  $9652,$01 Command (#N$01).
  $9653,$01 Skip count: #N(#PEEK(#PC)).
  $9654,$01 Tile ID: #R$9C82(#N$23).
N $9655 Command #N$01: Skip tiles.
  $9655,$01 Command (#N$01).
  $9656,$01 Skip count: #N(#PEEK(#PC)).
  $9657,$01 Tile ID: #R$9C82(#N$23).
N $9658 Command #N$01: Skip tiles.
  $9658,$01 Command (#N$01).
  $9659,$01 Skip count: #N(#PEEK(#PC)).
  $965A,$01 Tile ID: #R$9C82(#N$23).
N $965B Command #N$01: Skip tiles.
  $965B,$01 Command (#N$01).
  $965C,$01 Skip count: #N(#PEEK(#PC)).
  $965D,$01 Tile ID: #R$9C82(#N$23).
N $965E Command #N$01: Skip tiles.
  $965E,$01 Command (#N$01).
  $965F,$01 Skip count: #N(#PEEK(#PC)).
  $9660,$01 Tile ID: #R$A202(#N$D3).
  $9661,$01 Tile ID: #R$9C82(#N$23).
  $9662,$01 Tile ID: #R$9C82(#N$23).
N $9663 Command #N$01: Skip tiles.
  $9663,$01 Command (#N$01).
  $9664,$01 Skip count: #N(#PEEK(#PC)).
N $9665 Command #N$02: Draw repeated tile.
  $9665,$01 Command (#N$02).
  $9666,$01 Repeat count: #N(#PEEK(#PC)).
  $9667,$01 Tile ID: #R$9C82(#N$23).
N $9668 Command #N$01: Skip tiles.
  $9668,$01 Command (#N$01).
  $9669,$01 Skip count: #N(#PEEK(#PC)).
  $966A,$01 Tile ID: #R$A202(#N$D3).
  $966B,$01 Tile ID: #R$9C82(#N$23).
  $966C,$01 Tile ID: #R$A20A(#N$D4).
N $966D Command #N$01: Skip tiles.
  $966D,$01 Command (#N$01).
  $966E,$01 Skip count: #N(#PEEK(#PC)).
  $966F,$01 Tile ID: #R$9C82(#N$23).
N $9670 Command #N$01: Skip tiles.
  $9670,$01 Command (#N$01).
  $9671,$01 Skip count: #N(#PEEK(#PC)).
  $9672,$01 Tile ID: #R$9C82(#N$23).
N $9673 Command #N$01: Skip tiles.
  $9673,$01 Command (#N$01).
  $9674,$01 Skip count: #N(#PEEK(#PC)).
N $9675 Command #N$03: Fill attribute buffer.
  $9675,$01 Command (#N$03).
  $9676,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $9677 Attribute overlay: repeat colour.
  $9677,$01 Opcode (#N$1B).
  $9678,$01 Repeat count: #N(#PEEK(#PC)).
  $9679,$01 Colour: #COLOUR(#PEEK(#PC)).
  $967A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $967B Attribute overlay: repeat colour.
  $967B,$01 Opcode (#N$1B).
  $967C,$01 Repeat count: #N(#PEEK(#PC)).
  $967D,$01 Colour: #COLOUR(#PEEK(#PC)).
N $967E Attribute overlay: repeat colour.
  $967E,$01 Opcode (#N$1B).
  $967F,$01 Repeat count: #N(#PEEK(#PC)).
  $9680,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9681 Attribute overlay: repeat colour.
  $9681,$01 Opcode (#N$1B).
  $9682,$01 Repeat count: #N(#PEEK(#PC)).
  $9683,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9684,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9685,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9686,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9687 Attribute overlay: repeat colour.
  $9687,$01 Opcode (#N$1B).
  $9688,$01 Repeat count: #N(#PEEK(#PC)).
  $9689,$01 Colour: #COLOUR(#PEEK(#PC)).
N $968A Attribute overlay: repeat colour.
  $968A,$01 Opcode (#N$1B).
  $968B,$01 Repeat count: #N(#PEEK(#PC)).
  $968C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $968D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $968E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $968F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9690,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9691,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9692,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9693,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9694,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9695,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9696 Attribute overlay: repeat colour.
  $9696,$01 Opcode (#N$1B).
  $9697,$01 Repeat count: #N(#PEEK(#PC)).
  $9698,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9699,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $969A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $969B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $969C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $969D Attribute overlay: repeat colour.
  $969D,$01 Opcode (#N$1B).
  $969E,$01 Repeat count: #N(#PEEK(#PC)).
  $969F,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96A0 Attribute overlay: repeat colour.
  $96A0,$01 Opcode (#N$1B).
  $96A1,$01 Repeat count: #N(#PEEK(#PC)).
  $96A2,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96A3 Attribute overlay: repeat colour.
  $96A3,$01 Opcode (#N$1B).
  $96A4,$01 Repeat count: #N(#PEEK(#PC)).
  $96A5,$01 Colour: #COLOUR(#PEEK(#PC)).
  $96A6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96A7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96A8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96A9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96AF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96B8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $96B9 Attribute overlay: repeat colour.
  $96B9,$01 Opcode (#N$1B).
  $96BA,$01 Repeat count: #N(#PEEK(#PC)).
  $96BB,$01 Colour: #COLOUR(#PEEK(#PC)).
  $96BC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96BD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96BE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96BF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96C9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96CA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96CB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96CC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96CD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96CE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $96CF Attribute overlay: repeat colour.
  $96CF,$01 Opcode (#N$1B).
  $96D0,$01 Repeat count: #N(#PEEK(#PC)).
  $96D1,$01 Colour: #COLOUR(#PEEK(#PC)).
  $96D2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96D9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96DF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96E0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96E1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96E2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96E3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $96E4 Attribute overlay: repeat colour.
  $96E4,$01 Opcode (#N$1B).
  $96E5,$01 Repeat count: #N(#PEEK(#PC)).
  $96E6,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96E7 Attribute overlay: repeat colour.
  $96E7,$01 Opcode (#N$1B).
  $96E8,$01 Repeat count: #N(#PEEK(#PC)).
  $96E9,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96EA Attribute overlay: repeat colour.
  $96EA,$01 Opcode (#N$1B).
  $96EB,$01 Repeat count: #N(#PEEK(#PC)).
  $96EC,$01 Colour: #COLOUR(#PEEK(#PC)).
  $96ED,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96EF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96F0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $96F1 Attribute overlay: repeat colour.
  $96F1,$01 Opcode (#N$1B).
  $96F2,$01 Repeat count: #N(#PEEK(#PC)).
  $96F3,$01 Colour: #COLOUR(#PEEK(#PC)).
  $96F4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96F5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $96F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $96F8 Attribute overlay: repeat colour.
  $96F8,$01 Opcode (#N$1B).
  $96F9,$01 Repeat count: #N(#PEEK(#PC)).
  $96FA,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96FB Attribute overlay: repeat colour.
  $96FB,$01 Opcode (#N$1B).
  $96FC,$01 Repeat count: #N(#PEEK(#PC)).
  $96FD,$01 Colour: #COLOUR(#PEEK(#PC)).
N $96FE Attribute overlay: repeat colour.
  $96FE,$01 Opcode (#N$1B).
  $96FF,$01 Repeat count: #N(#PEEK(#PC)).
  $9700,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9701,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9702,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9703,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9704,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9705,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9706,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9707,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9708,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9709,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $970F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9710,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9711,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9712,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9713,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9714,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9715,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9716 Attribute overlay: repeat colour.
  $9716,$01 Opcode (#N$1B).
  $9717,$01 Repeat count: #N(#PEEK(#PC)).
  $9718,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9719,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $971F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9720,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9721,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9722,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9723 Attribute overlay: repeat colour.
  $9723,$01 Opcode (#N$1B).
  $9724,$01 Repeat count: #N(#PEEK(#PC)).
  $9725,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9726,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9727,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9728,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9729,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $972A Attribute overlay: repeat colour.
  $972A,$01 Opcode (#N$1B).
  $972B,$01 Repeat count: #N(#PEEK(#PC)).
  $972C,$01 Colour: #COLOUR(#PEEK(#PC)).
  $972D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $972E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $972F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9730,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9731,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9732,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9733,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9734,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9735,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9736,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9737,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9738,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9739,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $973F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9740,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9741,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9742 Attribute overlay: repeat colour.
  $9742,$01 Opcode (#N$1B).
  $9743,$01 Repeat count: #N(#PEEK(#PC)).
  $9744,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9745,$01 End of attribute overlay.
  $9746,$01 Terminator.

b $9747 Room #N$0D: Level 2
@ $9747 label=Room13_Level2
D $9747 #ROOM$0D
N $9747 Command #N$01: Skip tiles.
  $9747,$01 Command (#N$01).
  $9748,$01 Skip count: #N(#PEEK(#PC)).
N $9749 Command #N$01: Skip tiles.
  $9749,$01 Command (#N$01).
  $974A,$01 Skip count: #N(#PEEK(#PC)).
N $974B Command #N$01: Skip tiles.
  $974B,$01 Command (#N$01).
  $974C,$01 Skip count: #N(#PEEK(#PC)).
N $974D Command #N$03: Fill attribute buffer.
  $974D,$01 Command (#N$03).
  $974E,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $974F Attribute overlay: skip.
  $974F,$01 Opcode (#N$12).
  $9750,$01 Skip count: #N(#PEEK(#PC)).
  $9751,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9752 Attribute overlay: skip.
  $9752,$01 Opcode (#N$12).
  $9753,$01 Skip count: #N(#PEEK(#PC)).
  $9754,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9755 Attribute overlay: skip.
  $9755,$01 Opcode (#N$12).
  $9756,$01 Skip count: #N(#PEEK(#PC)).
  $9757,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9758,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9759 Attribute overlay: skip.
  $9759,$01 Opcode (#N$12).
  $975A,$01 Skip count: #N(#PEEK(#PC)).
  $975B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $975C Attribute overlay: skip.
  $975C,$01 Opcode (#N$12).
  $975D,$01 Skip count: #N(#PEEK(#PC)).
  $975E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $975F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9760,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9761,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9762 Attribute overlay: skip.
  $9762,$01 Opcode (#N$12).
  $9763,$01 Skip count: #N(#PEEK(#PC)).
  $9764,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9765 Attribute overlay: skip.
  $9765,$01 Opcode (#N$12).
  $9766,$01 Skip count: #N(#PEEK(#PC)).
  $9767,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9768 Attribute overlay: skip.
  $9768,$01 Opcode (#N$12).
  $9769,$01 Skip count: #N(#PEEK(#PC)).
  $976A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $976B Attribute overlay: skip.
  $976B,$01 Opcode (#N$12).
  $976C,$01 Skip count: #N(#PEEK(#PC)).
  $976D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $976E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $976F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9770,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9771,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9772 Attribute overlay: skip.
  $9772,$01 Opcode (#N$12).
  $9773,$01 Skip count: #N(#PEEK(#PC)).
  $9774,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9775,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9776,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9777,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9778,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9779,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $977A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $977B Attribute overlay: skip.
  $977B,$01 Opcode (#N$12).
  $977C,$01 Skip count: #N(#PEEK(#PC)).
  $977D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $977E Attribute overlay: skip.
  $977E,$01 Opcode (#N$12).
  $977F,$01 Skip count: #N(#PEEK(#PC)).
  $9780,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9781 Attribute overlay: skip.
  $9781,$01 Opcode (#N$12).
  $9782,$01 Skip count: #N(#PEEK(#PC)).
  $9783,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9784 Attribute overlay: skip.
  $9784,$01 Opcode (#N$12).
  $9785,$01 Skip count: #N(#PEEK(#PC)).
  $9786,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9787 Attribute overlay: skip.
  $9787,$01 Opcode (#N$12).
  $9788,$01 Skip count: #N(#PEEK(#PC)).
  $9789,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $978A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $978B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $978C Attribute overlay: skip.
  $978C,$01 Opcode (#N$12).
  $978D,$01 Skip count: #N(#PEEK(#PC)).
  $978E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $978F Attribute overlay: skip.
  $978F,$01 Opcode (#N$12).
  $9790,$01 Skip count: #N(#PEEK(#PC)).
  $9791,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9792 Attribute overlay: skip.
  $9792,$01 Opcode (#N$12).
  $9793,$01 Skip count: #N(#PEEK(#PC)).
  $9794,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9795 Attribute overlay: skip.
  $9795,$01 Opcode (#N$12).
  $9796,$01 Skip count: #N(#PEEK(#PC)).
  $9797,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9798,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9799 Attribute overlay: skip.
  $9799,$01 Opcode (#N$12).
  $979A,$01 Skip count: #N(#PEEK(#PC)).
  $979B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $979C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $979D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $979E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $979F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97A0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97A1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97A2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97A3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97A4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97A5 Attribute overlay: skip.
  $97A5,$01 Opcode (#N$12).
  $97A6,$01 Skip count: #N(#PEEK(#PC)).
  $97A7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97A8 Attribute overlay: skip.
  $97A8,$01 Opcode (#N$12).
  $97A9,$01 Skip count: #N(#PEEK(#PC)).
  $97AA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97AB Attribute overlay: skip.
  $97AB,$01 Opcode (#N$12).
  $97AC,$01 Skip count: #N(#PEEK(#PC)).
  $97AD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97AE Attribute overlay: skip.
  $97AE,$01 Opcode (#N$12).
  $97AF,$01 Skip count: #N(#PEEK(#PC)).
  $97B0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97B1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97B2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97B3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97B4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97B5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97B6 Attribute overlay: skip.
  $97B6,$01 Opcode (#N$12).
  $97B7,$01 Skip count: #N(#PEEK(#PC)).
  $97B8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97B9 Attribute overlay: skip.
  $97B9,$01 Opcode (#N$12).
  $97BA,$01 Skip count: #N(#PEEK(#PC)).
  $97BB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97BC Attribute overlay: skip.
  $97BC,$01 Opcode (#N$12).
  $97BD,$01 Skip count: #N(#PEEK(#PC)).
N $97BE Attribute overlay: repeat colour.
  $97BE,$01 Opcode (#N$1B).
  $97BF,$01 Repeat count: #N(#PEEK(#PC)).
  $97C0,$01 Colour: #COLOUR(#PEEK(#PC)).
  $97C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97C2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97C3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97C4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97C5 Attribute overlay: skip.
  $97C5,$01 Opcode (#N$12).
  $97C6,$01 Skip count: #N(#PEEK(#PC)).
  $97C7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97C8 Attribute overlay: skip.
  $97C8,$01 Opcode (#N$12).
  $97C9,$01 Skip count: #N(#PEEK(#PC)).
  $97CA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97CB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97CC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97CD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97CE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97CF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97D0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97D1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97D2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97D3 Attribute overlay: repeat colour.
  $97D3,$01 Opcode (#N$1B).
  $97D4,$01 Repeat count: #N(#PEEK(#PC)).
  $97D5,$01 Colour: #COLOUR(#PEEK(#PC)).
N $97D6 Attribute overlay: skip.
  $97D6,$01 Opcode (#N$12).
  $97D7,$01 Skip count: #N(#PEEK(#PC)).
  $97D8,$01 End of attribute overlay.
  $97D9,$01 Terminator.

b $97DA Room #N$0E: Level 3
@ $97DA label=Room14_Level3
D $97DA #ROOM$0E
N $97DA Command #N$01: Skip tiles.
  $97DA,$01 Command (#N$01).
  $97DB,$01 Skip count: #N(#PEEK(#PC)).
N $97DC Command #N$01: Skip tiles.
  $97DC,$01 Command (#N$01).
  $97DD,$01 Skip count: #N(#PEEK(#PC)).
N $97DE Command #N$01: Skip tiles.
  $97DE,$01 Command (#N$01).
  $97DF,$01 Skip count: #N(#PEEK(#PC)).
N $97E0 Command #N$03: Fill attribute buffer.
  $97E0,$01 Command (#N$03).
  $97E1,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $97E2 Attribute overlay: skip.
  $97E2,$01 Opcode (#N$12).
  $97E3,$01 Skip count: #N(#PEEK(#PC)).
  $97E4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97E5 Attribute overlay: skip.
  $97E5,$01 Opcode (#N$12).
  $97E6,$01 Skip count: #N(#PEEK(#PC)).
  $97E7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97E8 Attribute overlay: skip.
  $97E8,$01 Opcode (#N$12).
  $97E9,$01 Skip count: #N(#PEEK(#PC)).
  $97EA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97EB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97EC Attribute overlay: skip.
  $97EC,$01 Opcode (#N$12).
  $97ED,$01 Skip count: #N(#PEEK(#PC)).
  $97EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97EF Attribute overlay: skip.
  $97EF,$01 Opcode (#N$12).
  $97F0,$01 Skip count: #N(#PEEK(#PC)).
  $97F1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97F2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97F3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $97F4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97F5 Attribute overlay: skip.
  $97F5,$01 Opcode (#N$12).
  $97F6,$01 Skip count: #N(#PEEK(#PC)).
  $97F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97F8 Attribute overlay: skip.
  $97F8,$01 Opcode (#N$12).
  $97F9,$01 Skip count: #N(#PEEK(#PC)).
  $97FA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97FB Attribute overlay: skip.
  $97FB,$01 Opcode (#N$12).
  $97FC,$01 Skip count: #N(#PEEK(#PC)).
  $97FD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $97FE Attribute overlay: skip.
  $97FE,$01 Opcode (#N$12).
  $97FF,$01 Skip count: #N(#PEEK(#PC)).
  $9800,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9801,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9802,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9803,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9804,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9805 Attribute overlay: skip.
  $9805,$01 Opcode (#N$12).
  $9806,$01 Skip count: #N(#PEEK(#PC)).
  $9807,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9808,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9809,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $980A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $980B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $980C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $980D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $980E Attribute overlay: skip.
  $980E,$01 Opcode (#N$12).
  $980F,$01 Skip count: #N(#PEEK(#PC)).
  $9810,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9811 Attribute overlay: skip.
  $9811,$01 Opcode (#N$12).
  $9812,$01 Skip count: #N(#PEEK(#PC)).
  $9813,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9814 Attribute overlay: skip.
  $9814,$01 Opcode (#N$12).
  $9815,$01 Skip count: #N(#PEEK(#PC)).
  $9816,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9817 Attribute overlay: skip.
  $9817,$01 Opcode (#N$12).
  $9818,$01 Skip count: #N(#PEEK(#PC)).
  $9819,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $981A Attribute overlay: skip.
  $981A,$01 Opcode (#N$12).
  $981B,$01 Skip count: #N(#PEEK(#PC)).
  $981C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $981D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $981E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $981F Attribute overlay: skip.
  $981F,$01 Opcode (#N$12).
  $9820,$01 Skip count: #N(#PEEK(#PC)).
  $9821,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9822 Attribute overlay: skip.
  $9822,$01 Opcode (#N$12).
  $9823,$01 Skip count: #N(#PEEK(#PC)).
  $9824,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9825 Attribute overlay: skip.
  $9825,$01 Opcode (#N$12).
  $9826,$01 Skip count: #N(#PEEK(#PC)).
  $9827,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9828 Attribute overlay: skip.
  $9828,$01 Opcode (#N$12).
  $9829,$01 Skip count: #N(#PEEK(#PC)).
  $982A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $982B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $982C Attribute overlay: skip.
  $982C,$01 Opcode (#N$12).
  $982D,$01 Skip count: #N(#PEEK(#PC)).
  $982E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $982F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9830,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9831,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9832,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9833,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9834,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9835,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9836,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9837,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9838 Attribute overlay: skip.
  $9838,$01 Opcode (#N$12).
  $9839,$01 Skip count: #N(#PEEK(#PC)).
  $983A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $983B Attribute overlay: skip.
  $983B,$01 Opcode (#N$12).
  $983C,$01 Skip count: #N(#PEEK(#PC)).
  $983D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $983E Attribute overlay: skip.
  $983E,$01 Opcode (#N$12).
  $983F,$01 Skip count: #N(#PEEK(#PC)).
  $9840,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9841 Attribute overlay: skip.
  $9841,$01 Opcode (#N$12).
  $9842,$01 Skip count: #N(#PEEK(#PC)).
  $9843,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9844,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9845,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9846,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9847,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9848,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9849 Attribute overlay: skip.
  $9849,$01 Opcode (#N$12).
  $984A,$01 Skip count: #N(#PEEK(#PC)).
  $984B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $984C Attribute overlay: skip.
  $984C,$01 Opcode (#N$12).
  $984D,$01 Skip count: #N(#PEEK(#PC)).
  $984E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $984F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9850,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9851,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9852 Attribute overlay: skip.
  $9852,$01 Opcode (#N$12).
  $9853,$01 Skip count: #N(#PEEK(#PC)).
N $9854 Attribute overlay: repeat colour.
  $9854,$01 Opcode (#N$1B).
  $9855,$01 Repeat count: #N(#PEEK(#PC)).
  $9856,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9857,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9858,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9859,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $985A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $985B Attribute overlay: skip.
  $985B,$01 Opcode (#N$12).
  $985C,$01 Skip count: #N(#PEEK(#PC)).
  $985D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $985E Attribute overlay: skip.
  $985E,$01 Opcode (#N$12).
  $985F,$01 Skip count: #N(#PEEK(#PC)).
  $9860,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9861,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9862,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9863,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9864,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9865,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9866,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9867 Attribute overlay: skip.
  $9867,$01 Opcode (#N$12).
  $9868,$01 Skip count: #N(#PEEK(#PC)).
  $9869,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $986A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $986B Attribute overlay: skip.
  $986B,$01 Opcode (#N$12).
  $986C,$01 Skip count: #N(#PEEK(#PC)).
  $986D,$01 End of attribute overlay.
  $986E,$01 Terminator.

b $986F Room #N$0F: Level 4
@ $986F label=Room15_Level4
D $986F #ROOM$0F
N $986F Command #N$01: Skip tiles.
  $986F,$01 Command (#N$01).
  $9870,$01 Skip count: #N(#PEEK(#PC)).
N $9871 Command #N$01: Skip tiles.
  $9871,$01 Command (#N$01).
  $9872,$01 Skip count: #N(#PEEK(#PC)).
N $9873 Command #N$01: Skip tiles.
  $9873,$01 Command (#N$01).
  $9874,$01 Skip count: #N(#PEEK(#PC)).
N $9875 Command #N$03: Fill attribute buffer.
  $9875,$01 Command (#N$03).
  $9876,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $9877 Attribute overlay: skip.
  $9877,$01 Opcode (#N$12).
  $9878,$01 Skip count: #N(#PEEK(#PC)).
  $9879,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $987A Attribute overlay: skip.
  $987A,$01 Opcode (#N$12).
  $987B,$01 Skip count: #N(#PEEK(#PC)).
  $987C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $987D Attribute overlay: skip.
  $987D,$01 Opcode (#N$12).
  $987E,$01 Skip count: #N(#PEEK(#PC)).
  $987F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9880 Attribute overlay: skip.
  $9880,$01 Opcode (#N$12).
  $9881,$01 Skip count: #N(#PEEK(#PC)).
  $9882,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9883 Attribute overlay: skip.
  $9883,$01 Opcode (#N$12).
  $9884,$01 Skip count: #N(#PEEK(#PC)).
  $9885,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9886 Attribute overlay: skip.
  $9886,$01 Opcode (#N$12).
  $9887,$01 Skip count: #N(#PEEK(#PC)).
  $9888,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9889 Attribute overlay: skip.
  $9889,$01 Opcode (#N$12).
  $988A,$01 Skip count: #N(#PEEK(#PC)).
  $988B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $988C Attribute overlay: skip.
  $988C,$01 Opcode (#N$12).
  $988D,$01 Skip count: #N(#PEEK(#PC)).
  $988E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $988F Attribute overlay: skip.
  $988F,$01 Opcode (#N$12).
  $9890,$01 Skip count: #N(#PEEK(#PC)).
  $9891,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9892,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9893,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9894,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9895,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9896 Attribute overlay: skip.
  $9896,$01 Opcode (#N$12).
  $9897,$01 Skip count: #N(#PEEK(#PC)).
  $9898,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9899,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $989A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $989B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $989C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $989D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $989E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $989F Attribute overlay: skip.
  $989F,$01 Opcode (#N$12).
  $98A0,$01 Skip count: #N(#PEEK(#PC)).
  $98A1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98A2 Attribute overlay: skip.
  $98A2,$01 Opcode (#N$12).
  $98A3,$01 Skip count: #N(#PEEK(#PC)).
  $98A4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98A5 Attribute overlay: skip.
  $98A5,$01 Opcode (#N$12).
  $98A6,$01 Skip count: #N(#PEEK(#PC)).
  $98A7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98A8 Attribute overlay: skip.
  $98A8,$01 Opcode (#N$12).
  $98A9,$01 Skip count: #N(#PEEK(#PC)).
  $98AA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98AB Attribute overlay: skip.
  $98AB,$01 Opcode (#N$12).
  $98AC,$01 Skip count: #N(#PEEK(#PC)).
  $98AD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98AE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98AF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98B0 Attribute overlay: skip.
  $98B0,$01 Opcode (#N$12).
  $98B1,$01 Skip count: #N(#PEEK(#PC)).
  $98B2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98B3 Attribute overlay: skip.
  $98B3,$01 Opcode (#N$12).
  $98B4,$01 Skip count: #N(#PEEK(#PC)).
  $98B5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98B6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98B7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98B8 Attribute overlay: skip.
  $98B8,$01 Opcode (#N$12).
  $98B9,$01 Skip count: #N(#PEEK(#PC)).
  $98BA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98BB Attribute overlay: skip.
  $98BB,$01 Opcode (#N$12).
  $98BC,$01 Skip count: #N(#PEEK(#PC)).
  $98BD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98BE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98BF Attribute overlay: skip.
  $98BF,$01 Opcode (#N$12).
  $98C0,$01 Skip count: #N(#PEEK(#PC)).
  $98C1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C4,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98C9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98CA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98CB Attribute overlay: skip.
  $98CB,$01 Opcode (#N$12).
  $98CC,$01 Skip count: #N(#PEEK(#PC)).
  $98CD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98CE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98CF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98D0 Attribute overlay: skip.
  $98D0,$01 Opcode (#N$12).
  $98D1,$01 Skip count: #N(#PEEK(#PC)).
  $98D2,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98D3 Attribute overlay: skip.
  $98D3,$01 Opcode (#N$12).
  $98D4,$01 Skip count: #N(#PEEK(#PC)).
  $98D5,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98D6 Attribute overlay: skip.
  $98D6,$01 Opcode (#N$12).
  $98D7,$01 Skip count: #N(#PEEK(#PC)).
  $98D8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98D9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DD,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98DF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98E0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98E1,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98E2 Attribute overlay: repeat colour.
  $98E2,$01 Opcode (#N$1B).
  $98E3,$01 Repeat count: #N(#PEEK(#PC)).
  $98E4,$01 Colour: #COLOUR(#PEEK(#PC)).
N $98E5 Attribute overlay: repeat colour.
  $98E5,$01 Opcode (#N$1B).
  $98E6,$01 Repeat count: #N(#PEEK(#PC)).
  $98E7,$01 Colour: #COLOUR(#PEEK(#PC)).
N $98E8 Attribute overlay: skip.
  $98E8,$01 Opcode (#N$12).
  $98E9,$01 Skip count: #N(#PEEK(#PC)).
N $98EA Attribute overlay: repeat colour.
  $98EA,$01 Opcode (#N$1B).
  $98EB,$01 Repeat count: #N(#PEEK(#PC)).
  $98EC,$01 Colour: #COLOUR(#PEEK(#PC)).
  $98ED,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98EE,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98EF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98F0,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98F1 Attribute overlay: skip.
  $98F1,$01 Opcode (#N$12).
  $98F2,$01 Skip count: #N(#PEEK(#PC)).
  $98F3,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98F4 Attribute overlay: skip.
  $98F4,$01 Opcode (#N$12).
  $98F5,$01 Skip count: #N(#PEEK(#PC)).
  $98F6,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98F7,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98F8,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98F9,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98FA,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98FB,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $98FC,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $98FD Attribute overlay: skip.
  $98FD,$01 Opcode (#N$12).
  $98FE,$01 Skip count: #N(#PEEK(#PC)).
  $98FF,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9900 Attribute overlay: skip.
  $9900,$01 Opcode (#N$12).
  $9901,$01 Skip count: #N(#PEEK(#PC)).
  $9902,$01 End of attribute overlay.
  $9903,$01 Terminator.

b $9904 Room #N$10: Level 5
@ $9904 label=Room16_Level5
D $9904 #ROOM$10
N $9904 Command #N$01: Skip tiles.
  $9904,$01 Command (#N$01).
  $9905,$01 Skip count: #N(#PEEK(#PC)).
N $9906 Command #N$01: Skip tiles.
  $9906,$01 Command (#N$01).
  $9907,$01 Skip count: #N(#PEEK(#PC)).
N $9908 Command #N$01: Skip tiles.
  $9908,$01 Command (#N$01).
  $9909,$01 Skip count: #N(#PEEK(#PC)).
N $990A Command #N$03: Fill attribute buffer.
  $990A,$01 Command (#N$03).
  $990B,$01 Base fill colour: #COLOUR(#PEEK(#PC)).
N $990C Attribute overlay: skip.
  $990C,$01 Opcode (#N$12).
  $990D,$01 Skip count: #N(#PEEK(#PC)).
  $990E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $990F Attribute overlay: skip.
  $990F,$01 Opcode (#N$12).
  $9910,$01 Skip count: #N(#PEEK(#PC)).
  $9911,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9912 Attribute overlay: skip.
  $9912,$01 Opcode (#N$12).
  $9913,$01 Skip count: #N(#PEEK(#PC)).
N $9914 Attribute overlay: repeat colour.
  $9914,$01 Opcode (#N$1B).
  $9915,$01 Repeat count: #N(#PEEK(#PC)).
  $9916,$01 Colour: #COLOUR(#PEEK(#PC)).
N $9917 Attribute overlay: skip.
  $9917,$01 Opcode (#N$12).
  $9918,$01 Skip count: #N(#PEEK(#PC)).
  $9919,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $991A Attribute overlay: skip.
  $991A,$01 Opcode (#N$12).
  $991B,$01 Skip count: #N(#PEEK(#PC)).
  $991C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $991D Attribute overlay: skip.
  $991D,$01 Opcode (#N$12).
  $991E,$01 Skip count: #N(#PEEK(#PC)).
  $991F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9920 Attribute overlay: skip.
  $9920,$01 Opcode (#N$12).
  $9921,$01 Skip count: #N(#PEEK(#PC)).
  $9922,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9923 Attribute overlay: skip.
  $9923,$01 Opcode (#N$12).
  $9924,$01 Skip count: #N(#PEEK(#PC)).
  $9925,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9926 Attribute overlay: skip.
  $9926,$01 Opcode (#N$12).
  $9927,$01 Skip count: #N(#PEEK(#PC)).
  $9928,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9929,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $992A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $992B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $992C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $992D Attribute overlay: skip.
  $992D,$01 Opcode (#N$12).
  $992E,$01 Skip count: #N(#PEEK(#PC)).
  $992F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9930,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9931,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9932,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9933,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9934,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9935,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9936 Attribute overlay: skip.
  $9936,$01 Opcode (#N$12).
  $9937,$01 Skip count: #N(#PEEK(#PC)).
  $9938,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9939,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $993A Attribute overlay: skip.
  $993A,$01 Opcode (#N$12).
  $993B,$01 Skip count: #N(#PEEK(#PC)).
  $993C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $993D Attribute overlay: skip.
  $993D,$01 Opcode (#N$12).
  $993E,$01 Skip count: #N(#PEEK(#PC)).
  $993F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9940 Attribute overlay: skip.
  $9940,$01 Opcode (#N$12).
  $9941,$01 Skip count: #N(#PEEK(#PC)).
  $9942,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9943 Attribute overlay: skip.
  $9943,$01 Opcode (#N$12).
  $9944,$01 Skip count: #N(#PEEK(#PC)).
  $9945,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9946,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9947,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9948 Attribute overlay: skip.
  $9948,$01 Opcode (#N$12).
  $9949,$01 Skip count: #N(#PEEK(#PC)).
  $994A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $994B Attribute overlay: skip.
  $994B,$01 Opcode (#N$12).
  $994C,$01 Skip count: #N(#PEEK(#PC)).
  $994D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $994E Attribute overlay: skip.
  $994E,$01 Opcode (#N$12).
  $994F,$01 Skip count: #N(#PEEK(#PC)).
  $9950,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9951 Attribute overlay: skip.
  $9951,$01 Opcode (#N$12).
  $9952,$01 Skip count: #N(#PEEK(#PC)).
  $9953,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9954,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9955 Attribute overlay: skip.
  $9955,$01 Opcode (#N$12).
  $9956,$01 Skip count: #N(#PEEK(#PC)).
  $9957,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9958,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9959,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $995F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9960,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9961 Attribute overlay: skip.
  $9961,$01 Opcode (#N$12).
  $9962,$01 Skip count: #N(#PEEK(#PC)).
  $9963,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9964 Attribute overlay: skip.
  $9964,$01 Opcode (#N$12).
  $9965,$01 Skip count: #N(#PEEK(#PC)).
  $9966,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9967 Attribute overlay: skip.
  $9967,$01 Opcode (#N$12).
  $9968,$01 Skip count: #N(#PEEK(#PC)).
  $9969,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $996A Attribute overlay: skip.
  $996A,$01 Opcode (#N$12).
  $996B,$01 Skip count: #N(#PEEK(#PC)).
  $996C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $996D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $996E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $996F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9970,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9971,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9972 Attribute overlay: skip.
  $9972,$01 Opcode (#N$12).
  $9973,$01 Skip count: #N(#PEEK(#PC)).
  $9974,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9975 Attribute overlay: skip.
  $9975,$01 Opcode (#N$12).
  $9976,$01 Skip count: #N(#PEEK(#PC)).
  $9977,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9978,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9979,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $997A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $997B Attribute overlay: skip.
  $997B,$01 Opcode (#N$12).
  $997C,$01 Skip count: #N(#PEEK(#PC)).
N $997D Attribute overlay: repeat colour.
  $997D,$01 Opcode (#N$1B).
  $997E,$01 Repeat count: #N(#PEEK(#PC)).
  $997F,$01 Colour: #COLOUR(#PEEK(#PC)).
  $9980,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9981,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9982,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9983,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9984 Attribute overlay: skip.
  $9984,$01 Opcode (#N$12).
  $9985,$01 Skip count: #N(#PEEK(#PC)).
  $9986,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9987 Attribute overlay: skip.
  $9987,$01 Opcode (#N$12).
  $9988,$01 Skip count: #N(#PEEK(#PC)).
  $9989,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998A,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998B,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998C,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998D,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998E,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $998F,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9990 Attribute overlay: skip.
  $9990,$01 Opcode (#N$12).
  $9991,$01 Skip count: #N(#PEEK(#PC)).
  $9992,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
  $9993,$01 Attribute cell: #COLOUR(#PEEK(#PC)).
N $9994 Attribute overlay: skip.
  $9994,$01 Opcode (#N$12).
  $9995,$01 Skip count: #N(#PEEK(#PC)).
  $9996,$01 End of attribute overlay.
  $9997,$01 Terminator.

b $9998

b $9BAA Graphics: Default Tile Set
@ $9BAA label=TileSet_Default
  $9BAA,$08 #UDGTABLE { Sprite ID: #N($08+(#PC-$9BAA)/$08) | #UDG(#PC) } TABLE#
L $9BAA,$08,$F8

u $A36A Graphics: Alternate Tile Set
@ $A36A label=TileSet_Alternate
D $A36A Utilised from #R$5E72, but it doesn't appear that it's ever called and
. the tiles here are all empty data.
B $A36A,$08
B $A762,$01 Terminator.

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

b $A793 Graphics:
@ $A793 label=Graphics_Frame_01
@ $A79B label=Graphics_Frame_02
@ $A7A3 label=Graphics_Frame_03
@ $A7AB label=Graphics_Frame_04
  $A793,$08 #UDG(#PC)
L $A793,$08,$04

b $A7B3 Graphics: Worm
@ $A7B3 label=Graphics_WormFrame_01
@ $A7BB label=Graphics_WormFrame_02
@ $A7C3 label=Graphics_WormFrame_03
@ $A7CB label=Graphics_WormFrame_04
  $A7B3,$08 #UDG(#PC,attr=$67)
L $A7B3,$08,$04

b $A7D3 Graphics: Egg
@ $A7D3 label=Graphics_EggFrame_01
@ $A7DB label=Graphics_EggFrame_02
@ $A7E3 label=Graphics_EggFrame_03
@ $A7EB label=Graphics_EggFrame_04
@ $A7F3 label=Graphics_EggFrame_05
  $A7D3,$08 #UDG(#PC)
L $A7D3,$08,$05

b $A7FB Graphics: Bomb
@ $A7FB label=Graphics_Bomb
  $A7FB,$08 #UDG(#PC)

u $A803

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
N $B05B Frog: sitting right.
@ $B05B label=Sprite_2A
@ $B07B label=Sprite_2B
N $B09B Frog: sitting left.
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
N $B1DB Explosion.
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
N $B4BB Plane: flying left.
@ $B4BB label=Sprite_4D
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
N $B67B Parachute.
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

u $B73B

c $BB1C Draw Sprites and Merge Collision Map
@ $BB1C label=Draw_Sprites
D $BB1C Draws all active sprites (Percy, hazards, etc.) to the screen buffer and
. then merges the collision map with the background scenery. First draws up to
. #N$08 three-column-wide sprites (e.g. Percy, large hazards), then up to #N$08
. two-column-wide sprites (e.g. smaller objects). After drawing, the sprite
. positions are backed up and the collision map is scanned to composite sprite
. pixels onto the background.
R $BB1C IX Percy sprite data pointer
N $BB1C Check if lives backup is non-zero; if so, clear the sprite overlay
. buffer and return early (used during life-lost sequence).
  $BB1C,$04 Point #REGix at #R$DAC0.
  $BB20,$06 Jump to #R$BB33 if *#R$5FBE is zero.
  $BB26,$0C Clear #N$02BF bytes of the sprite overlay buffer from #R$F800
. onwards.
  $BB32,$01 Return.
N $BB33 Main sprite drawing loop: draw up to #N$08 three-column-wide sprites.
@ $BB33 label=Draw_3Wide_Sprites
  $BB33,$04 Point #REGix at #R$DAC0.
  $BB37,$05 Write a terminator byte (#N$FF) to *#R$FAC0.
  $BB3C,$02 Set the sprite counter to #N$08 in #REGb.
@ $BB3E label=Draw_3Wide_Loop
  $BB3E,$01 Stash the sprite counter on the stack.
  $BB3F,$0B Clamp the Y position: if *#REGix+#N$01 is not less than #N$A1,
. write #N$A0 to *#REGix+#N$01.
@ $BB4A label=Draw_3Wide_TestActive
  $BB4A,$07 Jump to #R$BDE4 if the sprite is inactive (*#REGix+#N$03 which is
. frame ID is zero).
  $BB51,$03 Call #R$BC0E.
  $BB54,$01 Stash the screen buffer address on the stack.
  $BB55,$03 Call #R$BD5E.
  $BB58,$01 Restore the screen buffer address from the stack.
  $BB59,$03 Call #R$BC52.
@ $BB5C label=Advance_To_Next_Sprite
  $BB5C,$08 Advance #REGix to the next sprite entry (each entry is #N$04 bytes).
  $BB64,$01 Restore the sprite counter from the stack.
  $BB65,$02 Decrease the sprite counter and loop back to #R$BB3E until all
. #N$08 three-wide sprites are processed.
N $BB67 Draw up to #N$08 two-column-wide sprites.
@ $BB67 label=Draw_2Wide_Sprites
  $BB67,$02 Set the sprite counter to #N$08 in #REGb.
@ $BB69 label=Draw_2Wide_Loop
  $BB69,$01 Stash the sprite counter on the stack.
  $BB6A,$0B Clamp the Y position: if *#REGix+#N$01 is not less than #N$A9,
. write #N$A8 to *#REGix+#N$01.
  $BB75,$06 Jump to #R$BB86 if the sprite is inactive (*#REGix+#N$03 is zero).
  $BB7B,$03 Call #R$BC0E.
  $BB7E,$01 Stash the screen buffer address on the stack.
  $BB7F,$03 Call #R$BDA6.
  $BB82,$01 Restore the screen buffer address from the stack.
  $BB83,$03 Call #R$BCF7.
@ $BB86 label=Advance_To_Next_2Wide
  $BB86,$08 Advance #REGix to the next sprite entry (each entry is #N$04 bytes).
  $BB8E,$01 Restore the sprite counter from the stack.
  $BB8F,$02 Decrease the sprite counter and loop back to #R$BB69 until all
. #N$08 two-wide sprites are processed.
N $BB91 Back up current sprite positions for the next frame's erase pass.
  $BB91,$0B Copy #N$0040 bytes from #R$DAC0 to #R$DB00.
N $BB9C Scan the collision overlay buffer and merge sprite pixels onto the
. background. Each non-zero, non-#N$FF byte in the buffer is a countdown;
. when it reaches zero the sprite pixel data is composited with the scenery.
  $BB9C,$03 Set #REGhl to #N$F7FF (one byte before the overlay buffer).
  $BB9F,$01 Set #REGa to #N$00.
@ $BBA0 label=Collision_Scan_Loop
  $BBA0,$05 Increment #REGhl and jump back to #R$BBA0 if *#REGhl is zero
. (skip empty cells).
  $BBA5,$03 Return if the terminator (#N$FF) is found indicating the end of the
. buffer.
  $BBA8,$01 Decrease the countdown at *#REGhl.
  $BBA9,$05 Jump to #R$BBBB if the value was #N$02 (skip background restore).
N $BBAE Restore the background pixel at this position from the scenery buffer.
  $BBAE,$01 Stash the overlay buffer pointer on the stack.
  $BBAF,$04 Calculate the scenery source address in #REGde by subtracting
. #N$20 from the high byte of #REGhl.
  $BBB3,$01 Copy the low byte across.
  $BBB4,$04 Calculate the screen destination address in #REGhl by subtracting
. #N$A0 from the high byte.
  $BBB8,$02 Copy the scenery byte from *#REGde to the screen buffer at *#REGhl.
  $BBBA,$01 Restore the overlay buffer pointer from the stack.
N $BBBB Merge the sprite column pixels with the background. Derives the sprite
. buffer, background and screen buffer addresses from the overlay buffer pointer,
. then ORs sprite data onto the background for #N$08 pixel rows.
@ $BBBB label=Merge_Sprite_Column
  $BBBB,$01 Stash the overlay buffer pointer on the stack.
M $BBBC,$06 Derive the attribute row from the overlay buffer address: mask the
. low two bits of the high byte, rotate left three times and set bits 6-7 to
. form the base screen buffer address high byte.
  $BBBD,$02,b$01 Keep only bits 0-1.
  $BBC2,$02,b$01 Set bits 6-7.
  $BBC4,$05 Set #REGh, #REGb (sprite source) and #REGd (screen destination) to
. this base. Set bit 5 of #REGb for the sprite buffer and reset bit 7 of
. #REGd for the screen buffer.
  $BBCB,$02 Copy the low byte to #REGc and #REGe.
N $BBCD Merge eight pixel rows: OR the sprite data from *#REGbc onto the
. background at *#REGhl, write the result to the screen buffer at *#REGde, then
. clear the sprite source byte.
  $BBCD,$05 Row 1: merge sprite with background, write to screen, clear sprite.
  $BBD2,$08 Row 2: advance all row pointers and merge.
  $BBDA,$08 Row 3: advance all row pointers and merge.
  $BBE2,$08 Row 4: advance all row pointers and merge.
  $BBEA,$08 Row 5: advance all row pointers and merge.
  $BBF2,$09 Row 6: advance all row pointers and merge.
  $BBFB,$06 Row 7: advance all row pointers and merge.
  $BC01,$09 Row 8: advance all row pointers, merge and clear sprite.
  $BC0A,$01 Restore the overlay buffer pointer from the stack.
  $BC0B,$03 Jump back to #R$BBA0 to continue scanning.

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

c $BC37 Adjust Screen Address at Row Boundary
@ $BC37 label=Adjust_Screen_Address
D $BC37 Adjusts the screen buffer address in #REGhl when a pixel row crosses a
. character cell boundary.
R $BC37 HL Screen buffer address
R $BC37 O:HL Adjusted Screen buffer address
  $BC37,$01 Load the low byte of the screen address.
M $BC38,$03 Undo the previous row increment and test if the next character row
. would cross into the next screen third.
  $BC3A,$02,b$01 Keep only bits 5-7.
  $BC3C,$02 Jump to #R$BC47 if crossing into the next screen third.
  $BC3E,$04 Add #N$20 to #REGl to move to the next character row.
M $BC42,$04 Mask #REGh to reset the pixel row bits.
  $BC43,$02,b$01 Keep only bits 3-7.
  $BC46,$01 Return.
@ $BC47 label=Next_Screen_Third
M $BC47,$04 Mask #REGl to keep only the column bits.
  $BC48,$02,b$01 Keep only bits 0-4.
M $BC4B,$04 Mask #REGh and add #N$08 to advance to the next screen third.
  $BC4C,$02,b$01 Keep only bits 3-7.
  $BC51,$01 Return.

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

u $BCF4

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
M $BD2D,$04 Write the ink bits to *#REGhl.
  $BD2E,$02,b$01 Keep only bits 3-7.
  $BD32,$01 Move to the next column.
M $BD33,$04 Write the ink bits to *#REGhl.
  $BD34,$02,b$01 Keep only bits 3-7.
N $BD38 Return if Y-aligned, otherwise write a second row.
  $BD38,$01 Move back one column.
  $BD39,$02 Test bit 1 of #REGd.
  $BD3B,$01 Return if Y-aligned.
N $BD3C Move down one attribute row.
  $BD3C,$03 #REGbc=#N($0020,$04,$04).
  $BD3F,$01 #REGhl+=#REGbc.
N $BD40 Write attribute to the second row (2 cells).
M $BD40,$04 Write the ink bits to *#REGhl.
  $BD41,$02,b$01 Keep only bits 3-7.
  $BD45,$01 Move to the next column.
M $BD46,$04 Write the ink bits to *#REGhl.
  $BD47,$02,b$01 Keep only bits 3-7.
  $BD4B,$01 Return.

N $BD4C X-aligned: write attributes across 1 column only.
@ $BD4C label=WriteAttributeBlock2Wide_1Column
N $BD4C Write attribute to the first row (1 cell).
M $BD4C,$04 Write the ink bits to *#REGhl.
  $BD4D,$02,b$01 Keep only bits 3-7.
N $BD51 Return if Y-aligned, otherwise write a second row.
  $BD51,$02 Test bit 1 of #REGd.
  $BD53,$01 Return if Y-aligned.
N $BD54 Move down one attribute row.
  $BD54,$03 #REGbc=#N($0020,$04,$04).
  $BD57,$01 #REGhl+=#REGbc.
N $BD58 Write attribute to the second row (1 cell).
M $BD58,$04 Write the ink bits to *#REGhl.
  $BD59,$02,b$01 Keep only bits 3-7.
  $BD5D,$01 Return.

c $BD5E Draw 3-Wide Sprite Column
@ $BD5E label=Draw_3Wide_Sprite_Column
D $BD5E Draws a three-column-wide sprite to the screen buffer. Looks up the
. sprite graphic data from the frame table at #R$AB3B, then shifts and ORs the
. pixel data across two adjacent screen columns, repeated for two column pairs
. (covering three columns total). The shift amount is self-modified at
. #R$BD81(#N$BD82).
R $BD5E A Shift amount (self-modified into the code)
R $BD5E HL Screen buffer address
R $BD5E IX Pointer to sprite data (IX+#N$03 = one-indexed frame number)
N $BD5E Look up the sprite graphic data address. Each frame is #N$20 bytes.
  $BD5E,$03 Self-modify the shift jump offset at #R$BD81(#N$BD82).
  $BD61,$01 Stash the screen buffer address on the stack.
  $BD62,$03 Point #REGde at #R$AB3B (3-wide sprite frame table base).
  $BD65,$04 Load the frame ID from *#REGix+#N$03 and decrement to make it
. zero-indexed.
  $BD69,$08 Multiply the frame index by #N$20 and add to the table base to get
. the graphic data address.
  $BD71,$01 Exchange so #REGde points to the sprite graphic data.
  $BD72,$01 Restore the screen buffer address from the stack.
N $BD73 Draw two column pairs, each #N$10 pixels tall, covering three
. screen columns. #REGc holds a mask of #N$07 used to detect character cell
. boundaries for screen address adjustment.
  $BD73,$02 Set the column pair counter to #N$02 in #REGb.
@ $BD75 label=Draw_3Wide_Column_Loop
  $BD75,$02 Set the row boundary mask to #N$07 in #REGc.
  $BD77,$02 Stash the column pair counter and screen buffer address on the
. stack.
  $BD79,$02 Set the row counter to #N$10 in #REGb.
N $BD7B For each row, read a byte of sprite data, shift it left by the
. self-modified amount and OR the resulting two bytes across two adjacent
. screen buffer columns.
@ $BD7B label=Draw_3Wide_Row_Loop
  $BD7B,$02 Stash the graphic data pointer and screen buffer address on the
. stack.
N $BD7D Read the sprite data byte and shift it into a 16-bit value in #REGhl.
N $BD7D The shift amount at #R$BD81(#N$BD82) was self-modified on entry to
. control the horizontal pixel alignment.
  $BD7D,$01 Load the graphic byte from *#REGde.
  $BD7E,$03 Transfer sprite byte to #REGhl (clearing the high byte).
  $BD81,$02 Jump into the shift sequence (self-modified offset controls the
. number of shifts applied).
@ $BD83 label=Shift_3Wide_Extra
  $BD83,$01 Shift #REGhl left one position (extra shift).
@ $BD84 label=Shift_3Wide_Fine
  $BD84,$06 Shift #REGhl left seven positions; the total shift spreads the
. graphic byte across #REGh and #REGl.
N $BD8B OR the shifted sprite data onto the screen buffer across two adjacent
. columns.
  $BD8B,$02 Restore the screen buffer address into #REGde, keeping a copy on
. the stack.
  $BD8D,$01 Exchange so #REGhl=screen buffer address, #REGde=shifted sprite
. data.
  $BD8E,$03 OR the high byte of the shifted data onto the first screen column
. at *#REGhl.
  $BD91,$04 Advance to the next column and OR the low byte onto the second
. screen column at *#REGhl.
  $BD95,$02 Restore the screen buffer address and graphic data pointer from the
. stack.
N $BD97 Move down one pixel row in the screen buffer and check for a character
. cell boundary crossing.
  $BD97,$01 Move down one pixel row in the screen buffer.
  $BD98,$02 Test if we've crossed a character cell boundary (every #N$08 rows).
  $BD9A,$03 Call #R$BC37 to adjust the screen buffer address if a character cell
. boundary was crossed.
N $BD9D Move to the next sprite data byte and loop.
  $BD9D,$01 Advance the sprite data pointer.
  $BD9E,$02 Decrease the row counter and loop back to #R$BD7B until all #N$10
. rows are drawn.
N $BDA0 Move to the next column in the screen buffer and loop.
  $BDA0,$02 Restore the screen buffer address and column pair counter from the
. stack.
  $BDA2,$01 Move one byte to the right in the screen buffer.
  $BDA3,$02 Decrease the column pair counter and loop back to #R$BD75 until
. both column pairs are drawn.
  $BDA5,$01 Return.

c $BDA6 Draw 2-Wide Sprite Column
@ $BDA6 label=Draw_2Wide_Sprite_Column
D $BDA6 Draws a two-column-wide sprite to the screen buffer. Looks up the sprite
. graphic data from the frame table at #R$A763, then shifts and ORs the pixel
. data across two adjacent screen columns. The shift amount is self-modified at
. #R$BDC4(#N$BDC5).
R $BDA6 A Shift amount (self-modified into the code)
R $BDA6 HL Screen buffer address
R $BDA6 IX Pointer to sprite data (IX+#N$03 = one-indexed frame number)
N $BDA6 Look up the sprite graphic data address.
  $BDA6,$03 Self-modify the shift jump offset at #R$BDC4(#N$BDC5).
  $BDA9,$01 Stash the screen buffer address on the stack.
  $BDAA,$03 Point #REGde at #R$A763 (2-wide sprite frame table base).
  $BDAD,$04 Load the frame ID from *#REGix+#N$03 and decrement to make it
. zero-indexed.
  $BDB1,$07 Multiply the frame index by #N$08 and add to the table base to get
. the graphic data address.
  $BDB8,$01 Exchange so #REGde points to the sprite graphic data.
  $BDB9,$01 Restore the screen buffer address from the stack.
N $BDBA Draw eight pixel rows of the sprite across two columns.
  $BDBA,$02 Set the row counter to #N$08 in #REGb.
  $BDBC,$02 Set the row boundary mask to #N$07 in #REGc.
@ $BDBE label=Draw_2Wide_Row_Loop
  $BDBE,$02 Stash the graphic data pointer and screen buffer address on the stack.
  $BDC0,$04 Load the graphic byte from *#REGde into #REGl; set #REGh to #N$00.
  $BDC4,$02 Jump into the shift sequence (self-modified offset controls the
. number of shifts applied).
  $BDC6,$05 Shift #REGhl left five positions (coarse shift).
@ $BDCB label=Shift_Fine
  $BDCB,$03 Shift #REGhl left three more positions (fine shift); the total
. shift spreads the sprite byte across #REGh and #REGl.
  $BDCE,$02 Restore the screen buffer address onto the stack and copy to #REGde.
  $BDD0,$04 OR the high byte of the shifted data onto the first screen column
. at *#REGhl.
  $BDD4,$04 Advance to the next column and OR the low byte onto the second
. screen column at *#REGhl.
  $BDD8,$02 Restore the screen buffer address and graphic data pointer from the stack.
  $BDDA,$01 Advance to the next pixel row in the screen buffer.
  $BDDB,$01 Advance to the next graphic byte.
  $BDDC,$05 If the pixel row has crossed a character boundary (masked with
. #REGc), call #R$BC37 to adjust the screen buffer address.
  $BDE1,$02 Decrease the row counter and loop back to #R$BDBE until all #N$08
. rows are drawn.
  $BDE3,$01 Return.

c $BDE4 Sprite Inactive Delay
@ $BDE4 label=Sprite_Inactive_Delay
D $BDE4 Called when a 3-wide sprite is inactive. Executes a timing delay loop to
. keep frame timing consistent, then advances to the next sprite entry.
R $BDE4 IX Pointer to the inactive sprite entry (preserved)
  $BDE4,$01 Stash the sprite counter on the stack.
  $BDE5,$02 Set the delay counter to #N$C8 in #REGb.
@ $BDE7 label=Inactive_Delay_Loop
  $BDE7,$0B NOP as a timing delay.
  $BDF2,$02 Decrease the delay counter and loop back to #R$BDE7 until complete.
  $BDF4,$01 Restore the sprite counter from the stack.
  $BDF5,$03 Jump to #R$BB5C to advance to the next sprite.

u $BDF8
B $BDF8,$08,$01

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

u $BE93
B $BE93,$01

u $BE94 Unused: Draw 2-Wide Sprite With Attributes
@ $BE94 label=Unused_Draw_2Wide
D $BE94 Unused alternative routine to draw a 2-wide sprite and apply its
. attributes in a single pass. Later replaced by #R$BDA6 and #R$BD43.
C $BE94,$02 Set the row counter to #N$08 in #REGb.
@ $BE96 label=Unused_Draw_2Wide_Row_Loop
C $BE96,$03 OR the sprite data byte from *#REGde onto the first screen column
. at *#REGhl.
C $BE99,$05 Advance to the next column and OR the next sprite byte onto the
. second column.
C $BE9E,$02 Move back to the first column and advance the sprite data pointer.
C $BEA0,$01 Move down one pixel row in the screen buffer.
C $BEA1,$02 Check if the pixel row has crossed a character boundary.
C $BEA3,$03 Call #N$BD67 to adjust the screen address if needed.
C $BEA6,$02 Decrease the row counter and loop back to #R$BE96 until all #N$08
. rows are drawn.
N $BEA8 Apply attributes for the 2-wide sprite.
C $BEA8,$02 Set #REGd to #N$01 (flag: two columns wide).
C $BEAA,$01 Restore the screen address from the stack.
C $BEAB,$03 Load the sprite X position from *#REGix+#N$00 into #REGe.
C $BEAE,$03 Call #R$BECA to apply the sprite attributes.
C $BEB1,$01 Return.

u $BEB2 Unused: Draw 1-Wide Sprite With Attributes
@ $BEB2 label=Unused_Draw_1Wide
D $BEB2 Unused alternative routine to draw a 1-wide sprite and apply its
. attributes in a single pass.
C $BEB2,$02 Set the row counter to #N$08 in #REGb.
@ $BEB4 label=Unused_Draw_1Wide_Row_Loop
C $BEB4,$03 OR the sprite data byte from *#REGde onto the screen at *#REGhl.
C $BEB7,$01 Move down one pixel row in the screen buffer.
C $BEB8,$02 Check if the pixel row has crossed a character boundary.
C $BEBA,$03 Call #N$BD67 to adjust the screen address if needed.
C $BEBD,$01 Advance the sprite data pointer.
C $BEBE,$02 Decrease the row counter and loop back to #R$BEB4 until all #N$08
. rows are drawn.
N $BEC0 Apply attributes for the 1-wide sprite.
C $BEC0,$01 Restore the screen address from the stack.
C $BEC1,$03 Load the sprite X position from *#REGix+#N$00 into #REGe.
C $BEC4,$02 Set #REGd to #N$00 (flag: one column wide).
C $BEC6,$03 Call #R$BECA to apply the sprite attributes.
C $BEC9,$01 Return.

u $BECA Unused: Apply Sprite Attributes
@ $BECA label=Unused_Apply_Attributes
D $BECA Unused routine to apply colour attributes for a sprite. Handles both
. the overlay buffer attributes and the screen attributes.
R $BECA D Bit 0: #N$01 = two columns wide, #N$00 = one column wide
R $BECA E Sprite X position
R $BECA HL Screen buffer address
C $BECA,$02 Set #REGc to #N$58 (overlay attribute buffer base high byte).
C $BECC,$03 Load the sprite X position from *#REGix+#N$00.
C $BECF,$04 Jump to #R$BED8 if the X position is #N$FF (sprite offscreen).
C $BED3,$01 Stash the screen address on the stack.
C $BED4,$03 Call #R$BEE0 to apply the overlay buffer attributes.
C $BED7,$01 Restore the screen address from the stack.
@ $BED8 label=Unused_Apply_Screen_Attributes
C $BED8,$02 Set #REGc to #N$F8 (screen attribute buffer base high byte).
C $BEDA,$02 Set #REGe to #N$02 (attribute INK colour).
C $BEDC,$03 Call #R$BEE0 to apply the screen attributes.
C $BEDF,$01 Return.

u $BEE0 Unused: Write Sprite Attribute Cells
@ $BEE0 label=Unused_Write_Attribute_Cells
D $BEE0 Unused routine to write INK colour to attribute cells for a sprite.
. Converts the screen buffer address to an attribute address, then writes
. the colour to one or two cells depending on the sprite width, handling
. character row boundaries if the sprite straddles two rows.
R $BEE0 C Attribute buffer base high byte
R $BEE0 D Bit 0: width flag, Bit 1: set if straddling two character rows
R $BEE0 E Attribute INK colour
R $BEE0 HL Screen buffer address
C $BEE0,$08 Check if the sprite straddles two character rows by testing bits
. 0-2 of #REGh; if non-zero, set bit 1 of #REGd.
N $BEE8 Convert the screen buffer address to the attribute buffer address.
@ $BEE8 label=Unused_Convert_To_Attribute
C $BEE8,$08 Rotate #REGh right three times, mask with #N$03 and OR with #REGc
. to form the attribute buffer high byte.
C $BEF0,$04 Jump to #R$BF13 if bit 0 of #REGd is clear (one column wide).
N $BEF2 Two columns wide: write the INK colour to two adjacent attribute cells.
C $BEF4,$05 Read *#REGhl, mask off the existing INK with #N$F8, OR in #REGe
. and write back.
C $BEF9,$06 Advance to the next column, read, mask, OR and write back.
C $BEFF,$01 Move back to the first column.
C $BF00,$03 Return if bit 1 of #REGd is clear (no row straddling).
N $BF03 Sprite straddles two character rows: write the INK colour to the next
. row as well.
C $BF03,$04 Add #N($0020,$04,$04) to #REGhl to advance to the next attribute row.
C $BF07,$05 Read, mask with #N$F8, OR in #REGe and write back.
C $BF0C,$06 Advance to the next column, read, mask, OR and write back.
C $BF12,$01 Return.
N $BF13 One column wide: write the INK colour to a single attribute cell.
@ $BF13 label=Unused_Write_1Wide_Attribute
C $BF13,$05 Read *#REGhl, mask with #N$F8, OR in #REGe and write back.
C $BF18,$03 Return if bit 1 of #REGd is clear (no row straddling).
C $BF1B,$04 Add #N($0020,$04,$04) to #REGhl to advance to the next attribute row.
C $BF1F,$05 Read, mask with #N$F8, OR in #REGe and write back.
C $BF24,$01 Return.

u $BF25 Unused: Fragment
@ $BF25 label=Unused_Fragment
D $BF25 Appears to be an orphaned fragment from an earlier version of the sprite
. drawing code.
C $BF25,$01 Advance the sprite data pointer.
C $BF26,$02 Restore #REGaf and #REGbc from the stack.
C $BF28,$02 Decrease counter and loop back to #R$BF16.
C $BF2A,$01 Restore #REGhl from the stack.
C $BF2B,$01 Return.

u $BF2C Unused: Copy 8 Bytes
@ $BF2C label=Unused_Copy_8_Bytes
D $BF2C Unused routine to copy #N$08 bytes from *#REGde to *#REGhl.
C $BF2C,$02 Set the byte counter to #N$08 in #REGb.
@ $BF2E label=Unused_Copy_Loop
C $BF2E,$02 Copy one byte from *#REGde to *#REGhl.
C $BF30,$01 Advance the destination pointer.
C $BF31,$01 Advance the source pointer.
C $BF32,$02 Decrease the counter and loop back to #R$BF2E until all #N$08
. bytes are copied.
C $BF34,$01 Return.

u $BF35 Unused: Draw 3-Wide Sprite With Attributes
@ $BF35 label=Unused_Draw_3Wide
D $BF35 Unused alternative routine to draw a 3-wide sprite and apply its
. attributes in a single pass. Later replaced by #R$BD5E and #R$BD6E.
C $BF35,$03 Copy #REGde to #REGix.
C $BF38,$03 Load the screen address low byte from *#REGix+#N$00.
C $BF3B,$02 Advance #REGix.
C $BF3D,$03 Load the screen address high byte from *#REGix+#N$00.
C $BF40,$01 Stash the screen address on the stack.
C $BF41,$02 Advance #REGix.
C $BF43,$03 Load the width flag from *#REGix+#N$00.
C $BF46,$02 Advance #REGix.
C $BF48,$02 Copy #REGix to #REGde.
C $BF4A,$02 Advance #REGde past the data header.
C $BF4C,$02 Set the row boundary mask to #N$07 in #REGc.
C $BF4E,$03 Jump to #R$BF6F if the width flag is zero (one column wide).
N $BF51 Draw two columns per row.
C $BF51,$02 Set the row counter to #N$08 in #REGb.
@ $BF53 label=Unused_Draw_3Wide_Row_Loop
C $BF53,$03 OR the sprite data byte from *#REGde onto the first screen column
. at *#REGhl.
C $BF56,$05 Advance to the next column and OR the next byte onto the second
. column.
C $BF5B,$02 Move back to the first column and advance the sprite data pointer.
C $BF5D,$01 Move down one pixel row in the screen buffer.
C $BF5E,$02 Check if the pixel row has crossed a character boundary.
C $BF60,$03 Call #N$BD67 to adjust the screen address if needed.
C $BF63,$02 Decrease the row counter and loop back to #R$BF53 until all #N$08
. rows are drawn.
N $BF65 Apply attributes for the 3-wide sprite (two columns).
C $BF65,$02 Set #REGd to #N$01 (flag: two columns wide).
C $BF67,$01 Restore the screen address from the stack.
C $BF68,$03 Load the sprite X position from *#REGix+#N$00 into #REGe.
C $BF6B,$03 Call #R$BF87 to apply the sprite attributes.
C $BF6E,$01 Return.
N $BF6F Draw one column per row.
@ $BF6F label=Unused_Draw_3Wide_1Col
C $BF6F,$02 Set the row counter to #N$08 in #REGb.
@ $BF71 label=Unused_Draw_3Wide_1Col_Loop
C $BF71,$03 OR the sprite data byte from *#REGde onto the screen at *#REGhl.
C $BF74,$01 Move down one pixel row in the screen buffer.
C $BF75,$02 Check if the pixel row has crossed a character boundary.
C $BF77,$03 Call #N$BD67 to adjust the screen address if needed.
C $BF7A,$01 Advance the sprite data pointer.
C $BF7B,$02 Decrease the row counter and loop back to #R$BF71 until all #N$08
. rows are drawn.
N $BF7D Apply attributes for the 3-wide sprite (one column).
C $BF7D,$01 Restore the screen address from the stack.
C $BF7E,$03 Load the sprite X position from *#REGix+#N$00 into #REGe.
C $BF81,$02 Set #REGd to #N$00 (flag: one column wide).
C $BF83,$03 Call #R$BF87 to apply the sprite attributes.
C $BF86,$01 Return.

u $BF87 Unused: Apply 3-Wide Sprite Attributes
@ $BF87 label=Unused_Apply_3Wide_Attributes
D $BF87 Unused routine to apply colour attributes for a 3-wide sprite. Handles
. both the overlay buffer and screen attributes.
R $BF87 D Bit 0: #N$01 = two columns wide, #N$00 = one column wide
R $BF87 E Sprite X position
R $BF87 HL Screen buffer address
C $BF87,$02 Set #REGc to #N$58 (overlay attribute buffer base high byte).
C $BF89,$01 Stash the screen address on the stack.
C $BF8A,$03 Call #R$BF94 to apply the overlay buffer attributes.
C $BF8D,$01 Restore the screen address from the stack.
C $BF8E,$02 Set #REGc to #N$F8 (screen attribute buffer base high byte).
C $BF90,$03 Call #R$BF94 to apply the screen attributes.
C $BF93,$01 Return.

u $BF94 Unused: Write 3-Wide Attribute Cells
@ $BF94 label=Unused_Write_3Wide_Attributes
D $BF94 Unused routine to write INK colour to attribute cells for a 3-wide
. sprite. Identical in structure to #R$BEE0 but used by the 3-wide drawing
. path.
R $BF94 C Attribute buffer base high byte
R $BF94 D Bit 0: width flag, Bit 1: set if straddling two character rows
R $BF94 E Attribute INK colour
R $BF94 HL Screen buffer address
C $BF94,$06 Check if the sprite straddles two character rows by testing bits
. 0-2 of #REGh; if non-zero, set bit 1 of #REGd.
@ $BF9C label=Unused_3Wide_Convert_Attr
C $BF9C,$08 Convert the screen address to the attribute address using #REGc as
. the base high byte.
C $BFA4,$04 Jump to #R$BFC7 if bit 0 of #REGd is clear (one column wide).
N $BFA8 Two columns wide: write the INK colour to two adjacent attribute cells.
C $BFA8,$05 Read *#REGhl, mask with #N$F8, OR in #REGe and write back.
C $BFAD,$06 Advance to the next column, read, mask, OR and write back.
C $BFB3,$01 Move back to the first column.
C $BFB4,$03 Return if bit 1 of #REGd is clear (no row straddling).
C $BFB7,$04 Add #N($0020,$04,$04) to advance to the next attribute row.
C $BFBB,$05 Read, mask with #N$F8, OR in #REGe and write back.
C $BFC0,$06 Advance to the next column, read, mask, OR and write back.
C $BFC6,$01 Return.
N $BFC7 One column wide: write the INK colour to a single attribute cell.
@ $BFC7 label=Unused_3Wide_Write_1Col_Attr
C $BFC7,$05 Read *#REGhl, mask with #N$F8, OR in #REGe and write back.
C $BFCC,$03 Return if bit 1 of #REGd is clear (no row straddling).
C $BFCF,$04 Add #N($0020,$04,$04) to advance to the next attribute row.
C $BFD3,$05 Read, mask with #N$F8, OR in #REGe and write back.
C $BFD8,$01 Return.

u $BFD9 Unused: Fragment 2
@ $BFD9 label=Unused_Fragment_2
D $BFD9 Orphaned fragment from an earlier version of the attribute writing code.
C $BFD9,$01 Copy #REGd to #REGc.
C $BFDA,$01 Return if zero flag is set.
C $BFDB,$04 Add #N($0020,$04,$04) to advance to the next attribute row.
C $BFDF,$05 Read, mask with #N$F8, OR in #REGe and write back.
C $BFE4,$01 Return.

u $BFE5
B $BFE5,$1B

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

g $DAC4 3-Wide Sprite 1 Data States
@ $DAC4 label=Sprite01_3Wide_X_Position
D $DAC4 Used by #R$69F7(the Red Bird).
B $DAC4,$01 Sprite 1 X position.
@ $DAC5 label=Sprite01_3Wide_Y_Position
B $DAC5,$01 Sprite 1 Y position.
@ $DAC6 label=Sprite01_3Wide_Colour
B $DAC6,$01 Sprite 1 INK colour.
@ $DAC7 label=Sprite01_3Wide_Frame_ID
B $DAC7,$01 Sprite 1 frame ID.

g $DAC8 3-Wide Sprite 2 Data States
@ $DAC8 label=Sprite02_3Wide_X_Position
D $DAC8 Used by #R$7082(Frog 1), #R$6E5D(Car Type 1).
B $DAC8,$01 Sprite 2 X position.
@ $DAC9 label=Sprite02_3Wide_Y_Position
B $DAC9,$01 Sprite 2 Y position.
@ $DACA label=Sprite02_3Wide_Colour
B $DACA,$01 Sprite 2 INK colour.
@ $DACB label=Sprite02_3Wide_Frame_ID
B $DACB,$01 Sprite 2 frame ID.

g $DACC 3-Wide Sprite 3 Data States
@ $DACC label=Sprite03_3Wide_X_Position
D $DACC Used by #R$7082(Frog 2).
B $DACC,$01 Sprite 3 X position.
@ $DACD label=Sprite03_3Wide_Y_Position
B $DACD,$01 Sprite 3 Y position.
@ $DACE label=Sprite03_3Wide_Colour
B $DACE,$01 Sprite 3 INK colour.
@ $DACF label=Sprite03_3Wide_Frame_ID
B $DACF,$01 Sprite 3 frame ID.

g $DAD0 3-Wide Sprite 4 Data States
@ $DAD0 label=Sprite04_3Wide_X_Position
D $DAD0 Used by #R$7028(Car Type 3), #R$7512(Cat).
B $DAD0,$01 Sprite 4 X position.
@ $DAD1 label=Sprite04_3Wide_Y_Position
B $DAD1,$01 Sprite 4 Y position.
@ $DAD2 label=Sprite04_3Wide_Colour
B $DAD2,$01 Sprite 4 INK colour.
@ $DAD3 label=Sprite04_3Wide_Frame_ID
B $DAD3,$01 Sprite 4 frame ID.

g $DAD4 3-Wide Sprite 5 Data States
@ $DAD4 label=Sprite05_3Wide_X_Position
D $DAD4 Used by #R$6F8D(Car Type 2), #R$758B(Dog), #R$7680(Plane).
B $DAD4,$01 Sprite 5 X position.
@ $DAD5 label=Sprite05_3Wide_Y_Position
B $DAD5,$01 Sprite 5 Y position.
@ $DAD6 label=Sprite05_3Wide_Colour
B $DAD6,$01 Sprite 5 INK colour.
@ $DAD7 label=Sprite05_3Wide_Frame_ID
B $DAD7,$01 Sprite 5 frame ID.

g $DAD8 3-Wide Sprite 6 Data States
@ $DAD8 label=Sprite06_3Wide_X_Position
D $DAD8 Used by #R$7439(the Helicopter), #R$79D2(Parachute).
B $DAD8,$01 Sprite 6 X position.
@ $DAD9 label=Sprite06_3Wide_Y_Position
B $DAD9,$01 Sprite 6 Y position.
@ $DADA label=Sprite06_3Wide_Colour
B $DADA,$01 Sprite 6 INK colour.
@ $DADB label=Sprite06_3Wide_Frame_ID
B $DADB,$01 Sprite 6 frame ID.

g $DADC 3-Wide Sprite 7 Data States
@ $DADC label=Sprite07_3Wide_X_Position
D $DADC Used by #R$7512(Cat), #R$759A(UFO), #R$7680(Plane).
B $DADC,$01 Sprite 7 X position.
@ $DADD label=Sprite07_3Wide_Y_Position
B $DADD,$01 Sprite 7 Y position.
@ $DADE label=Sprite07_3Wide_Colour
B $DADE,$01 Sprite 7 INK colour.
@ $DADF label=Sprite07_3Wide_Frame_ID
B $DADF,$01 Sprite 7 frame ID.

g $DAE0 Egg Sprite Data
@ $DAE0 label=Egg_X_Position
B $DAE0,$01 Egg X position.
@ $DAE1 label=Egg_Y_Position
B $DAE1,$01 Egg Y position.
@ $DAE2 label=Egg_Colour
B $DAE2,$01 Egg INK colour.
@ $DAE3 label=Egg_Frame_ID
B $DAE3,$01 Egg frame ID.

g $DAE4 Butterfly Sprite Data
@ $DAE4 label=Butterfly_X_Position
D $DAE4 Sprite data for the butterfly collectible.
B $DAE4,$01 Butterfly X position.
@ $DAE5 label=Butterfly_Y_Position
B $DAE5,$01 Butterfly Y position.
@ $DAE6 label=Butterfly_Active_Flag
B $DAE6,$01 Butterfly active flag.
@ $DAE7 label=Butterfly_Frame_ID
B $DAE7,$01 Butterfly frame ID.

g $DAE8 2-Wide Sprite 1 Data States
@ $DAE8 label=Sprite01_2Wide_X_Position
B $DAE8,$01 Sprite 1 X position.
@ $DAE9 label=Sprite01_2Wide__Y_Position
B $DAE9,$01 Sprite 1 Y position.
@ $DAEA label=Sprite01_2Wide_Colour
B $DAEA,$01 Sprite 1 INK colour.
@ $DAEB label=Sprite01_2WideFrame_ID
B $DAEB,$01 Sprite 1 frame ID.

g $DAEC 2-Wide Sprite 2 Data States
@ $DAEC label=Sprite02_2Wide_X_Position
B $DAEC,$01 Sprite 2 X position.
@ $DAED label=Sprite02_2Wide_Y_Position
B $DAED,$01 Sprite 2 Y position.
@ $DAEE label=Sprite02_2Wide_Colour
B $DAEE,$01 Sprite 2 INK colour.
@ $DAEF label=Sprite02_2WideFrame_ID
B $DAEF,$01 Sprite 2 frame ID.

g $DAF0 2-Wide Sprite 3 Data States
@ $DAF0 label=Sprite03_2Wide_X_Position
B $DAF0,$01 Sprite 3 X position.
@ $DAF1 label=Sprite03_2Wide_Y_Position
B $DAF1,$01 Sprite 3 Y position.
@ $DAF2 label=Sprite03_2Wide_Colour
B $DAF2,$01 Sprite 3 INK colour.
@ $DAF3 label=Sprite03_2WideFrame_ID
B $DAF3,$01 Sprite 3 frame ID.

g $DAF4 2-Wide Sprite 4 Data States
@ $DAF4 label=Sprite04_2Wide_X_Position
B $DAF4,$01 Sprite 4 X position.
@ $DAF5 label=Sprite04_2Wide_Y_Position
B $DAF5,$01 Sprite 4 Y position.
@ $DAF6 label=Sprite04_2Wide_Colour
B $DAF6,$01 Sprite 4 INK colour.
@ $DAF7 label=Sprite04_2WideFrame_ID
B $DAF7,$01 Sprite 4 frame ID.

g $DAF8 2-Wide Sprite 5 Data States
@ $DAF8 label=Sprite05_2Wide_X_Position
B $DAF8,$01 Sprite 5 X position.
@ $DAF9 label=Sprite05_2Wide_Y_Position
B $DAF9,$01 Sprite 5 Y position.
@ $DAFA label=Sprite05_2Wide_Colour
B $DAFA,$01 Sprite 5 INK colour.
@ $DAFB label=Sprite05_2WideFrame_ID
B $DAFB,$01 Sprite 5 frame ID.

g $DAFC 2-Wide Sprite 6 Data States
@ $DAFC label=Sprite06_2Wide_X_Position
B $DAFC,$01 Sprite 6 X position.
@ $DAFD label=Sprite06_2Wide_Y_Position
B $DAFD,$01 Sprite 6 Y position.
@ $DAFE label=Sprite06_2Wide_Colour
B $DAFE,$01 Sprite 6 INK colour.
@ $DAFF label=Sprite06_2WideFrame_ID
B $DAFF,$01 Sprite 6 frame ID.

g $DB00 Backup: Percy
@ $DB00 label=Backup_Percy
D $DB00 Backup of #R$DAC0. First byte is Percy's X from previous frame (used for
. wing flap animation); written each frame by #R$BB91.
B $DB00,$04

g $DB04 Backup: 3-Wide Sprite 1
@ $DB04 label=Backup_3Wide_Sprite1
D $DB04 Backup of #R$DAC4; written each frame by #R$BB91.
B $DB04,$04

g $DB08 Backup: 3-Wide Sprite 2
@ $DB08 label=Backup_3Wide_Sprite2
D $DB08 Backup of #R$DAC8; written each frame by #R$BB91.
B $DB08,$04

g $DB0C Backup: 3-Wide Sprite 3
@ $DB0C label=Backup_3Wide_Sprite3
D $DB0C Backup of #R$DACC; written each frame by #R$BB91.
B $DB0C,$04

g $DB10 Backup: 3-Wide Sprite 4
@ $DB10 label=Backup_3Wide_Sprite4
D $DB10 Backup of #R$DAD0; written each frame by #R$BB91.
B $DB10,$04

g $DB14 Backup: 3-Wide Sprite 5
@ $DB14 label=Backup_3Wide_Sprite5
D $DB14 Backup of #R$DAD4; written each frame by #R$BB91.
B $DB14,$04

g $DB18 Backup: 3-Wide Sprite 6
@ $DB18 label=Backup_3Wide_Sprite6
D $DB18 Backup of #R$DAD8; written each frame by #R$BB91.
B $DB18,$04

g $DB1C Backup: 3-Wide Sprite 7
@ $DB1C label=Backup_3Wide_Sprite7
D $DB1C Backup of #R$DADC; written each frame by #R$BB91.
B $DB1C,$04

g $DB20 Backup: Egg
@ $DB20 label=Backup_Egg
D $DB20 Backup of #R$DAE0; written each frame by #R$BB91.
B $DB20,$04

u $DB24

g $DB28 Backup: 2-Wide Sprite 1
@ $DB28 label=Backup_2Wide_Sprite1
D $DB28 Backup of #R$DAE8; written each frame by #R$BB91.
B $DB28,$04

g $DB2C Backup: 2-Wide Sprite 2
@ $DB2C label=Backup_2Wide_Sprite2
D $DB2C Backup of #R$DAEC; written each frame by #R$BB91.
B $DB2C,$04

g $DB30 Backup: 2-Wide Sprite 3
@ $DB30 label=Backup_2Wide_Sprite3
D $DB30 Backup of #R$DAF0; written each frame by #R$BB91.
B $DB30,$04

g $DB34 Backup: 2-Wide Sprite 4
@ $DB34 label=Backup_2Wide_Sprite4
D $DB34 Backup of #R$DAF4; written each frame by #R$BB91.
B $DB34,$04

g $DB38 Backup: 2-Wide Sprite 5
@ $DB38 label=Backup_2Wide_Sprite5
D $DB38 Backup of #R$DAF8; written each frame by #R$BB91.
B $DB38,$04

g $DB3C Backup: 2-Wide Sprite 6
@ $DB3C label=Backup_2Wide_Sprite6
D $DB3C Backup of #R$DAFC; written each frame by #R$BB91.
B $DB3C,$04

u $DB40
B $DB40,$035E

g $DE9E Room Object Data
@ $DE9E label=Room_Object_Data
D $DE9E Buffer holding the state of interactive objects (worms, nest slots) for
. all rooms. Each byte can be:
. #TABLE(default,centre,centre)
. { =h Value | =h Meaning }
. { #N$00 | Empty / available }
. { #N$1E | Worm collected by Percy }
. { #N$1F | Worm delivered to nest }
. TABLE#
. The buffer is #N$0160 bytes long, pointed to per-room by #R$5FB5.
  $DE9E,$0160,$20

g $E000 Sprite Buffer
@ $E000 label=SpriteBuffer
B $E000,$1800,$20

g $F800 Overlay Buffer
@ $F800 label=OverlayBuffer
B $F800,$02C0,$20
@ $FAC0 label=OverlayBuffer_End
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
@ $FBF9 label=Audio_LevelCompleteJingle
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
D $FF58 #UDGTABLE
. { =h Copy of the spider sprite }
. { =h Sprite ID: #N($5F) | =h Sprite ID: #N($60) }
. { #UDGS$02,$02(spider-01)(
.   #UDG($FF58+$08*($02*$x+$y))(*udg)
.   udg
. ) |
. #UDGS$02,$02(spider-02)(
.   #UDG($FF78+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
. #UDGTABLE
. { =h Slight variation on car 2 }
. { =h Sprite ID: #N($22) | =h Sprite ID: #N($23) }
. { #UDGS$02,$02(car-two-driving-right-01)(
.   #UDG($FF98+$08*($02*$x+$y))(*udg)
.   udg
. ) |
. #UDGS$02,$02(car-two-driving-right-02)(
.   #UDG($FFB8+$08*($02*$x+$y))(*udg)
.   udg
. ) } TABLE#
  $FF58,$08 #N((#PC-$FF58)/$08): #UDG(#PC)
L $FF58,$08,$15

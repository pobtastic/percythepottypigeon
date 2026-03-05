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
  $60AE,$03 #REGa=*#REGix+#N$21.
  $60B1,$02 #REGa+=#N$04.
  $60B3,$02 Has the egg reached Y position #N$A8?
  $60B5,$02 Jump to #R$60BF if not yet reached.
N $60B7 Egg has reached its target so end the egg drop state.
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
N $60ED Start the egg drop sequence and set the egg's target position/
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
  $66B5,$05 Set *#R$5FAA to #N$FF (mark Percy as carrying a worm).
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
  $66FB,$05 Set *#R$5FAC to #N$FF (enable worm drop).
@ $6700 label=Set_Worm_Sprite_X
  $6700,$0A Calculate the worm-in-beak X position: if *#R$5FA5 (facing
. direction) is zero (facing right), add #N$0C to Percy's X, otherwise add
. #N$FB (offset left).
  $670A,$02 #REGa=#N$FB.
  $670C,$03 Add the offset to Percy's X position.
  $670F,$03 Write the result to *#REGix+#N$20 (worm sprite X position).
  $6712,$05 Set the worm sprite Y position to Percy's Y plus #N$04.
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
  $677D,$02 Output the speaker state to port #N$FE.
  $677F,$02 Loop the inner delay for #REGb iterations.
  $6781,$09 Toggle the speaker bit pattern using XOR #N$18, mixed with duration
. bits for a warbling effect.
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
  $690E,$03 Call #R$6A5F.
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

c $6BC8 Red Bird Direction Jump Table
@ $6BC8 label=RedBirdDirectionJumpTable
D $6BC8 Movement direction jump table. The entry point is self-modified at
. #R$6BC8(#N$6BC9) to jump to one of 8 directional movement handlers. Each
. handler adjusts #REGb (Y) and/or #REGc (X) by the flight speed value at
. *#REGhl, then falls through to #R$6C0C to validate the position.
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
  $6BC8,$02 Self-modified jump; offset written by #R$6B4E.
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
N $6C26 Position is within this region so store it and return success.
  $6C26,$03 Write #REGc to *#REGix+#N$00 (X position).
  $6C29,$03 Write #REGb to *#REGix+#N$01 (Y position).
  $6C2C,$01 Restore the boundary pointer from the stack.
  $6C2D,$01 Clear carry (valid position).
  $6C2E,$01 Return.
N $6C2F Position is outside this region so try the next one.
@ $6C2F label=ValidateRedBirdPosition_Next
  $6C2F,$01 Restore the boundary pointer from the stack.
  $6C30,$04 Advance #REGhl by #N$04 (next boundary entry).
  $6C34,$02 Jump to #R$6C0F.
N $6C36 End of boundary data. No valid region found.
@ $6C36 label=ValidateRedBirdPosition_OutOfBounds
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

  $6CDF

c $6DAB Handle Cars
@ $6DAB label=Handle_Cars
D $6DAB Dispatches to the appropriate car handler based on the current room, then
. manages the car movement and crash animation. Cars move left across the screen
. and are randomised when they go off-screen. When hit by Percy's egg, a crash
. animation plays using frames #N$24-#N$27 before the car resets.
N $6DAB Check if respawning; if so, reset the car state.
  $6DAB,$06 Jump to #R$6DB8 if *#R$5FBB (respawn flag) is zero.
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
  $6DD5,$07 Call #R$6E2F if *#R$5FBB (respawn flag) is non-zero to randomise
. the car.
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
  $6E0F,$04 Set the front sprite frame to #N$1E (car front).
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
  $6F94,$03 #REGa=*#R$5FBB.
  $6F97,$03 Jump to #R$700C if the room buffer flag is set.
N $6F9A If the car crash timer is active, handle the crash animation.
  $6F9A,$03 #REGa=*#R$7208.
  $6F9D,$04 Jump to #R$6E6E if the crash timer is active.
N $6FA1 Check which road the car is on.
  $6FA1,$03 #REGa=*#REGix+#N$01 (car Y position).
  $6FA4,$02 Is the car on the upper road (#N$90)?
  $6FA6,$02 Jump to #R$6FCB if on the upper road.
N $6FA8 Car is on the lower road (Y=#N$A0) — driving left.
  $6FA8,$03 #REGa=*#REGix+#N$00 (car X position).
  $6FAB,$01 #REGa-=*#REGhl (subtract speed).
  $6FAC,$02 Has the car reached #N$68 (left boundary)?
  $6FAE,$02 Jump to #R$6FEE if at the left boundary (turn around).
N $6FB0 Update positions and set driving left frames.
@ $6FB0 label=Handler_CarType2_UpdateLeft
  $6FB0,$03 Write #REGa to *#REGix+#N$00 (front X).
  $6FB3,$02 #REGa+=#N$10.
  $6FB5,$03 Write #REGa to *#REGix+#N$04 (rear X).
  $6FB8,$04 Write #N$A0 to *#REGix+#N$01 (front Y: lower road).
  $6FBC,$04 Write #N$A0 to *#REGix+#N$05 (rear Y: lower road).
  $6FC0,$04 Write #N$1E to *#REGix+#N$03 (front frame: driving left).
  $6FC4,$04 Write #N$1F to *#REGix+#N$07 (rear frame: driving left).
  $6FC8,$03 Jump to #R$6EE8.
N $6FCB Car is on the upper road (Y=#N$90) — driving right.
@ $6FCB label=Handler_CarType2_DriveRight
  $6FCB,$03 #REGa=*#REGix+#N$00 (car X position).
  $6FCE,$01 #REGa+=*#REGhl (add speed).
  $6FCF,$02 Has the car reached #N$DE (right edge)?
  $6FD1,$02 Jump to #R$700C if at the right edge (reinitialise).
N $6FD3 Update positions and set driving right frames.
@ $6FD3 label=Handler_CarType2_UpdateRight
  $6FD3,$03 Write #REGa to *#REGix+#N$00 (front X).
  $6FD6,$02 #REGa+=#N$10.
  $6FD8,$03 Write #REGa to *#REGix+#N$04 (rear X).
  $6FDB,$04 Write #N$90 to *#REGix+#N$01 (front Y: upper road).
  $6FDF,$04 Write #N$90 to *#REGix+#N$05 (rear Y: upper road).
  $6FE3,$04 Write #N$1C to *#REGix+#N$03 (front frame: driving right).
  $6FE7,$04 Write #N$1D to *#REGix+#N$07 (rear frame: driving right).
  $6FEB,$03 Jump to #R$6EBC.
N $6FEE Car reached the left boundary — turn around. Pick a new random speed
. and colour, then start driving right from the left boundary.
@ $6FEE label=Handler_CarType2_TurnAround
  $6FEE,$01 Stash #REGhl on the stack.
  $6FEF,$03 Call #R$6C39.
  $6FF2,$01 Restore #REGhl from the stack.
  $6FF3,$02,b$01 Keep only bits 0-1 (random speed #N$00-#N$03).
  $6FF5,$01 Increment (speed #N$01-#N$04).
  $6FF6,$01 Write the new speed to *#REGhl.
N $6FF7 Pick a new colour, rejecting #N$01 (blue).
  $6FF7,$01 Stash #REGhl on the stack.
  $6FF8,$03 Call #R$6C39.
  $6FFB,$01 Restore #REGhl from the stack.
  $6FFC,$02,b$01 Keep only bits 0-1.
  $6FFE,$02 Is the colour #N$01 (blue)?
  $7000,$02 Jump to #R$6FF7 if blue (pick again).
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
  $7011,$02,b$01 Keep only bits 0-1.
  $7013,$01 Increment (speed #N$01-#N$04).
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
  $7031,$03 #REGa=*#R$5FBB.
  $7034,$03 Jump to #R$704E if the room buffer flag is set.
N $7037 If the car crash timer is active, handle the crash animation.
  $7037,$03 #REGa=*#R$7208.
  $703A,$04 Jump to #R$6E6E if the crash timer is active.
N $703E Check which road the car is on.
  $703E,$03 #REGa=*#REGix+#N$01 (car Y position).
  $7041,$02 Is the car on the upper road (#N$90)?
  $7043,$02 Jump to #R$7063 if on the upper road.
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
  $7053,$02,b$01 Keep only bits 0-1.
  $7055,$02 Is the colour #N$01 (blue)?
  $7057,$02 Jump to #R$704E if blue (pick again).
  $7059,$03 Write #REGa to *#REGix+#N$02 (front colour).
  $705C,$03 Write #REGa to *#REGix+#N$06 (rear colour).
  $705F,$01 #REGa=#N$00 (start from the left edge).
  $7060,$03 Jump to #R$6FD3.
N $7063 Car is on the upper road — driving right.
@ $7063 label=Handler_CarType3_DriveRight
  $7063,$03 #REGa=*#REGix+#N$00 (car X position).
  $7066,$01 #REGa+=*#REGhl (add speed).
  $7067,$02 Has the car reached #N$28?
  $7069,$02 Jump to #R$706E if past the boundary.
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
  $70E2,$09 Increment the animation frame at *#REGix+#N$02, wrapping at #N$03.
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
  $70FC,$08 Calculate the speaker output from the counter: add #N$03, rotate
. left, mask with #N$18 and set bit 0 for the border; output to port #N$FE.
  $7106,$04 Increment the ascending counter; jump to #R$7114 if it has not
. reached #N$19.
N $710C Ascending phase complete; switch to descending.
  $710C,$06 Write #N$00 to the ascending counter, set the descending flag to
. #N$FF, and move back.
  $7112,$02 Jump to #R$7144.
@ $7114 label=Store_Ascending_Counter
  $7114,$01 Write the updated ascending counter back.
  $7115,$02 Jump to #R$7144.
N $7117 Descending phase: decrement the pitch and output to the speaker.
@ $7117 label=Frog_Sound_Descending
  $7117,$01 Move back to the ascending counter (used as pitch value).
  $7118,$06 Calculate the speaker output from the counter: rotate left, mask
. with #N$18 and set bit 0 for the border; output to port #N$FE.
  $7120,$03 Decrement the counter; jump to #R$7144 if it is non-zero.
  $7123,$04 Counter has reached zero; clear the descending flag and move back.
  $7127,$02 Jump to #R$7144.
N $7129 No sound playing; randomly trigger a new croak if the frog is idle.
@ $7129 label=Check_Random_Croak
  $7129,$06 Read the R register and mask with #N$3F; jump to #R$7144 if it does
. not equal #N$0F (random chance to croak).
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
  $7161,$04 Set the sprite frame to #R$B01B(#N$28) (frog jumping right).
  $7165,$02 Return if bit 7 of #REGd is not set (facing right).
  $7168,$03 Increment the sprite frame to #R$B03B(#N$29) (frog jumping left).
  $716B,$01 Return.
N $716C Frog is on the platform; set its resting position.
@ $716C label=Frog_On_Platform
  $716C,$03 Set the Y position to the platform Y from #REGb.
  $716F,$02 Jump to #R$7184 if bit 7 of #REGd is set (frog faces left).
  $7173,$03 Set the X position to the platform X from #REGc.
  $7176,$04 Set the sprite frame to #R$B05B(#N$2A) (frog sitting right).
@ $717A label=Random_Tongue_Flick
M $717A,$04 Read the R register and mask.
  $717C,$02,b$01 Keep only bits 0-4.
  $717E,$02 Return if the result is non-zero (random chance to flick tongue).
  $7180,$03 Increment the sprite frame by one (tongue-out variant).
  $7183,$01 Return.
N $7184 Left-facing frog on platform.
@ $7184 label=Frog_Facing_Left
  $7184,$06 Set the X position to platform X plus #N$68.
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

c $7439 Handle Red Bird Movement
@ $7439 label=Handle_Red_Bird
D $7439 Controls the red bird hazard movement and animation. Generates random
. direction changes and movement delays, moves the bird according to its current
. direction, and updates the animation frame. Used by all room handlers.
R $7439 IX Pointer to red bird sprite data
N $7439 Set up the red bird data pointer and check if respawning is needed.
  $7439,$04 Point #REGiy at #R$7508.
@ $743D label=Handle_Red_Bird_Entry
  $743D,$07 Call #R$74A7 if *#R$5FBB (respawn flag) is non-zero to randomise
. the red bird's position.
  $7444,$07 Jump to #R$74B9 if bit 7 of *#REGiy+#N$00 is set (bird is
. spawning/inactive).
N $744B Decrement the movement delay timer; if it hasn't expired, skip ahead
. to move the bird in its current direction.
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
N $7466 Move the red bird in its current direction.
@ $7466 label=Move_Red_Bird
M $7466,$05 Fetch the current direction from *#REGiy+#N$00, mask with #N$07
. and double it to form a jump table index.
  $7469,$02,b$01 Keep only bits 0-2.
  $746C,$03 Write the direction index to *#R$6BC8(#N$6BC9).
  $746F,$03 Point #REGhl at #R$7507 (movement boundary data).
  $7472,$06 Load the red bird's X position into #REGc and Y position into
. #REGb from *#REGix+#N$00 and *#REGix+#N$01.
  $7478,$03 Call #R$6BA0 to move the bird in the current direction.
  $747B,$02 Jump to #R$7450 if the move was invalid (carry set) and pick a new
. random direction.
N $747D Determine the facing direction based on the bird's position relative to
. Percy.
  $747D,$08 Jump to #R$748F if the red bird's X position with Percy's previous
. X position is equal.
  $7485,$06 Set *#REGiy+#N$03 to #N$00 (facing left) if the bird is to the left
. of Percy; jump to #R$748F.
  $748B,$04 Set *#REGiy+#N$03 to #N$04 (facing right) if the bird is to the
. right of Percy.
N $748F Update the red bird's animation frame.
@ $748F label=Update_Red_Bird_Frame
M $748F,$06 Increment the animation counter at *#REGiy+#N$04, wrapping at
. #N$03 to cycle through four frames.
  $7493,$02,b$01 Keep only bits 0-1.
  $7495,$03 Write the result to *#REGiy+#N$03.
  $7498,$05 Calculate the sprite frame ID: add #N$2E (base frame) plus the
. facing offset from *#REGiy+#N$03.
  $749D,$03 Write the sprite frame ID to *#REGix+#N$03.
  $74A0,$04 Set the sprite active flag at *#REGix+#N$02 to #N$01.
  $74A4,$03 Jump to #R$74D6.

c $74A7 Randomise Red Bird Position
@ $74A7 label=Randomise_Red_Bird_Position
D $74A7 Generates a random position for the red bird and validates it. Keeps
. generating new coordinates until a valid position is found, then clears the
. spawning flag.
R $74A7 IX Pointer to red bird sprite data
R $74A7 IY Pointer to red bird state data
@ $74A7 label=Randomise_Position_Loop
  $74A7,$08 Generate a random X coordinate in #REGc and a random Y coordinate
. in #REGb by calling #R$7930 twice.
  $74AF,$05 Call #R$6C0C and jump back to #R$74A7 if the position is invalid.
  $74B4,$04 Clear bit 7 of *#REGiy+#N$00 (mark the red bird as active/no longer
. spawning).
  $74B8,$01 Return.

c $74B9 Animate Stunned Red Bird
@ $74B9 label=Animate_Stunned_RedBird
D $74B9 Animates the stunned red bird sequence. Increments the animation counter
. until it reaches #N$85, cycling through animation frames. Assigns a random
. colour attribute and plays a hit sound each frame.
R $74B9 IX Pointer to red bird sprite data
R $74B9 IY Pointer to red bird state data
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

g $7507 Red Bird Movement Boundary
@ $7507 label=RedBird_MovementBoundary
D $7507 Single byte used as movement boundary data; read at #R$746F.
B $7507,$01

g $7508 Red Bird Data States
@ $7508 label=RedBird_DataStates
B $7508,$0A,$01

c $7512 Handle Cat
@ $7512 label=Handle_Cat
D $7512 Controls the cat hazard that patrols horizontally along a platform. The
. cat bounces between left and right boundaries, animates through walking frames,
. and checks for collision with Percy and Percy's egg. The cat parameters vary
. per room, looked up from state data indexed by the current room number.
R $7512 IX Pointer to the cat sprite data
N $7512 Set up the cat state pointer and movement parameters.
  $7512,$04 Point #REGiy at #R$7AC8.
  $7516,$03 Point #REGhl at #R$7589.
  $7519,$03 Set #REGb=#N$07 (sprite active value) and #REGc=#R$B23B(#N$39)
. (base cat frame).
@ $751C label=Calculate_Hazard_Room_Offset
  $751C,$0B Calculate the state data offset: (*#R$5FC5 - #N$01) * #N$04, and
. add to #REGiy to point at this room's cat state entry.
@ $7527 label=Cat_Entry
  $7527,$07 Call #R$7574 if *#R$5FBB (respawn flag) is non-zero to reset the
. cat position.
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

c $758B Handle Dog
@ $758B label=Handle_Dog
D $758B Controls the dog hazard that patrols horizontally along a platform. Uses
. the same movement logic as the cat but with different state data, boundaries
. and sprite frames.
R $758B IX Pointer to the dog sprite data
  $758B,$04 Point #REGiy at #R$7AE8.
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

c $759A Handle UFO
@ $759A label=Handle_UFO
D $759A Controls the UFO hazard. The UFO wanders randomly around the screen and
. attempts to abduct Percy. When it catches Percy, it teleports him to the UFO's
. position, plays a tractor beam sound effect, then drops him downward. The UFO
. cannot be stunned by Percy's egg, but a hit will cancel the egg.
R $759A IX Pointer to the UFO sprite data
N $759A Check for respawn.
  $759A,$07 Call #R$7628 if *#R$5FBB (respawn flag) is set to reset the UFO.
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
  $75C9,$05 Load the direction from *#REGhl+#N$01, mask with #N$07 and double
. to form a jump table index.
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
  $7771,$02,b$01 Keep only bit 0.
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

c $7893 Handle Walking Paratrooper
@ $7893 label=Handle_Walking_Paratrooper
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
  $78A6,$02 Set the base sprite frame in #REGc to #R$B57B(#N$53) (paratrooper
. walking right).
  $78A8,$0B Fetch the current room from *#R$5FC5, decrement and multiply by
. #N$04 to index into the state data; add offset to #REGiy.
N $78B3 Check if the paratrooper needs to reset after Percy respawns.
  $78B3,$06 Skip to #R$78BD if *#R$5FBB (respawn flag) is unset.
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
. Only rooms #N$05, #N$06 and #N$08 have active paratrooper entries.
N $7928 Room #N($01+#PC-$7928):
B $7928,$01
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
  $794A,$07 Call #R$79C0 to initialise the spider if *#R$5FBB (respawn flag) is
. non-zero.
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

c $79D2 Handle Parachute Descent
@ $79D2 label=Handle_Parachute_Descent
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
  $7A41,$09 Increment the animation counter at *#REGiy+#N$03, wrapping at
. #N$07.
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
. #TABLE(default,centre,centre)
. { =h Offset | =h Description }
. { #N$00 | Stunned flag (bit 7 set = stunned by egg) }
. { #N$01 | Landing counter }
. { #N$02 | Detach flag }
. { #N$03 | Animation counter }
. TABLE#
B $7AC3,$04,$01

g $7AC7 Random Seed
@ $7AC7 label=RandomSeed
B $7AC7,$01

g $7AC8 Cat State Data
@ $7AC8 label=Cat_State_Data
D $7AC8 State variables for the cat hazard.
B $7AC8,$04,$01

g $7AE8 Dog State Data
@ $7AE8 label=Dog_State_Data
D $7AE8 State variables for the dog hazard.
B $7AE8,$04,$01

g $7B04 Table: Parachute Starting X Positions
@ $7B04 label=Table_ParachuteXPosition
D $7B04 Lookup table of starting X positions for the parachute, indexed by
. room number minus one.
B $7B04,$09,$01

g $7B0D Paratrooper Room State Data
@ $7B0D label=Paratrooper_Room_State_Data
D $7B0D Per-room state data for the walking paratrooper, with four bytes per
. room. Indexed by (room number - #N$01) * #N$04. Only rooms #N$05, #N$06 and
. #N$08 have active entries.
. #TABLE(default,centre,centre)
. { =h Offset | =h Description }
. { #N$00 | Stunned flag (bit 7 set = stunned by egg) }
. { #N$01 | Platform Y position }
. { #N$02 | Left boundary X position }
. { #N$03 | Right boundary X position }
. TABLE#
N $7B0D Room #N($01+(#PC-$7B0D)/$04):
B $7B0D,$04
L $7B0D,$04,$08

u $7B2D
B $7B2D,$01

g $7B2E Jump Table: Room Handlers
@ $7B2E label=JumpTable_RoomHandler
W $7B2E,$02 Handler for room #N($01+(#PC-$7B2E)/$02).
L $7B2E,$02,$0B

u $7B44

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

b $9747 Room #N$0D: Level 2
@ $9747 label=Room13_Level2
D $9747 #ROOM$0D
  $97D9,$01 Terminator.

b $97DA Room #N$0E: Level 3
@ $97DA label=Room14_Level3
D $97DA #ROOM$0E
  $986E,$01 Terminator.

b $986F Room #N$0F: Level 4
@ $986F label=Room15_Level4
D $986F #ROOM$0F
  $9903,$01 Terminator.

b $9904 Room #N$10: Level 5
@ $9904 label=Room16_Level5
D $9904 #ROOM$10
  $9997,$01 Terminator.

b $9998

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
  $BBBC,$06 Derive the attribute row from the overlay buffer address: mask the
. low two bits of the high byte, rotate left three times and set bits 6-7 to
. form the base screen buffer address high byte.
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
D $DAD8 Used by #R$7439(the Red Bird), #R$79D2(Parachute).
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

u $DAE4
B $DAE4,$04

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

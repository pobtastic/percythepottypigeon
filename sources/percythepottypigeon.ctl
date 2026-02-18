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
  $5DEA,$04 Write #N$07 to *#REGix+#N$02.
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
N $5E6D If none of the above matched, trigger an error.
@ $5E6D label=PopulateRoomBuffer_Error
  $5E6D,$01 #HTML(Run the ERROR_1 routine:
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0008.html">RST #N$08</a>.)
  $5E6E,$01 Increment #REGb by one.
N $5E6F Command #N$00: no-op. Skip this byte and continue parsing.
@ $5E6F label=Command00_Skip
  $5E6F,$01 Increment the room data pointer by one.
  $5E70,$02 Jump to #R$5E55.

c $5E72 Command #N$04: Switch Tile Set
@ $5E72 label=Command04_SwitchTileSet
D $5E72 Command #N$04: Switch the tile set.
.
. The following byte selects which tile set to use — #N$01 for the default set
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

c $5E92 Command #N$01: Draw Repeated Tile
@ $5E92 label=Command01_RepeatedTile
D $5E92 Command #N$01: Draw a repeated tile. The following byte specifies how
. many times to repeat the current tile.
R $5E92 DE Tile counter
R $5E92 HL The room data pointer
  $5E92,$01 Increment the room data pointer by one.
  $5E93,$01 Fetch the tile byte/ repeat counter.
  $5E94,$01 Increment the room data pointer by one to move past the command
. byte.
  $5E95,$01 Set the repeat counter in #REGb.
@ $5E96 label=RepeatedTile_Loop
  $5E96,$03 Stash the room data pointer, tile counter and repeat counter on the
. stack.
  $5E99,$02 #REGd=#N$01 (flag: advance position only, don't draw).
  $5E9B,$03 Call #R$5F35.
  $5E9E,$03 Restore the repeat counter, tile counter and room data pointer from
. the stack.
  $5EA1,$01 Decrease the tile counter by one.
  $5EA2,$04 Jump to #R$5E6D if the tile counter is zero.
  $5EA6,$02 Decrease the repeat counter by one and loop back to #R$5E96 until
. all repeats are processed.
  $5EA8,$02 Jump to #R$5E55 to continue parsing.

c $5EAA Command #N$02: Tile With Attribute
@ $5EAA label=Command02_TileWithAttribute
D $5EAA Command #N$02: Draw a tile with an explicit attribute.
.
. The following two bytes specify the repeat count and the tile character to
. draw.
R $5EAA DE Tile counter
R $5EAA HL Pointer to the room data
  $5EAA,$01 Increment the room data pointer by one.
  $5EAB,$02 Fetch the repeat counter from *#REGhl and store it in #REGb.
  $5EAD,$01 Increment the room data pointer by one.
  $5EAE,$01 Fetch the tile ID from *#REGhl and store it in #REGa.
  $5EAF,$01 Increment the room data pointer by one to move past the command
. bytes.
@ $5EB0 label=TileWithAttribute_Loop
  $5EB0,$04 Stash the tile character, repeat counter, tile counter and room data
. pointer on the stack.
  $5EB4,$02 #REGd=#N$00 (flag: draw tile to screen buffer).
  $5EB6,$03 Call #R$5F35.
  $5EB9,$04 Restore the room data pointer, tile counter, repeat counter and tile
. character from the stack.
  $5EBD,$01 Switch to shadow #REGaf to preserve the tile character.
  $5EBE,$01 Decrease the tile counter by one.
  $5EBF,$04 Jump back to #R$5E6D if the tile counter is zero.
  $5EC3,$01 Switch back to main #REGaf to retrieve the tile character.
  $5EC4,$02 Decrease the repeat counter by one and loop back to #R$5EB0 until
. all tiles are drawn.
  $5EC6,$02 Jump to #R$5E55 to continue parsing.

c $5EC8 Command #N$08 (Or Higher): Single Tile
@ $5EC8 label=Command08+_SingleTile
D $5EC8 Command #N$08+: draw a single tile. The command byte itself is the tile
. character to draw.
R $5EC8 DE Tile counter
R $5EC8 HL Pointer to the room data
  $5EC8,$01 Fetch the tile ID from *#REGhl and store it in #REGa.
  $5EC9,$01 Increment the room data pointer by one to move past the command
. byte.
  $5ECA,$02 Stash the room data pointer and tile counter on the stack.
  $5ECC,$02 #REGd=#N$00 (flag: draw tile to screen buffer).
  $5ECE,$03 Call #R$5F35.
  $5ED1,$02 Restore the tile counter and room data pointer from the stack.
  $5ED3,$01 Decrease #REGde by one.
  $5ED4,$04 Jump back to #R$5E6D if #REGde is zero.
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
  $5EDC,$01 #REGc=*#REGhl.
N $5EDD Fill #N$02C0 attribute cells at #R$D800 with the base colour.
  $5EDD,$04 #REGix=#R$D800.
  $5EE1,$03 #REGde=#N($02C0,$04,$04).
@ $5EE4 label=PopulateRoomBuffer_FillAttributes_Loop
  $5EE4,$03 Write #REGc to *#REGix+#N$00.
  $5EE7,$02 Increment #REGix by one.
  $5EE9,$01 Decrease #REGde by one.
  $5EEA,$04 Jump back to #R$5EE4 until #REGde is zero.
N $5EEE Now parse the attribute overlay data to apply per-cell changes on top
. of the base fill colour.
@ $5EEE label=PopulateRoomBuffer_AttributeOverlay
  $5EEE,$01 Increment #REGhl by one.
  $5EEF,$03 #REGde=#N($02C1,$04,$04).
  $5EF2,$04 #REGix=#R$D800.
@ $5EF6 label=PopulateRoomBuffer_AttributeOverlay_Loop
  $5EF6,$01 #REGa=*#REGhl.
  $5EF7,$04 Jump to #R$5F12 if #REGa is #N$12 (skip command).
  $5EFB,$04 Jump to #R$5F21 if #REGa is #N$1B (repeat command).
  $5EFF,$04 Jump to #R$5F74 if #REGa is #N$24 (end of attribute data).
N $5F03 Otherwise, write this byte directly as a single attribute value.
  $5F03,$01 #REGc=*#REGhl.
  $5F04,$03 Write #REGc to *#REGix+#N$00.
  $5F07,$01 Decrease #REGde by one.
  $5F08,$02 Increment #REGix by one.
  $5F0A,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F0F,$01 Increment #REGhl by one.
  $5F10,$02 Jump to #R$5EF6.
N $5F12 Attribute overlay command #N$12: skip over a number of attribute cells.
N $5F12 The following byte gives the skip count.
@ $5F12 label=PopulateRoomBuffer_AttributeSkip
  $5F12,$01 Increment #REGhl by one.
  $5F13,$01 #REGb=*#REGhl.
@ $5F14 label=PopulateRoomBuffer_AttributeSkip_Loop
  $5F14,$02 Increment #REGix by one.
  $5F16,$01 Decrease #REGde by one.
  $5F17,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F1C,$02 Decrease the skip counter by one and loop back to #R$5F14 until done.
  $5F1E,$01 Increment #REGhl by one.
  $5F1F,$02 Jump to #R$5EF6.
N $5F21 Attribute overlay command #N$1B: repeat a colour value a number of
. times. The following two bytes give the repeat count and colour value.
@ $5F21 label=PopulateRoomBuffer_AttributeRepeat
  $5F21,$01 Increment #REGhl by one.
  $5F22,$01 #REGb=*#REGhl.
  $5F23,$01 Increment #REGhl by one.
  $5F24,$01 #REGc=*#REGhl.
  $5F25,$01 Increment #REGhl by one.
@ $5F26 label=PopulateRoomBuffer_AttributeRepeat_Loop
  $5F26,$03 Write #REGc to *#REGix+#N$00.
  $5F29,$02 Increment #REGix by one.
  $5F2B,$01 Decrease #REGde by one.
  $5F2C,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F31,$02 Decrease the repeat counter by one and loop back to #R$5F26 until
. done.
  $5F33,$02 Jump to #R$5EF6.

c $5F35 Draw Room Tile
@ $5F35 label=DrawRoomTile
D $5F35 Draws a single tile to the screen buffer at the current drawing
. position stored in *#R$5FB9. The position is advanced after each call. If
. #REGdbit 0 is set, the position is advanced but no tile is drawn (used for
. blank/ skip tiles in command #N$01).
R $5F35 A Tile character to draw
R $5F35 D Bit 0: #N$01=advance position only, #N$00=draw and advance
; Load and advance the current column/row drawing position.
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
  $5F48,$03 Return if bit 0 of #REGd is set.
N $5F4B Calculate the screen buffer address from the column (#REGc) and row
. (#REGb) drawing position. This converts the character cell coordinates into a
. pixel address within the screen buffer at #R$C000.
  $5F4B,$01 #REGl=#REGc.
  $5F4C,$01 #REGa=#REGb.
  $5F4D,$02,b$01 Keep only bits 0-2.
  $5F4F,$01 RRCA.
  $5F50,$01 RRCA.
  $5F51,$01 RRCA.
  $5F52,$01 Merge in the column bits from #REGl.
  $5F53,$01 #REGl=#REGa.
  $5F54,$01 #REGa=#REGb.
  $5F55,$02,b$01 Keep only bits 3-4.
  $5F57,$02,b$01 Set bits 6-7 for the screen buffer base at #R$C000.
  $5F59,$01 #REGh=#REGa.
N $5F5A Look up the tile graphic data from the active tile set and copy all
. #N$08 pixel rows to the screen buffer.
  $5F5A,$01 Stash the screen buffer address on the stack.
  $5F5B,$04 #REGde=*#R$5FC1 (active tile set base address).
  $5F5F,$01 Retrieve the tile character from shadow #REGaf.
  $5F60,$02 #REGa-=#N$08.
  $5F62,$03 Transfer the tile index to #REGhl.
  $5F65,$03 Multiply by #N$08 (bytes per tile).
  $5F68,$01 Add the tile set base address.
  $5F69,$01 Exchange so #REGde=tile graphic data, #REGhl=screen buffer address.
  $5F6A,$01 Restore the screen buffer address from the stack.
  $5F6B,$02 Set a line counter in #REGb of #N$08.
@ $5F6D label=DrawRoomTile_CopyLoop
  $5F6D,$01 #REGa=*#REGde.
  $5F6E,$01 Write #REGa to *#REGhl.
  $5F6F,$01 Advance the tile graphic data pointer.
  $5F70,$01 Move down one pixel row in the screen buffer.
  $5F71,$02 Decrease the line counter by one and loop back to #R$5F6D until all
. #N$08 rows are drawn.
  $5F73,$01 Return.
N $5F74 Attribute overlay command #N$24: end of attribute data. Finalises the
. room setup by resetting game flags and calculating the base address for this
. room's colour attribute lookup table.
@ $5F74 label=PopulateRoomBuffer_EndAttributes
  $5F74,$06 Jump to #R$5F83 if *#R$5FA9 is zero.
  $5F7A,$04 Write #N$00 to *#R$5FA9.
  $5F7E,$01 No operation.
  $5F7F,$01 No operation.
  $5F80,$03 Write #N$00 to *#R$DAE3.
N $5F83 Calculate the base address for this room's colour attributes. Each room
. has #N$20 bytes of attribute data stored sequentially from #R$DE9E, so
. multiply the zero-indexed room number by #N$20 and add the base.
@ $5F83 label=PopulateRoomBuffer_SetAttributeBase
  $5F83,$03 #REGa=*#R$5FC5 (current room number).
  $5F86,$01 Decrease by one to make zero-indexed.
  $5F87,$03 #REGde=#R$DE9E.
  $5F8A,$03 Transfer the room index to #REGhl.
  $5F8D,$05 Multiply by #N$20.
  $5F92,$01 Add the base address.
  $5F93,$03 Write the result to *#R$5FB5.
N $5F96 Wait for the next interrupt frame, then transfer the completed screen
. buffer to the display.
  $5F96,$01 Enable interrupts.
  $5F97,$01 Halt operation (suspend CPU until the next interrupt).
  $5F98,$01 Disable interrupts.
N $5F99 Set up printing the room to the screen buffer.
  $5F99,$02 Set a counter in #REGb for #N$16 rows to print.
  $5F9B,$03 Point #REGhl at #R$C000.
  $5F9E,$03 Jump to #R$6438.

g $5FA1 Header Drawn Flag
@ $5FA1 label=Header_Drawn_Flag
D $5FA1 #N$00=draw HUD via #R$63BB when needed; #N$01=already drawn.
B $5FA1,$01

g $5FA2
B $5FA2,$01

g $5FA3
B $5FA3,$01

g $5FA4
B $5FA4,$01

g $5FA5
B $5FA5,$01

g $5FA6
B $5FA6,$01

g $5FA7 Title Countdown?
@ $5FA7 label=Title_Countdown
D $5FA7 Countdown or init; read at #R$5FE9; when zero call #R$6480. Cleared at #R$655C.
B $5FA7,$01

g $5FA9 Skip Flag?
@ $5FA9 label=Skip_Flag
D $5FA9 When zero at #R$5F74 jump to #R$5F83. Cleared at #R$5F7A.
B $5FA9,$01

g $5FAA
B $5FAA,$01

g $5FAD

g $5FB1 Stored Level Or Phase?
@ $5FB1 label=Stored_Level_Or_Phase
D $5FB1 Copied to #R$5FC5 in some paths; cleared when lives are reset.
B $5FB1,$01

g $5FB2 Aux State?
@ $5FB2 label=Aux_State
D $5FB2 Pointer base; used with #R$68B8.
B $5FB2,$01

g $5FB3 Player Lives
@ $5FB3 label=Lives
D $5FB3 Current lives count. Synced with #R$5FBE for compare/display.
B $5FB3,$01

g $5FB4 Chick Animation States
@ $5FB4 label=ChickAnimationStates
B $5FB4,$01

g $5FB5 Saved Pointer
@ $5FB5 label=Saved_Pointer
D $5FB5 Caller #REGhl stored here; read at #R$664D.
W $5FB5,$02

g $5FB9 Room Drawing Position
@ $5FB9 label=RoomDrawPosition
D $5FB9 The two-byte drawing position used by #R$5F35 to track where the next
. tile should be placed.
.
. The low byte is the column and the high byte is the row.
B $5FB9,$02

g $5FBB Level Flag?
@ $5FBB label=Level_Flag
D $5FBB #N$FF when level active; read in many game loops.
B $5FBB,$01

g $5FBC Pause Flag
@ $5FBC label=Pause_Flag
D $5FBC #N$00=not paused, #N$FF=paused; set at #R$5DF5.
B $5FBC,$01

g $5FBD Sub-State?
@ $5FBD label=Sub_State
D $5FBD Written from #REGa in #R$68D1.
B $5FBD,$01

g $5FBE Lives Backup?
@ $5FBE label=Lives_Backup
D $5FBE Copy of #R$5FB3 for compare/display; synced at #R$654C/#R$69EC.
B $5FBE,$03

g $5FC1 Pointer: Active Tile Set
@ $5FC1 label=Pointer_ActiveTileSet
D $5FC1 Holds the pointer to the currently active tile set.
W $5FC1,$02

g $5FC3 Pointer: Current Room Data
@ $5FC3 label=Pointer_CurrentRoomData
D $5FC3 Points to the data for the current room.
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
N $5FD8 Found a block terminator — check if we've reached the target room.
@ $5FD8 label=FindRoomData_FoundTerminator
  $5FD8,$01 Increment the room counter in #REGe.
  $5FD9,$05 Jump to #R$5FE7 if the room counter has exceeded #N$11 (maximum
. number of rooms — room not found).
  $5FDE,$03 Jump to #R$5FE3 if the room counter matches the target room number.
  $5FE1,$02 Otherwise, jump to #R$5FD1 to keep scanning.
N $5FE3 The target room was found — store the pointer to its data.
@ $5FE3 label=FindRoomData_Found
  $5FE3,$03 Write #REGhl to *#R$5FC3.
  $5FE6,$01 Return.

c $5FE7 Raise Table Error
@ $5FE7 label=Raise_Table_Error
D $5FE7 RST #N$08 then LD A,(BC). Used when table index >= #N$11 in #R$5FC6.

c $5FE9 Handle Pause Input
@ $5FE9 label=Handle_Pause_Input
  $6480,$03 #REGhl=#N$52EC (screen buffer location).
  $6483,$03 #REGa=*#R$5FA7.
  $6486,$03 Jump to #R$648E if #REGa is zero.
  $6489,$01 Decrease #REGa by one.
  $648A,$03 Write #REGa to *#R$5FA7.
  $648D,$01 Return.

  $648E,$07 Jump to #R$64BE if *#REGix+#N$01 is greater than or equal to #N$90.
  $6495,$03 #REGa=*#R$5FAB.
  $6498,$01 Increment #REGa by one.
  $6499,$03 Write #REGa to *#R$5FAB.
  $649C,$03 Return if #REGa is not equal to #N$07.
  $649F,$04 Write #N$00 to *#R$5FAB.
  $64A3,$05 Return if *#R$5FAD is non-zero.
  $64A8,$04 Jump to #R$64B6 if *#REGhl is zero.
  $64AC,$02 Shift *#REGhl left (with carry).
  $64AE,$01 #REGa=*#REGhl.
  $64AF,$01 Increment #REGh by one.
  $64B0,$01 Write #REGa to *#REGhl.
  $64B1,$01 Increment #REGh by one.
  $64B2,$01 Write #REGa to *#REGhl.
  $64B3,$01 Increment #REGh by one.
  $64B4,$01 Write #REGa to *#REGhl.
  $64B5,$01 Return.

  $64B6,$01 Decrease #REGl by one.
  $64B7,$05 Jump to #R$64E1 if #REGl is equal to #N$E0.
  $64BC,$02 Jump to #R$64A8.

  $64BE,$03 #REGa=*#R$5FAB.
  $64C1,$01 Increment #REGa by one.
  $64C2,$03 Write #REGa to *#R$5FAB.
  $64C5,$03 Return if #REGa is less than #N$03.
  $64C8,$04 Write #N$00 to *#R$5FAB.
  $64CC,$03 #REGhl=#N$52E1 (screen buffer location).
  $64CF,$05 Jump to #R$64DA if *#REGhl is equal to #N$FF.
  $64D4,$02 Shift *#REGhl right.
  $64D6,$02 Set bit 7 of *#REGhl.
  $64D8,$02 Jump to #R$64AE.

  $64DA,$01 Increment #REGl by one.
  $64DB,$04 Return if #REGl is equal to #N$ED.
  $64DF,$02 Jump to #R$64CF.
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
  $6535,$02 #REGa=#N$30.
  $6537,$03 #REGhl=#N$50F0 (screen buffer location).
  $653A,$03 Call #R$6581.

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

c $6480 Handle Title Screen
@ $6480 label=Handle_Title_Screen
D $6480 #R$5FA7 countdown or init; IX+1 compare; #R$5FAB counter. Called from
. #R$5FE9 when Z.

c $653D Initialise Lives
@ $653D label=Initialise_Lives
D $653D Set #R$5FB3 and #R$5FBE to #N$33, clear #R$5FB1, call #R$68F7 then
. jump to #R$659B (game over / title).
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
  $656A,$02 #REGb=#N$60.
  $656C,$03 Call #R$64CC.
  $656F,$02 Decrease counter by one and loop back to #R$656C until counter is zero.
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
N $67EF Handle decimal carry — subtract #N$0A from the current digit and
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
N $67FA This digit also overflowed — wrap it to #N$00 and continue propagating.
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

c $6832 Update State Counters?
@ $6832 label=Update_State_Counters
  $6832,$03 #REGhl=#R$689F.
  $6835,$04 #REGb=*#R$5FC5.
  $6839,$01 #REGa=*#REGhl.
  $683A,$03 Return if #REGa is equal to #N$FF.
  $683D,$04 Call #R$6847 if #REGa is equal to #REGb.
  $6841,$04 Increment #REGhl by four.
  $6845,$02 Jump to #R$6839.

  $6847,$01 Stash #REGhl on the stack.
  $6848,$01 Increment #REGhl by one.
  $6849,$01 Increment *#REGhl by one.
  $684A,$01 #REGa=*#REGhl.
  $684B,$04 Jump to #R$6851 if #REGa is not equal to #N$03.
  $684F,$02 Write #N$00 to *#REGhl.
  $6851,$01 Stash #REGaf on the stack.
  $6852,$03 #REGa=*#R$DAC0.
  $6855,$03 RRCA.
  $6858,$02,b$01 Keep only bits 0-4.
  $685A,$01 #REGc=#REGa.
  $685B,$01 Increment #REGhl by one.
  $685C,$01 #REGa=*#REGhl.
  $685D,$02,b$01 Keep only bits 0-4.
  $685F,$03 Jump to #R$6867 if #REGa is greater than or equal to #REGc.
  $6862,$01 Restore #REGaf from the stack.
  $6863,$02 #REGa+=#N$03.
  $6865,$02 Jump to #R$6868.
  $6867,$01 Restore #REGaf from the stack.
  $6868,$03 #REGde=#R$AD5B.
  $686B,$02 #REGh=#N$00.
  $686D,$01 #REGl=#REGa.
  $686E,$05 Multiply #REGhl by #N$20.
  $6873,$01 #REGhl+=#REGde.
  $6874,$01 Exchange the #REGde and #REGhl registers.
  $6875,$01 Restore #REGhl from the stack.
  $6876,$01 Stash #REGhl on the stack.
  $6877,$02 Increment #REGhl by two.
  $6879,$01 #REGc=*#REGhl.
  $687A,$01 Increment #REGhl by one.
  $687B,$01 #REGb=*#REGhl.
  $687C,$02 Copy #REGbc into #REGhl on the stack.
  $687E,$02 Stash #REGhl and #REGhl on the stack.
  $6880,$03 Call #R$6692.
  $6883,$01 Restore #REGhl from the stack.
  $6884,$04 #REGhl+=#N($0020,$04,$04).
  $6888,$03 Call #R$6692.
  $688B,$01 Restore #REGhl from the stack.
  $688C,$01 Increment #REGl by one.
  $688D,$01 Stash #REGhl on the stack.
  $688E,$03 Call #R$6692.
  $6891,$01 Restore #REGhl from the stack.
  $6892,$04 #REGhl+=#N($0020,$04,$04).
  $6896,$03 Call #R$6692.
  $6899,$01 Restore #REGhl from the stack.
  $689A,$04 #REGb=*#R$5FC5.
  $689E,$01 Return.

b $689F
  $689F,$04
L $689F,$04,$06
  $68B7,$01 Terminator.

c $68B8 Handle Life Lost
@ $68B8 label=Handle_Life_Lost
  $68B8,$04 Decrease *#R$5FB2 by one.
  $68BC,$01 Return if *#REGhl is not equal to #N$00.
  $68BD,$02 Stash #REGix on the stack.
  $68BF,$02 #REGb=#N$28.
  $68C1,$03 #REGhl=#N$0320.
  $68C4,$03 #REGde=#N($0008,$04,$04).
  $68C7,$03 Call #R$693B.
  $68CA,$02 Decrease counter by one and loop back to #R$68C7 until counter is zero.
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
  $68E8,$03 #REGhl=#R$FBF9.
  $68EB,$03 Call #R$FAC4.
  $68EE,$01 Disable interrupts.
  $68EF,$03 Call #R$6562.
  $68F2,$04 Write #N$00 to *#R$5FA5.
  $68F6,$01 Return.

c $68F7 Update Lives Display
@ $68F7 label=Update_Lives_Display
D $68F7 Read #R$5FB1 and #R$5FB3; increment #R$5FB1; when #R$5FB1=#N$04 give
. extra life and print at #N$50F0.
  $68F7,$03 #REGa=*#R$5FB1.
  $68FA,$03 #REGhl=#R$5FB3.
  $68FD,$04 Jump to #R$6911 if #REGa is equal to #N$05.
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

c $693B Flash Border Step
@ $693B label=Flash_Border_Step
D $693B Push BC/HL/DE; set border from R; write #R$5FB4 and BORDCR; BEEP.
. Used in loop from #R$68B8.
  $693B,$03 Stash #REGbc, #REGhl and #REGde on the stack.
  $693E,$02 #REGa=#N$19.
  $6940,$03 Call #R$67B2.
  $6943,$02 #REGa=the contents of the Memory Refresh Register.
  $6945,$01 #REGl=#REGa.
  $6946,$02 #REGh=#N$00.
  $6948,$01 #REGa=*#REGhl.
  $6949,$03 Write #REGa to *#R$5FB4.
  $694C,$02,b$01 Keep only bits 3-5.
  $694E,$03 #HTML(Write #REGa to *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C48.html">BORDCR</a>.)
  $6951,$02 Restore #REGde and #REGhl from the stack.
  $6953,$02 Stash #REGhl and #REGde on the stack.
  $6955,$03 #HTML(Call <a href="https://skoolkid.github.io/rom/asm/03B5.html">BEEP</a>.)
  $6958,$02 Restore #REGde and #REGhl from the stack.
  $695A,$03 #REGbc=#N($000F,$04,$04).
  $695D,$02 #REGhl-=#REGde (with carry).
  $695F,$01 Restore #REGbc from the stack.
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
  $69DE,$07 Call #R$64BE if *#R$5FAD is non-zero.
  $69E5,$06 Write *#R$5FB3 to *#R$6CC3.
  $69EB,$04 Write #N$00 to *#R$5FBE.
  $69EF,$01 Increment #REGa by one.
  $69F0,$02 Set border to the colour held by #REGa.
  $69F2,$04 Restore #REGiy and #REGix from the stack.
  $69F6,$01 Return.

c $69F7 Load Level Data
@ $69F7 label=Load_Level_Data

c $6AF6

c $6C39

c $6C53

c $6C85

c $6CA5

b $6CB2
  $6CC3

c $6CDD

c $6DAB Dispatch Game State
@ $6DAB label=Dispatch_Game_State

c $6E2F

c $6E5D

b $71E9

c $720F Room Handler Dispatch
@ $720F label=RoomHandlerDispatch
N $720F This is a self-modified instruction — the immediate value is patched at
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
N $7250 Set up the second object — only processed during phase #N$03.
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
N $730F First object — initialised during phases #N$01, #N$03 and #N$04.
  $730F,$04 #REGix=#R$DAC8.
  $7313,$01 Stash the phase counter on the stack.
  $7314,$0F Call #R$794A if the phase counter is #N$01#RAW(,) #N$03 or #N$04.
  $7323,$01 Restore the phase counter from the stack.
N $7324 Second object — return early if still in phase #N$01.
  $7324,$04 #REGix=#R$DACC.
  $7328,$02 Return if the phase counter is #N$01.
  $732B,$01 Stash the phase counter on the stack.
  $732C,$03 Call #R$7512.
  $732F,$01 Restore the phase counter from the stack.
N $7330 Third object — initialised during phase #N$02, then handled every phase
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
N $7344 Fourth object — initialised during phase #N$04.
  $7344,$04 #REGix=#R$DAD4.
  $7348,$01 Stash the phase counter on the stack.
  $7349,$04 #REGiy=#R$750D.
  $734D,$05 Call #R$743D if the phase counter is #N$04.
  $7352,$01 Restore the phase counter from the stack.
  $7353,$02 Return if the phase counter is #N$04.
  $7355,$01 Return.
N $7356 Fifth object — active from phase #N$05 onwards.
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

g $7679
B $7679,$07

c $7680

c $7893

g $7924

c $7930

c $794A Handler: Spider
@ $794A label=Handler_Spider
R $794A IX Pointer to the spider object state
  $794A,$07 Call #R$79C0 if *#R$5FBB is non-zero.
  $7951,$03 #REGhl=#R$D90A.
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
  $A763,$08 #UDG(#PC)
L $A763,$08,$02

b $A773
  $A773,$08 #UDG(#PC)
L $A773,$08,$12

b $AB3B
  $AB3B,$08 #UDG(#PC)
L $AB3B,$08,$A0

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

c $BC52

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

g $C000 Room Buffer
@ $C000 label=RoomBuffer
B $C000,$1800,$20

c $C1DD Game Entry Point
@ $C1DD label=GameEntryPoint
  $C1DD,$0B Copy #N$0176 bytes of data from #N$053F to #R$C000(#N$C001).
  $C1E8,$06 #HTML(Write #R$FF58 to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C7B.html">UDG</a>.)
  $C1EE,$06 #HTML(Write <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/3D00.html">#N$3C00</a>
. (CHARSET-#N$100) to 
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C36.html">CHARS</a>.)
  $C1F4,$0C Blank #N$1770 bytes of data starting from #R$E000.
N $C200 Set the lower screen to the default #N$02 lines.
  $C200,$05 #HTML(Write #N$02 to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C6B.html">DF_SZ</a>.)
  $C205,$03 Jump to #R$5DC0.

g $D90A

g $DAC0 Percy States
@ $DAC0 label=Percy_X_Position
B $DAC0,$01 Percy X position.
@ $DAC1 label=Percy_Y_Position
B $DAC1,$01 Percy Y position.
@ $DAC2 label=Percy_Colour
B $DAC2,$01 Percy INK colour.
@ $DAC3 label=Percy_Frame_ID
B $DAC3,$01 Percy frame ID.

g $DAC7

g $DAC8 Spider States
@ $DAC8 label=Spider_X_Position
B $DAC8,$01 Spider X position.
@ $DAC9 label=Spider_Y_Position
B $DAC9,$01 Spider Y position.
@ $DACA label=Spider_Colour
B $DACA,$01 Spider INK colour.
@ $DACB label=Spider_Frame_ID
B $DACB,$01 Spider frame ID.

g $DACC

g $DAD0

g $DAD4

g $DAD8

g $DADC

g $DAE3

g $DB00

b $DE9E

g $E000 Sprite Buffer
@ $E000 label=SpriteBuffer
B $E000,$1800,$20

b $F800

g $FAC0
B $FAC0,$01

c $FAC1
N $FAC1 #HTML(#AUDIO(next-level.wav)(#INCLUDE(NextLevel)))
  $FAC1,$03 #REGhl=#R$FAF9.
  $FAC4,$01 No operation.
  $FAC5,$01 #REGa=*#REGhl.
  $FAC6,$03 Return if #REGa is equal to #N$FF.
  $FAC9,$03 Jump to #R$FAEA if #REGa is zero.
  $FACC,$03 Set border to #INK$00.
  $FACF,$02 #REGd=*#REGhl.
  $FAD1,$01 Increment #REGhl by one.
  $FAD2,$01 #REGc=*#REGhl.
  $FAD3,$02 Send to the speaker.
  $FAD5,$01 Decrease #REGd by one.
  $FAD6,$02 Jump to #R$FADB if #REGd is not equal to #REGa.
  $FAD8,$01 #REGd=#REGe.
  $FAD9,$02,b$01 Flip bits 3-4.
  $FADB,$02 Decrease counter by one and loop back to #R$FAD3 until counter is zero.
  $FADD,$01 Decrease #REGc by one.
  $FADE,$02 Jump to #R$FAD3 if #REGc is not equal to #REGa.
  $FAE0,$01 Increment #REGhl by one.
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
  $FAEA,$01 Increment #REGhl by one.
  $FAEB,$01 #REGc=*#REGhl.
  $FAEC,$01 No operation.
  $FAED,$01 No operation.
  $FAEE,$01 No operation.
  $FAEF,$01 No operation.
  $FAF0,$01 No operation.
  $FAF1,$02 Decrease counter by one and loop back to #R$FAED until counter is zero.
  $FAF3,$01 Decrease #REGc by one.
  $FAF4,$02 Jump back to #R$FAEC until #REGc is zero.
  $FAF6,$01 Increment #REGhl by one.
  $FAF7,$02 Jump to #R$FAC5.

b $FAF9 Audio: Next Level Jingle
@ $FAF9 label=Audio_NextLevelJingle
@ $FBF9 label=Audio_LoseLifeJingle
  $FAF9,$0120
  $FC19,$02 Terminator.

c $FC1B Print Author Byline
@ $FC1B label=Print_AuthorByline
D $FC1B Prints the Author Byline messaging to the screen buffer.
  $FC1B,$04 Check if *#R$5FBC is non-zero.
  $FC1F,$02 Jump to #R$FC52 if *#R$5FBC is non-zero.
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
N $FC66 All digits matched — scores are equal, so no update needed.
  $FC66,$02 Jump to #R$FC73.
N $FC68 New high score — copy the current score over the stored high score.
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

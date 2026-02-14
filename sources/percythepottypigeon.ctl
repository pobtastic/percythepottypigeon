; Copyright Gremlin Graphics Software Ltd 1984, 2025 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Percy the Potty Pigeon Loading Screen. } { #SCR$02(loading) } UDGTABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

i $5B00

g $5BFE Stack

c $5DC0 Game Initialise
@ $5DC0 label=Game_Initialise
  $5DC0,$01 Disable interrupts.
  $5DC1,$01 #REGa=#N$00.
  $5DC2,$03 #REGsp=#R$5BFE.
  $5DC5,$06 Write #N$00 to; #LIST
. { *#R$5FBC }
. { *#R$5FAA }
. LIST#
  $5DCB,$02 Set border to: #INK$00.
N $5DCD #HTML(Open channel #N$02 (upper screen) via <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>.)
  $5DCD,$03 #HTML(Call <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/1601.html">CHAN_OPEN</a>.)
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

c $5E24 Populate Level Buffer
@ $5E24 label=PopulateLevelBuffer
  $5E24,$03 #REGa=*#R$5FC5.
  $5E27,$06 Write #R$83A9 to *#R$5FC3.
  $5E2D,$06 Write #R$9BAA to *#R$5FC1.
  $5E33,$04 Call #R$5FC6 if #REGa is not equal to #N$00.
  $5E37,$0D Clear #N$17FF bytes from #R$C000 onwards.
  $5E44,$05 Write #N$FF to *#R$5FBB.
  $5E49,$06 Write #N($00FF,$04,$04) to *#R$5FB9.
  $5E4F,$03 #REGde=#N$02C1.
  $5E52,$03 #REGhl=*#R$5FC3.
  $5E55,$01 #REGa=*#REGhl.
  $5E56,$03 Jump to #R$5E6F if #REGa is zero.
  $5E59,$04 Jump to #R$5E92 if #REGa is equal to #N$01.
  $5E5D,$04 Jump to #R$5EAA if #REGa is equal to #N$02.
  $5E61,$04 Jump to #R$5EDB if #REGa is equal to #N$03.
  $5E65,$04 Jump to #R$5E72 if #REGa is equal to #N$04.
  $5E69,$04 Jump to #R$5EC8 if #REGa is greater than or equal to #N$08.
  $5E6D,$01 #HTML(Run the ERROR_1 routine:
. <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/0008.html">RST #N$08</a>.)
  $5E6E,$01 Increment #REGb by one.
  $5E6F,$01 Increment #REGhl by one.
  $5E70,$02 Jump to #R$5E55.

  $5E72,$01 Increment #REGhl by one.
  $5E73,$01 #REGa=*#REGhl.
  $5E74,$01 Increment #REGhl by one.
  $5E75,$04 Jump to #R$5E88 if #REGa is equal to #N$01.
  $5E79,$05 Jump to #R$5FE7 if #REGa is not equal to #N$02.
  $5E7E,$01 Stash #REGhl on the stack.
  $5E7F,$06 Write #R$A36A to *#R$5FC1.
  $5E85,$01 Restore #REGhl from the stack.
  $5E86,$02 Jump to #R$5E55.

  $5E88,$01 Stash #REGhl on the stack.
  $5E89,$06 Write #R$9BAA to *#R$5FC1.
  $5E8F,$01 Restore #REGhl from the stack.
  $5E90,$02 Jump to #R$5E55.

  $5E92,$01 Increment #REGhl by one.
  $5E93,$01 #REGa=*#REGhl.
  $5E94,$01 Increment #REGhl by one.
  $5E95,$01 #REGb=#REGa.
  $5E96,$03 Stash #REGhl, #REGde and #REGbc on the stack.
  $5E99,$02 #REGd=#N$01.
  $5E9B,$03 Call #R$5F35.
  $5E9E,$03 Restore #REGbc, #REGde and #REGhl from the stack.
  $5EA1,$01 Decrease #REGde by one.
  $5EA2,$04 Jump back to #R$5E6D if #REGde is zero.
  $5EA6,$02 Decrease counter by one and loop back to #R$5E96 until counter is zero.
  $5EA8,$02 Jump to #R$5E55.

  $5EAA,$01 Increment #REGhl by one.
  $5EAB,$01 #REGa=*#REGhl.
  $5EAC,$01 #REGb=#REGa.
  $5EAD,$01 Increment #REGhl by one.
  $5EAE,$01 #REGa=*#REGhl.
  $5EAF,$01 Increment #REGhl by one.
  $5EB0,$04 Stash #REGaf, #REGbc, #REGde and #REGhl on the stack.
  $5EB4,$02 #REGd=#N$00.
  $5EB6,$03 Call #R$5F35.
  $5EB9,$04 Restore #REGhl, #REGde, #REGbc and #REGaf from the stack.
  $5EBD,$01 Exchange the #REGaf register with the shadow #REGaf register.
  $5EBE,$01 Decrease #REGde by one.
  $5EBF,$04 Jump back to #R$5E6D if #REGde is zero.
  $5EC3,$01 Exchange the shadow #REGaf register with the #REGaf register.
  $5EC4,$02 Decrease counter by one and loop back to #R$5EB0 until counter is zero.
  $5EC6,$02 Jump to #R$5E55.

  $5EC8,$01 #REGa=*#REGhl.
  $5EC9,$01 Increment #REGhl by one.
  $5ECA,$02 Stash #REGhl and #REGde on the stack.
  $5ECC,$02 #REGd=#N$00.
  $5ECE,$03 Call #R$5F35.
  $5ED1,$02 Restore #REGde and #REGhl from the stack.
  $5ED3,$01 Decrease #REGde by one.
  $5ED4,$04 Jump back to #R$5E6D if #REGde is zero.
  $5ED8,$03 Jump to #R$5E55.

  $5EDB,$01 Increment #REGhl by one.
  $5EDC,$01 #REGc=*#REGhl.
  $5EDD,$04 #REGix=#R$D800.
  $5EE1,$03 #REGde=#N($02C0,$04,$04).
  $5EE4,$03 Write #REGc to *#REGix+#N$00.
  $5EE7,$02 Increment #REGix by one.
  $5EE9,$01 Decrease #REGde by one.
  $5EEA,$04 Jump back to #R$5EE4 until #REGde is zero.
  $5EEE,$01 Increment #REGhl by one.
  $5EEF,$03 #REGde=#N($02C1,$04,$04).
  $5EF2,$04 #REGix=#R$D800.
  $5EF6,$01 #REGa=*#REGhl.
  $5EF7,$04 Jump to #R$5F12 if #REGa is equal to #N$12.
  $5EFB,$04 Jump to #R$5F21 if #REGa is equal to #N$1B.
  $5EFF,$04 Jump to #R$5F74 if #REGa is equal to #N$24.
  $5F03,$01 #REGc=*#REGhl.
  $5F04,$03 Write #REGc to *#REGix+#N$00.
  $5F07,$01 Decrease #REGde by one.
  $5F08,$02 Increment #REGix by one.
  $5F0A,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F0F,$01 Increment #REGhl by one.
  $5F10,$02 Jump to #R$5EF6.

  $5F12,$01 Increment #REGhl by one.
  $5F13,$01 #REGb=*#REGhl.
  $5F14,$02 Increment #REGix by one.
  $5F16,$01 Decrease #REGde by one.
  $5F17,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F1C,$02 Decrease counter by one and loop back to #R$5F14 until counter is zero.
  $5F1E,$01 Increment #REGhl by one.
  $5F1F,$02 Jump to #R$5EF6.

  $5F21,$01 Increment #REGhl by one.
  $5F22,$01 #REGb=*#REGhl.
  $5F23,$01 Increment #REGhl by one.
  $5F24,$01 #REGc=*#REGhl.
  $5F25,$01 Increment #REGhl by one.
  $5F26,$03 Write #REGc to *#REGix+#N$00.
  $5F29,$02 Increment #REGix by one.
  $5F2B,$01 Decrease #REGde by one.
  $5F2C,$05 Jump back to #R$5E6D if #REGde is zero.
  $5F31,$02 Decrease counter by one and loop back to #R$5F26 until counter is zero.
  $5F33,$02 Jump to #R$5EF6.

  $5F35,$04 #REGbc=*#R$5FB9.
  $5F39,$01 Increment #REGc by one.
  $5F3A,$01 Exchange the #REGaf register with the shadow #REGaf register.
  $5F3B,$04 Jump to #R$5F41 if bit 5 of #REGc is set.
  $5F3F,$02 Jump to #R$5F44.

  $5F41,$01 Increment #REGb by one.
  $5F42,$02 #REGc=#N$00.
  $5F44,$04 Write #REGbc to *#R$5FB9.
  $5F48,$03 Return if bit 0 of #REGd is set.
  $5F4B,$01 #REGl=#REGc.
  $5F4C,$01 #REGa=#REGb.
  $5F4D,$02,b$01 Keep only bits 0-2.
  $5F4F,$01 RRCA.
  $5F50,$01 RRCA.
  $5F51,$01 RRCA.
  $5F52,$01 Set the bits from #REGl.
  $5F53,$01 #REGl=#REGa.
  $5F54,$01 #REGa=#REGb.
  $5F55,$02,b$01 Keep only bits 3-4.
  $5F57,$02,b$01 Set bits 6-7.
  $5F59,$01 #REGh=#REGa.
  $5F5A,$01 Stash #REGhl on the stack.
  $5F5B,$04 #REGde=*#R$5FC1.
  $5F5F,$01 Exchange the #REGaf register with the shadow #REGaf register.
  $5F60,$02 #REGa-=#N$08.
  $5F62,$01 #REGl=#REGa.
  $5F63,$02 #REGh=#N$00.
  $5F65,$01 #REGhl+=#REGhl.
  $5F66,$01 #REGhl+=#REGhl.
  $5F67,$01 #REGhl+=#REGhl.
  $5F68,$01 #REGhl+=#REGde.
  $5F69,$01 Exchange the #REGde and #REGhl registers.
  $5F6A,$01 Restore #REGhl from the stack.
  $5F6B,$02 #REGb=#N$08.
  $5F6D,$01 #REGa=*#REGde.
  $5F6E,$01 Write #REGa to *#REGhl.
  $5F6F,$01 Increment #REGde by one.
  $5F70,$01 Increment #REGh by one.
  $5F71,$02 Decrease counter by one and loop back to #R$5F6D until counter is zero.
  $5F73,$01 Return.

  $5F74,$06 Jump to #R$5F83 if *#R$5FA9 is zero.
  $5F7A,$04 Write #N$00 to *#R$5FA9.
  $5F7E,$01 No operation.
  $5F7F,$01 No operation.
  $5F80,$03 Write #N$00 to *#R$DAE3.
  $5F83,$03 #REGa=*#R$5FC5.
  $5F86,$01 Decrease #REGa by one.
  $5F87,$03 #REGde=#R$DE9E.
  $5F8A,$01 #REGl=#REGa.
  $5F8B,$02 #REGh=#N$00.
  $5F8D,$01 #REGhl+=#REGhl.
  $5F8E,$01 #REGhl+=#REGhl.
  $5F8F,$01 #REGhl+=#REGhl.
  $5F90,$01 #REGhl+=#REGhl.
  $5F91,$01 #REGhl+=#REGhl.
  $5F92,$01 #REGhl+=#REGde.
  $5F93,$03 Write #REGhl to *#R$5FB5.
  $5F96,$01 Enable interrupts.
  $5F97,$01 Halt operation (suspend CPU until the next interrupt).
  $5F98,$01 Disable interrupts.
  $5F99,$02 #REGb=#N$16.
  $5F9B,$03 #REGhl=#R$C000.
  $5F9E,$03 Jump to #R$6438.

g $5FA1
B $5FA1,$0A,$01

g $5FB1
B $5FB1,$01

g $5FB2
B $5FB2,$01

g $5FB3 Player Lives
@ $5FB3 label=Lives
B $5FB3,$01

g $5FB5
W $5FB5,$02

g $5FB9

g $5FBB

g $5FBC

g $5FBD

g $5FBE

g $5FC1
W $5FC1,$02

g $5FC3
W $5FC3,$02

g $5FC5

c $5FC6
  $5FC6,$04 #REGd=*#R$5FC5.
  $5FCA,$02 #REGe=#N$01.
  $5FCC,$02 Return if *#R$5FC5 is equal to #N$01.
  $5FCE,$03 #REGhl=#R$83AA.
  $5FD1,$01 #REGa=*#REGhl.
  $5FD2,$01 Increment #REGhl by one.
  $5FD3,$03 Jump to #R$5FD8 if #REGa is zero.
  $5FD6,$02 Jump to #R$5FD1.

  $5FD8,$01 Increment #REGe by one.
  $5FD9,$05 Jump to #R$5FE7 if #REGe is greater than or equal to #N$11.
  $5FDE,$03 Jump to #R$5FE3 if #REGa is equal to #REGd.
  $5FE1,$02 Jump to #R$5FD1.

  $5FE3,$03 Write #REGhl to *#R$5FC3.
  $5FE6,$01 Return.

c $5FE7

c $5FE9

c $63BB
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

c $6438
  $6438,$02 Stash #REGbc and #REGhl on the stack.
  $643A,$03 Call #R$6456.
  $643D,$02 Restore #REGhl and #REGbc from the stack.
  $643F,$04 #REGl+=#N$20.
  $6443,$03 Jump to #R$644A if #REGa is non-zero.
  $6446,$04 #REGh+=#N$08.
  $644A,$02 Decrease counter by one and loop back to #R$6438 until counter is zero.
  $644C,$07 Call #R$63BB if *#R$5FA1 is zero.
  $6453,$03 Jump to #R$63CB.

c $6456 Draw Level Row
@ $6456 label=DrawLevelRow
  $6456,$02 #REGb=#N$08.
  $6458,$03 Stash #REGhl, #REGbc and #REGhl on the stack.
  $645B,$01 #REGd=#REGh.
  $645C,$01 #REGe=#REGl.
  $645D,$02 Reset bit 7 of #REGd.
  $645F,$03 #REGbc=#N($0020,$04,$04).
  $6462,$02 LDIR.
  $6464,$02 Restore #REGhl and #REGbc from the stack.
  $6466,$01 Increment #REGh by one.
  $6467,$02 Decrease counter by one and loop back to #R$6459 until counter is zero.
  $6469,$01 Restore #REGhl from the stack.
  $646A,$01 #REGa=#REGh.
  $646B,$03 RRCA.
  $646E,$02,b$01 Keep only bits 0-1.
  $6470,$02,b$01 Set bits 3-4, 6-7.
  $6472,$01 #REGh=#REGa.
  $6473,$01 #REGe=#REGl.
  $6474,$01 #REGa=#REGh.
  $6475,$02,b$01 Keep only bits 0-1.
  $6477,$02,b$01 Set bits 3-4, 6.
  $6479,$01 #REGd=#REGa.
  $647A,$03 #REGbc=#N($0020,$04,$04).
  $647D,$02 LDIR.
  $647F,$01 Return.

c $6480

c $653D
  $654A,$08 Write #N$33 to; #LIST
. { *#R$5FBE }
. { *#R$5FB3 }
. LIST#
  $6552,$04 Write #N$00 to *#R$5FB1.
  $6556,$03 Call #R$68F7.
  $6559,$03 Jump to #R$659B.

c $655C
  $655C,$03 #REGhl=#N$50F0 (screen buffer location).
  $655F,$03 Call #R$6581.
  $6562,$05 Write #N$06 to *#R$5FC5.
  $6567,$03 Call #R$5E24.
  $656A,$02 #REGb=#N$60.
  $656C,$03 Call #R$64CC.
  $656F,$02 Decrease counter by one and loop back to #R$656C until counter is zero.
  $6571,$05 Write #N$38 to *#R$DAC0.
  $6576,$03 Write #N$9E to *#R$DAC1.
  $6579,$03 Write #N$07 to *#R$DAC2.
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

c $659B
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
  $65D6,$03 Jump to #R$65D4 if #REGde is less than #N$3D.
  $65D9,$04 Set the border to #INK$01.
  $65DD,$02 #REGb=#N$0A.
  $65DF,$03 #REGhl=#R$5FA1.
  $65E2,$02 Write #N$00 to *#REGhl.
  $65E4,$01 Increment #REGhl by one.
  $65E5,$02 Decrease counter by one and loop back to #R$65E2 until counter is zero.
  $65E7,$03 Jump to #R$6562.

c $65EA

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

c $662B

c $6832
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
  $68B7,$01 Terminator.

c $68B8

c $68F7
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

c $693B
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

c $6992
  $6992,$03 Call #R$662B.
  $6995,$03 Call #R$6832.
  $6998,$08 Call #R$65EA if *#R$5FC5 is equal to #N$06.
  $69A0,$03 Call #R$69A7.
  $69A3,$03 Call #R$BB1C.
  $69A6,$01 Return.

c $69A7

c $69F7

c $6DAB

c $720F

c $83A9

c $83AA

c $BB1C

c $C001

c $C1DD Game Entry Point
@ $C1DD label=GameEntryPoint
  $C1DD,$0B Copy #N$0176 bytes of data from #N$053F to #R$C001.
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

c $FC1B

  $FC3C,$01 Return.

c $FC3D

b $FF58 Graphics: Custom UDGs
@ $FF58 label=Graphics_CustomUDGs
  $FF58,$08 #N((#PC-$FF58)/$08): #UDG(#PC)
L $FF58,$08,$15

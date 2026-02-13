; Copyright Gremlin Graphics Software Ltd 1984, 2025 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $4000 @org=$4000
b $4000 Loading Screen
D $4000 #UDGTABLE { =h Percy the Potty Pigeon Loading Screen. } { #SCR$02(loading) } UDGTABLE#
@ $4000 label=Loading
  $4000,$1800,$20 Pixels.
  $5800,$0300,$20 Attributes.

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
N $5DFA Main title screen input loop.
@ $5DFA label=TitleScreen_InputLoop
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

c $5E24

g $5FAA

g $5FB1
B $5FB1,$01

g $5FB2
B $5FB2,$01

g $5FB3 Player Lives
@ $5FB3 label=Lives
B $5FB3,$01

g $5FBB

g $5FBC

g $5FBD

g $5FBE

g $5FC5

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

c $6966 Title Screen Border Effect
@ $6966 label=TitleScreen_BorderEffect
D $6966 Displays a rainbow-like cycling colour border while waiting for the
. player to press "S" to start the game.
  $6966,$01 Enable interrupts.
  $6967,$05 Pause for #N$14 frames to give the player a moment before the
. effect begins.
@ $6969 label=TitleScreen_BorderEffect_ShortLoop
@ $696C label=TitleScreen_BorderEffect_ColourCycle
  $696C,$02 Set a frame counter in #REGb of #N$0E frames.
  $696E,$01 Halt operation (suspend CPU until the next interrupt).
N $696F Derive a border colour (#N$00-#N$07) from the current frame loop
. counter.
@ $696F label=TitleScreen_BorderEffect_ColourLoop
  $696F,$01 Copy the frame counter value into #REGa.
  $6970,$02,b$01 Keep only bits 0-2.
M $696F,$03 Load #REGa with bits 0-2 of the current frame counter value. This
. limits the value to be between #N$00-#N$07 (i.e. the colour palette).
  $6972,$01 Stash the frame counter on the stack.
@ $6973 label=TitleScreen_Border_PauseLoop_01
  $6973,$02 Decrease the frame counter by one and loop until the counter is
. zero.
  $6975,$01 Restore the frame counter from the stack.
  $6976,$01 But keep a copy of it back on the stack.
  $6977,$02 Set #REGb to #N$00 which increases the size of the counter.
@ $6979 label=TitleScreen_Border_PauseLoop_02
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

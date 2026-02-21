; Copyright 1984 Gremlin Graphics Software Ltd, 2026 Urbanscan, 2026 ArcadeGeek LTD.
; NOTE: Disassembly is Work-In-Progress.
; Label naming is loosely based on Action_ActionName_SubAction e.g. Print_HighScore_Loop.

> $C1DD @start
> $C1DD @org
> $C1DD @remote=main:$C1DD
c $C1DD Game Entry Point
@ $C1DD label=GameEntryPoint
  $C1DD,$0B Copy #N$0176 bytes of data from #N$053F to #R$C000@main(RoomBuffer).
  $C1E8,$06 #HTML(Write #R$FF58@main(Graphics_CustomUDGs) to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C7B.html">UDG</a>.)
  $C1EE,$06 #HTML(Write <a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/3D00.html">#N$3C00</a>
. (CHARSET-#N$100) to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C36.html">CHARS</a>.)
  $C1F4,$0C Blank #N$1770 bytes of data starting from #R$E000@main(SpriteBuffer).
N $C200 Set the lower screen to the default #N$02 lines.
  $C200,$05 #HTML(Write #N$02 to
. *<a rel="noopener nofollow" href="https://skoolkit.ca/disassemblies/rom/hex/asm/5C6B.html">DF_SZ</a>.)
  $C205,$03 Jump to #R$5DC0@main(Game_Initialise).

i $C208

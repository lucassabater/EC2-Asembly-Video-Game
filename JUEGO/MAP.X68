MAPPRINT
            MOVEM.L D0-D7/A0,-(A7)
            LEA MAPDATA,A0
            MOVE.L  #MAPCOL0,D1
            MOVE.B #80,D0
            TRAP #15
            ADDQ.B #1,D0
            TRAP #15

            MOVE.B  #87,D0
            CLR.W   D2
            MOVE.W  #MAPTILEL,D4
            MOVE.W  #(SCRHEIGH/MAPTILEL)-1,D6

.CLOOP      CLR.W   D1
            MOVE.W  #MAPTILEL,D3
            MOVE.W  #(SCRWIDTH/MAPTILEL)-1,D5
.RLOOP      MOVE.B  (A0)+,D7                ; GET MAP CELL                      
            BTST    #0,D7
            BNE    .NEXT
            TRAP    #15
.NEXT       MOVE.W  D3,D1
            ADD.W   #MAPTILEL,D3
            DBRA.W  D5,.RLOOP
            MOVE.W  D4,D2
            ADD.W   #MAPTILEL,D4
            DBRA.W  D6,.CLOOP

            
            
            LEA MAPDATA,A0
            MOVE.L  #MAPCOL1,D1
            MOVE.B #80,D0
            TRAP #15
            ADDQ.B #1,D0
            TRAP #15

            MOVE.B  #87,D0
            CLR.W   D2
            MOVE.W  #MAPTILEL,D4
            MOVE.W  #(SCRHEIGH/MAPTILEL)-1,D6

.CLOOP2     CLR.W   D1
            MOVE.W  #MAPTILEL,D3
            MOVE.W  #(SCRWIDTH/MAPTILEL)-1,D5
.RLOOP2     MOVE.B  (A0)+,D7                ; GET MAP CELL                      
            BTST    #0,D7
            BEQ     .NEXT2
            TRAP    #15
.NEXT2      MOVE.W  D3,D1
            ADD.W   #MAPTILEL,D3
            DBRA.W  D5,.RLOOP2
            MOVE.W  D4,D2
            ADD.W   #MAPTILEL,D4
            DBRA.W  D6,.CLOOP2
            MOVEM.L (A7)+,D0-D7/A0
            RTS



*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~

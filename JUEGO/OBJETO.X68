; =============================================================================
; SHOT MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 TIPO DE DISPARO 
; =============================================================================

; -----------------------------------------------------------------------------
OBJINIT
; INITALIZES A SHOT
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
;            D1.W INITIAL X COORDINATE
;            D2.W INITIAL Y COORDINATE
;            D3.W TYPE OF OBJECT
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D1,(A0)
            MOVE.W  D2,2(A0)
            MOVE.W  D3,4(A0)
            RTS

; -----------------------------------------------------------------------------
OBJUPD
; UPDATES A SHOT BY MOVING IN FUNCTION OF 4(A0).
; 
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------          
            MOVEM.L D0-D7,-(A7)
            JSR CHKOBSTS
            TST.B D7
            BGE .END
            
            MOVE.W  (A0),D2                 ; PREPARE SHOT COORDINATES FOR
            MOVE.W  2(A0),D3                ; COLLISION CHECK   
            MOVE.W  #OBJRADIUS,D5
            MOVE.W  #OBJRADIUS,D7
            MOVE.W  (XPROTA),D0
            MOVE.W  (YPROTA),D1
            MOVE.W  #CUERPO,D4
            MOVE.W  #CUERPO,D6
            JSR     UTLCHCOL
            TST.B   D0
            BNE     .PICKUP                     ; IF COLLISION, EXPLODE IT
.END        
            MOVEM.L (A7)+,D0-D7
            RTS
            
.PICKUP     
            CMP #0,4(A0)
            BNE .SIGUIENTE1
            MOVE.W  #1,PROTAPOW
            MOVE.W  #5,NDISPAROS                ;5 DISPAROS
            MOVE.L   D7,-(A7)
            MOVE.B  #SNDSHOT,D7
            JSR     SNDPLAY
            MOVE.L   (A7)+,D7
            BRA .END2
            
.SIGUIENTE1 CMP #1,4(A0)
            BNE .SIGUIENTE2
            MOVE.W  #3,MALOSPED                 ;RELENTIZAR ENEMIGOS
            MOVE.L   D7,-(A7)
            MOVE.B  #SNDSLOW,D7
            JSR     SNDPLAY
            MOVE.L   (A7)+,D7
            BRA .END2
            
.SIGUIENTE2 
            MOVE.W  #1,D0
            MOVE.L   D7,-(A7)
            MOVE.B  #SNDBOOM,D7                 ;EXPLOSION
            JSR     SNDPLAY
            MOVE.L   (A7)+,D7             
            JSR DMMDELETE

.END2
            JSR     AGLKILL                      ; DESTROY OBJ
            BRA     .END
            
            RTS
            
; -----------------------------------------------------------------------------
OBJPLOT
; PLOTS THE SHOT.
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L     D0-D4,-(A7)
            
            CMP.W #0,4(A0)         
            BEQ .ES_CERO1          
            CMP.W #1,4(A0)         
            BEQ .ES_UNO1                     
            CMP.W #2,4(A0)         
            BEQ .ES_DOS1                            

.ES_CERO1:
            MOVE.L      #$0000FF00,D1
            BRA .DRAW
            
.ES_UNO1:
            MOVE.L      #$00FF0000,D1
            BRA .DRAW

.ES_DOS1:
            MOVE.L      #$000000FF,D1

.DRAW
            MOVE.W      #80,D0   
            TRAP        #15
            ADDQ.W      #1,D0
            TRAP        #15
            MOVE.W      (A0),D1
            MOVE.W      2(A0),D2
            MOVE.W      D1,D3
            MOVE.W      D2,D4
            ADD.W       #OBJRADIUS,D3
            ADD.W       #OBJRADIUS,D4
            MOVE.B      #88,D0
            TRAP        #15
            MOVEM.L     (A7)+,D0-D4
            RTS







*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~

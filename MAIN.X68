*------------------------------------------------------------------------------
* Title      : 
* Written by : Antoni Navarro Moreno i Lucas Sabater Margarit
* Date       :
* Description:
*------------------------------------------------------------------------------

    ORG    $1000

    INCLUDE "CONST.X68" 
    INCLUDE "SYSCONST.X68"          ; SYSTEM CONSTANTS
    INCLUDE "LIB/DMMCONST.X68"
    INCLUDE "LIB/DMMCODE.X68"
    INCLUDE "SYSTEM.X68"
    INCLUDE "LIB/AGLCODE.X68"
    INCLUDE "LIB/UTLCODE.X68"
    INCLUDE "MAPDATA.X68"
    INCLUDE "SHOT.X68"
    INCLUDE "PROTA.X68"
    INCLUDE "MALO.X68"
    INCLUDE "MAP.X68"
    INCLUDE "INTRO.X68"
    INCLUDE "GAME.X68"
    INCLUDE "AYUDA.X68"
    INCLUDE "END.X68"
    INCLUDE "STATES.X68"
    INCLUDE "IMGDATA.X68"
    INCLUDE "OBJETO.X68"


START: 
    ORI.W   #$0700,SR
    JSR     SYSINIT             ;INIT
    JSR     UTLINIT
    JSR     STAINIT
    
.LOOP       
    TRAP    #KBDUPTN
    TRAP    #TRNMREAD           ;TRAP SET UP
    JSR     STAUPD              ;STATE UPDATE
    
.WINT       
    TST.B   (SCRINTCT)
    BEQ     .WINT               ;BUFFER
    CLR.B   (SCRINTCT)
    
    JSR     STAPLOT             ;PLOT OF STATE
    
    BRA     .LOOP
    

    SIMHALT    
    
    INCLUDE "VAR.X68"
    INCLUDE "LIB/UTLVARS.X68"
    INCLUDE "SYSVAR.X68"
    INCLUDE "LIB/DMMVARS.X68"
    
    END    START


























*~Font name~Courier New~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~

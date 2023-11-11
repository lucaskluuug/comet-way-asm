;|////////////////////////////////////////////////////////////////////////////////|
;|/ ABOUT THE GAME                                                               /|
;|////////////////////////////////////////////////////////////////////////////////|

; Universidade de Caxias do Sul
; Anderson Pastore Rizzi
; Lucas Klug Arndt

; Notes:
; The game screen goes from line 0 to 184.
; The status bar goes from line 185 to 199.


                  
;|////////////////////////////////////////////////////////////////////////////////|
;|/ MODEL AND STACK                                                              /|
;|////////////////////////////////////////////////////////////////////////////////|

.model small

.stack 100H ; Define a stack of 256 bytes (100H).



;|////////////////////////////////////////////////////////////////////////////////|
;|/ DATA SEGMENT                                                                 /|
;|////////////////////////////////////////////////////////////////////////////////|

.data
    CR EQU 13 ; Defines a constant of value 13 (Carriage Return).
    LF EQU 10 ; Defines a constant of value 10 (Line Feed).

    STR_TITLE db "      ____                      _   ", 13, 10
              db "     / __ \                    | |  ", 13, 10
              db "    | /  \/ ___  _ __ ___   ___| |_ ", 13, 10
              db "    | |    / _ \| '_ ` _ \ / _ \ __|", 13, 10
              db "    | \__/\ (_) | | | | | |  __/ |_ ", 13, 10
              db "     \____/\___/|_| |_| |_|\___|\__|", 13, 10
              db "        __          __              ", 13, 10
              db "        \ \        / /              ", 13, 10
              db "         \ \  /\  / /_ _ _   _      ", 13, 10
              db "          \ \/  \/ / _` | | | |     ", 13, 10
              db "           \  /\  / (_| | |_| |     ", 13, 10
              db "            \/  \/ \__,_|\__, |     ", 13, 10
              db "                          __/ |     ", 13, 10
              db "                         |___/      ", 13, 10
              
    STR_GAME_OVER db "        _____                       ", 13, 10
                 db "       / ____|                      ", 13, 10
                 db "      | |  __  __ _ _ __ ___   ___  ", 13, 10
                 db "      | | |_ |/ _` | '_ ` _ \ / _ \ ", 13, 10
                 db "      | |__| | (_| | | | | | |  __/ ", 13, 10
                 db "       \_____|\__,_|_| |_| |_|\___| ", 13, 10
                 db "           / __ \                   ", 13, 10
                 db "          | |  | |_   _____ _ __    ", 13, 10
                 db "          | |  | \ \ / / _ \ '__|   ", 13, 10
                 db "          | |__| |\ V /  __/ |      ", 13, 10
                 db "           \____/  \_/ \___|_|      ", 13, 10
                 db "                                    ", 13, 10
                 db "                                    ", 13, 10
                 db "                                    ", 13, 10
                 db "        PRESS ANY KEY TO CONTINUE   ", 13, 10
           
                 
    STR_WIN_GAME db "__     __        __          ___       ", 13, 10
                 db "\ \   / /        \ \        / (_)      ", 13, 10
                 db " \ \_/ /__  _   _ \ \  /\  / / _ _ __  ", 13, 10
                 db "  \   / _ \| | | | \ \/  \/ / | | '_ \ ", 13, 10
                 db "   | | (_) | |_| |  \  /\  /  | | | | |", 13, 10
                 db "   |_|\___/ \__,_|   \/  \/   |_|_| |_|", 13, 10
                 db "                                       ", 13, 10
                 db "                                       ", 13, 10
                 db "                                       ", 13, 10
                 db "        PRESS ANY KEY TO CONTINUE      ", 13, 10


                                              
    

                             
    STR_MENU_PLAY_SELECTED db "               >> PLAY <<", 13, 10
                           db "                  QUIT   ", 13, 10 
          
    STR_MENU_QUIT_SELECTED db "                  PLAY   ", 13, 10 
                           db "               >> QUIT <<", 13, 10
    
    SPACECRAFT_MODEL db "XXXX      "
                     db " XXOXXO   "
                     db "  XOOX    "
                     db " XXXXXOXX "
                     db "    XOXOOX"
                     db "    XOXOOX"
                     db " XXXXXOXX "
                     db "  XOOX    "
                     db " XXOXXO   "
                     db "XXXX     $"
    
    COMET_MODEL db "   XXXX   "
                db " XXXOXXXX "
                db " XXOXXXOX "
                db "XXXOXOOXOX"
                db "XXOXOXOOXX"
                db "XXXXOOXXOX"
                db "XXOXXOOXXX"
                db " XXXXXOOX "
                db " XXXOXXXX "
                db "   XXXX  $" 
        
    SHIELD_MODEL db " XXXXXXXX "
                 db "XXOOOOOOXX"
                 db "XOXXOOOOOX"
                 db "XXOXOOOOOX"
                 db "XOXOOOOOOX"
                 db "XXXOXOOOOX"
                 db "XXOXOOOOXX"
                 db " XXOXXOXX "
                 db "   XOOX   "
                 db "    XX   $"

    HEALTH_MODEL db "   XXXX   "
                 db "   XOOX   "
                 db "   XOOX   "
                 db "XXXXOOXXXX"
                 db "XOOOOOOOOX"
                 db "XOOOOOOOOX"
                 db "XXXXOOXXXX"
                 db "   XOOX   "
                 db "   XOOX   "
                 db "   XXXX  $"

    BAR db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX$"
   
    BAR_LESS db "XXXXXXXXXXXXX"
             db "XXXXXXXXXXXXX"
             db "XXXXXXXXXXXXX"
             db "XXXXXXXXXXXXX"
             db "XXXXXXXXXXXXX$"



;|////////////////////////////////////////////////////////////////////////////////|
;|/ CODE SEGMENT                                                                 /|
;|////////////////////////////////////////////////////////////////////////////////|

.code  

;/********************************************************************************/
;/* KEYBOARD AND VIDEO PROCEDURES                                                */
;/********************************************************************************/

; Sets the video to 320 x 200 format with 256 colors.
SET_VIDEO proc
    push AX 
    mov AL, 13H
    mov AH, 00H
    int 10H      
    pop AX      
    ret
endp



; Returns the keyboard status. If there are no keys in the buffer, ZF is activated.
CHECK_KEYBOARD_STATUS proc
    mov AH, 01H
    int 16H
    ret
endp



; Returns in AH the key read from the keyboard buffer.
READ_KEY proc
    mov AH, 00H
    int 16H
    ret
endp



;/********************************************************************************/
;/* PRINTING PROCEDURES                                                          */
;/********************************************************************************/

; This procedure writes a string to the video memory at the specified position.
; * Receives the string in DI.
; * Receives the length of the string in CX.
; * Receives the color in SI.
; * Receives the initial X coordinate in DL.
; * Receives the initial Y coordinate in DH.
PRINT_STRING proc
    push BP 
    push DX
    push BX
    push AX
      
    mov AH, 13H ;funcao da interrupcao 10h
    mov AL, 01H ;modo
    mov BP, DI  ;BP recebe o endereco de inicio da string
    mov BH, 0H  ;numero da pagina de video
    mov BX, SI  ;BX recebe a cor
    int 10H
    
    pop AX
    pop BX            
    pop DX
    pop BP
    ret
endp



; This procedure loads the values necessary to print the game title into the 
; registers and calls the procedure that performs this operation. It has no 
; input value.
PRINT_TITLE proc
    push DI
    push SI
    push CX
    push DX
    
    mov DI, offset STR_TITLE
    mov SI, 02H              ; Sets the title color.
    mov CX, 532              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 01H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    
    pop DX
    pop CX
    pop SI
    pop DI
    ret
endp



; This procedure loads the values necessary to print the end game screen into the 
; registers and calls the procedure that performs this operation. It has no 
; input value.
PRINT_GAME_OVER proc
    push DI
    push SI
    push CX
    push DX

    ; NAO ESTA PRONTO!
    mov DI, offset STR_GAME_OVER
    ;mov SI, 40H              ; Sets the title color.
    mov CX, 570              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 04H              ; Sets the starting Y coordinate.

    mov AH, 13H ;funcao da interrupcao 10h
    mov AL, 01H ;modo
    mov BL, 04H
    mov BP, DI  ;BP recebe o endereco de inicio da string
    mov BH, 0H  ;numero da pagina de video
    ;mov BX, SI  ;BX recebe a cor
    int 10H
    ;call PRINT_STRING
    
    pop DX
    pop CX
    pop SI
    pop DI
    ret
endp


; This procedure loads the values necessary to print the win game screen into the 
; registers and calls the procedure that performs this operation. It has no 
; input value.
PRINT_CONGRATULATIONS proc
    push DI
    push SI
    push CX
    push DX

    mov DI, offset STR_WIN_GAME
    mov SI, 1FH              ; Sets the title color.
    mov CX, 410              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 06H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    
    pop DX
    pop CX
    pop SI
    pop DI
    ret
endp



; This procedure loads the values necessary to print the informed menu into 
; the registers and calls the procedure that performs this operation.
; * Receives the menu string in DI
; * Receives the color in SI.
PRINT_MENU proc
    push CX
    push DX
    
    mov CX, 54        ; Sets the size of the menu.
    mov DL, 00H       ; Sets the starting X coordinate.
    mov DH, 14H       ; Sets the starting Y coordinate.
    call PRINT_STRING 
    
    pop DX
    pop CX
    ret
endp



; This procedure prints a 10x10 pixel drawing in up to two colors on the screen.
; * Receive the 10x10 design in SI.
; * Receives the width of the drawing in AX.
; * Receives the position of the starting pixel in BX.
; * Receives the color of pixel X in DL.
; * Receives the color of pixel O in DH.
DRAW proc
    push AX
    push BX
    push CX
    push DX
    push DI
    push SI
    
    push AX
    mov AX, 0A000H  ; Moves the starting address of the video memory to AX.
    mov ES, AX      
    xor CX, CX      
    mov AX, BX
    pop BX          ; BX contains the width of the drawing.
    
LOOP_INSERT_PIXEL:
    cmp byte ptr [SI], '$'
    je END_DRAW
    mov DI, AX
    cmp byte ptr [SI], 'X'
    jnz CHECK_PIXEL_O
    mov ES:[DI], DL ; Inserts the pixel into memory.
    jmp NEXT_PIXEL

CHECK_PIXEL_O:
    cmp byte ptr [SI], 'O'
    jnz NEXT_PIXEL
    mov ES:[DI], DH ; Inserts the pixel into memory.
  
NEXT_PIXEL:
    inc CX  
    inc SI  
    inc AX
    cmp CX, BX  ; If CX = BX, skip to the next line, as the drawing is BX pixels wide.
    jz NEXT_LINE
    jmp LOOP_INSERT_PIXEL
    
NEXT_LINE:
    push BX
    push AX
    mov AX, BX
    mov BX, 320
    sub BX, AX
    pop AX
    add AX, BX ; Move AX to the next line.
    pop BX
    xor CX, CX  ; Reset the counter.
    jmp LOOP_INSERT_PIXEL
            
END_DRAW:
    mov AX, DS
    mov ES, AX
    pop SI
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX            
    ret
endp



; This procedure prints a series of continuous pixels of the same color given a 
; starting address and an ending address.
; * Receives the color in DL.
; * Receives starting position in BX.
; * Receives final position in CX.
DRAW_CONTINUOUS_PIXELS proc
    push AX
    push BX
    push CX
    push DX
    push DI

    mov AX, 0A000H  ; Moves the starting address of the video memory to AX.
    mov ES, AX    
    mov DI, BX 

LOOP_CONTINUOUS_PIXELS:
    mov ES:[DI], DL
    cmp DI, CX
    jae END_DRAW_CONTINUOUS_PIXELS
    inc DI
    jmp LOOP_CONTINUOUS_PIXELS

END_DRAW_CONTINUOUS_PIXELS:
    mov AX, DS
    mov ES, AX
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



;/********************************************************************************/
;/* HOME SCREEN PROCEDURE                                                        */
;/********************************************************************************/

; Procedure responsible for the operation of the home screen.
HOME_SCREEN proc
    push AX
    push BX
    push CX
    push DX
    push SI

    call PRINT_TITLE

    ; Draw the spaceship.
    mov SI, offset SPACECRAFT_MODEL
    mov DL, 03H   ; Color for pixel X.
    mov DH, 0FH   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 43310 ; Print starting position (line 135).
    call DRAW

    ; Draw the comet.
    mov SI, offset COMET_MODEL
    mov DL, 08H   ; Color for pixel X.
    mov DH, 07H   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 43340 ; Print starting position (line 135).
    call DRAW

    ; Design health symbol.
    mov SI, offset HEALTH_MODEL
    mov DL, 04H   ; Color for pixel X.
    mov DH, 0CH   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 43370 ; Print starting position (line 135).
    call DRAW

    ; Draw the shield.
    mov SI, offset SHIELD_MODEL
    mov DL, 01H   ; Color for pixel X.
    mov DH, 09H   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 43400 ; Print starting position (line 135).
    call DRAW
    
    ; Prints the menu with the "PLAY" option selected.
    mov DI, offset STR_MENU_PLAY_SELECTED
    mov SI, 0FH
    mov CX, 1 ; CX stores the selected menu option.
    call PRINT_MENU

LOOP_HOME_SCREEN:
    call CHECK_KEYBOARD_STATUS
    jz LOOP_HOME_SCREEN
    call READ_KEY
    cmp AH, 48H   ; Checks if the UP key was pressed.
    je HOME_SCREEN_UP
    cmp AH, 50H   ; Checks if the DOWN key was pressed.
    je HOME_SCREEN_DOWN
    cmp AH, 1CH   ; Checks if the ENTER key was pressed.
    je HOME_SCREEN_ENTER
    jmp END_HOME_SCREEN

HOME_SCREEN_UP:
    mov DI, offset STR_MENU_PLAY_SELECTED
    mov SI, 0FH
    mov CX, 1
    call PRINT_MENU
    jmp LOOP_HOME_SCREEN    

HOME_SCREEN_DOWN:
    mov DI, offset STR_MENU_QUIT_SELECTED
    mov SI, 0FH
    mov CX, 2
    call PRINT_MENU
    jmp LOOP_HOME_SCREEN

HOME_SCREEN_ENTER:
    cmp CX, 1
    je HOME_SCREEN_TO_GAME_SCREEN
    jmp END_HOME_SCREEN

HOME_SCREEN_TO_GAME_SCREEN:
    call GAME_SCREEN
    jmp END_HOME_SCREEN

END_HOME_SCREEN:
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



;/********************************************************************************/
;/* GAME SCREEN PROCEDURE                                                        */
;/********************************************************************************/

GAME_SCREEN proc
    ; Paint the upper part of the screen black.
    mov DL, 00H   ; Black color.
    mov BX, 0     
    mov CX, 59199
    call DRAW_CONTINUOUS_PIXELS

    ; Paint the lower part of the screen orange.
    mov DL, 06H   ; Orange color.
    mov BX, 59200 ; Starts from row 185.
    mov CX, 63999 ; Ends at the end of the screen.
    call DRAW_CONTINUOUS_PIXELS

    ; Draw the blue time bar (adjust the length and color as needed).
    mov SI, offset BAR
    mov DL, 01H   ; Color for pixel X.
    mov AX, 130   ; Drawing width. 
    mov BX, 60820 ; Print starting position (row 190 and column 20).
    call DRAW

    ; Draw the green time bar (adjust the length and color as needed).
    mov SI, offset BAR
    mov DL, 02H   ; Color for pixel X.
    mov AX, 130   ; Drawing width. 
    mov BX, 60970 ; Print starting position (row 190 and column 170).
    call DRAW

    ; Draw the spaceship in the middle of the game screen.
    mov SI, offset SPACECRAFT_MODEL
    mov DL, 03H   ; Color for pixel X.
    mov DH, 0FH   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 29595 ; Print starting position (row 92 and column 155).
    call DRAW
    
    ret
endp



; Procedure responsible for the operation of the end of game screen.
; NOTA TEMPORARIA: Esta tela deve receber em um registrador se o jogador ganhou ou perdeu.
END_OF_GAME_SCREEN proc
    ;PERDEU
    ;Paints the entire screen red.
    mov DL, 04H
    mov BX, 0
    mov CX, 63999
    call DRAW_CONTINUOUS_PIXELS
    call PRINT_GAME_OVER
    
    ;GANHOU
    ;Paints the entire screen yellow
    ;mov DL, 0EH
    ;mov BX, 0
    ;mov CX, 64000
    ;call DRAW_CONTINUOUS_PIXELS
    ;call PRINT_CONGRATULATIONS

    ret
endp


;/********************************************************************************/
;/* MAIN PROCEDURE                                                               */
;/********************************************************************************/

MAIN:  
    ; Data segment configuration.
    mov AX, @DATA
    mov DS, AX 
    mov ES, AX
    
    call SET_VIDEO
    call HOME_SCREEN
    
    call END_OF_GAME_SCREEN

    ; Terminate process with return code (only on Emu8086).
    ;mov AH, 4CH   
    ;int 21h
    
end MAIN



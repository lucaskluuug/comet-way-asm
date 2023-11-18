;|////////////////////////////////////////////////////////////////////////////////|
;|/ ABOUT THE GAME                                                               /|
;|////////////////////////////////////////////////////////////////////////////////|

; Universidade de Caxias do Sul
; Anderson Pastore Rizzi
; Lucas Klug Arndt

; Notes:
; The game screen goes from line 0 to 183.
; The status bar goes from line 184 to 199.
; The size of the spaceship, asteroid, health symbol and shield must be 10x10 and cannot be changed.

; TODO: A proc das barras de progresso precisa ser feita.
; TODO: As telas de mudanca de fase precisam serem feitas.

                  
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
    TIME_BAR db 0            ; Stores the remaining amount of time (maximum 10).
    HEALTH_BAR db 0          ; Stores the remaining amount of health (maximum 10).
    LOADING_BAR db 0         ; ...
    SPACECRAFT_POSITION dw 0 ; Stores the position of the spacecraft's first pixel in relation to the beginning of the screen.



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


             
    STR_GAME_OVER db "        _____                          ", 13, 10
                  db "       / ____|                         ", 13, 10
                  db "      | |  __  __ _ _ __ ___   ___     ", 13, 10
                  db "      | | |_ |/ _` | '_ ` _ \ / _ \    ", 13, 10
                  db "      | |__| | (_| | | | | | |  __/    ", 13, 10
                  db "       \_____|\__,_|_| |_| |_|\___|    ", 13, 10
                  db "           / __ \                      ", 13, 10
                  db "          | |  | |_   _____ _ __       ", 13, 10
                  db "          | |  | \ \ / / _ \ '__|      ", 13, 10
                  db "          | |__| |\ V /  __/ |         ", 13, 10
                  db "           \____/  \_/ \___|_|         ", 13, 10
                  db "                                       ", 13, 10
                  db "                                       ", 13, 10
                  db "                                       ", 13, 10
                  db "        PRESS ANY KEY TO CONTINUE      ", 13, 10
           

                 
    STR_WON_GAME db "__     __        __          ___       ", 13, 10
                 db "\ \   / /        \ \        / (_)      ", 13, 10
                 db " \ \_/ /__  _   _ \ \  /\  / / _ _ __  ", 13, 10
                 db "  \   / _ \| | | | \ \/  \/ / | | '_ \ ", 13, 10
                 db "   | | (_) | |_| |  \  /\  /  | | | | |", 13, 10
                 db "   |_|\___/ \__,_|   \/  \/   |_|_| |_|", 13, 10
                 db "                                       ", 13, 10
                 db "                                       ", 13, 10
                 db "                                       ", 13, 10
                 db "        PRESS ANY KEY TO CONTINUE      ", 13, 10


    STR_LEVEL_1 db "  _                    _   __ ", 13, 10
                db " | |                  | | /_ |", 13, 10
                db " | |     _____   _____| |  | |", 13, 10
                db " | |    / _ \ \ / / _ \ |  | |", 13, 10
                db " | |___|  __/\ V /  __/ |  | |", 13, 10
                db " |______\___| \_/ \___|_|  |_|", 13, 10
                              


    STR_LEVEL_2 db "  _                    _   ___  ", 13, 10
                db " | |                  | | |__ \ ", 13, 10
                db " | |     _____   _____| |    ) |", 13, 10
                db " | |    / _ \ \ / / _ \ |   / / ", 13, 10
                db " | |___|  __/\ V /  __/ |  / /_ ", 13, 10
                db " |______\___| \_/ \___|_| |____|", 13, 10



    STR_LEVEL_3 db "  _                    _   ____  ", 13, 10
                db " | |                  | | |___ \ ", 13, 10
                db " | |     _____   _____| |   __) |", 13, 10
                db " | |    / _ \ \ / / _ \ |  |__ < ", 13, 10
                db " | |___|  __/\ V /  __/ |  ___) |", 13, 10
                db " |______\___| \_/ \___|_| |____/ ", 13, 10
                                 
                                 


    

                             
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

    BAR db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        db "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX$"
   
    BAR_LESS db "XXXXXXXXXXXX"
             db "XXXXXXXXXXXX"
             db "XXXXXXXXXXXX"
             db "XXXXXXXXXXXX"
             db "XXXXXXXXXXXX"
             db "XXXXXXXXXXXX$"

    TIME_MARKER db "OOOOOOOO"
                db "OOXXXXOO"
                db "OOOXXOOO"
                db "OOOXXOOO"
                db "OOOXXOOO"
                db "OOOOOOOO$"

    HEALTH_MARKER db "OOOOOOOO"
                  db "OOXOOXOO"
                  db "OOXOOXOO"
                  db "OOXXXXOO"
                  db "OOXOOXOO"
                  db "OOOOOOOO$"



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

  
  
; Generate a rand number using the system time.
; Ref: https://stackoverflow.com/questions/17855817/generating-a-random-number-within-range-of-0-9-in-x86-8086-assembly
; * Receives the minimum value in BL.
; * Receives the maximum value in BH.
; * Returns the value in BL.
RANDGEN proc
    push AX
    push CX
    push DX

RANDSTART:
    mov AH, 00H  ; Interrupts to get system time.        
    int 1AH      ; CX:DX now hold number of clock ticks since midnight.          
    mov AX, DX
    xor DX, DX
    xor CX, CX
    mov CL, BH    
    div CX       ; Here dx contains the remainder of the division.
    cmp DL, BL
    jb RANDSTART                 
    mov BL, DL   ; Moves the generated number to BL.

    pop DX
    pop CX
    pop AX
    ret
endp



LOAD_DS_AND_ES_WITH_DATA_SEGMENT proc
    push AX
    mov AX, @DATA
    mov DS, AX
    mov ES, AX
    pop AX
    ret
endp



LOAD_DS_AND_ES_WITH_VIDEO_SEGMENT proc
    push AX
    mov AX, 0A000H
    mov DS, AX
    mov ES, AX
    pop AX
    ret
endp



; ...
; * Receives the wait value in microseconds in CXDX.
DELAY proc  
    push AX
    mov AH, 86H
    int 15H
    pop AX
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

    mov DI, offset STR_GAME_OVER
    mov SI, 04H              ; Sets the title color.
    mov CX, 570              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 04H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    
    pop DX
    pop CX
    pop SI
    pop DI
    ret
endp


; This procedure loads the values necessary to print the win game screen into the 
; registers and calls the procedure that performs this operation. It has no 
; input value.
PRINT_YOU_WON proc
    push DI
    push SI
    push CX
    push DX

    mov DI, offset STR_WON_GAME
    mov SI, 0FH              ; Sets the title color.
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
; * Receives the drawing in SI.
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
PAINT_PIXELS_IN_SEQUENCE proc
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
    jae END_PAINT_PIXELS_IN_SEQUENCE
    inc DI
    jmp LOOP_CONTINUOUS_PIXELS

END_PAINT_PIXELS_IN_SEQUENCE:
    mov AX, DS
    mov ES, AX
    pop DI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



; This procedure updates the health, time and loading screen bars.
; * Receives the drawing of the bar segment in SI.
; * Receives the address of the bar data in DI.
; * Receives the length of the bar segment in AX.
; * Receives the initial position of the bar in BX.
; * Receives the operation number (0 to decrement and 1 to increment) in CX.
; * Receives the color of the bar segment in DX.
PROGRESS_BAR proc
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI





    pop DI
    pop SI
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

HOME_SCREEN_LOOP:
    ; Paints the entire screen black.
    mov DL, 00H
    mov BX, 0
    mov CX, 63999
    call PAINT_PIXELS_IN_SEQUENCE
    call PRINT_GAME_OVER

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

HOME_SCREEN_WAITING_FOR_KEY:
    call CHECK_KEYBOARD_STATUS
    jz HOME_SCREEN_WAITING_FOR_KEY
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
    jmp HOME_SCREEN_WAITING_FOR_KEY    

HOME_SCREEN_DOWN:
    mov DI, offset STR_MENU_QUIT_SELECTED
    mov SI, 0FH
    mov CX, 2
    call PRINT_MENU
    jmp HOME_SCREEN_WAITING_FOR_KEY

HOME_SCREEN_ENTER:
    cmp CX, 1
    je HOME_SCREEN_TO_GAME_SCREEN
    jmp END_HOME_SCREEN

HOME_SCREEN_TO_GAME_SCREEN:
    call GAME_SCREEN
    jmp HOME_SCREEN_LOOP

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
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI
    
    ; Calls the level loading screen.
    ;mov CX, 1
    ;call LEVEL_CHANGE_SCREEN

    ; Paint the upper part of the screen black.
    mov DL, 00H   ; Black color.
    mov BX, 0     
    mov CX, 59199
    call PAINT_PIXELS_IN_SEQUENCE

    ; Paint the lower part of the screen orange.
    mov DL, 06H   ; Orange color.
    mov BX, 58880 ; Starts from row 184.
    mov CX, 63999 ; Ends at the end of the screen.
    call PAINT_PIXELS_IN_SEQUENCE

    ; Draw the blue time bar.
    mov SI, offset BAR
    mov DL, 01H   ; Color for pixel X.
    mov AX, 120   ; Drawing width. 
    mov BX, 60512 ; Print starting position (row 189 and column 32).
    call DRAW

    ; Draw the green health bar.
    mov SI, offset BAR
    mov DL, 02H   ; Color for pixel X.
    mov AX, 120   ; Drawing width. 
    mov BX, 60648 ; Print starting position (row 189 and column 168).
    call DRAW

    ; Draw the spaceship in the middle of the game screen.
    mov SI, offset SPACECRAFT_MODEL
    mov DL, 03H   ; Color for pixel X.
    mov DH, 0FH   ; Color for pixel O.
    mov AX, 10    ; Drawing width. 
    mov BX, 29595 ; Print starting position (row 92 and column 155).
    call DRAW

    ; Draw the time marker.
    mov SI, offset TIME_MARKER
    mov DL, 0FH   ; Color for pixel X.
    mov DH, 04H   ; Color for pixel O.
    mov AX, 8     ; Drawing width. 
    mov BX, 60498 ; Print starting position (row 189 and column 18).
    call DRAW

    ; Draw the health marker.
    mov SI, offset HEALTH_MARKER
    mov DL, 0FH   ; Color for pixel X.
    mov DH, 04H   ; Color for pixel O.
    mov AX, 8     ; Drawing width. 
    mov BX, 60774 ; Print starting position (row 189 and column 294).
    call DRAW

    ; Draw 
    mov SI, offset BAR_LESS
    mov DL, 00H   ; Color for pixel X.
    mov AX, 12    ; Drawing width. 
    mov BX, 60512 ; Print starting position (row x and column x).
    call DRAW

    mov AX, 1     ; AX stores the current status of the game (0 if you lost, 1 to start level 1, 2 if you advanced to level 2, 3 if you advanced to level 3 and 4 if you won the game.)
    mov BX, 29595 ; BX stores the ship's starting position.
    mov SI, offset SPACECRAFT_POSITION
    mov [SI], BX

GAME_SCREEN_LOOP:
    cmp AX, 0
    je END_GAME_SCREEN
    cmp AX, 4
    je END_GAME_SCREEN
    call GAME_MATCH
    jmp GAME_SCREEN_LOOP

END_GAME_SCREEN:
    call END_OF_GAME_SCREEN

    pop DI
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



;/********************************************************************************/
;/* END OF GAME SCREEN PROCEDURE                                                 */
;/********************************************************************************/

; Procedure responsible for the operation of the end of game screen.
; * Receives game status in AX.
END_OF_GAME_SCREEN proc
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI

    cmp AX, 0
    je GO_TO_THE_GAME_OVER_SCREEN
    cmp AX, 4
    je GO_TO_THE_YOU_WON_SCREEN

GO_TO_THE_GAME_OVER_SCREEN:
    ;Paints the entire screen red.
    mov DL, 04H
    mov BX, 0
    mov CX, 63999
    call PAINT_PIXELS_IN_SEQUENCE
    call PRINT_GAME_OVER
    jmp WAITING_FOR_KEY_ON_THE_END_OF_GAME_SCREEN 
    
GO_TO_THE_YOU_WON_SCREEN:
    ;Paints the entire screen yellow.
    mov DL, 0EH
    mov BX, 0
    mov CX, 63999
    call PAINT_PIXELS_IN_SEQUENCE
    call PRINT_YOU_WON

WAITING_FOR_KEY_ON_THE_END_OF_GAME_SCREEN:
    call CHECK_KEYBOARD_STATUS
    jz WAITING_FOR_KEY_ON_THE_END_OF_GAME_SCREEN
    call READ_KEY

    pop DI
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



;/********************************************************************************/
;/* LEVEL CHANGE SCREEN PROCEDURE                                                */
;/********************************************************************************/

; ...
; * Receives the level number in CX.
LEVEL_CHANGE_SCREEN proc
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI

    mov AX, CX

    ;Paints the entire screen black.
    mov DL, 00H
    mov BX, 0
    mov CX, 63999
    call PAINT_PIXELS_IN_SEQUENCE

    cmp AX, 1
    je LEVEL_CHANGE_1
    cmp AX, 2
    je LEVEL_CHANGE_2
    jmp LEVEL_CHANGE_3

LEVEL_CHANGE_1:
    mov DI, offset STR_LEVEL_1
    mov SI, 0FH              ; Sets the title color.
    mov CX, 192              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 06H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    jmp LEVEL_CHANGE_DELAY

LEVEL_CHANGE_2:
    mov DI, offset STR_LEVEL_2
    mov SI, 0FH              ; Sets the title color.
    mov CX, 204              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 06H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    jmp LEVEL_CHANGE_DELAY

LEVEL_CHANGE_3:
    mov DI, offset STR_LEVEL_3
    mov SI, 0FH              ; Sets the title color.
    mov CX, 210              ; Sets the size of the title.
    mov DL, 00H              ; Sets the starting X coordinate.
    mov DH, 06H              ; Sets the starting Y coordinate.
    call PRINT_STRING
    jmp LEVEL_CHANGE_DELAY

LEVEL_CHANGE_DELAY:
    ; Calls a 1 second wait.
    mov CX, 000FH
    mov DX, 4240H
    call DELAY
    
LOOP_INFINITO2:
    ;call CHECK_KEYBOARD_STATUS
    ;jz LOOP_INFINITO
    ;call READ_KEY
    ;jmp LOOP_INFINITO2


    pop DI
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



;/********************************************************************************/
;/* GAME MATCH PROCEDURE                                                         */
;/********************************************************************************/

; ...
; * Receives the status of the level to be played in AX.
; * Returns the level result in AX.
GAME_MATCH proc
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI

GAME_MATCH_LOOP:

    call CHECK_KEYBOARD_STATUS
    jz GAME_MATCH_LOOP
    call READ_KEY
    cmp AH, 48H   ; Checks if the UP key was pressed.
    je GAME_MOVE_SPACECRAFT_UP
    cmp AH, 50H   ; Checks if the DOWN key was pressed.
    je GAME_MOVE_SPACECRAFT_DOWN
    cmp AH, 39H   ; Checks if the SPACE key was pressed.
    je TEMPORARIO
    jmp TEMPORARIO

GAME_MOVE_SPACECRAFT_UP:
    mov AX, 1
    call MOVE_SPACECRAFT
    jmp GAME_MATCH_LOOP

GAME_MOVE_SPACECRAFT_DOWN:
    mov AX, 0
    call MOVE_SPACECRAFT
    jmp GAME_MATCH_LOOP


TEMPORARIO:



LOOP_INFINITO:
    call CHECK_KEYBOARD_STATUS
    jz LOOP_INFINITO
    call READ_KEY
    jmp LOOP_INFINITO

    pop DI
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
    ret
endp



; This procedure moves the spacecraft up or down.
; * Receives the direction of movement in AX (0 down and 1 up).
MOVE_SPACECRAFT proc
    push AX
    push BX
    push CX
    push DX
    push SI
    push DI
    cld ; DF = 0
    cmp AX, 0
    je MOVE_SPACECRAFT_DOWN
    jmp MOVE_SPACECRAFT_UP

MOVE_SPACECRAFT_UP: 
    call LOAD_DS_AND_ES_WITH_DATA_SEGMENT
    mov SI, offset SPACECRAFT_POSITION
    mov AX, [SI]
    mov SI, AX
    cmp SI, 475 ; Checks if the spacecraft has reached the upper limit of the screen.
    je END_MOVE_SPACECRAFT
    call LOAD_DS_AND_ES_WITH_VIDEO_SEGMENT
    mov AX, 11
    
    MOVE_SPACECRAFT_UP_LOOP:
    cmp AX, 0
    je FINISHED_MOVING_SPACECRAFT_UP 
    dec AX 
    mov DI, SI
    sub DI, 320
    mov CX, 10
    rep movsb
    sub SI, 10
    add SI, 320
    jmp MOVE_SPACECRAFT_UP_LOOP
     
    FINISHED_MOVING_SPACECRAFT_UP: 
    sub SI, 3840
    call LOAD_DS_AND_ES_WITH_DATA_SEGMENT
    mov AX, SI
    mov SI, offset SPACECRAFT_POSITION
    mov [SI], AX
    jmp END_MOVE_SPACECRAFT


MOVE_SPACECRAFT_DOWN: 
    call LOAD_DS_AND_ES_WITH_DATA_SEGMENT
    mov SI, offset SPACECRAFT_POSITION
    mov AX, [SI]
    mov SI, AX
    add SI, 2880  ; Move SI to the last line of the drawing.
    cmp SI, 58395 ; Checks if the spacecraft has reached the lower limit of the screen.
    je END_MOVE_SPACECRAFT
    call LOAD_DS_AND_ES_WITH_VIDEO_SEGMENT
    mov AX, 11
    
    MOVE_SPACECRAFT_DOWN_LOOP:
    cmp AX, 0
    je FINISHED_MOVING_SPACECRAFT_DOWN 
    dec AX 
    mov DI, SI
    add DI, 320
    mov CX, 10
    rep movsb
    sub SI, 10
    sub SI, 320
    jmp MOVE_SPACECRAFT_DOWN_LOOP
     
    FINISHED_MOVING_SPACECRAFT_DOWN: 
    add SI, 960
    call LOAD_DS_AND_ES_WITH_DATA_SEGMENT
    mov AX, SI
    mov SI, offset SPACECRAFT_POSITION
    mov [SI], AX
    jmp END_MOVE_SPACECRAFT

END_MOVE_SPACECRAFT:
    pop DI
    pop SI
    pop DX
    pop CX
    pop BX
    pop AX
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
    
    ;mov BL, 5
    ;mov BH, 27
    ;call RANDGEN

    call SET_VIDEO
    call HOME_SCREEN

    ; Terminate process with return code (only on Emu8086).
    ;mov AH, 4CH   
    ;int 21h
    
end MAIN

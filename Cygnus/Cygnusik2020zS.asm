
                        emulate_spectrum "128k"         ; Set a model with 128K of RAM              ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ;   INCLUDE "CygnusLoading.asm"


;                        ORG ZeusAddr0                   ;
                        ;  org $C000                       ; Build the code to run at $C000


                        ORG 24064                       ;
Addrs:
; 24064
ATTR1_EMPTY:            DEFS 512                        ; EQU 24064                   ;Screen ATTR Buffer for empty level
; 24576
SCREEN1:                DEFS 4096                       ; EQU 24576                   ;Screen buffer
; 28672
SCREEN1_EMPTY:          DEFS 4096                       ; EQU 28672                    ;Screen buffer for empty 3

                        ORG 32768                       ;


                        ;    dispto zeuspage(2)              ; But displace it so it goes in memory at $14000

; 32768
ATTR1:                  DEFS 512                        ; EQU 32768                 ;Screen ATTR Buffer

; 20480
SCREEN                  EQU 16384                       ; Screen
ATTR                    EQU 22528                       ; Attributes
MAIN_TEXT_DISPLAY_START_ADDRESS:EQU 23073               ;

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ZeusAddr0:              equ 33280                       ;

                        ORG ZeusAddr0                   ;
ZeusAddr0B:


Init:

Startaddress:
AppEntry:


                        DI                              ;
                        LD SP,24064                     ; 49152                     ;


; JP STARTA     ; YY;

; Check whether there is a joystick connected
                        XOR A                           ; Initialise Kempston flag
                        LD (KEMPSTON),A                 ;
                        LD BC,31                        ; B=0, C=31 (joystick port)
                        XOR A                           ; A=0
A34970:                 IN E,(C)                        ; Combine 256 readings of the joystick port in A; if no joystick is connected, some of these readings will have bit 5 set
                        OR E                            ;
                        DJNZ A34970                     ;
                        AND 32                          ; Is a joystick connected (bit 5 reset)?
                        JR NZ,STARTA                    ; Jump if not
                        LD A,1                          ; Set the Kempston joystick indicator at 34254 to 1
                        LD (KEMPSTON),A                 ;
STARTA:

; LD HL,TRACKER_SOUND_DATA  ;Set background sound after fire sound
; CALL GENERAL_SOUND           ;Get back to background sound
; ret



                        CALL RESET_ALL_SOUNDS           ; Reset sounds
                        LD A,69                         ; Normal text colour
                        LD (NORMAL_LCD_COLOUR),A        ; Set normal LCD text colour

                    ;    JP GO                           ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        XOR A                           ; A=0 to set border black
                        OUT (254),A                     ; Border black
                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL GET_KEY_DELAY_6            ; Wait for Enter key or joystick fire
                        CALL RESET_ALL_SOUNDS           ; Stop all sounds
                        CALL FADE_OUT_6                 ; Fade out ATTR
                        LD BC,1000                      ; Set delay
                        CALL DELAY1LOOP                 ; Delay

                        CALL DISPLAY_START_MESSAGE_6    ; Display Start message

; Check for Enter key or joystick fire being pressed to start the game
; HALT

                        CALL GET_KEY_DELAY_6            ; Wait for Enter key or joystick fire
                        CALL RESET_ALL_SOUNDS           ; Stop all sounds
GO99:

                        CALL FADE_OUT_6                 ; Fade out ATTR to black
                        LD BC,1000                      ; Set delay
                        CALL DELAY1LOOP                 ; Delay


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jumps here after start credits message
; Start game demo loop waiting for Skill selection
GO:

                        DI                              ; Disable interupts
                        IM 1                            ; Interupt mode 1
                        ; LD SP,24064                     ; Set Stack pointer;24064 was 49152                     ;

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD HL,MUSIC_DATA_4              ; Music data
                        CALL init1_4                    ; Setup Music

; Clear screen buffer to set colour
                        LD A,7                          ;
                        LD HL,ATTR1                     ; HL=Start address
                        LD DE,ATTR1+1                   ;
                        LD BC,511                       ;
                        LD (HL),A                       ;  Set colour
                        LDIR                            ;

; Clear visible screen and ATTR
                        XOR A                           ;
                        LD HL,16384                     ; First address of Display file
                        LD DE,16385                     ; Second address of Display file
                        LD BC,4095                      ; Number of bytes to fill buffer
                        LD (HL),A                       ; Set screen address to blank
                        LDIR                            ; Fill screen memory ; Clear screen to black paper and ink and set border colour

                        ; Set ink to white on black and initialize spinning icon
                        LD (SPINING_ICON_STATUS),A      ; Initialize spinning icon status
                        ; Clear top 2 3rds ATTR A=colour

                        LD HL,22528                     ; Get Screen start address store into HL
                        LD D,H                          ; DE=Start address
                        LD E,L                          ;
                        INC E                           ; Add one address to DE
                        LD BC,512                       ; 767 bytes fill the ATTR area
                        LD (HL),A                       ; Set ATTR address to colour in A
                        LDIR                            ; Fill memory


; Clear the screen and ATTR buffer
                        ;       CALL CLEAR_SCREEN_BUFFER        ; Clear screen buffer
                        ;      CALL CLEAR_SCREEN_ATTR_BUFFER   ; Clear screen ATTR buffer

; Display Console and border
                        CALL MEMORY_SWITCH_1            ; Memory switch 1
                        CALL DISPLAY_CONSOLE_28990_1    ; Display console
                        CALL DISPLAY_COCKPIT_1          ; Display border

; Display timer and colour it dark blue
                        ;  CALL DISPLAY_TIMER              ; Display 00:00 in timer

                        CALL RESET_TIMER                ;  Make timer dark blue

                        XOR A                           ; A=0
                        LD (COUNTER),A                  ; Update counter
                        LD (SCROLL_COUNT),A             ; Reset scroll counter
                        OUT (254),A                     ; Set border to black
                        LD (LOGO_MODE),A                ; Reset logo implode explode counter
                        LD (SHIELDS_ON),A               ; Reset Shields on
                        CALL COCKPIT_COLOUR_ENTRY_1     ; Set Shields to off
                        CALL COPY_LOGO_DATA_TO_TEMP     ;
                        CALL RESET_METERS               ; Reset meters

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL DISPLAY_SELECT_LEVEL_TEXT_4 ; Display Select Level text

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISPLAY_LOGO_COORDINATES_6: ; Display the logo using the coordinates data

                        CALL ZIPZAP_SCREEN_COPY         ; Copy buffer to visible screen to display logo

; Logo rounded corners
                        CALL DISPLAY_LOGO_ROUNDED_CORNERS_6; Add rounded corners to logo

                        CALL ENABLE_MUSIC_INTERUPT      ; Start music



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Wait for level to be selected loop
LEVEL_SELECTED:
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD A,(NORMAL_LCD_COLOUR)        ; Get Default LCD colour, usually light cyan on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR

                        XOR A                           ; A=0 to reset message status
                        LD (MESSAGE_STATUS),A           ; Reset message status

LEVEL_SELECTED2:
                        LD HL,COUNTER                   ; Get counter
                        INC (HL)                        ; Add 1 to counter
                        LD A,(COUNTER)                  ; Get counter
                        CP 1                            ; Is counter at 1?
                        JR NZ,SKIP_ENABLING_TITLE_SPINING_ICON; If not then skip spinning icon

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ; Clear text screen
; Enable the spinning icon
                        LD A,1                          ; A=1 to set spining icon status
                        LD (SPINING_ICON_STATUS),A      ; Set spining status icon on
                        JP SKIP_DISABLING_TITLE_SPINING_ICON;

SKIP_ENABLING_TITLE_SPINING_ICON:
                        CP 51                           ; Is counter at 51?
                        JR NZ,SKIP_DISABLING_TITLE_SPINING_ICON;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ; Clear text screen

                        XOR A                           ; A=0
                        ;  LD (COUNTER),A                  ; Update counter
                        LD (SPINING_ICON_STATUS),A      ; Set spining status icon off

                        INC A                           ; Message 1 - Start message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        JP LEVEL_SELECTED               ;

SKIP_DISABLING_TITLE_SPINING_ICON:
                        LD A,(MESSAGE_STATUS)           ; Get message status
                        OR A                            ; End of message
                        JR NZ,SKIP_RESET_START_MESSAGE  ; If not then skip resetting message

                        INC A                           ; Message 1 - Start message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
SKIP_RESET_START_MESSAGE:

                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Display start message

                        CALL READ_KEYS_1TO5_c29023      ; Read keys 1 to 5
                        JR NZ,START_GAME                ; If key 1 to 5 is selected then jump into game


LOGO_COLOUR:            LD A,1                          ;


                        LD B,20                         ; Repeat loop 20 times
LOGO_COLOUR_LOOP3:
                        PUSH BC                         ; Save repeat loop
                        LD HL,22724-64                  ; Top left of logo ATTR

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL TOP_BOTTOM_LOGO_ATTR_3     ;

                        LD DE,8                         ; Setup DE for addition to move to next ATTR line
                        ADD HL,DE                       ; Move HL to next ATTR line


                        LD B,5                          ; 5 lines of ATTR
LOGO_COLOUR_LOOP2:
                        PUSH BC                         ; Save lines loop
                        LD B,24                         ; 24 collumns to colour
LOGO_COLOUR_LOOP1:

                        LD A,(LOGO_COLOUR+1)            ; Get setting from address LOGO_COLOUR+1
                        AND 10                          ; Light blue paper whatever happens
                        OR 66                           ; Logo stays red ink whatever happens
                        LD (HL),A                       ; Colour current ATTR address
                        INC HL                          ; Move to next ATTR address
                        DJNZ LOGO_COLOUR_LOOP1          ; Jump back for all 24 collumns of current ATTR line

                        LD DE,8                         ; Setup DE for addition to move to next ATTR line
                        ADD HL,DE                       ; Move HL to next ATTR line

                        POP BC                          ; Restore lines loop
                        DJNZ LOGO_COLOUR_LOOP2          ; Jump back to complete 3 lines

                        CALL TOP_BOTTOM_LOGO_ATTR_3     ; Colour top and bottom of logo

                        POP BC                          ; Restore repeat loop
                        DJNZ LOGO_COLOUR_LOOP3          ; Jump back for repeat
                        LD D,A                          ; Save current colours to D
                        LD HL,LOGO_COLOUR+1             ; Point to logo colour varable
                        INC (HL)                        ; Add 1 to logo colour
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(COUNTER3)                 ; Get counter
                        ; INC A
                        ADD A,6                         ; Add 6
                        LD (COUNTER3),A                 ; Update counter 3
                        CP 136                          ; If it is below 136 then skip highlighting logo
                        JR C,SKIP_LOGO_BAR              ;

                        LD A,D                          ; Restore current colour from D
                        OR 71                           ; Bright white ink whatever happens
                        LD HL,(TITLE_ATTR_BAR)          ; Get current ATTR address
                        LD (HL),A                       ; Set ATTR for top row as bright white on blue or black paper 71
                        LD DE,33                        ; Move down 1 ATTR line and in 1 collumn so ATTR update has an angle
                        ADD HL,DE                       ;
                        LD (HL),A                       ; 71
                        ADD HL,DE                       ; Move down 1 ATTR line and in 1 collumn so ATTR update has an angle
                        LD (HL),A                       ; 71

                        SBC HL,DE                       ; Move back to top logo ATTR bar
                        SBC HL,DE                       ;
                        INC HL                          ; Move in 1 collumn for the highlight angle
                        LD A,L                          ; Get collumn number
                        CP 218                          ; Is it 218?
                        JR NZ,SKIP_RESETTING_ATTR_BAR   ; If not then skip reseting ATTR highlight bar

; Reset ATTR highlight bar
SKIP_LOGO_BAR:
                        LD HL,22724                     ; Top left ATTR address of logo

SKIP_RESETTING_ATTR_BAR:

                        LD (TITLE_ATTR_BAR),HL          ; Update title ATTR highlight bar
                        JP LEVEL_SELECTED2              ; Jump back until level is selected
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


TITLE_ATTR_BAR:         DEFW 22724                      ;

RESET_GAME_PHASE:       DB 0                            ;
RESET_GAME_PHASE1:      DB 0                            ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Start game after Skill level is selected

START_GAME:             ; ld a,41                       ;
                        ;  ld  (WATER_STATUS),a


                        INC A                           ;
                        LD (LEVEL),A                    ;

                        ;  PUSH AF                         ;
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        ; POP AF                          ;
                        CALL SETUP_SECTORS_4            ;

                        ;  CALL SELECT_LEVEL_MESSAGE_BLANK ; Erase left window
                        CALL RESET_SERVICES_FIGURES     ; Reset services figures

                        XOR A                           ;
                        LD (CYGNUS_FOUND),A             ; Reset Cygnus Found
                        LD (MESSAGE_STATUS),A           ; Get message status

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;

                        LD A,43                         ; Message 42 SYSTEM TESTS
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        XOR A                           ;
                        LD (SPINING_ICON_STATUS),A      ;
                        ;          CALL SELECT_LEVEL_MESSAGE_BLANK
                        ; GGGJJ:      JP GGGJJ

; Stop music
                        DI                              ;
                        IM 1                            ;
                        EI                              ;


                        CALL RESET_ALL_SOUNDS           ; Reset all sounds

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;  LD A,71                         ;
                        ;  LD (CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1),A;
                        ;  CALL CLEAR_SCREEN_ATTR_BUFFER   ; Clear screen ATTR buffer CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1 to set colour
                        ; Clear screen buffer to set colour
                        LD A,7                          ;
                        LD HL,ATTR1                     ; HL=Start address
                        LD DE,ATTR1+1                   ;
                        LD BC,511                       ;
                        LD (HL),A                       ;  Set colour
                        LDIR                            ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Explode logo and perform system test
                   ;     JP SKIP_TEST                    ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                  ;

                        XOR A                           ; 0 TO 12

                        LD (RESET_GAME_PHASE1),A        ;
                        LD A,1                          ; Enable system test
                        LD (SYSTEM_TEST),A              ;
                        LD B,3                          ; 3 meters to reset
INITIALISE_START_GAME_TEST_LOOP2:
                        PUSH BC                         ;


; Do some flash things before starting the game like system test and meters
INITIALISE_START_GAME_TEST_LOOP:
                        PUSH AF                         ;

                        SRL A                           ;
                        LD (RESET_GAME_PHASE),A         ;

                        LD A,(RESET_GAME_PHASE1)        ;

                        OR A                            ; CP 0                            ;
                        JR NZ,NEXT_METER1               ;
                        LD A,(RESET_GAME_PHASE)         ;
                        LD (LASER_METER_STORE),A        ;
                        CALL SET_LASER_METER            ;
                        JR NEXT_METER3                  ;

NEXT_METER1:
                        CP 1                            ;
                        JR NZ,NEXT_METER2               ;
                        LD A,(RESET_GAME_PHASE)         ;
                        LD (SHIELDS_METER_STORE),A      ;
                        CALL SET_SHIELDS_METER          ;
                        JR NEXT_METER3                  ;

NEXT_METER2:
                        CP 2                            ;
                        JR NZ,NEXT_METER3               ;
                        LD A,(RESET_GAME_PHASE)         ;
                        LD (POWER_STATUS),A             ;
                        CALL SET_POWER_METER            ;

NEXT_METER3:

                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Display start message
                        CALL CLEAR_BUFFER               ; Clear any rubbish out of the screen buffer

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISPLAY_LOGO_COORDINATES_6: ; Display the logo using the coordinates data
                        CALL ZIPZAP_SCREEN_COPY         ;

                        POP AF                          ;
                        INC A                           ;

                        LD (RESET_GAME_PHASE),A         ;


                        CP 25                           ;
                        JR C,INITIALISE_START_GAME_TEST_LOOP;


                        LD A,(RESET_GAME_PHASE1)        ; Get game test phase
                        OR A                            ; CP 0                            ; Is test phase at 0?
                        JR NZ,SKIP_TEST_WARNING         ; Jump display warning if not

                        LD A,66                         ; Bright red on black
                        LD (WARNING_ON),A               ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ;

                        JP SKIP_TEST_SERVICE            ;

SKIP_TEST_WARNING:
                        LD A,(RESET_GAME_PHASE1)        ; Get game test phase
                        CP 1                            ; Is test phase at 1?
                        JR NZ,SKIP_TEST_SERVICE         ; Jump display service if not

                        LD A,66                         ; Bright red on black
                        LD (SERVICE_ON),A               ; Set service light bright red
                        CALL SERVICE_OFF_ON             ; Switch on service light

SKIP_TEST_SERVICE:

                        LD HL,RESET_GAME_PHASE1         ;
                        INC (HL)                        ;

                        POP BC                          ;
                        DJNZ INITIALISE_START_GAME_TEST_LOOP2;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        XOR A                           ; Disable system test
                        LD (SYSTEM_TEST),A              ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;
SKIP_TEST:
                        LD A,200                        ;
                        LD (TAKEOFF_PITCH),A            ;
                        CALL CLEAR_BUFFER               ; Clear any rubbish out of the screen buffer
                        CALL ZIPZAP_SCREEN_COPY_SCREEN  ; Clear play area


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CALL MEMORY_SWITCH_6            ; Memory switch 6

                        LD IX,ALIEN_SHIP_1_ENABLED      ;
                        CALL COPY_DEFAULT_EXPLODE_DATA_TO_CORRECT_ALIEN_6;
                        LD A,160                        ;
                        LD (ALIEN_UP_DOWN_LOCATION_6+1),A ;
                        LD A,118                        ;
                        LD (ALIEN_LEFT_RIGHT_LOCATION_6+1),A;

; Flash play area
                        LD B,60                         ;
                        LD E,16                         ;
DO_FLASH_PLAY_AREA:
                        PUSH BC                         ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3


                        DEC E                           ;
                        ;  LD A,E

                        ;  OR A
                        JR NZ,SKIP_RESET_FLASH_COUNTDOWN;

                        LD E,16                         ;

SKIP_RESET_FLASH_COUNTDOWN:

                        BIT 0,E                         ;
                        JR Z,SKIP_WHITE                 ;
                        CALL FLASH_PLAY_AREA_WHITE_3    ;
                        JP SKIP_BLACK                   ;
SKIP_WHITE:
                        CALL FLASH_PLAY_AREA_BLACK_3    ;
SKIP_BLACK:

                        LD A,E                          ;
                        CP 8                            ;

                        JR C,SKIP_TAKE                  ;
                        CALL DISPLAY_ATTR_TAKE_TEXT_3   ;
                        JP SKIP_OFF                     ;
SKIP_TAKE:
                        CALL DISPLAY_ATTR_OFF_TEXT_3    ;
SKIP_OFF:
                        LD BC,1000                      ;
                        CALL DELAY1LOOP                 ;
                        PUSH DE                         ;
                        CALL CLEAR_SCREEN_BUFFER        ;

                        LD IX,ALIEN_SHIP_1_ENABLED      ;

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL TAKE_OFF_SOUND_6           ;
                        CALL DRAW_EXPLODING_DOTS_6      ;



                        CALL ZIPZAP_SCREEN_COPY_SCREEN  ; Copy buffer to screen

                        POP DE                          ;


                        POP BC                          ;
                        DJNZ DO_FLASH_PLAY_AREA         ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CALL CLEAR_SCREEN_BUFFER        ;
                        CALL ZIPZAP_SCREEN_COPY_SCREEN  ; Clear play area

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_GAME_SCREEN_ATTR_3   ; Clear screen ATTR buffer CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1 to set colour



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SKIP_TEST:              ;                               ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup some varables
                        XOR A                           ;
                        LD (AMBIENCE_SOUND1_DURATION),A ;
                        LD (MAP_SELECT_STORE_NUMBER_b30583),A ; Used to store the current sector number
                        LD (RADAR_SELECT_SECTOR_STORE),A ; Used to count radar sector
                        LD HL,TRADING_KEYS_ENABLED      ;
                        LD DE,TRADING_KEYS_ENABLED+1    ;
                        LD BC,39                        ;
                        LD (HL),A                       ;
                        LDIR                            ;


                        ;   LD (TRADING_KEYS_ENABLED),A     ; Set to 0 so trading yeys are disabled
                        ;   LD (FIRE_ON),A                  ;
                        ;   LD (FIRE_HAS_BEEN_DONE),A       ;
                        ;   LD (GAME_MODE),A                ; Initialise game mode
                        ;   LD (SNOW_TEXT_SCREEN_ON),A      ; Initialise Text screen interference
                        ;   LD (SPEEDMAX),A                 ; Counts up to speed. Then calls move stars
                        ;   LD (ABORT_ENABLED),A            ;
                        ;   LD (HYPERDRIVE),A               ; Hyperdrive is off
                        ;   LD (SITES_ON),A                 ; Set sites off         ;Sites are off
                        ;   LD (LED_STATUS_SCREEN),A        ; Initialise LED Status Screen
                        ;   LD (MAP_SELECT_STORE_NUMBER_b30583),A ; Start sector select at top left of map
                        ;   LD (RELEASE_RANDOM_NUMBER_SETTING),A ; Start random counter
                        ;   LD (PLANET_LANDING_MODE),A      ; 0 for confrontation. 1 for landing
                        ;   LD (SYSTEM_RESET),A             ; Initialise system reset
                        ;   LD (OXYGEN_LEAK),A              ; Reset Oxygen leak status to not leaking
                        ;   LD (WE_ARE_HIT),A               ; Hit counter
                        ;   LD (COUNTER),A                  ; General 255 counter 1
                        ;   LD (UP_DOWN_TEMP),A             ; Reset side scrolling aliens up/down
                        ;   LD (UP_DOWN_COUNTER),A          ; Reset sprite up/down counter
                        ;   LD (SET_WARNING_ON),A           ; Used to set warning on/off 1=on
                        ;   LD (WARNING_DELAY_COUNTER),A    ; Flash warning timer
                        ;   LD (NASTY_FRAME_COUNT),A        ; Reset side scrolling sprite frame counter
                        ;   LD (SET_SERVICE_ON),A           ; Used to set SERVICE on/off 1=on
                        ;   LD (SERVICE_DELAY_COUNTER),A    ; Flash SERVICE timer
                        ;   LD (UP_DOWN_SETTING),A          ; Reset sprite up/down setting
                        ;   LD (PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER),A; Reset the planet takeoff from side scroller counter
                        ;   LD (WHO_FIRED_FIRST),A          ; Reset who fired first to 0 -  1 if you fired first or 2 if alien fired first
                        ;   LD (ENGINE_STATUS),A            ; Initialise Engine status
                        ;   LD (ALIEN_FIRED),A              ; Reset alien has fired flag
                        ;   LD (SET_GAME_OVER),A            ; Initialise Game over status
                        ;   LD (RADAR_MOVE_TIMER),A         ; Initialise Radar move timer
                        ;   LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Initialise alien encounter sequence
                        ;   LD (BUY_SELL),A                 ; Initialises Buy and sell flag
                        ;   LD (DRAW_RING_ON),A             ; Initialize draw ring to off
                        ;   LD (SCROLL_SHOW_BARS_ON),A      ; Set charge bars to off
                        ;   LD (POWER_FULL_LOCK),A          ; Initialize Power Full status lock
                        ;   LD (ITEM_SELLING_TO_ALIEN),A    ; Initializes what we are selling to alien
                        ;   LD (INTERESTED_IN_QTY),A        ; Stores current alien interested in qty
                        ;   LD (OFFER_HD_QTY),A             ; Stores current alien offering amount of HD per unit
                        ;   LD (WE_ARE_HIT_COUNTDOWN),A     ; Initialize We are hit countdown
                        ;   LD (BUY_SELL_MENU),A            ; Initialize Buy/Sell menu
                        ; ld a,2                          ;
                        ; ld (SET_GAME_OVER),a            ; Initialise Game over status


                        LD A,10                         ;
                        LD (REPUTATION),A               ; Initialise reputation
                        CALL SET_REPUTATION             ; Set reputation


                        ;  LD A,96                         ; Black ink on bright green paper
                        ;  LD (GUN_STATUS_COLOUR),A        ; Diagram gun status colour
                        ;  LD (ENGINE_STATUS_COLOUR),A     ; Diagram engine status colour
                        ;  LD (WATER_STATUS_COLOUR),A      ; Diagram water status colour
                        ;  LD (FOOD_STATUS_COLOUR),A       ; Diagram food status colour
                        ;  LD (COCKPIT_STATUS_COLOUR),A    ; Diagram cockpit status colour
                        ;  LD (FUEL_STATUS_COLOUR),A       ; Diagram fuel status colour
                        ;  CALL SET_COCKPIT_STATUS         ; Set Cockpit status

                        CALL RESET_METERS               ;

                        ;       LD A,100                        ; Set percentage
                        ;       LD (ENGINE_STATUS),A            ; Initialise Engine status
                        ;       LD (OXYGEN),A                   ; Initialise OXYGEN status
                        ;       ; LD (WATER_STATUS),A             ; Initialise water status
                        ;       ; LD A,1
                        ;       LD (FOOD),A                     ; Initialise food status
                        ;       LD (WATER_STATUS),A             ; Initialise water status
                        ;       CALL SET_ENGINE                 ; Set engine status
                        ;       CALL SET_OXYGEN                 ; Set OXYGEN status
                        ;       CALL SET_WATER_STATUS           ; Set water status
                        ;       CALL SET_FOOD_STATUS            ; Set food status
                        ;       ; ld a,2                          ;
                        ;       LD (FUEL),A                     ; Initialise FUEL status
                        ;
                        ;       CALL SET_FUEL                   ; Set FUEL status
                        ;
                        ;
                        ;       LD A,11                         ;
                        ;       LD (SHIELDS_METER_STORE),A      ;
                        ;       LD (LASER_METER_STORE),A        ;
                        ;       LD (POWER_STATUS),A             ;
                        ;       CALL SET_POWER_STATUS           ; Set POWER status


                        LD A,32                         ;
                        LD (SP1Y_SHIP),A                ;
                        LD (SP1X_SHIP),A                ;


                        ;   LD A,99
                        ;  LD (TEMPERATURE),A              ;
                        ;         CALL SET_TEMPERATURE            ;

                        LD A,20                         ;
                        LD (ROCKET_DROP_COUNTER),A      ; Sets initial rocket counter to reduce rocket count when 0

                        LD A,255                        ;
                        LD (COUNTER2),A                 ; General 255 counter 2

                        LD A,5                          ; Start speed
                        LD (SPEED),A                    ; Save start speed
                        LD A,50                         ; Message 51 for speed 2 to start game
                        LD (LAST_SPEED_MESSAGE),A       ; Save message number for later

                        LD A,1                          ; Sets friendly alien to yes and Dark blue on black

                        ;    LD (GAME_MODE),A   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD (ALIEN_IS_FRIENDLY),A        ; Initialise alien friendly setting 1 for friendly
                        LD (WARNING_ON),A               ; Set Warning colour BLUE ON BLACK
                        LD (SERVICE_ON),A               ; Set Service colour

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ; Display Warning colour

                        CALL SERVICE_OFF_ON             ; Display Service colour
                        ; CALL SHIELDS_ON_OFF             ; Set shields

                        XOR A                           ;
                        LD (SITES_ON),A                 ; Sites off
                        LD (LED_STATUS_SCREEN),A        ; Update Services on/off status
                        LD (ICON_COUNTER),A             ;
                        ;  LD (SHIELDS_ON),A               ; Reset Shields on
                        LD (ALARM_SOUND_MUTE),A         ; Start with alaerm mute off
                        LD (MESSAGE_STATUS),A           ; Reset message status
                        LD (SERVICES_ON),A              ; Set Services status to off
                        LD (PROGRESS),A                 ; Reset Progress

                        CALL CLEAR_EMPTY_BUFFER         ; Clear empty screen attr to white ink on black paper
                        CALL CLEAR_BUFFER               ; Clear the screen buffer

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISABLE_ALL_ALIENS_6       ; Clear all aliens

; Set game error
                        LD A,R                          ; Get random
                        AND 3                           ;
                        LD (ERROR_SELECT),A             ; Set game error for later when error is required


; Clear select level text
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL COLOUR_RADAR_4             ; Colour radar
                        CALL SELECT_LEVEL_MESSAGE_BLANK_4 ; Erase right window


                        CALL DISPLAY_RADAR_ICONS_4      ; Display the radar icons
; Setup stars

                        LD A,(GAME_MODE)                ; Get game mode
                        OR A                            ; Is it mode 0 for 3D
                        JR NZ,SKIP_SETUP_3D_STARS       ; If not then skip setting up 3D stars


                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL SETUP_START_STARS_6        ; Setup 3D stars
                        JP SKIP_SETUP_SIDE_STARS        ; Skip setting up side scrolling stars

SKIP_SETUP_3D_STARS:

                        CALL SETUP_STARS_SIDE_SCROLLER  ; Setup side scrolling stars

SKIP_SETUP_SIDE_STARS:

                        LD HL,TEXT_CHARACTER_DATA_OFFSET ; Start of graphic text data offset
                        ;   LD (TEXT_CHARACTER_OFFSET_STORE_26602),HL ; Set Graphics offset pointer to Start of graphics text data


                        LD A,(LEVEL)                    ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        CALL RESET_TIMER                ; Reset the timer and make it dark blue

                        JP NEW_GAME                     ; Jump to skip new sector start


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; JUMPS BACK HERE FOR START OF EACH SECTOR
SECTOR_START:
                        LD A,255                        ; Setup A to 255 to setup general counter 2
                        LD (COUNTER2),A                 ; General 255 counter 2


                        LD A,(MAP_SELECT_STORE_NUMBER_b30583) ; Get sector value
                        LD (SECTOR_VALUE_MEMORY),A      ; Memorise it

                        XOR A                           ;
                        LD (RELEASE_RANDOM_NUMBER_COUNTER),A ; Reset random release counter

                        LD A,(LAST_SPEED_MESSAGE)       ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jumps here when new game only
NEW_GAME:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ;

                        LD A,4                          ;
                        LD (COUNTER4),A                 ; General 255 countdown counter 4 for freestyle aliens appearing

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Main game loop
MAIN_LOOP:

                        LD HL,23672                     ; Get Spectrum Frames
                        LD A,(HL)                       ; Get frames into A
                        LD (CPU_ATTR),A                 ; Update CPU ATTR store

; Get ready for Freestyle aliens?
                        LD HL,COUNTER2                  ; Get counter 2
                        DEC (HL)                        ; Take 1 from counter 2
                        DEC (HL)                        ;

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get Alien encounter sequence
                        OR A                            ; CP 0?
                        JR NZ,SKIP_ENABLING_FREESTYLE_ALIEN ; Do not get ready for Freestyle aliens if already in comms with aliens


                        LD A,(COUNTER)                  ; Get general counter
                        OR A                            ;
                        JR NZ,SKIP_DECREMEMNTING_COUNTER4;



                        LD A,(COUNTER4)                 ; Used to count down FROM 1 when COUNTER =0 for timing when freestyle aliens appear
                        CP 0                            ;
                        JR Z,SKIP_DECREMEMNTING_COUNTER4 ; Do not count down counter4 if already 0
                        DEC A                           ; Take 1 from counter4
                        LD (COUNTER4),A                 ; Update counter4


                        LD A,(SHIELDS_ON)               ; Get Shields on/off
                        OR A                            ; Are shields off?
                        JR Z,SKIP_DECREMEMNTING_COUNTER4 ; If not then skip reducing power

                        CALL TAKE_1_FROM_POWER_METER    ; Take 1 from power


SKIP_DECREMEMNTING_COUNTER4:
; Check to see if we are on sector 0 as we dont want aliens on sector 0
                        LD A,(MAP_SELECT_STORE_NUMBER_b30583) ; Get sector pointer
                        OR A                            ; Are we on sector 0?
                        JR Z,SKIP_ENABLING_FREESTYLE_ALIEN ; If so then skip freestyle aliens

                        CALL MEMORY_SWITCH_4            ;
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get current sector value into A
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_ENABLING_FREESTYLE_ALIEN ; Skip freestyle aliens if not 0

                        LD A,(COUNTER4)                 ; Get Counter4
                        ;   push af
                        ;   ld b,a
                        ;   call DISPLAY_NUMBER
                        ;    pop af

                        CP 1                            ; Is counter at 1?
                        JR NZ,SKIP_SETTING_WARNING_ON_FOR_FREESTYLE_ALIENS;
                        CALL SWITCH_WARNING_ON          ;
                        JP SKIP_ENABLING_FREESTYLE_ALIEN ;

SKIP_SETTING_WARNING_ON_FOR_FREESTYLE_ALIENS:
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_ENABLING_FREESTYLE_ALIEN ; If not then skip enabling Freestyle aliens

                        CALL SWITCH_WARNING_OFF         ;
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ;

                        ; Aliens appear freestyle
FREESTYLE_ALIENS:
                        CALL MEMORY_SWITCH_4            ;
                        CALL RESTORE_RADAR_POINTER_TO_CURRENT_4 ; Restore radar to current sector
SKIP_RESTORING_RADAR_POINTER:

                        LD A,(SPEEDMAX)                 ; Get Speed timer value
                        OR A                            ;
                        JR Z,SELECT_3_ALIENS            ;

                        LD B,2                          ; Setup loop to choose how many freestyle aliens to spawn
                        JP FREESTYLE_ALIEN_SPAWN_LOOP   ;
SELECT_3_ALIENS:

                        LD B,4                          ; Setup loop to choose how many freestyle aliens to spawn

FREESTYLE_ALIEN_SPAWN_LOOP:
                        PUSH BC                         ;
                        CALL ADD_1_TO_ICON              ; Add 1 to icon to add ship count in icon and Display Radar icons
                        POP BC                          ;
                        DJNZ FREESTYLE_ALIEN_SPAWN_LOOP ; Jump back to add aliens

                        CALL ENABLE_ALIENS              ; Check to see if we need to enable aliens

                        CALL MEMORY_SWITCH_3            ; Switch to bank 3
                        LD HL,ALIEN_NAME_6_3            ; Set Alien name to unfriendly alien
                        CALL SKIP_ADDING_TO_ALIEN_NAME_3 ; Set Unfriendly alien and name alien

                        ;   CALL SET_ALIEN_APPEARS_TO_255_UPDATE_RADAR_ICONS ; Set the Aliens appear counter so they apear after a delay when the sector is entered and update Radar icons

                        CALL MEMORY_SWITCH_4            ; Switch to bank 4

                        ; CALL SELECT_LEVEL_MESSAGE_BLANK ;
                        ; CALL DISPLAY_RADAR_ICONSB
                        CALL UPDATE_SECTOR_VALUE_4      ;
                        ;

SKIP_ENABLING_FREESTYLE_ALIEN:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reduce or charge power
                        LD A,(SPEED)                    ; Get speed
                        CP 1                            ; CP 1                            ; Are we on full power?
                        JR NZ,SKIP_MAIN_POWER_REDUCTION ; If not then skip checking to reduce power

                        LD A,(COUNTER)                  ; Get game counter
                        OR A                            ; CP 250                          ; Is it 250?
                        JR NZ,SKIP_MAIN_POWER_CHARGING  ; If not then skip reducing/charging power
                        CALL TAKE_1_FROM_POWER_METER    ; Take 1 from power
                        XOR A                           ; Setup A to 0 to stop count down Scroll show bars
                        LD (SCROLL_SHOW_BARS_ON),A      ; Set Scroll show bars to 0 to stop bars when not charging

                        JP SKIP_MAIN_POWER_CHARGING     ;

SKIP_MAIN_POWER_REDUCTION:;Jumps here if not on full power;

                        LD A,(SITES_ON)                 ; Get sites on status?
                        OR A                            ; 0 for off?
                        JR NZ,SKIP_MAIN_POWER_CHARGING  ; If not zero then skip charging power

                        LD A,(SHIELDS_ON)               ; Get Shields on/off
                        OR A                            ; Are shields off?
                        JR NZ,SKIP_MAIN_POWER_CHARGING  ; If on then skip charging power

                        LD A,(PROGRESS)                 ; Get Progress
                        CP 50                           ; Is Progress Less than 50?
                        JR NC,SKIP_SHIELD_INCREASE_WHEN_SHIELD_IS_OFF ; If so then skip adding to Sheilds

                        ;  CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD A,(COUNTER)                  ;
                        OR A                            ;
                        CALL Z,INCREASE_SHIELDS         ;

SKIP_SHIELD_INCREASE_WHEN_SHIELD_IS_OFF:
; Sites are off so check the game counter is at 150
                        LD A,(COUNTER)                  ; Get game counter
                        CP 150                          ; Is it 150?
                        JR NZ,SKIP_MAIN_POWER_CHARGING  ; If not then skip adding 1 to power
                        CALL ADD_1_TO_POWER_METER       ; Add 1 to power

; If power already full then skip charging scroller
SKIP_MAIN_POWER_CHARGING:
; Check to see is scroll charger bar counter is 0. If not then take 1 from it

                        LD HL,SCROLL_SHOW_BARS_ON       ; Get scroll bar status for power charging
                        LD A,(HL)                       ;
                        OR A                            ; Is it 0?
                        JR Z,SKIP_COUNT_DOWN_SCROLL_BAR ; If so then skip counting down scroll bar
                        DEC (HL)                        ; Take 1 from scroll bar count down

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL SCROLL_SHOW_BARS_3         ; Scroll the charger bars

SKIP_COUNT_DOWN_SCROLL_BAR:

                        LD A,(COUNTER2)                 ; Get counter2
                        CP 2                            ; Is it 2 OR LESS?
                        JR NC,SKIP_DECREMENTING_ALIEN_ENCOUNTER_COUNTER; If not then skip decrementing alien sequence counter

                        LD A,255                        ; Reset counter 2 to 255
                        LD (COUNTER2),A                 ;


                        LD HL,ALIEN_ENCOUNTER_SEQUENCE  ; Get alien encounter sequence counter
                        LD A,(HL)                       ;
                        OR A                            ; Is it 0?
                        JR Z,SKIP_DECREMENTING_ALIEN_ENCOUNTER_COUNTER; If so then skip decrementing Alien Encounter Sequence counter
                        DEC (HL)                        ; Take 1 from Alien Encounter Sequence
                        ;  LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Update Alien Encounter Sequence

SKIP_DECREMENTING_ALIEN_ENCOUNTER_COUNTER:

                        LD HL,DRAW_RING_ON              ; Get transaction ring status
                        LD A,(HL)                       ;
                        OR A                            ; Is it 0 for off?
                        JR Z,SKIP_DECREMENTING_DRAW_RING; If so then skip taking 1 from the transaction ring countdown
                        DEC (HL)                        ; Take 1 from the transaction ring countdown
                        ;   LD (DRAW_RING_ON),A             ; Update the transaction ring countdown

SKIP_DECREMENTING_DRAW_RING:
; Do we need to display the snow text screen?

                        LD A,(SNOW_TEXT_SCREEN_ON)      ; Is text screen interference enabled?
                        OR A                            ; CP 0                            ;
                        CALL NZ,SNOW_TEXT_SCREEN        ; Display interference if so

; Add 1 to game counter
                        ; POP AF                          ; Restore counter
                        LD HL,COUNTER                   ; Get 0 to 255 counter
                        INC (HL)                        ; Increment 0 to 255 counter
                        LD A,(HL)                       ; Update counter

; Check to enable spining hour glass icon
                        CP 220                          ; Is it 220?
                        JR NZ,SKIP_ENABLE_SPINING_ICON  ; If not then skip setting spining icon to on

                        LD A,R                          ;
                        CP 50                           ;
                        JR NC,SKIP_ENABLE_SPINING_ICON  ;

                        LD A,(MESSAGE_STATUS)           ; Get message status
                        OR A                            ; Is it off?
                        JR NZ,SKIP_DISABLE_SPINING_ICON ; If on then we dont want spining icon

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get Alien encounter sequence
                        OR A                            ; CP 0?
                        JR NZ,SKIP_ENABLE_SPINING_ICON  ; No hour glass if we are in an alien encounter

; Enable spining hour glass
                        LD A,1                          ;
                        LD (SPINING_ICON_STATUS),A      ; Enable spining icon

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;

                        JP SKIP_DISABLE_SPINING_ICON    ; Jump the disable spining icon
SKIP_ENABLE_SPINING_ICON:
                        LD A,(SPINING_ICON_STATUS)      ; Get spining icon status
                        CP 0                            ; Is it off?
                        JR Z,SKIP_DISABLE_SPINING_ICON  ; Skip disabling spinning icon if it is not enabled


                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        RRA                             ;
                        RRA                             ;
                        OR A                            ;
                        JR NZ,SKIP_DISABLE_SPINING_ICON ;
                        XOR A                           ; A=0
                        LD (SPINING_ICON_STATUS),A      ; Disable spinning icon
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;          ;
                        LD A,(LAST_MESSAGE_STATUS)      ; Get last message status
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
SKIP_DISABLE_SPINING_ICON:
; Do we need to flash the warning light?
                        LD A,(SET_WARNING_ON)           ; Is flashing warning enabled?
                        OR A                            ; CP 0                            ;
                        CALL NZ,FLASH_WARNING           ; Call warning flip flop if so
; Do we need to flash the Service light?
                        LD A,(SET_SERVICE_ON)           ; Is flashing SERVICE enabled?
                        OR A                            ; CP 0                            ;
                        CALL NZ,FLASH_SERVICE           ; Call SERVICE flip flop if so


; Do we need to display a message on the LCD?
                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Display text slowly with cursor in main text window until (MESSAGE_STATUS)=0 B=colour

; Check to see if we need to move sector selector
                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_MOVING_SECTOR_SELECTOR ; If not then we must not allow moving sector selector

                        CALL MOVE_SECTOR_SELECTOR_c30584 ; Move sector select cursor
SKIP_MOVING_SECTOR_SELECTOR:

; Check to see if we need to do anything with the Radar move timer. Do we need to set the radar back if no L key is pressed after a few seconds
                        LD A,(RADAR_MOVE_TIMER)         ; Get radar move timer
                        ;  push af
                        ;  ld b,a
                        ;  call DISPLAY_NUMBER
                        ;   pop af


                        CP 0                            ; Is it 0?
                        JR Z,SKIP_DECREMENTING_RADAR_MOVE_TIMER ; If 0 then skip decrementing it
                        DEC A                           ; Take 1 from timer
                        LD (RADAR_MOVE_TIMER),A         ; Update the timer
                        CP 1                            ; Is timer at 1?
                        JR NZ,SKIP_DECREMENTING_RADAR_MOVE_TIMER ; Skip reseting the timer if not
                        XOR A                           ; Set A to 0 to reset timer
                        LD (RADAR_MOVE_TIMER),A         ; Reset the timer to 0


                        LD A,(MAP_SELECT_STORE_NUMBER_b30583); Get current sector
                        LD (RADAR_SELECT_SECTOR_STORE),A; Update sector store

                        CALL MEMORY_SWITCH_4            ;
                        CALL RESTORE_RADAR_POINTER_TO_CURRENT_4 ; Reset Radar pointer to current sector

SKIP_DECREMENTING_RADAR_MOVE_TIMER:



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check for Hyperdrive selected  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD A,(GAME_MODE)                ; Get game mode
                        OR A                            ; Is it 2D mode?
                        JR NZ,SKIP_SETTING_HYPERSPEED_TO_ON ; Skip checking to enable Hyperdrive if so

                        LD A,(HYPERDRIVE)               ; Get Hyperdrive counter
                        OR A                            ; CP 0                            ; If Hyperdrive at 0?
                        JR NZ,SKIP_SETTING_HYPERSPEED_TO_ON ; Skip checking to enable Hyperdrive if so

                        CALL GET_KEYS_H_TO_L_c30715     ; Check key press
                        BIT 3,A                         ; Is key "J" pressed?
                        JR NZ,SKIP_SETTING_HYPERSPEED_TO_ON ; If not then jump to skip selecting Hyperspeed to on

                        CALL HYPERDRIVE_ON              ; Set Hyperdrive to on

                        ;  CALL NEXT_TORPEDO0     ;Flash screen


                        XOR A                           ; Set A to 0 to reset timer
                        LD (RADAR_MOVE_TIMER),A         ; Reset the timer to 0

SKIP_SETTING_HYPERSPEED_TO_ON:; Check to see if we need to count down the Hyperdrive counter;

                        LD A,(HYPERDRIVE)               ; Get Hyperdrive counter
                        OR A                            ; CP 0                            ; If Hyperdrive at 0?
                        JP Z,SKIP_COUNTING_DOWN_HYPERDRIVE ; Skip decrementing Hyperdrive if so
                        DEC A                           ; Decrement Hyperdrive
                        LD (HYPERDRIVE),A               ; Update Hyperdrive

                        CP 1                            ; Is Hyperdrive at 1?
                        JR NZ,SKIP_SETTING_HYPERDRIVE_OFF ; If not then skip setting Hyperdrive to off

                        CALL HYPERDRIVE_OFF             ;
                        JP SECTOR_START                 ;

SKIP_SETTING_HYPERDRIVE_OFF:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_COUNTING_DOWN_HYPERDRIVE:
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fast clear-screen routine
; Uses the stack to block clear memory

                        ; FOR HYPERDRIVE''''''''''''''''''''
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; Is if 0 for off?
                        JR Z,UPDATE_SCREEN              ; If off then jump to normal screen updates


                        CP 5                            ; Is it 5?
                        JR Z,DECREMENT_POWER_HYPERDRIVE ; Decrement from power meter if so
                        CP 25                           ; Is it 25?
                        JR Z,DECREMENT_POWER_HYPERDRIVE ; Decrement from power meter if so
                        CP 50                           ; Is it 50?
                        JR Z,DECREMENT_POWER_HYPERDRIVE ; Decrement from power meter if so

                        JP ss                           ; If not then skip reducing power

DECREMENT_POWER_HYPERDRIVE:
                        CALL TAKE_1_FROM_POWER_METER    ; Take 1 from power
                        ;
                        JP ss                           ; SKIP_CLEAR_BUFFER                   ;If on then skip deleting display buffer to make lines of stars


; Clear screen buffer
UPDATE_SCREEN:
                        DI                              ;
                        ;
                        LD (SET_STACK_POINTER+1),SP     ; Save the stack
                        LD SP,SCREEN1+4096              ; Set stack pointer to end of screen buffer



                        LD HL,0                         ; Set HL to 0 to clear the buffer
                        LD B,32                         ; 128                        ; Set loop counter
; Fill the memory
PUSHLOOP:
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2

                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2

                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2

                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2

                        DJNZ PUSHLOOP                   ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Fast clear-screen routine
; Uses the stack to block clear memory

                        DI                              ;
; Save the stack pointer
                        LD SP,ATTR1+511                 ; e.g. to fill from &C000 to &FFFF (&4000 bytes), set SP to &FFFF+1 = &0000

; Define the region of RAM to be filled
                        LD H,71                         ; Bright white ink on black paper
                        LD L,71                         ;

                        LD B,8                          ; 8 memory location blocks                         ;
; Fill the memory
PUSHLOOP2:
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2

                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2
                        PUSH HL                         ; Writes HL to (SP-2) and DECs SP by 2



                        DJNZ PUSHLOOP2                  ;
SET_STACK_POINTER:
                        LD SP,(0)                       ; Restore the stack



                        EI                              ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ss:




                        LD A,(GAME_MODE)                ; Get game mode 0 for normal or 1 for side scroller
                        CP 1                            ; Are we side scrolling?
                        JP NZ,SKIP_SIDE_SCROLLER        ; If not then skip side scroller
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SIDE SCROLLER SECTION



; The empty buffer containing the planet graphics is copied to the buffer

                        CALL COPY_EMPTY_BUFFER_TO_BUFFER; Copy the empty buffer to the display buffer so we can scroll the planet
                        LD A,(SPEED)                    ; Get speed 0 to 5
                        LD B,A                          ; Save to B
                        LD A,6                          ; 5-B=speed
                        SUB B                           ;
                        LD (SIDE_SPRITES_SPEED+1),A     ; Set side sprites speed
                        LD (SIDE_ALIEN_FIRE_SPEED+1),A  ; Set side alien fire speed
                        LD B,A                          ;
SC2:
                        PUSH BC                         ;
; Scroll blank buffer left for next time
                        LD B,63                         ; 63 lines to scroll                       ;
                        LD HL,SCREEN1_EMPTY+2048        ; Point at bottom half of blank buffer where planet graphics are
SC1:
                        PUSH HL                         ;
                        POP DE                          ;

                        PUSH BC                         ;
                        LD A,(HL)                       ;
                        INC L                           ; WAS INC HL!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                        LD BC,31                        ;

                        LDIR                            ;

                        LD (DE),A                       ;
                        POP BC                          ;

                        DJNZ SC1                        ; Jump back to complete scrolling
                        POP BC                          ;
                        DJNZ SC2                        ; Jump back to complete scrolling
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display sprites for aliens and items
                        CALL MEMORY_SWITCH_0            ; Memory switch 3
                        LD IX,SIDE_SCROLLING_SPRITE_DATA_0 ; Start address for side scrolling sprite data

DISPLAY_SPRITES_LOOP1:
                        CALL MEMORY_SWITCH_0            ; Memory switch 3
                        LD A,(IX+0)                     ; Get sprite data for start of block
                        CP 255                          ; Are we at the end of the data?
                        JP Z,END_DISPLAY_SPRITES_SIDE_SCROLLING ; Jump out of sprite routine if so

; Only enable the sprite if it is not already enabled
                        BIT 0,A                         ; Is sprite already enabled?
                        JR NZ,DISPLAY_SPRITES_JUMP      ; If so then jump the rest of the enable checks

; Enable the sprite if its enable data equals the Game Counter2
                        LD HL,COUNTER                   ; Get game counter
                        LD A,(IX+3)                     ; Get sprite counter
                        CP (HL)                         ; Compare with game counter
                        JR NZ,JUMP_ENABLE_SPRITE        ; If equals game counter then enable sprite
; Enable sprite
                        SET 0,(IX+0)                    ; Set data to enabled for current sprite
                        JP DISPLAY_SPRITES_JUMP         ; Jump to display sprite

JUMP_ENABLE_SPRITE:
; Jumps here if sprite is already enable
                        BIT 0,(IX+0)                    ; Is sprite enabled?
                        JP Z,ALIEN_FIRE_CHECK           ; Jump to check firing if not

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DISPLAY_SPRITES_JUMP:   ;Direction 0 for left, 1 for right 2 for left up/down, 3 for right up/down;
                        ; Check if sprite is at far left
                        LD A,(IX+2)                     ; Get sprite left/right
                        CP 4                            ; Is sprite at far left?
                        JP C,DISABLE_RESET_SPRITE_WITH_JUMPBACK ; If so then reset it and jump back to move to next sprite

                        LD B,(IX+5)                     ; Get sprite speed
; Move sprite left
                        SUB B                           ; Subtract speed to move sprite left
SIDE_SPRITES_SPEED:
                        SUB 0                           ; Sub side sprite speed to move sprite fast or slow depending on speed
                        LD(IX+2),A                      ; Move sprite left

; Sprite left and falling
                        LD A,(IX+1)                     ; Get sprite up/down coordinate
                        CP 40                           ; Is it above ground level?
                        JP NC,MOVE_SPRITE_LEFT_NO_FALL  ; If so then jump to move sprite left
; Sprite may be falling
                        LD A,R                          ; A=Random number
                        CP 50                           ; Is number above 50?
                        JR C,MOVE_SPRITE_LEFT_NO_FALL   ; If not then jump fall

                        INC (IX+1)                      ; Move sprite down 1 pixel
                        ; LD A,(IX+1)                     ; Get sprite up/down coordinates
                        ; INC A                           ; Move sprite coordinate down 1 pixel
                        LD A,(IX+1)                     ; Update sprite up/down coordinates
                        CP 90                           ; Is sprite at bottom of screen?
                        JP NC,DISABLE_RESET_SPRITE_WITH_JUMPBACK ; If so then reset it and jump back to move to next sprite

MOVE_SPRITE_LEFT_NO_FALL:
                        LD A,(IX+2)                     ; Get y coordinate for current sprite
                        CP 8                            ; Is sprite at far left?
                        JP C,DISABLE_RESET_SPRITE_WITH_JUMPBACK ; If so then reset it and jump back to move to next sprite

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check to see if up/down required
                        XOR A                           ; LD A,0


                        LD (UP_DOWN_TEMP),A             ; Save addition for up/down
                        LD A,(IX+4)                     ; Get sprite travel direction indicator
                        CP 0                            ; Is sprite traveling left with no up/down?                                  ;Is sprite traveling left with no up/down?
                        JR Z,NO_UP_DOWN                 ; Jump up/down code if not required

; Start of Up/Down movement
                        LD HL,UP_DOWN_COUNTER           ; Get up/down counter
                        INC (HL)                        ; Add 1 to up/down counter
                        LD A,(HL)                       ; Get up/down counter
                        CP 60                           ; Does up/down counter=16?
                        CALL Z,RESET_UP_DOWN_COUNTER    ; If so then reset the up/down counter
                        CP 30                           ; Is it 16 or greater?
                        CALL NC,UP_DOWN_SETTING_DOWN    ; Take 1 from up/down coordinate to move sprite up
                        ; Is it less than 16
                        CALL C,UP_DOWN_SETTING_UP       ; Add 1 to up/down coordinate to move sprite down

                        LD A,(UP_DOWN_SETTING)          ; Get up/down coordinate
                        LD (UP_DOWN_TEMP),A             ; Update up/down store

; Jumps here if there is no up/down
NO_UP_DOWN:

                        LD A,(UP_DOWN_TEMP)             ; Get sprite temporary up down sign wave coordinate
                        LD B,A                          ; Store in B
NO_UP_DOWN2:            LD A,(IX+1)                     ; Get the sprite x coordinate
                        ADD A,B                         ; Add the temporary to sprite up/down coordinate

; Display sprite
                        LD (dispx+1),A                  ; Set the varable for the sprite x coordinate
                        LD A,(IX+2)                     ; Get the sprite y coordinate
                        LD (dispy+1),A                  ; Set the varable for the sprite y coordinate

                        ; LD A,(IX+7)                   ; Get sprite colour flag
                        ; OR A                          ; Does it equal anything apart from zero?
                        ; CALL NZ,COLOUR_SPRITE         ; If so then colour the sprite
; Select sprite data
                        ; LD A,(NASTY_FRAME_COUNT)        ; Get sprite frame counter

                        LD L,(IX+9)                     ; Set sprite graphic frame 0 address
                        LD H,(IX+10)                    ;


SKIP_SELECTING_FRAME1:

                        CALL sprite                     ; Display sprite if it is enabled

; Check for Cygnus colliding with side scrolling sprites

                        CALL COLLISION_CHECK            ; Check collision


ALIEN_FIRE_CHECK:
; Check if Alien should fire SIDE SCROLLER

                        BIT 0,(IX+0)                    ; Get alien enabled status, IS BIT 0 SET TO ON?
                        JR Z,SKIP_ENABLING_ALIEN_FIRE   ; If alien not enabled then alien cannot fire
; Sprite is enabled so can fire if it is an alien
                        LD A,(IX+6)                     ; Get sprite type
                        CP 1                            ; Is it alien?
                        JR NZ,SKIP_ENABLING_ALIEN_FIRE  ; If not then we are not going to be firing
; This is an alien
                        BIT 7,(IX+0)                    ; Get alien fire status IS BIT 7 ON?
                        JR NZ,SKIP_ENABLING_ALIEN_FIRE  ; If 1 alien is already firing then skip enabling alien fire routine
; Is alien on visible screen? If not then dont fire. Fire only if on visible screen
                        LD A,(IX+2)                     ; Get sprite left/right
                        CP 160                          ; Is sprite in physical screen less than 160?
                        JR C,SKIP_ENABLING_ALIEN_FIRE   ; If not then we are not going to be firing

; This is an alien and it is not already firing.
; Get a random number. If it is less than 5 then make the current alien fire

                        LD A,R                          ; Get random number
                        CP 5                            ; Compare with 5, Is less than 5?
                        JP NC,SKIP_ENABLING_ALIEN_FIRE  ; Skip setting alien to fire if so
                        ; CALL SIDE_SCROLLING_ALIEN_FIRING ; Set side scrolling alien to fire

                        ; BIT 7,(IX+0)                     ; Get alien fire status
                        ; JP Z,SPRITE_INCREMENT           ; If 0 then skip alien fire routine

; Set side scrolling alien to fire
SIDE_SCROLLING_ALIEN_FIRING:
                        SET 7,(IX+0)                    ; Set alien firing flag

; SET_ALIEN_FIRE_COORDINATES:
                        LD A,(IX+1)                     ; Get sprite x
                        LD (IX+7),A                     ; Copy alien X coordinate to byte 7 of sprite data
                        LD A,(IX+2)                     ; Get sprite y
                        LD (IX+8),A                     ; Copy alien y coordinate to byte 7 of sprite data

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SKIP_ENABLING_ALIEN_FIRE:;Jumps here if not an alien or Alien fire is already happening;

                        BIT 7,(IX+0)                    ; Get alien fire status
                        JP Z,SPRITE_INCREMENT           ; If 0 then skip alien fire routine
; Alien is firing

                        LD HL,SIDE_SCROLLING_ALIEN_MISSILE ; Side scrolling alien missile graphic

                        LD A,(IX+7)                     ; Get alien ship up/down
                        LD (dispx+1),A                  ; Set sprite to X coordinate
                        LD A,(IX+8)                     ; Get alien ship left/right
                        LD (dispy+1),A                  ; Set sprite to Y coordinate
                        LD A,1                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;

                        CALL sprite                     ; Draw missile
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;    LD A,(WE_ARE_HIT_COUNTDOWN)
                        ;      LD B,0
                        ;      LD C,A
                        ;      CALL DISPLAYNUMBER
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check for Cygnus colliding with side scrolling alien fire

                        CALL COLLISION_CHECK2           ; Check colision

; Move alien missile down if random number met
                        LD A,R                          ; Get random
                        CP 20                           ; Is it 20 ?
                        JR NC,SKIP_MOVING_ALIEN_MISSILE_DOWN ; If not then skip moving missile down
                        INC (IX+7)                      ; Move alien missile down 1 pixel

; Move alien missile left
SKIP_MOVING_ALIEN_MISSILE_DOWN:
                        LD A,(IX+8)                     ; Move alien missile left
                        SUB 4                           ; Take 4 pixel spaces from A
SIDE_ALIEN_FIRE_SPEED:
                        SUB 0                           ; Take side speed to move missile left depending on speed
                        LD (IX+8),A                     ; Move alien missile left
                        CP 8                            ; Is missile near left of screen?
                        CALL C,SIDE_SCROLLING_DISABLE_ALIEN_FIRING ; Reset missile if so

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get ready for next sprite
SPRITE_INCREMENT:
                        LD A,(PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER) ; Get side scroller takeoff counter
                        CP 0                            ;
                        JR Z,SKIP_TAKING_OFF_2          ;

; We are leaving the planet so scroll all the sprites down also
                        LD A,(IX+1)                     ; Is sprite already at bottom of the screen?
                        CP 120                          ;
                        JR NC,SKIP_TAKING_OFF_2         ; If so then dont move sprite down any more

                        INC (IX+1)                      ; Move sprite down 1 pixel

                        LD A,(IX+7)                     ; Is alien missile at bottom of screen?
                        CP 120                          ;
                        JR NC,SKIP_TAKING_OFF_2         ; If so then dont move alien missile down screen

                        INC (IX+7)                      ; Move alien missile down screen
SKIP_TAKING_OFF_2:

                        LD A,(IX+0)                     ; Get current alien enabled status
                        BIT 0,A                         ; Is alien enabled?
                        JR Z,SKIP_CHECK_CYGNUS_MISSILE_HITTING_ALIEN ; Skip checking for Cygnus missile hitting alien if so

; Are we checking to see if Cygnus fire has hit an alien?
                        LD A,(IX+6)                     ; Get colission status of sprite
                        CP 1                            ; Alien?
                        JR NZ,SKIP_CHECK_CYGNUS_MISSILE_HITTING_ALIEN; Skip checking Cygnus fire hits alien if not

                        LD A,(FIRE_ON)                  ; Get player fire status
                        CP 0                            ; Are we firing?
                        JR Z,SKIP_CHECK_CYGNUS_MISSILE_HITTING_ALIEN;

                        CALL NZ,COLLISION_CHECK3        ; Check to see if Cygnus missile is hitting an alien

SKIP_CHECK_CYGNUS_MISSILE_HITTING_ALIEN:

                        LD BC,11                        ; Setup BC for addition
                        ADD IX,BC                       ; Add 25 to sprite data for next sprite

                        JP DISPLAY_SPRITES_LOOP1        ; Jump back to check next sprite if a>0

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; END OF DISPLAYING SIDE SCROLLING SPRITES
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
END_DISPLAY_SPRITES_SIDE_SCROLLING:
; Display ship
                        LD A,(WE_ARE_HIT_COUNTDOWN)     ; Get We are hit countdown
                        BIT 0,A                         ;
                        JR NZ,SKIP_DISPLAYING_CYGNUS    ; Skip flashing the cockpit if so

                        CALL MEMORY_SWITCH_0            ; Memory switch 3
                        LD HL,SHIPGRAPHICS_MASK_A_0     ; Mask

                        LD A,(SP1X_SHIP)                ; Get Horace X coordinate
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(SP1Y_SHIP)                ; Get Horace Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        LD A,2                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite
                        ; CALL NZ,HIT
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD HL,SHIPGRAPHICS_A_0          ;
                        LD A,(SP1X_SHIP)                ; Get Horace X coordinate
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(SP1Y_SHIP)                ; Get Horace Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        LD A,1                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite
                        ; CALL NZ,HIT




                        LD HL,SHIPGRAPHICS_MASK_B_0     ;
                        LD A,(SP1X_SHIP)                ; Get Horace X coordinate
                        ADD A,16                        ;
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(SP1Y_SHIP)                ; Get Horace Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        LD A,2                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite
                        ; Display sprite
; ;;;;;;;;;;;;;;;;;;;;;;;
; Display ship


                        LD HL,SHIPGRAPHICS_B_0          ;
                        LD A,(SP1X_SHIP)                ; Get Horace X coordinate
                        ADD A,16                        ;
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(SP1Y_SHIP)                ; Get Horace Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        LD A,1                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite

SKIP_DISPLAYING_CYGNUS:
; Jump here to skip displaying Cygnus if hit to make Cygnus flash


; Anything after here is not checked for colission;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check to see if we are hit and need to flash Cygnus
                        LD HL,WE_ARE_HIT_COUNTDOWN      ; Get We are hit countdown
                        LD A,(HL)                       ; Update We are hit countdown
                        OR A                            ; Is it at 0?
                        JR Z,SKIP_FLASHING_CONSOLE_WHEN_HIT2 ; Skip flashing the cockpit if so
                        DEC (HL)                        ;

SKIP_FLASHING_CONSOLE_WHEN_HIT2:

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DRAW_STARS_DATA1_SIDE_SCROLLER_6 ; draw over 0 snow from data 1
                        CALL UPDATE_DATA_1_SIDE_SCROLLER_6 ; update data 1

                        LD A,(DIRECTION)                ; DIRECTION bits 0-up, 1-down, 2-left, 3-right
                        LD B,A                          ; Save Direction
                        BIT 1,B                         ; Moving down?
                        CALL NZ,MOVEDOWN                ; Call move down routine if so

                        ; LD A,B;(DIRECTION)     ;DIRECTION bits 0-up, 1-down, 2-left, 3-right
                        BIT 0,B                         ; Moving up?
                        CALL NZ,MOVEUP                  ; Call move up routine if so

                        ; LD A,B;(DIRECTION)     ;DIRECTION bits 0-up, 1-down, 2-left, 3-right
                        BIT 3,B                         ; Moving right?
                        CALL NZ,MOVERIGHT               ; Call move right routine if so

                        ; LD A,B;(DIRECTION)     ;DIRECTION bits 0-up, 1-down, 2-left, 3-right
                        BIT 2,B                         ; Moving left?
                        CALL NZ,MOVELEFT                ; Call move left routine if so

NEXT_THINGS_2:

                        LD A,(NASTY_FRAME_COUNT)        ; Get Nasty frame counter
                        CPL                             ; flip flop Nasty frame counter
                        LD (NASTY_FRAME_COUNT),A        ; Save


; Check for P for takeoff

                        LD A,(PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER) ; Get side scroller takeoff counter
                        CP 0                            ; Is it 0?
                        JR NZ,SKIP_LEAVE_PLANET_SETUP   ; If so then we are already taking off so no need to check P key


                        LD BC,57342                     ; Port for Y, U, I, O, P
                        IN A,(C)                        ; Get key
                        ; BIT 0,A                         ; "P" pressed?
                        RRA                             ;  "P" pressed?
                        JR C,SKIP_LEAVE_PLANET_SETUP    ; If not then skip landing sequence

                        DI                              ;
                        IM 1                            ;
                        EI                              ;
                        CALL RESET_ALL_SOUNDS           ; Reset all sounds


; Setup leave planet sequence
                        LD A,64                         ; Set side scroller takeoff counter to 64 lines to scroll down
                        LD (PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER),A ; Get side scroller takeoff counter


SKIP_LEAVE_PLANET_SETUP:
; Are we leaving the planet?

                        LD A,(PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER) ; Get side scroller takeoff counter
                        CP 0                            ; Is it 0?
                        JR Z,SKIP_LEAVE_PLANET          ; If so then we are not leaving the planet so skip the following


; We are leaving the planet

                        CALL SCROLL_BLANK_BUFFER_DOWN:  ; Scroll down the play area 1 pixel
                        LD A,(PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER) ; Get side scroller takeoff counter
                        DEC A                           ; Take 1 from side scroller takeoff counter
                        LD (PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER),A ; Update side scroller takeoff counter
                        CP 1                            ;
                        JR NZ,SKIP_SETTING_LEAVE_PLANET_TO_OFF ; If not then skip setting the leave planet to off


                        XOR A                           ; A=0
                        LD (PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER),A ; Set side scroller takeoff counter to 0
                        LD (GAME_MODE),A                ; Set game mode back to 3D

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL SETUP_START_STARS_6        ;

                        CALL ERASE_SECTOR               ;


SKIP_SETTING_LEAVE_PLANET_TO_OFF:
; Allow registry in 3D mode?
SKIP_LEAVE_PLANET:
                        LD A,(LED_STATUS_SCREEN)        ; Get LED screen Status
                        OR A                            ;
                        JR Z,SKIP_DISPLAYING_REGISTRY   ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL DISPLAY_LED_SCREEN_3       ;


SKIP_DISPLAYING_REGISTRY:
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jumps here to skip the side scroller
SKIP_SIDE_SCROLLER:

                        LD A,(GAME_MODE)                ; Get game mode 0 for normal or 1 for side scroller
                        OR A                            ; Are we side scrolling?
                        JP NZ,SKIP_3D_SECTION           ; If not then skip side scroller

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;3D Section



                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; CP 0
                        JP NZ,SKIP_DRAWING_ALIENS       ; If on then skip some checks

                        LD A,(SERVICES_ON)              ; Get Services status
                        OR A                            ; CP 0                            ;
                        JP Z,SKIP_DISPLAYING_SHIP_DIAGRAM;
                        CALL DISPLAY_TEXT_ONE_BY_ONE_LARGE_SCREEN; ;Display Services message if not off

SKIP_DISPLAYING_SERVICES_TEXT:
                        LD A,(SERVICES_ON)              ; Get Services status
                        CP 254                          ; Is Services=254 to copy ship diagram to empty buffer?
                        JR NZ,SKIP_DISPLAYING_SHIP_DIAGRAMA ; If not 254 then skip displaying ship diagram
                        ; LD A,7                          ;
                        CALL CLEAR_EMPTY_BUFFER         ; Clear empty screen buffer ready for ship diagram

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL COPY_SHIP_DIAGRAM_TO_BLANK_BUFFER_6;

                        LD A,253                        ; A=253 to display ship diagram
                        LD (SERVICES_ON),A              ; Set Services status to 253 to display ship diagram


SKIP_DISPLAYING_SHIP_DIAGRAMA:

                        LD A,(SERVICES_ON)              ; Get Services status
                        CP 253                          ;
                        JP NZ,SKIP_DISPLAYING_SHIP_DIAGRAMB ; If not 2 then skip displaying ship diagram

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy the empty buffer to the display buffer
COPY_EMPTY_BUFFER_TO_BUFFER2B:

UPDATESCREENONLY2B:
                        LD HL,SCREEN1_EMPTY             ; Point to screen buffer
                        LD DE,SCREEN1                   ; Point to displayed screen
                        LD BC,4096                      ; 4096 bytes to copy

SCREENUPDATELOOP2B:
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer

                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer


                        JP PE,SCREENUPDATELOOP2B        ; Jump back until all buffer is done
                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL COLOUR_DIAGRAM_6           ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check for keys N and M to move Services screens
SKIP_DISPLAYING_SHIP_DIAGRAMB:
                        LD A,(SERVICES_ON)              ; Get Services status
                        CP 254                          ; Is Services already displaying text
                        JR Z,DONT_SUBTRACT_SERVICES_SCREEN_PAGE ; Skip enabling the text if so

                        CALL GET_KEYS_B_TO_SPACE        ;       N3 M2
                        BIT 4,A                         ; B pressed?
                        JR NZ,DONT_SUBTRACT_SERVICES_SCREEN_PAGE ; Return if so
                        LD A,254                        ;
                        LD (SERVICES_ON),A              ;
                        CALL GET_MESSAGE_POINTER_LARGE_SCREEN2 ; Set text for Service screen 2
                        JP SKIP_DISPLAYING_SHIP_DIAGRAM ;

DONT_SUBTRACT_SERVICES_SCREEN_PAGE:
                        LD A,(SERVICES_ON)              ; Get Services status
                        CP 255                          ; Is Services already displaying text
                        JR Z,DONT_INCREMENT_SERVICES_SCREEN_PAGE ; Skip enabling the text if so

                        CALL GET_KEYS_B_TO_SPACE        ; Get keys for Services pages 1 or 2
                        BIT 3,A                         ; N pressed?
                        JR NZ,DONT_INCREMENT_SERVICES_SCREEN_PAGE ; Return if so
                        LD A,255                        ; Setup A to set services to display text
                        LD (SERVICES_ON),A              ; Set services to display text
                        ; LD A,7                          ;
                        CALL CLEAR_EMPTY_BUFFER         ; Clear the empty buffer
                        CALL GET_MESSAGE_POINTER_LARGE_SCREEN;  ;Set text for Service screen 1

DONT_INCREMENT_SERVICES_SCREEN_PAGE:


SKIP_DISPLAYING_SHIP_DIAGRAM:


; Draw aliens

                        ; PUSH HL
                        ; PUSH BC

                        ; LD A,(ALIEN_TRACK_LOCK_TIMER)
                        ; LD A,(LASER_METER_STORE)        ;
                        ; LD A,(SHIELDS_METER_STORE)      ;
                        ; LD A,(POWER_STATUS)        ;
                        ; LD A,(ALIEN_SHIP_1_UP_DOWN)
                        ; LD A,(ALIEN_TRACK_LOCK_TIMER)
                        ; LD A,(LEVEL)
                        ; LD A,(SERVICES_ON)
                        ;   LD A,(WE_ARE_HIT_COUNTDOW
                        ;   LD B,0
                        ;   LD C,A
                        ;  CALL DISPLAYNUMBER
                        ; POP BC
                        ; POP HL

                        LD A,(CURRENT_SECTOR_VALUE)     ; Get current sector status
; We cannot have this checking or the last alien will not explode, so next 2 lines remarked out
                        ;  OR A                            ; CP 0 - Is there nothing going on
                        ;  JP Z,SKIP_DRAWING_ALIENS        ; If so then skip drawing aliens

                        CP 5                            ; Planets?
                        JP NC,SKIP_DRAWING_ALIENS       ; If so then skip drawing aliens

; We have aliens to display;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Count down the aliens appear counter
                        LD HL,ALIENS_APPEAR_COUNTER     ; Get aliens appear counter
                        ;   out (254),a
                        LD A,(HL)                       ; Get aliens appear counter for testing
                        OR A                            ; Is aliens appear counter at 0?
                        JR Z,SKIP_ALIENS_APPEAR_COUNTER_COUNTDOWN ; If alien appears counter = 0 then skip counting down
                        DEC (HL)                        ; Take 1 from aliens appear counter

SKIP_ALIENS_APPEAR_COUNTER_COUNTDOWN:;Jump here when Alien appear counter =0 for no more countdown;
                        LD A,(HL)                       ; Get aliens appear counter for testing
                        CP 50                           ; Is Alien appears counter at 50?
                        JR NZ,SKIP_SELECTING_ALIEN_NAME ; If not 50 then skip we are alien name message
                        LD A,57                         ; We are alien name message
                        ; out (254),a
                        CALL GET_MESSAGE_POINTERB       ; Set the message
                        JP SKIP_WE_ARE_ALIEN_MESSAGE    ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_SELECTING_ALIEN_NAME:
; Do we need to initialize the Alien Encounter sequence?
                        CP 1                            ; Is Alien appears counter at 1?
                        JR NZ,SKIP_WE_ARE_ALIEN_MESSAGE ; If not 1 then skip reseting Alien appears counter and initializing Alien Encounter sequuence counter
                        ; ld a,2
                        ; out (254),a

                        XOR A                           ; A=0
                        LD (ALIENS_APPEAR_COUNTER),A    ; Reset alien appears counter

                        LD A,255                        ; Setup A to set alien encounter sequence
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Set alien encounter sequence to start at 255

SKIP_WE_ARE_ALIEN_MESSAGE:
; Do not display the aliens until the Alien Appear counter is at 0
                        LD A,(ALIENS_APPEAR_COUNTER)    ; Get aliens appear counter
                        OR A                            ; CP 0                            ;
                        JP NZ,SKIP_DRAWING_ALIENS       ; If not then skip drawing aliens
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Draw 3D aliens
                        LD A,(ONE_TWO_COUNTER)          ; Get 1-2 counter
                        CPL                             ; If 0 then 255, if 255 then 0
                        LD (ONE_TWO_COUNTER),A          ; Update counter

; Draw any enabled 3D alien ships
                        LD IX,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data

                        LD A,4                          ; Alien ships max to check
                        LD (ALIEN_NUMBER),A             ; Save alien counter
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DRAW_ALIEN_SHIPS_LOOP:  ;Loop for displaying all alien ships;

; Is current alien ship enabled?
                        LD A,(IX+0)                     ; Get alien enabled flag
                        OR A                            ; CP 0 - Is the alien enabled?
                        JP Z,MOVE_TO_NEXT_ALIEN         ; If not then move to next alien

                        CP 1                            ; Alien is just flying around after being hit?
                        JP NZ,MOVE_TO_NEXT_ALIEN2       ; Jump displaying alien if so but still check if exploding

; Current alien ship is enabled

ALIEN_DISTANCE:

                        LD D,0                          ;
                        LD A,(IX+1)                     ; Get alien distance flag

                        PUSH IX                         ;
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD IX,ALIEN_SHIP_DATA_TABLE     ; Get alien graphic table refering to graphics in memory 3

                        ADD A,A                         ; Data is in groups of 4 bytes
                        ADD A,A                         ;
                        LD E,A                          ; DE=addition

                        ADD IX,DE                       ; Add addition to HL to move along table
; HL=Table address
                        LD L,(IX+0)                     ; Get graphic address into HL
                        LD H,(IX+1)                     ;
                        LD E,(IX+2)                     ; Get Animation addition into DE
                        LD D,0                          ;
                        LD B,(IX+3)                     ; Get graphic offset into B

                        POP IX                          ;
NEXT_ALIEN_SET:
; Draw Alien
                        LD A,(ONE_TWO_COUNTER)          ; Get alien ship frame counter 1-2
                        OR A                            ; CP 0                            ; Are we on second frame?
                        JR Z,SKIP_MOVING_TO_ALIEN_FRAME2 ; If so then skip moving to frame 2

                        ADD HL,DE                       ; Move to frame 2
                        ;

; HL now=correct graphic pointer

; Only display if between 125 AND 190

SKIP_MOVING_TO_ALIEN_FRAME2:

                        LD A,(IX+3)                     ; Get alien ship left/right
                        SUB B                           ;
                        LD (dispy+1),A                  ; Set sprite to Y coordinate

                        LD A,(IX+2)                     ; Get alien ship up/down
                        LD (dispx+1),A                  ; Set sprite to X coordinate
                        CP 130                          ; Up/down less than 130
                        JP C,MOVE_ALIEN                 ; If not then skip drawing double sprite
                        ; Do not display if so
                        LD A,(IX+2)                     ; Get alien ship up/down
                        CP 254                          ; Up/down less than 254
                        JP NC,MOVE_ALIEN                ; Do not display if so
                        LD A,1                          ;
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ;
                        LD A,(IX+1)                     ; Get alien distance flag
                        CP 2                            ; Is the graphic 2 sprites put together?
                        JP C,MOVE_ALIEN                 ; If not then skip drawing double sprite
; Double sprite
                        LD A,(IX+2)                     ; Get alien ship up/down
                        LD (dispx+1),A                  ; Set sprite to X coordinate
                        LD A,(dispy+1)                  ; Get alien ship left/right
                        ADD A,16                        ; Move to right
                        LD (dispy+1),A                  ; Set sprite to Y coordinate
                        LD A,(IX+2)                     ; Get alien ship up/down
                        CP 130                          ; Up/down less than 125
                        JP C,MOVE_ALIEN                 ; Do not display if so
                        LD A,(IX+2)                     ; Get alien ship up/down
                        CP 255                          ; Up/down less than 125
                        JP NC,MOVE_ALIEN                ; Do not display if so
                        LD A,1                          ;
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ;

; Triple sprite
                        LD A,(IX+1)                     ; Get alien distance flag
                        CP 4                            ; Is the graphic 2 sprites put together?
                        JP C,MOVE_ALIEN                 ; If not then skip drawing double sprite

                        LD A,(IX+2)                     ; Get alien ship up/down
                        LD (dispx+1),A                  ; Set sprite to X coordinate
                        LD A,(dispy+1)                  ; Get alien ship left/right
                        ADD A,16                        ; Move to right
                        LD (dispy+1),A                  ; Set sprite to Y coordinate
                        LD A,(IX+2)                     ; Get alien ship up/down
                        CP 130                          ; Up/down less than 125
                        JP C,MOVE_ALIEN                 ; Do not display if so
                        LD A,(IX+2)                     ; Get alien ship up/down
                        CP 255                          ; Up/down less than 125
                        JP NC,MOVE_ALIEN                ; Do not display if so
                        LD A,1                          ;
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien is now on screen. Check rest of Alien properties
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Check if alien is firing torpedo
; Are we in the middle of alien encounter sequence? If so then no alien fire
                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        OR A                            ; Is it off?
                        JR NZ,SKIP_ENABLING_ALIEN_TORPEDO; Skip enabling torpedo if in a encounter sequence

                        LD A,(IX+10)                    ; Get alien ship behavior
                        CP 4                            ; Is it 4 for disapear after an encounter?
                        JR Z,SKIP_ENABLING_ALIEN_TORPEDO; Skip enabling torpedo if it is

                        LD A,(IX+8)                     ; Get current alien torpedo enabled
                        CP 1                            ; Is it set to 1 on?
                        JR NZ,ENABLE_ALIEN_FIRING_RANDOM;


                        CALL DISPLAY_ALIEN_TORPEDO      ; Call the alien torpedo routine if so
                        JP SKIP_ENABLING_ALIEN_TORPEDO  ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make alien randomly fire torpedo 3D
ENABLE_ALIEN_FIRING_RANDOM:

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien fires near middle of play area only
                        LD A,(IX+2)                     ;
                        CP 170                          ;
                        JP C,SKIP_ENABLING_ALIEN_TORPEDO;

                        CP 200                          ;
                        JP NC,SKIP_ENABLING_ALIEN_TORPEDO;

                        LD A,(IX+3)                     ;
                        CP 10                           ;
                        JP C,SKIP_ENABLING_ALIEN_TORPEDO;

                        CP 230                          ;
                        JP NC,SKIP_ENABLING_ALIEN_TORPEDO;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Create random number to see if we need to make alien fire

                        LD A,R                          ; Get random number into A
                        CP 10                           ; Is the random number 10?
                        JR NC,SKIP_ENABLING_ALIEN_TORPEDO ; If not then skip enabling torpedo

                        CALL ENABLE_CURRENT_ALIEN_TORPEDO ; Enable current alien torpedo

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_ENABLING_ALIEN_TORPEDO:
; Alien Tracker section
                        LD A,(SITES_ON)                 ; If sites are off then skip alien tracker
                        OR A                            ; CP 0                            ;
                        JR Z,MOVE_ALIEN                 ;

; Alien tracker, Check if individual alien is being tracked and skip moving that alien if so
                        LD A,(IX+10)                    ; Get current alien sequence
                        ; LD A,(ALIEN_TRACK_LOCK_TIMER)   ; Get alien track lock timer
                        CP 255                          ; Is current alien locked on sites?
                        JP Z,MOVE_TO_NEXT_ALIEN2        ; Skip alien movement if so


; CURRENT_SEQUENCE:     ;Current game squence (IX+10)
                        ; 0=Nothing
                        ; 1=Aliens appear from back to distance
                        ; 2=Aliens appear from distance to front of ship
                        ; 3=Random (Normal)
                        ; 4=Disapear
                        ; 255=freeze on sites
MOVE_ALIEN:
; Are the aliens just coming into visibility on the screen
                        LD A,(SPECIAL_ALIEN_FRAME_COUNTER) ; Get special alien movement counter
                        OR A                            ; CP 0                            ; Is counter =0?
                        JR Z,RANDOM_ALIEN_MOVEMENT      ; Alien movement start sequence is completed if so

                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 3                            ; Is current sequence random?
                        JP NZ,SKIP_MOVING_CLOSER        ; If not random then skip random movement
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien Random movement starts here
RANDOM_ALIEN_MOVEMENT:
                        LD A,R                          ; Get random number
                        ; CALL RND
                        AND 7                           ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CP 1                            ; Is it 1?
                        JR NZ,SKIP_MOVING_DOWN          ; If not then skip moving down
                        ; Move alien up ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INC (IX+2)                      ; Move alien down
                        JP SKIP_MOVING_UP               ; Jump to skip moving up
SKIP_MOVING_DOWN:
                        CP 7                            ; Is random number 2?
                        JR NZ,SKIP_MOVING_UP            ; If not then skip moving down
; Move alien down ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVING_UP:
                        CP 3                            ; Is random number 3?
                        JR NZ,SKIP_MOVING_LEFT1         ; If not then skip moving left
; Move alien left ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        DEC (IX+3)                      ; Adjust alien ship left/right
                        JP SKIP_MOVING_LEFT             ;
SKIP_MOVING_LEFT1:
                        CP 4                            ;
                        JR NZ,SKIP_MOVING_LEFT          ;
                        INC (IX-3)                      ; Adjust alien ship left/right

; Check if movement keys are pressed
; DIRECTION bits 0-up, 1-down, 2-left, 3-right
SKIP_MOVING_LEFT:
                        LD A,(DIRECTION)                ;
                        BIT 2,A                         ;
                        JR Z,SKIP_MOVING_LEFT2          ;
                        DEC (IX+3)                      ;
SKIP_MOVING_LEFT2:
                        BIT 3,A                         ;
                        JR Z,SKIP_MOVING_RIGHT2         ;
                        INC (IX+3)                      ;

SKIP_MOVING_RIGHT2:
                        BIT 0,A                         ;
                        JR Z,SKIP_MOVING_UP2            ;
                        DEC (IX+2)                      ;
SKIP_MOVING_UP2:
                        BIT 1,A                         ;
                        JR Z,SKIP_MOVING_DOWN2          ;
                        INC (IX+2)                      ;

SKIP_MOVING_DOWN2:




; Change alien distance ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ALIEN_SHIP_4_ENABLED:   DB 0                            ; Alien ship 4 enabled
; ALIEN_SHIP_4_DISTANCE:  DB 3                            ; Alien ship 4 distance 1 to 4
; ALIEN_SHIP_4_UP_DOWN:   DB 70                           ; Alien ship 4 up/down coordinate
; ALIEN_SHIP_4_LEFT_RIGHT:DB 90                           ; Alien ship 4 left/right coordinate
; ALIEN_TORPEDO_COUNTER_4:DB 0                            ; Used to store frame
; ALIEN_TORPEDO_UP_DOWN_4:DB 0                            ; Alien torpedo up/down coordinate
; ALIEN_TORPEDO_SIZE_4:   DB 0                            ; Alien torpedo size, 4 for 4x4
; ALIEN_TORPEDO_WIDTH_4:  DB 0                            ; Alien torpedo width 4=4 COLLUMNS
; ALIEN_TORPEDO_FIRE_ENABLED_4:DB 0                       ; Set to 1 when alien is firing
; ALIEN_TORPEDO_LEFT_RIGHT_4:DB 0                         ; Set Alien torpedo left/right coordinate
; ALIEN_SHIP_4_SEQUENCE:  DB 0                            ; Sequence number denotes how the ship acts
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; CALL RELEASE_RANDOM_NUMBER
                        ;          AND 10
                        ;   LD B,0
                        ;            LD C,A
                        ;            CALL DISPLAYNUMBER

                        ; CALL RELEASE_RANDOM_NUMBER      ;

                        LD A,R                          ;
                        LD B,A                          ;
                        ;  PUSH BC
                        ;          LD B,A
                        ;        LD C,0
                        ;              CALL DISPLAY_NUMBER
                        ;  POP BC

                        LD A,(COUNTER)                  ;
                        CP 50                           ;
                        JR NZ,SKIP_MOVING_AWAY_OR_FAR   ;

                        LD A,(SPEED)                    ; Check to see how fast we are going to determine weather to bring alien closer
                        CP 1                            ; Is ship moving fast?
                        JR Z,DONT_SKIP_MOVING_CLOSER    ; If so then do not skip moving closer

SKIP_MOVING_AWAY_OR_FAR:

                        LD A,B                          ; Get random number
                        CP 32                           ; Is it 32?
                        JR NZ,SKIP_MOVING_AWAY          ; If not then do not move away
                        LD A,(IX+1)                     ; Get current alien image number
                        OR A                            ; CP 0 ; Is alien graphic farthest image
                        JR Z,SKIP_MOVING_CLOSER         ;
                        DEC (IX+1)                      ; Adjust alien ship up/down
                        JP SKIP_MOVING_CLOSER           ;

SKIP_MOVING_AWAY:
                        LD A,(COUNTER)                  ;
                        CP 20                           ;
                        JR NZ,SKIP_MOVING_AWAY_OR_FAR2  ;

                        LD A,(SPEED)                    ;
                        CP 1                            ;
                        JR Z,DONT_SKIP_MOVING_CLOSER    ;

SKIP_MOVING_AWAY_OR_FAR2:
                        LD A,B                          ; Get random number
                        CP 60                           ; Is it 60?
                        JR NZ,SKIP_MOVING_CLOSER        ;

DONT_SKIP_MOVING_CLOSER:
                        LD A,(IX+1)                     ; Get current alien image number
                        CP 6                            ; Is alien graphic closest image
                        JR NC,SKIP_MOVING_CLOSER        ;
                        INC (IX+1)                      ; Adjust alien ship DISTANCE

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_MOVING_CLOSER:     ;Jumps here when random movement is not required;

                        LD A,(SPECIAL_ALIEN_FRAME_COUNTER) ; Get special alien movement counter
                        CP 1                            ; Is counter >0?
                        JP C,SKIP_DECREMENTING_SPECIAL_ALIEN_FRAME_COUNTER;
                        DEC A                           ;
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Update alien special frame counter

; Back to distance sequence
                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 1                            ; Is current sequence back to distance?
                        JR NZ,SKIP_BACK_TO_DISTANCE_SEQUENCE ; If not back to distance sequence then skip

                        LD A,(IX+2)                     ; Get alien up/down
                        CP 180                          ; Middle of screen
                        JP NC,SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down

SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE:
                        JP C,SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE:
                        LD A,(IX+3)                     ; Get alien left/right
                        CP 110                          ; Middle of screen
                        JP C,SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE;

SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE:
                        JP NC,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;

SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE:

                        ; Move alien to distance
                        LD A,(IX+1)                     ; Get alien distance
                        CP 1                            ; Is distance 1 yet?
                        JP C,SKIP_BACK_TO_DISTANCE_SEQUENCE ; If so then skip moving to distance
                        DEC (IX+1)                      ; Move alien to distance

SKIP_BACK_TO_DISTANCE_SEQUENCE:;Jumps here when no back to distance sequence is required;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Distance to back sequence
                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 2                            ; Is current sequence distance to back?
                        JR NZ,SKIP_DISTANCE_TO_BACK_SEQUENCE ; If not distance to back sequence then skip
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD A,(IX+2)                     ; Get alien up/down
                        CP 180                          ; Middle of screen
                        JP NC,SKIP_MOVE_ALIEN_DOWN_DISTANCE_TO_BACK_SEQUENCE;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down

SKIP_MOVE_ALIEN_DOWN_DISTANCE_TO_BACK_SEQUENCE:
                        JP C,SKIP_MOVE_ALIEN_UP_DISTANCE_TO_BACK_SEQUENCE;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_DISTANCE_TO_BACK_SEQUENCE:
                        LD A,(IX+3)                     ; Get alien left/right
                        CP 110                          ; Middle of screen
                        JP C,SKIP_MOVE_ALIEN_RIGHT_DISTANCE_TO_BACK_SEQUENCE;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_DISTANCE_TO_BACK_SEQUENCE:;

SKIP_MOVE_ALIEN_RIGHT_DISTANCE_TO_BACK_SEQUENCE:
                        JP NC,SKIP_MOVE_ALIEN_LEFT_DISTANCE_TO_BACK_SEQUENCE;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;

SKIP_MOVE_ALIEN_LEFT_DISTANCE_TO_BACK_SEQUENCE:

                        ;   LD A,(SPECIAL_ALIEN_FRAME_COUNTER)
                        ;   CP 5
                        ;   JR NC,SKIP_DISTANCE_TO_BACK_SEQUENCE

                        ; Move alien to distance
                        LD A,(IX+1)                     ; Get alien distance
                        CP 6                            ; Is distance 6 yet?
                        JP NC,SKIP_DISTANCE_TO_BACK_SEQUENCE ; If so then skip moving to distance
                        INC (IX+1)                      ; Move alien to distance

SKIP_DISTANCE_TO_BACK_SEQUENCE:;Jumps here when no back to distance sequence is required;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Distance to Back 4 corners sequence. Used to end alien encounters
                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 4                            ; Is current sequence distance to Back 4 corners?
                        JP NZ,SKIP_BACK_TO_DISTANCE_SEQUENCE2 ; If not back to distance sequence then skip

                        LD A,(DRAW_RING_ON)             ; Get ring status
                        CP 0                            ; Wait for ring to finish
                        JP NZ,SKIP_BACK_TO_DISTANCE_SEQUENCE2;

                        LD A,(ALIEN_NUMBER)             ; Restore alien number
                        CP 1                            ; Are we dealing with alien 0?
                        JR NZ,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2a;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien 0
                        LD A,(IX+2)                     ; Get alien up/down
                        CP 8                            ; Top of screen?
                        JP NC,SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2a;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down
                        JP SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2a;

SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2a:

                        CP 170                          ;
                        JP C,SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2a;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2a:

                        LD A,(IX+3)                     ; Get alien left/right
                        CP 0                            ; Left of screen?
                        JP C,SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2a;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2a:

                        CP 170                          ;
                        JP NC,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2a;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;

                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;


SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2a:;         ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CP 2                            ; Are we dealing with alien 2?
                        JR NZ,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2b:;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien 1
                        LD A,(IX+2)                     ; Get alien up/down
                        CP 8                            ; Top of screen?
                        JP NC,SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2b;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down
                        JP SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2b:;

SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2b:
                        CP 170                          ;
                        JP C,SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2b;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2b:
                        LD A,(IX+3)                     ; Get alien left/right
                        CP 8                            ; Left of screen
                        JP C,SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2b;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2b:
                        CP 230                          ; Right of screen
                        JP NC,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2b;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2b:;         ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CP 3                            ; Are we dealing with alien 3?
                        JR NZ,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2c:;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien 2
                        LD A,(IX+2)                     ; Get alien up/down
                        CP 230                          ; Top of screen?
                        JP NC,SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2c;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down
                        JP SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2c:;


SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2c:
                        CP 8                            ;
                        JP C,SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2c;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2c:

                        LD A,(IX+3)                     ; Get alien left/right
                        CP 8                            ; Left of screen
                        JP C,SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2c;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;


SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2c:
                        CP 245                          ;
                        JP NC,SKIP_BACK_TO_DISTANCE_SEQUENCE2c:;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;

                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2c:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        CP 4                            ; Are we dealing with alien 3?
                        JR NZ,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien 3
                        LD A,(IX+2)                     ; Get alien up/down
                        CP 230                          ; Top of screen?
                        JP NC,SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2d;

                        INC (IX+2)                      ; Move alien down
                        INC (IX+2)                      ; Move alien down
                        JP SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_DOWN_BACK_TO_FRONT_SEQUENCE2d:
                        CP 8                            ;
                        JP C,SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2d;
                        DEC (IX+2)                      ; Move alien up
                        DEC (IX+2)                      ; Move alien up

SKIP_MOVE_ALIEN_UP_BACK_TO_FRONT_SEQUENCE2d:

                        LD A,(IX+3)                     ; Get alien left/right
                        CP 230                          ; top of screen
                        JP C,SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2d;
                        SUB 4                           ; Move alien right
                        LD (IX+3),A                     ;
                        JP SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;

SKIP_MOVE_ALIEN_RIGHT_BACK_TO_FRONT_SEQUENCE2d:
                        JP NC,SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:;
                        ADD A,4                         ; Move alien right
                        LD (IX+3),A                     ;

SKIP_MOVE_ALIEN_LEFT_BACK_TO_FRONT_SEQUENCE2d:


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Move alien to distance
                        LD A,(IX+1)                     ; Get alien distance
                        CP 0                            ; Is distance 6yet?
                        JP Z,SKIP_BACK_TO_DISTANCE_SEQUENCE2c ; If so then skip moving to back of ship


                        DEC (IX+1)                      ; Move alien to distance

SKIP_BACK_TO_DISTANCE_SEQUENCE2c:
                        LD A,(SPECIAL_ALIEN_FRAME_COUNTER) ; Get special sequence counter
                        CP 30                            ; Is it less than 30?
                        JR NC,SKIP_BACK_TO_DISTANCE_SEQUENCE2;

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISABLE_ALL_ALIENS_6       ; If so then disable aliens

                        CALL ERASE_SECTOR               ;
                        JP SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_BACK_TO_DISTANCE_SEQUENCE2:;Jumps here when no Distance to Back 4 corners sequence is required;



SKIP_DECREMENTING_SPECIAL_ALIEN_FRAME_COUNTER:


; Move aliens if ship is moving up/down/left/right
; DIRECTION bits 0-up, 1-down, 2-left, 3-right

                        LD A,(DIRECTION)                ;
                        BIT 0,A                         ;
                        JR Z,SKIP_MOVING_UPA            ;
                        INC (IX+2)                      ;
                        INC (IX+2)                      ;
                        JP SKIP_MOVING_DOWNB            ;
SKIP_MOVING_UPA:
                        ; DIRECTION bits 0-up, 1-down, 2-left, 3-right

                        LD A,(DIRECTION)                ;
                        BIT 1,A                         ;
                        JR Z,SKIP_MOVING_DOWNB          ;
                        DEC (IX+2)                      ;
                        DEC (IX+2)                      ;
SKIP_MOVING_DOWNB:
                        ; DIRECTION bits 0-up, 1-down, 2-left, 3-right

                        LD A,(DIRECTION)                ;
                        BIT 2,A                         ;
                        JR Z,SKIP_MOVING_LEFTA          ;
                        DEC (IX+3)                      ;
                        DEC (IX+3)                      ;
                        JP MOVE_TO_NEXT_ALIEN2          ;
SKIP_MOVING_LEFTA:
; DIRECTION bits 0-up, 1-down, 2-left, 3-right

                        LD A,(DIRECTION)                ;
                        BIT 3,A                         ;
                        JR Z,MOVE_TO_NEXT_ALIEN2        ;
                        INC (IX+3)                      ;
                        INC (IX+3)                      ;

MOVE_TO_NEXT_ALIEN2:

                        CALL CHECK_ALIEN_HIT            ; Check to see if alien is exploding or hit by torpedo

; ;;;;;;;;;;;;;;;;;;;;;;;;
; If the current alien is locked then we need to update the locked timer
                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 255                          ; Is current alien set on locked on sites                         ;
                        JR NZ,SKIP_RESETTING_ALIEN_LOCKED ; Skip updating tracked timer if current alien is not locked

                        LD A,(ALIEN_TRACK_LOCK_TIMER)   ; Get Tracked lock timer
                        CP 0                            ;
                        JR Z,SKIP_DECREMENTING_TRACK_LOCK_TIMER;

                        DEC A                           ; Take 1 from track lock timer
                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Update Tracked lock timer
                        CP 0                            ;
                        JR NC,SKIP_RESETTING_ALIEN_LOCKED;  ;If not less than 1 then skip resetting alien track lock timer

SKIP_DECREMENTING_TRACK_LOCK_TIMER:
                        LD A,3                          ; Set A=3 to set alien sequence to random
                        LD (IX+10),A                    ; Set current alien sequence to UNLOCKED Random

                        XOR A                           ; Set A to 0
                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Reset Alien track locked timer



SKIP_RESETTING_ALIEN_LOCKED:

MOVE_TO_NEXT_ALIEN:
                        LD DE,12+32                     ; Move to next alien ship data
                        ADD IX,DE                       ;
                        ; POP AF                          ;
                        LD A,(ALIEN_NUMBER)             ; Restore alien number
                        DEC A                           ; Take 1 from Alien number
                        LD (ALIEN_NUMBER),A             ; Update alien number
                        JP NZ,DRAW_ALIEN_SHIPS_LOOP     ; Jump back for next alien ship

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check to see if we are hit and need to flash console
                        LD HL,WE_ARE_HIT_COUNTDOWN      ; Get We are hit countdown
                        LD A,(HL)                       ; Update We are hit countdown
                        OR A                            ; Is it at 0?
                        JR Z,SKIP_FLASHING_CONSOLE_WHEN_HIT ; Skip flashing the cockpit if so
                        CP 10                           ;
                        JR NZ,SKIP_HIT_SOUND            ;


SKIP_HIT_SOUND:

                        ;  DEC (HL)                        ;
                        ;  DEC (HL)                        ;
                        ;  DEC (HL)                        ;
                        ;  DEC (HL)                        ;
                        DEC (HL)                        ;

                        CALL FLASH_CONSOLE_WHEN_HIT     ;


SKIP_FLASHING_CONSOLE_WHEN_HIT:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Trade?

; Is an alien encounter hapening?;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        OR A                            ; No encounter hapening? Would be 0 if not
                        JP Z,SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip trading if so


                        LD A,(CURRENT_SECTOR_VALUE)     ; Get sector value
                        OR A                            ; Is it now 0, all aliens gone?
                        JR NZ,SKIP_ALL_ALIENS_GONE      ;


                        XOR A                           ; A=0
                        LD (BUY_SELL),A                 ; Disable Buy/Sell
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset the encounter
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys
                        JP SKIP_BUY_SELL                ; Skip decline offer sequence

SKIP_ALL_ALIENS_GONE:

; Is alien friendly?;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(ALIEN_IS_FRIENDLY)        ; Get alien friendly status

                        CP 0                            ; 0 for alien is not friendly?
                        JP Z,SKIP_ALIEN_TRADING         ; Skip trading if alien is not friendly


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Investigating alien and you;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CALL MEMORY_SWITCH_3            ; Memory switch 3

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        CP 255                          ; Are we at begining of sequence after alien has named themsevles?
                        JP Z,INITIAL_ALIEN_CHECKS_3     ; If 255 (start) then perform initial alien checks
                        ; Alien detect if you have bad reputation

; After initial checks Alien encounter sequence is at 254

                        CP 253                          ; Are we at next stage of trading?
                        JP Z,SECOND_TRADING_STAGEA_3    ; If so then jump to second trading stage A
                        ; Alien is open to trade message
; After second phase checks Alien encounter sequence is at 252

                        CP 251                          ;
                        JP Z,SECOND_TRADING_STAGEB_3    ; If so then jump to second trading stage B
; Setup Are you buying or selling stage, Enable trading keys and reset timer

; After second phaseB checks Alien encounter sequence is at 250

                        CP 249                          ;
                        JP Z,SECOND_TRADING_STAGEC_3    ; If not then skip second trading stage
                        ; Take 1 from the counter sequence
; After second phase C checks Alien encounter sequence is at 248






SKIP_SECOND_TRADING_STAGEC:
; Check if we are at the trading stage (trading keys are enabled)?

                        LD A,(TRADING_KEYS_ENABLED)     ; This is set to 1 if keys are enabled
                        CP 0                            ; Is it 0 for no keys enabled?
                        JR Z,SKIP_READING_D_KEY_FOR_SELLING ; Skip reading keys if they are not enabled

; Trade keys are enabled ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Skip checking for B or S keys if already done
                        LD A,(BUY_SELL)                 ; Get buy sell flag
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_READING_D_KEY_FOR_SELLING ; Skip reading D or S keys if already selected

; Are we firing at Aliens when trading?
                        LD A,(FIRE_ON)                  ; Get player fire status
                        CP 0                            ; Are we firing?
                        JP NZ,DECLINE_ALIEN_OFFER       ; If so then Aliens will not want to trade any more

                        CALL DISPLAY_TIMER:             ; Display timer

; Took too long to press B or S?
                        ;  LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        ;  CP 246                          ; Is the counter at 246?
                        ;  JP NC,SKIP_RESETTING_ALIEN_ENCOUNTER_A ; If not then skip checking for B or S keys as alien has got impatient

                        LD A,(TIMER_DIGIT2)             ; Get timer
                        CP 3                            ; Is timer seconds at 30?
                        JR NZ,SKIP_RESETTING_ALIEN_ENCOUNTER_A ; If not then skip checking for B or S keys as alien has got impatient

; Timer hit 30 seconds - Taken too long to answer B or S
                        LD A,63                         ; You have taken too long to decide
                        CALL GET_MESSAGE_POINTERB       ; Set message

                        XOR A                           ; A=0 to set alien not friendly
                        LD (ALIEN_IS_FRIENDLY),A        ; Set aliens to not friendly
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys

                        CALL MEMORY_SWITCH_3            ;
                        CALL RESET_ALIEN_COUNTER_SEQUENCE_3 ; Reset the alien encounter sequence to 0

                        CALL RESET_TIMER                ; Reset the timer to dark blue

                        JP SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip rest of trading

SKIP_RESETTING_ALIEN_ENCOUNTER_A:

                        CALL GET_KEYS_B_TO_SPACE        ; Read B key for this area
                        BIT 4,A                         ; B pressed?
                        JR NZ,SKIP_READING_B_KEY_FOR_BUYING ; Jump if not
                        LD A,1                          ; Set A to 1 for buying
                        LD (BUY_SELL),A                 ; Set Buy Sell flag to buy
                        ; LD A,1                          ; Dark blue timer
                        ; CALL SET_TIMER_COLOUR           ; Set timer to dark blue
                        CALL RESET_TIMER                ;
                        LD A,101                        ; Set next stage
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ;

                        JP SKIP_READING_D_KEY_FOR_SELLING ; Jump to next section

SKIP_READING_B_KEY_FOR_BUYING:
; Check for A key
                        CALL GET_KEYS_G_TO_A_c30715     ; Check for key presses A to G
                        BIT 0,A                         ; A pressed for abort
                        JP Z,DECLINE_ALIEN_OFFER        ; If so then abort alien encounter
; Check for D key
                        BIT 2,A                         ; Check D key
                        JR NZ,SKIP_READING_D_KEY_FOR_SELLING ; If D is not pressed then jump setting sell to on/off

                        LD A,2                          ; Set A to 2 for selling
                        LD (BUY_SELL),A                 ; Set Buy Sell flag to sell
                        LD A,1                          ; Dark blue timer
                        CALL SET_TIMER_COLOUR           ; Set timer to dark blue
                        LD A,101                        ; Set next stage
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ;

SKIP_READING_D_KEY_FOR_SELLING:
; Next stage of alien trading - Setup Buy/Sell

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        CP 101                          ; Is sequence at 100 or less?
                        JR C,SKIP_BUY_SELL_NEXT_STAGE   ; Skip next stage if not

                        CALL MEMORY_SWITCH_3            ;
                        LD A,(BUY_SELL)                 ; Get Buy Sell flag to buy
                        CP 0                            ; Is Buy_sell set to 0 for no trading?
                        JP Z,SKIP_BUY_SELL              ; If so then skip Buy/sell

                        CP 1                            ; Are we buying?
                        JP Z,SETUP_BUYING_3             ; Call Buying routine

                        CP 2                            ; Are we selling?
                        JP Z,SETUP_SELLING_3            ; Call Selling routine

; ALIEN_ENCOUNTER_SEQUENCE=99 FROM HERE


                        JP SKIP_BUY_SELL                ; Jump the return from buy/sell routines

RETURN_FROM_BUY_SELL:





SKIP_BUY_SELL_NEXT_STAGE:
; Check for Y or N to accept offer from alien


                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        CP 99                           ; Is sequence at 99?
                        JP NC,SKIP_BUY_SELL_NEXT_STAGE2 ; Skip next stage if not

                        ; ld a,r                          ;
                        ; out (254),a                     ;

; Buying menu selection

                        LD A,(BUY_SELL_MENU)            ; Get Buy Sell selection menu flag to buy
                        CP 1                            ; Are we buying?
                        JR NZ,SKIP_BUYING_MENU_SELECTION ; Skip buying if not

; We are selecting what to buy

                        ; Get menu selection Read keys

                        LD BC,64510                     ; Keyboard port for Q,W,E,R,T
                        IN A,(C)                        ; Read keys Q,W,E,R,T
                        LD B,5                          ; 5 keys to read
                        LD C,A                          ;
                        SUB A                           ;
C29032b:
                        INC A                           ;
                        SRL C                           ;
                        JR NC,SELECT_BUY_MENU_KEY_PRESSED ;
                        DJNZ C29032b                    ;
                        SUB A                           ;
                        JR Z,SKIP_BUYING_MENU_SELECTION ;
SELECT_BUY_MENU_KEY_PRESSED:
                        ; out (254),a                     ;
                        CP 5                            ; Abort pressed?
                        JP Z,DECLINE_ALIEN_OFFER        ;

                        CALL MEMORY_SWITCH_3            ;
                        LD (BUYING_FROM_ALIEN_ITEM),A   ;
                        CALL BUYING_FROM_ALIEN_COMODITIES_3 ; Setup buying comodity

                        LD A,72                         ;
                        CALL GET_MESSAGE_POINTERB       ; Set message to Alien offers message

SKIP_BUYING_MENU_SELECTION:
                        LD A,(BUY_SELL)                 ;
                        CP 3                            ; Are we at stage of waiting for Y/N for alien buy offer?
                        JR NZ,SKIP_ALIEN_BUY_OFFER_Y_N  ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Waiting to accept Y/N alien buy offer

                        CALL DISPLAY_TIMER:             ; Display timer

; Took too long to press Y or N?
                        LD A,(TIMER_DIGIT2)             ; Get timer
                        CP 3                            ; Is timer seconds at 30?
                        JR NZ,SKIP_RESETTING_ALIEN_ENCOUNTER_B ; If not then skip checking for B or S keys as alien has got impatient

; Timer hit 30 seconds - Taken too long to answer S or S
                        LD A,63                         ; You have taken too long to decide
                        CALL GET_MESSAGE_POINTERB       ; Set message

                        XOR A                           ; A=0 to set alien not friendly
                        LD (ALIEN_IS_FRIENDLY),A        ; Set aliens to not friendly
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL RESET_ALIEN_COUNTER_SEQUENCE_3 ; Reset the alien encounter sequence to 0


                        ; LD A,1                          ; Move A to 1 to set dark blue for timer
                        ; CALL SET_TIMER_COLOUR:          ; Called with A=clock colour
                        CALL RESET_TIMER                ;

                        JP SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip rest of trading


SKIP_RESETTING_ALIEN_ENCOUNTER_B:
                        CALL GET_KEYS_Y_TO_P            ; Check for Y key
                        BIT 4,A                         ; Y pressed?
                        JR Z,ACCEPTED_ALIEN_OFFER2      ; Jump to accept alien offer
                        CALL GET_KEYS_B_TO_SPACE        ; Check for N key
                        BIT 3,A                         ; N pressed?
                        JR Z,DECLINE_ALIEN_OFFER        ; Jump to decline offer
                        JP SKIP_BUY_SELL                ; Jump to skip Accepting or declining offer
ACCEPTED_ALIEN_OFFER2:
; Jumps here if you press Y to accept alien offer
                        LD A,40                         ; A=40 to set ring draw to on count down
                        LD (DRAW_RING_ON),A             ; Set ring draw to on
                        CALL MEMORY_SWITCH_3            ;
                        CALL SET_BUYING_TAKINGS_3       ; Update the books
                        LD A,60                         ; Sending cargo message
                        CALL GET_MESSAGE_POINTERB       ; Set message


                        XOR A                           ; A=0
                        LD (BUY_SELL),A                 ; Disable Buy/Sell
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset the encounter
                        LD A,250                        ; Set to alien end sequence counter
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Update the Special alien frame counter to end sequence
                        LD B,4                          ; Set alien sequence to end sequence
                        CALL SET_ALL_ALIENS_SEQUENCE_FOR_DISAPEAR;
                        JP SKIP_BUY_SELL                ; Skip decline offer sequence


SKIP_ALIEN_BUY_OFFER_Y_N:

                        LD A,(BUY_SELL)                 ; Get Buy Sell flag to buy
                        CP 2                            ; Are we buying?
                        JP NZ,SKIP_BUY_SELL             ; Jump buy acceptance if not
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Waiting for Y or N keys to be pressed
                        CALL GET_KEYS_Y_TO_P            ; Check for Y key
                        BIT 4,A                         ; Y pressed?
                        JR Z,ACCEPTED_ALIEN_OFFER       ; Jump to accept alien offer
                        CALL GET_KEYS_B_TO_SPACE        ; Check for N key
                        BIT 3,A                         ; N pressed?
                        JR Z,DECLINE_ALIEN_OFFER        ; Jump to decline offer
                        JP SKIP_BUY_SELL                ; Jump to skip Accepting or declining offer
ACCEPTED_ALIEN_OFFER:
; Jumps here if you press Y to accept alien offer
                        LD A,40                         ; A=40 to set ring draw to on count down
                        LD (DRAW_RING_ON),A             ; Set ring draw to on
                        CALL MEMORY_SWITCH_3            ;
                        CALL SET_SELLING_TAKINGS_3      ; Update the books
                        LD A,60                         ; Sending cargo message
                        CALL GET_MESSAGE_POINTERB       ; Set message
                        XOR A                           ; A=0
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset the encounter
                        LD A,250                        ; Set to alien end sequence counter
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Update the Special alien frame counter to end sequence
                        LD B,4                          ; Set alien sequence to end sequence
                        CALL SET_ALL_ALIENS_SEQUENCE_FOR_DISAPEAR;
                        JP SKIP_BUY_SELL                ; Skip decline offer sequence


DECLINE_ALIEN_OFFER:
                        XOR A                           ; A=0
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset the encounter
                        LD (BUY_SELL),A                 ; Disable Buy/Sell

                        LD A,1                          ; Dark blue timer
                        CALL SET_TIMER_COLOUR           ; Set timer to dark blue

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL RESET_ALIEN_COUNTER_SEQUENCE_3 ; Reset the alien encounter sequence to 0
                        XOR A                           ; A=0
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys
                        LD A,R                          ; Get random number
                        CP 2                            ; Is it less than 2?
                        JR C,SKIP_SAFE_ALIEN_DECLINE_OFFER; If so then skip safe alien decline offer

; Get aliens ready for declined offer where they leave quietly
                        LD A,8                          ; Reset Freestyle aliens to 8 time
                        LD (COUNTER4),A                 ;
                        LD A,69                         ; See you again message
                        CALL GET_MESSAGE_POINTERB       ; Set message
                        LD A,20                         ; Set to alien end sequence counter
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Update the Special alien frame counter to end sequence

                        LD B,4                          ; Set alien sequence to end sequence
                        CALL SET_ALL_ALIENS_SEQUENCE_FOR_DISAPEAR;
                        JP SKIP_BUY_SELL                ; Skip decline offer sequence
SKIP_SAFE_ALIEN_DECLINE_OFFER:
; Get aliens ready for declined offer where they turn on you
                        LD A,70                         ; Thankyou for wasting our time message
                        CALL GET_MESSAGE_POINTERB       ; Set message
                        XOR A                           ; A=0 to set alien not friendly
                        LD (ALIEN_IS_FRIENDLY),A        ; Set aliens to not friendly
                        JP SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip decline offer sequence

SKIP_BUY_SELL_NEXT_STAGE2:

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        CP 96                           ; Is sequence at 96?
                        JR NZ,SKIP_BUY_SELL             ; Skip next stage if not

SKIP_BUY_SELL:
                        LD A,(ALIEN_IS_FRIENDLY)        ; Get alien friendly status
                        OR A                            ; 0 for alien is not friendly?
                        JR NZ,SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip torpedo loaded if friendly
SKIP_ALIEN_TRADING:
; Jumps here if unfriendly aliens
                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        CP 253                          ; Is the counter at 253?
                        JR C,SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE;
                        LD A,37                         ; Message - Detecting that alien has torpedo loaded
                        CALL GET_MESSAGE_POINTERB       ; Set message

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL RESET_ALIEN_COUNTER_SEQUENCE_3 ; Reset the alien encounter sequence to 0


SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE:






; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jump here if no aliens to draw
SKIP_DRAWING_ALIENS:

                        LD BC,57342                     ; Port for Y, U, I, O, P
                        IN A,(C)                        ; Get key
                        ; PUSH AF                         ;
                        LD (SAVE_KEYPRESS1+1),A         ; Save the key press for later


                        BIT 1,A                         ; "O" pressed?
                        JR NZ,SKIP_ENABLING_SYSTEM_RESET ; If so then skip enabling system reset

                        LD A,(ABORT_ENABLED)            ; Only perform system reset
                        OR A                            ; if Abort is initiated and O is pressed
                        JR Z,SKIP_ENABLING_SYSTEM_RESET ;

                        LD A,(SYSTEM_RESET)             ; System reset wont initialise if already running
                        OR A                            ; CP 0                            ;
                        JR NZ,SKIP_ENABLING_SYSTEM_RESET;
; Initiate system reset
                        LD A,250                        ; Set System Reset to 250 for countdown
                        LD (SYSTEM_RESET),A             ; Enable system reset sequence countdown

                        LD A,33                         ; System Reset Message
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL


SKIP_ENABLING_SYSTEM_RESET:

                        CALL MEMORY_SWITCH_3            ; Memory switch 3

                        LD A,(SYSTEM_RESET)             ; Get system reset status
                        OR A                            ; CP 0                            ; Is it 0?
                        JP Z,SKIP_COUNTING_DOWN_SYSTEM_RESET ; If so then skip counting down
                        DEC A                           ; Take 1 from System reset countdown
                        LD (SYSTEM_RESET),A             ; Update System reset status

                        CP 180                          ; Is the system reset status at 180?
                        JR NZ,SKIP_SYSTEM_RESET_MESSAGE_2 ; If not then skip displaying second message

                        LD A,34                         ; Bios loaded Message
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL
                        JP SKIP_COUNTING_DOWN_SYSTEM_RESET;

SKIP_SYSTEM_RESET_MESSAGE_2:
                        CP 150                          ; Is system reset status at 150?
                        JR NZ,SKIP_SYSTEM_RESET_MESSAGE_3;  If not then skip phase 3 of system reset

                        LD A,2                          ; Set display to red on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR
; Do we need to try snow fix after system reset?

                        LD A,(SYSTEM_RESET)             ; Get system reset status
                        CP 50                           ; Is it at 50?
                        JR NZ,SKIP_FIXING_PROBLEM_WITH_REBOOT; If not then skip trying to fix

                        XOR A                           ; A=0
                        LD (SNOW_TEXT_SCREEN_ON),A      ; Update snow text status to stop it
                        ;
SKIP_FIXING_PROBLEM_WITH_REBOOT:

                        JP SKIP_COUNTING_DOWN_SYSTEM_RESET;  Jump to skip any more system reset checks for now

SKIP_SYSTEM_RESET_MESSAGE_3:
                        CP 90                           ; Is system reset at 90?
                        JR NZ,SKIP_SYSTEM_RESET_MESSAGE_4 ; If not then skip setting back to Cyan ink on black paper

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD A,(NORMAL_LCD_COLOUR)        ; Set display to Cyan on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR

                        LD A,18                         ; DORBA OS LOADED
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL
                        JP SKIP_COUNTING_DOWN_SYSTEM_RESET;  Jump to skip any more system reset checks for now
SKIP_SYSTEM_RESET_MESSAGE_4:
                        CP 1                            ; Is system reset at 0?
                        JR NZ,SKIP_COUNTING_DOWN_SYSTEM_RESET ; If not then skip setting back to Cyan ink on black paper
                        LD A,(LEVEL)                    ; Set to level message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL



SKIP_COUNTING_DOWN_SYSTEM_RESET:
; Check to see if P was pressed to land

                        ;  POP AF                          ; Restore P press status
                        ; BIT 0,A                         ; "P" pressed?
SAVE_KEYPRESS1:         LD A,0                          ; Set by keypress above
                        RRA                             ; "P" pressed?

                        JR C,SKIP_LANDING2              ; If not then skip landing sequence

                        LD A,(SITES_ON)                 ; Get sites status
                        OR A                            ; Are sites on?
                        JR Z,SKIP_FUNCTION_NOT_ALLOWED  ;

                        CALL FUNCTION_NOT_ALLOWED       ; Sites are on so not allowed
                        JP SKIP_LANDING2                ; If so then skip landing

SKIP_FUNCTION_NOT_ALLOWED:

                        LD A,(SERVICES_ON)              ; Get Services status
                        OR A                            ; CP 0                            ;
                        CALL NZ,FUNCTION_NOT_ALLOWED    ; Sites are on so not allowed
                        JR NZ,SKIP_LANDING2             ;


                        CALL MEMORY_SWITCH_4            ;
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get current sector value into A

                        CP 9                            ; Is it a planet full of stuff to shoot?
                        JR NZ,SKIP_LANDING              ; Skip landing if not a planet
                        CALL PLANET_LANDING_SEQUENCE    ; Lets land

                        ;    DI                              ;
                        ;    IM 2                            ;
                        ;    EI                              ;


                        JP SKIP_LANDING2                ;

SKIP_LANDING:
                        CP 10                           ; Is it a planet landing only?
                        JR NZ,SKIP_LANDING2             ; Skip landing if not a planet
                        CALL PLANET_LANDING_SEQUENCE    ; Lets land

SKIP_LANDING2:
                        LD A,(SITES_ON)                 ; Get sites status
                        OR A                            ; Are sites on?
                        CALL NZ,DISPLAY_SITES           ; If so then display sites





; SKIP_CLEAR_BUFFER:
                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DRAW_STARS_DATA1_6         ; Display stars and arange next stars
; Allow registry when side scrolling?
                        LD A,(LED_STATUS_SCREEN)        ; Get LED screen Status
                        OR A                            ;
                        JR Z,SKIP_DISPLAYING_REGISTRY2  ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL DISPLAY_LED_SCREEN_3       ;


SKIP_DISPLAYING_REGISTRY2:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jumps here if side scroller is enabled
SKIP_3D_SECTION:
; The side scroller jumps the above to here to check keys apart from planet landing.


                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; CP 0                            ;
                        JR NZ,FIRE_SKIP                 ; If on then skip some checks

; Check for fire
                        LD A,(GAME_MODE)                ; Get game mode
                        OR A                            ; CP 1, Game mode side scroller? 1 for side scroller
                        JP NZ,FIRE_3D_SKIP              ; If so then skip the 3D fire

                        ; 3D fire
                        LD A,(FIRE_ON)                  ; Check if already firing
                        OR A                            ; CP 1                            ;
                        CALL NZ,DISPLAY_TORPEDO         ;
                        JP FIRE_SKIP                    ;

; Jumps here if not firing in 3D mode
FIRE_3D_SKIP:

                        LD A,(FIRE_ON)                  ; Get fire status
                        OR A                            ; CP 1                            ; Are we firing?
                        CALL NZ,FIRING_SIDE_SCROLLER    ; Update side scrolling fire


; Jumps here after checking fire mode
FIRE_SKIP:

                        LD HL,SPEEDMAX                  ; Counts up to speed. Then calls move stars
                        INC (HL)                        ; Add 1 to Speedmax

                        CALL CHECK_ABORT                ; Check if Abort key is pressed

                        LD A,(ABORT_ENABLED)            ; Get Mission Abort status
                        CP 1                            ;
                        CALL NC,ABORT_IS_SET_SO_CHECK_Y_N ; Check Y or N keys for abort

                        XOR A                           ;
                        LD (DIRECTION),A                ; Reset direction keys


                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; CP 0
                        JP NZ,UPDATESCREEN              ; If on then skip some checks



                        CALL GET_KEYS_c27096l           ;

                        ; PUSH BC
                        ; LD A,(SCAN_LINE_DELAY3)
                        ; LD A,(HUNCHBACK_DIRECTION_LEFT_RIGHT_LAST)
                        ;  LD A,(SP1X);_LEFT_RIGHT
                        ; LD A,(TORPEDO_COUNTER)
                        ; LD B,0
                        ; LD C,A
                        ; CALL DISPLAYNUMBER

                        ; POP BC


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DIRECTION:                                DB 0            ;Set direction
                        ; DIRECTION bits 0-up, 1-down, 2-left, 3-right
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check movement keys

; NONE 10111111
; 9 -  10111101
; 8 -  10111011
; 7 -  10110111
; 6 -  10101111


                        ; BIT 0,A                         ; Read key 0

                        RRA                             ;
                        JP C,GET_NEXT_KEY1              ; Fire key
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Set Fire On
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(FIRE_ON)                  ; Check if already firing
                        CP 1                            ; Are we firing already?
                        JR Z,GET_NEXT_KEY1              ; Jump setting fire if we are

                        ; CALL RESTORE_RADAR_POINTER_TO_CURRENT ; Reset radar pointer as we are firing

                        LD A,(LASER_METER_STORE)        ; Out of rockets?
                        CP 1                            ; CP 0                            ;
                        JR C,GET_NEXT_KEY1              ; Jump setting fire if we are


                        LD HL,TORPEDO_SOUND             ; Point at torpeds sound data
                        CALL GENERAL_SOUND              ; Play sound

                        ;    LD A,(LASER_METER_STORE)      ;Get Laser meter store
                        ;   OR A                            ; CP 0                          ;Is meter at 0?
                        ;    JP Z,SKIP_UPDATE_LASER_METER   ;Do not set meter if zero

                        ; LD A,(LASER_METER_STORE)        ;
                        ; DEC A                           ;
                        ; LD (LASER_METER_STORE),A        ;

                        LD A,(ROCKET_DROP_COUNTER)      ; Get rocket reduce counter
                        DEC A                           ; Take 1 from it
                        LD (ROCKET_DROP_COUNTER),A      ; Update the rocket counter

                        ; OUT (254),A
                        OR A                            ; Is it at 0?
                        JR NZ,SKIP_UPDATE_LASER_METER   ;


                        LD HL,LASER_METER_STORE         ;
                        DEC (HL)                        ;
                        CALL SET_LASER_METER            ;
                        LD A,20                         ; 50 misiles drop the rocket counter
                        LD (ROCKET_DROP_COUNTER),A      ; Update the rocket counter



SKIP_UPDATE_LASER_METER:

                        LD A,(GAME_MODE)                ;
                        CP 1                            ;
                        JR NZ,SKIP_SIDE_SCROLLING_FIRE_SETUP;

; Setup side scrolling fire
                        LD A,1                          ; Set fire on
                        LD (FIRE_ON),A                  ;
                        LD A,(SP1X_SHIP)                ; Get side ship x (left/right) coordinate
                        ADD A,8                         ; Add 8 to start bullets to right of ship
                        LD (BULLET_ACROSS),A            ; Set bullet left/right coordinate
                        LD A,(SP1Y_SHIP)                ; ;Get side ship y (up/down) coordinate
                        ; ADD A,16

                        LD (FIRE1Y),A                   ; Set bullet up/down coordinate
                        JP GET_NEXT_KEY1                ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_SIDE_SCROLLING_FIRE_SETUP:
; Setup 3D firing
                        LD A,(WHO_FIRED_FIRST)          ; Get Who fired first 1 if you fired first or 2 if alien fired first
                        CP 2                            ; Is it 2 for Alien fired first?
                        JR NZ,SKIP_WHO_FIRED_FIRST      ; If not then jump the fired first checks

                        LD HL,REPUTATION                ; Get reputation
                        LD A,(HL)                       ; Get reputation setting
                        OR A                            ; Is it already 0?
                        JR Z,SKIP_DECREMENT_REPUTATION  ; Skip taking 1 from reputation if so
                        DEC (HL)                        ; Take 1 from reputation
                        CALL SET_REPUTATION             ; Set the reputation status
SKIP_DECREMENT_REPUTATION:

                        LD A,(WHO_FIRED_FIRST)          ; Get Who fired first 1 if you fired first or 2 if alien fired first
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_WHO_FIRED_FIRST      ; If not then jump the fired first checks

; Set to 1 if you fired first or 2 if alien fired first
                        LD A,(ALIEN_FIRED)              ; Get Alien fired status
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_SETTING_YOU_FIRED_FIRSTA ; If not then Alien fired first so skip setting you fired first
                        LD A,1                          ;
                        LD (WHO_FIRED_FIRST),A          ; Set who fired first to 1 for you firing first


SKIP_SETTING_YOU_FIRED_FIRSTA:
                        LD A,2                          ;
                        LD (WHO_FIRED_FIRST),A          ; Set who fired first to 2 for Alien firing first
SKIP_WHO_FIRED_FIRST:

                        LD A,1                          ; Set fire on
                        LD (FIRE_ON),A                  ;
                        LD (FIRE_HAS_BEEN_DONE),A       ; Set fire used to 1 for reputation or alien retaliation

                        XOR A                           ; A=0
                        LD (TORPEDO_COUNTER),A          ; Reset Torpedo counter to 0
                        LD A,10                         ; A=10
                        LD (TORPEDO_UP_DOWN),A          ; Torpedo Up/down coordinate=10


; DIRECTION bits 0-up, 1-down, 2-left, 3-right

GET_NEXT_KEY1:
                        LD A,(DIRECTION)                ; Get Direction into A
                        LD B,A                          ; Save to B

                        CALL GET_KEYS_c27096l           ; Check key presses for keys 6 to 9

                        BIT 1,A                         ; Read key 9 Right
                        JR NZ,GET_NEXT_KEY2             ; Skip setting direction if key is not pressed

                        SET 3,B                         ; Set for right
GET_NEXT_KEY2:
                        BIT 2,A                         ; Read key 8  Left
                        JR NZ,GET_NEXT_KEY3             ; Skip setting direction if key is not pressed

                        SET 2,B                         ; Set for left
GET_NEXT_KEY3:
                        BIT 3,A                         ; Read key 7 Up
                        JR NZ,GET_NEXT_KEY4             ; Skip setting direction if key is not pressed

                        SET 0,B                         ; Set for up
GET_NEXT_KEY4:
                        BIT 4,A                         ; Read key  6 Down
                        JR NZ,GET_NEXT_KEY5             ; Skip setting direction if key is not pressed

                        SET 1,B                         ; Set for down
GET_NEXT_KEY5:
                        LD A,B                          ; Get direction into A
                        LD (DIRECTION),A                ; Update direction
                        POP AF                          ;

; PUSH BC
;       PUSH AF
;       LD A,(DIRECTION)
;       LD B,0
;                      LD C,A
;                      CALL DISPLAYNUMBER
;                      POP AF
;                      POP BC

; End of reading direction/fire keys
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



                        LD A,(SYSTEM_RESET)             ;
                        OR A                            ; CP 0                            ;
                        JR NZ,SKIP_MUTING_ALARM_SOUND   ; Dont allow when reset system is hapening





; Is an alien encounter hapening?;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CALL GET_KEYS_G_TO_A_c30715     ; Check for key presses A to G
                        LD B,A                          ;

                        ;   LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        ;  OR A                            ; No encounter hapening? Would be 0 if not
                        ;  JR NZ,SKIP_ENABLE_SITES         ; Skip enabling sites if so


                        ; CALL GET_KEYS_G_TO_A_c30715     ; Check for key presses A to G

                        BIT 1,B                         ; Check S key
                        JR NZ,SKIP_ENABLE_SITES         ; If S is not pressed then jump setting Sites to on/off
                        CALL SITES_ON_OFF               ; Set Sites to on/off
                        JP SKIP_ENABLE_SERVICE          ; Jump to skip checking if we need to enable Service screen
SKIP_ENABLE_SITES:

                        ;   CALL GET_KEYS_G_TO_A_c30715_F     ; Check for key presses A to G

                        BIT 3,B                         ; Check F key
                        JR NZ,SKIP_SHIELDS_ON_OFF       ; If F is not pressed then jump setting Shields on/off to on/off
                        CALL SHIELDS_ON_OFF             ; Set Sites to on/off
                        JP SKIP_ENABLE_SERVICE          ; Jump to skip checking if we need to enable Service screen

SKIP_SHIELDS_ON_OFF:

                        ;  CALL GET_KEYS_G_TO_A_c30715     ; Check for key presses A to G
                        BIT 0,B                         ; Check A key
                        JR NZ,SKIP_ENABLE_SERVICE       ; If A key is not pressed then skip setting service screen on/off

                        LD A,(GAME_MODE)                ;
                        OR A                            ;
                        JR NZ,SKIP_ENABLE_SERVICE:      ;


                        CALL SERVICES_ON_OFF            ; Set Service screen to on/off

SKIP_ENABLE_SERVICE:
                        CALL GET_KEYS_Q_TO_T_c30715     ;

                        BIT 3,A                         ; Check R key
                        JR NZ,SKIP_ENABLE_LED_STATUS    ; If R key is not pressed then skip setting LED STATUS screen on/off
                        ; LD A,(GAME_MODE)                ; Get game mode
                        ; OR A                            ; Are we on 3D game?
                        ; JR NZ,SKIP_ENABLE_LED_STATUS:   ; Skip setting LED status screen if not

                        LD A,(ABORT_ENABLED)            ;
                        CP 0                            ;
                        CALL NZ,LED_STATUS_SCREEN_ON_OFF ; Set Service screen to on/off

SKIP_ENABLE_LED_STATUS:

; Check to see if we need to switch on/off Shields


                        ;   CALL GET_KEYS_G_TO_A_c30715_F     ; Check for key presses A to G
                        ;   BIT 3,A                         ; Check F key
                        ;  JR NZ,SKIP_SHIELDS_ON_OFF       ; If F is not pressed then jump setting Shields on/off to on/off
                        ; CALL SHIELDS_ON_OFF             ; Set Sites to on/off

; SKIP_SHIELDS_ON_OFF:



; CALL CHECK_METER_STATUS


; Mute alarm sounds if "M" is pressed
                        CALL GET_KEYS_B_TO_SPACE_FOR_M  ;
                        BIT 2,A                         ; M pressed?
                        JR NZ,SKIP_MUTING_ALARM_SOUND   ; Skip muting alarm if so
                        CALL ALARM_MUTE_ON_OFF          ;

SKIP_MUTING_ALARM_SOUND:


                        LD A,(DRAW_RING_ON)             ; Get Ring drawing status
                        CP 1                            ; Is drawing ring counter down to 5?
                        JR NZ,SKIP_SETTING_LAST_SPEED_MESSAGE_AFTER_RING ; Skip setting last speed message if not

                        LD A,(LAST_SPEED_MESSAGE)       ; If so then Set last speed message                         ;
                        CALL GET_MESSAGE_POINTER        ; Set the message
                        JP SKIP_DRAWING_RING            ; Jump testing if draw ring counter is at 0

SKIP_SETTING_LAST_SPEED_MESSAGE_AFTER_RING:

                        OR A                            ; Is Ring drawing status 0?
                        JR Z,SKIP_DRAWING_RING          ; If so then skip drawing ring
                        CALL MEMORY_SWITCH_6            ; Set memory to block 6
                        CALL DRAW_RING_6                ; Draw ring to buffer
                        ; CALL MEMORY_SWITCH_1            ; Set memory back to 1

SKIP_DRAWING_RING:



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy buffer to visible screen
UPDATESCREEN:
NEXT100:
                        CALL ZIPZAP_SCREEN_COPY         ;


                        LD A,(HYPERDRIVE)               ; Get Hyperdrive status
                        OR A                            ; CP 0                            ;
                        JR NZ,SKIP_SETTING_SPEED        ; If on then skip some checks


; Set speed

                        CALL READ_KEYS_1TO5_c29023      ; Read keys 1 to 5
                        JR Z,SKIP_SETTING_SPEED         ;

                        LD (SPEED),A                    ;
                        LD DE,4                         ; Setup for addition to set background sound volume depending on speed
                        LD HL,BACKGROUND_SOUND_DATA+6   ;

                        CP 1                            ;
                        JR NZ,NEXT_SPEED_CHECK1         ;
                        LD (HL),25                      ; Set background noise pitch to speed
                        ADD HL,DE                       ; Move to background sound volume data
                        LD (HL),4                       ; Set background noise volume
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ; Update sound
                        ; LD A,46                         ;
                        JP NEXT_SPEED_CHECK5            ;

NEXT_SPEED_CHECK1:
                        CP 2                            ;

                        JR NZ,NEXT_SPEED_CHECK2         ;
                        LD (HL),19                      ; Set background noise pitch to speed
                        ADD HL,DE                       ; Move to background sound volume data
                        LD (HL),4                       ; Set background noise volume
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ; Update sound
                        LD A,47                         ;
                        JP NEXT_SPEED_CHECK5            ;

NEXT_SPEED_CHECK2:
                        CP 3                            ;

                        JR NZ,NEXT_SPEED_CHECK3         ;
                        LD (HL),18                      ; Set background noise pitch to speed
                        ADD HL,DE                       ; Move to background sound volume data
                        LD (HL),3                       ; Set background noise volume
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ; Update sound
                        ; LD A,48                         ;
                        JP NEXT_SPEED_CHECK5            ;

NEXT_SPEED_CHECK3:
                        CP 4                            ;

                        JR NZ,NEXT_SPEED_CHECK4         ;
                        LD (HL),17                      ; Set background noise pitch to speed
                        ADD HL,DE                       ; Move to background sound volume data
                        LD (HL),3                       ; Set background noise volume
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ; Update sound
                        ; LD A,49                         ;
                        JP NEXT_SPEED_CHECK5            ;

NEXT_SPEED_CHECK4:
                        CP 5                            ;

                        JR NZ,NEXT_SPEED_CHECK5         ;
                        LD (HL),16                      ; Set background noise pitch to speed
                        ADD HL,DE                       ; Move to background sound volume data
                        LD (HL),2                       ; Set background noise volume
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ; Update sound
                        ; LD A,50                         ;


NEXT_SPEED_CHECK5:
                        LD (LAST_SPEED_MESSAGE),A       ; Store last speed message

                        LD B,45                         ;
                        LD A,(SPEED)                    ;
                        ADD A,B                         ;

                        CALL GET_MESSAGE_POINTER        ; Get message into HL

SKIP_SETTING_SPEED:
                        ; Check and adjust Oxygen
                        LD A,(OXYGEN_LEAK)              ; Get Oxygen leak status
                        CP 1                            ; Is it on?
                        JR NZ,SKIP_LOSING_OXYGEN        ;

                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 20                           ; CP 0                            ;
                        JR NC,SKIP_LOSING_OXYGEN        ;

                        CALL DECREMENT_OXYGEN           ; Take 1 from oxygen and update oxygen, set losing oxygen notice

                        ;   LD A,15                         ; Message 15 Losing Oxygen
                        ;   CALL GET_MESSAGE_POINTER        ; Get message into HL
SKIP_LOSING_OXYGEN:
; Check to see if we need to increment temperature

                        LD A,(COUNTER)                  ; Get 0 to 255 counter


; Update top left border screen
                        LD B,3                          ; 3 LINES TO DRAW
                        LD HL,16384+(3*32)              ; Get screen address for mini screen



BORDER_CHANGES_LOOP1:

                        PUSH AF                         ;
                        OR %10101010                    ; Add space between bits
                        LD (HL),A                       ; Update small screen on border
                        PUSH HL                         ;
                        INC L                           ; Move to next collumn
                        POP AF                          ;
                        PUSH AF                         ;
                        AND %10101100                   ; Dont mess up border graphics
                        OR (HL)                         ; Merge with what is already on border
                        LD (HL),A                       ; Use game counter to update small screen on border
                        POP HL                          ; Take 1 from collumn
                        INC H                           ; Move to next 2nd hires line
                        INC H                           ;
                        POP AF                          ;
                        RRA                             ; Rotate data to make dots move
                        DJNZ BORDER_CHANGES_LOOP1       ; Jump back until all lines are done

; If speed is 1 then we increment temperature


                        LD A,(SPEED)                    ; Get speed    ;Get speed
                        CP 1                            ; Is speed on 1 for full speed?
                        JR NZ,SKIP_INCREMENTING_TEMPERATURE ; If not then skip temperature changes/checks

                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 200                          ; Is the counter at 200?
                        JR NZ,SKIP_INCREMENTING_TEMPERATURE ; If counter is not zero then skip temperature changes/checks

                        CALL MEMORY_SWITCH_3            ; Set memory back to 3
                        CALL ADD_1_TO_TEMPERATURE_3     ; Add 1 to temperature   ;Add 2 to temperature
                        CALL ADD_1_TO_TEMPERATURE_3     ; Add 1 to temperature
SKIP_INCREMENTING_TEMPERATURE:

; Decrement temperature if counter is at 250
                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 250                          ; Is the counter at 250?
                        JR NZ,SKIP_DECREMENTING_TEMPERATURE ; If counter is not zero then skip temperature changes/checks

                        LD A,(TEMPERATURE)              ; Get temperature
                        CP 22                           ; Is it at 22 or above?
                        JR C,SKIP_DECREMENTING_TEMPERATURE ; If not then skip decrementing temperature

                        CALL MEMORY_SWITCH_3            ; Set memory back to 3
                        CALL TAKE_1_FROM_TEMPERATURE_3  ; Take 1 from temperature

SKIP_DECREMENTING_TEMPERATURE:

                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 100                          ; Is the counter at 100?
                        JR NZ,SKIP_CHANGING_WATER       ; If game counter is not 100 then skip changing water


                        LD A,R                          ; Get random number
                        OR A                            ; Is it 0?
                        JR Z,SKIP_CHANGING_WATER        ; If not then skip decrementing water


                        CALL DECREMENT_WATER            ; Take 1 from water

SKIP_CHANGING_WATER:

                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 50                           ; Is the counter at 100?
                        JR NZ,SKIP_CHANGING_FOOD        ; If game counter is not 50 then skip changing food

                        LD A,R                          ; Get random number
                        OR A                            ; Is it 0?
                        JR Z,SKIP_CHANGING_FOOD         ; If not then skip decrementing food

                        CALL DECREMENT_FOOD             ; Take 1 from food
SKIP_CHANGING_FOOD:
                        ;  LD A,(COUNTER)                  ; Get game counter
                        ;  CP 100                          ; Is it 100?
                        ;  JR NZ,SKIP_CHECKING_FOR_GAME_OVER; If not then skip counting down game over counter


                        LD HL,SET_GAME_OVER             ; Get Game over countdown
                        LD A,(HL)                       ;

                        CP 0                            ; Is it 0 for not game over?
                        JR Z,SKIP_CHECKING_FOR_GAME_OVER;
                        DEC (HL)                        ; Take 1 from game over countdown

                        CP 150                          ;
                        JR NZ,SKIP_DISPLAYING_CLOSE_TO_DISTRUCTION;

                        LD A,31                         ; Message 31 Ship unable to support life MESSAGE
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL

SKIP_DISPLAYING_CLOSE_TO_DISTRUCTION:

                        ; LD A,(SET_GAME_OVER)            ; Get Game over countdown

                        ; LD (SET_GAME_OVER),A            ; Update game over counter
                        CP 1                            ; Is game over counter at 1?
                        JP Z,GAME_OVER                  ; If so then jump to game over

SKIP_CHECKING_FOR_GAME_OVER:

; Do we need to scroll radar 1 pixel to finish selection?
                        LD HL,SCROLLLINELEFTB_COUNTER   ; Get scroll radar counter
                        LD A,(HL)                       ; Put scroll radar counter into A for testing
                        OR A                            ; Is it zero?
                        JR Z,SKIP_SCROLL_RADAR_1_PIXEL  ; If so then skip scrolling and counting down counter

                        DEC (HL)                        ; Take 1 from scroll radar counter

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD B,1                          ; Scroll Radar only 1 pixel
                        CALL OVERAL_SCROLL_LEFT_LOOP_4  ; Scroll radar 1 pixel if counter is greater than 0

SKIP_SCROLL_RADAR_1_PIXEL:

                        LD A,(CYGNUS_FOUND)             ; Get Cygnus Found
                        OR A                            ; We already found it?
                        JR NZ,SKIP_CYGNUS_FOUND         ; No need to set again


                        LD A,(PROGRESS)                 ; Get progress
                        CP 250                          ; 100% progress?
                        CALL NC,SET_CYGNUS_FOUND        ; Set Cygnus as found

SKIP_CYGNUS_FOUND:      ; Skip to here if already found ;
                        LD A,(COUNTER)                  ; Get game counter
                        OR A                            ; Is it at 0?
                        JR NZ,SKIP_TAKE_1_FROM_FUEL     ; If not then skip taking one from fuel

                        LD A,(SPEED)                    ; Get speed
                        LD B,A                          ; Save speed
                        LD A,6                          ; A=6
                        SUB B                           ; Subtract speed
                        LD B,A                          ; B=total for loop To take more from fuel if faster
TAKE_1_FROM_FUEL_LOOP:
                        PUSH BC                         ; Save loop
                        CALL TAKE_1_FROM_FUEL           ; Take 1 from fuel
                        POP BC                          ; Restore loop
                        DJNZ TAKE_1_FROM_FUEL_LOOP      ; Jump back to complete reducing fuel
SKIP_TAKE_1_FROM_FUEL:

                        LD HL,23672                     ; Get Spectrum Frames
                        LD A,(CPU_ATTR)                 ; Get stored frame
                        ADD 4                           ;
                        CP (HL)                         ; Compare with stored frame
                        JR NC,SKIP_SETTING_CPU_HIGH2    ; If the same then skip setting CPU red

                        LD A,(COUNTER)                  ; Get 0 to 255 counter
                        CP 100                          ; Is the counter at 200?
                        JR NZ,SKIP_CPU_TEMP_INCREASE    ; If counter is not zero then skip temperature changes/checks

                        CALL RESET_ALL_SOUNDS           ;

                        CALL MEMORY_SWITCH_3            ; Set memory back to 3
                        CALL ADD_1_TO_TEMPERATURE_3     ; Add 1 to temperature
                        CALL ADD_1_TO_TEMPERATURE_3     ; Add 1 to temperature



SKIP_CPU_TEMP_INCREASE:
                        LD A,66                         ; Bright red on black for high CPU

                        JP SKIP_SETTING_CPU_HIGH        ; Jump setting to normal
SKIP_SETTING_CPU_HIGH2:
                        LD A,68                         ; Bright green on black for normal

SKIP_SETTING_CPU_HIGH:
; Set CPU attr   A=COLOUR
SET_CPU_ATTR:
                        LD HL,23091                     ; First ATTR address of CPU icon
                        LD (HL),A                       ; Set address to colour
                        INC HL                          ; Move to next ATTR address
                        LD (HL),A                       ; Set address to colour

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




                        JP MAIN_LOOP                    ; Jump back main game loop
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from food
DECREMENT_FOOD:
                        LD A,(FOOD)                     ; Get food status
                        CP 0                            ; Is food status 0?
                        JR Z,SKIP_SETTING_FOOD          ; If so then GAME OVER, OUT OF FOOD
                        DEC A                           ; Take 1 from food
                        LD (FOOD),A                     ; Update food

                        CALL SET_FOOD_STATUS            ;
                        RET                             ; Jump to continue

SKIP_SETTING_FOOD:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,81                         ; Message for FOOD depleted
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to oxygen
ADD_1_TO_FOOD:
                        LD A,(FOOD)                     ; Get food percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to food
                        LD (FOOD),A                     ; Update food
                        CALL SET_FOOD_STATUS            ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Take 1 from oxygen
DECREMENT_OXYGEN:
                        LD A,(OXYGEN)                   ; Get oxygen status
                        CP 0                            ; Is oxygen status 0?
                        JR Z,SKIP_SETTING_OXYGEN        ; SKIP_CHANGING_OXYGEN        ; If so then GAME OVER, OUT OF OXYGEN

                        DEC A                           ; Take 1 from oxygen
                        LD (OXYGEN),A                   ; Update oxygen status
                        CALL SET_OXYGEN                 ; Set oxygen status

                        LD A,15                         ; Message 15 Losing Oxygen
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        RET                             ; Jump to continue
SKIP_SETTING_OXYGEN:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,82                         ; Message for oxygen depleted
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to oxygen
ADD_1_TO_OXYGEN:
                        LD A,(OXYGEN)                   ; Get oxygen percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to oxygen
                        LD (OXYGEN),A                   ; Update oxygen
                        CALL SET_OXYGEN_STATUS          ; Set oxygen status
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DECREMENT_WATER:        ;Take 1 from water              ;
                        LD A,(WATER_STATUS)             ; Get water status

                        ;  push af
                        ;  ld b,a
                        ;  call DISPLAY_NUMBER
                        ;  pop af


                        CP 0                            ; Is water status 0?
                        JR Z,SKIP_SETTING_WATER         ; SKIP_CHANGING_WATER        ; If so then GAME OVER, OUT OF WATER

                        DEC A                           ; Take 1 from water
                        LD (WATER_STATUS),A             ; Update water status
                        CALL SET_WATER_STATUS           ; Set water status
                        RET                             ; Jump to continue
SKIP_SETTING_WATER:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,83                         ; Message for water depleted
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        RET                             ;

; Add 1 to water
ADD_1_TO_WATER:
                        LD A,(WATER_STATUS)             ; Get water percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to water
                        LD (WATER_STATUS),A             ; Update water
                        CALL SET_WATER_STATUS           ; Set water status
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Game Over counter
SET_GAME_OVER_COUNTER:
                        LD A,(SET_GAME_OVER)            ; Get Game over counter status
                        CP 0                            ; Is it 0?
                        RET NZ                          ; Do not set status to 100 if not 0

                        LD A,201                        ; Set game over to 2 for game over countdown
                        LD (SET_GAME_OVER),A            ; Update Game Over attribute

                        LD A,242                        ; Flash bottom right corner of screen                     ; Border area to set ATTR to show game over set
                        LD (23295),A                    ;


                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPRITE_DROPPING:
                        LD A,(IX+1)                     ; Get up/down coordinate
                        ADD A,8                         ; Add 8 pixels to coordinate to drop sprite
                        LD (IX+1),A                     ; Update sprite coordinate
                        ; LD A,(IX+1)                                 ;Get up/down coordinate
                        CP 89                           ; Is sprite at bottom of play area?
                        JR NC,DROPPING_RESET            ; Reset if so
                        LD B,0                          ;
                        JP NO_UP_DOWN2                  ;

; This section is for falling nasties when they hit the bottom         Direction 0 for left, 1 for right
                        ;      |  |  |   |  ------------------ 2 for left up/down, 3 for right up/down 4 for bell
DROPPING_RESET:         ;00000001 00000010 00000011 00000100;


                        XOR A                           ; Set A to reset sprite
                        LD (IX+0),A                     ; Update sprite status
                        LD A,48                         ; Reset sprite up/down coordinate
                        LD (IX+1),A                     ; Update sprite coordinate


                        CALL DISABLE_RESET_SPRITE       ; Call if sprite is traveling left

                        LD B,0                          ;
                        JP NO_UP_DOWN2                  ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Delay loop  BC=Delay
DELAY1LOOP:
                        LD HL,19967-5                   ; Rotate the meter graphic for show
                        RRC (HL)                        ;
                        INC H                           ;
                        RRC (HL)                        ;
                        INC H                           ;
                        RRC (HL)                        ;

                        PUSH AF                         ;
DELAY1LOOP2:


                        DEC BC                          ; Take one from delay counter
                        LD A,B                          ; Load A with delay counter higher byte
                        OR C                            ; Higher byte and lower byte = 0?
                        JR NZ,DELAY1LOOP2               ; Jump back to complete delay
                        POP AF                          ;
                        RET                             ; Return if so

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check if Alien is hitting Cygnus
COLLISION_CHECK:

                        CALL COLLISION                  ; Check for cygnus collision with alien
                        RET NC                          ; Return if no collision
        ; Looks like a collision
                        CALL DISABLE_RESET_SPRITE       ; CALL to reset present

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Side Scroller Check colission IX+6 0-do nothing, 1-Alien so fire/check collision to be hit, 2-Fuel, 3-10HD, 4-100HD, 5-Rocket
                        LD A,(IX+6)                     ; Get collision check flag
                        CP 1                            ; Is it 1, You hit an alien?
                        JR NZ,COLISSION_NEXT_1          ; If not then jump for next check
                        CALL FLASH_SCREEN_REDUCE_SHIELDS ; If so then flash screen and reduce shields

                        LD HL,ALIEN_EXPLODING_SOUND     ; Alien exploding sound data
                        CALL GENERAL_SOUND              ; Play exploding alien sound

                        RET                             ;

COLISSION_NEXT_1:
                        CP 2                            ; Is it 2 for fuel?
                        JR NZ,COLISSION_NEXT_2          ; If not then jump for next check
                        CALL Z,ADD_1_TO_FUEL            ; Add 1 to fuel percentage
                        RET                             ; Return
COLISSION_NEXT_2:
                        CP 3                            ; Is it 3 for 10HD?
                        JR NZ,COLISSION_NEXT_3          ; If not then jump for next check
                        LD B,10                         ; Call Add 1 to HD 10 times
                        CALL ADD_B_TO_HD                ; Add 10 to HD
                        RET                             ;
COLISSION_NEXT_3:
                        CP 4                            ; Is it 4 for 100HD?
                        JR NZ,COLISSION_NEXT_4          ; If not then jump for next check
                        LD B,100                        ; Call Add 1 to HD 10 times
                        CALL ADD_B_TO_HD                ; Add 10 to HD
                        RET                             ;

COLISSION_NEXT_4:
                        CP 5                            ; Is it 5 for Rocket?
                        RET NZ                          ; JR NZ,COLISSION_NEXT_5 - If not then jump for next check
                        LD A,(LASER_METER_STORE)        ; Get laser meter
                        CP 13                           ; Already full?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to laser meter
                        LD (LASER_METER_STORE),A        ; Update laser meter
                        CALL SET_LASER_METER            ; Update laser meter on screen

COLISSION_NEXT_5:
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Adds B to HD - Called with B=figure 10 or 100
ADD_B_TO_HD:
                        PUSH BC                         ;
                        CALL ADD_1_TO_HD                ; Add 1 to HD
                        POP BC                          ;
                        DJNZ ADD_B_TO_HD                ; Loop back until B=0
                        RET                             ; Ret
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check for side scrolling alien missile hitting Cygnus
COLLISION_CHECK2:
                        CALL COLLISION2                 ; Check for collision
                        RET NC                          ; Return if no collision
        ; Looks like a collision
                        CALL SIDE_SCROLLING_DISABLE_ALIEN_FIRING ; CALL to reset alien fire
                        CALL FLASH_SCREEN_REDUCE_SHIELDS ; If so then flash screen and reduce shields
                        LD HL,ALIEN_EXPLODING_SOUND     ; Alien exploding sound data
                        CALL GENERAL_SOUND              ; Play exploding alien sound
                        RET                             ;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Collision check with corner clipping for side scrolling alien missile hitting Cygnus

COLLISION2:
                        LD A,(SP1Y_SHIP)                ; Get player's X coords
                        SUB (IX+7)                      ; subtract sprite x.
                        JP P,CHC1A                      ; No, skip negation
                        NEG                             ; Make it positive.
CHC1A:
                        CP 15                           ; within x range?
                        RET NC                          ; no - they've missed.

                        LD E,A                          ; Store difference
                        LD A,(SP1X_SHIP)                ; Get player's Y coords
                        SUB (IX+8)                      ; Subtract Y.
                        JP P,CHC2A                      ; No, skip negation
                        NEG                             ; Make it positive.
CHC2A:
                        CP 15                           ; within y range?
                        RET NC                          ; A is Greater than 16? no collision.

                        ADD A,E                         ; add x difference.
                        CP 14                           ; only 5 corner pixels touching?
                        RET                             ; carry set if there's a collision.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Collision check with corner clipping.

COLLISION:
                        LD A,(SP1Y_SHIP)                ; Get player's X coords
                        SUB (IX+1)                      ; subtract sprite x.
                        JP P,CHC1                       ; No, skip negation
                        NEG                             ; Make it positive.
CHC1:
                        CP 15                           ; within x range?
                        RET NC                          ; no - they've missed.

                        LD E,A                          ; Store difference
                        LD A,(SP1X_SHIP)                ; Get player's Y coords
                        SUB (IX+2)                      ; Subtract Y.
                        JP P,CHC2                       ; No, skip negation
                        NEG                             ; Make it positive.
CHC2:
                        CP 15                           ; within y range?
                        RET NC                          ; A is Greater than 16? no collision.

                        ADD A,E                         ; add x difference.
                        CP 14                           ; only 5 corner pixels touching?
                        RET                             ; carry set if there's a collision.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check for side scrolling Cygnus missile hitting alien
COLLISION_CHECK3:
                        CALL COLLISION3                 ; Check for collision
                        RET NC                          ; Return if no collision
; Looks like a collision
                        LD HL,ALIEN_EXPLODING_SOUND     ; Alien exploding sound data
                        CALL GENERAL_SOUND              ; Play exploding alien sound

                        XOR A                           ;
                        RES 0,(IX+0)                    ; Disable alien
                        LD (FIRE_ON),A                  ; Disable fire
                        LD (BULLET_ACROSS),A            ;
                        LD (FIRE1Y),A                   ;

                        CALL MEMORY_SWITCH_0            ; Memory switch 3
                        LD HL,EXPLODE_ALIEN_GRAPHIC1_0  ; Point at exploding alien graphics
                        LD B,1                          ; 2 frames for explosion graphics
EXPLODE_SIDE_ALIEN_LOOP:
                        LD A,(IX+1)                     ; Get the sprite x coordinate
                        SUB 8                           ;
                        LD (dispx+1),A                  ; Set the varable for the sprite x coordinate
                        LD A,(IX+2)                     ; Get the sprite y coordinate
                        LD (dispy+1),A                  ; Set the varable for the sprite y coordinate
                        XOR A                           ; LD A,1                          ; A=1 to set Merge mode
                        LD (MERGE_SPRITE+1),A           ; Set sprite merge mode
                        PUSH HL                         ;
                        PUSH BC                         ;
                        CALL sprite                     ; Display sprite
                        POP BC                          ;
                        POP HL                          ;
                        LD DE,32                        ; Setup DE for addition for next exploding graphic block
                        ADD HL,DE                       ; Move to next exploding graphic block
                        DJNZ EXPLODE_SIDE_ALIEN_LOOP    ; Jump back until all frames of explosion are completed

                        LD A,240                        ;
                        LD (IX+2),A                     ; Reset alien to far right


                        RET                             ; Return



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Collision check with corner clipping for side scrolling.

COLLISION3:
                        LD A,(BULLET_ACROSS)            ; Get player's X coords
                        SUB (IX+2)                      ; subtract sprite x.
                        JP P,CHC1AA                     ; No, skip negation
                        NEG                             ; Make it positive.
CHC1AA:
                        CP 15                           ; within x range?
                        RET NC                          ; no - they've missed.

                        LD E,A                          ; Store difference
                        LD A,(FIRE1Y)                   ; Get player's Y coords
                        SUB (IX+1)                      ; Subtract Y.
                        JP P,CHC2AA                     ; No, skip negation
                        NEG                             ; Make it positive.
CHC2AA:
                        CP 15                           ; within y range?
                        RET NC                          ; A is Greater than 16? no collision.

                        add a,e                         ; add x difference.
                        cp 14                           ; only 5 corner pixels touching?
                        ret                             ; carry set if there's a collision.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Has alien been hit
CHECK_ALIEN_HIT:

                        ; LD A,(IX+0)
                        ; CP 2
                        ; JP NZ,SKIP_ALIEN_HIT_MESSAGE
                        ; LD A,13         ; Message 13 ALIEN HIT MESSAGE
                        ;    CALL GET_MESSAGE_POINTER  ;Get message into HL
; SKIP_ALIEN_HIT_MESSAGE:

; Is alien already exploding?
                        LD A,(IX+0)                     ;
                        CP 2                            ; If already exploding then will be greater than 1
                        JP NC,ALIEN_EXPLODING           ; Alien is already exploding
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; Check if alien is in middle of screen
                        LD A,(IX+3)                     ; Get alien ship left/right
                        LD B,120                        ; 112                        ;
                        SUB B                           ;

                        ; CP 112              ;In middle of the screen?
                        CP 6                            ;
                        RET NC                          ; Return if not

                        ; Alien is in the middle of the screen.


                        LD A,(IX+2)                     ; Get alien up/down coordinate
                        LD B,173                        ;
                        SUB B                           ;
                        CP 6                            ; In middle of the screen?
                        RET NC                          ; Return if not

                        ; LD A,(IX+3)          ;Get alien LEFT/RIGHT coordinate
                        ; CP 80
                        ; JP NZ,SKIP_ALIEN_LOCKON
                        ; SITES SQUARE AT 22765


                        LD A,(SITES_ON)                 ; We dont want tracker if sites are off
                        OR A                            ; CP 0                            ;
                        JP Z,SKIP_SITES_TRACK_COLOUR    ;


                        LD A,(ALIEN_TRACK_LOCK_TIMER)   ; Check if alien already tracked
                        OR A                            ; Is the timer 0 meaning nothing is being tracked?
                        JR NZ,SKIP_SETTING_TRACK_LOCK_TIMER ; Skip setting alien tracked if not

                        LD A,(IX+10)                    ; Get current alien sequence
                        CP 255                          ; Is current alien set on locked on sites                         ;
                        JR Z,SKIP_SETTING_TRACK_LOCK_TIMER ; Skip setting tracked timer if already tracked

                        LD A,12                         ; Message 11 ALIEN TRACKED MESSAGE
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

; Alien is tracked so set the current alien as locked on sites
                        LD A,255                        ; Setup A to set current alien as locked on sites
                        LD (IX+10),A                    ; Set current alien sequence to locked on sites

; Alien is tracked so set the tracked lock timer
                        LD A,30                         ; Set alien track lock timer
                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Update Tracked lock timer

SKIP_SETTING_TRACK_LOCK_TIMER:

; Flash red locked on sites
                        LD A,(ALIEN_TRACK_LOCK_TIMER)   ;
                        BIT 0,A                         ;  Get bit 0 of tracked locked timer
                        JR NZ,SKIP_SITES_TRACK_COLOUR   ;  Change colour alternately as bit 0 is on or off
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour top of sites bright red as we have tracked an alien

                        LD HL,22765-129+10240+2         ; 22765-129+10240  32876;Start of sites ATTR
                        LD A,4                          ; Start with 3 collumns to fill
                        LD B,4                          ; Four rows for top of sites
SITES_LOOP1:
                        PUSH BC                         ; Save rows counter
                        PUSH HL                         ; Save ATTR address
                        LD B,A                          ; Set collumns for row
                        CALL SITES_LOOP2                ;
                        POP HL                          ; Restore ATTR address
                        LD DE,31                        ; Setup addition to move to next ATTR line
                        ADD HL,DE                       ; Add to HL to move to next ATTR line

                        ADD A,2                         ; Add 1 to collumn
                        POP BC                          ; Restore Rows loop
                        DJNZ SITES_LOOP1                ; Complete all rows

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour bottom of sites bright red as we have tracked an alien

                        LD B,4                          ; Four rows for top of sites
SITES_LOOP1B:
                        PUSH BC                         ; Save rows counter
                        PUSH HL                         ; Save ATTR address
                        LD B,A                          ; Set collumns for row
                        CALL SITES_LOOP2                ;
                        POP HL                          ; Restore ATTR address
                        LD DE,33                        ; Setup addition to move to next ATTR line
                        ADD HL,DE                       ; Add to HL to move to next ATTR line

                        SUB 2                           ; Add 1 to collumn
                        POP BC                          ; Restore Rows loop
                        DJNZ SITES_LOOP1B               ; Complete all rows

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Tracker sound
                        LD HL,TRACKER_SOUND_DATA        ; Set background sound after fire sound
                        CALL GENERAL_SOUND              ; Get back to background sound
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SKIP_SITES_TRACK_COLOUR:
; SKIP_ALIEN_LOCKON:

                        LD A,(TORPEDO_UP_DOWN)          ; Get torpedo Y coords
                        CP 7                            ; Is torpedo near middle of screen?
                        RET C                           ; Return if not

                        LD A,(TORPEDO_COUNTER)          ; Get Torpedo counter
                        CP 17                           ; Is torpedo near middle of screen?
                        RET NZ                          ; Return if not we dont want alien exploding if torpedo is not near alien

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien is hit, disable alien
DISABLE_ALIEN:
; 3D Alien hit by Cygnus fire so disable
                        LD A,8                          ; Reset Freestyle aliens to 8 time
                        LD (COUNTER4),A                 ;

                        LD A,13                         ; Message 13 Alien destroyed message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        XOR A                           ;
                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Reset Tracked lock timer

                        LD HL,ALIEN_EXPLODING_SOUND     ; Alien exploding sound data
                        CALL GENERAL_SOUND              ; Play exploding alien sound

                        LD (IX+0),40                    ; Set alien enable counter to 30 to count down explosion
                        LD (IX+10),3                    ; Reset alien to random and not locked to sites
                        CALL TAKE_1_FROM_ICON           ; Remove 1 alien from current radar icon


                        ; CALL DISPLAY_RADAR_ICONS        ; Update radar icons

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SITES_LOOP2:
                        LD (HL),66                      ; Set current ATTR address to bright red
                        INC HL                          ;        Move to next collumn
                        DJNZ SITES_LOOP2                ; Complete row
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable side scrolling sprite
DISABLE_RESET_SPRITE:
                        ; Set first byte of sprite data to 0 for disabled
                        RES 0,(IX+0)                    ; Set data to disabled for current sprite
                        LD (IX+1),30                    ; Reset sprite up/down
                        LD A,R                          ; Get random number
                        AND 16                          ; Up to 2 character spaces
                        ADD A,(IX+1)                    ; Add the random number to up/down position
                        LD (IX+1),A                     ; Update sprite up/down with random position to start next time
                        LD (IX+2),247                   ; Reset sprite to its start position
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable side scrolling sprite with jump back
DISABLE_RESET_SPRITE_WITH_JUMPBACK:

                        CALL DISABLE_RESET_SPRITE       ; Disable side scrolling sprite
                        JP SKIP_CHECK_CYGNUS_MISSILE_HITTING_ALIEN ; Jump back for next alien


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SKIP_TAKING_1_FROM_ALIENS:
;                        CALL ERASE_SECTOR               ; Erase sector for no aliens
;                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIEN_EXPLODING:
; Check if alien is finished exploding
                        LD A,(IX+0)                     ; Get exploding alien counter
                        CP 39                           ;
                        JR NZ,SKIP_RESETTING_ALIEN_EXPLODING_DATA;
                        CALL MEMORY_SWITCH_6            ; Set memory to block 6
                        CALL COPY_DEFAULT_EXPLODE_DATA_TO_CORRECT_ALIEN_6 ; Copy the default alien data
SKIP_RESETTING_ALIEN_EXPLODING_DATA:


; Alien is exploding
                        DEC (IX+0)                      ; Take 1 from exploding alien counter
                        ; out (254),a
                        CP 2                            ; Are we at end of explosion?
                        JP Z,DISABLE_ALIEN2             ; If so then disable alien

                        CALL MEMORY_SWITCH_6            ; Set memory to block 6
                        CALL DRAW_EXPLODING_DOTS_6      ;

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Disable alien and clear track lock
DISABLE_ALIEN2:
                        XOR A                           ;
                        LD (IX+0),A                     ; Disable alien

                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Set alien tracK lock timer

                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timer varables
TIMER_DIGIT1:           DB 0                            ; Timer digit
TIMER_DIGIT2:           DB 0                            ; Timer digit
TIMER_DIGIT3:           DB 0                            ; Timer digit
TIMER_DIGIT4:           DB 0                            ; Timer digit
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset timer and set to dark blue ink
RESET_TIMER:

                        XOR A                           ; A=0
                        LD (23672),A                    ; Get Spectrum Frames
                        LD HL,0                         ; Set HL=0
                        LD (TIMER_DIGIT1),HL            ; Reset Digits 1 and 2
                        LD (TIMER_DIGIT3),HL            ; Reset Digits 3 and 4
                        INC A                           ; Set for dark blue ink
SET_TIMER_COLOUR:       ; Called with A=clock colour    ;
                        LD B,5                          ;
                        LD HL,22528+491                 ;

SET_TIMER_COLOUR_LOOP:

                        LD (HL),A                       ;
                        INC HL                          ;
                        DJNZ SET_TIMER_COLOUR_LOOP:     ;

                        CALL DISPLAY_FIGURES_IN_TIMER   ; Display reset timer

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display timer
;
DISPLAY_TIMER:
                        LD A,69                         ; Bright cyan on black paper
                        CALL SET_TIMER_COLOUR:          ; Called with A=clock colour


                        CALL c41168                     ; Update digits from Spectrum Frames

; Calls here to manually display figures in timer for reset
DISPLAY_FIGURES_IN_TIMER:
                        LD A,(TIMER_DIGIT4)             ; Get Digit 4
                        LD D,15                         ; Line 15
                        LD E,11                         ; Collumn 11
                        OR 128                          ;

                        CALL DISPLAY_8X8_TEXT_c26682    ; Display digit 4

                        LD A,(TIMER_DIGIT3)             ; Get Digit 3
                        OR 128                          ;
                        INC E                           ; Move to next collumn
                        CALL DISPLAY_8X8_TEXT_c26682    ; Display digit 3

                        LD A,138                        ; Character for ":"
                        INC E                           ; Move to next collumn
                        CALL DISPLAY_8X8_TEXT_c26682    ; Display ":"

                        LD A,(TIMER_DIGIT2)             ; Get Digit 2
                        OR 128                          ;
                        INC E                           ; Move to next collumn
                        CALL DISPLAY_8X8_TEXT_c26682    ; Display digit 2

                        LD A,(TIMER_DIGIT1)             ; Get Digit 1
                        OR 128                          ;
                        INC E                           ; Move to next collumn
                        CALL DISPLAY_8X8_TEXT_c26682    ; Display digit 1
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set clock from Spectrum Frames
c41168:                 LD HL,23672                     ; Get Spectrum Frames
                        LD A,(HL)                       ; A= Frames
                        SUB 50                          ; Take 50 frames per second from Frames
                        JP P,b41178                     ; If not zero then do not return
                        RET                             ; Return
b41178:                 LD (HL),A                       ; Update Frames
                        LD A,(TIMER_DIGIT1)             ; Get digit 1
                        LD B,A                          ; Store in B
                        INC B                           ; Add 1 to stored Digit 1
                        LD A,10                         ; Setup A to test
                        CP B                            ; Does B=10?
                        JR Z,b41194                     ; If so then jump to reset digit to 1
                        LD A,B                          ; A=updated digit
                        LD (TIMER_DIGIT1),A             ; Update digit
                        RET                             ; Return
b41194:                 XOR A                           ; A=0
                        LD (TIMER_DIGIT1),A             ; Reset digit 1
                        LD A,(TIMER_DIGIT2)             ; Get digit 2
                        LD B,A                          ; Store in B
                        INC B                           ; Add 1 to stored Digit 2
                        LD A,6                          ; Setup A to test
                        CP B                            ; Does B=6?
                        JR Z,b41213                     ; If so then jump to reset digit to 2
                        LD A,B                          ; A=updated digit
                        LD (TIMER_DIGIT2),A             ; Update digit
                        RET                             ; Return
b41213:                 XOR A                           ; A=0
                        LD (TIMER_DIGIT2),A             ; Reset digit 2
                        LD A,(TIMER_DIGIT3)             ; Get digit 3
                        LD B,A                          ; Store in B
                        INC B                           ; Add 1 to stored Digit 3
                        LD A,10                         ; Setup A to test
                        CP B                            ; Does B=9?
                        JR Z,b41232                     ; If so then jump to reset digit to 3
                        LD A,B                          ; A=updated digit
                        LD (TIMER_DIGIT3),A             ; Update digit                       ;
                        RET                             ; Return
b41232:                 XOR A                           ; A=0
                        LD (TIMER_DIGIT3),A             ; Reset digit 3                      ;
                        LD A,(TIMER_DIGIT4)             ; Get digit 4
                        LD B,A                          ; Store in B
                        INC B                           ; Add 1 to stored Digit 4
                        LD A,10                         ; Setup A to test
                        CP B                            ; Does B=9?
                        RET Z                           ; ,TIMER_COLLUMN              ; If so then jump to reset digit to RETURN   ;
                        LD A,B                          ; A=updated digit
                        LD (TIMER_DIGIT4),A             ; Update digit                       ;
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RELEASE_RANDOM_NUMBER_COUNTER:DB 0                      ; When counts up to counter setting - release random number

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Release random number into A
RELEASE_RANDOM_NUMBER:

                        LD A,R                          ;
                        LD B,A                          ;
                        LD A,(RELEASE_RANDOM_NUMBER_COUNTER);
                        ADD A,B                         ;
                        LD (RELEASE_RANDOM_NUMBER_COUNTER),A;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set side scrolling alien to NOT fire
SIDE_SCROLLING_DISABLE_ALIEN_FIRING:
                        LD A,(IX+6)                     ; Get sprite status
                        CP 1                            ; Is this an alien sprite?
                        RET NZ                          ; Return if not

                        BIT 7,(IX+0)                    ; Get alien status
                        RET Z                           ; Is Alien firing? Return if not
                        RES 7,(IX+0)                    ; Disable alien firing
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup random stars for side scroller
SETUP_STARS_SIDE_SCROLLER:
                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        LD IX,SNOW_FLAKE_DATA1_6        ;

                        LD B,25                         ;
SNOWLOOP1B:
                        PUSH BC                         ;
                        CALL RND                        ; Random across
                        INC A                           ;
                        INC A                           ;
                        INC A                           ;
                        LD (IX+1),A                     ; Setup across
                        CALL RND                        ;
                        AND %01111111                   ; UP/DOWN
                        LD (IX+0),A                     ;
                        CALL RND                        ; Setup speed down
                        AND %00000001                   ;
                        OR A                            ; CP 0                            ;
                        CALL Z,SET_TO_1B                ;
                        LD (IX+2),A                     ;
                        CALL RND                        ; Random left/right
                        AND %00000001                   ; Keep first bit only

                        LD (IX+4),A                     ; Set left right
                        CALL RND                        ; Random left/right speed
                        AND %00000111                   ; Keep first 2 bit only
                        OR A                            ; CP 0                            ;
                        CALL Z,SET_TO_1B                ;
                        LD (IX+3),A                     ; Set left right speed
                        LD BC,5                         ;
                        ADD IX,BC                       ;
                        POP BC                          ;

                        DJNZ SNOWLOOP1B                 ;
                        RET                             ;
SET_TO_1B:
                        LD A,2                          ;
                        RET                             ;




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get screen pixel address
; B = Y pixel position
; C = X pixel position
; Returns address in HL
; Used by radar scan line
; GET_SCREEN_ADDRESS_c29864:
;                        ADD A,136                       ;
;                        LD B,A                          ;
;                        ; LD A,B              ; Calculate Y2,Y1,Y0
;                        AND 7                           ; Mask out unwanted bits
;                        OR 64                           ; Set base address of screen
;                        LD H,A                          ; Store in H
;                        LD A,B                          ; Calculate Y7,Y6
;                        RRA                             ; Shift to position
;                        RRA                             ;
;                        RRA                             ;
;                        AND 24                          ; Mask out unwanted bits
;                        OR H                            ; OR with Y2,Y1,Y0
;                        LD H,A                          ; Store in H
;                        LD A,B                          ; Calculate Y5,Y4,Y3
;                        RLA                             ; Shift to position
;                        RLA                             ;
;                        AND 224                         ; Mask out unwanted bits
;                        LD L,A                          ; Store in L
                        ;                       RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get screen BUFFER address
; B = Y pixel position
; C = X pixel position
; Returns address in HL

GET_SCREEN_ADDRESS_c29864DE:
                        ; ADD A,136
                        LD B,A                          ;
                        ; LD A,B              ; Calculate Y2,Y1,Y0
                        AND 7                           ; Mask out unwanted bits
                        OR 64                           ; Set base address of screen
                        LD D,A                          ; Store in H
                        LD A,B                          ; Calculate Y7,Y6
                        RRA                             ; Shift to position
                        RRA                             ;
                        RRA                             ;
                        AND 24                          ; Mask out unwanted bits
                        OR D                            ; OR with Y2,Y1,Y0
                        LD D,A                          ; Store in H
                        LD A,B                          ; Calculate Y5,Y4,Y3
                        RLA                             ; Shift to position
                        RLA                             ;
                        AND 224                         ; Mask out unwanted bits
                        LD E,A                          ; Store in L
                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get screen buffer address into HL Called with A=Line
; BUFFER SCREEN ADDRESS
GET_SCREEN_BUFFER_ADDRESS_c29864:

                        ADD A,136                       ;
GET_SCREEN_BUFFER_ADDRESS_c29864B:
                        LD B,A                          ;
                        ; LD A,B              ; Calculate Y2,Y1,Y0
                        AND 7                           ; Mask out unwanted bits
                        OR 96                           ; Set base address of screen
                        LD H,A                          ; Store in H
                        LD A,B                          ; Calculate Y7,Y6
                        RRA                             ; Shift to position
                        RRA                             ;
                        RRA                             ;
                        AND 24                          ; Mask out unwanted bits
                        OR H                            ; OR with Y2,Y1,Y0
                        LD H,A                          ; Store in H
                        LD A,B                          ; Calculate Y5,Y4,Y3
                        RLA                             ; Shift to position
                        RLA                             ;
                        AND 224                         ; Mask out unwanted bits
                        LD L,A                          ; Store in L
                        ; LD DE,8192                      ;
                        ; ADD HL,DE                       ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get screen buffer text address into HL

; D = Y character position
; E = X character position
; Returns address in DE
; Used by rocket
GET_SCREEN_BUFFER_TEXT_ADDRESS_c29864:
                        LD D,A                          ;
                        AND 7                           ;
                        RRA                             ;
                        RRA                             ;
                        RRA                             ;
                        RRA                             ;
                        ; OR E
                        LD L,A                          ;
                        LD A,D                          ;
                        AND 24                          ;
                        OR 96                           ;
                        LD H,A                          ;
                        RET                             ; Returns screen address in DE

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ; Colour console when hit by torpedo
HIT_BY_TORPEDO_COLOUR_CHANGE:

                        LD A,(SHIELDS_ON)               ; Get Sheilds status
                        CP 1                            ; Are Sheilds on?
                        JR Z,SKIP_SETTING_HIT_COUNTER_TO_80; If so then skip setting hit counter to 80, but set to 40

                        LD A,80                         ; Set A to 80 for we are hit countdown
                        JP SETTING_HIT_COUNTER_TO_80    ; Skip setting hit counter to 40

SKIP_SETTING_HIT_COUNTER_TO_80:
                        LD A,40                         ; Set A to 40 for we are hit countdown when Sheilds are on
SETTING_HIT_COUNTER_TO_80:
                        LD (WE_ARE_HIT_COUNTDOWN),A     ; Set we are hit countdown to change console colours until countdown=0


                        LD HL,ALIEN_EXPLODING_SOUND     ; We are hit so make exploding sound
                        CALL GENERAL_SOUND              ; Call sound
                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flash console when hit
FLASH_CONSOLE_WHEN_HIT:
; Set colour of cockpit Bright white on black paper
                        CALL MEMORY_SWITCH_1            ; Memory switch 1
                        LD A,62                         ; 62 for LD A, instruction
                        LD (COCKPIT_SET_1_1),A          ; Place LD A, instruction
                        LD (SET_COCKPIT_LEFT_RIGHTA_1),A ; Place LD A, instruction
                        LD (SET_COCKPIT_LEFT_RIGHTB_1),A ; Place LD A, instruction

                        LD A,71                         ;   Bright white on black
                        LD (COCKPIT_SET_1_1+1),A        ;  Set Bright white on black
                        LD (SET_COCKPIT_LEFT_RIGHTA_1+1),A ; Set Bright white on black
                        LD (SET_COCKPIT_LEFT_RIGHTB_1+1),A ; Set Bright white on black
                        CALL COCKPIT_COLOUR_ENTRY_1:    ; Used when hit by torpedo to change colour of cockpit

; Reset colour of cockpit back to normal
                        XOR A                           ; 0 to NOP LD A, instructions
                        LD (COCKPIT_SET_1_1),A          ;
                        LD (SET_COCKPIT_LEFT_RIGHTA_1),A ;
                        LD (SET_COCKPIT_LEFT_RIGHTB_1),A ;
                        LD (COCKPIT_SET_1_1+1),A        ;
                        LD (SET_COCKPIT_LEFT_RIGHTA_1+1),A ;
                        LD (SET_COCKPIT_LEFT_RIGHTB_1+1),A ;
                        CALL COCKPIT_COLOUR_ENTRY_1:    ; Used when hit by torpedo to change colour of cockpit


                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup the logo data into memory for manipulation
COPY_LOGO_DATA_TO_TEMP:

                        CALL MEMORY_SWITCH_6            ; Memory switch 6

                        LD HL,LOGO_COORDINATES_DATA_6   ; HL=LOGO DATA
                        LD DE,LOGO_COORDINATES_DATA_TEMP_6 ; DE=LOGO DATA TEMP
                        LD BC,1796                      ;
                        LDIR                            ; Move the default logo data to temp for manipulation
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Ship is hit, flash colours and border
; HIT:
                        ;    LD B,25                         ; 25 flashes
; HIT_LOOP:
                        ;    LD A,7                          ; Ink white
                        ;    OUT (254),A                     ; Border white
                        ;    XOR A                           ; Ink black
                        ;    OUT (254),A                     ; Border black
                        ;    DJNZ HIT_LOOP                   ; Jump back for loop
                        ;    RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display Cygnus missile on side scroller
FIRING_SIDE_SCROLLER:
                        LD A,(BULLET_ACROSS)            ;
                        ADD A,16                        ;
                        CP 220                          ;
                        JP NC,STOP_FIRE                 ;
                        LD (BULLET_ACROSS),A            ;
                        LD C,A                          ;
                        LD A,(FIRE1Y)                   ;
                        ADD A,6                         ;
                        LD B,A                          ;
                        CALL GET_SCREEN_HIRES_ADDRESS   ;
                        LD A,R                          ;
                        LD (HL),A                       ;
                        INC HL                          ;
                        LD (HL),A                       ;

                        INC B                           ;
                        CALL GET_SCREEN_HIRES_ADDRESS   ;
                        LD A,R                          ;
                        LD (HL),A                       ;
                        INC HL                          ;
                        LD (HL),A                       ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get screen hires address into HL
GET_SCREEN_HIRES_ADDRESS:
                        AND B                           ; A holds b7b6b5b4b3b2b1b0,
                        RRA                             ; The bite of B. And now 0b7b6b5b4b3b2b1.
                        SCF                             ;
                        RRA                             ; Now 10b7b6b5b4b3b2.
                        AND A                           ;
                        RRA                             ; Now 010b7b6b5b4b3.
                        XOR B                           ;
                        AND 248                         ; Finally 010b7b6b2b1b0, so that
                        XOR B                           ; H becomes 64 + 8*INT (B/64) +
                        OR 96                           ;
                        LD H,A                          ; B (mod 8), the high byte of the
                        LD A,C                          ; pixel address. C contains X.
                        RLCA                            ; A starts as c7c6c5c4c3c2c1c0.
                        RLCA                            ;
                        RLCA                            ; And is now c2c1c0c7c6c5c4c3.
                        XOR B                           ;
                        AND 199                         ;
                        XOR B                           ; Now c2c1b5b4b3c5c4c3.
                        RLCA                            ;
                        RLCA                            ; Finally b5b4b3c7c6c5c4c3, so
                        LD L,A                          ; that L becomes 32*INT (B(mod
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Stop fire
STOP_FIRE:
                        LD HL,FIRE_ON                   ; Stop fire
                        LD (HL),0                       ; Set fire to off
; Reset sound to background
                        LD HL,BACKGROUND_SOUND_DATA     ; Set background sound after fire sound
                        CALL GENERAL_SOUND              ; Get back to background sound
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Get random number into A
RND:                    ;rnd                            ;


Rand1:                  ld hl,(Seed+2)                  ;
                        rl l                            ;
                        rl h                            ;
                        rl l                            ;
                        rl h                            ;
                        ld c,h                          ;
                        ld a,(Seed)                     ;
                        rla                             ;
                        ld b,a                          ;
                        ld de,(Seed+1)                  ;
                        rl e                            ;
                        rl d                            ;
                        res 7,d                         ;
                        ld hl,(Seed)                    ;
                        add hl,bc                       ;
                        ld (Seed),hl                    ;
                        ld hl,(Seed+2)                  ;
                        adc hl,de                       ;
                        res 7,h                         ;
                        ld (Seed+2),hl                  ;
                        ret m                           ;
                        ld hl,Seed                      ;
Rand2:                  inc (hl)                        ;
                        ret nz                          ;
                        inc hl                          ;
                        jr Rand2                        ;

Seed                    defb "Nih!"                     ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set memory to page 0
MEMORY_SWITCH_0:
                        PUSH AF                         ;
                        XOR A                           ;
                        JP MEMORY_SWITCHER              ; Jump to switch memory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set memory to page 1
MEMORY_SWITCH_1:
                        PUSH AF                         ;
                        LD A,1                          ;
                        JP MEMORY_SWITCHER              ; Jump to switch memory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set memory to page 4
MEMORY_SWITCH_4:
                        PUSH AF                         ;
                        LD A,4                          ;
                        JP MEMORY_SWITCHER              ; Jump to switch memory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set memory to page 6
MEMORY_SWITCH_6:
                        PUSH AF                         ;
                        LD A,6                          ;
                        JP MEMORY_SWITCHER              ; Jump to switch memory
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Set memory to page 3
MEMORY_SWITCH_3:
                        PUSH AF                         ;
                        LD A,3                          ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Switches in memory bank at 49152
MEMORY_SWITCHER:
                        PUSH HL                         ;
                        LD (SWITCH_SETTING+1),A         ; Block
                        LD A,(23388)                    ; Previous value of port
                        AND 248                         ;
SWITCH_SETTING:         ;Bank number +1 to switch       ;
                        OR 0                            ; Select bank IN B
                        LD BC,32765                     ;
                        DI                              ;
                        LD (23388),A                    ;
                        OUT (C),A                       ;

                        LD HL,18719                     ; Point to border location for dot
SWITCH_DOT:             LD A,(SWITCH_SETTING+1)         ; Set to memory bank
                        RL A                            ; Rotate left 2 times to get into center of graphic
                        RL A                            ;
                        XOR (HL)                        ;
                        LD (HL),A                       ; Update screen border location
                        POP HL                          ;
                        POP AF                          ;
                        EI                              ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Smooth scroll up screen
; Called with A=scroll up screen graphic number (planet or alien base)

; SELECT_LANDING_PLANET_GRAPHICS:
                        ; LD HL,41984   ; Data for TIME SHIFT    COMPLETE      EFFECTIVE     3RD MILLENIUM
                        ; INC A         ; Add 1 to A to get into the correct memory area for graphic to scroll selection
                        ; LD DE,2048    ; Each selection is 2048 bytes
; C31805
; ADD HL,DE     ; Add graphic memory location
                        ; DEC A         ; Take 1 from counter
                        ; JR NZ,C31805   ; Jump back until we have the correct graphic selected
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PLANET_LANDING_SEQUENCE:
; Planet landing
                        XOR A                           ; A=0
                        LD (SHIELDS_ON),A               ; Update Shields on/off status
                        CALL MANUAL_SET_SHIELDS         ; Set shields screen colour


                        LD A,54                         ; MESSAGE FOR LANDING
                        CALL GET_MESSAGE_POINTER        ;

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        LD HL,PLANET_LANDING_SCREEN_1_6 ;
                        LD (PLANET_GRAPHIC_LOCATION_31862),HL;

                        ; ;;;;;;;;;;;;;;;;;


                        LD A,(CURRENT_SECTOR_VALUE)     ; Get current sector value
                        CP 9                            ; Is it a planet full of stuff to shoot?
                        JR NZ,SKIP_SETTING_LANDING_TO_CONFRONTATION;

                        XOR A                           ;  Set landing to confrontation
                        LD (PLANET_LANDING_MODE),A      ; 0 for confrontation. 1 for landing
                        JP PERFORM_LANDING              ; Jump to land

SKIP_SETTING_LANDING_TO_CONFRONTATION:
                        ; ;;;;;;;;;;;;;

                        CP 10                           ; Is this a full planet?
                        JR NZ,SKIP_SETTING_LANDING_TO_JUST_LAND;

                        LD A,1                          ;  Set landing to confrontation
                        LD (PLANET_LANDING_MODE),A      ; 0 for confrontation. 1 for landing
                        ; JP PERFORM_LANDING              ;Jump to land

SKIP_SETTING_LANDING_TO_JUST_LAND:
PERFORM_LANDING:
                        LD A,(PLANET_LANDING_MODE)      ; 0 for confrontation. 1 for landing
                        CP 1                            ;
                        JR Z,SKIP_PLANET_CONFRONTATION_MODE ; Land only

; Confrontation landing
                        ; Setup side scrolling sprite data
                        CALL MEMORY_SWITCH_0            ; Memory switch 3
                        LD HL,SIDE_SCROLLING_SPRITE_DATA_SET_0 ; Initialise sprite data
                        LD DE,SIDE_SCROLLING_SPRITE_DATA_0;

                        LD BC,400                       ; Length of data
                        LDIR                            ;
                        ; Scroll up 64 lines
                        LD A,60                         ; Only scroll half up 60 lines
                        JP CALL_PLANET_SEQUENCE         ; Jump so we dont scroll planet up 80 lines as we are not completely landing

SKIP_PLANET_CONFRONTATION_MODE:;Land only               ; Jumps here if we are landing only
                        LD A,80                         ; Set to scroll planet up 80 lines

CALL_PLANET_SEQUENCE:
; We are fully landing
                        CALL SCROLL_LANDING_UP_c31798   ; Scroll on the planet for landing

                        LD A,(PLANET_LANDING_MODE)      ; 0 for confrontation. 1 for landing
                        CP 1                            ; Is it 1?
                        JR Z,LANDING_ONLY               ; If so then Land only for health boost and some repairs

; So do not set game mode
                        LD A,1                          ;   Set game mode to side scroller confrontation
                        LD (GAME_MODE),A                ;
                        CALL COPY_SCREEN_BUFFER_TO_EMPTY_BUFFER ; Save planet graphics to empty buffer for scrolling

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LANDING_ONLY:
; Landing only with no confontation
        ; Delay before takeoff

                        ;  LD BC,1030                      ;
                        ; CALL DELAY1LOOP                 ;

; Gygnus found?
                        LD A,(CYGNUS_FOUND)             ; Is Cygnus found?
                        OR A                            ; 0?
                        JP NZ,FLASH_FOUND_CYGNUS_CONTROL ; Jump to found control if not zero


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display menu after landed
                        LD A,17                         ; Message for landed menu
                        CALL GET_MESSAGE_POINTER        ;

                        ; DEFM "Y-FULL SERVICE@"            ; Menu after landing
                        ; DEFM "COST 10000 d@"
                        ; DEFM "P-TAKE OFF@"
WAIT_FOR_KEY:
                        CALL GET_KEYS_Y_TO_P            ; Check for Y key
                        BIT 0,A                         ; P pressed?
                        JR Z,SKIP_PURCHASE_SERVICE      ; Jump to accept alien offer
                        BIT 4,A                         ; Y pressed?
                        JR Z,PERFORM_SERVICE            ;


                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Update LCD Text
                        LD BC,3050                      ; Set BC for delay
                        CALL DELAY1LOOP                 ; Make a delay

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL PERFORM_AMBIENCE_SOUND4_6  ;

                        JP WAIT_FOR_KEY                 ; Jump back to wait for key
PERFORM_SERVICE:
; Fix everything

                        CALL RESET_METERS               ; Reset all meters

                        XOR A                           ; Set A=0

                        LD (SNOW_TEXT_SCREEN_ON),A      ; Update snow text status to stop it
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;


                        LD A,68                         ; Expenses message
                        CALL GET_MESSAGE_POINTERB       ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL TAKE_10000_FROM_HD_3       ; Expenses of 10000HD


                        LD A,27                         ; Message for Ship repairs complete
                        CALL GET_MESSAGE_POINTERB       ;


                        LD A,100                        ;
SHIP_REPAIRS_LOOP:
                        PUSH AF                         ;
                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Update LCD Text

                        LD BC,4050                      ; Set BC for delay
                        CALL DELAY1LOOP                 ; Make a delay
                        POP AF                          ;
                        DEC A                           ;
                        JR NZ,SHIP_REPAIRS_LOOP         ;

; Planet take off
SKIP_PURCHASE_SERVICE:
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Smooth scroll down screen with sound (planet or alien base)
                        CALL CLEAR_BUFFER               ; Flush the screen buffer to prevent planet flashing up

                        LD A,55                         ; MESSAGE FOR TAKE OFF
                        CALL GET_MESSAGE_POINTER        ;

                        LD B,64                         ; 64 lines to scroll down
C31814B:

                        PUSH BC                         ; Save scroll planet down loop
                        CALL SCROLL_PLAY_AREA_DOWN:     ; Scroll down the play area 1 pixel
                        CALL DISPLAY_TEXT_ONE_BY_ONE    ; Update LCD Text
                        LD BC,3050                      ; Set BC for delay
                        CALL DELAY1LOOP                 ; Make a delay
                        POP BC                          ; Restore  scroll planet down loop
                        DJNZ C31814B                    ; Jump back until complete take off

                        CALL MEMORY_SWITCH_4            ;
                        CALL RESTORE_RADAR_POINTER_TO_CURRENT_4 ; Reset radar pointer as we are firing

                        CALL ERASE_SECTOR               ; Erase sector after taking off
                        LD HL,BACKGROUND_SOUND_DATA     ;
                        CALL GENERAL_SOUND              ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SPARE
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PLANET_GRAPHIC_LOCATION_31862:DB 0,0                    ; Used to store planet graphic location
                        ; PLANET_LANDING_SCREEN_1

CYGNUS_GRAPHIC_LOCATION:DB 0,0                          ; Stores Cygnus graphic for when found
CYGNUS_FOUND:           DB 0                            ; Set to 1 when Cygnus is found
CYGNUS_FOUND_COUNTER:   DB 0                            ; Used to count scroll and when to display Cygnus

























                        ; 684K FREE HERE




if                      *> 40129                        ;
                        zeuserror "out of room"         ;
      endif                                             ;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Defaults to calling musical note on every interupt.
ORG                     40130                           ;

MUSIC_INTERUPT:

                        ; CALL MEMORY_SWITCH_4            ; Memory switch 4
                        DI                              ; Disable interrupts

                        PUSH AF                         ; Preserve all registers
                        PUSH BC                         ;
                        PUSH DE                         ;
                        PUSH HL                         ;
                        PUSH IX                         ;
                        EXX                             ;
                        EX AF,AF'                       ;;
                        PUSH AF                         ;
                        PUSH BC                         ;
                        PUSH DE                         ;
                        PUSH HL                         ;
                        PUSH IY                         ;
INTERUPT_SWITCH:        CALL MEMORY_SWITCH_4            ; Memory switch 4
INTERUPT_ADDRESS:       CALL play                       ; Do some interrupt stuff
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        POP IY                          ; Restore all registers
                        POP HL                          ;
                        POP DE                          ;
                        POP BC                          ;
                        POP AF                          ;
                        EXX                             ;
                        EX AF,AF'                       ;;
                        POP IX                          ;
                        POP HL                          ;
                        POP DE                          ;
                        POP BC                          ;
                        POP AF                          ;
                        ; CALL MEMORY_SWITCH_3            ; Memory switch 3
                        EI                              ; Enable interrupts

                        RETI                            ; Return from interrupt




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Cygnus is found
SET_CYGNUS_FOUND:

                        LD A,1                          ; Set A to 1 to set Cygnus Found
                        LD (CYGNUS_FOUND),A             ; Set Cygnus Found
                        LD (CYGNUS_FOUND_COUNTER),A     ; Set Cygnus scroll up position counter
                        CALL MEMORY_SWITCH_6            ; Memory switch 6

                        LD A,R                          ; Get random
                        CP 2                            ; Check for 2
                        JR NC,SKIP_CYGNUS_FOUND_GRAPHIC_A ; Skip to other graphic if not
                        LD HL,FOUND_CYGNUS_GRAPHIC_1_6  ; Set Cygnus found graphic 1

                        JP SKIP_CYGNUS_FOUND_GRAPHIC_B  ; Jump Set cygnus found 2 graphic

SKIP_CYGNUS_FOUND_GRAPHIC_A:

                        LD HL,FOUND_CYGNUS_GRAPHIC_2_6  ; Set Cygnus found graphic 2

SKIP_CYGNUS_FOUND_GRAPHIC_B:

                        LD (CYGNUS_GRAPHIC_LOCATION),HL ; Set the location varable

                        CALL MAKE_CURRENT_SECTOR_PLANET ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll planet up screen A=scroll duration
SCROLL_LANDING_UP_c31798:
                        ; LD (PLANET_GRAPHIC_LOCATION_31862),HL ; Store selected graphic address into 31862
                        ; LD A,64                        ; Height of screen to scroll up
C31814:                 ;
                        PUSH AF                         ;

                        CALL MEMORY_SWITCH_6            ; Memory switch 6

                        LD A,109                        ; Set line 0 (bottom of play area)
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864B ; Get screen address into HL Called with A=Line
                        ; POP AF                          ;

                        EX DE,HL                        ;
                        ; Place line of landing screen across the top of the console in the play area
                        ; DE=SCREEN ADDRESS
                        ; COPY 1 LINE OF DATA AT BOTTOM OF PLAY AREA
                        PUSH DE                         ;
                        LD HL,(PLANET_GRAPHIC_LOCATION_31862) ; Get selected graphic address
                        LD BC,32                        ; 32 collumns to complete
                        LDIR                            ; Copy the data
                        ; BOTTOM LINE DONE
                        ; UPDATE GRAPHIC LOCATION

                        LD (PLANET_GRAPHIC_LOCATION_31862),HL ; Update graphic pointer
                        POP DE                          ;

                        LD A,(PLANET_LANDING_MODE)      ; 0 for confrontation. 1 for landing
                        OR A                            ; Is it 1?
                        JR Z,SKIP_DISPLAYING_CYGNUS_ON_SCROLL ; If so then Land only for health boost and some repairs

                        ;
                        LD A,(CYGNUS_FOUND_COUNTER)     ;
                        INC A                           ;
                        LD (CYGNUS_FOUND_COUNTER),A     ;

                        CP 30                           ;
                        JR C,SKIP_DISPLAYING_CYGNUS_ON_SCROLL;
                        CP 54                           ;
                        JR NC,SKIP_DISPLAYING_CYGNUS_ON_SCROLL;


                        LD A,(CYGNUS_FOUND)             ; Is Cygnus found?
                        OR A                            ; CP 0
                        CALL NZ,DISPLAY_CYGNUS_ON_SCROLL_UP ; If not 0 then dicplay Cygnus line by line

SKIP_DISPLAYING_CYGNUS_ON_SCROLL:;


                        ; PUSH AF                         ; Copy the buffer to visible screen
                        CALL ZIPZAP_SCREEN_COPY         ;
                        ; POP AF                          ;

                        PUSH BC                         ;
                        ; PUSH AF                         ;
                        PUSH DE                         ;
                        PUSH HL                         ;
                        CALL DISPLAY_TEXT_ONE_BY_ONE    ;

                        LD A,(SET_WARNING_ON)           ; Is flashing warning enabled?
                        OR A                            ; CP 0                            ;
                        CALL NZ,FLASH_WARNING           ; Call warning flip flop if so

                        LD A,(SET_SERVICE_ON)           ; Is flashing SERVICE enabled?
                        OR A                            ; CP 0                            ;
                        CALL NZ,FLASH_SERVICE           ; Call SERVICE flip flop if so

                        CALL SCROLL_BUFFER_UP           ; 2

                        POP HL                          ;
                        POP DE                          ;
                        ;  POP AF                          ;
                        POP BC                          ;

                        POP AF                          ;
                        DEC A                           ; Move pointer to get next line address
                        JR NZ,C31814                    ;



                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset the up/down counter
RESET_UP_DOWN_COUNTER:
                        XOR A                           ; Reset A to zero
                        LD (UP_DOWN_COUNTER),A          ; Reset up/down counter
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 to up/down coordinate to move sprite down
UP_DOWN_SETTING_UP:

                        LD HL,UP_DOWN_SETTING           ;

                        DEC (HL)                        ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to up/down coordinate to move sprite down
UP_DOWN_SETTING_DOWN:

                        LD HL,UP_DOWN_SETTING           ;

                        INC (HL)                        ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll buffer up 8 hires lines
SCROLL_BUFFER_UP:

                        ; LD B,0                          ;
                        ; LD C,0                          ;
                        LD BC,0                         ;
                        PUSH BC                         ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864B;
                        POP BC                          ;
                        XOR A                           ; LD A,0                          ;
LP22:
                        PUSH AF                         ;
                        DEC B                           ;
                        PUSH BC                         ;
                        PUSH HL                         ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864B;
                        POP DE                          ;
                        PUSH HL                         ;
                        ; LD B,0                          ;
                        ; LD C,32                         ;
                        LD BC,32                        ;
                        LDIR                            ;
                        POP HL                          ;
                        POP BC                          ;
                        POP AF                          ;
                        INC A                           ;
                        CP 127                          ;
                        JR NZ,LP22                      ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cygnus is found so scroll it on
DISPLAY_CYGNUS_ON_SCROLL_UP:

                        INC E                           ;
                        INC E                           ;
                        INC E                           ;
                        INC E                           ;


                        PUSH HL                         ;
                        PUSH BC                         ;
                        ; LD HL,CYGNUS_GRAPHIC_LOCATION   ; Get current Cygnus graphic pointer
                        ; INC (HL)                        ; Move to next Cygnus graphic pointer
                        LD B,4                          ; Cygnus is 4 blocks wide

                        LD HL,(CYGNUS_GRAPHIC_LOCATION) ;

DISPLAY_CYGNUS_LOOP:
                        LD A,(HL)                       ; Get current Cygnus data into A
                        LD (DE),A                       ; Place to screen
                        INC HL                          ; Move to next graphic data
                        INC E                           ; Move to next collumn
                        DJNZ DISPLAY_CYGNUS_LOOP        ; Jump back for all 4 collumns


                        LD (CYGNUS_GRAPHIC_LOCATION),HL ; Update Cygnus graphic pointer


                        POP BC                          ;
                        POP HL                          ;

                        RET                             ; Ret
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Planet takeoff from landing sequence scroll
SCROLL_PLAY_AREA_DOWN:


                        ;   LD B,80                      ;
                        ;   LD C,16                         ;
                        LD BC,20496                     ;
                        PUSH BC                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH
                        POP BC                          ;
                        LD A,0                          ;
LP22B:
                        PUSH AF                         ;
                        INC B                           ;
                        PUSH BC                         ;
                        PUSH HL                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH
                        POP DE                          ;
                        PUSH HL                         ;
                        ; LD B,0                          ;
                        ; LD C,28                         ;
                        LD BC,28                        ;
                        LDIR                            ;
                        POP HL                          ;
                        POP BC                          ;
                        POP AF                          ;
                        INC A                           ;
                        CP 72                           ;
                        JR NZ,LP22B                     ;
                        ; CALL ERASE_SECTOR               ; Erase sector after taking off
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Planet takeoff from confrontation sequence scroll
SCROLL_BLANK_BUFFER_DOWN:;Move play area down 1 pixel (Used for taking off FROM CONFRONTATION);


                        LD B,64+16                      ;
                        LD C,16                         ;
                        PUSH BC                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH

                        LD DE,12288                     ;
                        ADD HL,DE                       ;


                        POP BC                          ;
                        LD A,0                          ;
LP22BB:
                        PUSH AF                         ;
                        INC B                           ;
                        PUSH BC                         ;
                        PUSH HL                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH

                        LD DE,12288                     ;
                        ADD HL,DE                       ;


                        POP DE                          ;
                        PUSH HL                         ;
                        ; LD B,0                          ;
                        ; LD C,28                         ;
                        LD BC,28                        ;
                        LDIR                            ;
                        POP HL                          ;
                        POP BC                          ;
                        POP AF                          ;
                        INC A                           ;
                        CP 72                           ;
                        JR NZ,LP22BB                    ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function not allowed
FUNCTION_NOT_ALLOWED:
                        LD A,75                         ; Function not allowed message
                        CALL GET_MESSAGE_POINTERB       ; Set message
                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Routine at 61348
ayctrl                  EQU 65533                       ; Control
aydata                  EQU 49149                       ; Data
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Sound called with HL=Sound data
GENERAL_SOUND:
                        ld d,0                          ; start with register 0.
w8912a:
                        ld a,(hl)                       ; value to write.

                        cp 255                          ; Is data 255?
                        call nz,outer                   ; If not then change value
                        inc hl                          ; Move to next data
                        inc d                           ; Move to next register
                        ld a,d                          ; A=Register number for testing
                        cp 14                           ; Are we at last register?
                        jr nz,w8912a                    ; repeat until done.
                        ret                             ; Return


outer                   ld bc,ayctrl                    ; select control port
                        out (c),d                       ; send specified value
                        ld bc,aydata                    ; select data port
                        out (c),a                       ; send specified value
                        ret                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset sound
RESET_ALL_SOUNDS:
                        LD HL,RESET_SOUND_DATA          ; Data for sound reset
                        CALL GENERAL_SOUND              ; Reset sound
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESET_SOUND_DATA:       DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make torpedo sound
TORPEDO_SOUND:

                        ; Fine| |Course
                        DB 0,0                          ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 200,10                       ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 0,0                          ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C


                        DB 25                           ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB %00010001                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
                        DB %00010000                    ; (8) 4-bit (0-15) channel A volume
                        DB %00000010                    ; (9) 4-bit (0-15) channel B volume
                        DB %00000000                    ; (10)4-bit (0-15) channel C volume

                        DB 1                            ; (11) 8-bit (0-255) Envelope fine duration
                        DB 40                           ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 9                            ; (13) 4-bit (0-15)  Envelope shape
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Make torpedo sound
ALIEN_TORPEDO_SOUND_3D:

                        ; Fine| |Course
                        DB 0,0                          ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 0,0                          ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 100,10                       ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C


                        DB 15                           ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB %00010001                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
                        DB %00010000                    ; (8) 4-bit (0-15) channel A volume
                        DB %00000010                    ; (9) 4-bit (0-15) channel B volume
                        DB %00000000                    ; (10)4-bit (0-15) channel C volume

                        DB 0                            ; (11) 8-bit (0-255) Envelope fine duration
                        DB 40                           ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 9                            ; (13) 4-bit (0-15)  Envelope shape
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exploding alien sound data
ALIEN_EXPLODING_SOUND:
                        ; Pitch
                        ; Fine| |Course
                        DB 0,0                          ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,15                       ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 0,0                          ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        ;    Not used
                        ;        |||
                        DB 31                           ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB 1                            ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
                        DB %00010000                    ; (8) 4-bit (0-15) channel A volume
                        DB %00010000                    ; (9) 4-bit (0-15) channel B volume
                        DB %00000000                    ; (10)4-bit (0-15) channel C volume

                        DB 1                            ; (11) 8-bit (0-255) Envelope fine duration
                        DB 50                           ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 9                            ; (13) 4-bit (0-15)  Envelope shape















; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Background noise data
BACKGROUND_SOUND_DATA:
                        ; Pitch
                        ; Fine| |Course
                        DB 255,255                      ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,255                      ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 255,255                      ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        ; Not used
                        ;        |||

                        DB 19                           ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ; N/A  CBACBA
                        ;   ||||||||
sndmix:                 DB %00000001                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
sndvola:                DB 4                            ; (8) 4-bit (0-15) channel A volume
sndvolb:                DB 255                          ; (9) 4-bit (0-15) channel B volume
sndvolc:                DB 255                          ; (10)4-bit (0-15) channel C volume

envfine:                DB 255                          ; (11) 8-bit (0-255) Envelope fine duration
envcourse:              DB 255                          ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
envshape:               DB 13                           ; (13) 4-bit (0-15)  Envelope shape

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Exploding alien sound data
DISPLAY_SITES_SOUND:
                        ; Pitch
                        ; Fine| |Course
                        DB 33,1                         ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 20,66                        ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 5,2                          ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        ;    Not used
                        ;        |||
                        DB 6                            ; (6) 5-bit (0-31) Noise pitch

                        ;           Noise
                        ;      Tone|  |
                        ; Not used CBACBA
                        ;   ||||||||
                        DB %00111000                    ; (7) 8-bit Mixer

;                              Volume
                        ;       ||||
;                  Use Envelope|||||
                        DB %00010000                    ; (8) 4-bit (0-15) channel A volume
                        DB %00010000                    ; (9) 4-bit (0-15) channel B volume
                        DB %00010000                    ; (10)4-bit (0-15) channel C volume

                        DB 20                           ; (11) 8-bit (0-255) Envelope fine duration
                        DB 5                            ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 9                            ; (13) 4-bit (0-15)  Envelope shape

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alarm sound data
                        ; Pitch
                        ; Fine| |Course
ALARM_SOUND_DATA:
                        DB 0,1                          ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,255                      ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 255,255                      ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        ;    Not used
                        ;        |||
                        DB 0                            ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;     CBACBA
                        ;   ||||||||
                        DB %00001000                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
                        DB %00010000                    ; (8) 4-bit (0-15) channel A volume
                        DB 0                            ; (9) 4-bit (0-15) channel B volume
                        DB 0                            ; (10)4-bit (0-15) channel C volume

                        DB %11111111                    ; (11) 8-bit (0-255) Envelope fine duration
                        DB %00001111                    ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB %00001001                    ; (13) 4-bit (0-15)  Envelope shape

; 0      \__________     single decay then off

; 1      /|_________     single attack then off

; 8      \|\|\|\|\|\     repeated decay

; 9      \__________     single decay then off

; 10      \/\/\/\/\/\     repeated decay-attack

;          _________
; 11      \|              single decay then hold

; 12      /|/|/|/|/|/     repeated attack
;         __________
; 13      /               single attack then hold

; 14      /\/\/\/\/\/     repeated attack-decay

; 15      /|_________     single attack then off

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Tracker sound data
                        ; Pitch
                        ; Fine| |Course
TRACKER_SOUND_DATA:
                        DB 0,220                        ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 0,220                        ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 255,255                      ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        ;    Not used
                        ;        |||
                        DB 1                            ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB %00010000                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;    Use Envelope|||||
                        DB 255                          ; (8) 4-bit (0-15) channel A volume
                        DB %00010000                    ; (9) 4-bit (0-15) channel B volume
                        DB 255                          ; (10)4-bit (0-15) channel C volume

                        DB %01111111                    ; (11) 8-bit (0-255) Envelope fine duration
                        DB %00001111                    ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 1                            ; (13) 4-bit (0-15)  Envelope shape

; 0      \__________     single decay then off

; 1      /|_________     single attack then off

; 8      \|\|\|\|\|\     repeated decay

; 9      \__________     single decay then off

; 10      \/\/\/\/\/\     repeated decay-attack

;           _________
; 11      \|              single decay then hold

; 12      /|/|/|/|/|/     repeated attack
;         __________
; 13     /               single attack then hold

; 14      /\/\/\/\/\/     repeated attack-decay

; 15      /|_________     single attack then off



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AMBIENCE_SOUND1:

                        ; Fine| |Course
                        DB 255,255                      ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,255                      ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
CONTROLS_PITCH:         DB 30,0                         ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

                        DB 255                          ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB %00100000                    ; (7) 8-bit Mixer
;                Volume
                        ;  ||||
;                  Use Envelope|||||
                        DB 255                          ; (8) 4-bit (0-15) channel A volume
                        DB 255                          ; (9) 4-bit (0-15) channel B volume
                        DB %00010000                    ; (10)4-bit (0-15) channel C volume

                        DB 0                            ; (11) 8-bit (0-255) Envelope fine duration
AMBIENCE_SOUND1_DURATION:DB 10                          ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 13                           ; (13) 4-bit (0-15)  Envelope shape

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TAKEOFF_SOUND1:

                        ; Fine| |Course
                        DB 255,255                      ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,255                      ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
                        DB 0                            ;
TAKEOFF_PITCH:          DB 0                            ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C

TAKEOFF_PITCH_NOISE:    DB 0                            ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;      CBACBA
                        ;    ||||||||
                        DB %00100001                    ; (7) 8-bit Mixer
;                Volume
                        ;  ||||
;                  Use Envelope|||||
                        DB 8                            ; (8) 4-bit (0-15) channel A volume
                        DB 255                          ; (9) 4-bit (0-15) channel B volume
                        DB %00010000                    ; (10)4-bit (0-15) channel C volume

                        DB 0                            ; (11) 8-bit (0-255) Envelope fine duration
TAKEOFF_SOUND_DURATION: DB 0                            ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 1                            ; (13) 4-bit (0-15)  Envelope shape
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

AMBIENCE_SOUND4_SEQUENCE_DATA:
                        DEFB 20,0,19,20,0,0,0,0,0,0,0,0,0,20,0,19,10,0,0,0,0,0,0,0,0,0,255;
AMBIENCE_SOUND4_SEQUENCE_COUNTER:DEFB 0                 ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
AMBIENCE_SOUND4_DATA:

                        ; Fine| |Course
                        DB 255,255                      ; (0) 8 bit 0-255 (1) 4 bit 0 to 15 tone registers, channel A
                        DB 255,255                      ; (2) 8 bit 0-255 (3) 4 bit 0 to 15 tone registers, channel B
AMBIENCE_SOUND4_PITCH:  DB 255,0                        ; (4) 8 bit 0-255 (5) 4 bit 0 to 15 tone registers, channel C


                        DB 0                            ; (6) 5-bit (0-31) Noise pitch

                        ;        Noise
                        ;   Tone|  |
                        ;   Not used CBACBA
                        ;    ||||||||
                        DB %00100000                    ; (7) 8-bit Mixer

;                Volume
                        ;  ||||
;                  Use Envelope|||||
                        DB 255                          ; (8) 4-bit (0-15) channel A volume
                        DB 255                          ; (9) 4-bit (0-15) channel B volume
                        DB %0010000                     ; (10)4-bit (0-15) channel C volume

                        DB 0                            ; (11) 8-bit (0-255) Envelope fine duration
DURATION:               DB 150                          ; (12) 8-bit (0-255) Envelope course duration

                        ; Not used
                        ;             ||||
                        DB 0                            ; (13) 4-bit (0-15)  Envelope shape


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
KEY_26623:              DB 0                            ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get keys pressed for pause game and movement/fire. Result in A

GET_KEYS_c27096l:

                        PUSH BC                         ;
                        LD BC,49150                     ; Port for H, J, K, L, Enter
                        IN A,(C)                        ; Read port


                        BIT 4,A                         ; Is H pressed to pause the game?
                        JR NZ,C27115                    ; If so then skip checking A-G to see if A is pressed to unpause game
                        LD BC,65022                     ; Port to read keys A to G
C27109:

                        LD BC,65022                     ; Port to read keys A to G
                        ; IN A,(C)                        ; Read port
                        ;  BIT 0,A                         ; Is key D pressed to unpause the game
                        ;  JR NZ,SKIP_HACK_TEST            ;
                        ;  OUT (254),A                     ;

                        ;  CALL TAKE_1_FROM_HD             ;
                        ;  OUT (254),A                     ;
; SKIP_HACK_TEST:
                        IN A,(C)                        ; Read port
                        BIT 2,A                         ; Is key D pressed to unpause the game

                        JR NZ,C27109                    ; Jump back to wait for the S key until it is pressed to freeze the game


C27115:
                        LD BC,61438                     ; Port to read keys 6, 7, 8, 9, 0
                        IN A,(C)                        ; Read keys 6, 7, 8, 9, 0
                        LD C,A                          ; C=key pressed
                        LD A,(KEY_26623)                ;
                        CPL                             ;
                        AND 1                           ;
                        LD B,A                          ;
                        LD A,C                          ;
                        LD (KEY_26623),A                ;
                        OR B                            ;
                        POP BC                          ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TEXT_CHARACTER_DATA_OFFSET:
; Text character data offset
                        DB 250,219,31,119               ;
                        DB 62,1,211,95,6,0,16,254       ;
                        DB 219,159,230,1,32,250,151,211 ;
                        DB 95,16,254,35,27,122,179,32   ;
                        DB 222,251,201,0,1,2,3,4        ;
                        DB 5,6,0,0,0,0,0,0              ;
SIDE_SCROLLING_ALIEN_MISSILE:
                        DB 0,0,0,0,0,0,0,0              ;  Side scrolling alien missile
                        DB 0, 0, 0, 0, 1, 128, 3, 192   ;
                        DB 3, 192, 1, 128, 0, 0, 0, 0   ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
; Title border corners
BORDER_CORNER_GRAPHICS:
                        DB %11111111                    ;
                        DB %11111100                    ;
                        DB %11110000                    ;
                        DB %11100000                    ;
                        DB %11000000                    ;
                        DB %11000000                    ;
                        DB %10000000                    ;
                        DB %10000000                    ;



                        DB %11111111                    ;
                        DB %00111111                    ;
                        DB %00001111                    ;
                        DB %00000111                    ;
                        DB %00000011                    ;
                        DB %00000011                    ;
                        DB %00000001                    ;
                        DB %00000001                    ;


                        DB %10000000                    ;
                        DB %10000000                    ;
                        DB %11000000                    ;
                        DB %11000000                    ;
                        DB %11100000                    ;
                        DB %11110000                    ;
                        DB %11111100                    ;
                        DB %11111111                    ;


                        DB %00000001                    ;
                        DB %00000001                    ;
                        DB %00000011                    ;
                        DB %00000011                    ;
                        DB %00000111                    ;
                        DB %00001111                    ;
                        DB %00111111                    ;
                        DB %11111111                    ;

; SPARE
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;

                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;

                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0,0,0,0,0              ;
                        DB 0,0,0,0                      ; :

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Text character set
TEXT_GRAPHICS_DATA_b32777:
                        DB 255,255,255,255,255,255,255,255 ; Text cursor
                        defb 255, 255, 255, 255, 192, 3, 128, 1 ; LED block graphic left  "
                        defb 128, 1, 192, 3, 255, 255, 255, 255 ; LED block graphic right #
                        DB 8,62,40,62,10,62,8,0         ; $
                        DB 98,100,8,16,38,70,0,0        ; %
                        defb 0, 48, 72, 65, 90, 74, 49, 0 ; &  Gan
                        defb 0, 0, 0, 8, 148, 148, 212, 0 ; '
                        DB 4,8,8,8,8,4,0,0              ; (
                        DB 32,16,16,16,16,32,0,0        ; )
                        DB 0,20,8,62,8,20,0,0           ; *
                        DB 0,8,8,62,8,8,0,0             ; +
                        DB 0,0,0,0,8,8,16,0             ; ,
                        DB 0,0,0,62,0,0,0,0             ; -
                        DB 0,0,0,0,24,24,0,0            ; .
                        DB 0,2,4,8,16,32,0,0            ; /
                        DB 0,126,66,70,70,126,0,0       ; 0
                        DB 0,24,8,8,28,28,0,0           ; 1
                        DB 0,126,6,126,64,126,0,0       ; 2
                        DB 0,124,4,126,6,126,0,0        ; 3
                        DB 0,96,102,126,6,6,0,0         ; 4
                        DB 0,126,64,126,6,126,0,0       ; 5
                        DB 0,124,64,126,70,126,0,0      ; 6
                        DB 0,126,6,12,24,24,0,0         ; 7
                        DB 0,60,36,126,102,126,0,0      ; 8
                        DB 0,126,66,126,6,6,0,0         ; 9
                        DB 0,24,24,0,24,24,0,0          ; :
                        DB 0,16,0,0,16,16,32,128        ; ;
                        DB 0,4,8,16,8,4,0,0             ; <
                        DB 0,0,62,0,62,0,0,0            ; =
                        DB 0,16,8,4,8,16,0,0            ; >
                        DB 60,66,4,8,0,8,0,0            ; ?
                        DB 60,74,86,94,64,60,0,0        ; @
                        DB 0,126,70,126,70,70,0,0       ; A
                        DB 0,124,98,124,98,124,0,0      ; B
                        DB 0,126,70,64,70,126,0,0       ; C
                        DB 0,126,70,70,70,126,0,0       ; D
                        DB 0,126,96,126,96,126,0,0      ; E
                        DB 0,126,96,126,96,96,0,0       ; F
                        DB 0,126,64,78,70,126,0,0       ; G
                        DB 0,98,98,126,98,98,0,0        ; H
                        DB 0,24,24,24,24,24,0,0         ; I
                        DB 0,12,12,12,12,60,0,0         ; J
                        DB 0,100,100,126,70,70,0,0      ; K
                        DB 0,96,96,96,96,126,0,0        ; L
                        DB 0,126,86,86,86,86,0,0        ; M
                        DB 0,126,70,70,70,70,0,0        ; N
                        DB 0,126,98,98,98,126,0,0       ; O
                        DB 0,126,98,126,96,96,0,0       ; P
                        DB 0,124,100,100,100,126,0,0    ; Q
                        DB 0,126,98,124,70,70,0,0       ; R
                        DB 0,126,96,126,6,126,0,0       ; S
                        DB 0,126,24,24,24,24,0,0        ; T
                        DB 0,98,98,98,98,126,0,0        ; U
                        DB 0,98,98,98,52,24,0,0         ; V
                        DB 0,106,106,106,106,126,0,0    ; W
                        DB 0,98,98,60,70,70,0,0         ; X
                        DB 0,98,98,126,24,24,0,0        ; Y
                        DB 0,126,6,24,96,126,0,0        ; Z
                        DB 14,8,8,8,8,14,0,0            ; [
                        DB 0,64,32,16,8,4,0,0           ; \
                        DB 112,16,16,16,16,112,0,0      ; ]
                        DB 16,56,84,16,16,16,0,0        ; arrow pointing up
                        DB 0,0,0,0,0,0,255,0            ; _
                        DB 0,0,24,0,0,0,0,0             ; -
                        DB 0,0,60,36,0,0,0,0            ; |-|
                        DB 0,24,126,66,0,0,0,0          ; |--|
                        DB 0,24,126,189,129,0,0,0       ; |---|

; Currency (Upside down Yen inside C)
                        DB %01111110                    ;
                        DB %11101011                    ; Currency (Upside down Yen inside C)
                        DB %11011100                    ;
                        DB %11001000                    ;
                        DB %11010100                    ;
                        DB %11100011                    ;
                        DB %01111110                    ;
                        DB %00000000                    ; was d

; Alien name graphics
                        defb 0, 96, 80, 99, 85, 85, 99, 0 ; e BazzaHs
                        defb 0, 0, 59, 8, 17, 34, 187, 0 ; f
                        defb 0, 1, 129, 153, 41, 41, 157, 0 ; g
                        defb 0, 64, 76, 208, 72, 68, 88, 0 ; h

                        defb 0, 72, 74, 72, 74, 42, 18, 0 ; i Vills
                        defb 0, 0, 166, 168, 164, 162, 172, 0 ; j

                        defb 0, 48, 74, 66, 90, 74, 51, 0 ; k Gubbins
                        defb 0, 0, 162, 162, 179, 170, 179, 0 ; l
                        defb 0, 0, 32, 4, 42, 170, 42, 0 ; m
                        defb 0, 0, 96, 128, 64, 32, 192, 0 ; n

                        defb 0, 96, 85, 97, 85, 85, 85, 0 ; o Ribat
                        defb 0, 0, 0, 8, 148, 84, 142, 0 ; p
                        defb 0, 0, 128, 192, 128, 128, 96, 0 ; q

                        defb 0, 48, 68, 68, 70, 69, 53, 0 ; r  Cholp
                        defb 0, 0, 36, 84, 84, 84, 39, 0 ; s
                        defb 0, 0, 96, 80, 96, 64, 64, 0 ; t

                        defb 0, 48, 68, 68, 70, 69, 53, 0 ; u Chon
                        defb 0, 0, 34, 85, 85, 85, 37, 0 ; v

                        ; DB 0,68,84,84,84,40,0,0         ; w
                        DB %00000000                    ;
                        DB %00000110                    ;
                        DB %00001001                    ;
                        DB %00001001                    ;
                        DB %00000110                    ;
                        DB %00000000                    ;
                        DB %00000000                    ;
                        DB %00000000                    ;

; Menu arrows
                        DB %00001000                    ;
                        DB %00000100                    ; --->
                        DB %00000010                    ;
                        DB %11111111                    ;
                        DB %00000010                    ;
                        DB %00000100                    ;
                        DB %00001000                    ;
                        DB %00000000                    ;

                        DB %00010000                    ;
                        DB %00100000                    ;
                        DB %01000000                    ; <---
                        DB %11111111                    ;
                        DB %01000000                    ;
                        DB %00100000                    ;
                        DB %00010000                    ;
                        DB %00000000                    ;

; More alien name graphics
                        defb 0, 80, 82, 101, 85, 85, 74, 0 ; z
                        defb 0, 0, 114, 21, 38, 68, 115, 0 ; { Koze

                        defb 0, 80, 82, 85, 86, 84, 35, 0 ; | Vendi
                        defb 0, 0, 33, 81, 83, 85, 83, 0 ; }
                        defb 0, 0, 64, 0, 64, 64, 64, 0 ; ~

                        DB 66,153,161,161,153,66,60     ;


; LED Font for timer
                        defb 0, 60, 66, 66, 0, 66, 66, 60;
                        defb 0, 0, 2, 2, 0, 2, 2, 0     ;
                        defb 0, 60, 2, 2, 60, 64, 64, 60;
                        defb 0, 60, 2, 2, 60, 2, 2, 60  ;
                        defb 0, 0, 66, 66, 60, 2, 2, 0  ;
                        defb 0, 60, 64, 64, 60, 2, 2, 60;
                        defb 0, 60, 64, 64, 60, 66, 66, 60;
                        defb 0, 60, 2, 2, 0, 2, 2, 0    ;
                        defb 0, 60, 66, 66, 60, 66, 66, 60;
                        defb 0, 60, 66, 66, 60, 2, 2, 60;
                        defb 0, 0, 24, 24, 0, 24, 24, 0 ;



; Data block at 33536
; b33536                  DB 0                            ;




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display large graphic
; Data Byte 1/2-screen address, 3=rows used, 4=collumns used
DISPLAY_LARGE_GRAPHIC:

                        LD L,(IX+0)                     ;
                        LD H,(IX+1)                     ; Get start screen address

                        LD A,(IX+2)                     ; Get number of rows
                        LD C,(IX+3)                     ; Get number of collumns

                        INC IX                          ; Move IX to graphic data
                        INC IX                          ;
                        INC IX                          ;
                        INC IX                          ;

DISPLAY_LARGE_GRAPHIC_LOOP3:
                        ; PUSH HL                         ; Save original screen address
                        PUSH AF                         ; Save rows loop

                        LD A,8                          ; 8 Hi res lines
DISPLAY_LARGE_GRAPHIC_LOOP1:

                        PUSH AF                         ; Save Hires lines loop
                        LD B,C                          ; Get collumns (13 columns)
DISPLAY_LARGE_GRAPHIC_LOOP2:
                        LD A,(MERGE_SPRITE+1)           ; Get sprite merge status
                        OR A                            ; Is it 0?
                        JR Z,SKIP_MERGE                 ; Jump merge if so

                        LD A,(IX+0)                     ; Get graphic data
                        OR (HL)                         ; Merge with what is already on screen
                        JP CONTINUE_WITH_GRAPHIC        ;
SKIP_MERGE:
                        LD A,(IX+0)                     ; Get graphic data
CONTINUE_WITH_GRAPHIC:
                        LD (HL),A                       ; Place graphic data to screen
                        INC IX                          ; Move to next graphic data
                        INC L                           ; Move to next screen address to the right

                        DJNZ DISPLAY_LARGE_GRAPHIC_LOOP2 ; Jump back until all collumns are done

                        LD A,L                          ; Setup A for a subtraction
                        SUB C                           ; Subtract collumns to go back to begining of graphic for next Hi res line
                        LD L,A                          ; Update screen address
; NextScaneLine:  ;LB8CC  Taken from Sabre Wulf
; Lb8cc
                        INC H                           ;
                        LD A,H                          ;
                        AND 7                           ;
                        JR NZ,SKIP_NEXT_SCAN_LINE       ;
                        LD A,L                          ;
                        ADD A,32                        ;
                        LD L,A                          ;
                        AND 224                         ;
                        JR Z,SKIP_NEXT_SCAN_LINE        ;
                        LD A,H                          ;
                        SUB 8                           ;
                        LD H,A                          ;

SKIP_NEXT_SCAN_LINE:

                        ; INC H                           ; Move to next screen Hires line

                        POP AF                          ; Restore Hi res lines loop
                        DEC A                           ; Take one from Hi res lines loop
                        JR NZ,DISPLAY_LARGE_GRAPHIC_LOOP1 ; Jump back until all Hi res lines loop are completed

                        POP AF                          ; Restore rows loop
                        ;  LD DE,32                        ; Setup DE for addition
                        ; ADD HL,DE                       ; Update screen address for next text line
                        DEC A                           ; Take one from rows loop
                        JR NZ,DISPLAY_LARGE_GRAPHIC_LOOP3 ; Jump back until all rows are completed
                        RET                             ; Return




















































; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flip flop alarm mute set to on/off
ALARM_MUTE_ON_OFF:
                        LD A,(ALARM_SOUND_MUTE)         ; Get alarm sound mute status
                        CPL                             ; If 0 then 255, if 255 then 0
                        LD (ALARM_SOUND_MUTE),A         ; Update alarm sound mute status
                        OR A                            ; Is it 0 for mute off?
                        JR Z,SET_ALARM_MUTE_ON          ; Jump to Mute On message if so
SET_ALARM_MUTE_OFF:
                        LD A,36                         ; Set message for Mute off
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        RET                             ; Return

SET_ALARM_MUTE_ON:      ;Set alarm mute on              ;

                        LD A,35                         ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flip flop Shields set to on/off
SHIELDS_ON_OFF:

                        LD A,(GAME_MODE)                ; Are we side scrolling?
                        OR A                            ;
                        RET NZ                          ; Return if so


                        LD A,(SHIELDS_ON)               ; Get Shields on/off status
                        CPL                             ; If 0 then 255, if 255 then 0
                        LD (SHIELDS_ON),A               ; Update Shields on/off status

                        OR A                            ; Is it 0 for Shields on?
                        JR NZ,SET_SHIELDS_ON            ; Jump to Shields On message if so

SET_SHIELDS_OFF:        ;Set Shields off                ;
                        LD A,77                         ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD HL,DISPLAY_SITES_SOUND       ;
                        JP END_SET_SHIELDS              ; Return

SET_SHIELDS_ON:         ;Set Shields on                 ;
                        LD A,78                         ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD HL,BACKGROUND_SOUND_DATA     ;

END_SET_SHIELDS:
                        CALL GENERAL_SOUND              ;

MANUAL_SET_SHIELDS:     CALL MEMORY_SWITCH_1            ; Memory switch 1
                        CALL COCKPIT_COLOUR_ENTRY_1     ;

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flip flop sites set to on/off
SITES_ON_OFF:

                        LD A,(LED_STATUS_SCREEN)        ; Get LED Status screen on/off status
                        OR A                            ; LED Status screen on/off status 0?
                        RET NZ                          ; Return if not so LED Status screen is on


                        LD A,(GAME_MODE)                ; Are we side scrolling?
                        OR A                            ;
                        RET NZ                          ; Return if so

                        LD A,(SERVICES_ON)              ; Get Services status
                        OR A                            ; Is Services message switched off?
                        RET NZ                          ; If services are on then stop sites enabling

                        LD A,(SITES_ON)                 ; Get Sites on/off status
                        CPL                             ; If 0 then 255, if 255 then 0
                        LD (SITES_ON),A                 ; Update Sites on/off status
                        OR A                            ; Is it 0 for Sites on?
                        JR Z,SET_SITES_OFF              ; Jump to Sites On message if so

SET_SITES_ON:           ;Set sites off                  ;

                        LD A,44                         ; Set message for Sites on
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        LD HL,DISPLAY_SITES_SOUND       ;

                        JP END_SET_SITES                ; Return

SET_SITES_OFF:          ;Set sites on                   ;

                        LD A,45                         ; Set message for sites off
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD HL,BACKGROUND_SOUND_DATA     ;



END_SET_SITES:
                        CALL GENERAL_SOUND              ;

                        XOR A                           ; A=0
                        LD (ALIEN_TRACK_LOCK_TIMER),A   ; Set alien track lock timer
                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flip flop Service menu set to on/off
SERVICES_ON_OFF:
                        LD A,(LED_STATUS_SCREEN)        ; Get LED Status screen on/off status
                        OR A                            ; LED Status screen on/off status 0?
                        RET NZ                          ; Return if not so LED Status screen is on

                        LD A,(SITES_ON)                 ; If sites are on then prevent services
                        OR A                            ; Sites on/off status 0?
                        RET NZ                          ; Return if not so sites are on
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD A,(SERVICES_ON)              ; Get Services on/off status
                        OR A                            ; Services off?
                        JR NZ,SET_SERVICES_OFF          ; If not then turn them off
                        OR A                            ; Services off?
                        JR Z,SET_SERVICES_ON            ; If so then turn them on

                        RET                             ;

SET_SERVICES_OFF:       ;Set Services off               ;
                        XOR A                           ; Message 0
                        LD (SERVICES_ON),A              ; Update Services on/off status

                        ; CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD A,7                          ;
                        CALL CLEAR_EMPTY_SCREEN_BUFFER  ;
                        RET                             ;

SET_SERVICES_ON:        ;Set services on                ;
                        ; LD A,7                          ;
                        CALL CLEAR_EMPTY_BUFFER         ;

                        LD A,255                        ;
                        LD (SERVICES_ON),A              ; Update Services on/off status

                        LD A,52                         ; Set message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        CALL GET_MESSAGE_POINTER_LARGE_SCREEN;
                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flip flop LED Status screen set to on/off
LED_STATUS_SCREEN_ON_OFF:

                        LD A,(SITES_ON)                 ; If sites are on then prevent services
                        OR A                            ; Sites on/off status 0?
                        RET NZ                          ; Return if not so sites are on

                        LD A,(SERVICES_ON)              ; Get Services on/off status
                        OR A                            ; Services on/off status 0?
                        RET NZ                          ; Return if not so Services are on
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ; CALL DONT_ABORT_MISSION

                        LD A,(LED_STATUS_SCREEN)        ; Get LED Status screen on/off status
                        OR A                            ; LED Status screen off?
                        JR NZ,SET_LED_STATUS_SCREEN_OFF ; If not then turn it off
                        ;  OR A                            ; LED Status screen off?
                        JR Z,SET_LED_STATUS_SCREEN_ON   ; If so then turn it on

                        RET                             ;

SET_LED_STATUS_SCREEN_OFF:;Set LED Status screen off    ;
                        XOR A                           ; Message 0
                        LD (LED_STATUS_SCREEN),A        ; LED Status screen on/off status
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        CALL DONT_ABORT_MISSION         ;
                        RET                             ;

SET_LED_STATUS_SCREEN_ON:;Set LED Status screen on      ;

                        LD A,1                          ;
                        LD (LED_STATUS_SCREEN),A        ; Update Services on/off status

                        LD A,71                         ; Set message to displaying Computer Registry
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        CALL DONT_ABORT_MISSION         ;

                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display Torpedo into screen buffer
DISPLAY_TORPEDO:
                        LD A,1                          ;
                        LD (MERGE_SPRITE+1),A           ;
                        CALL MEMORY_SWITCH_1            ; Memory switch 1

                        LD HL,TORPEDO_COUNTER           ;
                        INC (HL)                        ;
                        LD A,(HL)                       ;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        CP 16                           ;
                        JP C,NEXT_TORPEDO5              ; LESS THAN 18     2x2
                        JP NC,SET_TORPEDO_5             ; Greater than 18
NEXT_TORPEDO5:

                        CP 8                            ;
                        JP C,NEXT_TORPEDO4              ; LESS THAN 16
                        JP NC,SET_TORPEDO_4             ; Greater than 16

NEXT_TORPEDO4:

                        CP 6                            ;
                        JP C,NEXT_TORPEDO3              ; LESS THAN 13
                        JP NC,SET_TORPEDO_3             ; Greater than 13


NEXT_TORPEDO3:


                        CP 4                            ;
                        JP C,NEXT_TORPEDO2              ; LESS THAN 10
                        JP NC,SET_TORPEDO_2             ; Greater than 10

NEXT_TORPEDO2:
                        CP 2                            ;
                        JP C,NEXT_TORPEDO0              ; LESS THAN 10
                        JP NC,SET_TORPEDO_1             ; Less than 5

NEXT_TORPEDO0:

                        RET                             ;





                        ; Jumps back here after setting torpedo info
NEXT_TORPEDO1:

                        ; LD DE,16584+1024  ;screen address
                        LD A,(TORPEDO_UP_DOWN)          ;
                        ; PUSH HL
                        ; LD A,10
                        CALL GET_SCREEN_BUFFER_TEXT_ADDRESS_c29864;
                        ; POP HL

                        LD DE,15                        ;
                        ADD HL,DE                       ; Move rocket to screen center

                        ; IX=GRAPHIC
                        ; HL=SCREEN ADDRESS

                        ; LD A,(TORPEDO_SIZE)
                        ; LD H,(IX+1) ;Get screen address
                        ; LD L,(IX+0)


                        LD A,(TORPEDO_WIDTH)            ; Get collumns
                        LD C,A                          ;
                        LD A,(TORPEDO_SIZE)             ; Get rows


                        CALL DISPLAY_LARGE_GRAPHIC_LOOP3 ; Display large graphic

                        LD A,(TORPEDO_UP_DOWN)          ;
                        CP 8                            ;
                        JP C,SKIP_MOVING_TORPEDO_UP     ;
                        SUB 1                           ;
                        LD (TORPEDO_UP_DOWN),A          ;
SKIP_MOVING_TORPEDO_UP:
                        LD A,(TORPEDO_COUNTER)          ;
                        CP 20                           ;
                        JP NC,RESET_TORPEDO             ;

; Do we need to Colour torpedo?
                        LD A,(TORPEDO_COUNTER)          ;
                        CP 6                            ;
                        RET NC                          ;
; Colour torpedo
                        LD HL,ATTR1+463-97-31           ;
                        LD B,3                          ;
                        LD A,66                         ;
COLOUR_TORPEDO_LOOP:
                        LD (HL),A                       ; 66
                        INC HL                          ;
                        LD (HL),70                      ;
                        INC HL                          ;
                        LD (HL),70                      ;
                        INC HL                          ;
                        LD (HL),A                       ;
                        LD DE,29                        ;
                        ADD HL,DE                       ;
                        DJNZ COLOUR_TORPEDO_LOOP        ;
                        LD (HL),A                       ;
                        INC HL                          ;
                        LD (HL),70                      ;
                        INC HL                          ;
                        LD (HL),70                      ;
                        INC HL                          ;
                        LD (HL),A                       ;

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_TORPEDO_1:
                        LD IX,TORPEDO1_1                ; TORPEDS graphics data
                        LD A,5                          ; 40 Hires lines
                        LD (TORPEDO_SIZE),A             ;
                        LD A,5                          ;
                        LD (TORPEDO_WIDTH),A            ;
                        JP NEXT_TORPEDO1                ;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_TORPEDO_2:
                        LD IX,TORPEDO2_1                ; TORPEDS graphics data
                        LD A,4                          ; 32 Hires lines
                        LD (TORPEDO_SIZE),A             ;
                        LD A,4                          ;
                        LD (TORPEDO_WIDTH),A            ;

                        JP NEXT_TORPEDO1                ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_TORPEDO_3:
                        LD IX,TORPEDO3_1                ; TORPEDS graphics data
                        LD A,3                          ; 24 Hires lines
                        LD (TORPEDO_SIZE),A             ;

                        LD A,3                          ;
                        LD (TORPEDO_WIDTH),A            ;
                        JP NEXT_TORPEDO1                ;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_TORPEDO_4:
                        LD IX,TORPEDO4_1                ; TORPEDS graphics data
                        LD A,2                          ; 16 Hires lines
                        LD (TORPEDO_SIZE),A             ;

                        LD A,2                          ;
                        LD (TORPEDO_WIDTH),A            ;
                        JP NEXT_TORPEDO1                ;
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_TORPEDO_5:
                        LD IX,TORPEDO5_1                ; TORPEDS graphics data
                        LD A,2                          ; 8 Hires lines
                        LD (TORPEDO_SIZE),A             ;
                        LD A,2                          ;
                        LD (TORPEDO_WIDTH),A            ;
                        JP NEXT_TORPEDO1                ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESET_TORPEDO:
                        XOR A                           ;
                        LD (FIRE_ON),A                  ;
                        LD (TORPEDO_COUNTER),A          ;
                        LD A,16                         ;
                        LD (TORPEDO_UP_DOWN),A          ;

                        LD HL,BACKGROUND_SOUND_DATA     ; Set background sound after fire sound
                        CALL GENERAL_SOUND              ; Get back to background sound




                        RET                             ;











































































; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display Sites into screen buffer
DISPLAY_SITES:
                        LD A,1                          ;
                        LD (MERGE_SPRITE+1),A           ;
                        LD A,(COUNTER)                  ; Get game counter
                        CP 200                          ; Is it 200?
                        JR NZ,SKIP_POWER_REDUCTION      ; If not then skip reducing power
                        CALL TAKE_1_FROM_POWER_METER    ; Take 1 from power
SKIP_POWER_REDUCTION:
; Check there is enough power for sites

                        LD A,(POWER_STATUS)             ; Get current power
                        CP 5                            ; Is it 5 or less?
                        JR NC,SKIP_DISABLING_SITES_DUE_TO_POWER;

                        CALL SITES_ON_OFF               ; Turn sites off
                        LD A,28                         ; Message for power too low
                        CALL GET_MESSAGE_POINTER        ; Set message Function not possible Power too low

                        RET                             ;
SKIP_DISABLING_SITES_DUE_TO_POWER:

                        CALL MEMORY_SWITCH_1            ; Memory switch 1
                        LD IX,SITES_GRAPHICS_1          ; Sites graphics data

                        LD A,18*8                       ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864;
                        LD DE,12                        ;
                        ADD HL,DE                       ; Move sites to screen center

                        ; IX=GRAPHIC
                        ; HL=SCREEN ADDRESS
                        LD A,8                          ; Get collumns
                        LD C,A                          ;
                        LD A,5                          ; Get rows

                        CALL DISPLAY_LARGE_GRAPHIC_LOOP3 ; Display large graphic

                        LD A,23*8                       ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864;
                        LD DE,12                        ;
                        ADD HL,DE                       ; Move sites to screen center

                        ; IX=GRAPHIC
                        ; HL=SCREEN ADDRESS
                        LD A,8                          ; Get collumns
                        LD C,A                          ;
                        LD A,3                          ; Get rows

                        CALL DISPLAY_LARGE_GRAPHIC_LOOP3 ; Display large graphic

                        ; CALL MEMORY_SWITCH_0            ; Memory switch 0


                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MESSAGE_POINTER_31231:  DB 0,0                          ; Message pointer store
MESSAGE_POINTER_31231BASIC:DB 0,0                       ; Message pointer store
MESSAGE_STATUS:         DB 0                            ; Message length store
TEXT_COLLUMN_31324:     DB 0                            ;
TEXT_ROW_31325          DB 0                            ;
TEXT_COLLUMN_31324BASIC:DB 0                            ;
TEXT_ROW_31325BASIC     DB 0                            ;
LAST_MESSAGE_STATUS:    DB 0                            ; Save last message status
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup new message, Get message into HL
; A=MESSAGE NUMBER HL=MESSAGE ADDRESS
GET_MESSAGE_POINTER:
                        LD (LAST_MESSAGE_STATUS),A      ; Save current message status if we need to repeat it
                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(MESSAGE_STATUS)           ; Get message status
                        OR A                            ; Is it off?
                        RET NZ                          ; Do not setup a new message if already displaying one

                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        OR A                            ; No encounter hapening? Would be 0 if not
                        RET NZ                          ; Skip if alien encounter sequence

                        LD A,(ABORT_ENABLED)            ; Are we in Abort mode?
                        OR A                            ;
                        RET NZ                          ; Return if so to prevent any other messages

                        JP SKIP_GET_MESSAGE_POINTERB    ;
GET_MESSAGE_POINTERB:

                        LD (LAST_MESSAGE_STATUS),A      ; Save current message status if we need to repeat it

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ; Clear text screen

SKIP_GET_MESSAGE_POINTERB:
                        LD A,(SNOW_TEXT_SCREEN_ON)      ; Get interference on text display status
                        OR A                            ; Is it enabled?                           ;
                        JR Z,SKIP_RED_LED_ON_LCD        ; Skip counting down snow text counter if not

                        LD A,66                         ; Bright red on black
                        JP SKIP_GREEN_LED_ON_LCD        ; Jump to set LED to red
SKIP_RED_LED_ON_LCD:
                        LD A,68                         ; Bright green on black
SKIP_GREEN_LED_ON_LCD:
                        CALL SET_LCD_LED_STATUS_COLOUR  ; Colour the LED on the LCD screen to A
; Clear the cursor on LCD
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD A,(NORMAL_LCD_COLOUR)        ; Light cyan on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR


                        LD A,7                          ;
                        LD (SCROLL_COUNT),A             ; Update scroll counter




                        ;    LD A,(NORMAL_LCD_COLOUR)        ; Set display to Cyan on black
                        ;    LD (TEXT_COLOUR+1),A            ; Set text colour
                        ;    CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR
                        ; EX AF,AF'                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,(LAST_MESSAGE_STATUS)      ;
                        ;   OR A                            ; CP 0 ; Is message 0 for erase message?
                        ;   JR Z,FORCE_MESSAGE0             ; If so then skip finding message index

                        ADD A,A                         ; a*2 (limits Number to 128)
                        LD H,0                          ;
                        LD L,A                          ;

                        LD DE,MESSAGE_INDEX_3           ;
                        ADD HL,DE                       ;

                        ; HL=message index pointer result
                        LD E,(HL)                       ; HL=MESSAGE ADDRESS
                        INC HL                          ;
                        LD D,(HL)                       ;

                        ;  PUSH DE                         ;
                        ;  POP HL                          ;
                        EX DE,HL                        ;
MESSAGE_0_SKIPPED:

                        LD (MESSAGE_POINTER_31231),HL   ; Update the message pointer

                        LD A,1                          ; A=1 to set message status to on
                        LD (MESSAGE_STATUS),A           ;  Set message status to on
                        ; Reset row and collumn for the new message

                        ; ;;;;;;;;;;;;;;;;
                        LD A,1                          ; 9                          ;  Collumn 9 to start
                        LD (TEXT_COLLUMN_31324),A       ; Setup text collumn and row

                        LD A,22                         ; ROW 22
                        LD (TEXT_ROW_31325),A           ; Setup text collumn and row
                        ; CALL MEMORY_SWITCH_4            ; Memory switch 4
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; 6 WIDE, 5 TALL
; Display simple text
DISPLAY_TEXT:
                        LD B,30                         ; 30 characters to display
DISPLAY_BASIC_TEXT_LOOP:
                        PUSH BC                         ; Save loop

                        LD HL,(MESSAGE_POINTER_31231BASIC); Get message pointer into HL
                        LD A,(HL)                       ; Get current character into A
                        LD DE,(TEXT_COLLUMN_31324BASIC) ; Get text collumn and row
                        PUSH DE                         ; Save text collumn and row

                        CALL DISPLAY_8X8_TEXT_c26682    ; Display text character

                        LD HL,MESSAGE_POINTER_31231BASIC; Get message pointer into HL
                        INC (HL)                        ; Move to next character

                        POP DE                          ; Restore text collumn and row
                        INC E                           ; Add 1 to text collumn
                        LD A,30                         ; Setup A to test for collumn 30
                        CP E                            ; Are we at collumn 30?
                        JR NC,SKIP_TEXT_COLLUMN_RESET_31313B ; If not then skip resetting collumn back to 9
                        LD E,25                         ; Set collumn to 25
                        INC D                           ; Move to next line
SKIP_TEXT_COLLUMN_RESET_31313B:
                        LD (TEXT_COLLUMN_31324BASIC),DE ; Place collumn and row into 31324
                        ; LD HL,33536   ; Start of graphic data offset
                        ; LD (26602),HL ; Set Graphics offset pointer to Start of graphics data
                        POP BC                          ; Restore loop
                        DJNZ DISPLAY_BASIC_TEXT_LOOP    ; Jump back until all characters are displayed

                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get ATTR Address of visible ATTR into HL Called with DE=collumn/row
; GET_ATTR:
                        ;    ld a,D                          ; x position.
                        ;    rrca                            ; multiply by 32.
                        ;    rrca                            ;
                        ;    rrca                            ;
                        ;    ld l,a                          ; store away in l.
                        ;    and 3                           ; mask bits for high byte.
                        ;    add a,88                        ; 88*256=22528, start of attributes.
                        ;    ld h,a                          ; high byte done.
                        ;    ld a,l                          ; get x*32 again.
                        ;    and 224                         ; mask low byte.
                        ;    ld l,a                          ; put in l.
                        ;    ld a,E                          ; get y displacement.
                        ;    add a,l                         ; add to low byte.
                        ;    ld l,a                          ; hl=address of attributes.
                        ;    ; ld a,(hl)           ; return attribute in a.
                        ;    ret                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get ATTR Address of visible ATTR into HL Called with DE=collumn/row
GET_ATTR_EMPTY:
                        ld a,D                          ; x position.
                        rrca                            ; multiply by 32.
                        rrca                            ;
                        rrca                            ;
                        ld l,a                          ; store away in l.
                        and 3                           ; mask bits for high byte.
                        add a,94                        ; 88*256=22528, start of attributes.
                        ld h,a                          ; high byte done.
                        ld a,l                          ; get x*32 again.
                        and 224                         ; mask low byte.
                        ld l,a                          ; put in l.
                        ld a,E                          ; get y displacement.
                        add a,l                         ; add to low byte.
                        ld l,a                          ; hl=address of attributes.
                        ; ld a,(hl)           ; return attribute in a.
                        ret                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Display text slowly with cursor in main text window until (MESSAGE_STATUS)=0 B=colour
DISPLAY_TEXT_ONE_BY_ONE:
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        LD A,(SPINING_ICON_STATUS)      ; Get spining icon status
                        OR A                            ; Is it off?
                        JP NZ,DISPLAY_BUSY_ICON_3       ;

DISPLAY_TEXT_ONE_BY_ONE_WITHOUT_MEMORY_SWITCH_TO:
                        LD A,(MESSAGE_STATUS)           ; Get current message status
                        OR A                            ; CP 0                            ; Check for message length=1
                        RET Z                           ; Return if message status =0 no message left to display
                        ; Do not proceed if no more message to display

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; CALL MEMORY_SWITCH_3            ; Memory switch 3

                        LD HL,(MESSAGE_POINTER_31231)   ; HL=current message data pointer
                        LD A,(HL)                       ; Get current message data into A
; Are we end of line?
                        CP 94                           ; End of message code
                        JR NZ,SKIP_MESSAGE_RESET        ; If we are not at end of message (code 94) then skip reseting message
; Reset message

                        LD A,70                         ; Bright yellow on black
                        CALL SET_LCD_LED_STATUS_COLOUR  ; Colour the LED on the LCD screen to A
                        XOR A                           ; A=0
                        LD (MESSAGE_STATUS),A           ; Set message status to off
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour the LED on the LCD screen to A
SET_LCD_LED_STATUS_COLOUR:
                        LD (22528+749),A                ; Set first LCD Status colour square to bright yellow on black
                        LD (22528+750),A                ; Set second LCD Status colour square to bright yellow on black
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SKIP_MESSAGE_RESET:

                        LD HL,SCROLL_COUNT              ; Get scroll count
                        LD A,(HL)                       ;
                        OR A                            ; Are we scrolling? Will be 0 if not                            ;
                        JR Z,SKIP_SCROLL_COUNT_TEST     ; If not scrolling then jump to display character
                        DEC (HL)                        ; Take 1 from scroll counter
                        ; LD (SCROLL_COUNT),A             ; Update scroll counter
                        ; JP SCROLL_TEXT_DISPLAY_UP       ; Jump to scroller

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll text display up 1 character
SCROLL_TEXT_DISPLAY_UP:
                        ;  PUSH AF                         ;
                        ;  PUSH BC                         ;
                        ;  PUSH DE                         ;

                        ; LD A,7*8                        ; ROW
                        ; LD (COLLUMN+1),A                ;

                        ; LD A,8                          ; 9*8                        ; COLLUMN
                        ; LD (ROW+1),A                    ;

                        ; LD A,6*8                        ;
                        ; LD (HEIGHT+1),A                 ;

                        ; LD A,14                         ;
                        ; LD (WIDTHS+1),A                 ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD B,2                          ;
SCROLL_LOOP_A:
                        PUSH BC                         ;

; COLLUMN:                LD A,7*8                        ;
                        LD B,56                         ; Collumn
ROW:                    LD A,8                          ; Rows
                        LD C,A                          ;
                        PUSH BC                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH
                        POP BC                          ;
HEIGHT:                 LD A,6*8                        ; Height
LPS2:
                        PUSH AF                         ;
                        DEC B                           ;
                        PUSH BC                         ;
                        PUSH HL                         ;
                        CALL GET_SCREEN_ADDRESS_ROM     ; CALL 22AAH
                        POP DE                          ;
                        PUSH HL                         ;
                        LD B,0                          ;
WIDTHS:                 LD A,14                         ; Width
                        LD C,A                          ;
                        LDIR                            ;
                        POP HL                          ;
                        POP BC                          ;
                        POP AF                          ;
                        DEC A                           ;
                        JR NZ,LPS2                      ;

                        POP BC                          ;
                        DJNZ SCROLL_LOOP_A              ;
                        ;  POP DE                          ;
                        ;  POP BC                          ;
                        ;  POP AF                          ;

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




SKIP_SCROLL_COUNT_TEST:
                        LD HL,(MESSAGE_POINTER_31231)   ; Get message pointer address
                        LD A,(HL)                       ; Place character into A
                        LD DE,(TEXT_COLLUMN_31324)      ; Get text collumn and row


; If end of line code then skip printing the character
                        CP 64                           ; End of line code?
                        JR Z,SKIP_PRINTING_CHARACTER    ; Skip displaying character if so

                        PUSH DE                         ; Save text collumn and row
                        DEC E                           ; Align text with collumn 0 of flourescent display
                        CP 32                           ;
                        CALL NZ,DISPLAY_8X8_TEXT_c26682 ; Display text character
                        POP DE                          ; Restore text collumn and row

SKIP_PRINTING_CHARACTER:

                        ld a,D                          ; x position.
                        rrca                            ; multiply by 32.
                        rrca                            ;
                        rrca                            ;
                        ld l,a                          ; store away in l.
                        and 3                           ; mask bits for high byte.
                        add a,88                        ; 88*256=22528, start of attributes.
                        ld h,a                          ; high byte done.
                        ld a,l                          ; get x*32 again.
                        and 224                         ; mask low byte.
                        ld l,a                          ; put in l.
                        ld a,E                          ; get y displacement.
                        add a,l                         ; add to low byte.
                        ld l,a                          ; hl=address of attributes.



                        ; HL=address of ATTR
                        LD A,E                          ;
                        CP 14                           ; 14                           ;
                        JR NC,SKIP_MESSAGE_CURSOR       ;
; Colour the text
                        LD A,(NORMAL_LCD_COLOUR)        ; Light cyan on black
                        LD B,A                          ;
                        LD (HL),A                       ; Set ATTR

; SKIP_FIRST_CHARACTER_MESSAGE_CURSOR:
                        INC L                           ; Move collumn 1 to the right

                        LD A,E                          ;
                        CP 13                           ; 20                           ;
                        JR NC,SKIP_MESSAGE_CURSOR       ;
; Display cursor

                        LD A,B                          ; ; Get text colour
                        CPL                             ; Set cursor colour
                        LD (HL),A                       ; Set ATTR
SKIP_MESSAGE_CURSOR:
                        PUSH HL                         ; Save ATTR address

                        LD HL,MESSAGE_POINTER_31231     ; Get message pointer into HL
                        INC (HL)                        ; Increase message pointer to next address
                        LD HL,(MESSAGE_POINTER_31231)   ; Get message data
                        LD A,(HL)                       ; Get data into A for testing
                        POP HL                          ;
                        CP 64                           ; End of line code?
                        JR NZ,SKIP_TEXT_COLLUMN_RESET_31313 ; If so then skip testing for end of line

; Erase cursor at end of line
                        LD A,E                          ;
                        CP 14                           ; 20                           ;
                        JR NC,SKIP_MESSAGE_CURSOR_ERASE ;                                         ;
                        LD (HL),B                       ; Set ATTR to normal
SKIP_MESSAGE_CURSOR_ERASE:
                        LD E,1                          ; Set collumn to 1
                        LD A,4                          ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SET SCROLL TEXT COUNTER
                        LD (SCROLL_COUNT),A             ; Update scroll counter
                        JP SKIP_TEXT_COLLUMN_RESET_31313BB;
SKIP_TEXT_COLLUMN_RESET_31313:

                        INC E                           ;
SKIP_TEXT_COLLUMN_RESET_31313BB:
                        LD (TEXT_COLLUMN_31324),DE      ; Place collumn and row into 31324
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Cygnus is found and we are landing                       ;
FLASH_FOUND_CYGNUS_CONTROL:

                        LD A,30                         ;
                        CALL GET_MESSAGE_POINTERB       ;


                        LD B,25                         ;
FLASH_FOUND_CYGNUS_CONTROL_LOOP1:;
                        PUSH BC                         ;

                        XOR A                           ; LD A,0
FLASH_FOUND_CYGNUS_CONTROL_LOOP2:
                        PUSH AF                         ;
                        CALL DISPLAY_TEXT_ONE_BY_ONE    ;
                        LD BC,7000                      ;
                        CALL DELAY1LOOP                 ;
                        POP AF                          ;
                        CALL FLASH_FOUND_CYGNUS         ;
                        INC A                           ;
                        CP 7                            ;
                        JR NZ,FLASH_FOUND_CYGNUS_CONTROL_LOOP2;

                        POP BC                          ;
                        DJNZ FLASH_FOUND_CYGNUS_CONTROL_LOOP1;


                        JP STARTA                       ; Start all over again
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flash found Cygnus on planet  A=COLOUR
FLASH_FOUND_CYGNUS:

                        LD HL,22848+4-32-64             ;
                        LD B,3                          ;
FLASH_FOUND_CYGNUS_LOOP1:
                        PUSH BC                         ;

                        LD B,4                          ;
FLASH_FOUND_CYGNUS_LOOP2:
                        LD (HL),A                       ;
                        INC L                           ;
                        DJNZ FLASH_FOUND_CYGNUS_LOOP2   ;

                        POP BC                          ;
                        LD DE,28                        ;
                        ADD HL,DE                       ;
                        DJNZ FLASH_FOUND_CYGNUS_LOOP1   ;

                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MESSAGE0_LARGE_SCREEN:  DB 0,0                          ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup new message, Get message into HL  For data 1 on large screen
GET_MESSAGE_POINTER_LARGE_SCREEN:
                        LD HL,SERVICE_MENU_DATA1        ;
                        ; Reset row and collumn for the new message
                        LD A,3                          ; Collumn 3
                        LD (TEXT_ROW_LARGE_SCREEN_31325),A ; Setup text collumn and row
                        JP SET_MESSAGE_POINTER_LARGE_SCREEN;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup new message, Get message into HL  For data 2 on large screen
GET_MESSAGE_POINTER_LARGE_SCREEN2:
                        LD HL,SERVICE_MENU_DATA2        ;
                        ; Reset row and collumn for the new message
                        LD A,11                         ; Collumn 11
                        LD (TEXT_ROW_LARGE_SCREEN_31325),A ; Setup text collumn and row

SET_MESSAGE_POINTER_LARGE_SCREEN:
                        LD A,2                          ;  Row 2
                        LD (TEXT_COLLUMN_LARGE_SCREEN_31324),A ; Setup text collumn and row
                        LD (MESSAGE_POINTER_LARGE_SCREEN_31231),HL ; Update the message pointer
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset double height text
RESET_DOUBLE_HEIGHT_TEXT:
                        XOR A                           ;
                        LD (DOUBLE_HEIGHT_TEXT),A       ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Used for large font
MOVE_TEXT_DOWN_1_LINE_FOR_LARGE_FONT:
                        LD A,E                          ;
                        ADD A,32                        ;
                        LD E,A                          ;
                        CCF                             ;
                        SBC A,A                         ;
                        AND 248                         ;
                        ADD A,D                         ;
                        LD D,A                          ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MESSAGE_LENGTH_LARGE_SCREEN_31230:DB 0                  ;
MESSAGE_POINTER_LARGE_SCREEN_31231:DB 0,0               ;
TEXT_COLLUMN_LARGE_SCREEN_31324:DB 0                    ;
TEXT_ROW_LARGE_SCREEN_31325 DB 0                        ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display text slowly with cursor in large window until (MESSAGE_STATUS)=0 B=colour
DISPLAY_TEXT_ONE_BY_ONE_LARGE_SCREEN:

                        LD B,3                          ; 2 characters at a time to speed up printing
DISPLAY_TEXT_ONE_BY_ONE_LARGE_SCREEN_LOOP:
                        PUSH BC                         ; Save 2 characters at a time loop
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; More message to display
                        LD HL,(MESSAGE_POINTER_LARGE_SCREEN_31231);
                        LD A,(HL)                       ; Get surrent string character
                        CP "$"                          ; Begining of figure string marker?
                        JR Z,UPDATESCREENONLY2          ; Do not display it if so

                        OR A                            ;
                        JP Z,UPDATE_LARGE_MESSAGE_IN_BUFFER_RESET ; Return if message length=0 no message left to display
                        LD (SET_TEXTA+1),A              ;
                        CP 91                           ; Is it a [ for double height?
                        JR NZ,SKIP_SWITCHING_ON_DOUBLE_HEIGHT;
                        LD A,1                          ;
                        LD (DOUBLE_HEIGHT_TEXT),A       ;

                        LD HL,MESSAGE_POINTER_LARGE_SCREEN_31231;
                        INC (HL)                        ;
                        POP BC                          ;
                        JP UPDATESCREENONLY             ;


SKIP_SWITCHING_ON_DOUBLE_HEIGHT:

                        CP 93                           ; Is it a ] to switch double height off?
                        JR NZ,SKIP_SWITCHING_OFF_DOUBLE_HEIGHT;
                        XOR A                           ; A=0
                        LD (DOUBLE_HEIGHT_TEXT),A       ; Switch off double height
                        LD HL,MESSAGE_POINTER_LARGE_SCREEN_31231;
                        INC (HL)                        ;
                        LD HL,TEXT_ROW_LARGE_SCREEN_31325 ; Setup text collumn and row
                        INC (HL)                        ;

                        POP BC                          ;
                        JP UPDATESCREENONLY             ;

SKIP_SWITCHING_OFF_DOUBLE_HEIGHT:

                        LD DE,(TEXT_COLLUMN_LARGE_SCREEN_31324) ; Get text collumn and row

; CALL DISPLAY_8X8_TEXT_LARGE_SCREEN_c26682    ; Display text character
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display 8X8 graphic to blank cache

DISPLAY_8X8_TEXT_LARGE_SCREEN_c26682:

; PUSH DE       ; Save screen address
                        ; CALL GET_GRAPHICS_POINTER_INTO_HL_c26670 ; Get graphic pointer into HL, A=graphic number
;  POP DE        ; Restore screen address

                        ; Get graphic pointer into HL, B=graphic number

                        ;  LD H,0                          ;
SET_TEXTA:              LD HL,0                         ; Set character

                        ADD HL,HL                       ;
                        ADD HL,HL                       ;
                        ADD HL,HL                       ;
                        LD BC,TEXT_CHARACTER_DATA_OFFSET ; Graphics offset pointer

                        ADD HL,BC                       ;
                        ;


                        ; DE HOLDS COORDINATES
DISPLAY_8X8_TEXT_LARGE_SCREEN_c26682_MANUAL:
                        LD A,D                          ;
                        AND 24                          ;
                        OR 112                          ; 64
                        PUSH AF                         ;
                        SUB A                           ;
                        SRL D                           ;
                        RRA                             ;
                        SRL D                           ;
                        RRA                             ;
                        SRL D                           ;
                        RRA                             ;
                        OR E                            ;
                        POP DE                          ;
                        LD E,A                          ;

                        LD B,7                          ; 8 HIRES LINES TO DISPLAY CHARACTER
DISPLAY_CHARACTER_LOOP_LARGE_SCREEN:
                        LD A,(HL)                       ; Get graphic data into A
                        LD (DE),A                       ; Place the data to current screen address in DE
                        INC D                           ; Move down 1 hi res line
                        LD C,A                          ;
                        LD A,(DOUBLE_HEIGHT_TEXT)       ; Get Double height text flag
                        OR A                            ; Is it off?
                        JR Z,SKIP_DOUBLE_HEIGHTB        ; Normal text if so
                        LD A,C                          ;
                        LD (DE),A                       ; Place the data to current screen address in DE
                        INC D                           ; Move down 1 hi res line


                        LD A,D                          ;
                        AND 7                           ;
                        CALL Z,MOVE_TEXT_DOWN_1_LINE_FOR_LARGE_FONT:;
SKIP_DOUBLE_HEIGHTB:

                        INC HL                          ; Move to next graphic data

                        DJNZ DISPLAY_CHARACTER_LOOP_LARGE_SCREEN;
; ;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy the empty buffer to the display buffer
COPY_EMPTY_BUFFER_TO_BUFFER2:

UPDATESCREENONLY2:
                        LD HL,SCREEN1_EMPTY             ; Point to screen buffer
                        LD DE,SCREEN1                   ; Point to displayed screen
                        LD BC,4096-512                  ; 4096 bytes to copy

SCREENUPDATELOOP2:
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer

                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer

                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer

                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        JP PE,SCREENUPDATELOOP2         ; Jump back until all buffer is done



; ;;;;;;;;;;;;;;;;;;;;;;
                        LD DE,(TEXT_COLLUMN_LARGE_SCREEN_31324) ; Get text collumn and row

                        ; Erase white box
                        INC E                           ; Add 1 to text collumn
                        LD A,29                         ; Setup A to test for collumn 29
                        CP E                            ; Are we at collumn 23?
                        JR C,SKIP_TEXT_COLLUMN_RESET_LARGE_SCREEN_31313BBB ; If not then skip resetting collumn back to 9
; Display cursor if less than collumn 29

                        LD A,(DOUBLE_HEIGHT_TEXT)       ; Get Double height text flag
                        OR A                            ; Is it off?
                        JR NZ,SKIP_TEXT_COLLUMN_RESET_LARGE_SCREEN_31313BBB: ; Skip the cursor if double height

                        CALL GET_ATTR_EMPTY             ; Get ATTR address for empty buffer
                        LD A,104                        ; 120           ;Cyan box
                        LD (HL),A                       ; Display Light Blue cursor

; CALL COPY_BLANK_ATTR_TO_BUFFER    ; Copy blank ATTR to buffer

SKIP_TEXT_COLLUMN_RESET_LARGE_SCREEN_31313BBB:

                        DEC E                           ; Move cursor back 1 collumn to set text ink

                        LD HL,MESSAGE_POINTER_LARGE_SCREEN_31231;
                        INC (HL)                        ;
                        ; Normal ink
                        CALL GET_ATTR_EMPTY             ;

                        LD A,7                          ; A=7 for white ink on black paper
                        LD (HL),A                       ; Set white ink

                        CALL COPY_BLANK_ATTR_TO_BUFFER  ; Copy blank ATTR to buffer

                        ; POP DE                          ; Restore text collumn and row
                        LD DE,(TEXT_COLLUMN_LARGE_SCREEN_31324) ; Get text collumn and row
                        INC E                           ; Add 1 to text collumn
                        LD A,30                         ; Setup A to test for collumn 30
                        CP E                            ; Are we at collumn 30?
                        JR NZ,SKIP_TEXT_COLLUMN_RESET_LARGE_SCREEN_31313 ; If not then skip resetting collumn back to 2
                        LD E,2                          ; Set collumn to 2
                        INC D                           ; Move to next line
SKIP_TEXT_COLLUMN_RESET_LARGE_SCREEN_31313:



                        LD (TEXT_COLLUMN_LARGE_SCREEN_31324),DE ; Place collumn and row into 31324
                        ; LD HL,33536   ; Start of graphic data offset
                        ; LD (26602),HL ; Set Graphics offset pointer to Start of graphics data
                        POP BC                          ;
                        DEC B                           ;
                        JP NZ,DISPLAY_TEXT_ONE_BY_ONE_LARGE_SCREEN_LOOP;
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy blank attr buffer to screen attr buffer
COPY_BLANK_ATTR_TO_BUFFER:
                        PUSH DE                         ;

                        LD HL,ATTR1_EMPTY               ; HL=ATTR screen buffer
                        LD DE,ATTR1                     ; DE=Visible screen ATTR
                        LD BC,512                       ; 512 bytes to copy

UPDATESCREENLOOP1:
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR
                        LDI                             ; Copy data from ATTR buffer to screen ATTR

                        JP PE, UPDATESCREENLOOP1        ; Loop back to complete all screen locations



; LD DE,ATTR1 ; Get Screen start address store into HL
;  LD HL,ATTR1_EMPTY        ; DE=Start address
;  LD BC,512     ; 767 bytes fill the ATTR area
;  LDIR          ; Fill memory
                        POP DE                          ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy screen buffer to empty buffer
COPY_SCREEN_BUFFER_TO_EMPTY_BUFFER:

                        LD HL,SCREEN1                   ; Point to displayed screen
                        LD DE,SCREEN1_EMPTY             ; Point to screen buffer
                        LD BC,4000                      ; 96                      ; 4096 bytes to copy
                        LDIR                            ;


                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display 8X8 graphic
; A=graphic number, DE=coordinates
DISPLAY_8X8_TEXT_c26682:


                        ; LD D,22
                        ; LD E,9

                        LD H,0                          ; Set HL to graphic number
                        LD L,A                          ;

                        ADD HL,HL                       ; Multiply by 8 to filter to eack text character data
                        ADD HL,HL                       ;
                        ADD HL,HL                       ;
                        LD BC,TEXT_CHARACTER_DATA_OFFSET ; Text graphics offset pointer

                        ADD HL,BC                       ; Add the graphic number to the offset pointer to load the text graphic address into HL

                        ; DE HOLDS COORDINATES
DISPLAY_8X8_TEXT_c26682_MANUAL:
                        LD A,D                          ;
                        AND 24                          ;
                        OR 64                           ;
                        PUSH AF                         ;
                        SUB A                           ;
                        SRL D                           ;
                        RRA                             ;
                        SRL D                           ;
                        RRA                             ;
                        SRL D                           ;
                        RRA                             ;
                        OR E                            ;
                        POP DE                          ;
                        LD E,A                          ;

                        ; DE now holds screen address
DISPLAY8X8_GRAPHIC:     ; HL holds text graphic data    ;
                        LD B,7                          ; 6 HIRES LINES TO DISPLAY CHARACTER
DISPLAY_CHARACTER_LOOP:

                        LD A,(HL)                       ; Get graphic data into A
                        LD (DE),A                       ; Place the data to current screen address in DE
                        INC D                           ; Move down 1 hires line
                        INC HL                          ; Move to next graphic data
                        DJNZ DISPLAY_CHARACTER_LOOP     ;

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Move sector select cursor
MOVE_SECTOR_SELECTOR_c30584:
; Dont move radar if side scrolling mode
                        LD A,(GAME_MODE)                ; Get game mode
                        OR A                            ;
                        RET NZ                          ; Do not move the radar if side scrolling mode

; Dony move radar if already scrolling it
                        LD A,(SCROLLLINELEFTB_COUNTER)  ; Get radar scroll counter
                        OR A                            ; Is it 0 for not scrolling?
                        RET NZ                          ; Return if not 0 as the scroll is still happening

; Is L key being pressed?
                        ;  CALL GET_SECTOR_TABLE_POINTER_c30613 ; Get sector map location
                        CALL GET_KEYS_H_TO_L_c30715     ; Check key press
                        BIT 1,A                         ; Is key "L" pressed?
                        RET NZ                          ; If not then jump to skip selecting the sector

                        ;   LD A,4                          ;
                        ;   LD (COUNTER4),A                 ; Prevent Freestyle aliens if selecting sector

                        LD A,(RADAR_MOVE_TIMER)         ; Get radar move timer
                        CP 0                            ;
                        JR NZ,SKIP_SETTING_RADAR_MOVER_TO_CURRENT_SECTOR;

                        LD A,(MAP_SELECT_STORE_NUMBER_b30583); Get current sector
                        LD (RADAR_SELECT_SECTOR_STORE),A ; Store it for radar move
SKIP_SETTING_RADAR_MOVER_TO_CURRENT_SECTOR:

                        LD A,100                        ; Setup A for move selector timer
                        LD (RADAR_MOVE_TIMER),A         ; Set radar move timer
                        LD HL,RADAR_SELECT_SECTOR_STORE ; Map flashing square location store number 0 to 99
                        INC (HL)                        ; Move to next flashing square store number
                        ; LD A,101                        ; Setup A to test if we are at end of map
                        CP 101                          ; Compare end of map
                        JR NZ,C30607B                   ; If not located at end of map then skip moving to begining of map
                        LD (HL),0                       ; Reset flashing map square location back to top left of map

C30607B:
                        ;  PUSH HL                         ; Save map select store number
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL DISPLAY_RADAR_ICONS_4      ; Scroll on the next icon
                        ;  POP HL                          ; Restore map select store number
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display basic icon graphic in radar screen
; DISPLAY_BASIC_GRAPHIC:
; HL=GRAPHIC

;                        POP DE                          ; Restore text collumn and row
;                        INC E                           ; Add 1 to text collumn

;                        LD A,30                         ; Setup A to test for collumn 7
;                        CP E                            ; Are we at collumn 23?
;                        JR NZ,SKIP_TEXT_COLLUMN_RESET_31313C ; If not then skip resetting collumn back to 9
;                        LD E,25                         ; Set collumn to 9
;                        INC D                           ; Move to next line
; SKIP_TEXT_COLLUMN_RESET_31313C:
;                        LD (TEXT_COLLUMN_RADAR),DE      ; Place collumn and row into 31324

;                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to icon to add ship count in icon  Used when on sector with no aliens then they suddenly appear to attack
ADD_1_TO_ICON:
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get address for flashing square into HL, A=Sector type
                        CP 3                            ; Is sector value greater than 4?
                        RET NC                          ; If so then return without incrementing
                        INC A                           ; Add 1 to icon data to increase aliens on icon
                        JP UPDATE_ICON_STATUS_AFTER_TAKE_OR_ADD ; Take or add jumps here to update icons
                        ; LD (HL),A                       ; Update current sector icon data
                        ; RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from icon to reduce ship count in icon
TAKE_1_FROM_ICON:
                        LD HL,PROGRESS                  ; Get Progress
                        INC (HL)                        ; Add 1 to progress

                        LD A,10                         ;
                        LD (COUNTER4),A                 ; General 255 counter 4

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get address for flashing square into HL, A=Sector type
                        OR A                            ; CP 0                            ; Is sector value 0?
                        RET Z                           ;


                        DEC A                           ; Take 1 from icon data to reduce aliens on icon
                        ; LD (HL),A                       ; Update current sector icon data
                        ; RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take or add jumps here to update icons
UPDATE_ICON_STATUS_AFTER_TAKE_OR_ADD:
                        LD (HL),A                       ; Update current sector icon data
                        ; CALL DISPLAY_RADAR_ICONS        ; Update radar icons
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL UPDATE_SECTOR_VALUE_4      ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Erase sector - Used when sector is completed
ERASE_SECTOR:
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4;
                        LD (HL),0                       ;

                        CALL UPDATE_SECTOR_VALUE_4      ;

                        LD HL,PROGRESS                  ; Get Progress
                        INC (HL)                        ; Add 1 to progress
                        ;  LD (PROGRESS),A                 ; Update progress

                        ; CALL DISPLAY_RADAR_ICONSB       ; Update radar

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_L_KEY_REPEAT_30714:DB 255              ; Used to prevent L key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys  H, J, K, L, Enter
GET_KEYS_H_TO_L_c30715:
                        LD BC,49150                     ; Keyboard port for H, J, K, L, Enter
                        IN A,(C)                        ; Read keys H, J, K, L, Enter
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_L_KEY_REPEAT_30714) ; Set 30714 to prevent key repeat
                        CALL ORGANISE_KEYS2             ;
                        LD (STORE_TO_PREVENT_L_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hyperdrive on        https://www.youtube.com/watch?v=NAWL8ejf2nM
HYPERDRIVE_ON:
                        LD A,(SYSTEM_RESET)             ; System reset is hapening so cannot perform this function
                        AND A                           ;
                        JR NZ,FUNCTION_NOT_POSSIBLE2    ;

                        LD A,(SERVICES_ON)              ; Check Services are on
                        OR A                            ; Are they off
                        JR NZ,FUNCTION_NOT_POSSIBLE2    ; Jump if so

                        LD A,(CURRENT_SECTOR_VALUE)     ; Get current sector value
                        OR A                            ;
                        JR NZ,FUNCTION_NOT_POSSIBLE2    ; Jump if so


                        LD A,(POWER_STATUS)             ; Get current power
                        CP 5                            ; Is it 5 or less?
                        JR NC,SKIP_LOW_POWER            ; If not then skip low power test
                        LD A,28                         ; Message for power too low
                        CALL GET_MESSAGE_POINTER        ; Set message Function not possible Power too low

                        RET                             ;
SKIP_LOW_POWER:
                        LD A,7                          ; MESSAGE FOR Hyperdrive
                        CALL GET_MESSAGE_POINTERB       ; Set message




                        CALL CLEAR_BUFFER               ; Clear screen buffer
                        LD A,(SPEED)                    ; Get current speed
                        LD (SPEED_SAVE),A               ; Save the current speed
                        LD A,(SPEEDMAX)                 ; Get current speedmax
                        LD (SPEEDMAX_SAVE),A            ; Save current speedmax

                        LD A,70                         ; Set hyperdrive timer to start counting down
                        LD (HYPERDRIVE),A               ;

                        XOR A                           ; Set speed
                        LD (SPEED),A                    ;
                        LD (SPEEDMAX),A                 ; Counts up to speed. Then calls move stars
                        LD (SERVICES_ON),A              ; Turn off Services screen

                        LD (SITES_ON),A                 ;
                        CALL SET_SITES_OFF              ; Turn Sites off
                        CALL SET_SERVICES_OFF           ; Turn off Services

; Set the Aliens appear counter so they apear after a delay when the sector is entered and update Radar icons
SET_ALIEN_APPEARS_TO_255_UPDATE_RADAR_ICONS:
                        LD A,255                        ; Set Alien Appears counter to 255
                        LD (ALIENS_APPEAR_COUNTER),A    ; Set alien apears countdown timer
                        ; CALL DISPLAY_RADAR_ICONS        ; Update radar icons

                        CALL NEXT_TORPEDO0              ; Flash play area

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Function not possible message
FUNCTION_NOT_POSSIBLE2:
                        LD A,21                         ;
                        CALL GET_MESSAGE_POINTERB       ; Set message
                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Enable aliens  Check to see if we need to enable aliens
ENABLE_ALIENS:
                        ; LD A,(CURRENT_SECTOR_VALUE);Get current sector value


                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISABLE_ALL_ALIENS_6       ; Disable all aliens

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4; Get Sector value into A
                        ; A=SECTOR VALUE

                        OR A                            ; CP 0                            ; Are we at zero aliens?
                        RET Z                           ; If so then skip enabling any aliens
                        ; ;;;;;;;;;;;;;;;;;;;;;;;Without these two commands, Abort crashes after hyperdrive to a planet;;;;;;;;;;;;;;;
                        ; ;;;;;;;;;;;;;;;;;;Because over 4 alien datas enabled floods the executable code;;;;;;;;;;;;;;;;;;;;;;;;;;
                        CP 5                            ; Is sector value above 5?
                        RET NC                          ; Return if so as we have no aliens to enable
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We need to display some aliens so set them up. A=number of aliens
                        LD B,A                          ;
                        LD DE,12+32                     ; Setup DE for addition for next alien ship block
; 4 alien ships max
                        LD IY,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data
ENABLE_ALIEN_SHIPS_LOOP:;Loop for enabling alien ships  ;
                        LD (IY+0),1                     ; Enable alien ship
                        LD (IY+4),1                     ; Reset torpedo frame
                        ADD IY,DE                       ; Move to next alien ship block
                        DJNZ ENABLE_ALIEN_SHIPS_LOOP    ; Jump back to enable aliens

                        CALL SET_ALL_ALIENS_SEQUENCE    ; Set the aliens sequence status for each alien (IX+10)

                        CALL MEMORY_SWITCH_3            ;
                        CALL SET_ALIEN_NAME_3           ; Name the aliens

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_1_KEY_REPEAT_30714:DB 255              ; Used to prevent L key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Read keys 1 to 5 to select level and game speed

READ_KEYS_1TO5_c29023:
                        LD BC,63486                     ; Port to Read keys 1 to 5
                        IN A,(C)                        ; Read keys 1 to 5
                        LD B,5                          ; 5 keys to read
                        LD C,A                          ;
                        SUB A                           ;
C29032:
                        INC A                           ;
                        SRL C                           ;
                        RET NC                          ;
                        DJNZ C29032                     ;
                        SUB A                           ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_Y_KEY_REPEAT_30714:DB 255              ; Used to prevent Y key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys Y, U, I, O, P
GET_KEYS_Y_TO_P:
                        LD BC,57342                     ; Keyboard port for Y, U, I, O, P
                        IN A,(C)                        ; Read keys Y, U, I, O, P
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_Y_KEY_REPEAT_30714) ; Set 30714 to prevent key repeat
                        CALL ORGANISE_KEYS2             ;
                        LD (STORE_TO_PREVENT_Y_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_N_KEY_REPEAT_30714:DB 255              ; Used to prevent N key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys B, N, M, Symbol Shift, Space
GET_KEYS_B_TO_SPACE:
                        LD BC,32766                     ; Keyboard port for B, N, M, Symbol Shift, Space
                        IN A,(C)                        ; Read keys B, N, M, Symbol Shift, Space
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_N_KEY_REPEAT_30714) ; Set to prevent key repeat
                        CALL ORGANISE_KEYS2             ;
                        LD (STORE_TO_PREVENT_N_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORGANISE_KEYS2:
                        CPL                             ;
                        AND 2                           ;
                        LD B,A                          ;
                        LD A,C                          ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_M_KEY_REPEAT_30714:DB 255              ; Used to prevent N key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys B, N, M, Symbol Shift, Space
GET_KEYS_B_TO_SPACE_FOR_M:
                        LD BC,32766                     ; Keyboard port for B, N, M, Symbol Shift, Space
                        IN A,(C)                        ; Read keys B, N, M, Symbol Shift, Space
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_M_KEY_REPEAT_30714) ; Set to prevent key repeat
                        CALL ORGANISE_KEY_PRESS         ;
                        LD (STORE_TO_PREVENT_M_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_S_KEY_REPEAT_30714:DB 255              ; Used to prevent S key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys G, F, D, S, A
GET_KEYS_G_TO_A_c30715:
                        LD BC,65022                     ; Keyboard port for G, F, D, S, A
                        IN A,(C)                        ; Read keys G, F, D, S, A
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_S_KEY_REPEAT_30714) ; Set to prevent key repeat
                        CALL ORGANISE_KEY_PRESS         ;
                        LD (STORE_TO_PREVENT_S_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORGANISE_KEY_PRESS:
                        CPL                             ;
                        ; AND 7                           ;
                        LD B,A                          ; B=stored figure
                        LD A,C                          ; A=keypress
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
STORE_TO_PREVENT_Q_KEY_REPEAT_30714:DB 255              ; Used to prevent S key repeat
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Read keys Q,W,E,R,T
GET_KEYS_Q_TO_T_c30715:
                        LD BC,64510                     ; Keyboard port for Q,W,E,R,T
                        IN A,(C)                        ; Read keys Q to T
                        LD C,A                          ;
                        LD A,(STORE_TO_PREVENT_Q_KEY_REPEAT_30714) ; Set to prevent key repeat
                        CALL ORGANISE_KEY_PRESS3        ;
                        LD (STORE_TO_PREVENT_Q_KEY_REPEAT_30714),A ;
                        OR B                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORGANISE_KEY_PRESS3:
                        CPL                             ;

                        LD B,A                          ;
                        LD A,C                          ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






; Read keys CAPS to Shift and Space to B to check for abort mission and run Abort sequence
CHECK_ABORT:
                        LD A,(SYSTEM_RESET)             ; System reset is hapening so cannot perform this function
                        AND A                           ; Is System reset hapening?
                        RET NZ                          ; Return if not

                        LD BC,65278                     ; Port for keys Caps to V
                        IN A,(C)                        ; Get key
                        BIT 0,A                         ; Caps Shift pressed?
                        RET NZ                          ; Return if not
                        LD BC,32766                     ; Port for keys Space to B
                        IN A,(C)                        ; Get key
                        BIT 0,A                         ; Space pressed?
                        RET NZ                          ; Return if not
                        LD A,32                         ; A=31 for message number 31 - Abort Mission
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;
                        LD A,250                        ; A=250 to set Mission Abort sequence countdown timer
                        LD (ABORT_ENABLED),A            ; Set Mission Abort sequence countdown timer
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THIS IS CALLED IF  ABORT_ENABLED SET TO 1
ABORT_IS_SET_SO_CHECK_Y_N:
; ABORT_MISSION_TEXT_LOOP:

                        LD HL,ABORT_ENABLED             ; Take 1 from Mission Abort countdown timer
                        DEC (HL)                        ;
                        LD A,(HL)                       ;
                        OR A                            ; CP 0                            ; If Mission Abort timer is 0 then cancel abort
                        JR Z,DONT_ABORT_MISSION         ;

                        LD A,(SYSTEM_RESET)             ;
                        OR A                            ; CP 0                            ;
                        RET NZ                          ; Dont allow abort when reset system is hapening
                        CALL GET_KEYS_Y_TO_P            ;
                        BIT 4,A                         ; Y pressed?
                        JR NZ,SKIP_PERFORM_ABORT        ;
                        XOR A                           ;
                        LD (ABORT_ENABLED),A            ; Update Abort game status
                        JP GO                           ; Return if not
SKIP_PERFORM_ABORT:


                        CALL GET_KEYS_B_TO_SPACE        ;
                        BIT 3,A                         ; N pressed?
                        RET NZ                          ; Return if not

DONT_ABORT_MISSION:

                        XOR A                           ; RESET ABORT
                        LD (ABORT_ENABLED),A            ; Update Abort game status
                        LD A,(SYSTEM_RESET)             ; Get System reseting status
                        OR A                            ; Is it off? CP 0                            ;
                        RET NZ                          ; Dont display Abort aborted if system reseting

; System was reseting

                        LD A,53                         ; A=53 for message number 53 - Dont Abort Mission
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Warning on/off flip flop to flash warning
FLASH_WARNING:
                        ; We only want the snow LCD if shields are low
                        LD A,(SHIELDS_METER_STORE)      ; Get Laser meter store
                        CP 5                            ; Is it below 5?
                        JR NC,SKIP_SNOW_LCD2            ; Skip the snow LCD checks if so

                        LD HL,SNOW_TEXT_SCREEN_ON       ; Get interference on text display status
                        LD A,(HL)                       ;
                        CP 0                            ; Is it enabled?                           ;
                        JR Z,SKIP_SNOW_TEXT_COUNTDOWN   ; Skip counting down snow text counter if not
                        DEC (HL)                        ; Take 1 from snow text counter
                        ; LD (SNOW_TEXT_SCREEN_ON),A      ; Update snow text status
                        JR NZ,SKIP_SHOW_LCD_SNOW        ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL CLEAR_TEXT_SCREEN_3        ;     ; If snow text is zero then Clear text screen
                        JP SKIP_SNOW_TEXT_COUNTDOWN     ; Jump if snow text status is zero to skip displaying error message
SKIP_SHOW_LCD_SNOW:
                        ; Set message
; LD A,39
                        LD A,(ERROR_SELECT)             ; Get error selector
                        ADD A,39                        ; Move to correct message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

SKIP_SNOW_TEXT_COUNTDOWN:

                        LD A,R                          ; Get random number
                        CP 5                            ; Is it 5?
                        JR NZ,SKIP_SNOW_LCD2            ; If not then skip setting snow text counter to 10

                        LD A,(MESSAGE_STATUS)           ; Get message status
                        OR A                            ; Is it off?
                        JR NZ,SKIP_SNOW_LCD2            ; If not then skip setting snow text counter to 10

                        LD A,10                         ; A=10 to set snow text counter
                        LD (SNOW_TEXT_SCREEN_ON),A      ; Update snow text counter status
SKIP_SNOW_LCD2:         ;Jumps here if turn off random number is no good;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        LD A,(WARNING_DELAY_COUNTER)    ; Get warning light delay counter
                        INC A                           ; Add 1 to counter
                        LD (WARNING_DELAY_COUNTER),A    ; Update warning light delay counter
                        CP 10                           ; Is the counter at 10?
                        JR NZ,SKIP_ENABLE_WARNING1      ; If not then jump to skip enabling warning light

                        LD A,66                         ; A=66 for bright red
                        LD (WARNING_ON),A               ; Set colour to BRIGHT RED

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ; Set colours for warning light
SKIP_ENABLE_WARNING1:

                        CP 20                           ; Is the counter at 20?
                        RET C                           ; Return if greater than 20

                        XOR A                           ; Set A to 0
                        LD (WARNING_DELAY_COUNTER),A    ; Reset warning delay light counter
                        INC A                           ; Set colour to dark blue
                        LD (WARNING_ON),A               ; Set warning light to blue

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ; Set warning light colour

; SKIP_WARNING1:

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Service on/off flip flop to flash service      OPTIMIZED
FLASH_SERVICE:
                        LD A,(SERVICE_DELAY_COUNTER)    ; Get Flash Service delay counter
                        INC A                           ; Add 1 to counter
                        LD (SERVICE_DELAY_COUNTER),A    ; Update Service delay counter
                        CP 10                           ; Is it 10?
                        JR NZ,SKIP_ENABLE_SERVICE1      ; If not then jump to check if 20
; Service delay counter is 10
                        LD A,66                         ; BRIGHT RED on black paper
                        LD (SERVICE_ON),A               ; Set Service_On to colour BRIGHT RED on black paper

                        JP SERVICE_OFF_ON               ; Set ATTR

SKIP_ENABLE_SERVICE1:
                        CP 20                           ; Is Service delay counter on 20?
                        RET C                           ; Return if less than 20

                        XOR A                           ; A=0
                        LD (SERVICE_DELAY_COUNTER),A    ; Reset Service delay counter
                        INC A                           ; Set colour to dark blue on black paper A=1
                        LD (SERVICE_ON),A               ; Set Service_On to colour dark blue on black paper
                        JP SERVICE_OFF_ON               ; Set ATTR
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour warning/service lights B=length of dial, HL=ATTR start, A=colour
COLOUR_DIALS:
                        LD (HL),A                       ; Set current ATTR to colour in A
                        INC HL                          ; Move to next ATTR address
                        DJNZ COLOUR_DIALS               ; Jump back until all completed
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SERVICE_ON:             DB 0                            ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Called with SERVICE_ON =colour   0 OR 66  OPTIMIZED
SERVICE_OFF_ON:
                        LD A,(SERVICE_ON)               ; Get Service colour
                        LD B,6                          ; Setup B as loop counter
                        LD HL,23225-8                   ; 6 ATTR spaces to change colour working backwards from address 23161+6

                        CALL COLOUR_DIALS               ; Colour dial

                        LD A,(ALARM_SOUND_MUTE)         ; Get alarm sound mute status
                        OR A                            ; Is it on?
                        RET NZ                          ; Return without making sound if so

                        LD A,(SERVICE_ON)               ; Get warning colour
                        LD HL,ALARM_SOUND_DATA          ; Alarm sound data
                        CP 1                            ; Does services colour = anything apart from dark blue?
                        CALL NZ,GENERAL_SOUND           ; If so then must be lit so make alarm sound          ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from power meter
TAKE_1_FROM_POWER_METER:
                        LD A,(POWER_STATUS)             ; Get power status
                        CP 1                            ; Is it at 1 or less?
                        JR C,SKIP_TAKE_1_FROM_POWER_METER;
                        DEC A                           ; Take 1 from power status
                        LD (POWER_STATUS),A             ; Update POWER status

SKIP_TAKE_1_FROM_POWER_METER:
                        ;  CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL SET_POWER_METER            ; Update power meter

                        LD A,19                         ; MESSAGE FOR POWER DEPLETING
                        CALL GET_MESSAGE_POINTER        ;

                        LD A,(POWER_STATUS)             ; Get power status
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_POWER_GAME_OVER      ; Skip setting game over counter if not
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,24                         ; Message for POWER depleting
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

SKIP_POWER_GAME_OVER:

                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to power meter
ADD_1_TO_POWER_METER:
                        LD A,(POWER_STATUS)             ; Get power status
                        CP 11                           ; Is it at 11 or more?
                        JR NC,POWER_FULL                ;
                        INC A                           ; Add 1 from power status
                        LD (POWER_STATUS),A             ; Update POWER status

                        ;  CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL SET_POWER_METER            ; Update power meter


                        LD A,26                         ; MESSAGE FOR POWER CHARGING
                        CALL GET_MESSAGE_POINTER        ;

                        CALL TAKE_1_FROM_FUEL           ; Using fuel to charge power

                        LD A,200                        ; Setup A to 200 to count down Scroll show bars
                        LD (SCROLL_SHOW_BARS_ON),A      ; Set Scroll show bars to 250 for countdown to move bars when charging

                        XOR A                           ; A=0
                        LD (POWER_FULL_LOCK),A          ; Reset power full lock so next time the power full gives a message

                        RET                             ; Return

POWER_FULL:
                        LD A,(POWER_FULL_LOCK)          ; Get power lock status
                        CP 1                            ; Is it set (we already had the power full message)?
                        JR Z,POWER_FULL_LOCK_IS_SET     ; Skip Power full message if so


                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; If alien encounter then we dont want Power full message
                        OR A                            ; Is it 0?
                        RET NZ                          ; If not then return to prevent Power Full message




                        LD A,1                          ; Set A=1 to enable Power FUll status lock
                        LD (POWER_FULL_LOCK),A          ; Set Power full lock



                        LD A,64                         ;
                        CALL GET_MESSAGE_POINTER        ; Set the message to Power Full


                        RET                             ; Return
POWER_FULL_LOCK_IS_SET:


                        ;    LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        ;    OR A                            ;
                        ;    RET NZ                          ; We do not want speed message if in alien encounter
                        ;
                        ;       LD A,(ALIENS_APPEAR_COUNTER)    ; Get aliens appear counter
                        ;    OR A                            ; Is it 0?
                        ;    RET NZ                          ; If not then return to prevent Power Full message
                        ;
                        ;      ret
                        ;
                        ;    LD A,(LAST_SPEED_MESSAGE)       ; Set last speed message                         ;
                        ;    CALL GET_MESSAGE_POINTER        ; Set the message
                        RET                             ;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
tmp0:                   DB 0,0                          ; Temporary store for sprite routine
tmp1:                   DB 0,0                          ; Temporary store for sprite routine
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This is my main sprite routine and expects coordinates in (dispx,dispy)
; where dispx is the vertical coord from the top of the screen (0-176), and
; dispy is the horizontal coord from the left of the screen (0 to 240).
; Sprite data is stored as you'd expect in its unshifted form as this
; routine takes care of all the shifting itself.  This means that sprite
; handling isn't particularly fast but the graphics only take 1/8th of the
; space they would require in pre-shifted form.

; On entry BC must point to the unshifted sprite data.

sprit7:                 xor 7                           ; complement last 3 bits.
                        inc a                           ; add one for luck!
sprit3:                 rl d                            ; rotate left...
                        rl c                            ; ...into middle byte...
                        rl e                            ; ...and finally into left character cell.
                        dec a                           ; count shifts we've done.
                        jr nz,sprit3                    ; return until all shifts complete.

; Line of sprite image is now in e + c + d, we need it in form c + d + e.

                        ld a,e                          ; left edge of image is currently in e.
                        ld e,d                          ; put right edge there instead.
                        ld d,c                          ; middle bit goes in d.
                        ld c,a                          ; and the left edge back into c.
                        jr sprit0                       ; we've done the switch so transfer to screen.

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display sprite

dispx:
sprite:                 ld a,0                          ; (dispx)                    ; draws sprite (hl).

                        ld (tmp1),a                     ; store vertical.
                        ; call scadd          ; calculate screen address.
; Calculating a screen address from a pixel coordinate can be tricky!
; The Spectrum screen display is organized into 3 segments of 2048 bytes,
; all containing 8 rows of 32 character squares, each with 8 lines.
; Hence 8 * 32 * 8 * 3 = 6144 bytes.
; Low resolution colour filter = 32 * 8 character squares = 768 bytes.
; Total = 6144 + 768 = 6912 bytes, 16384 to 23295 inclusive.

scadd:                  ld a,(dispx+1)                  ; Returns screen address of coordinates
                        AND 127                         ;

                        ld b,a                          ; (dispx, dispy) in de.
                        and 7                           ; Line 0-7 within character square.
                        add a,96                        ; 96 * 256 = 24576 (Start of screen buffer)
                        ld d,a                          ; Line * 256.
                        ld a,b                          ; fetch x coord again.
                        rrca                            ; divide pixel displacement by 8.
                        rrca                            ;
                        rrca                            ;
                        and 24                          ; Segment 0-2 multiplied by 8.
                        add a,d                         ; Add to h (so multiply by 8 * 256 = 2048)
                        ld d,a                          ;
                        ld a,b                          ; 8 character squares per segment.
                        rlca                            ; Divide x by 8 and multiply by 32,
                        rlca                            ; net calculation: multiply by 4.
                        and 224                         ; Mask off bits we don't want.

                        ld e,a                          ; Vertical coordinate calculation done.
dispy:
                        ld a,0                          ; (dispy)                    ; y coordinate.   LEFT/RIGHT
                        ld b,a                          ; remember horizontal position for later.
                        rrca                            ; now need to divide by 8.
                        rrca                            ;
                        rrca                            ;
                        and 31                          ; Squares 0 - 31 across screen.
                        add a,e                         ; Add to total so far.
                        ld e,a                          ; de = address of screen.


nextsp:
                        ld a,16                         ; height of sprite in pixels.
sprit1:                 ex af,af'                       ; store loop counter.  Height loop;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        push de                         ; store screen address.
                        ld c,(hl)                       ; first sprite graphic data.
                        inc hl                          ; increment pointer to sprite data to right.
                        ld d,(hl)                       ; next part of sprite image.
                        inc hl                          ; point to next row of sprite data.
                        ld (tmp0),hl                    ; store sprite data pointer in tmp0 for later.
                        ld e,0                          ; blank right byte for now.
                        ld a,b                          ; b holds y position.
                        and 7                           ; how are we straddling character cells?
                        jr z,sprit0                     ; we're not straddling them, don't bother shifting.
                        cp 5                            ; 5 or more right shifts needed?
                        jr nc,sprit7                    ; yes, shift from left as it's quicker.
                        and a                           ; oops, carry flag is set so clear it.
sprit2:                 rr c                            ; rotate left byte right...
                        rr d                            ; ...through middle byte...
                        rr e                            ; ...into right byte.
                        dec a                           ; one less shift to do.
                        jr nz,sprit2                    ; return until all shifts complete.
sprit0:                 pop hl                          ; pop screen address from stack.

MERGE_SPRITE:           LD A,0                          ;
                        CP 1                            ;
                        JP Z,MERGE_SPRITE_WITH_BACGROUND;
                        CP 2                            ;
                        JP Z,AND_MASK_WITH_BACKGROUND   ;


; Do not merge sprite with background

                        ; ld a,C           ; what's there already.
                        ; or c               ; merge in image data.
                        ld (hl),C                       ; place onto screen.
                        inc l                           ; next character cell to right please.
                        ; ld a,d           ; what's there already.
                        ; or d               ; merge with middle bit of image.
                        ld (hl),d                       ; put back onto screen.
                        inc hl                          ; next bit of screen area.
                        ; ld a,(hl)           ; what's already there.
                        ; or e               ; right edge of sprite image data.
                        ld (hl),e                       ; plonk it on screen.
                        JP SKIP_MERGE_SPRITE_WITH_BACKGROUND;

; AND MASK with what is already there
AND_MASK_WITH_BACKGROUND:

                        ld a,(hl)                       ; what's there already.
                        AND c                           ; merge in image data.
                        ld (hl),a                       ; place onto screen.
                        inc l                           ; next character cell to right please.
                        ld a,(hl)                       ; what's there already.
                        AND d                           ; merge with middle bit of image.
                        ld (hl),a                       ; put back onto screen.
                        inc hl                          ; next bit of screen area.
                        ; ld a,(hl)           ; what's already there.
                        ; AND e               ; right edge of sprite image data.
                        ; ld (hl),a           ; plonk it on screen.
                        JP SKIP_MERGE_SPRITE_WITH_BACKGROUND;



; Merge with what is already there
MERGE_SPRITE_WITH_BACGROUND:

                        ld a,(hl)                       ; what's there already.
                        or c                            ; merge in image data.
                        ld (hl),a                       ; place onto screen.
                        inc l                           ; next character cell to right please.
                        ld a,(hl)                       ; what's there already.
                        or d                            ; merge with middle bit of image.
                        ld (hl),a                       ; put back onto screen.
                        inc hl                          ; next bit of screen area.
                        ld a,(hl)                       ; what's already there.
                        or e                            ; right edge of sprite image data.
                        ld (hl),a                       ; plonk it on screen.

; Jumps here after not merging the sprite
SKIP_MERGE_SPRITE_WITH_BACKGROUND:
                        ld a,(tmp1)                     ; temporary vertical coordinate.
                        inc a                           ; next line down.
                        ld (tmp1),a                     ; store new position.
                        and 63                          ; are we moving to next third of screen?
                        jr z,sprit4                     ; yes so find next segment.
                        and 7                           ; moving into character cell below?
                        jr z,sprit5                     ; yes, find next row.
                        dec hl                          ; left 2 bytes.
                        dec l                           ; not straddling 256-byte boundary here.
                        inc h                           ; next row of this character cell.
sprit6:                 ex de,hl                        ; screen address in de.
                        ld hl,(tmp0)                    ; restore graphic address.
                        ex af,af'                       ; restore loop counter.;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        dec a                           ; decrement it.
                        jr nz,sprit1                    ; not reached bottom of sprite yet to repeat.
                        ret                             ; job done.

sprit4:                 ld de,30                        ; next segment is 30 bytes on.
                        add hl,de                       ; add to screen address.
                        jr sprit6                       ; repeat.
sprit5:                 ld de,63774                     ; minus 1762.
                        add hl,de                       ; subtract 1762 from physical screen address.
                        jp sprit6                       ; rejoin loop.
                        ret                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy from screen buffer to visible screen
ZIPZAP_SCREEN_COPY:

                        ;  XOR B                           ; Set low byte for LDIR counter to zero
                        ;  LD A,28                         ; 28 collumns
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set ATTR from line 2 to 13 collumn 2 to 29
                        ; LD (SAVE_SPB+1),SP
                        LD HL,32834                     ; +(12*32)                     ;
                        LD DE,22594                     ; +(12*32)                     ; ATTR Line 2,2


                        LD A,12                         ;

C45503:
                        LD BC,28                        ;

                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;
                        LDI                             ;


                        INC DE                          ;
                        INC DE                          ;
                        INC DE                          ;
                        INC DE                          ;
                        INC HL                          ; 6
                        INC HL                          ; 12
                        INC HL                          ;  18
                        INC HL                          ;   24
                        DEC A                           ;
                        JR NZ,C45503                    ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ZIPZAP_SCREEN_COPY_SCREEN:
                        XOR B                           ;
                        LD A,28                         ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24642                     ;
                        LD DE,16450                     ;
                        LDIR                            ; LINE 17

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24674                     ;
                        LD DE,16482                     ;
                        LDIR                            ; LINE 24

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24706                     ;
                        LD DE,16514                     ;
                        LDIR                            ; LINE 32

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24738                     ;
                        LD DE,16546                     ;
                        LDIR                            ; LINE 40

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24770                     ;
                        LD DE,16578                     ;
                        LDIR                            ; LINE 48

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24802                     ;
                        LD DE,16610                     ;
                        LDIR                            ; LINE 56

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24898                     ;
                        LD DE,16706                     ;
                        LDIR                            ; LINE 18

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24930                     ;
                        LD DE,16738                     ;
                        LDIR                            ; LINE 26

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24962                     ;
                        LD DE,16770                     ;
                        LDIR                            ; LINE 34

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,24994                     ;
                        LD DE,16802                     ;
                        LDIR                            ; LINE 42

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25026                     ;
                        LD DE,16834                     ;
                        LDIR                            ; LINE 50

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25058                     ;
                        LD DE,16866                     ;
                        LDIR                            ; LINE 58

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25154                     ;
                        LD DE,16962                     ;
                        LDIR                            ; LINE 19

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25186                     ;
                        LD DE,16994                     ;
                        LDIR                            ; LINE 27
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25218                     ;
                        LD DE,17026                     ;
                        LDIR                            ; LINE 35
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25250                     ;
                        LD DE,17058                     ;
                        LDIR                            ; LINE 43

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25282                     ;
                        LD DE,17090                     ;
                        LDIR                            ; LINE 51

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25314                     ;
                        LD DE,17122                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25410                     ;
                        LD DE,17218                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25442                     ;
                        LD DE,17250                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25474                     ;
                        LD DE,17282                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25506                     ;
                        LD DE,17314                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25538                     ;
                        LD DE,17346                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25570                     ;
                        LD DE,17378                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25666                     ;
                        LD DE,17474                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25698                     ;
                        LD DE,17506                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25730                     ;
                        LD DE,17538                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25762                     ;
                        LD DE,17570                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25794                     ;
                        LD DE,17602                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25826                     ;
                        LD DE,17634                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25922                     ;
                        LD DE,17730                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25954                     ;
                        LD DE,17762                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,25986                     ;
                        LD DE,17794                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26018                     ;
                        LD DE,17826                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26050                     ;
                        LD DE,17858                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26082                     ;
                        LD DE,17890                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26178                     ;
                        LD DE,17986                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26210                     ;
                        LD DE,18018                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26242                     ;
                        LD DE,18050                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26274                     ;
                        LD DE,18082                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26306                     ;
                        LD DE,18114                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26338                     ;
                        LD DE,18146                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26434                     ;
                        LD DE,18242                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26466                     ;
                        LD DE,18274                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26498                     ;
                        LD DE,18306                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26530                     ;
                        LD DE,18338                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26562                     ;
                        LD DE,18370                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26594                     ;
                        LD DE,18402                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26626                     ;
                        LD DE,18434                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26658                     ;
                        LD DE,18466                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26690                     ;
                        LD DE,18498                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26722                     ;
                        LD DE,18530                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26754                     ;
                        LD DE,18562                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26786                     ;
                        LD DE,18594                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26882                     ;
                        LD DE,18690                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26914                     ;
                        LD DE,18722                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26946                     ;
                        LD DE,18754                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,26978                     ;
                        LD DE,18786                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27010                     ;
                        LD DE,18818                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27042                     ;
                        LD DE,18850                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27138                     ;
                        LD DE,18946                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27170                     ;
                        LD DE,18978                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27202                     ;
                        LD DE,19010                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27234                     ;
                        LD DE,19042                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27266                     ;
                        LD DE,19074                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27298                     ;
                        LD DE,19106                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27394                     ;
                        LD DE,19202                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27426                     ;
                        LD DE,19234                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27458                     ;
                        LD DE,19266                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27490                     ;
                        LD DE,19298                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27522                     ;
                        LD DE,19330                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27554                     ;
                        LD DE,19362                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27650                     ;
                        LD DE,19458                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27682                     ;
                        LD DE,19490                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27714                     ;
                        LD DE,19522                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27746                     ;
                        LD DE,19554                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27778                     ;
                        LD DE,19586                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27810                     ;
                        LD DE,19618                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27906                     ;
                        LD DE,19714                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27938                     ;
                        LD DE,19746                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,27970                     ;
                        LD DE,19778                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28002                     ;
                        LD DE,19810                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28034                     ;
                        LD DE,19842                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28066                     ;
                        LD DE,19874                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28162                     ;
                        LD DE,19970                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28194                     ;
                        LD DE,20002                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28226                     ;
                        LD DE,20034                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28258                     ;
                        LD DE,20066                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28290                     ;
                        LD DE,20098                     ;
                        LDIR                            ;
                        LD C,A                          ; Set high byte for LDIR counter to 28
                        LD HL,28322                     ;
                        LD DE,20130                     ;
                        LDIR                            ;


                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28418                     ;
                        LD DE,20226                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28450                     ;
                        LD DE,20258                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28482                     ;
                        LD DE,20290                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28514                     ;
                        LD DE,20322                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28546                     ;
                        LD DE,20354                     ;
                        LDIR                            ;

                        LD C,A                          ; Set high byte for LDIR counter to 28          ;
                        LD HL,28578                     ;
                        LD DE,20386                     ;
                        LDIR                            ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 2D ship movement

; Move up
MOVEUP:
                        LD A,(SP1Y_SHIP)                ; Get Y coordinate of SPACESHIP
                        CP 20                           ; Is SPACESHIP at top of play area?
                        RET C                           ; Return if Yes

                        SUB 4                           ; Reduce coordinate by 1 pixel
                        LD (SP1Y_SHIP),A                ; Update Y coordinate of SPACESHIP
                        RET                             ; Return

; Move down
MOVEDOWN:
                        LD A,(SP1Y_SHIP)                ; Get Y coordinate of HORACE
                        CP 60                           ; Is HORACE at bottom of play area?
                        RET NC                          ;
                        ADD A,4                         ; Add coordinate by 1 pixel
                        LD (SP1Y_SHIP),A                ; Update Y coordinate of SPACESHIP
                        RET                             ; Return

; Move right
MOVERIGHT:
                        LD A,(SP1X_SHIP)                ; Get X coordinate of SPACESHIP
                        CP 150                          ; Is SPACESHIP at far right of play area?
                        RET NC                          ; Return if Yes
                        ADD A,8                         ; Decrease coordinate

                        LD (SP1X_SHIP),A                ; Update X coordinate of SPACESHIP

                        RET                             ; Return
; Move left
MOVELEFT:
                        LD A,(SP1X_SHIP)                ; Get X coordinate of SPACESHIP
                        CP 20                           ; Is SPACESHIP at far left of play area?
                        RET C                           ; Return if Yes
                        SUB 8                           ; Increase coordinate by 1 count
                        LD (SP1X_SHIP),A                ; Update X coordinate of SPACESHIP

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPECIAL_ALIEN_FRAME_COUNTER:DB 0                        ; Used to count alien frame
                        ; Starts at 255 and counts down to control
                        ; Back to distance for example
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set all aliens sequence type

                        ; Current sequence
                        ; 0=Nothing
                        ; 1=Aliens appear from back to distance
                        ; 2=Aliens appear from distance to front of ship
                        ; 3=Random (Normal)
                        ; 4=Disapear (After trade)

SET_ALL_ALIENS_SEQUENCE:
                        CALL RELEASE_RANDOM_NUMBER      ;
                        AND 3                           ;
                        ;  ld a,1;1;2                          ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD B,A                          ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;   out (254),a
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Calls here when aliens need to disapear, perhaps after trading Called with B=sequence number
SET_ALL_ALIENS_SEQUENCE_FOR_DISAPEAR:
                        LD IX,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data

                        LD A,4                          ; 4 alien ships max
SET_ALL_ALIEN_SHIPS_SEQUENCE_LOOP:;Loop for enabling alien ships;
                        LD (IX+10),B                    ; Set alien ship behavior

                        LD DE,12+32                     ;
                        ADD IX,DE                       ;

                        DEC A                           ;
                        JR NZ,SET_ALL_ALIEN_SHIPS_SEQUENCE_LOOP;


RESET_ALIEN_COORDINATES:
; Set start coordinates
                        PUSH BC                         ;
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        POP BC                          ;
                        ; 1=Aliens appear from back to distance
                        LD A,B                          ;
                        CP 1                            ;
                        JP Z,SET_ALL_ALIENS_COORDINATES_4_CORNERS_3 ; Set alien sequence to start behind ship so they fly to the distance

; We dont want back to distance this time

                        ; 2=Aliens appear from distance to front of ship
                        CP 2                            ;
                        JP Z,SET_ALL_ALIENS_COORDINATES_DISTANCE_3 ; Set alien sequence to start in distance fly towards the ship
; We dont want distance to back this time
                        ; 3=Random (Normal)
                        CP 3                            ;
                        JP Z,SET_ALL_ALIENS_COORDINATES_RANDOM_3 ; Set alien sequence to start in random positions



                        RET                             ;

                        ; 150k FREE HERE


      if *> 45550                                       ;
                        zeuserror "out of room"         ;
      endif                                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ORG                     45568                           ;

                        ; Interupt table
INTERUPT_VECTOR_TABLE:
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156,156;
                        DEFB 156,156,156,156,156,156,156;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Large screen text wrap around reset message 1
UPDATE_LARGE_MESSAGE_IN_BUFFER_RESET:

                        POP BC                          ;
                        LD A,(SERVICES_ON)              ;   Get Services screen number
                        CP 255                          ; Is it screen1?
                        JR NZ,SKIP_RESETTING_SCREEN_A   ; If not then skip screen 1 wrap around

                        CALL GET_MESSAGE_POINTER_LARGE_SCREEN ; Reset screen 1 message
                        JP COPY_EMPTY_BUFFER_TO_BUFFER  ; Skip resetting screen 2
SKIP_RESETTING_SCREEN_A:

                        CALL GET_MESSAGE_POINTER_LARGE_SCREEN2 ; Reset message on screen 2

; SKIP_RESETTING_SCREEN_2:

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copy the empty buffer to the display buffer
COPY_EMPTY_BUFFER_TO_BUFFER:

UPDATESCREENONLY:
                        LD HL,SCREEN1_EMPTY             ; Point to screen buffer
                        LD DE,SCREEN1                   ; Point to displayed screen
                        LD BC,4096                      ; 4096 bytes to copy

SCREENUPDATELOOP:
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer

                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer
                        LDI                             ; Copy empty screen buffer to screen buffer




                        JP PE,SCREENUPDATELOOP          ; Jump back until all buffer is done

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour sprite
; D=COLOUR
; COLOUR_SPRITE:
;                        PUSH DE                         ; Save colour
;                        CALL GET_ATTR_ADDRESS           ; Get ATTR address into HL

; TWO_ROWS_ONLY:
                        ;                       LD A,D                          ; Get sprite colour

; COLOUR_SPRITE2:         LD BC,30                        ; Set BC up for addition
                        ;                       LD (HL),A                       ; Set colour for top left graphic
                        ;                       INC HL                          ; Move to right one graphic
                        ;                       LD (HL),A                       ; Set colour for top middle graphic
                        ;                       INC HL                          ; Move to right one graphic
                        ;                       LD (HL),A                       ; Set colour for bottom middle graphic
                        ;
                        ;                       ADD HL,BC                       ; Jump to next line
                        ;                       LD (HL),A                       ; Set colour for bottom left graphic
                        ;                       INC HL                          ; Move to right one graphic
                        ;                       LD (HL),A                       ; Set colour for bottom middle graphic
                        ;                       INC HL                          ; Move to right one graphic
                        ;                       LD (HL),A                       ; Set colour for bottom middle graphic
                        ;
                        ;                       EX AF,AF'                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;                       POP DE                          ; Restore colour
                        ;                       RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Get screen ATTR address into HL
; GET_ATTR_ADDRESS:

;                        PUSH BC                         ;
;                        LD A,(dispy+1)                  ; up/down       ; Look at the vertical first.
;                        RRCA                            ;
;                        RRCA                            ;
;                        RRCA                            ;
;                        AND 31                          ;
;
;                        LD L,A                          ;
;                        LD A,(dispx+1)                  ; get horizontal position.
;                        RLCA                            ;
;                        RLCA                            ;
;
;                        LD C,A                          ;
;                        AND 224                         ;
;                        OR L                            ;
;                        LD L,A                          ;
;                        LD A,C                          ;
;                        AND 3                           ;
;        ; OR   88
;                        ADD A,128                       ; attributes start at 128*256=32768.
;                        LD H,A                          ;
;                        POP BC                          ;
;                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset Services Information figures
RESET_SERVICES_FIGURES:

; TOTAL HD RESET
                        CALL RESET_HD                   ;

; SHIELDS RESET
                        LD HL,GOOD                      ;
                        LD DE,SHEILDS_DATA              ;
                        LD BC,4                         ;
                        LDIR                            ;

; TEMPERATURE RESET
                        CALL RESET_TEMPERATURE_FIGURES  ;

; FUEL REMAINING RESET  Xargon-3
RESET_FUEL_FIGURES:
                        LD HL,RESET_FIGURES             ;
                        LD DE,FUEL_DATA                 ;
                        JP RESET_FIGURES1               ;

                        ;  LD BC,3                         ;
                        ; LDIR                            ;
                        ; RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESET_TEMPERATURE_FIGURES:
                        ; Reset all three digits of TEMPERATURE to 000
                        LD HL,RESET_FIGURES             ;
                        LD DE,TEMPERATURE_DATA          ;
RESET_FIGURES1:
                        LD BC,3                         ;
                        LDIR                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset HD Figures
RESET_HD:
                        LD HL,RESET_FIGURES_HD          ;
                        LD DE,HD_DATA                   ;
                        LD BC,8                         ;
                        LDIR                            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Increment HD
ADD_1_TO_HD:
                        LD HL,HD_DATA+6                 ; Last digit of HD data
                        ; LD C,8                          ; Data is 8 figures
                        CALL INCREMENT_FIGURES          ; Add 1 to the figure
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from HD
TAKE_1_FROM_HD:
                        PUSH BC                         ;

                        LD HL,HD_DATA+6                 ; Last digit of HD data
                        PUSH HL                         ; Save address for check
                        CALL DECREMENT_FIGURE           ; Take 1 from figure
                        POP HL                          ; Restore address for check

; Check if all digits are zero
                        LD B,9                          ; Set loop to check for 9 digits
TAKE_1_FROM_HD_CHECK_LOOP:

                        LD A,(HL)                       ; Get current digit
                        CP "0"                          ; Is the digit a 0?
                        JR NZ,TOO_MANY                  ; Return if not a zero
                        DEC HL                          ; Move to next digit address
                        DJNZ TAKE_1_FROM_HD_CHECK_LOOP  ; Jump back to check next digit
; All zeros
                        LD A,90                         ; Message for out of money
                        CALL GET_MESSAGE_POINTERB       ; Get message into HL

                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        POP BC                          ;
                        RET                             ;

TOO_MANY:
                        POP BC                          ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Services Reputation status
; REPUTATION_GOOD:                          DEFM "GOOD"
; REPUTATION_OK:                            DEFM "OK  "
; REPUTATION_BAD:                           DEFM "BAD "
; REPUTATION                                         ;0=Good, 1=OK, 2=Bad
; FUEL:                                     DB 0    ;Fuel percentage
; SHIELDS:                                  DB 0    ;Shields percentage
; ENGINE_STATUS                             DB 0    ;Engine status ;0-good, 1-OK, 2-bad
; TEMPERATURE:                              DB 0    ;Temperature
; POWER_STATUS:                             DB 0    ;POWER_STATUS Status ;>12-good, >5-OK, <2-bad
; OXYGEN:                                   DB 0    ;OXYGEN status ;0-good, 1-OK, 2-bad

;https://www.youtube.com/watch?v=gqSzDJGFCgI
SET_REPUTATION:

                        LD A,(REPUTATION)               ;
                        CP 4                            ; CP 0                            ;
                        JP C,SET_REPUTATION_TO_BAD      ;
                        CP 7                            ;
                        JP C,SET_REPUTATION_TO_OK       ;
                        CP 9                            ;
                        JP Z,SET_REPUTATION_TO_GOOD     ;
                        RET                             ;

SET_REPUTATION_STATUS:
; HL=TEXT STRING
                        LD DE,REPUTATION_DATA           ;
                        JP SET_POWER_STATUS_LOOPA       ; Jump to set status text


                        ; LD B,4                          ;
; SET_REPUTATION_LOOP:
                        ;                       LD A,(HL)                       ;
                        ;                       LD (DE),A                       ;
                        ;                       INC DE                          ;
                        ;                       INC HL                          ;
                        ;                       DJNZ SET_REPUTATION_LOOP        ;
                        ;
                        ;                      RET                             ;

SET_REPUTATION_TO_GOOD:
                        LD HL,GOOD                      ;
                        JP SET_REPUTATION_STATUS        ;

SET_REPUTATION_TO_OK:
                        LD HL,OK                        ;
                        JP SET_REPUTATION_STATUS        ;

SET_REPUTATION_TO_BAD:
                        LD HL,BAD                       ;
                        JP SET_REPUTATION_STATUS        ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_ENGINE:
                        LD A,(ENGINE_STATUS)            ;

                        CP 25                           ;
                        JP C,SET_ENGINE_TO_BAD          ; If engine status is above 0 AND BELOW 50 then set to BAD
                        CP 50                           ;
                        JP C,SET_ENGINE_TO_OK           ; If engine status is above 50 then set to OK
                        CP 90                           ;
                        JP C,SET_ENGINE_TO_GOOD         ; If engine status is above 90 then set to good

                        RET                             ;

SETTING_ENGINE_STATUS:
; HL=TEXT STRING
                        LD DE,ENGINE_DATA               ;
                        JP SET_POWER_STATUS_LOOPA       ; Jump to set status text



                        ; LD B,4                          ;
; SET_ENGINE_STATUS_LOOP:
                        ;                       LD A,(HL)                       ;
                        ;                       LD (DE),A                       ;
                        ;                       INC DE                          ;
                        ;                       INC HL                          ;
                        ;                       DJNZ SET_ENGINE_STATUS_LOOP     ;

                        ;                       RET                             ;

SET_ENGINE_TO_GOOD:
                        LD A,96                         ; Set diagram engine status colour to black ink in light green
                        LD (ENGINE_STATUS_COLOUR),A     ;
                        CALL SWITCH_WARNING_OFF         ; Switch off warning

                        LD HL,GOOD                      ;
                        JP SETTING_ENGINE_STATUS        ;

SET_ENGINE_TO_OK:
                        LD A,112                        ; Set diagram engine status colour to black ink in light yellow
                        LD (ENGINE_STATUS_COLOUR),A     ;
                        CALL SWITCH_WARNING_OFF         ; Switch off warning
                        LD HL,OK                        ;
                        JP SETTING_ENGINE_STATUS        ;

SET_ENGINE_TO_BAD:
                        LD A,80                         ; Set diagram engine status colour to black ink in light RED
                        LD (ENGINE_STATUS_COLOUR),A     ;

                        CALL SWITCH_WARNING_ON          ; Switch on warning

                        LD HL,BAD                       ;
                        JP SETTING_ENGINE_STATUS        ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_COCKPIT_STATUS:
                        ; LD A,96                         ; Diagram status black on bright green
                        ; LD (COCKPIT_STATUS_COLOUR),A       ;

                        LD DE,COCKPIT_DATA              ;
                        LD HL,GOOD                      ;

                        CALL SET_POWER_STATUS_LOOPA     ;

                        LD A,(COCKPIT_STATUS_COLOUR)    ;
                        CP 80                           ;
                        JR Z,SET_COCKPIT_TO_BAD         ; If Cockpit status colour on 80 then set to BAD


                        LD A,(COCKPIT_STATUS_COLOUR)    ;
                        CP 112                          ;
                        JR Z,SET_COCKPIT_TO_OK          ; If Cockpit status colour on 112 then set to OK
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_COCKPIT_TO_BAD:     ; Severe damage                 ;
                        ; LD A,80                         ; Diagram status black on bright red
                        ; LD (COCKPIT_STATUS_COLOUR),A       ;

                        LD A,84                         ; Cockpit destroyed message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD DE,COCKPIT_DATA              ;
                        LD HL,BAD                       ;

                        ;
                        CALL SET_POWER_STATUS_LOOPA     ;

                        CALL SWITCH_WARNING_ON          ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_COCKPIT_TO_OK:
                        LD A,74                         ; Cockpit Severe damage messag
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD DE,COCKPIT_DATA              ;
                        LD HL,OK                        ;

                        ;
                        CALL SET_POWER_STATUS_LOOPA     ;

                        CALL SWITCH_WARNING_ON          ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FOOD_STATUS:
                        LD A,96                         ; Set food to good and diagram status black on bright green
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD DE,FOOD_DATA                 ; Get Good string and add it to string location to display
                        LD HL,GOOD                      ;
                        CALL SET_POWER_STATUS_LOOPA     ;


                        LD A,(FOOD)                     ;

                        CP 20                           ;
                        JR C,SET_FOOD_TO_BAD            ; If food status is BELOW 20 then set to BAD

                        CP 40                           ;
                        JP C,SET_FOOD_TO_OK             ; If food status is BELOW 40 then set to GOOD


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_FOOD_TO_BAD:
                        LD A,80                         ; Diagram status black on bright red
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD A,73                         ; Food low message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        LD DE,FOOD_DATA                 ;
                        LD HL,BAD                       ;
SET_FOOD_CALLBACK:
                        ;
                        CALL SET_POWER_STATUS_LOOPA     ;

                        CALL SWITCH_WARNING_ON          ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FOOD_TO_OK:
                        LD A,112                        ; Diagram status black on bright yellow
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD A,73                         ; Food low message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        LD DE,FOOD_DATA                 ;
                        LD HL,OK                        ;
                        JP SET_FOOD_CALLBACK            ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_WATER_STATUS:
                        LD A,96                         ; Set water to good and diagram status black on bright green
                        LD (WATER_STATUS_COLOUR),A      ; Set water status colour on status map to black on bright green

                        LD DE,WATER_DATA                ; Point HL to Service menu data for Water
                        LD HL,GOOD                      ; Point HL to "Good" string
                        ; CALL SET_POWER_STATUS_LOOPA     ;


                        LD A,(WATER_STATUS)             ;

                        CP 20                           ;
                        JR C,SET_WATER_TO_BAD           ; If water status is bellow 20 then set to BAD

                        CP 40                           ;
                        JP C,SET_WATER_TO_OK            ; If water status is BELOW 40 then set to OK


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_WATER_TO_BAD:
                        LD A,80                         ; Diagram status black on bright red
                        LD (WATER_STATUS_COLOUR),A      ;

                        LD A,16                         ; Water low message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD DE,WATER_DATA                ;
                        LD HL,BAD                       ;

SET_WATER_CALLBACK:     ;
                        CALL SET_POWER_STATUS_LOOPA:    ;

                        CALL SWITCH_WARNING_ON          ; Switch on warning

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_WATER_TO_OK:
                        LD A,112                        ; Diagram status black on bright yellow
                        LD (WATER_STATUS_COLOUR),A      ;

                        LD A,16                         ; Water low message
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD DE,WATER_DATA                ;
                        LD HL,OK                        ;
                        JP SET_WATER_CALLBACK           ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_POWER_STATUS:

                        LD A,(POWER_STATUS)             ; Get Power status


                        CP 2                            ; Is Power status at 2?
                        JR C,SET_POWER_TO_BAD           ; If power status is above 0 AND BELOW 2 then set to BAD
                        CP 5                            ; Is Power status at 2?
                        JR C,SET_POWER_TO_OK            ; If Power status is above 5 then set to OK

                        CP 12                           ; Is Power status at 12?
                        JR C,SET_POWER_TO_GOOD          ; If Power status is above 12 then set to good

                        RET                             ; Return

SET_POWER_STATUS2:
; Update service menu text HL=TEXT STRING
                        LD DE,POWER_DATA                ; DE=Service menu data location for Power status


SET_POWER_STATUS_LOOPA:
                        LD B,4                          ;
SET_POWER_STATUS_LOOPX:
                        LD A,(HL)                       ;
                        CP 255                          ;
                        RET Z                           ;
                        LD (DE),A                       ;
                        INC DE                          ;
                        INC HL                          ;
                        ;  LD BC,4                         ; 4 characters to update
                        ; LDIR                            ;

                        DJNZ SET_POWER_STATUS_LOOPX     ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_POWER_TO_GOOD:
                        CALL SWITCH_WARNING_OFF         ; Set warning off
                        LD HL,GOOD                      ; Point to "Good" string
                        JP SET_POWER_STATUS2            ; Update the service menu with selected text string

SET_POWER_TO_OK:

                        CALL SWITCH_WARNING_OFF         ; Set warning off
                        LD HL,OK                        ; Point to "OK" string
                        JP SET_POWER_STATUS2            ; Update the service menu with selected text string

SET_POWER_TO_BAD:

                        CALL SWITCH_WARNING_ON          ; Set warning on
                        LD HL,BAD                       ; Point to "Bad" string
                        JP SET_POWER_STATUS2            ; Update the service menu with selected text string

                        RET                             ; Return

SWITCH_WARNING_ON:
                        LD A,1                          ; A=1 to switch on Warning
                        LD (SET_WARNING_ON),A           ; Set warning to on
                        RET                             ;
SWITCH_WARNING_OFF:
                        XOR A                           ; A=1 to switch on Warning
                        LD (SET_WARNING_ON),A           ; Set warning to on

                        INC A                           ; A=1 for blue
                        LD (WARNING_ON),A               ;

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SWITCH_SERVICE_ON:
                        LD A,1                          ; A=1 to switch on Warning
                        LD (SET_SERVICE_ON),A           ; Set warning to on
                        RET                             ;
SWITCH_SERVICE_OFF:
                        XOR A                           ; A=1 to switch on Warning
                        LD (SET_SERVICE_ON),A           ; Set warning to on
                        LD (SERVICE_ON),A               ;
                        CALL SERVICE_OFF_ON             ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Take temperature value and turn into text form in data
SET_TEMPERATURE:

                        CALL RESET_TEMPERATURE_FIGURES  ; Set the figures to 000

                        LD A,(TEMPERATURE)              ; Get TEMP
                        ;  LD C,4                          ; Data is 4 figures
                        LD HL,TEMPERATURE_DATA+2        ; Last digit of TEMPERATURE data
                        LD B,A                          ; Setup Loop to call increment data routine
SET_TEMPERATURE_LOOP:
                        PUSH HL                         ; Save data pointer address
                        ;  PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES          ; Add 1 to the figure
                        ;  POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_TEMPERATURE_LOOP       ; Jump back until figure is set

; Plot bar on left border
                        ;                    LD A,(TEMPERATURE)              ; Get TEMP
                        ;                    SRA A                           ;
                        ;                    SRA A                           ;


                        ;                   LD HL,20480-128                 ; Screen address
; PLOT_BAR_BORDER_LOOP:
                        ;                       PUSH AF                         ;
                        ;                      LD A,3                          ;
                        ;                     AND %00000111                   ;
                        ;                    OR (HL)                         ;

                        ;                   LD (HL),A                       ; Draw bar
                        ;                  INC L                           ;

                        ;                 LD A,192                        ;
        ;                AND %11000000                   ;
                        ;               OR (HL)                         ;

                        ;              LD (HL),A                       ; Draw bar
                        ;             POP AF                          ;
                        ;            DEC L                           ;
                        ;           DEC H                           ;
                        ;          DEC A                           ; Take 1 from loop
                        ;         JR NZ,PLOT_BAR_BORDER_LOOP      ; Jump back until all of bar is done






                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to Engine
ADD_1_TO_ENGINE:
                        LD A,(ENGINE_STATUS)            ; Get engine status 0 to 100
                        CP 100                          ; Is it at 100?
                        JR Z,SKIP_ADD_1_TO_ENGINE       ; If so then do not add any more
                        INC A                           ; Add 1
                        LD (ENGINE_STATUS),A            ; Update engine status
                        CP 80                           ; Is it at 80?
                        JR NZ,SKIP_ADD_TO_ENGINE_SERVICE;
                        CALL SWITCH_SERVICE_ON          ; If so then switch Service warning on


                        LD A,80                         ; MESSAGE FOR Engine service required
                        CALL GET_MESSAGE_POINTER        ;
SKIP_ADD_TO_ENGINE_SERVICE:
                        CALL SET_ENGINE                 ; Set the Engine status
SKIP_ADD_1_TO_ENGINE:
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take fuel value and turn into text form in data
SET_FUEL:
                        CALL RESET_FUEL_FIGURES         ; Set the figures to 000 so we can count the fuel up to set the new figure
                        ; Assume fuel is OK

                        CALL SWITCH_WARNING_OFF         ; Switch warning off


                        LD A,96                         ; Black ink on light green paper
                        LD (FUEL_STATUS_COLOUR),A       ;
; Get Fuel status
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 40                           ; Is fuel low?
                        JR NC,SKIP_SETTING_FUEL_WARNING ; If NOT then skip setting fuel warning

                        LD A,112                        ; Black ink on light yellow paper
                        LD (FUEL_STATUS_COLOUR),A       ;

                        CALL SWITCH_WARNING_ON          ; Switch warning on

                        LD A,67                         ; MESSAGE FOR Xargon low
                        CALL GET_MESSAGE_POINTER        ;
                        JP SKIP_DISPLAY_FUEL_FULL       ;
SKIP_SETTING_FUEL_WARNING:


                        ; LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 30                           ; Is fuel depleted?
                        JR NC,SKIP_SETTING_FUEL_WARNING2 ; If NOT then skip setting fuel warning

                        LD A,80                         ; Black ink on light red paper
                        LD (FUEL_STATUS_COLOUR),A       ;

                        CALL SWITCH_WARNING_ON          ; Switch warning on

                        LD A,64                         ; MESSAGE FOR Xargon depleted
                        CALL GET_MESSAGE_POINTER        ;
                        JP SKIP_DISPLAY_FUEL_FULL       ;

SKIP_SETTING_FUEL_WARNING2:

                        ;  LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 1                            ; Fuel at 1 or below?
                        JR C,FUEL_DEPLETED2             ; Out of fuel

                        ;  LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 90                           ;
                        JR C,SKIP_DISPLAY_FUEL_FULL     ; If 90 or below then skip Fuel ok


                        LD A,65                         ; MESSAGE FOR Xargon OK
                        CALL GET_MESSAGE_POINTER        ;
SKIP_DISPLAY_FUEL_FULL:

                        ;  LD C,3                          ; Data is 3 figures
                        LD HL,FUEL_DATA+2               ; Last digit of fuel data

                        LD A,(FUEL)                     ; Get fuel percentage remaining                          ; Setup Loop to call increment data routine
                        LD B,A                          ;
SET_FUEL_LOOP:
                        PUSH HL                         ; Save data pointer address
                        ; PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES          ; Add 1 to the figure
                        ; POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_FUEL_LOOP              ; Jump back until figure is set
                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to fuel
ADD_1_TO_FUEL:
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET NC                          ; Return if so
                        INC A                           ; Add 1 to fuel
                        LD (FUEL),A                     ; Update fuel
                        CALL SET_FUEL                   ; Update fuel
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from fuel
TAKE_1_FROM_FUEL:
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 1                            ; Is it already at 1% or less?
                        JR C,FUEL_DEPLETED              ; Jump to fuel depleted if so
                        DEC A                           ; Take 1 from fuel
                        LD (FUEL),A                     ; Update fuel
                        CALL SET_FUEL                   ; Update fuel
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Out of fuel so set game over countdown
FUEL_DEPLETED:
                        CALL SET_FUEL                   ; Update fuel
FUEL_DEPLETED2:

                        LD A,89                         ; MESSAGE FOR Fuel Depleted
                        CALL GET_MESSAGE_POINTER        ;

                        CALL SET_GAME_OVER_COUNTER      ; Set game over countdown



                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RADAR_SECTOR_NUMBER_DEFAULT_TEXT:DEFM "000"             ;
RADAR_SECTOR_NUMBER_TEXT:DEFM "000"                     ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Increment figure pointed to by setting HL to the last digit address
; The entry point to this routine is here. HL pointing at the digit of the score to be incremented

INCREMENT_FIGURES:

; Check current figure to see if it is a 9, if it is not then set to a zero and move to the next digit to the left and increment it
                        LD A,(HL)                       ; A=last byte of data to adjust
                        CP "9"                          ; is value at 9?
                        JR NZ,ADD_1_TO_DIGIT            ; If not then jump to increment digit

; Digit is a 9 so set it to 0 and move to the digit to the left to check to see if it is a space or a 9 and if not then increment it
                        LD (HL),"0"                     ; 56                      ; Set address to "0"
                        DEC HL                          ; Go to next score address to the left


                        JP INCREMENT_FIGURES            ;

; Add 1 to the digit and leave
ADD_1_TO_DIGIT:         INC (HL)                        ; increase current digit

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DECREMENT_FIGURE:

; Check current figure to see if it is a 9, if it is not then set to a zero and move to the next digit to the left and increment it
                        LD A,(HL)                       ; A=last byte of data to adjust
                        CP "0"                          ; is value at 9?
                        JR NZ,TAKE_1_FROM_DIGIT         ; If not then jump to decrement digit

; Digit is a 9 so set it to 0 and move to the digit to the left to check to see if it is a space or a 9 and if not then increment it
                        LD (HL),"9"                     ; 56                      ; Set address to "0"
                        DEC HL                          ; Go to next score address to the left

; Get digit and check if it is a dollar for far left end of number
                        LD A,(HL)                       ; A=next byte of score
                        CP "$"                          ; Is the data a "$"?
                        RET Z                           ; Return if so

                        JP DECREMENT_FIGURE             ;



; Add 1 to the digit and leave
TAKE_1_FROM_DIGIT:      DEC (HL)                        ; increase current digit


                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Oxygen status
SET_OXYGEN:
                        LD A,(OXYGEN)                   ;

                        CP 20                           ;
                        JR C,SET_OXYGEN_TO_BAD          ; If OXYGEN status is above 0 AND BELOW 50 then set to BAD
                        CP 50                           ;
                        JR C,SET_OXYGEN_TO_OK           ; If OXYGEN status is above 50 then set to OK

                        CP 90                           ;
                        JR C,SET_OXYGEN_TO_GOOD         ; If OXYGEN status is above 90 then set to good

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_OXYGEN_STATUS:
; HL=TEXT STRING
                        LD DE,OXYGEN_DATA               ;
                        JP SET_POWER_STATUS_LOOPA       ; Jump to set status text

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_OXYGEN_TO_GOOD:
                        LD HL,GOOD                      ;
                        JP SET_OXYGEN_STATUS            ;

SET_OXYGEN_TO_OK:
                        LD HL,OK                        ;
                        JP SET_OXYGEN_STATUS            ;

SET_OXYGEN_TO_BAD:
                        LD A,14                         ; Message 14 OXYGEN LOW
                        CALL GET_MESSAGE_POINTER        ; Get message into HL
                        LD HL,BAD                       ;
                        JP SET_OXYGEN_STATUS            ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get Sheilds status from meter store and set text to Good,OK,Bad
SET_SHEILDS:

                        LD A,(SHIELDS_METER_STORE)      ;
                        CP 10                           ;   Shields between 10 and 13 is good
                        JP NC,SET_SHEILDS_TO_GOOD       ;
                        CP 5                            ;   Shields between 5 and 10 is ok
                        JP NC,SET_SHEILDS_TO_OK         ;
                        CP 2                            ;   Shields less than 2 is bad
                        JP C,SET_SHEILDS_TO_BAD         ;
                        RET                             ;

SET_SHEILDS_STATUS:
; HL=TEXT STRING
                        LD DE,SHEILDS_DATA              ;
                        JP SET_POWER_STATUS_LOOPA       ; Jump to set status text


                        ;   LD B,4                          ;
; SET_SHEILDS_LOOP:
                        ;                       LD A,(HL)                       ;
                        ;                       LD (DE),A                       ;
                        ;                       INC DE                          ;
                        ;                       INC HL                          ;
                        ;                       DJNZ SET_SHEILDS_LOOP           ;
                        ;                       RET                             ;

SET_SHEILDS_TO_GOOD:
                        LD HL,GOOD                      ;
                        JP SET_SHEILDS_STATUS           ;

SET_SHEILDS_TO_OK:
                        LD HL,OK                        ;
                        JP SET_SHEILDS_STATUS           ;

SET_SHEILDS_TO_BAD:
                        LD HL,BAD                       ;
                        JP SET_SHEILDS_STATUS           ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Game over
GAME_OVER:
                        ; LD A,31                         ; Message 31 Ship unable to support life MESSAGE
                        ; CALL GET_MESSAGE_POINTER        ; Get message into HL
                        XOR A                           ; Reset game over flag
                        LD (SET_GAME_OVER),A            ; Update Game Over attribute

                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL SCREEN_WIPE_6              ;

                        JP GO                           ; Jump back to abort mission
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


RESET_METERS:           ;Reset all meters back to normal;

                        LD A,96                         ; Black ink on bright green paper
                        ;    LD HL,GUN_STATUS_COLOUR         ;
                        ;    LD (HL),A                       ;
                        ;    LD DE,GUN_STATUS_COLOUR+1       ;
                        ;    LD BC,5                         ;
                        ;   LDIR                            ;


                        LD (GUN_STATUS_COLOUR),A        ; Diagram gun status colour
                        LD (ENGINE_STATUS_COLOUR),A     ; Diagram engine status colour
                        LD (WATER_STATUS_COLOUR),A      ; Diagram water status colour
                        LD (FOOD_STATUS_COLOUR),A       ; Diagram food status colour
                        LD (COCKPIT_STATUS_COLOUR),A    ; Diagram cockpit status colour
                        LD (FUEL_STATUS_COLOUR),A       ; Diagram fuel status colour

                        CALL SET_COCKPIT_STATUS         ; Set Cockpit status

                        LD A,100                        ;
                        LD (ENGINE_STATUS),A            ;
                        LD (WATER_STATUS),A             ;
                        LD (OXYGEN),A                   ;
                        LD (FUEL),A                     ;
                        LD (FOOD),A                     ;

                        ;  LD B,5                          ;
; SET_STATUS_LOOP:
                        ;  LD (HL),A                       ;
                        ;  INC HL                          ;
                        ;  DJNZ SET_STATUS_LOOP            ;

                        ; ENGINE_STATUS DB 0              ; 67                         ; Engine status 0 to 100%
                        ;  WATER_STATUS:           DB 0                            ; 68                         ; Stores water status 0 to 100%
                        ;  OXYGEN:                 DB 0                            ; 69                         ; Oxygen status ;0-good, 1-OK, 2-bad
                        ;  FUEL:                   DB 0                            ; 70                         ; Fuel percentage (XARGON-3)
                        ;  FOOD:                   DB 0                            ; 71                         ; Food status

                        ;   LD (ENGINE_STATUS),A            ; Initialise Engine status
                        ;   LD (WATER_STATUS),A             ;
                        ;   LD (FOOD),A                     ;
                        ;   LD (OXYGEN),A                   ; Initialise OXYGEN status
                        ; LD (WATER_STATUS),A             ; Initialise water status
                        ; LD A,1
                        ;   LD (FOOD),A                     ; Initialise food status
                        ;  LD (WATER_STATUS),A             ; Initialise water status



                        CALL SET_ENGINE                 ; Set engine status
                        CALL SET_OXYGEN                 ; Set OXYGEN status
                        CALL SET_WATER_STATUS           ; Set water status
                        CALL SET_FOOD_STATUS            ; Set food status
                        ; ld a,2                          ;
                        ; LD (FUEL),A                     ; Initialise FUEL status

                        CALL SET_FUEL                   ; Set FUEL status


                        LD A,11                         ;
                        LD (SHIELDS_METER_STORE),A      ;
                        LD (LASER_METER_STORE),A        ;
                        LD (POWER_STATUS),A             ;
                        CALL SET_POWER_STATUS           ; Set POWER status


                        LD A,32                         ;
                        LD (TEMPERATURE),A              ;
                        CALL SET_TEMPERATURE            ;

                        XOR A                           ;

RESET_METERS_LOOP:
                        INC A                           ;
                        LD (LASER_METER_STORE),A        ;
                        LD (SHIELDS_METER_STORE),A      ;
                        LD (POWER_STATUS),A             ;

                        PUSH AF                         ;
                        ;
                        CALL SET_SHIELDS_METER          ;
                        CALL SET_LASER_METER            ;                    ;
                        CALL SET_POWER_METER            ;
                        POP AF                          ;

                        CP 11                           ; 13 fills the meter
                        JR Z,RESET_WARNINGS             ;


                        LD BC,9000                      ;
                        CALL DELAY1LOOP                 ;

                        JR RESET_METERS_LOOP            ;
; Switch Warnings off
RESET_WARNINGS:

                        CALL SWITCH_WARNING_OFF         ; Set warning off
                        CALL SWITCH_SERVICE_OFF         ; Switch Service warning off

                        LD A,1                          ; Blue on black
                        LD (WARNING_ON),A               ; Set warning LED to off 66=on
                        LD (SERVICE_ON),A               ; Set service LED to off 66=on

                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL WARNING_OFF_ON_3           ; Set colour for warning LED
                        CALL SERVICE_OFF_ON             ; Set colour for service LED

                        RET                             ;

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Shields meter:  (SHIELDS_METER_STORE 0 to 13)   OPTIMIZED
SET_SHIELDS_METER:

                        CALL SET_SHEILDS                ;

                        LD A,(SYSTEM_TEST)              ; If system testing then skip messages
                        CP 1                            ;
                        JR Z,SKIP_ENABLE_WARNING_METER4 ;

                        LD A,(SHIELDS_METER_STORE)      ; Get Laser meter store
                        CP 5                            ;
                        JR NC,SKIP_ENABLE_WARNING_METER2;

                        LD A,8                          ; Set message for Sheilds critical
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        CALL SWITCH_WARNING_ON          ; Set warning on
                        JP SKIP_ENABLE_WARNING_METER4   ;

SKIP_ENABLE_WARNING_METER2:

                        CP 11                           ;
                        JR NZ,SKIP_ENABLE_WARNING_METER4;
                        LD A,27                         ; Set message for All systems OK
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

SKIP_ENABLE_WARNING_METER4:

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD A,(SHIELDS_METER_STORE)      ; Get Sheilds meter store
                        CALL BARS_SETUP_4               ; Setup data for bars

                        LD HL,20636-8+256               ; next line is 20636
                        CALL DISPLAY_METER_BARS_4       ; Display bars in meters

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set laser meter:  (LASER_METER_STORE 0 to 13)   OPTIMIZED
SET_LASER_METER:
                        LD A,96                         ; Set diagram warning to black on light green
                        LD (GUN_STATUS_COLOUR),A        ; Set Diagram gun status colour

                        LD A,(LASER_METER_STORE)        ; Get Laser meter store
                        CP 5                            ; Is it 5?
                        JP NC,SKIP_ENABLE_WARNING_METER1; If greater than 5 then skip setting warning

                        LD A,(SYSTEM_TEST)              ; Get system testing status
                        CP 1                            ; Is it on?
                        JP Z,SKIP_ENABLE_WARNING_METER1 ; If system testing then skip messages

                        LD A,10                         ; Set message Rockets Low
                        CALL GET_MESSAGE_POINTER        ; Get message into HL

                        LD A,80                         ; Set diagram warning to black on light RED
                        LD (GUN_STATUS_COLOUR),A        ;

                        CALL SWITCH_WARNING_ON          ; Set warning on

SKIP_ENABLE_WARNING_METER1:

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD A,(LASER_METER_STORE)        ; Get Laser meter store
                        CALL BARS_SETUP_4               ; Setup data for bars

                        LD HL,20572-8+256               ; next line is 20828
                        CALL DISPLAY_METER_BARS_4       ; Display bars in meters
                        RET                             ; Return;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set POWER meter:  (POWER_STATUS 0 to 13)
SET_POWER_METER:
                        CALL SET_POWER_STATUS           ; Update Services menu

                        LD A,(POWER_STATUS)             ; Get Laser meter store
                        CP 5                            ;
                        JP NC,SKIP_ENABLE_WARNING_METER3;

                        LD A,(SYSTEM_TEST)              ; If system testing then skip messages
                        CP 1                            ;
                        JP Z,SKIP_ENABLE_WARNING_METER3 ;

                        CALL SWITCH_WARNING_ON          ; Set warning on

SKIP_ENABLE_WARNING_METER3:

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD A,(POWER_STATUS)             ; Get Power meter store
                        CALL BARS_SETUP_4               ; Setup data for bars

                        LD HL,20700-8+256               ; Next line is 20700
                        CALL DISPLAY_METER_BARS_4       ; Display bars in meters

                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHOW_LARGE_ALIEN_TORPEDO_1:
                        PUSH IX                         ;
                        LD IX,LARGE_ALIEN_TORPEDO1_4    ;
                        LD A,R                          ;
                        AND 32                          ;
                        ADD A,20*8                      ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864;
                        LD DE,6                         ;
                        LD A,R                          ;
                        AND 7                           ;
                        ADD A,E                         ;
                        LD E,A                          ;

                        ADD HL,DE                       ; Move sites to screen center

                        ; IX=GRAPHIC
                        ; HL=SCREEN ADDRESS
                        LD A,12                         ; Get collumns
                        LD C,A                          ;
                        LD A,5                          ; Get rows

                        CALL DISPLAY_LARGE_GRAPHIC_LOOP3 ; Display large graphic
                        POP IX                          ;


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SHOW_LARGE_ALIEN_TORPEDO_2:

                        PUSH IX                         ;
                        LD IX,LARGE_ALIEN_TORPEDO2_4    ; Torpedo graphics data
DLL:
                        LD A,R                          ;
                        AND 32                          ;
                        ADD A,20*8                      ;
                        CALL GET_SCREEN_BUFFER_ADDRESS_c29864;
                        LD DE,3                         ;
                        LD A,R                          ;
                        AND 7                           ;
                        ADD A,E                         ;
                        LD E,A                          ;
                        ADD HL,DE                       ; Move sites to screen center

                        ; IX=GRAPHIC
                        ; HL=SCREEN ADDRESS
                        LD A,19                         ; Get collumns
                        LD C,A                          ;
                        LD A,7                          ; Get rows

                        CALL DISPLAY_LARGE_GRAPHIC_LOOP3 ; Display large graphic
                        POP IX                          ;


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ALIEN_SHIP_1_ENABLED:                     DB 0     ;Alien ship 1 enabled
; ALIEN_SHIP_1_DISTANCE:                    DB 0     ;Alien ship 1 distance 1 to 4
; ALIEN_SHIP_1_UP_DOWN:                     DB 40     ;Alien ship 1 up/down coordinate
; ALIEN_SHIP_1_LEFY_RIGHT:                  DB 40     ;Alien ship 1 left/right coordinate
; ALIEN_TORPEDO_COUNTER_1:   (4)               DB 0      ;Used to store frame
; ALIEN_TORPEDO_UP_DOWN:     (5)               DB 0      ;Alien torpedo up/down coordinate
; ALIEN_TORPEDO_SIZE:        (6)               DB 0      ;Alien torpedo size, 4 for 4x4
; ALIEN_TORPEDO_WIDTH:       (7)               DB 0      ;Alien torpedo width 4=4 COLLUMNS
; ALIEN_TORPEDO_FIRE_ENABLED:(8)               DB 0      ;Set to 1 when alien is firing
; ALIEN_TORPEDO_LEFT/RIGHT  :(9)               DB 0      ;Set Alien torpedo left/right coordinate
; ALIEN_SHIP_1_SEQUENCE:     (10)                 DB 0      ;Sequence number denotes how the ship acts

; Display alien torpedo
DISPLAY_ALIEN_TORPEDO:
                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        LD D,0                          ;
                        INC (IX+4)                      ; Add 1 to current alien torpedo frame counter
                        LD A,(IX+4)                     ; Get current alien torpedo frame counter

                        CP 12                           ;
                        CALL Z,SHOW_LARGE_ALIEN_TORPEDO_1;
                        CP 13                           ;
                        CALL Z,SHOW_LARGE_ALIEN_TORPEDO_2;


                        CP 14                           ; Is it 17?
                        JP NC,RESET_ALIEN_TORPEDO       ; If so then reset current alien torpedo


                        LD HL,ALIEN_TORPEDO_GRAPHICS_4  ; Get alien graphic table from memory 4

                        OR A                            ;
                        JR Z,NEXT_ALIEN_TORPEDO         ;

                        LD B,A                          ;
                        LD DE,64                        ;
TORPEDO_SELECT_LOOP:

                        ADD HL,DE                       ; Add addition to HL to move along table
                        DJNZ TORPEDO_SELECT_LOOP        ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jumps here after setting the current alien torpedo coordinates and graphic
NEXT_ALIEN_TORPEDO:

; Move torpedo up/down
; LD A,(IX+5)    ;Update current alien torpedo up/down
; ADD A,8
; LD (IX+5),A



SKIP_ALLIGNING_DOUBLE_ALIEN_TORPEDO_GRAPHIC:
                        PUSH HL                         ;
                        LD A,(IX+9)                     ; Get torpedo X coordinate
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(IX+5)                     ; Get torpedo Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        LD A,1                          ; OR SPRITE
                        LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite
                        POP HL                          ;
                        LD DE,32                        ; Move to next sprite data
                        ADD HL,DE                       ;

                        LD A,(IX+9)                     ; Get torpedo X coordinate
                        ADD A,16                        ;
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,(IX+5)                     ; Get torpedo Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate
                        ;  LD A,1                          ; OR SPRITE
                        ;  LD (MERGE_SPRITE+1),A           ;
                        CALL sprite                     ; Display sprite

SKIP_DISPLAYING_DOUBLE_ALIEN_TORPEDO_GRAPHIC:

                        ; INC (IX+9)  ;Allign alien torpedo as it gets bigger

                        INC (IX+5)                      ; Move torpedo down 1 pixel
                        INC (IX+5)                      ; Move torpedo down 1 pixel

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ALIEN_SHIP_1_ENABLED:       (0)              DB 0     ;Alien ship 1 enabled
; ALIEN_SHIP_1_DISTANCE:      (1)              DB 0     ;Alien ship 1 distance 1 to 4
; ALIEN_SHIP_1_UP_DOWN:       (2)              DB 40     ;Alien ship 1 up/down coordinate
; ALIEN_SHIP_1_LEFY_RIGHT:   (3)               DB 40     ;Alien ship 1 left/right coordinate
; ALIEN_TORPEDO_COUNTER_1:   (4)               DB 0      ;Used to store frame
; ALIEN_TORPEDO_UP_DOWN:     (5)               DB 0      ;Alien torpedo up/down coordinate
; ALIEN_TORPEDO_SIZE:        (6)               DB 0      ;Alien torpedo size, 4 for 4x4
; ALIEN_TORPEDO_WIDTH:       (7)               DB 0      ;Alien torpedo width 4=4 COLLUMNS
; ALIEN_TORPEDO_FIRE_ENABLED:(8)               DB 0      ;Set to 1 when alien is firing
; ALIEN_TORPEDO_LEFT/RIGHT  :(9)               DB 0      ;Set Alien torpedo left/right coordinate
; ALIEN_SHIP_1_SEQUENCE:     (10)                 DB 0      ;Sequence number denotes how the ship acts 255 for freeze on sites
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Who fired first?
CHECK_WHO_FIRED_FIRST:
                        LD HL,WHO_FIRED_FIRST           ; Get Who fired first 1 if you fired first or 2 if alien fired first
                        LD A,(HL)                       ;
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_WHO_FIRED_FIRSTB     ; If not then jump the fired first checks as already set

; Set to 1 if you fired first or 2 if alien fired first
                        LD A,(ALIEN_FIRED)              ; Get Alien fired status
                        OR A                            ; Is it 0?
                        JR NZ,SKIP_SETTING_YOU_FIRED_FIRSTB ; If not then Alien fired first so skip setting you fired first
                        LD A,1                          ;
                        LD (HL),A                       ; Set who fired first to 1 for you firing first
                        JP SKIP_WHO_FIRED_FIRSTB        ;

SKIP_SETTING_YOU_FIRED_FIRSTB:
                        LD A,2                          ;
                        LD (HL),A                       ; Set who fired first to 2 for Alien firing first
SKIP_WHO_FIRED_FIRSTB:
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Enable current alien torpedo
ENABLE_CURRENT_ALIEN_TORPEDO:
                        CALL CHECK_WHO_FIRED_FIRST      ; Check who fired first
                        LD A,1                          ; Set Alien has fired flag to 1
                        LD A,(ALIEN_FIRED)              ; Set Alien has fired flag

                        LD (IX+8),1                     ; Enable current alien torpedo

                        LD A,(IX+2)                     ; Initialise up/down
                        ADD A,8                         ; Torpedo starts under alien ship
                        LD (IX+5),A                     ;

                        LD A,(IX+3)                     ; Initialise left/right
                        ;  ADD A,8                         ; Torpedo starts in the centre of alien ship
                        LD (IX+9),A                     ;

                        LD (IX+4),0                     ; Reset torpedo counter

                        LD HL,ALIEN_TORPEDO_SOUND_3D    ;
                        CALL GENERAL_SOUND              ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Flash the screen if hit by alien torpedo and reduce sheilds
FLASH_SCREEN_REDUCE_SHIELDS:
                        CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL FLASH_PLAY_AREA_WHITE_3    ;

                        CALL SET_WE_ARE_HIT_STATUSES_3  ;
                        LD BC,5000                      ;
                        CALL DELAY1LOOP                 ;


                        ; CALL FLASH_PLAY_AREA_BLACK_3    ;
                        CALL HIT_BY_TORPEDO_COLOUR_CHANGE;

                        LD A,(SHIELDS_ON)               ; Get Shields on/off
                        OR A                            ; Are shields off?
                        JR NZ,SKIP_SET_GAME_OVER_SHIELDS_OFF ; If on then skip reducing cockpit
                        LD HL,WE_ARE_HIT                ;
                        INC (HL)                        ;
                        ; INC (HL)                        ;
                        ; CALL MEMORY_SWITCH_3            ; Memory switch 3
                        CALL DECREASE_SHIELDS           ;
                        RET                             ;

SKIP_SET_GAME_OVER_SHIELDS_OFF:

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Switch off torpedo
RESET_ALIEN_TORPEDO:
                        LD (IX+8),0                     ; A    ;Disable current alien fire
                        LD (IX+4),0                     ; A    ;Reset current alien torpedo frame counter
                        CALL FLASH_SCREEN_REDUCE_SHIELDS;

                        LD HL,BACKGROUND_SOUND_DATA     ; Set background sound after fire sound
                        CALL GENERAL_SOUND              ; Get back to background sound
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Snow on text screen  - Interference
SNOW_TEXT_SCREEN:
                        XOR A                           ; Do not skip increment to create interference
                        LD (SKIP_INCREMENT),A           ;

                        LD HL,20000                     ; ROM graphic snow data
                        LD A,R                          ;
DISPLAY_SNOW_TEXT_LOOP3:
                        INC HL                          ;
                        DEC A                           ;
                        JR NZ,DISPLAY_SNOW_TEXT_LOOP3   ;

FILL_TEXT_SCREEN:

                        LD B,64-16                      ; 64 Hires lines
DISPLAY_SNOW_TEXT_LOOP2:;Lines loop                     ;
                        PUSH BC                         ;

                        LD A,B                          ;
                        ADD A,134                       ; Move down to bottom of screen

                        CALL GET_SCREEN_ADDRESS_c29864DE ; Get screen address into DE
; DE=SCREEN ADDRESS
                        PUSH HL                         ;
                        EX DE,HL                        ;
                        LD DE,1                         ; 9                         ; Start 1 collumns across
                        ADD HL,DE                       ;
                        EX DE,HL                        ;
                        POP HL                          ;
                        LD B,14                         ; 14 collumns to place data onto
DISPLAY_SNOW_TEXT_LOOP1:
                        LD A,(HL)                       ;
                        LD (DE),A                       ; Place data to hires line on screen

                        LD A,(SKIP_INCREMENT)           ; Get skip increment status
                        OR A                            ; Should we skip increment?
                        JR NZ,SKIP_INCREMENT_DATA       ; Yes if not 0.
                        INC HL                          ; Move to next graphics data
SKIP_INCREMENT_DATA:
                        INC E                           ; Move to next collumn
                        DJNZ DISPLAY_SNOW_TEXT_LOOP1    ;

                        POP BC                          ; Take 1 from lines loop
                        DJNZ DISPLAY_SNOW_TEXT_LOOP2    ; Jump back for all64 lines

                        RET                             ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; SOME SPARE

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Service menu text data   At address  47616
                        ALIGN 256                       ;                                           ;
SERVICE_MENU_DATA1:
                        ; Length=252  9x28 COLLUMNS
                        DEFM "    [SERVICES INFORMATION]    ";  30
                        DEFM "TOTAL HD       : d"       ;
HD_DATA:                DEFM "1000000   "               ;   47-FUEL START   56 END 58  28
                        DEFM "REPUTATION     : "        ;
REPUTATION_DATA:        DEFM "GOOD       "              ; 86
                        DEFM "XARGON-3       :$"        ;
FUEL_DATA:              DEFM "000%       "              ; 106 END OF DATA   114
                        DEFM "SHIELDS        : "        ;
SHEILDS_DATA:           DEFM "GOOD       "              ;  142
                        DEFM "ENGINE STATUS  : "        ;
ENGINE_DATA:            DEFM "GOOD       "              ; 170
                        DEFM "TEMPERATURE    : $"       ;
TEMPERATURE_DATA:       DEFM "000 wC    "               ; 198
                        DEFM "POWER STATUS   : "        ;
POWER_DATA:             DEFM "GOOD       "              ; 226
                        DEFM "OXYGEN         : "        ;
OXYGEN_DATA:            DEFM "GOOD       "              ; 254
                        DEFB 0                          ; END  255
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; NOP                             ; Get to next 256K block
                        ; noflow                          ;
                        ALIGN 256                       ;
SERVICE_MENU_DATA2:     ; Length=84                     ;
                        DEFM "   WATER       : "        ; 17
WATER_DATA:             DEFM "GOOD       "              ; 11
                        DEFM "   FOOD        : "        ; 17
FOOD_DATA:              DEFM "GOOD       "              ; 11
                        DEFM "   COCKPIT     : "        ; 17
COCKPIT_DATA:           DEFM "GOOD       "              ; 11
                        DEFB 0                          ; END   ; 85

                        DEFB 255                        ; 86

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIEN_SHIP_DATA_TABLE:
                        DW ALIEN_SHIP_1A_3              ;
                        DB 32,2                         ;

                        DW ALIEN_SHIP_1A_B_3            ;
                        DB 32,4                         ;

                        DW ALIEN_SHIP_1A_C_3            ;
                        DB 64,8                         ;

                        DW ALIEN_SHIP_2A_3              ;
                        DB 64,8                         ;

                        DW ALIEN_SHIP_2A_A_3            ;
                        DB 96,16                        ;

                        DW ALIEN_SHIP_2C_A_3            ;
                        DB 96,20                        ;

                        DW ALIEN_SHIP_3A_3              ;
                        DB 96,24                        ;    28
                        ; 148

; -------------------------------------------------------------------------------------------------
PROGRESS:               DB 0                            ; Progress counter
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Vars go here
VARABLES:


KEMPSTON:               DB 0                            ; 1             ; Set to 1 if Kempston exists
; Initialies to zero
SCROLL_COUNT:           DB 0                            ; 2             ; Counts down from 8 to scroll. 0=no scroll
TRADING_KEYS_ENABLED:   DB 0                            ; 3             ; 1=Alien trading keys on . 0 for off
FIRE_HAS_BEEN_DONE:     DB 0                            ; 4                ; Set to 1 when fire was used.
REPUTATION:             DB 0                            ; 5              ; 100%
ALIEN_FIRED:            DB 0                            ; 6            ; Set to 1 when alien fires
WHO_FIRED_FIRST:        DB 0                            ; 7          ; Set to 1 if you fired first or 2 if alien fired first
; Initialies to zero
SPEEDMAX:               DB 0                            ; 8      ; Used to store speed countdown
FIRE_ON:                DB 0                            ; 9    ; Set to 1 when fire is on
GAME_MODE:              DB 0                            ; 10                 ; 0 for normal or 1 for side scroller
ABORT_ENABLED:          DB 0                            ; 11                 ;
SNOW_TEXT_SCREEN_ON:    DB 0                            ; 12               ; Set to 1 to enable interference on text display
ALARM_SOUND_MUTE:       DB 0                            ; 13             ; Set to 1 when muted
PLANET_LANDING_MODE:    DB 0                            ; 14              ; 0 for confrontation. 1 for landing
SYSTEM_RESET:           DB 0                            ; 15               ; Counts down to 0 when reset pressed
SET_WARNING_ON:         DB 0                            ; 16               ; Used to set warning on/off 1=on
WARNING_DELAY_COUNTER:  DB 0                            ; 17                ; Used to time warning flasher
OXYGEN_LEAK:            DB 0                            ; 18               ; Set to 1 when leaking
WE_ARE_HIT:             DB 0                            ; 19                ; Hit counter
COUNTER:                DB 0                            ; 20                 ; Used to count in a loop 0 to 255
UP_DOWN_TEMP:           DB 0                            ; 21                  ; Used to move side scrolling aliens up/down
CURRENT_SECTOR_VALUE:   DB 0                            ; 22                  ; Sector value selected on radar
SECTOR_VALUE_MEMORY     DB 0                            ; 23                   ; Used to memorise the sector value to reset radar after radar move timer has hit 1
PLANET_SIDE_SCROLLER_TAKEOFF_COUNTER:DB 0               ; 24              ; Used to set the takeoff process for taking off from side scroller
POWER_STATUS:           DB 0                            ; 25              ; POWER_STATUS Status ;0-good, 1-OK, 2-bad
ALIEN_ENCOUNTER_SEQUENCE:DB 0                           ; 26               ; Counts up with game counter when aliens are encountered
BUY_SELL:               DB 0                            ; 27                ; Set to 0 for no trading, 1 for buy and 2 for sell
DRAW_RING_ON:           DB 0                            ; 28                  ; Stores ring draw status
SCROLL_SHOW_BARS_ON:    DB 0                            ; 29                   ; Set to 1 for charge bars moving
DOUBLE_HEIGHT_TEXT:     DB 0                            ; 30                   ; Double height text flag    1=Double height
POWER_FULL_LOCK:        DB 0                            ; 31                   ; Stores Power Full lock (No power full message when set)
ITEM_SELLING_TO_ALIEN:  DB 0                            ; 32                   ; Item selling to alien
INTERESTED_IN_QTY:      DB 0                            ; 33                   ; Stores current alien interested in qty
OFFER_HD_QTY:           DB 0                            ; 34                  ; Stores current alien offering amount of HD per unit
WE_ARE_HIT_COUNTDOWN:   DB 0                            ; 35                  ; Stores we are hit countdown
LOGO_PROGRESS:          DB 0,0                          ; 36 37                   ; Used to store last logo data pointer
LOGO_MODE:              DB 0                            ; 38                    ; 0=NORMAL, 1= EXPLODE
ALIEN_TRACK_LOCK_TIMER: DB 0                            ; 39                    ; Alien track lock timer
LAST_SPEED_MESSAGE:     DB 0                            ; 40                    ; Stores last speed
ALIEN_NUMBER:           DB 0                            ; 41                    ; Stores current alien number
BUY_SELL_MENU:          DB 0                            ; 42
SCROLLLINELEFTB_COUNTER DB 0                            ; 43                    ; Used to count down icon scroll in radar


; Initialies to 1
SYSTEM_TEST:            DB 0                            ; 44                     ; Enable/Disable system test
WARNING_ON:             DB 0                            ; 45                     ; Warning alarm on/off enable
UP_DOWN_COUNTER:        DB 0                            ; 46                      ; Used for moving sprites up/down
NASTY_FRAME_COUNT:      DB 0                            ; 47                      ; Counter for side scroller sprites frame
UP_DOWN_SETTING:        DB 0                            ; 48                     ; Used for sprite up/down
SITES_ON:               DB 0                            ; 49                     ; Used to store sites status
SERVICES_ON:            DB 0                            ; 50                     ; Used to store services status
SHIELDS_ON:             DB 0                            ; 51                      ;Shields on/off switch
SET_GAME_OVER:          DB 0                            ; 52                     ; Set to 1 when game is over
SPINING_ICON_COUNTER:   DB 0                            ; 53                     ; Used for the spining icon frame counter
SPINING_ICON_STATUS:    DB 0                            ; 54                     ; Spining icon 1 on 0 off

; Initialies to 5
SPEED:                  DB 0                            ; 55                         ; Used to store speed
RADAR_MOVE_TIMER:       DB 0                            ; 56                       ; Set to 250 when L key pressed to reset radar back to where it was if no Huperdrive is done
ALIEN_IS_FRIENDLY:      DB 0                            ; 57                       ; Set to 1 when alien is friendly 0 for unfriendly



; Initialies to 32
SP1X_SHIP:              DB 0                            ; 58                        ;
SP1Y_SHIP:              DB 0                            ; 59                         ;
TEMPERATURE:            DB 0                            ; 60                         ; Temperature

; Initialies to 96
GUN_STATUS_COLOUR:      DB 0                            ; 61                         ; Diagram gun status colour
ENGINE_STATUS_COLOUR:   DB 0                            ; 62                          ; Diagram engine status colour
WATER_STATUS_COLOUR:    DB 0                            ; 63                         ; Diagram water status colour
FOOD_STATUS_COLOUR:     DB 0                            ; 64                          ; Diagram food status colour
COCKPIT_STATUS_COLOUR:  DB 0                            ; 65                         ; Diagram cockpit status colour
FUEL_STATUS_COLOUR:     DB 0                            ; 66                         ; Diagram fuel (XARGON-3) status colour

; Initialies to 100
ENGINE_STATUS           DB 0                            ; 67                         ; Engine status 0 to 100%
WATER_STATUS:           DB 0                            ; 68                         ; Stores water status 0 to 100%
OXYGEN:                 DB 0                            ; 69                         ; Oxygen status ;0-good, 1-OK, 2-bad
FUEL:                   DB 0                            ; 70                         ; Fuel percentage (XARGON-3)
FOOD:                   DB 0                            ; 71                         ; Food status

; Initialies to other
LEVEL:                  DB 0                            ; 72                        ;
DIRECTION:              DB 0                            ; 73                        ; Set direction                                                            ;bits 0-up, 1-down, 2-left, 3-right

SET_SERVICE_ON:         DB 0                            ; 74                          ; Used to set SERVICE on/off 1=on
SERVICE_DELAY_COUNTER:  DB 0                            ; 75                          ; Used to time warning flasher

FIRE1Y:                 DB 0                            ; 76                      ; 3D fire Y coordinate
SPACESHIPUDG:           DB 0,0                          ; 77 78                      ; UNUSED
ONE_TWO_COUNTER:        DB 0                            ; 79                     ; Used to select UFO frame 0 or 1
SPACESHIP_DIRECTION_LEFT_RIGHT:DB 0                     ; 80                  ;
SPACESHIP_DIRECTION_UP_DOWN:DB 0                        ; 81                  ;
BULLET_ACROSS:          DB 0                            ; 82                  ;
SHIELDS_METER_STORE:    DB 0                            ; 83                   ;
LASER_METER_STORE       DB 0                            ; 84                    ;
TEXT_COLOUR_UNUSED:     DB 0                            ; 85                     ; Stores text colour UNUSED
NORMAL_LCD_COLOUR:      DB 0                            ; 86                     ; Normal LCD text colour
COUNTER2:               DB 0                            ; 87                     ; Used to count in a loop 255 to 0
COUNTER3:               DB 0                            ; 88                      ; Used as a temporary counter to count in a loop 255 to 0
COUNTER4:               DB 0                            ; 89                      ; Used as a temporary counter to count in a loop 255 to 0
ROCKET_DROP_COUNTER:    DB 0                            ; 90                      ; When at 0 then the rocket reduces count by 1
ERROR_SELECT:           DB 0                            ; 91                      ; Set at start of game for 1 of 4 messages
ALIENS_APPEAR_COUNTER:  DB 0                            ; 92                      ; Set to random number when going to new sector and counts down to 0 then aliens appear
SKIP_INCREMENT:         DB 0                            ; 93                       ; 0 - Do not skip Increment memory pointer, 1 - Skip Increment
LED_STATUS_SCREEN:      DB 0                            ; 94                      ; Set to 1 for LED status screen on

ASKING_QTY_FIGURE:      DB 0                            ; 95
ASKING_HD_FIGURE:       DB 0                            ; 96
BUYING_FROM_ALIEN_ITEM: DB 0                            ; 97
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SPEED_SAVE:             DB 0                            ; Used to store the current speed before hyperdrive
SPEEDMAX_SAVE:          DB 0                            ; Used to store the current speed max before hyperdrive
HYPERDRIVE:             DB 0                            ; Hyperdrive is enabled if value is greater than 0
ICON_COUNTER:           DB 0                            ; Add 1 to this every time the cursor is moved
TEMP_MOVE_STORE:        DB 0                            ;
CPU_ATTR:               DB 0                            ; CPU ATTR store

; SPACESHIPFRAME:                           DB 0     ;Spaceship frame
; Alien ship varables

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ALIEN_TORPEDO_NUMBER:  DB 0    ;Used to count alien firing
; ALIEN_TORPEDO_COUNTER: DB 0  ;Used to store frame
; ALIEN_TORPEDO_UP_DOWN: DB 0
; ALIEN_TORPEDO_SIZE:    DB 0 ;4 for 4x4
; ALIEN_TORPEDO_WIDTH:   DB 0 ;4=4 COLLUMNS
; ALIEN_TORPEDO_FIRE_ENABLED:(8)               DB 0      ;Set to 1 when alien is firing
; ALIEN_TORPEDO_LEFT/RIGHT  :(9)               DB 0      ;Set Alien torpedo left/right coordinate
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



ALIEN_SHIP_1_ENABLED:   DB 0                            ; Alien ship 1 enabled
ALIEN_SHIP_1_DISTANCE:  DB 0                            ; Alien ship 1 distance 1 to 4
ALIEN_SHIP_1_UP_DOWN:   DB 40                           ; Alien ship 1 up/down coordinate
ALIEN_SHIP_1_LEFT_RIGHT:DB 40                           ; Alien ship 1 left/right coordinate
ALIEN_TORPEDO_COUNTER_1:DB 0                            ; Used to store frame
ALIEN_TORPEDO_UP_DOWN_1:DB 0                            ; Alien torpedo up/down coordinate
ALIEN_TORPEDO_SIZE_1:   DB 0                            ; Alien torpedo size, 4 for 4x4
ALIEN_TORPEDO_WIDTH_1:  DB 0                            ; Alien torpedo width 4=4 COLLUMNS
ALIEN_TORPEDO_FIRE_ENABLED_1:DB 0                       ; Set to 1 when alien is firing
ALIEN_TORPEDO_LEFT_RIGHT_1:DB 0                         ; Set Alien torpedo left/right coordinate
ALIEN_SHIP_1_SEQUENCE:  DB 0                            ; Sequence number denotes how the ship acts
ALIEN_SHIP_1_EXPLODE_COUNTER:DB 0                       ; Explode counter
                        DEFB 132,87,122,87,132,87,122,87;
                        DEFB 132,89,122,89,132,85,122,85;
                        DEFB 130,91,124,91,130,83,124,83;
                        DEFB 129,92,125,92,129,82,125,82;



ALIEN_SHIP_2_ENABLED:   DB 0                            ; Alien ship 2 enabled
ALIEN_SHIP_2_DISTANCE:  DB 1                            ; Alien ship 2 distance 1 to 4
ALIEN_SHIP_2_UP_DOWN:   DB 50                           ; Alien ship 2 up/down coordinate
ALIEN_SHIP_2_LEFT_RIGHT:DB 50                           ; Alien ship 2 left/right coordinate
ALIEN_TORPEDO_COUNTER_2:DB 0                            ; Used to store frame
ALIEN_TORPEDO_UP_DOWN_2:DB 0                            ; Alien torpedo up/down coordinate
ALIEN_TORPEDO_SIZE_2:   DB 0                            ; Alien torpedo size, 4 for 4x4
ALIEN_TORPEDO_WIDTH_2:  DB 0                            ; Alien torpedo width 4=4 COLLUMNS
ALIEN_TORPEDO_FIRE_ENABLED_2:DB 0                       ; Set to 1 when alien is firing
ALIEN_TORPEDO_LEFT_RIGHT_2:DB 0                         ; Set Alien torpedo left/right coordinate
ALIEN_SHIP_2_SEQUENCE:  DB 0                            ; Sequence number denotes how the ship acts
ALIEN_SHIP_2_EXPLODE_COUNTER:DB 0                       ; Explode counter

                        ALIGN 256                       ;

                        DEFB 132,87,122,87,132,87,122,87;
                        DEFB 132,89,122,89,132,85,122,85;
                        DEFB 130,91,124,91,130,83,124,83;
                        DEFB 129,92,125,92,129,82,125,82;  32






ALIEN_SHIP_3_ENABLED:   DB 0                            ; Alien ship 3 enabled
ALIEN_SHIP_3_DISTANCE:  DB 2                            ; Alien ship 3 distance 1 to 4
ALIEN_SHIP_3_UP_DOWN:   DB 60                           ; Alien ship 3 up/down coordinate
ALIEN_SHIP_3_LEFT_RIGHT:DB 60                           ; Alien ship 3 left/right coordinate
ALIEN_TORPEDO_COUNTER_3:DB 0                            ; Used to store frame
ALIEN_TORPEDO_UP_DOWN_3:DB 0                            ; Alien torpedo up/down coordinate
ALIEN_TORPEDO_SIZE_3:   DB 0                            ; Alien torpedo size, 4 for 4x4
ALIEN_TORPEDO_WIDTH_3:  DB 0                            ; Alien torpedo width 4=4 COLLUMNS
ALIEN_TORPEDO_FIRE_ENABLED_3:DB 0                       ; Set to 1 when alien is firing
ALIEN_TORPEDO_LEFT_RIGHT_3:DB 0                         ; Set Alien torpedo left/right coordinate
ALIEN_SHIP_3_SEQUENCE:  DB 0                            ; Sequence number denotes how the ship acts
ALIEN_SHIP_3_EXPLODE_COUNTER:DB 0                       ; Explode counter
                        DEFB 132,87,122,87,132,87,122,87;
                        DEFB 132,89,122,89,132,85,122,85;
                        DEFB 130,91,124,91,130,83,124,83;
                        DEFB 129,92,125,92,129,82,125,82;


ALIEN_SHIP_4_ENABLED:   DB 0                            ; Alien ship 4 enabled
ALIEN_SHIP_4_DISTANCE:  DB 3                            ; Alien ship 4 distance 1 to 4
ALIEN_SHIP_4_UP_DOWN:   DB 70                           ; Alien ship 4 up/down coordinate
ALIEN_SHIP_4_LEFT_RIGHT:DB 90                           ; Alien ship 4 left/right coordinate
ALIEN_TORPEDO_COUNTER_4:DB 0                            ; Used to store frame
ALIEN_TORPEDO_UP_DOWN_4:DB 0                            ; Alien torpedo up/down coordinate
ALIEN_TORPEDO_SIZE_4:   DB 0                            ; Alien torpedo size, 4 for 4x4
ALIEN_TORPEDO_WIDTH_4:  DB 0                            ; Alien torpedo width 4=4 COLLUMNS
ALIEN_TORPEDO_FIRE_ENABLED_4:DB 0                       ; Set to 1 when alien is firing
ALIEN_TORPEDO_LEFT_RIGHT_4:DB 0                         ; Set Alien torpedo left/right coordinate
ALIEN_SHIP_4_SEQUENCE:  DB 0                            ; Sequence number denotes how the ship acts
ALIEN_SHIP_4_EXPLODE_COUNTER:DB 0                       ; Explode counter
                        DEFB 132,87,122,87,132,87,122,87;
                        DEFB 132,89,122,89,132,85,122,85;
                        DEFB 130,91,124,91,130,83,124,83;
                        DEFB 129,92,125,92,129,82,125,82;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RESET_FIGURES:          DEFM "000"                      ; Used to reset figures data
RESET_FIGURES_HD:       DEFM "$  10000"                 ; Reset HD to 10000
RESET_FIGURES_100:      DEFM "100"                      ; Used to set percentage back to 100%
GOOD:                   DEFM "GOOD"                     ;
OK:                     DEFM "OK  "                     ;
BAD:                    DEFM "BAD "                     ;

MAP_SELECT_STORE_NUMBER_b30583:DB 0                     ; Used to store the current sector number

RADAR_SELECT_SECTOR_STORE:DB 0                          ; Used to count radar sector

TORPEDO_COUNTER:        DB 0                            ; Used to store frame
TORPEDO_UP_DOWN:        DB 0                            ;
TORPEDO_SIZE:           DB 0                            ; 4 for 4x4
TORPEDO_WIDTH:          DB 0                            ; 4=4 COLLUMNS


; CURRENT_SEQUENCE:       DB 0                            ; Current game squence   NOT USED!!!!!!!!!!
                        ; 0=Nothing
                        ; 1=Aliens appear from back to distance
; ALIEN_SEQUENCE_SELECTOR_COUNTER1:DB 0                   ; Alien 1 animation frame
; ALIEN_SEQUENCE_SELECTOR_COUNTER2:DB 0                   ; Alien 2 animation frame
; ALIEN_SEQUENCE_SELECTOR_COUNTER3:DB 0                   ; Alien 3 animation frame
; ALIEN_SEQUENCE_SELECTOR_COUNTER4:DB 0                   ; Alien 4 animation frame

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -------------------------------------------------------------------------------------------------

; -------------------------------------------------------------------------------------------------
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; CLEAR ROUTINES

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear screen
CLEAR_SCREEN_c26769:
                        ; LD HL,16384                     ; First address of Display file
                        ; LD DE,16385                     ; Second address of Display file
                        ; LD BC,4095                      ; Number of bytes to fill buffer
                        ; LD (HL),0                       ; Set screen address to blank
                        ; LDIR                            ; Fill screen memory
                        ;
                        ; RET


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear screen  BUFFER

CLEAR_SCREEN_BUFFER:
                        LD HL,SCREEN1                   ; First address of Display file
                        LD DE,SCREEN1+1                 ; Second address of Display file
PERFORM_LDIR:
                        LD BC,4095                      ; Number of bytes to fill buffer
                        LD (HL),0                       ; Set screen address to blank
                        LDIR                            ; Fill screen memory

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear screen buffer CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1 to set colour
CLEAR_SCREEN_ATTR_BUFFER:
                        LD HL,ATTR1                     ; HL=Start address
                        LD BC,511                       ;
CLEAR_SCREEN_ATTR_BUFFER_LOOP:
CLEAR_SCREEN_ATTR_BUFFER_COLOUR:LD (HL),7               ;  Address +1 to set colour
                        INC HL                          ;
                        DEC BC                          ;
                        LD A,B                          ;
                        OR C                            ;
                        JR NZ,CLEAR_SCREEN_ATTR_BUFFER_LOOP ;
                        RET                             ;                  ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear empty screen buffer
CLEAR_EMPTY_SCREEN_BUFFER:
                        LD HL,ATTR1_EMPTY               ; HL=Start address
                        LD DE,ATTR1_EMPTY+1             ;
                        LD BC,511                       ; 767 bytes fill the ATTR area
                        XOR A                           ;
                        LD (CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1),A;
                        JP CLEAR_SCREEN_ATTR_BUFFER_COLOUR;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear screen buffer
CLEAR_BUFFER:
                        LD HL,SCREEN1                   ;
                        LD DE,SCREEN1+1                 ;
                        LD BC,4095                      ; 4096 bytes fill the screen buffer
                        LD (HL),0                       ;
                        LDIR                            ; Fill memory
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear empty screen attr to white ink on black paper
CLEAR_EMPTY_BUFFER:

                        LD HL,SCREEN1_EMPTY             ;
                        LD DE,SCREEN1_EMPTY+1           ;
                        LD BC,4000                      ; 4096 bytes fill the ATTR area
                        LD (HL),0                       ;
                        LDIR                            ; Fill memory


                        LD DE,ATTR1_EMPTY+1             ; Get Screen start address store into HL
                        LD HL,ATTR1_EMPTY               ; DE=Start address
                        LD BC,511                       ; 512 bytes fill the ATTR area
                        LD A,7                          ;
                        LD (CLEAR_SCREEN_ATTR_BUFFER_COLOUR+1),A;
                        JP CLEAR_SCREEN_ATTR_BUFFER_COLOUR;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENABLE_MUSIC_INTERUPT:
                        ;  RET
                        DI                              ; Make sure no interrupts are called!
                        LD A,178                        ; Interupt table is at 45568
                        LD I,A                          ; Set Interupt
                        IM 2                            ; Interupt mode 2

                        ;   LD A,high INTERUPT_VECTOR_TABLE ; High byte address of vector table
                        ;   LD I,A                          ; Set I register to this
                        ;   IM 2                            ; Set Interrupt Mode 2
                        EI                              ; Enable interrupts again
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; when we are at a stage of finding Cygnus, sector becomes a planet
MAKE_CURRENT_SECTOR_PLANET:
                        CALL MEMORY_SWITCH_6            ; Memory switch 6
                        CALL DISABLE_ALL_ALIENS_6       ; Disable all aliens

                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL GET_SECTOR_TABLE_POINTER_c30613_4 ; Get address for flashing square into HL, A=Sector type
                        LD A,10                         ;
                        LD (HL),A                       ; Update current sector icon data

                        CALL DISPLAY_RADAR_ICONSB_4     ; Update radar
                        CALL SKIP_LOW_POWER             ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Shadow of screen address routine from ROM BC=screen coordinate HL returned with screen address
GET_SCREEN_ADDRESS_ROM:

                        LD A,191                        ; 175    ;Test that the y co-ordinate (in B) is not greater than 175.
                        SUB B                           ;

                        LD B,A                          ; B now contains 175 minus y.
                        AND A                           ; A holds b7b6b5b4b3b2b1b0, the bits of B.
                        RRA                             ; And now 0b7b6b5b4b3b2b1.
                        SCF                             ; Now 10b7b6b5b4b3b2.
                        RRA                             ;
                        AND A                           ; Now 010b7b6b5b4b3.
                        RRA                             ;
                        XOR B                           ; Finally 010b7b6b2b1b0, so that H becomes 64+8*INT(B/64)+(B mod 8), the high byte of the pixel address.
                        AND %11111000                   ;
                        XOR B                           ;
                        LD H,A                          ;
                        LD A,C                          ; C contains x.
                        RLCA                            ; A starts as c7c6c5c4c3c2c1c0 and becomes c4c3c2c1c0c7c6c5.
                        RLCA                            ;
                        RLCA                            ;
                        XOR B                           ; Now c4c3b5b4b3c7c6c5.
                        AND %11000111                   ;
                        XOR B                           ;
                        RLCA                            ; Finally b5b4b3c7c6c5c4c3, so that L becomes 32*INT((B mod 64)/8)+INT(x/8), the low byte.
                        RLCA                            ;
                        LD L,A                          ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Hyperdrive off
HYPERDRIVE_OFF:
                        LD A,4                          ;
                        LD (COUNTER4),A                 ; General 255 counter 4

                        LD A,(SPEED_SAVE)               ; Get saved speed
                        LD (SPEED),A                    ; Restore saved speed

                        LD A,(SPEEDMAX_SAVE)            ; Get saved speedmax
                        LD (SPEEDMAX),A                 ; Restore saved speedmax

                        XOR A                           ; A=0
                        ; LD (SPEEDMAX),A                 ; Counts up to speed. Then calls move stars
                        LD (HYPERDRIVE),A               ; Set hyperdrive timer to stop counting down

                        LD A,(RADAR_SELECT_SECTOR_STORE); Get sector store

                        LD (MAP_SELECT_STORE_NUMBER_b30583),A; Update current sector


                        CALL MEMORY_SWITCH_4            ; Memory switch 4
                        CALL UPDATE_SECTOR_VALUE_4      ; Switch to new sector
                        CALL ENABLE_ALIENS              ; Check to see if we need to enable aliens

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SPARE

                        ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DECREASE_SHIELDS:
                        LD HL,SHIELDS_METER_STORE       ; Get Shields status
                        LD A,(HL)                       ;
                        CP 1                            ; Is it 1 or less
                        RET Z                           ; Skip decrementing shields meter it it is already on 1
                        DEC (HL)                        ; Take 1 from shields

                        JP SET_SHIELDS_METER            ; Update the shields meter

                        ;  RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INCREASE_SHIELDS:
                        LD HL,SHIELDS_METER_STORE       ; Get Shields status
                        LD A,(HL)                       ;
                        CP 11                           ; Is it 1 or less
                        RET Z                           ; Skip decrementing shields meter it it is already on 1
                        INC (HL)                        ; Take 1 from shields

                        JP SET_SHIELDS_METER            ; Update the shields meter

                        ;  RET                             ; Return



Addre:                  equ *-1
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


      if *> 49151                                       ;
                        zeuserror "out of room"         ;
      endif                                             ;



; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INCLUDE "BANK1B.ASM"            ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INCLUDE "BANK3.ASM"             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INCLUDE "BANK4bb.ASM"           ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INCLUDE "BANK6.ASM"             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        INCLUDE "BANK0.ASM"             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        Zeus_PC=AppEntry                ; Start at Startaddress

                     import_bin "CygnusLOADINGSCREEN.scr",$4000;
                   ;     output_tap_auto "test3.tap","Test3","Test3";
                        output_tzx_auto "test3.tzx","Test3","Test3";

                    ;    output_tzx "Cygnus.tzx","Cygnus","Cygnus",Addrs,Addre-Addrs,3,Startaddress
                    ;    output_tzx_block "Cygnus.tzx",Addrs1,Addre1-Addrs1
                    ;    output_tzx_block "Cygnus.tzx",Addrs3,Addre3-Addrs3
                    ;    output_tzx_block "Cygnus.tzx",Addrs4,Addre4-Addrs4
                    ;    output_tzx_block "Cygnus.tzx",Addrs6,Addre6-Addrs6
                     ;   output_tzx_block "Cygnus.tzx",Addrs0,Addre0-Addrs0


                        output_z80 "Cygnus"+".z80"      ; Save a Z80 file
                        ;     output_szx "Cygnus"+".szx"      ; Save a szx file


                        END Init                        ;


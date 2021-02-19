; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; .______        ___      .__   __.  __  ___
; |   _  \      /   \     |  \ |  | |  |/  /
; |  |_)  |    /  ^  \    |   \|  | |  '  /        _
; |   _  <    /  /_\  \   |  . `  | |    <       / _ \
; |  |_)  |  /  _____  \  |  |\   | |  .  \     | (_) |
; |______/  /__/     \__\ |__| \__| |__|\__\     \___/



                        org 49152                       ; Build the code to run at $C000
                        dispto zeuspage(0)              ; But displace it
                     ;  dispto $10000
Addrs0:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Side scroller graphics
SHIPGRAPHICS_A_0:
                        DB 0, 0, 0, 0, 0, 124, 1, 254, 7, 229, 31, 250, 63, 253, 254, 254;
                        DB 255, 127, 63, 255, 5, 95, 10, 175, 5, 199, 0, 1, 0, 0, 0, 0;
SHIPGRAPHICS_B_0:
                        DB 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 252, 60, 127, 246, 255, 255;
                        DB 0, 126, 0, 0, 128, 0, 224, 0, 240, 0, 240, 0, 0, 0, 0, 0;



SHIPGRAPHICS_MASK_A_0:
                        DB 255, 255, 255, 143, 254, 3, 248, 1, 224, 0, 192, 0, 128, 0, 0, 0;
                        DB 0, 0, 0, 0, 192, 0, 192, 0, 240, 32, 240, 48, 255, 252, 255, 255;
SHIPGRAPHICS_MASK_B_0:
                        DB 255, 255, 255, 255, 255, 255, 255, 255, 3, 135, 0, 1, 0, 0, 0, 0;
                        DB 0, 0, 127, 131, 63, 255, 15, 255, 7, 255, 7, 255, 15, 255, 255, 255;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Side scroller graphics movement data

                        ; align 256                       ; Put these on page boundaries

SIDE_SCROLLING_SPRITE_DATA_SET_0:
                        ;  Acvive x  y Counter                0 - Normal left
                        ;    |   |  |  |   ------------------ Bit 1-left up/down, Bit 2-Falling
                        ;    |   |  |  |  |  -------Speed
                        ;    |   |  |  |  | | |Check colission 0-do nothing, 1-Alien so fire/check collision to be hit, 2-Fuel, 3-10HD, 4-100HD, 5-Rocket
                        ;    |   |  |  |  | | | ;--------------Missile x 0=disabled
                        DEFB 0, 28,247,10,2,8,1,0,0     ; ----Missile y
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien2
                        DEFB 0, 18,247,50,2,4,1,0,0     ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien3
                        DEFB 0, 32,247,100,2,2,1,0,0    ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien4
                        DEFB 0, 18, 247,200,2,2,1,0,0   ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Fuel
                        DEFB 0, 16, 247,150,1,1,2,0,0   ;
                        DEFW FUEL_GRAPHIC_0             ;
                        ; 10HD
                        DEFB 0, 24, 247,220,0,2,3,0,0   ;
                        DEFW TENHD_GRAPHIC_0            ;
                        ; 100HD
                        DEFB 0, 16, 247,120,0,1,4,0,0   ;
                        DEFW HUNDREDHD_GRAPHIC_0        ;
                        ; Rocket pickup
                        DEFB 0, 32, 247,180,1,2,5,0,0   ;
                        DEFW ROCKET_PICKUP_GRAPHIC_0    ;

                        ;  Acvive x  y Counter                0 - Normal left
                        ;    |   |  |  |   ------------------ Bit 1-left up/down, Bit 2-Falling
                        ;    |   |  |  |  |  -------Speed
                        ;    |   |  |  |  | | |Check colission 0-do nothing, 1-Alien so fire/check collision to be hit, 2-Fuel, 3-10HD, 4-100HD, 5-Rocket
                        ;    |   |  |  |  | | | ;--------------Missile x 0=disabled
                        DEFB 0, 22,247,20,2,4,1,0,0     ; ----Missile y
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien6
                        DEFB 0, 24,247,70,2,4,1,0,0     ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien7
                        DEFB 0, 28,247,220,2,2,1,0,0    ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien8
                        DEFB 0, 18, 247,230,2,2,1,0,0   ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien9
                        DEFB 0, 18, 247,235,2,2,1,0,0   ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien10
                        DEFB 0, 22, 247,245,2,2,1,0,0   ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien11
                        DEFB 0, 24, 247,38,2,2,1,0,0    ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)
                        ; Alien12
                        DEFB 0, 18, 247,56,2,2,1,0,0    ;
                        DEFW SIDE_SCROLLING_ALIEN_SHIP_A_0; ----Address of sprite data (2 frames)


                        DEFB 255                        ; 176 bytes
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Pickup items
FUEL_GRAPHIC_0:
defb 3, 192, 12, 240, 19, 248, 47, 252, 120, 30, 120, 30, 249, 255, 249, 255;
defb 248, 127, 248, 127, 121, 254, 121, 254, 57, 244, 31, 200, 15, 48, 3, 192;


TENHD_GRAPHIC_0:
defb 3, 192, 12, 240, 19, 248, 45, 156, 121, 110, 125, 110, 253, 111, 253, 159;
defb 255, 255, 237, 143, 97, 182, 109, 142, 63, 252, 31, 200, 15, 48, 3, 192;


HUNDREDHD_GRAPHIC_0:
defb 3, 192, 12, 240, 19, 248, 63, 252, 118, 238, 101, 86, 245, 87, 246, 239;
defb 255, 255, 237, 143, 97, 182, 109, 142, 63, 252, 31, 200, 15, 48, 3, 192;


ROCKET_PICKUP_GRAPHIC_0:
defb 3, 192, 12, 240, 51, 248, 47, 252, 120, 62, 120, 30, 249, 159, 249, 159;
defb 248, 63, 248, 63, 121, 158, 121, 158, 63, 252, 31, 200, 15, 48, 3, 192;



; Side scrolling Alien ship A AND B
                        ; ORG 57600
SIDE_SCROLLING_ALIEN_SHIP_A_0:


                        defb 3, 192, 6, 224, 5, 224, 13, 240;
                        defb 11, 240, 11, 240, 31, 248, 127, 254;
                        defb 238, 239, 255, 255, 127, 254, 8, 16;
                        defb 24, 24, 16, 8, 48, 12, 32, 4;


SIDE_SCROLLING_ALIEN_SHIP_B_0:


                        defb 3, 192, 6, 224, 5, 224, 13, 240;
                        defb 11, 240, 11, 240, 31, 248, 127, 254;
                        defb 187, 187, 255, 255, 127, 254, 8, 16;
                        defb 24, 24, 16, 8, 48, 12, 32, 4;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Side scroller exploding alien graphic

EXPLODE_ALIEN_GRAPHIC1_0:
                        DEFB 4,2,66,150,10,74,111,164   ;
                        DEFB 86,168,17,116,37,86,18,2   ;
                        DEFB 0,128,16,18,50,124,73,132  ;
                        DEFB 38,146,8,96,16,132,0,0     ;

EXPLODE_ALIEN_GRAPHIC2_0:

                        DEFB 0,0,2,0,10,80,1,32         ;
                        DEFB 22,224,9,136,17,208,2,36   ;
                        DEFB 37,1,0,128,0,0,0,0         ;
                        DEFB 0,4,34,56,17,64,22,172     ;




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        align 256                       ; Put these on page boundaries


SIDE_SCROLLING_SPRITE_DATA_0:DEFS 180                   ; bytes - 8 sprites X 25 bytes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_REPUTATION_0:

                        LD A,(REPUTATION)               ;
                        CP 4                            ; CP 0                            ;
                        JP C,SET_REPUTATION_TO_BAD_0    ;
                        CP 7                            ;
                        JP C,SET_REPUTATION_TO_OK_0     ;
                        CP 9                            ;
                        JP Z,SET_REPUTATION_TO_GOOD_0   ;
                        RET                             ;

SET_REPUTATION_STATUS_0:
; HL=TEXT STRING
                        LD DE,REPUTATION_DATA           ;
                        JP SET_POWER_STATUS_LOOPA_0     ; Jump to set status text

SET_REPUTATION_TO_GOOD_0:
                        LD HL,GOOD                      ;
                        JP SET_REPUTATION_STATUS_0      ;

SET_REPUTATION_TO_OK_0:
                        LD HL,OK                        ;
                        JP SET_REPUTATION_STATUS_0      ;

SET_REPUTATION_TO_BAD_0:
                        LD HL,BAD                       ;
                        JP SET_REPUTATION_STATUS_0      ;

                        RET                             ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_SOME_VARABLES_0:
                        XOR A                           ;
                        LD (AMBIENCE_SOUND1_DURATION),A ;
                        LD (MAP_SELECT_STORE_NUMBER_b30583),A ; Used to store the current sector number
                        LD (RADAR_SELECT_SECTOR_STORE),A ; Used to count radar sector
                        LD HL,TRADING_KEYS_ENABLED      ;
                        LD DE,TRADING_KEYS_ENABLED+1    ;
                        LD BC,39                        ;
                        LD (HL),A                       ;
                        LDIR                            ;

; Set game error
                        LD A,R                          ; Get random
                        AND 3                           ;
                        LD (ERROR_SELECT),A             ; Set game error for later when error is required


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

                        LD A,32                         ;
                        LD (SP1Y_SHIP),A                ;
                        LD (SP1X_SHIP),A                ;

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

                        XOR A                           ;
                        LD (SITES_ON),A                 ; Sites off
                        LD (LED_STATUS_SCREEN),A        ; Update Services on/off status
                        LD (ICON_COUNTER),A             ;
                        ;  LD (SHIELDS_ON),A               ; Reset Shields on
                        LD (ALARM_SOUND_MUTE),A         ; Start with alaerm mute off
                        LD (MESSAGE_STATUS),A           ; Reset message status
                        LD (SERVICES_ON),A              ; Set Services status to off
                        LD (PROGRESS),A                 ; Reset Progress




                        RET                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_POWER_STATUS_LOOPA_0:
                        LD B,4                          ;
SET_POWER_STATUS_LOOPX_0:
                        LD A,(HL)                       ;
                        CP 255                          ;
                        RET Z                           ;
                        LD (DE),A                       ;
                        INC DE                          ;
                        INC HL                          ;
                        ;  LD BC,4                         ; 4 characters to update
                        ; LDIR                            ;

                        DJNZ SET_POWER_STATUS_LOOPX_0   ;
                        RET                             ; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 if *> 62500                                     ;
                        zeuserror "out of room"         ;
        endif                                           ;








Addre0:                 equ *-1









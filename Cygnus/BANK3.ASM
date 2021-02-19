; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; .______        ___      .__   __.  __  ___     ____
; |   _  \      /   \     |  \ |  | |  |/  /    |___ \
; |  |_)  |    /  ^  \    |   \|  | |  '  /       __) |
; |   _  <    /  /_\  \   |  . `  | |    <       |__ <
; |  |_)  |  /  _____  \  |  |\   | |  .  \      ___) |
; |______/  /__/     \__\ |__| \__| |__|\__\    |____/
; ORG 58624
; 6 LINES BY 14 COLLUMNS

; ZeusAddr3:              equ $1C000

                        org 49152                       ; Build the code to run at $C000
                        dispto zeuspage(3)              ; But displace it so it goes in memory at $14000

                    ;  dispto $1C000
Addrs3:
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ; Blank message (Scroll 5 times to scroll off screen last message)
MESSAGE0:
                        DEFM "@"                        ;
                        DEFM "^"                        ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ; Message data for credits on start screen
MESSAGE0B:
                        DEFM "@"                        ;
                        DEFM "CODE@"                    ;
                        DEFM "STEVE BROAD@"             ;
                        DEFM "CONSULTANTS@"             ;
                        DEFM "BAZZA H@"                 ;
                        DEFM "VILLORDSUTCH@"            ; String end = code 94
                        DEFM "MUSIC@"                   ;
                        DEFM "DAVID@"                   ;
                        DEFM "SAPHIER@"                 ;
                        DEFM "PIXEL ART@"               ;
                        DEFM "ANDY@"                    ;
                        DEFM "GREEN  @"                 ;
                        DEFM "SPECIAL THANKS@"          ;
                        DEFM "SIMON BRATTEL@"           ;
                        DEFM "@@@@@"                    ; Scroll off
                        DEFM "^"                        ; 129



; LEVEL ONE     SELECTED      ALL SYSTEMS   OPERATIONAL
MESSAGE1:               DEFM "@"                        ;
                        DEFM "PROG: LEVEL 1@"           ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL.@"            ;
                        DEFM "POWER@"                   ;
                        DEFM "SET TO 5%@^"              ; 57


MESSAGE74:              ;Not allowed message (75)       ;
                        DEFM "@"                        ;
                        DEFM "FUNCTION@"                ;
                        DEFM "NOT ALLOWED@"             ;
                        DEFM "WHILE VIEWING@"           ;
                        DEFM "DATA@"                    ;
                        DEFM "^"                        ; 42   241


                        align 256                       ; Put these on page boundaries
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LEVEL TWO     SELECTED      ALL SYSTEMS   OPERATIONAL          34505

MESSAGE2:               DEFM "@"                        ;
                        DEFM "PROG: LEVEL 2@"           ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL.@"            ; 57
                        DEFM "POWER@"                   ;
                        DEFM "SET TO 5%@^"              ;


; DORBA BIOS V2.18 message
MESSAGE33:
                        DEFM "@"                        ;
                        DEFM "DORBA BIOS@"              ; 11 40
                        DEFM "V2.18@"                   ; 6
                        DEFM "SUB SYSTEMS@"             ; 12
                        DEFM "LOADED@^"                 ; 7  38


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; LEVEL THREE   SELECTED      ALL SYSTEMS   OPERATIONAL
MESSAGE3:               DEFM "@"                        ;
                        DEFM "PROG: LEVEL 3@"           ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL.@"            ; 57
                        DEFM "POWER@"                   ;
                        DEFM "SET TO 5%@^"              ;




; LEVEL FOUR    SELECTED      ALL SYSTEMS   OPERATIONAL
MESSAGE4:               DEFM "@"                        ;
                        DEFM "PROG: LEVEL 4@"           ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL.@"            ; 57
                        DEFM "POWER@"                   ;
                        DEFM "SET TO 5%@^"              ;   209

                        align 256                       ; Put these on page boundaries
; ORG 59136
; LEVEL FIVE    SELECTED      ALL SYSTEMS   OPERATIONAL
MESSAGE5:               DEFM "@"                        ;
                        DEFM "PROG: LEVEL 5@"           ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL.@"            ;  57
                        DEFM "POWER@"                   ;
                        DEFM "SET TO 5%@^"              ;


; Hyperdrive message
MESSAGE6:
                        DEFM "@"                        ;
                        DEFM "PROG:@"                   ;
                        DEFM "HYPERDRIVE@"              ; 19
                        DEFM "^"                        ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Report Sheilds Critical message

MESSAGE7:               DEFM "@"                        ;
                        DEFM "REPORT:@"                 ;
                        DEFM "SHIELDS@"                 ; 27
                        DEFM "CRITICAL@^"               ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Report Sheilds Failed message
MESSAGE8:               DEFM "@"                        ;
                        DEFM "REPORT:@"                 ;
                        DEFM "SHIELDS@"                 ;
                        DEFM "FAILED@^"                 ; 25
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; Report Rockets Low message
MESSAGE9:
                        DEFM "@"                        ;
                        DEFM "REPORT:@"                 ;
                        DEFM "ROCKETS LOW^"             ; 21


; Report Rockets Depleted message
MESSAGE10:              DEFM "@"                        ;
                        DEFM "REPORT:@"                 ;
                        DEFM "ROCKETS@"                 ; 26
                        DEFM "DEPLETED^"                ;


; Alien tracked message
MESSAGE11:              DEFM "@"                        ;
                        DEFM "ALIEN TRACKED^"           ; 15



; Alien destroyed message
MESSAGE12:
                        DEFM "@"                        ;
                        DEFM "ALIEN@"                   ; 17
                        DEFM "DESTROYED^"               ;


; Oxygen low message
MESSAGE13:
                        DEFM "@"                        ;
                        DEFM "OXYGEN@"                  ;
                        DEFM "LOW^"                     ; 12

; Losing Oxygen message
MESSAGE14:
                        DEFM "@"                        ;
                        DEFM "LOSING@"                  ;
                        DEFM "OXYGEN@"                  ;
                        DEFM "^"                        ; 16


; Water low message         (16)
MESSAGE15:
                        DEFM "@"                        ;
                        DEFM "WATER LOW^"               ; 11     246
                        align 256                       ; Put these on page boundaries



; DORBA OS LOADED message
MESSAGE17:
                        DEFM "@"                        ;
                        DEFM "@"                        ;
                        DEFM "D O R B A@"               ;
                        DEFM "OS 2020A@"
                        DEFM "LOADED@"               ;
                        DEFM "SYSTEM@"                  ;
                        DEFM "OPERATIONAL^"             ; 41



; Power depleting message
MESSAGE18:
                        DEFM "@"                        ;
                        DEFM "POWER@"                   ;
                        DEFM "DEPLETING^"               ; 17
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Temperature High message

MESSAGE19:
                        DEFM "@"                        ;
                        DEFM "TEMPERATURE@"             ;
                        DEFM "HIGH^"                    ; 18


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function not allowed
MESSAGE20:
                        DEFM "@"                        ;
                        DEFM "FUNCTION@"                ;  UNUSED
                        DEFM "NOT@"                     ;
                        DEFM "POSSIBLE^"                ; 26



; Temperature Low message
MESSAGE21:
                        DEFM "@"                        ;
                        DEFM "TEMPERATURE@"             ;
                        DEFM "LOW^"                     ; 17


; Temperature got too Low message
MESSAGE22:
                        DEFM "@"                        ;
                        DEFM "TEMPERATURE@"             ; UNUSED
                        DEFM "GOT TOO@"                 ;
                        DEFM "LOW^"                     ; 25


; Food depleted message    (24)
MESSAGE23:
                        DEFM "@"                        ;
                        DEFM "FOOD@"                    ; Unused
                        DEFM "DEPLETED^"                ; 15



; Power depleted message
MESSAGE24:
                        DEFM "@"                        ;
                        DEFM "POWER@"                   ;
                        DEFM "DEPLETED^"                ; 18



; Engines charging message   (26)
MESSAGE25:
                        DEFM "@"                        ;
                        DEFM "ENGINES@"                 ;
                        DEFM "CHARGING@"                ;
                        DEFM "POWER^"                   ;  24

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ;
                        align 256                       ; Put these on page boundaries
; Ship repairs complete message
MESSAGE26:
                        DEFM "@"                        ;
                        DEFM "SHIP REPAIRS@"            ;
                        DEFM "COMPLETE@"                ;
                        DEFM "@"                        ; 48
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "OPERATIONAL^"             ;
                        ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Function not possible Power too low message
MESSAGE27:
                        DEFM "@"                        ;
                        DEFM "FUNCTION@"                ;
                        DEFM "NOT POSSIBLE@"            ;
                        DEFM "POWER TOO@"               ;
                        DEFM "LOW@"                     ;
                        DEFM "^"                        ; 38


; We detect you have a bad reputation message
MESSAGE28:
                        DEFM "@"                        ;
                        DEFM "WE DETECT YOU@"           ;
                        DEFM "HAVE A BAD@"              ;
                        DEFM "REPUTATION@"              ;
                        DEFM "^"                        ; 38

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;  Mission completed message
MESSAGE29:
                        DEFM "@"                        ;
                        DEFM "CYGNUS ALPHA@"            ;
                        DEFM "CONFIRMED@"               ;
                        DEFM "CONTACT@"                 ;
                        DEFM "MISSION@"                 ;
                        DEFM "COMPLETED@"               ;
                        DEFM "^"                        ; 50


; Fatal Damage Ship unable to support human life (NOT USED?)
MESSAGE30:
                        DEFM "@"                        ;
                        DEFM "FATAL DAMAGE@"            ;
                        DEFM "SHIP UNABLE@"             ;
                        DEFM "TO SUPPORT@"              ;  66
                        DEFM "HUMAN LIFE@"              ;
                        DEFM "TERMINATE@"               ;
                        DEFM "MISSION@^"                ;  240


                        align 256                       ; Put these on page boundaries

; Mission abort please confirm message
MESSAGE31:
                        DEFM "@"                        ;
                        DEFM "PROG: ABORT@"             ;
                        DEFM "PLEASE CONFIRM@"          ; 37
                        DEFM "Y OR N^"                  ;

; Performing System Reset message                        ;
MESSAGE32:
                        DEFM "@"                        ; 1
                        DEFM "PERFORMING@"              ; 11
                        DEFM "SYSTEM RESET@"            ; 13 38
                        DEFM "@"                        ;
                        DEFM "PLEASE WAIT@^"            ; 12  ;39

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Alarm mute off message
MESSAGE34:
                        DEFM "@"                        ;
                        DEFM "ALARM MUTE OFF@^"         ; 17

; Alarm mute on message
MESSAGE35:
                        DEFM "@"                        ;
                        DEFM "ALARM MUTE ON@^"          ; 15


; Detecting alien has torpedo loaded message
MESSAGE36:
                        DEFM "@"                        ;
                        DEFM "DETECTING@"               ;
                        DEFM "ALIEN HAS@"               ; 36
                        DEFM "TORPEDO LOADED@^"         ;
                        ;


; Alien contact please stand by message
MESSAGE37:
                        DEFM "@"                        ;
                        DEFM "ALIEN CONTACT@"           ;
                        DEFM "PLEASE@"                  ;
                        DEFM "STAND BY@^"               ; 29
                        ;

; Error fault 01 (0xff) Invalid Function message
MESSAGE38:
                        DEFM "@"                        ;
                        DEFM " ERROR: FAULT@"           ;
                        DEFM "01 (0XFF)@"               ;
                        DEFM "INVALID@"                 ; 41
                        DEFM "FUNCTION@^"               ;
                        ; 214

                        align 256                       ; Put these on page boundaries

                        ;
; Error fault 01 (0x1f) The device is not ready message
MESSAGE39:
                        DEFM "@"                        ;
                        DEFM " ERROR: FAULT@"           ;
                        DEFM "21 (0X1F)@"               ; 48
                        DEFM "THE DEVICE@"              ;
                        DEFM "IS NOT READY@^"           ;
                        ;
                        align 256                       ; Put these on page boundaries
; Error fault 01 (0x1b) Cannot write to the device message
MESSAGE40:
                        DEFM "@"                        ;
                        DEFM " ERROR: FAULT@"           ;
                        DEFM "29 (0X1B)@"               ;
                        DEFM "THE SYSTEM@"              ; 62
                        DEFM "CANNOT WRITE@"            ;
                        DEFM "TO THE DEVICE@^"          ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The system cannot read from the specified device.

MESSAGE41:
                        DEFM "@"                        ;
                        DEFM " ERROR: FAULT@"           ;
                        DEFM "30 (0X1C)@"               ;
                        DEFM "THE SYSTEM@"              ; 59
                        DEFM "CANNOT READ@"             ;
                        DEFM "FROM DEVICE@^"            ;
                        ;


; Performing system tests message
MESSAGE42:
                        DEFM "@"                        ;
                        DEFM " PERFORMING@"             ;
                        DEFM "SYSTEM TESTS@"            ;
                        DEFM "@"                        ; 29
                        DEFM "@"                        ;
                        DEFM "^"                        ;

; Sites on message
MESSAGE43:
                        DEFM "@"                        ;
                        DEFM "PROG: SITES ON@"          ;
                        DEFM "@"                        ; 46
                        DEFM "TIME PROCESSOR@"          ;
                        DEFM "SET TO 80%@^"             ; 244

                        align 256                       ; Put these on page boundaries


; Sites off message
MESSAGE44:
                        DEFM "@"                        ;
                        DEFM "PROG:SITES OFF@"          ;
                        DEFM "@"                        ; 46
                        DEFM "TIME PROCESSOR@"          ;
                        DEFM "SET TO 99%@^"             ;
; Engine power
; Speed full power message
MESSAGE45:
                        DEFM "@"                        ;
                        DEFM "PROG: SPEED@"             ; 26
                        DEFM "FULL POWER@"              ;
                        DEFM "^"                        ;
; Speed 75% power message
MESSAGE46:
                        DEFM "@"                        ;
                        DEFM "PROG: SPEED@"             ; 25
                        DEFM "75% POWER@"               ;
                        DEFM "^"                        ;

; Speed 50% power message
MESSAGE47:
                        DEFM "@"                        ;
                        DEFM "PROG: SPEED@"             ; 24
                        DEFM "50% POWER@"               ;
                        DEFM "^"                        ;


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Speed 25% power message
MESSAGE48:
                        DEFM "@"                        ;
                        DEFM "PROG: SPEED@"             ; 24
                        DEFM "25% POWER@"               ;
                        DEFM "^"                        ;

; Speed 5% power message
MESSAGE49:
                        DEFM "@"                        ;
                        DEFM "PROG: SPEED@"             ; 23
                        DEFM "5% POWER@"                ;
                        DEFM "^"                        ;

; Transfering cargo message
MESSAGE50:
                        DEFM "@"                        ;
                        DEFM "TRANSFERING@"             ; 25
                        DEFM "CARGO@"                   ;
                        DEFM "^"                        ;

; Service menu keys message
MESSAGE51:
                        DEFM "@"                        ;
                        DEFM "SERVICE MENU@"            ; 25
                        DEFM "KEYS By Nx^"              ; 218

                        align 256                       ; Put these on page boundaries


; Mission abotrted message
MESSAGE52:
                        DEFM "@"                        ;
                        DEFM "PROG: MISSION@"           ;
                        DEFM "ABORT ABORTED@"           ; 48
                        DEFM "RESUME MISSION@"          ;
                        DEFM "^"                        ;

; Planet landing message
MESSAGE53:
                        DEFM "@"                        ;
                        DEFM "PROG: PLANET@"            ;
                        DEFM "LANDING@"                 ; 23
                        DEFM "^"                        ;

; Planet take off message
MESSAGE54:
                        DEFM "@"                        ;
                        DEFM "PROG: PLANET@"            ; 23
                        DEFM "TAKE OFF@"                ;
                        DEFM "^"                        ;


; All systems normal message
MESSAGE55:
                        DEFM "@"                        ;
                        DEFM "ALL SYSTEMS@"             ;
                        DEFM "NORMAL. HAVE@"            ; 38
                        DEFM "A GOOD FLIGHT@"           ;
                        DEFM "^"                        ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Detecting Alien Name message
MESSAGE56:
                        DEFM "@"                        ;
                        DEFM "DETECTING@"               ;
                        DEFM "ALIEN NAME@"              ;
ALIEN_NAME:             DEFM "    @"                    ; Detecting Alien Name message Alien name section
                        DEFM "^"                        ;  28

; We are open to Trade message
MESSAGE57:

                        DEFM "@"                        ;
                        DEFM "WE ARE@"                  ;
                        DEFM "OPEN TO TRADE@"           ;
                        DEFM "@"                        ;  25
                        DEFM "^"                        ;

; Are you buying or selling message
MESSAGE58:
                        DEFM "@"                        ;
                        DEFM "ARE YOU@"                 ;
                        DEFM "B-BUYING@"                ;
                        DEFM "D-SELLING?@"              ;
                        DEFM "A-ABORT@"                 ; 38
                        DEFM "^"                        ; 223

                        align 256                       ; Put these on page boundaries




; Sending Cargo message USED?
MESSAGE59:
                        DEFM "@"                        ;
                        DEFM "SENDING@"                 ;
                        DEFM "CARGO@"                   ;
                        DEFM "^"                        ;  16

; We offer money per units message
MESSAGE60:              ;(61)                           ;
                        DEFM "@"                        ;
                        DEFM "WE OFFER@"                ;
OFFER_HD_3:             DEFM "000 d PER@"               ; Offer price section of We offer money per units message
INTERESTED_IN_3:        DEFM "             @"           ;
OFFER_UNITS_3:          DEFM "FOR 000 UNITS@"           ; Number of units section of We offer money per units message
                        DEFM "OF YOUR STOCK@"           ;   63
                        DEFM "    Y/N"                  ;
                        DEFM "^"                        ;


; Buy from Aliens list
MESSAGE61:              ;(62)                           ;
                        DEFM "@"                        ;    Aliens buy from you
                        DEFM "WE CAN OFFER@"            ;
                        DEFM "Q XARGON-3@"              ;
                        DEFM "W WATER@"                 ;
                        DEFM "E OXYGEN@"                ;
                        DEFM "R FOOD@"                  ;
                        DEFM "T ABORT^"                 ;
                        ;  55

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; You took too long message    ; (63)
MESSAGE62:
                        DEFM "@"                        ;
                        DEFM "YOU TOOK@"                ;
                        DEFM "TOO LONG"                 ;
                        DEFM "^"                        ; 19

; Power Full message     (64)
MESSAGE63:
                        DEFM "@"                        ;
                        DEFM "POWER@"                   ;
                        DEFM "FULL"                     ;
                        DEFM "^"                        ; 12

; XARGON-3 Full message     (65)
MESSAGE64:
                        DEFM "@"                        ;
                        DEFM "XARGON-3@"                ;
                        DEFM "FULL"                     ;
                        DEFM "^"                        ;   15

; XARGON-3 depleted message
MESSAGE65:
                        DEFM "@"                        ;
                        DEFM "XARGON-3@"                ;
                        DEFM "DEPLETED"                 ;
                        DEFM "^"                        ;   19

; XARGON-3 low message
MESSAGE66:
                        DEFM "@"                        ;
                        DEFM "XARGON-3@"                ;
                        DEFM "LOW@"                     ;
                        DEFM "^"                        ;   15

; Oxygen depleted message
MESSAGE67:              DEFM "@"                        ;
                        DEFM "EXPENSES@"                ;
                        DEFM "10000d@"                  ;
                        DEFM "TOTAL@"                   ;
                        DEFM "^"                        ; 17   231

                        align 256                       ; Put these on page boundaries



; Very disapointing desicion message
MESSAGE68:
                        DEFM "@"                        ;
                        DEFM "VERY@"                    ;
                        DEFM "DISAPPOINTING@"           ;
                        DEFM "DECISION@"                ;
                        DEFM "WE WILL MEET@"            ;
                        DEFM "AGAIN^"                   ; 48

; Very disapointing thank you for wasting our time message
MESSAGE69:
                        DEFM "@"                        ;
                        DEFM "VERY@"                    ;
                        DEFM "DISAPPOINTING@"           ;
                        DEFM "THANK YOU@"               ;
                        DEFM "FOR WASTING@"             ;
                        DEFM "OUR TIME^"                ; 51


; Registry display
MESSAGE70:
                        DEFM "@"                        ;
                        DEFM "COMPUTER@"                ;
                        DEFM "REGISTRY@"                ;
                        DEFM "STATUS^"                  ; 26

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Buying from aliens message

MESSAGE71:
                        DEFM "@"                        ;
                        DEFM "WE ARE ASKING@"           ;
ASKING_HD:              DEFM "000 d FOR@"               ; Asking price section of We offer money per units message
ASKING_UNITS:           DEFM "000 UNITS@"               ; Number of units section of We ask money per units message
ASKING_NAME:            DEFM "OF           @"           ;
                        DEFM "    Y/N"                  ;
                        DEFM "^"                        ;  57


; Food low message         (73)
MESSAGE72:
                        DEFM "@"                        ;
                        DEFM "FOOD LOW^"                ; 11


; Cockpit Severe damage message         (74)
MESSAGE73:
                        DEFM "@"                        ;
                        DEFM "COCKPIT@"                 ; 24
                        DEFM "SEVERE@"                  ;
                        DEFM "DAMAGE^"                  ;   217
                        align 256                       ; Put these on page boundaries

MESSAGE75:
                        DEFM "@"                        ;
                        DEFM "CYGNUS ALPHA@"            ;
                        DEFM "CONFIRMED@"               ;
                        DEFM "CONTACT@"                 ;
                        DEFM "MISSION@"                 ;
                        DEFM "COMPLETED@"               ;
                        DEFM "^"                        ; 50

MESSAGE76:
                        DEFM "@"                        ;
                        DEFM "SHIELDS OFF@"             ;
                        DEFM "^"                        ; 14

MESSAGE77:
                        DEFM "@"                        ;
                        DEFM "SHIELDS ON@"              ;
                        DEFM "^"                        ; 13



MESSAGE78:
                        DEFM "@"                        ;
                        DEFM "SHIELDS ON@"              ;
                        DEFM "^"                        ; 13

MESSAGE79:
                        DEFM "@"                        ;
                        DEFM "ENGINE@"                  ;   Unused
                        DEFM "SERVICE@"                 ;
                        DEFM "REQUIRED@"                ;
                        DEFM "^"                        ; 26


; Game over messages

MESSAGE80:
                        DEFM "@"                        ;
                        DEFM "FOOD@"                    ;
                        DEFM "DEPLETED^"                ; 15


MESSAGE81:
                        DEFM "@"                        ;
                        DEFM "OXYGEN@"                  ;
                        DEFM "DEPLETED^"                ; 17


MESSAGE82:
                        DEFM "@"                        ;
                        DEFM "WATER@"                   ;
                        DEFM "DEPLETED^"                ; 16     164


MESSAGE83:
                        DEFM "@"                        ;
                        DEFM "COCKPIT@"                 ; 19
                        DEFM "DESTROYED^"               ;

MESSAGE84:
                        DEFM "@"                        ;
                        DEFM "OXYGEN@"                  ; 17
                        DEFM "DEPLETED^"                ;

MESSAGE85:
                        DEFM "@"                        ;
                        DEFM "POWER@"                   ; 14
                        DEFM "FAILED^"                  ;

MESSAGE86:
                        DEFM "@"                        ;
                        DEFM "TEMPERATURE@"             ; 26
                        DEFM "GOT TOO@"                 ;
                        DEFM "HIGH^"                    ;


MESSAGE87:
                        DEFM "@"                        ;
                        DEFM "TEMPERATURE@"             ;
                        DEFM "GOT TOO@"                 ;
                        DEFM "LOW^"                     ; 24

                        align 256                       ; Put these on page boundaries

MESSAGE88:
                        DEFM "@"                        ;
                        DEFM "FUEL@"                    ;   Unused
                        DEFM "DEPLETED^"                ;  15

MESSAGE89:
                        DEFM "@"                        ;
                        DEFM "OUT OF@"                  ;   Unused
                        DEFM "MONEY@"                   ;
                        DEFM "^"                        ; 3

MESSAGE90:
                        DEFM "@"                        ;
                        DEFM "@"                        ;   Unused
                        DEFM "^"                        ; 3     21

; Water depleted message
MESSAGE16:
                        DEFM "@"                        ;
                        DEFM "WELCOME@"                 ;
                        DEFM "Y-FULL SERVICE@"          ; Menu after landing
                        DEFM "COST 10000 d@"            ;
                        DEFM "P-TAKE OFF@"              ;
                        DEFM "^"                        ; 16
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

ALIEN_NAME_INDEX_3:     ; Put these on page boundaries  ;

; Nice aliens  1=Friendly, 0=Unfriendly Each name is 4 Bytes

ALIEN_NAME_1_3:         DB 1                            ;
                        DEFM "opq "                     ; RIBAT alien name data

ALIEN_NAME_2_3:         DB 1                            ;
                        DEFM "rst "                     ; CHOLP alien name data

ALIEN_NAME_3_3:         DB 1                            ;
                        DEFM "uv  "                     ; CHON alien name data

ALIEN_NAME_4_3:         DB 1                            ;
                        DEFM "z{  "                     ; KOZE alien name data

ALIEN_NAME_5_3:         DB 1                            ;
                        DEFM "|}~ "                     ; VENDI alien name data

; Nasty aliens

ALIEN_NAME_6_3:         DB 0                            ;
                        DEFM "&'  "                     ; GAN alien name data

ALIEN_NAME_7_3:         DB 0                            ;
                        DEFM "efgh"                     ; BAZZAHS alien name data

ALIEN_NAME_8_3:         DB 0                            ;
                        DEFM "ij  "                     ; VILLS alien name data

ALIEN_NAME_9_3:         DB 0                            ;
                        DEFM "klmn"                     ; GUBBINS alien name data     ;45    187


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        align 256                       ; Put these on page boundaries
; Messages index table
MESSAGE_INDEX_3:

                        DEFW MESSAGE0,MESSAGE0B,MESSAGE1,MESSAGE2,MESSAGE3,MESSAGE4,MESSAGE5,MESSAGE6,MESSAGE7,MESSAGE8,MESSAGE9,MESSAGE10;  24
                        DEFW MESSAGE11,MESSAGE12,MESSAGE13,MESSAGE14,MESSAGE15,MESSAGE16,MESSAGE17,MESSAGE18,MESSAGE19,MESSAGE20;      44
                        DEFW MESSAGE21,MESSAGE22,MESSAGE23,MESSAGE24,MESSAGE25,MESSAGE26,MESSAGE27,MESSAGE28,MESSAGE29,MESSAGE30;     64
                        DEFW MESSAGE31,MESSAGE32,MESSAGE33,MESSAGE34,MESSAGE35,MESSAGE36,MESSAGE37,MESSAGE38,MESSAGE39,MESSAGE40;    84
                        DEFW MESSAGE41,MESSAGE42,MESSAGE43,MESSAGE44,MESSAGE45,MESSAGE46,MESSAGE47,MESSAGE48,MESSAGE49,MESSAGE50;
                        DEFW MESSAGE51,MESSAGE52,MESSAGE53,MESSAGE54,MESSAGE55,MESSAGE56,MESSAGE57,MESSAGE58,MESSAGE59,MESSAGE60;
                        DEFW MESSAGE61,MESSAGE62,MESSAGE63,MESSAGE64,MESSAGE65,MESSAGE66,MESSAGE67,MESSAGE68,MESSAGE69,MESSAGE70 ; 140
                        DEFW MESSAGE71,MESSAGE72,MESSAGE73,MESSAGE74,MESSAGE75,MESSAGE76,MESSAGE77,MESSAGE78,MESSAGE79,MESSAGE80 ; 244
                        DEFW MESSAGE81,MESSAGE82,MESSAGE83,MESSAGE84,MESSAGE85,MESSAGE86,MESSAGE87,MESSAGE88,MESSAGE89,MESSAGE90 ; 244
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                        align 256                       ; Put these on page boundaries

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set alien name
SET_ALIEN_NAME_3:
                        LD HL,ALIEN_NAME_1_3            ; First alien name data

                        LD A,(COUNTER)                  ; Get game counter

                        CP 10                           ;
                        JR NC,NEXT_ALIEN_NAME_0_3       ; Skip adding if 0
                        LD HL,ALIEN_NAME_1_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_0_3:
                        CP 30                           ;
                        JR NC,NEXT_ALIEN_NAME_1_3       ;

                        LD HL,ALIEN_NAME_2_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_1_3:
                        CP 70                           ;
                        JR NC,NEXT_ALIEN_NAME_2_3       ;
                        LD HL,ALIEN_NAME_3_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_2_3:
                        CP 100                          ;
                        JR NC,NEXT_ALIEN_NAME_3_3       ;
                        LD HL,ALIEN_NAME_4_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_3_3:
                        CP 130                          ;
                        JR NC,NEXT_ALIEN_NAME_4_3       ;
                        LD HL,ALIEN_NAME_5_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_4_3:
                        CP 160                          ;
                        JR NC,NEXT_ALIEN_NAME_5_3       ;
                        LD HL,ALIEN_NAME_6_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_5_3:
                        CP 190                          ;
                        JR NC,NEXT_ALIEN_NAME_6_3       ;
                        LD HL,ALIEN_NAME_7_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_6_3:
                        CP 220                          ;
                        JR NC,NEXT_ALIEN_NAME_7_3       ;
                        LD HL,ALIEN_NAME_8_3            ; First alien name data
                        JP SKIP_ADDING_TO_ALIEN_NAME_3  ;
NEXT_ALIEN_NAME_7_3:
                        LD HL,ALIEN_NAME_9_3            ; First alien name data


SKIP_ADDING_TO_ALIEN_NAME_3:

                        LD A,(HL)                       ; Get first byte for alien friendly status
                        ; OUT (254),A
                        ; ld a,1
                        LD (ALIEN_IS_FRIENDLY),A        ; Initialise alien friendly setting 0 for not friendly
                        INC HL                          ; Move to text data
                        LD DE,ALIEN_NAME                ; Location to copy name to
                        LD BC,4                         ; 4 bytes to copy
                        LDIR                            ; Copy name

                        RET                             ; Return


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        align 256                       ; Put these on page boundaries
; Comodity names to copy to message
SETUP_COMMODITY_DATA1_3:
                        DEFM "UNIT XARGON-3@  "         ;  16
SETUP_COMMODITY_DATA2_3:
                        DEFM "UNIT WATER   @  "         ;  32
SETUP_COMMODITY_DATA3_3:
                        DEFM "UNIT OXYGEN  @  "         ;  48
SETUP_COMMODITY_DATA4_3:
                        DEFM "UNIT FOOD    @  "         ;  64

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3D Alien ship 1A AND 1B
; ORG 57344

                        align 256                       ; Put these on page boundaries
ALIEN_SHIP_1A_3:        ;Both frames same Ship size 1   ;

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 1, 128, 3, 192, 31, 248;
                        defb 63, 252, 15, 240, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ; 32


ALIEN_SHIP_1B_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 1, 128, 3, 192, 31, 248;
                        defb 63, 252, 15, 240, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ; 64

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ALIEN_SHIP_1A_B_3:      ;Both frames same Ship size 2   ;

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 1, 128, 3, 192, 3, 192, 31, 248;
                        defb 255, 255, 255, 255, 63, 252, 31, 248;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;


ALIEN_SHIP_1B_B_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 1, 128, 3, 192, 3, 192, 31, 248;
                        defb 255, 255, 255, 255, 63, 252, 31, 248;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ; 128
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        align 256                       ; Put these on page boundaries
ALIEN_SHIP_1A_C_3:      ;Both frames same Ship size 3   ;

                        defb 0, 0, 0, 0, 0, 0, 0, 3     ;
                        defb 0, 7, 0, 7, 0, 7, 0, 255   ;
                        defb 31, 255, 31, 255, 15, 255, 1, 255;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;

                        defb 0, 0, 0, 0, 0, 0, 192, 0   ;
                        defb 224, 0, 224, 0, 224, 0, 255, 0;
                        defb 255, 240, 255, 240, 255, 224, 255, 128;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ; 64


ALIEN_SHIP_1B_C_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 3     ;
                        defb 0, 7, 0, 7, 0, 7, 0, 255   ;
                        defb 31, 255, 31, 255, 15, 255, 1, 255;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;

                        defb 0, 0, 0, 0, 0, 0, 192, 0   ;
                        defb 224, 0, 224, 0, 224, 0, 255, 0;
                        defb 255, 240, 255, 240, 255, 224, 255, 128;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;  128




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien ship 2A AND 2B

                        align 256                       ; Put these on page boundaries

ALIEN_SHIP_2A_3:        ; Ship size 4                   ;

                        defb 0, 0, 0, 0, 0, 0, 0, 3     ;
                        defb 0, 6, 0, 5, 0, 7, 1, 255   ;
                        defb 62, 31, 64, 32, 127, 255, 27, 187;
                        defb 0, 127, 0, 0, 0, 0, 0, 0   ;

                        defb 0, 0, 0, 0, 0, 0, 192, 0   ;
                        defb 224, 0, 224, 0, 224, 0, 255, 192;
                        defb 252, 56, 2, 4, 255, 252, 187, 160;
                        defb 252, 0, 0, 0, 0, 0, 0, 0   ;   64

ALIEN_SHIP_2B_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 3     ;
                        defb 0, 6, 0, 5, 0, 7, 1, 255   ;
                        defb 62, 159, 66, 0, 127, 255, 30, 238;
                        defb 0, 127, 0, 0, 0, 0, 0, 0   ;

                        defb 0, 0, 0, 0, 0, 0, 192, 0   ;
                        defb 224, 0, 224, 0, 224, 0, 255, 192;
                        defb 252, 184, 128, 36, 255, 252, 238, 224;
                        defb 252, 0, 0, 0, 0, 0, 0, 0   ; 128

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien ship 3A AND 3B
                        align 256                       ; Put these on page boundaries
ALIEN_SHIP_3A_3:        ; Ship size 7                   ;

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 1, 240, 6, 0, 28, 0, 23, 254;
                        defb 31, 159, 7, 191, 0, 255, 0, 3;
                        defb 3, 224, 25, 248, 23, 248, 47, 252;
                        defb 39, 252, 47, 252, 47, 252, 255, 255;
                        defb 31, 252, 32, 2, 64, 1, 128, 0;
                        defb 255, 255, 62, 124, 190, 125, 255, 255;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 15, 128, 0, 96, 0, 56, 255, 232;
                        defb 249, 248, 253, 224, 255, 0, 192, 0 ; 96


                        ;  align 256                       ; Put these on page boundaries

ALIEN_SHIP_3B_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 1, 240, 6, 7, 28, 24, 31, 254;
                        defb 30, 115, 7, 247, 0, 255, 0, 3;
                        defb 3, 224, 25, 248, 23, 248, 47, 252;
                        defb 39, 252, 47, 252, 47, 252, 255, 255;
                        defb 223, 253, 0, 128, 0, 128, 0, 128;
                        defb 255, 255, 231, 231, 231, 231, 255, 255;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 143, 128, 112, 96, 12, 56, 255, 248;
                        defb 158, 120, 223, 224, 255, 0, 192, 0; 96

                        align 256                       ; Put these on page boundaries

ALIEN_SHIP_2A_A_3:      ; Ship size 5                   ;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 0, 241, 3, 6, 3, 252, 0, 223;
                        defb 0, 61, 0, 7, 0, 0, 0, 0    ;

                        defb 0, 0, 0, 0, 3, 192, 5, 224 ;
                        defb 11, 240, 15, 240, 11, 240, 251, 255;
                        defb 31, 252, 0, 0, 0, 0, 255, 255;
                        defb 247, 222, 255, 255, 0, 0, 0, 0;

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 143, 0, 97, 128, 127, 128, 238, 0;
                        defb 240, 0, 0, 0, 0, 0, 0, 0   ;  96


ALIEN_SHIP_2B_B_3:

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 0, 240, 3, 0, 3, 252, 0, 183;
                        defb 0, 63, 0, 7, 0, 0, 0, 0    ;


                        defb 0, 0, 0, 0, 3, 192, 5, 224 ;
                        defb 11, 240, 15, 240, 11, 240, 251, 255;
                        defb 31, 252, 32, 130, 64, 128, 255, 255;
                        defb 190, 251, 255, 255, 0, 0, 0, 0;

                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 15, 0, 1, 128, 255, 128, 186, 0;
                        defb 240, 0, 0, 0, 0, 0, 0, 0   ; 192

                        align 256                       ; Put these on page boundaries

ALIEN_SHIP_2C_A_3:      ;Alien size 6                   ;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 0, 240, 3, 0, 6, 0, 7, 254 ;
                        defb 3, 119, 0, 63, 0, 3, 0, 0  ;
                        defb 0, 0, 3, 192, 14, 240, 11, 240;
                        defb 23, 248, 27, 248, 23, 248, 255, 255;
                        defb 31, 252, 32, 2, 64, 1, 128, 0;
                        defb 255, 255, 190, 251, 255, 255, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 15, 0, 0, 192, 0, 96, 255, 224;
                        defb 222, 192, 252, 0, 0, 0, 0, 0 ; 96

ALIEN_SHIP_2C_B_3:
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 0, 15    ;
                        defb 0, 240, 3, 7, 7, 56, 7, 254;
                        defb 3, 223, 0, 61, 0, 3, 0, 0  ;
                        defb 0, 0, 3, 192, 14, 240, 11, 240;
                        defb 23, 248, 27, 248, 23, 248, 255, 255;
                        defb 127, 254, 128, 129, 0, 128, 0, 128;
                        defb 255, 255, 247, 222, 255, 255, 0, 0;
                        defb 0, 0, 0, 0, 0, 0, 0, 0     ;
                        defb 0, 0, 0, 0, 0, 0, 240, 0   ;
                        defb 15, 0, 224, 192, 24, 96, 255, 224;
                        defb 251, 192, 252, 0, 0, 0, 0, 0;   ;192


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Spining icon graphics
                        align 256                       ; Put these on page boundaries
SPINING_ICON_1_3:
                        defb 1, 128, 3, 192, 3, 192, 25, 128, 24, 8, 0, 0, 0, 0, 64, 0;
                        defb 64, 2, 0, 0, 0, 0, 0, 0, 16, 8, 0, 0, 1, 0, 0, 0;      32

SPINING_ICON_2_3:
                        defb 0, 0, 1, 128, 1, 152, 48, 60, 0, 60, 0, 24, 0, 0, 0, 0;
                        defb 64, 2, 0, 0, 0, 0, 0, 0, 16, 8, 0, 0, 1, 0, 0, 0;     32

SPINING_ICON_3_3:
                        defb 0, 0, 1, 128, 0, 0, 16, 24, 0, 24, 0, 0, 0, 6, 0, 15;
                        defb 64, 15, 0, 6, 0, 0, 0, 0, 16, 8, 0, 0, 1, 0, 0, 0;

SPINING_ICON_4_3:
                        defb 0, 0, 0, 128, 0, 0, 16, 8, 0, 8, 0, 0, 0, 0, 0, 6;
                        defb 64, 6, 0, 0, 0, 24, 0, 60, 16, 60, 0, 24, 1, 0, 0, 0; 224

                        ;    align 256                       ; Put these on page boundaries

SPINING_ICON_5_3:
                        defb 0, 0, 0, 128, 0, 0, 16, 8, 0, 0, 0, 0, 0, 0, 0, 2;
                        defb 64, 2, 0, 0, 0, 0, 0, 24, 17, 152, 3, 192, 3, 192, 1, 128;

SPINING_ICON_6_3:
                        defb 0, 0, 0, 128, 0, 0, 16, 8, 0, 0, 0, 0, 0, 0, 64, 2;
                        defb 0, 0, 0, 0, 24, 0, 60, 0, 60, 24, 25, 128, 1, 128, 0, 0;

SPINING_ICON_7_3:
                        defb 0, 0, 0, 128, 0, 0, 16, 8, 0, 0, 0, 0, 96, 0, 240, 2;
                        defb 240, 0, 96, 0, 0, 0, 24, 0, 24, 8, 0, 0, 1, 128, 0, 0;

SPINING_ICON_8_3:
                        defb 0, 0, 0, 128, 24, 0, 60, 8, 60, 0, 24, 0, 0, 0, 96, 2;
                        defb 96, 0, 0, 0, 0, 0, 16, 0, 16, 8, 0, 0, 1, 0, 0, 0;  128
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

                        ;  align 256                       ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ICON_POSITION_COUNTER_3:DEFB 1,1                        ; Counts position of icon selector ROW,COLLUMN

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Display LED screen
DISPLAY_LED_SCREEN_3:
                        OR A                            ; Over write sprite mode
                        LD (MERGE_SPRITE+1),A           ;

                        LD D,24                         ; Line 3
                        LD E,48                         ; Collumn 2
                        ; LD DE,8240                      ; Line 3, Collumn 2
                        LD B,5                          ; 6 lines to display
DISPLAY_LED_STATUS_LOOP2_3:
                        PUSH BC                         ; Save Lines loop

                        LD C,10                         ; Number of blocks across
DISPLAY_LED_STATUS_LOOP1_3:


                        PUSH BC                         ;
                        PUSH DE                         ;


                        LD HL,LED_GRAPHIC_DATA_3        ;

                        LD A,E                          ;
                        LD (dispy+1),A                  ; Set sprite Y to X coordinate
                        LD A,D                          ; Get Horace Y coordinate
                        LD (dispx+1),A                  ; Set sprite Y to X coordinate

                        CALL sprite                     ; Display sprite
                        POP DE                          ;
                        POP BC                          ;
                        ; POP HL                          ;
                        ; POP AF                          ;

                        LD A,16                         ;
                        ADD A,E                         ;
                        LD E,A                          ; Move to next collumn

                        DEC C                           ; Take 1 from collumn loop
                        JR NZ,DISPLAY_LED_STATUS_LOOP1_3 ; Jump back to complete row

                        POP BC                          ; Restore lines loop
; Move to next line
                        LD A,16                         ;
                        ADD A,D                         ;
                        LD D,A                          ;
                        LD E,48                         ;
                        DJNZ DISPLAY_LED_STATUS_LOOP2_3 ;


                        LD DE,VARABLES                  ; DE=address of first varable to colour

                        LD HL,ATTR1+134-32              ; HL=First ATTR screen address of first varable to colour

                        LD C,0                          ; Start with lines 0 to colour up to 10
REGISTRY_COLOUR_STATUS_LOOP2_3:
                        PUSH BC                         ; Save lines loop

                        LD B,0                          ; Start with collumns 0 to colour up to 10
REGISTRY_COLOUR_STATUS_LOOP1_3:

                        LD A,(DE)                       ; A=current varable setting
                        OR A                            ; Is it 0?
                        JR Z,SKIP_COLOUR_REGISTRY1_3    ; Skip colouring it if so
                        LD (HL),A                       ; Set current ATTR address to the colour
SKIP_COLOUR_REGISTRY1_3:
                        PUSH AF                         ; Save the colour
                        PUSH HL                         ; Save the current ATTR address

                        LD HL,(ICON_POSITION_COUNTER_3) ; Get Icon position into HL
                        LD A,L                          ; A=collumn to compare
                        DEC A                           ;
                        CP B                            ; Compare it with current collumns loop counter
                        JR NZ,SKIP_FLASH_CURSOR_3       ; Skip flashing the ATTR if does not match

                        LD A,H                          ; A=Row to compare
                        DEC A                           ;
                        CP C                            ; Compare it with line loop counter
                        JR NZ,SKIP_FLASH_CURSOR_3       ; Skip flashing the ATTR if does not match

                        LD A,255                        ; A=White on white
                        POP HL                          ; Restore current ATTR address
                        LD (HL),A                       ; Set current ATTR to white on white to highlight it
                        JP MOVE_TO_NEXT_3               ; Jump the current ATTR address restore

SKIP_FLASH_CURSOR_3:
                        POP HL                          ; Restore current ATTR address

MOVE_TO_NEXT_3:

                        POP AF                          ; Restore current ATTR setting to fill second ATTR to the right
                        INC HL                          ; Add 1 to the current ATTR address to movo to the right 1 ATTR location
                        OR A                            ; Is current ATTR 0?
                        JR Z,SKIP_COLOUR_REGISTRY2_3    ; Skip colouring it if so
                        LD (HL),A                       ; Set current ATTR address to the colour
SKIP_COLOUR_REGISTRY2_3:

                        INC HL                          ; Add 1 to the current ATTR address to movo to the right 1 ATTR location
                        INC DE                          ; Move to next varable
                        INC B                           ; Add 1 to collumn counter
                        LD A,10                         ; Setup A to test
                        CP B                            ; is collumn counter at 10?
                        JR NZ,REGISTRY_COLOUR_STATUS_LOOP1_3; If not then jump back to complete row

                        POP BC                          ; Restore row counter
                        PUSH DE                         ; Save current varable address
                        LD DE,12                        ; Setup DE for addition
                        ADD HL,DE                       ; Add to DE to move down a ATTR line
                        POP DE                          ; Restore current varable address
                        INC C                           ; Add 1 to row counter
                        LD A,10                         ; Setup A to test
                        CP C                            ; Is row at 10?
                        JR NZ,REGISTRY_COLOUR_STATUS_LOOP2_3; Jump back to complete all rows if not

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Check selected icon movement
CHECK_ICON_MOVEMENT_KEY_3:


                        CALL GET_KEYS_Y_TO_P            ; Check for U key
                        BIT 3,A                         ; U pressed?
                        JR Z,MOVEMENT_KEY_OK_3          ; Zero if so

                        JP GET_VARABLE_LOCATION_3       ;
MOVEMENT_KEY_OK_3:
                        LD A,(ICON_COUNTER)             ; Get icon counter
                        INC A                           ; Add 1 to counter
                        LD (ICON_COUNTER),A             ; Update icon counter

                        LD HL,(ICON_POSITION_COUNTER_3) ; Point HL at position counters

                        LD A,L                          ; Get collumn
                        CP 10                           ; Is it 10?
                        JR Z,DROP_A_LINE_3              ; If so then drop a line

                        INC A                           ; Increase A to drop a line
                        LD L,A                          ; Update L to drop a line
                        JP UPDATE_ICON_POSITION_3       ; Jump to update coordinates


DROP_A_LINE_3:
                        LD A,H                          ; Get Row
                        CP 10                           ; Are we at end of row 10?
                        JR NZ,SKIP_RESET_3              ; If not then Skip reset back to begining
; Reset back to first location
                        XOR A                           ; Set A to 0
                        LD (ICON_COUNTER),A             ; Update icon counter to reset it
                        LD A,1                          ; Set Reset coordinates
                        JP UPDATE_COORDINATES_3         ;

SKIP_RESET_3:
                        INC A                           ; Add 1 to collumn

UPDATE_COORDINATES_3:
                        LD H,A                          ; Set HL to updated coordinates
                        ; LD A,1                          ;
                        LD L,1                          ; Reset commumn

UPDATE_ICON_POSITION_3:
                        LD (ICON_POSITION_COUNTER_3),HL ; Update position counters
GET_VARABLE_LOCATION_3:
; Point at Varables area to get selected varable
                        LD DE,VARABLES                  ; Get varables area pointer
                        LD A,(ICON_COUNTER)             ; Get icon counter
                        ;     LD HL,22528
                        ;  LD (HL),A
                        ; OUT (254),A
ADD_TO_ICON_VARABLE_POSITION_LOOP_3:
                        INC DE                          ; Add 1 to DE to get to gorrect varable
                        DEC A                           ; Take 1 from add loop
                        JR NZ,ADD_TO_ICON_VARABLE_POSITION_LOOP_3 ; Jump back to finish adding to DE

; DE now=selected varable

SKIP_MOVING_SELECTED_ICON_3:
; Check for setting the varable keys
                        LD BC,64510                     ; Keyboard port for Q,W,E,R,T
                        IN A,(C)                        ; Read keys Q to T

                        BIT 1,A                         ; W pressed?
                        JR NZ,SKIP_ADD_TO_VARABLE_3     ; Zero if so
                        ; OUT (254),A
                        LD A,(DE)                       ; Get varable setting
                        INC A                           ; Add 1 to varable
                        LD (DE),A                       ; Update varable
                        JP SKIP_TAKE_FROM_VARABLE_3     ;
SKIP_ADD_TO_VARABLE_3:

                        LD BC,64510                     ; Keyboard port for Q,W,E,R,T
                        IN A,(C)                        ; Read keys Q to T

                        BIT 2,A                         ; E pressed?
                        ;   OUT (254),A
                        JR NZ,SKIP_TAKE_FROM_VARABLE_3  ; Zero if so
                        LD A,(DE)                       ; Get varable setting
                        DEC A                           ; Take from varable
                        LD (DE),A                       ; Update varable
SKIP_TAKE_FROM_VARABLE_3:


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Graphic data for the LED blocks
LED_GRAPHIC_DATA_3:

                        defb 0, 0, 0, 0, 63, 252, 127, 254;
                        defb 127, 254, 63, 252, 0, 0, 0, 0;
                        defb 0, 0, 0, 0, 63, 252, 127, 254;
                        defb 127, 254, 63, 252, 0, 0, 0, 0;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear game screen ATTR                ;
CLEAR_GAME_SCREEN_ATTR_3:
                        LD A,0                          ; A=0 for black on black
                        LD (TEXT_COLOUR+1),A            ;          ; Set screen colour
                        LD A,12                         ; 12 lines of attr
                        LD (LINES+1),A                  ; Set lines
                        LD A,28                         ; 28 collumns
                        LD (COLLUMNS+1),A               ; Set collumns
                        LD A,4                          ; 4 spaces between lines to move to next line
                        LD (SET_MAIN_TEXT_DISPLAY_ATTR_SPACE+1),A; Set line spacing
                        LD HL,22528+66                  ; Set start ATTR address
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_B_3; Colour the display
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR
SET_MAIN_TEXT_DISPLAY_ATTR_3:
                        LD A,6                          ; 6 lines of attr
                        LD (LINES+1),A                  ; Set lines
                        LD A,14                         ; 14 collumns
                        LD (COLLUMNS+1),A               ; Set collumns
                        LD A,18                         ; 18 spaces between lines to move to next line
                        LD (SET_MAIN_TEXT_DISPLAY_ATTR_SPACE+1),A; Set line spacing
                        LD HL,MAIN_TEXT_DISPLAY_START_ADDRESS; Set start ATTR address
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_B_3; Colour the display
                        RET                             ; Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_MAIN_TEXT_DISPLAY_ATTR_B_3:
; SCREEN_ATTR_ADDRESS:    LD HL,MAIN_TEXT_DISPLAY_START_ADDRESS ; Start ATTR of large text screen
LINES:                  LD B,6                          ; 6 lines
                        LD D,0                          ; Set D to 0 for DE addition
DISPLAY_TEXT_ONE_BY_ONE_ATTR_LOOP1_3:

COLLUMNS:               LD A,14                         ; 14 collumns
DISPLAY_TEXT_ONE_BY_ONE_ATTR_LOOPG_3:

TEXT_COLOUR:            LD (HL),0                       ; Set current ATTR address to colour
                        INC L                           ; Move to next collumn
                        DEC A                           ; Decrease collumn counter
                        JR NZ,DISPLAY_TEXT_ONE_BY_ONE_ATTR_LOOPG_3; Jump back until all of line is completed
SET_MAIN_TEXT_DISPLAY_ATTR_SPACE:LD E,18                ; Setup DE for addition
                        ADD HL,DE                       ; Move to next line
                        DJNZ DISPLAY_TEXT_ONE_BY_ONE_ATTR_LOOP1_3; Jump back until all lines are completed
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set all alien coordinates to 4 corners of view
SET_ALL_ALIENS_COORDINATES_4_CORNERS_3:

; LD A,2
; OUT (254),A

                        LD A,50                         ;
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Set back to distance counter to 50 to start back to distance sequence


                        LD IX,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data
                        ; Alien 1 top right
                        LD (IX+1),7                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),130                   ; Alien ship 1 up/down coordinate  130 top 180 bottom
                        LD (IX+3),220                   ; Alien ship 1 left/right coordinate

                        LD DE,12+32                     ;
                        ADD IX,DE                       ;
                        ; Alien 1 top left
                        LD (IX+1),6                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),130                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),10                    ; Alien ship 1 left/right coordinate

                        ; LD DE,12                        ;
                        ADD IX,DE                       ;
                        ; Alien 3 bottom right
                        LD (IX+1),5                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),230                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),200                   ; Alien ship 1 left/right coordinate
                        ;  LD (IX+10),1


                        ;  LD DE,12                        ;
                        ADD IX,DE                       ;
                        ; Alien 3 bottom left
                        LD (IX+1),4                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),230                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),20                    ; Alien ship 1 left/right coordinate
                        ; LD (IX+10),1


                        ;  LD DE,11                        ;
                        ;  ADD IX,DE                       ;


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set all alien coordinates to distance
SET_ALL_ALIENS_COORDINATES_DISTANCE_3:

                        LD A,40                         ;
                        LD (SPECIAL_ALIEN_FRAME_COUNTER),A ; Set back to distance counter to 25 to start distance to back sequence


                        LD IX,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data
                        ; Alien 1 top right
                        LD (IX+1),1                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),120                   ; Alien ship 1 up/down coordinate  130 top 180 bottom
                        LD (IX+3),190                   ; Alien ship 1 left/right coordinate

                        LD DE,12+32                     ;
                        ADD IX,DE                       ;
                        ; Alien 1 top left
                        LD (IX+1),1                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),130                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),30                    ; Alien ship 1 left/right coordinate

                        ;  LD DE,12                        ;
                        ADD IX,DE                       ;
                        ; Alien 3 bottom right
                        LD (IX+1),1                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),200                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),180                   ; Alien ship 1 left/right coordinate
                        ;  LD (IX+10),1


                        ;  LD DE,12                        ;
                        ADD IX,DE                       ;
                        ; Alien 3 bottom left
                        LD (IX+1),1                     ; Alien ship 1 distance 1 to 7
                        LD (IX+2),200                   ; Alien ship 1 up/down coordinate
                        LD (IX+3),40                    ; Alien ship 1 left/right coordinate
                        ; LD (IX+10),1


                        ;   LD DE,11                        ;
                        ;   ADD IX,DE                       ;


                        RET                             ;
; Set alien sequence to start in random positions
SET_ALL_ALIENS_COORDINATES_RANDOM_3:

                        LD IX,ALIEN_SHIP_1_ENABLED      ; Point at alien ship data


                        LD (IX+1),0                     ; Alien ship 1 distance 1 to 7
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 150                          ;
                        LD (IX+2),A                     ; Alien ship 1 up/down coordinate
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 40                           ;
                        LD (IX+3),A                     ; Alien ship 1 left/right coordinate

                        LD DE,12+32                     ;
                        ADD IX,DE                       ;

                        LD (IX+1),0                     ; Alien ship 1 distance 1 to 7
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 120                          ;
                        LD (IX+2),A                     ; Alien ship 1 up/down coordinate
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 40                           ;
                        LD (IX+3),A                     ; Alien ship 1 left/right coordinate

                        ; LD DE,12                        ;
                        ADD IX,DE                       ;

                        LD (IX+1),0                     ; Alien ship 1 distance 1 to 7
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 100                          ;
                        LD (IX+2),A                     ; Alien ship 1 up/down coordinate
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 30                           ;
                        LD (IX+3),A                     ; Alien ship 1 left/right coordinate

                        ; LD DE,12                        ;
                        ADD IX,DE                       ;

                        LD (IX+1),0                     ; Alien ship 1 distance 1 to 7
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 200                          ;
                        LD (IX+2),A                     ; Alien ship 1 up/down coordinate
                        CALL RELEASE_RANDOM_NUMBER      ;
                        OR 60                           ;
                        LD (IX+3),A                     ; Alien ship 1 left/right coordinate

                        ;    LD DE,11                        ;
                        ;    ADD IX,DE                       ;


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Called with WARNING_ON =colour   1 OR 66    OPTIMIZED
WARNING_OFF_ON_3:       ; Start of warning LED          ;
                        LD A,(WARNING_ON)               ; Get warning colour
                        LD B,6                          ; Setup B as loop counter
                        LD HL,23161-8                   ; ATTR start address for Warning light

                        CALL COLOUR_DIALS               ; Colour dial

                        LD A,(ALARM_SOUND_MUTE)         ; Get alarm sound mute status
                        OR A                            ; Is it on?
                        RET NZ                          ; Return without making sound if so

                        LD A,(WARNING_ON)               ; Get warning colour
                        LD HL,ALARM_SOUND_DATA          ; Alarm sound data
                        CP 1                            ; Does warning colour = anything apart from dark blue?
                        CALL NZ,GENERAL_SOUND           ; If so then must be lit so make alarm sound
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Colour each line of logo
TOP_BOTTOM_LOGO_ATTR_3:

                        LD A,(LOGO_COLOUR+1)            ; Get colour counter
                        AND 10                          ; Light blue paper whatever happens
                        RES 1,A                         ;
                        LD B,24                         ; 24 text positions to colour on one line
LOGO_COLOUR_LOOP3C_3:
                        LD (HL),A                       ; Update current ATTR location with colour
                        INC HL                          ; Move to next ATTR address
                        DJNZ LOGO_COLOUR_LOOP3C_3       ; Jump back to cover all text locations for single line
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Used for start of game
FLASH_PLAY_AREA_WHITE_3:
                        LD HL,30840                     ;
                        ; LD H,120                        ;
                        ; LD L,120                        ;
                        JP PERFORM_FLASH_PLAY_AREA_3    ;

FLASH_PLAY_AREA_BLACK_3:
                        LD HL,18247                     ;
                        ; LD H,71                         ;
                        ; LD L,71                         ;
                        JP PERFORM_FLASH_PLAY_AREA_3    ;


PERFORM_FLASH_PLAY_AREA_3:
                        DI                              ;
                        LD (STACKA+1),SP            ; Save Stack pointer
                        LD SP,22974                     ; Bottom right of play area

FLASH_PLAY_AREA_LINES_3:
                        LD A,12                         ; 12 lines default
FLASH_PLAY_AREA_LOOP2_3:

                        LD B,14                         ; 14 collumns
FLASH_PLAY_AREA_LOOP_3:
                        PUSH HL                         ;
                        DJNZ FLASH_PLAY_AREA_LOOP_3     ;

                        DEC SP                          ;
                        DEC SP                          ;
                        DEC SP                          ;
                        DEC SP                          ;
                        DEC A                           ;

                        JR NZ,FLASH_PLAY_AREA_LOOP2_3   ;


STACKA:                        LD SP,0                         ;
                        LD A,12                         ;
                        LD (FLASH_PLAY_AREA_LINES_3+1),A ;
                        EI                              ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Display rotating icon and advance 1 frame
DISPLAY_BUSY_ICON_3:
                        LD A,67                         ; Bright magenta on black
                        CALL SET_LCD_LED_STATUS_COLOUR  ; Colour the LED on the LCD screen to A

                        LD A,(NORMAL_LCD_COLOUR)        ; Light cyan on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR

                        ; LD A,(MESSAGE_STATUS)           ; Get message status
                        ; CP 0                            ; Already displaying a message so no icon required?
                        ; RET NZ                           ;

                        XOR A                           ; A=0 to reset sprite merge to off
                        LD (MERGE_SPRITE+1),A           ; Set merge sprite to off
                        LD HL,SPINING_ICON_COUNTER      ; Get current spinning icon frame
                        INC (HL)                        ; Move to next graphic
                        LD A,(HL)                       ; Get current spinning icon frame
                        ; CP 8                            ; Are we at graphic 8?
                        ; JR C,SKIP_RESETING_BUSY_ICON    ; If not then skip resetting busy icon frame
                        ; LD (HL),A                       ; Update spining icon counter

SKIP_RESETING_BUSY_ICON_3:
                        LD HL,SPINING_ICON_1_3          ; Start of spining icon graphics data

DISPLAY_BUSY_ICON_LOOP_3:

                        ADD A,A                         ;
                        ADD A,A                         ;
                        ADD A,A                         ;
                        ADD A,A                         ;
                        ADD A,A                         ; 20
                        LD L,A                          ; 4


SKIP_CHOSING_GRAPHIC_3:
                        PUSH HL                         ;
                        POP IX                          ;

                        ; IX=GRAPHIC

                        LD HL,20583                     ; +15                  ; HL=SCREEN ADDRESS

                        LD C,2                          ; Width
                        LD A,C                          ; Get rows
                        JP DISPLAY_LARGE_GRAPHIC_LOOP3  ; Display large graphic
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Place ATTR take text onto screen
DISPLAY_ATTR_TAKE_TEXT_3:
                        LD HL,TAKE_TEXT_ATTR_DATA_3     ;
                        JP DISPLAY_ATTR_TEXT_3          ;

; Place ATTR off text onto screen
DISPLAY_ATTR_OFF_TEXT_3:
                        LD HL,OFF_TEXT_ATTR_DATA_3      ;

; Place ATTR text onto screen
DISPLAY_ATTR_TEXT_3:
                        LD A,(HL)                       ; Get first byte of block
                        CP 255                          ; Does it = 255?
                        RET Z                           ; Finish if so
                        LD C,A                          ; Load into B
                        INC HL                          ; Move to next address
                        LD B,(HL)                       ; Load into C
                        INC HL                          ; Move to next address
                        LD A,(HL)                       ; Get colour data
                        INC HL                          ; Move to next address
                        LD (BC),A                       ; Colour ATTR
                        JP DISPLAY_ATTR_TEXT_3          ; Jump back to complete text
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TAKE_TEXT_ATTR_DATA_3:  ; Data for the ATTR word take   ;
                        DEFB 132,88,87,133,88,87,134,88 ;
                        DEFB 87,135,88,87,136,88,87,140 ;
                        DEFB 88,87,144,88,87,148,88,87  ;
                        DEFB 150,88,87,151,88,87,152,88 ;
                        DEFB 87,153,88,87,154,88,87,166 ;
                        DEFB 88,87,171,88,87,173,88,87  ;
                        DEFB 176,88,87,179,88,87,182,88 ;
                        DEFB 87,198,88,87,203,88,87,204 ;
                        DEFB 88,87,205,88,87,208,88,87  ;
                        DEFB 209,88,87,210,88,87,214,88 ;
                        DEFB 87,215,88,87,216,88,87,217 ;
                        DEFB 88,87,230,88,87,234,88,87  ;
                        DEFB 235,88,87,237,88,87,238,88 ;
                        DEFB 87,240,88,87,243,88,87,246 ;
                        DEFB 88,87,6,89,87,10,89,87     ;
                        DEFB 14,89,87,16,89,87,20,89    ;
                        DEFB 87,22,89,87,23,89,87,24    ;
                        DEFB 89,87,25,89,87,26,89,87    ;

                        DEFB 255                        ; End of data
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
OFF_TEXT_ATTR_DATA_3:   ; Data for the ATTR word off    ;
                        DEFB 136,88,87,137,88,87,138,88 ;
                        DEFB 87,141,88,87,142,88,87,143 ;
                        DEFB 88,87,144,88,87,145,88,87  ;
                        DEFB 147,88,87,148,88,87,149,88 ;
                        DEFB 87,150,88,87,151,88,87,167 ;
                        DEFB 88,87,171,88,87,173,88,87  ;
                        DEFB 179,88,87,199,88,87,203,88 ;
                        DEFB 87,205,88,87,206,88,87,207 ;
                        DEFB 88,87,211,88,87,212,88,87  ;
                        DEFB 213,88,87,231,88,87,235,88 ;
                        DEFB 87,237,88,87,243,88,87,8   ;
                        DEFB 89,87,9,89,87,10,89,87     ;
                        DEFB 13,89,87,19,89,87          ;

                        DEFB 255                        ; End of data


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Scroll for show bars on top of console when power is charging
SCROLL_SHOW_BARS_3:

                        LD HL,20453+2                   ; -256               ; 18661+2 ;LAST address of bars

                        LD C,8                          ; 8 pixel lines

SCROLLNEXTLINE:
                        LD B,3                          ; 3 collumns
                        ; OR A                            ; Set carry
SCROLLNEXTBYTE:
                        RLC (HL)                        ; Rotate left content of screen at HL
                        DEC HL                          ; get screen location to the left
                        DJNZ SCROLLNEXTBYTE             ;

                        PUSH BC                         ; Save BC
                        LD BC,3                         ;
SCROLLSUBLOOP2:
                        ADD HL,BC                       ; Add 3 addresses to HL

                        LD BC,255                       ; Subtract 256 from HL for next pixel line to scroll

                        SBC HL,BC                       ;

SCROLLSUBLOOP:


                        DEC HL                          ; Subtract one more to make 256
                        POP BC                          ; Restore BC
                        DEC C                           ; Decrement C count for next pixel line
                        JR NZ,SCROLLNEXTLINE            ; Jump back to scroll next pixel line until C=0
                        RET                             ;

; Trade routines
; First phase where the aliens appear and this is called if they are friendly
AFTER_ALIENS_APPEAR_3:





; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Alien detect if you have bad reputation;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
INITIAL_ALIEN_CHECKS_3:
                        ; CALL SET_COUNTER2               ; Set counter 2 to close to 2 so speed up next phase
                        CALL TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3 ; Take 1 from alien counter sequence to 254
                        XOR A                           ; A=0 for reseting trade keys
                        LD (TRADING_KEYS_ENABLED),A     ; Disable trade keys
                        LD (SITES_ON),A                 ; Set Sites on/off status to off
                        LD A,(REPUTATION)               ; Get your reputation
                        CP 4                            ; You have a bad one 1 to 10?
                        JR NC,SKIP_BAD_REPUTATION_SETUP_3 ; If not then skip the bad reputation routine
; You have a bad reputation;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        LD A,29                         ; Message that alien detects you have a bad one
                        CALL GET_MESSAGE_POINTERB_3     ; Set message
                        XOR A                           ; Setup A to reset alien encounter sequence
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset alien encounter sequence as no trading will happen
                        ; JP SKIP_ALIEN_TRADING           ; Skip rest of trading

SKIP_BAD_REPUTATION_SETUP_3:
                        JP SKIP_DETECTING_ALIEN_HAS_TORPEDO_MESSAGE ; Skip rest of trading

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Second phase of trading;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SECOND_TRADING_STAGEA_3:
                        ; CALL SET_COUNTER2               ; Set counter 2 to close to 2 so speed up next phase
                        CALL TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3 ; Take 1 from alien counter sequence to 252
                        LD A,58                         ; Message that alien is open to trade
                        CALL GET_MESSAGE_POINTERB_3     ; Set message
                        JP SKIP_ALIEN_TRADING           ; Skip rest of trading

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup Are you buying or selling stage, Enable trading keys and reset timer
SECOND_TRADING_STAGEB_3:
                        ; CALL SET_COUNTER2               ; Set counter 2 to close to 2 so speed up next phase
                        CALL TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3 ; Take 1 from alien counter sequence to 250
                        LD A,59                         ; Are you buying or selling? B or S
                        CALL GET_MESSAGE_POINTERB_3     ; Set message

                        CALL RESET_TIMER:               ; Reset timer


                        LD A,1                          ; A=1 to enable trade keys
                        LD (TRADING_KEYS_ENABLED),A     ; Enable trade keys

                        JP SKIP_ALIEN_TRADING           ; Skip rest of trading

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECOND_TRADING_STAGEC_3:
                        CALL TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3 ; Take 1 from alien counter sequence to 248

                        JP SKIP_ALIEN_TRADING           ; Skip rest of trading
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from Alien encounter sequence
TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3:
                        LD A,(ALIEN_ENCOUNTER_SEQUENCE) ; Get alien encounter sequence
                        DEC A                           ; Take 1 from alien counter sequence
                        JP UPDATE_ALIEN_ENCOUNTER_SEQUENCE_3;
                        ;  LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Update alien counter sequence
                        ; RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset alien encounter to 0
RESET_ALIEN_COUNTER_SEQUENCE_3:
                        XOR A                           ; Setup A to reset alien encounter sequence

UPDATE_ALIEN_ENCOUNTER_SEQUENCE_3:
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset alien encounter sequence as no trading will
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 10000HD for expenses
TAKE_10000_FROM_HD_3:

                        LD BC,10000                     ;
SERVICE_LOOP_1_3:
                        PUSH BC                         ;

                        CALL TAKE_1_FROM_HD_3             ;
                        CALL DISPLAY_TEXT_ONE_BY_ONE_WITHOUT_MEMORY_SWITCH_TO    ; Update LCD Text

                        POP BC                          ;
                        DEC BC                          ;
                        LD A,B                          ;
                        OR C                            ;
                        JR NZ,SERVICE_LOOP_1_3            ;
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We are buying from alien
SETUP_BUYING_3:
                        LD A,62                         ; Setup A=message number 60 for We are interested in
                        CALL GET_MESSAGE_POINTERB_3     ; Set message

SETUP_BUYING2_3:        ; Shared code for selling also  ;

                        LD A,100                        ; Setup A for starting Buy/Sell process
                        LD (ALIEN_ENCOUNTER_SEQUENCE),A ; Reset alien encounter sequence to 100 start trading


                        CALL TAKE_1_FROM_ALIEN_COUNTER_SEQENCE_3 ; Take 1 from alien counter sequence to 99

                        LD A,1                          ;
                        LD (BUY_SELL_MENU),A            ; Set Buy/Sell menu to on to prevent speed controls


                        JP RETURN_FROM_BUY_SELL         ; Jump back to continue game

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; We are selling to alien
SETUP_SELLING_3:
                     ;   CALL SETUP_COMMODITY_3          ; Setup message for alien interested in information
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup commodity - What are we selling?  Quantity
;SETUP_COMMODITY_3:
; Reset figures
                        LD A,48                         ; To set to "0"
                        LD HL,OFFER_HD_3                ; Reset Alien offers this amount of HD text
                        LD B,2                          ; 3 digits to set
                        CALL SET_TEXT_LOOP_3            ; Call text set loop;

                        LD HL,OFFER_UNITS_3+4           ; Reset Alien wants this number of units
                        LD B,2                          ; 3 digits to set
                        CALL SET_TEXT_LOOP_3            ; Call text set loop;

; ;;;;;;;;;;;;;;;;;;;
; Set quantity
                        LD A,10                       ; Get random number

                        LD (INTERESTED_IN_QTY),A        ; Store alien interested in number of units
                        LD HL,OFFER_UNITS_3+6           ; Alien wants this number of units
                        ;  LD C,2                          ; Data is 3 figures
                        LD B,A                          ;
                        CALL SET_FIGURES_LOOP_3           ;
; ;;;;;;;;;;;;;;;;;;;;;;
; Set cost per item
                        LD A,10                          ; Get random number

                        LD (OFFER_HD_QTY),A             ; Store alien offering number of HD per unit
                        LD HL,OFFER_HD_3+2              ; Alien offers this amount of HD
                        ;   LD C,2                          ; Data is 3 figures
                        LD B,A                          ;
                        CALL SET_FIGURES_LOOP_3           ;


; ;;;;;;;;;;;;;;;;;;;;;
; Set item
                        LD A,R                          ; Get random number

                        AND 4                           ;

                        OR A                            ;
                        JR NZ,SKIP_SETTING_ITEM_1_3       ;

                        LD HL,SETUP_COMMODITY_DATA1_3   ; Point at commodity data
                        JP NEXT_CHECK_ON_LIST_3           ;
SKIP_SETTING_ITEM_1_3:
                        CP 1                            ;
                        JR NZ,SKIP_SETTING_ITEM_2_3       ;
                        LD HL,SETUP_COMMODITY_DATA2_3   ; Point at commodity data
                        JP NEXT_CHECK_ON_LIST_3           ;
SKIP_SETTING_ITEM_2_3:


                        CP 2                            ;
                        JR NZ,SKIP_SETTING_ITEM_3       ;
                        LD HL,SETUP_COMMODITY_DATA3_3   ; Point at commodity data
                        JP NEXT_CHECK_ON_LIST_3           ;
SKIP_SETTING_ITEM_3:


                        LD HL,SETUP_COMMODITY_DATA4_3   ; Point at commodity data

NEXT_CHECK_ON_LIST_3:
                        LD (ITEM_SELLING_TO_ALIEN),A    ; Set item selling to alien

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Place Interested in item name into Message string
PLACE_ITEM_INTO_INTERESTED_IN_3:
                        ; HL=ITEM NAME STRING
               ;LD HL,SETUP_COMMODITY_DATA1_3

                        LD DE,INTERESTED_IN_3           ; Alien is interested in
                        LD B,13                        ; String is 14 wide
ACCC_3:
                       LD A,(HL)
                        LD (DE),A
                         INC HL
                        INC DE
                        DJNZ ACCC_3



                    ;    LDIR                            ;
                    ;    RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



                        LD A,61                         ; Setup A=message number 60 for We are interested in
                        CALL GET_MESSAGE_POINTERB_3     ; Set message

                        JP SETUP_BUYING2_3              ; Jump back to continue game

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Set counter 2 to close to 2 so speed up next phase
; SET_COUNTER2:
;                        LD A,200                          ;
;                        LD A,(COUNTER2)                 ; Get counter2
;                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



                        ;     DEFM "UNIT XARGON-3@  "         ;  16
                        ;     DEFM "UNIT WATER   @  "         ;  32
                        ;     DEFM "UNIT OXYGEN  @  "         ;  48
                        ;     DEFM "UNIT FOOD    @  "         ;  64
                        ;     DEFM "UNIT XARGON-3@  "         ;  80
                        ;     DEFM "UNIT WATER   @  "         ;  96
                        ;     DEFM "UNIT OXYGEN  @  "         ;  112




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FIGURES_LOOP_3:       ; B=TOTAL TO INCREMENT HL=DATA LOCATION;
                        PUSH HL                         ; Save data pointer address
                        ; PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES_3          ; Add 1 to the figure
                        ; POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_FIGURES_LOOP_3           ; Jump back until figure is set
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Increment figure pointed to by setting HL to the last digit address
; The entry point to this routine is here. HL pointing at the digit of the score to be incremented

INCREMENT_FIGURES_3:

; Check current figure to see if it is a 9, if it is not then set to a zero and move to the next digit to the left and increment it
                        LD A,(HL)                       ; A=last byte of data to adjust
                        CP "9"                          ; is value at 9?
                        JR NZ,ADD_1_TO_DIGIT_3            ; If not then jump to increment digit

; Digit is a 9 so set it to 0 and move to the digit to the left to check to see if it is a space or a 9 and if not then increment it
                        LD (HL),"0"                     ; 56                      ; Set address to "0"
                        DEC HL                          ; Go to next score address to the left


                        JP INCREMENT_FIGURES_3            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to the digit and leave
ADD_1_TO_DIGIT_3:         INC (HL)                        ; increase current digit

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Used to set text string for reseting figures HL=location to change, B=loop count and A=value
SET_TEXT_LOOP_3:
                        LD (HL),A                       ;
                        INC HL                          ;
                        DJNZ SET_TEXT_LOOP_3            ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BUYING_FROM_ALIEN_COMODITIES_3:; We are buying from the aliens;
; Reset figures
                        LD A,48                         ; To set to "0"
                        LD HL,ASKING_HD                 ; Alien asking this amount of HD text
                        LD B,2                          ; 3 digits to set
                        CALL SET_TEXT_LOOP_3            ; Call text set loop;

                        LD HL,ASKING_UNITS              ; Alien wants to sell this number of units
                        LD B,2                          ; 3 digits to set
                        CALL SET_TEXT_LOOP_3            ; Call text set loop;

; ;;;;;;;;;;;;;;;;;;;
; Set quantity
                        LD A,10                         ; Get random number

                        LD (ASKING_QTY_FIGURE),A        ; Store alien interested in number of units
                        LD HL,ASKING_UNITS+2            ; Alien wants this number of units
                        ;   LD C,2                          ; Data is 3 figures
                        LD B,A                          ;

                        CALL SET_FIGURES_LOOP_3           ;
; ;;;;;;;;;;;;;;;;;;;;;;
; Set cost OF items
                        LD A,10                        ; Get random number

                        LD (ASKING_HD_FIGURE),A         ; Store alien offering number of HD per unit
                        LD HL,ASKING_HD+2               ; Alien offers this amount of HD
                        ;   LD C,2                          ; Data is 3 figures
                        LD B,A                          ;
                        CALL SET_FIGURES_LOOP_3           ;


                        ; 1 XARGON-3
                        ; 2 WATER
                        ; 3 OXYGEN
                        ; 4 FOOD
; Setup name

:

                        LD A,(BUYING_FROM_ALIEN_ITEM)   ;
                        CP 1                            ; Are we buying Xargon-3?
                        JR NZ,BUYING_WATER_3            ; If not then jump to next item


BUYING_XARGON3_3:
; We are buying Xargon-3
                        LD HL,SETUP_COMMODITY_DATA1_3+5 ; Point HL to Xargon-3 string
                        JP END_BUYING_FROM_ALIEN_3      ;


BUYING_WATER_3:
                        CP 2                            ;
                        JR NZ,BUYING_OXYGEN_3           ;
                        LD HL,SETUP_COMMODITY_DATA2_3+5 ; Point HL to Water string
                        JP END_BUYING_FROM_ALIEN_3      ;

BUYING_OXYGEN_3:
                        CP 3                            ;
                        JR NZ,BUYING_FOOD_3             ;
                        LD HL,SETUP_COMMODITY_DATA3_3+5 ; Point HL to oxygen string
                        JP END_BUYING_FROM_ALIEN_3      ;

BUYING_FOOD_3:
                        LD HL,SETUP_COMMODITY_DATA4_3+5 ; Point HL to food string



END_BUYING_FROM_ALIEN_3:
                        LD BC,7                         ; 8 characters to set
                        LD DE,ASKING_NAME+3             ; Point DE to message content to place name

                        LDIR                            ; Copy string

                        XOR A                           ; Set A to 0
                        LD (BUY_SELL_MENU),A            ; End buy sell menu

                        LD A,3                          ;
                        LD (BUY_SELL),A                 ; Set to Wait for confirm buying status

                        RET                             ; Return




; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;







; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; When we have sold stuff to the aliens, we need to update the books
SET_SELLING_TAKINGS_3:
                        LD A,(ITEM_SELLING_TO_ALIEN)    ; Get item we are selling
                        LD C,A                          ; Save item we are selling
                        LD A,(INTERESTED_IN_QTY)        ; Get quantity of items we are selling
                        LD B,A                          ; Setup qty loop
SELLING_QTY_LOOP_3:
                        PUSH BC                         ;
; Selling fuel?
                        XOR A                           ; Check for 0 for selling fuel
                        CP C                            ; Are we selling fuel?
                        JR NZ,SKIP_SELLING_ITEM1_3      ;
                        CALL TAKE_1_FROM_FUEL_3         ; If so then decrement fuel
                        JP NEXT_SELLING_LOOP_3          ;

SKIP_SELLING_ITEM1_3:
; Selling water?:
                        LD A,1                          ; Check for 32 for selling water
                        CP C                            ; Are we selling fuel?
                        JR NZ,SKIP_SELLING_ITEM2_3      ;
                        CALL DECREMENT_WATER_3          ; Take 1 from water
                        JP NEXT_SELLING_LOOP_3          ;
SKIP_SELLING_ITEM2_3:
; Selling oxygen?:
                        LD A,2                          ; Check for 48 for selling oxygen
                        CP C                            ; Are we selling oxygen?
                        JR NZ,SKIP_SELLING_ITEM3_3      ;
                        CALL DECREMENT_OXYGEN_3         ; Take 1 from water


SKIP_SELLING_ITEM3_3:
; Selling food?:
                        LD A,3                          ; Check for 64 for selling food
                        CP C                            ; Are we selling food?
                        JR NZ,SKIP_SELLING_ITEM4_3      ;
                        CALL DECREMENT_FOOD_3             ; Take 1 from food

SKIP_SELLING_ITEM4_3:

                        LD A,4                          ; Check for 64 for selling food
                        CP C                            ; Are we selling food?
                        JR NZ,NEXT_SELLING_LOOP_3       ;
                        CALL Z,DECREMENT_FOOD_3           ; Take 1 from food

NEXT_SELLING_LOOP_3:
                        POP BC                          ;
                        DJNZ SELLING_QTY_LOOP_3         ; Jump back for number of units

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


                        LD A,(OFFER_HD_QTY)             ; Get amount of HD per item
                        LD B,A                          ; Setup amount of HD per item loop

AMOUNT_OF_HD_PER_ITEM_LOOP_3:
                        PUSH BC                         ;

                        LD A,(INTERESTED_IN_QTY)        ; Get quantity of items we are selling
                        LD B,A                          ;
ADD_CASH_LOOP1_3:
                        PUSH BC                         ;
                        CALL ADD_1_TO_HD_3                ; Take the money
                        POP BC                          ;

                        DJNZ ADD_CASH_LOOP1_3           ; Jump back to take all money


                        POP BC                          ;
                        DJNZ AMOUNT_OF_HD_PER_ITEM_LOOP_3 ; Jump back for number of units

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_BUYING_TAKINGS_3:
; Update outgoings for when buying from aliens and add to your items


                        LD A,(ASKING_HD_FIGURE)         ; Amount of HD is cost you to take from your HD
                        LD B,A                          ;
TAKE_FROM_HD_LOOP_3:

                        CALL TAKE_1_FROM_HD_3             ;

                        DJNZ TAKE_FROM_HD_LOOP_3        ;


                        ; 1 XARGON-3
                        ; 2 WATER
                        ; 3 OXYGEN
                        ; 4 FOOD
                        LD A,(ASKING_QTY_FIGURE)        ; Quantity of purchased items to be added to your stock
                        LD B,A                          ;

BUYING_ADD_TO_YOUR_ITEMS_LOOP_3:; Loop to add to your stock;
                        PUSH BC                         ;
                        LD A,(BUYING_FROM_ALIEN_ITEM)   ; Item number to add to

                        CP 1                            ;
                        JR NZ,SKIP_ADDING_TO_FUEL_3     ;
                        CALL ADD_1_TO_FUEL_3              ; Add 1 to Xargon-3
                        JP SKIP_ADDING_1_TO_FOOD_3      ;
SKIP_ADDING_TO_FUEL_3:
                        CP 2                            ;
                        JR NZ,SKIP_ADDING_TO_WATER_3    ;
                        CALL ADD_1_TO_WATER_3             ; Add 1 to water
                        JP SKIP_ADDING_1_TO_FOOD_3      ;
SKIP_ADDING_TO_WATER_3:
                        CP 3                            ;
                        JR NZ,SKIP_ADDING_1_TO_OXYGEN_3 ;
                        CALL ADD_1_TO_OXYGEN_3          ; Add 1 to oxygen
                        JP SKIP_ADDING_1_TO_FOOD_3      ;
SKIP_ADDING_1_TO_OXYGEN_3:
                        CP 4                            ;
                        JR NZ,SKIP_ADDING_1_TO_FOOD_3   ;
                        CALL ADD_1_TO_FOOD_3            ; Add 1 to food
SKIP_ADDING_1_TO_FOOD_3:
                        POP BC                          ;
                        DJNZ BUYING_ADD_TO_YOUR_ITEMS_LOOP_3;

                        RET                             ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to temperature
ADD_1_TO_TEMPERATURE_3:

                        LD A,(TEMPERATURE)              ; Get TEMP
                        CP 80                           ; Is temperature at 80 or more?
                        JR NC,TEMPERATURE_IS_TOO_HOT_3  ; If so then jump to Too Hot!
                        INC A                           ; Add 1 to temperature
                        LD (TEMPERATURE),A              ; Update Temperature
                        CALL SET_TEMPERATURE_3          ; Take temperature value and turn into text form in data
                        RET                             ;
TEMPERATURE_IS_TOO_HOT_3:

                        CP 99                           ;
                        JR NC,TEMPERATURE_IS_TOO_HOT_GAME_OVER_3 ; If so then jump to Too Hot GAME OVER!
                        INC A                           ; Add 1 to temperature
                        LD (TEMPERATURE),A              ; Update Temperature
                        CALL SET_TEMPERATURE_3          ; Take temperature value and turn into text form in data
                        CALL SWITCH_WARNING_ON_3        ; Switch warning on
                        CALL ADD_1_TO_ENGINE_3          ; Add to Engine status
                        LD A,(COUNTER)                  ; Get game counter
                        RET NZ                          ; Dont display temperature high message if counter is not zero
                        LD A,20                         ; MESSAGE FOR TEMPERATURE HIGH
                        CALL GET_MESSAGE_POINTER_3      ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SWITCH_WARNING_ON_3:
                        LD A,1                          ; A=1 to switch on Warning
                        LD (SET_WARNING_ON),A           ; Set warning to on
                        RET                             ;
SWITCH_WARNING_OFF_3:
                        XOR A                           ; A=1 to switch on Warning
                        LD (SET_WARNING_ON),A           ; Set warning to on

                        INC A                           ; A=1 for blue
                        LD (WARNING_ON),A               ;

                        CALL WARNING_OFF_ON_3           ;
                        RET                             ; Return





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set game over countdown and select message for temperature too hot
TEMPERATURE_IS_TOO_HOT_GAME_OVER_3:

                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,87                         ; MESSAGE FOR TEMPERATURE to HIGH so game over
                        CALL GET_MESSAGE_POINTER_3      ;


                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from temperature
TAKE_1_FROM_TEMPERATURE_3:
                        LD A,(TEMPERATURE)              ; Get TEMP
                        CP 18                           ; Is temperature at 18 or less?
                        JR C,TEMPERATURE_IS_TOO_COLD_3  ; If so then jump to Too cold!
                        DEC A                           ; Take 1 to temperature
                        LD (TEMPERATURE),A              ; Update Temperature
                        CALL SET_TEMPERATURE_3          ; Take temperature value and turn into text form in data
                        RET                             ; Return

TEMPERATURE_IS_TOO_COLD_3:
                        CP 1                            ; Is temperature 1 or less?
                        JR NC,TEMPERATURE_IS_TOO_COLD_GAME_OVER_3;

                        DEC A                           ; Take 1 to temperature
                        LD (TEMPERATURE),A              ; Update Temperature
                        CALL SET_TEMPERATURE_3          ; Take temperature value and turn into text form in data

                        CALL SWITCH_WARNING_ON_3        ; Switch warning on
                        CALL SWITCH_SERVICE_ON_3        ; Switch Service warning on

                        LD A,(COUNTER)                  ; Get game counter
                        RET NZ                          ; Dont display temperature high message if counter is not zero

                        LD A,22                         ; MESSAGE FOR TEMPERATURE HIGH
                        CALL GET_MESSAGE_POINTER_3      ;
                        RET                             ; Return

TEMPERATURE_IS_TOO_COLD_GAME_OVER_3:
; Set game over countdown and temperature too cold message as temperature is too cold
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,88                         ; MESSAGE FOR TEMPERATURE to cold so game over
                        CALL GET_MESSAGE_POINTER_3      ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup new message, Get message into HL
; A=MESSAGE NUMBER HL=MESSAGE ADDRESS
GET_MESSAGE_POINTER_3:
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

                        JP SKIP_GET_MESSAGE_POINTERB_3  ;
GET_MESSAGE_POINTERB_3:

                        LD (LAST_MESSAGE_STATUS),A      ; Save current message status if we need to repeat it

                        CALL CLEAR_TEXT_SCREEN_3        ; Clear text screen
SKIP_GET_MESSAGE_POINTERB_3:
                        LD A,(SNOW_TEXT_SCREEN_ON)      ; Get interference on text display status
                        OR A                            ; Is it enabled?                           ;
                        JR Z,SKIP_RED_LED_ON_LCD_3      ; Skip counting down snow text counter if not

                        LD A,66                         ; Bright red on black
                        JP SKIP_GREEN_LED_ON_LCD_3      ; Jump to set LED to red
SKIP_RED_LED_ON_LCD_3:
                        LD A,68                         ; Bright green on black
SKIP_GREEN_LED_ON_LCD_3:
                        CALL SET_LCD_LED_STATUS_COLOUR  ; Colour the LED on the LCD screen to A
; Clear the cursor on LCD
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
MESSAGE_0_SKIPPED_3:

                        LD (MESSAGE_POINTER_31231),HL   ; Update the message pointer

                        LD A,1                          ; A=1 to set message status to on
                        LD (MESSAGE_STATUS),A           ;  Set message status to on
                        ; Reset row and collumn for the new message

                        ; ;;;;;;;;;;;;;;;;
                        LD A,1                          ; 9                          ;  Collumn 9 to start
                        LD (TEXT_COLLUMN_31324),A       ; Setup text collumn and row

                        LD A,22                         ; ROW 22
                        LD (TEXT_ROW_31325),A           ; Setup text collumn and row
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take fuel value and turn into text form in data
SET_FUEL_3:
                        CALL RESET_FUEL_FIGURES_3       ; Set the figures to 000 so we can count the fuel up to set the new figure
                        ; Assume fuel is OK

                        CALL SWITCH_WARNING_OFF_3       ; Switch warning off


                        LD A,96                         ; Black ink on light green paper
                        LD (FUEL_STATUS_COLOUR),A       ;
; Get Fuel status
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 40                           ; Is fuel low?
                        JR NC,SKIP_SETTING_FUEL_WARNING_3 ; If NOT then skip setting fuel warning

                        LD A,112                        ; Black ink on light yellow paper
                        LD (FUEL_STATUS_COLOUR),A       ;

                        CALL SWITCH_WARNING_ON_3        ; Switch warning on

                        LD A,67                         ; MESSAGE FOR Xargon low
                        CALL GET_MESSAGE_POINTER_3      ;
                        JP SKIP_DISPLAY_FUEL_FULL_3     ;
SKIP_SETTING_FUEL_WARNING_3:


                        ; LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 30                           ; Is fuel depleted?
                        JR NC,SKIP_SETTING_FUEL_WARNING2_3 ; If NOT then skip setting fuel warning

                        LD A,80                         ; Black ink on light red paper
                        LD (FUEL_STATUS_COLOUR),A       ;

                        CALL SWITCH_WARNING_ON_3        ; Switch warning on

                        LD A,64                         ; MESSAGE FOR Xargon depleted
                        CALL GET_MESSAGE_POINTER_3      ;
                        JP SKIP_DISPLAY_FUEL_FULL_3     ;

SKIP_SETTING_FUEL_WARNING2_3:

                        ;  LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 1                            ; Fuel at 1 or below?
                        JR C,FUEL_DEPLETED2_3           ; Out of fuel

                        ;  LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 90                           ;
                        JR C,SKIP_DISPLAY_FUEL_FULL_3   ; If 90 or below then skip Fuel ok


                        LD A,65                         ; MESSAGE FOR Xargon OK
                        CALL GET_MESSAGE_POINTER_3      ;
SKIP_DISPLAY_FUEL_FULL_3:

                        ;  LD C,3                          ; Data is 3 figures
                        LD HL,FUEL_DATA+2               ; Last digit of fuel data

                        LD A,(FUEL)                     ; Get fuel percentage remaining                          ; Setup Loop to call increment data routine
                        LD B,A                          ;
SET_FUEL_LOOP_3:
                        PUSH HL                         ; Save data pointer address
                        ; PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES_3          ; Add 1 to the figure
                        ; POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_FUEL_LOOP_3            ; Jump back until figure is set
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from fuel
TAKE_1_FROM_FUEL_3:
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        OR A                            ; No fuel left at all
                        RET Z                           ; Return if so
                        CP 1                            ; Is it already at 1% or less?
                        JR Z,FUEL_DEPLETED_3            ; Jump to fuel depleted if so
                        DEC A                           ; Take 1 from fuel
                        LD (FUEL),A                     ; Update fuel
                        CALL SET_FUEL_3                 ; Update fuel
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Out of fuel so set game over countdown
FUEL_DEPLETED_3:
                        CALL SET_FUEL_3                 ; Update fuel
FUEL_DEPLETED2_3:

                        LD A,89                         ; MESSAGE FOR Fuel Depleted
                        CALL GET_MESSAGE_POINTER_3      ;

                        CALL SET_GAME_OVER_COUNTER      ; Set game over countdown



                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
                        ; Take 1 from oxygen
DECREMENT_OXYGEN_3:
                        LD A,(OXYGEN)                   ; Get oxygen status
                        CP 0                            ; Is oxygen status 0?
                        JR Z,SKIP_SETTING_OXYGEN_3      ; SKIP_CHANGING_OXYGEN        ; If so then GAME OVER, OUT OF OXYGEN

                        DEC A                           ; Take 1 from oxygen
                        LD (OXYGEN),A                   ; Update oxygen status
                        CALL SET_OXYGEN_3               ; Set oxygen status

                        LD A,15                         ; Message 15 Losing Oxygen
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        RET                             ; Jump to continue
SKIP_SETTING_OXYGEN_3:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,82                         ; Message for oxygen depleted
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        RET                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Set Oxygen status
SET_OXYGEN_3:
                        LD A,(OXYGEN)                   ;

                        CP 20                           ;
                        JR C,SET_OXYGEN_TO_BAD_3        ; If OXYGEN status is above 0 AND BELOW 50 then set to BAD
                        CP 50                           ;
                        JR C,SET_OXYGEN_TO_OK_3         ; If OXYGEN status is above 50 then set to OK

                        CP 90                           ;
                        JR C,SET_OXYGEN_TO_GOOD_3       ; If OXYGEN status is above 90 then set to good

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to oxygen
ADD_1_TO_OXYGEN_3:
                        LD A,(OXYGEN)                   ; Get oxygen percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to oxygen
                        LD (OXYGEN),A                   ; Update oxygen
                        CALL SET_OXYGEN_STATUS_3        ; Set oxygen status
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_OXYGEN_STATUS_3:
; HL=TEXT STRING
                        LD DE,OXYGEN_DATA               ;
                        JP SET_POWER_STATUS_LOOPA_3       ; Jump to set status text

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_OXYGEN_TO_GOOD_3:
                        LD HL,GOOD                      ;
                        JP SET_OXYGEN_STATUS_3          ;

SET_OXYGEN_TO_OK_3:
                        LD HL,OK                        ;
                        JP SET_OXYGEN_STATUS_3          ;

SET_OXYGEN_TO_BAD_3:
                        LD A,14                         ; Message 14 OXYGEN LOW
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        LD HL,BAD                       ;
                        JP SET_OXYGEN_STATUS_3          ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from food
DECREMENT_FOOD_3:
                        LD A,(FOOD)                     ; Get food status
                        CP 0                            ; Is food status 0?
                        JR Z,SKIP_SETTING_FOOD_3        ; If so then GAME OVER, OUT OF FOOD
                        DEC A                           ; Take 1 from food
                        LD (FOOD),A                     ; Update food

                        CALL SET_FOOD_STATUS_3          ;
                        RET                             ; Jump to continue

SKIP_SETTING_FOOD_3:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,81                         ; Message for FOOD depleted
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to oxygen
ADD_1_TO_FOOD_3:
                        LD A,(FOOD)                     ; Get food percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to food
                        LD (FOOD),A                     ; Update food
                        CALL SET_FOOD_STATUS_3          ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FOOD_STATUS_3:
                        LD A,96                         ; Set food to good and diagram status black on bright green
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD DE,FOOD_DATA                 ; Get Good string and add it to string location to display
                        LD HL,GOOD                      ;
                        CALL SET_POWER_STATUS_LOOPA_3     ;


                        LD A,(FOOD)                     ;

                        CP 20                           ;
                        JR C,SET_FOOD_TO_BAD_3          ; If food status is BELOW 20 then set to BAD

                        CP 40                           ;
                        JP C,SET_FOOD_TO_OK_3           ; If food status is BELOW 40 then set to GOOD


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_FOOD_TO_BAD_3:
                        LD A,80                         ; Diagram status black on bright red
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD A,73                         ; Food low message
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL

                        LD DE,FOOD_DATA                 ;
                        LD HL,BAD                       ;
SET_FOOD_CALLBACK_3:
                        ;
                        CALL SET_POWER_STATUS_LOOPA_3     ;
                        CALL SWITCH_WARNING_ON_3        ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_FOOD_TO_OK_3:
                        LD A,112                        ; Diagram status black on bright yellow
                        LD (FOOD_STATUS_COLOUR),A       ;

                        LD A,73                         ; Food low message
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL

                        LD DE,FOOD_DATA                 ;
                        LD HL,OK                        ;
                        JP SET_FOOD_CALLBACK_3          ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
DECREMENT_WATER_3:      ;Take 1 from water              ;
                        LD A,(WATER_STATUS)             ; Get water status

                        CP 0                            ; Is water status 0?
                        JR Z,SKIP_SETTING_WATER_3       ; SKIP_CHANGING_WATER        ; If so then GAME OVER, OUT OF WATER

                        DEC A                           ; Take 1 from water
                        LD (WATER_STATUS),A             ; Update water status
                        CALL SET_WATER_STATUS_3         ; Set water status
                        RET                             ; Jump to continue
SKIP_SETTING_WATER_3:
                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        LD A,83                         ; Message for water depleted
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        RET                             ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to water
ADD_1_TO_WATER_3:
                        LD A,(WATER_STATUS)             ; Get water percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET Z                           ; Return if so
                        INC A                           ; Add 1 to water
                        LD (WATER_STATUS),A             ; Update water
                        CALL SET_WATER_STATUS_3         ; Set water status
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_WATER_STATUS_3:
                        LD A,96                         ; Set water to good and diagram status black on bright green
                        LD (WATER_STATUS_COLOUR),A      ; Set water status colour on status map to black on bright green

                        LD DE,WATER_DATA                ; Point HL to Service menu data for Water
                        LD HL,GOOD                      ; Point HL to "Good" string


                        LD A,(WATER_STATUS)             ;

                        CP 20                           ;
                        JR C,SET_WATER_TO_BAD_3         ; If water status is bellow 20 then set to BAD

                        CP 40                           ;
                        JP C,SET_WATER_TO_OK_3          ; If water status is BELOW 40 then set to OK


                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_WATER_TO_BAD_3:
                        LD A,80                         ; Diagram status black on bright red
                        LD (WATER_STATUS_COLOUR),A      ;

                        LD A,16                         ; Water low message
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        LD DE,WATER_DATA                ;
                        LD HL,BAD                       ;

SET_WATER_CALLBACK_3:   ;
                        CALL SET_POWER_STATUS_LOOPA_3:    ;

                        CALL SWITCH_WARNING_ON_3        ; Switch on warning

                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_WATER_TO_OK_3:
                        LD A,112                        ; Diagram status black on bright yellow
                        LD (WATER_STATUS_COLOUR),A      ;

                        LD A,16                         ; Water low message
                        CALL GET_MESSAGE_POINTER_3      ; Get message into HL
                        LD DE,WATER_DATA                ;
                        LD HL,OK                        ;
                        JP SET_WATER_CALLBACK_3         ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SWITCH_SERVICE_ON_3:
                        LD A,1                          ; A=1 to switch on Warning
                        LD (SET_SERVICE_ON),A           ; Set warning to on
                        RET                             ;
SWITCH_SERVICE_OFF_3:
                        XOR A                           ; A=1 to switch on Warning
                        LD (SET_SERVICE_ON),A           ; Set warning to on
                        LD (SERVICE_ON),A               ;
                        CALL SERVICE_OFF_ON_3             ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Called with SERVICE_ON =colour   0 OR 66  OPTIMIZED
SERVICE_OFF_ON_3:
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to Engine
ADD_1_TO_ENGINE_3:
                        LD A,(ENGINE_STATUS)            ; Get engine status 0 to 100
                        CP 100                          ; Is it at 100?
                        JR Z,SKIP_ADD_1_TO_ENGINE_3     ; If so then do not add any more
                        INC A                           ; Add 1
                        LD (ENGINE_STATUS),A            ; Update engine status
                        CP 80                           ; Is it at 80?
                        JR NZ,SKIP_ADD_TO_ENGINE_SERVICE_3;
                        CALL SWITCH_SERVICE_ON_3        ; If so then switch Service warning on


                        LD A,80                         ; MESSAGE FOR Engine service required
                        CALL GET_MESSAGE_POINTER_3      ;
SKIP_ADD_TO_ENGINE_SERVICE_3:
                        CALL SET_ENGINE_3               ; Set the Engine status
SKIP_ADD_1_TO_ENGINE_3:
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_ENGINE_3:
                        LD A,(ENGINE_STATUS)            ;

                        CP 25                           ;
                        JP C,SET_ENGINE_TO_BAD_3        ; If engine status is above 0 AND BELOW 50 then set to BAD
                        CP 50                           ;
                        JP C,SET_ENGINE_TO_OK_3         ; If engine status is above 50 then set to OK
                        CP 90                           ;
                        JP C,SET_ENGINE_TO_GOOD_3       ; If engine status is above 90 then set to good

                        RET                             ;

SETTING_ENGINE_STATUS_3:
; HL=TEXT STRING
                        LD DE,ENGINE_DATA               ;
                        JP SET_POWER_STATUS_LOOPA_3       ; Jump to set status text

SET_ENGINE_TO_GOOD_3:
                        LD A,96                         ; Set diagram engine status colour to black ink in light green
                        LD (ENGINE_STATUS_COLOUR),A     ;
                        CALL SWITCH_WARNING_OFF_3       ; Switch off warning

                        LD HL,GOOD                      ;
                        JP SETTING_ENGINE_STATUS_3      ;

SET_ENGINE_TO_OK_3:
                        LD A,112                        ; Set diagram engine status colour to black ink in light yellow
                        LD (ENGINE_STATUS_COLOUR),A     ;
                        CALL SWITCH_WARNING_OFF_3       ; Switch off warning
                        LD HL,OK                        ;
                        JP SETTING_ENGINE_STATUS_3      ;

SET_ENGINE_TO_BAD_3:
                        LD A,80                         ; Set diagram engine status colour to black ink in light RED
                        LD (ENGINE_STATUS_COLOUR),A     ;

                        CALL SWITCH_WARNING_ON_3        ; Switch on warning

                        LD HL,BAD                       ;
                        JP SETTING_ENGINE_STATUS_3      ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take temperature value and turn into text form in data
SET_TEMPERATURE_3:

                        CALL RESET_TEMPERATURE_FIGURES_3 ; Set the figures to 000

                        LD A,(TEMPERATURE)              ; Get TEMP
                        ;  LD C,4                          ; Data is 4 figures
                        LD HL,TEMPERATURE_DATA+2        ; Last digit of TEMPERATURE data
                        LD B,A                          ; Setup Loop to call increment data routine
SET_TEMPERATURE_LOOP_3:
                        PUSH HL                         ; Save data pointer address
                        ;  PUSH BC                         ; Save loop
                        CALL INCREMENT_FIGURES_3          ; Add 1 to the figure
                        ;  POP BC                          ; Restore loop
                        POP HL                          ; Restore data pointer
                        DJNZ SET_TEMPERATURE_LOOP_3     ; Jump back until figure is set

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Reset Services Information figures
RESET_SERVICES_FIGURES_3:

; TOTAL HD RESET
                        LD HL,RESET_FIGURES_HD          ;
                        LD DE,HD_DATA                   ;
                        LD BC,8                         ;
                        LDIR                            ;

; SHIELDS RESET
                        LD HL,GOOD                      ;
                        LD DE,SHEILDS_DATA              ;
                        LD BC,4                         ;
                        LDIR                            ;

; TEMPERATURE RESET
                        CALL RESET_TEMPERATURE_FIGURES_3 ;

; FUEL REMAINING RESET  Xargon-3
RESET_FUEL_FIGURES_3:
                        LD HL,RESET_FIGURES             ;
                        LD DE,FUEL_DATA                 ;
                        JP RESET_FIGURES1_3             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RESET_TEMPERATURE_FIGURES_3:
                        ; Reset all three digits of TEMPERATURE to 000
                        LD HL,RESET_FIGURES             ;
                        LD DE,TEMPERATURE_DATA          ;
RESET_FIGURES1_3:
                        LD BC,3                         ;
                        LDIR                            ;
                        RET                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Increment HD
ADD_1_TO_HD_3:
                        LD HL,HD_DATA+6                 ; Last digit of HD data
                        ; LD C,8                          ; Data is 8 figures
                        CALL INCREMENT_FIGURES_3          ; Add 1 to the figure
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Take 1 from HD
TAKE_1_FROM_HD_3:
                        PUSH BC                         ;

                        LD HL,HD_DATA+6                 ; Last digit of HD data
                        PUSH HL                         ; Save address for check
                        CALL DECREMENT_FIGURE           ; Take 1 from figure
                        POP HL                          ; Restore address for check

; Check if all digits are zero
                        LD B,9                          ; Set loop to check for 9 digits
TAKE_1_FROM_HD_CHECK_LOOP_3:

                        LD A,(HL)                       ; Get current digit
                        CP "0"                          ; Is the digit a 0?
                        JR NZ,TOO_MANY_3                  ; Return if not a zero
                        DEC HL                          ; Move to next digit address
                        DJNZ TAKE_1_FROM_HD_CHECK_LOOP_3  ; Jump back to check next digit
; All zeros
                        LD A,90                         ; Message for out of money
                        CALL GET_MESSAGE_POINTERB_3       ; Get message into HL

                        CALL SET_GAME_OVER_COUNTER      ; Set game over to 100 for game over countdown

                        POP BC                          ;
                        RET                             ;

TOO_MANY_3:
                        POP BC                          ;
                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Add 1 to fuel
ADD_1_TO_FUEL_3:
                        LD A,(FUEL)                     ; Get fuel percentage remaining
                        CP 100                          ; Is it already at 100%?
                        RET NC                          ; Return if so
                        INC A                           ; Add 1 to fuel
                        LD (FUEL),A                     ; Update fuel
                        CALL SET_FUEL_3                   ; Update fuel
                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Adds B to HD - Called with B=figure 10 or 100
ADD_B_TO_HD_3:
                        PUSH BC                         ;
                        CALL ADD_1_TO_HD_3                ; Add 1 to HD

                        POP BC                          ;
                        DJNZ ADD_B_TO_HD_3                ; Loop back until B=0
                        RET                             ; Ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_WE_ARE_HIT_STATUSES_3:
; Calls here when we are hit

                        LD A,(SHIELDS_METER_STORE)      ; Get Shields

                        CP 1                            ; Have Sheilds gone?
                        JR NZ,SKIP_SETTING_COCKPIT_STATUS_TO_RED_3 ; Skip setting cockpit status if shields still exist

SKIP_SHIELDS_METER_CHECK_3:
                        LD A,(WE_ARE_HIT)               ; Get We are hit counter


; Cockpit destroyed?
                        CP 25                           ; Have we been hit 25 times?
                        JR NZ,SKIP_SETTING_GAME_OVER_ON_20_HITS_3; If not then skip Cockpit destroyed message and end game countdown

                        LD A,84                         ; Message for Cockpit destroyed
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        CALL SET_GAME_OVER_COUNTER      ; Set game over countdown
                        JP SKIP_SETTING_COCKPIT_STATUS_TO_RED_3; Jump over next checks
SKIP_SETTING_GAME_OVER_ON_20_HITS_3:
; Cockpit critical?
                        CP 20                           ; Have we been hit 20 times?
                        JR NZ,SKIP_SETTING_CRITICAL_ON_20_HITS_3; If not then skip Cockpitsevere damage message and setting to yellow
                        LD A,74                         ; Message for Cockpit severe damage
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        LD A,80                         ; Bright red on black
                        LD (COCKPIT_STATUS_COLOUR),A    ; Set Cockpit status to red
                        CALL SET_COCKPIT_STATUS_3         ; Update Cockpit status
                        JP SKIP_SETTING_COCKPIT_STATUS_TO_RED_3; Jump over next checks

SKIP_SETTING_CRITICAL_ON_20_HITS_3:
                        CP 10                           ; Are we hit more than 10 times?
                        JR NZ,SKIP_SETTING_COCKPIT_STATUS_TO_RED_3; Less than 10 so skip
                        LD A,74                         ; Message for Cockpit severe damage
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        LD A,112                        ; Bright yellow on black
                        LD (COCKPIT_STATUS_COLOUR),A    ; Set Cockpit status to red
                        CALL SET_COCKPIT_STATUS_3         ; Update Cockpit status

SKIP_SETTING_COCKPIT_STATUS_TO_RED_3:
; Check to see if we need to set Oxygen leak status to on
                        LD A,(COCKPIT_STATUS_COLOUR)    ; Get Cockpit status colour
                        CP 80                           ; Is it 80 for red?
                        JR NZ,SKIP_SETTING_OXYGEN_LEAK_TO_ON_3; If not then skip setting Oxygen leak

                        LD A,R                          ; Get random number
                        CP 5                            ; Is it 5?
                        JR NC,SKIP_SETTING_OXYGEN_LEAK_TO_ON_3 ; If not then skip setting oxygen leak
                        LD A,199                        ; Flashing bright white on black
                        LD (23296-16),A                 ; Attr location for icon Set colour

; Set Oxygen leak status to on
                        LD A,1                          ;
                        LD (OXYGEN_LEAK),A              ; Set Oxygen leak to on

                        LD A,(23673)                    ; Get system clock
                        CP 200                          ; Is it at 200 or above?
                        JR C,SKIP_SETTING_OXYGEN_LEAK_TO_ON_3;
                        LD A,85                         ; Message for Oxygen depleted
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        CALL SET_GAME_OVER_COUNTER      ; Set game over countdown if so
                        ;
SKIP_SETTING_OXYGEN_LEAK_TO_ON_3:

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_COCKPIT_STATUS_3:
                        ; LD A,96                         ; Diagram status black on bright green
                        ; LD (COCKPIT_STATUS_COLOUR),A       ;

                        LD DE,COCKPIT_DATA              ;
                        LD HL,GOOD                      ;

                        CALL SET_POWER_STATUS_LOOPA_3     ;

                        LD A,(COCKPIT_STATUS_COLOUR)    ;
                        CP 80                           ;
                        JR Z,SET_COCKPIT_TO_BAD_3         ; If Cockpit status colour on 80 then set to BAD


                        LD A,(COCKPIT_STATUS_COLOUR)    ;
                        CP 112                          ;
                        JR Z,SET_COCKPIT_TO_OK_3          ; If Cockpit status colour on 112 then set to OK
                        RET                             ;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SET_COCKPIT_TO_BAD_3:     ; Severe damage                 ;
                        ; LD A,80                         ; Diagram status black on bright red
                        ; LD (COCKPIT_STATUS_COLOUR),A       ;

                        LD A,84                         ; Cockpit destroyed message
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        LD DE,COCKPIT_DATA              ;
                        LD HL,BAD                       ;

                        ;
                        CALL SET_POWER_STATUS_LOOPA_3     ;

                        CALL SWITCH_WARNING_ON_3        ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_COCKPIT_TO_OK_3:
                        LD A,74                         ; Cockpit Severe damage messag
                        CALL GET_MESSAGE_POINTER_3        ; Get message into HL
                        LD DE,COCKPIT_DATA              ;
                        LD HL,OK                        ;

                        ;
                        CALL SET_POWER_STATUS_LOOPA_3     ;

                        CALL SWITCH_WARNING_ON_3        ; Switch on warning

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_POWER_STATUS_3:
                        LD A,(POWER_STATUS)             ; Get Power status


                        CP 2                            ; Is Power status at 2?
                        JR C,SET_POWER_TO_BAD_3           ; If power status is above 0 AND BELOW 2 then set to BAD
                        CP 5                            ; Is Power status at 2?
                        JR C,SET_POWER_TO_OK_3            ; If Power status is above 5 then set to OK

                        CP 12                           ; Is Power status at 12?
                        JR C,SET_POWER_TO_GOOD_3          ; If Power status is above 12 then set to good

                        RET                             ; Return

SET_POWER_STATUS2_3:
; Update service menu text HL=TEXT STRING
                        LD DE,POWER_DATA                ; DE=Service menu data location for Power status


SET_POWER_STATUS_LOOPA_3:
                        LD B,4                          ;
SET_POWER_STATUS_LOOPX_3:
                        LD A,(HL)                       ;
                        CP 255                          ;
                        RET Z                           ;
                        LD (DE),A                       ;
                        INC DE                          ;
                        INC HL                          ;
                        ;  LD BC,4                         ; 4 characters to update
                        ; LDIR                            ;

                        DJNZ SET_POWER_STATUS_LOOPX_3     ;
                        RET                             ; Return
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SET_POWER_TO_GOOD_3:
                        CALL SWITCH_WARNING_OFF_3       ; Set warning off
                        LD HL,GOOD                      ; Point to "Good" string
                        JP SET_POWER_STATUS2_3            ; Update the service menu with selected text string

SET_POWER_TO_OK_3:

                        CALL SWITCH_WARNING_OFF_3       ; Set warning off
                        LD HL,OK                        ; Point to "OK" string
                        JP SET_POWER_STATUS2_3            ; Update the service menu with selected text string

SET_POWER_TO_BAD_3:

                        CALL SWITCH_WARNING_ON_3        ; Set warning on
                        LD HL,BAD                       ; Point to "Bad" string
                        JP SET_POWER_STATUS2_3            ; Update the service menu with selected text string

                        RET                             ; Return

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Get Sheilds status from meter store and set text to Good,OK,Bad
SET_SHEILDS_3:

                        LD A,(SHIELDS_METER_STORE)      ;
                        CP 10                           ;   Shields between 10 and 13 is good
                        JP NC,SET_SHEILDS_TO_GOOD_3       ;
                        CP 5                            ;   Shields between 5 and 10 is ok
                        JP NC,SET_SHEILDS_TO_OK_3         ;
                        CP 2                            ;   Shields less than 2 is bad
                        JP C,SET_SHEILDS_TO_BAD_3         ;
                        RET                             ;

SET_SHEILDS_STATUS_3:
; HL=TEXT STRING
                        LD DE,SHEILDS_DATA              ;
                        JP SET_POWER_STATUS_LOOPA_3       ; Jump to set status text

SET_SHEILDS_TO_GOOD_3:
                        LD HL,GOOD                      ;
                        JP SET_SHEILDS_STATUS_3           ;

SET_SHEILDS_TO_OK_3:
                        LD HL,OK                        ;
                        JP SET_SHEILDS_STATUS_3           ;

SET_SHEILDS_TO_BAD_3:
                        LD HL,BAD                       ;
                        JP SET_SHEILDS_STATUS_3           ;

                        RET                             ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Clear text screen  - Interference
CLEAR_TEXT_SCREEN_3:
                        LD A,1                          ; A=1 to skip increment graphic in text fill
                        LD (SKIP_INCREMENT),A           ; Set skip increment status
                        LD HL,30                        ;
                        CALL FILL_TEXT_SCREEN           ;

                        LD A,(NORMAL_LCD_COLOUR)        ; Set display to Cyan on black
                        LD (TEXT_COLOUR+1),A            ; Set text colour
                        CALL SET_MAIN_TEXT_DISPLAY_ATTR_3 ; Clear text screen ATTR TO COLOUR SET IN TEXT_COLOUR

                        LD A,70                         ; Bright yellow on black
                        CALL SET_LCD_LED_STATUS_COLOUR  ; Colour the LED on the LCD screen to A
                        RET                             ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
StringEnd3:
Addre3:             equ *-1
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
        if *> 59000                                     ;
                        zeuserror "out of room"         ;
        endif                                           ;

; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



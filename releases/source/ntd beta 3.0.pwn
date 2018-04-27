/********************************************************************
*	Nickk's TextDraw editor											*
*	Release: Beta 3.0												*
*	All right reserved! C By: Nickk888								*
*																	*
*	Credits:														*
*	a_samp: SAMP Team												*
*	zcmd: ZeeX														*
*	dfile: DrAkE													*
*	rgb: Abyss Morgan												*
*	sscanf: Y_Less													*
*	a_http: SAMP Team												*
*																	*
*	YOU ARE NOT ALLOWED TO RECREATE THIS FILTERSCRIPT WITHOUT		*
*	GIVEN ANY CREDITS! DO NOT COPY THIS SCRIPT ELSEWHERE!			*
*********************************************************************/

#include <a_samp>
#include <zcmd>
#include <dfile>
#include <rgb>
#include <sscanf>
#include <a_http>

//SETTINGS
#define SCRIPT_VERSION "v3.0 Beta"
#define SCRIPT_VERSION_CHECK "3.0"
#define MAX_PROJECTS 	50
#define MAX_TDS			500
#define BUTTON_TD_SIZE		35.5
#define BUTTON_TD_SPACER	35.5
#define BUTTON_MINHEIGHT	15
#define BUTTON_MAXHEIGHT	412
#define CHANGING_VAR_TIME 25
#define MAXFORMATEDTD 50
#define BLOCK_VARS_TIME 100
#define CURSOR_COLOR 0xFF0000FF
#define BUTTON_TD_COLOR 0xFFFFFFFF
#define TDPICKER_COLOR_ACTIVE 0x00FF00FF
#define TDPICKER_COLOR 0xFFFFFF55
#define PROJECTLIST_FILEPATH "NTD/ntdlist.list"
#define SETTINGS_FILEPATH "NTD/ntdsettings.ini"

//#define DEBUGMODE

//TEXT
#define CAPTION_TEXT "{00FFFF}Nickk's TD Editor - {00FF00}"

//RESOURCE NAMES
#define WELCOME_SCREEN "NTD_RESOURCES:Welcome_Screen"
#define BUTTON_EXIT "NTD_RESOURCES:Button_Close"
#define BUTTON_SETTINGS "NTD_RESOURCES:Button_Settings"
#define BUTTON_NEW "NTD_RESOURCES:Button_New_Active"
#define BUTTON_OPEN "NTD_RESOURCES:Button_Open_Active"
#define BUTTON_CLOSE "NTD_RESOURCES:Button_Close_Active"
#define BUTTON_EXPORT "NTD_RESOURCES:Button_Export_Active"
#define BUTTON_MANAGE "NTD_RESOURCES:Button_Manage_Active"
#define BUTTON_FONT "NTD_RESOURCES:Button_Font_Active"
#define BUTTON_POSITION "NTD_RESOURCES:Button_Position_Active"
#define BUTTON_SIZE "NTD_RESOURCES:Button_Size_Active"
#define BUTTON_TEKST "NTD_RESOURCES:Button_Tekst_Active"
#define BUTTON_COLOR "NTD_RESOURCES:Button_Color_Active"
#define BUTTON_OUTLINE "NTD_RESOURCES:Button_Outline_Active"
#define BUTTON_SHADOW "NTD_RESOURCES:Button_Shadow_Active"
#define BUTTON_USEBOX "NTD_RESOURCES:Button_UseBox_Active"
#define BUTTON_ALIGNMENT "NTD_RESOURCES:Button_Alligment_Active"
#define BUTTON_SWITCHPUBLIC "NTD_RESOURCES:Button_SwitchPublic_Active"
#define BUTTON_SELECTABLE "NTD_RESOURCES:Button_Selectable_Active"
#define BUTTON_PROPORTIONALITY "NTD_RESOURCES:Button_Proportionality_Active"
#define BUTTON_MPREVIEW "NTD_RESOURCES:Button_MPreview_Active"

//DIALOGS
#define DIALOG_NEW 510
#define DIALOG_OPEN 511
#define DIALOG_MANAGE 512
#define DIALOG_MANAGE2 513
#define DIALOG_FONT 514
#define DIALOG_TEKST 515
#define DIALOG_COLOR1 516
#define DIALOG_COLOR2 517
#define DIALOG_COLOR3 518
#define DIALOG_COLOR4 519
#define DIALOG_COLOR5 520
#define DIALOG_COLOR6 521
#define DIALOG_COLOR7 522
#define DIALOG_WIELKOSC 523
#define DIALOG_OPEN2 524
#define DIALOG_EXPORT 525
#define DIALOG_INFO 526
#define DIALOG_PREVIEWMODEL 527
#define DIALOG_PREVIEWMODEL1 528
#define DIALOG_EXIT 529
#define DIALOG_SETTINGS 530
#define DIALOG_SETTINGSCOLOR 531
#define DIALOG_SETTINGSCOLOR1 532
#define DIALOG_SETTINGRESET 533
#define DIALOG_DELETEPROJECT 534
#define DIALOG_DELETETD 535
#define DIALOG_SPRITES1 536
#define DIALOG_SPRITES2 537
#define DIALOG_MANAGE3 538
#define DIALOG_MANAGE4 539

//SPRITES
#define MAX_SPRITES 100
#define SPRITE_TYPE_0 "FONTS"
#define SPRITE_TYPE_1 "HUD"
#define SPRITE_TYPE_2 "INTRO 1-4"
#define SPRITE_TYPE_3 "LD_BEAT"
#define SPRITE_TYPE_4 "LD_BUM"
#define SPRITE_TYPE_5 "LD_CARD"
#define SPRITE_TYPE_6 "LD_CHAT"
#define SPRITE_TYPE_7 "LD_DRV"
#define SPRITE_TYPE_8 "LD_DUAL"
#define SPRITE_TYPE_9 "LD_GRAV"
#define SPRITE_TYPE_10 "LD_RACE"
#define SPRITE_TYPE_11 "LD_RCE1"
#define SPRITE_TYPE_12 "LD_RCE2"
#define SPRITE_TYPE_13 "LD_RCE3"
#define SPRITE_TYPE_14 "LD_RCE4 & LD_RCE5"
#define SPRITE_TYPE_15 "LD_TATT"
#define SPRITE_TYPE_16 "LOADSCS"
#define SPRITE_TYPE_17 "VEHICLES"


//TEXTDRAWS
new Text:E_Box;
new Text:B_NewProject;
new Text:B_OpenProject;
new Text:B_CloseProject;
new Text:B_Export;
new Text:B_Manage;
new Text:B_Font;
new Text:B_Position;
new Text:B_Size;
new Text:B_Tekst;
new Text:B_Color;
new Text:B_Outline;
new Text:B_Shadow;
new Text:B_UseBox;
new Text:B_Alignment;
new Text:B_SwitchPublic;
new Text:B_Selectable;
new Text:B_Proportionality;
new Text:B_MPreview;
new Text:B_Exit;
new Text:B_Settings;
new Text:WelcomeScreen;

new bool:ScriptActive;

//ARRAYS
new Template[][][] =
{
	{"Zwykly Box", "_ 295.000000 169.000000 1 1 1 0 0.600000 10.300003 -1 255 135 1 298.500000 75.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 135"},
	{"Zegarek", "00:00 577.000000 20.000000 3 1 2 0 0.554166 2.449999 -1 255 50 0 400.000000 17.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Data", "00.00.0000 577.000000 8.000000 3 1 2 0 0.266666 1.299999 -1 255 50 0 400.000000 17.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Niestandardowy Licznik Pieniedzy", "$00000000 496.000000 76.000000 3 0 2 0 0.579166 2.399999 1097458175 255 50 0 400.000000 17.000000 0 1 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Licznik Pojazdu", "~y~NAZWA:_~g~INFERNUS~n~~y~PREDKOSC:_~b~100KM/h~n~~y~ZYCIE:_~r~100~n~~y~PALIWO:_~w~64L 480.000000 316.000000 2 0 1 0 0.229166 1.950000 -1 255 100 1 604.000000 17.000000 0 1 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 100"},
	{"Procentualna Kamizelka", "100% 578.000000 44.000000 2 0 1 0 0.241666 0.900000 -1 255 50 0 400.000000 17.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Procentualne Zycie", "100% 578.000000 66.000000 2 0 1 0 0.241666 0.899999 -1 255 50 0 400.000000 17.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Miejscowosc(Zones.inc)", "NAZWA_MIEJSCOWOSCI 89.000000 322.000000 3 0 1 0 0.233333 1.450000 -293409025 255 30 1 400.000000 129.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 30"},
	{"Podglad Modeli", "Podglad_Modelu 250.000000 150.000000 5 1 0 0 0.600000 2.000000 -1 125 255 0 112.500000 150.000000 0 1 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 125 255"},
	{"Klikalny Przycisk", "MOJ_PRZYCISK 310.000000 211.000000 2 1 1 0 0.258333 1.750000 -1 255 200 1 16.500000 90.500000 1 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 200"},
	{"Sprite", "HUD:radar_burgershot 301.000000 211.000000 4 1 1 0 0.600000 2.000000 -1 255 50 1 17.000000 17.000000 0 1 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 50"},
	{"Pasek stanu Gracza", "ID:_0_I_PING:_14_I_XP:_150/1840_I_LVL:_15_I_K:_64_I_D:_102 319.000000 236.000000 2 1 0 0 0.279166 1.350000 -1 255 101 1 12.000000 640.000000 0 2 1 0 1 1 -10.000000 0.000000 -20.000000 1.000000 255 255 101"}
};

new PremadeColor[][] =
{
	{0x000000FF, "Czarny"},
	{0xFFFFFFFF, "Bialy"},
	{0xD3D3D3FF, "Jasno Szary"},
	{0xBEBEBEFF, "Szary"},
	{0x4D4D4DFF, "Ciemno Szary"},
	{0xC0C0C0FF, "Srebrny"},
	{0xFF0000FF, "Czerwony"},
	{0x8B0000FF, "Ciemno Czerwony"},
	{0xADD8E6FF, "Jasno Niebieski"},
	{0x0000FFFF, "Niebieski"},
	{0x00008bFF, "Granatowy"},
	{0x4169E1FF, "Szlachetno Niebieski"},
	{0x00FFFFFF, "Aqua/Cyan"},
	{0x008B8BFF, "Ciemny Aqua/Cyan"},
	{0x87CEFAFF, "Kolor Nieba"},
	{0x6495EDFF, "Chaber"},
	{0x7CDC00FF, "Jasno Zielony"},
	{0x00FF00FF, "Zielony"},
	{0x008B00FF, "Ciemno Zielony"},
	{0x556B2FFF, "Oliwkowy"},
	{0x32CD32FF, "Limetka"},
	{0xFFFF00FF, "Zolty"},
	{0xFFD700FF, "Zloty"},
	{0xD2691EFF, "Czekoladowy"},
	{0xBDB76BFF, "Ciemna Khaki"},
	{0xFFFFF0FF, "Ivory"},
	{0xE6E6FAFF, "Lawenda"},
	{0xF5F5DCFF, "Beza"},
	{0xFF8000FF, "Pomaranczowy"},
	{0xEE7600FF, "Ciemno Pomaranczowy"},
	{0xFF7F50FF, "Koralowy"},
	{0xA52A2AFF, "Brazowy"},
	{0xEE82EEFF, "Fioletowy"},
	{0x9400D3FF, "Ciemno Fioletowy"},
	{0xFF80FFFF, "Rozowy"},
	{0xFF00FFFF, "Magenta"},
	{0x663399FF, "Purpurowy"},
	{0x9932CCFF, "Orchidea"},
	{0x68228BFF, "Ciemna Orchidea"}
};

new Sprites[][][] =
{
   //ID | LIBRARY | SPRITE
	{0, "FONTS", "font1"},
	{0, "FONTS", "font2"},
	
	{1, "HUD", "arrow"},
	{1, "HUD", "fist"},
	{1, "HUD", "radardisc"},
	{1, "HUD", "radarringplane"},
	{1, "HUD", "radar_airyard"},
	{1, "HUD", "radar_ammugun"},
	{1, "HUD", "radar_barbers"},
	{1, "HUD", "radar_bigsmoke"},
	{1, "HUD", "radar_boatyard"},
	{1, "HUD", "radar_bulldozer"},
	{1, "HUD", "radar_burgershot"},
	{1, "HUD", "radar_cash"},
	{1, "HUD", "radar_catalinapink"},
	{1, "HUD", "radar_centre"},
	{1, "HUD", "radar_cesarviapando"},
	{1, "HUD", "radar_chicken"},
	{1, "HUD", "radar_cj"},
	{1, "HUD", "radar_crash1"},
	{1, "HUD", "radar_datedisco"},
	{1, "HUD", "radar_datedrink"},
	{1, "HUD", "radar_datefood"},
	{1, "HUD", "radar_diner"},
	{1, "HUD", "radar_emmetgun"},
	{1, "HUD", "radar_enemyattack"},
	{1, "HUD", "radar_fire"},
	{1, "HUD", "radar_flag"},
	{1, "HUD", "radar_gangb"},
	{1, "HUD", "radar_gangg"},
	{1, "HUD", "radar_gangn"},
	{1, "HUD", "radar_gangp"},
	{1, "HUD", "radar_gangy"},
	{1, "HUD", "radar_girlfriend"},
	{1, "HUD", "radar_gym"},
	{1, "HUD", "radar_hostpital"},
	{1, "HUD", "radar_impound"},
	{1, "HUD", "radar_light"},
	{1, "HUD", "radar_locosyndicate"},
	{1, "HUD", "radar_maddog"},
	{1, "HUD", "radar_mafiacasino"},
	{1, "HUD", "radar_mcstrap"},
	{1, "HUD", "radar_modgarage"},
	{1, "HUD", "radar_north"},
	{1, "HUD", "radar_ogloc"},
	{1, "HUD", "radar_pizza"},
	{1, "HUD", "radar_police"},
	{1, "HUD", "radar_propertyg"},
	{1, "HUD", "radar_propertyr"},
	{1, "HUD", "radar_qmark"},
	{1, "HUD", "radar_race"},
	{1, "HUD", "radar_runway"},
	{1, "HUD", "radar_ryder"},
	{1, "HUD", "radar_savegame"},
	{1, "HUD", "radar_school"},
	{1, "HUD", "radar_spray"},
	{1, "HUD", "radar_sweet"},
	{1, "HUD", "radar_tattoo"},
	{1, "HUD", "radar_thetruth"},
	{1, "HUD", "radar_toreno"},
	{1, "HUD", "radar_torenoranch"},
	{1, "HUD", "radar_triads"},
	{1, "HUD", "radar_triadscasino"},
	{1, "HUD", "radar_truck"},
	{1, "HUD", "radar_tshirt"},
	{1, "HUD", "radar_waypoint"},
	{1, "HUD", "radar_woozie"},
	{1, "HUD", "radar_zero"},
	{1, "HUD", "sitem16"},
	{1, "HUD", "siterocket"},
	{1, "HUD", "skipicon"},
	
	{2, "INTRO1", "intro1"},
	{2, "INTRO2", "intro2"},
	{2, "INTRO3", "intro3"},
	{2, "INTRO4", "intro4"},
	
	{3, "ld_beat", "chit"},
	{3, "ld_beat", "circle"},
	{3, "ld_beat", "cring"},
	{3, "ld_beat", "cross"},
	{3, "ld_beat", "down"},
	{3, "ld_beat", "downl"},
	{3, "ld_beat", "downr"},
	{3, "ld_beat", "left"},
	{3, "ld_beat", "right"},
	{3, "ld_beat", "square"},
	{3, "ld_beat", "triang"},
	{3, "ld_beat", "up"},
	{3, "ld_beat", "upl"},
	{3, "ld_beat", "upr"},
	
	{4, "ld_bum", "blkdot"},
	{4, "ld_bum", "bum1"},
	{4, "ld_bum", "bum2"},
	
	{5, "ld_card", "cd10c"},
	{5, "ld_card", "cd10d"},
	{5, "ld_card", "cd10h"},
	{5, "ld_card", "cd10s"},
	{5, "ld_card", "cd11c"},
	{5, "ld_card", "cd11d"},
	{5, "ld_card", "cd11h"},
	{5, "ld_card", "cd11s"},
	{5, "ld_card", "cd12c"},
	{5, "ld_card", "cd12d"},
	{5, "ld_card", "cd12h"},
	{5, "ld_card", "cd12s"},
	{5, "ld_card", "cd13c"},
	{5, "ld_card", "cd13d"},
	{5, "ld_card", "cd13h"},
	{5, "ld_card", "cd13s"},
	{5, "ld_card", "cd1c"},
	{5, "ld_card", "cd1d"},
	{5, "ld_card", "cd1h"},
	{5, "ld_card", "cd1s"},
	{5, "ld_card", "cd2c"},
	{5, "ld_card", "cd2d"},
	{5, "ld_card", "cd2h"},
	{5, "ld_card", "cd2s"},
	{5, "ld_card", "cd3c"},
	{5, "ld_card", "cd3d"},
	{5, "ld_card", "cd3h"},
	{5, "ld_card", "cd3s"},
	{5, "ld_card", "cd4c"},
	{5, "ld_card", "cd4d"},
	{5, "ld_card", "cd4h"},
	{5, "ld_card", "cd4s"},
	{5, "ld_card", "cd5c"},
	{5, "ld_card", "cd5d"},
	{5, "ld_card", "cd5h"},
	{5, "ld_card", "cd5s"},
	{5, "ld_card", "cd6c"},
	{5, "ld_card", "cd6d"},
	{5, "ld_card", "cd6h"},
	{5, "ld_card", "cd6s"},
	{5, "ld_card", "cd7c"},
	{5, "ld_card", "cd7d"},
	{5, "ld_card", "cd7h"},
	{5, "ld_card", "cd7s"},
	{5, "ld_card", "cd8c"},
	{5, "ld_card", "cd8d"},
	{5, "ld_card", "cd8h"},
	{5, "ld_card", "cd8s"},
	{5, "ld_card", "cd9c"},
	{5, "ld_card", "cd9d"},
	{5, "ld_card", "cd9h"},
	{5, "ld_card", "cd9s"},
	{5, "ld_card", "cdback"},
	
	{6, "ld_chat", "badchat"},
	{6, "ld_chat", "dpad_64"},
	{6, "ld_chat", "dpad_lr"},
	{6, "ld_chat", "goodcha"},
	{6, "ld_chat", "thumbup"},
	{6, "ld_chat", "thumbdn"},
	
	{7, "ld_drv", "blkdot"},
	{7, "ld_drv", "brboat"},
	{7, "ld_drv", "brfly"},
	{7, "ld_drv", "bronze"},
	{7, "ld_drv", "goboat"},
	{7, "ld_drv", "gold"},
	{7, "ld_drv", "golfly"},
	{7, "ld_drv", "naward"},
	{7, "ld_drv", "nawtxt"},
	{7, "ld_drv", "ribb"},
	{7, "ld_drv", "ribbw"},
	{7, "ld_drv", "silboat"},
	{7, "ld_drv", "silfly"},
	{7, "ld_drv", "silver"},
	{7, "ld_drv", "tvbase"},
	{7, "ld_drv", "tvcorn"},
	
	{8, "ld_dual", "backgnd"},
	{8, "ld_dual", "black"},
	{8, "ld_dual", "dark"},
	{8, "ld_dual", "duality"},
	{8, "ld_dual", "ex1"},
	{8, "ld_dual", "ex2"},
	{8, "ld_dual", "ex3"},
	{8, "ld_dual", "ex4"},
	{8, "ld_dual", "health"},
	{8, "ld_dual", "layer"},
	{8, "ld_dual", "light"},
	{8, "ld_dual", "power"},
	{8, "ld_dual", "rockshp"},
	{8, "ld_dual", "shoot"},
	{8, "ld_dual", "thrustg"},
	{8, "ld_dual", "tvcorn"},
	{8, "ld_dual", "white"},
	
	{9, "ld_grav", "bee1"},
	{9, "ld_grav", "bee2"},
	{9, "ld_grav", "beea"},
	{9, "ld_grav", "bumble"},
	{9, "ld_grav", "exitw"},
	{9, "ld_grav", "exity"},
	{9, "ld_grav", "flwr"},
	{9, "ld_grav", "flwra"},
	{9, "ld_grav", "ghost"},
	{9, "ld_grav", "hiscorew"},
	{9, "ld_grav", "hiscorey"},
	{9, "ld_grav", "hive"},
	{9, "ld_grav", "hon"},
	{9, "ld_grav", "leaf"},
	{9, "ld_grav", "playw"},
	{9, "ld_grav", "playy"},
	{9, "ld_grav", "sky"},
	{9, "ld_grav", "thorn"},
	{9, "ld_grav", "timer"},
	{9, "ld_grav", "tvcorn"},
	{9, "ld_grav", "tvl"},
	{9, "ld_grav", "tvr"},
	
	{10, "ld_race", "race00"},
	{10, "ld_race", "race01"},
	{10, "ld_race", "race02"},
	{10, "ld_race", "race03"},
	{10, "ld_race", "race04"},
	{10, "ld_race", "race05"},
	{10, "ld_race", "race06"},
	{10, "ld_race", "race07"},
	{10, "ld_race", "race08"},
	{10, "ld_race", "race09"},
	{10, "ld_race", "race10"},
	{10, "ld_race", "race11"},
	{10, "ld_race", "race12"},
	
	{11, "ld_rce1", "race00"},
	{11, "ld_rce1", "race01"},
	{11, "ld_rce1", "race02"},
	{11, "ld_rce1", "race03"},
	{11, "ld_rce1", "race04"},
	{11, "ld_rce1", "race05"},
	
	{12, "ld_rce2", "race06"},
	{12, "ld_rce2", "race07"},
	{12, "ld_rce2", "race08"},
	{12, "ld_rce2", "race09"},
	{12, "ld_rce2", "race10"},
	{12, "ld_rce2", "race11"},
	
	{13, "ld_rce3", "race12"},
	{13, "ld_rce3", "race13"},
	{13, "ld_rce3", "race14"},
	{13, "ld_rce3", "race15"},
	{13, "ld_rce3", "race16"},
	{13, "ld_rce3", "race17"},
	
	{14, "ld_rce4", "race18"},
	{14, "ld_rce4", "race19"},
	{14, "ld_rce4", "race20"},
	{14, "ld_rce4", "race21"},
	{14, "ld_rce4", "race22"},
	{14, "ld_rce4", "race23"},
	{14, "ld_rce5", "race24"},
	
	{15, "ld_tatt", "10ls"},
	{15, "ld_tatt", "10ls2"},
	{15, "ld_tatt", "10ls3"},
	{15, "ld_tatt", "10ls4"},
	{15, "ld_tatt", "10ls5"},
	{15, "ld_tatt", "10og"},
	{15, "ld_tatt", "10weed"},
	{15, "ld_tatt", "11dice"},
	{15, "ld_tatt", "11dice2"},
	{15, "ld_tatt", "11ggift"},
	{15, "ld_tatt", "11grov2"},
	{15, "ld_tatt", "11grov3"},
	{15, "ld_tatt", "11grove"},
	{15, "ld_tatt", "11jail"},
	{15, "ld_tatt", "12angel"},
	{15, "ld_tatt", "12bndit"},
	{15, "ld_tatt", "12cross"},
	{15, "ld_tatt", "12dager"},
	{15, "ld_tatt", "12maybr"},
	{15, "ld_tatt", "12myfac"},
	{15, "ld_tatt", "4rip"},
	{15, "ld_tatt", "4spider"},
	{15, "ld_tatt", "4weed"},
	{15, "ld_tatt", "5cross"},
	{15, "ld_tatt", "5cross2"},
	{15, "ld_tatt", "5cross3"},
	{15, "ld_tatt", "5gun"},
	{15, "ld_tatt", "6africa"},
	{15, "ld_tatt", "6aztec"},
	{15, "ld_tatt", "6clown"},
	{15, "ld_tatt", "6crown"},
	{15, "ld_tatt", "7cross"},
	{15, "ld_tatt", "7cross2"},
	{15, "ld_tatt", "7cross3"},
	{15, "ld_tatt", "7mary"},
	{15, "ld_tatt", "8gun"},
	{15, "ld_tatt", "8poker"},
	{15, "ld_tatt", "8sa"},
	{15, "ld_tatt", "8sa2"},
	{15, "ld_tatt", "8sa3"},
	{15, "ld_tatt", "8santos"},
	{15, "ld_tatt", "8westsd"},
	{15, "ld_tatt", "9bullt"},
	{15, "ld_tatt", "9crown"},
	{15, "ld_tatt", "9gun"},
	{15, "ld_tatt", "9gun2"},
	{15, "ld_tatt", "9homby"},
	{15, "ld_tatt", "9rasta"},
	
	{16, "load0uk", "load0uk"},
	{16, "loadsc0", "loadsc0"},
	{16, "loadsc1", "loadsc1"},
	{16, "loadsc10", "loadsc10"},
	{16, "loadsc11", "loadsc11"},
	{16, "loadsc12", "loadsc12"},
	{16, "loadsc13", "loadsc13"},
	{16, "loadsc14", "loadsc14"},
	{16, "loadsc2", "loadsc2"},
	{16, "loadsc3", "loadsc3"},
	{16, "loadsc4", "loadsc4"},
	{16, "loadsc5", "loadsc5"},
	{16, "loadsc6", "loadsc6"},
	{16, "loadsc7", "loadsc7"},
	{16, "loadsc8", "loadsc8"},
	{16, "loadsc9", "loadsc9"},
	
	{17, "vehicle", "plateback1"},
	{17, "vehicle", "plateback2"},
	{17, "vehicle", "plateback3"},
	{17, "vehicle", "vehicleenvmap128"}
	
};
	
//Enums
enum SpriteData
{
	Slibrary[50],
	Sname[50]
}
new SpriteLibrary[MAX_SPRITES][SpriteData];

enum TD
{
	bool:tdCreated,
	bool:UseBox,
	bool:Selectable,
	bool:Proportional,
	Text:tdself,
	Text:tdpicker,
	tdstring[300],
	Float:PosX,
	Float:PosY,
	PrevModel,
	PrevModelC1,
	PrevModelC2,
	Float:PrevRotX,
	Float:PrevRotY,
	Float:PrevRotZ,
	Float:PrevRotZoom,
	Font,
	bool:isPublic,
	OutlineSize,
	ShadowSize,
	Alignment,
	Float:LetterSizeX,
	Float:LetterSizeY,
	Float:BoxSizeX,
	Float:BoxSizeY,
	Color,
	ColorA,
	BGColor,
	BGColorA,
	BoxColor,
	BoxColorA,
	tdhltimer
}
new NTD[MAX_TDS][TD];

enum NTDPlayerData
{
	bool:InEditor,
	bool:ProjectOpened,
	bool:ChangingEditorPosition,
	bool:ChangingPosition,
	bool:ChangingMRotation,
	bool:ChangingMZoom,
	bool:ChangingSize,
	bool:ChangingMColor,
	bool:ChangingAlpha,
	bool:ChangingSprite,
	bool:Accelerate,
	bool:BlockVarsTime,
	SpritePicker,
	SpriteIndex,
	WelcomeScreenColor,
	WelcomeScreenAlpha,
	OnList,
	ProjectID,
	ChangingSizeState,
	ChangingVarsTimer,
	WelcomeTimer,
	CursorTimer,
	ProjectName[128],
	playerIDInEditor,
	ChoosenTDID,
	EditingTDID,
	ChangingMColorState,
	CCombinatorR,
	CCombinatorG,
	CCombinatorB,
	CCombinatorA,
	IsOnPage
}
new NTDPlayer[NTDPlayerData];

enum TDListData
{
	proname[128],
	proid,
	protda,
	prolastmin,
	prolasthour,
	prolastday,
	prolastmonth,
	prolastyear
}
new TDList[MAX_PROJECTS][TDListData];

//OTHERS
new EditorHeight;
new EditorCursorColor;
new EditorButtonsColor;
new EditorFasterKey;
new EditorAcceptKey;
new bool:EditorQuickSelect;
new EditorVersion[10];
new TDAdress[MAX_TDS];

//PUBLICS
public OnFilterScriptInit()
{
	if(dfile_FileExists("/NTD") && dfile_FileExists("/NTD/Exports") && dfile_FileExists("/NTD/Projects"))
	{
		ScriptActive = true;
		printf("\n[NTD]Edytor TextDrawow od Nickk888 %s zostal pomyslnie zinicjalizowany!", SCRIPT_VERSION);
	}
	else
	{
		ScriptActive = false;
		printf("\n[NTD ERROR]Nie mozna bylo odnalezc folder lub foldery!");
		printf("[NTD ERROR]Prosze stworzyc folder 'NTD' wewnatrz 'scriptfiles'!");
		printf("[NTD ERROR]Wewnatrz 'NTD' nalezy stworzyc folder 'Exports' i 'Projects'!");
		printf("[NTD ERROR]Skrypt zostanie zablokowany!\n");
		return 1;
	}
	if(!dfile_FileExists(PROJECTLIST_FILEPATH))
		dfile_Create(PROJECTLIST_FILEPATH);
	if(!dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Create(SETTINGS_FILEPATH);
		dfile_Open(SETTINGS_FILEPATH);
		dfile_WriteFloat("editor_height", BUTTON_MAXHEIGHT);
		dfile_WriteInt("editor_hcolor", CURSOR_COLOR);
		dfile_WriteInt("editor_bcolor", BUTTON_TD_COLOR);
		dfile_WriteInt("editor_fasterkey", KEY_JUMP);
		dfile_WriteInt("editor_acceptkey", KEY_SPRINT);
		dfile_WriteBool("editor_quickselect", true);
		dfile_WriteString("editor_scriptversion", SCRIPT_VERSION_CHECK);
		dfile_SaveFile();
		dfile_CloseFile();
		EditorHeight = BUTTON_MAXHEIGHT;
		EditorCursorColor = CURSOR_COLOR;
		EditorButtonsColor = BUTTON_TD_COLOR;
		EditorFasterKey = KEY_JUMP;
		EditorAcceptKey = KEY_SPRINT;
		EditorQuickSelect = true;
		format(EditorVersion, sizeof EditorVersion, SCRIPT_VERSION_CHECK);
	}
	else LoadConfigurations();
	HTTP(-1, HTTP_GET, "samp-scripters.pl/Nickk888SAMP/ntd_version.txt", "", "HTTPVersionCheck");
	return 1;
}

new tdamount;
new projamount;

public OnPlayerDeath(playerid, killerid)
{
	if(ScriptActive && NTDPlayer[InEditor])
			if(NTDPlayer[playerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if(ScriptActive && NTDPlayer[InEditor])
			if(NTDPlayer[playerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnFilterScriptExit()
{
	for(new i; i <= GetPlayerPoolSize(); i++) 
	{
		if(ScriptActive && NTDPlayer[InEditor])
			if(NTDPlayer[playerIDInEditor] == i)
			{
				cmd_ntd(i, " ");
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
			}
	}
	return 1;
}

CMD:ntd(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(ScriptActive)
		{
			if(NTDPlayer[InEditor] == false)
			{
				LoadConfigurations();
				CreateEditor();
				NTDPlayer[InEditor] = true;
				NTDPlayer[ChangingPosition] = false;
				NTDPlayer[ProjectOpened] = false;
				NTDPlayer[ChangingSize] = false;
				NTDPlayer[ChangingEditorPosition] = false;
				NTDPlayer[ChangingAlpha] = false;
				NTDPlayer[playerIDInEditor] = playerid;
				NTDPlayer[ChoosenTDID] = -1;
				NTDPlayer[EditingTDID] = -1;
				NTDPlayer[ChangingMColorState] = -1;
				NTDPlayer[CursorTimer] = -1;
				NTDPlayer[WelcomeTimer] = -1;
				NTDPlayer[WelcomeScreenAlpha] = -1;
				ShowWelcomeScreen(true);
				TogglePlayerControllable(playerid, false);
				projamount = GetAllProjects();
				if(!strcmp(EditorVersion, SCRIPT_VERSION_CHECK) && !isnull(EditorVersion))
				{
					ShowEditorEx(playerid);
					ShowInfo(playerid, "{FFFFFF}Aby wyjsc z edytora, uzyj komende {00FFFF}/NTD");
				}
				else ShowPlayerDialog(playerid, DIALOG_SETTINGRESET, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Nowa wersja", "{FF0000}Wersja skryptu jest inna niz w pliku konfiguracyjnej!\n{FFFFFF}Chy chcesz przywrocic ustawienia domyslne by wszystkie funkcje poprawnie zadzialaly?", "Tak", "Nie");
					
				for(new i; i < 15; i++)
					SendClientMessage(playerid, -1, " ");
				
				HTTP(playerid, HTTP_GET, "samp-scripters.pl/Nickk888SAMP/ntd_version.txt", "", "HTTPVersionCheck");
			}
			else
			{
				if(NTDPlayer[playerIDInEditor] == playerid)
				{
					SaveConfigurations();
					HideEditor(playerid);
					DestroyEditor();
					NTDPlayer[InEditor] = false;
					NTDPlayer[ChangingPosition] = false;
					NTDPlayer[ChangingSize] = false;
					NTDPlayer[ChangingEditorPosition] = false;
					NTDPlayer[ChangingAlpha] = false;
					NTDPlayer[ChoosenTDID] = -1;
					NTDPlayer[EditingTDID] = -1;
					NTDPlayer[ChangingMColorState] = -1;
					PlayerSelectTD(playerid, false);
					TextDrawDestroy(WelcomeScreen);
					if(NTDPlayer[WelcomeTimer] != -1)
					{
						
						NTDPlayer[WelcomeScreenAlpha] = -1;
						KillTimer(NTDPlayer[WelcomeTimer]);
						NTDPlayer[WelcomeTimer] = -1;
					}
					TogglePlayerControllable(playerid, true);
					SendClientMessage(playerid, -1, "{FF8040}NTD: {FFFFFF}Edytor zostal wylaczony.");
					if(NTDPlayer[ProjectOpened])
					{
						SaveProject();
						for(new i; i < MAX_TDS; i++)
							DestroyTD(i);
						NTDPlayer[ProjectOpened] = false;
					}
				}
				else SendClientMessage(playerid, -1, "{FF8040}NTD: {FF0000}Inny gracz aktualnie korzysta z edytora!");
			}
		}
		else ShowInfo(playerid, "{FF0000}Skrypt zostal zablokowany!\n{FFFFFF}Sprawdz Log serwera aby otrzymac wiecej informacji!");
	}
	else SendClientMessage(playerid, -1, "{FF8040}NTD: {FF0000}Nie jestes uprawniony/a by skorzystac z tej komendy!");
	return 1;
}

forward HTTPVersionCheck(index, response_code, data[]);
public HTTPVersionCheck(index, response_code, data[])
{
    new buffer[128];
    if(response_code == 200) 
    {
        if(strcmp(SCRIPT_VERSION_CHECK, data) && !isnull(data))
		{
			if(index == -1)
			{
				print("[NTD]Istnieje nowsza wersja tego skryptu!");
				format(buffer, sizeof(buffer), "[NTD]Wersja skryptu: %s | Nowa wersja: %s", SCRIPT_VERSION_CHECK, data);
				print(buffer); 
				print("[NTD]Sciagnij najnowsza wersje uzywajac ten link: https://goo.gl/NUh4us");
			}
			else
			{
				SendClientMessage(index, -1, "{FF8040}NTD: {FFFFFF}Istnieje nowsza wersja tego skryptu! Wersja tego skryptu");
				format(buffer, sizeof(buffer), "{FF8040}NTD: {FFFFFF}Wersja tego skryptu: {FF8040}%s{FFFFFF} | Nowa wersja: {FF8040}%s", SCRIPT_VERSION_CHECK, data);
				SendClientMessage(index, -1, buffer);
				SendClientMessage(index, -1, "{FF8040}NTD: {FFFFFF}Sciagnij najnowsza wersje uzywajac ten link: {FF8040}https://goo.gl/NUh4us");
			}
		}
    }
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{		
	if(ScriptActive && NTDPlayer[InEditor])
	{
		if(newkeys & EditorAcceptKey)
		{
			if(NTDPlayer[InEditor])
			{
				if(playerid == NTDPlayer[playerIDInEditor])
				{
					if(NTDPlayer[ChangingPosition] || NTDPlayer[ChangingSize] || NTDPlayer[ChangingMRotation] || 
					NTDPlayer[ChangingMZoom] || NTDPlayer[ChangingMColor] || NTDPlayer[ChangingEditorPosition] || 
					NTDPlayer[ChangingAlpha] || NTDPlayer[ChangingSprite])
					{
						NTDPlayer[ChangingPosition] = false;
						NTDPlayer[ChangingSize] = false;
						NTDPlayer[ChangingMRotation] = false;
						NTDPlayer[ChangingMZoom] = false;
						NTDPlayer[ChangingMColor] = false;
						NTDPlayer[ChangingEditorPosition] = false;
						NTDPlayer[ChangingAlpha] = false;
						NTDPlayer[ChangingSprite] = false;
						ShowEditorEx(playerid);
						KillTimer(NTDPlayer[ChangingVarsTimer]);
						PlayerSelectTD(playerid, true);
					}
				}
			}
		}
		if(newkeys & EditorFasterKey)
		{
			if(NTDPlayer[InEditor] && (NTDPlayer[ChangingPosition] || NTDPlayer[ChangingSize]  || NTDPlayer[ChangingMRotation] 
			|| NTDPlayer[ChangingMZoom] || NTDPlayer[ChangingMColor] || NTDPlayer[ChangingEditorPosition] || 
			NTDPlayer[ChangingAlpha]))
			{
				if(playerid == NTDPlayer[playerIDInEditor])
				{
					NTDPlayer[Accelerate] = true;
				}
			}
		}
		if(oldkeys & EditorFasterKey)
			NTDPlayer[Accelerate] = false;
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(ScriptActive && NTDPlayer[InEditor])
	{
		new string[300], longstring[1000];
		new tdid = NTDPlayer[EditingTDID];
		if(dialogid == DIALOG_SPRITES2)
		{
			if(response)
			{
				new sindex;
				for(new i; i < sizeof Sprites; i++)
				{
					if(Sprites[i][0][0] == listitem)
					{
						format(SpriteLibrary[sindex][Slibrary], 50, Sprites[i][1]); 
						format(SpriteLibrary[sindex][Sname], 50, Sprites[i][2]); 
						sindex++;
					}
				}
				NTDPlayer[SpriteIndex] = sindex;
				NTDPlayer[SpritePicker] = 0;
				NTDPlayer[ChangingSprite] = true;
				NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
				PlayerSelectTD(playerid, false);
				HideEditor(playerid);
			}
			else OnPlayerClickTextDraw(playerid, B_Tekst);
		}
		if(dialogid == DIALOG_SPRITES1)
		{
			if(response)
			{
				if(listitem == 0) //Wpisz recznie
				{
					ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Spritea", "{FFFFFF}Podaj nazwe biblioteki i nazwe spritea.\nPrzyklad: {FF8040}hud:radar_impound", "Potwierdz", "Wroc");
				}
				else if(listitem == 1) //Biblioteka
				{
					strcat(string, SPRITE_TYPE_0"\n");
					strcat(string, SPRITE_TYPE_1"\n");
					strcat(string, SPRITE_TYPE_2"\n");
					strcat(string, SPRITE_TYPE_3"\n");
					strcat(string, SPRITE_TYPE_4"\n");
					strcat(string, SPRITE_TYPE_5"\n");
					strcat(string, SPRITE_TYPE_6"\n");
					strcat(string, SPRITE_TYPE_7"\n");
					strcat(string, SPRITE_TYPE_8"\n");
					strcat(string, SPRITE_TYPE_9"\n");
					strcat(string, SPRITE_TYPE_10"\n");
					strcat(string, SPRITE_TYPE_11"\n");
					strcat(string, SPRITE_TYPE_12"\n");
					strcat(string, SPRITE_TYPE_13"\n");
					strcat(string, SPRITE_TYPE_14"\n");
					strcat(string, SPRITE_TYPE_15"\n");
					strcat(string, SPRITE_TYPE_16"\n");
					strcat(string, SPRITE_TYPE_17);
					ShowPlayerDialog(playerid, DIALOG_SPRITES2, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Spritea", string, "Potwierdz", "Wroc");
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_SETTINGRESET)
		{
			if(response)
			{
				EditorHeight = BUTTON_MAXHEIGHT;
				EditorCursorColor = CURSOR_COLOR;
				EditorButtonsColor = BUTTON_TD_COLOR;
				EditorFasterKey = KEY_JUMP;
				EditorAcceptKey = KEY_SPRINT;
				EditorVersion = SCRIPT_VERSION_CHECK;
				QuickSelectionShow(playerid, true);
				EditorQuickSelect = true;
				DestroyEditor();
				CreateEditor();
				ShowEditorEx(playerid);
				SaveConfigurations();
				PlayerSelectTD(playerid, false);
				ShowInfo(playerid, "{00FF00}Ustawienia zostaly przywrocone!");
			}
			else
			{
				EditorVersion = SCRIPT_VERSION_CHECK;
				ShowEditorEx(playerid);
			}
		}
		if(dialogid == DIALOG_SETTINGSCOLOR1)
		{
			if(response)
			{
				EditorButtonsColor = PremadeColor[listitem + 1][0];
				DestroyEditor();
				CreateEditor();
				ShowEditorEx(playerid);
			}
			else OnPlayerClickTextDraw(playerid, B_Settings);
		}
		if(dialogid == DIALOG_SETTINGSCOLOR)
		{
			if(response)
			{
				EditorCursorColor = PremadeColor[listitem + 1][0];
				ShowEditorEx(playerid);
			}
			else OnPlayerClickTextDraw(playerid, B_Settings);
		}
		if(dialogid == DIALOG_SETTINGS)
		{
			if(response)
			{
				if(listitem == 0) //Pozycja Edytora
				{
					NTDPlayer[ChangingEditorPosition] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
				}
				if(listitem == 1) //Zmien kolor najechania
				{
					for(new i = 1; i < sizeof PremadeColor; i++)
					{
						format(string, sizeof string, "%s%s\n", GetColorRGBA(PremadeColor[i][0]), PremadeColor[i][1]);
						strcat(longstring, string);
					}
					ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru najechania", longstring, "Potwierdz", "Wroc");
				}
				if(listitem == 2) //Zmien kolor przyciskow
				{
					for(new i = 1; i < sizeof PremadeColor; i++)
					{
						format(string, sizeof string, "%s%s\n", GetColorRGBA(PremadeColor[i][0]), PremadeColor[i][1]);
						strcat(longstring, string);
					}
					ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR1, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru przyciskow", longstring, "Potwierdz", "Wroc");
				}
				if(listitem == 3) //Odwroc Shift z Spacja
				{
					new keyA = EditorFasterKey;
					new keyB = EditorAcceptKey;
					EditorFasterKey = keyB;
					EditorAcceptKey = keyA;
					ShowInfo(playerid, "{00FF00}Przyciski zostaly odwrocone!");
				}
				if(listitem == 4) //Szybki wybor
				{
					if(EditorQuickSelect)
					{
						ShowInfo(playerid, "{FFFFFF}Szybki wybor zostal {FF0000}wylaczony!");
						EditorQuickSelect = false;
						QuickSelectionShow(playerid, false);
					}
					else
					{
						ShowInfo(playerid, "{FFFFFF}Szybki wybor zostal {00FF00}wlaczony!");
						EditorQuickSelect = true;
						QuickSelectionShow(playerid, true);
					}
					
				}
				if(listitem == 5) //Ustawienia fabryczne
				{
					ShowPlayerDialog(playerid, DIALOG_SETTINGRESET, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Przywracanie ustawien domyslnych", "{FF0000}Czy jestes pewny/a ze chcesz przywrocic domyslne ustawienia?", "Tak", "Nie");
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_EXIT)
		{
			if(response)
				cmd_ntd(playerid, " ");
			else
				ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_PREVIEWMODEL1)
		{
			if(response)
			{
				if(IsNumeric(inputtext) && strval(inputtext) >= 0)
				{
					NTD[tdid][PrevModel] = strval(inputtext);
					UpdateTD(playerid, tdid);
					ShowEditorEx(playerid);
				}
				else ShowInfo(playerid, "{FF0000}ID modelu jest bledne!");
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_PREVIEWMODEL)
		{
			if(response)
			{
				if(listitem == 0) //Zmien Model
				{
					ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL1, DIALOG_STYLE_INPUT, CAPTION_TEXT"Podglad Modeli", "{FFFFFF}Podaj numer modelu Postaci, Pojazdu lub obiektu.", "Potwierdz", "Wroc");
				}
				if(listitem > 0)
				{
					if(listitem == 1) NTDPlayer[ChangingMRotation] = true;
					else if(listitem == 2) NTDPlayer[ChangingMZoom] = true;
					else if(listitem == 3) NTDPlayer[ChangingMColor] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_INFO) 
			ShowEditorEx(playerid);
		if(dialogid == DIALOG_EXPORT)
		{
			if(response)
			{
				if(ExportProject(NTDPlayer[ProjectName], listitem))
				{
					format(string, sizeof string, "{00FF00}Projekt zostal pomyslnie wyeksportowany!\n{FFFFFF}Projekt wyeksportowany do {00FFFF}scriptfiles / NTD / Exports / %s.pwn", NTDPlayer[ProjectName]);
					ShowInfo(playerid, string);
				}
				else ShowInfo(playerid, "{FF0000}Podczas eksportu wystapil problem...");
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_WIELKOSC)
		{
			if(response)
			{
				NTDPlayer[ChangingSizeState] = listitem;
				NTDPlayer[ChangingSize] = true;
				NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
				PlayerSelectTD(playerid, false);
				HideEditor(playerid);
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_COLOR3)
		{
			if(response)
			{
				new red, green, blue, alpha, color;
				RGBAToHex(PremadeColor[listitem][0],red,green,blue, alpha); 
				#pragma unused alpha
				if(NTDPlayer[ChangingMColorState] == 0) //Tekst Color
				{
					HexToRGBA(color,red,green,blue,NTD[tdid][ColorA]);
					NTD[tdid][Color] = color;
				}
				else if(NTDPlayer[ChangingMColorState] == 1) //BG Color
				{
					HexToRGBA(color,red,green,blue,NTD[tdid][BGColorA]);
					NTD[tdid][BGColor] = color;
				}
				else if(NTDPlayer[ChangingMColorState] == 2) //Box Color
				{
					HexToRGBA(color,red,green,blue,NTD[tdid][BoxColorA]);
					NTD[tdid][BoxColor] = color;
				}
				UpdateTD(playerid, tdid);
				ShowEditorEx(playerid);
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR7)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorA] = strval(inputtext);
						new ccolor;
						HexToRGBA(ccolor,NTDPlayer[CCombinatorR],NTDPlayer[CCombinatorG],NTDPlayer[CCombinatorB],NTDPlayer[CCombinatorA]);
						if(NTDPlayer[ChangingMColorState] == 0) //Tekst Color
						{
							NTD[tdid][Color] = ccolor;
							NTD[tdid][ColorA] = NTDPlayer[CCombinatorA];
							UpdateTD(playerid, tdid);
						}
						else if(NTDPlayer[ChangingMColorState] == 1) //BG Color
						{
							NTD[tdid][BGColor] = ccolor;
							NTD[tdid][BGColorA] = NTDPlayer[CCombinatorA];
							UpdateTD(playerid, tdid);
						}
						else if(NTDPlayer[ChangingMColorState] == 2) //Box Color
						{
							NTD[tdid][BoxColor] = ccolor;
							NTD[tdid][BoxColorA] = NTDPlayer[CCombinatorA];
							UpdateTD(playerid, tdid);
						}
						ShowEditorEx(playerid);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR6)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorB] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR5)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorG] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR4)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorR] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR2)
		{
			if(response)
			{
				if(listitem == 0) //Gotowe kolory
				{
					for(new i; i < sizeof PremadeColor; i++)
					{
						format(string, sizeof string, "%s%s\n", GetColorRGBA(PremadeColor[i][0]), PremadeColor[i][1]);
						strcat(longstring, string);
					}
					ShowPlayerDialog(playerid, DIALOG_COLOR3, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", longstring, "Potwierdz", "Wroc");
				}
				else if(listitem == 1) //Kombinator
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
				else if(listitem == 2) //Przezroczystosc
				{
					NTDPlayer[ChangingAlpha] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
			}
			else ColorDialog(playerid, 0);
		}
		if(dialogid == DIALOG_COLOR1)
		{
			if(response)
			{
				if(listitem == 0) //Tekst kolor
				{
					NTDPlayer[ChangingMColorState] = 0;
					ColorDialog(playerid, 1);
				}
				else if(listitem == 1) //Kolor tla
				{
					NTDPlayer[ChangingMColorState] = 1;
					ColorDialog(playerid, 1);
				}
				else if(listitem == 2) //Box Color
				{
					NTDPlayer[ChangingMColorState] = 2;
					ColorDialog(playerid, 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_TEKST)
		{
			if(response)
			{
				if(strlen(inputtext))
				{
					format(NTD[tdid][tdstring], 300, inputtext);
					TextDrawDestroy(NTD[tdid][tdself]);
					TextDrawDestroy(NTD[tdid][tdpicker]);
					DrawTD(tdid);
					ShowEditorEx(playerid);
				}
				else ShowEditorEx(playerid);
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_MANAGE2)
		{
			if(response)
			{
				if(listitem == 0) //Modyfikuj
				{
					SelectTD(playerid, NTDPlayer[ChoosenTDID]);
					ShowEditorEx(playerid);
				}
				else if(listitem == 1) //Zklonuj
				{
					tdid = CreateNewTD(NTDPlayer[ChoosenTDID]);
					if(tdid != -1)
					{
						DrawTD(tdid);
						SelectTD(playerid, tdid);
						format(string, sizeof string, "~y~ZKLONOWANO_ID_~r~%i", NTDPlayer[ChoosenTDID]);
						GameTextForPlayer(playerid, string, 5000, 6);
						PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
						ShowEditorEx(playerid, true);
					}
					else ShowInfo(playerid, "Osiagnieto maksymalna ilosc tekstdrawow!");
				}
				else if(listitem == 2) //Usun
				{
					new formatedtd[MAXFORMATEDTD];
					format(formatedtd, MAXFORMATEDTD, NTD[NTDPlayer[ChoosenTDID]][tdstring]);
					if(strlen(NTD[NTDPlayer[ChoosenTDID]][tdstring]) > MAXFORMATEDTD - 4)
					{
						strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
						strcat(formatedtd, "...");
					}
					format(string, sizeof string, "{FF0000}Czy jestes pewny/a ze chcesz usunac ten TextDraw?\n{FFFFFF}Tekst: {00FF00}\x22%s\x22", formatedtd);
					ShowPlayerDialog(playerid, DIALOG_DELETETD, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Usuwanie", string, "Tak", "Nie");
				}
				
			}
			else ShowEditorEx(playerid, true);
		}
		if(dialogid == DIALOG_DELETETD)
		{
			if(response)
			{
				DestroyTD(NTDPlayer[ChoosenTDID]);
				GetAllTD();
				if(NTDPlayer[EditingTDID] == NTDPlayer[ChoosenTDID])
					NTDPlayer[EditingTDID] = -1;
				format(string, sizeof string, "~r~USUNIETO_ID_%i", NTDPlayer[ChoosenTDID]);
				GameTextForPlayer(playerid, string, 5000, 6);
				PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
				ShowEditorEx(playerid, true);
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_MANAGE4)
		{
			if(response)
			{
				tdid = CreateNewTDFromTemplate(listitem);
				if(tdid != -1)
				{
					DrawTD(tdid);
					SelectTD(playerid, tdid);
					format(string, sizeof string, "~g~STWORZONO_NOWY_TEXTDRAW_~r~%i", tdid);
					GameTextForPlayer(playerid, string, 5000, 6);
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid, true);
				}
				else ShowInfo(playerid, "Osiagnieto maksymalna ilosc tekstdrawow!");
			}
			else ShowEditorEx(playerid, true);
		}
		if(dialogid == DIALOG_MANAGE3)
		{
			if(response)
			{
				if(listitem == 0) //Zwykly
				{
					tdid = CreateNewTD();
					if(tdid != -1)
					{
						DrawTD(tdid);
						SelectTD(playerid, tdid);
						PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
						format(string, sizeof string, "~g~STWORZONO_NOWY_TEXTDRAW");
						GameTextForPlayer(playerid, string, 5000, 6);
					}
					else ShowInfo(playerid, "Osiagnieto maksymalna ilosc tekstdrawow!");
				}
				else if(listitem == 1) //Uzyj Szablon
				{
					for(new i; i < sizeof Template; i++)
					{
						format(string, sizeof string, "{FF8040}%s\n", Template[i][0]);
						strcat(longstring, string);
					}
					ShowPlayerDialog(playerid, DIALOG_MANAGE4, DIALOG_STYLE_LIST, CAPTION_TEXT"Uzyj Szablon", longstring, "Wybierz", "Wroc");
				}
			}
			else ShowEditorEx(playerid, true);
		}
		if(dialogid == DIALOG_MANAGE)
		{
			if(response)
			{
				if(listitem == 0) //Stworz nowy TD
				{
					ShowPlayerDialog(playerid, DIALOG_MANAGE3, DIALOG_STYLE_LIST,  CAPTION_TEXT"Nowy TextDraw", "{FFFFFF}Zwykly\n{FF8800}Uzyj szablon", "Potwierdz", "Wroc");
				}
				else if(listitem > 0 && listitem < 11) //TDS
				{
					listitem = (listitem - 1) + (10 * NTDPlayer[IsOnPage]);
					ShowTDOptions(TDAdress[listitem]);
					
				}
				else if(listitem == 11)
				{
					OpenTDDialog(playerid, NTDPlayer[IsOnPage] + 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_OPEN2)
		{
			if(response)
			{
				if(listitem == 0) //Wczytaj
				{
					if(LoadProject(NTDPlayer[ProjectName]))
					{
						format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal pomyslnie zaladowany!", NTDPlayer[ProjectName]);
						ShowInfo(playerid, string);
						ShowEditorEx(playerid);
						ShowWelcomeScreen(false);
					}
					else ShowInfo(playerid, "{FF0000}Podczas zaladowania projektu wystapil problem!");
				}
				else if(listitem == 1) //Usun
				{
					ShowPlayerDialog(playerid, DIALOG_DELETEPROJECT, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Usuwanie", "{FF0000}Czy jestes pewny/a ze chcesz usunac ten Projekt?", "Tak", "Nie");
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_OPEN)
		{
			if(response)
			{
				if(listitem < 10)
				{
					new lister;
					if(NTDPlayer[IsOnPage] > 0) lister = (listitem + (NTDPlayer[IsOnPage] * 10));
					else lister = listitem;
					format(NTDPlayer[ProjectName], 128, TDList[lister][proname]);
					NTDPlayer[ProjectID] = TDList[lister][proid];
					ShowPlayerDialog(playerid, DIALOG_OPEN2, DIALOG_STYLE_LIST, CAPTION_TEXT"Projekty", "{FFFFFF}Wczytaj\n{FF0000}Usun", "Potwierdz", "Wroc");
				}
				else if(listitem == 10)
				{
					OpenProjectDialog(playerid, NTDPlayer[IsOnPage] + 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_DELETEPROJECT)
		{
			if(response)
			{
				if(DeleteProject(NTDPlayer[ProjectName]))
				{
					format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal usuniety!", NTDPlayer[ProjectName]);
					ShowInfo(playerid, string);
				}
				else ShowInfo(playerid, "{FF0000}Podczas usuwania projektu wystapil problem!");
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_NEW)
		{
			if(response)
			{
				format(NTDPlayer[ProjectName], 128, inputtext);
				if(strlen(NTDPlayer[ProjectName]) > 0 && strlen(NTDPlayer[ProjectName]) < 40)
				{
					new pid = CreateProject(NTDPlayer[ProjectName]);
					if(pid != -1)
					{
						NTDPlayer[ProjectID] = pid;
						LoadProject(NTDPlayer[ProjectName]);
						format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal pomyslnie stworzony!", NTDPlayer[ProjectName]);
						ShowInfo(playerid, string);
						ShowWelcomeScreen(false);
					}
					else ShowInfo(playerid, "{FF0000}Taki projekt juz istnieje!");
				}
				else ShowInfo(playerid, "{FF0000}Nazwa jest za krotka lub za dluga!");
			}
			else ShowEditorEx(playerid);
		}
	}
	return 0;
}

forward ChangingVarsTime();
public ChangingVarsTime()
{
	new tdid = NTDPlayer[EditingTDID];
	new bool:varupdated;
	new Keys,ud,lr;
	new string[80];
	new playerid = NTDPlayer[playerIDInEditor];
    GetPlayerKeys(playerid,Keys,ud,lr);
	
	if(NTDPlayer[BlockVarsTime] == false)
	{
		if(ud == KEY_UP)
		{
			varupdated = true;
			if(NTDPlayer[ChangingSprite] == true)
			{
				NTDPlayer[SpritePicker]++;
				if(NTDPlayer[SpritePicker] > (NTDPlayer[SpriteIndex] - 1))
					NTDPlayer[SpritePicker] = 0;
				new SP = NTDPlayer[SpritePicker];
				format(string, sizeof string, "%s:%s", SpriteLibrary[SP][Slibrary], SpriteLibrary[SP][Sname]);
				format(NTD[tdid][tdstring], 128, string);
				BlockVarsChanger(true);
			}
			else if(NTDPlayer[ChangingAlpha] == true)
			{
				if(NTDPlayer[ChangingMColorState] == 0) //Tekst
					if(!NTDPlayer[Accelerate]) NTD[tdid][ColorA] += 1;	
					else NTD[tdid][ColorA] += 10;	
				if(NTDPlayer[ChangingMColorState] == 1) //Tlo
					if(!NTDPlayer[Accelerate]) NTD[tdid][BGColorA] += 1;
					else NTD[tdid][BGColorA] += 10;
				if(NTDPlayer[ChangingMColorState] == 2) //Box
					if(!NTDPlayer[Accelerate]) NTD[tdid][BoxColorA] += 1;
					else NTD[tdid][BoxColorA] += 10;
			}
			else if(NTDPlayer[ChangingEditorPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					EditorHeight -= 1;
				else 
					EditorHeight -= 10;
			}
			else if(NTDPlayer[ChangingPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					NTD[tdid][PosY] -= 1.0;
				else 
					NTD[tdid][PosY] -= 10.0;
			}	
			else if(NTDPlayer[ChangingSize] == true)
			{
				if(!NTDPlayer[Accelerate]) 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeY] -= 0.05; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeY] -= 0.5; 
				} 
				else 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeY] -= 0.5; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeY] -= 5.0; 
				}
			}	
			else if(NTDPlayer[ChangingMRotation] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					NTD[tdid][PrevRotX] += 1.0;
				else 
					NTD[tdid][PrevRotY] += 1.0;
			}
			else if(NTDPlayer[ChangingMZoom] == true)
			{
				if(NTDPlayer[Accelerate]) 
					NTD[tdid][PrevRotZoom] -= 0.1;
				else 
					NTD[tdid][PrevRotZoom] -= 0.01;
			}
			else if(NTDPlayer[ChangingMColor] == true)
			{
				if(NTDPlayer[Accelerate]) 
					NTD[tdid][PrevModelC2] ++;
				else 
					NTD[tdid][PrevModelC1] ++;
			}
		}
		else if(ud == KEY_DOWN)
		{
			varupdated = true;
			if(NTDPlayer[ChangingSprite] == true)
			{
				NTDPlayer[SpritePicker]--;
				if(NTDPlayer[SpritePicker] < 0)
					NTDPlayer[SpritePicker] = (NTDPlayer[SpriteIndex] - 1);
				new SP = NTDPlayer[SpritePicker];
				format(string, sizeof string, "%s:%s", SpriteLibrary[SP][Slibrary], SpriteLibrary[SP][Sname]);
				format(NTD[tdid][tdstring], 128, string);
				BlockVarsChanger(true);
			}
			else if(NTDPlayer[ChangingAlpha] == true)
			{
				if(NTDPlayer[ChangingMColorState] == 0) //Tekst
					if(!NTDPlayer[Accelerate]) NTD[tdid][ColorA] -= 1;	
					else NTD[tdid][ColorA] -= 10;	
				if(NTDPlayer[ChangingMColorState] == 1) //Tlo
					if(!NTDPlayer[Accelerate]) NTD[tdid][BGColorA] -= 1;
					else NTD[tdid][BGColorA] -= 10;
				if(NTDPlayer[ChangingMColorState] == 2) //Box
					if(!NTDPlayer[Accelerate]) NTD[tdid][BoxColorA] -= 1;
					else NTD[tdid][BoxColorA] -= 10;
			}
			else if(NTDPlayer[ChangingEditorPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					EditorHeight += 1;
				else 
					EditorHeight += 10;
			}
			else if(NTDPlayer[ChangingPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					NTD[tdid][PosY] += 1.0;
				else
					NTD[tdid][PosY] += 10.0;
			}	
			else if(NTDPlayer[ChangingSize] == true)
			{
				if(!NTDPlayer[Accelerate]) 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeY] += 0.05; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeY] += 0.5; 
				} 
				else 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeY] += 0.5; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeY] += 5.0; 
				}
			}
			else if(NTDPlayer[ChangingMRotation] == true)
			{
				if(!NTDPlayer[Accelerate])
					NTD[tdid][PrevRotX] -= 1.0;
				else 
					NTD[tdid][PrevRotY] -= 1.0;
			}
			else if(NTDPlayer[ChangingMZoom] == true)
			{
				if(NTDPlayer[Accelerate]) 
					NTD[tdid][PrevRotZoom] += 0.1;
				else 
					NTD[tdid][PrevRotZoom] += 0.01;
			}
			else if(NTDPlayer[ChangingMColor] == true)
			{
				if(NTDPlayer[Accelerate]) 
					NTD[tdid][PrevModelC2] --;
				else 
					NTD[tdid][PrevModelC1] --;
			}
		}
		if(lr == KEY_LEFT)
		{
			varupdated = true;
			if(NTDPlayer[ChangingPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					NTD[tdid][PosX] -= 1.0; 
				else
					NTD[tdid][PosX] -= 10.0; 
			}	
			else if(NTDPlayer[ChangingSize] == true)
			{
				if(!NTDPlayer[Accelerate]) 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeX] -= 0.05 / 12; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeX] -= 0.5; 
				} 
				else 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeX] -= 0.5 / 12; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeX] -= 5.0; 
				}
			}
			else if(NTDPlayer[ChangingMRotation] == true)
			{
				if(!NTDPlayer[Accelerate])
					NTD[tdid][PrevRotZ] -= 1.0;
			}
		}
		else if(lr == KEY_RIGHT)
		{
			varupdated = true;
			if(NTDPlayer[ChangingPosition] == true)
			{
				if(!NTDPlayer[Accelerate]) 
					NTD[tdid][PosX] += 1.0; 	
				else 
					NTD[tdid][PosX] += 10.0; 
			}	
			else if(NTDPlayer[ChangingSize] == true)
			{
				if(!NTDPlayer[Accelerate]) 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeX] += 0.05 / 12; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeX] += 0.5; 
				} 
				else 
				{
					if(NTDPlayer[ChangingSizeState] == 0) 
						NTD[tdid][LetterSizeX] += 0.5 / 12; 
					else if(NTDPlayer[ChangingSizeState] == 1) 
						NTD[tdid][BoxSizeX] += 5.0; 
				}
			}
			else if(NTDPlayer[ChangingMRotation] == true)
			{
				if(!NTDPlayer[Accelerate])
					NTD[tdid][PrevRotZ] += 1.0;
			}
		}
	}
	// // // // //
	
	if(NTDPlayer[ChangingAlpha] == true)
	{
		
		if(NTDPlayer[ChangingMColorState] == 0) //Tekst
		{		
			NTD[tdid][ColorA] = clamp(NTD[tdid][ColorA], 0, 255);
			format(string, sizeof string, "~w~Przezroczystosc:~y~%i~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][ColorA]);
		}
		else if(NTDPlayer[ChangingMColorState] == 1) //Tlo
		{
			NTD[tdid][BGColorA] = clamp(NTD[tdid][BGColorA], 0, 255);
			format(string, sizeof string, "~w~Przezroczystosc:~y~%i~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][BGColorA]);
		}
		else if(NTDPlayer[ChangingMColorState] == 2) //Box
		{
			NTD[tdid][BoxColorA] = clamp(NTD[tdid][BoxColorA], 0, 255);
			format(string, sizeof string, "~w~Przezroczystosc:~y~%i~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][BoxColorA]);
		}
	}
	else if(NTDPlayer[ChangingEditorPosition] == true)
	{
		EditorHeight = clamp(EditorHeight, BUTTON_MINHEIGHT, BUTTON_MAXHEIGHT);
		format(string, sizeof string, "~w~Wysokosc:~y~%i~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", EditorHeight);
	}
	else if(NTDPlayer[ChangingMColor] == true)
	{
		NTD[tdid][PrevModelC1] = clamp(NTD[tdid][PrevModelC1], 0, 255);
		NTD[tdid][PrevModelC2] = clamp(NTD[tdid][PrevModelC2], 0, 255);
		format(string, sizeof string, "~w~Kolor 1:~y~%d ~w~Kolor 2:~y~%d ~n~~p~SHIFT=Kolor 2 SPACJA=Zakoncz", NTD[tdid][PrevModelC1], NTD[tdid][PrevModelC2]);
	}	
	else if(NTDPlayer[ChangingPosition] == true)
		format(string, sizeof string, "~w~X:~y~%.1f ~w~Y:~y~%.1f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][PosX], NTD[tdid][PosY]);
	else if(NTDPlayer[ChangingMRotation] == true)
	{
		if(NTD[tdid][PrevRotX] > 360 || NTD[tdid][PrevRotX] < -360) NTD[tdid][PrevRotX] = 0.0;
		if(NTD[tdid][PrevRotY] > 360 || NTD[tdid][PrevRotY] < -360) NTD[tdid][PrevRotY] = 0.0;
		if(NTD[tdid][PrevRotZ] > 360 || NTD[tdid][PrevRotZ] < -360) NTD[tdid][PrevRotZ] = 0.0;
		format(string, sizeof string, "~w~X:~y~%.1f ~w~Y:~y~%.1f ~w~Z:~y~%.1f~n~~p~SHIFT=Koordynaty Y SPACJA=Zakoncz", NTD[tdid][PrevRotX], NTD[tdid][PrevRotY], NTD[tdid][PrevRotZ]);
	}
	else if(NTDPlayer[ChangingMZoom] == true)
	{
		if(NTD[tdid][PrevRotZoom] < 0) NTD[tdid][PrevRotZoom] = 0.0;
		if(NTD[tdid][PrevRotZoom] > 15) NTD[tdid][PrevRotZoom] = 15.0;
		format(string, sizeof string, "~w~Zblizenie:~y~%.2f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][PrevRotZoom]);
	}
	else if(NTDPlayer[ChangingSize] == true) {
		if(NTDPlayer[ChangingSizeState] == 0) format(string, sizeof string, "~w~X:~y~%.5f ~w~Y:~y~%.5f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][LetterSizeX], NTD[tdid][LetterSizeY]);
		else if(NTDPlayer[ChangingSizeState] == 1) format(string, sizeof string, "~w~X:~y~%.5f ~w~Y:~y~%.5f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][BoxSizeX], NTD[tdid][BoxSizeY]);
	}
	else if(NTDPlayer[ChangingSprite] == true) {
		format(string, sizeof string, "~w~Sprite: ~y~%s~n~~w~(~g~ID: %i~w~)~n~~p~SPACJA=Zakoncz", NTD[tdid][tdstring], NTDPlayer[SpritePicker]);
	}
	GameTextForPlayer(playerid, string, 200, 4);
	if(varupdated)
	{
		if(NTDPlayer[ChangingEditorPosition] == false)
		{
			if(NTDPlayer[ChangingPosition] == true || NTDPlayer[ChangingSprite] == true) 
			{
				TextDrawDestroy(NTD[tdid][tdself]);
				TextDrawDestroy(NTD[tdid][tdpicker]);
				DrawTD(tdid);
			}
			else UpdateTD(playerid, tdid);
		}
		else
		{
			DestroyEditor();
			CreateEditor();
			ShowEditorEx(playerid, false);
		}
	}
	return 1;
}


public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(ScriptActive && NTDPlayer[InEditor])
	{
		new string[300];
		new tdid = NTDPlayer[EditingTDID];
		if(NTDPlayer[ProjectOpened] && EditorQuickSelect)
		{
			new pool = GetTDPoolSize();
			for(new i; i <= pool; i++)
			{
				if(clickedid == NTD[i][tdpicker])
				{
					if(SelectTD(playerid, i) == 0)
					{
						ShowTDOptions(i);
					}
					return 1;
				}
				 
			}
		}
		if(clickedid == B_Exit)
		{
			ShowPlayerDialog(playerid, DIALOG_EXIT, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Wyjscie", "{FF5500}Czy jestes pewny/a ze chcesz wyjsc z edytora?\n{FFFFFF}Otwarte projekty zostana automatycznie zapisywane!", "Tak", "Nie");
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Settings)
		{
			new invertedstr[40], quickselectstr[30];
			if(EditorAcceptKey == KEY_JUMP && EditorFasterKey == KEY_SPRINT)
				invertedstr = "{FFFFFF}[{FFFF00}ODWROCONE{FFFFFF}]";
				
			if(EditorQuickSelect) quickselectstr = "{00FF00}Wlaczony{FFFFFF}";
			else quickselectstr = "{FF0000}Wylaczony{FFFFFF}";
			format(string, sizeof string, "{FFFFFF}Zmien pozycje edytora\nZmien kolor najechania\nZmien kolor przyciskow\nOdwroc Shift z Spacja %s\nSzybki wybor: [%s]\n{FF0000}Przywroc ustawienia domyslne", invertedstr, quickselectstr);
			ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_LIST, CAPTION_TEXT"Ustawienia Edytora", string, "Wybierz", "Wroc");
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_MPreview)
		{
			if(NTD[tdid][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			{
				ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL, DIALOG_STYLE_LIST, CAPTION_TEXT"Podglad Modeli", "{FF5500}Zmien ID Modelu\n{FF80FF}Zmien Rotacje\n{FF5500}Zmien Przyblizenie\n{FF80FF}Zmien kolor modelu pojazdu", "Wybierz", "Wroc");
				PlayerSelectTD(playerid, false);
			}
			else ShowInfo(NTDPlayer[playerIDInEditor], "{FF0000}Aby uzyc ta opcje, zmien Czcionke na 5!"), PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Proportionality)
		{
			
			if(NTD[tdid][Proportional] == false)
				NTD[tdid][Proportional] = true,
				GameTextForPlayer(playerid, "~g~PROPORCJONALNY", 1500, 6);
			else
				NTD[tdid][Proportional] = false,
				GameTextForPlayer(playerid, "~r~NIE PROPORCJONALNY", 1500, 6);
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Alignment)
		{
			if(NTD[tdid][Alignment] == 3)
				NTD[tdid][Alignment] = 0;
			
			NTD[tdid][Alignment]++;
			UpdateTD(playerid, tdid);
			if(NTD[tdid][Alignment] == 1) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~y~Do lewej", 1500, 6);
			else if(NTD[tdid][Alignment] == 2) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~g~Do srodka", 1500, 6);
			else if(NTD[tdid][Alignment] == 3) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~r~Do prawej", 1500, 6);
			return 1;
		}
		else if(clickedid == B_SwitchPublic)
		{
			if(NTD[tdid][isPublic] == false)
				NTD[tdid][isPublic] = true,
				GameTextForPlayer(playerid, "~g~Publiczny", 1500, 6);
			else
				NTD[tdid][isPublic] = false,
				GameTextForPlayer(playerid, "~b~Dla Gracza", 1500, 6);
			return 1;
		}
		else if(clickedid == B_Selectable)
		{
			if(NTD[tdid][Selectable] == false)
				NTD[tdid][Selectable] = true,
				GameTextForPlayer(playerid, "~w~Klikalny: ~g~Tak", 1500, 6);
			else
				NTD[tdid][Selectable] = false,
				GameTextForPlayer(playerid, "~w~Klikalny: ~r~Nie", 1500, 6);
			
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Shadow)
		{
			if(NTD[tdid][ShadowSize] == 4)
				NTD[tdid][ShadowSize] = -1;
			
			NTD[tdid][ShadowSize]++;
			UpdateTD(playerid, tdid);
			format(string, sizeof string, "~w~Wielkosc cienia~n~~y~%i", NTD[tdid][ShadowSize]);
			GameTextForPlayer(playerid, string, 1500, 6);
			return 1;
		}
		else if(clickedid == B_UseBox)
		{
			if(NTD[tdid][UseBox] == false)
				NTD[tdid][UseBox] = true,
				GameTextForPlayer(playerid, "~w~Box: ~g~Wl", 1500, 6);
			else
				NTD[tdid][UseBox] = false,
				GameTextForPlayer(playerid, "~w~Box: ~r~Wyl", 1500, 6);
			
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Outline)
		{
			if(NTD[tdid][OutlineSize] == 4)
				NTD[tdid][OutlineSize] = -1;
			
			NTD[tdid][OutlineSize]++;
			UpdateTD(playerid, tdid);
			format(string, sizeof string, "~w~Grubosc obramowania~n~~y~%i", NTD[tdid][OutlineSize]);
			GameTextForPlayer(playerid, string, 1500, 6);
			return 1;
		}
		else if(clickedid == B_Color)
		{
			ColorDialog(playerid, 0);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Tekst)
		{
			if(NTD[tdid][Font] != 4 && NTD[tdid][Font] != 5) ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Tekstu", "{FFFFFF}Podaj nowy tekst ktory zostanie ustawiony...", "Potwierdz", "Wroc");
			else if(NTD[tdid][Font] == 4) ShowPlayerDialog(playerid, DIALOG_SPRITES1, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Spritea", "{FF8040}Wpisz recznie\n{FF5500}Wybierz z biblioteki", "Potwierdz", "Wroc");
			else if(NTD[tdid][Font] == 5) ShowInfo(playerid, "{FF0000}Nie mozna zmienic Tekst podgladu modelu...");
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Size)
		{
			if(NTD[tdid][Font] != 4 && NTD[tdid][Font] != 5) ShowPlayerDialog(playerid, DIALOG_WIELKOSC, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Wielkosci", "{FF8040}Tekstu/Boxu(Wysokosc)\n{FF5500}Boxu(Szerokosc)", "Potwierdz", "Wroc");
			else if(NTD[tdid][Font] == 4 || NTD[tdid][Font] == 5)
			{
				NTDPlayer[ChangingSizeState] = 1;
				NTDPlayer[ChangingSize] = true;
				NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
				HideEditor(playerid);
			}
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Position)
		{
			NTDPlayer[ChangingPosition] = true;
			NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
			PlayerSelectTD(playerid, false);
			HideEditor(playerid);
			return 1;
		}
		else if(clickedid == B_Font)
		{
			if(NTD[tdid][Font] == 5)
				NTD[tdid][Font] = -1;
			
			NTD[tdid][Font]++;
			UpdateTD(playerid, tdid);
			
			if(NTD[tdid][Font] == 4)
				GameTextForPlayer(playerid, "~w~Czcionka~n~~g~TXD Sprite", 1500, 6);
			else if(NTD[tdid][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
				GameTextForPlayer(playerid, "~w~Czcionka~n~~b~Podglad Modeli", 1500, 6);
			else
				format(string, sizeof string, "~w~Czcionka~n~~y~%i", NTD[tdid][Font]),
				GameTextForPlayer(playerid, string, 1500, 6);
			return 1;
		}
		else if(clickedid == B_NewProject)
		{
			ShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT, CAPTION_TEXT"Nowy Projekt", "{FFFFFF}Wpisz nazwe swojego nowego projektu...", "Stworz", "Wroc");
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_CloseProject)
		{
			if(SaveProject() == 0) ShowInfo(playerid, "{FF0000}Podczas zapisu projektu wystapil problem...");
			else ShowInfo(playerid, "{FFFFFF}Projekt zostal pomyslnie zapisany i zamkniety...");
			
			for(new i; i < MAX_TDS; i++)
				DestroyTD(i);
			NTDPlayer[ProjectOpened] = false;
			NTDPlayer[EditingTDID] = -1;
			
			ShowWelcomeScreen(true);
			ShowEditorEx(playerid);
			return 1;
		}
		else if(clickedid == B_Manage)
		{
			OpenTDDialog(playerid, 0);
			return 1;
		}
		else if(clickedid == B_OpenProject)
		{
			OpenProjectDialog(playerid, 0);
			return 1;
		}
		else if(clickedid == B_Export)
		{
			ShowPlayerDialog(playerid, DIALOG_EXPORT, DIALOG_STYLE_LIST, CAPTION_TEXT"Eksportuj jako...", "{FFFFFF}Zwykly Eksport\n{FF8040}Gotowy skrypt", "Eksportuj", "Wroc");
			PlayerSelectTD(playerid, false);
			return 1;
		}
	}
	return 0;
}

forward BlockVarsChanger(bool:block);
public BlockVarsChanger(bool:block)
{
	if(block)
	{
		NTDPlayer[BlockVarsTime] = true;
		SetTimerEx("BlockVarsChanger", BLOCK_VARS_TIME, false, "b", false);
	}
	else NTDPlayer[BlockVarsTime] = false;
	return 1;
}

stock ShowTDOptions(tdid)
{
	new string[180];
	NTDPlayer[ChoosenTDID] = tdid;
	format(string, sizeof string, "%sID %i \x22%s\x22", CAPTION_TEXT, NTDPlayer[ChoosenTDID], NTD[NTDPlayer[ChoosenTDID]][tdstring]);
	ShowPlayerDialog(NTDPlayer[playerIDInEditor], DIALOG_MANAGE2, DIALOG_STYLE_LIST,  string, "{FFFFFF}Modyfikuj\n{FF8800}Zklonuj\n{FF0000}Usun", "Potwierdz", "Wroc");
	return 1;
}

stock UpdateTD(playerid, td)
{
	new red,green,blue, alpha;
	#pragma unused alpha
	TextDrawFont(NTD[td][tdself], NTD[td][Font]);
	TextDrawSetOutline(NTD[td][tdself], NTD[td][OutlineSize]);
	TextDrawSetShadow(NTD[td][tdself], NTD[td][ShadowSize]);
	TextDrawLetterSize(NTD[td][tdself], NTD[td][LetterSizeX], NTD[td][LetterSizeY]);
	RGBAToHex(NTD[td][Color],red,green,blue, alpha); 
	HexToRGBA(NTD[td][Color],red,green,blue,NTD[td][ColorA]);
	TextDrawColor(NTD[td][tdself], NTD[td][Color]);
	RGBAToHex(NTD[td][BGColor],red,green,blue, alpha);
	HexToRGBA(NTD[td][BGColor],red,green,blue,NTD[td][BGColorA]);
	TextDrawBackgroundColor(NTD[td][tdself], NTD[td][BGColor]);
	RGBAToHex(NTD[td][BoxColor],red,green,blue, alpha); 
	HexToRGBA(NTD[td][BoxColor],red,green,blue,NTD[td][BoxColorA]);
	TextDrawBoxColor(NTD[td][tdself], NTD[td][BoxColor]);
	TextDrawUseBox(NTD[td][tdself], NTD[td][UseBox]);	
	TextDrawTextSize(NTD[td][tdself], NTD[td][BoxSizeX], NTD[td][BoxSizeY]);
	TextDrawSetSelectable(NTD[td][tdself], NTD[td][Selectable]);
	TextDrawAlignment(NTD[td][tdself], NTD[td][Alignment]);
	TextDrawSetProportional(NTD[td][tdself], NTD[td][Proportional]);
	TextDrawSetPreviewModel(NTD[td][tdself], NTD[td][PrevModel]);
	TextDrawSetPreviewRot(NTD[td][tdself], NTD[td][PrevRotX], NTD[td][PrevRotY], NTD[td][PrevRotZ], NTD[td][PrevRotZoom]);
	TextDrawSetPreviewVehCol(NTD[td][tdself], NTD[td][PrevModelC1], NTD[td][PrevModelC2]);
	TextDrawShowForPlayer(playerid, NTD[td][tdself]);
	return 1;
}

stock QuickSelectionShow(playerid, bool:enable)
{
	if(NTDPlayer[ProjectOpened] == true)
	{
		new pool = GetTDPoolSize();
		if(enable)
		{
			for(new i; i <= pool; i++)
				if(NTD[i][tdCreated] == true)
					TextDrawShowForPlayer(playerid, NTD[i][tdpicker]);
		}
		else
		{
			for(new i; i <= pool; i++)
				if(NTD[i][tdCreated] == true)
					TextDrawHideForPlayer(playerid, NTD[i][tdpicker]);
		}
	}
	return 1;
}

stock SelectTD(playerid, tdid)
{
	if(tdid != NTDPlayer[EditingTDID])
	{
		new string[128];
		new ptdid = NTDPlayer[EditingTDID];
		NTDPlayer[EditingTDID] = tdid;
		format(string, sizeof string, "~g~WYBRANO_ID_~r~%i", NTDPlayer[EditingTDID]);
		GameTextForPlayer(playerid, string, 5000, 6);
		PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		HighlightTD(playerid, NTDPlayer[EditingTDID]);
		ShowEditorEx(playerid);
		TextDrawColor(NTD[tdid][tdpicker], TDPICKER_COLOR_ACTIVE);
		if(EditorQuickSelect) TextDrawShowForPlayer(playerid, NTD[tdid][tdpicker]);
		if(ptdid != -1 && tdid != ptdid)
		{
			TextDrawColor(NTD[ptdid][tdpicker], TDPICKER_COLOR);
			if(EditorQuickSelect) TextDrawShowForPlayer(playerid, NTD[ptdid][tdpicker]);
		}
		return 1;
	}
	return 0;
}

stock CreateProject(projectname[])
{
	new string[500];
	format(string, sizeof string, "NTD/Projects/%s.ntdp", projectname);			
	if(!dfile_FileExists(string))
	{
		new pid = WriteIntoList(projectname);
		if(pid != -1)
		{
			dfile_Create(string);
			projamount = GetAllProjects();		
			return pid;
		}
		else ShowInfo(NTDPlayer[playerIDInEditor], "{FF0000}Podczas zapisu projektu wystapil problem...");
	}
	return -1;
}

stock ShowInfo(playerid, text[])
{
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Informacja", text, "OK", #);
	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	return 1;
}


stock ExportProject(projectname[], exporttype=0)
{
	new filename[128], string[500], bool:clickableTD;
	format(filename, 128, "/NTD/Exports/%s.pwn", projectname);
	if(dfile_FileExists(filename))
		dfile_Delete(filename);
	
	if(dfile_FileExists("/NTD/Exports"))
	{
		if(dfile_Create(filename))
		{
			new File:file = fopen(filename, io_append);
			if(file)
			{
				new tda = GetAllTD();
				fwrite(file, "/*\nTen plik zostal wygenerowany przez skrypt Nickk's TextDraw editor\n");
				fwrite(file, "Autorem skryptu NTD jest Nickk888\n*/\n\n");
				if(exporttype == 0) //RAW EXPORT
				{
					fwrite(file, "//ZMIENNE\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new Text:textdraw_%i;\n", i);
						else if(!NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new PlayerText:textdraw_%i[MAX_PLAYERS];\n", i);
						fwrite(file, string);
					}
					fwrite(file, "\n//TEXTDRAWY\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "textdraw_%i = TextDrawCreate(%f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawFont(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawLetterSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawTextSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetOutline(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetShadow(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawAlignment(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawBackgroundColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawBoxColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawUseBox(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetProportional(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetSelectable(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "TextDrawSetPreviewModel(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "TextDrawSetPreviewRot(textdraw_%i, %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "TextDrawSetPreviewVehCol(textdraw_%i, %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
						}					
						else if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "textdraw_%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawFont(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawLetterSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawTextSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetOutline(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetShadow(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawAlignment(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawBackgroundColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawBoxColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawUseBox(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetProportional(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetSelectable(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetPreviewVehCol(playerid, textdraw_%i[playerid], %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
							fwrite(file, string);
							fwrite(file, "\n");
						}
						if(NTD[TDAdress[i]][Selectable])
								clickableTD = true;
					}
					fwrite(file, "\n//POKAZ/UKRYJ\n");
					fwrite(file, "TextDrawShowForPlayer(playerid, textdraw_0); //Pokazuje TextDraw graczowi.\n");
					fwrite(file, "TextDrawShowForAll(textdraw_0); //Pokazuje TextDraw wszystkim.\n\n");
					fwrite(file, "TextDrawHideForPlayer(playerid, textdraw_0); //Ukrywa TextDraw graczowi.\n");
					fwrite(file, "TextDrawHideForAll(textdraw_0); //Ukrywa TextDraw wszystkim.\n\n");
					fwrite(file, "PlayerTextDrawShow(playerid, textdraw_0[playerid]); //Pokazuje PlayerTextDraw graczowi.\n");
					fwrite(file, "PlayerTextDrawHide(playerid, textdraw_0[playerid]); //Ukrywa PlayerTextDraw graczowi.\n");
					if(clickableTD) 
						fwrite(file, "\nSelectTextDraw(playerid, 0xFF0000FF); //Wyswietla kursor by moc wybrac TextDraw");
				}
				else if(exporttype == 1) //WORKING FS EXPORT
				{
					fwrite(file, "#include <a_samp>\n\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new Text:textdraw_%i;\n", i);
						else if(!NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new PlayerText:textdraw_%i[MAX_PLAYERS];\n", i);
						fwrite(file, string);
					}

					fwrite(file, "\npublic OnFilterScriptInit()\n{\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\ttextdraw_%i = TextDrawCreate(%f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawFont(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawLetterSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawTextSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetOutline(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetShadow(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawAlignment(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawBackgroundColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawBoxColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawUseBox(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetProportional(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetSelectable(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "\tTextDrawSetPreviewModel(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "\tTextDrawSetPreviewRot(textdraw_%i, %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "\tTextDrawSetPreviewVehCol(textdraw_%i, %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
						}
						if(NTD[TDAdress[i]][Selectable])
							clickableTD = true;						
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnPlayerConnect(playerid)\n{\n");
					for(new i; i < tda; i++)
					{
						if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\ttextdraw_%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawFont(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawLetterSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawTextSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetOutline(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetShadow(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawAlignment(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawBackgroundColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawBoxColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawUseBox(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetProportional(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetSelectable(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Selectable])
								clickableTD = true;
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewModel(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewRot(playerid, textdraw_%i[playerid], %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewVehCol(playerid, textdraw_%i[playerid], %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
							
						}
						if(NTD[TDAdress[i]][Selectable])
							clickableTD = true;		
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnPlayerDisconnect(playerid)\n{\n");
					for(new i; i < tda; i++)
					{
						if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\tPlayerTextDrawDestroy(playerid, textdraw_%i[playerid]);\n", i);
							fwrite(file, string);
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					
					fwrite(file, "\npublic OnPlayerCommandText(playerid, cmdtext[])\n{\n");
					fwrite(file, "\tif(!strcmp(cmdtext, \x22/tdtest\x22, true))\n\t{\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\t\tTextDrawShowForPlayer(playerid, textdraw_%i);\n", i);
							fwrite(file, string);
						}
						else if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\t\tPlayerTextDrawShow(playerid, textdraw_%i[playerid]);\n", i);
							fwrite(file, string);
						}
					}
					if(clickableTD) 
						fwrite(file, "\t\tSelectTextDraw(playerid, 0xFF0000FF);\n");
					fwrite(file, "\t\treturn 1;\n\t}\n");
					fwrite(file, "\treturn 0;\n}\n");
				}
				fclose(file);
				return 1;
			}
		}
	}
	return 0;
}

stock OpenTDDialog(playerid, pageid)
{
	new longstring[1000], string[128], formatedtd[MAXFORMATEDTD], lister, listerindex;
	if(pageid == 0) listerindex = 10;
	else listerindex = 10;
	strcat(longstring, "{FF5500}Stworz nowy TextDraw\n");
	for(new i = (listerindex * pageid); i < tdamount; i++)
	{
		if(lister < listerindex)
		{
			lister++;
			format(formatedtd, MAXFORMATEDTD, NTD[TDAdress[i]][tdstring]);
			if(strlen(NTD[TDAdress[i]][tdstring]) > MAXFORMATEDTD - 4)
			{
				strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
				strcat(formatedtd, "...");
			}
			if(TDAdress[i] != NTDPlayer[EditingTDID]) format(string, sizeof string, "{FFFFFF}%i. {76DCC0}\x22%s\x22\n", TDAdress[i], formatedtd);
			else format(string, sizeof string, "{FFFFFF}%i. {FF0000}\x22%s\x22\n", TDAdress[i], formatedtd);
			strcat(longstring, string);
		}
		else
		{
			strcat(longstring, "{FF5500}Dalej...");
			break;
		}
	}
	NTDPlayer[OnList] = lister;
	NTDPlayer[IsOnPage] = pageid;
	PlayerSelectTD(playerid, false);
	format(string, sizeof string, "%s Moje TextDrawy (%i/%i TD)", CAPTION_TEXT, tdamount, MAX_TDS);
	ShowPlayerDialog(playerid, DIALOG_MANAGE, DIALOG_STYLE_TABLIST,  string, longstring, "Potwierdz", "Wroc");
	return 1;
}

stock GetAllTD()
{
	tdamount = 0;
	for(new i; i < MAX_TDS; i++)
	{
		if(NTD[i][tdCreated])
		{
			TDAdress[tdamount] = i;
			tdamount++;
		}
	}
	#if defined DEBUGMODE 
	printf("[NTD]Got all TextDraws.. Amount: %i", tdamount); 
	#endif
	return tdamount;
}

stock GetTDPoolSize()
{
	new tdpool = 0;
	for(new i; i < MAX_TDS; i++)
		if(NTD[i][tdCreated]) 
			tdpool = i;
	#if defined DEBUGMODE 
	printf("[NTD]Got TD Pool.. Pool: %i", tdpool); 
	#endif
	return tdpool;
}

stock GetAllProjects()
{
	new string[300];
	new index;
	if(dfile_FileExists(PROJECTLIST_FILEPATH))
	{
		dfile_Open(PROJECTLIST_FILEPATH);
		for(new i; i < MAX_PROJECTS; i++)
			format(TDList[i][proname], 128, "");
		for(new i; i < MAX_PROJECTS; i++)
		{
			format(string, sizeof string, "Project_%i", i);
			string = dfile_ReadString(string);
			if(strlen(string) > 0)
			{
				TDList[index][proid] = i;
				sscanf(string, "siiiiii", TDList[index][proname], TDList[index][protda], TDList[index][prolasthour],
				TDList[index][prolastmin],TDList[index][prolastday], TDList[index][prolastmonth], TDList[index][prolastyear]);
				index++;
			}
		}
	}
	return index;
}

stock OpenProjectDialog(playerid, pageid)
{
	new longstring[2000], string[128], lister, listerindex;
	if(pageid == 0) listerindex = 10;
	else listerindex = 10 * pageid;
	
	if(projamount > 0)
	{
		strcat(longstring, "Nazwa\tIlosc TD\tOstatnio zmodyfikowano\n");
		for(new i = (10 * pageid); i < MAX_PROJECTS; i++)
		{
			if(strlen(TDList[i][proname]) != 0)
			{
				if(lister < listerindex)
				{
					lister++;
					format(string, sizeof string, "%s\t%d\t%02d.%02d.%04d godz. %02d:%02d\n", TDList[i][proname], TDList[i][protda], TDList[i][prolastday],
					TDList[i][prolastmonth], TDList[i][prolastyear], TDList[i][prolasthour], TDList[i][prolastmin]);
					strcat(longstring, string);
				}
				else
				{
					strcat(longstring, "{FF5500}Dalej...");
					break;
				}
			}
		}
		NTDPlayer[OnList] = lister;
		NTDPlayer[IsOnPage] = pageid; 
		format(string, sizeof string, "%s Moje Projekty(%i/%i)", CAPTION_TEXT, projamount, MAX_PROJECTS);
		ShowPlayerDialog(playerid, DIALOG_OPEN, DIALOG_STYLE_TABLIST_HEADERS, string, longstring, "Wybierz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	else ShowInfo(playerid, "{FF0000}Aktualnie nie posiadasz zadnych projektow!");
	return 1;
}

stock ColorDialog(playerid, cstate)
{
	if(cstate == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_COLOR1, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Kolor tekstu\n{FF8040}Kolor tla/obramowania\n{FFFFFF}Kolor boxu", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	else if(cstate == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_COLOR2, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Gotowe kolory\n{FF8040}Kombinator RGBA\n{FFFFFF}Zmien Przezroczystosc", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	return 1;
}

forward PlayerSelectTD(playerid, bool:select);
public PlayerSelectTD(playerid, bool:select)
{
	if(select)
	{
		SelectTextDraw(playerid, EditorCursorColor);
		if(NTDPlayer[CursorTimer] == -1)
			NTDPlayer[CursorTimer] = SetTimerEx("PlayerSelectTD", 1000, true, "ib", playerid, true);
	}
	else
	{
		CancelSelectTextDraw(playerid);
		KillTimer(NTDPlayer[CursorTimer]);
		NTDPlayer[CursorTimer] = -1;
	}
	return 1;
}

stock ShowEditorEx(playerid, bool:showmouse = true)
{
	if(NTDPlayer[ProjectOpened] == true)
	{
		PlayerSelectTD(playerid, showmouse);
		if(NTDPlayer[EditingTDID] != -1)
			ShowEditor(playerid, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
		else 
			ShowEditor(playerid, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false);
	}
	else 
		ShowEditor(playerid, true, true, false, false, false, false, false, false ,false, false, false, false, false, false, false, false, false, false), 
		PlayerSelectTD(playerid, showmouse);
	return 1;
}

stock DeleteProject(projectname[])
{
	new string[200];
	#if defined DEBUGMODE 
	printf("[NTD]Attempting to delete project: %s", projectname); 
	#endif
	format(string, sizeof string, "NTD/Projects/%s.ntdp", projectname);
	if(dfile_FileExists(string))
	{
		dfile_Delete(string);
		#if defined DEBUGMODE 
		printf("[NTD]Deleted file '%s'", projectname); 
		#endif
		if(dfile_FileExists(PROJECTLIST_FILEPATH))
		{
			dfile_Open(PROJECTLIST_FILEPATH);
			for(new i; i < MAX_PROJECTS; i++)
			{
				format(string, sizeof string, "Project_%i", i);
				new projecttemp[200], pronametemp[128];
				format(projecttemp, 200, dfile_ReadString(string));
				sscanf(projecttemp, "siiiiii", pronametemp);
				if(strcmp(pronametemp, projectname) == 0 && strlen(pronametemp) > 0)
				{
					dfile_UnSet(string);
					dfile_SaveFile();
					dfile_CloseFile();
					projamount = GetAllProjects();
					#if defined DEBUGMODE 
					printf("[NTD]Deleted project '%s' from project list at '%s'", projectname, string); 
					#endif
					return 1;
				}
			}
		}
	}
	return 0;
}

stock LoadConfigurations()
{
	if(dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Open(SETTINGS_FILEPATH);
		EditorHeight = dfile_ReadInt("editor_height");
		EditorCursorColor = dfile_ReadInt("editor_hcolor");
		EditorButtonsColor = dfile_ReadInt("editor_bcolor");
		EditorFasterKey = dfile_ReadInt("editor_fasterkey");
		EditorAcceptKey = dfile_ReadInt("editor_acceptkey");
		EditorQuickSelect = dfile_ReadBool("editor_quickselect");
		format(EditorVersion, sizeof EditorVersion, dfile_ReadString("editor_scriptversion"));
		dfile_CloseFile();
	}
	return 1;
}

stock SaveConfigurations()
{
	if(!dfile_FileExists(SETTINGS_FILEPATH))
		dfile_Create(SETTINGS_FILEPATH);
	if(dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Open(SETTINGS_FILEPATH);
		dfile_WriteInt("editor_height", EditorHeight);
		dfile_WriteInt("editor_hcolor", EditorCursorColor);
		dfile_WriteInt("editor_bcolor", EditorButtonsColor);
		dfile_WriteInt("editor_fasterkey", EditorFasterKey);
		dfile_WriteInt("editor_acceptkey", EditorAcceptKey);
		dfile_WriteBool("editor_quickselect", EditorQuickSelect);
		dfile_WriteString("editor_scriptversion", EditorVersion);
		dfile_SaveFile();
		dfile_CloseFile();
	}
	return 1;
}

stock SaveProject()
{
	new string[128], file[300], longstring[1000], stringex[128];
	#if defined DEBUGMODE 
	printf("[NTD]Attempting to save project: %s", NTDPlayer[ProjectName]);
	#endif
	
	format(file, sizeof file, "NTD/ntdlist.list");
	if(dfile_FileExists(file))
	{
		new hour, minute, second, year, month, day;
		gettime(hour, minute, second);
		getdate(year, month, day);
		dfile_Open(file);
		format(file, sizeof file, "Project_%i", NTDPlayer[ProjectID]);
		format(string, sizeof string, "%s %i %i %i %i %i %i", NTDPlayer[ProjectName], tdamount, hour, minute, day, month, year);
		dfile_WriteString(file, string);
		dfile_SaveFile();
		dfile_CloseFile();
		GetAllProjects();
	}
	
	format(file, sizeof file, "NTD/Projects/%s.ntdp", NTDPlayer[ProjectName]);
	if(dfile_FileExists(file))
	{
		dfile_Open(file);
		for(new i; i < MAX_TDS; i++)
		{
			if(NTD[i][tdCreated])
			{
				longstring = "";
				
				format(string, sizeof string, "td_%i_string", i);
				dfile_WriteString(string, NTD[i][tdstring]);
				format(string, sizeof string, "td_%i_data", i);
				format(stringex, sizeof stringex, "%f %f ", NTD[i][PosX], NTD[i][PosY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD[i][Font], NTD[i][isPublic]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD[i][OutlineSize], NTD[i][ShadowSize]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%f %f ", NTD[i][LetterSizeX], NTD[i][LetterSizeY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD[i][Color], NTD[i][BGColor], NTD[i][BoxColor]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %f %f ", NTD[i][UseBox], NTD[i][BoxSizeX], NTD[i][BoxSizeY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD[i][Selectable], NTD[i][Alignment], NTD[i][Proportional]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i %f %f %f %f ", NTD[i][PrevModel], NTD[i][PrevModelC1], NTD[i][PrevModelC2], NTD[i][PrevRotX], NTD[i][PrevRotY], NTD[i][PrevRotZ], NTD[i][PrevRotZoom]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i", NTD[i][ColorA], NTD[i][BGColorA], NTD[i][BoxColorA]);
				strcat(longstring, stringex);
				dfile_WriteString(string, longstring);
			}
			else
			{
				format(string, sizeof string, "td_%i_string", i);
				dfile_UnSet(string);
				format(string, sizeof string, "td_%i_data", i);
				dfile_UnSet(string);
			}
		}
		dfile_SaveFile();
		dfile_CloseFile();
		return 1;
	}
	return 0;
}

stock LoadProject(projectname[])
{
	#if defined DEBUGMODE 
	new tc = GetTickCount();
	printf("[NTD]Attempting to open file: %s", projectname);
	#endif
	new string[300], longstring[2000];
	format(string, sizeof string, "NTD/Projects/%s.ntdp", projectname);
	if(dfile_FileExists(string))
	{
		
		for(new i; i < MAX_TDS; i++)
			NTD[i][tdCreated] = false;
			
		format(NTDPlayer[ProjectName], 128, projectname);
		NTDPlayer[ProjectOpened] = true;
		dfile_Open(string);
		for(new i; i < MAX_TDS; i++)
		{
			format(string, sizeof string, "td_%i_data", i);
			if(strlen(dfile_ReadString(string)) > 0)
			{
				NTD[i][tdCreated] = true;
				NTD[i][tdhltimer] = -1;
				format(string, sizeof string, "td_%i_string", i);
				format(NTD[i][tdstring] , 300, dfile_ReadString(string));
				format(string, sizeof string, "td_%i_data", i);
				format(longstring, sizeof longstring, dfile_ReadString(string)); 
				
				sscanf(longstring, "ffiiiiffiiiiffiiiiiiffffiii",
				NTD[i][PosX], NTD[i][PosY], NTD[i][Font], NTD[i][isPublic],
				NTD[i][OutlineSize], NTD[i][ShadowSize], NTD[i][LetterSizeX], NTD[i][LetterSizeY],
				NTD[i][Color], NTD[i][BGColor], NTD[i][BoxColor], NTD[i][UseBox], NTD[i][BoxSizeX], NTD[i][BoxSizeY],
				NTD[i][Selectable], NTD[i][Alignment], NTD[i][Proportional], NTD[i][PrevModel], NTD[i][PrevModelC1], 
				NTD[i][PrevModelC2], NTD[i][PrevRotX], NTD[i][PrevRotY], NTD[i][PrevRotZ], NTD[i][PrevRotZoom],
				NTD[i][ColorA], NTD[i][BGColorA], NTD[i][BoxColorA]);
				
				DrawTD(i);
				#if defined DEBUGMODE 
				printf("[NTD]Created TD ID: %i", i);
				#endif
			}
		}
		GetAllTD();
		#if defined DEBUGMODE 
		printf("Project Loaded in %i ms", GetTickCount() - tc);
		#endif
		return 1;
		
	}
	return 0;
}

stock CreateNewTDFromTemplate(templateid)
{
	new Tstring[300], Float:TPosX, Float:TPosY, TFont, bool:TisPublic, TOutlineSize, 
	TShadowSize, Float:TLetterSizeX, Float:TLetterSizeY, TColor, TBGColor, TBoxColor, 
	bool:ZUseBox, Float:TBoxSizeX, Float:TBoxSizeY, bool:TSelectable, TAlignment, 
	bool:TProportional, TPrevModel, TPrevModelC1, TPrevModelC2, Float:TPrevRotX, Float:TPrevRotY,
	Float:TPrevRotZ, Float:TPrevRotZoom, TColorA, TBGColorA, TBoxColorA;
	
	sscanf(Template[templateid][1][0], "sffiiiiffiiiiffiiiiiiffffiii",
		Tstring, TPosX, TPosY, TFont, TisPublic, TOutlineSize, 
		TShadowSize, TLetterSizeX, TLetterSizeY, TColor, TBGColor, TBoxColor, 
		ZUseBox, TBoxSizeX, TBoxSizeY, TSelectable, TAlignment, 
		TProportional, TPrevModel, TPrevModelC1, TPrevModelC2, TPrevRotX, TPrevRotY,
		TPrevRotZ, TPrevRotZoom, TColorA, TBGColorA, TBoxColorA);
		
	new tdid = CreateNewTD(-2, Tstring, TPosX, TPosY, TFont, TisPublic, TOutlineSize, 
		TShadowSize, TLetterSizeX, TLetterSizeY, TColor, TBGColor, TBoxColor, 
		ZUseBox, TBoxSizeX, TBoxSizeY, TSelectable, TAlignment, 
		TProportional, TPrevModel, TPrevModelC1, TPrevModelC2, TPrevRotX, TPrevRotY,
		TPrevRotZ, TPrevRotZoom, TColorA, TBGColorA, TBoxColorA);
	

	return tdid;
}

stock DestroyTD(td)
{
	if(NTD[td][tdCreated] == true)
	{
		NTD[td][tdCreated] = false;
		TextDrawDestroy(NTD[td][tdself]);
		TextDrawDestroy(NTD[td][tdpicker]);
	}
}

forward HLTD(playerid, td);
public HLTD(playerid, td)
{
	new red, green, blue, alpha;
	#pragma unused alpha
	RGBAToHex(NTD[td][Color],red,green,blue, alpha); 
	HexToRGBA(NTD[td][Color],red,green,blue,NTD[td][ColorA]);
	TextDrawColor(NTD[td][tdself], NTD[td][Color]);
	RGBAToHex(NTD[td][BGColor],red,green,blue, alpha);
	HexToRGBA(NTD[td][BGColor],red,green,blue,NTD[td][BGColorA]);
	TextDrawBackgroundColor(NTD[td][tdself], NTD[td][BGColor]);
	RGBAToHex(NTD[td][BoxColor],red,green,blue, alpha); 
	HexToRGBA(NTD[td][BoxColor],red,green,blue,NTD[td][BoxColorA]);
	TextDrawBoxColor(NTD[td][tdself], NTD[td][BoxColor]);
	TextDrawShowForPlayer(playerid, NTD[td][tdself]);
	return 1;
}

stock HighlightTD(playerid, td)
{
	TextDrawColor(NTD[td][tdself], 0xFFFF00FF);
	TextDrawBackgroundColor(NTD[td][tdself], 0xFFFF00FF);
	TextDrawBoxColor(NTD[td][tdself], 0xFFFF00FF);
	TextDrawShowForPlayer(playerid, NTD[td][tdself]);

	if(NTD[td][tdhltimer] != -1)
		KillTimer(NTD[td][tdhltimer]);
	NTD[td][tdhltimer] = SetTimerEx("HLTD", 250, false, "ii", playerid, td);
	return 1;
}

stock DrawTD(td)
{
	new playerid = NTDPlayer[playerIDInEditor];
	new red, green, blue, alpha;
	#pragma unused alpha
	if(NTD[td][tdCreated] == true)
	{
		//TD
		NTD[td][tdself] = TextDrawCreate(NTD[td][PosX], NTD[td][PosY], NTD[td][tdstring]);
		TextDrawFont(NTD[td][tdself], NTD[td][Font]);
		TextDrawSetOutline(NTD[td][tdself], NTD[td][OutlineSize]);
		TextDrawSetShadow(NTD[td][tdself], NTD[td][ShadowSize]);
		TextDrawLetterSize(NTD[td][tdself], NTD[td][LetterSizeX], NTD[td][LetterSizeY]);
		RGBAToHex(NTD[td][Color],red,green,blue, alpha); 
		HexToRGBA(NTD[td][Color],red,green,blue,NTD[td][ColorA]);
		TextDrawColor(NTD[td][tdself], NTD[td][Color]);
		RGBAToHex(NTD[td][BGColor],red,green,blue, alpha);
		HexToRGBA(NTD[td][BGColor],red,green,blue,NTD[td][BGColorA]);
		TextDrawBackgroundColor(NTD[td][tdself], NTD[td][BGColor]);
		RGBAToHex(NTD[td][BoxColor],red,green,blue, alpha); 
		HexToRGBA(NTD[td][BoxColor],red,green,blue,NTD[td][BoxColorA]);
		TextDrawBoxColor(NTD[td][tdself], NTD[td][BoxColor]);
		TextDrawUseBox(NTD[td][tdself], NTD[td][UseBox]);	
		TextDrawTextSize(NTD[td][tdself], NTD[td][BoxSizeX], NTD[td][BoxSizeY]);
		TextDrawSetSelectable(NTD[td][tdself], NTD[td][Selectable]);
		TextDrawAlignment(NTD[td][tdself], NTD[td][Alignment]);
		TextDrawSetProportional(NTD[td][tdself], NTD[td][Proportional]);
		TextDrawSetPreviewModel(NTD[td][tdself], NTD[td][PrevModel]);
		TextDrawSetPreviewRot(NTD[td][tdself], NTD[td][PrevRotX], NTD[td][PrevRotY], NTD[td][PrevRotZ], NTD[td][PrevRotZoom]);
		TextDrawSetPreviewVehCol(NTD[td][tdself], NTD[td][PrevModelC1], NTD[td][PrevModelC2]);
		
		//Picker
		NTD[td][tdpicker] = TextDrawCreate(NTD[td][PosX] - 1, NTD[td][PosY] - 10, "E");
		TextDrawFont(NTD[td][tdpicker], 1);
		TextDrawSetOutline(NTD[td][tdpicker], 0);
		TextDrawSetShadow(NTD[td][tdpicker], 0);
		TextDrawLetterSize(NTD[td][tdpicker], 0.445833, 1.600000);
		TextDrawTextSize(NTD[td][tdpicker], 20.0, 20.0);
		TextDrawAlignment(NTD[td][tdpicker], 2);
		TextDrawSetSelectable(NTD[td][tdpicker], true);
		
		if(NTDPlayer[EditingTDID] != td) 
			TextDrawColor(NTD[td][tdpicker], TDPICKER_COLOR);
		else
			TextDrawColor(NTD[td][tdpicker], TDPICKER_COLOR_ACTIVE);
		
		//Show
		TextDrawShowForPlayer(playerid, NTD[td][tdself]);
		if(EditorQuickSelect) TextDrawShowForPlayer(playerid, NTD[td][tdpicker]);
		return 1;
	}
	return 0;
}

stock CreateNewTD(cloneid = -1, Tstring[] = "_", Float:TPosX = 0.0, Float:TPosY = 0.0, TFont = 0, bool:TisPublic = true, TOutlineSize = 0, 
TShadowSize = 0, Float:TLetterSizeX = 0.0, Float:TLetterSizeY = 0.0, TColor = -1, TBGColor = -1, TBoxColor = -1, 
bool:ZUseBox = true, Float:TBoxSizeX = 0.0, Float:TBoxSizeY = 0.0, bool:TSelectable = false, TAlignment = 0, 
bool:TProportional = true, TPrevModel = 0, TPrevModelC1 = -1, TPrevModelC2 = -1, Float:TPrevRotX = 0.0, Float:TPrevRotY = 0.0,
Float:TPrevRotZ = 0.0, Float:TPrevRotZoom = 0.0, TColorA = -1, TBGColorA = 255, TBoxColorA = 255)
{
	for(new i; i < MAX_TDS; i++)
	{
		if(NTD[i][tdCreated] == false)
		{
			NTD[i][tdCreated] = true;
			if(cloneid == -2) //Template
			{
				format(NTD[i][tdstring], 300, Tstring);
				NTD[i][PosX] = TPosX;
				NTD[i][PosY] = TPosY;
				NTD[i][Font] = TFont;
				NTD[i][isPublic] = TisPublic;
				NTD[i][OutlineSize] = TOutlineSize;
				NTD[i][ShadowSize] = TShadowSize;
				NTD[i][LetterSizeX] = TLetterSizeX;
				NTD[i][LetterSizeY] = TLetterSizeY;
				NTD[i][BoxSizeX] = TBoxSizeX;
				NTD[i][BoxSizeY] = TBoxSizeY;
				NTD[i][Color] = TColor;
				NTD[i][BGColor] = TBGColor;
				NTD[i][BoxColor] = TBoxColor;
				NTD[i][ColorA] = TColorA;
				NTD[i][BGColorA] = TBGColorA;
				NTD[i][BoxColorA] = TBoxColorA;
				NTD[i][Alignment] = TAlignment;
				NTD[i][Selectable] = TSelectable;
				NTD[i][Proportional] = TProportional;
				NTD[i][UseBox] = ZUseBox;
				NTD[i][PrevModel] = TPrevModel;
				NTD[i][PrevModelC1] = TPrevModelC1;
				NTD[i][PrevModelC2] = TPrevModelC2;
				NTD[i][PrevRotX] = TPrevRotX;
				NTD[i][PrevRotY] = TPrevRotY;
				NTD[i][PrevRotZ] = TPrevRotZ;
				NTD[i][PrevRotZoom] = TPrevRotZoom;
			}
			else if(cloneid == -1) //Normal
			{
				format(NTD[i][tdstring], 300, "Nowy_TextDraw");
				NTD[i][PosX] = 233.0;
				NTD[i][PosY] = 225.0;
				NTD[i][Font] = 1;
				NTD[i][isPublic] = true;
				NTD[i][OutlineSize] = 1;
				NTD[i][ShadowSize] = 0;
				NTD[i][LetterSizeX] = 0.6;
				NTD[i][LetterSizeY] = 2.0;
				NTD[i][BoxSizeX] = 400.0;
				NTD[i][BoxSizeY] = 17.0;
				NTD[i][Color] = -1;
				NTD[i][BGColor] = 255;
				NTD[i][BoxColor] = 100;
				NTD[i][ColorA] = 255;
				NTD[i][BGColorA] = 255;
				NTD[i][BoxColorA] = 50;
				NTD[i][Alignment] = 1;
				NTD[i][Selectable] = false;
				NTD[i][Proportional] = true;
				NTD[i][UseBox] = true;
				NTD[i][PrevModel] = 0;
				NTD[i][PrevModelC1] = 1;
				NTD[i][PrevModelC2] = 1;
				NTD[i][PrevRotX] = -10.0;
				NTD[i][PrevRotY] = 0.0;
				NTD[i][PrevRotZ] = -20.0;
				NTD[i][PrevRotZoom] = 1.0;
			}
			else //Clone
			{
				if(NTD[cloneid][tdCreated] == true)
				{
					format(NTD[i][tdstring], 300, NTD[cloneid][tdstring]);
					NTD[i][PosX] = NTD[cloneid][PosX];
					NTD[i][PosY] = NTD[cloneid][PosY];
					NTD[i][Font] = NTD[cloneid][Font];
					NTD[i][isPublic] = NTD[cloneid][isPublic];
					NTD[i][OutlineSize] = NTD[cloneid][OutlineSize];
					NTD[i][ShadowSize] = NTD[cloneid][ShadowSize];
					NTD[i][LetterSizeX] = NTD[cloneid][LetterSizeX];
					NTD[i][LetterSizeY] = NTD[cloneid][LetterSizeY];
					NTD[i][BoxSizeX] = NTD[cloneid][BoxSizeX];
					NTD[i][BoxSizeY] = NTD[cloneid][BoxSizeY];
					NTD[i][Color] = NTD[cloneid][Color];
					NTD[i][BGColor] = NTD[cloneid][BGColor];
					NTD[i][BoxColor] = NTD[cloneid][BoxColor];
					NTD[i][ColorA] = NTD[cloneid][ColorA];
					NTD[i][BGColorA] = NTD[cloneid][BGColorA];
					NTD[i][BoxColorA] = NTD[cloneid][BoxColorA];
					NTD[i][Alignment] = NTD[cloneid][Alignment];
					NTD[i][Selectable] = NTD[cloneid][Selectable];
					NTD[i][Proportional] = NTD[cloneid][Proportional];
					NTD[i][UseBox] = NTD[cloneid][UseBox];
					NTD[i][PrevModel] = NTD[cloneid][PrevModel];
					NTD[i][PrevModelC1] = NTD[cloneid][PrevModelC1];
					NTD[i][PrevModelC2] = NTD[cloneid][PrevModelC2];
					NTD[i][PrevRotX] = NTD[cloneid][PrevRotX];
					NTD[i][PrevRotY] = NTD[cloneid][PrevRotY];
					NTD[i][PrevRotZ] = NTD[cloneid][PrevRotZ];
					NTD[i][PrevRotZoom] = NTD[cloneid][PrevRotZoom];
				}
			}
			GetAllTD();
			return i;
		}
	}
	return -1;
}

stock ShowEditor(playerid, bool:b1_active, bool:b2_active, bool:b3_active, bool:b4_active, bool:b5_active, bool:b6_active, bool:b7_active, bool:b8_active, bool:b9_active, bool:b10_active, bool:b11_active, bool:b12_active, bool:b13_active, bool:b14_active, bool:b15_active, bool:b16_active, bool:b17_active, bool:b18_active)
{
	HideEditor(playerid);
	#if defined DEBUGMODE 
	print("[NTD]Showing Editor");
	#endif
	TextDrawShowForPlayer(playerid, B_Exit);
	TextDrawShowForPlayer(playerid, B_Settings);
	TextDrawShowForPlayer(playerid, E_Box);
	if(b1_active) TextDrawShowForPlayer(playerid, B_NewProject);
	if(b2_active) TextDrawShowForPlayer(playerid, B_OpenProject);
	if(b3_active) TextDrawShowForPlayer(playerid, B_CloseProject);
	if(b4_active) TextDrawShowForPlayer(playerid, B_Export);
	if(b5_active) TextDrawShowForPlayer(playerid, B_Manage);
	if(b6_active) TextDrawShowForPlayer(playerid, B_Font);
	if(b7_active) TextDrawShowForPlayer(playerid, B_MPreview);
	if(b8_active) TextDrawShowForPlayer(playerid, B_Position);
	if(b9_active) TextDrawShowForPlayer(playerid, B_Size);
	if(b10_active) TextDrawShowForPlayer(playerid, B_Tekst);
	if(b11_active) TextDrawShowForPlayer(playerid, B_Color);
	if(b12_active) TextDrawShowForPlayer(playerid, B_Outline);
	if(b13_active) TextDrawShowForPlayer(playerid, B_Shadow);
	if(b14_active) TextDrawShowForPlayer(playerid, B_UseBox);
	if(b15_active) TextDrawShowForPlayer(playerid, B_Alignment);
	if(b16_active) TextDrawShowForPlayer(playerid, B_SwitchPublic);
	if(b17_active) TextDrawShowForPlayer(playerid, B_Selectable);
	if(b18_active) TextDrawShowForPlayer(playerid, B_Proportionality);
	NTDPlayer[InEditor] = true;
	return 1;
}

stock HideEditor(playerid)
{
	#if defined DEBUGMODE 
	print("[NTD]Hiding Editor");
	#endif
	TextDrawHideForPlayer(playerid, E_Box);
	TextDrawHideForPlayer(playerid, B_Exit);
	TextDrawHideForPlayer(playerid, B_Settings);
	TextDrawHideForPlayer(playerid, B_NewProject);
	TextDrawHideForPlayer(playerid, B_OpenProject);
	TextDrawHideForPlayer(playerid, B_CloseProject);
	TextDrawHideForPlayer(playerid, B_Export);
	TextDrawHideForPlayer(playerid, B_Manage);
	TextDrawHideForPlayer(playerid, B_Font);
	TextDrawHideForPlayer(playerid, B_Position);
	TextDrawHideForPlayer(playerid, B_Size);
	TextDrawHideForPlayer(playerid, B_Tekst);
	TextDrawHideForPlayer(playerid, B_Color);
	TextDrawHideForPlayer(playerid, B_Outline);
	TextDrawHideForPlayer(playerid, B_Shadow);
	TextDrawHideForPlayer(playerid, B_UseBox);
	TextDrawHideForPlayer(playerid, B_Alignment);
	TextDrawHideForPlayer(playerid, B_SwitchPublic);
	TextDrawHideForPlayer(playerid, B_Selectable);
	TextDrawHideForPlayer(playerid, B_Proportionality);
	TextDrawHideForPlayer(playerid, B_MPreview);
	return 1;
}

stock DestroyEditor()
{
	#if defined DEBUGMODE 
	print("[NTD]Destroying Editor");
	#endif
	TextDrawDestroy(E_Box);
	TextDrawDestroy(B_Exit);
	TextDrawDestroy(B_Settings);
	TextDrawDestroy(B_NewProject);
	TextDrawDestroy(B_OpenProject);
	TextDrawDestroy(B_CloseProject);
	TextDrawDestroy(B_Export);
	TextDrawDestroy(B_Manage);
	TextDrawDestroy(B_Font);
	TextDrawDestroy(B_Position);
	TextDrawDestroy(B_Size);
	TextDrawDestroy(B_Tekst);
	TextDrawDestroy(B_Color);
	TextDrawDestroy(B_Outline);
	TextDrawDestroy(B_Shadow);
	TextDrawDestroy(B_UseBox);
	TextDrawDestroy(B_Alignment);
	TextDrawDestroy(B_SwitchPublic);
	TextDrawDestroy(B_Selectable);
	TextDrawDestroy(B_Proportionality);
	TextDrawDestroy(B_MPreview);
	return 1;
}

stock WriteIntoList(name[])
{
	new string[500];
	if(dfile_FileExists(PROJECTLIST_FILEPATH))
	{
		dfile_Open(PROJECTLIST_FILEPATH);
		for(new i; i < MAX_PROJECTS; i++)
		{
			format(string, sizeof string, "Project_%i", i);
			new prname[128];
			format(prname, 128, dfile_ReadString(string));
			if(strlen(prname) == 0)
			{
				dfile_WriteString(string, name);
				dfile_SaveFile();
				dfile_CloseFile();
				return i;
			}
		}
	}
	return -1;
}

forward FadeTimer(bool:fadein);
public FadeTimer(bool:fadein)
{
	if(fadein)
	{
		if(NTDPlayer[WelcomeScreenAlpha] < 254)
		{
			NTDPlayer[WelcomeScreenAlpha] += 3;
			NTDPlayer[WelcomeScreenColor] = ShiftRGBToRGBA(NTDPlayer[WelcomeScreenColor], NTDPlayer[WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, NTDPlayer[WelcomeScreenColor]);
			TextDrawShowForPlayer(NTDPlayer[playerIDInEditor], WelcomeScreen);
		}
		else 
		{
			KillTimer(NTDPlayer[WelcomeTimer]);
			NTDPlayer[WelcomeTimer] = -1;
		}
			
		
	}
	else
	{
		if(NTDPlayer[WelcomeScreenAlpha] > 0)
		{
			NTDPlayer[WelcomeScreenAlpha] -= 3;
			NTDPlayer[WelcomeScreenColor] = ShiftRGBToRGBA(NTDPlayer[WelcomeScreenColor], NTDPlayer[WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, NTDPlayer[WelcomeScreenColor]);
			TextDrawShowForPlayer(NTDPlayer[playerIDInEditor], WelcomeScreen);
		}
		else 
		{
			TextDrawDestroy(WelcomeScreen);
			NTDPlayer[WelcomeScreenAlpha] = -1;
			KillTimer(NTDPlayer[WelcomeTimer]);
			NTDPlayer[WelcomeTimer] = -1;
		}
	}
	return 1;
}

stock ShowWelcomeScreen(bool:show)
{
	if(show)
	{
		if(NTDPlayer[WelcomeScreenAlpha] == -1)
		{
			NTDPlayer[WelcomeScreenAlpha] = 0;
			NTDPlayer[WelcomeScreenColor] = 0xFFFFFFFF;
			NTDPlayer[WelcomeScreenColor] = ShiftRGBToRGBA(NTDPlayer[WelcomeScreenColor], NTDPlayer[WelcomeScreenAlpha]);
			WelcomeScreen = TextDrawCreate(121.000000, 81.000000, WELCOME_SCREEN);
			TextDrawFont(WelcomeScreen, 4);
			TextDrawTextSize(WelcomeScreen, 397.500000, 244.000000);
			TextDrawColor(WelcomeScreen, NTDPlayer[WelcomeScreenColor]);
		}
		if(NTDPlayer[WelcomeTimer] != -1)
			KillTimer(NTDPlayer[WelcomeTimer]);
			
		TextDrawShowForPlayer(NTDPlayer[playerIDInEditor], WelcomeScreen);
		NTDPlayer[WelcomeTimer] = SetTimerEx("FadeTimer", 25, true, "b", true);
	}
	else
	{
		if(NTDPlayer[WelcomeScreenAlpha] != -1)
		{
			if(NTDPlayer[WelcomeTimer] != -1)
				KillTimer(NTDPlayer[WelcomeTimer]);
				
			TextDrawShowForPlayer(NTDPlayer[playerIDInEditor], WelcomeScreen);
			NTDPlayer[WelcomeTimer] = SetTimerEx("FadeTimer", 25, true, "b", false);
		}
	}
	return 1;
}

stock CreateEditor()
{
	#if defined DEBUGMODE 
	print("[NTD]Creating Editor");
	#endif

	E_Box = TextDrawCreate(0.000000, EditorHeight, "~n~~n~");
	TextDrawFont(E_Box, 1);
	TextDrawLetterSize(E_Box, 0.600000, 2.000000);
	TextDrawTextSize(E_Box, 640.000000, 17.000000);
	TextDrawBoxColor(E_Box, 0x000000AA);
	TextDrawUseBox(E_Box, 1);
	
	B_Exit = TextDrawCreate(0, EditorHeight - 15, BUTTON_EXIT);
	TextDrawFont(B_Exit, 4);
	TextDrawTextSize(B_Exit, BUTTON_TD_SIZE / 3, BUTTON_TD_SIZE / 3);
	TextDrawColor(B_Exit, 0x990000FF);
	TextDrawSetSelectable(B_Exit, true);
	
	B_Settings = TextDrawCreate(0 + BUTTON_TD_SIZE / 3, EditorHeight - 15, BUTTON_SETTINGS);
	TextDrawFont(B_Settings, 4);
	TextDrawTextSize(B_Settings, BUTTON_TD_SIZE / 3, BUTTON_TD_SIZE / 3);
	TextDrawColor(B_Settings, 0x000000FF);
	TextDrawSetSelectable(B_Settings, true);
	
	B_NewProject = TextDrawCreate(0, EditorHeight, BUTTON_NEW);
	TextDrawFont(B_NewProject, 4);
	TextDrawTextSize(B_NewProject, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_NewProject, true);
	TextDrawColor(B_NewProject, EditorButtonsColor);
	
	B_OpenProject = TextDrawCreate(BUTTON_TD_SPACER, EditorHeight, BUTTON_OPEN);
	TextDrawFont(B_OpenProject, 4);
	TextDrawTextSize(B_OpenProject, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_OpenProject, true);
	TextDrawColor(B_OpenProject, EditorButtonsColor);
	
	B_CloseProject = TextDrawCreate(BUTTON_TD_SPACER * 2, EditorHeight, BUTTON_CLOSE);
	TextDrawFont(B_CloseProject, 4);
	TextDrawTextSize(B_CloseProject, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_CloseProject, true);
	TextDrawColor(B_CloseProject, EditorButtonsColor);
	
	B_Export = TextDrawCreate(BUTTON_TD_SPACER * 3, EditorHeight, BUTTON_EXPORT);
	TextDrawFont(B_Export, 4);
	TextDrawTextSize(B_Export, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Export, true);
	TextDrawColor(B_Export, EditorButtonsColor);
	
	B_Manage = TextDrawCreate(BUTTON_TD_SPACER * 4, EditorHeight, BUTTON_MANAGE);
	TextDrawFont(B_Manage, 4);
	TextDrawTextSize(B_Manage, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Manage, true);
	TextDrawColor(B_Manage, EditorButtonsColor);
	
	B_Font = TextDrawCreate(BUTTON_TD_SPACER * 5, EditorHeight, BUTTON_FONT);
	TextDrawFont(B_Font, 4);
	TextDrawTextSize(B_Font, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Font, true);
	TextDrawColor(B_Font, EditorButtonsColor);
	
	B_MPreview = TextDrawCreate(BUTTON_TD_SPACER * 6, EditorHeight, BUTTON_MPREVIEW);
	TextDrawFont(B_MPreview, 4);
	TextDrawTextSize(B_MPreview, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_MPreview, true);
	TextDrawColor(B_MPreview, EditorButtonsColor);
	
	B_Position = TextDrawCreate(BUTTON_TD_SPACER * 7, EditorHeight, BUTTON_POSITION);
	TextDrawFont(B_Position, 4);
	TextDrawTextSize(B_Position, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Position, true);
	TextDrawColor(B_Position, EditorButtonsColor);
	
	B_Size = TextDrawCreate(BUTTON_TD_SPACER * 8, EditorHeight, BUTTON_SIZE);
	TextDrawFont(B_Size, 4);
	TextDrawTextSize(B_Size, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Size, true);
	TextDrawColor(B_Size, EditorButtonsColor);
	
	B_Tekst = TextDrawCreate(BUTTON_TD_SPACER * 9, EditorHeight, BUTTON_TEKST);
	TextDrawFont(B_Tekst, 4);
	TextDrawTextSize(B_Tekst, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Tekst, true);
	TextDrawColor(B_Tekst, EditorButtonsColor);
	
	B_Color = TextDrawCreate(BUTTON_TD_SPACER * 10, EditorHeight, BUTTON_COLOR);
	TextDrawFont(B_Color, 4);
	TextDrawTextSize(B_Color, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Color, true);
	TextDrawColor(B_Color, EditorButtonsColor);
	
	B_Outline = TextDrawCreate(BUTTON_TD_SPACER * 11, EditorHeight, BUTTON_OUTLINE);
	TextDrawFont(B_Outline, 4);
	TextDrawTextSize(B_Outline, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Outline, true);
	TextDrawColor(B_Outline, EditorButtonsColor);
	
	B_Shadow = TextDrawCreate(BUTTON_TD_SPACER * 12, EditorHeight, BUTTON_SHADOW);
	TextDrawFont(B_Shadow, 4);
	TextDrawTextSize(B_Shadow, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Shadow, true);
	TextDrawColor(B_Shadow, EditorButtonsColor);
	
	B_UseBox = TextDrawCreate(BUTTON_TD_SPACER * 13, EditorHeight, BUTTON_USEBOX);
	TextDrawFont(B_UseBox, 4);
	TextDrawTextSize(B_UseBox, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_UseBox, true);
	TextDrawColor(B_UseBox, EditorButtonsColor);
	
	B_Alignment = TextDrawCreate(BUTTON_TD_SPACER * 14, EditorHeight, BUTTON_ALIGNMENT);
	TextDrawFont(B_Alignment, 4);
	TextDrawTextSize(B_Alignment, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Alignment, true);
	TextDrawColor(B_Alignment, EditorButtonsColor);
	
	B_SwitchPublic = TextDrawCreate(BUTTON_TD_SPACER * 15, EditorHeight, BUTTON_SWITCHPUBLIC);
	TextDrawFont(B_SwitchPublic, 4);
	TextDrawTextSize(B_SwitchPublic, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_SwitchPublic, true);
	TextDrawColor(B_SwitchPublic, EditorButtonsColor);
	
	B_Selectable = TextDrawCreate(BUTTON_TD_SPACER * 16, EditorHeight, BUTTON_SELECTABLE);
	TextDrawFont(B_Selectable, 4);
	TextDrawTextSize(B_Selectable, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Selectable, true);
	TextDrawColor(B_Selectable, EditorButtonsColor);
	
	B_Proportionality = TextDrawCreate(BUTTON_TD_SPACER * 17, EditorHeight, BUTTON_PROPORTIONALITY);
	TextDrawFont(B_Proportionality, 4);
	TextDrawTextSize(B_Proportionality, BUTTON_TD_SIZE, BUTTON_TD_SIZE);
	TextDrawSetSelectable(B_Proportionality, true);
	TextDrawColor(B_Proportionality, EditorButtonsColor);
	
	return 1;
}

stock IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}
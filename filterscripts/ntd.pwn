/********************************************************************
*	Nickk's TextDraw editor											*
*	Release: 5.0												*
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

//INCLUDES
#include <a_samp>
#include <zcmd>
#include <dfile>
#include <rgb>
#include <sscanf>
#include <YSI\y_stringhash>
#include <YSI\y_iterate>
#include <ndialog-pages>

//DEFINES
#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

//SETTINGS
#define SCRIPT_VERSION 					"v5.0"
#define SCRIPT_VERSION_CHECK 			"5.0"
#define TD_PICKER_TEXT					"S"
// Limits
#define MAX_TEMPLATES					50
#define MAX_PROJECTS 					50
#define MAX_TDS							500
#define MAX_LANGUAGES					10
#define MAX_SPRITES 					100
#define MAX_LANGUAGE_DIALOGS			40
#define MAX_DIALOG_INFO					10
//
#define DEFAULT_LANG_STRING_SIZE		328
#define BUTTON_TD_SIZE					35.5
#define BUTTON_TD_SPACER				35.5
#define BUTTON_MINHEIGHT				15
#define BUTTON_MAXHEIGHT				412
#define CHANGING_VAR_TIME 				35
#define MAXFORMATEDTD 					28
#define BLOCK_VARS_TIME 				100
#define CURSOR_COLOR 					-8388353
#define BUTTON_TD_COLOR 				-1
#define DIALOG_DIALOG_ADDER				1000
#define TDPICKER_COLOR_ACTIVE 			0xFFFF00FF
#define TDPICKER_COLOR 					0xFFFFFF55
// File paths
#define PROJECTLIST_FILEPATH 			"NTD/projects.list"
#define LANGUAGESLIST_FILEPATH			"NTD/languages.list"
#define TEMPLATESLIST_FILEPATH			"NTD/templates.xml"
#define SETTINGS_FILEPATH 				"NTD/settings.ini"
#define LANGUAGES_PATH					"NTD/languages"

//DIALOG CAPTION TEXT
#define CAPTION_TEXT 					"{FFFFFF}NTD "SCRIPT_VERSION" - {00FF00}"

//RESOURCE NAMES
#define WELCOME_SCREEN 					"NTD_RESOURCES:Welcome_Screen"
#define BACKGROUND_BAR					"NTD_RESOURCES:BG_Bar"
#define BUTTON_EXIT 					"NTD_RESOURCES:Button_Exit"
#define BUTTON_SETTINGS 				"NTD_RESOURCES:Button_Settings"
#define BUTTON_NEW 						"NTD_RESOURCES:Button_New"
#define BUTTON_OPEN 					"NTD_RESOURCES:Button_Open"
#define BUTTON_CLOSE 					"NTD_RESOURCES:Button_Close"
#define BUTTON_EXPORT 					"NTD_RESOURCES:Button_Export"
#define BUTTON_MANAGE 					"NTD_RESOURCES:Button_Manage"
#define BUTTON_FONT 					"NTD_RESOURCES:Button_Font"
#define BUTTON_POSITION 				"NTD_RESOURCES:Button_Position"
#define BUTTON_SIZE 					"NTD_RESOURCES:Button_Size"
#define BUTTON_TEKST 					"NTD_RESOURCES:Button_Tekst"
#define BUTTON_COLOR 					"NTD_RESOURCES:Button_Color"
#define BUTTON_OUTLINE 					"NTD_RESOURCES:Button_Outline"
#define BUTTON_SHADOW 					"NTD_RESOURCES:Button_Shadow"
#define BUTTON_USEBOX 					"NTD_RESOURCES:Button_UseBox"
#define BUTTON_ALIGNMENT 				"NTD_RESOURCES:Button_Alignment"
#define BUTTON_SWITCHPUBLIC 			"NTD_RESOURCES:Button_SwitchPublic"
#define BUTTON_SELECTABLE 				"NTD_RESOURCES:Button_Selectable"
#define BUTTON_PROPORTIONALITY 			"NTD_RESOURCES:Button_Proportionality"
#define BUTTON_MPREVIEW 				"NTD_RESOURCES:Button_MPreview"

//LANGUAGES
#define LANG_NONE 						-1
#define LANGUAGE_LOADED 				0

//DIALOGS
#define DIALOG_LANGUAGE 				(0 + DIALOG_DIALOG_ADDER)
#define DIALOG_NEW 						(1 + DIALOG_DIALOG_ADDER)
#define DIALOG_OPEN 					(2 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANAGE 					(3 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANAGE2 					(4 + DIALOG_DIALOG_ADDER)
#define DIALOG_FONT 					(5 + DIALOG_DIALOG_ADDER)
#define DIALOG_TEKST 					(6 + DIALOG_DIALOG_ADDER)
#define DIALOG_COLOR1 					(7 + DIALOG_DIALOG_ADDER)
#define DIALOG_COLOR2 					(8 + DIALOG_DIALOG_ADDER)
#define DIALOG_COLOR3 					(9 + DIALOG_DIALOG_ADDER)
#define DIALOG_COLOR4 					(10 + DIALOG_DIALOG_ADDER)
#define DIALOG_SIZE 					(11 + DIALOG_DIALOG_ADDER)
#define DIALOG_OPEN2 					(12 + DIALOG_DIALOG_ADDER)
#define DIALOG_EXPORT 					(13 + DIALOG_DIALOG_ADDER)
#define DIALOG_INFO 					(14 + DIALOG_DIALOG_ADDER)
#define DIALOG_PREVIEWMODEL 			(15 + DIALOG_DIALOG_ADDER)
#define DIALOG_PREVIEWMODEL1 			(16 + DIALOG_DIALOG_ADDER)
#define DIALOG_EXIT 					(17 + DIALOG_DIALOG_ADDER)
#define DIALOG_SETTINGS 				(18 + DIALOG_DIALOG_ADDER)
#define DIALOG_SETTINGSCOLOR 			(19 + DIALOG_DIALOG_ADDER)
#define DIALOG_SETTINGSCOLOR1 			(20 + DIALOG_DIALOG_ADDER)
#define DIALOG_SETTINGRESET 			(21 + DIALOG_DIALOG_ADDER)
#define DIALOG_DELETEPROJECT 			(22 + DIALOG_DIALOG_ADDER)
#define DIALOG_DELETETD 				(23 + DIALOG_DIALOG_ADDER)
#define DIALOG_SPRITES1 				(24 + DIALOG_DIALOG_ADDER)
#define DIALOG_SPRITES2 				(25 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANAGE3 					(26 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANAGE4 					(27 + DIALOG_DIALOG_ADDER)
#define DIALOG_CHANGEPARAMNAME 			(28 + DIALOG_DIALOG_ADDER)
#define DIALOG_LANGUAGE_SETTINGS 		(29 + DIALOG_DIALOG_ADDER)
#define DIALOG_RENAMEPROJECT 			(30 + DIALOG_DIALOG_ADDER)
#define DIALOG_EXPORT2 					(31 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANUALVARCHANGE 			(32 + DIALOG_DIALOG_ADDER)
#define DIALOG_MANUALVARCHANGE1 		(33 + DIALOG_DIALOG_ADDER)

//SPRITES
#define SPRITE_TYPE_0 					"FONTS"
#define SPRITE_TYPE_1 					"HUD"
#define SPRITE_TYPE_2 					"INTRO 1-4"
#define SPRITE_TYPE_3 					"LD_BEAT"
#define SPRITE_TYPE_4 					"LD_BUM"
#define SPRITE_TYPE_5 					"LD_CARD"
#define SPRITE_TYPE_6 					"LD_CHAT"
#define SPRITE_TYPE_7 					"LD_DRV"
#define SPRITE_TYPE_8 					"LD_DUAL"
#define SPRITE_TYPE_9 					"LD_GRAV"
#define SPRITE_TYPE_10 					"LD_RACE"
#define SPRITE_TYPE_11 					"LD_RCE1"
#define SPRITE_TYPE_12 					"LD_RCE2"
#define SPRITE_TYPE_13 					"LD_RCE3"
#define SPRITE_TYPE_14 					"LD_RCE4 & LD_RCE5"
#define SPRITE_TYPE_15 					"LD_TATT"
#define SPRITE_TYPE_16 					"LOADSCS"
#define SPRITE_TYPE_17 					"VEHICLES"
#define SPRITE_TYPE_18 					"LD_POOL"
#define SPRITE_TYPE_19 					"SAMAPS"

//DIALOGLANGUAGE
#define DL_SETTINGS 					0
#define DL_SPRITECHANGE 				1
#define DL_OVERRIDECOLORCHANGE 			2
#define DL_BUTTONSCOLORCHANGE 			3
#define DL_SETTINGSRESET 				4
#define DL_NEWPROJECT 					5
#define DL_TDLIST 						6
#define DL_EXPORTPROJECT 				7
#define DL_NEWTEXTDRAW 					8
#define DL_PROJECTSLIST 				9
#define DL_EXITCONFIRMATION 			10
#define DL_TDOPTIONS 					11
#define DL_PROJECTSOPTIONS 				12
#define DL_PREVIEWMODELID 				13
#define DL_VARIABLECHANGE 				14
#define DL_COLORCHANGE 					15
#define DL_DELETECONFIRM 				16
#define DL_USETEMPLATE 					17
#define DL_PREMADECOLORS 				18
#define DL_PROJECTNAMECHANGE 			19
#define DL_DELETEPROJECTCONFIRM 		20
#define DL_PREVIEWMODELCHANGELIST 		21
#define DL_TEXTCHANGE 					22
#define DL_SPRITECHANGELIST 			23
#define DL_BOXSIZECHANGELIST 			24
#define DL_COLORCHANGELIST1 			25
#define DL_COLORCHANGELIST2 			26
#define DL_OLDVERSIONSETTINGSRESET 		27
#define DL_EXPORTWITHARRAY 				28
#define DL_MANUALVARCHANGE 				29
#define DL_MANUALVARCHANGE1 			30

//CHANGING TYPES
#define CH_NONE 						0
#define CH_EDITOR_POS 					1
#define CH_POSITION 					2
#define CH_MODEL_ROTATION 				3
#define CH_MODEL_ZOOM 					4
#define CH_MODEL_COLOR 					5
#define CH_SIZE 						6
#define CH_ALPHA 						7
#define CH_SPRITE 						8
#define CH_LAYER 						9

//ITERATORS
new Iterator:I_TEMPLATES<MAX_TEMPLATES>;
new Iterator:I_LANGUAGES<MAX_LANGUAGES>;
new Iterator:I_PROJECTS<MAX_PROJECTS>;
new Iterator:I_TEXTDRAWS<MAX_TDS>;

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

//ARRAYS

new Premade_Colors[][] =
{
	0x000000FF,
	0xFFFFFFFF,
	0xD3D3D3FF,
	0xBEBEBEFF,
	0x4D4D4DFF,
	0xC0C0C0FF,
	0xFF0000FF,
	0x8B0000FF,
	0xADD8E6FF,
	0x0000FFFF,
	0x00008bFF,
	0x4169E1FF,
	0x00FFFFFF,
	0x008B8BFF,
	0x87CEFAFF,
	0x6495EDFF,
	0x7CDC00FF,
	0x00FF00FF,
	0x008B00FF,
	0x556B2FFF,
	0x32CD32FF,
	0xFFFF00FF,
	0xFFD700FF,
	0xD2691EFF,
	0xFFFFF0FF,
	0xE6E6FAFF,
	0xF5F5DCFF,
	0xFF8000FF,
	0xEE7600FF,
	0xFF7F50FF,
	0xA52A2AFF,
	0xEE82EEFF,
	0x9400D3FF,
	0xFF80FFFF,
	0xFF00FFFF,
	0x663399FF,
	0x9932CCFF,
	0x68228BFF
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
	{17, "vehicle", "vehicleenvmap128"},
	
	{18, "ld_pool", "ball"},
	{18, "ld_pool", "nib"},
	
	{19, "samaps", "map"}
	
	
};

//ENUMERATORS

//Templates Data
enum E_TEMPLATE
{
	Template_Name[60],
	Template_Data[258]
};
new Template[MAX_TEMPLATES][E_TEMPLATE];

//Languages Data
enum E_LANGUAGE_STR_DIALOG
{
	d_s_caption[128],
	d_s_button1[32],
	d_s_button2[32]
}
new DLS[MAX_LANGUAGE_DIALOGS][E_LANGUAGE_STR_DIALOG]; //Dialog Language String
new DLI[MAX_LANGUAGE_DIALOGS][MAX_DIALOG_INFO][128]; //Dialog Language Info

enum E_LANGUAGE
{
	l_name[32],
	l_file[32]
}
new Language[MAX_LANGUAGES][E_LANGUAGE]; //Languages List

enum E_LANGUAGE_STR
{
	str_nopermit[DEFAULT_LANG_STRING_SIZE],
	str_editordisabled[DEFAULT_LANG_STRING_SIZE],
	str_editorinuse[DEFAULT_LANG_STRING_SIZE],
	str_infodialogcaption[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorleave[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorlocked[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorreset[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorkeyswiched[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorfsdisabled[DEFAULT_LANG_STRING_SIZE],
	str_infoeditorfsenabled[DEFAULT_LANG_STRING_SIZE],
	str_infoeditortdvisibility[DEFAULT_LANG_STRING_SIZE],
	str_infoinvalidmodelid[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectexported[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectexporterror[DEFAULT_LANG_STRING_SIZE],
	str_infoparamnamechange[DEFAULT_LANG_STRING_SIZE],
	str_infoparamnamechangetaken[DEFAULT_LANG_STRING_SIZE],
	str_infoparamnamechangecharserr[DEFAULT_LANG_STRING_SIZE],
	str_infoparamnamechangeammerr[DEFAULT_LANG_STRING_SIZE],
	str_infomaxtextdrawsreached[DEFAULT_LANG_STRING_SIZE],
	str_fsenabled[DEFAULT_LANG_STRING_SIZE],
	str_fsdisabled[DEFAULT_LANG_STRING_SIZE],
	str_tdvforme[DEFAULT_LANG_STRING_SIZE],
	str_tdvforall[DEFAULT_LANG_STRING_SIZE],
	str_keysinverted[DEFAULT_LANG_STRING_SIZE],
	str_infolanguagechanged[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectinvalidname[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectexists[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectcreated[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectclosed[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectsaveerror[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectlimit[DEFAULT_LANG_STRING_SIZE],
	str_infoprojectloaded[DEFAULT_LANG_STRING_SIZE],
	str_previewmodelidinvalid[DEFAULT_LANG_STRING_SIZE],
	str_tdclonedinfo[DEFAULT_LANG_STRING_SIZE],
	str_tddeletedinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdcreatedinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdselectedinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdfontspriteinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdfontprevmodelinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdfontinfo[DEFAULT_LANG_STRING_SIZE],
	str_tdcoloralpha[DEFAULT_LANG_STRING_SIZE],
	str_tdlayer[DEFAULT_LANG_STRING_SIZE],
	str_tdeditorposition[DEFAULT_LANG_STRING_SIZE],
	str_tdprevmodelcolor[DEFAULT_LANG_STRING_SIZE],
	str_tdposition[DEFAULT_LANG_STRING_SIZE],
	str_tdrotation[DEFAULT_LANG_STRING_SIZE],
	str_tdpremodelzoom[DEFAULT_LANG_STRING_SIZE],
	str_tdsize[DEFAULT_LANG_STRING_SIZE],
	str_tdsprite[DEFAULT_LANG_STRING_SIZE],
	str_tdproportionality_true[DEFAULT_LANG_STRING_SIZE],
	str_tdproportionality_false[DEFAULT_LANG_STRING_SIZE],
	str_tdalignment_left[DEFAULT_LANG_STRING_SIZE],
	str_tdalignment_center[DEFAULT_LANG_STRING_SIZE],
	str_tdalignment_right[DEFAULT_LANG_STRING_SIZE],
	str_projectrenamed[DEFAULT_LANG_STRING_SIZE],
	str_projectnamechangecharerr[DEFAULT_LANG_STRING_SIZE],
	str_projectnameexists[DEFAULT_LANG_STRING_SIZE],
	str_projectnamechangeerror[DEFAULT_LANG_STRING_SIZE],
	str_projectloaderror[DEFAULT_LANG_STRING_SIZE],
	str_projectdeleteerror[DEFAULT_LANG_STRING_SIZE],
	str_projectdeleted[DEFAULT_LANG_STRING_SIZE],
	str_modelpreviewinvalidfont[DEFAULT_LANG_STRING_SIZE],
	str_tdpublic[DEFAULT_LANG_STRING_SIZE],
	str_tdperplayer[DEFAULT_LANG_STRING_SIZE],
	str_tdclickable[DEFAULT_LANG_STRING_SIZE],
	str_tdnotclickable[DEFAULT_LANG_STRING_SIZE],
	str_tdshadowsize[DEFAULT_LANG_STRING_SIZE],
	str_tdboxenabled[DEFAULT_LANG_STRING_SIZE],
	str_tdboxdisabled[DEFAULT_LANG_STRING_SIZE],
	str_tdoutlinesize[DEFAULT_LANG_STRING_SIZE],
	str_modeltexterror[DEFAULT_LANG_STRING_SIZE],
	str_noprojectsfound[DEFAULT_LANG_STRING_SIZE],
	str_languagefilenotfound[DEFAULT_LANG_STRING_SIZE],
	str_infocompmodedisabled[DEFAULT_LANG_STRING_SIZE],
	str_infocompmodeenabled[DEFAULT_LANG_STRING_SIZE],
	str_compmodeenabled[DEFAULT_LANG_STRING_SIZE],
	str_compmodedisabled[DEFAULT_LANG_STRING_SIZE],
	str_exportarraymode[DEFAULT_LANG_STRING_SIZE],
	str_manualchangemessage[DEFAULT_LANG_STRING_SIZE],
	str_manualchangetypemzoom[DEFAULT_LANG_STRING_SIZE],
	str_manualchangetypemcolor1[DEFAULT_LANG_STRING_SIZE],
	str_manualchangetypemcolor2[DEFAULT_LANG_STRING_SIZE]
};
new Language_Strings[E_LANGUAGE_STR]; //Language strings

//Sprite Data
enum E_SPRITE
{
	Sprite_Lib[50],
	Sprite_Name[50]
}
new Sprite_Library[MAX_SPRITES][E_SPRITE]; //Sprites Data

//TextDraw Data
enum E_TD
{
	bool:TD_Created,
	bool:TD_UseBox,
	bool:TD_Selectable,
	bool:TD_Proportional,
	bool:TD_IsPublic,
	Float:TD_PosX,
	Float:TD_PosY,
	Float:TD_PrevRotX,
	Float:TD_PrevRotY,
	Float:TD_PrevRotZ,
	Float:TD_PrevRotZoom,
	Float:TD_LetterSizeX,
	Float:TD_LetterSizeY,
	Float:TD_BoxSizeX,
	Float:TD_BoxSizeY,
	Text:TD_SelfID,
	Text:TD_PickerID,
	TD_Text[300],
	TD_VarName[35],
	TD_PrevModelID,
	TD_PrevModelC1,
	TD_PrevModelC2,
	TD_Font,
	TD_OutlineSize,
	TD_ShadowSize,
	TD_Alignment,
	TD_Color,
	TD_ColorAlpha,
	TD_BGColor,
	TD_BGColorAlpha,
	TD_BoxColor,
	TD_BoxColorAlpha,
	TD_HighlightTimer
}
new NTD_TD[MAX_TDS][E_TD]; //Textdraws Data

//Player Data
enum E_USER
{
	bool:User_InEditor,
	bool:User_ProjectOpened,
	bool:User_Accelerate,
	bool:User_BlockVarsTime,
	User_ChangingState,
	User_ManualChangeType,
	User_ExportType,
	User_ProjectName[128],
	User_SpritePicker,
	User_SpriteIndex,
	User_WelcomeScreenColor,
	User_WelcomeScreenAlpha,
	User_ChangingSizeState,
	User_ChangingVarsTimer,
	User_WelcomeTimer,
	User_CursorTimer,
	User_PlayerIDInEditor,
	User_ChoosenTDID,
	User_EditingTDID,
	User_ChangingMColorState
}
new NTD_User[E_USER]; //User Data

//Project data
enum E_PROJECT
{
	Pro_Name[128],
	Pro_TDA,
	Pro_LastMin,
	Pro_LastHour,
	Pro_LastDay,
	Pro_LastMonth,
	Pro_LastYear
}
new NTD_Projects[MAX_PROJECTS][E_PROJECT]; //Projects Data

//OTHERS
new bool:ScriptScriptActive;
new bool:EditorQuickSelect;
new bool:EditorTextDrawShowForAll;
new bool:EditorCompactMode = false;
new bool:EditorVarUpdated;
new Float:EditorCompactSize = 2.0;
new EditorPosY;
new EditorPosX;
new EditorCursorColor;
new EditorButtonsColor;
new EditorFasterKey;
new EditorAcceptKey;
new EditorLanguage;
new EditorVersion[10];
new EditorLString[5000];
new EditorString[400];
new EditorLanguageFile[32];


//CALLBACKS
public OnFilterScriptInit()
{
	EditorLanguage = LANG_NONE;
	if(dfile_FileExists("/NTD") && dfile_FileExists("/NTD/Exports") && dfile_FileExists("/NTD/Projects") && dfile_FileExists(LANGUAGES_PATH))
	{
		ScriptScriptActive = true;
		printf("[NTD] TextDraw editor by Nickk888 %s has been successfully initialized!\n", SCRIPT_VERSION);
	}
	else
	{
		ScriptScriptActive = false;
		printf("\n[NTD ERROR] Could not find folder or folders!");
		printf("[NTD ERROR] Please create 'NTD' folder inside 'scriptfiles'!");
		printf("[NTD ERROR] Within 'NTD' you should create the 'Exports', 'Projects' and 'Languages' folder!");
		printf("[NTD ERROR] The script will be unloaded or blocked!\n");
		SendRconCommand("unloadfs ntd");
		return 1;
	}
	if(!dfile_FileExists(PROJECTLIST_FILEPATH))
		dfile_Create(PROJECTLIST_FILEPATH);
	if(!dfile_FileExists(LANGUAGESLIST_FILEPATH))
		dfile_Create(LANGUAGESLIST_FILEPATH);
	if(!dfile_FileExists(TEMPLATESLIST_FILEPATH))
		dfile_Create(TEMPLATESLIST_FILEPATH);
	if(!dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Create(SETTINGS_FILEPATH);
		dfile_Open(SETTINGS_FILEPATH);
		dfile_WriteFloat("editor_x", 0);
		dfile_WriteFloat("editor_y", BUTTON_MAXHEIGHT);
		dfile_WriteInt("editor_hcolor", CURSOR_COLOR);
		dfile_WriteInt("editor_bcolor", BUTTON_TD_COLOR);
		dfile_WriteInt("editor_fasterkey", KEY_JUMP);
		dfile_WriteInt("editor_acceptkey", KEY_SPRINT);
		dfile_WriteBool("editor_quickselect", true);
		dfile_WriteBool("editor_tdshowforall", false);
		dfile_WriteBool("editor_compactmode", false);
		dfile_WriteString("editor_scriptversion", SCRIPT_VERSION_CHECK);
		dfile_WriteString("editor_languagefile", "");
		dfile_SaveFile();
		dfile_CloseFile();
		EditorPosY = BUTTON_MAXHEIGHT;
		EditorCursorColor = CURSOR_COLOR;
		EditorButtonsColor = BUTTON_TD_COLOR;
		EditorFasterKey = KEY_JUMP;
		EditorAcceptKey = KEY_SPRINT;
		EditorQuickSelect = true;
		EditorTextDrawShowForAll = false;
		EditorLanguage = LANG_NONE;
		format(EditorVersion, sizeof EditorVersion, SCRIPT_VERSION_CHECK);
	}
	else LoadConfigurations();
	return 1;
}

public OnPlayerConnect(playerid)
{
	if(ScriptScriptActive && NTD_User[User_InEditor])
	{
		if(EditorTextDrawShowForAll)
		{
			foreach(new i : I_TEXTDRAWS)
			{
				TextDrawShowForPlayer(playerid, NTD_TD[i][TD_SelfID]);
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid)
{
	if(ScriptScriptActive && NTD_User[User_InEditor])
			if(NTD_User[User_PlayerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if(ScriptScriptActive && NTD_User[User_InEditor])
			if(NTD_User[User_PlayerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnFilterScriptExit()
{
	foreach(new i : Player)
	{
		if(ScriptScriptActive && NTD_User[User_InEditor])
			if(NTD_User[User_PlayerIDInEditor] == i)
			{
				cmd_ntd(i, "");
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
			}
	}
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{		
	if(ScriptScriptActive && NTD_User[User_InEditor])
	{
		if(newkeys & EditorAcceptKey)
		{
			if(playerid == NTD_User[User_PlayerIDInEditor])
			{
				if(NTD_User[User_ChangingState] != CH_NONE)
				{
					NTD_User[User_ChangingState] = CH_NONE;
					ShowEditorEx(playerid);
					EnableVarChangeTimer(false);
					PlayerSelectTD(playerid, true);
				}
			}
		}
		if(newkeys & EditorFasterKey)
		{
			if(NTD_User[User_ChangingState] != CH_NONE)
			{
				if(playerid == NTD_User[User_PlayerIDInEditor])
				{
					NTD_User[User_Accelerate] = true;
				}
			}
		}
		if(oldkeys & EditorFasterKey)
			NTD_User[User_Accelerate] = false;
		if(newkeys & KEY_WALK)
		{
			switch(NTD_User[User_ChangingState])
			{
				case CH_POSITION, CH_SIZE, CH_MODEL_ROTATION, CH_MODEL_ZOOM, CH_MODEL_COLOR:
				{
					if(playerid == NTD_User[User_PlayerIDInEditor])
				{
					ShowManualVarChangeDialog(playerid);
				}
				}
			}
		}
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	EditorLString = "";
	EditorString = "";
	if(ScriptScriptActive)
	{
		if(dialogid == DIALOG_LANGUAGE)
		{
			if(response)
			{
				format(EditorString, sizeof EditorString, "%s/%s", LANGUAGES_PATH, Language[listitem][l_file]);
				if(LanguageLoad(EditorString, Language[listitem][l_file]))
				{
					EditorLanguage = LANGUAGE_LOADED;
					format(EditorLanguageFile, sizeof EditorLanguageFile, Language[listitem][l_file]);
					SaveConfigurations();
				}
				cmd_ntd(playerid, " ");
			}
		}
	}
	if(dialogid == DIALOG_SETTINGRESET && !NTD_User[User_InEditor])
	{
		if(response)
		{
			ResetConfiguration(playerid);
			SaveConfigurations();
		}
		else
		{
			EditorVersion = SCRIPT_VERSION_CHECK;
			SaveConfigurations();
		}
		cmd_ntd(playerid, " ");
	}
	else if(ScriptScriptActive && NTD_User[User_InEditor])
	{
		new tdid = NTD_User[User_EditingTDID];
		switch(dialogid)
		{
			case DIALOG_MANUALVARCHANGE1:
			{
				if(response)
				{
					if(!isnull(inputtext))
					{
						switch(NTD_User[User_ChangingState])
						{
							case CH_POSITION:
							{
								switch(NTD_User[User_ManualChangeType])
								{
									case 0: //X
										NTD_TD[tdid][TD_PosX] = floatstr(inputtext);
									case 1: //Y
										NTD_TD[tdid][TD_PosY] = floatstr(inputtext);
								}
							}
							case CH_SIZE:
							{
								switch(NTD_User[User_ManualChangeType])
								{
									case 0: //X
									{
										if(NTD_User[User_ChangingSizeState] == 0)
											NTD_TD[tdid][TD_LetterSizeX] = floatstr(inputtext);
										else 
											NTD_TD[tdid][TD_BoxSizeX] = floatstr(inputtext);
									}
									case 1: //Y
									{
										if(NTD_User[User_ChangingSizeState] == 0)
											NTD_TD[tdid][TD_LetterSizeY] = floatstr(inputtext);
										else 
											NTD_TD[tdid][TD_BoxSizeY] = floatstr(inputtext);
									}
								}
							}
							case CH_MODEL_ROTATION:
							{
								switch(NTD_User[User_ManualChangeType])
								{
									case 0: //X
										NTD_TD[tdid][TD_PrevRotX] = floatstr(inputtext);
									case 1: //Y
										NTD_TD[tdid][TD_PrevRotY] = floatstr(inputtext);
									case 2: //Z
										NTD_TD[tdid][TD_PrevRotZ] = floatstr(inputtext);
								}
							}
							case CH_MODEL_ZOOM: //Zoom
							{
								NTD_TD[tdid][TD_PrevRotZoom] = floatstr(inputtext);
							}
							case CH_MODEL_COLOR:
							{
								switch(NTD_User[User_ManualChangeType])
								{
									case 0: //TD_Color 1
										NTD_TD[tdid][TD_PrevModelC1] = strval(inputtext);
									case 1: //TD_Color 2
										NTD_TD[tdid][TD_PrevModelC2] = strval(inputtext);
								}
							}
						}
						EditorVarUpdated = true;
					}
				}
				else ShowManualVarChangeDialog(playerid);
			}
			case DIALOG_MANUALVARCHANGE:
			{
				if(response)
				{
					NTD_User[User_ManualChangeType] = listitem;
					CreateDialogOnLanguageData(DL_MANUALVARCHANGE1);
					CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE1);
					switch(NTD_User[User_ChangingState])
					{
						case CH_POSITION:
						{
							switch(NTD_User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PosX]);
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PosY]);
								}
							}
						}
						case CH_SIZE:
						{
							switch(NTD_User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, (NTD_User[User_ChangingSizeState] == 0) ? (NTD_TD[tdid][TD_LetterSizeX]) : (NTD_TD[tdid][TD_BoxSizeX]));
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, (NTD_User[User_ChangingSizeState] == 0) ? (NTD_TD[tdid][TD_LetterSizeY]) : (NTD_TD[tdid][TD_BoxSizeY]));
								}
							}
						}
						case CH_MODEL_ROTATION:
						{
							switch(NTD_User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotX]);
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotY]);
								}
								case 2: //Z
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotZ]);
								}
							}
						}
						case CH_MODEL_ZOOM: //Zoom
						{
							strreplace(EditorLString, "#1", Language_Strings[str_manualchangetypemzoom]);
							strreplace(EditorLString, "#2", "%f");
							format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotZoom]);
						}
						case CH_MODEL_COLOR:
						{
							switch(NTD_User[User_ManualChangeType])
							{
								case 0: //TD_Color 1
								{
									strreplace(EditorLString, "#1",  Language_Strings[str_manualchangetypemcolor1]);
									strreplace(EditorLString, "#2", "%i");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevModelC1]);
								}
								case 1: //TD_Color 2
								{
									strreplace(EditorLString, "#1",  Language_Strings[str_manualchangetypemcolor2]);
									strreplace(EditorLString, "#2", "%i");
									format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevModelC2]);
								}
							}
						}
					}
					ShowPlayerDialog(playerid, DIALOG_MANUALVARCHANGE1, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_MANUALVARCHANGE1][d_s_button1], DLS[DL_MANUALVARCHANGE1][d_s_button2]);
				}
			}
			case DIALOG_SPRITES2:
			{
				if(response)
				{
					new sindex;
					for(new i; i < sizeof Sprites; i++)
					{
						if(Sprites[i][0][0] == listitem)
						{
							format(Sprite_Library[sindex][Sprite_Lib], 50, Sprites[i][1]); 
							format(Sprite_Library[sindex][Sprite_Name], 50, Sprites[i][2]); 
							sindex++;
						}
					}
					NTD_User[User_SpriteIndex] = sindex;
					NTD_User[User_SpritePicker] = 0;
					NTD_User[User_ChangingState] = CH_SPRITE;
					EnableVarChangeTimer(true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
				else OnPlayerClickTextDraw(playerid, B_Tekst);
			}
			case DIALOG_INFO: 
				ShowEditorEx(playerid);
			case DIALOG_SPRITES1:
			{
				if(response)
				{
					if(listitem == 0) //Wpisz recznie
					{
						CreateDialogOnLanguageData(DL_SPRITECHANGE);
						CreateDialogCaptionOnLangData(DL_SPRITECHANGE);
						ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_SPRITECHANGE][d_s_button1], DLS[DL_SPRITECHANGE][d_s_button2]);
					}
					else if(listitem == 1) //Biblioteka
					{
						strcat(EditorLString, SPRITE_TYPE_0"\n");
						strcat(EditorLString, SPRITE_TYPE_1"\n");
						strcat(EditorLString, SPRITE_TYPE_2"\n");
						strcat(EditorLString, SPRITE_TYPE_3"\n");
						strcat(EditorLString, SPRITE_TYPE_4"\n");
						strcat(EditorLString, SPRITE_TYPE_5"\n");
						strcat(EditorLString, SPRITE_TYPE_6"\n");
						strcat(EditorLString, SPRITE_TYPE_7"\n");
						strcat(EditorLString, SPRITE_TYPE_8"\n");
						strcat(EditorLString, SPRITE_TYPE_9"\n");
						strcat(EditorLString, SPRITE_TYPE_10"\n");
						strcat(EditorLString, SPRITE_TYPE_11"\n");
						strcat(EditorLString, SPRITE_TYPE_12"\n");
						strcat(EditorLString, SPRITE_TYPE_13"\n");
						strcat(EditorLString, SPRITE_TYPE_14"\n");
						strcat(EditorLString, SPRITE_TYPE_15"\n");
						strcat(EditorLString, SPRITE_TYPE_16"\n");
						strcat(EditorLString, SPRITE_TYPE_17"\n");
						strcat(EditorLString, SPRITE_TYPE_18"\n");
						strcat(EditorLString, SPRITE_TYPE_19);
						CreateDialogCaptionOnLangData(DL_SPRITECHANGE);
						ShowPlayerDialog(playerid, DIALOG_SPRITES2, DIALOG_STYLE_LIST, EditorString, EditorLString,  DLS[DL_SPRITECHANGE][d_s_button1], DLS[DL_SPRITECHANGE][d_s_button2]);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_SETTINGRESET:
			{
				if(response)
				{
					ResetConfiguration(playerid);
					DestroyEditor();
					CreateEditor();
					ShowEditorEx(playerid);
					SaveConfigurations();
					PlayerSelectTD(playerid, false);
					ShowInfo(playerid, Language_Strings[str_infoeditorreset]);
				}
				else
				{
					EditorVersion = SCRIPT_VERSION_CHECK;
					SaveConfigurations();
					ShowEditorEx(playerid);
				}
			}
			case DIALOG_SETTINGSCOLOR1:
			{
				if(response)
				{
					EditorButtonsColor = Premade_Colors[listitem + 1][0];
					DestroyEditor();
					CreateEditor();
					ShowEditorEx(playerid);
				}
				else OnPlayerClickTextDraw(playerid, B_Settings);
			}
			case DIALOG_SETTINGSCOLOR:
			{
				if(response)
				{
					EditorCursorColor = Premade_Colors[listitem + 1][0];
					ShowEditorEx(playerid);
				}
				else OnPlayerClickTextDraw(playerid, B_Settings);
			}
			case DIALOG_SETTINGS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: //Pozycja Edytora
						{
							NTD_User[User_ChangingState] = CH_EDITOR_POS;
							EnableVarChangeTimer(true);
							PlayerSelectTD(playerid, false);
						}
						case 1: //Zmien kolor najechania
						{
							for(new i = 1; i < sizeof Premade_Colors; i++)
							{
								format(EditorString, sizeof EditorString, "%s############################\n", GetColorRGBA(Premade_Colors[i][0]));
								strcat(EditorLString, EditorString);
							}
							CreateDialogCaptionOnLangData(DL_OVERRIDECOLORCHANGE);
							ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_OVERRIDECOLORCHANGE][d_s_button1], DLS[DL_OVERRIDECOLORCHANGE][d_s_button2]);
						}
						case 2: //Zmien kolor przyciskow
						{
							for(new i = 1; i < sizeof Premade_Colors; i++)
							{
								format(EditorString, sizeof EditorString, "%s############################\n", GetColorRGBA(Premade_Colors[i][0]));
								strcat(EditorLString, EditorString);
							}
							CreateDialogCaptionOnLangData(DL_BUTTONSCOLORCHANGE);
							ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR1, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_BUTTONSCOLORCHANGE][d_s_button1], DLS[DL_BUTTONSCOLORCHANGE][d_s_button2]);
						}
						case 3: //Odwroc Shift z Spacja
						{
							new keyA = EditorFasterKey;
							new keyB = EditorAcceptKey;
							EditorFasterKey = keyB;
							EditorAcceptKey = keyA;
							ShowInfo(playerid, Language_Strings[str_infoeditorkeyswiched]);
						}
						case 4: //Szybki wybor
						{
							if(EditorQuickSelect)
							{
								EditorQuickSelect = false;
								QuickSelectionShow(playerid, false);
								ShowInfo(playerid, Language_Strings[str_infoeditorfsdisabled]);
							}
							else
							{
								EditorQuickSelect = true;
								QuickSelectionShow(playerid, true);
								ShowInfo(playerid, Language_Strings[str_infoeditorfsenabled]);
							}
							
						}
						case 5: //Wyswietlanie TextDrawow
						{
							if(EditorTextDrawShowForAll) 
								ToggleTextDrawShowForAll(false);
							else
								ToggleTextDrawShowForAll(true);
							ShowInfo(playerid, Language_Strings[str_infoeditortdvisibility]);
						}
						case 6: //Tryb kompaktowy
						{
							if(EditorCompactMode)
							{
								EditorCompactMode = false;
								ShowInfo(playerid, Language_Strings[str_infocompmodedisabled]);
							}
							else
							{
								EditorCompactMode = true;
								ShowInfo(playerid, Language_Strings[str_infocompmodeenabled]);
							}
							DestroyEditor();
							CreateEditor();
							ShowEditorEx(playerid);
						}
						case 7: //Zmien jezyk
							ShowLanguageChangeDialog(playerid, DIALOG_LANGUAGE_SETTINGS);
						case 8: //Ustawienia fabryczne
						{
							CreateDialogOnLanguageData(DL_SETTINGSRESET);
							CreateDialogCaptionOnLangData(DL_SETTINGSRESET);
							ShowPlayerDialog(playerid, DIALOG_SETTINGRESET, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_SETTINGSRESET][d_s_button1], DLS[DL_SETTINGSRESET][d_s_button2]);
						}
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_LANGUAGE_SETTINGS:
			{
				if(response)
				{
					format(EditorString, sizeof EditorString, "%s/%s", LANGUAGES_PATH, Language[listitem][l_file]);
					if(LanguageLoad(EditorString, Language[listitem][l_file]))
					{
						EditorLanguage = LANGUAGE_LOADED;
						format(EditorLanguageFile, sizeof EditorLanguageFile, Language[listitem][l_file]);
						SaveConfigurations();
						cmd_ntd(playerid, " ");
						cmd_ntd(playerid, " ");
						ShowInfo(playerid, Language_Strings[str_infolanguagechanged]);
					}
					else ShowInfo(playerid, Language_Strings[str_languagefilenotfound]);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_EXIT:
			{
				if(response)
					cmd_ntd(playerid, " ");
				else
					ShowEditorEx(playerid);
			}
			case DIALOG_PREVIEWMODEL1:
			{
				if(response)
				{
					if(IsNumeric(inputtext) && strval(inputtext) >= 0)
					{
						NTD_TD[tdid][TD_PrevModelID] = strval(inputtext);
						UpdateTD(playerid, tdid);
						ShowEditorEx(playerid);
					}
					else 
					{
						ShowInfo(playerid, Language_Strings[str_previewmodelidinvalid]);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_PREVIEWMODEL:
			{
				if(response)
				{
					if(listitem == 0) //Zmien Model
					{
						CreateDialogOnLanguageData(DL_PREVIEWMODELID);
						CreateDialogCaptionOnLangData(DL_PREVIEWMODELID);
						ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL1, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_PREVIEWMODELID][d_s_button1], DLS[DL_PREVIEWMODELID][d_s_button2]);
					}
					else if(listitem > 0)
					{
						if(listitem == 1) NTD_User[User_ChangingState] = CH_MODEL_ROTATION;
						else if(listitem == 2) NTD_User[User_ChangingState] = CH_MODEL_ZOOM;
						else if(listitem == 3) NTD_User[User_ChangingState] = CH_MODEL_COLOR;
						EnableVarChangeTimer(true);
						PlayerSelectTD(playerid, false);
						HideEditor(playerid);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_EXPORT2:
			{
				if(ExportProject(NTD_User[User_ProjectName], NTD_User[User_ExportType], bool:response))
				{
					format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectexported]);
					format(EditorString, sizeof EditorString, " {00FFFF}scriptfiles / NTD / Exports / %s.pwn", NTD_User[User_ProjectName]);
					strcat(EditorLString, EditorString);
					strreplace(EditorLString, "#n", "\n");
					ShowInfo(playerid, EditorLString);
				}
				else 
					ShowInfo(playerid, Language_Strings[str_infoprojectexporterror]);
			}
			case DIALOG_EXPORT:
			{
				if(response)
				{
					NTD_User[User_ExportType] = listitem;
					CreateDialogOnLanguageData(DL_EXPORTWITHARRAY);
					CreateDialogCaptionOnLangData(DL_EXPORTWITHARRAY);
					ShowPlayerDialog(playerid, DIALOG_EXPORT2, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_EXPORTWITHARRAY][d_s_button1], DLS[DL_EXPORTWITHARRAY][d_s_button2]);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_SIZE:
			{
				if(response)
				{
					NTD_User[User_ChangingSizeState] = listitem;
					NTD_User[User_ChangingState] = CH_SIZE;
					EnableVarChangeTimer(true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_COLOR3:
			{
				if(response)
				{
					new red, green, blue, alpha, color;
					RGBAToHex(Premade_Colors[listitem][0],red,green,blue, alpha); 
					#pragma unused alpha
					switch(NTD_User[User_ChangingMColorState])
					{
						case 0: //Tekst TD_Color
						{
							HexToRGBA(color,red,green,blue,NTD_TD[tdid][TD_ColorAlpha]);
							NTD_TD[tdid][TD_Color] = color;
						}
						case 1: //BG TD_Color
						{
							HexToRGBA(color,red,green,blue,NTD_TD[tdid][TD_BGColorAlpha]);
							NTD_TD[tdid][TD_BGColor] = color;
						}
						case 2: //Box TD_Color
						{
							HexToRGBA(color,red,green,blue,NTD_TD[tdid][TD_BoxColorAlpha]);
							NTD_TD[tdid][TD_BoxColor] = color;
						}
					}
					UpdateTD(playerid, tdid);
					ShowEditorEx(playerid);
				}
				else ColorDialog(playerid, 1);
			}
			case DIALOG_COLOR4:
			{
				if(response)
				{
					if(strlen(inputtext) >= 1)
					{
						new color[4];
						if(sscanf(inputtext, "iiii", color[0], color[1], color[2], color[3]) == 0) //RGBA
						{
							HexToRGBA(color[0], color[0], color[1], color[2], color[3]);
						}
						else if(strlen(inputtext) == 8) //HEX
						{
							color[0] = HexToInt(inputtext);
						}
						switch(NTD_User[User_ChangingMColorState])
						{
							case 0: //Tekst TD_Color
							{
								NTD_TD[tdid][TD_Color] = color[0];
								NTD_TD[tdid][TD_ColorAlpha] = GetAFromRGBA(color[0]);
							}
							case 1: //BG TD_Color
							{
								NTD_TD[tdid][TD_BGColor] = color[0];
								NTD_TD[tdid][TD_BGColorAlpha] = GetAFromRGBA(color[0]);
							}
							case 2: //Box TD_Color
							{
								NTD_TD[tdid][TD_BoxColor] = color[0];
								NTD_TD[tdid][TD_BoxColorAlpha] = GetAFromRGBA(color[0]);
							}
						}
						UpdateTD(playerid, tdid);
						ShowEditorEx(playerid);
					}
				}
				else ColorDialog(playerid, 1);
			}
			case DIALOG_COLOR2:
			{
				if(response)
				{
					if(listitem == 0) //Gotowe kolory
					{
						for(new i; i < sizeof Premade_Colors; i++)
						{
							format(EditorString, sizeof EditorString, "%s############################\n", GetColorRGBA(Premade_Colors[i][0]));
							strcat(EditorLString, EditorString);
						}
						CreateDialogCaptionOnLangData(DL_PREMADECOLORS);
						ShowPlayerDialog(playerid, DIALOG_COLOR3, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_PREMADECOLORS][d_s_button1], DLS[DL_PREMADECOLORS][d_s_button2]);
					}
					else if(listitem == 1) //Kombinator
					{
						new color[4], tmp_str[12];
						switch(NTD_User[User_ChangingMColorState])
						{
							case 0: RGBAToHex(NTD_TD[tdid][TD_Color],color[0],color[1],color[2],color[3]);
							case 1: RGBAToHex(NTD_TD[tdid][TD_BGColor],color[0],color[1],color[2],color[3]);
							case 2: RGBAToHex(NTD_TD[tdid][TD_BoxColor],color[0],color[1],color[2],color[3]);
						}
						CreateDialogOnLanguageData(DL_COLORCHANGE);
						CreateDialogCaptionOnLangData(DL_COLORCHANGE);
						format(tmp_str, sizeof tmp_str, "%i", color[0]);
						strreplace(EditorLString, "#1", tmp_str);
						format(tmp_str, sizeof tmp_str, "%i", color[1]);
						strreplace(EditorLString, "#2", tmp_str);
						format(tmp_str, sizeof tmp_str, "%i", color[2]);
						strreplace(EditorLString, "#3", tmp_str);
						format(tmp_str, sizeof tmp_str, "%i", color[3]);
						strreplace(EditorLString, "#4", tmp_str);
						format(tmp_str, sizeof tmp_str, "%x", NTD_TD[tdid][TD_Color]);
						strreplace(EditorLString, "#5", tmp_str);
						ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_COLORCHANGE][d_s_button1], DLS[DL_COLORCHANGE][d_s_button2]);
					}
					else if(listitem == 2) //Przezroczystosc
					{
						NTD_User[User_ChangingState] = CH_ALPHA;
						EnableVarChangeTimer(true);
						PlayerSelectTD(playerid, false);
						HideEditor(playerid);
					}
				}
				else ColorDialog(playerid, 0);
			}
			case DIALOG_COLOR1:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: //Tekst kolor
						{
							NTD_User[User_ChangingMColorState] = 0;
							ColorDialog(playerid, 1);
						}
						case 1: //Kolor tla
						{
							NTD_User[User_ChangingMColorState] = 1;
							ColorDialog(playerid, 1);
						}
						case 2: //Box TD_Color
						{
							NTD_User[User_ChangingMColorState] = 2;
							ColorDialog(playerid, 1);
						}
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_TEKST:
			{
				if(response)
				{
					if(strlen(inputtext))
					{
						format(NTD_TD[tdid][TD_Text], 300, inputtext);
						TextDrawDestroy(NTD_TD[tdid][TD_SelfID]);
						TextDrawDestroy(NTD_TD[tdid][TD_PickerID]);
						DrawTD(tdid);
						ShowEditorEx(playerid);
					}
					else ShowEditorEx(playerid);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_CHANGEPARAMNAME:
			{
				if(response)
				{
					if(strlen(inputtext) != 0)
					{
						if(strlen(inputtext) < 35)
						{
							if(IsValidString(inputtext))
							{
								if(VariableExists(inputtext) == false)
								{
									format(NTD_TD[NTD_User[User_ChoosenTDID]][TD_VarName], 35, inputtext);
									format(EditorLString, sizeof EditorLString, Language_Strings[str_infoparamnamechange]);
									strreplace(EditorLString, "#n", "\n");
									strreplace(EditorLString, "#1", NTD_TD[NTD_User[User_ChoosenTDID]][TD_VarName]);
									strreplace(EditorLString, "#2", NTD_TD[NTD_User[User_ChoosenTDID]][TD_Text]);
									ShowInfo(playerid, EditorLString);
								}
								else ShowInfo(playerid, Language_Strings[str_infoparamnamechangetaken]);
							}
							else ShowInfo(playerid, Language_Strings[str_infoparamnamechangecharserr]);
						}
						else ShowInfo(playerid, Language_Strings[str_infoparamnamechangeammerr]);
					}
					else
					{
						format(NTD_TD[NTD_User[User_ChoosenTDID]][TD_VarName], 35, "");
						ShowEditorEx(playerid);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_MANAGE2:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: //Modyfikuj
						{
							SelectTD(playerid, NTD_User[User_ChoosenTDID]);
							ShowEditorEx(playerid);
						}
						case 1: //Sklonuj
						{
							tdid = CreateNewTD(NTD_User[User_ChoosenTDID]);
							if(tdid != -1)
							{
								DrawTD(tdid);
								SelectTD(playerid, tdid);
								//
								new tmp_str[12];
								format(EditorString, sizeof EditorString, Language_Strings[str_tdclonedinfo]);
								format(tmp_str, sizeof tmp_str, "%i", NTD_User[User_ChoosenTDID]);
								strreplace(EditorString, "#1", tmp_str);
								//
								GameTextForPlayer(playerid, EditorString, 5000, 6);
								PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
								RelayerEditor();
								ShowEditorEx(playerid, true);
							}
							else ShowInfo(playerid, Language_Strings[str_infomaxtextdrawsreached]);
						}
						case 2: //Zmien warstwe
						{
							NTD_User[User_ChangingState] = CH_LAYER;
							EnableVarChangeTimer(true);
							PlayerSelectTD(playerid, false);
							HideEditor(playerid);
						}
						case 3: //Zmien nazwe parametru
						{
							CreateDialogOnLanguageData(DL_VARIABLECHANGE);
							CreateDialogCaptionOnLangData(DL_VARIABLECHANGE);
							strreplace(EditorLString, "#1", GetProcessedTDVarName(NTD_User[User_ChoosenTDID]));
							strreplace(EditorLString, "#2", NTD_TD[NTD_User[User_ChoosenTDID]][TD_Text]);
							ShowPlayerDialog(playerid, DIALOG_CHANGEPARAMNAME, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_VARIABLECHANGE][d_s_button1], DLS[DL_VARIABLECHANGE][d_s_button2]);
						}
						case 4: //Usun
						{
							new formatedtd[MAXFORMATEDTD];
							format(formatedtd, MAXFORMATEDTD, NTD_TD[NTD_User[User_ChoosenTDID]][TD_Text]);
							if(strlen(NTD_TD[NTD_User[User_ChoosenTDID]][TD_Text]) > MAXFORMATEDTD - 4)
							{
								strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
								strcat(formatedtd, "...");
							}
							CreateDialogOnLanguageData(DL_DELETECONFIRM);
							CreateDialogCaptionOnLangData(DL_DELETECONFIRM);
							strreplace(EditorLString, "#1", formatedtd);
							ShowPlayerDialog(playerid, DIALOG_DELETETD, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_DELETECONFIRM][d_s_button1], DLS[DL_DELETECONFIRM][d_s_button2]);
						}
					}
					
				}
				else ShowEditorEx(playerid, true);
			}
			case DIALOG_DELETETD:
			{
				if(response)
				{
					DestroyTD(NTD_User[User_ChoosenTDID]);
					Iter_Remove(I_TEXTDRAWS, NTD_User[User_ChoosenTDID]);
					if(NTD_User[User_EditingTDID] == NTD_User[User_ChoosenTDID])
						NTD_User[User_EditingTDID] = -1;
					//
					new tmp_str[12];
					format(EditorString, sizeof EditorString, Language_Strings[str_tddeletedinfo]);
					format(tmp_str, sizeof tmp_str, "%i", NTD_User[User_ChoosenTDID]);
					strreplace(EditorString, "#1", tmp_str);
					//
					GameTextForPlayer(playerid, EditorString, 5000, 6);
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid, true);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_MANAGE4:
			{
				if(response)
				{
					tdid = CreateNewTDFromTemplate(listitem);
					if(tdid != -1)
					{
						DrawTD(tdid);
						SelectTD(playerid, tdid);
						//
						new tmp_str[12];
						format(EditorString, sizeof EditorString, Language_Strings[str_tdcreatedinfo]);
						format(tmp_str, sizeof tmp_str, "%i", tdid);
						strreplace(EditorString, "#1", tmp_str);
						//
						GameTextForPlayer(playerid, EditorString, 5000, 6);
						PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
						RelayerEditor();
						ShowEditorEx(playerid, true);
						
					}
					else ShowInfo(playerid, Language_Strings[str_infomaxtextdrawsreached]);
				}
				else ShowEditorEx(playerid, true);
			}
			case DIALOG_MANAGE3:
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
							//
							new tmp_str[12];
							format(EditorString, sizeof EditorString, Language_Strings[str_tdcreatedinfo]);
							format(tmp_str, sizeof tmp_str, "%i", tdid);
							strreplace(EditorString, "#1", tmp_str);
							//
							PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
							GameTextForPlayer(playerid, EditorString, 5000, 6);
							//
							RelayerEditor();
							ShowEditorEx(playerid, true);
							
						}
						else ShowInfo(playerid, Language_Strings[str_infomaxtextdrawsreached]);
					}
					else if(listitem == 1) //Uzyj Szablon
					{
						foreach(new i : I_TEMPLATES)
						{
							format(EditorString, sizeof EditorString, "{FF8040}%s\n", Template[i][Template_Name]);
							strcat(EditorLString, EditorString);
						}
						CreateDialogCaptionOnLangData(DL_USETEMPLATE);
						ShowPlayerDialog(playerid, DIALOG_MANAGE4, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_USETEMPLATE][d_s_button1], DLS[DL_USETEMPLATE][d_s_button2]);
					}
				}
				else ShowEditorEx(playerid, true);
			}
			case DIALOG_MANAGE:
			{
				if(response)
				{
					if(listitem == INVALID_LISTITEM) 
						return 0;
					if(listitem == 0) //Stworz nowy TD
					{
						CreateDialogOnLanguageData(DL_NEWTEXTDRAW);
						CreateDialogCaptionOnLangData(DL_NEWTEXTDRAW);
						ShowPlayerDialog(playerid, DIALOG_MANAGE3, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_NEWTEXTDRAW][d_s_button1], DLS[DL_NEWTEXTDRAW][d_s_button2]);
					}
					else //TDS
					{
						new index = Iter_Index(I_TEXTDRAWS, (listitem - 1));
						ShowTDOptions(index);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_RENAMEPROJECT:
			{
				if(response)
				{
					new oldproname[60];
					format(oldproname, 60, NTD_User[User_ProjectName]);
					new changepn = RenameProject(oldproname, inputtext);
					switch(changepn)
					{
						case 1:
						{
							format(EditorLString, sizeof EditorLString, Language_Strings[str_projectrenamed]);
							strreplace(EditorLString, "#n", "\n");
							strreplace(EditorLString, "#1", oldproname);
							strreplace(EditorLString, "#2", NTD_User[User_ProjectName]);
							ShowInfo(playerid, EditorLString);
						} 
						case 2: ShowInfo(playerid, Language_Strings[str_projectnamechangecharerr]);
						case 3: ShowInfo(playerid, Language_Strings[str_projectnameexists]);
						case -1: ShowInfo(playerid, Language_Strings[str_projectnamechangeerror]);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_OPEN2:
			{
				if(listitem == INVALID_LISTITEM) 
					return 0;
				if(response)
				{
					switch(listitem)
					{
						case 0: //Wczytaj
						{
							if(LoadProject(NTD_User[User_ProjectName]))
							{
								format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectloaded]);
								strreplace(EditorLString, "#1", NTD_User[User_ProjectName]);
								ShowInfo(playerid, EditorLString);
								ShowWelcomeScreen(false);
								RelayerEditor();
								ShowEditorEx(playerid);
							}
							else ShowInfo(playerid, Language_Strings[str_projectloaderror]);
						}
						case 1: //Zmien nazwe
						{
							CreateDialogOnLanguageData(DL_PROJECTNAMECHANGE);
							CreateDialogCaptionOnLangData(DL_PROJECTNAMECHANGE);
							strreplace(EditorLString, "#1", NTD_User[User_ProjectName]);
							ShowPlayerDialog(playerid, DIALOG_RENAMEPROJECT, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_PROJECTNAMECHANGE][d_s_button1], DLS[DL_PROJECTNAMECHANGE][d_s_button2]);
							PlayerSelectTD(playerid, false);
						}
						case 2: //Usun
						{
							CreateDialogOnLanguageData(DL_DELETEPROJECTCONFIRM);
							CreateDialogCaptionOnLangData(DL_DELETEPROJECTCONFIRM);
							ShowPlayerDialog(playerid, DIALOG_DELETEPROJECT, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_DELETEPROJECTCONFIRM][d_s_button1], DLS[DL_DELETEPROJECTCONFIRM][d_s_button2]);
						}
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_OPEN:
			{
				if(response)
				{
					if(listitem == INVALID_LISTITEM) 
						return 0;
					new index = Iter_Index(I_PROJECTS, listitem);
					format(NTD_User[User_ProjectName], 128, NTD_Projects[index][Pro_Name]);
					CreateDialogOnLanguageData(DL_PROJECTSOPTIONS);
					CreateDialogCaptionOnLangData(DL_PROJECTSOPTIONS);
					ShowPlayerDialog(playerid, DIALOG_OPEN2, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_PROJECTSOPTIONS][d_s_button1], DLS[DL_PROJECTSOPTIONS][d_s_button2]);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_DELETEPROJECT:
			{
				if(response)
				{
					if(DeleteProject(NTD_User[User_ProjectName]))
					{
						format(EditorLString, sizeof EditorLString, Language_Strings[str_projectdeleted]);
						strreplace(EditorLString, "#1", NTD_User[User_ProjectName]);
						ShowInfo(playerid, EditorLString);
						GetAllProjects();
					}
					else ShowInfo(playerid, Language_Strings[str_projectdeleteerror]);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_NEW:
			{
				if(response)
				{
					format(NTD_User[User_ProjectName], 128, inputtext);
					if(strlen(NTD_User[User_ProjectName]) > 0 && strlen(NTD_User[User_ProjectName]) < 40 && IsValidString(NTD_User[User_ProjectName]))
					{
						new pid = CreateProject(NTD_User[User_ProjectName]);
						if(pid != -1)
						{
							LoadProject(NTD_User[User_ProjectName]);
							format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectcreated]);
							strreplace(EditorLString, "#1", NTD_User[User_ProjectName]);
							ShowInfo(playerid, EditorLString);
							ShowWelcomeScreen(false);
							ShowEditorEx(playerid);
						}
						else ShowInfo(playerid, Language_Strings[str_infoprojectexists]);
					}
					else ShowInfo(playerid, Language_Strings[str_infoprojectinvalidname]);
				}
				else ShowEditorEx(playerid);
			}
		}
	}
	return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(ScriptScriptActive && NTD_User[User_InEditor])
	{
		new tdid = NTD_User[User_EditingTDID];
		if(NTD_User[User_ProjectOpened] && EditorQuickSelect)
		{
			foreach(new i : I_TEXTDRAWS)
			{
				if(clickedid == NTD_TD[i][TD_PickerID])
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
			CreateDialogOnLanguageData(DL_EXITCONFIRMATION);
			CreateDialogCaptionOnLangData(DL_EXITCONFIRMATION);
			ShowPlayerDialog(playerid, DIALOG_EXIT, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_EXITCONFIRMATION][d_s_button1], DLS[DL_EXITCONFIRMATION][d_s_button2]);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Settings)
		{
			new invertedstr[40], quickselectstr[30], compmodestr[30], tdvisistr[60];
			if(EditorAcceptKey == KEY_JUMP && EditorFasterKey == KEY_SPRINT)
				format(invertedstr, sizeof invertedstr, "{FFFFFF}[%s]", Language_Strings[str_keysinverted]);
				
			if(EditorQuickSelect)
				format(quickselectstr, sizeof quickselectstr, Language_Strings[str_fsenabled]);
			else 
				format(quickselectstr, sizeof quickselectstr, Language_Strings[str_fsdisabled]);
			
			if(EditorTextDrawShowForAll)
				format(tdvisistr, sizeof tdvisistr, Language_Strings[str_tdvforall]);
			else 
				format(tdvisistr, sizeof tdvisistr, Language_Strings[str_tdvforme]);
				
			if(EditorCompactMode)
				format(compmodestr, sizeof compmodestr, Language_Strings[str_compmodeenabled]);
			else 
				format(compmodestr, sizeof compmodestr, Language_Strings[str_compmodedisabled]);
			
			CreateDialogOnLanguageData(DL_SETTINGS);
			strreplace(EditorLString, "#1", invertedstr);
			strreplace(EditorLString, "#2", quickselectstr);
			strreplace(EditorLString, "#3", tdvisistr);
			strreplace(EditorLString, "#4", compmodestr);
			CreateDialogCaptionOnLangData(DL_SETTINGS);
			ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_SETTINGS][d_s_button1], DLS[DL_SETTINGS][d_s_button2]);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_MPreview)
		{
			if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			{
				CreateDialogOnLanguageData(DL_PREVIEWMODELCHANGELIST);
				CreateDialogCaptionOnLangData(DL_PREVIEWMODELCHANGELIST);
				ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_PREVIEWMODELCHANGELIST][d_s_button1], DLS[DL_PREVIEWMODELCHANGELIST][d_s_button2]);
				PlayerSelectTD(playerid, false);
			}
			else 
			{
				ShowInfo(NTD_User[User_PlayerIDInEditor], Language_Strings[str_modelpreviewinvalidfont]);
				PlayerSelectTD(playerid, false);
			}
			return 1;
		}
		else if(clickedid == B_Proportionality)
		{
			if(NTD_TD[tdid][TD_Proportional] == false)
			{
				NTD_TD[tdid][TD_Proportional] = true;
				GameTextForPlayer(playerid, Language_Strings[str_tdproportionality_true], 1500, 6);
			}
			else 
			{
				NTD_TD[tdid][TD_Proportional] = false;
				GameTextForPlayer(playerid, Language_Strings[str_tdproportionality_false], 1500, 6);
			}
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Alignment)
		{
			if(NTD_TD[tdid][TD_Alignment] == 3)
				NTD_TD[tdid][TD_Alignment] = 0;
			
			NTD_TD[tdid][TD_Alignment]++;
			UpdateTD(playerid, tdid);
			switch(NTD_TD[tdid][TD_Alignment])
			{
				case 1: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_left], 1500, 6);
				case 2: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_center], 1500, 6);
				case 3: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_right], 1500, 6);
			}
			return 1;
		}
		else if(clickedid == B_SwitchPublic)
		{
			if(NTD_TD[tdid][TD_IsPublic] == false)
			{
				NTD_TD[tdid][TD_IsPublic] = true;
				GameTextForPlayer(playerid, Language_Strings[str_tdpublic], 1500, 6);
			}
			else
			{
				NTD_TD[tdid][TD_IsPublic] = false;
				GameTextForPlayer(playerid, Language_Strings[str_tdperplayer], 1500, 6);
			}
			return 1;
		}
		else if(clickedid == B_Selectable)
		{
			if(NTD_TD[tdid][TD_Selectable] == false)
			{
				NTD_TD[tdid][TD_Selectable] = true;
				GameTextForPlayer(playerid, Language_Strings[str_tdclickable], 1500, 6);
			}
			else
			{
				NTD_TD[tdid][TD_Selectable] = false;
				GameTextForPlayer(playerid, Language_Strings[str_tdnotclickable], 1500, 6);
			}
			
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Shadow)
		{
			new tmp_str[5];
			if(NTD_TD[tdid][TD_ShadowSize] == 4)
				NTD_TD[tdid][TD_ShadowSize] = -1;
			
			NTD_TD[tdid][TD_ShadowSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, Language_Strings[str_tdshadowsize]);
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_ShadowSize]);
			strreplace(EditorString, "#1", tmp_str);
			GameTextForPlayer(playerid, EditorString, 1500, 6);
			return 1;
		}
		else if(clickedid == B_UseBox)
		{
			if(NTD_TD[tdid][TD_UseBox] == false)
			{
				NTD_TD[tdid][TD_UseBox] = true;
				GameTextForPlayer(playerid, Language_Strings[str_tdboxenabled], 1500, 6);
			}
			else
			{
				NTD_TD[tdid][TD_UseBox] = false;
				GameTextForPlayer(playerid, Language_Strings[str_tdboxdisabled], 1500, 6);
			}
			
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Outline)
		{
			new tmp_str[5];
			if(NTD_TD[tdid][TD_OutlineSize] == 4)
				NTD_TD[tdid][TD_OutlineSize] = -1;
			
			NTD_TD[tdid][TD_OutlineSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, Language_Strings[str_tdoutlinesize]);
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_OutlineSize]);
			strreplace(EditorString, "#1", tmp_str);
			GameTextForPlayer(playerid, EditorString, 1500, 6);
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
			if(NTD_TD[tdid][TD_Font] != 4 && NTD_TD[tdid][TD_Font] != 5) 
			{
				CreateDialogOnLanguageData(DL_TEXTCHANGE);
				CreateDialogCaptionOnLangData(DL_TEXTCHANGE);
				ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_TEXTCHANGE][d_s_button1], DLS[DL_TEXTCHANGE][d_s_button2]);
			}
			else if(NTD_TD[tdid][TD_Font] == 4) 
			{
				CreateDialogOnLanguageData(DL_SPRITECHANGELIST);
				CreateDialogCaptionOnLangData(DL_SPRITECHANGELIST);
				ShowPlayerDialog(playerid, DIALOG_SPRITES1, DIALOG_STYLE_LIST,EditorString, EditorLString, DLS[DL_SPRITECHANGELIST][d_s_button1], DLS[DL_SPRITECHANGELIST][d_s_button2]);
			}
			else if(NTD_TD[tdid][TD_Font] == 5) 
			{
				ShowInfo(playerid, Language_Strings[str_modeltexterror]);
			}
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Size)
		{
			if(NTD_TD[tdid][TD_Font] != 4 && NTD_TD[tdid][TD_Font] != 5) 
			{
				CreateDialogOnLanguageData(DL_BOXSIZECHANGELIST);
				CreateDialogCaptionOnLangData(DL_BOXSIZECHANGELIST);
				ShowPlayerDialog(playerid, DIALOG_SIZE, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_BOXSIZECHANGELIST][d_s_button1], DLS[DL_BOXSIZECHANGELIST][d_s_button2]);
			}
			else if(NTD_TD[tdid][TD_Font] == 4 || NTD_TD[tdid][TD_Font] == 5)
			{
				NTD_User[User_ChangingSizeState] = 1;
				NTD_User[User_ChangingState] = CH_SIZE;
				EnableVarChangeTimer(true);
				HideEditor(playerid);
			}
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Position)
		{
			NTD_User[User_ChangingState] = CH_POSITION;
			EnableVarChangeTimer(true);
			PlayerSelectTD(playerid, false);
			HideEditor(playerid);
			return 1;
		}
		else if(clickedid == B_Font)
		{
			if(NTD_TD[tdid][TD_Font] == 5)
				NTD_TD[tdid][TD_Font] = 0;
			else
				NTD_TD[tdid][TD_Font]++;
			//
			UpdateTD(playerid, tdid);
			switch(NTD_TD[tdid][TD_Font])
			{
				case 4: GameTextForPlayer(playerid, Language_Strings[str_tdfontspriteinfo], 1500, 6);
				case TEXT_DRAW_FONT_MODEL_PREVIEW: GameTextForPlayer(playerid, Language_Strings[str_tdfontprevmodelinfo], 1500, 6);
				default: 
				{
					new tmp_str[12];
					format(EditorString, sizeof EditorString, Language_Strings[str_tdfontinfo]);
					format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_Font]);
					strreplace(EditorString, "#1", tmp_str);
					GameTextForPlayer(playerid, EditorString, 1500, 6);
				}
			}
			return 1;
		}
		else if(clickedid == B_NewProject)
		{
			if(Iter_Count(I_PROJECTS) < MAX_PROJECTS)
			{
				CreateDialogOnLanguageData(DL_NEWPROJECT);
				CreateDialogCaptionOnLangData(DL_NEWPROJECT);
				ShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_NEWPROJECT][d_s_button1], DLS[DL_NEWPROJECT][d_s_button2]);
				PlayerSelectTD(playerid, false);
			}
			else ShowInfo(playerid, Language_Strings[str_infoprojectlimit]);
			return 1;
		}
		else if(clickedid == B_CloseProject)
		{
			if(SaveProject() == 0) 
				ShowInfo(playerid, Language_Strings[str_infoprojectsaveerror]);
			else 
				ShowInfo(playerid, Language_Strings[str_infoprojectclosed]);
			
			foreach(new i : I_TEXTDRAWS)
				DestroyTD(i);
			NTD_User[User_ProjectOpened] = false;
			NTD_User[User_EditingTDID] = -1;
			
			ShowWelcomeScreen(true);
			ShowEditorEx(playerid);
			return 1;
		}
		else if(clickedid == B_Manage)
		{
			OpenTDDialog(playerid);
			return 1;
		}
		else if(clickedid == B_OpenProject)
		{
			OpenProjectDialog(playerid);
			return 1;
		}
		else if(clickedid == B_Export)
		{
			CreateDialogOnLanguageData(DL_EXPORTPROJECT);
			CreateDialogCaptionOnLangData(DL_EXPORTPROJECT);
			ShowPlayerDialog(playerid, DIALOG_EXPORT, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_EXPORTPROJECT][d_s_button1], DLS[DL_EXPORTPROJECT][d_s_button2]);
			PlayerSelectTD(playerid, false);
			return 1;
		}
	}
	return 0;
}

//TIMERS

forward BlockVarsChanger(bool:block);
public BlockVarsChanger(bool:block)
{
	if(block)
	{
		NTD_User[User_BlockVarsTime] = true;
		SetTimerEx("BlockVarsChanger", BLOCK_VARS_TIME, false, "b", false);
	}
	else NTD_User[User_BlockVarsTime] = false;
	return 1;
}

forward ChangingVarsTime();
public ChangingVarsTime()
{
	new tdid = NTD_User[User_EditingTDID];
	new Keys,ud,lr;
	new tmp_str[12];
	new newlayer;
	new playerid = NTD_User[User_PlayerIDInEditor];
    GetPlayerKeys(playerid,Keys,ud,lr);
	
	if(NTD_User[User_BlockVarsTime] == false)
	{
		if(ud == KEY_UP)
		{
			EditorVarUpdated = true;
			switch(NTD_User[User_ChangingState])
			{
				case CH_LAYER:
				{
					newlayer = SwapTDLayers(NTD_User[User_ChoosenTDID], Iter_Next(I_TEXTDRAWS, NTD_User[User_ChoosenTDID]));
					if(newlayer != -1)
					{
						NTD_User[User_ChoosenTDID] = newlayer;
						NTD_User[User_EditingTDID] = newlayer;
						RelayerEditor();
						BlockVarsChanger(true);
					}
				}
				case CH_SPRITE:
				{
					NTD_User[User_SpritePicker]++;
					if(NTD_User[User_SpritePicker] > (NTD_User[User_SpriteIndex] - 1))
						NTD_User[User_SpritePicker] = 0;
					new SP = NTD_User[User_SpritePicker];
					format(EditorString, sizeof EditorString, "%s:%s", Sprite_Library[SP][Sprite_Lib], Sprite_Library[SP][Sprite_Name]);
					format(NTD_TD[tdid][TD_Text], 128, EditorString);
					BlockVarsChanger(true);
				}
				case CH_ALPHA:
				{
					switch(NTD_User[User_ChangingMColorState])
					{
						case 0: //Tekst
						{
							if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_ColorAlpha] += 1;	
							else NTD_TD[tdid][TD_ColorAlpha] += 10;
						}					
						case 1: //Tlo
						{
							if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_BGColorAlpha] += 1;
							else NTD_TD[tdid][TD_BGColorAlpha] += 10;
						}
						case 2: //Box
						{
							if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_BoxColorAlpha] += 1;
							else NTD_TD[tdid][TD_BoxColorAlpha] += 10;
						}
					}
				}
				case CH_EDITOR_POS:
				{
					if(!NTD_User[User_Accelerate]) 
						EditorPosY -= 1;
					else 
						EditorPosY -= 10;
				}
				case CH_POSITION:
				{
					if(!NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PosY] -= 1.0;
					else 
						NTD_TD[tdid][TD_PosY] -= 10.0;
				}	
				case CH_SIZE:
				{
					if(!NTD_User[User_Accelerate]) 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeY] -= 0.05; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeY] -= 0.5; 
					} 
					else 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeY] -= 0.5; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeY] -= 5.0; 
					}
				}	
				case CH_MODEL_ROTATION:
				{
					if(!NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PrevRotX] += 1.0;
					else 
						NTD_TD[tdid][TD_PrevRotY] += 1.0;
				}
				case CH_MODEL_ZOOM:
				{
					if(NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PrevRotZoom] -= 0.1;
					else 
						NTD_TD[tdid][TD_PrevRotZoom] -= 0.01;
				}
				case CH_MODEL_COLOR:
				{
					if(NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PrevModelC2] ++;
					else 
						NTD_TD[tdid][TD_PrevModelC1] ++;
				}
			}
		}
		else if(ud == KEY_DOWN)
		{
			EditorVarUpdated = true;
			switch(NTD_User[User_ChangingState])
			{
				case CH_LAYER:
				{
					newlayer = SwapTDLayers(NTD_User[User_ChoosenTDID], Iter_Prev(I_TEXTDRAWS, NTD_User[User_ChoosenTDID]));
					if(newlayer != -1)
					{
						NTD_User[User_ChoosenTDID] = newlayer;
						NTD_User[User_EditingTDID] = newlayer;
						RelayerEditor();
						BlockVarsChanger(true);
					}
				}
				case CH_SPRITE:
				{
					NTD_User[User_SpritePicker]--;
					if(NTD_User[User_SpritePicker] < 0)
						NTD_User[User_SpritePicker] = (NTD_User[User_SpriteIndex] - 1);
					new SP = NTD_User[User_SpritePicker];
					format(EditorString, sizeof EditorString, "%s:%s", Sprite_Library[SP][Sprite_Lib], Sprite_Library[SP][Sprite_Name]);
					format(NTD_TD[tdid][TD_Text], 128, EditorString);
					BlockVarsChanger(true);
				}
				case CH_ALPHA:
				{
					if(NTD_User[User_ChangingMColorState] == 0) //Tekst
						if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_ColorAlpha] -= 1;	
						else NTD_TD[tdid][TD_ColorAlpha] -= 10;	
					if(NTD_User[User_ChangingMColorState] == 1) //Tlo
						if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_BGColorAlpha] -= 1;
						else NTD_TD[tdid][TD_BGColorAlpha] -= 10;
					if(NTD_User[User_ChangingMColorState] == 2) //Box
						if(!NTD_User[User_Accelerate]) NTD_TD[tdid][TD_BoxColorAlpha] -= 1;
						else NTD_TD[tdid][TD_BoxColorAlpha] -= 10;
				}
				case CH_EDITOR_POS:
				{
					if(!NTD_User[User_Accelerate]) 
						EditorPosY += 1;
					else 
						EditorPosY += 10;
				}
				case CH_POSITION:
				{
					if(!NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PosY] += 1.0;
					else
						NTD_TD[tdid][TD_PosY] += 10.0;
				}	
				case CH_SIZE:
				{
					if(!NTD_User[User_Accelerate]) 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeY] += 0.05; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeY] += 0.5; 
					} 
					else 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeY] += 0.5; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeY] += 5.0; 
					}
				}
				case CH_MODEL_ROTATION:
				{
					if(!NTD_User[User_Accelerate])
						NTD_TD[tdid][TD_PrevRotX] -= 1.0;
					else 
						NTD_TD[tdid][TD_PrevRotY] -= 1.0;
				}
				case CH_MODEL_ZOOM:
				{
					if(NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PrevRotZoom] += 0.1;
					else 
						NTD_TD[tdid][TD_PrevRotZoom] += 0.01;
				}
				case CH_MODEL_COLOR:
				{
					if(NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PrevModelC2] --;
					else 
						NTD_TD[tdid][TD_PrevModelC1] --;
				}
			}
		}
		if(lr == KEY_LEFT)
		{
			EditorVarUpdated = true;
			switch(NTD_User[User_ChangingState])
			{
				case CH_POSITION:
				{
					if(!NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PosX] -= 1.0; 
					else
						NTD_TD[tdid][TD_PosX] -= 10.0; 
				}	
				case CH_SIZE:
				{
					if(!NTD_User[User_Accelerate]) 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeX] -= 0.05 / 12; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeX] -= 0.5; 
					} 
					else 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeX] -= 0.5 / 12; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeX] -= 5.0; 
					}
				}
				case CH_EDITOR_POS:
				{
					if(EditorCompactMode)
					{
						if(!NTD_User[User_Accelerate]) 
							EditorPosX -= 1;
						else 
							EditorPosX -= 10;
					}
				}
				case CH_MODEL_ROTATION:
				{
					if(!NTD_User[User_Accelerate])
						NTD_TD[tdid][TD_PrevRotZ] -= 1.0;
				}
			}
		}
		else if(lr == KEY_RIGHT)
		{
			EditorVarUpdated = true;
			switch(NTD_User[User_ChangingState])
			{
				case CH_POSITION:
				{
					if(!NTD_User[User_Accelerate]) 
						NTD_TD[tdid][TD_PosX] += 1.0; 	
					else 
						NTD_TD[tdid][TD_PosX] += 10.0; 
				}	
				case CH_SIZE:
				{
					if(!NTD_User[User_Accelerate]) 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeX] += 0.05 / 12; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeX] += 0.5; 
					} 
					else 
					{
						if(NTD_User[User_ChangingSizeState] == 0) 
							NTD_TD[tdid][TD_LetterSizeX] += 0.5 / 12; 
						else if(NTD_User[User_ChangingSizeState] == 1) 
							NTD_TD[tdid][TD_BoxSizeX] += 5.0; 
					}
				}
				case CH_EDITOR_POS:
				{
					if(EditorCompactMode)
					{
						if(!NTD_User[User_Accelerate]) 
							EditorPosX += 1;
						else 
							EditorPosX += 10;
					}
					
				}
				case CH_MODEL_ROTATION:
				{
					if(!NTD_User[User_Accelerate])
						NTD_TD[tdid][TD_PrevRotZ] += 1.0;
				}
			}
		}
	}
	// // // // // Visuals // // // // //
	switch(NTD_User[User_ChangingState])
	{
		case CH_LAYER:
		{
			format(EditorString, sizeof EditorString, Language_Strings[str_tdlayer]);
			format(tmp_str, sizeof tmp_str, "%i", tdid);
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_ALPHA:
		{
			format(EditorString, sizeof EditorString, Language_Strings[str_tdcoloralpha]);
			switch(NTD_User[User_ChangingMColorState])
			{
				case 0:
				{
					NTD_TD[tdid][TD_ColorAlpha] = clamp(NTD_TD[tdid][TD_ColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_ColorAlpha]);
				}
				case 1:
				{
					NTD_TD[tdid][TD_BGColorAlpha] = clamp(NTD_TD[tdid][TD_BGColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_BGColorAlpha]);
				}
				case 2:
				{
					NTD_TD[tdid][TD_BoxColorAlpha] = clamp(NTD_TD[tdid][TD_BoxColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_BoxColorAlpha]);
				}
			}
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_EDITOR_POS:
		{
			EditorPosY = clamp(EditorPosY, BUTTON_MINHEIGHT, BUTTON_MAXHEIGHT);
			EditorPosX = clamp(EditorPosX, 0, 615);
			format(EditorString, sizeof EditorString, Language_Strings[str_tdeditorposition]);
			format(tmp_str, sizeof tmp_str, "%i", EditorPosX);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%i", EditorPosY);
			strreplace(EditorString, "#2", tmp_str);
		}
		case CH_MODEL_COLOR:
		{
			NTD_TD[tdid][TD_PrevModelC1] = clamp(NTD_TD[tdid][TD_PrevModelC1], 0, 255);
			NTD_TD[tdid][TD_PrevModelC2] = clamp(NTD_TD[tdid][TD_PrevModelC2], 0, 255);
			format(EditorString, sizeof EditorString, Language_Strings[str_tdprevmodelcolor]);
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_PrevModelC1]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_PrevModelC2]);
			strreplace(EditorString, "#2", tmp_str);
		}	
		case CH_POSITION:
		{
			format(EditorString, sizeof EditorString, Language_Strings[str_tdposition]);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PosX]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PosY]);
			strreplace(EditorString, "#2", tmp_str);
		}
		case CH_MODEL_ROTATION:
		{
			if(NTD_TD[tdid][TD_PrevRotX] > 360 || NTD_TD[tdid][TD_PrevRotX] < -360) NTD_TD[tdid][TD_PrevRotX] = 0.0;
			if(NTD_TD[tdid][TD_PrevRotY] > 360 || NTD_TD[tdid][TD_PrevRotY] < -360) NTD_TD[tdid][TD_PrevRotY] = 0.0;
			if(NTD_TD[tdid][TD_PrevRotZ] > 360 || NTD_TD[tdid][TD_PrevRotZ] < -360) NTD_TD[tdid][TD_PrevRotZ] = 0.0;
			
			format(EditorString, sizeof EditorString, Language_Strings[str_tdrotation]);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PrevRotX]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PrevRotY]);
			strreplace(EditorString, "#2", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PrevRotZ]);
			strreplace(EditorString, "#3", tmp_str);
		}
		case CH_MODEL_ZOOM:
		{
			if(NTD_TD[tdid][TD_PrevRotZoom] < 0) NTD_TD[tdid][TD_PrevRotZoom] = 0.0;
			if(NTD_TD[tdid][TD_PrevRotZoom] > 15) NTD_TD[tdid][TD_PrevRotZoom] = 15.0;
			
			format(EditorString, sizeof EditorString, Language_Strings[str_tdpremodelzoom]);
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PrevRotZoom]);
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_SIZE:
		{
			format(EditorString, sizeof EditorString, Language_Strings[str_tdsize]);
			switch(NTD_User[User_ChangingSizeState])
			{
				case 0:
				{
					format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_LetterSizeX]);
					strreplace(EditorString, "#1", tmp_str);
					format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_LetterSizeY]);
					strreplace(EditorString, "#2", tmp_str);
				}
				case 1:
				{
					format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_BoxSizeX]);
					strreplace(EditorString, "#1", tmp_str);
					format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_BoxSizeY]);
					strreplace(EditorString, "#2", tmp_str);
				}
			}
		}
		case CH_SPRITE:
		{
			format(EditorString, sizeof EditorString, Language_Strings[str_tdsprite]);
			strreplace(EditorString, "#1", NTD_TD[tdid][TD_Text]);
			format(tmp_str, sizeof tmp_str, "%i", NTD_User[User_SpritePicker]);
			strreplace(EditorString, "#2", tmp_str);
		}
	}
	GameTextForPlayer(playerid, EditorString, 200, 4);
	if(EditorVarUpdated)
	{
		EditorVarUpdated = false;
		if(NTD_User[User_ChangingState] != CH_EDITOR_POS)
		{
			if(NTD_User[User_ChangingState] == CH_POSITION || NTD_User[User_ChangingState] == CH_SPRITE) 
			{
				TextDrawDestroy(NTD_TD[tdid][TD_SelfID]);
				TextDrawDestroy(NTD_TD[tdid][TD_PickerID]);
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

//COMMANDS

CMD:ntd(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(ScriptScriptActive)
		{
			if(NTD_User[User_InEditor] == false)
			{
				LoadConfigurations();
				if(Lang(LANG_NONE))
				{
					ShowLanguageChangeDialog(playerid, DIALOG_LANGUAGE);
					return 1;
				}
				else if(strcmp(EditorVersion, SCRIPT_VERSION_CHECK, false) != 0)
				{
					CreateDialogOnLanguageData(DL_OLDVERSIONSETTINGSRESET);
					CreateDialogCaptionOnLangData(DL_OLDVERSIONSETTINGSRESET);
					ShowPlayerDialog(playerid, DIALOG_SETTINGRESET, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_OLDVERSIONSETTINGSRESET][d_s_button1], DLS[DL_OLDVERSIONSETTINGSRESET][d_s_button2]);
					return 1;
				}
				CreateEditor();
				NTD_User[User_InEditor] = true;
				NTD_User[User_ChangingState] = CH_NONE;
				NTD_User[User_ProjectOpened] = false;
				NTD_User[User_PlayerIDInEditor] = playerid;
				NTD_User[User_ChoosenTDID] = -1;
				NTD_User[User_EditingTDID] = -1;
				NTD_User[User_ChangingMColorState] = -1;
				NTD_User[User_CursorTimer] = -1;
				NTD_User[User_WelcomeTimer] = -1;
				NTD_User[User_WelcomeScreenAlpha] = -1;
				ShowWelcomeScreen(true);
				TogglePlayerControllable(playerid, false);
				GetAllProjects();
				ShowEditorEx(playerid);
				ShowInfo(playerid, Language_Strings[str_infoeditorleave]);
				for(new i; i < 15; i++)
					SendClientMessage(playerid, -1, " ");
			}
			else
			{
				if(NTD_User[User_PlayerIDInEditor] == playerid)
				{
					SaveConfigurations();
					HideEditor(playerid);
					DestroyEditor();
					NTD_User[User_InEditor] = false;
					NTD_User[User_ChangingState] = CH_NONE;
					NTD_User[User_ChoosenTDID] = -1;
					NTD_User[User_EditingTDID] = -1;
					NTD_User[User_ChangingMColorState] = -1;
					PlayerSelectTD(playerid, false);
					TextDrawDestroy(WelcomeScreen);
					if(NTD_User[User_WelcomeTimer] != -1)
					{
						
						NTD_User[User_WelcomeScreenAlpha] = -1;
						KillTimer(NTD_User[User_WelcomeTimer]);
						NTD_User[User_WelcomeTimer] = -1;
					}
					TogglePlayerControllable(playerid, true);
					format(EditorString, sizeof EditorString, "{FF8040}NTD: %s", Language_Strings[str_editordisabled]);
					SendClientMessage(playerid, -1, EditorString);
					if(NTD_User[User_ProjectOpened])
					{
						SaveProject();
						foreach(new i : I_TEXTDRAWS)
							DestroyTD(i);
						NTD_User[User_ProjectOpened] = false;
					}
				}
				else 
				{
					format(EditorString, sizeof EditorString, "{FF8040}NTD: %s", Language_Strings[str_editorinuse]);
					SendClientMessage(playerid, -1, EditorString);
				}
			}
		}
		else 
		{
			if(Lang(LANG_NONE))
				ShowInfo(playerid, "{FF0000}Script has been disabled!\n{FFFFFF}Check server logs for more informations!");
			else
				ShowInfo(playerid, Language_Strings[str_infoeditorlocked]);
		}
	}
	else
	{
		
		if(Lang(LANG_NONE))
			SendClientMessage(playerid, -1, "{FF8040}NTD: {FF0000}You are not authorized to use this command! Please Login to RCON.");
		else
		{
			format(EditorString, sizeof EditorString, "{FF8040}NTD: %s", Language_Strings[str_nopermit]);
			SendClientMessage(playerid, -1, EditorString);
		}
			
	}
	return 1;
}

//FUNCTIONS

stock EnableVarChangeTimer(bool:starttimer)
{
	if(starttimer)
	{
		if(NTD_User[User_ChangingVarsTimer] != -1)
			KillTimer(NTD_User[User_ChangingVarsTimer]);
		NTD_User[User_ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
	}
	else
	{
		if(NTD_User[User_ChangingVarsTimer] != -1)
			KillTimer(NTD_User[User_ChangingVarsTimer]);
		NTD_User[User_ChangingVarsTimer] = -1;
	}
	return 1;
}

stock ShowManualVarChangeDialog(playerid)
{
	EditorLString = "";
	new tdid = NTD_User[User_EditingTDID];
	strunpack(EditorString, DLI[DL_MANUALVARCHANGE][0]);
	strcat(EditorString, "\n");
	strcat(EditorLString, EditorString);
	switch(NTD_User[User_ChangingState])
	{
		case CH_POSITION:
		{
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][1]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][2]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strreplace(EditorLString, "#1", "%f");
			strreplace(EditorLString, "#2", "%f");
			format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PosX], NTD_TD[tdid][TD_PosY]);
			CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE);	
		}
		case CH_SIZE:
		{
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][1]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][2]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strreplace(EditorLString, "#1", "%f");
			strreplace(EditorLString, "#2", "%f");
			format(EditorLString, sizeof EditorLString, EditorLString, 
			(NTD_User[User_ChangingSizeState] == 0) ? (NTD_TD[tdid][TD_LetterSizeX]) : (NTD_TD[tdid][TD_BoxSizeX]), 
			(NTD_User[User_ChangingSizeState] == 0) ? (NTD_TD[tdid][TD_LetterSizeY]) : (NTD_TD[tdid][TD_BoxSizeY]));
			CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE);	
		}
		case CH_MODEL_ROTATION:
		{
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][1]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][2]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][3]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strreplace(EditorLString, "#1", "%f");
			strreplace(EditorLString, "#2", "%f");
			strreplace(EditorLString, "#3", "%f");
			format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotX], NTD_TD[tdid][TD_PrevRotY], NTD_TD[tdid][TD_PrevRotZ]);
			CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE);	
		}
		case CH_MODEL_ZOOM:
		{
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][4]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strreplace(EditorLString, "#4", "%f");
			format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevRotZoom]);
			CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE);	
		}
		case CH_MODEL_COLOR:
		{
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][5]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strunpack(EditorString, DLI[DL_MANUALVARCHANGE][6]);
			strcat(EditorString, "\n");
			strcat(EditorLString, EditorString);
			strreplace(EditorLString, "#5", "%i");
			strreplace(EditorLString, "#6", "%i");
			format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_PrevModelC1], NTD_TD[tdid][TD_PrevModelC2]);
			CreateDialogCaptionOnLangData(DL_MANUALVARCHANGE);	
		}
	}
	strreplace(EditorLString, "#t", "\t");
	ShowPlayerDialog(playerid, DIALOG_MANUALVARCHANGE, DIALOG_STYLE_TABLIST_HEADERS, EditorString, EditorLString, DLS[DL_MANUALVARCHANGE][d_s_button1], DLS[DL_MANUALVARCHANGE][d_s_button2]);
	return 1;
}


stock SwapTDLayers(tdid, tolayer)
{
	if(tolayer == Iter_Begin(I_TEXTDRAWS) || tolayer == Iter_End(I_TEXTDRAWS)) 
		return -1;
	new old_td_data[E_TD];
	old_td_data = NTD_TD[tdid];
	//Swapping enums
	NTD_TD[tdid] = NTD_TD[tolayer];
	NTD_TD[tolayer] = old_td_data;
	return tolayer;
}

stock ResetConfiguration(playerid)
{
	EditorPosY = BUTTON_MAXHEIGHT;
	EditorCursorColor = CURSOR_COLOR;
	EditorButtonsColor = BUTTON_TD_COLOR;
	EditorFasterKey = KEY_JUMP;
	EditorAcceptKey = KEY_SPRINT;
	EditorVersion = SCRIPT_VERSION_CHECK;
	ToggleTextDrawShowForAll(false);
	QuickSelectionShow(playerid, true);
	EditorQuickSelect = true;
	return 1;
}

stock CreateDialogCaptionOnLangData(dialoglanguageid)
{
	format(EditorString, sizeof EditorString, CAPTION_TEXT"%s", DLS[dialoglanguageid][d_s_caption]);
	strreplace(EditorString, "#x", "\x");
	return 1;
}

stock strreplace(sstring[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(sstring)) 
{
    if (limit == 0)
        return 0;
    new sublen = strlen(search), replen = strlen(replacement), bool:packed = ispacked(sstring), maxlen = maxlength, len = strlen(sstring), count = 0;
    if (packed)
        maxlen *= 4;
    if (!sublen)
        return 0;
    while (-1 != (pos = strfind(sstring, search, ignorecase, pos))) 
	{
        strdel(sstring, pos, pos + sublen);
        len -= sublen;
        if (replen && len + replen < maxlen) {
            strins(sstring, replacement, pos, maxlength);
            
            pos += replen;
            len += replen;
        }
        if (limit != -1 && ++count >= limit)
            break;
    }
    return count;
}

stock CreateDialogOnLanguageData(dialoglanguageid)
{
	EditorLString = "";
	for(new i; i < MAX_DIALOG_INFO; i++)
	{
		if(strlen(DLI[dialoglanguageid][i]) > 1)
		{
			if(i > 0) strcat(EditorLString, "\n");
			strunpack(EditorString, DLI[dialoglanguageid][i]);
			strcat(EditorLString, EditorString);
		}
	}
	strreplace(EditorLString, "#t", "\t");
	strreplace(EditorLString, "#n", "\n");
	return 1;
}

stock ShowLanguageChangeDialog(playerid, ondialogid)
{
	EditorLString = "";
	foreach(new i : I_LANGUAGES)
	{
		format(EditorString, sizeof EditorString, "%s/%s", LANGUAGES_PATH, Language[i][l_file]);
		format(EditorLString, sizeof EditorLString, "%s{8080FF}%s\t{FFFFFF}%s%s\n", EditorLString, Language[i][l_name], (fexist(EditorString)) ? ("{FFFFFF}") : ("{FF0000}"), Language[i][l_file]);
	}
	ShowPlayerDialog(playerid, ondialogid, DIALOG_STYLE_TABLIST, CAPTION_TEXT"Language", EditorLString, "OK", #);
	return 1;
}

stock RenameProject(projectname[], newprojectname[])
{
	new string1[128], string2[128];
	format(string1, sizeof string1, "NTD/Projects/%s.ntdp", projectname);	
	if(!dfile_FileExists(string1)) 	
		return -1;
	format(string2, sizeof string2, "NTD/Projects/%s.ntdp", newprojectname);	
	if(dfile_FileExists(string2)) 
		return 3;
	if(!IsValidString(newprojectname) || strlen(newprojectname) == 0 || strlen(newprojectname) > 40)
		return 2;
	
	
	dfile_RenameFile(string1, string2);
	format(NTD_User[User_ProjectName], 35, newprojectname);
	
	//Project List Update
	if(fexist(PROJECTLIST_FILEPATH))
	{
		new File:file = fopen(PROJECTLIST_FILEPATH, io_readwrite);
		if(file)
		{
			new hour, minute, year, month, day, tda;
			while(fread(file, string1))
			{
				if(sscanf(string1, "siiiiii", string2, tda, hour, minute, day, month, year) == 0)
				{
					if(strcmp(string2, projectname, true) == 0)
					{
						format(EditorString, sizeof EditorString, "%s %i %i %i %i %i %i\n", NTD_User[User_ProjectName], tda, hour, minute, day, month, year);
						fclose(file);
						ProjectFileLineReplace(PROJECTLIST_FILEPATH, projectname, EditorString);
						break;
					}
					
				}
			}
		}
		GetAllProjects();
	}
	return 1;
}

forward bool:VariableExists(string[]);
stock bool:VariableExists(string[])
{
	foreach(new i : I_TEXTDRAWS)
		if(!strcmp(NTD_TD[i][TD_VarName], string, false) && !isnull(NTD_TD[i][TD_VarName]) && NTD_TD[i][TD_Created]) return true;
	return false;
}

stock IsValidString(string[])
{
	new un[][] = {" ", "!", "?", "=", "$", "§", "'", "´", "^", "°", "/", "*", "+", "~", ".", ","};
	for(new i; i < sizeof un; i++)
		if(strfind(string, un[i][0], true) != -1) return false;
	return true;
}

stock Lang(lang)
{
	if(EditorLanguage == lang) return true;
	return false;
}

stock ShowTDOptions(tdid)
{
	new tmp_str[12];
	NTD_User[User_ChoosenTDID] = tdid;
	CreateDialogOnLanguageData(DL_TDOPTIONS);
	CreateDialogCaptionOnLangData(DL_TDOPTIONS);
	format(tmp_str, sizeof tmp_str, "%i", NTD_User[User_ChoosenTDID]);
	strreplace(EditorString, "#1", tmp_str);
	strreplace(EditorString, "#2", NTD_TD[NTD_User[User_ChoosenTDID]][TD_Text]);
	ShowPlayerDialog(NTD_User[User_PlayerIDInEditor], DIALOG_MANAGE2, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_TDOPTIONS][d_s_button1], DLS[DL_TDOPTIONS][d_s_button2]);
	PlayerSelectTD(NTD_User[User_PlayerIDInEditor], false);
	return 1;
}

stock UpdateTD(playerid, td)
{
	new red,green,blue,alpha;
	#pragma unused alpha
	TextDrawFont(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Font]);
	TextDrawSetOutline(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_OutlineSize]);
	TextDrawSetShadow(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_ShadowSize]);
	TextDrawLetterSize(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_LetterSizeX], NTD_TD[td][TD_LetterSizeY]);
	RGBAToHex(NTD_TD[td][TD_Color],red,green,blue, alpha); 
	HexToRGBA(NTD_TD[td][TD_Color],red,green,blue,NTD_TD[td][TD_ColorAlpha]);
	TextDrawColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Color]);
	RGBAToHex(NTD_TD[td][TD_BGColor],red,green,blue, alpha);
	HexToRGBA(NTD_TD[td][TD_BGColor],red,green,blue,NTD_TD[td][TD_BGColorAlpha]);
	TextDrawBackgroundColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BGColor]);
	RGBAToHex(NTD_TD[td][TD_BoxColor],red,green,blue, alpha); 
	HexToRGBA(NTD_TD[td][TD_BoxColor],red,green,blue,NTD_TD[td][TD_BoxColorAlpha]);
	TextDrawBoxColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxColor]);
	TextDrawUseBox(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_UseBox]);	
	TextDrawTextSize(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxSizeX], NTD_TD[td][TD_BoxSizeY]);
	TextDrawSetSelectable(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Selectable]);
	TextDrawAlignment(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Alignment]);
	TextDrawSetProportional(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Proportional]);
	TextDrawSetPreviewModel(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevModelID]);
	TextDrawSetPreviewRot(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevRotX], NTD_TD[td][TD_PrevRotY], NTD_TD[td][TD_PrevRotZ], NTD_TD[td][TD_PrevRotZoom]);
	TextDrawSetPreviewVehCol(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevModelC1], NTD_TD[td][TD_PrevModelC2]);
	if(!EditorTextDrawShowForAll) TextDrawShowForPlayer(playerid, NTD_TD[td][TD_SelfID]);
	else TextDrawShowForAll(NTD_TD[td][TD_SelfID]);
	return 1;
}

stock QuickSelectionShow(playerid, bool:enable)
{
	if(NTD_User[User_ProjectOpened] == true)
	{
		if(enable)
		{
			foreach(new i : I_TEXTDRAWS)
				TextDrawShowForPlayer(playerid, NTD_TD[i][TD_PickerID]);
		}
		else
		{
			foreach(new i : I_TEXTDRAWS)
				TextDrawHideForPlayer(playerid, NTD_TD[i][TD_PickerID]);
		}
	}
	return 1;
}

stock SelectTD(playerid, tdid)
{
	if(tdid != NTD_User[User_EditingTDID])
	{
		new ptdid = NTD_User[User_EditingTDID];
		NTD_User[User_EditingTDID] = tdid;
		//
		new tmp_str[12];
		format(EditorString, sizeof EditorString, Language_Strings[str_tdselectedinfo]);
		format(tmp_str, sizeof tmp_str, "%i", NTD_User[User_EditingTDID]);
		strreplace(EditorString, "#1", tmp_str);
		//
		GameTextForPlayer(playerid, EditorString, 5000, 6);
		PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
		HighlightTD(playerid, NTD_User[User_EditingTDID]);
		ShowEditorEx(playerid);
		TextDrawColor(NTD_TD[tdid][TD_PickerID], TDPICKER_COLOR_ACTIVE);
		if(EditorQuickSelect) TextDrawShowForPlayer(playerid, NTD_TD[tdid][TD_PickerID]);
		if(ptdid != -1 && tdid != ptdid)
		{
			TextDrawColor(NTD_TD[ptdid][TD_PickerID], TDPICKER_COLOR);
			if(EditorQuickSelect) TextDrawShowForPlayer(playerid, NTD_TD[ptdid][TD_PickerID]);
		}
		return 1;
	}
	return 0;
}

stock CreateProject(projectname[])
{
	format(EditorString, sizeof EditorString, "NTD/Projects/%s.ntdp", projectname);			
	if(!dfile_FileExists(EditorString))
	{
		new pid = WriteIntoList(projectname);
		if(pid == 1)
		{
			format(EditorString, sizeof EditorString, "NTD/Projects/%s.ntdp", projectname);	
			dfile_Create(EditorString);
			GetAllProjects();		
			return pid;
		}
	}
	return -1;
}

stock ShowInfo(playerid, text[])
{
	format(EditorString, sizeof EditorString, CAPTION_TEXT"%s", Language_Strings[str_infodialogcaption]);
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, EditorString, text, "OK", #);
	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	return 1;
}


stock ExportProject(projectname[], exporttype=0, bool:intoarray = false)
{
	new filename[128], bool:clickableTD, publiccount, nonpubliccount;
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
				fwrite(file, "/*\nThis file was generated by Nickk's TextDraw editor script\n");
				fwrite(file, "Nickk888 is the author of the NTD script\n*/\n\n");
				if(exporttype == 0) //RAW EXPORT
				{
					fwrite(file, "//Variables\n");
					if(intoarray) //ARRAY
					{
						//Count non custom vars
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0) publiccount++;
							else if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0) nonpubliccount++;
						}
						//Generate Non custom Vars
						if(publiccount > 0)
						{
							format(EditorString, sizeof EditorString, "new Text:PublicTD[%i];\n", publiccount);
							fwrite(file, EditorString);
						}
						if(nonpubliccount > 0)
						{
							format(EditorString, sizeof EditorString, "new PlayerText:PlayerTD[MAX_PLAYERS][%i];\n", nonpubliccount);
							fwrite(file, EditorString);
						}
						//Generate Custom Vars
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "new Text:%s;\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "new PlayerText:%s[MAX_PLAYERS];\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic]) format(EditorString, sizeof EditorString, "new Text:%s;\n", GetProcessedTDVarName(i));
							fwrite(file, EditorString);
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic]) format(EditorString, sizeof EditorString, "new PlayerText:%s[MAX_PLAYERS];\n", GetProcessedTDVarName(i));
							fwrite(file, EditorString);
						}
					}
					fwrite(file, "\n//Textdraws\n");
					if(intoarray) //ARRAY
					{
						publiccount = 0;
						nonpubliccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								if(strlen(NTD_TD[i][TD_VarName]) == 0) //Non custom var name
								{
									format(EditorString, sizeof EditorString, "PublicTD[%i] = TextDrawCreate(%f, %f, \x22%s\x22);\n", publiccount, NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawFont(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawLetterSize(PublicTD[%i], %f, %f);\n", publiccount, NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawTextSize(PublicTD[%i], %f, %f);\n", publiccount, NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetOutline(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetShadow(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawAlignment(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawBackgroundColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawBoxColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawUseBox(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetProportional(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetSelectable(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewModel(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewRot(PublicTD[%i], %f, %f, %f, %f);\n", publiccount, NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewVehCol(PublicTD[%i], %i, %i);\n", publiccount, NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
										
									}
									fwrite(file, "\n");
									publiccount++;
								}
								else //Custom var name
								{
									format(EditorString, sizeof EditorString, "%s = TextDrawCreate(%f, %f, \x22%s\x22);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawFont(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawLetterSize(%s, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawTextSize(%s, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetOutline(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetShadow(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawAlignment(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawBackgroundColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawBoxColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawUseBox(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetProportional(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetSelectable(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewModel(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewRot(%s, %f, %f, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "TextDrawSetPreviewVehCol(%s, %i, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
										
									}
									fwrite(file, "\n");
								}
							}					
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
						fwrite(file, "\n//Player Textdraws\n");
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								if(strlen(NTD_TD[i][TD_VarName]) == 0) //Non Custom var name
								{
									format(EditorString, sizeof EditorString, "PlayerTD[playerid][%i] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", nonpubliccount, NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawFont(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawLetterSize(playerid, PlayerTD[playerid][%i], %f, %f);\n", nonpubliccount, NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawTextSize(playerid, PlayerTD[playerid][%i], %f, %f);\n", nonpubliccount, NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetOutline(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetShadow(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawAlignment(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawBoxColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawUseBox(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetProportional(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][%i], %f, %f, %f, %f);\n", nonpubliccount, NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][%i], %i, %i);\n", nonpubliccount, NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
									}
									fwrite(file, "\n");
									nonpubliccount++;
								}
								else //Custom var name
								{
									format(EditorString, sizeof EditorString, "%s[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawFont(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawLetterSize(playerid, %s[playerid], %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawTextSize(playerid, %s[playerid], %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetOutline(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetShadow(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawAlignment(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawBackgroundColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawBoxColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawUseBox(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetProportional(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetSelectable(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewModel(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewRot(playerid, %s[playerid], %f, %f, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewVehCol(playerid, %s[playerid], %i, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
									}
									fwrite(file, "\n");
								}
							}
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "%s = TextDrawCreate(%f, %f, \x22%s\x22);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawFont(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawLetterSize(%s, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawTextSize(%s, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawSetOutline(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawSetShadow(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawAlignment(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawBackgroundColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawBoxColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawUseBox(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawSetProportional(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "TextDrawSetSelectable(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
								fwrite(file, EditorString);
								if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
								{
									format(EditorString, sizeof EditorString, "TextDrawSetPreviewModel(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetPreviewRot(%s, %f, %f, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "TextDrawSetPreviewVehCol(%s, %i, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
									fwrite(file, EditorString);
									
								}
								fwrite(file, "\n");
							}					
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
						fwrite(file, "//Player Textdraws\n");
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "%s[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawFont(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawLetterSize(playerid, %s[playerid], %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawTextSize(playerid, %s[playerid], %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawSetOutline(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawSetShadow(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawAlignment(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawBackgroundColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawBoxColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawUseBox(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawSetProportional(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "PlayerTextDrawSetSelectable(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
								fwrite(file, EditorString);
								if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
								{
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewModel(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewRot(playerid, %s[playerid], %f, %f, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "PlayerTextDrawSetPreviewVehCol(playerid, %s[playerid], %i, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
									fwrite(file, EditorString);
								}
								fwrite(file, "\n");
							}
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
					}
				}
				else if(exporttype == 1) //WORKING FS EXPORT
				{
					fwrite(file, "#include <a_samp>\n\n");
					if(intoarray) //ARRAY
					{
						//Count non custom vars
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0) publiccount++;
							else if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0) nonpubliccount++;
						}
						//Generate Non custom Vars
						if(publiccount > 0)
						{
							format(EditorString, sizeof EditorString, "new Text:PublicTD[%i];\n", publiccount);
							fwrite(file, EditorString);
						}
						if(nonpubliccount > 0)
						{
							format(EditorString, sizeof EditorString, "new PlayerText:PlayerTD[MAX_PLAYERS][%i];\n", nonpubliccount);
							fwrite(file, EditorString);
						}
						//Generate Custom Vars
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "new Text:%s;\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "new PlayerText:%s[MAX_PLAYERS];\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic]) format(EditorString, sizeof EditorString, "new Text:%s;\n", GetProcessedTDVarName(i));
							fwrite(file, EditorString);
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic]) format(EditorString, sizeof EditorString, "new PlayerText:%s[MAX_PLAYERS];\n", GetProcessedTDVarName(i));
							fwrite(file, EditorString);
						}
					}

					fwrite(file, "\npublic OnFilterScriptInit()\n{\n");
					if(intoarray) //ARRAY
					{
						publiccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								if(strlen(NTD_TD[i][TD_VarName]) == 0) //Non custom var name
								{
									format(EditorString, sizeof EditorString, "\tPublicTD[%i] = TextDrawCreate(%f, %f, \x22%s\x22);\n", publiccount, NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawFont(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawLetterSize(PublicTD[%i], %f, %f);\n", publiccount, NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawTextSize(PublicTD[%i], %f, %f);\n", publiccount, NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetOutline(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetShadow(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawAlignment(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawBackgroundColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawBoxColor(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawUseBox(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetProportional(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetSelectable(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewModel(PublicTD[%i], %i);\n", publiccount, NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewRot(PublicTD[%i], %f, %f, %f, %f);\n", publiccount, NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewVehCol(PublicTD[%i], %i, %i);\n", publiccount, NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
										
									}
									fwrite(file, "\n");
									publiccount++;
								}
								else //Custom var name
								{
									format(EditorString, sizeof EditorString, "\t%s = TextDrawCreate(%f, %f, \x22%s\x22);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawFont(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawLetterSize(%s, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawTextSize(%s, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetOutline(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetShadow(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawAlignment(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawBackgroundColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawBoxColor(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawUseBox(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetProportional(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetSelectable(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewModel(%s, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewRot(%s, %f, %f, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewVehCol(%s, %i, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
										
									}
									fwrite(file, "\n");
								}
							}					
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\t%s = TextDrawCreate(%f, %f, \x22%s\x22);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawFont(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawLetterSize(%s, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawTextSize(%s, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawSetOutline(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawSetShadow(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawAlignment(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawBackgroundColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawBoxColor(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawUseBox(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawSetProportional(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tTextDrawSetSelectable(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
								fwrite(file, EditorString);
								if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
								{
									format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewModel(%s, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewRot(%s, %f, %f, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tTextDrawSetPreviewVehCol(%s, %i, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
									fwrite(file, EditorString);
									
								}
								fwrite(file, "\n");
								if(NTD_TD[i][TD_Selectable])
									clickableTD = true;
							}					
							
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnFilterScriptExit()\n{\n");
					if(intoarray) //ARRAY
					{
						publiccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0)
							{
								format(EditorString, sizeof EditorString, "\tTextDrawDestroy(PublicTD[%i]);\n", publiccount);
								fwrite(file, EditorString);
								publiccount++;
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "\tTextDrawDestroy(%s);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\tTextDrawDestroy(%s);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					
					fwrite(file, "\npublic OnPlayerConnect(playerid)\n{\n");
					if(intoarray) //ARRAY
					{
						nonpubliccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								if(strlen(NTD_TD[i][TD_VarName]) == 0) //Non Custom var name
								{
									format(EditorString, sizeof EditorString, "\tPlayerTD[playerid][%i] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", nonpubliccount, NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawFont(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawLetterSize(playerid, PlayerTD[playerid][%i], %f, %f);\n", nonpubliccount, NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawTextSize(playerid, PlayerTD[playerid][%i], %f, %f);\n", nonpubliccount, NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetOutline(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetShadow(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawAlignment(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawBackgroundColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawBoxColor(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawUseBox(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetProportional(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetSelectable(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewModel(playerid, PlayerTD[playerid][%i], %i);\n", nonpubliccount, NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewRot(playerid, PlayerTD[playerid][%i], %f, %f, %f, %f);\n", nonpubliccount, NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewVehCol(playerid, PlayerTD[playerid][%i], %i, %i);\n", nonpubliccount, NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
									}
									fwrite(file, "\n");
									nonpubliccount++;
								}
								else //Custom var name
								{
									format(EditorString, sizeof EditorString, "\t%s[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawFont(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawLetterSize(playerid, %s[playerid], %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawTextSize(playerid, %s[playerid], %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetOutline(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetShadow(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawAlignment(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawBackgroundColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawBoxColor(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawUseBox(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetProportional(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetSelectable(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
									fwrite(file, EditorString);
									if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
									{
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewModel(playerid, %s[playerid], %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewRot(playerid, %s[playerid], %f, %f, %f, %f);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
										fwrite(file, EditorString);
										format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewVehCol(playerid, %s[playerid], %i, %i);\n",  GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
										fwrite(file, EditorString);
									}
									fwrite(file, "\n");
								}
							}
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\t%s[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY], NTD_TD[i][TD_Text]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawFont(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Font]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawLetterSize(playerid, %s[playerid], %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawTextSize(playerid, %s[playerid], %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetOutline(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_OutlineSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetShadow(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_ShadowSize]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawAlignment(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Alignment]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Color]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawBackgroundColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BGColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawBoxColor(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_BoxColor]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawUseBox(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_UseBox]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetProportional(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Proportional]);
								fwrite(file, EditorString);
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetSelectable(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_Selectable]);
								fwrite(file, EditorString);
								if(NTD_TD[i][TD_Selectable])
									clickableTD = true;
								if(NTD_TD[i][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
								{
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewModel(playerid, %s[playerid], %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelID]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewRot(playerid, %s[playerid], %f, %f, %f, %f);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
									fwrite(file, EditorString);
									format(EditorString, sizeof EditorString, "\tPlayerTextDrawSetPreviewVehCol(playerid, %s[playerid], %i, %i);\n", GetProcessedTDVarName(i), NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2]);
									fwrite(file, EditorString);
								}
								fwrite(file, "\n");
								
							}
							if(NTD_TD[i][TD_Selectable])
								clickableTD = true;		
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnPlayerDisconnect(playerid)\n{\n");
					if(intoarray) //ARRAY
					{
						nonpubliccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0)
							{
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawDestroy(playerid, PlayerTD[playerid][%i]);\n", nonpubliccount);
								fwrite(file, EditorString);
								nonpubliccount++;
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawDestroy(playerid, %s[playerid]);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\tPlayerTextDrawDestroy(playerid, %s[playerid]);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					
					fwrite(file, "\npublic OnPlayerCommandText(playerid, cmdtext[])\n{\n");
					fwrite(file, "\tif(!strcmp(cmdtext, \x22/tdtest\x22, true))\n\t{\n");
					if(intoarray) //ARRAY
					{
						publiccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0)
							{
								format(EditorString, sizeof EditorString, "\t\tTextDrawShowForPlayer(playerid, PublicTD[%i]);\n", publiccount);
								fwrite(file, EditorString);
								publiccount++;
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "\t\tTextDrawShowForPlayer(playerid, %s);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\t\tTextDrawShowForPlayer(playerid, %s);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					if(intoarray) //ARRAY
					{
						nonpubliccount = 0;
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) == 0)
							{
								format(EditorString, sizeof EditorString, "\t\tPlayerTextDrawShow(playerid, PlayerTD[playerid][%i]);\n", nonpubliccount);
								fwrite(file, EditorString);
								nonpubliccount++;
							}
						}
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic] && strlen(NTD_TD[i][TD_VarName]) != 0)
							{
								format(EditorString, sizeof EditorString, "\t\tPlayerTextDrawShow(playerid, %s[playerid]);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
						}
					}
					else //NON ARRAY
					{
						foreach(new i : I_TEXTDRAWS)
						{
							if(!NTD_TD[i][TD_IsPublic])
							{
								format(EditorString, sizeof EditorString, "\t\tPlayerTextDrawShow(playerid, %s[playerid]);\n", GetProcessedTDVarName(i));
								fwrite(file, EditorString);
							}
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

stock OpenTDDialog(playerid)
{
	new formatedtd[MAXFORMATEDTD];
	CreateDialogOnLanguageData(DL_TDLIST);
	
	foreach(new i : I_TEXTDRAWS)
	{
		format(formatedtd, MAXFORMATEDTD, NTD_TD[i][TD_Text]);
		if(strlen(NTD_TD[i][TD_Text]) > MAXFORMATEDTD - 4)
		{
			strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
			strcat(formatedtd, "...");
		}
		if(i != NTD_User[User_EditingTDID]) format(EditorString, sizeof EditorString, "{FFFFFF}%i. {76DCC0}\x22%s\x22\t(%s)\n", i, formatedtd, GetProcessedTDVarName(i));
		else format(EditorString, sizeof EditorString, "{FFFFFF}%i. {FFFF00}\x22%s\x22\t(%s)\n", i, formatedtd, GetProcessedTDVarName(i));
		strcat(EditorLString, EditorString);
	}
	PlayerSelectTD(playerid, false);
	//
	CreateDialogCaptionOnLangData(DL_TDLIST);
	new tmp_str[2][24];
	format(tmp_str[0], 24, "%i", Iter_Count(I_TEXTDRAWS));
	format(tmp_str[1], 24, "%i", MAX_TDS);
	strreplace(EditorString, "#1", tmp_str[0]);
	strreplace(EditorString, "#2", tmp_str[1]);
	
	ShowPlayerDialog(playerid, DIALOG_MANAGE, DIALOG_STYLE_TABLIST_HEADERS,  EditorString, EditorLString, DLS[DL_TDLIST][d_s_button1], DLS[DL_TDLIST][d_s_button2], 9);
	return 1;
}

stock GetAllProjects()
{
	new index, line[128];
	if(dfile_FileExists(PROJECTLIST_FILEPATH))
	{
		Iter_Clear(I_PROJECTS);
		new File:file = fopen(PROJECTLIST_FILEPATH, io_read);
		if(file)
		{
			while(fread(file, line))
			{
				index = Iter_Free(I_PROJECTS);
				if(index >= 0 && index < MAX_PROJECTS)
				{
					if(sscanf(line, "siiiiii", 
					NTD_Projects[index][Pro_Name], 
					NTD_Projects[index][Pro_TDA], 
					NTD_Projects[index][Pro_LastHour],
					NTD_Projects[index][Pro_LastMin],
					NTD_Projects[index][Pro_LastDay], 
					NTD_Projects[index][Pro_LastMonth], 
					NTD_Projects[index][Pro_LastYear]) == 0)
					{
						Iter_Add(I_PROJECTS, index);
					}
				}
				else break;
			}
			fclose(file);
		}
	}
	return index;
}

stock OpenProjectDialog(playerid)
{
	EditorString = "";
	EditorLString = "";
	if(Iter_Count(I_PROJECTS) > 0)
	{
		CreateDialogOnLanguageData(DL_PROJECTSLIST);
		foreach(new i : I_PROJECTS)
		{
			format(EditorString, sizeof EditorString, "%s\t%d\t%02d.%02d.%04d | %02d:%02d\n", 
			NTD_Projects[i][Pro_Name], 
			NTD_Projects[i][Pro_TDA], 
			NTD_Projects[i][Pro_LastDay],
			NTD_Projects[i][Pro_LastMonth], 
			NTD_Projects[i][Pro_LastYear], 
			NTD_Projects[i][Pro_LastHour], 
			NTD_Projects[i][Pro_LastMin]);
			strcat(EditorLString, EditorString);
		}
		//
		CreateDialogCaptionOnLangData(DL_PROJECTSLIST);
		new tmp_str[2][24];
		format(tmp_str[0], 24, "%i", Iter_Count(I_PROJECTS));
		format(tmp_str[1], 24, "%i", MAX_PROJECTS);
		strreplace(EditorString, "#1", tmp_str[0]);
		strreplace(EditorString, "#2", tmp_str[1]);
		ShowPlayerDialog(playerid, DIALOG_OPEN, DIALOG_STYLE_TABLIST_HEADERS, EditorString, EditorLString, DLS[DL_PROJECTSLIST][d_s_button1], DLS[DL_PROJECTSLIST][d_s_button2], 10);
		PlayerSelectTD(playerid, false);
	}
	else 
	{
		ShowInfo(playerid, Language_Strings[str_noprojectsfound]);
	}
	return 1;
}

stock ColorDialog(playerid, cstate)
{
	if(cstate == 0)
	{
		CreateDialogOnLanguageData(DL_COLORCHANGELIST1);
		CreateDialogCaptionOnLangData(DL_COLORCHANGELIST1);
		ShowPlayerDialog(playerid, DIALOG_COLOR1, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_COLORCHANGELIST1][d_s_button1], DLS[DL_COLORCHANGELIST1][d_s_button2]);
		PlayerSelectTD(playerid, false);
	}
	else if(cstate == 1)
	{
		CreateDialogOnLanguageData(DL_COLORCHANGELIST2);
		CreateDialogCaptionOnLangData(DL_COLORCHANGELIST2);
		ShowPlayerDialog(playerid, DIALOG_COLOR2, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_COLORCHANGELIST2][d_s_button1], DLS[DL_COLORCHANGELIST2][d_s_button2]);
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
		if(NTD_User[User_CursorTimer] == -1)
			NTD_User[User_CursorTimer] = SetTimerEx("PlayerSelectTD", 1000, true, "ib", playerid, true);
	}
	else
	{
		CancelSelectTextDraw(playerid);
		if(NTD_User[User_CursorTimer] != -1)
		{
			KillTimer(NTD_User[User_CursorTimer]);
			NTD_User[User_CursorTimer] = -1;
		}
	}
	return 1;
}

stock ShowEditorEx(playerid, bool:showmouse = true)
{
	PlayerSelectTD(playerid, showmouse);
	if(NTD_User[User_ProjectOpened] == true)
	{
		if(NTD_User[User_EditingTDID] != -1)
			ShowEditor(playerid, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
		else 
			ShowEditor(playerid, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false);
	}
	else 
		ShowEditor(playerid, true, true, false, false, false, false, false, false ,false, false, false, false, false, false, false, false, false, false);
	return 1;
}

stock DeleteProject(projectname[])
{
	format(EditorString, sizeof EditorString, "NTD/Projects/%s.ntdp", projectname);
	if(dfile_FileExists(EditorString))
	{
		dfile_Delete(EditorString);
		if(fexist(PROJECTLIST_FILEPATH))
		{
			ProjectFileLineReplace(PROJECTLIST_FILEPATH, projectname, "");
			return 1;
		}
	}
	return 0;
}

stock ToggleTextDrawShowForAll(bool:toggle)
{
	EditorTextDrawShowForAll = toggle;
	if(toggle)
	{
		foreach(new i : I_TEXTDRAWS)
		{
			if(NTD_TD[i][TD_Created])
				TextDrawShowForAll(NTD_TD[i][TD_SelfID]);
		}
	}
	else
	{
		foreach(new i : I_TEXTDRAWS)
		{
			if(NTD_TD[i][TD_Created])
			{
				TextDrawHideForAll(NTD_TD[i][TD_SelfID]);
				TextDrawShowForPlayer(NTD_User[User_PlayerIDInEditor], NTD_TD[i][TD_SelfID]);
			}
		}
	}
	return 1;
}

stock LoadConfigurations()
{
	if(dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Open(SETTINGS_FILEPATH);
		EditorPosX = dfile_ReadInt("editor_x");
		EditorPosY = dfile_ReadInt("editor_y");
		EditorCursorColor = dfile_ReadInt("editor_hcolor");
		EditorButtonsColor = dfile_ReadInt("editor_bcolor");
		EditorFasterKey = dfile_ReadInt("editor_fasterkey");
		EditorAcceptKey = dfile_ReadInt("editor_acceptkey");
		EditorQuickSelect = dfile_ReadBool("editor_quickselect");
		EditorTextDrawShowForAll = dfile_ReadBool("editor_tdshowforall");
		EditorCompactMode = dfile_ReadBool("editor_compactmode");
		format(EditorVersion, sizeof EditorVersion, dfile_ReadString("editor_scriptversion"));
		format(EditorLanguageFile, sizeof EditorLanguageFile, dfile_ReadString("editor_languagefile"));
		dfile_CloseFile();
	}
	if(dfile_FileExists(LANGUAGESLIST_FILEPATH))
	{
		new File:file = fopen(LANGUAGESLIST_FILEPATH, io_read);
		new free;
		if(file)
		{
			Iter_Clear(I_LANGUAGES);
			while(fread(file, EditorString, sizeof EditorString))
			{
				free = Iter_Free(I_LANGUAGES);
				if(free >= 0 && free < MAX_LANGUAGES)
				{
					if(sscanf(EditorString, "p=ss", Language[free][l_name], Language[free][l_file]) == 0)
					{
						Iter_Add(I_LANGUAGES, free);
						strdel(Language[free][l_file], strlen(Language[free][l_file]) - 2, strlen(Language[free][l_file]));
						
					}
				}
				else break;
			}
			fclose(file);
		}
	}
	if(Lang(LANG_NONE))
	{
		if(strlen(EditorLanguageFile) > 1)
		{
			format(EditorString, sizeof EditorString, "%s/%s", LANGUAGES_PATH, EditorLanguageFile);
			if(LanguageLoad(EditorString, EditorLanguageFile))
			{
				EditorLanguage = LANGUAGE_LOADED;
			}
			else EditorLanguage = LANG_NONE;
		}
		else EditorLanguage = LANG_NONE;
	}
	return 1;
}

stock RelayerEditor()
{
	DestroyEditor();
	foreach(new i : I_TEXTDRAWS)
	{
		TextDrawDestroy(NTD_TD[i][TD_SelfID]);
		TextDrawDestroy(NTD_TD[i][TD_PickerID]);
	}
	foreach(new i : I_TEXTDRAWS)
	{
		DrawTD(i);
	}
	CreateEditor();
	
	return 1;
}

stock SaveConfigurations()
{
	if(!dfile_FileExists(SETTINGS_FILEPATH))
		dfile_Create(SETTINGS_FILEPATH);
	if(dfile_FileExists(SETTINGS_FILEPATH))
	{
		dfile_Open(SETTINGS_FILEPATH);
		dfile_WriteInt("editor_x", EditorPosX);
		dfile_WriteInt("editor_y", EditorPosY);
		dfile_WriteInt("editor_hcolor", EditorCursorColor);
		dfile_WriteInt("editor_bcolor", EditorButtonsColor);
		dfile_WriteInt("editor_fasterkey", EditorFasterKey);
		dfile_WriteInt("editor_acceptkey", EditorAcceptKey);
		dfile_WriteBool("editor_quickselect", EditorQuickSelect);
		dfile_WriteBool("editor_tdshowforall", EditorTextDrawShowForAll);
		dfile_WriteBool("editor_compactmode", EditorCompactMode);
		dfile_WriteString("editor_scriptversion", EditorVersion);
		dfile_WriteString("editor_languagefile", EditorLanguageFile);
		dfile_SaveFile();
		dfile_CloseFile();
	}
	return 1;
}

stock ProjectFileLineReplace(filename[], find[], replace[])
{
    if(!fexist(filename)) return 0;
    new File:handle = fopen(filename, io_read);
    if(!handle) return 0;
    new File:tmp = ftemp();
    if(!tmp)
    {
        fclose(handle);
        return 0;
    }
    new line[256], pname[32], timedata[6];
    while(fread(handle, line))
    {
		if(sscanf(line, "siiiiii", pname, timedata[0], timedata[1], timedata[2], timedata[3], timedata[4], timedata[5]) == 0)
		{
			if(strcmp(pname, find, true) == 0)
			{
				fwrite(tmp, replace);
			}
			else fwrite(tmp, line);
		}
    }
    fclose(handle);
    fseek(tmp, 0);
    handle = fopen(filename, io_write);
    if(!handle)
    {
        fclose(tmp);
        return 0;
    }
    while(fread(tmp, line))
    {
        fwrite(handle, line);
    }
    fclose(handle);
    fclose(tmp);
    return 1;
}

stock SaveProject()
{
	new file[300], stringex[128];
	
	//Project List
	format(file, sizeof file, PROJECTLIST_FILEPATH);
	if(fexist(file))
	{
		new hour, minute, second, year, month, day;
		gettime(hour, minute, second);
		getdate(year, month, day);
		//
		format(EditorString, sizeof EditorString, "%s %i %i %i %i %i %i\n", NTD_User[User_ProjectName], Iter_Count(I_TEXTDRAWS), hour, minute, day, month, year);
		ProjectFileLineReplace(file, NTD_User[User_ProjectName], EditorString);
		GetAllProjects();
	}
	
	//Project File
	format(file, sizeof file, "NTD/Projects/%s.ntdp", NTD_User[User_ProjectName]);
	if(dfile_FileExists(file) && NTD_User[User_ProjectOpened])
	{
		dfile_Open(file);
		foreach(new i : I_TEXTDRAWS)
		{
			if(NTD_TD[i][TD_Created])
			{
				EditorLString = "";
				
				format(EditorString, sizeof EditorString, "td_%i_string", i);
				dfile_WriteString(EditorString, NTD_TD[i][TD_Text]);
				format(EditorString, sizeof EditorString, "td_%i_data", i);
				format(stringex, sizeof stringex, "%f %f ", NTD_TD[i][TD_PosX], NTD_TD[i][TD_PosY]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD_TD[i][TD_Font], NTD_TD[i][TD_IsPublic]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD_TD[i][TD_OutlineSize], NTD_TD[i][TD_ShadowSize]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%f %f ", NTD_TD[i][TD_LetterSizeX], NTD_TD[i][TD_LetterSizeY]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD_TD[i][TD_Color], NTD_TD[i][TD_BGColor], NTD_TD[i][TD_BoxColor]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %f %f ", NTD_TD[i][TD_UseBox], NTD_TD[i][TD_BoxSizeX], NTD_TD[i][TD_BoxSizeY]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD_TD[i][TD_Selectable], NTD_TD[i][TD_Alignment], NTD_TD[i][TD_Proportional]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i %i %f %f %f %f ", NTD_TD[i][TD_PrevModelID], NTD_TD[i][TD_PrevModelC1], NTD_TD[i][TD_PrevModelC2], NTD_TD[i][TD_PrevRotX], NTD_TD[i][TD_PrevRotY], NTD_TD[i][TD_PrevRotZ], NTD_TD[i][TD_PrevRotZoom]);
				strcat(EditorLString, stringex);
				format(stringex, sizeof stringex, "%i %i %i %s", NTD_TD[i][TD_ColorAlpha], NTD_TD[i][TD_BGColorAlpha], NTD_TD[i][TD_BoxColorAlpha], NTD_TD[i][TD_VarName]);
				strcat(EditorLString, stringex);
				dfile_WriteString(EditorString, EditorLString);
			}
			else
			{
				format(EditorString, sizeof EditorString, "td_%i_string", i);
				dfile_UnSet(EditorString);
				format(EditorString, sizeof EditorString, "td_%i_data", i);
				dfile_UnSet(EditorString);
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
	format(EditorString, sizeof EditorString, "NTD/Projects/%s.ntdp", projectname);
	if(dfile_FileExists(EditorString))
	{
		Iter_Clear(I_TEXTDRAWS);
		for(new i; i < MAX_TDS; i++)
			NTD_TD[i][TD_Created] = false;
			
		format(NTD_User[User_ProjectName], 128, projectname);
		NTD_User[User_ProjectOpened] = true;
		dfile_Open(EditorString);
		new index;
		for(new i; i < MAX_TDS; i++)
		{
			format(EditorString, sizeof EditorString, "td_%i_data", i);
			if(strlen(dfile_ReadString(EditorString)) > 0)
			{
				index = Iter_Free(I_TEXTDRAWS);
				if(index >= 0 && index < MAX_TEXT_DRAWS)
				{
					Iter_Add(I_TEXTDRAWS, index);
					NTD_TD[index][TD_Created] = true;
					NTD_TD[index][TD_HighlightTimer] = -1;
					format(EditorString, sizeof EditorString, "td_%i_string", i);
					format(NTD_TD[index][TD_Text] , 300, dfile_ReadString(EditorString));
					format(EditorString, sizeof EditorString, "td_%i_data", i);
					format(EditorLString, sizeof EditorLString, dfile_ReadString(EditorString)); 
					
					sscanf(EditorLString, "ffiiiiffiiiiffiiiiiiffffiiis",
					NTD_TD[index][TD_PosX], NTD_TD[index][TD_PosY], NTD_TD[index][TD_Font], NTD_TD[index][TD_IsPublic],
					NTD_TD[index][TD_OutlineSize], NTD_TD[index][TD_ShadowSize], NTD_TD[index][TD_LetterSizeX], NTD_TD[index][TD_LetterSizeY],
					NTD_TD[index][TD_Color], NTD_TD[index][TD_BGColor], NTD_TD[index][TD_BoxColor], NTD_TD[index][TD_UseBox], NTD_TD[index][TD_BoxSizeX], NTD_TD[index][TD_BoxSizeY],
					NTD_TD[index][TD_Selectable], NTD_TD[index][TD_Alignment], NTD_TD[index][TD_Proportional], NTD_TD[index][TD_PrevModelID], NTD_TD[index][TD_PrevModelC1], 
					NTD_TD[index][TD_PrevModelC2], NTD_TD[index][TD_PrevRotX], NTD_TD[index][TD_PrevRotY], NTD_TD[index][TD_PrevRotZ], NTD_TD[index][TD_PrevRotZoom],
					NTD_TD[index][TD_ColorAlpha], NTD_TD[index][TD_BGColorAlpha], NTD_TD[index][TD_BoxColorAlpha], NTD_TD[index][TD_VarName]);

					if(strlen(NTD_TD[index][TD_VarName]) == 0)
						format(NTD_TD[index][TD_VarName], 35, "");
					
					DrawTD(index);
				}
				else break;
			}
		}
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
	
	sscanf(Template[templateid][Template_Data], "sffiiiiffiiiiffiiiiiiffffiii",
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

stock GetTemplatesAsLanguage(langname[])
{
	if(dfile_FileExists(TEMPLATESLIST_FILEPATH))
	{
		printf("[NTD] Loading templates from \"%s\" as language \"%s\"", TEMPLATESLIST_FILEPATH, langname);
		new File:lfile = fopen(TEMPLATESLIST_FILEPATH, io_read);
		if(lfile)
		{
			Iter_Clear(I_TEMPLATES);
			new line[320], template_name[60], template_string[258];
			new mline[2], bool:template_extract_mode = false;
			while(fread(lfile, line)) 
			{
				if(template_extract_mode)
				{
					mline[0] = strfind(line, "</template>", true);
					if(mline[0] != -1)
					{
						template_extract_mode = false;
						continue;
					}
					else
					{
						mline[1] = strfind(line, "<templatedata>", true);
						if(mline[1] != -1)
						{
							strmid(template_string, line, (mline[1] + 14), strlen(line));
							new free = Iter_Free(I_TEMPLATES);
							if(free >= 0 && free < MAX_TEMPLATES)
							{
								Iter_Add(I_TEMPLATES, free);
								format(Template[free][Template_Name], 60, template_name);
								format(Template[free][Template_Data], 258, template_string);
							}
							else break;
							template_extract_mode = false;
							continue;
						}
					}
				}
				else
				{
					mline[0] = strfind(line, "<template name", true);
					if(mline[0] != -1 && strfind(line, langname, true) != -1)
					{
						mline[1] = -1;
						for(new i = mline[0] + 15; i < strlen(line); i++)
						{
							if(line[i] == '"' && mline[1] == -1) 
								mline[1] = i;
							else if(mline[1] != -1 && line[i] == '"')
							{
								strmid(template_name, line, (mline[1] + 1), i);
								template_extract_mode = true;
								break;
							}
						}
					}
					else continue;
				}
			}
			fclose(lfile);
			return 1;
		}
	}
	return 0;
}

stock DestroyTD(td)
{
	if(NTD_TD[td][TD_Created] == true)
	{
		//Iter_SafeRemove(I_TEXTDRAWS, td);
		NTD_TD[td][TD_Created] = false;
		TextDrawDestroy(NTD_TD[td][TD_SelfID]);
		TextDrawDestroy(NTD_TD[td][TD_PickerID]);
	}
}

forward HLTD(playerid, td);
public HLTD(playerid, td)
{
	new red, green, blue, alpha;
	#pragma unused alpha
	RGBAToHex(NTD_TD[td][TD_Color],red,green,blue, alpha); 
	HexToRGBA(NTD_TD[td][TD_Color],red,green,blue,NTD_TD[td][TD_ColorAlpha]);
	TextDrawColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Color]);
	RGBAToHex(NTD_TD[td][TD_BGColor],red,green,blue, alpha);
	HexToRGBA(NTD_TD[td][TD_BGColor],red,green,blue,NTD_TD[td][TD_BGColorAlpha]);
	TextDrawBackgroundColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BGColor]);
	RGBAToHex(NTD_TD[td][TD_BoxColor],red,green,blue, alpha); 
	HexToRGBA(NTD_TD[td][TD_BoxColor],red,green,blue,NTD_TD[td][TD_BoxColorAlpha]);
	TextDrawBoxColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxColor]);
	TextDrawShowForPlayer(playerid, NTD_TD[td][TD_SelfID]);
	return 1;
}

stock HighlightTD(playerid, td)
{
	TextDrawColor(NTD_TD[td][TD_SelfID], 0xFFFF00FF);
	TextDrawBackgroundColor(NTD_TD[td][TD_SelfID], 0xFFFF00FF);
	TextDrawBoxColor(NTD_TD[td][TD_SelfID], 0xFFFF00FF);
	TextDrawShowForPlayer(playerid, NTD_TD[td][TD_SelfID]);

	if(NTD_TD[td][TD_HighlightTimer] != -1)
		KillTimer(NTD_TD[td][TD_HighlightTimer]);
	NTD_TD[td][TD_HighlightTimer] = SetTimerEx("HLTD", 250, false, "ii", playerid, td);
	return 1;
}

stock DrawTD(td)
{
	new playerid = NTD_User[User_PlayerIDInEditor];
	new red, green, blue, alpha;
	#pragma unused alpha
	if(NTD_TD[td][TD_Created] == true)
	{
		//TD
		NTD_TD[td][TD_SelfID] = TextDrawCreate(NTD_TD[td][TD_PosX], NTD_TD[td][TD_PosY], NTD_TD[td][TD_Text]);
		TextDrawFont(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Font]);
		TextDrawSetOutline(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_OutlineSize]);
		TextDrawSetShadow(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_ShadowSize]);
		TextDrawLetterSize(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_LetterSizeX], NTD_TD[td][TD_LetterSizeY]);
		RGBAToHex(NTD_TD[td][TD_Color],red,green,blue, alpha); 
		HexToRGBA(NTD_TD[td][TD_Color],red,green,blue,NTD_TD[td][TD_ColorAlpha]);
		TextDrawColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Color]);
		RGBAToHex(NTD_TD[td][TD_BGColor],red,green,blue, alpha);
		HexToRGBA(NTD_TD[td][TD_BGColor],red,green,blue,NTD_TD[td][TD_BGColorAlpha]);
		TextDrawBackgroundColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BGColor]);
		RGBAToHex(NTD_TD[td][TD_BoxColor],red,green,blue, alpha); 
		HexToRGBA(NTD_TD[td][TD_BoxColor],red,green,blue,NTD_TD[td][TD_BoxColorAlpha]);
		TextDrawBoxColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxColor]);
		TextDrawUseBox(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_UseBox]);	
		TextDrawTextSize(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxSizeX], NTD_TD[td][TD_BoxSizeY]);
		TextDrawSetSelectable(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Selectable]);
		TextDrawAlignment(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Alignment]);
		TextDrawSetProportional(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Proportional]);
		TextDrawSetPreviewModel(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevModelID]);
		TextDrawSetPreviewRot(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevRotX], NTD_TD[td][TD_PrevRotY], NTD_TD[td][TD_PrevRotZ], NTD_TD[td][TD_PrevRotZoom]);
		TextDrawSetPreviewVehCol(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_PrevModelC1], NTD_TD[td][TD_PrevModelC2]);
		
		//Picker
		NTD_TD[td][TD_PickerID] = TextDrawCreate(NTD_TD[td][TD_PosX] - 1, NTD_TD[td][TD_PosY] - 10, TD_PICKER_TEXT);
		TextDrawFont(NTD_TD[td][TD_PickerID], 1);
		TextDrawSetOutline(NTD_TD[td][TD_PickerID], 0);
		TextDrawSetShadow(NTD_TD[td][TD_PickerID], 0);
		TextDrawLetterSize(NTD_TD[td][TD_PickerID], 0.445833, 1.600000);
		TextDrawTextSize(NTD_TD[td][TD_PickerID], 15.0, 15.0);
		TextDrawAlignment(NTD_TD[td][TD_PickerID], 2);
		TextDrawSetSelectable(NTD_TD[td][TD_PickerID], true);
		
		if(NTD_User[User_EditingTDID] != td) 
			TextDrawColor(NTD_TD[td][TD_PickerID], TDPICKER_COLOR);
		else
			TextDrawColor(NTD_TD[td][TD_PickerID], TDPICKER_COLOR_ACTIVE);
		
		//Show
		if(!EditorTextDrawShowForAll) TextDrawShowForPlayer(playerid, NTD_TD[td][TD_SelfID]);
		else TextDrawShowForAll(NTD_TD[td][TD_SelfID]);
		
		if(EditorQuickSelect) 
			TextDrawShowForPlayer(playerid, NTD_TD[td][TD_PickerID]);
		return 1;
	}
	return 0;
}

stock GetProcessedTDVarName(tdid)
{
	new string[64] = "ERROR";
	if(NTD_TD[tdid][TD_Created])
	{
		if(strlen(NTD_TD[tdid][TD_VarName]) > 0)
			format(string, sizeof string, NTD_TD[tdid][TD_VarName]);
		else
			format(string, sizeof string, "textdraw_%i", tdid);
	}
	return string;
}

stock CreateNewTD(cloneid = -1, Tstring[] = "_", Float:TPosX = 0.0, Float:TPosY = 0.0, TFont = 0, bool:TisPublic = true, TOutlineSize = 0, 
TShadowSize = 0, Float:TLetterSizeX = 0.0, Float:TLetterSizeY = 0.0, TColor = -1, TBGColor = -1, TBoxColor = -1, 
bool:ZUseBox = true, Float:TBoxSizeX = 0.0, Float:TBoxSizeY = 0.0, bool:TSelectable = false, TAlignment = 0, 
bool:TProportional = true, TPrevModel = 0, TPrevModelC1 = -1, TPrevModelC2 = -1, Float:TPrevRotX = 0.0, Float:TPrevRotY = 0.0,
Float:TPrevRotZ = 0.0, Float:TPrevRotZoom = 0.0, TColorA = -1, TBGColorA = 255, TBoxColorA = 255)
{
	new index = Iter_Free(I_TEXTDRAWS);
	if(index >= 0 && index < MAX_TEXT_DRAWS)
	{
		Iter_Add(I_TEXTDRAWS, index);
		NTD_TD[index][TD_Created] = true;
		switch(cloneid)
		{
			case -2: //Template
			{
				format(NTD_TD[index][TD_Text], 300, Tstring);
				format(NTD_TD[index][TD_VarName], 35, "");
				NTD_TD[index][TD_PosX] = TPosX;
				NTD_TD[index][TD_PosY] = TPosY;
				NTD_TD[index][TD_Font] = TFont;
				NTD_TD[index][TD_IsPublic] = TisPublic;
				NTD_TD[index][TD_OutlineSize] = TOutlineSize;
				NTD_TD[index][TD_ShadowSize] = TShadowSize;
				NTD_TD[index][TD_LetterSizeX] = TLetterSizeX;
				NTD_TD[index][TD_LetterSizeY] = TLetterSizeY;
				NTD_TD[index][TD_BoxSizeX] = TBoxSizeX;
				NTD_TD[index][TD_BoxSizeY] = TBoxSizeY;
				NTD_TD[index][TD_Color] = TColor;
				NTD_TD[index][TD_BGColor] = TBGColor;
				NTD_TD[index][TD_BoxColor] = TBoxColor;
				NTD_TD[index][TD_ColorAlpha] = TColorA;
				NTD_TD[index][TD_BGColorAlpha] = TBGColorA;
				NTD_TD[index][TD_BoxColorAlpha] = TBoxColorA;
				NTD_TD[index][TD_Alignment] = TAlignment;
				NTD_TD[index][TD_Selectable] = TSelectable;
				NTD_TD[index][TD_Proportional] = TProportional;
				NTD_TD[index][TD_UseBox] = ZUseBox;
				NTD_TD[index][TD_PrevModelID] = TPrevModel;
				NTD_TD[index][TD_PrevModelC1] = TPrevModelC1;
				NTD_TD[index][TD_PrevModelC2] = TPrevModelC2;
				NTD_TD[index][TD_PrevRotX] = TPrevRotX;
				NTD_TD[index][TD_PrevRotY] = TPrevRotY;
				NTD_TD[index][TD_PrevRotZ] = TPrevRotZ;
				NTD_TD[index][TD_PrevRotZoom] = TPrevRotZoom;
			}
			case -1: //Normal
			{
				format(NTD_TD[index][TD_Text], 300, "TextDraw");
				format(NTD_TD[index][TD_VarName], 35, "");
				NTD_TD[index][TD_PosX] = 233.0;
				NTD_TD[index][TD_PosY] = 225.0;
				NTD_TD[index][TD_Font] = 1;
				NTD_TD[index][TD_IsPublic] = true;
				NTD_TD[index][TD_OutlineSize] = 1;
				NTD_TD[index][TD_ShadowSize] = 0;
				NTD_TD[index][TD_LetterSizeX] = 0.6;
				NTD_TD[index][TD_LetterSizeY] = 2.0;
				NTD_TD[index][TD_BoxSizeX] = 400.0;
				NTD_TD[index][TD_BoxSizeY] = 17.0;
				NTD_TD[index][TD_Color] = -1;
				NTD_TD[index][TD_BGColor] = 255;
				NTD_TD[index][TD_BoxColor] = 100;
				NTD_TD[index][TD_ColorAlpha] = 255;
				NTD_TD[index][TD_BGColorAlpha] = 255;
				NTD_TD[index][TD_BoxColorAlpha] = 50;
				NTD_TD[index][TD_Alignment] = 1;
				NTD_TD[index][TD_Selectable] = false;
				NTD_TD[index][TD_Proportional] = true;
				NTD_TD[index][TD_UseBox] = true;
				NTD_TD[index][TD_PrevModelID] = 0;
				NTD_TD[index][TD_PrevModelC1] = 1;
				NTD_TD[index][TD_PrevModelC2] = 1;
				NTD_TD[index][TD_PrevRotX] = -10.0;
				NTD_TD[index][TD_PrevRotY] = 0.0;
				NTD_TD[index][TD_PrevRotZ] = -20.0;
				NTD_TD[index][TD_PrevRotZoom] = 1.0;
			}
			default: //Clone
			{
				if(NTD_TD[cloneid][TD_Created] == true)
				{
					format(NTD_TD[index][TD_Text], 300, NTD_TD[cloneid][TD_Text]);
					format(NTD_TD[index][TD_VarName], 35, "");
					NTD_TD[index][TD_PosX] = NTD_TD[cloneid][TD_PosX];
					NTD_TD[index][TD_PosY] = NTD_TD[cloneid][TD_PosY];
					NTD_TD[index][TD_Font] = NTD_TD[cloneid][TD_Font];
					NTD_TD[index][TD_IsPublic] = NTD_TD[cloneid][TD_IsPublic];
					NTD_TD[index][TD_OutlineSize] = NTD_TD[cloneid][TD_OutlineSize];
					NTD_TD[index][TD_ShadowSize] = NTD_TD[cloneid][TD_ShadowSize];
					NTD_TD[index][TD_LetterSizeX] = NTD_TD[cloneid][TD_LetterSizeX];
					NTD_TD[index][TD_LetterSizeY] = NTD_TD[cloneid][TD_LetterSizeY];
					NTD_TD[index][TD_BoxSizeX] = NTD_TD[cloneid][TD_BoxSizeX];
					NTD_TD[index][TD_BoxSizeY] = NTD_TD[cloneid][TD_BoxSizeY];
					NTD_TD[index][TD_Color] = NTD_TD[cloneid][TD_Color];
					NTD_TD[index][TD_BGColor] = NTD_TD[cloneid][TD_BGColor];
					NTD_TD[index][TD_BoxColor] = NTD_TD[cloneid][TD_BoxColor];
					NTD_TD[index][TD_ColorAlpha] = NTD_TD[cloneid][TD_ColorAlpha];
					NTD_TD[index][TD_BGColorAlpha] = NTD_TD[cloneid][TD_BGColorAlpha];
					NTD_TD[index][TD_BoxColorAlpha] = NTD_TD[cloneid][TD_BoxColorAlpha];
					NTD_TD[index][TD_Alignment] = NTD_TD[cloneid][TD_Alignment];
					NTD_TD[index][TD_Selectable] = NTD_TD[cloneid][TD_Selectable];
					NTD_TD[index][TD_Proportional] = NTD_TD[cloneid][TD_Proportional];
					NTD_TD[index][TD_UseBox] = NTD_TD[cloneid][TD_UseBox];
					NTD_TD[index][TD_PrevModelID] = NTD_TD[cloneid][TD_PrevModelID];
					NTD_TD[index][TD_PrevModelC1] = NTD_TD[cloneid][TD_PrevModelC1];
					NTD_TD[index][TD_PrevModelC2] = NTD_TD[cloneid][TD_PrevModelC2];
					NTD_TD[index][TD_PrevRotX] = NTD_TD[cloneid][TD_PrevRotX];
					NTD_TD[index][TD_PrevRotY] = NTD_TD[cloneid][TD_PrevRotY];
					NTD_TD[index][TD_PrevRotZ] = NTD_TD[cloneid][TD_PrevRotZ];
					NTD_TD[index][TD_PrevRotZoom] = NTD_TD[cloneid][TD_PrevRotZoom];
				}
			}
		}
		return index;
	}
	return -1;
}

stock ShowEditor(playerid, bool:b1_active, bool:b2_active, bool:b3_active, bool:b4_active, bool:b5_active, bool:b6_active, bool:b7_active, bool:b8_active, bool:b9_active, bool:b10_active, bool:b11_active, bool:b12_active, bool:b13_active, bool:b14_active, bool:b15_active, bool:b16_active, bool:b17_active, bool:b18_active)
{
	HideEditor(playerid);
	TextDrawShowForPlayer(playerid, B_Exit);
	TextDrawShowForPlayer(playerid, B_Settings);
	TextDrawShowForPlayer(playerid, E_Box);
	
	TextDrawSetSelectable(B_NewProject, false);
	TextDrawSetSelectable(B_OpenProject, false);
	TextDrawSetSelectable(B_CloseProject, false);
	TextDrawSetSelectable(B_Export, false);
	TextDrawSetSelectable(B_Manage, false);
	TextDrawSetSelectable(B_Font, false);
	TextDrawSetSelectable(B_MPreview, false);
	TextDrawSetSelectable(B_Position, false);
	TextDrawSetSelectable(B_Size, false);
	TextDrawSetSelectable(B_Tekst, false);
	TextDrawSetSelectable(B_Color, false);
	TextDrawSetSelectable(B_Outline, false);
	TextDrawSetSelectable(B_Shadow, false);
	TextDrawSetSelectable(B_UseBox, false);
	TextDrawSetSelectable(B_Alignment, false);
	TextDrawSetSelectable(B_SwitchPublic, false);
	TextDrawSetSelectable(B_Selectable, false);
	TextDrawSetSelectable(B_Proportionality, false);
	
	new red,green,blue, alpha, unsetcolor;
	#pragma unused alpha
	RGBAToHex(EditorButtonsColor,red,green,blue, alpha); 
	HexToRGBA(unsetcolor,red,green,blue,35);
	TextDrawColor(B_NewProject, unsetcolor);
	TextDrawColor(B_OpenProject, unsetcolor);
	TextDrawColor(B_CloseProject, unsetcolor);
	TextDrawColor(B_Export, unsetcolor);
	TextDrawColor(B_Manage, unsetcolor);
	TextDrawColor(B_Font, unsetcolor);
	TextDrawColor(B_MPreview, unsetcolor);
	TextDrawColor(B_Position, unsetcolor);
	TextDrawColor(B_Size, unsetcolor);
	TextDrawColor(B_Tekst, unsetcolor);
	TextDrawColor(B_Color, unsetcolor);
	TextDrawColor(B_Outline, unsetcolor);
	TextDrawColor(B_Shadow, unsetcolor);
	TextDrawColor(B_UseBox, unsetcolor);
	TextDrawColor(B_Alignment, unsetcolor);
	TextDrawColor(B_SwitchPublic, unsetcolor);
	TextDrawColor(B_Selectable, unsetcolor);
	TextDrawColor(B_Proportionality, unsetcolor);
	
	if(b1_active) 
		TextDrawSetSelectable(B_NewProject, true),
		TextDrawColor(B_NewProject, EditorButtonsColor);
	if(b2_active) 
		TextDrawSetSelectable(B_OpenProject, true),
		TextDrawColor(B_OpenProject, EditorButtonsColor);
	if(b3_active) 
		TextDrawSetSelectable(B_CloseProject, true),
		TextDrawColor(B_CloseProject, EditorButtonsColor);
	if(b4_active) 
		TextDrawSetSelectable(B_Export, true),
		TextDrawColor(B_Export, EditorButtonsColor);
	if(b5_active) 
		TextDrawSetSelectable(B_Manage, true),
		TextDrawColor(B_Manage, EditorButtonsColor);
	if(b6_active) 
		TextDrawSetSelectable(B_Font, true),
		TextDrawColor(B_Font, EditorButtonsColor);
	if(b7_active) 
		TextDrawSetSelectable(B_MPreview, true),
		TextDrawColor(B_MPreview, EditorButtonsColor);
	if(b8_active) 
		TextDrawSetSelectable(B_Position, true),
		TextDrawColor(B_Position, EditorButtonsColor);
	if(b9_active) 
		TextDrawSetSelectable(B_Size, true),
		TextDrawColor(B_Size, EditorButtonsColor);
	if(b10_active) 
		TextDrawSetSelectable(B_Tekst, true),
		TextDrawColor(B_Tekst, EditorButtonsColor);
	if(b11_active) 
		TextDrawSetSelectable(B_Color, true),
		TextDrawColor(B_Color, EditorButtonsColor);
	if(b12_active) 
		TextDrawSetSelectable(B_Outline, true),
		TextDrawColor(B_Outline, EditorButtonsColor);
	if(b13_active) 
		TextDrawSetSelectable(B_Shadow, true),
		TextDrawColor(B_Shadow, EditorButtonsColor);
	if(b14_active) 
		TextDrawSetSelectable(B_UseBox, true),
		TextDrawColor(B_UseBox, EditorButtonsColor);
	if(b15_active) 
		TextDrawSetSelectable(B_Alignment, true),
		TextDrawColor(B_Alignment, EditorButtonsColor);
	if(b16_active) 
		TextDrawSetSelectable(B_SwitchPublic, true),
		TextDrawColor(B_SwitchPublic, EditorButtonsColor);
	if(b17_active) 
		TextDrawSetSelectable(B_Selectable, true),
		TextDrawColor(B_Selectable, EditorButtonsColor);
	if(b18_active) 
		TextDrawSetSelectable(B_Proportionality, true),
		TextDrawColor(B_Proportionality, EditorButtonsColor);
	
	TextDrawShowForPlayer(playerid, B_NewProject);
	TextDrawShowForPlayer(playerid, B_OpenProject);
	TextDrawShowForPlayer(playerid, B_CloseProject);
	TextDrawShowForPlayer(playerid, B_Export);
	TextDrawShowForPlayer(playerid, B_Manage);
	TextDrawShowForPlayer(playerid, B_Font);
	TextDrawShowForPlayer(playerid, B_MPreview);
	TextDrawShowForPlayer(playerid, B_Position);
	TextDrawShowForPlayer(playerid, B_Size);
	TextDrawShowForPlayer(playerid, B_Tekst);
	TextDrawShowForPlayer(playerid, B_Color);
	TextDrawShowForPlayer(playerid, B_Outline);
	TextDrawShowForPlayer(playerid, B_Shadow);
	TextDrawShowForPlayer(playerid, B_UseBox);
	TextDrawShowForPlayer(playerid, B_Alignment);
	TextDrawShowForPlayer(playerid, B_SwitchPublic);
	TextDrawShowForPlayer(playerid, B_Selectable);
	TextDrawShowForPlayer(playerid, B_Proportionality);
	NTD_User[User_InEditor] = true;
	return 1;
}

stock HideEditor(playerid)
{
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
	if(dfile_FileExists(PROJECTLIST_FILEPATH))
	{
		new line[128], hour, minute, second, year, month, day;
		new File:file = fopen(PROJECTLIST_FILEPATH, io_readwrite);
		if(file)
		{
			while(fread(file, line))
			{
				if(strfind(line, name) != -1)
					return -1;
			}
			gettime(hour, minute, second);
			getdate(year, month, day);
			format(EditorString, sizeof EditorString, "%s 0 %i %i %i %i %i\n", name, hour, minute, day, month, year);
			fwrite(file, EditorString);
			fclose(file);
			return 1;
		}
	}
	return 0;
}

forward FadeTimer(bool:fadein);
public FadeTimer(bool:fadein)
{
	if(fadein)
	{
		if(NTD_User[User_WelcomeScreenAlpha] < 254)
		{
			NTD_User[User_WelcomeScreenAlpha] += 3;
			NTD_User[User_WelcomeScreenColor] = ShiftRGBToRGBA(NTD_User[User_WelcomeScreenColor], NTD_User[User_WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, NTD_User[User_WelcomeScreenColor]);
			TextDrawShowForPlayer(NTD_User[User_PlayerIDInEditor], WelcomeScreen);
		}
		else 
		{
			KillTimer(NTD_User[User_WelcomeTimer]);
			NTD_User[User_WelcomeTimer] = -1;
		}
			
		
	}
	else
	{
		if(NTD_User[User_WelcomeScreenAlpha] > 0)
		{
			NTD_User[User_WelcomeScreenAlpha] -= 3;
			NTD_User[User_WelcomeScreenColor] = ShiftRGBToRGBA(NTD_User[User_WelcomeScreenColor], NTD_User[User_WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, NTD_User[User_WelcomeScreenColor]);
			TextDrawShowForPlayer(NTD_User[User_PlayerIDInEditor], WelcomeScreen);
		}
		else 
		{
			TextDrawDestroy(WelcomeScreen);
			NTD_User[User_WelcomeScreenAlpha] = -1;
			KillTimer(NTD_User[User_WelcomeTimer]);
			NTD_User[User_WelcomeTimer] = -1;
		}
	}
	return 1;
}

stock ShowWelcomeScreen(bool:show)
{
	if(show)
	{
		if(NTD_User[User_WelcomeScreenAlpha] == -1)
		{
			NTD_User[User_WelcomeScreenAlpha] = 0;
			NTD_User[User_WelcomeScreenColor] = 0xFFFFFFFF;
			NTD_User[User_WelcomeScreenColor] = ShiftRGBToRGBA(NTD_User[User_WelcomeScreenColor], NTD_User[User_WelcomeScreenAlpha]);
			WelcomeScreen = TextDrawCreate(121.000000, 81.000000, WELCOME_SCREEN);
			TextDrawFont(WelcomeScreen, 4);
			TextDrawTextSize(WelcomeScreen, 397.500000, 244.000000);
			TextDrawColor(WelcomeScreen, NTD_User[User_WelcomeScreenColor]);
		}
		if(NTD_User[User_WelcomeTimer] != -1)
			KillTimer(NTD_User[User_WelcomeTimer]);
			
		TextDrawShowForPlayer(NTD_User[User_PlayerIDInEditor], WelcomeScreen);
		NTD_User[User_WelcomeTimer] = SetTimerEx("FadeTimer", 25, true, "b", true);
	}
	else
	{
		if(NTD_User[User_WelcomeScreenAlpha] != -1)
		{
			if(NTD_User[User_WelcomeTimer] != -1)
				KillTimer(NTD_User[User_WelcomeTimer]);
				
			TextDrawShowForPlayer(NTD_User[User_PlayerIDInEditor], WelcomeScreen);
			NTD_User[User_WelcomeTimer] = SetTimerEx("FadeTimer", 25, true, "b", false);
		}
	}
	return 1;
}

stock CreateEditor()
{
	E_Box = TextDrawCreate((EditorCompactMode) ? (EditorPosX) : (0), EditorPosY, BACKGROUND_BAR);
	TextDrawFont(E_Box, 4);
	TextDrawLetterSize(E_Box, 0.600000, 2.000000);
	TextDrawTextSize(E_Box, 640.000000 / ((EditorCompactMode) ? (EditorCompactSize) : (1.0)), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawBoxColor(E_Box, 0xFFFFFFFF);
	//TextDrawUseBox(E_Box, 1);
	
	B_Exit = TextDrawCreate((EditorCompactMode) ? (EditorPosX) : (0), EditorPosY - 12, BUTTON_EXIT);
	TextDrawFont(B_Exit, 4);
	TextDrawTextSize(B_Exit, BUTTON_TD_SIZE / 3, BUTTON_TD_SIZE / 3);
	TextDrawColor(B_Exit, 0xDC143CFF);
	TextDrawSetSelectable(B_Exit, true);
	
	B_Settings = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SIZE / 3), EditorPosY - 12, BUTTON_SETTINGS);
	TextDrawFont(B_Settings, 4);
	TextDrawTextSize(B_Settings, BUTTON_TD_SIZE / 3, BUTTON_TD_SIZE / 3);
	TextDrawColor(B_Settings, 0xFFFFFFFF);
	TextDrawSetSelectable(B_Settings, true);
	
	B_NewProject = TextDrawCreate((EditorCompactMode) ? (EditorPosX) : (0), EditorPosY, BUTTON_NEW);
	TextDrawFont(B_NewProject, 4);
	TextDrawTextSize(B_NewProject, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_NewProject, true);
	TextDrawColor(B_NewProject, EditorButtonsColor);
	
	B_OpenProject = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), EditorPosY, BUTTON_OPEN);
	TextDrawFont(B_OpenProject, 4);
	TextDrawTextSize(B_OpenProject, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_OpenProject, true);
	TextDrawColor(B_OpenProject, EditorButtonsColor);
	
	B_CloseProject = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 2, EditorPosY, BUTTON_CLOSE);
	TextDrawFont(B_CloseProject, 4);
	TextDrawTextSize(B_CloseProject, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_CloseProject, true);
	TextDrawColor(B_CloseProject, EditorButtonsColor);
	
	B_Export = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 3, EditorPosY, BUTTON_EXPORT);
	TextDrawFont(B_Export, 4);
	TextDrawTextSize(B_Export, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Export, true);
	TextDrawColor(B_Export, EditorButtonsColor);
	
	B_Manage = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 4, EditorPosY, BUTTON_MANAGE);
	TextDrawFont(B_Manage, 4);
	TextDrawTextSize(B_Manage, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Manage, true);
	TextDrawColor(B_Manage, EditorButtonsColor);
	
	B_Font = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 5, EditorPosY, BUTTON_FONT);
	TextDrawFont(B_Font, 4);
	TextDrawTextSize(B_Font, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Font, true);
	TextDrawColor(B_Font, EditorButtonsColor);
	
	B_MPreview = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 6, EditorPosY, BUTTON_MPREVIEW);
	TextDrawFont(B_MPreview, 4);
	TextDrawTextSize(B_MPreview, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_MPreview, true);
	TextDrawColor(B_MPreview, EditorButtonsColor);
	
	B_Position = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 7, EditorPosY, BUTTON_POSITION);
	TextDrawFont(B_Position, 4);
	TextDrawTextSize(B_Position, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Position, true);
	TextDrawColor(B_Position, EditorButtonsColor);
	
	B_Size = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 8, EditorPosY, BUTTON_SIZE);
	TextDrawFont(B_Size, 4);
	TextDrawTextSize(B_Size, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Size, true);
	TextDrawColor(B_Size, EditorButtonsColor);
	
	B_Tekst = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 9, EditorPosY, BUTTON_TEKST);
	TextDrawFont(B_Tekst, 4);
	TextDrawTextSize(B_Tekst, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Tekst, true);
	TextDrawColor(B_Tekst, EditorButtonsColor);
	
	B_Color = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 10, EditorPosY, BUTTON_COLOR);
	TextDrawFont(B_Color, 4);
	TextDrawTextSize(B_Color, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Color, true);
	TextDrawColor(B_Color, EditorButtonsColor);
	
	B_Outline = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 11, EditorPosY, BUTTON_OUTLINE);
	TextDrawFont(B_Outline, 4);
	TextDrawTextSize(B_Outline, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Outline, true);
	TextDrawColor(B_Outline, EditorButtonsColor);
	
	B_Shadow = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 12, EditorPosY, BUTTON_SHADOW);
	TextDrawFont(B_Shadow, 4);
	TextDrawTextSize(B_Shadow, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Shadow, true);
	TextDrawColor(B_Shadow, EditorButtonsColor);
	
	B_UseBox = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 13, EditorPosY, BUTTON_USEBOX);
	TextDrawFont(B_UseBox, 4);
	TextDrawTextSize(B_UseBox, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_UseBox, true);
	TextDrawColor(B_UseBox, EditorButtonsColor);
	
	B_Alignment = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 14, EditorPosY, BUTTON_ALIGNMENT);
	TextDrawFont(B_Alignment, 4);
	TextDrawTextSize(B_Alignment, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Alignment, true);
	TextDrawColor(B_Alignment, EditorButtonsColor);
	
	B_SwitchPublic = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 15, EditorPosY, BUTTON_SWITCHPUBLIC);
	TextDrawFont(B_SwitchPublic, 4);
	TextDrawTextSize(B_SwitchPublic, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_SwitchPublic, true);
	TextDrawColor(B_SwitchPublic, EditorButtonsColor);
	
	B_Selectable = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 16, EditorPosY, BUTTON_SELECTABLE);
	TextDrawFont(B_Selectable, 4);
	TextDrawTextSize(B_Selectable, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Selectable, true);
	TextDrawColor(B_Selectable, EditorButtonsColor);
	
	B_Proportionality = TextDrawCreate(((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))) * 17, EditorPosY, BUTTON_PROPORTIONALITY);
	TextDrawFont(B_Proportionality, 4);
	TextDrawTextSize(B_Proportionality, (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))), (BUTTON_TD_SIZE / ((EditorCompactMode) ? (EditorCompactSize) : (1.0))));
	TextDrawSetSelectable(B_Proportionality, true);
	TextDrawColor(B_Proportionality, EditorButtonsColor);
	
	return 1;
}

stock LanguageLoad(languagefile[], langname[])
{
	new line[320], macro[68], macrotext[258];
	new mline[2], bool:dialogmode, dialogstr[32];
	if(dfile_FileExists(languagefile))
	{
		printf("[NTD] Loading language file \"%s\"", languagefile);
		new File:lfile = fopen(languagefile, io_read);
		if(lfile)
		{
			dialogmode = false;
			while(fread(lfile, line)) 
			{
				mline[0] = -1;
				mline[1] = -1;
				for(new i, j = strlen(line); i < j; i++)
				{
					if(line[0] == '#' || (line[0] == ' ' && !dialogmode))
						break;
					else if(line[i] == '<')
						mline[0] = i;
					else if(line[i] == '>')
						mline[1] = i;
					else if(mline[0] != -1 && mline[1] != -1)
					{
						strmid(macro, line, mline[0] + 1, mline[1]);
						strmid(macrotext, line, mline[1] + 1, j - 1);
						break;
					}
				}
				if(mline[0] != -1)
				{
					if(dialogmode)
					{
						if(strfind(macro, "/dialog") != -1)
							dialogmode = false;
						else
						{
							LanguageMacroApply(macro, macrotext, true, dialogstr);
						}
					}
					else
					{
						if(strfind(macro, "dialog name") != -1)
						{
							mline[0] = -1;
							for(new i, j = strlen(macro); i < j; i++)
							{
								if(macro[i] == '"' && mline[0] == -1)
									mline[0] = i;
								else if(macro[i] == '"' && mline[0] != -1)
								{
									strmid(macro, macro, mline[0] + 1, i);
									break;
								}
							}
							format(dialogstr, sizeof dialogstr, macro);
							//printf("Dialog Macro: %s | Text: %s", macro, macrotext);
							dialogmode = true;
						}
						else
						{
							LanguageMacroApply(macro, macrotext, false);
						}
					}
				}
			}
			fclose(lfile);
			GetTemplatesAsLanguage(langname);
			return 1;
		
		}
	}
	else printf("[NTD] Language file doesn't exist: %s", languagefile);
	return 0;
}

stock LanguageMacroApply(macro[], macrotext[], bool:isdialogmacro, dialogstr[] = "")
{
	if(!isdialogmacro)
	{
		//printf("Macro: %s | Text: %s", macro, macrotext);
		switch(YHash(macro))
		{
			case _H<nopermit>: format(Language_Strings[str_nopermit], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<editordisabled>: format(Language_Strings[str_editordisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<editorinuse>: format(Language_Strings[str_editorinuse], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infodialogcaption>: format(Language_Strings[str_infodialogcaption], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorleave>: format(Language_Strings[str_infoeditorleave], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorlocked>: format(Language_Strings[str_infoeditorlocked], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorreset>: format(Language_Strings[str_infoeditorreset], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<fsenabled>: format(Language_Strings[str_fsenabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<fsdisabled>: format(Language_Strings[str_fsdisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdvforme>: format(Language_Strings[str_tdvforme], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdvforall>: format(Language_Strings[str_tdvforall], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<keysinverted>: format(Language_Strings[str_keysinverted], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorkeyswiched>: format(Language_Strings[str_infoeditorkeyswiched], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorfastselectdisabled>: format(Language_Strings[str_infoeditorfsdisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditorfastselectenabled>: format(Language_Strings[str_infoeditorfsenabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoeditortdvisibility>: format(Language_Strings[str_infoeditortdvisibility], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoinvalidmodelid>: format(Language_Strings[str_infoinvalidmodelid], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectexported>: format(Language_Strings[str_infoprojectexported], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectexporterror>: format(Language_Strings[str_infoprojectexporterror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoparamnamechange>: format(Language_Strings[str_infoparamnamechange], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoparamnamechangetaken>: format(Language_Strings[str_infoparamnamechangetaken], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoparamnamechangecharserr>: format(Language_Strings[str_infoparamnamechangecharserr], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoparamnamechangeammerr>: format(Language_Strings[str_infoparamnamechangeammerr], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infomaxtextdrawsreached>: format(Language_Strings[str_infomaxtextdrawsreached], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infolanguagechanged>: format(Language_Strings[str_infolanguagechanged], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectinvalidname>: format(Language_Strings[str_infoprojectinvalidname], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectexists>: format(Language_Strings[str_infoprojectexists], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectcreated>: format(Language_Strings[str_infoprojectcreated], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectclosed>: format(Language_Strings[str_infoprojectclosed], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectsaveerror>: format(Language_Strings[str_infoprojectsaveerror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectlimit>: format(Language_Strings[str_infoprojectlimit], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infoprojectloaded>: format(Language_Strings[str_infoprojectloaded], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<previewmodelidinvalid>: format(Language_Strings[str_previewmodelidinvalid], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdclonedinfo>: format(Language_Strings[str_tdclonedinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tddeletedinfo>: format(Language_Strings[str_tddeletedinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdcreatedinfo>: format(Language_Strings[str_tdcreatedinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdselectedinfo>: format(Language_Strings[str_tdselectedinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdfontspriteinfo>: format(Language_Strings[str_tdfontspriteinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdfontprevmodelinfo>: format(Language_Strings[str_tdfontprevmodelinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdfontinfo>: format(Language_Strings[str_tdfontinfo], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdcoloralpha>: format(Language_Strings[str_tdcoloralpha], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdlayer>: format(Language_Strings[str_tdlayer], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdeditorposition>: format(Language_Strings[str_tdeditorposition], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdprevmodelcolor>: format(Language_Strings[str_tdprevmodelcolor], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdposition>: format(Language_Strings[str_tdposition], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdrotation>: format(Language_Strings[str_tdrotation], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdsize>: format(Language_Strings[str_tdsize], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdpremodelzoom>: format(Language_Strings[str_tdpremodelzoom], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdsprite>: format(Language_Strings[str_tdsprite], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdproportionality_true>: format(Language_Strings[str_tdproportionality_true], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdproportionality_false>: format(Language_Strings[str_tdproportionality_false], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdalignment_left>: format(Language_Strings[str_tdalignment_left], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdalignment_center>: format(Language_Strings[str_tdalignment_center], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdalignment_right>: format(Language_Strings[str_tdalignment_right], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectrenamed>: format(Language_Strings[str_projectrenamed], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectnamechangecharerr>: format(Language_Strings[str_projectnamechangecharerr], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectnameexists>: format(Language_Strings[str_projectnameexists], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectnamechangeerror>: format(Language_Strings[str_projectnamechangeerror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectloaderror>: format(Language_Strings[str_projectloaderror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectdeleteerror>: format(Language_Strings[str_projectdeleteerror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<projectdeleted>: format(Language_Strings[str_projectdeleted], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<modelpreviewinvalidfont>: format(Language_Strings[str_modelpreviewinvalidfont], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdpublic>: format(Language_Strings[str_tdpublic], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdperplayer>: format(Language_Strings[str_tdperplayer], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdclickable>: format(Language_Strings[str_tdclickable], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdnotclickable>: format(Language_Strings[str_tdnotclickable], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdshadowsize>: format(Language_Strings[str_tdshadowsize], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdboxenabled>: format(Language_Strings[str_tdboxenabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdboxdisabled>: format(Language_Strings[str_tdboxdisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<tdoutlinesize>: format(Language_Strings[str_tdoutlinesize], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<modeltexterror>: format(Language_Strings[str_modeltexterror], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<noprojectsfound>: format(Language_Strings[str_noprojectsfound], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<languagefilenotfound>: format(Language_Strings[str_languagefilenotfound], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infocompmodedisabled>: format(Language_Strings[str_infocompmodedisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<infocompmodeenabled>: format(Language_Strings[str_infocompmodeenabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<compmodeenabled>: format(Language_Strings[str_compmodeenabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<compmodedisabled>: format(Language_Strings[str_compmodedisabled], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<manualchangetypemzoom>: format(Language_Strings[str_manualchangetypemzoom], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<manualchangetypemcolor1>: format(Language_Strings[str_manualchangetypemcolor1], DEFAULT_LANG_STRING_SIZE, macrotext);
			case _H<manualchangetypemcolor2>: format(Language_Strings[str_manualchangetypemcolor2], DEFAULT_LANG_STRING_SIZE, macrotext);
		}
	}
	else
	{
		//printf("Dialog: %s | Macro: %s | Text: %s", dialogstr, macro, macrotext);
		if(isnull(macro))
			return 0;
		if(strcmp(macro, "caption", true) == 0)
		{
			switch(YHash(dialogstr))
			{
				case _H<dialogsettings>: format(DLS[DL_SETTINGS][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<spritechange>: format(DLS[DL_SPRITECHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<overridecolorchange>: format(DLS[DL_OVERRIDECOLORCHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<buttonscolorchange>: format(DLS[DL_BUTTONSCOLORCHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<settingsreset>: format(DLS[DL_SETTINGSRESET][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<newproject>: format(DLS[DL_NEWPROJECT][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<textdrawslist>: format(DLS[DL_TDLIST][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<exportproject>: format(DLS[DL_EXPORTPROJECT][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<newtextdraw>: format(DLS[DL_NEWTEXTDRAW][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<projectslist>: format(DLS[DL_PROJECTSLIST][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<exitconfirmation>: format(DLS[DL_EXITCONFIRMATION][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<tdoptions>: format(DLS[DL_TDOPTIONS][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<projectsoptions>: format(DLS[DL_PROJECTSOPTIONS][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<previewmodelid>: format(DLS[DL_PREVIEWMODELID][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<variablechange>: format(DLS[DL_VARIABLECHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<colorchange>: format(DLS[DL_COLORCHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<deletedconfirm>: format(DLS[DL_DELETECONFIRM][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<usetemplate>: format(DLS[DL_USETEMPLATE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<premadecolors>: format(DLS[DL_PREMADECOLORS][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<changeprojectname>: format(DLS[DL_PROJECTNAMECHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<deleteprojectconfirm>: format(DLS[DL_DELETEPROJECTCONFIRM][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<previewmodelchangelist>: format(DLS[DL_PREVIEWMODELCHANGELIST][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<textchange>: format(DLS[DL_TEXTCHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<spritechangelist>: format(DLS[DL_SPRITECHANGELIST][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<boxsizechangelist>: format(DLS[DL_BOXSIZECHANGELIST][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<colorchangelist1>: format(DLS[DL_COLORCHANGELIST1][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<colorchangelist2>: format(DLS[DL_COLORCHANGELIST2][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<oldversionsettingsreset>: format(DLS[DL_OLDVERSIONSETTINGSRESET][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<exportwitharray>: format(DLS[DL_EXPORTWITHARRAY][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<manualvarchange>: format(DLS[DL_MANUALVARCHANGE][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
				case _H<manualchangemessage>: format(DLS[DL_MANUALVARCHANGE1][d_s_caption], DEFAULT_LANG_STRING_SIZE, macrotext);
			}
		}
		else if(strcmp(macro, "button1", true) == 0)
		{
			switch(YHash(dialogstr))
			{
				case _H<dialogsettings>: format(DLS[DL_SETTINGS][d_s_button1], 32, macrotext);
				case _H<spritechange>: format(DLS[DL_SPRITECHANGE][d_s_button1], 32, macrotext);
				case _H<overridecolorchange>: format(DLS[DL_OVERRIDECOLORCHANGE][d_s_button1], 32, macrotext);
				case _H<buttonscolorchange>: format(DLS[DL_BUTTONSCOLORCHANGE][d_s_button1], 32, macrotext);
				case _H<settingsreset>: format(DLS[DL_SETTINGSRESET][d_s_button1], 32, macrotext);
				case _H<newproject>: format(DLS[DL_NEWPROJECT][d_s_button1], 32, macrotext);
				case _H<textdrawslist>: format(DLS[DL_TDLIST][d_s_button1], 32, macrotext);
				case _H<exportproject>: format(DLS[DL_EXPORTPROJECT][d_s_button1], 32, macrotext);
				case _H<newtextdraw>: format(DLS[DL_NEWTEXTDRAW][d_s_button1], 32, macrotext);
				case _H<projectslist>: format(DLS[DL_PROJECTSLIST][d_s_button1], 32, macrotext);
				case _H<exitconfirmation>: format(DLS[DL_EXITCONFIRMATION][d_s_button1], 32, macrotext);
				case _H<tdoptions>: format(DLS[DL_TDOPTIONS][d_s_button1], 32, macrotext);
				case _H<projectsoptions>: format(DLS[DL_PROJECTSOPTIONS][d_s_button1], 32, macrotext);
				case _H<previewmodelid>: format(DLS[DL_PREVIEWMODELID][d_s_button1], 32, macrotext);
				case _H<variablechange>: format(DLS[DL_VARIABLECHANGE][d_s_button1], 32, macrotext);
				case _H<colorchange>: format(DLS[DL_COLORCHANGE][d_s_button1], 32, macrotext);
				case _H<deletedconfirm>: format(DLS[DL_DELETECONFIRM][d_s_button1], 32, macrotext);
				case _H<usetemplate>: format(DLS[DL_USETEMPLATE][d_s_button1], 32, macrotext);
				case _H<premadecolors>: format(DLS[DL_PREMADECOLORS][d_s_button1], 32, macrotext);
				case _H<changeprojectname>: format(DLS[DL_PROJECTNAMECHANGE][d_s_button1], 32, macrotext);
				case _H<deleteprojectconfirm>: format(DLS[DL_DELETEPROJECTCONFIRM][d_s_button1], 32, macrotext);
				case _H<previewmodelchangelist>: format(DLS[DL_PREVIEWMODELCHANGELIST][d_s_button1], 32, macrotext);
				case _H<textchange>: format(DLS[DL_TEXTCHANGE][d_s_button1], 32, macrotext);
				case _H<spritechangelist>: format(DLS[DL_SPRITECHANGELIST][d_s_button1], 32, macrotext);
				case _H<boxsizechangelist>: format(DLS[DL_BOXSIZECHANGELIST][d_s_button1], 32, macrotext);
				case _H<colorchangelist1>: format(DLS[DL_COLORCHANGELIST1][d_s_button1], 32, macrotext);
				case _H<colorchangelist2>: format(DLS[DL_COLORCHANGELIST2][d_s_button1], 32, macrotext);
				case _H<oldversionsettingsreset>: format(DLS[DL_OLDVERSIONSETTINGSRESET][d_s_button1], 32, macrotext);
				case _H<exportwitharray>: format(DLS[DL_EXPORTWITHARRAY][d_s_button1], 32, macrotext);
				case _H<manualvarchange>: format(DLS[DL_MANUALVARCHANGE][d_s_button1], 32, macrotext);
				case _H<manualchangemessage>: format(DLS[DL_MANUALVARCHANGE1][d_s_button1], 32, macrotext);
			}
		}
		else if(strcmp(macro, "button2", true) == 0)
		{
			switch(YHash(dialogstr))
			{
				case _H<dialogsettings>: format(DLS[DL_SETTINGS][d_s_button2], 32, macrotext);
				case _H<spritechange>: format(DLS[DL_SPRITECHANGE][d_s_button2], 32, macrotext);
				case _H<overridecolorchange>: format(DLS[DL_OVERRIDECOLORCHANGE][d_s_button2], 32, macrotext);
				case _H<buttonscolorchange>: format(DLS[DL_BUTTONSCOLORCHANGE][d_s_button2], 32, macrotext);
				case _H<settingsreset>: format(DLS[DL_SETTINGSRESET][d_s_button2], 32, macrotext);
				case _H<newproject>: format(DLS[DL_NEWPROJECT][d_s_button2], 32, macrotext);
				case _H<textdrawslist>: format(DLS[DL_TDLIST][d_s_button2], 32, macrotext);
				case _H<exportproject>: format(DLS[DL_EXPORTPROJECT][d_s_button2], 32, macrotext);
				case _H<newtextdraw>: format(DLS[DL_NEWTEXTDRAW][d_s_button2], 32, macrotext);
				case _H<projectslist>: format(DLS[DL_PROJECTSLIST][d_s_button2], 32, macrotext);
				case _H<exitconfirmation>: format(DLS[DL_EXITCONFIRMATION][d_s_button2], 32, macrotext);
				case _H<tdoptions>: format(DLS[DL_TDOPTIONS][d_s_button2], 32, macrotext);
				case _H<projectsoptions>: format(DLS[DL_PROJECTSOPTIONS][d_s_button2], 32, macrotext);
				case _H<previewmodelid>: format(DLS[DL_PREVIEWMODELID][d_s_button2], 32, macrotext);
				case _H<variablechange>: format(DLS[DL_VARIABLECHANGE][d_s_button2], 32, macrotext);
				case _H<colorchange>: format(DLS[DL_COLORCHANGE][d_s_button2], 32, macrotext);
				case _H<deletedconfirm>: format(DLS[DL_DELETECONFIRM][d_s_button2], 32, macrotext);
				case _H<usetemplate>: format(DLS[DL_USETEMPLATE][d_s_button2], 32, macrotext);
				case _H<premadecolors>: format(DLS[DL_PREMADECOLORS][d_s_button2], 32, macrotext);
				case _H<changeprojectname>: format(DLS[DL_PROJECTNAMECHANGE][d_s_button2], 32, macrotext);
				case _H<deleteprojectconfirm>: format(DLS[DL_DELETEPROJECTCONFIRM][d_s_button2], 32, macrotext);
				case _H<previewmodelchangelist>: format(DLS[DL_PREVIEWMODELCHANGELIST][d_s_button2], 32, macrotext);
				case _H<textchange>: format(DLS[DL_TEXTCHANGE][d_s_button2], 32, macrotext);
				case _H<spritechangelist>: format(DLS[DL_SPRITECHANGELIST][d_s_button2], 32, macrotext);
				case _H<boxsizechangelist>: format(DLS[DL_BOXSIZECHANGELIST][d_s_button2], 32, macrotext);
				case _H<colorchangelist1>: format(DLS[DL_COLORCHANGELIST1][d_s_button2], 32, macrotext);
				case _H<colorchangelist2>: format(DLS[DL_COLORCHANGELIST2][d_s_button2], 32, macrotext);
				case _H<oldversionsettingsreset>: format(DLS[DL_OLDVERSIONSETTINGSRESET][d_s_button2], 32, macrotext);
				case _H<exportwitharray>: format(DLS[DL_EXPORTWITHARRAY][d_s_button2], 32, macrotext);
				case _H<manualvarchange>: format(DLS[DL_MANUALVARCHANGE][d_s_button2], 32, macrotext);
				case _H<manualchangemessage>: format(DLS[DL_MANUALVARCHANGE1][d_s_button2], 32, macrotext);
			}
		}
		else
		{
			for(new i; i < MAX_DIALOG_INFO; i++)
			{
				format(EditorString, sizeof EditorString, "info%i", i);
				if(strcmp(macro, EditorString, true) == 0)
				{
					switch(YHash(dialogstr))
					{	
						case _H<manualchangemessage>:
						{
							strpack(DLI[DL_MANUALVARCHANGE1][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_MANUALVARCHANGE1][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<manualvarchange>:
						{
							strpack(DLI[DL_MANUALVARCHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_MANUALVARCHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<exportwitharray>:
						{
							strpack(DLI[DL_EXPORTWITHARRAY][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_EXPORTWITHARRAY][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<oldversionsettingsreset>:
						{
							strpack(DLI[DL_OLDVERSIONSETTINGSRESET][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_OLDVERSIONSETTINGSRESET][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<deleteprojectconfirm>:
						{
							strpack(DLI[DL_DELETEPROJECTCONFIRM][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_DELETEPROJECTCONFIRM][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<colorchangelist2>:
						{
							strpack(DLI[DL_COLORCHANGELIST2][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_COLORCHANGELIST2][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<colorchangelist1>:
						{
							strpack(DLI[DL_COLORCHANGELIST1][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_COLORCHANGELIST1][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<boxsizechangelist>:
						{
							strpack(DLI[DL_BOXSIZECHANGELIST][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_BOXSIZECHANGELIST][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<spritechangelist>:
						{
							strpack(DLI[DL_SPRITECHANGELIST][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_SPRITECHANGELIST][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<textchange>:
						{
							strpack(DLI[DL_TEXTCHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_TEXTCHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<previewmodelchangelist>:
						{
							strpack(DLI[DL_PREVIEWMODELCHANGELIST][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_PREVIEWMODELCHANGELIST][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<changeprojectname>:
						{
							strpack(DLI[DL_PROJECTNAMECHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_PROJECTNAMECHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<variablechange>:
						{
							strpack(DLI[DL_VARIABLECHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_VARIABLECHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<dialogsettings>:
						{
							strpack(DLI[DL_SETTINGS][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_SETTINGS][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<spritechange>:
						{
							strpack(DLI[DL_SPRITECHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_SPRITECHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<settingsreset>:
						{
							strpack(DLI[DL_SETTINGSRESET][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_SETTINGSRESET][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<newproject>:
						{
							strpack(DLI[DL_NEWPROJECT][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_NEWPROJECT][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<textdrawslist>:
						{
							strpack(DLI[DL_TDLIST][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_TDLIST][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<exportproject>:
						{
							strpack(DLI[DL_EXPORTPROJECT][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_EXPORTPROJECT][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<newtextdraw>:
						{
							strpack(DLI[DL_NEWTEXTDRAW][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_NEWTEXTDRAW][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<projectslist>:
						{
							strpack(DLI[DL_PROJECTSLIST][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_PROJECTSLIST][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<exitconfirmation>:
						{
							strpack(DLI[DL_EXITCONFIRMATION][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_EXITCONFIRMATION][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<tdoptions>:
						{
							strpack(DLI[DL_TDOPTIONS][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_TDOPTIONS][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<projectsoptions>:
						{
							strpack(DLI[DL_PROJECTSOPTIONS][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_PROJECTSOPTIONS][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<previewmodelid>:
						{
							strpack(DLI[DL_PREVIEWMODELID][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_PREVIEWMODELID][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<colorchange>:
						{
							strpack(DLI[DL_COLORCHANGE][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_COLORCHANGE][j], DEFAULT_LANG_STRING_SIZE, "");
						}
						case _H<deletedconfirm>:
						{
							strpack(DLI[DL_DELETECONFIRM][i], macrotext);
							for(new j = i + 1; j < MAX_DIALOG_INFO; j++)
								format(DLI[DL_DELETECONFIRM][j], DEFAULT_LANG_STRING_SIZE, "");
						}
					}
					break;
				}
			}
		}
		
	}
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

stock HexToInt(string[])
{
	if (string[0]==0) return 0;
    new i;
    new cur=1;
    new res=0;
    for (i=strlen(string);i>0;i--) {
        if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
        cur=cur*16;
    }
    return res;
}

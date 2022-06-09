
//CHANGING TYPES
enum
{
	CH_NONE,
	CH_EDITOR_POS,
	CH_POSITION,
	CH_MODEL_ROTATION,
	CH_MODEL_ZOOM,
	CH_MODEL_COLOR,
	CH_SIZE,
	CH_ALPHA,
	CH_SPRITE,
	CH_LAYER
};


// File Extensions
enum
{
	FILE_EXTENSION_NTD, // Nickk's Text Draw Editor
	FILE_EXTENSION_NTD_LEGACY, // Nickk's Text Draw Editor
	FILE_EXTENSION_ZTD, // Zamaroht's Text Draw Editor
	FILE_EXTENSION_ITD, // iPLEOMAX's Text Draw Editor
	FILE_EXTENSION_RAW // Raw
};

enum E_EXTENSIONS
{
	fe_extension[16],
	fe_extensionName[24],
	fe_extensionId
};

new Extensions[][E_EXTENSIONS] = 
{
	{ "ntd", "NTD", FILE_EXTENSION_NTD },
	{ "ntdp", "NTD Legacy", FILE_EXTENSION_NTD_LEGACY },
	{ "tde", "ZTD (Zamaroth's)", FILE_EXTENSION_ZTD },
	{ "itd", "ITD (iPLEOMAX's)", FILE_EXTENSION_ITD },
	{ "pwn", "Raw Textdraws", FILE_EXTENSION_RAW }
};

// Colors
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

// Sprites
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

//Sprite Data
enum E_SPRITE
{
	Sprite_Lib[50],
	Sprite_Name[50]
}
new Sprite_Library[MAX_SPRITES][E_SPRITE]; //Sprites Data


// Templates Data
enum E_TEMPLATE
{
	Template_Name[64],
	Template_Data[258]
};
new Template[MAX_TEMPLATES][E_TEMPLATE];

// Language
enum E_LANGUAGE
{
	l_name[32],
	l_author[128],
	l_version[10],
	Node:l_messagesNode,
	Node:l_gametextsNode,
	Node:l_dialogsNode
}
new Language[MAX_LANGUAGES][E_LANGUAGE]; //Languages List

// Groups
enum E_GROUPS
{
	g_name[32]
}
new Group[MAX_GROUPS][E_GROUPS];

//TextDraw Data
enum E_TD
{
	bool:TD_Created,
	bool:TD_UseBox,
	bool:TD_Selectable,
	bool:TD_Proportional,
	bool:TD_IsGlobal,
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
	Float:TD_BarMaxPercentage,
	Text:TD_SelfID,
	PlayerBar:TD_BarID,
	Text:TD_PickerID,
	TD_Text[328],
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
	TD_HighlightTimer,
	TD_BarDirectory
}
new TextDraw[MAX_TEXTDRAWS][E_TD]; //Textdraws Data

//Player Data
enum E_USER
{
	bool:User_InEditor,
	bool:User_ProjectOpened,
	bool:User_Accelerate,
	bool:User_BlockVarsTime,
	bool:User_ChangingColorBar,
	User_ChangingState,
	User_ManualChangeType,
	User_ExportType,
	User_ProjectIndex,
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
new User[E_USER]; //User Data

//Project data
enum E_PROJECT
{
	Pro_fileName[128],
	Pro_fileExtensionId
}
new Projects[MAX_PROJECTS][E_PROJECT]; //Projects Data

enum
{
  LANG_TYPE_MESSAGES,
  LANG_TYPE_GAMETEXTS,
  LANG_TYPE_DIALOGS
}

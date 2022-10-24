/*
 __     __   _____   _____ 
 \ \   / /  / ____| |_   _|
  \ \_/ /  | (___     | |  
   \   /    \___ \    | |  
    | |     ____) |  _| |_ 
    |_|    |_____/  |_____|
    
*/

#define YSI_NO_OPTIMISATION_MESSAGE
#define YSI_NO_VERSION_CHECK
#define YSI_NO_CACHE_MESSAGE
#define YSI_NO_MODE_CACHE

/*
   _____          _     _     _                       
  / ____|        | |   | |   (_)                      
 | (___     ___  | |_  | |_   _   _ __     __ _   ___ 
  \___ \   / _ \ | __| | __| | | | '_ \   / _` | / __|
  ____) | |  __/ | |_  | |_  | | | | | | | (_| | \__ \ 
 |_____/   \___|  \__|  \__| |_| |_| |_|  \__, | |___/
                                           __/ |      
                                          |___/       
*/
#define SCRIPT_VERSION 			                    "7.0"

#define MAX_TEMPLATES				                    50						            //Max templates that can be loaded
#define MAX_PROJECTS 			  	                  (1000)					            //Max projects that can be created and loaded
#define MAX_TEXTDRAWS			                      (512 - 1)	                //Max TextDraws that can be created and loaded
#define MAX_LANGUAGES				                    30						            //Max languages that can be loaded
#define MAX_SPRITES 				                    100						            //Max sprites that can be loaded into library.
#define MAX_GROUPS                              100                       //Max groups that can be loaded

#define CHANGING_VAR_TIME 				              15						            //The Update time for the editor
#define MAXFORMATEDTD 					                32						            //Clamps the TextDraw name in the Dialogs
#define CURSOR_COLOR 					                  1687547391				          //Default Cursor Color
#define BUTTON_TD_COLOR 				                -1						            //Default Buttons Color
#define DIALOG_DIALOG_ADDER				              1000 					            //If there are coliding Dialog ID's, change this to fix it!
#define TDPICKER_COLOR_ACTIVE 			            0xFFFF00FF				      //Color of the TD Picker when active
#define TDPICKER_COLOR 					                0xFFFFFFCC			       	//Color of the TD Picker when inactive
#define CONFIRM_SOUNDID					                1083					  	        //Confirmation Sound
#define DEFAULT_DIALOG_ITEMS_PER_PAGE	          NDP_AUTO
#define MAX_DIALOG_ITEMS 				                (MAX_TEXTDRAWS + 1)


/*
   _____           _                      
  / ____|         | |                     
 | |        ___   | |   ___    _ __   ___ 
 | |       / _ \  | |  / _ \  | '__| / __|
 | |____  | (_) | | | | (_) | | |    \__ \ 
  \_____|  \___/  |_|  \___/  |_|    |___/
                                                                                  
*/
#define HEX_PALETTE_1 					"{134F5C}" //#134F5C
#define HEX_PALETTE_2 					"{274E13}" //#274E13
#define HEX_PALETTE_3 					"{F44336}" //#F44336
#define HEX_PALETTE_4 					"{76A5AF}" //#76A5AF
#define HEX_PALETTE_5 					"{737373}" //#737373

/*
  ______   _   _            _____            _     _           
 |  ____| (_) | |          |  __ \          | |   | |          
 | |__     _  | |   ___    | |__) |   __ _  | |_  | |__    ___ 
 |  __|   | | | |  / _ \   |  ___/   / _` | | __| | '_ \  / __|
 | |      | | | | |  __/   | |      | (_| | | |_  | | | | \__ \ 
 |_|      |_| |_|  \___|   |_|       \__,_|  \__| |_| |_| |___/
                                                                                                                           
*/

#define NTD_DIRECTORYPATH				       "ntd"					//Directory
#define EXPORTS_DIRECTORYPATH			     "ntd/exports"			//Directory
#define PROJECTS_DIRECTORYPATH         "ntd/projects"			//Directory
#define LANGUAGES_DIRECTORYPATH        "ntd/languages"			//Directory
#define TEMPLATESLIST_FILEPATH			   "ntd/templates.xml"		//File
#define SETTINGS_FILEPATH 				     "ntd/editor.json"		//File
#define PROJECTS_ORIGINAL_DIRPATH      PROJECTS_DIRECTORYPATH"/original" //Directory

/*
  _____                                                              _   _                            
 |  __ \                                                            | \ | |                           
 | |__) |   ___   ___    ___    _   _   _ __    ___    ___   ___    |  \| |   __ _   _ __ ___     ___ 
 |  _  /   / _ \ / __|  / _ \  | | | | | '__|  / __|  / _ \ / __|   | . ` |  / _` | | '_ ` _ \   / _ \ 
 | | \ \  |  __/ \__ \ | (_) | | |_| | | |    | (__  |  __/ \__ \   | |\  | | (_| | | | | | | | |  __/
 |_|  \_\  \___| |___/  \___/   \__,_| |_|     \___|  \___| |___/   |_| \_|  \__,_| |_| |_| |_|  \___|
                                                                                                                                                                                                    
*/
#define WELCOME_SCREEN 					      "NTD_RESOURCES:Welcome_Screen"
#define BACKGROUND_BAR					      "NTD_RESOURCES:BG_Bar"

#define BUTTON_TDSETTINGS					    "NTD_RESOURCES:Button_TDSettings"
#define BUTTON_TEXT 					        "NTD_RESOURCES:Button_Text"
#define BUTTON_SHADOW 					      "NTD_RESOURCES:Button_Shadow"
#define BUTTON_SIZE 				        	"NTD_RESOURCES:Button_Size"
#define BUTTON_ALIGNMENTCENTER 				"NTD_RESOURCES:Button_AlignmentCenter"
#define BUTTON_ALIGNMENTDOWN 					"NTD_RESOURCES:Button_AlignmentDown"
#define BUTTON_ALIGNMENTLEFT 				  "NTD_RESOURCES:Button_AlignmentLeft"
#define BUTTON_ALIGNMENTRIGHT 				"NTD_RESOURCES:Button_AlignmentRight"
#define BUTTON_ALIGNMENTTOP 					"NTD_RESOURCES:Button_AlignmentTop"
#define BUTTON_BOXOFF 					      "NTD_RESOURCES:Button_BoxOff"
#define BUTTON_BOXON 					        "NTD_RESOURCES:Button_BoxOn"
#define BUTTON_SAVE 					        "NTD_RESOURCES:Button_Save"
#define BUTTON_COLOR 					        "NTD_RESOURCES:Button_Color"
#define BUTTON_EXIT 			        	  "NTD_RESOURCES:Button_Exit"
#define BUTTON_EXPORT 					      "NTD_RESOURCES:Button_Export"
#define BUTTON_FONT 					        "NTD_RESOURCES:Button_Font"
#define BUTTON_GROUPS 					      "NTD_RESOURCES:Button_Groups"
#define BUTTON_MANAGE 					      "NTD_RESOURCES:Button_Manage"
#define BUTTON_NOTSELECTABLE 					"NTD_RESOURCES:Button_NotSelectable"
#define BUTTON_OPEN					          "NTD_RESOURCES:Button_Open"
#define BUTTON_OUTLINE 				        "NTD_RESOURCES:Button_Outline"
#define BUTTON_PERPLAYERTD 			      "NTD_RESOURCES:Button_PerPlayerTD"
#define BUTTON_POSITION 				      "NTD_RESOURCES:Button_Position"
#define BUTTON_PROPORTIONALITY 			  "NTD_RESOURCES:Button_Proportionality"
#define BUTTON_PUBLICTD 				      "NTD_RESOURCES:Button_PublicTD"
#define BUTTON_SELECTABLE 				    "NTD_RESOURCES:Button_Selectable"
#define BUTTON_SETTINGS 				      "NTD_RESOURCES:Button_Settings"

/*
  _____           _                                   _       
 |_   _|         | |                                 | |      
   | |    _ __   | |_    ___   _ __   _ __     __ _  | |  ___ 
   | |   | '_ \  | __|  / _ \ | '__| | '_ \   / _` | | | / __|
  _| |_  | | | | | |_  |  __/ | |    | | | | | (_| | | | \__ \ 
 |_____| |_| |_|  \__|  \___| |_|    |_| |_|  \__,_| |_| |___/

*/
#define MAX_NTD_LANGUAGE_DIALOGS		  40						//Do NOT change!
#define MAX_NTD_DIALOG_INFO				    10						//Do NOT change!
#define DEFAULT_LANG_STRING_SIZE		  328						//Do NOT change!
#define BUTTON_TD_SIZE					      35.5					//Do NOT change!
#define BUTTON_TD_SPACER				      35.5					//Do NOT change!
#define BUTTON_MINHEIGHT				      15						//Do NOT change!
#define BUTTON_MAXHEIGHT				      412						//Do NOT change!
#define BLOCK_VARS_TIME 				      100						//Do NOT change!
#define TEXT_DRAW_FONT_PROGRESS_BAR	  6 						//Do NOT change!

/*
   _____                  _   _                
  / ____|                (_) | |               
 | (___    _ __    _ __   _  | |_    ___   ___ 
  \___ \  | '_ \  | '__| | | | __|  / _ \ / __|
  ____) | | |_) | | |    | | | |_  |  __/ \__ \ 
 |_____/  | .__/  |_|    |_|  \__|  \___| |___/
          | |                                  
          |_|                                  
*/
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

/*
   ____    _     _                         
  / __ \  | |   | |                        
 | |  | | | |_  | |__     ___   _ __   ___ 
 | |  | | | __| | '_ \   / _ \ | '__| / __|
 | |__| | | |_  | | | | |  __/ | |    \__ \ 
  \____/   \__| |_| |_|  \___| |_|    |___/    

*/

#define CAPTION_TEXT 					HEX_PALETTE_1"NTD "SCRIPT_VERSION" {FFFFFF} "
#define LANGUAGES_CHECKSUM    "5611655cf77fe8960b2e5589920c36c2d628f4cc"


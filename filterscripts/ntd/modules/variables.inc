
/*
  _____   _                           _                        
 |_   _| | |                         | |                       
   | |   | |_    ___   _ __    __ _  | |_    ___    _ __   ___ 
   | |   | __|  / _ \ | '__|  / _` | | __|  / _ \  | '__| / __|
  _| |_  | |_  |  __/ | |    | (_| | | |_  | (_) | | |    \__ \ 
 |_____|  \__|  \___| |_|     \__,_|  \__|  \___/  |_|    |___/
                                                               
                                                               
*/
new Iterator:I_TEMPLATES<MAX_TEMPLATES>;
new Iterator:I_LANGUAGES<MAX_LANGUAGES>;
new Iterator:I_PROJECTS<MAX_PROJECTS>;
new Iterator:I_TEXTDRAWS<MAX_TEXTDRAWS>;
new Iterator:I_GROUPS<MAX_GROUPS>;

/*
  _______                 _     _____                                  
 |__   __|               | |   |  __ \                                 
    | |      ___  __  __ | |_  | |  | |  _ __    __ _  __      __  ___ 
    | |     / _ \ \ \/ / | __| | |  | | | '__|  / _` | \ \ /\ / / / __|
    | |    |  __/  >  <  | |_  | |__| | | |    | (_| |  \ V  V /  \__ \ 
    |_|     \___| /_/\_\  \__| |_____/  |_|     \__,_|   \_/\_/   |___/
                                                                       
                                                                       
*/
new Text:E_Box;
new Text:B_Groups;
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
new Text:B_TDSettings;
new Text:B_Exit;
new Text:B_Settings;
new Text:WelcomeScreen;

/*
   ____    _     _                         
  / __ \  | |   | |                        
 | |  | | | |_  | |__     ___   _ __   ___ 
 | |  | | | __| | '_ \   / _ \ | '__| / __|
 | |__| | | |_  | | | | |  __/ | |    \__ \ 
  \____/   \__| |_| |_|  \___| |_|    |___/
                                           
                                           
*/
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
new EditorLanguage = -1;
new EditorVersion[10];
new EditorLString[1000];
new EditorString[500];
new EditorMaxDialogItems;
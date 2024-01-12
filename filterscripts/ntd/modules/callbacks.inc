/*
  _   _           _     _                     _____           _   _   _                      _          
 | \ | |         | |   (_)                   / ____|         | | | | | |                    | |         
 |  \| |   __ _  | |_   _  __   __   ___    | |        __ _  | | | | | |__     __ _    ___  | | __  ___ 
 | . ` |  / _` | | __| | | \ \ / /  / _ \   | |       / _` | | | | | | '_ \   / _` |  / __| | |/ / / __|
 | |\  | | (_| | | |_  | |  \ V /  |  __/   | |____  | (_| | | | | | | |_) | | (_| | | (__  |   <  \__ \ 
 |_| \_|  \__,_|  \__| |_|   \_/    \___|    \_____|  \__,_| |_| |_| |_.__/   \__,_|  \___| |_|\_\ |___/
                                                                                                                                                                                                             
*/
public OnFilterScriptInit()
{
	Iter_Init(I_GROUP_TDS);
	ScriptScriptActive = false;
	if(Exists( MakePath(NTD_DIRECTORYPATH, true) ) && 
		Exists( MakePath(EXPORTS_DIRECTORYPATH, true) ) && 
		Exists( MakePath(PROJECTS_DIRECTORYPATH, true) ) && 
		Exists( MakePath(LANGUAGES_DIRECTORYPATH, true) ))
	{
		ScriptScriptActive = true;
		printf("[NTD] TextDraw editor by Nickk888 v%s has been initialized!\n", SCRIPT_VERSION);
	}
	else
	{
		ScriptScriptActive = false;
		printf("\n[NTD ERROR] Could not find directory or directories!");
		printf("[NTD ERROR] Please create 'ntd' directory inside 'scriptfiles'!");
		printf("[NTD ERROR] Within 'ntd' you should create the 'exports', 'projects' and 'languages' directory!");
		printf("[NTD ERROR] The script will be unloaded or blocked!\n");
		SendRconCommand("unloadfs ntd");
		return 1;
	}
	if(!Exists( MakePath(SETTINGS_FILEPATH, true) ))
	{
		ResetConfiguration(INVALID_PLAYER_ID);
		SaveConfigurations();
	}
	else LoadConfigurations();
	LoadLanguages();
	return 1;
}

public OnFilterScriptExit()
{
	if(ScriptScriptActive && User[User_InEditor])
	{
		CallNTDCommand(User[User_PlayerIDInEditor]);
	}
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(!strcmp("/ntd", cmdtext, true))
    {
        return CallNTDCommand(playerid);
    }
    return 0;
}

public OnPlayerConnect(playerid)
{
	if(ScriptScriptActive && User[User_InEditor])
	{
		if(EditorTextDrawShowForAll)
		{
			foreach(new i : I_TEXTDRAWS)
			{
				TextDrawShowForPlayer(playerid, TextDraw[i][TD_SelfID]);
			}
		}
	}
	return 1;
}

public OnPlayerDeath(playerid, killerid)
{
	if(ScriptScriptActive && User[User_InEditor])
		if(User[User_PlayerIDInEditor] == playerid)
			CallNTDCommand(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(ScriptScriptActive && User[User_InEditor])
		if(User[User_PlayerIDInEditor] == playerid)
			CallNTDCommand(playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{		
	if(ScriptScriptActive && User[User_InEditor])
	{
		if(newkeys & EditorAcceptKey)
		{
			if(playerid == User[User_PlayerIDInEditor])
			{
				if(User[User_ChangingState] != CH_NONE)
				{
					User[User_ChangingState] = CH_NONE;
					ShowEditorEx(playerid);
					EnableVarChangeTimer(false);
					PlayerSelectTD(playerid, true);
				}
			}
		}
		if(newkeys & EditorFasterKey)
		{
			if(User[User_ChangingState] != CH_NONE)
			{
				if(playerid == User[User_PlayerIDInEditor])
				{
					User[User_Accelerate] = true;
				}
			}
		}
		if(oldkeys & EditorFasterKey)
			User[User_Accelerate] = false;
		if(newkeys & KEY_WALK)
		{
			switch(User[User_ChangingState])
			{
				case CH_POSITION, CH_SIZE, CH_MODEL_ROTATION, CH_MODEL_ZOOM, CH_MODEL_COLOR:
				{
					if(playerid == User[User_PlayerIDInEditor])
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

	return 0;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(ScriptScriptActive && User[User_InEditor])
	{
		new tdid = User[User_EditingTDID];
		if(User[User_ProjectOpened] && EditorQuickSelect)
		{
			foreach(new i : I_TEXTDRAWS)
			{
				if(TextDraw[i][TD_Hidden])
					continue;
					
				if(clickedid == TextDraw[i][TD_PickerID])
				{
					if(SelectTD(playerid, i) == 0)
					{
						ShowTDOptions(playerid, i);
					}
					return 1;
				}
				 
			}
		}
		if(clickedid == B_Exit)
		{
			Dialog_Show(playerid, "D_ExitEditor", DIALOG_STYLE_MSGBOX, 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "caption"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "infos"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "button1"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "button2"));
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Settings)
		{
			ShowEditorSettings(playerid);
			return 1;
		}
		else if(clickedid == B_TDSettings)
		{
			if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			{
				Dialog_Show(playerid, "D_PreviewModel1", DIALOG_STYLE_LIST,
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "infos"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "button2"));
				PlayerSelectTD(playerid, false);
			}
			else if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				Dialog_Show(playerid, "D_BarMaxPercentage", DIALOG_STYLE_INPUT, 
				GetLanguageMessage("barmaxpercentagechange", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("barmaxpercentagechange", LANG_TYPE_DIALOGS, "infos", "f", TextDraw[tdid][TD_BarMaxPercentage]), 
				GetLanguageMessage("barmaxpercentagechange", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("barmaxpercentagechange", LANG_TYPE_DIALOGS, "button2"));
				PlayerSelectTD(playerid, false);
			}
			return 1;
		}
		else if(clickedid == B_Proportionality)
		{
			TextDraw[tdid][TD_Proportional] = !TextDraw[tdid][TD_Proportional];
			GameTextForPlayer(playerid, GetLanguageMessage( (TextDraw[tdid][TD_Proportional] ? "tdproportionality_true" : "tdproportionality_false") , LANG_TYPE_GAMETEXTS), 1500, 6);
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Alignment)
		{
			if(TextDraw[tdid][TD_Font] != TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				if(TextDraw[tdid][TD_Alignment] == 3)
					TextDraw[tdid][TD_Alignment] = 0;
				
				TextDraw[tdid][TD_Alignment]++;
				
				switch(TextDraw[tdid][TD_Alignment])
				{
					case 1: GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_left", LANG_TYPE_GAMETEXTS), 1500, 6);
					case 2: GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_center", LANG_TYPE_GAMETEXTS), 1500, 6);
					case 3: GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_right", LANG_TYPE_GAMETEXTS), 1500, 6);
				}
			}
			else if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				switch(TextDraw[tdid][TD_BarDirectory])
				{
					case BAR_DIRECTION_DOWN:
					{
						TextDraw[tdid][TD_BarDirectory] = BAR_DIRECTION_RIGHT;
						GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_right", LANG_TYPE_GAMETEXTS), 1500, 6);
					}
					case BAR_DIRECTION_RIGHT:
					{
						TextDraw[tdid][TD_BarDirectory] = BAR_DIRECTION_LEFT;
						GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_left", LANG_TYPE_GAMETEXTS), 1500, 6);
					}
					case BAR_DIRECTION_LEFT:
					{
						TextDraw[tdid][TD_BarDirectory] = BAR_DIRECTION_UP;
						GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_up", LANG_TYPE_GAMETEXTS), 1500, 6);
					}
					case BAR_DIRECTION_UP:
					{
						TextDraw[tdid][TD_BarDirectory] = BAR_DIRECTION_DOWN;
						GameTextForPlayer(playerid, GetLanguageMessage("tdalignment_down", LANG_TYPE_GAMETEXTS), 1500, 6);
					}
				}
			}
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_SwitchPublic)
		{
			TextDraw[tdid][TD_IsGlobal] = !TextDraw[tdid][TD_IsGlobal];
			GameTextForPlayer(playerid, GetLanguageMessage( (TextDraw[tdid][TD_IsGlobal] ? "tdpublic" : "tdperplayer") , LANG_TYPE_GAMETEXTS), 1500, 6);
			RedrawTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Selectable)
		{
			TextDraw[tdid][TD_Selectable] = !TextDraw[tdid][TD_Selectable];
			GameTextForPlayer(playerid, GetLanguageMessage( (TextDraw[tdid][TD_Selectable] ? "tdclickable" : "tdnotclickable") , LANG_TYPE_GAMETEXTS), 1500, 6);
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Shadow)
		{
			if(TextDraw[tdid][TD_OutlineSize] > 0)
			{
				TextDraw[tdid][TD_OutlineSize] = 0;
				TextDraw[tdid][TD_ShadowSize] = 0;
			}

			if(TextDraw[tdid][TD_ShadowSize] == 10)
				TextDraw[tdid][TD_ShadowSize] = -1;
			
			TextDraw[tdid][TD_ShadowSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdshadowsize", LANG_TYPE_GAMETEXTS, "", "i", TextDraw[tdid][TD_ShadowSize]));
			GameTextForPlayer(playerid, EditorString, 1500, 6);
			return 1;
		}
		else if(clickedid == B_Outline)
		{
			if(TextDraw[tdid][TD_ShadowSize] > 0)
			{
				TextDraw[tdid][TD_ShadowSize] = 0;
				TextDraw[tdid][TD_OutlineSize] = 0;
			}

			if(TextDraw[tdid][TD_OutlineSize] == 10)
				TextDraw[tdid][TD_OutlineSize] = -1;
			
			TextDraw[tdid][TD_OutlineSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdoutlinesize", LANG_TYPE_GAMETEXTS, "", "i", TextDraw[tdid][TD_OutlineSize]));
			GameTextForPlayer(playerid, EditorString, 1500, 6);
			return 1;
		}
		else if(clickedid == B_UseBox)
		{
			TextDraw[tdid][TD_UseBox] = !TextDraw[tdid][TD_UseBox];
			GameTextForPlayer(playerid, GetLanguageMessage( (TextDraw[tdid][TD_UseBox] ? "tdboxenabled" : "tdboxdisabled") , LANG_TYPE_GAMETEXTS), 1500, 6);
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_Color)
		{
			if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
				ColorDialog(playerid, 2);
			else 
				ColorDialog(playerid, 0);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Tekst)
		{
			if(TextDraw[tdid][TD_Font] != 4 && TextDraw[tdid][TD_Font] != 5) 
			{
				Dialog_Show(playerid, "D_TextChange", DIALOG_STYLE_INPUT, 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "infos"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "button2"));
			}
			else if(TextDraw[tdid][TD_Font] == 4) 
			{
				Dialog_Show(playerid, "D_SpritesChangeList", DIALOG_STYLE_LIST, 
				GetLanguageMessage("spritechangelist", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("spritechangelist", LANG_TYPE_DIALOGS, "infos"), 
				GetLanguageMessage("spritechangelist", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("spritechangelist", LANG_TYPE_DIALOGS, "button2"));
			}
			else if(TextDraw[tdid][TD_Font] == 5) 
			{
				ShowInfo(playerid, GetLanguageMessage("modeltexterror", LANG_TYPE_MESSAGES));
			}
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Size)
		{
			switch(TextDraw[tdid][TD_Font])
			{
				case 4, 5, TEXT_DRAW_FONT_PROGRESS_BAR:
				{
					User[User_ChangingSizeState] = 1;
					User[User_ChangingState] = CH_SIZE;
					EnableVarChangeTimer(true);
					HideEditor(playerid);
				}
				default:
				{
					Dialog_Show(playerid, "D_ChangeSize", DIALOG_STYLE_LIST, 
					GetLanguageMessage("boxsizechangelist", LANG_TYPE_DIALOGS, "caption"), 
					GetLanguageMessage("boxsizechangelist", LANG_TYPE_DIALOGS, "infos"), 
					GetLanguageMessage("boxsizechangelist", LANG_TYPE_DIALOGS, "button1"), 
					GetLanguageMessage("boxsizechangelist", LANG_TYPE_DIALOGS, "button2"));
				}
			}
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Position)
		{
			User[User_ChangingState] = CH_POSITION;
			EnableVarChangeTimer(true);
			PlayerSelectTD(playerid, false);
			HideEditor(playerid);
			return 1;
		}
		else if(clickedid == B_Font)
		{
			if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
				TextDraw[tdid][TD_Font] = 0;
			else
				TextDraw[tdid][TD_Font]++;
			//
			RedrawTD(playerid, tdid);
			switch(TextDraw[tdid][TD_Font])
			{
				case 4: GameTextForPlayer(playerid, GetLanguageMessage("tdfontspriteinfo", LANG_TYPE_GAMETEXTS), 1500, 6);
				case TEXT_DRAW_FONT_MODEL_PREVIEW: GameTextForPlayer(playerid, GetLanguageMessage("tdfontprevmodelinfo", LANG_TYPE_GAMETEXTS), 1500, 6);
				case TEXT_DRAW_FONT_PROGRESS_BAR: GameTextForPlayer(playerid, GetLanguageMessage("tdfontplayerprogressbar", LANG_TYPE_GAMETEXTS), 1500, 6);
				default: 
				{
					format(EditorString, sizeof EditorString, GetLanguageMessage("tdfontinfo", LANG_TYPE_GAMETEXTS, "", "i", TextDraw[tdid][TD_Font]));
					GameTextForPlayer(playerid, EditorString, 1500, 6);
				}
			}
			ShowEditorEx(playerid);
			return 1;
		}
		else if(clickedid == B_CloseProject)
		{
			if(SaveProject(GetProjectName(User[User_ProjectIndex], true)) == 0) 
				ShowInfo(playerid, GetLanguageMessage("infoprojectsaveerror", LANG_TYPE_MESSAGES));
			else 
				ShowInfo(playerid, GetLanguageMessage("infoprojectclosed", LANG_TYPE_MESSAGES));
			
			foreach(new i : I_TEXTDRAWS)
				DestroyTD(i, i);
			User[User_ProjectOpened] = false;
			User[User_EditingTDID] = -1;
			
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
			User[User_ExportType] = 0;
			User[User_ExportArrayMode] = true;
			ShowExportDialog(playerid);
			return 1;
		}
		else if(clickedid == B_Groups)
		{
			OpenGroupsDialog(playerid, 0);
			return 1;
		}
	}
	return 0;
}

/*
   ____    _     _                        _____           _   _   _                      _          
  / __ \  | |   | |                      / ____|         | | | | | |                    | |         
 | |  | | | |_  | |__     ___   _ __    | |        __ _  | | | | | |__     __ _    ___  | | __  ___ 
 | |  | | | __| | '_ \   / _ \ | '__|   | |       / _` | | | | | | '_ \   / _` |  / __| | |/ / / __|
 | |__| | | |_  | | | | |  __/ | |      | |____  | (_| | | | | | | |_) | | (_| | | (__  |   <  \__ \ 
  \____/   \__| |_| |_|  \___| |_|       \_____|  \__,_| |_| |_| |_.__/   \__,_|  \___| |_|\_\ |___/
                                                                                                                                                                                                       
*/

/* Highlight TextDraw */
public HLTD(playerid, td)
{
	new red, green, blue, alpha;
	#pragma unused alpha
	if(TextDraw[td][TD_SelfID] != Text:INVALID_TEXT_DRAW)
	{
		SplitRGBA(TextDraw[td][TD_Color],red,green,blue, alpha); 
		TextDraw[td][TD_Color] = CreateRGBA(red,green,blue,TextDraw[td][TD_ColorAlpha]);
		TextDrawColor(TextDraw[td][TD_SelfID], TextDraw[td][TD_Color]);
		SplitRGBA(TextDraw[td][TD_BGColor],red,green,blue, alpha);
		TextDraw[td][TD_BGColor] = CreateRGBA(red,green,blue,TextDraw[td][TD_BGColorAlpha]);
		TextDrawBackgroundColor(TextDraw[td][TD_SelfID], TextDraw[td][TD_BGColor]);
		SplitRGBA(TextDraw[td][TD_BoxColor],red,green,blue, alpha); 
		TextDraw[td][TD_BoxColor] = CreateRGBA(red,green,blue,TextDraw[td][TD_BoxColorAlpha]);
		TextDrawBoxColor(TextDraw[td][TD_SelfID], TextDraw[td][TD_BoxColor]);
		TextDrawShowForPlayer(playerid, TextDraw[td][TD_SelfID]);
	}
	else if(TextDraw[td][TD_BarID] != INVALID_PLAYER_BAR_ID)
	{
		SetPlayerProgressBarColour(playerid, TextDraw[td][TD_BarID], TextDraw[td][TD_Color]);
		ShowPlayerProgressBar(playerid, TextDraw[td][TD_BarID]);
	}
	return 1;
}

public PlayerSelectTD(playerid, bool:select)
{
	if(select)
	{
		SelectTextDraw(playerid, EditorCursorColor);
		if(User[User_CursorTimer] == -1)
			User[User_CursorTimer] = SetTimerEx("PlayerSelectTD", 1000, true, "ib", playerid, true);
	}
	else
	{
		CancelSelectTextDraw(playerid);
		if(User[User_CursorTimer] != -1)
		{
			KillTimer(User[User_CursorTimer]);
			User[User_CursorTimer] = -1;
		}
	}
	return 1;
}

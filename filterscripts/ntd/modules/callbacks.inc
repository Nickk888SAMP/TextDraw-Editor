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
	ScriptScriptActive = false;
	if(Exists( MakePath(NTD_DIRECTORYPATH, true) ) && 
		Exists( MakePath(EXPORTS_DIRECTORYPATH, true) ) && 
		Exists( MakePath(PROJECTS_DIRECTORYPATH, true) ) && 
		Exists( MakePath(LANGUAGES_DIRECTORYPATH, true) ))
	{
		ScriptScriptActive = true;
		printf("[NTD] TextDraw editor by Nickk888 %s has been successfully initialized!\n", SCRIPT_VERSION);
	}
	else
	{
		ScriptScriptActive = false;
		printf("\n[NTD ERROR] Could not find directory or directories!");
		printf("[NTD ERROR] Please create 'NTD' directory inside 'scriptfiles'!");
		printf("[NTD ERROR] Within 'NTD' you should create the 'exports', 'projects' and 'languages' directory!");
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
	EditorLString = "";
	EditorString = "";
	if(ScriptScriptActive)
	{
		if(dialogid == DIALOG_LANGUAGE)
		{
			if(response)
			{
				new index = Iter_Index(I_LANGUAGES, listitem);
				ChangeEditorLanguage(index);
				SaveConfigurations();
				if(!User[User_InEditor] && EditorLanguage != -1)
					CallNTDCommand(playerid);
			}
		}
	}
	if(dialogid == DIALOG_SETTINGRESET && !User[User_InEditor])
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
		CallNTDCommand(playerid);
	}
	else if(ScriptScriptActive && User[User_InEditor])
	{
		new tdid = User[User_EditingTDID];
		switch(dialogid)
		{
			case DIALOG_MANUALVARCHANGE1:
			{
				if(response)
				{
					if(!isnull(inputtext))
					{
						switch(User[User_ChangingState])
						{
							case CH_POSITION:
							{
								switch(User[User_ManualChangeType])
								{
									case 0: //X
										TextDraw[tdid][TD_PosX] = floatstr(inputtext);
									case 1: //Y
										TextDraw[tdid][TD_PosY] = floatstr(inputtext);
								}
							}
							case CH_SIZE:
							{
								switch(User[User_ManualChangeType])
								{
									case 0: //X
									{
										if(User[User_ChangingSizeState] == 0)
											TextDraw[tdid][TD_LetterSizeX] = floatstr(inputtext);
										else 
											TextDraw[tdid][TD_BoxSizeX] = floatstr(inputtext);
									}
									case 1: //Y
									{
										if(User[User_ChangingSizeState] == 0)
											TextDraw[tdid][TD_LetterSizeY] = floatstr(inputtext);
										else 
											TextDraw[tdid][TD_BoxSizeY] = floatstr(inputtext);
									}
								}
							}
							case CH_MODEL_ROTATION:
							{
								switch(User[User_ManualChangeType])
								{
									case 0: //X
										TextDraw[tdid][TD_PrevRotX] = floatstr(inputtext);
									case 1: //Y
										TextDraw[tdid][TD_PrevRotY] = floatstr(inputtext);
									case 2: //Z
										TextDraw[tdid][TD_PrevRotZ] = floatstr(inputtext);
								}
							}
							case CH_MODEL_ZOOM: //Zoom
							{
								TextDraw[tdid][TD_PrevRotZoom] = floatstr(inputtext);
							}
							case CH_MODEL_COLOR:
							{
								switch(User[User_ManualChangeType])
								{
									case 0: //TD_Color 1
										TextDraw[tdid][TD_PrevModelC1] = strval(inputtext);
									case 1: //TD_Color 2
										TextDraw[tdid][TD_PrevModelC2] = strval(inputtext);
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
					User[User_ManualChangeType] = listitem;
					switch(User[User_ChangingState])
					{
						case CH_POSITION:
						{
							switch(User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PosX]);
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PosY]);
								}
							}
						}
						case CH_SIZE:
						{
							switch(User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, (User[User_ChangingSizeState] == 0) ? (TextDraw[tdid][TD_LetterSizeX]) : (TextDraw[tdid][TD_BoxSizeX]));
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, (User[User_ChangingSizeState] == 0) ? (TextDraw[tdid][TD_LetterSizeY]) : (TextDraw[tdid][TD_BoxSizeY]));
								}
							}
						}
						case CH_MODEL_ROTATION:
						{
							switch(User[User_ManualChangeType])
							{
								case 0: //X
								{
									strreplace(EditorLString, "#1", "X");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevRotX]);
								}
								case 1: //Y
								{
									strreplace(EditorLString, "#1", "Y");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevRotY]);
								}
								case 2: //Z
								{
									strreplace(EditorLString, "#1", "Z");
									strreplace(EditorLString, "#2", "%f");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevRotZ]);
								}
							}
						}
						case CH_MODEL_ZOOM: //Zoom
						{
							strreplace(EditorLString, "#1", GetLanguageMessage("manualchangetypemzoom", LANG_TYPE_MESSAGES));
							strreplace(EditorLString, "#2", "%f");
							format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevRotZoom]);
						}
						case CH_MODEL_COLOR:
						{
							switch(User[User_ManualChangeType])
							{
								case 0: //TD_Color 1
								{
									strreplace(EditorLString, "#1",  GetLanguageMessage("manualchangetypemcolor1", LANG_TYPE_MESSAGES));
									strreplace(EditorLString, "#2", "%i");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevModelC1]);
								}
								case 1: //TD_Color 2
								{
									strreplace(EditorLString, "#1", GetLanguageMessage("manualchangetypemcolor2", LANG_TYPE_MESSAGES));
									strreplace(EditorLString, "#2", "%i");
									format(EditorLString, sizeof EditorLString, EditorLString, TextDraw[tdid][TD_PrevModelC2]);
								}
							}
						}
					}
					ShowPlayerDialog(playerid, DIALOG_MANUALVARCHANGE1, DIALOG_STYLE_INPUT, 
					GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "caption"), 
					EditorLString, 
					GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "button1"), 
					GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "button2"));
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
					User[User_SpriteIndex] = sindex;
					User[User_SpritePicker] = 0;
					User[User_ChangingState] = CH_SPRITE;
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
						ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "caption"), 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "infos"), 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button2"));
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
						//
						ShowPlayerDialog(playerid, DIALOG_SPRITES2, DIALOG_STYLE_LIST, 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "caption"), 
						EditorLString, 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button2"));
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
					ShowInfo(playerid, GetLanguageMessage("infoeditorreset", LANG_TYPE_MESSAGES));
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
							User[User_ChangingState] = CH_EDITOR_POS;
							EnableVarChangeTimer(true);
							PlayerSelectTD(playerid, false);
						}
						case 1: //Zmien kolor najechania
						{
							for(new i = 1; i < sizeof Premade_Colors; i++)
							{
								AddDialogListitem(playerid, "{%06x}############################", (Premade_Colors[i][0] >>> 8));
							}
							ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR, DIALOG_STYLE_LIST, 
							GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "caption"), #, 
							GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "button2"),
							NDP_AUTO);
						}
						case 2: //Zmien kolor przyciskow
						{
							for(new i = 1; i < sizeof Premade_Colors; i++)
							{
								AddDialogListitem(playerid, "{%06x}############################", (Premade_Colors[i][0] >>> 8));
							}
							ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR1, DIALOG_STYLE_LIST, 
							GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "caption"), #, 
							GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "button2"),
							NDP_AUTO);
						}
						case 3: //Odwroc Shift z Spacja
						{
							new keyA = EditorFasterKey;
							new keyB = EditorAcceptKey;
							EditorFasterKey = keyB;
							EditorAcceptKey = keyA;
							OnPlayerClickTextDraw(playerid, B_Settings);
						}
						case 4: //Szybki wybor
						{
							EditorQuickSelect = !EditorQuickSelect;
							QuickSelectionShow(playerid, EditorQuickSelect);
							OnPlayerClickTextDraw(playerid, B_Settings);
						}
						case 5: //Wyswietlanie TextDrawow
						{
							ToggleTextDrawShowForAll(!EditorTextDrawShowForAll);
							OnPlayerClickTextDraw(playerid, B_Settings);
						}
						case 6: //Tryb kompaktowy
						{
							EditorCompactMode = !EditorCompactMode;
							DestroyEditor();
							CreateEditor();
							ShowEditorEx(playerid);
							OnPlayerClickTextDraw(playerid, B_Settings);
						}
						case 7: //Zmien jezyk
							ShowLanguageChangeDialog(playerid, DIALOG_LANGUAGE_SETTINGS);
						case 8: //Ustawienia fabryczne
						{
							ShowPlayerDialog(playerid, DIALOG_SETTINGRESET, DIALOG_STYLE_MSGBOX, 
							GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "infos"), 
							GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "button2"));
						}
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_LANGUAGE_SETTINGS:
			{
				if(response)
				{
					new index = Iter_Index(I_LANGUAGES, listitem);
					ChangeEditorLanguage(index);
					SaveConfigurations();
					ShowInfo(playerid, GetLanguageMessage("infolanguagechanged", LANG_TYPE_MESSAGES));
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_EXIT:
			{
				if(response)
					CallNTDCommand(playerid);
				else
					ShowEditorEx(playerid);
			}
			case DIALOG_MAXBARPERCCHANGE:
			{
				if(response)
				{
					if((IsNumeric(inputtext) || IsFloat(inputtext)) && strval(inputtext) >= 0 && (floatstr(inputtext) > 0.0 && floatstr(inputtext) < cellmax))
					{
						TextDraw[tdid][TD_BarMaxPercentage] = floatstr(inputtext);
						UpdateTD(playerid, tdid);
						PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
					}
				}
				ShowEditorEx(playerid);
			}
			case DIALOG_PREVIEWMODEL1:
			{
				if(response)
				{
					TextDraw[tdid][TD_PrevModelID] = strval(inputtext);
					UpdateTD(playerid, tdid);
					PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_PREVIEWMODEL:
			{
				if(response)
				{
					if(listitem == 0) //Zmien Model
					{
						ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL1, DIALOG_STYLE_INPUT, 
						GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "caption"), 
						GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "infos"), 
						GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "button2"));
					}
					else if(listitem > 0)
					{
						if(listitem == 1) User[User_ChangingState] = CH_MODEL_ROTATION;
						else if(listitem == 2) User[User_ChangingState] = CH_MODEL_ZOOM;
						else if(listitem == 3) User[User_ChangingState] = CH_MODEL_COLOR;
						EnableVarChangeTimer(true);
						PlayerSelectTD(playerid, false);
						HideEditor(playerid);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_EXPORT2:
			{
				if(ExportProject(User[User_ProjectIndex], User[User_ExportType], bool:response))
				{
					format(EditorString, sizeof EditorString, HEX_PALETTE_2"%s/%s.pwn", MakePath(EXPORTS_DIRECTORYPATH, true), GetProjectName(User[User_ProjectIndex]));
					format(EditorLString, sizeof EditorLString, GetLanguageMessage("infoprojectexported", LANG_TYPE_MESSAGES, "", "s", EditorString));
					ShowInfo(playerid, EditorLString);
				}
				else 
					ShowInfo(playerid, GetLanguageMessage("infoprojectexporterror", LANG_TYPE_MESSAGES));
			}
			case DIALOG_EXPORT:
			{
				if(response)
				{
					User[User_ExportType] = listitem;
					ShowPlayerDialog(playerid, DIALOG_EXPORT2, DIALOG_STYLE_MSGBOX, 
					GetLanguageMessage("exportwitharray", LANG_TYPE_DIALOGS, "caption"), 
					GetLanguageMessage("exportwitharray", LANG_TYPE_DIALOGS, "infos"), 
					GetLanguageMessage("exportwitharray", LANG_TYPE_DIALOGS, "button1"), 
					GetLanguageMessage("exportwitharray", LANG_TYPE_DIALOGS, "button2"));
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_SIZE:
			{
				if(response)
				{
					User[User_ChangingSizeState] = listitem;
					User[User_ChangingState] = CH_SIZE;
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
					new red, green, blue, alpha;
					SplitRGBA(Premade_Colors[listitem][0],red,green,blue, alpha); 
					#pragma unused alpha
					switch(User[User_ChangingMColorState])
					{
						case 0: //Tekst TD_Color
						{
							TextDraw[tdid][TD_Color] = CreateRGBA(red,green,blue,TextDraw[tdid][TD_ColorAlpha]);
						}
						case 1: //BG TD_Color
						{
							TextDraw[tdid][TD_BGColor] = CreateRGBA(red,green,blue,TextDraw[tdid][TD_BGColorAlpha]);
						}
						case 2: //Box TD_Color
						{
							TextDraw[tdid][TD_BoxColor] = CreateRGBA(red,green,blue,TextDraw[tdid][TD_BoxColorAlpha]);
						}
					}
					UpdateTD(playerid, tdid);
					ShowEditorEx(playerid);
				}
				else if(!User[User_ChangingColorBar]) ColorDialog(playerid, 1);
				else ColorDialog(playerid, 2);
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
							color[0] = CreateRGBA(color[0], color[1], color[2], color[3]);
						}
						else if(strlen(inputtext) == 8) //HEX
						{
							color[0] = HexToInt(inputtext);
						}
						switch(User[User_ChangingMColorState])
						{
							case 0: //Tekst TD_Color
							{
								TextDraw[tdid][TD_Color] = color[0];
								TextDraw[tdid][TD_ColorAlpha] = CreateAFromRGBA(color[0]);
							}
							case 1: //BG TD_Color
							{
								TextDraw[tdid][TD_BGColor] = color[0];
								TextDraw[tdid][TD_BGColorAlpha] = CreateAFromRGBA(color[0]);
							}
							case 2: //Box TD_Color
							{
								TextDraw[tdid][TD_BoxColor] = color[0];
								TextDraw[tdid][TD_BoxColorAlpha] = CreateAFromRGBA(color[0]);
							}
						}
						UpdateTD(playerid, tdid);
						ShowEditorEx(playerid);
					}
				}
				else if(!User[User_ChangingColorBar]) ColorDialog(playerid, 1);
				else ColorDialog(playerid, 2);
			}
			case DIALOG_COLOR2:
			{
				if(response)
				{
					if(listitem == 0) //Gotowe kolory
					{
						for(new i; i < sizeof Premade_Colors; i++)
						{
							AddDialogListitem(playerid, "{%06x}############################\n", (Premade_Colors[i][0] >>> 8));
						}
						ShowPlayerDialog(playerid, DIALOG_COLOR3, DIALOG_STYLE_LIST, 
						GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "caption"), #, 
						GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "button2"),
						NDP_AUTO);
					}
					else if(listitem == 1) //Kombinator
					{
						new color[4];
						switch(User[User_ChangingMColorState])
						{
							case 0: SplitRGBA(TextDraw[tdid][TD_Color],color[0],color[1],color[2],color[3]);
							case 1: SplitRGBA(TextDraw[tdid][TD_BGColor],color[0],color[1],color[2],color[3]);
							case 2: SplitRGBA(TextDraw[tdid][TD_BoxColor],color[0],color[1],color[2],color[3]);
						}
						ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, 
						GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "caption"), 
						GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "infos", color[0], color[1], color[2], color[3], TextDraw[tdid][TD_Color]), 
						GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "button2"));
					}
					else if(listitem == 2) //Przezroczystosc
					{
						User[User_ChangingState] = CH_ALPHA;
						EnableVarChangeTimer(true);
						PlayerSelectTD(playerid, false);
						HideEditor(playerid);
					}
				}
				else if(!User[User_ChangingColorBar]) ColorDialog(playerid, 0);
				else PlayerSelectTD(playerid, true);
			}
			case DIALOG_COLOR1:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: //Tekst kolor
						{
							User[User_ChangingMColorState] = 0;
							ColorDialog(playerid, 1);
						}
						case 1: //Kolor tla
						{
							User[User_ChangingMColorState] = 1;
							ColorDialog(playerid, 1);
						}
						case 2: //Box TD_Color
						{
							User[User_ChangingMColorState] = 2;
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
						format(TextDraw[tdid][TD_Text], 300, inputtext);
						RedrawTD(playerid, tdid);
						ShowEditorEx(playerid);
						PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
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
									format(TextDraw[User[User_ChoosenTDID]][TD_VarName], 35, inputtext);
									ShowInfo(playerid, GetLanguageMessage("infoparamnamechange", LANG_TYPE_MESSAGES, "", "ss", GetProcessedTDVarName(User[User_ChoosenTDID]), TextDraw[User[User_ChoosenTDID]][TD_Text]));
									RedrawTD(playerid, User[User_ChoosenTDID]);
								}
								else ShowInfo(playerid, GetLanguageMessage("infoparamnamechangetaken", LANG_TYPE_MESSAGES));
							}
							else ShowInfo(playerid, GetLanguageMessage("infoparamnamechangecharserr", LANG_TYPE_MESSAGES));
						}
						else ShowInfo(playerid, GetLanguageMessage("infoparamnamechangeammerr", LANG_TYPE_MESSAGES));
					}
					else
					{
						format(TextDraw[User[User_ChoosenTDID]][TD_VarName], 35, "");
						ShowEditorEx(playerid);
					}
				}
				else ShowEditorEx(playerid), ShowTDOptions(playerid, User[User_ChoosenTDID]);
			}
			case DIALOG_MANAGE2:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: //Modyfikuj
						{
							SelectTD(playerid, User[User_ChoosenTDID]);
							ShowEditorEx(playerid);
						}
						case 1: //Sklonuj
						{
							tdid = CreateNewTD(User[User_ChoosenTDID]);
							if(tdid != -1)
							{
								DrawTD(tdid);
								SelectTD(playerid, tdid);
								//
								format(EditorString, sizeof EditorString, GetLanguageMessage("tdclonedinfo", LANG_TYPE_GAMETEXTS, "", "i", User[User_ChoosenTDID]));
								//
								GameTextForPlayer(playerid, EditorString, 5000, 6);
								PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
								RelayerEditor();
								ShowEditorEx(playerid, true);
							}
							else ShowInfo(playerid, GetLanguageMessage("infomaxtextdrawsreached", LANG_TYPE_MESSAGES));
						}
						case 2: //Zmien warstwe
						{
							User[User_ChangingState] = CH_LAYER;
							EnableVarChangeTimer(true);
							PlayerSelectTD(playerid, false);
							HideEditor(playerid);
						}
						case 3: //Zmien nazwe parametru
						{
							ShowPlayerDialog(playerid, DIALOG_CHANGEPARAMNAME, DIALOG_STYLE_INPUT, 
							GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "infos", "ss", GetProcessedTDVarName(User[User_ChoosenTDID]), TextDraw[User[User_ChoosenTDID]][TD_Text]), 
							GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "button2"));
						}
						case 4: //Usun
						{
							new formatedtd[MAXFORMATEDTD];
							format(formatedtd, MAXFORMATEDTD, TextDraw[User[User_ChoosenTDID]][TD_Text]);
							if(strlen(TextDraw[User[User_ChoosenTDID]][TD_Text]) > MAXFORMATEDTD - 4)
							{
								strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
								strcat(formatedtd, "...");
							}
							ShowPlayerDialog(playerid, DIALOG_DELETETD, DIALOG_STYLE_MSGBOX, 
							GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "infos", "s", formatedtd), 
							GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "button2"));
						}
					}
					
				} 
				else ShowEditorEx(playerid, true), OpenTDDialog(playerid);
			}
			case DIALOG_DELETETD:
			{
				if(response)
				{
					new next;
					DestroyTD(User[User_ChoosenTDID], next);
					Iter_Remove(I_TEXTDRAWS, User[User_ChoosenTDID]);
					if(User[User_EditingTDID] == User[User_ChoosenTDID])
						User[User_EditingTDID] = -1;
					//
					format(EditorString, sizeof EditorString, GetLanguageMessage("tddeletedinfo", LANG_TYPE_GAMETEXTS, "", "i", User[User_ChoosenTDID]));
					GameTextForPlayer(playerid, EditorString, 5000, 6);
					PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid, true);
				}
				else ShowEditorEx(playerid), ShowTDOptions(playerid, User[User_ChoosenTDID]);
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
						format(EditorString, sizeof EditorString, GetLanguageMessage("tdcreatedinfo", LANG_TYPE_GAMETEXTS, "", "i", tdid));
						GameTextForPlayer(playerid, EditorString, 5000, 6);
						PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
						RelayerEditor();
						ShowEditorEx(playerid, true);
						
					}
					else ShowInfo(playerid, GetLanguageMessage("infomaxtextdrawsreached", LANG_TYPE_MESSAGES));
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
							format(EditorString, sizeof EditorString, GetLanguageMessage("tdcreatedinfo", LANG_TYPE_GAMETEXTS, "", "i", tdid));
							PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
							GameTextForPlayer(playerid, EditorString, 5000, 6);
							//
							RelayerEditor();
							ShowEditorEx(playerid, true);
							
						}
						else ShowInfo(playerid, GetLanguageMessage("infomaxtextdrawsreached", LANG_TYPE_MESSAGES));
					}
					else if(listitem == 1) //Uzyj Szablon
					{
						foreach(new i : I_TEMPLATES)
						{
							format(EditorString, sizeof EditorString, "%s\n", Template[i][Template_Name]);
							strcat(EditorLString, EditorString);
						}
						ShowPlayerDialog(playerid, DIALOG_MANAGE4, DIALOG_STYLE_LIST, 
						GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "caption"), 
						EditorLString, 
						GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "button2"));
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
						ShowPlayerDialog(playerid, DIALOG_MANAGE3, DIALOG_STYLE_LIST, 
						GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "caption"), 
						GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "infos"), 
						GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "button1"), 
						GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "button2"));
					}
					else //TDS
					{
						new index = Iter_Index(I_TEXTDRAWS, (listitem - 1));
						ShowTDOptions(playerid, index);
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_RENAMEPROJECT:
			{
				if(response)
				{
					new oldproname[64];
					format(oldproname, 64, GetProjectName(User[User_ProjectIndex]));
					new changepn = RenameProject(User[User_ProjectIndex], inputtext);
					switch(changepn)
					{
						case 1:
						{
							format(EditorLString, sizeof EditorLString, GetLanguageMessage("projectrenamed", LANG_TYPE_MESSAGES, "", "ss", oldproname, inputtext));
							ShowInfo(playerid, EditorLString);
						} 
						case 2: ShowInfo(playerid, GetLanguageMessage("projectnamechangecharerr", LANG_TYPE_MESSAGES));
						case 3: ShowInfo(playerid, GetLanguageMessage("projectnameexists", LANG_TYPE_MESSAGES));
						case -1: ShowInfo(playerid, GetLanguageMessage("projectnamechangeerror", LANG_TYPE_MESSAGES));
					}
				}
				else ShowEditorEx(playerid), OpenProjectDialog(playerid);
			}
			case DIALOG_OPEN2:
			{
				if(listitem == INVALID_LISTITEM) 
					return 0;
				if(response)
				{
					new projectindex = User[User_ProjectIndex];
					switch(listitem)
					{
						case 0: //Wczytaj
						{
							if(Projects[projectindex][Pro_fileExtensionId] == FILE_EXTENSION_NTD)
							{
								if(LoadProject(projectindex))
								{
									ShowInfo(playerid, GetLanguageMessage("infoprojectloaded", LANG_TYPE_MESSAGES, "", "s", GetProjectName(projectindex)));
									ShowWelcomeScreen(false);
									RelayerEditor();
									ShowEditorEx(playerid);
								}
								else ShowInfo(playerid, GetLanguageMessage("projectloaderror", LANG_TYPE_MESSAGES));
							}
							else
							{
								ShowEditorEx(playerid);
							}
						}
						case 1: //Zmien nazwe
						{
							ShowPlayerDialog(playerid, DIALOG_RENAMEPROJECT, DIALOG_STYLE_INPUT, 
							GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "infos", "s", GetProjectName(projectindex)), 
							GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "button2"));
							PlayerSelectTD(playerid, false);
						}
						case 2: //Usun
						{
							ShowPlayerDialog(playerid, DIALOG_DELETEPROJECT, DIALOG_STYLE_MSGBOX, 
							GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "infos"), 
							GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "button2"));
						}
					}
				}
				else ShowEditorEx(playerid), OpenProjectDialog(playerid);
			}
			case DIALOG_OPEN:
			{
				if(response)
				{
					if(listitem == INVALID_LISTITEM) 
						return 0;
					switch(listitem)
					{
						case INVALID_LISTITEM: return 0;
						case 0: 
						{
							ShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT, 
							GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "caption"), 
							GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "infos"), 
							GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "button2"));
							PlayerSelectTD(playerid, false);
						}
						default:
						{
							new index = Iter_Index(I_PROJECTS, (listitem - 1));
							User[User_ProjectIndex] = index;
							ShowPlayerDialog(playerid, DIALOG_OPEN2, DIALOG_STYLE_LIST, 
							GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "caption", "s", Projects[index][Pro_fileName]), 
							GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "infos"), 
							GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "button1"), 
							GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "button2"));
						}
					}
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_DELETEPROJECT:
			{
				if(response)
				{
					if(DeleteProject(User[User_ProjectIndex]))
					{
						format(EditorLString, sizeof EditorLString, GetLanguageMessage("projectdeleted", LANG_TYPE_MESSAGES, "", "s", GetProjectName(User[User_ProjectIndex])));
						ShowInfo(playerid, EditorLString);
					}
					else ShowInfo(playerid, GetLanguageMessage("projectdeleteerror", LANG_TYPE_MESSAGES));
				}
				else ShowEditorEx(playerid), OpenProjectDialog(playerid);
			}
			case DIALOG_NEW:
			{
				if(response)
				{
					if(strlen(inputtext) > 0 && strlen(inputtext) < 40 && IsValidString(inputtext))
					{
						new pid = CreateProject(inputtext);
						if(pid != -1)
						{
							if( LoadProject(pid) )
							{
								format(EditorLString, sizeof EditorLString, GetLanguageMessage("infoprojectcreated", LANG_TYPE_MESSAGES, "", "s", inputtext));
								ShowInfo(playerid, EditorLString);
								ShowWelcomeScreen(false);
								ShowEditorEx(playerid);
							}
							else ShowInfo(playerid, GetLanguageMessage("projectloaderror", LANG_TYPE_MESSAGES));
						}
						else ShowInfo(playerid, GetLanguageMessage("infoprojectexists", LANG_TYPE_MESSAGES));
					}
					else ShowInfo(playerid, GetLanguageMessage("infoprojectinvalidname", LANG_TYPE_MESSAGES));
				}
				else ShowEditorEx(playerid);
			}
		}
	}
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
			ShowPlayerDialog(playerid, DIALOG_EXIT, DIALOG_STYLE_MSGBOX, 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "caption"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "infos"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "button1"), 
			GetLanguageMessage("exitconfirmation", LANG_TYPE_DIALOGS, "button2"));
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Settings)
		{
			new invertedstr[40], quickselectstr[30], compmodestr[30], tdvisistr[60], langstr[30];
			if(EditorAcceptKey == KEY_JUMP && EditorFasterKey == KEY_SPRINT)
				format(invertedstr, sizeof invertedstr, "%s%s", HEX_PALETTE_3, GetLanguageMessage("keysinverted", LANG_TYPE_MESSAGES));
				
			format(quickselectstr, sizeof quickselectstr, "%s%s", (EditorQuickSelect ? HEX_PALETTE_2 : HEX_PALETTE_3), GetLanguageMessage((EditorQuickSelect ? "texton" : "textoff"), LANG_TYPE_MESSAGES));
			format(tdvisistr, sizeof tdvisistr, "%s%s", (EditorTextDrawShowForAll ? HEX_PALETTE_3 : HEX_PALETTE_2), GetLanguageMessage((EditorTextDrawShowForAll ? "tdvforall" : "tdvforme"), LANG_TYPE_MESSAGES));
			format(compmodestr, sizeof compmodestr, "%s%s", (EditorCompactMode ? HEX_PALETTE_2 : HEX_PALETTE_3), GetLanguageMessage((EditorCompactMode ? "texton" : "textoff"), LANG_TYPE_MESSAGES));
			format(langstr, sizeof langstr, "%s%s", HEX_PALETTE_1"%s", (EditorLanguage == -1 ? "" : GetLanguageName(EditorLanguage)));
			
			format(EditorLString, sizeof EditorLString, GetLanguageMessage("dialogsettings", LANG_TYPE_DIALOGS, "infos", "sssss", invertedstr, quickselectstr, tdvisistr, compmodestr, langstr));
			ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, 
				GetLanguageMessage("dialogsettings", LANG_TYPE_DIALOGS, "caption"), 
				EditorLString, 
				GetLanguageMessage("dialogsettings", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("dialogsettings", LANG_TYPE_DIALOGS, "button2"));
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_TDSettings)
		{
			if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			{
				ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL, DIALOG_STYLE_LIST,
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "infos"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("previewmodelchangelist", LANG_TYPE_DIALOGS, "button2"));
				PlayerSelectTD(playerid, false);
			}
			else if(TextDraw[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				ShowPlayerDialog(playerid, DIALOG_MAXBARPERCCHANGE, DIALOG_STYLE_INPUT, 
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
			if(TextDraw[tdid][TD_ShadowSize] == 4)
				TextDraw[tdid][TD_ShadowSize] = -1;
			
			TextDraw[tdid][TD_ShadowSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdshadowsize", LANG_TYPE_GAMETEXTS, "", "i", TextDraw[tdid][TD_ShadowSize]));
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
		else if(clickedid == B_Outline)
		{
			if(TextDraw[tdid][TD_OutlineSize] == 4)
				TextDraw[tdid][TD_OutlineSize] = -1;
			
			TextDraw[tdid][TD_OutlineSize]++;
			UpdateTD(playerid, tdid);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdoutlinesize", LANG_TYPE_GAMETEXTS, "", "i", TextDraw[tdid][TD_OutlineSize]));
			GameTextForPlayer(playerid, EditorString, 1500, 6);
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
				ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "caption"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "infos"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "button1"), 
				GetLanguageMessage("textchange", LANG_TYPE_DIALOGS, "button2"));
			}
			else if(TextDraw[tdid][TD_Font] == 4) 
			{
				ShowPlayerDialog(playerid, DIALOG_SPRITES1, DIALOG_STYLE_LIST, 
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
					ShowPlayerDialog(playerid, DIALOG_SIZE, DIALOG_STYLE_LIST, 
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
			if(SaveProject(User[User_ProjectIndex]) == 0) 
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
			ShowPlayerDialog(playerid, DIALOG_EXPORT, DIALOG_STYLE_LIST, 
			GetLanguageMessage("exportproject", LANG_TYPE_DIALOGS, "caption"), 
			GetLanguageMessage("exportproject", LANG_TYPE_DIALOGS, "infos"), 
			GetLanguageMessage("exportproject", LANG_TYPE_DIALOGS, "button1"), 
			GetLanguageMessage("exportproject", LANG_TYPE_DIALOGS, "button2"));
			PlayerSelectTD(playerid, false);
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

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
	if(Exists(NTD_DIRECTORYPATH) && Exists(EXPORTS_DIRECTORYPATH) && Exists(PROJECTS_DIRECTORYPATH) && Exists(LANGUAGES_PATH))
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
	if(!Exists(SETTINGS_FILEPATH))
	{
		EditorPosX = 0;
		EditorPosY = BUTTON_MAXHEIGHT;
		EditorCursorColor = CURSOR_COLOR;
		EditorButtonsColor = BUTTON_TD_COLOR;
		EditorFasterKey = KEY_JUMP;
		EditorAcceptKey = KEY_SPRINT;
		EditorQuickSelect = true;
		EditorTextDrawShowForAll = false;
		EditorCompactMode = false;
		EditorLanguage = LANG_NONE;
		EditorMaxDialogItems = DEFAULT_DIALOG_ITEMS_PER_PAGE;
		format(EditorVersion, sizeof EditorVersion, SCRIPT_VERSION_CHECK);
		SaveConfigurations();
	}
	else LoadConfigurations();
	return 1;
}

public OnFilterScriptExit()
{
	foreach(new i : Player)
	{
		if(ScriptScriptActive && NTD_User[User_InEditor])
			if(NTD_User[User_PlayerIDInEditor] == i)
			{
				CallNTDCommand(i);
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
				break;
			}
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
			CallNTDCommand(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(ScriptScriptActive && NTD_User[User_InEditor])
		if(NTD_User[User_PlayerIDInEditor] == playerid)
			CallNTDCommand(playerid);
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
				format(EditorString, sizeof EditorString, "%s/%s", "ntd/languages", Language[listitem][l_file]);
				if(LanguageLoad(EditorString, Language[listitem][l_file]))
				{
					EditorLanguage = LANGUAGE_LOADED;
					format(EditorLanguageFile, sizeof EditorLanguageFile, Language[listitem][l_file]);
					SaveConfigurations();
				}
				CallNTDCommand(playerid);
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
		CallNTDCommand(playerid);
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
					CreateDialogOnLanguageData(playerid, DL_MANUALVARCHANGE1);
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
						CreateDialogOnLanguageData(playerid, DL_SPRITECHANGE);
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
								format(EditorString, sizeof EditorString, "{%06x}############################\n", (Premade_Colors[i][0] >>> 8));
								strcat(EditorLString, EditorString);
							}
							CreateDialogCaptionOnLangData(DL_OVERRIDECOLORCHANGE);
							ShowPlayerDialog(playerid, DIALOG_SETTINGSCOLOR, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_OVERRIDECOLORCHANGE][d_s_button1], DLS[DL_OVERRIDECOLORCHANGE][d_s_button2]);
						}
						case 2: //Zmien kolor przyciskow
						{
							for(new i = 1; i < sizeof Premade_Colors; i++)
							{
								format(EditorString, sizeof EditorString, "{%06x}############################\n", (Premade_Colors[i][0] >>> 8));
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
							CreateDialogOnLanguageData(playerid, DL_SETTINGSRESET);
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
						CallNTDCommand(playerid);
						CallNTDCommand(playerid);
						ShowInfo(playerid, Language_Strings[str_infolanguagechanged]);
					}
					else ShowInfo(playerid, Language_Strings[str_languagefilenotfound]);
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
						NTD_TD[tdid][TD_BarMaxPercentage] = floatstr(inputtext);
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
					if(IsNumeric(inputtext) && strval(inputtext) >= 0)
					{
						NTD_TD[tdid][TD_PrevModelID] = strval(inputtext);
						UpdateTD(playerid, tdid);
						PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
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
						CreateDialogOnLanguageData(playerid, DL_PREVIEWMODELID);
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
				if(ExportProject(NTD_User[User_ProjectIndex], NTD_User[User_ExportType], bool:response))
				{
					format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectexported]);
					format(EditorString, sizeof EditorString, " "HEX_PALETTE_3"scriptfiles/"EXPORTS_DIRECTORYPATH"%s.pwn", GetProjectName(NTD_User[User_ProjectIndex]));
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
					CreateDialogOnLanguageData(playerid, DL_EXPORTWITHARRAY);
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
					new red, green, blue, alpha;
					SplitRGBA(Premade_Colors[listitem][0],red,green,blue, alpha); 
					#pragma unused alpha
					switch(NTD_User[User_ChangingMColorState])
					{
						case 0: //Tekst TD_Color
						{
							NTD_TD[tdid][TD_Color] = CreateRGBA(red,green,blue,NTD_TD[tdid][TD_ColorAlpha]);
						}
						case 1: //BG TD_Color
						{
							NTD_TD[tdid][TD_BGColor] = CreateRGBA(red,green,blue,NTD_TD[tdid][TD_BGColorAlpha]);
						}
						case 2: //Box TD_Color
						{
							NTD_TD[tdid][TD_BoxColor] = CreateRGBA(red,green,blue,NTD_TD[tdid][TD_BoxColorAlpha]);
						}
					}
					UpdateTD(playerid, tdid);
					ShowEditorEx(playerid);
				}
				else if(!NTD_User[User_ChangingColorBar]) ColorDialog(playerid, 1);
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
						switch(NTD_User[User_ChangingMColorState])
						{
							case 0: //Tekst TD_Color
							{
								NTD_TD[tdid][TD_Color] = color[0];
								NTD_TD[tdid][TD_ColorAlpha] = CreateAFromRGBA(color[0]);
							}
							case 1: //BG TD_Color
							{
								NTD_TD[tdid][TD_BGColor] = color[0];
								NTD_TD[tdid][TD_BGColorAlpha] = CreateAFromRGBA(color[0]);
							}
							case 2: //Box TD_Color
							{
								NTD_TD[tdid][TD_BoxColor] = color[0];
								NTD_TD[tdid][TD_BoxColorAlpha] = CreateAFromRGBA(color[0]);
							}
						}
						UpdateTD(playerid, tdid);
						ShowEditorEx(playerid);
					}
				}
				else if(!NTD_User[User_ChangingColorBar]) ColorDialog(playerid, 1);
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
							format(EditorString, sizeof EditorString, "{%06x}############################\n", (Premade_Colors[i][0] >>> 8));
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
							case 0: SplitRGBA(NTD_TD[tdid][TD_Color],color[0],color[1],color[2],color[3]);
							case 1: SplitRGBA(NTD_TD[tdid][TD_BGColor],color[0],color[1],color[2],color[3]);
							case 2: SplitRGBA(NTD_TD[tdid][TD_BoxColor],color[0],color[1],color[2],color[3]);
						}
						CreateDialogOnLanguageData(playerid, DL_COLORCHANGE);
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
				else if(!NTD_User[User_ChangingColorBar]) ColorDialog(playerid, 0);
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
				else ShowEditorEx(playerid), ShowTDOptions(playerid, NTD_User[User_ChoosenTDID]);
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
								PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
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
							CreateDialogOnLanguageData(playerid, DL_VARIABLECHANGE);
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
							CreateDialogOnLanguageData(playerid, DL_DELETECONFIRM);
							CreateDialogCaptionOnLangData(DL_DELETECONFIRM);
							strreplace(EditorLString, "#1", formatedtd);
							ShowPlayerDialog(playerid, DIALOG_DELETETD, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_DELETECONFIRM][d_s_button1], DLS[DL_DELETECONFIRM][d_s_button2]);
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
					DestroyTD(NTD_User[User_ChoosenTDID], next);
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
					PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid, true);
				}
				else ShowEditorEx(playerid), ShowTDOptions(playerid, NTD_User[User_ChoosenTDID]);
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
						PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
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
							PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
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
							format(EditorString, sizeof EditorString, "%s\n", Template[i][Template_Name]);
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
						CreateDialogOnLanguageData(playerid, DL_NEWTEXTDRAW);
						CreateDialogCaptionOnLangData(DL_NEWTEXTDRAW);
						ShowPlayerDialog(playerid, DIALOG_MANAGE3, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_NEWTEXTDRAW][d_s_button1], DLS[DL_NEWTEXTDRAW][d_s_button2]);
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
					format(oldproname, 64, GetProjectName(NTD_User[User_ProjectIndex]));
					new changepn = RenameProject(NTD_User[User_ProjectIndex], inputtext);
					switch(changepn)
					{
						case 1:
						{
							format(EditorLString, sizeof EditorLString, Language_Strings[str_projectrenamed]);
							strreplace(EditorLString, "#n", "\n");
							strreplace(EditorLString, "#1", oldproname);
							strreplace(EditorLString, "#2", inputtext);
							ShowInfo(playerid, EditorLString);
						} 
						case 2: ShowInfo(playerid, Language_Strings[str_projectnamechangecharerr]);
						case 3: ShowInfo(playerid, Language_Strings[str_projectnameexists]);
						case -1: ShowInfo(playerid, Language_Strings[str_projectnamechangeerror]);
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
					switch(listitem)
					{
						case 0: //Wczytaj
						{
							if(LoadProject(NTD_User[User_ProjectIndex]))
							{
								format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectloaded]);
								strreplace(EditorLString, "#1", GetProjectName(NTD_User[User_ProjectIndex]));
								ShowInfo(playerid, EditorLString);
								ShowWelcomeScreen(false);
								RelayerEditor();
								ShowEditorEx(playerid);
							}
							else ShowInfo(playerid, Language_Strings[str_projectloaderror]);
						}
						case 1: //Zmien nazwe
						{
							CreateDialogOnLanguageData(playerid, DL_PROJECTNAMECHANGE);
							CreateDialogCaptionOnLangData(DL_PROJECTNAMECHANGE);
							strreplace(EditorLString, "#1", GetProjectName(NTD_User[User_ProjectIndex]));
							ShowPlayerDialog(playerid, DIALOG_RENAMEPROJECT, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_PROJECTNAMECHANGE][d_s_button1], DLS[DL_PROJECTNAMECHANGE][d_s_button2]);
							PlayerSelectTD(playerid, false);
						}
						case 2: //Usun
						{
							CreateDialogOnLanguageData(playerid, DL_DELETEPROJECTCONFIRM);
							CreateDialogCaptionOnLangData(DL_DELETEPROJECTCONFIRM);
							ShowPlayerDialog(playerid, DIALOG_DELETEPROJECT, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_DELETEPROJECTCONFIRM][d_s_button1], DLS[DL_DELETEPROJECTCONFIRM][d_s_button2]);
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
					new index = Iter_Index(I_PROJECTS, listitem);
					NTD_User[User_ProjectIndex] = index;
					CreateDialogOnLanguageData(playerid, DL_PROJECTSOPTIONS);
					CreateDialogCaptionOnLangData(DL_PROJECTSOPTIONS);
					ShowPlayerDialog(playerid, DIALOG_OPEN2, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_PROJECTSOPTIONS][d_s_button1], DLS[DL_PROJECTSOPTIONS][d_s_button2]);
				}
				else ShowEditorEx(playerid);
			}
			case DIALOG_DELETEPROJECT:
			{
				if(response)
				{
					if(DeleteProject(NTD_User[User_ProjectIndex]))
					{
						format(EditorLString, sizeof EditorLString, Language_Strings[str_projectdeleted]);
						strreplace(EditorLString, "#1", GetProjectName(NTD_User[User_ProjectIndex]));
						ShowInfo(playerid, EditorLString);
					}
					else ShowInfo(playerid, Language_Strings[str_projectdeleteerror]);
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
						if(pid != 0)
						{
							if(LoadProject(NTD_User[User_ProjectIndex]))
							{
								format(EditorLString, sizeof EditorLString, Language_Strings[str_infoprojectcreated]);
								strreplace(EditorLString, "#1", inputtext);
								ShowInfo(playerid, EditorLString);
								ShowWelcomeScreen(false);
								ShowEditorEx(playerid);
							}
							else ShowInfo(playerid, Language_Strings[str_projectloaderror]);
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
						ShowTDOptions(playerid, i);
					}
					return 1;
				}
				 
			}
		}
		if(clickedid == B_Exit)
		{
			CreateDialogOnLanguageData(playerid, DL_EXITCONFIRMATION);
			CreateDialogCaptionOnLangData(DL_EXITCONFIRMATION);
			ShowPlayerDialog(playerid, DIALOG_EXIT, DIALOG_STYLE_MSGBOX, EditorString, EditorLString, DLS[DL_EXITCONFIRMATION][d_s_button1], DLS[DL_EXITCONFIRMATION][d_s_button2]);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Settings)
		{
			new invertedstr[40], quickselectstr[30], compmodestr[30], tdvisistr[60];
			if(EditorAcceptKey == KEY_JUMP && EditorFasterKey == KEY_SPRINT)
				format(invertedstr, sizeof invertedstr, HEX_PALETTE_3"%s", Language_Strings[str_keysinverted]);
				
			if(EditorQuickSelect)
				format(quickselectstr, sizeof quickselectstr, HEX_PALETTE_2"%s", Language_Strings[str_fsenabled]);
			else 
				format(quickselectstr, sizeof quickselectstr, HEX_PALETTE_3"%s", Language_Strings[str_fsdisabled]);
			
			if(EditorTextDrawShowForAll)
				format(tdvisistr, sizeof tdvisistr, HEX_PALETTE_2"%s", Language_Strings[str_tdvforall]);
			else 
				format(tdvisistr, sizeof tdvisistr, HEX_PALETTE_3"%s", Language_Strings[str_tdvforme]);
				
			if(EditorCompactMode)
				format(compmodestr, sizeof compmodestr, HEX_PALETTE_2"%s", Language_Strings[str_compmodeenabled]);
			else 
				format(compmodestr, sizeof compmodestr, HEX_PALETTE_3"%s", Language_Strings[str_compmodedisabled]);
			
			CreateDialogOnLanguageData(playerid, DL_SETTINGS);
			strreplace(EditorLString, "#1", invertedstr);
			strreplace(EditorLString, "#2", quickselectstr);
			strreplace(EditorLString, "#3", tdvisistr);
			strreplace(EditorLString, "#4", compmodestr);
			CreateDialogCaptionOnLangData(DL_SETTINGS);
			ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_TABLIST, EditorString, EditorLString, DLS[DL_SETTINGS][d_s_button1], DLS[DL_SETTINGS][d_s_button2]);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_TDSettings)
		{
			if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			{
				CreateDialogOnLanguageData(playerid, DL_PREVIEWMODELCHANGELIST);
				CreateDialogCaptionOnLangData(DL_PREVIEWMODELCHANGELIST);
				ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_PREVIEWMODELCHANGELIST][d_s_button1], DLS[DL_PREVIEWMODELCHANGELIST][d_s_button2]);
				PlayerSelectTD(playerid, false);
			}
			else if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				CreateDialogOnLanguageData(playerid, DL_MAXBARPERCCHANGE);
				CreateDialogCaptionOnLangData(DL_MAXBARPERCCHANGE);
				strreplace(EditorLString, "#1", "%f");
				format(EditorLString, sizeof EditorLString, EditorLString, NTD_TD[tdid][TD_BarMaxPercentage]);
				ShowPlayerDialog(playerid, DIALOG_MAXBARPERCCHANGE, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_MAXBARPERCCHANGE][d_s_button1], DLS[DL_MAXBARPERCCHANGE][d_s_button2]);
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
			if(NTD_TD[tdid][TD_Font] != TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				if(NTD_TD[tdid][TD_Alignment] == 3)
					NTD_TD[tdid][TD_Alignment] = 0;
				
				NTD_TD[tdid][TD_Alignment]++;
				
				switch(NTD_TD[tdid][TD_Alignment])
				{
					case 1: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_left], 1500, 6);
					case 2: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_center], 1500, 6);
					case 3: GameTextForPlayer(playerid, Language_Strings[str_tdalignment_right], 1500, 6);
				}
			}
			else if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
			{
				switch(NTD_TD[tdid][TD_BarDirectory])
				{
					case BAR_DIRECTION_DOWN:
					{
						NTD_TD[tdid][TD_BarDirectory] = BAR_DIRECTION_RIGHT;
						GameTextForPlayer(playerid, Language_Strings[str_tdalignment_right], 1500, 6);
					}
					case BAR_DIRECTION_RIGHT:
					{
						NTD_TD[tdid][TD_BarDirectory] = BAR_DIRECTION_LEFT;
						GameTextForPlayer(playerid, Language_Strings[str_tdalignment_left], 1500, 6);
					}
					case BAR_DIRECTION_LEFT:
					{
						NTD_TD[tdid][TD_BarDirectory] = BAR_DIRECTION_UP;
						GameTextForPlayer(playerid, Language_Strings[str_tdalignment_up], 1500, 6);
					}
					case BAR_DIRECTION_UP:
					{
						NTD_TD[tdid][TD_BarDirectory] = BAR_DIRECTION_DOWN;
						GameTextForPlayer(playerid, Language_Strings[str_tdalignment_down], 1500, 6);
					}
				}
			}
			UpdateTD(playerid, tdid);
			return 1;
		}
		else if(clickedid == B_SwitchPublic)
		{
			if(NTD_TD[tdid][TD_IsGlobal] == false)
			{
				NTD_TD[tdid][TD_IsGlobal] = true;
				GameTextForPlayer(playerid, Language_Strings[str_tdpublic], 1500, 6);
			}
			else
			{
				NTD_TD[tdid][TD_IsGlobal] = false;
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
			if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
				ColorDialog(playerid, 2);
			else 
				ColorDialog(playerid, 0);
			PlayerSelectTD(playerid, false);
			return 1;
		}
		else if(clickedid == B_Tekst)
		{
			if(NTD_TD[tdid][TD_Font] != 4 && NTD_TD[tdid][TD_Font] != 5) 
			{
				CreateDialogOnLanguageData(playerid, DL_TEXTCHANGE);
				CreateDialogCaptionOnLangData(DL_TEXTCHANGE);
				ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_TEXTCHANGE][d_s_button1], DLS[DL_TEXTCHANGE][d_s_button2]);
			}
			else if(NTD_TD[tdid][TD_Font] == 4) 
			{
				CreateDialogOnLanguageData(playerid, DL_SPRITECHANGELIST);
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
			switch(NTD_TD[tdid][TD_Font])
			{
				case 4, 5, TEXT_DRAW_FONT_PROGRESS_BAR:
				{
					NTD_User[User_ChangingSizeState] = 1;
					NTD_User[User_ChangingState] = CH_SIZE;
					EnableVarChangeTimer(true);
					HideEditor(playerid);
				}
				default:
				{
					CreateDialogOnLanguageData(playerid, DL_BOXSIZECHANGELIST);
					CreateDialogCaptionOnLangData(DL_BOXSIZECHANGELIST);
					ShowPlayerDialog(playerid, DIALOG_SIZE, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_BOXSIZECHANGELIST][d_s_button1], DLS[DL_BOXSIZECHANGELIST][d_s_button2]);
				}
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
			if(NTD_TD[tdid][TD_Font] == TEXT_DRAW_FONT_PROGRESS_BAR)
				NTD_TD[tdid][TD_Font] = 0;
			else
				NTD_TD[tdid][TD_Font]++;
			//
			UpdateTD(playerid, tdid);
			switch(NTD_TD[tdid][TD_Font])
			{
				case 4: GameTextForPlayer(playerid, Language_Strings[str_tdfontspriteinfo], 1500, 6);
				case TEXT_DRAW_FONT_MODEL_PREVIEW: GameTextForPlayer(playerid, Language_Strings[str_tdfontprevmodelinfo], 1500, 6);
				case TEXT_DRAW_FONT_PROGRESS_BAR: GameTextForPlayer(playerid, Language_Strings[str_tdfontplayerprogressbar], 1500, 6);
				default: 
				{
					new tmp_str[12];
					format(EditorString, sizeof EditorString, Language_Strings[str_tdfontinfo]);
					format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_Font]);
					strreplace(EditorString, "#1", tmp_str);
					GameTextForPlayer(playerid, EditorString, 1500, 6);
				}
			}
			ShowEditorEx(playerid);
			return 1;
		}
		else if(clickedid == B_NewProject)
		{
			if(Iter_Count(I_PROJECTS) < MAX_NTD_PROJECTS)
			{
				CreateDialogOnLanguageData(playerid, DL_NEWPROJECT);
				CreateDialogCaptionOnLangData(DL_NEWPROJECT);
				ShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT, EditorString, EditorLString, DLS[DL_NEWPROJECT][d_s_button1], DLS[DL_NEWPROJECT][d_s_button2]);
				PlayerSelectTD(playerid, false);
			}
			else ShowInfo(playerid, Language_Strings[str_infoprojectlimit]);
			return 1;
		}
		else if(clickedid == B_CloseProject)
		{
			if(SaveProject(NTD_User[User_ProjectIndex]) == 0) 
				ShowInfo(playerid, Language_Strings[str_infoprojectsaveerror]);
			else 
				ShowInfo(playerid, Language_Strings[str_infoprojectclosed]);
			
			foreach(new i : I_TEXTDRAWS)
				DestroyTD(i, i);
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
			CreateDialogOnLanguageData(playerid, DL_EXPORTPROJECT);
			CreateDialogCaptionOnLangData(DL_EXPORTPROJECT);
			ShowPlayerDialog(playerid, DIALOG_EXPORT, DIALOG_STYLE_LIST, EditorString, EditorLString, DLS[DL_EXPORTPROJECT][d_s_button1], DLS[DL_EXPORTPROJECT][d_s_button2]);
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
	if(NTD_TD[td][TD_SelfID] != Text:INVALID_TEXT_DRAW)
	{
		SplitRGBA(NTD_TD[td][TD_Color],red,green,blue, alpha); 
		NTD_TD[td][TD_Color] = CreateRGBA(red,green,blue,NTD_TD[td][TD_ColorAlpha]);
		TextDrawColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_Color]);
		SplitRGBA(NTD_TD[td][TD_BGColor],red,green,blue, alpha);
		NTD_TD[td][TD_BGColor] = CreateRGBA(red,green,blue,NTD_TD[td][TD_BGColorAlpha]);
		TextDrawBackgroundColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BGColor]);
		SplitRGBA(NTD_TD[td][TD_BoxColor],red,green,blue, alpha); 
		NTD_TD[td][TD_BoxColor] = CreateRGBA(red,green,blue,NTD_TD[td][TD_BoxColorAlpha]);
		TextDrawBoxColor(NTD_TD[td][TD_SelfID], NTD_TD[td][TD_BoxColor]);
		TextDrawShowForPlayer(playerid, NTD_TD[td][TD_SelfID]);
	}
	else if(NTD_TD[td][TD_BarID] != INVALID_PLAYER_BAR_ID)
	{
		SetPlayerProgressBarColour(playerid, NTD_TD[td][TD_BarID], NTD_TD[td][TD_Color]);
		ShowPlayerProgressBar(playerid, NTD_TD[td][TD_BarID]);
	}
	return 1;
}

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

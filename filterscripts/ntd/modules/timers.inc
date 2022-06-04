
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
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdlayer", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%i", tdid);
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_ALPHA:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdcoloralpha", LANG_TYPE_GAMETEXTS));
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
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdeditorposition", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%i", EditorPosX);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%i", EditorPosY);
			strreplace(EditorString, "#2", tmp_str);
		}
		case CH_MODEL_COLOR:
		{
			NTD_TD[tdid][TD_PrevModelC1] = clamp(NTD_TD[tdid][TD_PrevModelC1], 0, 255);
			NTD_TD[tdid][TD_PrevModelC2] = clamp(NTD_TD[tdid][TD_PrevModelC2], 0, 255);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdprevmodelcolor", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_PrevModelC1]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%i", NTD_TD[tdid][TD_PrevModelC2]);
			strreplace(EditorString, "#2", tmp_str);
		}	
		case CH_POSITION:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdposition", LANG_TYPE_GAMETEXTS));
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
			
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdrotation", LANG_TYPE_GAMETEXTS));
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
			
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdpremodelzoom", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%.3f", NTD_TD[tdid][TD_PrevRotZoom]);
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_SIZE:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdsize", LANG_TYPE_GAMETEXTS));
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
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdsprite", LANG_TYPE_GAMETEXTS));
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
				if(NTD_TD[tdid][TD_SelfID] != Text:INVALID_TEXT_DRAW)
				{
					TextDrawDestroy(NTD_TD[tdid][TD_SelfID]);
					NTD_TD[tdid][TD_SelfID] = Text:INVALID_TEXT_DRAW;
				}
				if(NTD_TD[tdid][TD_BarID] != INVALID_PLAYER_BAR_ID)
				{
					DestroyPlayerProgressBar(playerid, NTD_TD[tdid][TD_BarID]);
					NTD_TD[tdid][TD_BarID] = INVALID_PLAYER_BAR_ID;
				}
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

public FadeTimer(bool:fadein)
{
	if(fadein)
	{
		if(NTD_User[User_WelcomeScreenAlpha] < 254)
		{
			NTD_User[User_WelcomeScreenAlpha] += 3;
			NTD_User[User_WelcomeScreenColor] = CreateRGBAWithAlpha(NTD_User[User_WelcomeScreenColor], NTD_User[User_WelcomeScreenAlpha]);
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
			NTD_User[User_WelcomeScreenColor] = CreateRGBAWithAlpha(NTD_User[User_WelcomeScreenColor], NTD_User[User_WelcomeScreenAlpha]);
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

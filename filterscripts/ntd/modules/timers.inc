
public ChangingVarsTime()
{
	new tdid = User[User_EditingTDID];
	new Keys,ud,lr;
	new tmp_str[12];
	new newlayer;
	new playerid = User[User_PlayerIDInEditor];
    GetPlayerKeys(playerid,Keys,ud,lr);
	
	if(User[User_BlockVarsTime] == false)
	{
		if(ud == KEY_UP)
		{
			EditorVarUpdated = true;
			switch(User[User_ChangingState])
			{
				case CH_LAYER:
				{
					newlayer = SwapTDLayers(User[User_ChoosenTDID], Iter_Next(I_TEXTDRAWS, User[User_ChoosenTDID]));
					if(newlayer != -1)
					{
						User[User_ChoosenTDID] = newlayer;
						User[User_EditingTDID] = newlayer;
						RelayerEditor();
						BlockVarsChanger(true);
					}
				}
				case CH_SPRITE:
				{
					User[User_SpritePicker]++;
					if(User[User_SpritePicker] > (User[User_SpriteIndex] - 1))
						User[User_SpritePicker] = 0;
					new SP = User[User_SpritePicker];
					format(EditorString, sizeof EditorString, "%s:%s", Sprite_Library[SP][Sprite_Lib], Sprite_Library[SP][Sprite_Name]);
					format(TextDraw[tdid][TD_Text], 128, EditorString);
					BlockVarsChanger(true);
				}
				case CH_ALPHA:
				{
					switch(User[User_ChangingMColorState])
					{
						case 0: //Tekst
						{
							if(!User[User_Accelerate]) TextDraw[tdid][TD_ColorAlpha] += 1;	
							else TextDraw[tdid][TD_ColorAlpha] += 10;
						}					
						case 1: //Tlo
						{
							if(!User[User_Accelerate]) TextDraw[tdid][TD_BGColorAlpha] += 1;
							else TextDraw[tdid][TD_BGColorAlpha] += 10;
						}
						case 2: //Box
						{
							if(!User[User_Accelerate]) TextDraw[tdid][TD_BoxColorAlpha] += 1;
							else TextDraw[tdid][TD_BoxColorAlpha] += 10;
						}
					}
				}
				case CH_EDITOR_POS:
				{
					if(!User[User_Accelerate]) 
						EditorPosY -= 1;
					else 
						EditorPosY -= 10;
				}
				case CH_POSITION:
				{
					if(!User[User_Accelerate]) 
						TextDraw[tdid][TD_PosY] -= 0.1;
					else 
						TextDraw[tdid][TD_PosY] -= 5.0;
				}	
				case CH_SIZE:
				{
					if(!User[User_Accelerate]) 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeY] -= 0.025; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeY] -= 0.25; 
					} 
					else 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeY] -= 0.25; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeY] -= 2.5; 
					}
				}	
				case CH_MODEL_ROTATION:
				{
					if(!User[User_Accelerate]) 
						TextDraw[tdid][TD_PrevRotX] += 1.0;
					else 
						TextDraw[tdid][TD_PrevRotY] += 1.0;
				}
				case CH_MODEL_ZOOM:
				{
					if(User[User_Accelerate]) 
						TextDraw[tdid][TD_PrevRotZoom] -= 0.1;
					else 
						TextDraw[tdid][TD_PrevRotZoom] -= 0.01;
				}
				case CH_MODEL_COLOR:
				{
					if(User[User_Accelerate]) 
						TextDraw[tdid][TD_PrevModelC2] ++;
					else 
						TextDraw[tdid][TD_PrevModelC1] ++;
				}
			}
		}
		else if(ud == KEY_DOWN)
		{
			EditorVarUpdated = true;
			switch(User[User_ChangingState])
			{
				case CH_LAYER:
				{
					newlayer = SwapTDLayers(User[User_ChoosenTDID], Iter_Prev(I_TEXTDRAWS, User[User_ChoosenTDID]));
					if(newlayer != -1)
					{
						User[User_ChoosenTDID] = newlayer;
						User[User_EditingTDID] = newlayer;
						RelayerEditor();
						BlockVarsChanger(true);
					}
				}
				case CH_SPRITE:
				{
					User[User_SpritePicker]--;
					if(User[User_SpritePicker] < 0)
						User[User_SpritePicker] = (User[User_SpriteIndex] - 1);
					new SP = User[User_SpritePicker];
					format(EditorString, sizeof EditorString, "%s:%s", Sprite_Library[SP][Sprite_Lib], Sprite_Library[SP][Sprite_Name]);
					format(TextDraw[tdid][TD_Text], 128, EditorString);
					BlockVarsChanger(true);
				}
				case CH_ALPHA:
				{
					if(User[User_ChangingMColorState] == 0) //Tekst
						if(!User[User_Accelerate]) TextDraw[tdid][TD_ColorAlpha] -= 1;	
						else TextDraw[tdid][TD_ColorAlpha] -= 10;	
					if(User[User_ChangingMColorState] == 1) //Tlo
						if(!User[User_Accelerate]) TextDraw[tdid][TD_BGColorAlpha] -= 1;
						else TextDraw[tdid][TD_BGColorAlpha] -= 10;
					if(User[User_ChangingMColorState] == 2) //Box
						if(!User[User_Accelerate]) TextDraw[tdid][TD_BoxColorAlpha] -= 1;
						else TextDraw[tdid][TD_BoxColorAlpha] -= 10;
				}
				case CH_EDITOR_POS:
				{
					if(!User[User_Accelerate]) 
						EditorPosY += 1;
					else 
						EditorPosY += 10;
				}
				case CH_POSITION:
				{
					if(!User[User_Accelerate]) 
						TextDraw[tdid][TD_PosY] += 0.1;
					else
						TextDraw[tdid][TD_PosY] += 5.0;
				}	
				case CH_SIZE:
				{
					if(!User[User_Accelerate]) 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeY] += 0.025; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeY] += 0.25; 
					} 
					else 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeY] += 0.25; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeY] += 2.5; 
					}
				}
				case CH_MODEL_ROTATION:
				{
					if(!User[User_Accelerate])
						TextDraw[tdid][TD_PrevRotX] -= 1.0;
					else 
						TextDraw[tdid][TD_PrevRotY] -= 1.0;
				}
				case CH_MODEL_ZOOM:
				{
					if(User[User_Accelerate]) 
						TextDraw[tdid][TD_PrevRotZoom] += 0.1;
					else 
						TextDraw[tdid][TD_PrevRotZoom] += 0.01;
				}
				case CH_MODEL_COLOR:
				{
					if(User[User_Accelerate]) 
						TextDraw[tdid][TD_PrevModelC2] --;
					else 
						TextDraw[tdid][TD_PrevModelC1] --;
				}
			}
		}
		if(lr == KEY_LEFT)
		{
			EditorVarUpdated = true;
			switch(User[User_ChangingState])
			{
				case CH_POSITION:
				{
					if(!User[User_Accelerate]) 
						TextDraw[tdid][TD_PosX] -= 0.1; 
					else
						TextDraw[tdid][TD_PosX] -= 5.0; 
				}	
				case CH_SIZE:
				{
					if(!User[User_Accelerate]) 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeX] -= 0.05 / 12; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeX] -= 0.5; 
					} 
					else 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeX] -= 0.5 / 12; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeX] -= 5.0; 
					}
				}
				case CH_EDITOR_POS:
				{
					if(EditorCompactMode)
					{
						if(!User[User_Accelerate]) 
							EditorPosX -= 1;
						else 
							EditorPosX -= 10;
					}
				}
				case CH_MODEL_ROTATION:
				{
					if(!User[User_Accelerate])
						TextDraw[tdid][TD_PrevRotZ] -= 1.0;
				}
			}
		}
		else if(lr == KEY_RIGHT)
		{
			EditorVarUpdated = true;
			switch(User[User_ChangingState])
			{
				case CH_POSITION:
				{
					if(!User[User_Accelerate]) 
						TextDraw[tdid][TD_PosX] += 0.1; 	
					else 
						TextDraw[tdid][TD_PosX] += 5.0; 
				}	
				case CH_SIZE:
				{
					if(!User[User_Accelerate]) 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeX] += 0.05 / 12; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeX] += 0.5; 
					} 
					else 
					{
						if(User[User_ChangingSizeState] == 0) 
							TextDraw[tdid][TD_LetterSizeX] += 0.5 / 12; 
						else if(User[User_ChangingSizeState] == 1) 
							TextDraw[tdid][TD_BoxSizeX] += 5.0; 
					}
				}
				case CH_EDITOR_POS:
				{
					if(EditorCompactMode)
					{
						if(!User[User_Accelerate]) 
							EditorPosX += 1;
						else 
							EditorPosX += 10;
					}
					
				}
				case CH_MODEL_ROTATION:
				{
					if(!User[User_Accelerate])
						TextDraw[tdid][TD_PrevRotZ] += 1.0;
				}
			}
		}
	}
	// // // // // Visuals // // // // //
	switch(User[User_ChangingState])
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
			switch(User[User_ChangingMColorState])
			{
				case 0:
				{
					TextDraw[tdid][TD_ColorAlpha] = clamp(TextDraw[tdid][TD_ColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", TextDraw[tdid][TD_ColorAlpha]);
				}
				case 1:
				{
					TextDraw[tdid][TD_BGColorAlpha] = clamp(TextDraw[tdid][TD_BGColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", TextDraw[tdid][TD_BGColorAlpha]);
				}
				case 2:
				{
					TextDraw[tdid][TD_BoxColorAlpha] = clamp(TextDraw[tdid][TD_BoxColorAlpha], 0, 255);
					format(tmp_str, sizeof tmp_str, "%i", TextDraw[tdid][TD_BoxColorAlpha]);
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
			TextDraw[tdid][TD_PrevModelC1] = clamp(TextDraw[tdid][TD_PrevModelC1], 0, 255);
			TextDraw[tdid][TD_PrevModelC2] = clamp(TextDraw[tdid][TD_PrevModelC2], 0, 255);
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdprevmodelcolor", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%i", TextDraw[tdid][TD_PrevModelC1]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%i", TextDraw[tdid][TD_PrevModelC2]);
			strreplace(EditorString, "#2", tmp_str);
		}	
		case CH_POSITION:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdposition", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PosX]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PosY]);
			strreplace(EditorString, "#2", tmp_str);
		}
		case CH_MODEL_ROTATION:
		{
			if(TextDraw[tdid][TD_PrevRotX] > 360 || TextDraw[tdid][TD_PrevRotX] < -360) TextDraw[tdid][TD_PrevRotX] = 0.0;
			if(TextDraw[tdid][TD_PrevRotY] > 360 || TextDraw[tdid][TD_PrevRotY] < -360) TextDraw[tdid][TD_PrevRotY] = 0.0;
			if(TextDraw[tdid][TD_PrevRotZ] > 360 || TextDraw[tdid][TD_PrevRotZ] < -360) TextDraw[tdid][TD_PrevRotZ] = 0.0;
			
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdrotation", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PrevRotX]);
			strreplace(EditorString, "#1", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PrevRotY]);
			strreplace(EditorString, "#2", tmp_str);
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PrevRotZ]);
			strreplace(EditorString, "#3", tmp_str);
		}
		case CH_MODEL_ZOOM:
		{
			if(TextDraw[tdid][TD_PrevRotZoom] < 0) TextDraw[tdid][TD_PrevRotZoom] = 0.0;
			if(TextDraw[tdid][TD_PrevRotZoom] > 15) TextDraw[tdid][TD_PrevRotZoom] = 15.0;
			
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdpremodelzoom", LANG_TYPE_GAMETEXTS));
			format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_PrevRotZoom]);
			strreplace(EditorString, "#1", tmp_str);
		}
		case CH_SIZE:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdsize", LANG_TYPE_GAMETEXTS));
			switch(User[User_ChangingSizeState])
			{
				case 0:
				{
					format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_LetterSizeX]);
					strreplace(EditorString, "#1", tmp_str);
					format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_LetterSizeY]);
					strreplace(EditorString, "#2", tmp_str);
				}
				case 1:
				{
					format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_BoxSizeX]);
					strreplace(EditorString, "#1", tmp_str);
					format(tmp_str, sizeof tmp_str, "%.3f", TextDraw[tdid][TD_BoxSizeY]);
					strreplace(EditorString, "#2", tmp_str);
				}
			}
		}
		case CH_SPRITE:
		{
			format(EditorString, sizeof EditorString, GetLanguageMessage("tdsprite", LANG_TYPE_GAMETEXTS));
			strreplace(EditorString, "#1", TextDraw[tdid][TD_Text]);
			format(tmp_str, sizeof tmp_str, "%i", User[User_SpritePicker]);
			strreplace(EditorString, "#2", tmp_str);
		}
	}
	GameTextForPlayer(playerid, EditorString, 200, 4);
	if(EditorVarUpdated)
	{
		EditorVarUpdated = false;
		if(User[User_ChangingState] != CH_EDITOR_POS)
		{
			if(User[User_ChangingState] == CH_POSITION || User[User_ChangingState] == CH_SPRITE) 
			{
				RedrawTD(playerid, tdid);
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
		if(User[User_WelcomeScreenAlpha] < 254)
		{
			User[User_WelcomeScreenAlpha] += 3;
			User[User_WelcomeScreenColor] = CreateRGBAWithAlpha(User[User_WelcomeScreenColor], User[User_WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, User[User_WelcomeScreenColor]);
			TextDrawShowForPlayer(User[User_PlayerIDInEditor], WelcomeScreen);
		}
		else 
		{
			KillTimer(User[User_WelcomeTimer]);
			User[User_WelcomeTimer] = -1;
		}
			
		
	}
	else
	{
		if(User[User_WelcomeScreenAlpha] > 0)
		{
			User[User_WelcomeScreenAlpha] -= 3;
			User[User_WelcomeScreenColor] = CreateRGBAWithAlpha(User[User_WelcomeScreenColor], User[User_WelcomeScreenAlpha]);
			TextDrawColor(WelcomeScreen, User[User_WelcomeScreenColor]);
			TextDrawShowForPlayer(User[User_PlayerIDInEditor], WelcomeScreen);
		}
		else 
		{
			TextDrawDestroy(WelcomeScreen);
			User[User_WelcomeScreenAlpha] = -1;
			KillTimer(User[User_WelcomeTimer]);
			User[User_WelcomeTimer] = -1;
		}
	}
	return 1;
}

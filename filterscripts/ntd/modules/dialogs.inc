/*
  _____    _           _                       
 |  __ \  (_)         | |                      
 | |  | |  _    __ _  | |   ___     __ _   ___ 
 | |  | | | |  / _` | | |  / _ \   / _` | / __|
 | |__| | | | | (_| | | | | (_) | | (_| | \__ \ 
 |_____/  |_|  \__,_| |_|  \___/   \__, | |___/
                                    __/ |      
                                   |___/       
*/




Dialog:D_ConvertProject(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new projectindex = User[User_ProjectIndex];
        new amount = TryConvertProject(projectindex);
        new filePathFrom[258], filePathTo[258];
        if(amount != -1)
        {
            if(!Exists( MakePath(PROJECTS_ORIGINAL_DIRPATH, true)))
                CreateDir(MakePath(PROJECTS_ORIGINAL_DIRPATH, true));
            
            format(filePathFrom, sizeof filePathFrom, PROJECTS_DIRECTORYPATH"/%s", GetProjectName(projectindex, true));
            format(filePathTo, sizeof filePathTo, PROJECTS_ORIGINAL_DIRPATH"/%s", GetProjectName(projectindex, true));
            MoveFile( MakePath(filePathFrom, true), MakePath(filePathTo, true) );
            ShowInfo(playerid, GetLanguageMessage("infoprojectconverted", LANG_TYPE_MESSAGES, "", "i", amount));
        } 
        else ShowInfo(playerid, GetLanguageMessage("infoprojecterror", LANG_TYPE_MESSAGES));
    }
    else ShowEditorEx(playerid), OpenProjectDialog(playerid);
    return 1;
}

Dialog:D_SettingsReset2(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        ResetConfiguration(playerid);
        SaveConfigurations();
        DestroyEditor();
        CreateEditor();
        ShowEditorEx(playerid);
        
        PlayerSelectTD(playerid, false);
        ShowInfo(playerid, GetLanguageMessage("infoeditorreset", LANG_TYPE_MESSAGES));
    }
    else
    {
        ShowEditorSettings(playerid);
    }
    return 1;
}

Dialog:D_ColorChange4(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
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
    return 1;
}

Dialog:D_ColorChange2(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
        if(listitem == 0) //Gotowe kolory
        {
            for(new i; i < sizeof Premade_Colors; i++)
            {
                AddDialogListitem(playerid, "{%06x}############################\n", (Premade_Colors[i][0] >>> 8));
            }
            ShowPlayerDialogPages(playerid, "DP_ColorChange3", DIALOG_STYLE_LIST, 
            GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "caption"),
            GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "button1"), 
            GetLanguageMessage("premadecolors", LANG_TYPE_DIALOGS, "button2"),
            EditorMaxDialogItems);
        }
        else if(listitem == 1) //Kombinator
        {
            new color[4], hex;
            switch(User[User_ChangingMColorState])
            {
                case 0: SplitRGBA(TextDraw[tdid][TD_Color],color[0],color[1],color[2],color[3]), hex = TextDraw[tdid][TD_Color];
                case 1: SplitRGBA(TextDraw[tdid][TD_BGColor],color[0],color[1],color[2],color[3]), hex = TextDraw[tdid][TD_BGColor];
                case 2: SplitRGBA(TextDraw[tdid][TD_BoxColor],color[0],color[1],color[2],color[3]), hex = TextDraw[tdid][TD_BoxColor];
            }
            Dialog_Show(playerid, "D_ColorChange4", DIALOG_STYLE_INPUT, 
            GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "caption"), 
            GetLanguageMessage("colorchange", LANG_TYPE_DIALOGS, "infos", "iiiix", color[0], color[1], color[2], color[3], hex), 
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
    return 1;
}

Dialog:D_ColorChange1(DIALOG_CALLBACK_PARAMETERS)
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
    return 1;
}

Dialog:D_PreviewModel2(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
        TextDraw[tdid][TD_PrevModelID] = strval(inputtext);
        UpdateTD(playerid, tdid);
        PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
        ShowEditorEx(playerid);
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_PreviewModel1(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Change Model
            {
                Dialog_Show(playerid, "D_PreviewModel2", DIALOG_STYLE_INPUT, 
                GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("previewmodelid", LANG_TYPE_DIALOGS, "button2"));
            }
            default:
            {
                User[User_ChangingState] = (listitem == 1 ? CH_MODEL_ROTATION : (listitem == 2 ? CH_MODEL_ZOOM : CH_MODEL_COLOR));
                EnableVarChangeTimer(true);
                PlayerSelectTD(playerid, false);
                HideEditor(playerid);
            }
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_BarMaxPercentage(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        if((IsNumeric(inputtext) || IsFloat(inputtext)) && strval(inputtext) >= 0 && (floatstr(inputtext) > 0.0 && floatstr(inputtext) < cellmax))
        {
            new tdid = User[User_EditingTDID];
            TextDraw[tdid][TD_BarMaxPercentage] = floatstr(inputtext);
            UpdateTD(playerid, tdid);
            PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
        }
    }
    ShowEditorEx(playerid);
    return 1;
}

Dialog:D_ChangeSize(DIALOG_CALLBACK_PARAMETERS)
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
    return 1;
}

Dialog:D_ExportProject(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: 
            {
                User[User_ExportType]++;
                if(User[User_ExportType] == 2)
                    User[User_ExportType] = 0;
                ShowExportDialog(playerid);
            }
            case 1:
            {
                User[User_ExportArrayMode] = !User[User_ExportArrayMode];
                ShowExportDialog(playerid);
            }
            case 2:
            {
                if(ExportProject(User[User_ProjectIndex], User[User_ExportType], User[User_ExportArrayMode]))
                {
                    new filePath[258];
                    format(filePath, sizeof filePath, HEX_PALETTE_2"%s/%s.pwn", MakePath(EXPORTS_DIRECTORYPATH, true), GetProjectName(User[User_ProjectIndex]));
                    ShowInfo(playerid, GetLanguageMessage("infoprojectexported", LANG_TYPE_MESSAGES, #, "s", filePath));
                }
                else
                {
                    ShowInfo(playerid, GetLanguageMessage("infoprojectexporterror", LANG_TYPE_MESSAGES));
                }
            }
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_DeleteProject(DIALOG_CALLBACK_PARAMETERS)
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
    return 1;
}

Dialog:D_RenameProject(DIALOG_CALLBACK_PARAMETERS)
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
    return 1;
}

Dialog:D_DeleteTextDraw(DIALOG_CALLBACK_PARAMETERS)
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
    return 1;
}

Dialog:D_ChangeParamName(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        if(strlen(inputtext) > 0 && !isnull(inputtext))
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
    return 1;
}

Dialog:D_SpritesChangeList(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Manual
            {
                Dialog_Show(playerid, "D_TextChange", DIALOG_STYLE_INPUT, 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button2"));
            }
            case 1: // Library
            {
                ClearDialogListitems(playerid);
                AddDialogListitem(playerid, SPRITE_TYPE_0);
                AddDialogListitem(playerid, SPRITE_TYPE_1);
                AddDialogListitem(playerid, SPRITE_TYPE_2);
                AddDialogListitem(playerid, SPRITE_TYPE_3);
                AddDialogListitem(playerid, SPRITE_TYPE_4);
                AddDialogListitem(playerid, SPRITE_TYPE_5);
                AddDialogListitem(playerid, SPRITE_TYPE_6);
                AddDialogListitem(playerid, SPRITE_TYPE_7);
                AddDialogListitem(playerid, SPRITE_TYPE_8);
                AddDialogListitem(playerid, SPRITE_TYPE_9);
                AddDialogListitem(playerid, SPRITE_TYPE_10);
                AddDialogListitem(playerid, SPRITE_TYPE_11);
                AddDialogListitem(playerid, SPRITE_TYPE_12);
                AddDialogListitem(playerid, SPRITE_TYPE_13);
                AddDialogListitem(playerid, SPRITE_TYPE_14);
                AddDialogListitem(playerid, SPRITE_TYPE_15);
                AddDialogListitem(playerid, SPRITE_TYPE_16);
                AddDialogListitem(playerid, SPRITE_TYPE_17);
                AddDialogListitem(playerid, SPRITE_TYPE_18);
                AddDialogListitem(playerid, SPRITE_TYPE_19);
                //
                ShowPlayerDialogPages(playerid, "DP_SpritesLibrary", DIALOG_STYLE_LIST, 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "caption"),
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("spritechange", LANG_TYPE_DIALOGS, "button2"),
                EditorMaxDialogItems);
            }
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_TextChange(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        if(strlen(inputtext))
        {
            new tdid = User[User_EditingTDID];
            format(TextDraw[tdid][TD_Text], 300, inputtext);
            RedrawTD(playerid, tdid);
            ShowEditorEx(playerid);
            PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
        }
        else ShowEditorEx(playerid);
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_Settings(DIALOG_CALLBACK_PARAMETERS)
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
                ClearDialogListitems(playerid);
                for(new i = 1; i < sizeof Premade_Colors; i++)
                {
                    AddDialogListitem(playerid, "{%06x}############################", (Premade_Colors[i][0] >>> 8));
                }
                ShowPlayerDialogPages(playerid, "D_OverrideColor", DIALOG_STYLE_LIST, 
                GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("overridecolorchange", LANG_TYPE_DIALOGS, "button2"),
                EditorMaxDialogItems);
            }
            case 2: //Zmien kolor przyciskow
            {
                ClearDialogListitems(playerid);
                for(new i = 1; i < sizeof Premade_Colors; i++)
                {
                    AddDialogListitem(playerid, "{%06x}############################", (Premade_Colors[i][0] >>> 8));
                }
                ShowPlayerDialogPages(playerid, "D_ButtonsColor", DIALOG_STYLE_LIST, 
                GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("buttonscolorchange", LANG_TYPE_DIALOGS, "button2"),
                EditorMaxDialogItems);
            }
            case 3: //Odwroc Shift z Spacja
            {
                new keyA = EditorFasterKey;
                new keyB = EditorAcceptKey;
                EditorFasterKey = keyB;
                EditorAcceptKey = keyA;
                ShowEditorSettings(playerid);
            }
            case 4: //Szybki wybor
            {
                EditorQuickSelect = !EditorQuickSelect;
                QuickSelectionShow(playerid, EditorQuickSelect);
                ShowEditorSettings(playerid);
            }
            case 5: //Wyswietlanie TextDrawow
            {
                ToggleTextDrawShowForAll(!EditorTextDrawShowForAll);
                ShowEditorSettings(playerid);
            }
            case 6: //Tryb kompaktowy
            {
                EditorCompactMode = !EditorCompactMode;
                DestroyEditor();
                CreateEditor();
                ShowEditorEx(playerid);
                ShowEditorSettings(playerid);
            }
            case 7: //Zmien jezyk
                ShowLanguageChangeDialog(playerid, 2);
            case 8: //Ustawienia fabryczne
            {
                Dialog_Show(playerid, "D_SettingsReset2", DIALOG_STYLE_MSGBOX, 
                GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("settingsreset", LANG_TYPE_DIALOGS, "button2"));
            }
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

Dialog:D_Info(DIALOG_CALLBACK_PARAMETERS)
{
    ShowEditorEx(playerid);
    return 1;
}

Dialog:D_ManualVariableChange(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
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
    return 1;
}

Dialog:D_SettingsReset(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        ResetConfiguration(playerid);
        SaveConfigurations();
    }
    else
    {
        EditorVersion = SCRIPT_VERSION;
        SaveConfigurations();
    }
    if(!User[User_InEditor])
        CallNTDCommand(playerid);
    return 1;
}

Dialog:D_TextDrawOptions(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_ChoosenTDID];
        if(tdid == -1)
            return 1;
        switch(listitem)
        {
            case 0: // Modify
            {
                SelectTD(playerid, tdid);
                ShowEditorEx(playerid);
            }
            case 1: // Duplicate
            {
                tdid = CreateNewTD(tdid);
                if(tdid != -1)
                {
                    DrawTD(tdid);
                    SelectTD(playerid, tdid);
                    //
                    format(EditorString, sizeof EditorString, GetLanguageMessage("tdclonedinfo", LANG_TYPE_GAMETEXTS, "", "i", tdid));
                    //
                    GameTextForPlayer(playerid, EditorString, 5000, 6);
                    PlayerPlaySound(playerid, CONFIRM_SOUNDID, 0.0, 0.0, 0.0);
                    RelayerEditor();
                    ShowEditorEx(playerid, true);
                }
                else ShowInfo(playerid, GetLanguageMessage("infomaxtextdrawsreached", LANG_TYPE_MESSAGES));
            }
            case 2: // Change Layer
            {
                User[User_ChangingState] = CH_LAYER;
                EnableVarChangeTimer(true);
                PlayerSelectTD(playerid, false);
                HideEditor(playerid);
            }
            case 3: // Change variable name
            {
                Dialog_Show(playerid, "D_ChangeParamName", DIALOG_STYLE_INPUT, 
                GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "infos", "ss", GetProcessedTDVarName(tdid), TextDraw[tdid][TD_Text]), 
                GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("variablechange", LANG_TYPE_DIALOGS, "button2"));
            }
            case 4: // Assign Group
            {
                OpenGroupsDialog(playerid, 1);
            }
            case 5: // Delete
            {
                new formatedtd[MAXFORMATEDTD];
                format(formatedtd, MAXFORMATEDTD, TextDraw[tdid][TD_Text]);
                if(strlen(TextDraw[tdid][TD_Text]) > MAXFORMATEDTD - 4)
                {
                    strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
                    strcat(formatedtd, "...");
                }
                Dialog_Show(playerid, "D_DeleteTextDraw", DIALOG_STYLE_MSGBOX, 
                GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "infos", "s", formatedtd), 
                GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("deletedconfirm", LANG_TYPE_DIALOGS, "button2"));
            }
        }
        
    } 
    else 
    {
        ShowEditorEx(playerid, true);
        OpenTDDialog(playerid);
    }
    return 1;
}

Dialog:D_ExitEditor(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
        CallNTDCommand(playerid);
    else
        ShowEditorEx(playerid);
    return 1;
}

Dialog:D_NewGroup(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        if(strlen(inputtext) > 0 && strlen(inputtext) < 128 && IsValidString(inputtext))
        {
            switch(CreateGroup(inputtext, Iter_Free(I_GROUPS), false))
            {
                case -1: ShowInfo(playerid, GetLanguageMessage("infogroupexists", LANG_TYPE_MESSAGES));
                case 0: ShowInfo(playerid, GetLanguageMessage("infomaxgroupsreached", LANG_TYPE_MESSAGES));
                case 1: OpenGroupsDialog(playerid, 0);
            }
        }
        else ShowInfo(playerid, GetLanguageMessage("infoprojectinvalidname", LANG_TYPE_MESSAGES));
    }
    else OpenGroupsDialog(playerid, 0);
    return 1;
}

Dialog:D_NewProject(DIALOG_CALLBACK_PARAMETERS)
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
    else ShowEditorEx(playerid), OpenProjectDialog(playerid);
    return 1;
}

Dialog:D_OpenProject(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new projectindex = User[User_ProjectIndex];
        switch(listitem)
        {
            case 0: // Load
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
                    
                    new tmp_str[128];
                    format(tmp_str, sizeof tmp_str, "%s.%s", GetProjectName(projectindex), Extensions[ FILE_EXTENSION_NTD ][fe_extension]);
                    //print(tmp_str);
                    Dialog_Show(playerid, "D_ConvertProject", DIALOG_STYLE_MSGBOX, 
                    GetLanguageMessage("infoprojectneedconvert", LANG_TYPE_DIALOGS, "caption"), 
                    GetLanguageMessage("infoprojectneedconvert", LANG_TYPE_DIALOGS, "infos", "sss", GetProjectName(projectindex, true), tmp_str, MakePath(PROJECTS_ORIGINAL_DIRPATH, true)), 
                    GetLanguageMessage("infoprojectneedconvert", LANG_TYPE_DIALOGS, "button1"), 
                    GetLanguageMessage("infoprojectneedconvert", LANG_TYPE_DIALOGS, "button2"));
                    PlayerSelectTD(playerid, false);
                }
            }
            case 1: // Change Name
            {
                Dialog_Show(playerid, "D_RenameProject", DIALOG_STYLE_INPUT, 
                GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "infos", "s", GetProjectName(projectindex)), 
                GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("changeprojectname", LANG_TYPE_DIALOGS, "button2"));
                PlayerSelectTD(playerid, false);
            }
            case 2: // Delete
            {
                Dialog_Show(playerid, "D_DeleteProject", DIALOG_STYLE_MSGBOX, 
                GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("deleteprojectconfirm", LANG_TYPE_DIALOGS, "button2"));
            }
        }
    }
    else ShowEditorEx(playerid), OpenProjectDialog(playerid);
    return 1;
}

Dialog:D_CreateNewTD(DIALOG_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Simple
            {
                new tdid = CreateNewTD();
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
            case 1: // Template
            {
                ClearDialogListitems(playerid);
                foreach(new i : I_TEMPLATES)
                {
                    AddDialogListitem(playerid, Template[i][Template_Name]);
                }
                ShowPlayerDialogPages(playerid, "DP_TemplatesList", DIALOG_STYLE_LIST, 
                GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "caption"),
                GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("usetemplate", LANG_TYPE_DIALOGS, "button2"),
                EditorMaxDialogItems);
            }
        }
    }
    else ShowEditorEx(playerid, true);
    return 1;
}

/*
  _____                               _     _____    _           _                       
 |  __ \                             | |   |  __ \  (_)         | |                      
 | |__) |   __ _    __ _    ___    __| |   | |  | |  _    __ _  | |   ___     __ _   ___ 
 |  ___/   / _` |  / _` |  / _ \  / _` |   | |  | | | |  / _` | | |  / _ \   / _` | / __|
 | |      | (_| | | (_| | |  __/ | (_| |   | |__| | | | | (_| | | | | (_) | | (_| | \__ \ 
 |_|       \__,_|  \__, |  \___|  \__,_|   |_____/  |_|  \__,_| |_|  \___/   \__, | |___/
                    __/ |                                                     __/ |      
                   |___/                                                     |___/       
*/

DialogPages:DP_ManualVariableChange(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
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
        Dialog_Show(playerid, "D_ManualVariableChange", DIALOG_STYLE_INPUT, 
        GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "caption"), 
        EditorLString, 
        GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "button1"), 
        GetLanguageMessage("manualvarchange", LANG_TYPE_DIALOGS, "button2"));
    }
    return 1;
}

DialogPages:DP_ChangeLanguage2(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new index = Iter_Index(I_LANGUAGES, listitem);
        ChangeEditorLanguage(index);
        SaveConfigurations();
        ShowInfo(playerid, GetLanguageMessage("infolanguagechanged", LANG_TYPE_MESSAGES));
    }
    else ShowEditorEx(playerid);
    return 1;
}

DialogPages:DP_ChangeLanguage1(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new index = Iter_Index(I_LANGUAGES, listitem);
        ChangeEditorLanguage(index);
        SaveConfigurations();

        if(!User[User_InEditor] && EditorLanguage != -1)
            CallNTDCommand(playerid);
    }
    return 1;
}

DialogPages:DP_TemplatesList(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = CreateNewTDFromTemplate(listitem);
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
    return 1;
}

DialogPages:DP_TextDrawList(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Create new TD
            {
                Dialog_Show(playerid, "D_CreateNewTD", DIALOG_STYLE_LIST, 
                GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("newtextdraw", LANG_TYPE_DIALOGS, "button2"));
            }
            default: // Text Draw Select
            {
                new index = Iter_Index(I_TEXTDRAWS, (listitem - 1));
                ShowTDOptions(playerid, index);
            }
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

DialogPages:DP_GroupsList(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        if(User[User_GroupDialogType] == 0) // Groups Manage
        {
            switch(listitem)
            {
                case 0: // Create new project
                {
                    Dialog_Show(playerid, "D_NewGroup", DIALOG_STYLE_INPUT, 
                        GetLanguageMessage("newgroup", LANG_TYPE_DIALOGS, "caption"), 
                        GetLanguageMessage("newgroup", LANG_TYPE_DIALOGS, "infos"), 
                        GetLanguageMessage("newgroup", LANG_TYPE_DIALOGS, "button1"), 
                        GetLanguageMessage("newgroup", LANG_TYPE_DIALOGS, "button2"));
                }
                default: // Group Select
                {
                    new tmp_groupHiddenStr[64];
                    User[User_ChoosenGroupID] = Iter_Index(I_GROUPS, (listitem - 1));
                    format(tmp_groupHiddenStr, 64, Group[ User[User_ChoosenGroupID] ][gr_hidden] ? GetLanguageMessage("texthidden", LANG_TYPE_MESSAGES) : GetLanguageMessage("textvisible", LANG_TYPE_MESSAGES));
                    strins(tmp_groupHiddenStr, Group[ User[User_ChoosenGroupID] ][gr_hidden] ? HEX_PALETTE_3 : HEX_PALETTE_2, 0);

                    ClearDialogListitems(playerid);
                    AddDialogListitem(playerid, GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "info0"));
                    AddDialogListitem(playerid, GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "info1"));
                    AddDialogListitem(playerid, GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "info2", "s", tmp_groupHiddenStr));
                    AddDialogListitem(playerid, GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "info3"));
                    AddDialogListitem(playerid, GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "info4"));

                    new formatedtd[MAXFORMATEDTD];
                    foreach(new i : I_GROUP_TDS[ User[User_ChoosenGroupID] ])
                    {
                        format(formatedtd, MAXFORMATEDTD, TextDraw[i][TD_Text]);
                        if(strlen(TextDraw[i][TD_Text]) > MAXFORMATEDTD - 4)
                        {
                            strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
                            strcat(formatedtd, "...");
                        }
                        AddDialogListitem(playerid, "%s%i "HEX_PALETTE_4"\"%s\"\t%s\t%s\t%s",
                            (i == User[User_EditingTDID] ? HEX_PALETTE_3">{FFFFFF} " : "   "),
                            i, 
                            formatedtd, 
                            GetProcessedTDVarName(i),
                            (TextDraw[i][TD_IsGlobal] ? HEX_PALETTE_2"Global" : HEX_PALETTE_3"Player"),
                            (TextDraw[i][TD_Selectable] ? HEX_PALETTE_2"Yes" : HEX_PALETTE_3"No"));
                    }

                    ShowPlayerDialogPages(playerid, "D_GroupOptions", DIALOG_STYLE_TABLIST_HEADERS, 
                    GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "caption", "is",  User[User_ChoosenGroupID], Group[  User[User_ChoosenGroupID] ][gr_name]), 
                    GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "button1"), 
                    GetLanguageMessage("groupoptions", LANG_TYPE_DIALOGS, "button2"),
                    EditorMaxDialogItems);
                }
            }
            PlayerSelectTD(playerid, false);
        }
        else // Group assign
        {
            new groupid = Iter_Index(I_GROUPS, listitem);
            AssignTextDrawGroup(User[User_ChoosenTDID], groupid);
            ShowTDOptions(playerid, User[User_ChoosenTDID]);
        }
    }
    else ShowEditorEx(playerid);
    return 1;
}

DialogPages:DP_ProjectsList(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        switch(listitem)
        {
            case 0: // Create new project
            {
                Dialog_Show(playerid, "D_NewProject", DIALOG_STYLE_INPUT, 
                GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "caption"), 
                GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("newproject", LANG_TYPE_DIALOGS, "button2"));
            }
            default: // Project Select
            {
                new index = Iter_Index(I_PROJECTS, (listitem - 1));
                User[User_ProjectIndex] = index;
                Dialog_Show(playerid, "D_OpenProject", DIALOG_STYLE_LIST, 
                GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "caption", "s", Projects[index][Pro_fileName]), 
                GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "infos"), 
                GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "button1"), 
                GetLanguageMessage("projectsoptions", LANG_TYPE_DIALOGS, "button2"));
            }
        }
        PlayerSelectTD(playerid, false);
    }
    else ShowEditorEx(playerid);
    return 1;
}

DialogPages:D_OverrideColor(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        EditorCursorColor = Premade_Colors[listitem + 1][0];
        ShowEditorEx(playerid);
    }
    else OnPlayerClickTextDraw(playerid, B_Settings);
    return 1;
}

DialogPages:D_ButtonsColor(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        EditorButtonsColor = Premade_Colors[listitem + 1][0];
        DestroyEditor();
        CreateEditor();
        ShowEditorEx(playerid);
    }
    else OnPlayerClickTextDraw(playerid, B_Settings);
    return 1;
}

DialogPages:DP_SpritesLibrary(DIALOG_PAGES_CALLBACK_PARAMETERS)
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
    return 1;
}

DialogPages:DP_ColorChange3(DIALOG_PAGES_CALLBACK_PARAMETERS)
{
    if(response)
    {
        new tdid = User[User_EditingTDID];
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
    return 1;
}

DialogPages:D_GroupOptions(DIALOG_CALLBACK_PARAMETERS)
{
    new groupId = User[User_ChoosenGroupID];
    if(response)
    {
        switch(listitem)
        {
            case 0: // Change Position
            {
                if(Iter_Count(I_GROUP_TDS[groupId]) > 0)
                {
                    User[User_ChangingState] = CH_BULK_POSITION;
                    EnableVarChangeTimer(true);
                    PlayerSelectTD(playerid, false);
                    HideEditor(playerid);
                }
            }
            case 1: // Change Visibility
            {

            }
            case 2: // Rename
            {

            }
            case 3: // Delete
            {
                
            }
            default:
            {
                new index = Iter_Index(I_GROUP_TDS[groupId], (listitem - 4));
                ShowTDOptions(playerid, index);
            }
        }
    }
    else OpenGroupsDialog(playerid, 0);
    return 1;
}
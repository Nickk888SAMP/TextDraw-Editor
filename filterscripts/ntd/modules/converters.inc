
ConvertNTDLegacy(const filePath[], const toFile[])
{
    new buf[324], File:handle = fopen(filePath, io_read);
    new macro[64], value[258], len, macroId, macroStr[32], convertedAmount;
    if(handle)
    {
        Iter_Clear(I_TEXTDRAWS);
        Iter_Clear(I_GROUPS);
        while(fread(handle, buf))
        {
            len = strlen(buf);
            strdel(buf, (len - 2), len);
            if(!isnull(buf) && sscanf(buf, "P<=>s[64]s[258]", macro, value) == 0)
            {
                strdel(macro, 0, 3);
                if(!isnull(macro) && sscanf(macro, "P<_>is[32]", macroId, macroStr) == 0 && !isnull(macroStr))
                {
                    VALID_ITER_INDEX(I_TEXTDRAWS, macroId)
                    {
                        if(!TextDraw[macroId][TD_Created])
                        {
                            Iter_Add(I_TEXTDRAWS, macroId);
                            TextDraw[macroId][TD_Created] = true;
                        }
                    }
                    else continue;
                    if(!strcmp(macroStr, "string", true))
                    {
                        format(TextDraw[macroId][TD_Text], 328, value);
                    }
                    else if(!strcmp(macroStr, "data", true))
                    {
                        sscanf(value, "ffiiiiffiiiiffiiiiiiffffiiis[35]",
                            TextDraw[macroId][TD_PosX], TextDraw[macroId][TD_PosY], TextDraw[macroId][TD_Font], TextDraw[macroId][TD_IsGlobal],
                            TextDraw[macroId][TD_OutlineSize], TextDraw[macroId][TD_ShadowSize], TextDraw[macroId][TD_LetterSizeX], TextDraw[macroId][TD_LetterSizeY],
                            TextDraw[macroId][TD_Color], TextDraw[macroId][TD_BGColor], TextDraw[macroId][TD_BoxColor], TextDraw[macroId][TD_UseBox], TextDraw[macroId][TD_BoxSizeX], TextDraw[macroId][TD_BoxSizeY],
                            TextDraw[macroId][TD_Selectable], TextDraw[macroId][TD_Alignment], TextDraw[macroId][TD_Proportional], TextDraw[macroId][TD_PrevModelID], TextDraw[macroId][TD_PrevModelC1], 
                            TextDraw[macroId][TD_PrevModelC2], TextDraw[macroId][TD_PrevRotX], TextDraw[macroId][TD_PrevRotY], TextDraw[macroId][TD_PrevRotZ], TextDraw[macroId][TD_PrevRotZoom],
                            TextDraw[macroId][TD_ColorAlpha], TextDraw[macroId][TD_BGColorAlpha], TextDraw[macroId][TD_BoxColorAlpha], TextDraw[macroId][TD_VarName]);
                    }
                    else if(!strcmp(macroStr, "bar_data", true))
                    {
                        sscanf(value, "fi", TextDraw[macroId][TD_BarMaxPercentage], TextDraw[macroId][TD_BarDirectory]);
                    }
                }
            }
        }
        convertedAmount = Iter_Count(I_TEXTDRAWS);
        fclose(handle);
        SaveProject(toFile);
        Iter_Clear(I_TEXTDRAWS);
        return convertedAmount;
    }
    return -1;
}
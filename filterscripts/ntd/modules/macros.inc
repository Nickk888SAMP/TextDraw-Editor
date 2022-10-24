// Is NUll
#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif

// Is Iter index valid
#define VALID_ITER_INDEX(%1,%2) if(%2 >= 0 && %2 < Iter_End(%1))

// Get Argument
#define GetArgStr(%0,%1); \
for (new i_%0 = 0; ; ++i_%0) \
{ \
    if ((%1[i_%0] = getarg((%0), i_%0)) != EOS) \
        continue; \
    else \
        break; \
}

#define DIALOG_CALLBACK_PARAMETERS \
    playerid, response, listitem, const inputtext[]

#define DIALOG_PAGES_CALLBACK_PARAMETERS \
    playerid, response, listitem

// Used inside language message function to search and replace the #1, #2, #3 etc. with the coresponding argument.
#define SEARCH_REPLACE_ARGUMENTS(%1); \ 
	if(args > 4) \
	{ \
		for(new a = 0; a < (args - 4); a++) \
		{ \
			format(tmpArgsMacroStr, 10, "#%i", (a + 1)); \
			strreplace(%1, tmpArgsMacroStr, argumentString[a]); \
		} \
	}

// TextDraw listing single TextDraw format
#define TDLIST_TD_FORMAT \
	new formatedtd[MAXFORMATEDTD], yesnotext[32], typetext[32]; \
	format(typetext, 32, "%s%s", (TextDraw[i][TD_IsGlobal] ? HEX_PALETTE_2 : HEX_PALETTE_3), (TextDraw[i][TD_IsGlobal] ? GetLanguageMessage("textglobal", LANG_TYPE_MESSAGES) : GetLanguageMessage("textplayer", LANG_TYPE_MESSAGES))); \
	format(yesnotext, 32, "%s%s", (TextDraw[i][TD_Selectable] ? HEX_PALETTE_2 : HEX_PALETTE_3), (TextDraw[i][TD_Selectable] ? GetLanguageMessage("textyes", LANG_TYPE_MESSAGES) : GetLanguageMessage("textno", LANG_TYPE_MESSAGES))); \
	format(formatedtd, MAXFORMATEDTD, TextDraw[i][TD_Text]); \
	if(strlen(TextDraw[i][TD_Text]) > MAXFORMATEDTD - 4) \
	{ \
		strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD); \
		strcat(formatedtd, "..."); \
	} \
	AddDialogListitem(playerid, "%s%i %s\"%s\"\t%s\t%s\t%s", \
	(i == User[User_EditingTDID] ? HEX_PALETTE_3">{FFFFFF} " : "   "), \
	i,  \
	(TextDraw[i][TD_Hidden] ? HEX_PALETTE_5 : HEX_PALETTE_4),\
	formatedtd,  \
	GetProcessedTDVarName(i), \
	typetext, \
	yesnotext);

// Buttons Offset
#define BUTTON_POS_X (((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0)) * btns_pos_offset))
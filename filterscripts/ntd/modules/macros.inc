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

// Buttons Offset
#define BUTTON_POS_X (((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0)) * btns_pos_offset))
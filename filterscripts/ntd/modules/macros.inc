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

// Buttons Offset
#define BUTTON_POS_X (((EditorCompactMode) ? (EditorPosX) : (0)) + (BUTTON_TD_SPACER / ((EditorCompactMode) ? (EditorCompactSize) : (1.0)) * btns_pos_offset))
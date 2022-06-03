#if !defined isnull
    #define isnull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))
#endif
#define VALID_ITER_INDEX(%1,%2) if(%2 >= 0 && %2 < Iter_End(%1))
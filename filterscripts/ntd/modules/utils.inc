CreateRGBAWithAlpha(color, a)
	return ((color) << 8) | (a);

CreateAFromRGBA(color)
	return (color & 0x000000FF);

CreateRGBA(r, g, b, a)
	return ((a) & 0xFF) | (((b) & 0xFF) << 8) | (((g) & 0xFF) << 16) | ((r) << 24);

SplitRGBA(color, &r, &g, &b, &a)
{
	r = (color & 0xFF000000) >> 24;
	g = (color & 0x00FF0000) >> 16;
	b = (color & 0x0000FF00) >> 8;
	a = (color & 0x000000FF);
	return 1;
}

strreplace(sstring[], const search[], const replacement[], bool:ignorecase = false, pos = 0, limit = -1, maxlength = sizeof(sstring)) 
{
    if (limit == 0)
        return 0;
    new sublen = strlen(search), replen = strlen(replacement), bool:packed = ispacked(sstring), maxlen = maxlength, len = strlen(sstring), count = 0;
    if (packed)
        maxlen *= 4;
    if (!sublen)
        return 0;
    while (-1 != (pos = strfind(sstring, search, ignorecase, pos))) 
	{
        strdel(sstring, pos, pos + sublen);
        len -= sublen;
        if (replen && len + replen < maxlen) {
            strins(sstring, replacement, pos, maxlength);
            
            pos += replen;
            len += replen;
        }
        if (limit != -1 && ++count >= limit)
            break;
    }
    return count;
}

IsValidString(const string[])
{
	new un[][] = {" ", "!", "?", "=", "$", "§", "'", "´", "^", "°", "/", "*", "+", "~", ".", ","};
	for(new i; i < sizeof un; i++)
		if(strfind(string, un[i][0], true) != -1) return false;
	return true;
}

IsFloat(const buf[])
{
    new l = strlen(buf);
    new dcount = 0;
    for(new i=0; i<l; i++)
    {
        if(buf[i] == '.')
        {
            if(i == 0 || i == l-1) return 0;
            else
            {
                dcount++;
            }
        }
        if((buf[i] > '9' || buf[i] < '0') && buf[i] != '+' && buf[i] != '-' && buf[i] != '.') return 0;
        if(buf[i] == '+' || buf[i] == '-')
        {
            if(i != 0 || l == 1) return 0;
        }
    }
    if(dcount == 0 || dcount > 1) return 0;
    return 1;
}

HexToInt(const string[])
{
	if (string[0]==0) return 0;
    new i;
    new cur=1;
    new res=0;
    for (i=strlen(string);i>0;i--) {
        if (string[i-1]<58) res=res+cur*(string[i-1]-48); else res=res+cur*(string[i-1]-65+10);
        cur=cur*16;
    }
    return res;
}



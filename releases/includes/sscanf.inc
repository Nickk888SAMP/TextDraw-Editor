#if defined _sscanf_included
	#endinput
#endif
#define _sscanf_included


stock sscanf(string[], format[], {Float,_}:...)
 {
 	#if defined isnull
 		if (isnull(string))
 	#else
 		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
 	#endif
  		{
  			return format[0];
  		}
  	#pragma tabsize 4
  	new
  		formatPos = 0,
  		stringPos = 0,
   		paramPos = 2,
  		paramCount = numargs(),
  		delim = ' ';
  	while (string[stringPos] && string[stringPos] <= ' ')
  	{
  		stringPos++;
  	}
  	while (paramPos < paramCount && string[stringPos])
  	{
  		switch (format[formatPos++])
  		{
  			case '\0':
  			{
   				return 0;
  			}
  			case 'i', 'd':
 			{
   				new
  					neg = 1,
  					num = 0,
  					ch = string[stringPos];
 				if (ch == '-')
   				{
  					neg = -1;
  					ch = string[++stringPos];
  				}
  				do
  				{
  					stringPos++;
  					if ('0' <= ch <= '9')
   					{
  						num = (num * 10) + (ch - '0');
  					}
  					else
 					{
   						return -1;
  					}
  				}
 				while ((ch = string[stringPos]) > ' ' && ch != delim);
  				setarg(paramPos, 0, num * neg);
  			}
  			case 'h', 'x':
  			{
  				new
  					num = 0,
 					ch = string[stringPos];
  				do
  				{
 					stringPos++;
  					switch (ch)
   					{
   						case 'x', 'X':
     						{
 	 						num = 0;
 							continue;
 	 					}
 	 				 	  case '0' .. '9':
 	 					{
  	 						num = (num << 4) | (ch - '0');
 						}
 	 					case 'a' .. 'f':
 	 					{
  	 						num = (num << 4) | (ch - ('a' - 10));
 	  					}
 	 					case 'A' .. 'F':
 	 					{
 	 						num = (num << 4) | (ch - ('A' - 10));
 	 					}
 	 					default:
 	 					{
 	 						return -1;
 	 					}
 	 				}
 	 			}
  	 			while ((ch = string[stringPos]) > ' ' && ch != delim);
  	  			setarg(paramPos, 0, num);
  	 		}
   	 		case 'c':
 	 		{
  	 			setarg(paramPos, 0, string[stringPos++]);
  	 		}
 	 		case 'f':
 	 		{

  	 			new changestr[16], changepos = 0, strpos = stringPos;
  	  			while(changepos < 16 && string[strpos] && string[strpos] != delim)
  				{
   	 				changestr[changepos++] = string[strpos++];
      	 			}
 	  			changestr[changepos] = '\0';
  				setarg(paramPos,0,_:floatstr(changestr));
    	 		}
 	 		case 'p':
  	 		{
  				delim = format[formatPos++];
  	 			continue;
  	 		}
  	 		case '\'':
  			{
  	 			new
  	 				end = formatPos - 1,
   	 				ch;
 	 			while ((ch = format[++end]) && ch != '\'') {}
 				if (!ch)
 	 			{
    	 				return -1;
 	 			}
 				format[end] = '\0';
 	 			if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
 	 			{
 	  				if (format[end + 1])
 	 				{
 	 					return -1;
 					}
 	 				return 0;
 	 			}
 	 			format[end] = '\'';
 	 			stringPos = ch + (end - formatPos);
 				formatPos = end + 1;
  	  		}
 	 		case 'u':
 	 		{
 	 			new
 	 				end = stringPos - 1,
 	  				id = 0,
 	 				bool:num = true,
 					ch;
 	 			while ((ch = string[++end]) && ch != delim)
 				{
 	 				if (num)
 	 				{
 	 					if ('0' <= ch <= '9')
 						{
 	 						id = (id * 10) + (ch - '0');
 						}
 	 					else
 						{
 	 						num = false;
 	 					}
 	 				}
 	 			}
 				if (num && IsPlayerConnected(id))
 				{
 	 				setarg(paramPos, 0, id);
 	 			}
 	 			else
 	 			{
 	 				#if !defined foreach
 						#define foreach(%1,%2) for (new %2 = 0; %2 < MAX_PLAYERS; %2++) if (IsPlayerConnected(%2))
 						#define __SSCANF_FOREACH__
 					#endif
 	 				string[end] = '\0';
 	 				num = false;
 	 				new
 	 					name[MAX_PLAYER_NAME];
 	 				id = end - stringPos;
 	 				foreach (Player, playerid)
 					{
 	 					GetPlayerName(playerid, name, sizeof (name));
 	 					if (!strcmp(name, string[stringPos], true, id))
 	 					{
 	 						setarg(paramPos, 0, playerid);
 	 						num = true;
 	 				 		break;
 	 					}
 	 				}
 	 				if (!num)
 	 				{
   						setarg(paramPos, 0, INVALID_PLAYER_ID);
 	 				}
  	 				string[end] = ch;
  	 				#if defined __SSCANF_FOREACH__
 	 					#undef foreach
  	 					#undef __SSCANF_FOREACH__
 	 				#endif
  	 			}
 	 			stringPos = end;
  	 		}
 	 		case 's', 'z':
 	 		{
 				new
    	 				i = 0,
 	 				ch;
  	 			if (format[formatPos])
  	 			{
 	 				while ((ch = string[stringPos++]) && ch != delim)
  	 				{
 	 					setarg(paramPos, i++, ch);
  	 				}
 	 				if (!i)
 	 				{
  	 					return -1;
 	 				}
  	 			}
 	 			else
  				{
  	 				while ((ch = string[stringPos++]))
  	 				{
  	 					setarg(paramPos, i++, ch);
 	 				}
 	 			}
  	 			stringPos--;
 	 			setarg(paramPos, i, '\0');
  	 		}
 	 		default:
 	 		{
 	 			continue;
 	 		}
 	 	}
 	 	while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
  	 	{
  	 		stringPos++;
 	 	}
 	 	while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
 	 	{
 	 		stringPos++;
 	 	}
 	 	paramPos++;
 	 }
  	do
  	 {
 	 	if ((delim = format[formatPos++]) > ' ')
 	 	{
 	 		if (delim == '\'')
 	 		{
 	 			while ((delim = format[formatPos++]) && delim != '\'') {}
  	 		}
 	 		else if (delim != 'z')
 	 		{
 				return delim;
 	 		}
 	 	}
  	}
  	while (delim > ' ');
  	return 0;
 }
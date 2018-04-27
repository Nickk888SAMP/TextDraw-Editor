/*
 *				Dfile 1.1.1
 *	  All right reserved! © By: DrAkE
 *		   Freely redistributable.
 *
 * Owner		: DrAkE
 * Time			: 2012.09.02
 *
 * Thanks to:
 *			ChuckNorris 	- Test, help
 *			Fade 			- Test, help
 *			Y_Less      	- boolstr function
 *			JaTochNietDan 	- FileManager
 *			[S]trong        - Precepts, functions
 *			Thiadmer 		- PAWN.
 *			SA:MP Team past, present, future - SA:MP.
 *
 *
 * Functions:
 *          dfile_Create - Create a file.
 *          dfile_Delete - Delete a file.
 *          dfile_Open - Open a file.
 *          dfile_CreateDirectory - Create a directory.
 *          dfile_DeleteDirectory - Delete a directory.
 *          dfile_DirectoryExists - Check if the directory exists.
 *          dfile_WriteString - Write string to the file.
 *          dfile_WriteInt - Write integer to the file.
 *          dfile_WriteBool - Write a bool integer to the file.
 *          dfile_WriteFloat - Write a float integer to the file.
 *          dfile_MultiSet - Write multi parameter and value to the file.
 *          dfile_MultiGet - Get multi parameter and value from the file.
 *          dfile_ReadString - Read a string from the file.
 *          dfile_ReadInt - Read an integer from the file.
 *          dfile_ReadFloat - Read a float integer from the file.
 *          dfile_MoveFile - Move a file to the destination.
 *          dfile_RenameFile - Rename a file.
 *          dfile_SaveFile - Write the cache to the file.
 *          dfile_FileExists - Check if the file exists.
 *          dfile_ParseString - Check if the parameter and the string is equal.
 *          dfile_ParseInt - Check if the parameter and the integer is equal.
 *          dfile_ParseFloat - Check if the parameter and the float is equal.
 *          dfile_ParseBool - Check if the parameter and the bool is equal.
 *          dfile_IsSet - Check if the parameter has value.
 *          dfile_UnSet - Delete the parameter's value.
 *
 * Update:
 *      2011/01/28:
 *          New functions: 	- dfile_FileExists
 *                       	- dfile_DirectoryExists
 *
 *		2011/01/29:
 *          New functions: 	- dfile_RenameFile
 *   	 Functions update: 	- dfile_ReadString - don't need the file name.
 *                       	- dfile_Open - need when you write or read from a file.
 *
 *      2011/02/01:
 *          New functions: 	- dfile_IsSet
 *                       	- dfile_UnSet
 *
 *      2011/09/10:
 *          New functions: 	- dfile_MultiSet
 *                       	- dfile_MultiGet
 *
 *          Other:       	- Faster :)
 *
 *      2012/02/04:
 *          Other:       	- don't need plugin anymore!
 *
*/
#if defined _dfile_included
  #endinput
#endif
#define _dfile_included

#if defined USE_PLUGIN_FUNCTIONS
	native file_move(file[],destination[]);
	native file_delete(file[]);
	native file_create(file[]);
	native file_write(file[],text[],mode[] = "a");
	native file_read(file[],storage[], size = sizeof(storage));
	native file_log();
	native file_exists(file[]);
	native dir_create(directory[]);
	native dir_delete(directory[]);
	native dir_exists(directory[]);
#endif

/*
native dfile_Create(fajl[]);
native dfile_Delete(fajl[]);
native dfile_Open(fajl[]);
native dfile_CreateDirectory(mappa[]);
native dfile_DeleteDirectory(mappa[]);
native dfile_DirectoryExists(mappa[]);
native dfile_WriteString(parameter[], ertek[]);
native dfile_WriteInt(parameter[], ertek[]);
native dfile_WriteBool(parameter[], bool:ertek);
native dfile_WriteFloat(parameter[], Float.ertek);
native dfile_MultiSet(tipusok[],{Float,_}:...);
native dfile_MultiGet(tipusok[],{Float,_}:...);
native dfile_ReadString(parameter[]);
native dfile_ReadInt(parameter[]);
native dfile_ReadFloat(parameter[]);
native dfile_ReadBool(parameter[]);
native dfile_MoveFile(fajl[], cel[]);
native dfile_RenameFile(reginev[], ujnev[]);
native dfile_SaveFile();
native dfile_FileExists(fajl[]);
native dfile_ParseString(parameter[], ertek[]);
native dfile_ParseInt(parameter[], ertek[]);
native dfile_ParseFloat(parameter[], Float:ertek);
native dfile_ParseBool(parameter[], bool:ertek);
native dfile_IsSet(parameter[]);
native dfile_UnSet(parameter[]);
*/

#define dfile_ReadFloat(%1) floatstr(dfile_ReadString(%1))
#define dfile_ReadInt(%1) strval(dfile_ReadString(%1))
#define dfile_ReadBool(%1) boolstr2(dfile_ReadString(%1))
#define dfile_DirectoryExists(%1) dir_exists(%1)
#define dfile_WriteString(%0,%1) dfile_AddToBuffer(%0,%1)

#if !defined strcpyy
	#define strcpyy(%0,%1,%2)                strcat((%0[0] = EOS, %0), %1, %2 + 1)
#endif

#define MAX_PARAMETER_SIZE (0x80)
#define MAX_ERTEK_SIZE (0x100)
#define FILE_NAME (0x40)
#define MAX_LINES (0x3E8)

static stock  
		fajlnev[FILE_NAME],
		paramtar[MAX_PARAMETER_SIZE],
		formazas[512+3],
		olvasas[512],
        File:fajlmegnyitas,
        File:celfajl,
        eredmeny[256],
        sorokszama = 0;

static stock
        parameternek[MAX_LINES],
		param[MAX_LINES][MAX_PARAMETER_SIZE],
		ert[MAX_LINES][MAX_ERTEK_SIZE];

stock bool:boolstr2(string[]){
	if (!string[0] || string[0] == '0' || !strcmp(string, "false", true)) return false;
	return true;
}

stock dfile_Create(fajl[]){
	#if defined USE_PLUGIN_FUNCTIONS
		format(formazas, sizeof(formazas), "scriptfiles/%s", fajl);
		if(file_exists(formazas)) return false;
		file_create(formazas);
	#else
	    if(fexist(fajl)) return false;
		fclose(fopen(fajl, io_write));
	#endif
	return true;
}

stock dfile_FileExists(fajl[]){
	#if defined USE_PLUGIN_FUNCTIONS
		format(formazas, sizeof(formazas), "scriptfiles/%s", fajl);
		return file_exists(formazas);
	#else
	    return fexist(fajl);
	#endif
}

stock dfile_Delete(fajl[]){
	#if defined USE_PLUGIN_FUNCTIONS
		format(formazas, sizeof(formazas), "scriptfiles/%s", fajl);
		if(!file_exists(formazas)) return false;
		file_delete(formazas);
	#else
	    if(!fexist(fajl)) return false;
	    fremove(fajl);
	#endif
	return true;
}

stock dfile_ReadString(parameter[]){
	new
		i = 0x0;
	for(; i < sorokszama; ++i)
	{
	    if(strcmp(param[i], parameter, false)) continue;
	    return ert[i];
	}
	eredmeny[0] = EOS;
	return eredmeny;
}

stock dfile_Open(fajl[])
{
	new
		sorokszama2 = 0x-1,
	    talalat;
    olvasas[0] = EOS;
	fajlmegnyitas = fopen(fajl,io_read);
    while(fread(fajlmegnyitas, olvasas))
	{
     	talalat = strfind(olvasas, "=", false);
     	strmid(param[++sorokszama2], olvasas, 0, talalat);
     	strmid(ert[sorokszama2], olvasas, talalat+1, strfind(olvasas, "\r\n", false));
		parameternek[sorokszama2] = dfile_HashString(param[sorokszama2]);
	}
	sorokszama = (sorokszama2 + 1);
    fclose(fajlmegnyitas);
    format(fajlnev,FILE_NAME,"%s",fajl);
}

stock dfile_HashString(buffer[])
{
	new totalContado = 0, i = strlen(buffer);
	while(i-- != 0) totalContado += buffer[i];
	return totalContado;
}

stock dfile_WriteInt(parameter[], ertek){
	new intvalue[MAX_ERTEK_SIZE];
	format(intvalue, sizeof(intvalue), "%d", ertek);
	return dfile_AddToBuffer(parameter, intvalue);
}

stock dfile_WriteBool(parameter[], bool:ertek){
    if(ertek) dfile_AddToBuffer(parameter, "true");
	else dfile_AddToBuffer(parameter, "false");
	return true;
}

stock dfile_WriteFloat(parameter[], Float:ertek){
	new floatvalue[MAX_ERTEK_SIZE];
	format(floatvalue, sizeof(floatvalue), "%f", ertek);
	return dfile_AddToBuffer(parameter, floatvalue);
}

stock dfile_AddToBuffer(parameter[], ertek[])
{
	new i, valami = dfile_HashString(parameter);
	for( ;  i != sorokszama ; ++i) if(valami == parameternek[i])
	{
		if(strcmp(param[i], parameter, false)) continue;
		return strcpyy(ert[i], ertek, MAX_ERTEK_SIZE);
	}
	parameternek[i]=valami;
	return strcpyy(param[i], parameter, MAX_PARAMETER_SIZE), strcpyy(ert[i], ertek, MAX_ERTEK_SIZE), sorokszama++, true;
}

stock dfile_MultiSet(tipusok[],{Float,_}:...)
{
	new
		i = 0x-1;
    while(++i<strlen(tipusok))
    {
        new l = 0x-1,
            iLoop = -1,
            string2[512];
        while(++l<MAX_PARAMETER_SIZE) paramtar[l] = getarg(1 + (i * 2), l);
        switch(tipusok[i])
        {
			case 'b': dfile_WriteBool(paramtar, bool:getarg(2 + (i * 2)));
			case 'd', 'i': dfile_WriteInt(paramtar, getarg(2 + (i * 2)));
			case 'f': dfile_WriteFloat(paramtar, Float:(getarg(2 + (i * 2))));
			case 's':
			{
				while((++iLoop != MAX_ERTEK_SIZE)) string2[iLoop] = getarg(2 + (i * 2), iLoop);
				dfile_WriteString(paramtar, string2);
 			}
		}
	}
	return false;
}

stock dfile_MultiGet(tipusok[],{Float,_}:...)
{
    new
		i = 0x-1;
    while(++i<strlen(tipusok))
    {
        new
			l = 0x-1,
			iLoop = 0x-1;
        while(++l<MAX_PARAMETER_SIZE) paramtar[l] = getarg(1 + (i * 2), l);
        switch(tipusok[i])
	    {
	        case 'b': setarg(2+(i*2), 0, boolstr2(dfile_ReadString(paramtar)));
			case 'd', 'i': setarg(2+(i*2), 0, strval(dfile_ReadString(paramtar)));
			case 'f': setarg(2+(i*2), 0, _:floatstr(dfile_ReadString(paramtar)));
			case 's':
			{
				format(formazas,sizeof(formazas),"%s",dfile_ReadString(paramtar));
				while((strlen(dfile_ReadString(paramtar)) != iLoop++)) setarg(2+(i*2),iLoop,formazas[iLoop]);
  			}
			default: return print("dFile Error: Unknown type definition!"), 0;
		}
    }
	return true;
}

stock dfile_CloseFile(){
	new
		i = -1;
	for(; ++i != sorokszama ;)
	{
		param[i][0] = EOS;
		ert[i][0] = EOS;
		parameternek[i] = 0;
	}
	return sorokszama = 0;
}

stock dfile_SaveFile()
{
	new
		iLoop = -1;
    fajlmegnyitas = fopen(fajlnev, io_write);
    while(++iLoop != sorokszama)
    {
        if(strlen(param[iLoop]) > 0)
		{
	        format(formazas, sizeof(formazas), "%s=%s\r\n", param[iLoop], ert[iLoop]);
	    	fwrite(fajlmegnyitas, formazas);
		}else break;
	}
    return fclose(fajlmegnyitas);
}

#if defined USE_PLUGIN_FUNCTIONS
	stock dfile_CreateDirectory(mappa[]){
		format(formazas, sizeof(formazas), "scriptfiles/%s", mappa);
		if(dir_exists(formazas)) return false;
		dir_create(formazas);
		return true;
	}

	stock dfile_DeleteDirectory(mappa[]){
		format(formazas, sizeof(formazas), "scriptfiles/%s", mappa);
		if(!dir_exists(formazas)) return false;
		dir_delete(formazas);
		return true;
	}
#endif

stock dfile_RenameFile(reginev[], ujnev[]){
	#if defined USE_PLUGIN_FUNCTIONS
		new formazas2[MAX_PARAMETER_SIZE];
		format(formazas, sizeof(formazas), "scriptfiles/%s", reginev);
		if(!file_exists(formazas)) return false;
		format(formazas2, sizeof(formazas2), "scriptfiles/%s", ujnev);
		return file_move(formazas, formazas2);
	#else
	    dfile_MoveFile(reginev, ujnev);
	#endif
}

stock dfile_MoveFile(fajl[], cel[]){
	#if defined USE_PLUGIN_FUNCTIONS
		format(formazas, sizeof(formazas), "scriptfiles/%s", fajl);
		if(!file_exists(formazas)) return false;
		file_move(formazas, cel);
	#else
	    if(!fexist(fajl)) return false;
		dfile_Create(cel);
	    fajlmegnyitas = fopen(fajl, io_read);
	    celfajl = fopen(cel, io_write);
	    while(fread(fajlmegnyitas, olvasas)) fwrite(celfajl, olvasas);
	    fclose(fajlmegnyitas);
	    fclose(celfajl);
	    fremove(fajl);
	#endif
	return true;
}

stock dfile_ParseString(parameter[], ertek[]){
	format(formazas, sizeof(formazas), "%s", dfile_ReadString(parameter));
	if(strval(dfile_ReadString(parameter)) == strval(ertek)) return true;
 	else return false;
}

stock dfile_ParseInt(parameter[], ertek){
    new intvalue[MAX_PARAMETER_SIZE];
	format(intvalue, sizeof(intvalue), "%d", ertek);
	return dfile_ParseString(parameter, intvalue);
}

stock dfile_ParseFloat(parameter[], Float:ertek){
    new floatvalue[MAX_PARAMETER_SIZE];
	format(floatvalue, sizeof(floatvalue), "%f", ertek);
	return dfile_ParseString(parameter, floatvalue);
}

stock dfile_ParseBool(parameter[], bool:ertek){
    new boolean;
    if(ertek) boolean = dfile_ParseString(parameter, "true");
	else boolean = dfile_ParseString(parameter, "false");
 	return boolean;
}

stock dfile_IsSet(parameter[]){
	if(!strlen(dfile_ReadString(parameter))) return false;
	else return true;
}

stock dfile_UnSet(parameter[]){
    new
		i = 0x-1;
	for( ; ++i != sorokszama ; )
	{
		if(!strcmp(param[i], parameter, false))
		{
			return ert[i][0] = EOS;
		}
	}
	return true;
}

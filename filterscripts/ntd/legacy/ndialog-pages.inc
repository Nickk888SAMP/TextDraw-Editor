/**********************************************************************************************************************************
!!!!! Please don't change the authors name! Every script is a rarity! So please be so kind and DON'T remove this license! !!!!!
**********************************************************************************************************************************

Script: NDialog-Pages
Type: Include
Version: 1.5
Author: Nickk888
Date: 22.04.2020

Social Media:
YouTube: https://www.youtube.com/channel/UCvjbpjJXET1QS9Wa0_XVCuw
Facebook: https://www.facebook.com/Nickk888FP/

___Description___
NDialog-Pages is basically an addon that adds 3 additional options to the "ShowPlayerDialog" function.
It will add a feature so that you can split the dialog list into multiple pages!

It will basically calculate how many items will fit into one page and generate the "Next" button
if there are too many. It will also add a "Back" button if you go to the second page etc.
It will calculate the "listitem" in such way, like a normal list would work, so you don't need to
make some calculation yourself, everything is automatic and it will return the correct "listitem".

It is VERY easy to use, because everything is fully automatic.

___Functions___
ShowPlayerDialog(playerid, dialogid, style, caption[], info[], button1[], button2[], items_per_page = 0, nextbutton[] = "{FF0000}>>>", backbutton[] = "{FF0000}<<<");

___How to Use___
To make the dialog split the items into multiple pages, you will need to first set the "items_per_page" parameter > 0.
"items_per_page" will tell the dialog, how many items will fit into ONE page!
Set it to 10, it will show you 10 items plus the "Next" and "Back" button.
You can also modify the buttons yourself, just set the "nextbutton" and or "backbutton" parameter, but that's optional.
Also check if "listitem" is NOT "-2" or "INVALID_LISTITEM", it will be invalid if the player will press the "Next" or "Back" button, so please negate it!

You can also add "#curpage", "#maxpage", "#nextpage" and "#prevpage" into the dialog strings to add additional informations into the dialog.


**********************************************************************************************************************************
!!!!! Please don't change the authors name! Every script is a rarity! So please be so kind and DON'T remove this license! !!!!!
**********************************************************************************************************************************/

#include <YSI_Coding\y_hooks> //By Y_Less | Thank you, great include <3

//Defines
#define INVALID_LISTITEM -2
#define DIALOG_MAX_STRING_SIZE 5000

//Enumerators
enum ndialogpages_data
{
	bool:ndp_isstylepage,
	ndp_amount,
	ndp_amountperpage,
	ndp_index[500],
	ndp_page,
	ndp_itemsonpage,
	ndp_string[DIALOG_MAX_STRING_SIZE],
	ndp_header[300],
	ndp_caption[300],
	ndp_button1[24],
	ndp_button2[24],
	ndp_nextbutton[64],
	ndp_backbutton[64],
	ndp_style,
	ndp_maxpage,
	ndp_dialogid
};
new NDP_P[MAX_PLAYERS][ndialogpages_data];

//Functions/Stocks
forward ndialog_pages_ShowPlayerDialog(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[], items_per_page = 0, const nextbutton[] = "{FF0000}>>>", const backbutton[] = "{FF0000}<<<");
stock ndialog_pages_ShowPlayerDialog(playerid, dialogid, style, const caption[], const info[], const button1[], const button2[], items_per_page = 0, const nextbutton[] = "{FF0000}>>>", const backbutton[] = "{FF0000}<<<")
{
	if(items_per_page > 0) NDP_P[playerid][ndp_isstylepage] = true;
	else NDP_P[playerid][ndp_isstylepage] = false;
	//Checking
	if(NDP_P[playerid][ndp_isstylepage])
	{
		if(strlen(info) > DIALOG_MAX_STRING_SIZE) 
			return print("[ndialog-pages] Dialog string limit exceeded! Will refuse open dialog.");
		if(style == DIALOG_STYLE_INPUT || style == DIALOG_STYLE_PASSWORD ||style == DIALOG_STYLE_MSGBOX) 
			return print("[ndialog-pages] Dialog style is invalid, pages will only work properly on lists.");
		
		new ndp_line1;
		new ndp_lister;
		new ndp_amountex;
		format(NDP_P[playerid][ndp_string], DIALOG_MAX_STRING_SIZE, "%s\n", info);
		//Getting the header of the TABLIST_HEADERS
		if(style == DIALOG_STYLE_TABLIST_HEADERS)
		{
			new ndp_line3 = strfind(NDP_P[playerid][ndp_string], "\n", true);
			if(ndp_line3 != -1)
			{
				strmid(NDP_P[playerid][ndp_header], NDP_P[playerid][ndp_string], 0, ndp_line3 + 1, 300);
				strdel(NDP_P[playerid][ndp_string], 0, ndp_line3 + 1);
			}
		}
		//Preparing the list without the "\n"
		for(;;)
		{
			new ndp_line2;
			ndp_line2 = strfind(NDP_P[playerid][ndp_string], "\n", true);
			if(ndp_line2 != -1)
			{
				NDP_P[playerid][ndp_index][ndp_amountex] = ndp_line1;
				ndp_amountex++;
				strdel(NDP_P[playerid][ndp_string], ndp_line2, ndp_line2 + 1);
				ndp_line1 = ndp_line2;
				ndp_lister++;
			}
			else 
			{
				NDP_P[playerid][ndp_index][ndp_amountex] = strlen(NDP_P[playerid][ndp_string]);
				break;
			}
		}
		//Saving all data to the enumerator
		NDP_P[playerid][ndp_dialogid] = dialogid;
		NDP_P[playerid][ndp_style] = style;
		NDP_P[playerid][ndp_page] = 0;
		NDP_P[playerid][ndp_amount] = ndp_amountex;
		NDP_P[playerid][ndp_amountperpage] = items_per_page;
		NDP_P[playerid][ndp_maxpage] = floatround(float(NDP_P[playerid][ndp_amount]) / float(NDP_P[playerid][ndp_amountperpage]), floatround_ceil); //A little bit buggy... But works most of the time :P
		format(NDP_P[playerid][ndp_button1], 24, button1);
		format(NDP_P[playerid][ndp_button2], 24, button2);
		format(NDP_P[playerid][ndp_caption], 300, caption);
		format(NDP_P[playerid][ndp_nextbutton], 64, nextbutton);
		format(NDP_P[playerid][ndp_backbutton], 64, backbutton);
		//Show
		NDP_ShowDialogPage(playerid, NDP_P[playerid][ndp_page]);
	}
	else ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2); //Default
	return 1;
}

//This will search and replace the hashtags with the variables
stock NDP_ReplaceDialogParamsString(playerid, const ndpstring[]) 
{
	new ndp_tmp_str[500], ndp_tmp_str2[15];
	format(ndp_tmp_str, 500, ndpstring);
	for(;;)
	{
		new ndp_line;
		ndp_line = strfind(ndp_tmp_str, "#curpage", true); //Current Page
		if(ndp_line != -1)
		{
			strdel(ndp_tmp_str, ndp_line, ndp_line + 8);
			format(ndp_tmp_str2, 15, "%i", NDP_P[playerid][ndp_page] + 1);
			strins(ndp_tmp_str, ndp_tmp_str2, ndp_line);
		}
		ndp_line = strfind(ndp_tmp_str, "#maxpage", true); //Max available pages
		if(ndp_line != -1)
		{
			strdel(ndp_tmp_str, ndp_line, ndp_line + 8);
			format(ndp_tmp_str2, 15, "%i", NDP_P[playerid][ndp_maxpage]);
			strins(ndp_tmp_str, ndp_tmp_str2, ndp_line);
		}
		ndp_line = strfind(ndp_tmp_str, "#nextpage", true); //Next page
		if(ndp_line != -1)
		{
			strdel(ndp_tmp_str, ndp_line, ndp_line + 9);
			format(ndp_tmp_str2, 15, "%i", (NDP_P[playerid][ndp_page] + 1) + 1);
			strins(ndp_tmp_str, ndp_tmp_str2, ndp_line);
		}
		ndp_line = strfind(ndp_tmp_str, "#prevpage", true); //previous page
		if(ndp_line != -1)
		{
			strdel(ndp_tmp_str, ndp_line, ndp_line + 9);
			format(ndp_tmp_str2, 15, "%i", (NDP_P[playerid][ndp_page] - 1) + 1);
			strins(ndp_tmp_str, ndp_tmp_str2, ndp_line);
		}
		if(ndp_line == -1) break; //Exit the loop if nothing found.
	}
	return ndp_tmp_str;
}

//This will generate and show the dialog with page, please don't use this stock! It's dependent with the enumerator's information!
stock NDP_ShowDialogPage(playerid, ndppage)
{
	new ndp_tmp_string[1000], ndp_tmp_string2[128];
	new ndp_lister, ndp_listerindex, bool:b_created;
	//Is the dialog TABLIST_HEADERS? If so, generate the header.
	if(NDP_P[playerid][ndp_style] == DIALOG_STYLE_TABLIST_HEADERS)
		strcat(ndp_tmp_string, NDP_P[playerid][ndp_header]);
	//Generating the list
	for(new i = (NDP_P[playerid][ndp_amountperpage] * ndppage); i < (NDP_P[playerid][ndp_amount]); i++)
	{
		ndp_listerindex = (NDP_P[playerid][ndp_amountperpage] * ndppage) + ndp_lister;
		if(ndp_lister < NDP_P[playerid][ndp_amountperpage])
		{
			strmid(ndp_tmp_string2, NDP_P[playerid][ndp_string], NDP_P[playerid][ndp_index][ndp_listerindex], NDP_P[playerid][ndp_index][ndp_listerindex + 1]);
			strcat(ndp_tmp_string, ndp_tmp_string2);
			strcat(ndp_tmp_string, "\n");
			ndp_lister++;
			continue;
		}
		else if(ndp_listerindex < (NDP_P[playerid][ndp_amount]))
		{
			strcat(ndp_tmp_string, NDP_P[playerid][ndp_nextbutton]);
			if(ndppage > 0)
				strcat(ndp_tmp_string, "\n"), strcat(ndp_tmp_string, NDP_P[playerid][ndp_backbutton]), b_created = true;
			break;
		}
	}
	NDP_P[playerid][ndp_itemsonpage] = ndp_lister;
	if(ndp_listerindex == (NDP_P[playerid][ndp_amount] - 1) && !b_created)
	{
		if(ndppage > 0)
			strcat(ndp_tmp_string, NDP_P[playerid][ndp_backbutton]);
	}
	//Search for hashtags and replace them with information
	format(ndp_tmp_string2, 128, NDP_ReplaceDialogParamsString(playerid, NDP_P[playerid][ndp_caption]));
	format(ndp_tmp_string, 1000, NDP_ReplaceDialogParamsString(playerid, ndp_tmp_string));
	//Show
	ShowPlayerDialog(playerid, NDP_P[playerid][ndp_dialogid], NDP_P[playerid][ndp_style], ndp_tmp_string2, ndp_tmp_string, NDP_P[playerid][ndp_button1], NDP_P[playerid][ndp_button2]);
	return 1;
}

//Callback hooking
hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == NDP_P[playerid][ndp_dialogid] && NDP_P[playerid][ndp_isstylepage])
	{
		new ndp_tmplistitem = (NDP_P[playerid][ndp_amountperpage] * NDP_P[playerid][ndp_page]) + listitem;
		if(ndp_tmplistitem < (NDP_P[playerid][ndp_amount]))
		{
			if(listitem == (NDP_P[playerid][ndp_itemsonpage])) //Button "Next"
			{
				NDP_P[playerid][ndp_page]++;
				if(response) NDP_ShowDialogPage(playerid, NDP_P[playerid][ndp_page]);
				listitem = INVALID_LISTITEM;
			}
			else if(listitem == (NDP_P[playerid][ndp_itemsonpage] + 1)) //Button "Back"
			{
				NDP_P[playerid][ndp_page]--;
				if(response) NDP_ShowDialogPage(playerid, NDP_P[playerid][ndp_page]);
				listitem = INVALID_LISTITEM;
			}
			else listitem = ndp_tmplistitem; //Normal item
		}
		else
		{
			//Also button "Back", but on the last page
			NDP_P[playerid][ndp_page]--;
			if(response) NDP_ShowDialogPage(playerid, NDP_P[playerid][ndp_page]);
			listitem = INVALID_LISTITEM;
		}
	}
	return 0;
}

// ALS Hooking
#if defined _ALS_ShowPlayerDialog
    #undef ShowPlayerDialog
#else
    #define _ALS_ShowPlayerDialog
#endif
#define ShowPlayerDialog ndialog_pages_ShowPlayerDialog
//
/********************************************************************
*	Nickk's TextDraw editor											*
*	Release: Beta 1.0												*
*	All right reserved! C By: Nickk888								*
*																	*
*	Credits:														*
*	a_samp: SAMP Team												*
*	zcmd: ZeeX														*
*	dfile: DrAkE													*
*	rgb: Abyss Morgan												*
*	sscanf: Y_Less													*
*	a_http: SAMP Team												*
*																	*
*	YOU ARE NOT ALLOWED TO RECREATE THIS FILTERSCRIPT WITHOUT		*
*	GIVEN ANY CREDITS! DO NOT COPY THIS SCRIPT ELSEWHERE!			*
*********************************************************************/

#include <a_samp>
#include <zcmd>
#include <dfile>
#include <rgb>
#include <a_http>
#include <sscanf>

//SETTINGS
#define SCRIPT_VERSION "v1.0 Beta"
#define MAX_PROJECTS 	50
#define MAX_TDS			100
#define BUTTON_SIZE		35.5
#define BUTTON_SPACER	35.5
#define BUTTON_HEIGHT	412
#define CHANGING_VAR_TIME 50
#define SCRIPT_VERSION_CHECK "1.0"
#define CURSOR_COLOR 0xFF0000FF

//#define DEBUGMODE

//TEXT
#define CAPTION_TEXT "{00FFFF}Nickk's TD Editor - {00FF00}"

//RESOURCE NAMES
#define BUTTON_NEW_ACTIVE "NTD_RESOURCES:Button_New_Active"

#define BUTTON_OPEN_ACTIVE "NTD_RESOURCES:Button_Open_Active"

#define BUTTON_CLOSE_ACTIVE "NTD_RESOURCES:Button_Close_Active"

#define BUTTON_EXPORT_ACTIVE "NTD_RESOURCES:Button_Export_Active"

#define BUTTON_MANAGE_ACTIVE "NTD_RESOURCES:Button_Manage_Active"

#define BUTTON_FONT_ACTIVE "NTD_RESOURCES:Button_Font_Active"

#define BUTTON_POSITION_ACTIVE "NTD_RESOURCES:Button_Position_Active"

#define BUTTON_SIZE_ACTIVE "NTD_RESOURCES:Button_Size_Active"

#define BUTTON_TEKST_ACTIVE "NTD_RESOURCES:Button_Tekst_Active"

#define BUTTON_COLOR_ACTIVE "NTD_RESOURCES:Button_Color_Active"

#define BUTTON_OUTLINE_ACTIVE "NTD_RESOURCES:Button_Outline_Active"

#define BUTTON_SHADOW_ACTIVE "NTD_RESOURCES:Button_Shadow_Active"

#define BUTTON_USEBOX_ACTIVE "NTD_RESOURCES:Button_UseBox_Active"

#define BUTTON_ALIGNMENT_ACTIVE "NTD_RESOURCES:BUTTON_ALLIGMENT_ACTIVE"

#define BUTTON_SWITCHPUBLIC_ACTIVE "NTD_RESOURCES:Button_SwitchPublic_Active"

#define BUTTON_SELECTABLE_ACTIVE "NTD_RESOURCES:Button_Selectable_Active"

#define BUTTON_PROPORTIONALITY_ACTIVE "NTD_RESOURCES:Button_Proportionality_Active"

#define BUTTON_MPREVIEW_ACTIVE "NTD_RESOURCES:Button_MPreview_Active"

//DIALOGS
#define DIALOG_NEW 510
#define DIALOG_OPEN 511
#define DIALOG_MANAGE 512
#define DIALOG_MANAGE2 513
#define DIALOG_FONT 514
#define DIALOG_TEKST 515
#define DIALOG_COLOR1 516
#define DIALOG_COLOR2 517
#define DIALOG_COLOR3 518
#define DIALOG_COLOR4 519
#define DIALOG_COLOR5 520
#define DIALOG_COLOR6 521
#define DIALOG_COLOR7 522
#define DIALOG_WIELKOSC 523
#define DIALOG_OPEN2 524
#define DIALOG_EXPORT 525
#define DIALOG_INFO 526
#define DIALOG_PREVIEWMODEL 527
#define DIALOG_PREVIEWMODEL1 528

new Text:E_Box;
new Text:B_NewActive;
new Text:B_OpenActive;
new Text:B_CloseActive;
new Text:B_ExportActive;
new Text:B_ManageActive;
new Text:B_FontActive;
new Text:B_PositionActive;
new Text:B_SizeActive;
new Text:B_TekstActive;
new Text:B_ColorActive;
new Text:B_OutlineActive;
new Text:B_ShadowActive;
new Text:B_UseBoxActive;
new Text:B_AlignmentActive;
new Text:B_SwitchPublicActive;
new Text:B_SelectableActive;
new Text:B_ProportionalityActive;
new Text:B_MPreviewActive;

new bool:ScriptActive;

new PremadeColor[][] =
{
	{0xFFFFFFFF, "Bialy"},
	{0x000000FF, "Czarny"},
	{0xFF0000FF, "Czerwony"},
	{0x0000FFFF, "Niebieski"},
	{0x00FF00FF, "Zielony"},
	{0xFFFF00FF, "Zolty"},
	{0x00FFFFFF, "Cyan"},
	{0xFF8000FF, "Pomaranczowy"},
	{0xFF80FFFF, "Rozowy"},
	{0x800000FF, "Brazowy"}
};

enum TD
{
	bool:tdCreated,
	bool:UseBox,
	bool:Selectable,
	bool:Proportional,
	Text:tdself,
	tdstring[300],
	Float:PosX,
	Float:PosY,
	PrevModel,
	PrevModelC1,
	PrevModelC2,
	Float:PrevRotX,
	Float:PrevRotY,
	Float:PrevRotZ,
	Float:PrevRotZoom,
	Font,
	bool:isPublic,
	OutlineSize,
	ShadowSize,
	Alignment,
	Float:LetterSizeX,
	Float:LetterSizeY,
	Float:BoxSizeX,
	Float:BoxSizeY,
	Color,
	BGColor,
	BoxColor
}
new NTD[MAX_TDS][TD];

enum NTDPlayerData
{
	bool:InEditor,
	bool:ProjectOpened,
	bool:ChangingPosition,
	bool:ChangingMRotation,
	bool:ChangingMZoom,
	bool:ChangingSize,
	bool:ChangingColor,
	bool:Accelerate,
	OnList,
	ChangingSizeState,
	ChangingVarsTimer,
	CursorTimer,
	ProjectName[128],
	playerIDInEditor,
	ChoosenTDID,
	EditingTDID,
	ChangingColorState,
	CCombinatorR,
	CCombinatorG,
	CCombinatorB,
	CCombinatorA,
	IsOnPage
}
new NTDPlayer[NTDPlayerData];

enum TDListData
{
	proname[128]
}
new TDList[MAX_PROJECTS][TDListData];

new TDAdress[MAX_TDS];
public OnFilterScriptInit()
{
	if(dfile_FileExists("/NTD") && dfile_FileExists("/NTD/Exports") && dfile_FileExists("/NTD/Projects"))
	{
		ScriptActive = true;
		printf("\n[NTD]Edytor TextDrawow od Nickk888 %s zostal pomyslnie zinicjalizowany!", SCRIPT_VERSION);
		printf("[NTD]Dziekuje za skorzystanie z mojego skryptu :)");
		printf("[NTD]Wszelkie bledy prosze zglosic na ponizszy E-Mail:");
		printf("[NTD]kevinnickk888@gmail.com\n");
	}
	else
	{
		ScriptActive = false;
		printf("\n[NTD ERROR]Nie mozna bylo odnalezc folder lub foldery!");
		printf("[NTD ERROR]Prosze stworzyc folder 'NTD' wewnatrz 'scriptfiles'!");
		printf("[NTD ERROR]Wewnatrz 'NTD' nalezy stworzyc folder 'Exports' i 'Projects'!");
		printf("[NTD ERROR]Skrypt zostanie zablokowany!\n");
	}
	HTTP(-1, HTTP_GET, "samp-scripters.pl/Nickk888SAMP/ntd_version.txt", "", "HTTPVersionCheck");
	return 1;
}

new tdamount;
new projamount;

public OnPlayerDeath(playerid, killerid)
{
	if(NTDPlayer[InEditor] == true) 
			if(NTDPlayer[playerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnPlayerDisconnect(playerid)
{
	if(NTDPlayer[InEditor] == true) 
			if(NTDPlayer[playerIDInEditor] == playerid)
				cmd_ntd(playerid, " ");
	return 1;
}

public OnFilterScriptExit()
{
	for(new i; i <= GetPlayerPoolSize(); i++) 
	{
		if(NTDPlayer[InEditor] == true) 
			if(NTDPlayer[playerIDInEditor] == i)
			{
				cmd_ntd(i, " ");
				ShowPlayerDialog(i, -1, DIALOG_STYLE_MSGBOX, "", "", "", "");
			}
	}
	return 1;
}

CMD:ntd(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		if(ScriptActive)
		{
			if(NTDPlayer[InEditor] == false)
			{
				CreateEditor();
				NTDPlayer[InEditor] = true;
				NTDPlayer[ChangingPosition] = false;
				NTDPlayer[ProjectOpened] = false;
				NTDPlayer[ChangingSize] = false;
				NTDPlayer[playerIDInEditor] = playerid;
				NTDPlayer[ChoosenTDID] = -1;
				NTDPlayer[EditingTDID] = -1;
				NTDPlayer[ChangingColorState] = -1;
				NTDPlayer[CursorTimer] = -1;
				PlayerSelectTD(playerid, true);		
				TogglePlayerControllable(playerid, false);
				projamount = GetAllProjects();
				ShowEditorEx(playerid);
				GameTextForPlayer(playerid, "~y~Text Draw Editor~n~~r~By Nickk888 "SCRIPT_VERSION, 5000, 6);
				SendClientMessage(playerid, -1, "{FF8040}NTD: {FFFFFF}Aby wyjsc z edytora, uzyj komende {00FFFF}/NTD");
				HTTP(playerid, HTTP_GET, "samp-scripters.pl/Nickk888SAMP/ntd_version.txt", "", "HTTPVersionCheck");
			}
			else
			{
				if(NTDPlayer[playerIDInEditor] == playerid)
				{
					HideEditor(playerid);
					DestroyEditor();
					NTDPlayer[InEditor] = false;
					NTDPlayer[ChangingPosition] = false;
					NTDPlayer[ChangingSize] = false;
					NTDPlayer[ChoosenTDID] = -1;
					NTDPlayer[EditingTDID] = -1;
					NTDPlayer[ChangingColorState] = -1;
					PlayerSelectTD(playerid, false);
					TogglePlayerControllable(playerid, true);
					SendClientMessage(playerid, -1, "{FF8040}NTD: {FFFFFF}Edytor zostal wylaczony.");
					if(NTDPlayer[ProjectOpened])
					{
						SaveProject();
						for(new i; i < MAX_TDS; i++)
							DestroyTD(i);
						NTDPlayer[ProjectOpened] = false;
					}
				}
				else SendClientMessage(playerid, -1, "{FF8040}NTD: {FF0000}Inny gracz aktualnie korzysta z edytora!");
			}
		}
		else ShowInfo(playerid, "{FF0000}Skrypt zostal zablokowany!\n{FFFFFF}Sprawdz Log serwera aby otrzymac wiecej informacji!");
	}
	else SendClientMessage(playerid, -1, "{FF8040}NTD: {FF0000}Nie jestes uprawniony/a by skorzystac z tej komendy!");
	return 1;
}

forward HTTPVersionCheck(index, response_code, data[]);
public HTTPVersionCheck(index, response_code, data[])
{
    new buffer[128];
    if(response_code == 200) 
    {
        if(strcmp(SCRIPT_VERSION_CHECK, data) && !isnull(data))
		{
			if(index == -1)
			{
				print("[NTD]Istnieje nowsza wersja tego skryptu!");
				format(buffer, sizeof(buffer), "[NTD]Wersja skryptu: %s | Nowa wersja: %s", SCRIPT_VERSION_CHECK, data);
				print(buffer); 
				print("[NTD]Sciagnij najnowsza wersje uzywajac ten link: https://goo.gl/NUh4us");
			}
			else
			{
				SendClientMessage(index, -1, "{FF8040}NTD: {FFFFFF}Istnieje nowsza wersja tego skryptu! Wersja tego skryptu");
				format(buffer, sizeof(buffer), "{FF8040}NTD: {FFFFFF}Wersja tego skryptu: {FF8040}%s{FFFFFF} | Nowa wersja: {FF8040}%s", SCRIPT_VERSION_CHECK, data);
				SendClientMessage(index, -1, buffer);
				SendClientMessage(index, -1, "{FF8040}NTD: {FFFFFF}Sciagnij najnowsza wersje uzywajac ten link: {FF8040}https://goo.gl/NUh4us");
			}
		}
    }
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{		
	if(ScriptActive)
	{
		if(newkeys & KEY_SPRINT)
		{
			if(NTDPlayer[InEditor])
			{
				if(playerid == NTDPlayer[playerIDInEditor])
				{
					if(NTDPlayer[ChangingPosition] || NTDPlayer[ChangingSize] || NTDPlayer[ChangingMRotation] || NTDPlayer[ChangingMZoom] || NTDPlayer[ChangingColor])
					{
						NTDPlayer[ChangingPosition] = false;
						NTDPlayer[ChangingSize] = false;
						NTDPlayer[ChangingMRotation] = false;
						NTDPlayer[ChangingMZoom] = false;
						NTDPlayer[ChangingColor] = false;
						ShowEditorEx(playerid);
						KillTimer(NTDPlayer[ChangingVarsTimer]);
						PlayerSelectTD(playerid, true);
					}
				}
			}
		}
		if(newkeys & KEY_JUMP)
		{
			if(NTDPlayer[InEditor] && (NTDPlayer[ChangingPosition] || NTDPlayer[ChangingSize]  || NTDPlayer[ChangingMRotation] || NTDPlayer[ChangingMZoom] || NTDPlayer[ChangingColor]))
			{
				if(playerid == NTDPlayer[playerIDInEditor])
				{
					NTDPlayer[Accelerate] = true;
				}
			}
		}
		if(oldkeys & KEY_JUMP)
			NTDPlayer[Accelerate] = false;
	}
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(ScriptActive)
	{
		new string[300], longstring[1000];
		new tdid = NTDPlayer[EditingTDID];
		if(dialogid == DIALOG_PREVIEWMODEL1)
		{
			if(response)
			{
				if(IsNumeric(inputtext) && strval(inputtext) >= 0)
				{
					NTD[tdid][PrevModel] = strval(inputtext);
					TextDrawSetPreviewModel(NTD[tdid][tdself], NTD[tdid][PrevModel]);
					TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
					ShowEditorEx(playerid);
				}
				else ShowInfo(playerid, "{FF0000}ID modelu jest bledne!");
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_PREVIEWMODEL)
		{
			if(response)
			{
				if(listitem == 0) //Zmien Model
				{
					ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL1, DIALOG_STYLE_INPUT, CAPTION_TEXT"Podglad Modeli", "{FF5500}Podaj numer modelu Postaci, Pojazdu lub obiektu.", "Potwierdz", "Wroc");
				}
				else if(listitem == 1) // Zmien Rotacje
				{
					NTDPlayer[ChangingMRotation] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
				else if(listitem == 2) //Zmien przyblizenie
				{
					NTDPlayer[ChangingMZoom] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
				else if(listitem == 3) //Zmien kolor pojazdu
				{
					NTDPlayer[ChangingColor] = true;
					NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
					PlayerSelectTD(playerid, false);
					HideEditor(playerid);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_INFO)
		{
			ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_EXPORT)
		{
			if(response)
			{
				if(ExportProject(NTDPlayer[ProjectName], listitem))
				{
					format(string, sizeof string, "{00FF00}Projekt zostal pomyslnie wyeksportowany!\n{FFFFFF}Projekt wyeksportowany do {00FFFF}scriptfiles/NTD/Exports/%s.pwn", GetRawProjectName(NTDPlayer[ProjectName]));
					ShowInfo(playerid, string);
				}
				else
				{
					ShowInfo(playerid, "{FF0000}Podczas eksportu wystapil problem...");
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_WIELKOSC)
		{
			if(response)
			{
				NTDPlayer[ChangingSizeState] = listitem;
				NTDPlayer[ChangingSize] = true;
				NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
				PlayerSelectTD(playerid, false);
				HideEditor(playerid);
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_COLOR3)
		{
			if(response)
			{
				if(NTDPlayer[ChangingColorState] == 0) //Tekst Color
				{
					NTD[tdid][Color] = PremadeColor[listitem][0];
					TextDrawColor(NTD[tdid][tdself], PremadeColor[listitem][0]);
				}
				else if(NTDPlayer[ChangingColorState] == 1) //BG Color
				{
					NTD[tdid][BGColor] = PremadeColor[listitem][0];
					TextDrawBackgroundColor(NTD[tdid][tdself], PremadeColor[listitem][0]);
				}
				else if(NTDPlayer[ChangingColorState] == 2) //Box Color
				{
					NTD[tdid][BoxColor] = PremadeColor[listitem][0];
					TextDrawBoxColor(NTD[tdid][tdself], PremadeColor[listitem][0]);
				}
				TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
				ShowEditorEx(playerid);
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR7)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorA] = strval(inputtext);
						new ccolor;
						HexToRGBA(ccolor,NTDPlayer[CCombinatorR],NTDPlayer[CCombinatorG],NTDPlayer[CCombinatorB],NTDPlayer[CCombinatorA]);
						if(NTDPlayer[ChangingColorState] == 0) //Tekst Color
						{
							NTD[tdid][Color] = ccolor;
							TextDrawColor(NTD[tdid][tdself], ccolor);
						}
						else if(NTDPlayer[ChangingColorState] == 1) //BG Color
						{
							NTD[tdid][BGColor] = ccolor;
							TextDrawBackgroundColor(NTD[tdid][tdself], ccolor);
						}
						else if(NTDPlayer[ChangingColorState] == 2) //Box Color
						{
							NTD[tdid][BoxColor] = ccolor;
							TextDrawBoxColor(NTD[tdid][tdself], ccolor);
						}
						TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
						ShowEditorEx(playerid);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR6)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorB] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR7, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj czwarta wartosc przezroczystosci\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR5)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorG] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR6, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj trzeci kolor {0000FF}NIEBIESKI\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR4)
		{
			if(response)
			{
				if(IsNumeric(inputtext))
				{
					if(strval(inputtext) >= 0 && strval(inputtext) <= 255)
					{
						NTDPlayer[CCombinatorR] = strval(inputtext);
						ShowPlayerDialog(playerid, DIALOG_COLOR5, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj drugi kolor {00FF00}ZIELONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
			}
			else ColorDialog(playerid, 1);
		}
		if(dialogid == DIALOG_COLOR2)
		{
			if(response)
			{
				if(listitem == 0) //Gotowe kolory
				{
					for(new i; i < sizeof PremadeColor; i++)
					{
						format(string, sizeof string, "%s%s\n", GetColorRGBA(PremadeColor[i][0]), PremadeColor[i][1]);
						strcat(longstring, string);
					}
					ShowPlayerDialog(playerid, DIALOG_COLOR3, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", longstring, "Potwierdz", "Wroc");
				}
				else if(listitem == 1) //Kombinator
				{
					ShowPlayerDialog(playerid, DIALOG_COLOR4, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Koloru", "{FFFFFF}Podaj pierwszy kolor {FF0000}CZERWONY\n{FFFFFF}Przedzial od 0-255.", "Dalej", "Wroc");
				}
				else if(listitem == 2) //Kolor Hex
				{
					
				}
			}
			else ColorDialog(playerid, 0);
		}
		if(dialogid == DIALOG_COLOR1)
		{
			if(response)
			{
				if(listitem == 0) //Tekst kolor
				{
					NTDPlayer[ChangingColorState] = 0;
					ColorDialog(playerid, 1);
				}
				else if(listitem == 1) //Kolor tla
				{
					NTDPlayer[ChangingColorState] = 1;
					ColorDialog(playerid, 1);
				}
				else if(listitem == 2) //Box Color
				{
					NTDPlayer[ChangingColorState] = 2;
					ColorDialog(playerid, 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_TEKST)
		{
			if(response)
			{
				if(strlen(inputtext))
				{
					TextDrawSetString(NTD[tdid][tdself], inputtext);
					format(NTD[tdid][tdstring], 300, inputtext);
					TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
					ShowEditorEx(playerid);
				}
				else ShowEditorEx(playerid);
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_MANAGE2)
		{
			if(response)
			{
				if(listitem == 0) //Modyfikuj
				{
					NTDPlayer[EditingTDID] = NTDPlayer[ChoosenTDID];
					format(string, sizeof string, "~g~MODYFIKUJESZ_ID_~r~%i", NTDPlayer[ChoosenTDID]);
					GameTextForPlayer(playerid, string, 5000, 6);
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
					ShowEditorEx(playerid);
				}
				if(listitem == 1) //Zklonuj
				{
					tdid = CreateNewTD(NTDPlayer[ChoosenTDID]);
					if(tdid != -1)
					{
						DrawTD(tdid);
						format(string, sizeof string, "~y~ZKLONOWANO_ID_~r~%i", NTDPlayer[ChoosenTDID]);
						GameTextForPlayer(playerid, string, 5000, 6);
						PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
						OnPlayerClickTextDraw(playerid, B_ManageActive);
					}
					else ShowInfo(playerid, "Osiagnieto maksymalna ilosc tekstdrawow!");
				}
				else if(listitem == 2) //Usun
				{
					DestroyTD(NTDPlayer[ChoosenTDID]);
					if(NTDPlayer[EditingTDID] == NTDPlayer[ChoosenTDID])
						NTDPlayer[EditingTDID] = -1;
					format(string, sizeof string, "~r~USUNIETO_ID_%i", NTDPlayer[ChoosenTDID]);
					GameTextForPlayer(playerid, string, 5000, 6);
					PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
					OnPlayerClickTextDraw(playerid, B_ManageActive);
				}
				
			}
			else OnPlayerClickTextDraw(playerid, B_ManageActive);
		}
		if(dialogid == DIALOG_MANAGE)
		{
			if(response)
			{
				if(listitem == 0) //Stworz nowy TD
				{
					tdid = CreateNewTD();
					if(tdid != -1)
					{
						DrawTD(tdid);
						PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
						format(string, sizeof string, "~g~STWORZONO_NOWY_TEXTDRAW");
						GameTextForPlayer(playerid, string, 5000, 6);
						OnPlayerClickTextDraw(playerid, B_ManageActive);
					}
					else ShowInfo(playerid, "Osiagnieto maksymalna ilosc tekstdrawow!");
				}
				else if(listitem > 0 && listitem < 11) //TDS
				{
					listitem = (listitem - 1) + (10 * NTDPlayer[IsOnPage]);
					NTDPlayer[ChoosenTDID] = TDAdress[listitem];
					format(string, sizeof string, "%sID %i '%s'", CAPTION_TEXT, NTDPlayer[ChoosenTDID], NTD[NTDPlayer[ChoosenTDID]][tdstring]);
					ShowPlayerDialog(playerid, DIALOG_MANAGE2, DIALOG_STYLE_LIST,  string, "{FFFFFF}Modyfikuj\n{FF8800}Zklonuj\n{FF0000}Usun", "Potwierdz", "Wroc");
				}
				else if(listitem == 11)
				{
					OpenTDDialog(playerid, NTDPlayer[IsOnPage] + 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_OPEN2)
		{
			if(response)
			{
				if(listitem == 0) //Wczytaj
				{
					if(LoadProject(NTDPlayer[ProjectName]))
					{
						format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal pomyslnie zaladowany!", NTDPlayer[ProjectName]);
						ShowInfo(playerid, string);
					}
					else ShowInfo(playerid, "{FF0000}Podczas zaladowania projektu wystapil problem!");
				}
				if(listitem == 1) //Usun
				{
					if(DeleteProject(NTDPlayer[ProjectName]))
					{
						format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal usuniety!", NTDPlayer[ProjectName]);
						ShowInfo(playerid, string);
					}
					else ShowInfo(playerid, "{FF0000}Podczas usuwania projektu wystapil problem!");
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_OPEN)
		{
			if(response)
			{
				if(listitem < 10)
				{
					new lister;
					if(NTDPlayer[IsOnPage] > 0) lister = (listitem + (NTDPlayer[IsOnPage] * 10));
					else lister = listitem;
					format(NTDPlayer[ProjectName], 128, TDList[lister][proname]);
					ShowPlayerDialog(playerid, DIALOG_OPEN2, DIALOG_STYLE_LIST, CAPTION_TEXT"Projekty", "{FFFFFF}Wczytaj\n{FF0000}Usun", "Potwierdz", "Wroc");
				}
				else if(listitem == 10)
				{
					OpenProjectDialog(playerid, NTDPlayer[IsOnPage] + 1);
				}
			}
			else ShowEditorEx(playerid);
		}
		if(dialogid == DIALOG_NEW)
		{
			if(response)
			{
				format(NTDPlayer[ProjectName], 128, inputtext);
				if(strlen(NTDPlayer[ProjectName]) > 0 && strlen(NTDPlayer[ProjectName]) < 40)
				{
					if(CreateProject(NTDPlayer[ProjectName]))
					{
						LoadProject(NTDPlayer[ProjectName]);
						format(string, sizeof string, "{FFFFFF}Projekt '{00FF00}%s{FFFFFF}' zostal pomyslnie stworzony!", NTDPlayer[ProjectName]);
						ShowInfo(playerid, string);
					}
					else ShowInfo(playerid, "{FF0000}Taki projekt juz istnieje!");
				}
				else ShowInfo(playerid, "{FF0000}Nieprawidlowa ilosc znakow!");
			}
			else ShowEditorEx(playerid);
		}
	}
	return 0;
}

forward ChangingVarsTime();
public ChangingVarsTime()
{
	new tdid = NTDPlayer[EditingTDID];
	new bool:varupdated;
	new Keys,ud,lr;
	new string[80];
	new playerid = NTDPlayer[playerIDInEditor];
    GetPlayerKeys(playerid,Keys,ud,lr);
	
	if(ud == KEY_UP)
	{
		varupdated = true;
		if(NTDPlayer[ChangingPosition] == true)
		{
			if(!NTDPlayer[Accelerate]) 
				NTD[tdid][PosY] -= 1.0;
			else 
				NTD[tdid][PosY] -= 10.0;
		}	
		else if(NTDPlayer[ChangingSize] == true)
		{
			if(!NTDPlayer[Accelerate]) 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeY] -= 0.05; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeY] -= 0.5; 
			} 
			else 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeY] -= 0.5; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeY] -= 5.0; 
			}
		}	
		else if(NTDPlayer[ChangingMRotation] == true)
		{
			if(!NTDPlayer[Accelerate]) 
				NTD[tdid][PrevRotX] += 1.0;
			else 
				NTD[tdid][PrevRotY] += 1.0;
		}
		else if(NTDPlayer[ChangingMZoom] == true)
		{
			if(NTDPlayer[Accelerate]) 
				NTD[tdid][PrevRotZoom] -= 0.1;
			else 
				NTD[tdid][PrevRotZoom] -= 0.01;
		}
		else if(NTDPlayer[ChangingColor] == true)
		{
			if(NTDPlayer[Accelerate]) 
				NTD[tdid][PrevModelC2] ++;
			else 
				NTD[tdid][PrevModelC1] ++;
		}
	}
	else if(ud == KEY_DOWN)
	{
		varupdated = true;
		if(NTDPlayer[ChangingPosition] == true)
		{
			if(!NTDPlayer[Accelerate]) 
				NTD[tdid][PosY] += 1.0;
			else
				NTD[tdid][PosY] += 10.0;
		}	
		else if(NTDPlayer[ChangingSize] == true)
		{
			if(!NTDPlayer[Accelerate]) 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeY] += 0.05; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeY] += 0.5; 
			} 
			else 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeY] += 0.5; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeY] += 5.0; 
			}
		}
		else if(NTDPlayer[ChangingMRotation] == true)
		{
			if(!NTDPlayer[Accelerate])
				NTD[tdid][PrevRotX] -= 1.0;
			else 
				NTD[tdid][PrevRotY] -= 1.0;
		}
		else if(NTDPlayer[ChangingMZoom] == true)
		{
			if(NTDPlayer[Accelerate]) 
				NTD[tdid][PrevRotZoom] += 0.1;
			else 
				NTD[tdid][PrevRotZoom] += 0.01;
		}
		else if(NTDPlayer[ChangingColor] == true)
		{
			if(NTDPlayer[Accelerate]) 
				NTD[tdid][PrevModelC2] --;
			else 
				NTD[tdid][PrevModelC1] --;
		}
	}
	if(lr == KEY_LEFT)
	{
		varupdated = true;
		if(NTDPlayer[ChangingPosition] == true)
		{
			if(!NTDPlayer[Accelerate]) 
				NTD[tdid][PosX] -= 1.0; 
			else
				NTD[tdid][PosX] -= 10.0; 
		}	
		else if(NTDPlayer[ChangingSize] == true)
		{
			if(!NTDPlayer[Accelerate]) 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeX] -= 0.05 / 12; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeX] -= 0.5; 
			} 
			else 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeX] -= 0.5 / 12; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeX] -= 5.0; 
			}
		}
		else if(NTDPlayer[ChangingMRotation] == true)
		{
			if(!NTDPlayer[Accelerate])
				NTD[tdid][PrevRotZ] -= 1.0;
		}
	}
	else if(lr == KEY_RIGHT)
	{
		varupdated = true;
		if(NTDPlayer[ChangingPosition] == true)
		{
			if(!NTDPlayer[Accelerate]) 
				NTD[tdid][PosX] += 1.0; 	
			else 
				NTD[tdid][PosX] += 10.0; 
		}	
		else if(NTDPlayer[ChangingSize] == true)
		{
			if(!NTDPlayer[Accelerate]) 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeX] += 0.05 / 12; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeX] += 0.5; 
			} 
			else 
			{
				if(NTDPlayer[ChangingSizeState] == 0) 
					NTD[tdid][LetterSizeX] += 0.5 / 12; 
				else if(NTDPlayer[ChangingSizeState] == 1) 
					NTD[tdid][BoxSizeX] += 5.0; 
			}
		}
		else if(NTDPlayer[ChangingMRotation] == true)
		{
			if(!NTDPlayer[Accelerate])
				NTD[tdid][PrevRotZ] += 1.0;
		}
	}
	
	if(varupdated)
	{
		TextDrawDestroy(NTD[tdid][tdself]);
		DrawTD(tdid);
	}
	if(NTDPlayer[ChangingColor] == true)
		format(string, sizeof string, "~w~Kolor 1:~y~%d ~w~Kolor 2:~y~%d ~n~~p~SHIFT=Kolor 2 SPACJA=Zakoncz", NTD[tdid][PrevModelC1], NTD[tdid][PrevModelC2]);
		
	if(NTDPlayer[ChangingPosition] == true)
		format(string, sizeof string, "~w~X:~y~%.1f ~w~Y:~y~%.1f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][PosX], NTD[tdid][PosY]);
	
	if(NTDPlayer[ChangingMRotation] == true)
		format(string, sizeof string, "~w~X:~y~%.1f ~w~Y:~y~%.1f ~w~Y:~y~%.1f~n~~p~SHIFT=Koordynaty Y SPACJA=Zakoncz", NTD[tdid][PrevRotX], NTD[tdid][PrevRotY], NTD[tdid][PrevRotZ]);
	
	if(NTDPlayer[ChangingMZoom] == true)
		format(string, sizeof string, "~w~Zblizenie:~y~%.2f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][PrevRotZoom]);
	
	if(NTDPlayer[ChangingSize] == true) {
		if(NTDPlayer[ChangingSizeState] == 0) format(string, sizeof string, "~w~X:~y~%.5f ~w~Y:~y~%.5f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][LetterSizeX], NTD[tdid][LetterSizeY]);
		else if(NTDPlayer[ChangingSizeState] == 1) format(string, sizeof string, "~w~X:~y~%.5f ~w~Y:~y~%.5f~n~~p~SHIFT=Szybciej SPACJA=Zakoncz", NTD[tdid][BoxSizeX], NTD[tdid][BoxSizeY]);
	}
	if(NTD[tdid][PrevRotX] > 360 || NTD[tdid][PrevRotX] < -360) NTD[tdid][PrevRotX] = 0.0;
	if(NTD[tdid][PrevRotY] > 360 || NTD[tdid][PrevRotY] < -360) NTD[tdid][PrevRotY] = 0.0;
	if(NTD[tdid][PrevRotZ] > 360 || NTD[tdid][PrevRotZ] < -360) NTD[tdid][PrevRotZ] = 0.0;
	if(NTD[tdid][PrevRotZoom] < 0) NTD[tdid][PrevRotZoom] = 0.0;
	if(NTD[tdid][PrevRotZoom] > 15) NTD[tdid][PrevRotZoom] = 15.0;
	if(NTD[tdid][PrevModelC1] < 0) NTD[tdid][PrevModelC1] = 255;
	if(NTD[tdid][PrevModelC1] > 255) NTD[tdid][PrevModelC1] = 0;
	if(NTD[tdid][PrevModelC2] < 0) NTD[tdid][PrevModelC2] = 255;
	if(NTD[tdid][PrevModelC2] > 255) NTD[tdid][PrevModelC2] = 0;
	GameTextForPlayer(playerid, string, 200, 4);
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	new string[128];
	new tdid = NTDPlayer[EditingTDID];
	if(clickedid == B_MPreviewActive)
	{
		if(NTD[tdid][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
		{
			ShowPlayerDialog(playerid, DIALOG_PREVIEWMODEL, DIALOG_STYLE_LIST, CAPTION_TEXT"Podglad Modeli", "{FF5500}Zmien ID Modelu\n{FF80FF}Zmien Rotacje\n{FF5500}Zmien Przyblizenie\n{FF80FF}Zmien kolor modelu pojazdu", "Wybierz", "Wroc");
			PlayerSelectTD(playerid, false);
		}
	}
	if(clickedid == B_ProportionalityActive)
	{
		
		if(NTD[tdid][Proportional] == false)
			NTD[tdid][Proportional] = true,
			GameTextForPlayer(playerid, "~g~PROPORCJONALNY", 1500, 6);
		else
			NTD[tdid][Proportional] = false,
			GameTextForPlayer(playerid, "~r~NIE PROPORCJONALNY", 1500, 6);
		TextDrawSetProportional(NTD[tdid][tdself], NTD[tdid][Proportional]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
	}
	if(clickedid == B_AlignmentActive)
	{
		if(NTD[tdid][Alignment] == 3)
			NTD[tdid][Alignment] = 0;
		
		NTD[tdid][Alignment]++;
		TextDrawAlignment(NTD[tdid][tdself], NTD[tdid][Alignment]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
		if(NTD[tdid][Alignment] == 1) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~y~Do lewej", 1500, 6);
		else if(NTD[tdid][Alignment] == 2) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~g~Do srodka", 1500, 6);
		else if(NTD[tdid][Alignment] == 3) GameTextForPlayer(playerid, "~w~Wyrownywanie~n~~r~Do prawej", 1500, 6);
	}
	if(clickedid == B_SwitchPublicActive)
	{
		if(NTD[tdid][isPublic] == false)
			NTD[tdid][isPublic] = true,
			GameTextForPlayer(playerid, "~g~Publiczny", 1500, 6);
		else
			NTD[tdid][isPublic] = false,
			GameTextForPlayer(playerid, "~b~Dla Gracza", 1500, 6);
		
	}
	if(clickedid == B_SelectableActive)
	{
		if(NTD[tdid][Selectable] == false)
			NTD[tdid][Selectable] = true,
			GameTextForPlayer(playerid, "~w~Klikalne: ~g~Tak", 1500, 6);
		else
			NTD[tdid][Selectable] = false,
			GameTextForPlayer(playerid, "~w~Klikalne: ~r~Nie", 1500, 6);
		
		TextDrawSetSelectable(NTD[tdid][tdself], NTD[tdid][Selectable]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
	}
	if(clickedid == B_ShadowActive)
	{
		if(NTD[tdid][ShadowSize] == 4)
			NTD[tdid][ShadowSize] = -1;
		
		NTD[tdid][ShadowSize]++;
		TextDrawSetShadow(NTD[tdid][tdself], NTD[tdid][ShadowSize]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
		format(string, sizeof string, "~w~Wielkosc cienia~n~~y~%i", NTD[tdid][ShadowSize]);
		GameTextForPlayer(playerid, string, 1500, 6);
	}
	if(clickedid == B_UseBoxActive)
	{
		if(NTD[tdid][UseBox] == false)
			NTD[tdid][UseBox] = true,
			GameTextForPlayer(playerid, "~w~Box: ~g~Wl", 1500, 6);
		else
			NTD[tdid][UseBox] = false,
			GameTextForPlayer(playerid, "~w~Box: ~r~Wyl", 1500, 6);
		
		TextDrawUseBox(NTD[tdid][tdself], NTD[tdid][UseBox]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
	}
	if(clickedid == B_OutlineActive)
	{
		if(NTD[tdid][OutlineSize] == 4)
			NTD[tdid][OutlineSize] = -1;
		
		NTD[tdid][OutlineSize]++;
		TextDrawSetOutline(NTD[tdid][tdself], NTD[tdid][OutlineSize]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
		format(string, sizeof string, "~w~Grubosc obramowania~n~~y~%i", NTD[tdid][OutlineSize]);
		GameTextForPlayer(playerid, string, 1500, 6);
	}
	if(clickedid == B_ColorActive)
	{
		ColorDialog(playerid, 0);
		PlayerSelectTD(playerid, false);
	}
	if(clickedid == B_TekstActive)
	{
		ShowPlayerDialog(playerid, DIALOG_TEKST, DIALOG_STYLE_INPUT, CAPTION_TEXT"Zmiana Tekstu", "{FFFFFF}Podaj nowy tekst ktory zostanie ustawiony...", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	if(clickedid == B_SizeActive)
	{
		ShowPlayerDialog(playerid, DIALOG_WIELKOSC, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Wielkosci", "{FF8040}Tekstu\n{FF5500}Boxu", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	if(clickedid == B_PositionActive)
	{
		NTDPlayer[ChangingPosition] = true;
		NTDPlayer[ChangingVarsTimer] = SetTimer("ChangingVarsTime", CHANGING_VAR_TIME, true);
		PlayerSelectTD(playerid, false);
		HideEditor(playerid);
	}
	if(clickedid == B_FontActive)
	{
		if(NTD[tdid][Font] == 5)
			NTD[tdid][Font] = -1;
		
		NTD[tdid][Font]++;
		TextDrawFont(NTD[tdid][tdself], NTD[tdid][Font]);
		TextDrawShowForPlayer(playerid, NTD[tdid][tdself]);
		
		if(NTD[tdid][Font] == 4)
			GameTextForPlayer(playerid, "~w~Czcionka~n~~g~TXD Sprite", 1500, 6);
		else if(NTD[tdid][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
			GameTextForPlayer(playerid, "~w~Czcionka~n~~b~Podglad Modeli", 1500, 6);
		else
			format(string, sizeof string, "~w~Czcionka~n~~y~%i", NTD[tdid][Font]),
			GameTextForPlayer(playerid, string, 1500, 6);
	}
	if(clickedid == B_NewActive)
	{
		ShowPlayerDialog(playerid, DIALOG_NEW, DIALOG_STYLE_INPUT, CAPTION_TEXT"Nowy Projekt", "{FFFF00}Wpisz nazwe swojego nowego projektu...", "Stworz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	if(clickedid == B_CloseActive)
	{
		if(SaveProject() == 0) ShowInfo(playerid, "{FF0000}Podczas zapisu projektu wystapil problem...");
		else ShowInfo(playerid, "{FFFFFF}Projekt zostal pomyslnie zapisany i zamykany...");
		
		for(new i; i < MAX_TDS; i++)
			DestroyTD(i);
		NTDPlayer[ProjectOpened] = false;
		NTDPlayer[EditingTDID] = -1;
		ShowEditorEx(playerid);
	}
	if(clickedid == B_ManageActive)
	{
		OpenTDDialog(playerid, 0);
	}
	if(clickedid == B_OpenActive)
	{
		OpenProjectDialog(playerid, 0);
		
	}
	if(clickedid == B_ExportActive)
	{
		ShowPlayerDialog(playerid, DIALOG_EXPORT, DIALOG_STYLE_LIST, CAPTION_TEXT"Eksportuj jako...", "{FFFF00}Zwykly Eksport\n{FF8040}Gotowy skrypt", "Eksportuj", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	return 0;
}

//STOCKI

stock CreateProject(projectname[])
{
	new string[500];
	format(string, sizeof string, "NTD/Projects/%s.ntdp", projectname);			
	if(!dfile_FileExists(string))
	{
		if(WriteIntoList(projectname))
		{
			dfile_Create(string);
			projamount = GetAllProjects();		
			return 1;
		}
		else ShowInfo(NTDPlayer[playerIDInEditor], "{FF0000}Podczas zapisu projektu wystapil problem...");
	}
	return 0;
}

stock ShowInfo(playerid, text[])
{
	ShowPlayerDialog(playerid, DIALOG_INFO, DIALOG_STYLE_MSGBOX, CAPTION_TEXT"Informacja", text, "OK", #);
	PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
	return 1;
}

stock GetRawProjectName(project[])
{
	new raw[128];
	format(raw, 128, project);
	new li = strfind(raw, ".ntdp", true);
	strdel(raw, li, strlen(raw));
	return raw;
}

stock ExportProject(projectname[], exporttype=0)
{
	new filename[128], string[500];
	format(filename, 128, "/NTD/Exports/%s.pwn", GetRawProjectName(projectname));
	if(dfile_FileExists(filename))
		dfile_Delete(filename);
	
	if(dfile_FileExists("/NTD/Exports"))
	{
		if(dfile_Create(filename))
		{
			new File:file = fopen(filename, io_append);
			if(file)
			{
				new tda = GetAllTD();
				fwrite(file, "/*\nTen plik zostal wygenerowany przez skrypt Nickk's TextDraw editor\n");
				fwrite(file, "Autorem skryptu NTD jest Nickk888\n*/\n\n");
				if(exporttype == 0) //RAW EXPORT
				{
					fwrite(file, "//ZMIENNE\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new Text:textdraw_%i;\n", i);
						else if(!NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new PlayerText:textdraw_%i[MAX_PLAYERS];\n", i);
						fwrite(file, string);
					}
					fwrite(file, "\n//TEXTDRAWY\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "textdraw_%i = TextDrawCreate(%f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawFont(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawLetterSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawTextSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetOutline(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetShadow(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawAlignment(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawBackgroundColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawBoxColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawUseBox(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetProportional(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "TextDrawSetSelectable(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "TextDrawSetPreviewModel(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "TextDrawSetPreviewRot(textdraw_%i, %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "TextDrawSetPreviewVehCol(textdraw_%i, %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
						}					
						else if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "textdraw_%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawFont(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawLetterSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawTextSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetOutline(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetShadow(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawAlignment(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawBackgroundColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawBoxColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawUseBox(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetProportional(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetSelectable(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							format(string, sizeof string, "PlayerTextDrawSetPreviewVehCol(playerid, textdraw_%i[playerid], %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
							fwrite(file, string);
							fwrite(file, "\n");
						}
						
					}
					fwrite(file, "\n//POKAZ/UKRYJ\n");
					fwrite(file, "TextDrawShowForPlayer(playerid, textdraw_0); //Pokazuje TextDraw graczowi.\n");
					fwrite(file, "TextDrawShowForAll(textdraw_0); //Pokazuje TextDraw wszystkim.\n\n");
					fwrite(file, "TextDrawHideForPlayer(playerid, textdraw_0); //Ukrywa TextDraw graczowi.\n");
					fwrite(file, "TextDrawHideForAll(textdraw_0); //Ukrywa TextDraw wszystkim.\n\n");
					fwrite(file, "PlayerTextDrawShow(playerid, textdraw_0[playerid]); //Pokazuje PlayerTextDraw graczowi.\n");
					fwrite(file, "PlayerTextDrawHide(playerid, textdraw_0[playerid]); //Ukrywa PlayerTextDraw graczowi.\n");
				}
				else if(exporttype == 1) //WORKING FS EXPORT
				{
					fwrite(file, "#include <a_samp>\n\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new Text:textdraw_%i;\n", i);
						else if(!NTD[TDAdress[i]][isPublic]) format(string, sizeof string, "new PlayerText:textdraw_%i[MAX_PLAYERS];\n", i);
						fwrite(file, string);
					}

					fwrite(file, "\npublic OnFilterScriptInit()\n{\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\ttextdraw_%i = TextDrawCreate(%f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawFont(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawLetterSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawTextSize(textdraw_%i, %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetOutline(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetShadow(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawAlignment(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawBackgroundColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawBoxColor(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawUseBox(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetProportional(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "\tTextDrawSetSelectable(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "\tTextDrawSetPreviewModel(textdraw_%i, %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "\tTextDrawSetPreviewRot(textdraw_%i, %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "\tTextDrawSetPreviewVehCol(textdraw_%i, %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
						}					
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnPlayerConnect(playerid)\n{\n");
					for(new i; i < tda; i++)
					{
						if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\ttextdraw_%i[playerid] = CreatePlayerTextDraw(playerid, %f, %f, \x22%s\x22);\n", i, NTD[TDAdress[i]][PosX], NTD[TDAdress[i]][PosY], NTD[TDAdress[i]][tdstring]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawFont(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Font]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawLetterSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][LetterSizeX], NTD[TDAdress[i]][LetterSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawTextSize(playerid, textdraw_%i[playerid], %f, %f);\n", i, NTD[TDAdress[i]][BoxSizeX], NTD[TDAdress[i]][BoxSizeY]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetOutline(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][OutlineSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetShadow(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][ShadowSize]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawAlignment(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Alignment]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Color]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawBackgroundColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BGColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawBoxColor(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][BoxColor]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawUseBox(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][UseBox]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetProportional(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Proportional]);
							fwrite(file, string);
							format(string, sizeof string, "\tPlayerTextDrawSetSelectable(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][Selectable]);
							fwrite(file, string);
							if(NTD[TDAdress[i]][Font] == TEXT_DRAW_FONT_MODEL_PREVIEW)
							{
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewModel(playerid, textdraw_%i[playerid], %i);\n", i, NTD[TDAdress[i]][PrevModel]);
								fwrite(file, string);
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewRot(playerid, textdraw_%i[playerid], %f, %f, %f, %f);\n", i, NTD[TDAdress[i]][PrevRotX], NTD[TDAdress[i]][PrevRotY], NTD[TDAdress[i]][PrevRotZ], NTD[TDAdress[i]][PrevRotZoom]);
								fwrite(file, string);
								format(string, sizeof string, "\tPlayerTextDrawSetPreviewVehCol(playerid, textdraw_%i[playerid], %i, %i);\n", i, NTD[TDAdress[i]][PrevModelC1], NTD[TDAdress[i]][PrevModelC2]);
								fwrite(file, string);
							}
							fwrite(file, "\n");
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					fwrite(file, "\npublic OnPlayerDisconnect(playerid)\n{\n");
					for(new i; i < tda; i++)
					{
						if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\tPlayerTextDrawDestroy(playerid, textdraw_%i[playerid]);\n", i);
							fwrite(file, string);
						}
					}
					fwrite(file, "\treturn 1;\n}\n");
					
					fwrite(file, "\npublic OnPlayerCommandText(playerid, cmdtext[])\n{\n");
					fwrite(file, "\tif(!strcmp(cmdtext, \x22/tdtest\x22, true))\n\t{\n");
					for(new i; i < tda; i++)
					{
						if(NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\t\tTextDrawShowForPlayer(playerid, textdraw_%i);\n", i);
							fwrite(file, string);
						}
						else if(!NTD[TDAdress[i]][isPublic])
						{
							format(string, sizeof string, "\t\tPlayerTextDrawShow(playerid, textdraw_%i[playerid]);\n", i);
							fwrite(file, string);
						}
					}
					fwrite(file, "\t\treturn 1;\n\t}\n");
					fwrite(file, "\treturn 0;\n}\n");
				}
				fclose(file);
				return 1;
			}
		}
	}
	return 0;
}

stock OpenTDDialog(playerid, pageid)
{
	#define MAXFORMATEDTD 50
	new longstring[1000], string[128], formatedtd[MAXFORMATEDTD], lister, listerindex;
	if(pageid == 0) listerindex = 10;
	else listerindex = 10;
	strcat(longstring, "{FF5500}Stworz nowy TextDraw\n");
	new il = GetAllTD();
	for(new i = (listerindex * pageid); i < tdamount; i++)
	{
		if(lister < listerindex)
		{
			lister++;
			format(formatedtd, MAXFORMATEDTD, NTD[TDAdress[i]][tdstring]);
			if(strlen(NTD[TDAdress[i]][tdstring]) > MAXFORMATEDTD - 4)
			{
				strdel(formatedtd, MAXFORMATEDTD - 4, MAXFORMATEDTD);
				strcat(formatedtd, "...");
			}
			format(string, sizeof string, "{FFFFFF}%i. {76DCC0}'%s'\n", TDAdress[i], formatedtd);
			strcat(longstring, string);
		}
		else
		{
			strcat(longstring, "{FF5500}Dalej...");
			break;
		}
	}
	NTDPlayer[OnList] = lister;
	NTDPlayer[IsOnPage] = pageid;
	PlayerSelectTD(playerid, false);
	format(string, sizeof string, "%s Moje TextDrawy (%i/%i TD)", CAPTION_TEXT, il, MAX_TDS);
	ShowPlayerDialog(playerid, DIALOG_MANAGE, DIALOG_STYLE_TABLIST,  string, longstring, "Potwierdz", "Wroc");
	return 1;
}

stock GetAllTD()
{
	tdamount = 0;
	for(new i; i < MAX_TDS; i++)
	{
		if(NTD[i][tdCreated])
		{
			TDAdress[tdamount] = i;
			tdamount++;
		}
	}
	return tdamount;
}

stock GetAllProjects()
{
	new string[300];
	new index;
	if(dfile_FileExists("NTD/ntdlist.list"))
	{
		dfile_Open("NTD/ntdlist.list");
		for(new i; i < MAX_PROJECTS; i++)
			format(TDList[i][proname], 128, "");
		for(new i; i < MAX_PROJECTS; i++)
		{
			format(string, sizeof string, "Project_%i", i);
			string = dfile_ReadString(string);
			if(strlen(string) > 0)
			{
				format(TDList[index][proname], 128, string);
				index++;
			}
		}
	}
	return index;
}

stock OpenProjectDialog(playerid, pageid)
{
	new longstring[2000], string[128], lister, listerindex;
	if(pageid == 0) listerindex = 10;
	else listerindex = 10 * pageid;
	
	if(projamount > 0)
	{
		for(new i = (10 * pageid); i < MAX_PROJECTS; i++)
		{
			if(strlen(TDList[i][proname]) != 0)
			{
				if(lister < listerindex)
				{
					lister++;
					format(string, sizeof string, "%s\n", TDList[i][proname]);
					strcat(longstring, string);
				}
				else
				{
					strcat(longstring, "{FF5500}Dalej...");
					break;
				}
			}
		}
		NTDPlayer[OnList] = lister;
		NTDPlayer[IsOnPage] = pageid; 
		format(string, sizeof string, "%s Moje Projekty(%i/%i)", CAPTION_TEXT, projamount, MAX_PROJECTS);
		ShowPlayerDialog(playerid, DIALOG_OPEN, DIALOG_STYLE_LIST, string, longstring, "Wybierz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	else
	{
		ShowInfo(playerid, "{FF0000}Aktualnie nie posiadasz zadnych projektow!");
	}
	return 1;
}

stock ColorDialog(playerid, cstate)
{
	if(cstate == 0)
	{
		ShowPlayerDialog(playerid, DIALOG_COLOR1, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", "{008080}Kolor tekstu\n{FF8040}Kolor tla\n{FF80FF}Kolor boxu", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	if(cstate == 1)
	{
		ShowPlayerDialog(playerid, DIALOG_COLOR2, DIALOG_STYLE_LIST, CAPTION_TEXT"Zmiana Koloru", "Gotowe kolory\nKombinator RGBA", "Potwierdz", "Wroc");
		PlayerSelectTD(playerid, false);
	}
	return 1;
}

stock PlayerSelectTD(playerid, bool:select)
{
	if(select)
	{
		SelectTextDraw(playerid, CURSOR_COLOR);
		if(NTDPlayer[CursorTimer] == -1)
			NTDPlayer[CursorTimer] = SetTimerEx("ShowCursor", 1000, true, "i", playerid);
	}
	else
	{
		CancelSelectTextDraw(playerid);
		KillTimer(NTDPlayer[CursorTimer]);
		NTDPlayer[CursorTimer] = -1;
	}
	return 1;
}

forward ShowCursor(playerid);
public ShowCursor(playerid)
{
	SelectTextDraw(playerid, CURSOR_COLOR);
	return 1;
}

stock ShowEditorEx(playerid)
{
	if(NTDPlayer[ProjectOpened] == true)
	{
		PlayerSelectTD(playerid, true);
		if(NTDPlayer[EditingTDID] != -1)
			ShowEditor(playerid, false, false, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true);
		else 
			ShowEditor(playerid, false, false, true, true, true, false, false, false, false, false, false, false, false, false, false, false, false, false);
	}
	else 
		ShowEditor(playerid, true, true, false, false, false, false, false, false ,false, false, false, false, false, false, false, false, false, false), 
		PlayerSelectTD(playerid, true);
	return 1;
}

stock DeleteProject(projectname[])
{
	new string[128];
	#if defined DEBUGMODE 
	printf("[NTD]Attempting to delete project: %s", projectname); 
	#endif
	format(string, sizeof string, "NTD/Projects/%s", projectname);
	if(dfile_FileExists(string))
	{
		dfile_Delete(string);
		#if defined DEBUGMODE 
		printf("[NTD]Deleted file '%s'", projectname); 
		#endif
		if(dfile_FileExists("NTD/ntdlist.list"))
		{
			dfile_Open("NTD/ntdlist.list");
			for(new i; i < MAX_PROJECTS; i++)
			{
				format(string, sizeof string, "Project_%i", i);
				new prname[128];
				format(prname, 128, dfile_ReadString(string));
				if(strcmp(prname, projectname) == 0 && strlen(prname) > 0)
				{
					dfile_UnSet(string);
					dfile_SaveFile();
					dfile_CloseFile();
					projamount = GetAllProjects();
					#if defined DEBUGMODE 
					printf("[NTD]Deleted project '%s' from project list at '%s'", projectname, string); 
					#endif
					return 1;
				}
			}
		}
	}
	return 0;
}

stock SaveProject()
{
	new string[128], file[300], longstring[1000], stringex[128];
	#if defined DEBUGMODE 
	printf("[NTD]Attempting to save project: %s", NTDPlayer[ProjectName]);
	#endif
	format(file, sizeof file, "NTD/Projects/%s", NTDPlayer[ProjectName]);
	if(dfile_FileExists(file))
	{
		dfile_Open(file);
		for(new i; i < MAX_TDS; i++)
		{
			if(NTD[i][tdCreated])
			{
				longstring = "";
				
				format(string, sizeof string, "td_%i_string", i);
				dfile_WriteString(string, NTD[i][tdstring]);
				format(string, sizeof string, "td_%i_data", i);
				format(stringex, sizeof stringex, "%f %f ", NTD[i][PosX], NTD[i][PosY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD[i][Font], NTD[i][isPublic]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i ", NTD[i][OutlineSize], NTD[i][ShadowSize]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%f %f ", NTD[i][LetterSizeX], NTD[i][LetterSizeY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD[i][Color], NTD[i][BGColor], NTD[i][BoxColor]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %f %f ", NTD[i][UseBox], NTD[i][BoxSizeX], NTD[i][BoxSizeY]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i ", NTD[i][Selectable], NTD[i][Alignment], NTD[i][Proportional]);
				strcat(longstring, stringex);
				format(stringex, sizeof stringex, "%i %i %i %f %f %f %f", NTD[i][PrevModel], NTD[i][PrevModelC1], NTD[i][PrevModelC2], NTD[i][PrevRotX], NTD[i][PrevRotY], NTD[i][PrevRotZ], NTD[i][PrevRotZoom]);
				strcat(longstring, stringex);
				dfile_WriteString(string, longstring);
			}
			else
			{
				format(string, sizeof string, "td_%i_string", i);
				dfile_UnSet(string);
				format(string, sizeof string, "td_%i_data", i);
				dfile_UnSet(string);
			}
		}
		dfile_SaveFile();
		dfile_CloseFile();
		return 1;
	}
	return 0;
}

stock LoadProject(projectname[])
{
	new string[300], longstring[2000];
	#if defined DEBUGMODE 
	printf("[NTD]Attempting to open file: %s", projectname);
	#endif
	format(string, sizeof string, "NTD/Projects/%s", projectname);
	if(dfile_FileExists(string))
	{
		
		for(new i; i < MAX_TDS; i++)
			NTD[i][tdCreated] = false;
			
		format(NTDPlayer[ProjectName], 128, "%s", projectname);
		NTDPlayer[ProjectOpened] = true;
		dfile_Open(string);
		for(new i; i < MAX_TDS; i++)
		{
			format(string, sizeof string, "td_%i_data", i);
			if(strlen(dfile_ReadString(string)) > 0)
			{
				NTD[i][tdCreated] = true;
				format(string, sizeof string, "td_%i_string", i);
				format(NTD[i][tdstring] , 300, dfile_ReadString(string));
				format(string, sizeof string, "td_%i_data", i);
				format(longstring, sizeof longstring, dfile_ReadString(string)); 
				
				sscanf(longstring, "ffiiiiffiiiiffiiiiiiffff",
				NTD[i][PosX], NTD[i][PosY], NTD[i][Font], NTD[i][isPublic],
				NTD[i][OutlineSize], NTD[i][ShadowSize], NTD[i][LetterSizeX], NTD[i][LetterSizeY],
				NTD[i][Color], NTD[i][BGColor], NTD[i][BoxColor], NTD[i][UseBox], NTD[i][BoxSizeX], NTD[i][BoxSizeY],
				NTD[i][Selectable], NTD[i][Alignment], NTD[i][Proportional], NTD[i][PrevModel], NTD[i][PrevModelC1], 
				NTD[i][PrevModelC2], NTD[i][PrevRotX], NTD[i][PrevRotY], NTD[i][PrevRotZ], NTD[i][PrevRotZoom]);
				
				DrawTD(i);
				#if defined DEBUGMODE 
				printf("[NTD]Created TD ID: %i", i);
				#endif
			}
		}
		return 1;
	}
	return 0;
}

stock DestroyTD(td)
{
	if(NTD[td][tdCreated] == true)
	{
		NTD[td][tdCreated] = false;
		TextDrawDestroy(NTD[td][tdself]);
	}
}

stock DrawTD(td)
{
	new playerid = NTDPlayer[playerIDInEditor];
	if(NTD[td][tdCreated] == true)
	{
		NTD[td][tdself] = TextDrawCreate(NTD[td][PosX], NTD[td][PosY], NTD[td][tdstring]);
		TextDrawFont(NTD[td][tdself], NTD[td][Font]);
		TextDrawSetOutline(NTD[td][tdself], NTD[td][OutlineSize]);
		TextDrawSetShadow(NTD[td][tdself], NTD[td][ShadowSize]);
		TextDrawLetterSize(NTD[td][tdself], NTD[td][LetterSizeX], NTD[td][LetterSizeY]);
		TextDrawColor(NTD[td][tdself], NTD[td][Color]);
		TextDrawBackgroundColor(NTD[td][tdself], NTD[td][BGColor]);
		TextDrawBoxColor(NTD[td][tdself], NTD[td][BoxColor]);
		TextDrawUseBox(NTD[td][tdself], NTD[td][UseBox]);	
		TextDrawTextSize(NTD[td][tdself], NTD[td][BoxSizeX], NTD[td][BoxSizeY]);
		TextDrawSetSelectable(NTD[td][tdself], NTD[td][Selectable]);
		TextDrawAlignment(NTD[td][tdself], NTD[td][Alignment]);
		TextDrawSetProportional(NTD[td][tdself], NTD[td][Proportional]);
		TextDrawSetPreviewModel(NTD[td][tdself], NTD[td][PrevModel]);
		TextDrawSetPreviewRot(NTD[td][tdself], NTD[td][PrevRotX], NTD[td][PrevRotY], NTD[td][PrevRotZ], NTD[td][PrevRotZoom]);
		TextDrawSetPreviewVehCol(NTD[td][tdself], NTD[td][PrevModelC1], NTD[td][PrevModelC2]);
		TextDrawShowForPlayer(playerid, NTD[td][tdself]);
	}
	return 1;
}

stock CreateNewTD(cloneid = -1)
{
	for(new i; i < MAX_TDS; i++)
	{
		if(NTD[i][tdCreated] == false)
		{
			NTD[i][tdCreated] = true;
			if(cloneid == -1)
			{
				format(NTD[i][tdstring], 300, "Nowy_TextDraw");
				NTD[i][PosX] = 233.0;
				NTD[i][PosY] = 225.0;
				NTD[i][Font] = 1;
				NTD[i][isPublic] = true;
				NTD[i][OutlineSize] = 1;
				NTD[i][ShadowSize] = 0;
				NTD[i][LetterSizeX] = 0.6;
				NTD[i][LetterSizeY] = 2.0;
				NTD[i][BoxSizeX] = 400.0;
				NTD[i][BoxSizeY] = 17.0;
				NTD[i][Color] = -1;
				NTD[i][BGColor] = 255;
				NTD[i][BoxColor] = 100;
				NTD[i][Alignment] = 1;
				NTD[i][Selectable] = false;
				NTD[i][Proportional] = true;
				NTD[i][UseBox] = true;
				NTD[i][PrevModel] = 0;
				NTD[i][PrevModelC1] = 1;
				NTD[i][PrevModelC2] = 1;
				NTD[i][PrevRotX] = -10.0;
				NTD[i][PrevRotY] = 0.0;
				NTD[i][PrevRotZ] = -20.0;
				NTD[i][PrevRotZoom] = 1.0;
			}
			else
			{
				if(NTD[cloneid][tdCreated] == true)
				{
					format(NTD[i][tdstring], 300, NTD[cloneid][tdstring]);
					NTD[i][PosX] = NTD[cloneid][PosX];
					NTD[i][PosY] = NTD[cloneid][PosY];
					NTD[i][Font] = NTD[cloneid][Font];
					NTD[i][isPublic] = NTD[cloneid][isPublic];
					NTD[i][OutlineSize] = NTD[cloneid][OutlineSize];
					NTD[i][ShadowSize] = NTD[cloneid][ShadowSize];
					NTD[i][LetterSizeX] = NTD[cloneid][LetterSizeX];
					NTD[i][LetterSizeY] = NTD[cloneid][LetterSizeY];
					NTD[i][BoxSizeX] = NTD[cloneid][BoxSizeX];
					NTD[i][BoxSizeY] = NTD[cloneid][BoxSizeY];
					NTD[i][Color] = NTD[cloneid][Color];
					NTD[i][BGColor] = NTD[cloneid][BGColor];
					NTD[i][BoxColor] = NTD[cloneid][BoxColor];
					NTD[i][Alignment] = NTD[cloneid][Alignment];
					NTD[i][Selectable] = NTD[cloneid][Selectable];
					NTD[i][Proportional] = NTD[cloneid][Proportional];
					NTD[i][UseBox] = NTD[cloneid][UseBox];
					NTD[i][PrevModel] = NTD[cloneid][PrevModel];
					NTD[i][PrevModelC1] = NTD[cloneid][PrevModelC1];
					NTD[i][PrevModelC2] = NTD[cloneid][PrevModelC2];
					NTD[i][PrevRotX] = NTD[cloneid][PrevRotX];
					NTD[i][PrevRotY] = NTD[cloneid][PrevRotY];
					NTD[i][PrevRotZ] = NTD[cloneid][PrevRotZ];
					NTD[i][PrevRotZoom] = NTD[cloneid][PrevRotZoom];
				}
			}
			return i;
		}
	}
	return -1;
}

stock ShowEditor(playerid, bool:b1_active, bool:b2_active, bool:b3_active, bool:b4_active, bool:b5_active, bool:b6_active, bool:b7_active, bool:b8_active, bool:b9_active, bool:b10_active, bool:b11_active, bool:b12_active, bool:b13_active, bool:b14_active, bool:b15_active, bool:b16_active, bool:b17_active, bool:b18_active)
{
	HideEditor(playerid);
	#if defined DEBUGMODE 
	print("[NTD]Showing Editor");
	#endif
	TextDrawShowForPlayer(playerid, E_Box);
	if(b1_active) TextDrawShowForPlayer(playerid, B_NewActive);
	if(b2_active) TextDrawShowForPlayer(playerid, B_OpenActive);
	if(b3_active) TextDrawShowForPlayer(playerid, B_CloseActive);
	if(b4_active) TextDrawShowForPlayer(playerid, B_ExportActive);
	if(b5_active) TextDrawShowForPlayer(playerid, B_ManageActive);
	if(b6_active) TextDrawShowForPlayer(playerid, B_FontActive);
	if(b7_active) TextDrawShowForPlayer(playerid, B_MPreviewActive);
	if(b8_active) TextDrawShowForPlayer(playerid, B_PositionActive);
	if(b9_active) TextDrawShowForPlayer(playerid, B_SizeActive);
	if(b10_active) TextDrawShowForPlayer(playerid, B_TekstActive);
	if(b11_active) TextDrawShowForPlayer(playerid, B_ColorActive);
	if(b12_active) TextDrawShowForPlayer(playerid, B_OutlineActive);
	if(b13_active) TextDrawShowForPlayer(playerid, B_ShadowActive);
	if(b14_active) TextDrawShowForPlayer(playerid, B_UseBoxActive);
	if(b15_active) TextDrawShowForPlayer(playerid, B_AlignmentActive);
	if(b16_active) TextDrawShowForPlayer(playerid, B_SwitchPublicActive);
	if(b17_active) TextDrawShowForPlayer(playerid, B_SelectableActive);
	if(b18_active) TextDrawShowForPlayer(playerid, B_ProportionalityActive);
	NTDPlayer[InEditor] = true;
	return 1;
}

stock HideEditor(playerid)
{
	#if defined DEBUGMODE 
	print("[NTD]Hiding Editor");
	#endif
	TextDrawHideForPlayer(playerid, E_Box);

	TextDrawHideForPlayer(playerid, B_NewActive);
	TextDrawHideForPlayer(playerid, B_OpenActive);
	TextDrawHideForPlayer(playerid, B_CloseActive);
	TextDrawHideForPlayer(playerid, B_ExportActive);
	TextDrawHideForPlayer(playerid, B_ManageActive);
	TextDrawHideForPlayer(playerid, B_FontActive);
	TextDrawHideForPlayer(playerid, B_PositionActive);
	TextDrawHideForPlayer(playerid, B_SizeActive);
	TextDrawHideForPlayer(playerid, B_TekstActive);
	TextDrawHideForPlayer(playerid, B_ColorActive);
	TextDrawHideForPlayer(playerid, B_OutlineActive);
	TextDrawHideForPlayer(playerid, B_ShadowActive);
	TextDrawHideForPlayer(playerid, B_UseBoxActive);
	TextDrawHideForPlayer(playerid, B_AlignmentActive);
	TextDrawHideForPlayer(playerid, B_SwitchPublicActive);
	TextDrawHideForPlayer(playerid, B_SelectableActive);
	TextDrawHideForPlayer(playerid, B_ProportionalityActive);
	TextDrawHideForPlayer(playerid, B_MPreviewActive);
	
	return 1;
}

stock DestroyEditor()
{
	#if defined DEBUGMODE 
	print("[NTD]Destroying Editor");
	#endif
	TextDrawDestroy(E_Box);
	
	TextDrawDestroy(B_NewActive);
	TextDrawDestroy(B_OpenActive);
	TextDrawDestroy(B_CloseActive);
	TextDrawDestroy(B_ExportActive);
	TextDrawDestroy(B_ManageActive);
	TextDrawDestroy(B_FontActive);
	TextDrawDestroy(B_PositionActive);
	TextDrawDestroy(B_SizeActive);
	TextDrawDestroy(B_TekstActive);
	TextDrawDestroy(B_ColorActive);
	TextDrawDestroy(B_OutlineActive);
	TextDrawDestroy(B_ShadowActive);
	TextDrawDestroy(B_UseBoxActive);
	TextDrawDestroy(B_AlignmentActive);
	TextDrawDestroy(B_SwitchPublicActive);
	TextDrawDestroy(B_SelectableActive);
	TextDrawDestroy(B_ProportionalityActive);
	TextDrawDestroy(B_MPreviewActive);

	return 1;
}

stock WriteIntoList(name[])
{
	new string[500];
	if(dfile_FileExists("NTD/ntdlist.list"))
	{
		dfile_Open("NTD/ntdlist.list");
		for(new i; i < MAX_PROJECTS; i++)
		{
			format(string, sizeof string, "Project_%i", i);
			new prname[128];
			format(prname, 128, dfile_ReadString(string));
			if(strlen(prname) == 0)
			{
				format(name, 128, "%s.ntdp", name);
				dfile_WriteString(string, name);
				dfile_SaveFile();
				dfile_CloseFile();
				return 1;
			}
		}
	}
	return 1;
}

stock CreateEditor()
{
	#if defined DEBUGMODE 
	print("[NTD]Creating Editor");
	#endif

	E_Box = TextDrawCreate(0.000000, 412.000000, "~n~~n~");
	TextDrawFont(E_Box, 1);
	TextDrawLetterSize(E_Box, 0.600000, 2.000000);
	TextDrawTextSize(E_Box, 640.000000, 17.000000);
	TextDrawBoxColor(E_Box, 255);
	TextDrawUseBox(E_Box, 1);
	
	B_NewActive = TextDrawCreate(0, BUTTON_HEIGHT, BUTTON_NEW_ACTIVE);
	TextDrawFont(B_NewActive, 4);
	TextDrawTextSize(B_NewActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_NewActive, true);
	
	B_OpenActive = TextDrawCreate(BUTTON_SPACER, BUTTON_HEIGHT, BUTTON_OPEN_ACTIVE);
	TextDrawFont(B_OpenActive, 4);
	TextDrawTextSize(B_OpenActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_OpenActive, true);
	
	B_CloseActive = TextDrawCreate(BUTTON_SPACER * 2, BUTTON_HEIGHT, BUTTON_CLOSE_ACTIVE);
	TextDrawFont(B_CloseActive, 4);
	TextDrawTextSize(B_CloseActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_CloseActive, true);
	
	B_ExportActive = TextDrawCreate(BUTTON_SPACER * 3, BUTTON_HEIGHT, BUTTON_EXPORT_ACTIVE);
	TextDrawFont(B_ExportActive, 4);
	TextDrawTextSize(B_ExportActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_ExportActive, true);
	
	B_ManageActive = TextDrawCreate(BUTTON_SPACER * 4, BUTTON_HEIGHT, BUTTON_MANAGE_ACTIVE);
	TextDrawFont(B_ManageActive, 4);
	TextDrawTextSize(B_ManageActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_ManageActive, true);
	
	B_FontActive = TextDrawCreate(BUTTON_SPACER * 5, BUTTON_HEIGHT, BUTTON_FONT_ACTIVE);
	TextDrawFont(B_FontActive, 4);
	TextDrawTextSize(B_FontActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_FontActive, true);
	
	B_MPreviewActive = TextDrawCreate(BUTTON_SPACER * 6, BUTTON_HEIGHT, BUTTON_MPREVIEW_ACTIVE);
	TextDrawFont(B_MPreviewActive, 4);
	TextDrawTextSize(B_MPreviewActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_MPreviewActive, true);
	
	B_PositionActive = TextDrawCreate(BUTTON_SPACER * 7, BUTTON_HEIGHT, BUTTON_POSITION_ACTIVE);
	TextDrawFont(B_PositionActive, 4);
	TextDrawTextSize(B_PositionActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_PositionActive, true);
	
	B_SizeActive = TextDrawCreate(BUTTON_SPACER * 8, BUTTON_HEIGHT, BUTTON_SIZE_ACTIVE);
	TextDrawFont(B_SizeActive, 4);
	TextDrawTextSize(B_SizeActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_SizeActive, true);
	
	B_TekstActive = TextDrawCreate(BUTTON_SPACER * 9, BUTTON_HEIGHT, BUTTON_TEKST_ACTIVE);
	TextDrawFont(B_TekstActive, 4);
	TextDrawTextSize(B_TekstActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_TekstActive, true);
	
	B_ColorActive = TextDrawCreate(BUTTON_SPACER * 10, BUTTON_HEIGHT, BUTTON_COLOR_ACTIVE);
	TextDrawFont(B_ColorActive, 4);
	TextDrawTextSize(B_ColorActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_ColorActive, true);
	
	B_OutlineActive = TextDrawCreate(BUTTON_SPACER * 11, BUTTON_HEIGHT, BUTTON_OUTLINE_ACTIVE);
	TextDrawFont(B_OutlineActive, 4);
	TextDrawTextSize(B_OutlineActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_OutlineActive, true);
	
	B_ShadowActive = TextDrawCreate(BUTTON_SPACER * 12, BUTTON_HEIGHT, BUTTON_SHADOW_ACTIVE);
	TextDrawFont(B_ShadowActive, 4);
	TextDrawTextSize(B_ShadowActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_ShadowActive, true);
	
	B_UseBoxActive = TextDrawCreate(BUTTON_SPACER * 13, BUTTON_HEIGHT, BUTTON_USEBOX_ACTIVE);
	TextDrawFont(B_UseBoxActive, 4);
	TextDrawTextSize(B_UseBoxActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_UseBoxActive, true);
	
	B_AlignmentActive = TextDrawCreate(BUTTON_SPACER * 14, BUTTON_HEIGHT, BUTTON_ALIGNMENT_ACTIVE);
	TextDrawFont(B_AlignmentActive, 4);
	TextDrawTextSize(B_AlignmentActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_AlignmentActive, true);
	
	B_SwitchPublicActive = TextDrawCreate(BUTTON_SPACER * 15, BUTTON_HEIGHT, BUTTON_SWITCHPUBLIC_ACTIVE);
	TextDrawFont(B_SwitchPublicActive, 4);
	TextDrawTextSize(B_SwitchPublicActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_SwitchPublicActive, true);
	
	B_SelectableActive = TextDrawCreate(BUTTON_SPACER * 16, BUTTON_HEIGHT, BUTTON_SELECTABLE_ACTIVE);
	TextDrawFont(B_SelectableActive, 4);
	TextDrawTextSize(B_SelectableActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_SelectableActive, true);
	
	B_ProportionalityActive = TextDrawCreate(BUTTON_SPACER * 17, BUTTON_HEIGHT, BUTTON_PROPORTIONALITY_ACTIVE);
	TextDrawFont(B_ProportionalityActive, 4);
	TextDrawTextSize(B_ProportionalityActive, BUTTON_SIZE, BUTTON_SIZE);
	TextDrawSetSelectable(B_ProportionalityActive, true);
	

	if(!dfile_FileExists("ntdlist.list"))
	{
		dfile_Create("NTD/ntdlist.list");
	}

	return 1;
}

stock HexToInt(string[])
{
    if(!string[0]) return 0;
    new cur = 1, res = 0;
    for(new i = strlen(string); i > 0; i--)
    {
        res += cur * (string[i - 1] - ((string[i - 1] < 58) ? (48) : (55)));
        cur = cur * 16;
    }
    return res;
}

stock IsNumeric(const string[])
{
    for (new i = 0, j = strlen(string); i < j; i++)
    {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

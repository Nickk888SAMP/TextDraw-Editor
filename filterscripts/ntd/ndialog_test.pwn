#include <a_samp>
#include <zcmd>
#include <ndialog>

CMD:dialog1(playerid)
{
	OpenDialog(playerid, "test_dialog1", DIALOG_STYLE_MSGBOX, "To jest Message Box", "To jest mój tekst", "Przycisk 1", "Przycisk 2");
	return 1;
}

CMD:dialog2(playerid)
{
	OpenDialog(playerid, "test_dialog2", DIALOG_STYLE_INPUT, "To jest Input Box", "To jest mój tekst", "Przycisk 1", "Przycisk 2");
	return 1;
}

CMD:dialog3(playerid)
{
	OpenDialog(playerid, "test_dialog3", DIALOG_STYLE_PASSWORD, "To jest Password Box", "Wpisz has³o", "Przycisk 1", "Przycisk 2");
	return 1;
}


DIALOG:test_dialog1(playerid, response)
{
	if(response)
	{
		SendClientMessage(playerid, -1, "To by³ mój pierwszy dialog! Który posiada wiadomoœæ!");
	}
	return 1;
}

DIALOG:test_dialog2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[128];
		format(string, sizeof string, "Wpisa³eœ: {FF0000}%s", inputtext);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

DIALOG:test_dialog3(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new string[128];
		format(string, sizeof string, "Twoje has³o to: {FF0000}%s", inputtext);
		SendClientMessage(playerid, -1, string);
	}
	return 1;
}

CMD:dialog(playerid)
{
	OpenDialog(playerid, "test_dialog", DIALOG_STYLE_LIST, "Choose your weapon!", \
	"AK-47\n \
	Desert Eagle\n \
	MINIGUN!\n \
	Dildo", "Button 1", "Button 2");
	return 1;
}

DIALOG:test_dialog(playerid, response, listitem)
{
	if(response)
	{
		switch(listitem)
		{
			case 0: GivePlayerWeapon(playerid, WEAPON_AK47, 100);
			case 1: GivePlayerWeapon(playerid, WEAPON_DEAGLE, 50);
			case 2: GivePlayerWeapon(playerid, WEAPON_MINIGUN, 5000);
			case 3: GivePlayerWeapon(playerid, WEAPON_DILDO, 1);
		}
		SendClientMessage(playerid, -1, "You have got a weapon!");
	}
	return 1;
}






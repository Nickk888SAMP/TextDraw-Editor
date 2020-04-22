/* Anty Money Hack
 *
 * (c) Copyright 2010, DrunkeR
 *
 */
#if defined _money_included
  #endinput
#endif
#define _money_included
#pragma library money

/* Native's
native GiveMoney(playerid, money);
native SetMoney(playerid, money);
native GetMoney(playerid);
native ResetMoney(playerid);
native OnMoneyUpdate(playerid);
*/

stock GiveMoney(playerid, money)
	return SetPVarInt(playerid, "money", GetPVarInt(playerid, "money") + money) & OnMoneyUpdate(playerid);

stock SetMoney(playerid, money)
	return SetPVarInt(playerid, "money", money) & OnMoneyUpdate(playerid);

stock GetMoney(playerid)
	return GetPVarInt(playerid, "money");

stock ResetMoney(playerid)
	return SetPVarInt(playerid, "money", 0) & OnMoneyUpdate(playerid);

stock OnMoneyUpdate(playerid)
	return ResetPlayerMoney(playerid) & GivePlayerMoney(playerid, GetPVarInt(playerid, "money"));
	
#define GivePlayerMoney GiveMoney
#define SetPlayerMoney SetMoney
#define GetPlayerMoney GetMoney
#define ResetPlayerMoney ResetMoney

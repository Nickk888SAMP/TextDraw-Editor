/************************************************************************************************
*	Nickk's TextDraw editor																		*
*	Release: 7.0.0																				*
*	All right reserved! C By: Nickk888															*
*																								*
*	Credits:																					*
*	a_samp: SAMP Team																			*
*	sscanf2: maddinat0r																			*
*	YSI: Y_Less																					*
*	ndialogpages: Nickk888 																		*
*	progress2: Southclaws 																		*
*	ASCII Art Generator: https://patorjk.com/software/taag/#p=display&h=0&v=0&f=Big				*
*																								*
*	YOU ARE NOT ALLOWED TO RECREATE THIS FILTERSCRIPT WITHOUT									*
*	GIVEN ANY CREDITS! DO NOT COPY THIS SCRIPT ELSEWHERE!										*
*************************************************************************************************/

#define MAX_PLAYERS 2
#include <modules\defines>

/*
  ___               _             _            
 |_ _|  _ _    __  | |  _  _   __| |  ___   ___
  | |  | ' \  / _| | | | || | / _` | / -_) (_-<
 |___| |_||_| \__| |_|  \_,_| \__,_| \___| /__/
                                               
*/

#tryinclude <crashdetect>
#include <a_samp>
#include <sscanf2>
#include <ndialog-pages>
#include <easyDialog>
#include <progress2>
#include <fsutil>
#include <json>
#include <YSI_Data\y_iterate>
#include <YSI_Coding\y_va>

/*
  ___                                        _      
 | __|  ___   _ _  __ __ __  __ _   _ _   __| |  ___
 | _|  / _ \ | '_| \ V  V / / _` | | '_| / _` | (_-<
 |_|   \___/ |_|    \_/\_/  \__,_| |_|   \__,_| /__/
                                                    
*/

forward bool:VariableExists(const string[]);
forward BlockVarsChanger(bool:block);
forward ChangingVarsTime();
forward PlayerSelectTD(playerid, bool:select);
forward HLTD(playerid, td);
forward FadeTimer(bool:fadein);

/*
  __  __            _          _            
 |  \/  |  ___   __| |  _  _  | |  ___   ___
 | |\/| | / _ \ / _` | | || | | | / -_) (_-<
 |_|  |_| \___/ \__,_|  \_,_| |_| \___| /__/
                                            
*/

#include <macros>
#include <variables>
#include <enumerators>
#include <utils>
#include <functions>
#include <converters>
#include <callbacks>
#include <timers>
#include <dialogs>
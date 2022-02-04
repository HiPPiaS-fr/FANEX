#include "fanex_include"

object oPC = OBJECT_SELF;
//string sScreenName = "MP_CHAT1";

void main(string sAction, string sSubAction)
{	
	if (sAction == "Send")
	{
		string sMessage = sSubAction;
	}
	else if (sAction == "Init")
	{
		//CloseGUIScreen(oPC, "SCREEN_MESSAGEMP_1");
	}
	else if (sAction == "Distance")
	{
		SetLocalFloat(oPC, "fTalk_Distance", StringToFloat(sSubAction));
		SendMessageToPC(oPC, "Distance d'écoute réglée à " + sSubAction);
	}
}
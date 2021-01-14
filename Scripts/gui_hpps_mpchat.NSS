void Talk(object oPC, string sMessage);

#include "fanex_include"

object oPC = OBJECT_SELF;
//string sScreenName = "MP_CHAT1";
string sScreenName = "SCREEN_MESSAGEMP_1";

void main(string sAction, string sSubAction)
{	
	if (sAction == "Send")
	{
		string sMessage = sSubAction;
		Talk(oPC, sSubAction);
		SetGUIObjectText(oPC, sScreenName, "inputbox", -1, "");
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

void Talk(object oPC, string sMessage)
{
	if (sMessage == ""){ }
	else
	{
		float fPortee = GetLocalFloat(oPC, "fTalk_Distance");
		float fDistance;
		object oList;
		string sName;
		string sColor;
		
		if (FindSubString(sMessage, ".", 0) == 0)
		{
			if 		(FindSubString(sMessage, ".20 ", 0) == 0){ fPortee = 20.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 4);}
			else if (FindSubString(sMessage, ".5 ", 0) == 0){ fPortee = 5.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".10 ", 0) == 0){ fPortee = 10.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 4);}
			else if (FindSubString(sMessage, ".2 ", 0) == 0){ fPortee = 2.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".Z ", 0) == 0){ fPortee = 100.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".z ", 0) == 0){ fPortee = 100.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else {SendMessageToPC(oPC, "Commande introuvable.");}
		}

		if (fPortee < 2.1f){sColor = "<color=#767676>";}
		else if (fPortee < 5.1f){sColor = "<color=#b6b6b6>";}
		else if (fPortee < 10.1f){sColor = "<color=#ffffff>";}
		else if (fPortee < 20.1f){sColor = "<color=#fdc42b>";}
		else {sColor = "<color=#fdf12b>";}
	
		oList = GetFirstPC();
		while (GetIsObjectValid(oList))
		{
			if (GetArea(oPC)==GetArea(oList))
			{
				sName = GetFanexName(oList, oPC);
			
				fDistance = GetDistanceBetween(oPC, oList);
			

				if (fDistance < fPortee)
				{
					AddListBoxRow(oList,sScreenName,"messagelistbox","Talk", "repliestext=" + sName + ": " + sColor + sMessage,"","","");
				}
			}
			oList = GetNextPC();
		}
	}
}
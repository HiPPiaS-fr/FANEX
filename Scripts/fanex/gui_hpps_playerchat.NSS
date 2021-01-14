void CreateList(object oPC, string sScreenName, string sListBox);

#include "fanex_include"

void main(string sAction, string sSubAction)
{
	object oPC = OBJECT_SELF;
	string sScreenName = "SCREEN_CHATSELECT";
	string sListBox = "PLAYER_LIST";
	
	if(sAction=="Init")
	{
		SetLocalString(oPC, "PlayerChatSelect", "Player");
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Update")
	{
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Select_PlayerOrChar")
	{
		SetLocalString(oPC, "PlayerChatSelect", sSubAction);
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Find_Dest")
	{
				
		object oList = GetFirstPC();
		string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect");
		string sName;
				
		SetLocalObject(oPC, "MP_Dest", OBJECT_INVALID);
		while (GetIsObjectValid(oList))
		{
			if (sPlayerChatSelect == "Char")
			{
				sName = GetFanexName(oPC, oList);
			}
			else
			{
				sName = GetPCPlayerName(oList);				
			}
			if (sName == sSubAction)
			{
				SetLocalObject(oPC, "MP_Dest", oList);
				SetLocalString(oPC, "MP_Dest_Name", sName);
			}

			oList = GetNextPC();
		}
		
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Send_Message")
	{
		object oDest = GetLocalObject(oPC, "MP_Dest");
		string sDest = GetLocalString(oPC, "MP_Dest_Name");
		string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect");
		string sMessage = sSubAction;
		
		if (sMessage == "")
		{
			SendMessageToPC(oPC, "Vous devez entrer un message dans le champ sous la liste avant de cliquer sur le destinataire.");
		}
		else
		{
			if (sPlayerChatSelect == "Player" && oDest != OBJECT_INVALID)
			{
				string sColor = "<color=#69d53e>";
				SendMessageToPC(oDest, sColor + "[PM]<b>" + GetPCPlayerName(oPC) + "</b> : " + sMessage);
				SendMessageToPC(oPC, sColor + "[PM]Moi à <b>" + GetPCPlayerName(oDest) + "</b> : " + sMessage);
			}
			else
			{
				string sColor = "<color=#c4892d>";
				string sSender = "<b>" + GetFanexName(oDest, oPC) + "</b> : ";
				AddListBoxRow(oDest, "SCREEN_MESSAGEMP_1", "messagelistbox", "PM", "repliestext=" + sColor + "[PM]" + sSender + sMessage,"","","");
				AddListBoxRow(oPC, "SCREEN_MESSAGEMP_1", "messagelistbox", "PM", "repliestext=" + sColor + "[PM]<b>Moi</b> à <b>" + sDest +"</b> :" + sMessage,"","","");
			}
			SetGUIObjectText(oPC, sScreenName, "Texte", -1, "");
		}
	}
	else if (sAction == "Send_All")
	{
		if (sSubAction != "")
		{		
			object oList = GetFirstPC();
			string sColor = "<color=#69d53e>";
			string sMessage = sColor + "[All] <b>" + GetPCPlayerName(oPC) + "</b> : " + sSubAction;
			
			while (GetIsObjectValid(oList))
			{
				SendMessageToPC(oList, sMessage);
				oList = GetNextPC();
			}
			SetGUIObjectText(oPC, sScreenName, "Texte", -1, "");
		}
		else 
		{
			SendMessageToPC(oPC, "Vous devez entrer un message dans le champ sous la liste avant de cliquer sur le bouton.");
		}
	}
	else if (sAction == "Send_DM")
	{
		if (sSubAction != "")
		{
			object oList = GetFirstPC();
			string sColor = "<color=#007eff>";
			string sSender= "[DM] <b>" + GetName(oPC) + "(" + GetPCPlayerName(oPC) + ")</b> : ";
			string sMessage = sColor + sSender + sSubAction;
				
			while (GetIsObjectValid(oList))
			{
				if (GetIsDM(oList) == TRUE)
				{
					SendMessageToPC(oList, sMessage);
				}
				oList = GetNextPC();
			}
			SendMessageToPC(oPC, sMessage);
			SetGUIObjectText(oPC, sScreenName, "Texte", -1, "");
		}
		else
		{
			SendMessageToPC(oPC, "Vous devez entrer un message dans le champ sous la liste avant de cliquer sur le bouton.");
		}
	}
	else if (sAction == "Send_Group")
	{
		if (sSubAction != "")
		{
			object oList = GetObjectFromRosterName(GetFirstRosterMember());
			string sColor = "<color=#69d53e>";
			string sSender= "[Group] <b>" + GetName(oPC) + "(" + GetPCPlayerName(oPC) + ")</b> : ";
			string sMessage = sColor + sSender + sSubAction;
				
			while (GetIsObjectValid(oList))
			{
				if (GetIsDM(oList) == TRUE)
				{
					SendMessageToPC(oList, sMessage);
				}
				oList = GetObjectFromRosterName(GetNextRosterMember());
			}
			SendMessageToPC(oPC, sMessage);
			SetGUIObjectText(oPC, sScreenName, "Texte", -1, "");
		}
		else
		{
			SendMessageToPC(oPC, "Vous devez entrer un message dans le champ sous la liste avant de cliquer sur le bouton.");
		}
	}
}

void CreateList(object oPC, string sScreenName, string sListBox)
{
	string sName;
	string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect");
	
	object oList;
	
	string sRow;
	string sTextFields;

	oList = GetFirstPC();
	while (GetIsObjectValid(oList))
	{
		if (sPlayerChatSelect == "Char") {sName = GetFanexName(oPC, oList);}
		else {sName = GetPCPlayerName(oList);}

		if (FindSubString(sName, "???", 0) == -1)
		{
			sRow = sName;
			sTextFields = "NAME="+sName;
			AddListBoxRow(oPC,sScreenName,sListBox,sRow,sTextFields,"","","");
		}
		oList = GetNextPC();
	}	
}
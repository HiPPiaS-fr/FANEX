// Projet Fanex par HiPPiaS : 	Fanex est un système qui cache le vrai nom du joueur au profit d'un nom que celui qui écoute aura défini.
//								Pour ne pas révéler le véritable identité du PJ, un nouveau sytème de PlayerChat a été codé.
//								Il est désormais possible d'envoyé les MP aux joueurs de manière HRP ou au personnage de manière RP à condition de le connaitre.
// 2022-02-03 :	Mise en place du script initial.

void CreateList(object oPC, string sScreenName, string sListBox);

#include "fanex_include"

void main(string sAction, string sSubAction)
{
	object oPC = OBJECT_SELF;
	string sScreenName = "SCREEN_CHATSELECT";
	string sListBox = "PLAYER_LIST";
	
	if(sAction=="Init")
	{
		SetLocalString(oPC, "PlayerChatSelect", "Player");	// Affiche la liste de joueurs par défaut.

		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Update")
	{
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Select_PlayerOrChar")
	{
		SetLocalString(oPC, "PlayerChatSelect", sSubAction);// Switch entre la liste de joueurs et celle de personnages.
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Find_Dest") // Récupère le nom personnage ou du joueur lors de la génération de la liste.

	{
				
		object oList = GetFirstPC();
		string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect");
		string sName;
				
		SetLocalObject(oPC, "MP_Dest", OBJECT_INVALID);
		while (GetIsObjectValid(oList))
		{
			if (sPlayerChatSelect == "Char")	// Si nous sommes sur la liste de personnages, le nom connu est récupéré au lieu du vrai nom.
			{
				sName = GetFanexName(oPC, oList);
			}
			else								// Sinon, on récupère le nom du joueur.
			{
				sName = GetPCPlayerName(oList);				
			}
			if (sName == sSubAction)			// Si le destinataire a été trouvé, on l'enregistre en tant qu'objet et son nom sur le PJ.
			{
				SetLocalObject(oPC, "MP_Dest", oList);
				SetLocalString(oPC, "MP_Dest_Name", sName);
			}

			oList = GetNextPC();
		}
		
		ClearListBox(oPC,sScreenName,sListBox);
		CreateList(oPC, sScreenName, sListBox);
	}
	else if (sAction == "Send_Message")			// Pour envoyer le message, on récupère l'objet et son nom sur le PJ en premier lieu.
	{
		object oDest = GetLocalObject(oPC, "MP_Dest");
		string sDest = GetLocalString(oPC, "MP_Dest_Name");
		string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect"); // Variable où est enregistré le type de destinatire (Joueur ou PJ).
		string sMessage = sSubAction;
		
		if (sMessage == "")
		{
			SendMessageToPC(oPC, "Vous devez entrer un message dans le champ sous la liste avant de cliquer sur le destinataire.");
		}
		else
		{
			if (sPlayerChatSelect == "Player" && oDest != OBJECT_INVALID) // Si on souhaite envoyer au joueur, on le fait avec notre nom de Joueur.
			{
				string sColor = "<color=#69d53e>";
				SendMessageToPC(oDest, sColor + "[PM]<b>" + GetPCPlayerName(oPC) + "</b> : " + sMessage);
				SendMessageToPC(oPC, sColor + "[PM]Moi à <b>" + GetPCPlayerName(oDest) + "</b> : " + sMessage);
			}
			else	// Si non (envoi en tant PJ), on récupère le nom que le PJ nous connait pour l'afficher dans son chat.
			{
				string sColor = "<color=#c4892d>";
				string sSender = "<b>" + GetFanexName(oDest, oPC) + "</b> : ";
				SendChatMessage(OBJECT_INVALID, oDest, CHAT_MODE_SERVER, sColor + "[PM]" + sSender + sMessage, FALSE);
				SendChatMessage(OBJECT_INVALID, oPC, CHAT_MODE_SERVER, sColor + "[PM]<b>Moi</b> à <b>" + sDest +"</b> :" + sMessage, FALSE);
			}
			SetGUIObjectText(oPC, sScreenName, "Texte", -1, "");
		}
	}
	else if (sAction == "Send_All") // Envoi à tous (shout).
	{
		if (sSubAction != "")		// On envoie toujous avec notre nom de joueur pas de PJ.
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
	else if (sAction == "Send_DM") // L'envoi aux DMs se fait toujours avec le nom de joueur et le vrai nom du PJ.
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
	else if (sAction == "Send_Group")	// Pour les messages de groupe, on envoie à chacun le nom connu et le nom de joueur.
	{
		if (sSubAction != "")
		{
			object oList = GetObjectFromRosterName(GetFirstRosterMember());
			
			string sColor = "<color=#69d53e>";
			string sSender= "[Group] <b>" + GetPCPlayerName(oPC) + "</b> : ";
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

void CreateList(object oPC, string sScreenName, string sListBox) // Créé la liste de joueurs dans l'UI.
{
	string sName;
	string sPlayerChatSelect = GetLocalString(oPC, "PlayerChatSelect"); // Recupère le type de liste affichée.
	
	object oList;
	
	string sRow;
	string sTextFields;

	oList = GetFirstPC();
	while (GetIsObjectValid(oList))
	{
		if (sPlayerChatSelect == "Char") {sName = GetFanexName(oPC, oList);} // Récupère le nom du PJ ou du joueur.
		else {sName = GetPCPlayerName(oList);}

		if (FindSubString(sName, "???", 0) == -1) // Si le nom du PJ est différent de ???, ajoute la ligne à la liste.
		{
			sRow = sName;
			sTextFields = "NAME="+sName;
			AddListBoxRow(oPC,sScreenName,sListBox,sRow,sTextFields,"","","");
		}
		oList = GetNextPC();
	}	
}
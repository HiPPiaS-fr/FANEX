// Projet Fanex par HiPPiaS : Fanex est un système qui cache le vrai nom du joueur au profit d'un nom que celui qui écoute aura défini.
// 2022-02-03 :	Création du OnChat pour envoyer tous les messages en mode serveur sans spécifier d'émetteur.
//				Ajout d'une fonctionnalité pour parler sur x mètres ou sur une zone.
 
void Talk(object oPC, string sMessage);

#include "fanex_include"

int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{
	Talk(oSender, sMessage);
	return FALSE;	
}

void Talk(object oPC, string sMessage)
{
	if (sMessage == ""){ }
	else
	{
		float fPortee = GetLocalFloat(oPC, "fTalk_Distance"); // Récupération de la distance d'écoute réglée (2m,5m,10m ou toute la zone).
		float fDistance;
		object oList;
		string sName;
		string sColor;
		
		if (FindSubString(sMessage, ".", 0) == 0) // Check si le joueur a pas changé la zone via le chat à l'aide des commandes .2,.5,.10 et .z)
		{
			if 		(FindSubString(sMessage, ".20 ", 0) == 0){ fPortee = 20.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 4);}
			else if (FindSubString(sMessage, ".5 ", 0) == 0){ fPortee = 5.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".10 ", 0) == 0){ fPortee = 10.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 4);}
			else if (FindSubString(sMessage, ".2 ", 0) == 0){ fPortee = 2.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".Z ", 0) == 0){ fPortee = 100.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else if (FindSubString(sMessage, ".z ", 0) == 0){ fPortee = 100.0f; sMessage = GetStringRight(sMessage, GetStringLength(sMessage) - 3);}
			else {SendMessageToPC(oPC, "Commande introuvable.");}
		}

		if (fPortee < 2.1f){sColor = "<color=#767676>";} // Définition de la couleur du texte en fonction de la distance.
		else if (fPortee < 5.1f){sColor = "<color=#b6b6b6>";}
		else if (fPortee < 10.1f){sColor = "<color=#ffffff>";}
		else if (fPortee < 20.1f){sColor = "<color=#fdc42b>";}
		else {sColor = "<color=#fdf12b>";}
	
		oList = GetFirstPC();
		while (GetIsObjectValid(oList))
		{
			if (GetArea(oPC)==GetArea(oList))
			{
				sName = "<color=#f8d1c6>" + GetFanexName(oList, oPC) + " : </c>";	// Récupère le nom attribué par celui qui écoute à celui qui parle.
			
				fDistance = GetDistanceBetween(oPC, oList);

				if (fDistance < fPortee)	// Si le joueur est à distance d'écoute, le message est envoyé au destinataire en utilisant le nom connu au lieu du vrai nom.
				{
					SendChatMessage(OBJECT_INVALID, oList, CHAT_MODE_SERVER, sName + sColor + sMessage, FALSE);
				}
			}
			oList = GetNextPC();
		}		
	}
}
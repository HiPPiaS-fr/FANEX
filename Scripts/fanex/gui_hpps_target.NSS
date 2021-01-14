//************************************ gui_hpps_target *****************************************//
//                                                                                              //
//  Scripteur : HiPPiaS                                    Date : 22/10/2017                    //
//                                                                                              //
// GUI : target_object.xml, target_enemy.xml
//**********************************************************************************************//

#include "fanex_include"

object oPC = OBJECT_SELF;										// Le PJ qui a lancé l'UI
object oTarget = GetPlayerCurrentTarget(oPC);					// L'objet ciblé


void main(string sArg0, string sArg1)							// sArg0 = nom de l'UI ciblée, sArg1 = Nom de l'objet texte ciblé et Nom souhaité (FirstName, LastName ou FullName)
{																// Si l'objet ciblé est un PJ
	if (GetIsPC(oTarget) == 1)									// On récupère son nom connu dans la bdd fanex
	{
		string sName = GetFanexName(oPC, oTarget);
		
		SetGUIObjectText(oPC, sArg0, sArg1,-1,sName);
		//SendMessageToPC(oPC, sArg0 + " : " + sArg1 + " chargé ?");
	}
	else														//Si l'objet ciblé n'est pas un PJ (à tester si c'est un DM PJ or not PJ ?)
	{															// On récupère le vrai nom technique de l'objet.
		SetGUIObjectText(oPC, sArg0, sArg1,-1,GetName(oTarget));
	}
}
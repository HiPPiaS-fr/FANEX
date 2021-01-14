//*********************************** gui_hpps_changename **************************************//
//                                                                                              //
//  Scripteur : HiPPiaS                                    Date : 22/10/2017                    //
//                                                                                              //
//**********************************************************************************************//

#include "fanex_include"


object oPC = OBJECT_SELF;			// Le PJ qui a lancé l'UI
object oTarget = GetItemActivatedTarget();

void main(string sAction, string sLocal0, string sLocal1)
{
	if (oPC == oTarget){SetGUIObjectHidden(oPC, "hpps_changename", "btnPreReset", FALSE);} // Affiche le bouton "Nom Original" si le PJ se cible lui même.
	else {SetGUIObjectHidden(oPC, "hpps_changename", "btnPreReset", TRUE);}

	if (GetIsPC(oTarget) != TRUE)
	{
		SendMessageToPC(oPC, "La cible n'est pas un joueur.");
		CloseGUIScreen(oPC,"hpps_changename");
	}
	else if (sAction == "Init")
	{	
		string sName = GetFanexName(oPC, oTarget);
		SetGUIObjectText(oPC, "hpps_changename", "TrueName",-1,sName);
		SetGUIObjectText(oPC, "hpps_changename", "txtFirstName",-1,"");
		SetGUIObjectText(oPC, "hpps_changename", "txtLastName",-1,"");
	}
	else if (sAction == "NewName")
	{
		//oTarget = GetLocalObject(oPC, "FanexTarget"); // Recupère la cible précédemment stockée en variable sur le PJ.
		SetFanexName(oPC, oTarget, sLocal0, sLocal1);
		CloseGUIScreen(oPC,"hpps_changename");
	}
	else if (sAction == "Reset")
	{
		SetGUIObjectText(oPC, "hpps_changename", "txtFirstName",-1,GetFirstName(oPC));
		SetGUIObjectText(oPC, "hpps_changename", "txtLastName",-1,GetLastName(oPC));		
	}
}
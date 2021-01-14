//include
#include "func_idcard_pc"



// script pricipal
void main()
{
	object oPC   = GetItemActivator();					// Nom du PJ
	DisplayGuiScreen(oPC, "hpps_changename", FALSE, "hpps_changename.xml");
}
/******************************************************************************
*****                          func_idcard_pc                              *****
*****                               V 1                                   *****
*****                             17/09/20                                *****
******************************************************************************/


// Déclarations
object GetoIDCard(object oPC);						// Charge la carte d'identité du PJ en tant qu'objet


//Functions

object GetoIDCard(object oPC)
{
	object oIDCard = GetFirstItemInInventory(oPC);
	while (GetTag(oIDCard) != "IDCard" && oIDCard != OBJECT_INVALID) {oIDCard = GetNextItemInInventory(oPC);} // Trouve l'IDCard dans l'inventaire
	
	if (oIDCard == OBJECT_INVALID)		// Si elle n'a pas été trouvée, créé la carte.
	{
		//SendMessageToPC ( oPC, "Carte d'identité non présente. Création en cours...");
		oIDCard = CreateItemOnObject("IDCard", oPC);
		//InitialyseIDCard(oPC);
	}
	else if (GetLocalInt(oIDCard, "Version") != 1)  // Si la version de la carte n'est pas la bonne.
	{
		// Script de mise à jour de la carte pour passer à la version supérieure.
	}	
	return oIDCard;
}
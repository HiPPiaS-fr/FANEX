/******************************************************************************
*****                             Onload                                  *****
*****                               V 1                                   *****
*****                            17/09/20                                 *****
******************************************************************************/

//include
#include "func_idcard_pc"
#include "fanex_include"

//Déclarations
object oPC = GetEnteringObject();

void main()
{
	Init_mysql(); // Vérification et Initialisation de MySQL
	Init_fanex(); // Vérification et Initialisation de la table fanex.
	CheckFanexPlayer(oPC); // Vérifie si le joueur est présent dans la table fanex.
	
	object oIDCard = GetoIDCard(oPC);
}
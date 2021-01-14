#include "nwnx_init"

string GetFanexName(object oPC, object oTarget); // oPC représente toujours le joueur qui fait la requête du nom et oTarget le nom qu'on veut afficher. Si c'est le même personnage, suffit de mettre oPC dans les 2).
string sCleanedSQLString(string sString);

void Init_fanex();
void CheckFanexPlayer(object oPC);
void SetFanexName(object oPC, object oTarget, string sFirstName, string sLastName);

void Init_fanex()
{
	if (!doesTableExist("fanex")) { 
	    SQLExecDirect("CREATE TABLE fanex (" +
	        "player varchar(64) PRIMARY KEY NOT NULL default '~'" +
	        ") ENGINE=MyISAM DEFAULT CHARSET=utf8;"
		);
		if (!doesTableExist("fanex")) { 
			PrintString("func_fanex: CREATE fanex failed.");
			return;
		}		
	}			
}

string sCleanedSQLString(string sString)
{
	int iForbidChar = FindSubString(sString, "'", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + GetStringRight(sString, GetStringLength(sString)-iForbidChar-1);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, " ", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + GetStringRight(sString, GetStringLength(sString)-iForbidChar-1);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "à", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "a" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "â", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "a" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ä", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "a" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}

	iForbidChar = FindSubString(sString, "é", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "e" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "è", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "e" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ê", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "e" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ë", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "e" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "î", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "i" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ï", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "i" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ô", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "o" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ö", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "o" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ù", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "u" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "û", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "u" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	iForbidChar = FindSubString(sString, "ü", 0);
	if (iForbidChar != -1)
	{
		sString = GetStringLeft(sString, iForbidChar) + "u" + GetStringRight(sString, GetStringLength(sString)-iForbidChar-2);
		sString = sCleanedSQLString(sString);
	}
	
	return sString;
}

void CheckFanexPlayer(object oPC)
{
	string sTag = GetTag(oPC);
	string sSQL = "SELECT player FROM fanex WHERE player='" + sTag + "'"; // Recherche le tag du pj dans la colonne player.
    SQLExecDirect(sSQL);

    if (SQLFetch() != SQL_SUCCESS) // Si le tag du PJ n'a pas été trouvé.
    {
		sTag = sCleanedSQLString(GetFirstName(oPC) + "_" + GetLastName(oPC));
	
		string sSQL = "ALTER TABLE fanex ADD "+ sTag +" VARCHAR(64) CHARACTER SET utf8 NOT NULL default '???'"; // Créé la colonne au nom du PJ
		SQLExecDirect(sSQL);
	
		sSQL = "INSERT INTO fanex (Player,"+ sTag +") VALUES ('"+ sTag +"','"+ SQLEncodeSpecialChars(GetFirstName(oPC)) + " " + SQLEncodeSpecialChars(GetLastName(oPC)) +"')"; // Ajoute le vrai nom du PJ à la colonne player à la colonne au nom du PJ.
		SQLExecDirect(sSQL);
		
		SetTag(oPC, sTag); // Définition du tag du PJ qui sera utilisé dans les lignes et colonnes de la bdd fanex.
    }
}

string GetFanexName(object oPC, object oTarget) // Récupère le nom dans la table fanex. oPC = Le joueur à qui on affiche, oTarget = Le joueur dont on récupère le nom.
{
	string sTagPC = GetTag(oPC);
	string sTagTarget = GetTag(oTarget);
	string sSQL = "SELECT " + sTagPC + " FROM fanex WHERE player='" + sTagTarget + "'"; // Va chercher le nom du PJ dans le champs dont la la ligne porte le tag du PC et la colonne portent le tag de la cible.
    SQLExecDirect(sSQL);
	
	string sName = "Error";	
	if (SQLFetch() == SQL_SUCCESS) {sName = SQLGetData(1);}
	
	return sName;
}

void SetFanexName(object oPC, object oTarget, string sFirstName, string sLastName)
{
	string sTagPC = GetTag(oPC);
	string sTagTarget = GetTag(oTarget);
	string sSQL = "UPDATE fanex SET "+ sTagPC +"='"+ SQLEncodeSpecialChars(sFirstName) + " " + SQLEncodeSpecialChars(sLastName) +"' WHERE player='" + sTagTarget + "'"; // Met à jour le nouveau nom du PJ.
	SQLExecDirect(sSQL);
}
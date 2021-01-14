// oSender - the person, NPC, or object who spoke
// oTarget - for CHAT_MODE_TELL and CHAT_MODE_SERVERMESSAGE, this is the person who is receiving the message. 
// nChannel - the CHAT_MODE_* const indicating which channel (tell, dm , shout, etc) was spoken on
// sMessage - the message that is spoken 
// return - return  FALSE to suppress the original message. return TRUE to allow it to display. 
 
int StartingConditional(object oSender, object oTarget, int nChannel, string sMessage)
{
	return FALSE;	
}
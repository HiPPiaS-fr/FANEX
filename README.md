# Fanex
Full ANonymoius EXperience

Being player on RP modules, I’m a big fan of anonymity systems that generate suspenseful atmospheres, especially when you add a touch of PVP. We often see very good systems which allow characters to be renamed but which are sometimes used hesitantly for technical reasons.

It is on this observation that the idea germinated to rethink the notion of identity on nwn2. FANEX was born …

FANEX: Full ANonymous EXperience

On Neverwinter, everyone knows everyone’s name thanks to the name you see posted everywhere. The goal of fanex is to break this system to no longer display what we see in an HRP way but what we know in an RP way.

Basics principles are very simple:

    It is the player who defines the name of his interlocutors and it’s this name that will be displayed everywhere on UIs.
    If a player disguises himself to conceal his identity, the name displayed will no longer be the known name.

How it works ?

    When creating the character, the player will indicate the real first and last names of his PC. These will later only be disclosed to DMs and player himself.
    The PC’s tag is modified using the firstname_lastname format.
    A row and a column with same format as label are created in an sql database.
    Players will then write down the names they know of each and this will fill in the fields of the table.

The real difficulty of this experience is not to create and fill this table, or even to retrieve the data from it, but to apply it to all UIs which are all designed to display real technical names of the characters.

It is this experience that I will try to share with you as regularly as possible.

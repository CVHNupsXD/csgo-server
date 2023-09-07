/* Colors available=>
\x01 = default
\x02 = darkred
\x03 = purple/teamcolor (idk)
\x04 = green
\x05 = lightgreen
\x06 = lime
\x07 = red
\x08 = grey
\x09 = yellow
\x0A = bluegrey
\x0B = blue
\x0C = darkblue
\x0D = grey2
\x0E = orchid
\x0F = lightred
\x10 = gold
*/
#include <sourcemod>

#pragma semicolon 1

#define MAXTEXTCOLORS 100

#define SERVER_TAG "[\x04AlimeGirl]\x01"

// Plugin definitions
#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
    name = "Default SM Text Replacer",
    author = "Mitch/Bacardi/Cruze",
    description = "Replaces the '[SM]' text with more color!",
    version = PLUGIN_VERSION,
    url = ""
};



public OnPluginStart()
{
    HookUserMessage(GetUserMessageId("TextMsg"), TextMsg, true);
}
public Action:TextMsg(UserMsg:msg_id, Handle:bf, const players[], playersNum, bool:reliable, bool:init)
{
    if(reliable)
    {
        new String:buffer[256];
        PbReadString(bf, "params", buffer, sizeof(buffer), 0);
        
        if(StrContains(buffer, "[SM]") == 0) 
        {
            new Handle:pack;
            CreateDataTimer(0.0, timer_strip, pack);

            WritePackCell(pack, playersNum);
            for(new i = 0; i < playersNum; i++)    
            {
                WritePackCell(pack, players[i]);
            }
            WritePackString(pack, buffer);
            ResetPack(pack);
            return Plugin_Handled;
        }
    }
    return Plugin_Continue;
}

public Action:timer_strip(Handle:timer, Handle:pack)
{
    new playersNum = ReadPackCell(pack);
    new players[playersNum];
    new client, count;

    for(new i = 0; i < playersNum; i++)
    {
        client = ReadPackCell(pack);
        if(IsClientInGame(client))
        {
            players[count++] = client;
        }
    }

    if(count < 1) return;
    
    playersNum = count;
    
    new String:buffer[255];
    ReadPackString(pack, buffer, sizeof(buffer));
    new String:QuickFormat[255];
    Format(QuickFormat, sizeof(QuickFormat), "%s", SERVER_TAG);
    ReplaceStringEx(buffer, sizeof(buffer), "[SM]", QuickFormat);
    
    new Handle:bf = StartMessage("SayText2", players, playersNum, USERMSG_RELIABLE|USERMSG_BLOCKHOOKS);
    //BfWriteString(bf, buffer);
    PbSetInt(bf, "ent_idx", -1);
    PbSetBool(bf, "chat", true);
    PbSetString(bf, "msg_name", buffer);
    PbAddString(bf, "params", "");
    PbAddString(bf, "params", "");
    PbAddString(bf, "params", "");
    PbAddString(bf, "params", "");
    EndMessage();
} 

/*
    GPB:F Stable 1.0 
    by Lucas Eduardo e Gustavo Bozzano
*/

// Includes:
#include <open.mp>

// Cores:
#define verde 0x9ACD32AA
#define vermelho 0xFF6347AA
#define branco 0xFFFFFFAA
#define cinza  0xAFAFAFAA
#define roxo 0xCA9CFFAA
#define laranja 0xFFA46BAA
#define indigo 0xD8D6FFAA
#define rosa 0xF0C9FFAA
#define limao 0x99FFB1AA
#define azul 0x0000FFAA
#define amarelo 0xFFD359AA

main()
{

}

// Variáveis globais:
new gpbMensagem[512];

// Funções nativas:
public OnGameModeInit()
{
    SetGameModeText("GPB:F Stable 1.0 "); // Nome do gamemode no launcher.
    SetNameTagDrawDistance(20.0); // Distancia de avistamento de nomes dos jogadores.
	SetWorldTime(5); // Hora inicial do servidor.
    return true;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerColor(playerid, branco); // Cor do nome do jogador.
    // TogglePlayerSpectating(playerid, true); // Jogador entra em modo espectador para ao conectar poder spawnar automaticamente.
    SetSpawnInfo(playerid, 0, random(311), 1826, -1372, 14, 269, WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0); // Informações de spawn do jogador: uma skin aleatória entre as 311, spawnando em Los Santos.
    SpawnPlayer(playerid); // Spawna o jogador de fato.
    TogglePlayerSpectating(playerid, false); // Desativa o modo espectador.
    return true;
}

public OnPlayerConnect(playerid)
{
    SetPlayerVirtualWorld(playerid, 0); // Define o jogador no mundo virtual 0.
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); // Desativa os marcadores de jogadores.
    RemovePlayerMapIcon(playerid, -1); // Remove o ícone do jogador no mapa.
    MensagemJogadorConecta(playerid); // Chama função de mostrar quem conectou-se.
    SendClientMessage(playerid, branco, "Seja bem-vindo ao GPB:Freeroam."); // Mensagem de boas-vindas.
    return true;
}

public OnPlayerDisconnect(playerid, reason)
{
    MensagemJogadorDesconecta(playerid); // Chama função de mostrar quem saiu.
    return true;
}

public OnPlayerSpawn(playerid)
{
    return true;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, WEAPON:weaponid, bodypart)
{
    return true;
}

public OnPlayerDeath(playerid, killerid, WEAPON:reason)
{
    return true;
}

public OnVehicleSpawn(vehicleid) {
    return true;
}

public OnVehicleDeath(vehicleid, killerid) {
    return true;
}

public OnPlayerStateChange(playerid, PLAYER_STATE:newstate, PLAYER_STATE:oldstate)
{
    return true;
}

public OnPlayerText(playerid, text[]) {
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return true;
}

forward MensagemJogadorConecta(playerid);
public MensagemJogadorConecta(playerid)
{
    new nome [MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(gpbMensagem, sizeof(gpbMensagem), "%s conectou-se.", nome);
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}

forward MensagemJogadorDesconecta(playerid);
public MensagemJogadorDesconecta(playerid)
{
    new nome [MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(gpbMensagem, sizeof(gpbMensagem), "%s saiu.", nome);
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}
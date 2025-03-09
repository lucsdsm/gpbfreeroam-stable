/*
    GPB:F Stable 1.0 
    by Lucas Eduardo e Gustavo Bozzano
*/

// Includes:

#include <open.mp>
#include <zcmd>
#include <sscanf2>
#include <foreach>

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

main() {}

// Enumeradores:

enum veiculoEnum {
    bool:motor,
    bool:luzes,
    bool:placa
}

// Variáveis globais:
new gpbMensagem[512]; // Armazenar strings de mensagens.

new veiculoInfo[MAX_VEHICLES][veiculoEnum]; // Array com informações dos veículos.

new veiculosNomes[212][] =  {"Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper", "Fire Truck", "Trashmaster", "Stretch", "Manana", 
	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", 
	"Mr. Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", 
	"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", 
	"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", 
	"Topfun", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", 
	"Quadbike", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", 
	"Baggage", "Dozer", "Maverick", "Vcnmav", "Rancher", "Fbirancher", "Virgo", "Greenwood", "Jetmax", "Hotrina", "Sandking", 
	"Blista Compact", "Polmav", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotrinb", "Hotring", "Bloodra", 
	"Lure", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker", "Roadtrain", "Nebula", 
	"Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona", "Fbitruck", 
	"Willard", "Forklift", "Tractor", "Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Brown Streak", "Vortex", "Vincent", 
	"Bullet", "Clover", "Sadler", "Firela", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility Van", 
	"Nevada", "Yosemite", "Windsor", "Monster 2", "Monster 3", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", 
	"Tahoma", "Savanna", "Bandito", "Freight Train Flatbed", "Streak Train Trailer", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", 
	"AT400", "DFT-30", "Huntley", "Stafford", "BF400", "Newsvan", "Tug", "Trailer (Tanker Commando)", "Emperor", "Wayfarer", "Euros", "Hotdog", 
	"Club", "Box Freight", "Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "Police LS", "Police SF", "Police LV", "Police Ranger", 
	"Picador", "Swat", "Alpha", "Phoenix", "Glenshit", "Sadlshit", "Baggage Trailer (covered)", 
	"Baggage Trailer (Uncovered)", "Trailer (Stairs)", "Boxburg", "Farm Trailer", "Street Clean Trailer"};

// Funções stock (Não são chamadas caso não sejam usadas):
stock RetornaNomeJogador(playerid) // Devolve o nome do jogador.
{
    new nome[24];
    GetPlayerName(playerid, nome, 24);
    return nome;
}

stock RetornaIdVeiculo(const nomeVeiculo[]) // Devolve o ID do veículo.
{
    for(new i; i < 211; i++) {
        if(strfind(veiculosNomes[i], nomeVeiculo, true) != -1) {
	 		return i + 400;
  		}
    }
    return -1;
}

stock EnviaMensagemComAlcance(sourceid, color, const message[], Float:range) {
    new Float:x, Float:y, Float: z;
    GetPlayerPos(sourceid, x, y, z);
    foreach(new ii:Player) {
        if(GetPlayerVirtualWorld(sourceid) == GetPlayerVirtualWorld(ii)) {
            if(IsPlayerInRangeOfPoint(ii, range, x, y, z)) {
                SendClientMessage(ii, color, message);
            }
        }
    }
}

stock CriaVeiculo(playerid, const idVeiculo, Float:x, Float:y, Float:z, Float:ang, bool:sirene) // Cria um veículo.
{
    new vehicleid = CreateVehicle(idVeiculo, x, y, z, ang, -1, -1, -1, sirene);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    return vehicleid;
}

// Calbacks nativos:
public OnGameModeInit()
{
    SetGameModeText("GPB:F Stable 1.0 "); // Nome do gamemode no launcher.
    SetNameTagDrawDistance(20.0); // Distância de avistamento de nomes dos jogadores.
	SetWorldTime(12); // Hora inicial do servidor.
    return true;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerColor(playerid, branco); // Cor do nome do jogador.
    SetSpawnInfo(playerid, 0, random(311), 1541.9520, -1674.9900, 13, 90, WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0); // Informações de spawn do jogador.
    SpawnPlayer(playerid); // Spawna o jogador de fato.
    TogglePlayerSpectating(playerid, false); // Desativa o modo espectador.
    return true;
}

public OnPlayerConnect(playerid)
{
    SetPlayerVirtualWorld(playerid, 0); // Define o jogador no mundo virtual 0.
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); // Desativa os marcadores de jogadores.
    RemovePlayerMapIcon(playerid, -1); // Remove o ícones do jogador no mapa.
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

public OnPlayerKeyStateChange(playerid, KEY:newkeys, KEY:oldkeys) {
    if (IsPlayerInAnyVehicle(playerid)) {
        if (newkeys == KEY_FIRE) {
            SetTimerEx("LigaDesligaMotor", 1000, false, "dd", playerid, GetPlayerVehicleID(playerid));
        }
    }
    return true;
}

public OnPlayerText(playerid, text[]) {
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    return 1;
}

public OnPlayerCommandPerformed(playerid, cmdtext[], success) { // Callback para um comando inexistente.
    format(gpbMensagem, 512, "Comando inexistente. Digite /comandos para ver os comandos disponíveis.", cmdtext);
    if(!success){
    	SendClientMessage(playerid, cinza, gpbMensagem);
    }
    return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    return true;
}

// Callbacks customizados:
forward MensagemJogadorConecta(playerid); // Função de mostrar quem conectou-se.
public MensagemJogadorConecta(playerid)
{
    format(gpbMensagem, sizeof(gpbMensagem), "%s conectou-se.", RetornaNomeJogador(playerid));
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}

forward MensagemJogadorDesconecta(playerid); // Função de mostrar quem saiu.
public MensagemJogadorDesconecta(playerid)
{
    new nome [MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(gpbMensagem, sizeof(gpbMensagem), "%s saiu.", RetornaNomeJogador(playerid));
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}

forward LigaDesligaMotor(playerid, vehicleid);
public LigaDesligaMotor(playerid, vehicleid)
{
    new enginem, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, enginem, lights, alarm, doors, bonnet, boot, objective);
    
    if (veiculoInfo[vehicleid][motor]) {
        veiculoInfo[vehicleid][motor] = false;
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, 500, "%s gira as chaves do seu veículo e liga-o.", RetornaNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    else {
        veiculoInfo[vehicleid][motor] = true;
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, 500, "%s gira as chaves do seu veículo e desliga-o.", RetornaNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    return 1;
}


// Comandos ZCMD:
CMD:vc(playerid, params[])
{
    new nomeVeiculo[32];
    if(sscanf(params, "s[32]", nomeVeiculo)){ // Se não for passado nenhum parâmetro.
    	SendClientMessage(playerid, cinza, "/vc [Nome do veículo]");
    	return 1;
	}

    new idVeiculo = RetornaIdVeiculo(nomeVeiculo);
    if (idVeiculo >= 400 && idVeiculo <= 611) {
        new Float:x, Float:y, Float:z, Float:ang;
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, ang);

        CriaVeiculo(playerid, idVeiculo, x, y, z, ang, false);
    }

    else {
        SendClientMessage(playerid, cinza, "Veículo inválido.");
        return 1;
    }

    return 1;
}


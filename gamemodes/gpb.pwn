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
    placa[9],
    prefixo[6]
}

// Vari�veis globais:
new gpbMensagem[512]; // Armazenar strings de mensagens.

new veiculoInfo[MAX_VEHICLES][veiculoEnum]; // Array com informa��es dos ve�culos.

new veiculosNomes[212][] =  { // Array com os nomes dos ve�culos.
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perennial", "Sentinel", "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", 
	"Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam", "Esperanto", "Taxi", "Washington", "Bobcat", 
	"Mr. Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", 
	"Trailer 1", "Previon", "Coach", "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", 
	"Seasparrow", "Pizzaboy", "Tram", "Trailer 2", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", 
	"Topfun", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic", "Sanchez", "Sparrow", "Patriot", 
	"Quadbike", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", 
	"Baggage", "Dozer", "Maverick", "San News", "Rancher", "Fbirancher", "Virgo", "Greenwood", "Jetmax", "Hotrina", "Sandking", 
	"Blista Compact", "Polmav", "Boxville", "Benson", "Mesa", "RC Goblin", "Hotrinb", "Hotring", "Bloodra", 
	"Lure", "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stuntplane", "Tanker", "Roadtrain", "Nebula", 
	"Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Towtruck", "Fortune", "Cadrona", "Fbitruck", 
	"Willard", "Forklift", "Tractor", "Combine Harvester", "Feltzer", "Remington", "Slamvan", "Blade", "Freight", "Brown Streak", "Vortex", "Vincent", 
	"Bullet", "Clover", "Sadler", "Firela", "Hustler", "Intruder", "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "UtilityVan", 
	"Nevada", "Yosemite", "Windsor", "Monster 2", "Monster 3", "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", 
	"Tahoma", "Savanna", "Bandito", "Freight Train Flatbed", "Streak Train Trailer", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", 
	"AT400", "DFT-30", "Huntley", "Stafford", "BF400", "Newsvan", "Tug", "Petrol Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", 
	"Club", "Box Freight", "Trailer 3", "Andromada", "Dodo", "RC Cam", "Launch", "Police LS", "Police SF", "Police LV", "Police Ranger", 
	"Picador", "Swat", "Alpha", "Phoenix", "Glenshit", "Sadlshit", "BaggageTrailer A", 
	"Baggage Trailer B", "TugStairs", "Boxburg", "Farm Trailer", "Utility Trailer"
};

/* Fun��es stock (N�o s�o chamadas caso n�o sejam usadas). Mas aqui est� separado para fun��es que servem para retornar algum valor, 
ou que realmente podem n�o ser chamadas. */
stock RetornarNomeJogador(playerid) // Devolve o nome do jogador.
{
    new nome[24];
    GetPlayerName(playerid, nome, 24);
    return nome;
}

stock RetornarIdVeiculo(const nomeVeiculo[]) // Devolve o ID do ve�culo.
{
    for(new i; i < 211; i++) {
        if(strfind(veiculosNomes[i], nomeVeiculo, true) != -1) {
	 		return i + 400;
  		}
    }
    return -1;
}

stock GerarPlacaVanilla() // Fun��o para gerar uma placa aleat�ria no padr�o do jogo.
{
    new placaVanilla[9] = "01ABC234";
	placaVanilla[0] = '0' + random(9);
	placaVanilla[1] = '0' + random(9);

	new letras[27] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	placaVanilla[2] = letras[random(26)];
	placaVanilla[3] = letras[random(26)];
	placaVanilla[4] = letras[random(26)];

	placaVanilla[5] = '0' + random(9);
	placaVanilla[6] = '0' + random(9);
	placaVanilla[7] = '0' + random(9);
	placaVanilla[8] = '\0';

    return placaVanilla;
}

stock GerarPlacaAmericana() // Fun��o para gerar uma placa aleat�ria no padr�o americano.
{
    new placaAmericana[8]; // 7 caracteres + '\0'

    new letras[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Gera 3 letras
    placaAmericana[0] = letras[random(26)];
    placaAmericana[1] = letras[random(26)];
    placaAmericana[2] = letras[random(26)];

    placaAmericana[3] = '-'; // Separador

    // Gera 4 n�meros
    placaAmericana[4] = '0' + random(10);
    placaAmericana[5] = '0' + random(10);
    placaAmericana[6] = '0' + random(10);
    placaAmericana[7] = '0' + random(10);
    placaAmericana[8] = '\0'; // Finaliza a string

    return placa;
}

stock GerarPlacaMercosul() // Fun��o para gerar uma placa aleat�ria no padr�o Mercosul.
{
    new placaMercosul[8]; // 7 caracteres + '\0'

    new letras[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

    // Gera 3 letras
    placaMercosul[0] = letras[random(26)];
    placaMercosul[1] = letras[random(26)];
    placaMercosul[2] = letras[random(26)];

    // Gera 1 n�mero
    placaMercosul[3] = '0' + random(10);

    // Gera 1 letra
    placaMercosul[4] = letras[random(26)];

    // Gera 2 n�meros
    placaMercosul[5] = '0' + random(10);
    placaMercosul[6] = '0' + random(10);
    placaMercosul[7] = '\0'; // Finaliza a string

    return placa;
}

stock RetornarPlacaVeiculo(vehicleid) { // Devolve a placa do ve�culo.
    new placa[9] = "";
	strcat(placa, veiculoInfo[vehicleid][placa]);
	return placa;
}

stock VerificarJogadorEmVeiculo(vehicleid) {
    for(new i = 0; i < MAX_PLAYERS; i++) {
		if(IsPlayerInVehicle(i, vehicleid) && (GetPlayerState(i) == PLAYER_STATE_DRIVER || GetPlayerState(i) == PLAYER_STATE_PASSENGER)) {
			return 1;
		}
	}
    return 0;
}

stock VerificarVeiculosNoRaioDoJogador(Float:radi, playerid, vehicleid) { // Verifica se o ve�culo est� no raio do jogador.
    new Float: PX, Float:PY, Float:PZ, Float:X, Float:Y, Float:Z;
    GetPlayerPos(playerid, PX, PY, PZ);
    GetVehiclePos(vehicleid, X,Y,Z);
    new Float:distancia = (X-PX) * (X-PX) + (Y-PY) * (Y-PY) + (Z-PZ) * (Z-PZ);

	if(distancia <= radi*radi) {
        return true;
    }

    return 0;
}

stock VerificarVeiculoSemMotor(vehicleid)  // Verifica se o ve�culo � um ve�culo sem motor.
{
    switch (GetVehicleModel(vehicleid)) {
        case 509, 510, 481, 606, 607, 610, 584, 611, 608, 435, 591, 590, 569, 570, 449, 450, 537, 538: return 1;
    }
    return 0;
}

// Calbacks nativos:
public OnGameModeInit()
{
    SetGameModeText("GPB:F Stable 1.0 "); // Nome do gamemode no launcher.
    SetNameTagDrawDistance(20.0); // Dist�ncia de avistamento de nomes dos jogadores.
    EnableStuntBonusForAll(false); // Desativa o b�nus de stunt.
	SetWorldTime(12); // Hora inicial do servidor.
    return true;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerColor(playerid, branco); // Cor do nome do jogador.
    SetSpawnInfo(playerid, 0, random(311), 1541.9520, -1674.9900, 13, 90, WEAPON_FIST, 0, WEAPON_FIST, 0, WEAPON_FIST, 0); // Informa��es de spawn do jogador.
    SpawnPlayer(playerid); // Spawna o jogador de fato.
    TogglePlayerSpectating(playerid, false); // Desativa o modo espectador.
    return true;
}

public OnPlayerConnect(playerid)
{
    VerificaNome(playerid); // Chama fun��o de verificar se o nome do jogador possui [GPB] no in�cio.
    SetPlayerVirtualWorld(playerid, 0); // Define o jogador no mundo virtual 0.
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF); // Desativa os marcadores de jogadores.
    RemovePlayerMapIcon(playerid, -1); // Remove o �cones do jogador no mapa.
    MensagemJogadorConecta(playerid); // Chama fun��o de mostrar quem conectou-se.
    SendClientMessage(playerid, branco, "Seja bem-vindo ao GPB:Freeroam."); // Mensagem de boas-vindas.
    return true;
}

public OnPlayerDisconnect(playerid, reason)
{
    MensagemJogadorDesconecta(playerid); // Chama fun��o de mostrar quem saiu.
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
        new vehicleid = GetPlayerVehicleID(playerid);
        if (newkeys == KEY_FIRE) // Bot�o "ALT" ou clique esquerdo do mouse.
        {
            if (VerificarVeiculoSemMotor(vehicleid) == 1) {
				return 1;
			}
            else {
                SetTimerEx("LigaDesligaMotor", 1000, false, "dd", playerid, GetPlayerVehicleID(playerid));
            }
        }
        else if (newkeys == KEY_ANALOG_UP) // Bot�o 8 do numpad.
        {
            if (VerificarVeiculoSemMotor(vehicleid) == 1) {
                return 1;
            }
            else {
                SetTimerEx("LigaDesligaLuzes", 500, false, "dd", playerid, GetPlayerVehicleID(playerid));
            }
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
    format(gpbMensagem, sizeof(gpbMensagem), "Comando inexistente. Digite /comandos para ver os comandos dispon�veis.", cmdtext);
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

// Fun��o para kickar o jogador
forward KickarJogador(playerid);
public KickarJogador(playerid)
{
    Kick(playerid);
    return 1;
}

forward VerificaNome(playerid); // Fun��o para verificar se o nome do jogador possui [GPB] no in�cio.
public VerificaNome(playerid)
{
    new nome[MAX_PLAYER_NAME];
	new gpb[6] = "[GPB]";
	nome = RetornarNomeJogador(playerid);
	for (new i = 0; i < 5; i++) { // Verifica sem tem o [GPB] no nome, se n�o tiver, kicka.
		if(nome[i] != gpb[i]) {
			SetTimerEx("KickarJogador", 1000, false, "i", playerid);
			SendClientMessage(playerid, vermelho, "Voc� deve usar [GPB] no come�o do nome para jogar.");
			break;
		}
	}
	return 1;
}

forward MensagemJogadorConecta(playerid); // Fun��o de mostrar quem conectou-se.
public MensagemJogadorConecta(playerid)
{
    format(gpbMensagem, sizeof(gpbMensagem), "%s conectou-se.", RetornarNomeJogador(playerid));
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}

forward MensagemJogadorDesconecta(playerid); // Fun��o de mostrar quem saiu.
public MensagemJogadorDesconecta(playerid)
{
    new nome [MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(gpbMensagem, sizeof(gpbMensagem), "%s saiu.", RetornarNomeJogador(playerid));
    SendClientMessage(playerid, cinza, gpbMensagem);
    return 1;
}

forward EnviaMensagemComAlcance(sourceid, color, const message[], Float:range); // Fun��o para enviar mensagem com alcance.
public EnviaMensagemComAlcance(sourceid, color, const message[], Float:range) 
{
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

forward CriaVeiculo(playerid, const idVeiculo, bool:sirene); // Cria um ve�culo.
public CriaVeiculo(playerid, const idVeiculo, bool:sirene)
{
    if (IsPlayerInAnyVehicle(playerid)) { // Se o player estiver em um ve�culo, apaga ele antes.
        new vehicleid = GetPlayerVehicleID(playerid);
        DestroyVehicle(vehicleid);
    }

    new Float:x, Float:y, Float:z, Float:ang;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, ang);

    new vehicleid = CreateVehicle(idVeiculo, x, y, z, ang, -1, -1, -1, sirene);

    // Gera uma placa aleat�ria para o ve�culo:
    new placaGerada[9];
    placaGerada = GerarPlacaVanilla();
    SetVehicleNumberPlate(vehicleid, placaGerada);
    veiculoInfo[vehicleid][placa] = placaGerada;

    PutPlayerInVehicle(playerid, vehicleid, 0);

    // Verifica se � um ve�culo sem motor para inici�-lo "ligado":
    if (VerificarVeiculoSemMotor(vehicleid) == 1) {
        veiculoInfo[vehicleid][motor] = true;
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, 0, 0, 0, 0, 0, 0);
    }

    // Mensagem de cria��o do ve�culo com seu nome:
    format(gpbMensagem, sizeof(gpbMensagem), "%s criado.", veiculosNomes[idVeiculo - 400]);
    SendClientMessage(playerid, cinza, gpbMensagem);

    // Par�metros do ve�culo criado:
    veiculoInfo[vehicleid][motor] = false;
    veiculoInfo[vehicleid][luzes] = false;
    return vehicleid;
}

forward LigaDesligaMotor(playerid, vehicleid);
public LigaDesligaMotor(playerid, vehicleid)
{
    new enginem, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, enginem, lights, alarm, doors, bonnet, boot, objective);
    
    if (veiculoInfo[vehicleid][motor] == true) {
        veiculoInfo[vehicleid][motor] = false;
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, sizeof(gpbMensagem), "%s gira as chaves do seu ve�culo e desliga-o.", RetornarNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    else if (veiculoInfo[vehicleid][motor] == false) {
        veiculoInfo[vehicleid][motor] = true;
        SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, sizeof(gpbMensagem), "%s gira as chaves do seu ve�culo e liga-o.", RetornarNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    return 1;
}

forward LigaDesligaLuzes(playerid, vehicleid);
public LigaDesligaLuzes(playerid, vehicleid)
{
    new enginem, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, enginem, lights, alarm, doors, bonnet, boot, objective);
    
    if (veiculoInfo[vehicleid][luzes] == true) {
        veiculoInfo[vehicleid][luzes] = false;
        SetVehicleParamsEx(vehicleid, enginem, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, sizeof(gpbMensagem), "%s desliga as luzes do seu ve�culo.", RetornarNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    else if (veiculoInfo[vehicleid][luzes] == false) {
        veiculoInfo[vehicleid][luzes] = true;
        SetVehicleParamsEx(vehicleid, enginem, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
        format(gpbMensagem, sizeof(gpbMensagem), "%s liga as luzes do seu ve�culo.", RetornarNomeJogador(playerid));
        EnviaMensagemComAlcance(playerid, roxo, gpbMensagem, 10);
    }
    return 1;
}

// Comandos ZCMD:
CMD:vc(playerid, params[]) // Comando para criar ve�culos.
{
    new nomeVeiculo[32];
    if(sscanf(params, "s[32]", nomeVeiculo)){ // Se n�o for passado nenhum par�metro.
    	SendClientMessage(playerid, cinza, "/vc [Nome do ve�culo]");
    	return 1;
	}

    new idVeiculo = RetornarIdVeiculo(nomeVeiculo);
    if (idVeiculo >= 400 && idVeiculo <= 611) {
        CriaVeiculo(playerid, idVeiculo, false);
    }

    else {
        SendClientMessage(playerid, cinza, "Ve�culo inv�lido.");
        return 1;
    }

    return 1;
}

CMD:vcs(playerid, params[]) // Comando para criar ve�culos com sirene.
{
    new nomeVeiculo[32];
    if(sscanf(params, "s[32]", nomeVeiculo)){ // Se n�o for passado nenhum par�metro.
    	SendClientMessage(playerid, cinza, "/vc [Nome do ve�culo]");
    	return 1;
    }

    new idVeiculo = RetornarIdVeiculo(nomeVeiculo);
    if (idVeiculo >= 400 && idVeiculo <= 611) {
        CriaVeiculo(playerid, idVeiculo, true);
    }

    else {
        SendClientMessage(playerid, cinza, "Ve�culo inv�lido.");
        return 1;
    }

    return 1;
}

CMD:vd(playerid, params[]) // Comando para excluir ve�culos.
{
    if (IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) != 0) { // N�o permitir exclus�o caso o jogador esteja como passageiro.
        SendClientMessage(playerid, cinza, "Voc� deve estar no banco do motorista para excluir um ve�culo.");
        return 1;
    }

    else if (IsPlayerInAnyVehicle(playerid)) { // Se o player estiver em um ve�culo, apaga ele.
        new vehicleid = GetPlayerVehicleID(playerid);
        format(gpbMensagem, 512, "%s exclu�do.", veiculosNomes[GetVehicleModel(vehicleid) - 400]);
        DestroyVehicle(vehicleid);
        SendClientMessage(playerid, cinza, gpbMensagem);
        return 1;
    }

    else { // Se n�o estiver dentro de um ve�culo, verifica se h� algum no raio.
        new veiculosProximos = 0;
        new vehicleid;
        for(new i; i != MAX_VEHICLES; i++) {
            new dist = VerificarVeiculosNoRaioDoJogador(5, playerid, i);
            if(dist) {
                vehicleid = i;
                veiculosProximos++;
            }
        }

        switch(veiculosProximos) {
            case 0: {
                SendClientMessage(playerid, cinza, "N�o h� ve�culos pr�ximos.");
            }
            case 1: {
                if (VerificarJogadorEmVeiculo(vehicleid)) {
                    SendClientMessage(playerid, cinza, "Voc� n�o pode excluir um ve�culo que est� sendo usado.");
                    return 1;
                }
                else {
                    format(gpbMensagem, sizeof(gpbMensagem), "%s exclu�do.", veiculosNomes[GetVehicleModel(vehicleid) - 400]);
                    DestroyVehicle(vehicleid);
                    SendClientMessage(playerid, cinza, gpbMensagem);
                }
            }
            default: { // Se houver mais de um ve�culo pr�ximo.
                SendClientMessage(playerid, cinza, "H� mais de um ve�culo pr�ximo. Distancie-se do que voc� n�o deseja excluir.");
            }   
        }
    }
    return 1;
}
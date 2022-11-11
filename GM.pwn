#include <a_samp>
#include <foreach>
#include <DOF2>
#include <mSelection>
#include <GVN>
#include <a_npc>
#define TEMPOESCAPARSALA                                 180000
#define BANDIDOC                                         0xFF0000AA
#define POLICIALC                                        0x0000CDAA
#define MAXCARROSCONCE 27
#define BRANCO                                           0xFFFFFFFF
#define ERROR                                            0xFF7777AA
#define VERDE                                            0x00FF00AA
#define AZUL                                             0x0000CDFF
#define PASTACONTAS                                      "Contas/%s.ini"
#define PASTAIPBANIDOS                                   "IPs Banidos/%s.ini"
#define PASTAIP                                          "IPs Registrados/%s.ini"
#define CONCESSIONARIA                                   "Concessionaria/%d.ini"
#define LOGPRINCIPAL                                     "log.txt"
#define LOGREGISTRO                                      "Logs/registros_log.txt"
#define LOGLOGIN                                         "Logs/logins_log.txt"
#define LOGSENHA                                         "Logs/senhas_log.txt"
#define LOGADMINISTRADORCMD                              "Logs/administradorcmds_log.txt"
#pragma dynamic 1600000


#define HOLDING (% 0) \
	( ( newkeys & ( % 0 ) ) == ( % 0 ) )

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

enum {

    d_senhasessao,
    d_tutorial,
    d_menu,
    d_escolherslotcarro,
    d_vendercarro,
    d_deletarcarro,
    d_entrarsala,
    d_entrarsala2,
    d_entrarsala3,
    d_entrarsala4,
    d_deixarsala,
    d_loja,
    d_loja2,
    d_trapacias
};
enum DataInfoP{

    Senha[180],
    Senhac[180],
    bool:Logando,
    bool:cSenha,
    bool:PassarTutorial,
    bool:EmTutorial,
    UltimaVisitaDia,
    UltimaVisitaMes,
    UltimaVisitaAno,
    bool:PodePassarTutorial,
    bool:TutorialConcluido,
    ParteDoTutorial,
    TimerTutorial,
    TimerCarregarOBJ,
    Skin,
    Dinheiro,
    Level,
    PaginaConce,
    veiculoconcepreview,
    SlotCarro,
    SlotCarro2,
    SlotCarro3,
    SlotCarro4,
    SlotCarro5,
    CorSlotCarro,
    CorSlotCarro2,
    CorSlotCarro3,
    CorSlotCarro4,
    CorSlotCarro5,
    PaginaGaragem,
    CorComprar,
    bool:ComprandoConce,
    bool:GaragemeConce,
    SlotCarroUsando,
    CorSlotCarroUsando,
    bool:MenuSala,
    Sala,
    IdSala,
    bool:Policial,
    bool:Bandido,
    VeiculoCorrendo,
    bool:EstaEmCorrida,
    ContagemInicialT,
    ContagemInicial,
    bool:JogandoSala,
    TimerSetTempoTD,
    TempoTD,
    CorMiniMapa,
    MiniMapaT,
    bool:NitroVeiculo,
    Nitro,
    NitroT,
    NitroT2,
    RecuperarNitroT,
    bool:NitroPermissao,
    Tag,
    Administrador,
    bool:Banido,
    Socio,
    CupomCarro,
    bool:Spawnado,
    SegundosUP,
    bool:EntrandoComecado,
    TimerDinheiro,
    bool:EscolhendoBonus,
    bool:Escudo,
    EscudoTempo,
    EscudoTimer,
    bool:Prego,
    PregoTempo,
    PregoTimer,
    bool:Missel,
    MisselTempo,
    MisselTimer,
    AttachmentIdentificar,
    AttachmentObject,
    PoderUsando,
    Float:TamanhoTDPoder,
    DistanciaMissel,
    PrimeiraVez,
    bool:MorreuBandido,
    CheckPoint,
    Volta,
    CorridaCar,
    CheckPointObj,
	bool:EstaEmGuerra,
	ArmaSlot1Inventario,
	MunicaoSlot1Inventario,
	CarregadaSlot1Inventario,
	MunicaoUsandoSlot1Inventario,
	CartuchoSlot1Inventario,
	ArmaDescarregadaSlot1Inventario
};
new PlayerInfo[MAX_PLAYERS][DataInfoP];
new Text:InicioSessaoTextDraw[MAX_PLAYERS][18];
new Text:Garagem[MAX_PLAYERS][8];
new Text:Concessionaria[MAX_PLAYERS][15];
new Text:Cores[MAX_PLAYERS][11];
new Text:MiniMapa[MAX_PLAYERS];
new Text:MiniMapa2[MAX_PLAYERS];
new Text:NitroTD[3][MAX_PLAYERS];
new Text:TempoFugirTD[MAX_PLAYERS];
new Text:NomeSalaTD[4];
new Text:SalaTD[8][MAX_PLAYERS];
new Text:DinheiroTD[MAX_PLAYERS];
new Text:BonusTD[8][MAX_PLAYERS];
new Text:Velocimetro[MAX_PLAYERS];
new Text:CorridaTD[3][MAX_PLAYERS];
new Text:AbrirMenu[2][MAX_PLAYERS];
new ano,mes,dia;
new horas,minutos,segundos;
new Text:Contagem[MAX_PLAYERS];
new maxdinheirobonus,maxnivelbonus;
new skinlist = mS_INVALID_LISTID;
new up,upsociobronze,upsocioprata,upsocioouro;
new Text:PoderTD[4][MAX_PLAYERS];
new Text:MisselTD[7][MAX_PLAYERS];
enum conce{

    veiculonome[MAX_PLAYER_NAME],
    veiculopreco,
    veiculovelocidade,
    veiculolevel,
    veiculoid,
    desbug,
    veiculomotor[MAX_PLAYER_NAME]
};
enum salainformacoes{

    s_players,
    bool:s_comecou,
    s_spawn,
    s_spawn2,
    s_timerfinalizarpartida,
    s_timerverificacao,
    bool:s_bandidoganhou,
    s_timerfugir,
    s_timerverificar,
    s_timeriniciar
};
new SalaInfo[2][salainformacoes];
enum motoinformacoes
{

    players,
    bool:comecou,
    posicaospawnar,
    premio,
    timercomecarpartida,
    timerverificarpartida,
    terminoupos
};
new MotoCrossSInfo[1][motoinformacoes];
enum carroinformacoes
{

    players,
    bool:comecou,
    posicaospawnar,
    premio,
    timercomecarpartida,
    timerverificarpartida,
    terminoupos
};
new CorridaHSInfo[1][carroinformacoes];
enum guerrainformacoes
{

    players,
    bool:comecou,
    premio,
    timercomecarpartida,
    timerverificarpartida,
};
new GuerraSInfo[1][guerrainformacoes];
new ConcessionariaI[MAXCARROSCONCE][conce];
forward ClearChatbox(playerid, lines);
forward CarregandoObjetos(playerid);
forward CreateAudioPlayerLocation(playerid, soundid);
forward CarregandoObjetos2(playerid);
forward CriarLogPrincipal(text[]);
forward CriarLogLogin(text[]);
forward CriarLogRegistro(text[]);
forward CriarLogSenha(text[]);
forward CriarLogAdministradorCMD(text[]);
forward AvancarTutorial(playerid);
forward CarregarConcessionaria();
forward AbrirAGaragem(playerid);
forward ConcluirCompra(playerid);
forward GivePlayerMoneyR(playerid, quantia);
forward EscaparSala1();
forward FinalizarJogo();
forward ComecarSala1();
forward IniciandoJogoSala1();
forward ContagemEX(playerid);
forward ChecarBandidoSala1();
forward AtualizarChatBubble();
forward VerificarSala1();
forward VerificarSala2();

public OnPlayerConnect(playerid)
{
    CarregarConta(playerid);
    new ip[100],arquivo[500];
    GetPlayerIp(playerid, ip, sizeof(ip));
    format(arquivo, sizeof(arquivo), PASTAIPBANIDOS, ip);
    if(DOF2_FileExists(arquivo)){ SetTimerEx("Kickar",1000,false,"i",playerid); return SendClientMessage(playerid, ERROR, "[AVISO]{FFFFFF}: Você esta banido(a) e não pode logar no servidor."); }
    if(PlayerInfo[playerid][Banido] == true){ SetTimerEx("Kickar",1000,false,"i",playerid); return SendClientMessage(playerid, ERROR, "[AVISO]{FFFFFF}: Você esta banido(a) e não pode logar no servidor."); }
    ResetarVariaveis(playerid);
    SetPlayerColor(playerid, -1);
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    if(IsPlayerNPC(playerid))
    {
        return SpawnPlayer(playerid);
    }
    ClearChatbox(playerid, 100);
    TogglePlayerControllable(playerid, 1);
    TogglePlayerSpectating(playerid, 1);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][0]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][1]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][2]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][3]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][4]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][5]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][6]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][7]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][8]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][9]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][10]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][12]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][13]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][14]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][15]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][16]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][17]);
    TextDrawShowForPlayer(playerid, InicioSessaoTextDraw[playerid][11]);
    SetPlayerCameraPos(playerid, -2012.1879, 227.6452, 42.9826);
    SetPlayerCameraLookAt(playerid, -2011.4672, 228.3454, 42.8425);
    SetPlayerPos(playerid, -1953.6727, 274.0313, 49.1937);
    new nomedojogador[180],nome[MAX_PLAYER_NAME],arquivo[500],ultimavisita[200];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
    format(nomedojogador, sizeof(nomedojogador), "%s", nome);
    TextDrawSetString( InicioSessaoTextDraw[playerid][14], nomedojogador);
    if(PlayerInfo[playerid][UltimaVisitaDia] == 0) { PlayerInfo[playerid][UltimaVisitaDia] = dia; }
    if(PlayerInfo[playerid][UltimaVisitaMes] == 0) { PlayerInfo[playerid][UltimaVisitaMes] = mes; }
    if(PlayerInfo[playerid][UltimaVisitaAno] == 0) { PlayerInfo[playerid][UltimaVisitaAno] = ano; }
    format(ultimavisita, sizeof(ultimavisita), "- Inicie uma sessao para entrar e comecar a jogar em nosso servidor ! sua ultima visita : %d/%d/%d", PlayerInfo[playerid][UltimaVisitaDia],PlayerInfo[playerid][UltimaVisitaMes],PlayerInfo[playerid][UltimaVisitaAno]);
    TextDrawSetString( InicioSessaoTextDraw[playerid][17], ultimavisita);
    SelectTextDraw(playerid, -1);
    PlayerInfo[playerid][Logando] = true;
    SetPlayerColor(playerid, -1);
    return 1;
}

main()
{

}
public OnGameModeInit()
{
    /*
    ConnectNPC("MeuPrimeiroNPC","PrimeiroNPC");
    ConnectNPC("MeuSegundoNPC","SegundoNPC");
    ConnectNPC("MeuTerceiroNPC","TerceiroNPC");
    */
	SetGameModeText("HotPursuit v1.0.00");
    SetTimer("AtualizarChatBubble", 1000, true);
    CarregarConcessionaria();
    getdate(ano,mes,dia);
    gettime(horas,minutos,segundos);
    new log[300];
    format(log, sizeof(log), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: Servidor iniciado com sucesso!", dia,mes,ano,horas,minutos,segundos);
    CriarLogPrincipal(log);
    skinlist = LoadModelSelectionMenu("mSelection Menus/skinsregistro.txt");

    up = 3600;
    upsociobronze = 3000;
    upsocioprata = 2400;
    upsocioouro = 1800;
    maxdinheirobonus = 6000;
    maxnivelbonus = 5;
    MotoCrossSInfo[0][premio] = 5000;
    CorridaHSInfo[0][premio] = 4000;
    GuerraSInfo[0][premio] = 4000;


	// Corrida
	new Grama[12];
	Grama[0] = CreateObject(18754, 1387.13623, -2396.85913, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[1] = CreateObject(18754, 1634.31116, -2397.13306, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[2] = CreateObject(18754, 1881.52478, -2396.56543, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[3] = CreateObject(18754, 1941.97607, -2250.66309, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[4] = CreateObject(18754, 2186.57324, -2251.34717, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[5] = CreateObject(18754, 2186.41382, -2498.92358, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[6] = CreateObject(18754, 1940.36584, -2514.97241, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[7] = CreateObject(18754, 1948.30859, -2615.68091, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[8] = CreateObject(18754, 2160.45605, -2616.54932, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[9] = CreateObject(18754, 1700.15015, -2615.47412, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[10] = CreateObject(18754, 1452.04358, -2615.41724, 212.41679,   0.00000, 0.00000, 0.00000);
	Grama[11] = CreateObject(18754, 1203.73132, -2615.12573, 212.41679,   0.00000, 0.00000, 0.00000);
	for(new i = 0; i != 12; i++) SetObjectMaterial(Grama[i], 0, 5735, "studio01_lawn", "Grass_128HV", 0xFFFFFFFF);
	//----
	CreateObject(8343, 1348.47864, -2569.22192, 212.95450,   0.00000, 0.00000, 90.00000);
	CreateObject(8344, 1365.07642, -2480.80200, 212.95450,   0.00000, 0.00000, -90.00000);
	CreateObject(8357, 1536.24524, -2456.62671, 212.98500,   0.00000, 0.00000, 90.00000);
	CreateObject(8357, 1748.82214, -2456.59082, 212.98500,   0.00000, 0.00000, 90.00000);
	CreateObject(8343, 1899.39050, -2433.65112, 212.95450,   0.00000, 0.00000, 180.00000);
	CreateObject(8357, 1923.40417, -2279.10815, 212.98500,   0.00000, 0.00000, 0.00000);
	CreateObject(8344, 1986.36890, -2232.78564, 212.95450,   0.00000, 0.00000, 180.00000);
	CreateObject(8357, 2010.53101, -2403.89648, 212.98500,   0.00000, 0.00000, 0.00000);
	CreateObject(8343, 2074.99048, -2570.00024, 212.95450,   0.00000, 0.00000, 180.00000);
	CreateObject(8357, 1924.28674, -2593.24097, 212.98500,   0.00000, 0.00000, 90.00000);
	CreateObject(8357, 1711.64050, -2593.49512, 212.98500,   0.00000, 0.00000, 90.00000);
	CreateObject(8357, 1499.07019, -2593.21997, 212.98500,   0.00000, 0.00000, 90.00000);
	CreateObject(8343, 2075.63623, -2477.91846, 212.95450,   0.00000, 0.00000, -90.00000);
	CreateObject(6524, 1505.83179, -2456.51221, 216.91789,   0.00000, 0.00000, 45.00000);
	CreateObject(7905, 1465.00427, -2438.33179, 217.46130,   0.00000, 0.00000, 7.00000);
	CreateObject(3873, 1365.64258, -2500.10474, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(3873, 1362.17346, -2548.59937, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1444.87488, -2437.49707, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1607.67566, -2437.62207, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1769.75745, -2437.64648, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(3873, 1878.26538, -2420.43481, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1853.16040, -2437.66138, 213.01620,   0.00000, 0.00000, -30.00000);
	CreateObject(987, 1863.46985, -2443.63110, 213.01620,   0.00000, 0.00000, -10.00000);
	CreateObject(987, 1875.18152, -2445.77393, 213.01620,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1887.06165, -2445.81494, 213.01620,   0.00000, 0.00000, 30.00000);
	CreateObject(987, 1897.39722, -2439.87646, 213.01620,   0.00000, 0.00000, 50.00000);
	CreateObject(987, 1905.03784, -2430.80371, 213.01620,   0.00000, 0.00000, 80.00000);
	CreateObject(987, 1864.73108, -2480.29102, 213.01620,   0.00000, 0.00000, 160.00000);
	CreateObject(5005, 1444.87488, -2476.49707, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1607.67627, -2476.47900, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1770.33875, -2476.65820, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1876.68567, -2480.40503, 213.01620,   0.00000, 0.00000, 180.00000);
	CreateObject(987, 1888.64783, -2480.40381, 213.01620,   0.00000, 0.00000, 180.00000);
	CreateObject(987, 1899.88770, -2476.27905, 213.01620,   0.00000, 0.00000, 200.00000);
	CreateObject(987, 1911.09033, -2472.16675, 213.01620,   0.00000, 0.00000, 200.00000);
	CreateObject(987, 1920.30493, -2464.48560, 213.01620,   0.00000, 0.00000, 220.00000);
	CreateObject(987, 1927.99170, -2455.49512, 213.01620,   0.00000, 0.00000, 230.00000);
	CreateObject(987, 1933.99915, -2445.09961, 213.01620,   0.00000, 0.00000, 240.00000);
	CreateObject(987, 1938.05688, -2434.02173, 213.01620,   0.00000, 0.00000, 250.00000);
	CreateObject(5005, 1906.78271, -2339.62085, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 1938.91809, -2354.72632, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 1938.94763, -2298.52661, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 1907.02637, -2176.91626, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1947.71802, -2207.87646, 213.01620,   0.00000, 0.00000, 220.00000);
	CreateObject(3873, 1965.04846, -2230.03784, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1959.48315, -2205.84839, 213.01620,   0.00000, 0.00000, 190.00000);
	CreateObject(987, 1971.37219, -2205.86426, 213.01620,   0.00000, 0.00000, 180.00000);
	CreateObject(987, 1982.53210, -2210.17627, 213.01620,   0.00000, 0.00000, 160.00000);
	CreateObject(987, 1991.29846, -2217.92578, 213.01620,   0.00000, 0.00000, 140.00000);
	CreateObject(5005, 1931.63391, -2172.36182, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1993.03088, -2174.75244, 213.01620,   0.00000, 0.00000, -40.00000);
	CreateObject(987, 2002.23645, -2182.36865, 213.01620,   0.00000, 0.00000, -40.00000);
	CreateObject(0, 2011.38525, -2190.01709, 213.01620,   0.00000, 0.00000, -50.00000);
	CreateObject(987, 2018.98743, -2199.16870, 213.01620,   0.00000, 0.00000, -60.00000);
	CreateObject(987, 2024.92078, -2209.51880, 213.01620,   0.00000, 0.00000, -70.00000);
	CreateObject(987, 2028.67505, -2220.46802, 213.01620,   0.00000, 0.00000, -80.00000);
	CreateObject(5005, 1990.93457, -2301.17847, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 2030.50769, -2315.24731, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 2030.41797, -2354.31909, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 1990.85986, -2430.08789, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 1984.59424, -2474.29248, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 2109.99585, -2433.88403, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 2118.95557, -2559.84082, 216.43340,   0.00000, 0.00000, 90.00000);
	CreateObject(5005, 2103.39038, -2593.43164, 216.43340,   0.00000, 0.00000, 60.00000);
	CreateObject(5005, 2103.39038, -2593.43164, 216.43340,   0.00000, 0.00000, 60.00000);
	CreateObject(5005, 2090.77686, -2603.86304, 216.43340,   0.00000, 0.00000, 40.00000);
	CreateObject(5005, 2077.96167, -2610.77466, 216.43340,   0.00000, 0.00000, 20.00000);
	CreateObject(5005, 2111.25879, -2464.67114, 216.43340,   0.00000, 0.00000, 120.00000);
	CreateObject(5005, 2117.37988, -2455.18066, 216.43340,   0.00000, 0.00000, 160.00000);
	CreateObject(3873, 2062.42993, -2498.51343, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(3873, 2057.19336, -2553.00098, 229.92670,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 2011.36853, -2189.87231, 213.01620,   0.00000, 0.00000, -50.00000);
	CreateObject(987, 2078.12842, -2480.03613, 212.94650,   0.00000, 0.00000, 150.00000);
	CreateObject(987, 2085.45361, -2489.21216, 212.94650,   0.00000, 0.00000, 130.00000);
	CreateObject(987, 2087.45874, -2500.84961, 212.94650,   0.00000, 0.00000, 100.00000);
	CreateObject(987, 2087.37158, -2512.68848, 212.94650,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 2087.37158, -2524.68848, 212.94650,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 2087.37158, -2536.68848, 212.94650,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 2087.37158, -2548.68848, 212.94650,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 2085.18115, -2560.15527, 212.94650,   0.00000, 0.00000, 80.00000);
	CreateObject(987, 2081.04175, -2571.21021, 212.94650,   0.00000, 0.00000, 70.00000);
	CreateObject(987, 2071.83398, -2578.64673, 212.94650,   0.00000, 0.00000, 40.00000);
	CreateObject(5005, 2034.11572, -2610.54980, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1989.51990, -2578.10547, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1871.29590, -2610.18726, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1826.87927, -2578.01563, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1614.04736, -2577.91528, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1709.17932, -2610.17188, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1546.78027, -2610.15430, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1385.33740, -2610.02612, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1502.10132, -2577.91040, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1435.81384, -2577.79639, 216.43340,   0.00000, 0.00000, 0.00000);
	CreateObject(5005, 1329.85120, -2599.69385, 216.43340,   0.00000, 0.00000, -40.00000);
	CreateObject(5005, 1308.89429, -2575.87451, 216.43340,   0.00000, 0.00000, -80.00000);
	CreateObject(5005, 1305.29236, -2539.35767, 216.43340,   0.00000, 0.00000, -90.00000);
	CreateObject(5005, 1308.73682, -2476.36865, 216.43340,   0.00000, 0.00000, -120.00000);
	CreateObject(5005, 1324.94849, -2453.69702, 216.43340,   0.00000, 0.00000, -150.00000);
	CreateObject(5005, 1326.21692, -2437.68018, 216.43340,   0.00000, 0.00000, -180.00000);
	CreateObject(987, 1346.21594, -2572.00049, 212.94350,   0.00000, 0.00000, -30.00000);
	CreateObject(987, 1338.74097, -2562.77173, 212.94350,   0.00000, 0.00000, -50.00000);
	CreateObject(987, 1334.82068, -2551.49902, 212.94350,   0.00000, 0.00000, -70.00000);
	CreateObject(987, 1334.91309, -2539.65820, 212.94350,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1334.91309, -2527.65820, 212.94350,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1334.91309, -2515.65820, 212.94350,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1334.91309, -2503.65820, 212.94350,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1337.05957, -2491.88428, 212.94350,   0.00000, 0.00000, -100.00000);
	CreateObject(987, 1343.09094, -2481.71753, 212.94350,   0.00000, 0.00000, -120.00000);
	CreateObject(987, 1354.28735, -2477.84229, 212.94350,   0.00000, 0.00000, -160.00000);
	CreateObject(987, 1365.62976, -2476.05786, 212.94350,   0.00000, 0.00000, -170.00000);
	CreateObject(13065, 1729.59412, -2566.00122, 211.02139,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1697.05750, -2577.73633, 212.95840,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1697.20972, -2565.94263, 212.95840,   0.00000, 0.00000, 90.00000);
	CreateObject(987, 1697.38293, -2556.85791, 212.95840,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1709.42737, -2556.91895, 212.95840,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1721.33472, -2556.93481, 212.95840,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1733.23889, -2557.03467, 212.95840,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1745.12085, -2557.03931, 212.95840,   0.00000, 0.00000, 0.00000);
	CreateObject(987, 1747.28271, -2566.28027, 212.95840,   0.00000, 0.00000, -90.00000);
	CreateObject(987, 1747.32495, -2554.29297, 212.95840,   0.00000, 0.00000, -90.00000);
	CreateObject(6959, 1708.18994, -2554.17749, 213.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19815, 1736.73315, -2567.27148, 215.43600,   0.00000, 0.00000, -90.00000);
	CreateObject(19899, 1736.26648, -2566.26563, 213.02760,   0.00000, 0.00000, 180.00000);
	CreateObject(19903, 1731.12964, -2567.89697, 213.02716,   0.00000, 0.00000, 0.00000);
    // MotoCross
    new verdinho[15];
    verdinho[0] = CreateObject(6959, 90.77410, 1648.34436, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[1] = CreateObject(6959, 90.82085, 1608.48962, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[2] = CreateObject(6959, 90.78777, 1568.63354, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[3] = CreateObject(6959, 49.50814, 1568.63599, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[4] = CreateObject(6959, 49.51152, 1608.56848, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[5] = CreateObject(6959, 49.76160, 1648.30688, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[6] = CreateObject(6959, 49.75192, 1688.20557, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[7] = CreateObject(6959, 91.03239, 1688.28638, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[8] = CreateObject(6959, 49.50358, 1528.78333, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[9] = CreateObject(6959, 90.58866, 1528.83569, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[10] = CreateObject(6959, 131.83597, 1528.86670, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[11] = CreateObject(6959, 131.82962, 1568.73425, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[12] = CreateObject(6959, 131.79788, 1608.58362, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[13] = CreateObject(6959, 131.81007, 1648.50134, 422.20959,   0.00000, 0.00000, 0.00000);
    verdinho[14] = CreateObject(6959, 131.85132, 1688.41333, 422.20959,   0.00000, 0.00000, 0.00000);
    for(new i = 0; i != 15; i++) SetObjectMaterial(verdinho[i], 0, 5735, "studio01_lawn", "Grass_128HV", 0xFFFFFFFF);
    //
    CreateObject(19380, 106.15559, 1650.54480, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 95.69479, 1650.57629, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 85.23387, 1650.56396, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 74.75708, 1650.55444, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.34053, 1650.56653, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.34739, 1640.96680, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.36384, 1631.38586, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.41335, 1621.74133, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 53.99087, 1621.75769, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 53.56204, 1617.00928, 422.16910,   0.00000, 70.00000, -90.00000);
    CreateObject(19380, 54.32315, 1597.13794, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 54.33290, 1587.60010, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.75654, 1587.61621, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 69.89755, 1587.63086, 422.16910,   0.00000, 60.00000, 0.00000);
    CreateObject(19380, 79.63589, 1587.64868, 424.76910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 89.38593, 1587.62146, 422.16910,   0.00000, 60.00000, 180.00000);
    CreateObject(19380, 94.68494, 1587.58691, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.12295, 1587.53943, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.11772, 1597.10754, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.15152, 1606.76587, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.14955, 1616.40625, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.08604, 1631.31995, 423.66910,   0.00000, 60.00000, 90.00000);
    CreateObject(19380, 105.14960, 1623.90625, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.13490, 1664.37622, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.12094, 1673.93701, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.15249, 1683.49878, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 105.59125, 1693.37366, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 96.09120, 1693.37366, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 86.59120, 1693.37366, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 77.07223, 1693.36731, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 67.57220, 1693.36731, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 57.96336, 1693.36328, 423.16910,   0.00000, 80.00000, 90.00000);
    CreateObject(19380, 57.95184, 1702.52197, 427.46909,   0.00000, 50.00000, 90.00000);
    CreateObject(19380, 48.45180, 1702.52197, 427.46909,   0.00000, 50.00000, 90.00000);
    CreateObject(19380, 38.95180, 1702.52197, 427.46909,   0.00000, 50.00000, 90.00000);
    CreateObject(19380, 39.41355, 1693.94189, 424.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 39.41360, 1684.44189, 424.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 39.41360, 1674.94189, 424.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 39.41360, 1665.44189, 424.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 39.49768, 1660.76672, 424.16910,   0.00000, 50.00000, -90.00000);
    CreateObject(19380, 40.16160, 1631.00342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1621.50342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1612.00342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1602.50342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1593.00342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1583.50342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1574.00342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1564.50342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.16160, 1555.00342, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.07907, 1617.21387, 421.16910,   0.00000, 60.00000, -90.00000);
    CreateObject(19380, 40.01157, 1606.64319, 421.16910,   0.00000, 60.00000, -90.00000);
    CreateObject(19380, 40.08030, 1606.60095, 421.16910,   0.00000, 60.00000, 90.00000);
    CreateObject(19444, 43.13412, 1611.88098, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 39.63410, 1611.88098, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 37.03412, 1611.88293, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 37.03093, 1601.34314, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 40.53090, 1601.34314, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 43.03090, 1601.34314, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 39.96371, 1596.03088, 421.16910,   0.00000, 60.00000, 90.00000);
    CreateObject(19380, 39.98069, 1597.14539, 421.16910,   0.00000, 60.00000, -90.00000);
    CreateObject(19444, 43.05592, 1591.82324, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 39.55590, 1591.82324, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 37.05590, 1591.82324, 423.80219,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.02394, 1586.55591, 421.16910,   0.00000, 60.00000, 90.00000);
    CreateObject(19444, 37.73960, 1572.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.28660, 1576.75879, 417.36911,   0.00000, 0.00000, 90.00000);
    CreateObject(19444, 41.23960, 1572.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 43.23960, 1572.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 43.23960, 1570.93896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 39.73960, 1570.93896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 37.73960, 1570.93896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 37.73960, 1569.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 41.23960, 1569.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19444, 43.23960, 1569.43896, 423.30219,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.48344, 1568.65857, 418.16910,   0.00000, 0.00000, 90.00000);
    CreateObject(19380, 40.48340, 1573.15857, 418.16910,   0.00000, 0.00000, 90.00000);
    CreateObject(18761, 40.31888, 1554.23059, 427.24799,   0.00000, 0.00000, 0.00000);
    CreateObject(19380, 116.42249, 1650.58569, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 126.93112, 1650.61865, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 126.90349, 1640.93469, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.23610, 1576.56677, 417.56909,   0.00000, 0.00000, 90.00000);
    CreateObject(19380, 126.97717, 1631.38562, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.02007, 1621.80591, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.00204, 1612.14514, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 126.96597, 1602.60449, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 126.98881, 1593.03955, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.02492, 1583.58691, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.03710, 1564.48914, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.08830, 1573.95520, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.07692, 1555.00378, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 127.04220, 1545.47925, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 116.68152, 1545.46948, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 106.28172, 1545.53650, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 95.88155, 1545.48206, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 85.49049, 1545.46350, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 75.14730, 1545.49841, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 64.73526, 1545.52319, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 54.33036, 1545.53638, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 43.84829, 1545.46777, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(19380, 40.05704, 1545.46252, 422.16910,   0.00000, 90.00000, 0.00000);
    CreateObject(18782, 58.56030, 1545.44275, 421.74799,   0.00000, 0.00000, 0.00000);
    CreateObject(18782, 69.80045, 1545.56238, 421.74799,   0.00000, 0.00000, -90.00000);
    CreateObject(18782, 79.74974, 1548.31763, 421.74799,   0.00000, 0.00000, 90.00000);
    CreateObject(16134, 129.22678, 1554.74377, 414.24701,   0.00000, 0.00000, 90.00000);
    CreateObject(18262, 126.71140, 1579.78296, 422.74619,   0.00000, 0.00000, 0.00000);
    CreateObject(18262, 124.71140, 1579.78296, 422.74619,   0.00000, 0.00000, 0.00000);
    CreateObject(18262, 122.71140, 1579.78296, 422.74619,   0.00000, 0.00000, 0.00000);
    CreateObject(18262, 128.71140, 1579.78296, 422.74619,   0.00000, 0.00000, 0.00000);
    CreateObject(18262, 130.71140, 1579.78296, 422.74619,   0.00000, 0.00000, 0.00000);
    CreateObject(18451, 126.76919, 1603.54199, 422.25214,   0.00000, 0.00000, 0.00000);
    CreateObject(13640, 100.85593, 1543.28210, 422.25439,   0.00000, 0.00000, 0.00000);
    CreateObject(13640, 100.85590, 1547.78210, 422.25439,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 127.76320, 1617.95825, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.78160, 1616.81140, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.76910, 1618.90417, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 128.12050, 1620.11670, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 128.35880, 1621.96472, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.65320, 1621.15344, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 126.12330, 1623.48999, 423.25360,   0.00000, 0.00000, -90.00000);
    CreateObject(18609, 121.60860, 1623.91565, 423.25360,   0.00000, 0.00000, -90.00000);
    CreateObject(18609, 122.13760, 1624.87085, 423.25360,   0.00000, 40.00000, -90.00000);
    CreateObject(18609, 126.20620, 1624.85010, 423.25360,   0.00000, 40.00000, -90.00000);
    CreateObject(18609, 122.38130, 1626.29736, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 126.07160, 1626.02954, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 127.88216, 1615.78064, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 127.89624, 1613.67712, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 127.87890, 1611.75195, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.83118, 1614.85461, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.84401, 1612.77112, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 132.95874, 1610.97437, 423.25360,   0.00000, 0.00000, 90.00000);
    CreateObject(18609, 122.36449, 1627.03735, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 126.02186, 1626.77869, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 126.14821, 1627.54602, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 122.16458, 1627.66992, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 126.18768, 1628.21936, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 121.60962, 1628.39502, 423.25360,   0.00000, 80.00000, -90.00000);
    CreateObject(18609, 88.25459, 1645.31104, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 89.77620, 1649.20581, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 89.04556, 1647.12732, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 86.87322, 1646.09070, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 85.74213, 1648.96008, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 87.74494, 1649.53015, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 86.65051, 1648.73694, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 85.99286, 1645.90979, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 84.93046, 1645.30383, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(18609, 84.58494, 1649.05420, 422.25360,   0.00000, 0.00000, 0.00000);
    CreateObject(6959, 29.25080, 1688.17053, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 29.25953, 1648.24426, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 29.22792, 1608.29907, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 29.22777, 1568.31714, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 29.24897, 1528.39929, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 49.18608, 1508.51624, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(6959, 89.06248, 1508.55933, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(6959, 129.02376, 1508.56970, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(6959, 148.95813, 1528.61853, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 148.99374, 1568.40515, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 149.02536, 1608.22192, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 149.06836, 1648.00366, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 149.08144, 1687.82849, 422.20959,   0.00000, 90.00000, 0.00000);
    CreateObject(6959, 129.05281, 1707.85620, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(6959, 89.19081, 1707.87488, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(6959, 49.24358, 1707.78735, 422.20959,   0.00000, 90.00000, 90.00000);
    CreateObject(3281, 45.31330, 1552.17493, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31330, 1556.17493, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31330, 1560.17493, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31330, 1564.17493, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07268, 1564.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07270, 1560.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07270, 1556.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07270, 1552.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07270, 1548.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.07270, 1544.18518, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 36.74936, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 40.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 44.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 48.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 52.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 56.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 60.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 64.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 68.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 72.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 76.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 80.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 84.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 88.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 47.42053, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 51.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 55.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 59.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 63.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 67.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 71.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 75.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 79.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 83.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 87.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 91.42050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 100.92050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 110.92050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 101.24940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 110.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 114.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 118.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 122.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 126.74940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 130.24940, 1540.77551, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 114.92050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 118.92050, 1550.12097, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 132.19937, 1542.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1546.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1550.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1554.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1558.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1562.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1566.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1570.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1574.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1578.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1582.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1586.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1590.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1594.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1598.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1602.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.19940, 1606.85901, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07595, 1555.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1559.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1563.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1567.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1571.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1575.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1579.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1583.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1587.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1591.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1595.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1599.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1603.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1607.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1632.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1636.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1640.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 122.07600, 1644.19458, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15907, 1632.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15910, 1636.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15910, 1640.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15910, 1644.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15910, 1648.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 132.15910, 1652.27197, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 119.91718, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 115.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 111.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 107.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 103.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 99.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 95.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 91.91720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 130.11185, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 126.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 122.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 118.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 114.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 110.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 106.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 102.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 98.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 94.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 82.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 78.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 74.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 70.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 66.11180, 1655.26001, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 62.10288, 1655.27795, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 82.41720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 78.41720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 74.41720, 1646.23010, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 59.28320, 1653.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1649.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1645.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1641.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1637.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1633.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.28320, 1629.31372, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21326, 1643.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1639.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1635.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1631.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1627.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1623.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 69.21330, 1619.66272, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 57.01468, 1626.38733, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 53.01470, 1626.38733, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 49.02376, 1624.58838, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 49.02380, 1620.58838, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 66.31191, 1617.18140, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 62.31190, 1617.18140, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 49.45100, 1599.81836, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 49.45100, 1595.81836, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 49.45100, 1591.81836, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 49.45100, 1587.81836, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.37690, 1600.01282, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 59.37690, 1596.01282, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 51.20469, 1582.92822, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 55.20470, 1582.92822, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 59.20470, 1582.92822, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 63.20470, 1582.92822, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 67.20470, 1582.92822, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 61.40807, 1592.10327, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 65.40810, 1592.10327, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 91.30800, 1592.18591, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 95.30800, 1592.18591, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 91.43357, 1582.96545, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 95.43360, 1582.96545, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 99.43360, 1582.96545, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 103.43360, 1582.96545, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 107.43360, 1582.96545, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 81.80997, 1582.99963, 425.75140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 77.61029, 1582.97766, 425.75140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 81.98630, 1592.23132, 425.75140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 77.87169, 1592.22339, 425.75140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 110.13685, 1584.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1588.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1592.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1596.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1600.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1604.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1608.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1612.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1616.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1620.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.13680, 1624.85046, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22488, 1594.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1598.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1602.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1606.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1610.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1614.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1618.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1622.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.22490, 1626.24377, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10192, 1661.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1665.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1669.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1673.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1677.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1681.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 100.10190, 1685.62341, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26389, 1661.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1665.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1669.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1673.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1677.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1681.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.26390, 1685.65088, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38546, 1696.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1692.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1688.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1684.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1680.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1676.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1672.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1668.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 44.38550, 1664.54675, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36542, 1696.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1692.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1688.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1684.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1680.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1676.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1672.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1668.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 34.36540, 1664.57458, 425.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 110.14110, 1690.87354, 423.75140,   0.00000, -10.00000, 90.00000);
    CreateObject(3281, 110.07340, 1695.00574, 424.35141,   0.00000, -10.00000, 90.00000);
    CreateObject(3281, 97.98996, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 93.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 89.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 85.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 81.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 77.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 73.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 69.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 65.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 61.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 57.99000, 1688.42383, 423.25140,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 107.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 103.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 99.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 95.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 91.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 87.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 83.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 79.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 75.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 71.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 67.97720, 1698.29578, 424.95139,   0.00000, 0.00000, 0.00000);
    CreateObject(3281, 53.29241, 1690.06348, 423.55139,   0.00000, -10.00000, 90.00000);
    CreateObject(3281, 53.33330, 1695.35486, 424.55139,   0.00000, -10.00000, 90.00000);
    CreateObject(3281, 45.31490, 1633.61401, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31430, 1629.63403, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31430, 1625.63403, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31430, 1621.63403, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.31430, 1617.63403, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.04647, 1633.75867, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.04650, 1629.75867, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.04650, 1625.75867, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.04650, 1621.75867, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.04650, 1617.75867, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.34248, 1585.82141, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 35.34250, 1581.32141, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.17101, 1581.26245, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(3281, 45.17100, 1585.26245, 423.25140,   0.00000, 0.00000, 90.00000);
    CreateObject(16613, 131.84016, 1524.39709, 422.15439,   0.00000, 0.00000, 90.00000);
    CreateObject(3244, 75.83372, 1603.68262, 422.15051,   0.00000, 0.00000, 0.00000);
    CreateObject(3244, 118.91787, 1664.83618, 422.15051,   0.00000, 0.00000, 0.00000);
    CreateObject(3244, 133.28815, 1696.12024, 422.15051,   0.00000, 0.00000, 0.00000);
    CreateObject(3244, 71.20851, 1672.17419, 422.15051,   0.00000, 0.00000, 0.00000);
    CreateObject(18236, 85.71841, 1620.49731, 422.15451,   0.00000, 0.00000, 40.00000);
    CreateObject(18234, 126.82229, 1682.09473, 422.15451,   0.00000, 0.00000, 40.00000);
    CreateObject(18236, 88.81284, 1565.47949, 422.15451,   0.00000, 0.00000, -90.00000);
    CreateObject(18236, 62.58008, 1522.58899, 422.15451,   0.00000, 0.00000, -90.00000);
    CreateObject(18236, 87.02010, 1525.07800, 422.15451,   0.00000, 0.00000, -120.00000);
    CreateObject(18236, 37.79080, 1528.64209, 422.15451,   0.00000, 0.00000, -150.00000);
    CreateVehicle(468, 44.1364, 1560.4985, 424.7548, 180.0000, -1, -1, 100);
    //
    new chao;
    chao = CreateObject(6959, 231.35970, 1994.22620, 416.61691,   0.00000, 0.00000, 0.00000);
    SetObjectMaterial(chao, 0, 10941, "silicon2_sfse", "ws_floortiles2", 0xFFFFFFFF);
    new grama[3];
    grama[0] = CreateObject(19444, 227.22249, 1989.55969, 416.58261,   0.00000, 90.00000, 90.00000);
    grama[1] = CreateObject(19444, 235.26649, 1992.46326, 416.58261,   0.00000, 90.00000, 0.00000);
    grama[2] = CreateObject(19444, 235.26649, 1993.46326, 416.58261,   0.00000, 90.00000, 0.00000);
    SetObjectMaterial(grama[0], 0, 5735, "studio01_lawn", "Grass_128HV", 0xFFFFFFFF);
    SetObjectMaterial(grama[1], 0, 5735, "studio01_lawn", "Grass_128HV", 0xFFFFFFFF);
    SetObjectMaterial(grama[2], 0, 5735, "studio01_lawn", "Grass_128HV", 0xFFFFFFFF);
    new separar[4];
    separar[0] = CreateObject(19443, 227.98260, 1989.59766, 416.08261,   90.00000, 90.00000, 90.00000);
    separar[1] = CreateObject(19443, 226.48260, 1989.59766, 416.08261,   90.00000, 90.00000, 90.00000);
    separar[2] = CreateObject(19443, 227.26060, 1991.42493, 415.08261,   0.00000, 0.00000, 90.00000);
    separar[3] = CreateObject(19443, 227.27040, 1987.86572, 415.08261,   0.00000, 0.00000, 90.00000);
    SetObjectMaterial(separar[0], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0xFFFFFFFF);
    SetObjectMaterial(separar[1], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0xFFFFFFFF);
    SetObjectMaterial(separar[2], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0xFFFFFFFF);
    SetObjectMaterial(separar[3], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0xFFFFFFFF);
    new parede[8];
    parede[0] = CreateObject(19449, 225.57449, 2000.86890, 418.08069,   0.00000, 0.00000, 0.00000);
    parede[1] = CreateObject(19449, 225.57449, 2000.86890, 421.58069,   0.00000, 0.00000, 0.00000);
    parede[2] = CreateObject(19449, 225.57272, 1991.64905, 418.08069,   0.00000, 0.00000, 0.00000);
    parede[3] = CreateObject(19449, 225.57449, 1991.66895, 421.58069,   0.00000, 0.00000, 0.00000);
    parede[4] = CreateObject(19449, 240.34641, 2000.94861, 418.08069,   0.00000, 0.00000, 0.00000);
    parede[5] = CreateObject(19449, 240.34641, 1991.44861, 418.08069,   0.00000, 0.00000, 0.00000);
    parede[6] = CreateObject(19449, 239.80121, 1986.91589, 418.08069,   0.00000, 0.00000, 90.00000);
    parede[7] = CreateObject(19449, 230.36761, 1986.93420, 418.08069,   0.00000, 0.00000, 90.00000);
    SetObjectMaterial(parede[0], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[1], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[2], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[3], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[4], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[5], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[6], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    SetObjectMaterial(parede[7], 0, 8678, "wddngchplgrnd01", "vgschapelwall01_128", 0xFFFFFFFF);
    CreateObject(11490, 220.29410, 2001.90247, 415.08069,   0.00000, 0.00000, 0.00000);
    CreateObject(19641, 225.55658, 1994.17224, 418.88049,   0.00000, 0.00000, 90.00000);
    CreateObject(19641, 225.56250, 1990.85242, 418.88049,   0.00000, 0.00000, 90.00000);
    CreateObject(736, 226.97882, 1989.55029, 427.67041,   0.00000, 0.00000, 0.00000);
    CreateObject(1280, 239.16469, 1992.87952, 417.08389,   0.00000, 0.00000, 0.00000);
    CreateObject(1280, 235.06346, 1989.78088, 417.08389,   0.00000, 0.00000, -90.00000);
    CreateObject(1280, 231.81508, 1992.89380, 417.08389,   0.00000, 0.00000, 180.00000);
    CreateObject(1280, 235.14301, 1996.29517, 417.08389,   0.00000, 0.00000, 90.00000);
    CreateObject(862, 235.28586, 1992.96167, 416.66989,   0.00000, 0.00000, 0.00000);
    CreateObject(19641, 232.44650, 1986.88586, 415.38049,   0.00000, 0.00000, 0.00000);
    CreateObject(19641, 236.44650, 1986.88586, 415.38049,   0.00000, 0.00000, 0.00000);
    CreateObject(19641, 224.64314, 1986.90894, 415.38049,   0.00000, 0.00000, 0.00000);
    CreateObject(19641, 240.37111, 1990.87097, 415.38049,   0.00000, 0.00000, 90.00000);
    CreateObject(19641, 240.37109, 1995.37097, 415.38049,   0.00000, 0.00000, 90.00000);
    CreateObject(1232, 237.69270, 1995.52332, 417.58401,   0.00000, 0.00000, 0.00000);
    CreateObject(1232, 232.18321, 1990.09961, 417.58401,   0.00000, 0.00000, 0.00000);
    CreateObject(1232, 226.67619, 1995.73254, 417.58401,   0.00000, 0.00000, 0.00000);
    new paredeinv[5];
    paredeinv[0] = CreateObject(19449, 235.80119, 1986.91589, 421.58069,   0.00000, 0.00000, 90.00000);
    paredeinv[1] = CreateObject(19449, 226.30119, 1986.91589, 421.58069,   0.00000, 0.00000, 90.00000);
    paredeinv[2] = CreateObject(19449, 240.34320, 1991.63074, 421.58069,   0.00000, 0.00000, 0.00000);
    paredeinv[3] = CreateObject(19449, 240.34320, 2001.13074, 421.58069,   0.00000, 0.00000, 0.00000);
    paredeinv[4] = CreateObject(19449, 235.49992, 1999.28601, 421.58069,   0.00000, 0.00000, 90.00000);
    SetObjectMaterial(paredeinv[0], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0x00FFFFFF);
    SetObjectMaterial(paredeinv[1], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0x00FFFFFF);
    SetObjectMaterial(paredeinv[2], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0x00FFFFFF);
    SetObjectMaterial(paredeinv[3], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0x00FFFFFF);
    SetObjectMaterial(paredeinv[4], 0, 10941, "silicon2_sfse", "ws_floortiles2", 0x00FFFFFF);

    for(new i; i != MAX_PLAYERS; i++)
	{
	    NomeSalaTD[0] = TextDrawCreate(156.017578, 138.250000, "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       0/10 Players");
	    TextDrawLetterSize(NomeSalaTD[0], 0.288360, 0.917499);
	    TextDrawAlignment(NomeSalaTD[0], 1);
	    TextDrawColor(NomeSalaTD[0], -1);
	    TextDrawSetShadow(NomeSalaTD[0], 0);
	    TextDrawSetOutline(NomeSalaTD[0], 0);
	    TextDrawBackgroundColor(NomeSalaTD[0], 51);
	    TextDrawFont(NomeSalaTD[0], 1);
	    TextDrawSetProportional(NomeSalaTD[0], 1);
	    TextDrawSetSelectable(NomeSalaTD[0], true);
	    TextDrawTextSize(NomeSalaTD[0], 532.158142, 26.000000);

	    NomeSalaTD[1] = TextDrawCreate(156.080535, 157.916641, "~l~[~y~MOTOCROSS~l~]       Premio: ~g~R$5000~l~         0/7 Players");
	    TextDrawLetterSize(NomeSalaTD[1], 0.288360, 0.917499);
	    TextDrawAlignment(NomeSalaTD[1], 1);
	    TextDrawColor(NomeSalaTD[1], -16776961);
	    TextDrawSetShadow(NomeSalaTD[1], 0);
	    TextDrawSetOutline(NomeSalaTD[1], 0);
	    TextDrawBackgroundColor(NomeSalaTD[1], 51);
	    TextDrawFont(NomeSalaTD[1], 1);
	    TextDrawSetProportional(NomeSalaTD[1], 1);
	    TextDrawSetSelectable(NomeSalaTD[1], true);
	    TextDrawTextSize(NomeSalaTD[1], 532.158142, 26.000000);

	    NomeSalaTD[2] = TextDrawCreate(156.143493, 176.999938, "~l~[~r~EUAxAFEGANI~l~]      Premio: ~g~R$20000~l~         0/30 Players");
	    TextDrawLetterSize(NomeSalaTD[2], 0.288358, 0.917499);
	    TextDrawAlignment(NomeSalaTD[2], 1);
	    TextDrawColor(NomeSalaTD[2], -16776961);
	    TextDrawSetShadow(NomeSalaTD[2], 0);
	    TextDrawSetOutline(NomeSalaTD[2], 0);
	    TextDrawBackgroundColor(NomeSalaTD[2], 51);
	    TextDrawFont(NomeSalaTD[2], 1);
	    TextDrawSetProportional(NomeSalaTD[2], 1);

	    NomeSalaTD[3] = TextDrawCreate(155.737930, 197.249923, "~l~[~b~CORRIDA~l~]            Premio: ~g~R$4000~l~         0/6 Players");
	    TextDrawLetterSize(NomeSalaTD[3], 0.288358, 0.917499);
	    TextDrawAlignment(NomeSalaTD[3], 1);
	    TextDrawColor(NomeSalaTD[3], -16776961);
	    TextDrawSetShadow(NomeSalaTD[3], 0);
	    TextDrawSetOutline(NomeSalaTD[3], 0);
	    TextDrawBackgroundColor(NomeSalaTD[3], 51);
	    TextDrawFont(NomeSalaTD[3], 1);
	    TextDrawSetProportional(NomeSalaTD[3], 1);
	    TextDrawSetSelectable(NomeSalaTD[3], true);
	    TextDrawTextSize(NomeSalaTD[3], 532.158142, 26.000000);
	
        InicioSessaoTextDraw[i][0] = TextDrawCreate(208.149154, 176.499893, "usebox");
        TextDrawLetterSize(InicioSessaoTextDraw[i][0], -0.009837, 13.851239);
        TextDrawTextSize(InicioSessaoTextDraw[i][0], 22.831726, 0.000000);
        TextDrawAlignment(InicioSessaoTextDraw[i][0], 1);
        TextDrawColor(InicioSessaoTextDraw[i][0], 0);
        TextDrawUseBox(InicioSessaoTextDraw[i][0], true);
        TextDrawBoxColor(InicioSessaoTextDraw[i][0], 102);
        TextDrawSetShadow(InicioSessaoTextDraw[i][0], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][0], 0);
        TextDrawFont(InicioSessaoTextDraw[i][0], 0);

        InicioSessaoTextDraw[i][1] = TextDrawCreate(92.424591, 291.416931, "usebox");
        TextDrawLetterSize(InicioSessaoTextDraw[i][1], 0.000000, -2.390743);
        TextDrawTextSize(InicioSessaoTextDraw[i][1], 143.710098, 0.000000);
        TextDrawAlignment(InicioSessaoTextDraw[i][1], 1);
        TextDrawColor(InicioSessaoTextDraw[i][1], 0);
        TextDrawUseBox(InicioSessaoTextDraw[i][1], true);
        TextDrawBoxColor(InicioSessaoTextDraw[i][1], 102);
        TextDrawSetShadow(InicioSessaoTextDraw[i][1], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][1], 0);
        TextDrawFont(InicioSessaoTextDraw[i][1], 0);

        InicioSessaoTextDraw[i][2] = TextDrawCreate(46.852157, 254.333312, "- Para iniciar uma sessao clique em 'entrar'.");
        TextDrawLetterSize(InicioSessaoTextDraw[i][2], 0.140774, 0.824165);
        TextDrawAlignment(InicioSessaoTextDraw[i][2], 1);
        TextDrawColor(InicioSessaoTextDraw[i][2], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][2], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][2], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][2], 51);
        TextDrawFont(InicioSessaoTextDraw[i][2], 2);
        TextDrawSetProportional(InicioSessaoTextDraw[i][2], 1);

        InicioSessaoTextDraw[i][3] = TextDrawCreate(36.139129, 247.749984, "-");
        TextDrawLetterSize(InicioSessaoTextDraw[i][3], 11.609704, 0.514999);
        TextDrawAlignment(InicioSessaoTextDraw[i][3], 1);
        TextDrawColor(InicioSessaoTextDraw[i][3], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][3], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][3], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][3], 51);
        TextDrawFont(InicioSessaoTextDraw[i][3], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][3], 1);

        InicioSessaoTextDraw[i][4] = TextDrawCreate(48.257698, 187.833358, "Iniciar sessao");
        TextDrawLetterSize(InicioSessaoTextDraw[i][4], 0.222297, 0.707499);
        TextDrawAlignment(InicioSessaoTextDraw[i][4], 1);
        TextDrawColor(InicioSessaoTextDraw[i][4], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][4], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][4], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][4], 51);
        TextDrawFont(InicioSessaoTextDraw[i][4], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][4], 1);

        InicioSessaoTextDraw[i][5] = TextDrawCreate(48.726211, 214.083343, "Nome:");
        TextDrawLetterSize(InicioSessaoTextDraw[i][5], 0.185753, 0.579165);
        TextDrawAlignment(InicioSessaoTextDraw[i][5], 1);
        TextDrawColor(InicioSessaoTextDraw[i][5], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][5], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][5], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][5], 51);
        TextDrawFont(InicioSessaoTextDraw[i][5], 2);
        TextDrawSetProportional(InicioSessaoTextDraw[i][5], 1);

        InicioSessaoTextDraw[i][6] = TextDrawCreate(41.698394, 194.833312, "-");
        TextDrawLetterSize(InicioSessaoTextDraw[i][6], 4.681688, 0.491665);
        TextDrawAlignment(InicioSessaoTextDraw[i][6], 1);
        TextDrawColor(InicioSessaoTextDraw[i][6], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][6], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][6], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][6], 51);
        TextDrawFont(InicioSessaoTextDraw[i][6], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][6], 1);

        InicioSessaoTextDraw[i][7] = TextDrawCreate(48.320648, 232.583328, "Senha:");
        TextDrawLetterSize(InicioSessaoTextDraw[i][7], 0.185753, 0.579165);
        TextDrawAlignment(InicioSessaoTextDraw[i][7], 1);
        TextDrawColor(InicioSessaoTextDraw[i][7], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][7], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][7], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][7], 51);
        TextDrawFont(InicioSessaoTextDraw[i][7], 2);
        TextDrawSetProportional(InicioSessaoTextDraw[i][7], 1);

        InicioSessaoTextDraw[i][8] = TextDrawCreate(37.139129, 262.750030, "-");
        TextDrawLetterSize(InicioSessaoTextDraw[i][8], 11.609704, 0.514999);
        TextDrawAlignment(InicioSessaoTextDraw[i][8], 1);
        TextDrawColor(InicioSessaoTextDraw[i][8], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][8], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][8], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][8], 51);
        TextDrawFont(InicioSessaoTextDraw[i][8], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][8], 1);

        InicioSessaoTextDraw[i][9] = TextDrawCreate(193.625183, 215.000000, "usebox");
        TextDrawLetterSize(InicioSessaoTextDraw[i][9], 0.000000, 0.461111);
        TextDrawTextSize(InicioSessaoTextDraw[i][9], 72.494873, 0.000000);
        TextDrawAlignment(InicioSessaoTextDraw[i][9], 1);
        TextDrawColor(InicioSessaoTextDraw[i][9], 0);
        TextDrawUseBox(InicioSessaoTextDraw[i][9], true);
        TextDrawBoxColor(InicioSessaoTextDraw[i][9], 102);
        TextDrawSetShadow(InicioSessaoTextDraw[i][9], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][9], 0);
        TextDrawFont(InicioSessaoTextDraw[i][9], 0);

        InicioSessaoTextDraw[i][10] = TextDrawCreate(198.373352, 233.499984, "usebox");
        TextDrawLetterSize(InicioSessaoTextDraw[i][10], 0.000000, 0.461111);
        TextDrawTextSize(InicioSessaoTextDraw[i][10], 76.243041, 0.000000);
        TextDrawAlignment(InicioSessaoTextDraw[i][10], 1);
        TextDrawColor(InicioSessaoTextDraw[i][10], 0);
        TextDrawUseBox(InicioSessaoTextDraw[i][10], true);
        TextDrawBoxColor(InicioSessaoTextDraw[i][10], 102);
        TextDrawSetShadow(InicioSessaoTextDraw[i][10], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][10], 0);
        TextDrawFont(InicioSessaoTextDraw[i][10], 0);

        InicioSessaoTextDraw[i][11] = TextDrawCreate(100.732101, 274.166595, "ENTRAR");
        TextDrawLetterSize(InicioSessaoTextDraw[i][11], 0.276647, 1.255833);
        TextDrawAlignment(InicioSessaoTextDraw[i][11], 1);
        TextDrawColor(InicioSessaoTextDraw[i][11], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][11], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][11], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][11], 51);
        TextDrawFont(InicioSessaoTextDraw[i][11], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][11], 1);
        TextDrawSetSelectable(InicioSessaoTextDraw[i][11], true);

        InicioSessaoTextDraw[i][12] = TextDrawCreate(74.494888, 211.750015, "I                          I");
        TextDrawLetterSize(InicioSessaoTextDraw[i][12], 0.266339, 1.051663);
        TextDrawAlignment(InicioSessaoTextDraw[i][12], 1);
        TextDrawColor(InicioSessaoTextDraw[i][12], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][12], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][12], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][12], 51);
        TextDrawFont(InicioSessaoTextDraw[i][12], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][12], 1);
        TextDrawSetSelectable(InicioSessaoTextDraw[i][12], false);

        InicioSessaoTextDraw[i][13] = TextDrawCreate(78.774536, 230.250000, "I                          I");
        TextDrawLetterSize(InicioSessaoTextDraw[i][13], 0.266339, 1.051663);
        TextDrawAlignment(InicioSessaoTextDraw[i][13], 1);
        TextDrawColor(InicioSessaoTextDraw[i][13], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][13], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][13], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][13], 51);
        TextDrawFont(InicioSessaoTextDraw[i][13], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][13], 1);
        TextDrawSetSelectable(InicioSessaoTextDraw[i][13], true);
        TextDrawTextSize(InicioSessaoTextDraw[i][13], 532.158142, 26.000000);

        InicioSessaoTextDraw[i][14] = TextDrawCreate(79.180130, 214.083343, "Nome_Sobrenome");
        TextDrawLetterSize(InicioSessaoTextDraw[i][14], 0.177320, 0.526665);
        TextDrawAlignment(InicioSessaoTextDraw[i][14], 1);
        TextDrawColor(InicioSessaoTextDraw[i][14], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][14], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][14], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][14], 51);
        TextDrawFont(InicioSessaoTextDraw[i][14], 2);
        TextDrawSetProportional(InicioSessaoTextDraw[i][14], 1);

        InicioSessaoTextDraw[i][15] = TextDrawCreate(83.928298, 233.166656, "Senha");
        TextDrawLetterSize(InicioSessaoTextDraw[i][15], 0.177320, 0.526665);
        TextDrawAlignment(InicioSessaoTextDraw[i][15], 1);
        TextDrawColor(InicioSessaoTextDraw[i][15], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][15], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][15], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][15], 51);
        TextDrawFont(InicioSessaoTextDraw[i][15], 2);
        TextDrawSetProportional(InicioSessaoTextDraw[i][15], 1);

        InicioSessaoTextDraw[i][16] = TextDrawCreate(642.937011, 433.166656, "usebox");
        TextDrawLetterSize(InicioSessaoTextDraw[i][16], 0.000000, 0.785187);
        TextDrawTextSize(InicioSessaoTextDraw[i][16], 275.364593, 0.000000);
        TextDrawAlignment(InicioSessaoTextDraw[i][16], 1);
        TextDrawColor(InicioSessaoTextDraw[i][16], 0);
        TextDrawUseBox(InicioSessaoTextDraw[i][16], true);
        TextDrawBoxColor(InicioSessaoTextDraw[i][16], 102);
        TextDrawSetShadow(InicioSessaoTextDraw[i][16], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][16], 0);
        TextDrawFont(InicioSessaoTextDraw[i][16], 0);

        InicioSessaoTextDraw[i][17] = TextDrawCreate(280.175598, 431.666656, "- Inicie uma sessao para entrar e comecar a jogar em nosso servidor ! sua ultima visita : 00/00/0000");
        TextDrawLetterSize(InicioSessaoTextDraw[i][17], 0.196061, 0.969998);
        TextDrawAlignment(InicioSessaoTextDraw[i][17], 1);
        TextDrawColor(InicioSessaoTextDraw[i][17], -1);
        TextDrawSetShadow(InicioSessaoTextDraw[i][17], 0);
        TextDrawSetOutline(InicioSessaoTextDraw[i][17], 1);
        TextDrawBackgroundColor(InicioSessaoTextDraw[i][17], 51);
        TextDrawFont(InicioSessaoTextDraw[i][17], 1);
        TextDrawSetProportional(InicioSessaoTextDraw[i][17], 1);

        CorridaTD[0][i] = TextDrawCreate(64.187400, 307.416656, "VOLTA: 0/3");
        TextDrawLetterSize(CorridaTD[0][i], 0.198872, 0.870833);
        TextDrawAlignment(CorridaTD[0][i], 1);
        TextDrawColor(CorridaTD[0][i], -1);
        TextDrawSetShadow(CorridaTD[0][i], 0);
        TextDrawSetOutline(CorridaTD[0][i], 1);
        TextDrawBackgroundColor(CorridaTD[0][i], 51);
        TextDrawFont(CorridaTD[0][i], 2);
        TextDrawSetProportional(CorridaTD[0][i], 1);

        CorridaTD[1][i] = TextDrawCreate(62.844795, 300.833343, "POSICAO: 1");
        TextDrawLetterSize(CorridaTD[1][i], 0.198872, 0.870833);
        TextDrawAlignment(CorridaTD[1][i], 1);
        TextDrawColor(CorridaTD[1][i], -1);
        TextDrawSetShadow(CorridaTD[1][i], 0);
        TextDrawSetOutline(CorridaTD[1][i], 1);
        TextDrawBackgroundColor(CorridaTD[1][i], 51);
        TextDrawFont(CorridaTD[1][i], 2);
        TextDrawSetProportional(CorridaTD[1][i], 1);

        CorridaTD[2][i] = TextDrawCreate(52.131767, 293.083312, "CheckPoint: 1/15");
        TextDrawLetterSize(CorridaTD[2][i], 0.198872, 0.870833);
        TextDrawAlignment(CorridaTD[2][i], 1);
        TextDrawColor(CorridaTD[2][i], -1);
        TextDrawSetShadow(CorridaTD[2][i], 0);
        TextDrawSetOutline(CorridaTD[2][i], 1);
        TextDrawBackgroundColor(CorridaTD[2][i], 51);
        TextDrawFont(CorridaTD[2][i], 2);
        TextDrawSetProportional(CorridaTD[2][i], 1);

        Contagem[i] = TextDrawCreate(301.727722, 178.500030, "5");
        TextDrawLetterSize(Contagem[i], 1.087188, 5.636666);
        TextDrawAlignment(Contagem[i], 1);
        TextDrawColor(Contagem[i], -1);
        TextDrawSetShadow(Contagem[i], 0);
        TextDrawSetOutline(Contagem[i], 1);
        TextDrawBackgroundColor(Contagem[i], 51);
        TextDrawFont(Contagem[i], 1);
        TextDrawSetProportional(Contagem[i], 1);

        AbrirMenu[0][i] = TextDrawCreate(140.213760, 429.083343, "usebox");
        TextDrawLetterSize(AbrirMenu[0][i], 0.000000, 0.673522);
        TextDrawTextSize(AbrirMenu[0][i], 35.481697, 0.000000);
        TextDrawAlignment(AbrirMenu[0][i], 1);
        TextDrawColor(AbrirMenu[0][i], 0);
        TextDrawUseBox(AbrirMenu[0][i], true);
        TextDrawBoxColor(AbrirMenu[0][i], 102);
        TextDrawSetShadow(AbrirMenu[0][i], 0);
        TextDrawSetOutline(AbrirMenu[0][i], 0);
        TextDrawFont(AbrirMenu[0][i], 0);

        AbrirMenu[1][i] = TextDrawCreate(45.446586, 427.583343, "Aperte ' ~r~Y~w~ ' para abrir o menu.");
        TextDrawLetterSize(AbrirMenu[1][i], 0.125314, 0.917499);
        TextDrawAlignment(AbrirMenu[1][i], 1);
        TextDrawColor(AbrirMenu[1][i], -1);
        TextDrawSetShadow(AbrirMenu[1][i], 0);
        TextDrawSetOutline(AbrirMenu[1][i], 1);
        TextDrawBackgroundColor(AbrirMenu[1][i], 51);
        TextDrawFont(AbrirMenu[1][i], 2);
        TextDrawSetProportional(AbrirMenu[1][i], 1);

        Velocimetro[i] = TextDrawCreate(64.655944, 329.583221, "0 KM/H");
        TextDrawLetterSize(Velocimetro[i], 0.282737, 1.028332);
        TextDrawAlignment(Velocimetro[i], 1);
        TextDrawColor(Velocimetro[i], -1);
        TextDrawSetShadow(Velocimetro[i], 0);
        TextDrawSetOutline(Velocimetro[i], 1);
        TextDrawBackgroundColor(Velocimetro[i], 51);
        TextDrawFont(Velocimetro[i], 2);
        TextDrawSetProportional(Velocimetro[i], 1);

        MisselTD[0][i] = TextDrawCreate(598.553527, 376.249755, "usebox");
        TextDrawLetterSize(MisselTD[0][i], 0.000000, 2.396118);
        TextDrawTextSize(MisselTD[0][i], 471.206146, 0.000000);
        TextDrawAlignment(MisselTD[0][i], 1);
        TextDrawColor(MisselTD[0][i], 0);
        TextDrawUseBox(MisselTD[0][i], true);
        TextDrawBoxColor(MisselTD[0][i], 102);
        TextDrawSetShadow(MisselTD[0][i], 0);
        TextDrawSetOutline(MisselTD[0][i], 0);
        TextDrawFont(MisselTD[0][i], 0);

        MisselTD[1][i] = TextDrawCreate(510.814086, 382.416656, "usebox");
        TextDrawLetterSize(MisselTD[1][i], 0.000000, 0.979631);
        TextDrawTextSize(MisselTD[1][i], 476.828735, 0.000000);
        TextDrawAlignment(MisselTD[1][i], 1);
        TextDrawColor(MisselTD[1][i], 0);
        TextDrawUseBox(MisselTD[1][i], true);
        TextDrawBoxColor(MisselTD[1][i], 102);
        TextDrawSetShadow(MisselTD[1][i], 0);
        TextDrawSetOutline(MisselTD[1][i], 0);
        TextDrawFont(MisselTD[1][i], 0);

        MisselTD[2][i] = TextDrawCreate(550.701293, 381.083343, "usebox");
        TextDrawLetterSize(MisselTD[2][i], 0.000000, 0.979631);
        TextDrawTextSize(MisselTD[2][i], 515.716064, 0.000000);
        TextDrawAlignment(MisselTD[2][i], 1);
        TextDrawColor(MisselTD[2][i], 0);
        TextDrawUseBox(MisselTD[2][i], true);
        TextDrawBoxColor(MisselTD[2][i], 102);
        TextDrawSetShadow(MisselTD[2][i], 0);
        TextDrawSetOutline(MisselTD[2][i], 0);
        TextDrawFont(MisselTD[2][i], 0);

        MisselTD[3][i] = TextDrawCreate(591.994079, 382.666687, "usebox");
        TextDrawLetterSize(MisselTD[3][i], 0.000000, 0.979631);
        TextDrawTextSize(MisselTD[3][i], 556.008850, 0.000000);
        TextDrawAlignment(MisselTD[3][i], 1);
        TextDrawColor(MisselTD[3][i], 0);
        TextDrawUseBox(MisselTD[3][i], true);
        TextDrawBoxColor(MisselTD[3][i], 102);
        TextDrawSetShadow(MisselTD[3][i], 0);
        TextDrawSetOutline(MisselTD[3][i], 0);
        TextDrawFont(MisselTD[3][i], 0);

        MisselTD[4][i] = TextDrawCreate(482.108612, 382.083312, "35 m");
        TextDrawLetterSize(MisselTD[4][i], 0.234948, 0.876667);
        TextDrawAlignment(MisselTD[4][i], 1);
        TextDrawColor(MisselTD[4][i], 16777215);
        TextDrawSetShadow(MisselTD[4][i], 0);
        TextDrawSetOutline(MisselTD[4][i], 1);
        TextDrawBackgroundColor(MisselTD[4][i], 51);
        TextDrawFont(MisselTD[4][i], 1);
        TextDrawSetProportional(MisselTD[4][i], 1);

        MisselTD[5][i] = TextDrawCreate(522.464538, 381.333282, "65 m");
        TextDrawLetterSize(MisselTD[5][i], 0.234948, 0.876667);
        TextDrawAlignment(MisselTD[5][i], 1);
        TextDrawColor(MisselTD[5][i], -1);
        TextDrawSetShadow(MisselTD[5][i], 0);
        TextDrawSetOutline(MisselTD[5][i], 1);
        TextDrawBackgroundColor(MisselTD[5][i], 51);
        TextDrawFont(MisselTD[5][i], 1);
        TextDrawSetProportional(MisselTD[5][i], 1);

        MisselTD[6][i] = TextDrawCreate(563.289062, 382.333282, "100 m");
        TextDrawLetterSize(MisselTD[6][i], 0.234948, 0.876667);
        TextDrawAlignment(MisselTD[6][i], 1);
        TextDrawColor(MisselTD[6][i], -1);
        TextDrawSetShadow(MisselTD[6][i], 0);
        TextDrawSetOutline(MisselTD[6][i], 1);
        TextDrawBackgroundColor(MisselTD[6][i], 51);
        TextDrawFont(MisselTD[6][i], 1);
        TextDrawSetProportional(MisselTD[6][i], 1);

        PoderTD[0][i] = TextDrawCreate(598.490417, 404.999938, "usebox");
        TextDrawLetterSize(PoderTD[0][i], 0.000000, 0.756295);
        TextDrawTextSize(PoderTD[0][i], 471.674713, 0.000000);
        TextDrawAlignment(PoderTD[0][i], 1);
        TextDrawColor(PoderTD[0][i], 0);
        TextDrawUseBox(PoderTD[0][i], true);
        TextDrawBoxColor(PoderTD[0][i], 102);
        TextDrawSetShadow(PoderTD[0][i], 0);
        TextDrawSetOutline(PoderTD[0][i], 0);
        TextDrawFont(PoderTD[0][i], 0);

        PoderTD[1][i] = TextDrawCreate(596.553466, 406.333312, "usebox");
        TextDrawLetterSize(PoderTD[1][i], 0.000000, 0.461111);
        TextDrawTextSize(PoderTD[1][i], 489.010253, 0.000000);
        TextDrawAlignment(PoderTD[1][i], 1);
        TextDrawColor(PoderTD[1][i], 0);
        TextDrawUseBox(PoderTD[1][i], true);
        TextDrawBoxColor(PoderTD[1][i], 16777215);
        TextDrawSetShadow(PoderTD[1][i], 0);
        TextDrawSetOutline(PoderTD[1][i], 0);
        TextDrawFont(PoderTD[1][i], 0);

        PoderTD[2][i] = TextDrawCreate(529.428955, 403.666717, "Escudo");
        TextDrawLetterSize(PoderTD[2][i], 0.211522, 0.800833);
        TextDrawAlignment(PoderTD[2][i], 1);
        TextDrawColor(PoderTD[2][i], -1);
        TextDrawSetShadow(PoderTD[2][i], 0);
        TextDrawSetOutline(PoderTD[2][i], 1);
        TextDrawBackgroundColor(PoderTD[2][i], 51);
        TextDrawFont(PoderTD[2][i], 1);
        TextDrawSetProportional(PoderTD[2][i], 1);

        PoderTD[3][i] = TextDrawCreate(473.000000, 399.000000, "New Textdraw");
        TextDrawBackgroundColor(PoderTD[3][i], -256);
        TextDrawFont(PoderTD[3][i], 5);
        TextDrawLetterSize(PoderTD[3][i], 0.500000, 1.000000);
        TextDrawColor(PoderTD[3][i], 16777215);
        TextDrawSetOutline(PoderTD[3][i], 0);
        TextDrawSetProportional(PoderTD[3][i], 1);
        TextDrawSetShadow(PoderTD[3][i], 1);
        TextDrawUseBox(PoderTD[3][i], 1);
        TextDrawBoxColor(PoderTD[3][i], -16776961);
        TextDrawTextSize(PoderTD[3][i], 18.000000, 18.000000);
        TextDrawSetPreviewModel(PoderTD[3][i], 18844);
        TextDrawSetPreviewRot(PoderTD[3][i], -16.000000, 0.000000, -55.000000, 1.000000);
        TextDrawSetSelectable(PoderTD[3][i], 0);

        BonusTD[0][i] = TextDrawCreate(525.806213, 126.333305, "usebox");
        TextDrawLetterSize(BonusTD[0][i], 0.000000, 25.224264);
        TextDrawTextSize(BonusTD[0][i], 109.039535, 0.000000);
        TextDrawAlignment(BonusTD[0][i], 1);
        TextDrawColor(BonusTD[0][i], 0);
        TextDrawUseBox(BonusTD[0][i], true);
        TextDrawBoxColor(BonusTD[0][i], 102);
        TextDrawSetShadow(BonusTD[0][i], 0);
        TextDrawSetOutline(BonusTD[0][i], 0);
        TextDrawFont(BonusTD[0][i], 0);

        BonusTD[1][i] = TextDrawCreate(246.568038, 152.583343, "usebox");
        TextDrawLetterSize(BonusTD[1][i], 0.000000, 19.451850);
        TextDrawTextSize(BonusTD[1][i], 134.808197, 0.000000);
        TextDrawAlignment(BonusTD[1][i], 1);
        TextDrawColor(BonusTD[1][i], 0);
        TextDrawUseBox(BonusTD[1][i], true);
        TextDrawBoxColor(BonusTD[1][i], 102);
        TextDrawSetShadow(BonusTD[1][i], 0);
        TextDrawSetOutline(BonusTD[1][i], 0);
        TextDrawFont(BonusTD[1][i], 0);

        BonusTD[2][i] = TextDrawCreate(371.257659, 153.000015, "usebox");
        TextDrawLetterSize(BonusTD[2][i], 0.000000, 19.451850);
        TextDrawTextSize(BonusTD[2][i], 258.497619, 0.000000);
        TextDrawAlignment(BonusTD[2][i], 1);
        TextDrawColor(BonusTD[2][i], 0);
        TextDrawUseBox(BonusTD[2][i], true);
        TextDrawBoxColor(BonusTD[2][i], 102);
        TextDrawSetShadow(BonusTD[2][i], 0);
        TextDrawSetOutline(BonusTD[2][i], 0);
        TextDrawFont(BonusTD[2][i], 0);

        BonusTD[3][i] = TextDrawCreate(501.101501, 152.833374, "usebox");
        TextDrawLetterSize(BonusTD[3][i], 0.000000, 19.451850);
        TextDrawTextSize(BonusTD[3][i], 387.341461, 0.000000);
        TextDrawAlignment(BonusTD[3][i], 1);
        TextDrawColor(BonusTD[3][i], 0);
        TextDrawUseBox(BonusTD[3][i], true);
        TextDrawBoxColor(BonusTD[3][i], 102);
        TextDrawSetShadow(BonusTD[3][i], 0);
        TextDrawSetOutline(BonusTD[3][i], 0);
        TextDrawFont(BonusTD[3][i], 0);

        BonusTD[4][i] = TextDrawCreate(154.143478, 127.166648, "?");
        TextDrawLetterSize(BonusTD[4][i], 3.985461, 22.389999);
        TextDrawAlignment(BonusTD[4][i], 1);
        TextDrawColor(BonusTD[4][i], -65281);
        TextDrawSetShadow(BonusTD[4][i], 0);
        TextDrawSetOutline(BonusTD[4][i], 1);
        TextDrawBackgroundColor(BonusTD[4][i], 51);
        TextDrawFont(BonusTD[4][i], 1);
        TextDrawSetProportional(BonusTD[4][i], 1);
        TextDrawSetSelectable(BonusTD[4][i], true);
        TextDrawTextSize(BonusTD[4][i], 250.158142, 136.000000);

        BonusTD[5][i] = TextDrawCreate(283.518280, 129.916671, "?");
        TextDrawLetterSize(BonusTD[5][i], 3.985461, 22.389999);
        TextDrawAlignment(BonusTD[5][i], 1);
        TextDrawColor(BonusTD[5][i], -65281);
        TextDrawSetShadow(BonusTD[5][i], 0);
        TextDrawSetOutline(BonusTD[5][i], 1);
        TextDrawBackgroundColor(BonusTD[5][i], 51);
        TextDrawFont(BonusTD[5][i], 1);
        TextDrawSetProportional(BonusTD[5][i], 1);
        TextDrawSetSelectable(BonusTD[5][i], true);
        TextDrawTextSize(BonusTD[5][i], 350.158142, 136.000000);

        BonusTD[6][i] = TextDrawCreate(411.956268, 128.000000, "?");
        TextDrawLetterSize(BonusTD[6][i], 3.985461, 22.389999);
        TextDrawAlignment(BonusTD[6][i], 1);
        TextDrawColor(BonusTD[6][i], -65281);
        TextDrawSetShadow(BonusTD[6][i], 0);
        TextDrawSetOutline(BonusTD[6][i], 1);
        TextDrawBackgroundColor(BonusTD[6][i], 51);
        TextDrawFont(BonusTD[6][i], 1);
        TextDrawSetProportional(BonusTD[6][i], 1);
        TextDrawSetSelectable(BonusTD[6][i], true);
        TextDrawTextSize(BonusTD[6][i], 550.158142, 136.000000);

        BonusTD[7][i] = TextDrawCreate(205.680725, 340.666687, "Selecione um para ganhar seu bonus(?)");
        TextDrawLetterSize(BonusTD[7][i], 0.330058, 1.226665);
        TextDrawAlignment(BonusTD[7][i], 1);
        TextDrawColor(BonusTD[7][i], -1);
        TextDrawSetShadow(BonusTD[7][i], 0);
        TextDrawSetOutline(BonusTD[7][i], 1);
        TextDrawBackgroundColor(BonusTD[7][i], 51);
        TextDrawFont(BonusTD[7][i], 1);
        TextDrawSetProportional(BonusTD[7][i], 1);

        DinheiroTD[i] = TextDrawCreate(500.381164, 98.000022, "+R$000");
        TextDrawLetterSize(DinheiroTD[i], 0.449999, 1.600000);
        TextDrawAlignment(DinheiroTD[i], 1);
        TextDrawColor(DinheiroTD[i], 16711935);
        TextDrawSetShadow(DinheiroTD[i], 0);
        TextDrawSetOutline(DinheiroTD[i], 1);
        TextDrawBackgroundColor(DinheiroTD[i], 51);
        TextDrawFont(DinheiroTD[i], 3);
        TextDrawSetProportional(DinheiroTD[i], 1);

        NitroTD[i][0] = TextDrawCreate(597.490295, 419.166564, "usebox");
        TextDrawLetterSize(NitroTD[i][0], 0.000000, 0.756295);
        TextDrawTextSize(NitroTD[i][0], 471.674774, 0.000000);
        TextDrawAlignment(NitroTD[i][0], 1);
        TextDrawColor(NitroTD[i][0], 0);
        TextDrawUseBox(NitroTD[i][0], true);
        TextDrawBoxColor(NitroTD[i][0], 102);
        TextDrawSetShadow(NitroTD[i][0], 0);
        TextDrawSetOutline(NitroTD[i][0], 0);
        TextDrawFont(NitroTD[i][0], 0);

        NitroTD[i][1] = TextDrawCreate(504.598205, 417.083312, "~b~~h~~h~IIIIIIIIIIIIIIII");
        TextDrawLetterSize(NitroTD[i][1], 0.383469, 1.086665);
        TextDrawAlignment(NitroTD[i][1], 1);
        TextDrawColor(NitroTD[i][1], -1);
        TextDrawSetShadow(NitroTD[i][1], 0);
        TextDrawSetOutline(NitroTD[i][1], 1);
        TextDrawBackgroundColor(NitroTD[i][1], 51);
        TextDrawFont(NitroTD[i][1], 2);
        TextDrawSetProportional(NitroTD[i][1], 1);

        NitroTD[i][2] = TextDrawCreate(470.000000, 410.000000, "New Textdraw");
        TextDrawBackgroundColor(NitroTD[i][2], -256);
        TextDrawFont(NitroTD[i][2], 5);
        TextDrawLetterSize(NitroTD[i][2], 0.500000, 1.000000);
        TextDrawColor(NitroTD[i][2], -1);
        TextDrawSetOutline(NitroTD[i][2], 0);
        TextDrawSetProportional(NitroTD[i][2], 1);
        TextDrawSetShadow(NitroTD[i][2], 1);
        TextDrawUseBox(NitroTD[i][2], 1);
        TextDrawBoxColor(NitroTD[i][2], 255);
        TextDrawTextSize(NitroTD[i][2], 32.000000, 24.000000);
        TextDrawSetPreviewModel(NitroTD[i][2], 1008);
        TextDrawSetPreviewRot(NitroTD[i][2], -16.000000, 0.000000, -55.000000, 1.000000);
        TextDrawSetSelectable(NitroTD[i][2], 0);

        MiniMapa2[i] = TextDrawCreate(46.852172, 347.666687, "LD_POOL:ball");
        TextDrawLetterSize(MiniMapa2[i], 0.002811, -0.093333);
        TextDrawTextSize(MiniMapa2[i], 78.243041, 71.749984);
        TextDrawAlignment(MiniMapa2[i], 1);
        TextDrawColor(MiniMapa2[i], 65365);
        TextDrawSetShadow(MiniMapa2[i], 0);
        TextDrawSetOutline(MiniMapa2[i], 0);
        TextDrawFont(MiniMapa2[i], 4);

        MiniMapa[i] = TextDrawCreate(46.852172, 347.666687, "LD_POOL:ball");
        TextDrawLetterSize(MiniMapa[i], 0.002811, -0.093333);
        TextDrawTextSize(MiniMapa[i], 78.243041, 71.749984);
        TextDrawAlignment(MiniMapa[i], 1);
        TextDrawColor(MiniMapa[i], -16777131);
        TextDrawSetShadow(MiniMapa[i], 0);
        TextDrawSetOutline(MiniMapa[i], 0);
        TextDrawFont(MiniMapa[i], 4);

        TempoFugirTD[i] = TextDrawCreate(530.366333, 200.083297, "Tempo: ~g~10 Minutos.");
        TextDrawLetterSize(TempoFugirTD[i], 0.240102, 0.853333);
        TextDrawAlignment(TempoFugirTD[i], 1);
        TextDrawColor(TempoFugirTD[i], -1);
        TextDrawSetShadow(TempoFugirTD[i], 0);
        TextDrawSetOutline(TempoFugirTD[i], 1);
        TextDrawBackgroundColor(TempoFugirTD[i], 51);
        TextDrawFont(TempoFugirTD[i], 1);
        TextDrawSetProportional(TempoFugirTD[i], 1);

        SalaTD[i][0] = TextDrawCreate(447.563598, 131.000000, "usebox");
        TextDrawLetterSize(SalaTD[i][0], 0.000000, 8.998282);
        TextDrawTextSize(SalaTD[i][0], 147.926788, 0.000000);
        TextDrawAlignment(SalaTD[i][0], 1);
        TextDrawColor(SalaTD[i][0], 0);
        TextDrawUseBox(SalaTD[i][0], true);
        TextDrawBoxColor(SalaTD[i][0], 102);
        TextDrawSetShadow(SalaTD[i][0], 0);
        TextDrawSetOutline(SalaTD[i][0], 0);
        TextDrawFont(SalaTD[i][0], 0);

        SalaTD[i][1] = TextDrawCreate(447.563690, 112.333328, "usebox");
        TextDrawLetterSize(SalaTD[i][1], 0.000000, 4.474830);
        TextDrawTextSize(SalaTD[i][1], 147.926788, 0.000000);
        TextDrawAlignment(SalaTD[i][1], 1);
        TextDrawColor(SalaTD[i][1], 0);
        TextDrawUseBox(SalaTD[i][1], true);
        TextDrawBoxColor(SalaTD[i][1], 35839);
        TextDrawSetShadow(SalaTD[i][1], 0);
        TextDrawSetOutline(SalaTD[i][1], 0);
        TextDrawFont(SalaTD[i][1], 0);

        SalaTD[i][2] = TextDrawCreate(446.626739, 132.750000, "usebox");
        TextDrawLetterSize(SalaTD[i][2], 0.000000, 8.674209);
        TextDrawTextSize(SalaTD[i][2], 148.863830, 0.000000);
        TextDrawAlignment(SalaTD[i][2], 1);
        TextDrawColor(SalaTD[i][2], 0);
        TextDrawUseBox(SalaTD[i][2], true);
        TextDrawBoxColor(SalaTD[i][2], 1768516095);
        TextDrawSetShadow(SalaTD[i][2], 0);
        TextDrawSetOutline(SalaTD[i][2], 0);
        TextDrawFont(SalaTD[i][2], 0);

        SalaTD[i][3] = TextDrawCreate(152.269409, 135.333343, "LD_SPAC:white");
        TextDrawLetterSize(SalaTD[i][3], 0.000000, 0.000000);
        TextDrawTextSize(SalaTD[i][3], 289.077606, 15.166656);
        TextDrawAlignment(SalaTD[i][3], 1);
        TextDrawColor(SalaTD[i][3], -1);
        TextDrawSetShadow(SalaTD[i][3], 0);
        TextDrawSetOutline(SalaTD[i][3], 0);
        TextDrawFont(SalaTD[i][3], 4);

        SalaTD[i][4] = TextDrawCreate(151.863845, 154.416656, "LD_SPAC:white");
        TextDrawLetterSize(SalaTD[i][4], 0.000000, 0.000000);
        TextDrawTextSize(SalaTD[i][4], 289.077606, 15.166656);
        TextDrawAlignment(SalaTD[i][4], 1);
        TextDrawColor(SalaTD[i][4], -1);
        TextDrawSetShadow(SalaTD[i][4], 0);
        TextDrawSetOutline(SalaTD[i][4], 0);
        TextDrawFont(SalaTD[i][4], 4);

        SalaTD[i][5] = TextDrawCreate(220.673385, 114.916641, "SALAS [HOT-PURSUIT]");
        TextDrawLetterSize(SalaTD[i][5], 0.376442, 1.220833);
        TextDrawAlignment(SalaTD[i][5], 1);
        TextDrawColor(SalaTD[i][5], -1);
        TextDrawSetShadow(SalaTD[i][5], 0);
        TextDrawSetOutline(SalaTD[i][5], 1);
        TextDrawBackgroundColor(SalaTD[i][5], 51);
        TextDrawFont(SalaTD[i][5], 1);
        TextDrawSetProportional(SalaTD[i][5], 1);

        SalaTD[i][6] = TextDrawCreate(151.863845, 174.249923, "LD_SPAC:white");
        TextDrawLetterSize(SalaTD[i][6], 0.000000, 0.000000);
        TextDrawTextSize(SalaTD[i][6], 289.077606, 15.166653);
        TextDrawAlignment(SalaTD[i][6], 1);
        TextDrawColor(SalaTD[i][6], -1);
        TextDrawSetShadow(SalaTD[i][6], 0);
        TextDrawSetOutline(SalaTD[i][6], 0);
        TextDrawFont(SalaTD[i][6], 4);

        SalaTD[i][7] = TextDrawCreate(151.926803, 194.499908, "LD_SPAC:white");
        TextDrawLetterSize(SalaTD[i][7], 0.000000, 0.000000);
        TextDrawTextSize(SalaTD[i][7], 289.077606, 15.166653);
        TextDrawAlignment(SalaTD[i][7], 1);
        TextDrawColor(SalaTD[i][7], -1);
        TextDrawSetShadow(SalaTD[i][7], 0);
        TextDrawSetOutline(SalaTD[i][7], 0);
        TextDrawFont(SalaTD[i][7], 4);

        Cores[i][0] = TextDrawCreate(123.346954, 134.500030, "usebox");
        TextDrawLetterSize(Cores[i][0], 0.000000, 15.757406);
        TextDrawTextSize(Cores[i][0], 7.370475, 0.000000);
        TextDrawAlignment(Cores[i][0], 1);
        TextDrawColor(Cores[i][0], 0);
        TextDrawUseBox(Cores[i][0], true);
        TextDrawBoxColor(Cores[i][0], 80);
        TextDrawSetShadow(Cores[i][0], 0);
        TextDrawSetOutline(Cores[i][0], 0);
        TextDrawFont(Cores[i][0], 0);

        Cores[i][1] = TextDrawCreate(13.118595, 136.500000, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][1], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][1], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][1], 1);
        TextDrawColor(Cores[i][1], 255);
        TextDrawSetShadow(Cores[i][1], 0);
        TextDrawSetOutline(Cores[i][1], 0);
        TextDrawFont(Cores[i][1], 4);
        TextDrawSetSelectable(Cores[i][1], true);

        Cores[i][2] = TextDrawCreate(34.733524, 136.333343, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][2], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][2], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][2], 1);
        TextDrawColor(Cores[i][2], -168443905);
        TextDrawSetShadow(Cores[i][2], 0);
        TextDrawSetOutline(Cores[i][2], 0);
        TextDrawFont(Cores[i][2], 4);
        TextDrawSetSelectable(Cores[i][2], true);

        Cores[i][3] = TextDrawCreate(56.816974, 136.166687, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][3], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][3], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][3], 1);
        TextDrawColor(Cores[i][3], 712483327);
        TextDrawSetShadow(Cores[i][3], 0);
        TextDrawSetOutline(Cores[i][3], 0);
        TextDrawFont(Cores[i][3], 4);
        TextDrawSetSelectable(Cores[i][3], true);

        Cores[i][4] = TextDrawCreate(77.963386, 136.000030, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][4], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][4], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][4], 1);
        TextDrawColor(Cores[i][4], -2080108289);
        TextDrawSetShadow(Cores[i][4], 0);
        TextDrawSetOutline(Cores[i][4], 0);
        TextDrawFont(Cores[i][4], 4);
        TextDrawSetSelectable(Cores[i][4], true);

        Cores[i][5] = TextDrawCreate(99.109794, 137.000045, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][5], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][5], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][5], 1);
        TextDrawColor(Cores[i][5], 641153535);
        TextDrawSetShadow(Cores[i][5], 0);
        TextDrawSetOutline(Cores[i][5], 0);
        TextDrawFont(Cores[i][5], 4);
        TextDrawSetSelectable(Cores[i][5], true);

        Cores[i][6] = TextDrawCreate(12.496345, 161.333435, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][6], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][6], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][6], 1);
        TextDrawColor(Cores[i][6], -2042335489);
        TextDrawSetShadow(Cores[i][6], 0);
        TextDrawSetOutline(Cores[i][6], 0);
        TextDrawFont(Cores[i][6], 4);
        TextDrawSetSelectable(Cores[i][6], true);

        Cores[i][7] = TextDrawCreate(34.579795, 160.583450, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][7], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][7], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][7], 1);
        TextDrawColor(Cores[i][7], -678555393);
        TextDrawSetShadow(Cores[i][7], 0);
        TextDrawSetOutline(Cores[i][7], 0);
        TextDrawFont(Cores[i][7], 4);
        TextDrawSetSelectable(Cores[i][7], true);

        Cores[i][8] = TextDrawCreate(56.194725, 160.416809, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][8], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][8], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][8], 1);
        TextDrawColor(Cores[i][8], 1282783231);
        TextDrawSetShadow(Cores[i][8], 0);
        TextDrawSetOutline(Cores[i][8], 0);
        TextDrawFont(Cores[i][8], 4);
        TextDrawSetSelectable(Cores[i][8], true);

        Cores[i][9] = TextDrawCreate(77.341133, 160.250167, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][9], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][9], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][9], 1);
        TextDrawColor(Cores[i][9], -1111570689);
        TextDrawSetShadow(Cores[i][9], 0);
        TextDrawSetOutline(Cores[i][9], 0);
        TextDrawFont(Cores[i][9], 4);
        TextDrawSetSelectable(Cores[i][9], true);

        Cores[i][10] = TextDrawCreate(98.956062, 160.083480, "LD_SPAC:white");
        TextDrawLetterSize(Cores[i][10], 0.000000, 0.000000);
        TextDrawTextSize(Cores[i][10], 15.929721, 17.500000);
        TextDrawAlignment(Cores[i][10], 1);
        TextDrawColor(Cores[i][10], 1584427775);
        TextDrawSetShadow(Cores[i][10], 0);
        TextDrawSetOutline(Cores[i][10], 0);
        TextDrawFont(Cores[i][10], 4);
        TextDrawSetSelectable(Cores[i][10], true);

        Garagem[i][0] = TextDrawCreate(81.991203, 188.416702, "LD_BEAT:left");
        TextDrawLetterSize(Garagem[i][0], 0.000000, 0.000000);
        TextDrawTextSize(Garagem[i][0], 32.796482, 26.833374);
        TextDrawAlignment(Garagem[i][0], 1);
        TextDrawColor(Garagem[i][0], -1);
        TextDrawSetShadow(Garagem[i][0], 0);
        TextDrawSetOutline(Garagem[i][0], 0);
        TextDrawFont(Garagem[i][0], 4);
        TextDrawSetSelectable(Garagem[i][0], true);

        Garagem[i][1] = TextDrawCreate(488.262176, 192.916717, "LD_BEAT:right");
        TextDrawLetterSize(Garagem[i][1], 0.000000, 0.000000);
        TextDrawTextSize(Garagem[i][1], 32.796482, 26.833374);
        TextDrawAlignment(Garagem[i][1], 1);
        TextDrawColor(Garagem[i][1], -1);
        TextDrawSetShadow(Garagem[i][1], 0);
        TextDrawSetOutline(Garagem[i][1], 0);
        TextDrawFont(Garagem[i][1], 4);
        TextDrawSetSelectable(Garagem[i][1], true);

        Garagem[i][2] = TextDrawCreate(394.152557, 395.250061, "usebox");
        TextDrawLetterSize(Garagem[i][2], 0.000000, 4.530372);
        TextDrawTextSize(Garagem[i][2], 213.519744, 0.000000);
        TextDrawAlignment(Garagem[i][2], 1);
        TextDrawColor(Garagem[i][2], 0);
        TextDrawUseBox(Garagem[i][2], true);
        TextDrawBoxColor(Garagem[i][2], 255);
        TextDrawSetShadow(Garagem[i][2], 0);
        TextDrawSetOutline(Garagem[i][2], 0);
        TextDrawFont(Garagem[i][2], 0);

        Garagem[i][3] = TextDrawCreate(392.341339, 396.833404, "usebox");
        TextDrawLetterSize(Garagem[i][3], 0.000000, 4.155555);
        TextDrawTextSize(Garagem[i][3], 214.925308, 0.000000);
        TextDrawAlignment(Garagem[i][3], 1);
        TextDrawColor(Garagem[i][3], 0);
        TextDrawUseBox(Garagem[i][3], true);
        TextDrawBoxColor(Garagem[i][3], -1061109505);
        TextDrawSetShadow(Garagem[i][3], 0);
        TextDrawSetOutline(Garagem[i][3], 0);
        TextDrawFont(Garagem[i][3], 0);

        Garagem[i][4] = TextDrawCreate(264.714477, 403.083312, "NOME: NENHUM");
        TextDrawLetterSize(Garagem[i][4], 0.215739, 0.859166);
        TextDrawAlignment(Garagem[i][4], 1);
        TextDrawColor(Garagem[i][4], -1);
        TextDrawSetShadow(Garagem[i][4], 0);
        TextDrawSetOutline(Garagem[i][4], 1);
        TextDrawBackgroundColor(Garagem[i][4], 51);
        TextDrawFont(Garagem[i][4], 2);
        TextDrawSetProportional(Garagem[i][4], 1);

        Garagem[i][5] = TextDrawCreate(235.260635, 424.500122, "USAR");
        TextDrawLetterSize(Garagem[i][5], 0.215739, 0.859166);
        TextDrawAlignment(Garagem[i][5], 1);
        TextDrawColor(Garagem[i][5], -1);
        TextDrawSetShadow(Garagem[i][5], 0);
        TextDrawSetOutline(Garagem[i][5], 1);
        TextDrawBackgroundColor(Garagem[i][5], 51);
        TextDrawFont(Garagem[i][5], 2);
        TextDrawSetProportional(Garagem[i][5], 1);
        TextDrawSetSelectable(Garagem[i][5], true);
        TextDrawTextSize(Garagem[i][5], 262.158142, 26.000000);

        Garagem[i][6] = TextDrawCreate(284.049713, 424.916778, "DELETAR");
        TextDrawLetterSize(Garagem[i][6], 0.215739, 0.859166);
        TextDrawAlignment(Garagem[i][6], 1);
        TextDrawColor(Garagem[i][6], -16776961);
        TextDrawSetShadow(Garagem[i][6], 0);
        TextDrawSetOutline(Garagem[i][6], 0);
        TextDrawBackgroundColor(Garagem[i][6], 51);
        TextDrawFont(Garagem[i][6], 2);
        TextDrawSetProportional(Garagem[i][6], 1);
        TextDrawSetSelectable(Garagem[i][6], true);
        TextDrawTextSize(Garagem[i][6], 342.158142, 26.000000);

        Garagem[i][7] = TextDrawCreate(346.426116, 425.333404, "VENDER");
        TextDrawLetterSize(Garagem[i][7], 0.215739, 0.859166);
        TextDrawAlignment(Garagem[i][7], 1);
        TextDrawColor(Garagem[i][7], 16711935);
        TextDrawSetShadow(Garagem[i][7], 0);
        TextDrawSetOutline(Garagem[i][7], 1);
        TextDrawBackgroundColor(Garagem[i][7], 51);
        TextDrawFont(Garagem[i][7], 2);
        TextDrawSetProportional(Garagem[i][7], 1);
        TextDrawSetSelectable(Garagem[i][7], true);
        TextDrawTextSize(Garagem[i][7], 432.158142, 26.000000);

        Concessionaria[i][0] = TextDrawCreate(601.707275, 383.000000, "usebox");
        TextDrawLetterSize(Concessionaria[i][0], 0.000000, 6.132780);
        TextDrawTextSize(Concessionaria[i][0], 40.635437, 0.000000);
        TextDrawAlignment(Concessionaria[i][0], 1);
        TextDrawColor(Concessionaria[i][0], 255);
        TextDrawUseBox(Concessionaria[i][0], true);
        TextDrawBoxColor(Concessionaria[i][0], 187);
        TextDrawSetShadow(Concessionaria[i][0], 0);
        TextDrawSetOutline(Concessionaria[i][0], 32);
        TextDrawBackgroundColor(Concessionaria[i][0], 255);
        TextDrawFont(Concessionaria[i][0], 0);

        Concessionaria[i][1] = TextDrawCreate(375.879913, 373.083312, "usebox");
        TextDrawLetterSize(Concessionaria[i][1], 0.000000, 2.078338);
        TextDrawTextSize(Concessionaria[i][1], 249.127380, 0.000000);
        TextDrawAlignment(Concessionaria[i][1], 1);
        TextDrawColor(Concessionaria[i][1], 0);
        TextDrawUseBox(Concessionaria[i][1], true);
        TextDrawBoxColor(Concessionaria[i][1], 187);
        TextDrawSetShadow(Concessionaria[i][1], -259);
        TextDrawSetOutline(Concessionaria[i][1], 0);
        TextDrawFont(Concessionaria[i][1], 0);

        Concessionaria[i][2] = TextDrawCreate(600.364624, 384.583343, "usebox");
        TextDrawLetterSize(Concessionaria[i][2], 0.000000, 5.711111);
        TextDrawTextSize(Concessionaria[i][2], 42.041000, 0.000000);
        TextDrawAlignment(Concessionaria[i][2], 1);
        TextDrawColor(Concessionaria[i][2], 255);
        TextDrawUseBox(Concessionaria[i][2], true);
        TextDrawBoxColor(Concessionaria[i][2], 1768516095);
        TextDrawSetShadow(Concessionaria[i][2], 0);
        TextDrawSetOutline(Concessionaria[i][2], 32);
        TextDrawBackgroundColor(Concessionaria[i][2], 255);
        TextDrawFont(Concessionaria[i][2], 0);

        Concessionaria[i][3] = TextDrawCreate(375.005828, 374.083312, "usebox");
        TextDrawLetterSize(Concessionaria[i][3], 0.000000, 1.656669);
        TextDrawTextSize(Concessionaria[i][3], 250.532943, 0.000000);
        TextDrawAlignment(Concessionaria[i][3], 1);
        TextDrawColor(Concessionaria[i][3], 0);
        TextDrawUseBox(Concessionaria[i][3], true);
        TextDrawBoxColor(Concessionaria[i][3], 1768516027);
        TextDrawSetShadow(Concessionaria[i][3], -259);
        TextDrawSetOutline(Concessionaria[i][3], 0);
        TextDrawFont(Concessionaria[i][3], 0);

        Concessionaria[i][4] = TextDrawCreate(267.057006, 372.750030, "CONCESSIONARIA");
        TextDrawLetterSize(Concessionaria[i][4], 0.250878, 0.888332);
        TextDrawAlignment(Concessionaria[i][4], 1);
        TextDrawColor(Concessionaria[i][4], -1);
        TextDrawSetShadow(Concessionaria[i][4], 0);
        TextDrawSetOutline(Concessionaria[i][4], 1);
        TextDrawBackgroundColor(Concessionaria[i][4], 51);
        TextDrawFont(Concessionaria[i][4], 2);
        TextDrawSetProportional(Concessionaria[i][4], 1);

        Concessionaria[i][5] = TextDrawCreate(122.284042, 393.749938, "NOME: NENHUM");
        TextDrawLetterSize(Concessionaria[i][5], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][5], 1);
        TextDrawColor(Concessionaria[i][5], -1);
        TextDrawSetShadow(Concessionaria[i][5], 0);
        TextDrawSetOutline(Concessionaria[i][5], 1);
        TextDrawBackgroundColor(Concessionaria[i][5], 51);
        TextDrawFont(Concessionaria[i][5], 2);
        TextDrawSetProportional(Concessionaria[i][5], 1);

        Concessionaria[i][6] = TextDrawCreate(122.347000, 405.833221, "PRECO: R$0");
        TextDrawLetterSize(Concessionaria[i][6], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][6], 1);
        TextDrawColor(Concessionaria[i][6], -1);
        TextDrawSetShadow(Concessionaria[i][6], 0);
        TextDrawSetOutline(Concessionaria[i][6], 1);
        TextDrawBackgroundColor(Concessionaria[i][6], 51);
        TextDrawFont(Concessionaria[i][6], 2);
        TextDrawSetProportional(Concessionaria[i][6], 1);

        Concessionaria[i][7] = TextDrawCreate(122.409957, 416.750030, "VELOCIDADE MAX: 0 KMH");
        TextDrawLetterSize(Concessionaria[i][7], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][7], 1);
        TextDrawColor(Concessionaria[i][7], -1);
        TextDrawSetShadow(Concessionaria[i][7], 0);
        TextDrawSetOutline(Concessionaria[i][7], 1);
        TextDrawBackgroundColor(Concessionaria[i][7], 51);
        TextDrawFont(Concessionaria[i][7], 2);
        TextDrawSetProportional(Concessionaria[i][7], 1);

        Concessionaria[i][8] = TextDrawCreate(377.348846, 393.833190, "STATUS: BLOQUEADO");
        TextDrawLetterSize(Concessionaria[i][8], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][8], 1);
        TextDrawColor(Concessionaria[i][8], -1);
        TextDrawSetShadow(Concessionaria[i][8], 0);
        TextDrawSetOutline(Concessionaria[i][8], 1);
        TextDrawBackgroundColor(Concessionaria[i][8], 51);
        TextDrawFont(Concessionaria[i][8], 2);
        TextDrawSetProportional(Concessionaria[i][8], 1);

        Concessionaria[i][9] = TextDrawCreate(377.411773, 406.499877, "MOTOR: NENHUM");
        TextDrawLetterSize(Concessionaria[i][9], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][9], 1);
        TextDrawColor(Concessionaria[i][9], -1);
        TextDrawSetShadow(Concessionaria[i][9], 0);
        TextDrawSetOutline(Concessionaria[i][9], 1);
        TextDrawBackgroundColor(Concessionaria[i][9], 51);
        TextDrawFont(Concessionaria[i][9], 2);
        TextDrawSetProportional(Concessionaria[i][9], 1);

        Concessionaria[i][10] = TextDrawCreate(377.943237, 419.749938, "STATUS MOTIVO: SEM NIVEL");
        TextDrawLetterSize(Concessionaria[i][10], 0.264465, 1.045833);
        TextDrawAlignment(Concessionaria[i][10], 1);
        TextDrawColor(Concessionaria[i][10], -1);
        TextDrawSetShadow(Concessionaria[i][10], 0);
        TextDrawSetOutline(Concessionaria[i][10], 1);
        TextDrawBackgroundColor(Concessionaria[i][10], 51);
        TextDrawFont(Concessionaria[i][10], 2);
        TextDrawSetProportional(Concessionaria[i][10], 1);

        Concessionaria[i][11] = TextDrawCreate(8.433382, 404.833465, "LD_BEAT:left");
        TextDrawLetterSize(Concessionaria[i][11], 0.000000, 0.000000);
        TextDrawTextSize(Concessionaria[i][11], 22.957540, 14.583312);
        TextDrawAlignment(Concessionaria[i][11], 1);
        TextDrawColor(Concessionaria[i][11], -1);
        TextDrawSetShadow(Concessionaria[i][11], 0);
        TextDrawSetOutline(Concessionaria[i][11], 0);
        TextDrawFont(Concessionaria[i][11], 4);
        TextDrawSetSelectable(Concessionaria[i][11], true);

        Concessionaria[i][12] = TextDrawCreate(605.861022, 405.250152, "LD_BEAT:right");
        TextDrawLetterSize(Concessionaria[i][12], 0.000000, 0.000000);
        TextDrawTextSize(Concessionaria[i][12], 22.957540, 14.583312);
        TextDrawAlignment(Concessionaria[i][12], 1);
        TextDrawColor(Concessionaria[i][12], -1);
        TextDrawSetShadow(Concessionaria[i][12], 0);
        TextDrawSetOutline(Concessionaria[i][12], 0);
        TextDrawFont(Concessionaria[i][12], 4);
        TextDrawSetSelectable(Concessionaria[i][12], true);

        Concessionaria[i][13] = TextDrawCreate(310.161071, 400.749908, "$");
        TextDrawLetterSize(Concessionaria[i][13], 0.527305, 2.352501);
        TextDrawAlignment(Concessionaria[i][13], 1);
        TextDrawColor(Concessionaria[i][13], 8388863);
        TextDrawSetShadow(Concessionaria[i][13], 0);
        TextDrawSetOutline(Concessionaria[i][13], 1);
        TextDrawBackgroundColor(Concessionaria[i][13], 51);
        TextDrawFont(Concessionaria[i][13], 1);
        TextDrawSetProportional(Concessionaria[i][13], 1);
        TextDrawSetSelectable(Concessionaria[i][13], true);
        TextDrawTextSize(Concessionaria[i][13], 332.158142, 26.000000);

        Concessionaria[i][14] = TextDrawCreate(53.000000, 375.000000, "New Textdraw");
        TextDrawBackgroundColor(Concessionaria[i][14], -256);
        TextDrawFont(Concessionaria[i][14], 5);
        TextDrawLetterSize(Concessionaria[i][14], 0.500000, 1.000000);
        TextDrawColor(Concessionaria[i][14], -1);
        TextDrawSetOutline(Concessionaria[i][14], 0);
        TextDrawSetProportional(Concessionaria[i][14], 1);
        TextDrawSetShadow(Concessionaria[i][14], 1);
        TextDrawUseBox(Concessionaria[i][14], 1);
        TextDrawBoxColor(Concessionaria[i][14], 255);
        TextDrawTextSize(Concessionaria[i][14], 67.000000, 65.000000);
        TextDrawSetPreviewModel(Concessionaria[i][14], 400);
        TextDrawSetPreviewRot(Concessionaria[i][14], -16.000000, 0.000000, -55.000000, 1.000000);
        TextDrawSetSelectable(Concessionaria[i][14], 0);
    }
	return 1;
}

public OnGameModeExit()
{

	return 1;
}

public OnPlayerText(playerid, text[])
{
    if(PlayerInfo[playerid][Logando] == true)
    {

        return 0;
    }
    new socio[200],string[500],cor[100];
    if(PlayerInfo[playerid][Socio] == 0){ socio = ""; cor = "{FFFFFF}"; }
    if(PlayerInfo[playerid][Socio] == 1){ socio = "[Socio Bronze]"; cor = "{B8860B}"; }
    if(PlayerInfo[playerid][Socio] == 2){ socio = "[Socio Prata]"; cor = "{808080}"; }
    if(PlayerInfo[playerid][Socio] == 3){ socio = "[Socio Ouro]"; cor = "{FFD700}"; }
    if(PlayerInfo[playerid][Administrador] == 1){ socio = "[Administrador]"; cor = "{FF3030}"; }
    if(PlayerInfo[playerid][Administrador] == 2){ socio = "[Dono]"; cor = "{FF3030}"; }
    if(PlayerInfo[playerid][Administrador] == 3){ socio = "[Programador]"; cor = "{FF3030}"; }
    format(string, sizeof(string), "%s%s%s(%d){FFFFFF}: %s", cor, PlayerName(playerid), socio, playerid, text);
    SendClientMessageToAll(BRANCO, string);
    return 0;
}

public OnPlayerDisconnect(playerid, reason)
{
    DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
    DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
    new porque[300],motivo[100];
    if(reason == 0){ motivo = "Conexão/Crash"; }
    if(reason == 1){ motivo = "Quit"; }
    if(reason == 2){ motivo = "Kikado/Banido"; }
    format(porque, sizeof(porque), "[{FF0000}Hot-Pursuit{FFFFFF}] %s desconectou do servidor [Motivo: %s].", PlayerName(playerid), motivo);
    SendClientMessageToAll(BRANCO, porque);
    if(PlayerInfo[playerid][Sala] == 1)
    {
        PlayerInfo[playerid][Sala] = 0;
        SalaInfo[0][s_players] -= 1;
        new sala[300];
        format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
        TextDrawSetString( NomeSalaTD[0], sala);
        if(PlayerInfo[playerid][EstaEmCorrida] == true)
        {
            if(PlayerInfo[playerid][Policial] == true)
            {
                DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
                if(SalaInfo[0][s_comecou] == true || SalaInfo[0][s_players] < 5)
                {
                    foreach(Player, i)
                    {
                        if(PlayerInfo[i][Sala] == 1)
                        {
                            ResetarVariaveis(i);
                            CarregarConta(i);
                            SpawnPlayer(i);
                            DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
                            SendClientMessage(i, ERROR, "[AVISO]{FFFFFF}: Não há player suficientes e a perseguição foi encerrada!");
                            SalaInfo[0][s_players] = 0;
                            format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                            TextDrawSetString( NomeSalaTD[0], sala);
                            SalaInfo[0][s_spawn] = 0;
                            SalaInfo[0][s_comecou] = false;
                            SalaInfo[0][s_bandidoganhou] = false;
                            KillTimer(SalaInfo[0][s_timerfugir]);
                            KillTimer(PlayerInfo[i][TimerSetTempoTD]);
                            TextDrawHideForPlayer(i, TempoFugirTD[i]);
                        }
                    }
                    ResetarVariavelSala1();
                }
            }
            if(PlayerInfo[playerid][Bandido] == true)
            {
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 1)
                    {
                        if(PlayerInfo[i][Policial] == true)
                        {
                            SendClientMessage(i, ERROR, "[AVISO]{FFFFFF}: O bandido desconectou!");
                            ResetarVariaveis(i);
                            CarregarConta(i);
                            DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                            SpawnPlayer(i);
                            SalaInfo[0][s_players] = 0;
                            SalaInfo[0][s_spawn] = 0;
                            SalaInfo[0][s_comecou] = false;
                            SalaInfo[0][s_bandidoganhou] = false;
                            format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                            TextDrawSetString( NomeSalaTD[0], sala);
                            KillTimer(SalaInfo[0][s_timerfugir]);
                            KillTimer(PlayerInfo[i][TimerSetTempoTD]);
                            TextDrawHideForPlayer(i, TempoFugirTD[i]);
                        }
                    }
                }
                ResetarVariavelSala1();
            }
        }
    }
    if(PlayerInfo[playerid][Sala] == 2)
    {
        PlayerInfo[playerid][Sala] = 0;
        MotoCrossSInfo[0][players] -= 1;
        new sala[300];
        format(sala, sizeof(sala), "~l~[~y~MOTOCROSS~l~]       Premio: ~g~R$%d~l~         %d/7 Players", MotoCrossSInfo[0][premio], MotoCrossSInfo[0][players]);
        TextDrawSetString( NomeSalaTD[1], sala);
    }
    if(PlayerInfo[playerid][Sala] == 3)
    {
        PlayerInfo[playerid][Sala] = 0;
        CorridaHSInfo[0][players] -= 1;
        new sala[300];
        format(sala, sizeof(sala), "~l~[~y~MOTOCROSS~l~]       Premio: ~g~R$%d~l~         %d/7 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
        TextDrawSetString( NomeSalaTD[1], sala);
    }
    if(PlayerInfo[playerid][Sala] == 4)
    {
        PlayerInfo[playerid][Sala] = 0;
        GuerraSInfo[0][players] -= 1;
        new sala[300];
        format(sala, sizeof(sala), "~l~[~r~EUAxAFEGANI~l~]      Premio: ~g~R$%d~l~         %d/30 Players", GuerraSInfo[0][premio], GuerraSInfo[0][players]);
        TextDrawSetString( NomeSalaTD[2], sala);
    }
    TextDrawSetString( InicioSessaoTextDraw[playerid][14], "Nome_Sobrenome");
    TextDrawSetString( InicioSessaoTextDraw[playerid][15], "Senha");
    PlayerInfo[playerid][Skin] = GetPlayerSkin(playerid);
    PlayerInfo[playerid][Dinheiro] = GetPlayerMoney(playerid);
    PlayerInfo[playerid][Level] = GetPlayerScore(playerid);
    SalvarConta(playerid);
    return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
    new Float:x,Float:y,Float:z;
    GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetPlayerPos(playerid, x, y, z);
    PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    PlayerInfo[playerid][CheckPoint] = 1;
    PlayerInfo[playerid][Volta] = 0;
    TextDrawShowForPlayer(playerid, AbrirMenu[0][playerid]);
    TextDrawShowForPlayer(playerid, AbrirMenu[1][playerid]);
    if(PlayerInfo[playerid][MorreuBandido] == true)
    {
        SalaInfo[0][s_bandidoganhou] = false;
        VerificarSala1();
        return 1;
    }
    TextDrawBoxColor(PoderTD[1][playerid], 16777215);
    PlayerInfo[playerid][TamanhoTDPoder] = 489.010253;
    StopAudioStreamForPlayer(playerid);
    SetPlayerVirtualWorld(playerid, 0);
    TextDrawHideForPlayer(playerid, NitroTD[playerid][0]);
    TextDrawHideForPlayer(playerid, NitroTD[playerid][1]);
    TextDrawHideForPlayer(playerid, NitroTD[playerid][2]);
    TextDrawHideForPlayer(playerid, CorridaTD[0][playerid]);
    TextDrawHideForPlayer(playerid, CorridaTD[1][playerid]);
    TextDrawHideForPlayer(playerid, CorridaTD[2][playerid]);
    TextDrawHideForPlayer(playerid, PoderTD[0][playerid]);
    TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
    TextDrawHideForPlayer(playerid, PoderTD[2][playerid]);
    TextDrawHideForPlayer(playerid, PoderTD[3][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[0][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[1][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[2][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[3][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[4][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[5][playerid]);
    TextDrawHideForPlayer(playerid, MisselTD[6][playerid]);
    PlayerInfo[playerid][Nitro] = 16;
    PlayerInfo[playerid][EscudoTempo] = 16;
    PlayerInfo[playerid][PregoTempo] = 16;
    PlayerInfo[playerid][MisselTempo] = 16;
    KillTimer(PlayerInfo[playerid][MiniMapaT]);
    TextDrawHideForPlayer(playerid, MiniMapa[playerid]);
    TextDrawHideForPlayer(playerid, MiniMapa2[playerid]);
    KillTimer(PlayerInfo[playerid][TimerSetTempoTD]);
    TextDrawHideForPlayer(playerid, TempoFugirTD[playerid]);
    foreach(Player,i){ SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00); }
    SetPlayerColor(playerid, BRANCO);
    if(PlayerInfo[playerid][EstaEmCorrida] == true)
    {
        if(PlayerInfo[playerid][Sala] == 1)
        {
            TextDrawShowForPlayer(playerid, NitroTD[playerid][0]);
            TextDrawShowForPlayer(playerid, NitroTD[playerid][1]);
            TextDrawShowForPlayer(playerid, NitroTD[playerid][2]);
            PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/s/79jhvtiezaacfcr/musica.mp3");
            SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
            PlayerInfo[playerid][MiniMapaT] = SetTimerEx("MiniMapaSet",600,true,"i",playerid);
            TextDrawShowForPlayer(playerid, MiniMapa[playerid]);
            if(PlayerInfo[playerid][PoderUsando] > 0)
            {
                TextDrawHideForPlayer(playerid, PoderTD[2][playerid]);
                TextDrawShowForPlayer(playerid, PoderTD[0][playerid]);
                TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
                TextDrawShowForPlayer(playerid, PoderTD[2][playerid]);
                TextDrawShowForPlayer(playerid, PoderTD[3][playerid]);
            }
            if(PlayerInfo[playerid][PoderUsando] == 1){ TextDrawSetString( PoderTD[2][playerid], "Escudo"); }
            if(PlayerInfo[playerid][PoderUsando] == 2){ TextDrawSetString( PoderTD[2][playerid], "Pregos"); }
            if(PlayerInfo[playerid][PoderUsando] == 3)
            {
                TextDrawSetString( PoderTD[2][playerid], "Missel");
                TextDrawShowForPlayer(playerid, MisselTD[0][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[1][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[2][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[3][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[4][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[5][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[6][playerid]);
            }
            if(PlayerInfo[playerid][Bandido] == true)
            {
                SetPlayerColor(playerid, BANDIDOC);
                PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1811.8918, -406.4462, 15.5986, 348.9099, 1, 1, 0, 0);
                SetPlayerPos(playerid, -1811.8918, -406.4462, 15.5986);
                PutPlayerInVehicle(playerid, PlayerInfo[playerid][VeiculoCorrendo], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][VeiculoCorrendo], 2);
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(PlayerInfo[playerid][VeiculoCorrendo], engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(PlayerInfo[playerid][VeiculoCorrendo], engine, lights, alarm, doors, bonnet, boot, 1);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 1){ SetPlayerMarkerForPlayer(i, playerid, BANDIDOC); }
                }
            }
            if(PlayerInfo[playerid][Policial] == true)
            {
                SetPlayerColor(playerid, POLICIALC);
                SalaInfo[0][s_spawn] += 1;
                if(SalaInfo[0][s_spawn] == 1) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1816.7161, -436.1431, 14.6880, 349.8865, 0, 0, 0, 0); SetPlayerPos(playerid, -1816.7161, -436.1431, 14.6880); }
                if(SalaInfo[0][s_spawn] == 2) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1821.2382, -435.8110, 14.6880, 351.3023, 0, 0, 0, 0); SetPlayerPos(playerid, -1821.2382, -435.8110, 14.6880); }
                if(SalaInfo[0][s_spawn] == 3) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1818.1913, -444.4048, 14.6880, 349.4710, 0, 0, 0, 0); SetPlayerPos(playerid, -1818.1913, -444.4048, 14.6880); }
                if(SalaInfo[0][s_spawn] == 4) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1822.5533, -443.8198, 14.6880, 351.3213, 0, 0, 0, 0); SetPlayerPos(playerid, -1822.5533, -443.8198, 14.6880); }
                if(SalaInfo[0][s_spawn] == 5) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1819.2941, -450.6338, 14.6880, 351.0887, 0, 0, 0, 0); SetPlayerPos(playerid, -1819.2941, -450.6338, 14.6880); }
                if(SalaInfo[0][s_spawn] == 6) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1823.4808, -450.1346, 14.6880, 352.4503, 0, 0, 0, 0); SetPlayerPos(playerid, -1823.4808, -450.1346, 14.6880); }
                if(SalaInfo[0][s_spawn] == 7) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1820.3391, -457.7933, 14.6880, 351.8941, 0, 0, 0, 0); SetPlayerPos(playerid, -1820.3391, -457.7933, 14.6880); }
                if(SalaInfo[0][s_spawn] == 8) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1824.4700, -457.2945, 14.6880, 352.6786, 0, 0, 0, 0); SetPlayerPos(playerid, -1824.4700, -457.2945, 14.6880); }
                if(SalaInfo[0][s_spawn] == 9) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], -1821.2692, -464.7719, 14.6880, 352.5127, 0, 0, 0, 0); SetPlayerPos(playerid, -1821.2692, -464.7719, 14.6880); }
                PutPlayerInVehicle(playerid, PlayerInfo[playerid][VeiculoCorrendo], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][VeiculoCorrendo], 2);
                PlayerInfo[playerid][CheckPoint] = 1;
            }
            TogglePlayerControllable(playerid, 0);
            SetPlayerVirtualWorld(playerid, 2);
            if(PlayerInfo[playerid][EntrandoComecado] == true)
            {
                TogglePlayerControllable(playerid, 1);
            }
            return 1;
        }
        /*if(PlayerInfo[playerid][Sala] == 2)
        {
            SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
            PlayerInfo[playerid][MiniMapaT] = SetTimerEx("MiniMapaSet",600,true,"i",playerid);
            TextDrawShowForPlayer(playerid, MiniMapa[playerid]);
            if(PlayerInfo[playerid][Bandido] == true)
            {
                SetPlayerColor(playerid, BANDIDOC);
                SalaInfo[1][s_spawn] += 1;
                if(SalaInfo[1][s_spawn] == 1){ PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1986.3041, 2019.9581, 11.1673, -90.0000, 1, 1, 0, 0); SetPlayerPos(playerid, 1986.3041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 2){ PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1986.3041, 2024.4581, 11.1673, -90.0000, 1, 1, 0, 0); SetPlayerPos(playerid, 1986.3041, 2024.4581, 11.1673); SalaInfo[1][s_spawn] = 0; }
                PutPlayerInVehicle(playerid, PlayerInfo[playerid][VeiculoCorrendo], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][VeiculoCorrendo], 3);
                new engine,lights,alarm,doors,bonnet,boot,objective;
                GetVehicleParamsEx(PlayerInfo[playerid][VeiculoCorrendo], engine, lights, alarm, doors, bonnet, boot, objective);
                SetVehicleParamsEx(PlayerInfo[playerid][VeiculoCorrendo], engine, lights, alarm, doors, bonnet, boot, 1);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 1){ SetPlayerMarkerForPlayer(i, playerid, BANDIDOC); }
                }
            }
            if(PlayerInfo[playerid][Policial] == true)
            {
                SetPlayerColor(playerid, POLICIALC);
                SalaInfo[1][s_spawn] += 1;
                if(SalaInfo[1][s_spawn] == 1) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1966.3041, 2019.9581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1966.3041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 2) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1966.3041, 2024.4581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1966.3041, 2024.4581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 3) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1959.3041, 2019.9581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1959.3041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 4) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1959.3041, 2024.4581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1959.3041, 2024.4581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 5) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1951.8041, 2024.4581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1951.8041, 2024.4581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 6) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1951.8041, 2019.9581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1951.8041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 7) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1944.8041, 2019.9581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1944.8041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 8) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1944.8041, 2024.4581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1944.8041, 2024.4581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 9) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1937.8041, 2019.9581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1937.8041, 2019.9581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 10) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1937.8041, 2024.4581, 11.1673, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1937.8041, 2024.4581, 11.1673); }
                if(SalaInfo[1][s_spawn] == 11) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1932.1743, 2027.6241, 11.1673, -140.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1932.1743, 2027.6241, 11.1673); }
                if(SalaInfo[1][s_spawn] == 12) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1929.1844, 2023.7433, 11.1673, -140.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1929.1844, 2023.7433, 11.1673); }
                if(SalaInfo[1][s_spawn] == 13) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1930.0380, 2034.9845, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1930.0380, 2034.9845, 11.1673); }
                if(SalaInfo[1][s_spawn] == 14) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1925.2582, 2034.8868, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1925.2582, 2034.8868, 11.1673); }
                if(SalaInfo[1][s_spawn] == 15) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1925.2697, 2043.0051, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1925.2697, 2043.0051, 11.1673); }
                if(SalaInfo[1][s_spawn] == 16) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1929.8947, 2043.4022, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1929.8947, 2043.4022, 11.1673); }
                if(SalaInfo[1][s_spawn] == 17) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1930.1235, 2049.8528, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1930.1235, 2049.8528, 11.1673); }
                if(SalaInfo[1][s_spawn] == 18) { PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 1925.4467, 2049.3743, 11.1673, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1925.4467, 2049.3743, 11.1673); }
                PutPlayerInVehicle(playerid, PlayerInfo[playerid][VeiculoCorrendo], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][VeiculoCorrendo], 3);
            }
            TogglePlayerControllable(playerid, 0);
            SetPlayerVirtualWorld(playerid, 3);
        }
        */
        else if(PlayerInfo[playerid][Sala] == 2)
        {
            MotoCrossSInfo[0][posicaospawnar] += 1;
            SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
            if(MotoCrossSInfo[0][posicaospawnar] == 1){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.1315, 1555.2085, 422.8489+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.1315, 1555.2085, 422.8489); }
            if(MotoCrossSInfo[0][posicaospawnar] == 2){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.1315+2, 1555.2085, 422.8489+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.1315+2, 1555.2085, 422.8489); }
            if(MotoCrossSInfo[0][posicaospawnar] == 3){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.1315+4, 1555.2085, 422.8489+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.1315+4, 1555.2085, 422.8489); }
            if(MotoCrossSInfo[0][posicaospawnar] == 4){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.1315+6, 1555.2085, 422.8489+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.1315+6, 1555.2085, 422.8489); }
            if(MotoCrossSInfo[0][posicaospawnar] == 5){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.2342, 1560.2214, 422.8501+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.2342, 1560.2214, 422.8501); }
            if(MotoCrossSInfo[0][posicaospawnar] == 6){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.2342+2, 1560.2214, 422.8501+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.2342+2, 1560.2214, 422.8501); }
            if(MotoCrossSInfo[0][posicaospawnar] == 7){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(468, 43.2342+4, 1560.2214, 422.8501+5, 180.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 43.2342+4, 1560.2214, 422.8501); }
            PutPlayerInVehicle(playerid, PlayerInfo[playerid][CorridaCar], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][CorridaCar], 5);
            TogglePlayerControllable(playerid, 0);
            SetPlayerVirtualWorld(playerid, 5);
            PlayerInfo[playerid][CheckPoint] = 1;
            SetPlayerCheckpoint(playerid, 79.3888,1544.5573,422.8443, 3.0);
            PlayerInfo[playerid][Volta] = 0;
            TextDrawShowForPlayer(playerid, CorridaTD[0][playerid]);
            TextDrawShowForPlayer(playerid, CorridaTD[1][playerid]);
            TextDrawShowForPlayer(playerid, CorridaTD[2][playerid]);
            TextDrawSetString( CorridaTD[0][playerid], "VOLTA: 3");
            TextDrawSetString( CorridaTD[1][playerid], "POSICAO: 1");
            TextDrawSetString( CorridaTD[2][playerid], "CheckPoint: 1/15");
            return 1;
        }
        else if(PlayerInfo[playerid][Sala] == 3)
        {
            CorridaHSInfo[0][posicaospawnar] += 1;
            SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
            if(CorridaHSInfo[0][posicaospawnar] == 1){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1503.1029, -2449.6775, 213.8643+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1503.1029, -2449.6775, 213.8643); }
            if(CorridaHSInfo[0][posicaospawnar] == 2){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1503.1029+4, -2449.6775, 213.8643+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1503.1029+4, -2449.6775, 213.8643); }
            if(CorridaHSInfo[0][posicaospawnar] == 3){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1503.1029+8, -2449.6775, 213.8643+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1503.1029+8, -2449.6775, 213.8643); }
            if(CorridaHSInfo[0][posicaospawnar] == 4){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1503.1029+12, -2449.6775, 213.8643+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1503.1029+12, -2449.6775, 213.8643); }
            if(CorridaHSInfo[0][posicaospawnar] == 5){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1485.8622, -2449.2014, 213.8727+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1485.8622, -2449.2014, 213.8727); }
            if(CorridaHSInfo[0][posicaospawnar] == 6){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1485.8622+4, -2449.2014, 213.8727+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1485.8622+4, -2449.2014, 213.8727); }
            if(CorridaHSInfo[0][posicaospawnar] == 7){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1485.8622+8, -2449.2014, 213.8727+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1485.8622+8, -2449.2014, 213.8727); }
            if(CorridaHSInfo[0][posicaospawnar] == 7){ PlayerInfo[playerid][CorridaCar] = CreateVehicle(494, 1485.8622+12, -2449.2014, 213.8727+5, -90.0000, 0, 0, 0, 0); SetPlayerPos(playerid, 1485.8622+12, -2449.2014, 213.8727); }
            PutPlayerInVehicle(playerid, PlayerInfo[playerid][CorridaCar], 0);
            LinkVehicleToInterior(PlayerInfo[playerid][CorridaCar], 5);
            TogglePlayerControllable(playerid, 0);
            SetPlayerInterior(playerid, 5);
            PlayerInfo[playerid][CheckPoint] = 1;
            PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1521.5593, -2455.0725, 213.8727, 0.0, 0.0, 0.0);
            SetPlayerCheckpoint(playerid, 1521.5593, -2455.0725, 213.8727, 30.0);
            PlayerInfo[playerid][Volta] = 0;
            TextDrawShowForPlayer(playerid, CorridaTD[0][playerid]);
            TextDrawShowForPlayer(playerid, CorridaTD[1][playerid]);
            TextDrawShowForPlayer(playerid, CorridaTD[2][playerid]);
            TextDrawSetString( CorridaTD[0][playerid], "VOLTA: 3");
            TextDrawSetString( CorridaTD[1][playerid], "POSICAO: 1");
            TextDrawSetString( CorridaTD[2][playerid], "CheckPoint: 1/10");
            PlayerInfo[playerid][Sala] = 3;
            return 1;
        }
        return 1;
    }
    TogglePlayerControllable(playerid, 0);
    PlayerInfo[playerid][TimerCarregarOBJ] = SetTimerEx("CarregandoObjetos", 3000, false, "i", playerid);
    SetPlayerSkin(playerid, PlayerInfo[playerid][Skin]);
    SetPlayerPos(playerid, 229.0576,1997.7352,417.5857);
    SetPlayerFacingAngle(playerid,185.2091);
    SetPlayerScore(playerid, PlayerInfo[playerid][Level]);
    foreach(Player, i){ SetPlayerMarkerForPlayer(i, playerid, 0xFFFFFF00); }
    if(PlayerInfo[playerid][Socio] == 1){ SetPlayerColor(playerid, 0xB8860BAA); }
    if(PlayerInfo[playerid][Socio] == 2){ SetPlayerColor(playerid, 0x808080AA); }
    if(PlayerInfo[playerid][Socio] == 3){ SetPlayerColor(playerid, 0xFFD700AA); }
    if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3){ SetPlayerColor(playerid, 0xCD2626AA); }
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    CreateAudioPlayerLocation(playerid, 1056);
    DisablePlayerCheckpoint(playerid);
    if(PlayerInfo[playerid][CheckPoint] == 1)
    {
        if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 79.3888, 1544.5573, 422.8443, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 79.3888,1544.5573,422.8443, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 2;
	        return 1;
		}
  		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1759.4631, -2455.0771, 213.8729, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1759.4631, -2455.0771, 213.8729, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 2;
	        return 1;
		}
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 2)
    {
    	if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 101.1210, 1544.3917, 422.8496, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 101.1210, 1544.3917, 422.8496, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 3;
	        return 1;
		}
 		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1918.9922, -2398.6975, 213.8499, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1918.9922, -2398.6975, 213.8499, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 3;
	        return 1;
		}
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 3)
    {
    	if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 126.6210, 1558.9077, 423.7162, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 126.6210, 1558.9077, 423.7162, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 4;
	        return 1;
        }
        if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1942.5474, -2200.8923, 213.8596, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1942.5474, -2200.8923, 213.8596, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 4;
	        return 1;
        }
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 4)
    {
    	if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 128.7200, 1620.2000, 423.6268, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 128.7200, 1620.2000, 423.6268, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 5;
	        return 1;
        }
       	if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 2009.9337, -2403.3691, 213.8650, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 2009.9337, -2403.3691, 213.8650, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 5;
	        return 1;
        }
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 5)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 128.4612, 1640.9210, 422.8377, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 128.4612, 1640.9210, 422.8377, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 6;
	        return 1;
        }
   		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1973.4178, -2590.8247, 213.8650, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1973.4178, -2590.8247, 213.8650, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 6;
	        return 1;
        }
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 6)
    {
        if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 80.3551, 1650.2314, 422.8447, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 80.3551, 1650.2314, 422.8447, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 7;
	        return 1;
		}
  		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1716.1589, -2594.1267, 213.8650, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1716.1589, -2594.1267, 213.8650, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 7;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 7)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 62.8330, 1626.2078, 422.8383, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 62.8330, 1626.2078, 422.8383, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 8;
	        return 1;
		}
		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1497.6298, -2592.5850, 213.8688, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1497.6298, -2592.5850, 213.8688, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 8;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 8)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 61.7399, 1589.2618, 422.8442, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 61.7399, 1589.2618, 422.8442, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 9;
	        return 1;
		}
		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1316.7238, -2507.9463, 213.8501, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1316.7238, -2507.9463, 213.8501, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 9;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 9)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 103.6311, 1591.5927, 422.8445, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 103.6311, 1591.5927, 422.8445, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 10;
	        return 1;
		}
		if(PlayerInfo[playerid][Sala] == 3)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1450.3246, -2458.1104, 213.8652, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 1450.3246, -2458.1104, 213.8652, 30.0);
	        PlayerInfo[playerid][CheckPoint] = 10;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 10)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 104.3371, 1665.2311, 422.8442, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 104.3371, 1665.2311, 422.8442, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 11;
	        return 1;
		}
		if(PlayerInfo[playerid][Sala] == 3)
        {
			if(PlayerInfo[playerid][Volta] != 3)
	        {
	            DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	            PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 1521.5593, -2455.0725, 213.8727, 0.0, 0.0, 0.0);
	            SetPlayerCheckpoint(playerid, 1521.5593, -2455.0725, 213.8727, 30.0);
	            PlayerInfo[playerid][CheckPoint] = 1;
	            PlayerInfo[playerid][Volta] += 1;
	            return 1;
	        }
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
	        new msg[500],pos[500];
	        CorridaHSInfo[0][terminoupos] += 1;
	        if(CorridaHSInfo[0][terminoupos] == 1){ pos = "Primeiro"; }
	        if(CorridaHSInfo[0][terminoupos] == 2){ pos = "Segundo"; }
	        if(CorridaHSInfo[0][terminoupos] == 3){ pos = "Terceiro"; }
	        if(CorridaHSInfo[0][terminoupos] == 4){ pos = "Quarto"; }
	        if(CorridaHSInfo[0][terminoupos] == 5){ pos = "Quinto"; }
	        if(CorridaHSInfo[0][terminoupos] == 6){ pos = "Sexto"; }
	        if(CorridaHSInfo[0][terminoupos] == 7){ pos = "Setimo"; }
	        format(msg, sizeof(msg), "[{4682B4}CORRIDA{FFFFFF}]: %s terminou a corrida em %s lugar.", PlayerName(playerid), pos);
	        SendClientMessageToAll(BRANCO, msg);
	        GivePlayerMoneyR(playerid, CorridaHSInfo[0][premio]);
	        SalvarConta(playerid);
	        ResetarVariaveis(playerid);
	        CarregarConta(playerid);
	        PlayerInfo[playerid][EstaEmCorrida] = true;
			SetPlayerCameraPos(playerid, 1229.4341, -2641.5759, 298.7553);
			SetPlayerCameraLookAt(playerid, 1230.3378, -2641.1465, 298.4509);
	        TextDrawHideForPlayer(playerid, CorridaTD[0][playerid]);
	        TextDrawHideForPlayer(playerid, CorridaTD[1][playerid]);
	        TextDrawHideForPlayer(playerid, CorridaTD[2][playerid]);
	        TogglePlayerControllable(playerid, 1);
	        SetPlayerPos(playerid, 1723.5957, -2558.6755, 214.0292);
	        PlayerInfo[playerid][Sala] = 3;
	        if(CorridaHSInfo[0][terminoupos] == CorridaHSInfo[0][players])
	        {
	            foreach(Player, i)
	            {
	                if(PlayerInfo[i][Sala] == 3)
	                {
	                    ResetarVariaveis(i);
	                    CarregarConta(i);
	                    SetCameraBehindPlayer(i);
	                    SpawnPlayer(i);
	                    ResetarVariaveisSala3();
	                    CorridaHSInfo[0][premio] += 1000;
	                }
	            }
	        }
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 11)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 78.7123, 1692.3634, 423.6832, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 78.7123, 1692.3634, 423.6832, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 12;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 12)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 46.1423, 1702.2810, 428.1746, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 46.1423, 1702.2810, 428.1746, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 13;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 13)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 41.0284, 1627.1830, 422.8445, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 41.0284, 1627.1830, 422.8445, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 14;
	        return 1;
		}
		return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 14)
    {
   		if(PlayerInfo[playerid][Sala] == 2)
        {
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 39.7517, 1583.0129, 422.8355, 0.0, 0.0, 0.0);
	        SetPlayerCheckpoint(playerid, 39.7517, 1583.0129, 422.8355, 7.0);
	        PlayerInfo[playerid][CheckPoint] = 15;
	        return 1;
        }
        return 1;
    }
    if(PlayerInfo[playerid][CheckPoint] == 15)
    {
    	if(PlayerInfo[playerid][Sala] == 2)
        {
	        if(PlayerInfo[playerid][Volta] != 3)
	        {
	            DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	            PlayerInfo[playerid][CheckPointObj] = CreatePlayerObject(playerid, 19945, 101.1210, 1544.3917, 422.8496, 0.0, 0.0, 0.0);
	            SetPlayerCheckpoint(playerid, 79.3888,1544.5573,422.8443, 7.0);
	            PlayerInfo[playerid][CheckPoint] = 1;
	            PlayerInfo[playerid][Volta] += 1;
	            return 1;
	        }
	        DestroyPlayerObject(playerid, PlayerInfo[playerid][CheckPointObj]);
	        DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
	        new msg[500],pos[500];
	        MotoCrossSInfo[0][terminoupos] += 1;
	        if(MotoCrossSInfo[0][terminoupos] == 1){ pos = "Primeiro"; }
	        if(MotoCrossSInfo[0][terminoupos] == 2){ pos = "Segundo"; }
	        if(MotoCrossSInfo[0][terminoupos] == 3){ pos = "Terceiro"; }
	        if(MotoCrossSInfo[0][terminoupos] == 4){ pos = "Quarto"; }
	        if(MotoCrossSInfo[0][terminoupos] == 5){ pos = "Quinto"; }
	        if(MotoCrossSInfo[0][terminoupos] == 6){ pos = "Sexto"; }
	        if(MotoCrossSInfo[0][terminoupos] == 7){ pos = "Setimo"; }
	        format(msg, sizeof(msg), "[{FF4500}MOTOCROSS{FFFFFF}]: %s terminou a corrida em %s lugar.", PlayerName(playerid), pos);
	        SendClientMessageToAll(BRANCO, msg);
	        GivePlayerMoneyR(playerid, MotoCrossSInfo[0][premio]);
	        SalvarConta(playerid);
	        ResetarVariaveis(playerid);
	        CarregarConta(playerid);
	        PlayerInfo[playerid][EstaEmCorrida] = true;
	        SetPlayerCameraPos(playerid, 111.5580, 1708.4485, 446.1476);
	        SetPlayerCameraLookAt(playerid, 111.2323, 1707.4939, 445.8327);
	        TextDrawHideForPlayer(playerid, CorridaTD[0][playerid]);
	        TextDrawHideForPlayer(playerid, CorridaTD[1][playerid]);
	        TextDrawHideForPlayer(playerid, CorridaTD[2][playerid]);
	        TogglePlayerControllable(playerid, 1);
	        SetPlayerPos(playerid, 49.5760, 1524.3468, 422.8473);
	        PlayerInfo[playerid][Sala] = 2;
	        if(MotoCrossSInfo[0][terminoupos] == MotoCrossSInfo[0][players])
	        {
	            foreach(Player, i)
	            {
	                if(PlayerInfo[i][Sala] == 2)
	                {
	                    ResetarVariaveis(i);
	                    CarregarConta(i);
	                    SetCameraBehindPlayer(i);
	                    SpawnPlayer(i);
	                    ResetarVariaveisSala2();
	                    MotoCrossSInfo[0][premio] += 1000;
	                }
	            }
	        }
	        return 1;
		}
        return 1;
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == d_senhasessao)
    {
        new arquivo[500],nome[MAX_PLAYER_NAME],senhadigitada[180];
        GetPlayerName(playerid, nome, sizeof(nome));
        format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
        PlayerInfo[playerid][cSenha] = true;
        if(!DOF2_FileExists(arquivo))
        {
            format(senhadigitada, sizeof(senhadigitada), "%s", inputtext);
            TextDrawSetString( InicioSessaoTextDraw[playerid][15], senhadigitada);
            PlayerInfo[playerid][Senha] = senhadigitada;
        }
        else
        {
            format(senhadigitada, sizeof(senhadigitada), "%s", inputtext);
            TextDrawSetString( InicioSessaoTextDraw[playerid][15], senhadigitada);
            PlayerInfo[playerid][Senhac] = senhadigitada;

        }
        return 1;
    }
    if(dialogid == d_tutorial)
    {
        if(response == 1)
        {
            if(PlayerInfo[playerid][PodePassarTutorial] == false)
            {
                PlayerInfo[playerid][ParteDoTutorial] = 1;
                PlayerInfo[playerid][PodePassarTutorial] = false;
                new aba[702];
                strcat(aba, "{FFFFFF}    Bom, o servidor é de {FF0000}Hot{0000CD}Pursuit{FFFFFF} como vocês podem ver no titulo do servidor, você\n");
                strcat(aba, "pode ganhar dinheiro/level fazendo perseguições e fugindo.\n\n");
                strcat(aba, "    Não terá sempre admins logados pois o servidor é automatico! ou seja você joga por conta da GameMode!\n");
                strcat(aba, "e claro os admins do servidor so podem usar comandos com um tipo de senha que é trocada sempre.\n\n");
                strcat(aba, "    Assim que você spawnar digite /menu e compre um carro na concessionaria! após feito isso vá na garagem(/menu) e selecione o carro\n");
                strcat(aba, "clicando no botão 'usar' e depois saia e comece a jogar em uma sala.\n\n");
                strcat(aba, "    Obs: Para sair de um local(não podera sair de uma perseguição) usando o comando /menu e clicando em sair.");
                ShowPlayerDialog(playerid, d_tutorial, DIALOG_STYLE_MSGBOX, " Informações sobre o servidor", aba, "Avançar", "");
                return SendClientMessage(playerid, ERROR, "Você não pode avançar agora!.");
            }
            else
            {
                ClearChatbox(playerid, 100);
                KillTimer(PlayerInfo[playerid][TimerTutorial]);
                SendClientMessage(playerid, BRANCO, "Você conclui o tutorial! escolha sua skin.");
                ShowModelSelectionMenu(playerid, skinlist, "", 0x00000050, 0x00000050 , 0xFFFFFF99);
                return PlayerInfo[playerid][PodePassarTutorial] = false;
            }
        }
    }
    if(dialogid == d_menu)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][GaragemeConce] == true || PlayerInfo[playerid][Spawnado] == true) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                if(PlayerInfo[playerid][Sala] > 0) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                PlayerInfo[playerid][GaragemeConce] = true;
                AbrirConcessionaria(playerid);
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][GaragemeConce] == true || PlayerInfo[playerid][Spawnado] == true) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                if(PlayerInfo[playerid][Sala] > 0) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                PlayerInfo[playerid][GaragemeConce] = true;
                AbrirAGaragem(playerid);
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][GaragemeConce] == true || PlayerInfo[playerid][Spawnado] == true) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                if(PlayerInfo[playerid][Sala] > 0) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                ShowPlayerDialog(playerid, d_loja, DIALOG_STYLE_TABLIST_HEADERS, "Loja - {FF0000}[HOTPURSUIT]", "{FFFFFF} - Loja para:\tProdutos\n - Veiculos\t Nitro/Trapacias", "Selecionar", "Cancelar");
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][GaragemeConce] == true || PlayerInfo[playerid][Spawnado] == true) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                if(PlayerInfo[playerid][Sala] > 0) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                AbrirSalas(playerid);
            }
            if(listitem == 4)
            {
                if(PlayerInfo[playerid][GaragemeConce] == true || PlayerInfo[playerid][Spawnado] == true) { return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você deve sair de onde você esta antes de usar está opção!"); }
                if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
                if(PlayerInfo[playerid][SlotCarroUsando] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você não selecionou um carro para usar ou não tem um."); }
                PlayerInfo[playerid][Spawnado] = true;
                PlayerInfo[playerid][VeiculoCorrendo] = CreateVehicle(PlayerInfo[playerid][SlotCarroUsando], 913.8081, -1220.3247, 16.9766, 270.8369, PlayerInfo[playerid][CorSlotCarroUsando], PlayerInfo[playerid][CorSlotCarroUsando], 0, 0);
                SetPlayerPos(playerid, 913.8081, -1220.3247, 16.9766);
                PutPlayerInVehicle(playerid, PlayerInfo[playerid][VeiculoCorrendo], 0);
                TextDrawShowForPlayer(playerid, NitroTD[playerid][0]);
                TextDrawShowForPlayer(playerid, NitroTD[playerid][1]);
                TextDrawShowForPlayer(playerid, NitroTD[playerid][2]);
            }
            if(listitem == 5)
            {
                if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
                SairOMenu(playerid);
            }
        }
    }
    if(dialogid == d_escolherslotcarro)
    {
        if(response)
        {
            new id = PlayerInfo[playerid][PaginaConce];
            if(PlayerInfo[playerid][CupomCarro] < 1)
            {
                if(PlayerInfo[playerid][Dinheiro] < ConcessionariaI[id][veiculopreco]){ return SendClientMessage(playerid, ERROR, "CONCESSIONARIA{FFFFFF}: Dinheiro insuficiente!"); }
            }
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][SlotCarro] > 400){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot já esta ocupado!"); }
                PlayerInfo[playerid][SlotCarro] = ConcessionariaI[id][veiculoid];
                PlayerInfo[playerid][CorSlotCarro] = PlayerInfo[playerid][CorComprar];
                SendClientMessage(playerid, VERDE, "CONCESSIONARIA{FFFFFF}: Veiculo comprado! ele foi colocado em sua garagem no slot 1.");
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][SlotCarro2] > 400){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot já esta ocupado!"); }
                PlayerInfo[playerid][SlotCarro2] = ConcessionariaI[id][veiculoid];
                PlayerInfo[playerid][CorSlotCarro2] = PlayerInfo[playerid][CorComprar];
                SendClientMessage(playerid, VERDE, "CONCESSIONARIA{FFFFFF}: Veiculo comprado! ele foi colocado em sua garagem no slot 2.");
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][SlotCarro3] > 400){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot já esta ocupado!"); }
                PlayerInfo[playerid][SlotCarro3] = ConcessionariaI[id][veiculoid];
                PlayerInfo[playerid][CorSlotCarro3] = PlayerInfo[playerid][CorComprar];
                SendClientMessage(playerid, VERDE, "CONCESSIONARIA{FFFFFF}: Veiculo comprado! ele foi colocado em sua garagem no slot 3.");
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][SlotCarro4] > 400){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot já esta ocupado!"); }
                PlayerInfo[playerid][SlotCarro4] = ConcessionariaI[id][veiculoid];
                PlayerInfo[playerid][CorSlotCarro4] = PlayerInfo[playerid][CorComprar];
                SendClientMessage(playerid, VERDE, "CONCESSIONARIA{FFFFFF}: Veiculo comprado! ele foi colocado em sua garagem no slot 4.");
            }
            if(listitem == 4)
            {
                if(PlayerInfo[playerid][SlotCarro5] > 400){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot já esta ocupado!"); }
                PlayerInfo[playerid][SlotCarro5] = ConcessionariaI[id][veiculoid];
                PlayerInfo[playerid][CorSlotCarro5] = PlayerInfo[playerid][CorComprar];
                SendClientMessage(playerid, VERDE, "CONCESSIONARIA{FFFFFF}: Veiculo comprado! ele foi colocado em sua garagem no slot 5.");
            }
            if(PlayerInfo[playerid][PrimeiraVez] == 1)
            {
                PlayerInfo[playerid][PrimeiraVez] = 3;
                SendClientMessage(playerid, BRANCO, "[{00FF00}SUCESSO{FFFFFF}]: Agora digite /menu e clique em sair e apos isso digite /menu novamente!");
                return 1;
            }
            if(PlayerInfo[playerid][CupomCarro] == 0){ GivePlayerMoneyR(playerid, -ConcessionariaI[id][veiculopreco]); }
            if(PlayerInfo[playerid][CupomCarro] > 0) { PlayerInfo[playerid][CupomCarro] -= 1; }
            SalvarConta(playerid);
            PlayerInfo[playerid][ComprandoConce] = false;
            TextDrawHideForPlayer(playerid, Cores[playerid][0]);
            TextDrawHideForPlayer(playerid, Cores[playerid][1]);
            TextDrawHideForPlayer(playerid, Cores[playerid][2]);
            TextDrawHideForPlayer(playerid, Cores[playerid][3]);
            TextDrawHideForPlayer(playerid, Cores[playerid][4]);
            TextDrawHideForPlayer(playerid, Cores[playerid][5]);
            TextDrawHideForPlayer(playerid, Cores[playerid][6]);
            TextDrawHideForPlayer(playerid, Cores[playerid][7]);
            TextDrawHideForPlayer(playerid, Cores[playerid][8]);
            TextDrawHideForPlayer(playerid, Cores[playerid][9]);
            TextDrawHideForPlayer(playerid, Cores[playerid][10]);
        }
    }
    if(dialogid == d_deletarcarro)
    {
        if(response)
        {
            new id = PlayerInfo[playerid][PaginaGaragem];
            new iddocarro;
            if(id == 0){ iddocarro = PlayerInfo[playerid][SlotCarro]; }
            if(id == 1){ iddocarro = PlayerInfo[playerid][SlotCarro2]; }
            if(id == 2){ iddocarro = PlayerInfo[playerid][SlotCarro3]; }
            if(id == 3){ iddocarro = PlayerInfo[playerid][SlotCarro4]; }
            if(id == 4){ iddocarro = PlayerInfo[playerid][SlotCarro5]; }
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[{FF0000}Hot-Pursuit{FFFFFF}]: Você deletou seu %s.", GetVehicleName(iddocarro));
            SendClientMessage(playerid, BRANCO, mensagem);
            if(id == 0) { PlayerInfo[playerid][SlotCarro] = 0; }
            if(id == 1) { PlayerInfo[playerid][SlotCarro2] = 0; }
            if(id == 2) { PlayerInfo[playerid][SlotCarro3] = 0; }
            if(id == 3) { PlayerInfo[playerid][SlotCarro4] = 0; }
            if(id == 4) { PlayerInfo[playerid][SlotCarro5] = 0; }
            if(PlayerInfo[playerid][SlotCarroUsando] == iddocarro){ PlayerInfo[playerid][SlotCarroUsando] = 0; }
            SalvarConta(playerid);
            new nome[200];
            if(PlayerInfo[playerid][PaginaGaragem] == 0)
            {
                format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro]));
                DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
            }
            if(PlayerInfo[playerid][PaginaGaragem] == 1)
            {
                format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro2]));
                DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro2], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro2], PlayerInfo[playerid][CorSlotCarro2], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
            }
            if(PlayerInfo[playerid][PaginaGaragem] == 2)
            {
                format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro3]));
                DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro3], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro3], PlayerInfo[playerid][CorSlotCarro3], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
            }
            if(PlayerInfo[playerid][PaginaGaragem] == 3)
            {
                format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro4]));
                DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro4], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro4], PlayerInfo[playerid][CorSlotCarro4], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
            }
            if(PlayerInfo[playerid][PaginaGaragem] == 4)
            {
                format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro5]));
                DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro5], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro5], PlayerInfo[playerid][CorSlotCarro5], 0);
                SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
            }
            TextDrawSetString( Garagem[playerid][4], nome);
        }
        else
        {

        }
    }
    if(dialogid == d_vendercarro)
    {
        if(response)
        {
            for(new idx = 0; idx < sizeof(ConcessionariaI) ; idx++)
            {
                new id = PlayerInfo[playerid][PaginaGaragem];
                new iddocarro;
                if(id == 0) { iddocarro = PlayerInfo[playerid][SlotCarro]; }
                if(id == 1) { iddocarro = PlayerInfo[playerid][SlotCarro2]; }
                if(id == 2) { iddocarro = PlayerInfo[playerid][SlotCarro3]; }
                if(id == 3) { iddocarro = PlayerInfo[playerid][SlotCarro4]; }
                if(id == 4) { iddocarro = PlayerInfo[playerid][SlotCarro5]; }
                if(ConcessionariaI[idx][veiculoid] == iddocarro)
                {
                    GivePlayerMoneyR(playerid, -ConcessionariaI[idx][veiculopreco]);
                    new mensagem[300];
                    format(mensagem, sizeof(mensagem), "[{FF0000}Hot-Pursuit{FFFFFF}]: Você vendeu seu %s por R$%d.", GetVehicleName(iddocarro), ConcessionariaI[idx][veiculopreco]);
                    SendClientMessage(playerid, BRANCO, mensagem);
                }
                if(id == 0) { PlayerInfo[playerid][SlotCarro] = 0; }
                if(id == 1) { PlayerInfo[playerid][SlotCarro2] = 0; }
                if(id == 2) { PlayerInfo[playerid][SlotCarro3] = 0; }
                if(id == 3) { PlayerInfo[playerid][SlotCarro4] = 0; }
                if(id == 4) { PlayerInfo[playerid][SlotCarro5] = 0; }
                SalvarConta(playerid);
                new nome[200];
                if(PlayerInfo[playerid][PaginaGaragem] == 0)
                {
                    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro]));
                    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro], 0);
                    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
                }
                if(PlayerInfo[playerid][PaginaGaragem] == 1)
                {
                    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro2]));
                    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro2], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro2], PlayerInfo[playerid][CorSlotCarro2], 0);
                    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
                }
                if(PlayerInfo[playerid][PaginaGaragem] == 2)
                {
                    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro3]));
                    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro3], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro3], PlayerInfo[playerid][CorSlotCarro3], 0);
                    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
                }
                if(PlayerInfo[playerid][PaginaGaragem] == 3)
                {
                    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro4]));
                    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro4], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro4], PlayerInfo[playerid][CorSlotCarro4], 0);
                    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
                }
                if(PlayerInfo[playerid][PaginaGaragem] == 4)
                {
                    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro5]));
                    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
                    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro5], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro5], PlayerInfo[playerid][CorSlotCarro5], 0);
                    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
                }
                TextDrawSetString( Garagem[playerid][4], nome);
            }
        }
        else
        {

        }
    }
    if(dialogid == d_entrarsala)
    {
        if(response)
        {
            if(PlayerInfo[playerid][SlotCarroUsando] == 0)
            {
                if(PlayerInfo[playerid][SlotCarro] == 0 && PlayerInfo[playerid][SlotCarro2] == 0 && PlayerInfo[playerid][SlotCarro3] == 0 && PlayerInfo[playerid][SlotCarro4] == 0 && PlayerInfo[playerid][SlotCarro5] == 0)
                {
                    return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem nenhum carro! compre uma para poder correr.");
                }
                if(PlayerInfo[playerid][SlotCarro] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro2]; }
                if(PlayerInfo[playerid][SlotCarro2] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro3]; }
                if(PlayerInfo[playerid][SlotCarro3] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro4]; }
                if(PlayerInfo[playerid][SlotCarro4] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro5]; }
                if(PlayerInfo[playerid][SlotCarro5] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro]; }
            }
            if(SalaInfo[0][s_players] == 10){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
            PlayerInfo[playerid][Sala] = 1;
            SalaInfo[0][s_players] += 1;
            PlayerInfo[playerid][IdSala] = SalaInfo[0][s_players];
            if(SalaInfo[0][s_comecou] == false)
            {
                if(SalaInfo[0][s_players] == 2)
                {
                    SalaInfo[0][s_timeriniciar] = SetTimer("IniciarJogoSala1",20000,false);
                    foreach(Player, i)
                    {
                        if(PlayerInfo[i][Sala] == 1)
                        {
                            SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: 20 segundos para inicio da partida.");
                        }
                    }
                }
            }
            else if(SalaInfo[0][s_comecou] == true)
            {
                PlayerInfo[playerid][Policial] = true;
                PlayerInfo[playerid][EstaEmCorrida] = true;
                SairOMenu(playerid);
                PlayerInfo[playerid][Sala] = 1;
                PlayerInfo[playerid][EntrandoComecado] = true;
                return 1;
            }
            new sala[300];
            format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
            TextDrawSetString( NomeSalaTD[0], sala);
        }
    }
    if(dialogid == d_entrarsala2)
    {
        if(response)
        {
            if(MotoCrossSInfo[0][premio] == 7){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
            if(PlayerInfo[playerid][EstaEmCorrida] == true){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já esta em uma corrida."); }
            MotoCrossSInfo[0][players] += 1;
            PlayerInfo[playerid][Sala] = 2;
            new sala[300];
            format(sala, sizeof(sala), "~l~[~y~MOTOCROSS~l~]       Premio: ~g~R$%d~l~         %d/7 Players", MotoCrossSInfo[0][premio], MotoCrossSInfo[0][players]);
            TextDrawSetString( NomeSalaTD[1], sala);
            if(MotoCrossSInfo[0][players] == 2 && MotoCrossSInfo[0][comecou] == false)
            {
                MotoCrossSInfo[0][timercomecarpartida] = SetTimer("IniciarMotocross",20000,false);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 2)
                    {
                        SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: 20 segundos para inicio da partida.");
                    }
                }
            }
        }
    }
    if(dialogid == d_entrarsala3)
    {
        if(response)
        {
            if(CorridaHSInfo[0][players] == 8){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
            if(PlayerInfo[playerid][EstaEmCorrida] == true){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já esta em uma corrida."); }
            CorridaHSInfo[0][players] += 1;
            PlayerInfo[playerid][Sala] = 3;
            new sala[300];
            format(sala, sizeof(sala), "~l~[~r~EUAxAFEGANI~l~]      Premio: ~g~R$%d~l~         %d/12 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
            TextDrawSetString( NomeSalaTD[3], sala);
            if(CorridaHSInfo[0][players] == 2 && CorridaHSInfo[0][comecou] == false)
            {
                CorridaHSInfo[0][timercomecarpartida] = SetTimer("IniciarCorrida",20000,false);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 3)
                    {
                        SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: 20 segundos para inicio da partida.");
                    }
                }
            }
        }
    }
    if(dialogid == d_entrarsala4)
    {
        if(response)
        {
            if(GuerraSInfo[0][players] == 30){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
            if(PlayerInfo[playerid][EstaEmGuerra] == true){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já esta em uma corrida."); }
            GuerraSInfo[0][players] += 1;
            PlayerInfo[playerid][Sala] = 4;
            new sala[300];
            format(sala, sizeof(sala), "~l~[~b~CORRIDA~l~]            Premio: ~g~R$%d~l~         %d/30 Players", GuerraSInfo[0][premio], GuerraSInfo[0][players]);
            TextDrawSetString( NomeSalaTD[2], sala);
            if(GuerraSInfo[0][players] == 1 && GuerraSInfo[0][comecou] == false)
            {
                GuerraSInfo[0][timercomecarpartida] = SetTimer("IniciarGuerra",20000,false);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Sala] == 4)
                    {
                        SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: 20 segundos para inicio da partida.");
                    }
                }
            }
        }
    }
    if(dialogid == d_deixarsala)
    {
        if(response)
        {

        }
        else
        {
            if(PlayerInfo[playerid][Sala] == 1)
            {
                PlayerInfo[playerid][Sala] = 0;
                SalaInfo[0][s_players] -= 1;
                new sala[300];
                format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                TextDrawSetString( NomeSalaTD[0], sala);
                if(PlayerInfo[playerid][EstaEmCorrida] == true)
                {
                    if(PlayerInfo[playerid][Policial] == true)
                    {
                        DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
                        ResetarVariaveis(playerid);
                        CarregarConta(playerid);
                        SpawnPlayer(playerid);
                        SalaInfo[0][s_players] -= 1;
                        SalaInfo[0][s_spawn] -= 1;
                    }
                    if(PlayerInfo[playerid][Bandido] == true)
                    {
                        foreach(Player, i)
                        {
                            if(PlayerInfo[i][Sala] == 1)
                            {
                                if(PlayerInfo[i][Policial] == true)
                                {
                                    SendClientMessage(i, ERROR, "[AVISO]{FFFFFF}: O bandido saiu da sala!");
                                    ResetarVariaveis(i);
                                    CarregarConta(i);
                                    DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                                    SpawnPlayer(i);
                                }
                            }
                        }
                        ResetarVariavelSala1();
                        format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                        TextDrawSetString( NomeSalaTD[0], sala);
                    }
                    if(SalaInfo[0][s_comecou] == true)
                    {
                        if(SalaInfo[0][s_players] < 2)
                        {
                            foreach(Player, i)
                            {
                                if(PlayerInfo[i][Sala] == 1)
                                {
                                    DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                                    ResetarVariaveis(playerid);
                                    CarregarConta(playerid);
                                    SpawnPlayer(i);
                                }
                            }
                            ResetarVariavelSala1();
                            format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                            TextDrawSetString( NomeSalaTD[0], sala);
                        }
                    }
                }
            }
            else if(PlayerInfo[playerid][Sala] == 2)
            {
                DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
                ResetarVariaveis(playerid);
                CarregarConta(playerid);
                SpawnPlayer(playerid);
                PlayerInfo[playerid][Sala] = 0;
                MotoCrossSInfo[0][players] -= 1;
                new sala[300];
                format(sala, sizeof(sala), "~l~[~y~MOTOCROSS~l~]       Premio: ~g~R$%d~l~         %d/7 Players", MotoCrossSInfo[0][premio], MotoCrossSInfo[0][players]);
                TextDrawSetString( NomeSalaTD[1], sala);
            }
        	else if(PlayerInfo[playerid][Sala] == 3)
            {
                DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
                ResetarVariaveis(playerid);
                CarregarConta(playerid);
                SpawnPlayer(playerid);
                PlayerInfo[playerid][Sala] = 0;
                CorridaHSInfo[0][players] -= 1;
                new sala[300];
                format(sala, sizeof(sala), "~l~[~b~CORRIDA~l~]            Premio: ~g~R$%d~l~         %d/8 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
                TextDrawSetString( NomeSalaTD[3], sala);
            }
        	else if(PlayerInfo[playerid][Sala] == 4)
            {
                DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
                ResetarVariaveis(playerid);
                CarregarConta(playerid);
                SpawnPlayer(playerid);
                PlayerInfo[playerid][Sala] = 0;
                GuerraSInfo[0][players] -= 1;
                new sala[300];
                format(sala, sizeof(sala), "~l~[~b~CORRIDA~l~]            Premio: ~g~R$%d~l~         %d/30 Players", GuerraSInfo[0][premio], GuerraSInfo[0][players]);
                TextDrawSetString( NomeSalaTD[2], sala);
            }
        }
    }
    if(dialogid == d_loja)
    {
        if(response)
        {
            if(listitem == 0)
            {
                ShowPlayerDialog(playerid, d_loja2, DIALOG_STYLE_TABLIST_HEADERS, "Loja/Veiculos - {FF0000}[HOTPURSUIT]", "{FFFFFF} - Produto:\tPreço\n - Nitro\t R$1.000\n - Escudo de agua\t R$13.000\n - Pregos danificadores\t R$20.000\n - Missel \t R$25.000", "Selecionar", "Cancelar");
            }
        }
    }
    if(dialogid == d_loja2)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][NitroVeiculo] == true)
                {
                    SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já possui nitro.");
                    return 1;
                }
                if(PlayerInfo[playerid][Dinheiro] > 999)
                {
                    GivePlayerMoneyR(playerid, -1000);
                    PlayerInfo[playerid][NitroVeiculo] = true;
                    SalvarConta(playerid);
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Nitro comprado.");
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem dinheiro suficiente");
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][Escudo] == true)
                {
                    SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já possui escudo.");
                    return 1;
                }
                if(PlayerInfo[playerid][Dinheiro] > 12999)
                {
                    GivePlayerMoneyR(playerid, -13000);
                    PlayerInfo[playerid][Escudo] = true;
                    SalvarConta(playerid);
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Escudo comprado.");
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem dinheiro suficiente");
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][Prego] == true)
                {
                    SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já possui pregos danificadores.");
                    return 1;
                }
                if(PlayerInfo[playerid][Dinheiro] > 19999)
                {
                    GivePlayerMoneyR(playerid, -20000);
                    PlayerInfo[playerid][Prego] = true;
                    SalvarConta(playerid);
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Pregos danificadores comprado.");
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem dinheiro suficiente");
            }
            if(listitem == 3)
            {
                if(PlayerInfo[playerid][Missel] == true)
                {
                    SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já possui missel.");
                    return 1;
                }
                if(PlayerInfo[playerid][Dinheiro] > 24999)
                {
                    GivePlayerMoneyR(playerid, -25000);
                    PlayerInfo[playerid][Missel] = true;
                    SalvarConta(playerid);
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Missel comprado.");
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem dinheiro suficiente");
            }
            SendClientMessage(playerid, BRANCO, "[{FFFF00}Hot-Pursuit{FFFFFF}]: Use /escolhertrapacias para escolher a trapacia de sua escolha");
        }
    }
    if(dialogid == d_trapacias)
    {
        if(response)
        {
            if(listitem == 0)
            {
                if(PlayerInfo[playerid][Escudo] == true)
                {
                    PlayerInfo[playerid][PoderUsando] = 1;
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Agora você esta usando o Escudo de agua.");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: O Escudo de agua so pode ser usado quando você for bandido!");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Segure CTRL para usar o poder.");
                    return 1;
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não possui essa trapaça!");
            }
            if(listitem == 1)
            {
                if(PlayerInfo[playerid][Prego] == true)
                {
                    PlayerInfo[playerid][PoderUsando] = 2;
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Agora você esta usando os Pregos Danificadores.");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Os Pregos danificadores so pode ser usado quando você for policial!");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Segure CTRL para usar o poder.");
                    return 1;
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não possui essa trapaça!");
            }
            if(listitem == 2)
            {
                if(PlayerInfo[playerid][Missel] == true)
                {
                    PlayerInfo[playerid][PoderUsando] = 3;
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Agora você esta usando o Missel.");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: O Missel so pode ser usado quando você for policial!");
                    SendClientMessage(playerid, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}]: Segure CTRL para usar o poder.");
                    SendClientMessage(playerid, BRANCO, "[{FFFF00}Hot-Pursuit{FFFFFF}]: Use a tecla E para trocar a distancia de alcance do seu missel.");
                    return 1;
                }
                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não possui essa trapaça!");
            }
        }
    }
    return 0;
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(PlayerInfo[playerid][EstaEmCorrida] == true && PlayerInfo[playerid][Sala] == 2){ return RepairVehicle(vehicleid); }
    if(PlayerInfo[playerid][Bandido] == true){ return 1; }
    RepairVehicle(vehicleid);
    return 1;
}

public OnPlayerUpdate(playerid)
{
    if(PlayerInfo[playerid][Sala] == 2)
    {
        if(!IsPlayerInAnyVehicle(playerid))
        {
            PutPlayerInVehicle(playerid, PlayerInfo[playerid][CorridaCar], 0);
        }
        RepairVehicle(GetPlayerVehicleID(playerid));
        new str[500]/*,str2[500]*/,str3[500];
        format(str, sizeof(str), "Volta: %d/3", PlayerInfo[playerid][Volta]);
        TextDrawSetString( CorridaTD[0][playerid], str);
        //format(str2, sizeof(str2), "Posição: ", PlayerInfo[playerid][Volta]);
        format(str3, sizeof(str3), "CheckPoint: %d/15", PlayerInfo[playerid][CheckPoint]);
        TextDrawSetString( CorridaTD[2][playerid], str3);
    }
    if(PlayerInfo[playerid][Sala] == 3)
    {
        if(!IsPlayerInAnyVehicle(playerid))
        {
            PutPlayerInVehicle(playerid, PlayerInfo[playerid][CorridaCar], 0);
        }
        RepairVehicle(GetPlayerVehicleID(playerid));
        new str[500]/*,str2[500]*/,str3[500];
        format(str, sizeof(str), "Volta: %d/3", PlayerInfo[playerid][Volta]);
        TextDrawSetString( CorridaTD[0][playerid], str);
        //format(str2, sizeof(str2), "Posição: ", PlayerInfo[playerid][Volta]);
        format(str3, sizeof(str3), "CheckPoint: %d/10", PlayerInfo[playerid][CheckPoint]);
        TextDrawSetString( CorridaTD[2][playerid], str3);
    }
    if(PlayerInfo[playerid][Bandido] == true && PlayerInfo[playerid][EstaEmCorrida] == true && PlayerInfo[playerid][Sala] == 1)
    {
        new Float:Pos[3];
        GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
        if(Pos[2] < 0)
        {
            SalaInfo[0][s_bandidoganhou] = false;
            VerificarSala1();
        }
    }
    if(IsPlayerInAnyVehicle(playerid))
    {
        new velo[300];
        format(velo, sizeof(velo), "%d KM/H", GetVehicleSpeed(GetPlayerVehicleID(playerid)));
        TextDrawSetString( Velocimetro[playerid], velo);
        TextDrawShowForPlayer(playerid, Velocimetro[playerid]);
    }
    if(!IsPlayerInAnyVehicle(playerid)){ TextDrawHideForPlayer(playerid, Velocimetro[playerid]); }
    if(GetPlayerWeapon(playerid) > 0 && PlayerInfo[playerid][EstaEmGuerra] == false)
    {
        new msg[500];
        format(msg, sizeof(msg), "[Ant-Cheat] O player %s foi kikado por estar com uma arma.", PlayerName(playerid));
        SendClientMessageToAll(0xE60000FF, msg);
        SetTimerEx("Kickar",1000,false,"i",playerid);
        return 1;
    }
    if(GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 300)
    {
        new msg[500];
        format(msg, sizeof(msg), "[Ant-Cheat] O player %s foi kikado por estar a mais de 300 Kmh por hora.", PlayerName(playerid));
        SendClientMessageToAll(0xE60000FF, msg);
        SetTimerEx("Kickar",1000,false,"i",playerid);
        return 1;
    }
    ResetPlayerMoney(playerid);
    SetPlayerScore(playerid, PlayerInfo[playerid][Level]);
    GivePlayerMoney(playerid, PlayerInfo[playerid][Dinheiro]);
    if(PlayerInfo[playerid][Bandido] == true && PlayerInfo[playerid][Sala] == 1 && PlayerInfo[playerid][JogandoSala] == true)
    {
        new Float:vida;
        GetVehicleHealth(GetPlayerVehicleID(playerid), vida);
        if(vida < 400)
        {
            SalaInfo[0][s_bandidoganhou] = true;
            return 1;
        }
        return 1;
    }
    if(IsPlayerInAnyVehicle(playerid))
    {
        static Float:Quat[2], Check;
        GetVehicleRotationQuat(GetPlayerVehicleID(playerid), Quat[0], Quat[1], Quat[0], Quat[0]);
        Check =  (Quat[1] >= 0.60 || Quat[1] <= -0.60);

        if(Check)
        {
        	if(PlayerInfo[playerid][Sala] == 2 && PlayerInfo[playerid][EstaEmCorrida] == true)
            {
                return 1;
            }
            if(PlayerInfo[playerid][Bandido] == true)
            {
                return 1;
            }
            new Float:x,Float:y,Float:z;
            GetPlayerPos(playerid, x, y, z);
            SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
            SetVehicleZAngle(GetPlayerVehicleID(playerid), 0);
        }
        Check = 0;
    }
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext,"/deixarsala",true)==0)
    {
        if(PlayerInfo[playerid][EstaEmCorrida] == true)
        {
            ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Deixar Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar");
            return 1;
        }
        return 1;
    }
    if(PlayerInfo[playerid][EstaEmCorrida] == true || PlayerInfo[playerid][EscolhendoBonus] == true)
    {
        return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você não pode usar comandos agora!");
    }
    if(strcmp(cmdtext,"/menu",true)==0)
    {
        if(PlayerInfo[playerid][PrimeiraVez] == 1)
        {
            ShowPlayerDialog(playerid, d_menu, DIALOG_STYLE_LIST, "Menu", " - Concessionaria {FF0000} <- Clique aqui para comprar um carro!\n - Garagem\n - Shop\n - Salas\n - Spawnar\n - Sair", "Entrar", "");
            return 1;
        }
        if(PlayerInfo[playerid][PrimeiraVez] == 2)
        {
            ShowPlayerDialog(playerid, d_menu, DIALOG_STYLE_LIST, "Menu", " - Concessionaria \n - Garagem {FF0000} <- Clique aqui para selecionar ou ver seus carros!\n - Shop\n - Salas\n - Spawnar\n - Sair", "Entrar", "");
            return 1;
        }
        if(PlayerInfo[playerid][PrimeiraVez] == 3)
        {
            ShowPlayerDialog(playerid, d_menu, DIALOG_STYLE_LIST, "Menu", " - Concessionaria\n - Garagem\n - Shop\n - Salas\n - Spawnar\n - Sair {FF0000} <- Clique aqui!", "Entrar", "");
            return 1;
        }
        if(PlayerInfo[playerid][PrimeiraVez] == 4)
        {
            ShowPlayerDialog(playerid, d_menu, DIALOG_STYLE_LIST, "Menu", " - Concessionaria\n - Garagem\n - Shop\n - Salas\n - Spawnar\n - Sair {FF0000} <- Clique aqui!", "Entrar", "");
            return 1;
        }
        ShowPlayerDialog(playerid, d_menu, DIALOG_STYLE_LIST, "Menu", " - Concessionaria\n - Garagem\n - Shop\n - Salas\n - Spawnar\n - Sair", "Entrar", "");
        return 1;
    }
    if(PlayerInfo[playerid][Logando] == true)
    {
        return ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_MSGBOX, "Aviso de erro", "- Você não pode usar comandos em quanto estiver logando!\n- Inicie uma sessão primeiro para poder jogar e usar comandos.", "Certo", "");
    }
    if(PlayerInfo[playerid][GaragemeConce] == true)
    {
        return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você não pode usar comandos agora!");
    }
    if(PlayerInfo[playerid][EmTutorial] == true)
    {
        return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Você não pode usar comandos no tutorial!");
    }
    new cmd[256];
	new idx;
	cmd = strtok(cmdtext, idx);

    if(strcmp(cmd,"/chatsocio",true)==0)
    {
        if(PlayerInfo[playerid][Socio] == 1 || PlayerInfo[playerid][Socio] == 2 || PlayerInfo[playerid][Socio] == 3)
        {
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
                idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
                result[idx - offset] = cmdtext[idx];
                idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /chatsocio [mensagem]");
                return 1;
            }

            new string[500],cor[100];
            if(PlayerInfo[playerid][Socio] == 1){ cor = "{B8860B}"; }
            if(PlayerInfo[playerid][Socio] == 2){ cor = "{808080}"; }
            if(PlayerInfo[playerid][Socio] == 3){ cor = "{FFD700}"; }
            foreach(Player, i)
            {
                if(PlayerInfo[i][Socio] == 1 || PlayerInfo[i][Socio] == 2 || PlayerInfo[i][Socio] == 3)
                {
                    format(string, sizeof(string), "%s[CHAT SOCIO] %s(%d): %s", cor, PlayerName(playerid), playerid, result);
                    SendClientMessage(i, BRANCO, string);
                }
            }
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/gmx",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /gmx [motivo]");
            	return 1;
            }


            new string[300];
            format(string, sizeof(string), "[Admin-Cmd]{FFFFFF} %s deu gmx [Motivo: %s].", PlayerName(playerid), result);
            SendClientMessageToAll(ERROR, string);
            SendRconCommand("gmx");
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/settempoup",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],upoption;
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /settempoup [tempo] [up]");
                SendClientMessage(playerid, ERROR, "[Opções]{FFFFFF}: 1 - Up player normal | 2 - Up Player Socio Bronze | 3 - Up Player Socio Prata | 4 - Up Player Socio Ouro.");
                return 1;
            }
            new tempo;
            tempo = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /settempoup [tempo] [up]");
                SendClientMessage(playerid, ERROR, "[Opções]{FFFFFF}: 0 - Reseta e deixa normal automaticamente | 1 - Up player normal | 2 - Up Player Socio Bronze | 3 - Up Player Socio Prata | 4 - Up Player Socio Ouro.");
                return 1;
            }
            upoption = strval(tmp);

            new upid[300],string[500];
            if(upoption < 0 || upoption > 4) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você colocou uma opção invalida."); }
            if(upoption == 0)
            {
                up = 3600;
                upsociobronze = 3000;
                upsocioprata = 2400;
                upsocioouro = 1800;
                format(string, sizeof(string), "[Admin-Cmd]{FFFFFF} %s deixou o tempo de up para o tempo normal.", PlayerName(playerid));
                SendClientMessageToAll(ERROR, string);
                return 1;
            }
            if(upoption == 1) { up = tempo; upid = "Normal"; }
            if(upoption == 2) { upsociobronze = tempo; upid = "Socio Bronze";  }
            if(upoption == 3) { upsocioprata = tempo; upid = "Socio Prata"; }
            if(upoption == 4) { upsocioouro = tempo; upid = "Socio Ouro"; }
            format(string, sizeof(string), "[Admin-Cmd]{FFFFFF} %s mudou o tempo de up dos players [%s] para %d.", PlayerName(playerid), upid, tempo);
            SendClientMessageToAll(ERROR, string);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setadministrador",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],nivel;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setadministrador [id] [nivel]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setadministrador [id] [nivel]");
                SendClientMessage(playerid, BRANCO, "NIVEIS: 0 - Retira Administrador. | 1 - Administrador | 2 - Dono | 3 - Scripter.");
                return 1;
            }
            nivel = strval(tmp);

            if(nivel > 3 || nivel < 0){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O nivel que você colocou não existe."); }
            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[800],cargostring[100];
            if(nivel == 0){ cargostring = "Retirou Administrador"; }
            if(nivel == 1){ cargostring = "Administrador"; }
            if(nivel == 2){ cargostring = "Dono"; }
            if(nivel == 3){ cargostring = "Programador"; }
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu administrador cargo [%s] para %s.", dia, mes, ano, horas, minutos, segundos, PlayerName(playerid), cargostring, PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            new mensagem[500];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s setou administrador [%s] para %s.", PlayerName(playerid),cargostring,PlayerName(id));
            if(nivel == 0){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s retirou o administrador de %s.", PlayerName(playerid),PlayerName(id)); }
            SendClientMessageToAll(0xE60000FF, mensagem);
            PlayerInfo[id][Administrador] = nivel;
            SalvarConta(id);
            SetPlayerColor(id, 0xCD2626AA);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/settag",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],tag;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /settag [id] [tag]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /settag [id] [tag]");
                SendClientMessage(playerid, BRANCO, "TAGS: 1 - BetaTester | 2 - Nenhum...");
                return 1;
            }
            tag = strval(tmp);

            if(tag > 1 || tag < 0){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O nivel que você colocou não existe."); }
            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[300],tagstring[100];
            if(tag == 0){ tagstring = "Retirou Tag."; }
            if(tag == 1){ tagstring = "Beta-Tester"; }
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu a tag de [%s] para o player.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),tagstring,PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s setou tag de [%s] para %s.", PlayerName(playerid),tagstring,PlayerName(id));
            if(tag == 0){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s retirou a tag de %s.", PlayerName(playerid),PlayerName(id)); }
            SendClientMessageToAll(0xE60000FF, mensagem);
            PlayerInfo[id][Tag] = tag;
            SalvarConta(id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/banir",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /banirpermanentemente [id] [motivo]");
            }
            new id;
            id = ReturnUser(tmp);
            id = strval(tmp);
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /banirpermanentemente [id] [motivo]");
            	return 1;
            }

            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s baniu %s permanentemente. [MOTIVO: %s]", PlayerName(playerid), PlayerName(id),result);
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s baniu o player %s permanentemente pelo motivo %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),PlayerName(id),result);
            CriarLogAdministradorCMD(logstring);
            PlayerInfo[idx][Banido] = true;
            SalvarConta(idx);
            SetTimerEx("Kickar",1000,false,"i",id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/desbanir",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /desbanir [nome] [motivo]");
                return true;
            }
            new nome[300];
            nome = tmp;
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /desbanir [nome] [motivo]");
            	return 1;
            }

            new mensagem[300];
            new arquivo[500];
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            if(!DOF2_FileExists(arquivo)) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta conta não existe no banco de dados."); }
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s desbaniu %s. [MOTIVO: %s]", PlayerName(playerid), nome, result);
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s desbaniu o player %s pelo motivo %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),nome,result);
            CriarLogAdministradorCMD(logstring);
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            DOF2_SetInt(arquivo,"Banido", 0);
            DOF2_SaveFile();
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/agendarbanimento",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /agendarbanimento [nome] [motivo]");
                return true;
            }
            new nome[300];
            nome = tmp;
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /agendarbanimento [nome] [motivo]");
            	return 1;
            }

            new mensagem[300];
            new arquivo[500];
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            if(!DOF2_FileExists(arquivo)) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta conta não existe no banco de dados."); }
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s agendou ban para %s. [MOTIVO: %s]", PlayerName(playerid), nome, result);
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s agendou ban para %s pelo motivo %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),nome,result);
            CriarLogAdministradorCMD(logstring);
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            DOF2_SetInt(arquivo,"Banido", 1);
            DOF2_SaveFile();
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/agendarsocio",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],nivel;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /agendarsocio [nome] [nivel]");
                return true;
            }
            new nome[300];
            nome = tmp;
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /agendarsocio [nome] [nivel]");
                return true;
            }
            nivel = strval(tmp);

            new mensagem[300];
            new arquivo[500];
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            if(nivel > 3 || nivel < 0){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O nivel que você colocou não existe."); }
            if(!DOF2_FileExists(arquivo)) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta conta não existe no banco de dados."); }
            new dinheiro,cupom,level;
            dinheiro = DOF2_GetInt(arquivo,"Dinheiro");
            cupom = DOF2_GetInt(arquivo,"CupomCarro");
            level = DOF2_GetInt(arquivo,"Level");
            if(nivel == 0){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s agendou retirada do Socio de %s.", PlayerName(playerid), nome); }
            if(nivel == 1){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s agendou Socio Bronze para %s.", PlayerName(playerid), nome); dinheiro += 20000; cupom += 1; level += 10; }
            if(nivel == 2){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s agendou Socio Prata para %s.", PlayerName(playerid), nome); dinheiro += 40000; cupom += 2; level += 20; }
            if(nivel == 3){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s agendou Socio Ouro para %s.", PlayerName(playerid), nome); dinheiro += 60000; cupom += 3; level += 30; }
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s agendou socio nivel %s para %s pelo motivo.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),nivel,nome);
            CriarLogAdministradorCMD(logstring);
            DOF2_SetInt(arquivo,"Socio", nivel);
            DOF2_SetInt(arquivo,"Dinheiro", dinheiro);
            DOF2_SetInt(arquivo,"CupomCarro", cupom);
            DOF2_SetInt(arquivo,"Level", level);
            DOF2_SaveFile();
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/kick",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /kick [id] [motivo]");
            }
            new id;
            id = ReturnUser(tmp);
            id = strval(tmp);
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /kick [id] [motivo]");
            	return 1;
            }

            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s kickou %s. [MOTIVO: %s]", PlayerName(playerid), PlayerName(id),result);
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s kickou o player %s pelo motivo %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),PlayerName(id),result);
            CriarLogAdministradorCMD(logstring);
            SetTimerEx("Kickar",1000,false,"i",id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setmaxnivelbonus",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /setmaxnivelbonus [nivel maximo]");
            }
            new maximo;
            maximo = ReturnUser(tmp);

            if(maximo < 0) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Nivel maximo invalido."); }
            maxnivelbonus = maximo;
            new msg[500];
            format(msg, sizeof(msg), "[Admin-Cmd]{FFFFFF} %s alterou o valor maximo de nivel bonus para %d.", PlayerName(playerid), maxnivelbonus);
            SendClientMessageToAll(0xFF0000AA, msg);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setmaxdinbonus",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /setmaxdinheirobonus [dinheiro maximo]");
            }
            new maximo;
            maximo = ReturnUser(tmp);

            if(maximo < 0) { return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Dinheiro maximo invalido."); }
            maxdinheirobonus = maximo;
            new msg[500];
            format(msg, sizeof(msg), "[Admin-Cmd]{FFFFFF} %s alterou o valor maximo de dinheiro bonus para R$%d.", PlayerName(playerid), maxdinheirobonus);
            SendClientMessageToAll(0xFF0000AA, msg);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/dardinheiro",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],quantia;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /dardinheiro [id] [quantia]");
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                return SendClientMessage(playerid, ERROR, "ERROR: /dardinheiro [id] [quantia]");
            }
            quantia = strval(tmp);


            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} O administrador %s deu R$%d para %s.", PlayerName(playerid), quantia, PlayerName(id));
            SendClientMessageToAll(0xE60000FF, mensagem);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu R$%d para o player %s", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),quantia,PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            GivePlayerMoneyR(id, quantia);
            SalvarConta(id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/anunciar",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
            	idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
            	result[idx - offset] = cmdtext[idx];
            	idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /anunciar [mensagem]");
            	return 1;
            }
            new formatar[300];
            SendClientMessageToAll(0xFF0000FF, "{FFFFFF}------------------{FF0000}[HOT-PURSUIT AVISO]{FFFFFF}------------------");
            format(formatar, sizeof(formatar), "[%s]:{FFFFFF} %s.", PlayerName(playerid), result);
            SendClientMessageToAll(0xFF0000FF, formatar);
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s anunciou [%s].", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),result);
            CriarLogAdministradorCMD(logstring);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setsocio",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],nivel;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setsocio [id] [nivel]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setsocio [id] [nivel]");
                SendClientMessage(playerid, BRANCO, "NIVEIS: 1 - Socio Bronze | 2 - Socio Prata | 3 - Socio Ouro");
                return 1;
            }
            nivel = strval(tmp);

            if(nivel > 3 || nivel < 0){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O nivel que você colocou não existe."); }
            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[600],nivelstring[100];
            if(nivel == 0){ nivelstring = "Retirou Socio."; }
            if(nivel == 1){ nivelstring = "Socio Bronze"; }
            if(nivel == 2){ nivelstring = "Socio Prata"; }
            if(nivel == 3){ nivelstring = "Socio Ouro"; }
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu Socio nivel [%s] para o player %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),nivelstring,PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            new mensagem[500];
            if(nivel == 0){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s retirou o Socio de %s.", PlayerName(playerid),PlayerName(id)); }
            if(nivel == 1){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s deu Socio Bronze para %s.", PlayerName(playerid),PlayerName(id)); PlayerInfo[id][Dinheiro] += 20000; PlayerInfo[id][CupomCarro] += 1; PlayerInfo[id][Level] += 10; }
            if(nivel == 2){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s deu Socio Prata para %s.", PlayerName(playerid),PlayerName(id)); PlayerInfo[id][Dinheiro] += 40000; PlayerInfo[id][CupomCarro] += 2; PlayerInfo[id][Level] += 20; }
            if(nivel == 3){ format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s deu Socio Ouro para %s.", PlayerName(playerid),PlayerName(id)); PlayerInfo[id][Dinheiro] += 60000; PlayerInfo[id][CupomCarro] += 3; PlayerInfo[id][Level] += 30; }
            SendClientMessageToAll(0xE60000FF, mensagem);
            PlayerInfo[id][Socio] = nivel;
            SalvarConta(id);
            if(PlayerInfo[id][Socio] == 1){ SetPlayerColor(id, 0xB8860BAA); }
            if(PlayerInfo[id][Socio] == 2){ SetPlayerColor(id, 0x808080AA); }
            if(PlayerInfo[id][Socio] == 3){ SetPlayerColor(id, 0xFFD700AA); }
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setcupomcarro",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],quantia;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setcupomcarro [id] [quantia]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setcupomcarro [id] [quantia]");
                return 1;
            }
            quantia = strval(tmp);

            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu %s cupons de carro para o player %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),quantia,PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s deu %s cupons de carro para %s.", PlayerName(playerid),quantia,PlayerName(id));
            SendClientMessageToAll(0xE60000FF, mensagem);
            PlayerInfo[id][CupomCarro] += quantia;
            SalvarConta(id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/setnivel",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300],quantia;

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setnivel [id] [nivel]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /setnivel [id] [nivel]");
                return 1;
            }
            quantia = strval(tmp);

            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s deu %s niveis para o player %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),quantia,PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            new mensagem[300];
            format(mensagem, sizeof(mensagem), "[Admin-Cmd]{FFFFFF} %s deu %s niveis para %s.", PlayerName(playerid),quantia,PlayerName(id));
            SendClientMessageToAll(0xE60000FF, mensagem);
            PlayerInfo[id][Level] += quantia;
            SalvarConta(id);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/pararspectarplayer",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            TogglePlayerSpectating(playerid, 0);
            ResetarVariaveis(playerid);
            CarregarConta(playerid);
            SairOMenu(playerid);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/spectarplayer",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];

            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /spectarplayer [id]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);

            if(playerid == id){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não pode se spectar."); }
            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new logstring[300];
            format(logstring, sizeof(logstring), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: O administrador %s esta spectrando %s.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),PlayerName(id));
            CriarLogAdministradorCMD(logstring);
            TogglePlayerSpectating(playerid, 1);
            PlayerSpectatePlayer(playerid, id, SPECTATE_MODE_NORMAL);
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/vercomandosadmin",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new dialog[1000];
    		new juntar[1000];
          	format(juntar, sizeof(juntar), " {FFFFFF}                           Administrador                        \n");
    		strcat(dialog,juntar);
    		format(juntar, sizeof(juntar), " {FFFFFF}• » /banirpermanentemente [id] [motivo] (bani um jogador permanentemente) « •\n");
    		strcat(dialog,juntar);
      		format(juntar, sizeof(juntar), " {FFFFFF}• » /kick [id] [motivo] (kika um jogador) « •\n");
    		strcat(dialog,juntar);
      		format(juntar, sizeof(juntar), " {FFFFFF}• » /agendarbanimento [nome] [motivo] (agenda um banimento de um jogador offline) « •\n");
    		strcat(dialog,juntar);
        	format(juntar, sizeof(juntar), " {FFFFFF}• » /dardinheiro [id] [motivo] (da dinheiro para um jogador) « •\n");
    		strcat(dialog,juntar);
        	format(juntar, sizeof(juntar), " {FFFFFF}• » /anunciar [mensagem] (anuncia uma mensagem para todos do servidor)  « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}                      Dono/Programador                            \n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /setadministrador [id] [nivel] (1 - Administrador | 2 - Dono | 3 - Programador) « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /setsocio [id] [nivel] (0 - Retira socio | 1 - Socio Bronze | 2 - Socio Prata | 3 - Socio Ouro) « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /agendarsocio [nome] [nivel] (0 - Retira socio | 1 - Socio Bronze | 2 - Socio Prata | 3 - Socio Ouro) « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /settag [id] [nivel] (0 - Retira tag | 1 - Beta-Tester) « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /setnivel [id] [nivel] « •\n");
    		strcat(dialog,juntar);
            format(juntar, sizeof(juntar), " {FFFFFF}• » /setcupomcarro [id] [quantia] « •\n");
    		strcat(dialog,juntar);
            ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Comandos Administrador - {FF0000}[HOT-PURSUIT]", dialog, "Ok", "");
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/verconta",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /verconta [id]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);

            if(!IsPlayerConnected(id)){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: O player que você colocou está offline."); }
            new mensagemstats[300],mensagemstats2[300],mensagemstats3[300],tag[300],administrador[300],socio[300];
            if(PlayerInfo[id][Tag] == 0){ tag = "Nenhuma"; }
            if(PlayerInfo[id][Tag] == 1){ tag = "Beta-Tester"; }
            if(PlayerInfo[id][Administrador] == 0){ administrador = "Sem Cargo"; }
            if(PlayerInfo[id][Administrador] == 1){ administrador = "Administrador"; }
            if(PlayerInfo[id][Administrador] == 2){ administrador = "Dono"; }
            if(PlayerInfo[id][Administrador] == 3){ administrador = "Programador"; }
            if(PlayerInfo[id][Socio] == 0){ socio = "Normal"; }
            if(PlayerInfo[id][Socio] == 1){ socio = "Socio Bronze"; }
            if(PlayerInfo[id][Socio] == 2){ socio = "Socio Prata"; }
            if(PlayerInfo[id][Socio] == 3){ socio = "Socio Ouro"; }
            SendClientMessage(playerid, BRANCO, "{800000}------------------------------{FFFFFF}[INFO CONTA]{800000}------------------------------");
            format(mensagemstats, sizeof(mensagemstats), "                        Dinheiro: {FF0000}[%d]{FFFFFF} | Cupons Carro: {FF0000}[%d]{FFFFFF} ", PlayerInfo[id][Dinheiro], PlayerInfo[id][CupomCarro]);
            SendClientMessage(playerid, BRANCO, mensagemstats);
            format(mensagemstats2, sizeof(mensagemstats2), "Tag: {FF0000}[%s]{FFFFFF} | Administrador: {FF0000}[%s]{FFFFFF} | Conta: {FF0000}[%s]{FFFFFF} ", tag, administrador, socio);
            SendClientMessage(playerid, BRANCO, mensagemstats2);
            format(mensagemstats3, sizeof(mensagemstats3), "                      Dono da conta: {FF0000}[%s]{FFFFFF}.", PlayerName(id));
            SendClientMessage(playerid, BRANCO, mensagemstats3);
            SendClientMessage(playerid, BRANCO, "{800000}----------------------------------------------------------------------------------");
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/minhaconta",true)==0)
    {
        new mensagemstats[300],mensagemstats2[300],tag[300],administrador[300],socio[300];
        if(PlayerInfo[playerid][Tag] == 0){ tag = "Nenhuma"; }
        if(PlayerInfo[playerid][Tag] == 1){ tag = "Beta-Tester"; }
        if(PlayerInfo[playerid][Administrador] == 0){ administrador = "Sem Cargo"; }
        if(PlayerInfo[playerid][Administrador] == 1){ administrador = "Administrador"; }
        if(PlayerInfo[playerid][Administrador] == 2){ administrador = "Dono"; }
        if(PlayerInfo[playerid][Administrador] == 3){ administrador = "Programador"; }
        if(PlayerInfo[playerid][Socio] == 0){ socio = "Normal"; }
        if(PlayerInfo[playerid][Socio] == 1){ socio = "Socio Bronze"; }
        if(PlayerInfo[playerid][Socio] == 2){ socio = "Socio Prata"; }
        if(PlayerInfo[playerid][Socio] == 3){ socio = "Socio Ouro"; }
        SendClientMessage(playerid, BRANCO, "{800000}------------------------------{FFFFFF}[INFO CONTA]{800000}------------------------------");
        format(mensagemstats, sizeof(mensagemstats), "                        Dinheiro: {FF0000}[%d]{FFFFFF} | Cupons Carro: {FF0000}[%d]{FFFFFF} ", PlayerInfo[playerid][Dinheiro], PlayerInfo[playerid][CupomCarro]);
        SendClientMessage(playerid, BRANCO, mensagemstats);
        format(mensagemstats2, sizeof(mensagemstats2), "Tag: {FF0000}[%s]{FFFFFF} | Administrador: {FF0000}[%s]{FFFFFF} | Conta: {FF0000}[%s]{FFFFFF} ", tag, administrador, socio);
        SendClientMessage(playerid, BRANCO, mensagemstats2);
        SendClientMessage(playerid, BRANCO, "{800000}----------------------------------------------------------------------------------");
        return 1;
    }
    if(strcmp(cmd,"/vercarros",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new tmp[300];
            tmp = strtok(cmdtext, idx);
            if(!strlen(tmp))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /vercarros [id]");
                return 1;
            }
            new id;
            id = ReturnUser(tmp);

            new mensagemstats[300],mensagemstats2[300],mensagemstats3[300];
            SendClientMessage(playerid, BRANCO, "{800000}------------------------------{FFFFFF}[INFO CARROS]{800000}------------------------------");
            format(mensagemstats, sizeof(mensagemstats), "           Slot 1: %s | Slot 2: %s | Slot 3: %s | Slot 4: %s | Slot 5: %s                 ", GetVehicleName(PlayerInfo[id][SlotCarro]), GetVehicleName(PlayerInfo[id][SlotCarro2]), GetVehicleName(PlayerInfo[id][SlotCarro3]), GetVehicleName(PlayerInfo[id][SlotCarro4]), GetVehicleName(PlayerInfo[id][SlotCarro5]));
            SendClientMessage(playerid, BRANCO, mensagemstats);
            format(mensagemstats2, sizeof(mensagemstats2), "Cor Carro Slot 1: %d | Cor Carro Slot 2: %d | Cor Carro Slot 3: %d | Cor Carro Slot 4: %d | Cor Carro Slot 5: %d", PlayerInfo[id][CorSlotCarro], PlayerInfo[id][CorSlotCarro2], PlayerInfo[id][CorSlotCarro3], PlayerInfo[id][CorSlotCarro4], PlayerInfo[id][CorSlotCarro5]);
            SendClientMessage(playerid, BRANCO, mensagemstats2);
            format(mensagemstats3, sizeof(mensagemstats3), "                     Dono da conta: {FF0000}[%s]{FFFFFF}.                   ", PlayerName(id));
            SendClientMessage(playerid, BRANCO, mensagemstats3);
            SendClientMessage(playerid, BRANCO, "{800000}----------------------------------------------------------------------------------");
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    if(strcmp(cmd,"/meuscarros",true)==0)
    {
        new mensagemstats[300],mensagemstats2[300];
        SendClientMessage(playerid, BRANCO, "{800000}------------------------------{FFFFFF}[INFO CARROS]{800000}------------------------------");
        format(mensagemstats, sizeof(mensagemstats), "           Slot 1: %s | Slot 2: %s | Slot 3: %s | Slot 4: %s | Slot 5: %s                 ", GetVehicleName(PlayerInfo[playerid][SlotCarro]), GetVehicleName(PlayerInfo[playerid][SlotCarro2]), GetVehicleName(PlayerInfo[playerid][SlotCarro3]), GetVehicleName(PlayerInfo[playerid][SlotCarro4]), GetVehicleName(PlayerInfo[playerid][SlotCarro5]));
        SendClientMessage(playerid, BRANCO, mensagemstats);
        format(mensagemstats2, sizeof(mensagemstats2), "Cor Carro Slot 1: %d | Cor Carro Slot 2: %d | Cor Carro Slot 3: %d | Cor Carro Slot 4: %d | Cor Carro Slot 5: %d", PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro2], PlayerInfo[playerid][CorSlotCarro3], PlayerInfo[playerid][CorSlotCarro4], PlayerInfo[playerid][CorSlotCarro5]);
        SendClientMessage(playerid, BRANCO, mensagemstats2);
        SendClientMessage(playerid, BRANCO, "{800000}----------------------------------------------------------------------------------");
        return 1;
    }
    if(strcmp(cmd,"/escolhertrapacias",true)==0)
    {
        if(PlayerInfo[playerid][PoderUsando] == 0){ ShowPlayerDialog(playerid, d_trapacias, DIALOG_STYLE_TABLIST_HEADERS, "Trapacias - {FF0000}[HOTPURSUIT]", "Trapaça\tEstado\n - Escudo de agua\tReservado\n - Pregos danificadores\tReservado\n - Missel\tReservado", "Selecionar", "Cancelar"); }
        if(PlayerInfo[playerid][PoderUsando] == 1){ ShowPlayerDialog(playerid, d_trapacias, DIALOG_STYLE_TABLIST_HEADERS, "Trapacias - {FF0000}[HOTPURSUIT]", "Trapaça\tEstado\n{00FFFF} - Escudo de agua\t{00FFFF}Usando{FFFFFF}\n - Pregos danificadores\tReservado\n - Missel\tReservado", "Selecionar", "Cancelar"); }
        if(PlayerInfo[playerid][PoderUsando] == 2){ ShowPlayerDialog(playerid, d_trapacias, DIALOG_STYLE_TABLIST_HEADERS, "Trapacias - {FF0000}[HOTPURSUIT]", "Trapaça\tEstado\n - Escudo de agua\tReservado\n{00FFFF} - Pregos danificadores\t{00FFFF}Usando\n - Missel\tReservado", "Selecionar", "Cancelar"); }
        if(PlayerInfo[playerid][PoderUsando] == 3){ ShowPlayerDialog(playerid, d_trapacias, DIALOG_STYLE_TABLIST_HEADERS, "Trapacias - {FF0000}[HOTPURSUIT]", "Trapaça\tEstado\n - Escudo de agua\tReservado\n - Pregos danificadores\tReservado\n{00FFFF} - Missel\t{00FFFF}Usando", "Selecionar", "Cancelar"); }
        return 1;
    }
    if(strcmp(cmd,"/guardararma",true)==0)
    {
        if(PlayerInfo[playerid][EstaEmGuerra] == true)
		{
            if(GetPlayerWeapon(playerid) == 31)
            {
                PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/s/zmr0c9ff17byih5/bolsa.mp3");
                PlayerInfo[playerid][CarregadaSlot1Inventario] = 2;
                SetPlayerAttachedObject(playerid, 0, 356, 1, 0.147813, 0.192977, -0.147979, 165.193389, 148.239089, 6.275139, 1.000000, 1.000000, 1.000000 );
                ResetPlayerWeapons(playerid);
                return 1;
            }
            else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem nenhuma arma em mãos.");
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não pode usar este comando agora.");
    }
    if(strcmp(cmd,"/equipamentos",true)==0)
    {
        PlayerInfo[playerid][ArmaSlot1Inventario] = 31;
        PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] = 30;
        PlayerInfo[playerid][CarregadaSlot1Inventario] = 2;
        PlayerInfo[playerid][CartuchoSlot1Inventario] = 1;
        PlayerInfo[playerid][EstaEmGuerra] = true;
        SetPlayerAttachedObject( playerid, 8, 18936, 2, 0.096949, 0.045831, 0.004879, 357.288452, 1.314143, 15.649106, 1.000000, 1.000000, 1.000000 ); // Helmet1 - capacete
		SetPlayerAttachedObject( playerid, 9, 19142, 1, 0.085413, 0.040295, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000 ); // Armour1 - Colete
		SendClientMessage(playerid, BRANCO, "[INFO]: Você pegou equipamentos balisticos + 30 balas de fuzil + 1 cartucho.");
		return 1;
    }
    if(strcmp(cmd,"/pegararma",true)==0)
    {
        if(PlayerInfo[playerid][EstaEmGuerra] == true)
		{
            if(GetPlayerWeapon(playerid) == 0)
            {
                PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/s/zmr0c9ff17byih5/bolsa.mp3");
                if(PlayerInfo[playerid][CarregadaSlot1Inventario] == 1){
                
                    PlayerInfo[playerid][CarregadaSlot1Inventario] = 2;
                    RemovePlayerAttachedObject(playerid, 0);
                    SetPlayerAttachedObject(playerid, 0, 356, 1, 0.147813, 0.192977, -0.147979, 165.193389, 148.239089, 6.275139, 1.000000, 1.000000, 1.000000 );
				}
  				if(PlayerInfo[playerid][CarregadaSlot1Inventario] == 2){

                    PlayerInfo[playerid][CarregadaSlot1Inventario] = 1;
                    RemovePlayerAttachedObject(playerid, 0);
                    if(PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] == 0)
                    {
                        PlayerInfo[playerid][CarregadaSlot1Inventario] = 1;
                        PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] = 1;
                        SetPlayerAttachedObject(playerid, 0, 356, 1, 0.147813, 0.192977, -0.147979, 165.193389, 148.239089, 6.275139, 1.000000, 1.000000, 1.000000 );
                        return 1;
                    }
                    PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] = 2;
                	GivePlayerWeapon(playerid, PlayerInfo[playerid][ArmaSlot1Inventario], PlayerInfo[playerid][MunicaoUsandoSlot1Inventario]);
			        return 1;
				}
				return 1;
			}
			return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você já esta com uma arma em mãos.");
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não pode usar este comando agora.");
    }
    if(strcmp(cmd,"/carregar",true)==0)
    {
        if(PlayerInfo[playerid][EstaEmGuerra] == true)
		{
		    if(PlayerInfo[playerid][CarregadaSlot1Inventario] == 1)
		    {
		        if(PlayerInfo[playerid][ArmaSlot1Inventario] == 31)
		        {
		            if(PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] > 0 && PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] == 1)
		            {
		                PlayAudioStreamForPlayer(playerid, "https://dl.dropboxusercontent.com/s/s3s9npcdmlm0hy2/carregando.mp3");
						ApplyAnimation(playerid, "BUDDY", "buddy_crouchreload", 4.1, 0, 0, 0, 0, 0);
						ApplyAnimation(playerid, "BUDDY", "buddy_crouchreload", 4.1, 0, 0, 0, 0, 0);
		                RemovePlayerAttachedObject(playerid, 0);
		                PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] = 2;
		    			PlayerInfo[playerid][CarregadaSlot1Inventario] = 1;
         				SendClientMessage(playerid, BRANCO, "[INFO]: Arma carregada.");
                   		GivePlayerWeapon(playerid, 31, PlayerInfo[playerid][MunicaoUsandoSlot1Inventario]);
						return 1;
		            }
		            else if(PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] == 0 && PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] == 1)
		            {
		                if(PlayerInfo[playerid][CartuchoSlot1Inventario] > 0)
		                {
		                    ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0);
		                    ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.1, 0, 0, 0, 0, 0);
		                    PlayerInfo[playerid][CartuchoSlot1Inventario] -= 1;
		                    PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] += 30;
							SendClientMessage(playerid, BRANCO, "[INFO]: Cartucho embocado.");
		                    return 1;
		                }
		                else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem cartuchos nem balas sobrando.");
		            }
		            else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Sua arma já esta carregada.");
		        }
		        return 1;
		    }
		    else if(PlayerInfo[playerid][CarregadaSlot1Inventario] == 2)
		    {
		        PlayerInfo[playerid][CarregadaSlot1Inventario] = 1;
      			SetPlayerAttachedObject(playerid, 0, 356, 1, 0.147813, 0.192977, -0.147979, 165.193389, 148.239089, 6.275139, 1.000000, 1.000000, 1.000000 );
                ResetPlayerWeapons(playerid);
                return 1;
		    }
		    return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não esta com nenhuma arma em mãos.");
  		}
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não pode usar este comando agora.");
    }
    if(strcmp(cmd,"/ajuda",true)==0)
    {
    	new dialog[1000];
		new juntar[1000];
		format(juntar, sizeof(juntar), " {FFFFFF}• » /menu (menu de acessibilidade do servidor.) « •\n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {FFFFFF}• » /relatorio [mensagem] (manda um relatorio para a equipe de administração.) « •\n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {FFFFFF}• » /mp [id] [mensagem] (manda mensagem privada para algum player online) « •\n");
		strcat(dialog,juntar);
    	format(juntar, sizeof(juntar), " {FFFFFF}• » /admins (vê todos os admins onlines no servidor.) « •\n");
		strcat(dialog,juntar);
    	format(juntar, sizeof(juntar), " {FFFFFF}• » /minhaconta (vê as informações da sua conta)  « •\n");
		strcat(dialog,juntar);
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Ajuda - {FF0000}[HOT-PURSUIT]", dialog, "Ok", "");
        return 1;
    }
    if(strcmp(cmd,"/creditos",true)==0)
    {
    	new dialog[1000];
		new juntar[1000];
		format(juntar, sizeof(juntar), " {FFFFFF}          Creditos do servidor            \n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {FFFFFF}• » Desenvolvedor/Fundador: AlienDog « •\n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {FFFFFF}• » BetaTester/Ajudante: DiegoS « •\n");
		strcat(dialog,juntar);
    	format(juntar, sizeof(juntar), " {FFFFFF}• » e a você por estar jogando em nosso servidor. « •\n");
		strcat(dialog,juntar);
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Creditos - {FF0000}[HOT-PURSUIT]", dialog, "Ok", "");
        return 1;
    }
    if(strcmp(cmd,"/socios",true)==0)
    {
        new dialog[1000];
		new juntar[1000];
  		format(juntar, sizeof(juntar), "                                                       Planos de socios do servidor:                                                       \n\n");
		strcat(dialog,juntar);
		format(juntar, sizeof(juntar), " {B8860B}Socio Bronze{FFFFFF} [R$20000 + 1 cupom carro gratis + 10 level + up em 50 minutos(normal 60 minutos) + nametag + nome personalizado]\n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {808080}Socio Prata{FFFFFF} [R$20000 + 1 cupom carro gratis + 20 level + up em 40 minutos(normal 60 minutos) + nametag + nome personalizado]\n");
		strcat(dialog,juntar);
  		format(juntar, sizeof(juntar), " {FFD700}Socio Ouro{FFFFFF} [R$20000 + 1 cupom carro gratis + 30 level + up em 30 minutos(normal 60 minutos) + nametag + nome personalizado]\n\n");
		strcat(dialog,juntar);
    	format(juntar, sizeof(juntar), " {FFFFFF}                                               Preços dos socios do servidor:                                                       \n\n");
		strcat(dialog,juntar);
    	format(juntar, sizeof(juntar), " {FFFFFF} - Socio Bronze[3 reais]\n");
		strcat(dialog,juntar);
      	format(juntar, sizeof(juntar), " {FFFFFF} - Socio Prata[4 reais]\n");
		strcat(dialog,juntar);
      	format(juntar, sizeof(juntar), " {FFFFFF} - Socio Ouro[5 reais]\n\n");
		strcat(dialog,juntar);
        format(juntar, sizeof(juntar), " {FFFFFF}                    Para adquirir algum desses socios você pode falar com um administrador ou entrar em nosso site.                    ");
		strcat(dialog,juntar);
        ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Preços/Beneficios socio - {FF0000}[HOT-PURSUIT]", dialog, "Ok", "");
        return 1;
    }
    if(strcmp(cmd,"/admins",true)==0)
    {
        SendClientMessage(playerid, BRANCO, "{800000}--------------------[{FFFFFF}ADMINISTRADORES ONLINE{800000}]-------------------");
		new count=0;
        foreach(Player, i)
        {
			if(IsPlayerConnected(i))
            {
				if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                {
					new str[256],cargo[300];
                    if(PlayerInfo[i][Administrador] == 1){ cargo = "Administrador"; }
                    if(PlayerInfo[i][Administrador] == 2){ cargo = "Dono"; }
                    if(PlayerInfo[i][Administrador] == 3){ cargo = "Programador"; }
					format(str, 256, "%s{FFFFFF}: {FF0000}%s{FFFFFF}.", cargo, PlayerName(i));
					SendClientMessage(playerid, 0xFF0000AA, str);
					count++;
				}
			}
		}
		if(count == 0)
        {
            SendClientMessage(playerid, BRANCO, "         Não há nenhum administrador online no momento.");
			SendClientMessage(playerid, ERROR, "{800000}----------------------------------------------------------------");
		}
        return 1;
    }
    if(strcmp(cmd,"/mensagemprivada",true)==0 || strcmp(cmd,"/mp",true)==0)
    {
        new tmp[300];

        tmp = strtok(cmdtext, idx);
        if(!strlen(tmp))
        {
            return SendClientMessage(playerid, ERROR, "ERROR: /mensagemprivada [id] [mensagem]");
        }
        new id;
        id = ReturnUser(tmp);
        id = strval(tmp);
        new length = strlen(cmdtext);
        while ((idx < length) && (cmdtext[idx] <= ' '))
        {
            idx++;
        }
        new offset = idx;
        new result[64];
        while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
        {
            result[idx - offset] = cmdtext[idx];
            idx++;
        }
        result[idx - offset] = EOS;
        if(!strlen(result))
        {
            SendClientMessage(playerid, ERROR, "ERROR: /mensagemprivada [id] [mensagem]");
            return 1;
        }

        new pm[400],preview[400];
        format(pm, sizeof(pm), "[MENSAGEM PRIVADA] Recebida de %s: %s", PlayerName(playerid), result);
        SendClientMessage(id, 0xFFFF00AA, pm);
        format(preview, sizeof(preview), "[MENSAGEM PRIVADA] Enviada para %s: %s", PlayerName(id), result);
        SendClientMessage(playerid, 0xFFFF00AA, preview);
        return 1;
    }
    if(strcmp(cmd,"/relatorio",true)==0)
    {
        new length = strlen(cmdtext);
        while ((idx < length) && (cmdtext[idx] <= ' '))
        {
            idx++;
        }
        new offset = idx;
        new result[64];
        while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
        {
            result[idx - offset] = cmdtext[idx];
            idx++;
        }
        result[idx - offset] = EOS;
        if(!strlen(result))
        {
            SendClientMessage(playerid, ERROR, "ERROR: /relatorio [mensagem]");
            return 1;
        }

        SendClientMessage(playerid, 0xFFFF00AA, "Relatorio enviado com sucessos aos administradores online.");
        foreach(Player, i)
        {
            if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
            {
                new relatorio[400];
                format(relatorio, sizeof(relatorio), "Relatorio de %s(%d): %s", PlayerName(playerid), playerid, result);
                SendClientMessage(i, 0xFFFF00AA, relatorio);
            }
        }
        return 1;
    }
    if(strcmp(cmd,"/chatadm",true)==0)
    {
        if(PlayerInfo[playerid][Administrador] == 1 || PlayerInfo[playerid][Administrador] == 2 || PlayerInfo[playerid][Administrador] == 3)
        {
            new length = strlen(cmdtext);
            while ((idx < length) && (cmdtext[idx] <= ' '))
            {
                idx++;
            }
            new offset = idx;
            new result[64];
            while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
            {
                result[idx - offset] = cmdtext[idx];
                idx++;
            }
            result[idx - offset] = EOS;
            if(!strlen(result))
            {
                SendClientMessage(playerid, ERROR, "ERROR: /chatadm [mensagem]");
                return 1;
            }

            foreach(Player, i)
            {
                if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                {
                    new mensagem[400];
                    format(mensagem, sizeof(mensagem), "[CHAT ADM] %s(%d): %s", PlayerName(playerid), playerid, result);
                    SendClientMessage(i, 0xFF3030AA, mensagem);
                }
            }
            return 1;
        }
        else return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem permissão para usar este comando.");
    }
    return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Comando inexistente ! use /ajuda ou chame um admin pelo /relatorio.");
}

public OnPlayerDeath(playerid, killerid, reason)
{
    DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
    DestroyVehicle(PlayerInfo[playerid][CorridaCar]);
    if(PlayerInfo[playerid][Sala] == 2) { return 1; }
    if(PlayerInfo[playerid][Sala] == 1 && SalaInfo[0][s_comecou] == true && PlayerInfo[playerid][Policial] == true)
    {
        PlayerInfo[playerid][EntrandoComecado] = true;
        return 1;
    }
    if(PlayerInfo[playerid][Sala] == 1 && SalaInfo[0][s_comecou] == true)
    {
        if(PlayerInfo[playerid][Bandido] == true)
        {
            PlayerInfo[playerid][MorreuBandido] = true;
        }
        return 1;
    }
    if(PlayerInfo[playerid][Sala] == 2 && SalaInfo[1][s_comecou] == true)
    {
        if(PlayerInfo[playerid][Bandido] == true)
        {
            SalaInfo[1][s_bandidoganhou] = false;
        }
        ResetarVariaveis(playerid);
        CarregarConta(playerid);
        return 1;
    }
    ResetarVariaveis(playerid);
    CarregarConta(playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(RELEASED(4))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(PlayerInfo[playerid][NitroVeiculo] == true)
            {
                KillTimer(PlayerInfo[playerid][NitroT]);
                KillTimer(PlayerInfo[playerid][RecuperarNitroT]);
                RemoveVehicleComponent(GetPlayerVehicleID(playerid),1010);
                PlayerInfo[playerid][RecuperarNitroT] = SetTimerEx("RecuperarNitro",3000,true,"i",playerid);
                PlayerInfo[playerid][NitroPermissao] = false;
                PlayerInfo[playerid][NitroT2] = SetTimerEx("PoderUsarDeNovo",3000,true,"i",playerid);
            }
        }
    }
    if(PRESSED(4))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(PlayerInfo[playerid][NitroVeiculo] == true && PlayerInfo[playerid][Nitro] > 1)
            {
                if(PlayerInfo[playerid][NitroPermissao] == true)
                {
                    KillTimer(PlayerInfo[playerid][RecuperarNitroT]);
                    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                    PlayerInfo[playerid][NitroT] = SetTimerEx("SetNitroTDP",3000,true,"i",playerid);
                    PlayerInfo[playerid][NitroT2] = SetTimerEx("PoderUsarDeNovo",3000,true,"i",playerid);
                }
            }
        }
    }
    if(RELEASED(1))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(PlayerInfo[playerid][EstaEmCorrida] == false){ return 1; }
            if(PlayerInfo[playerid][PoderUsando] == 1 && PlayerInfo[playerid][Escudo] == true && PlayerInfo[playerid][Bandido] == true)
            {
                DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                KillTimer(PlayerInfo[playerid][EscudoTimer]);
                return 1;
            }
            if(PlayerInfo[playerid][PoderUsando] == 2 && PlayerInfo[playerid][Prego] == true && PlayerInfo[playerid][Policial] == true)
            {
                DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                KillTimer(PlayerInfo[playerid][PregoTimer]);
                return 1;
            }
            if(PlayerInfo[playerid][PoderUsando] == 3 && PlayerInfo[playerid][Missel] == true && PlayerInfo[playerid][Policial] == true)
            {
                if(PlayerInfo[playerid][MisselTempo] > 0)
                {
                    DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                    PlayerInfo[playerid][MisselTempo] = 16;
                    TextDrawTextSize(PoderTD[1][playerid], 489.010253, 0.000000);
                    TextDrawBoxColor(PoderTD[1][playerid], 16777215);
                    TextDrawSetString( PoderTD[2][playerid], "Missel");
                    PlayerInfo[playerid][TamanhoTDPoder] = 489.010253;
                    TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
                    TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
                    KillTimer(PlayerInfo[playerid][MisselTimer]);
                }
                return 1;
            }
        }
    }
    if(PRESSED(1))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(PlayerInfo[playerid][EstaEmCorrida] == false){ return 1; }
            if(PlayerInfo[playerid][PoderUsando] == 1 && PlayerInfo[playerid][Escudo] == true && PlayerInfo[playerid][Bandido] == true)
            {
                if(PlayerInfo[playerid][EscudoTempo] > 0)
                {
                    DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                    PlayerInfo[playerid][AttachmentObject] = CreateObject(19321, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                    SetObjectMaterial(PlayerInfo[playerid][AttachmentObject], 0, 3947, "rczero_track", "waterclear256", 0xFFFFFF44);
                    SetObjectMaterial(PlayerInfo[playerid][AttachmentObject], 1, 3947, "rczero_track", "waterclear256", 0xFFFFFF44);
                    PlayerInfo[playerid][AttachmentIdentificar] = AttachObjectToVehicle(PlayerInfo[playerid][AttachmentObject], GetPlayerVehicleID(playerid), -0.009999, -0.334999, 0.209999, 0.000000, 0.000000, -178.890090);
                    PlayerInfo[playerid][EscudoTimer] = SetTimerEx("SetEscudoTempo",3000,true,"i",playerid);
                    return 1;
                }
            }
            if(PlayerInfo[playerid][PoderUsando] == 2 && PlayerInfo[playerid][Prego] == true && PlayerInfo[playerid][Policial] == true)
            {
                if(PlayerInfo[playerid][PregoTempo] > 0)
                {
                    DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                    PlayerInfo[playerid][AttachmentObject] = CreateObject(2899, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                    PlayerInfo[playerid][AttachmentIdentificar] = AttachObjectToVehicle(PlayerInfo[playerid][AttachmentObject], GetPlayerVehicleID(playerid), -0.039999, 1.239999, -0.749999, -184.920120, -178.890090, 179.895095);
                    PlayerInfo[playerid][PregoTimer] = SetTimerEx("SetPregoTempo",3000,true,"i",playerid);
                    return 1;
                }
            }
            if(PlayerInfo[playerid][PoderUsando] == 3 && PlayerInfo[playerid][Missel] == true && PlayerInfo[playerid][Policial] == true)
            {
                if(PlayerInfo[playerid][MisselTempo] > 0)
                {
                    DestroyObject(PlayerInfo[playerid][AttachmentObject]);
                    PlayerInfo[playerid][AttachmentObject] = CreateObject(3790, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
                    PlayerInfo[playerid][AttachmentIdentificar] = AttachObjectToVehicle(PlayerInfo[playerid][AttachmentObject], GetPlayerVehicleID(playerid), 0.000000, 0.000000, 0.679999, 0.000000, 1.005000, -87.434959);
                    PlayerInfo[playerid][MisselTimer] = SetTimerEx("SetMisselTempo",800,true,"i",playerid);
                    return 1;
                }
            }
        }
    }
    if(PRESSED(64))
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(PlayerInfo[playerid][EstaEmCorrida] == false){ return 1; }
            if(PlayerInfo[playerid][Policial] == true && PlayerInfo[playerid][EstaEmCorrida] == true)
            {
                if(PlayerInfo[playerid][DistanciaMissel] == 2)
                {
                    PlayerInfo[playerid][DistanciaMissel] = 0;
                    TextDrawColor(MisselTD[4][playerid], 16777215); TextDrawColor(MisselTD[5][playerid], -1); TextDrawColor(MisselTD[6][playerid], -1);
                    TextDrawHideForPlayer(playerid, MisselTD[4][playerid]);
                    TextDrawShowForPlayer(playerid, MisselTD[4][playerid]);
                    TextDrawHideForPlayer(playerid, MisselTD[5][playerid]);
                    TextDrawShowForPlayer(playerid, MisselTD[5][playerid]);
                    TextDrawHideForPlayer(playerid, MisselTD[6][playerid]);
                    TextDrawShowForPlayer(playerid, MisselTD[6][playerid]);
                    return 1;
                }
                PlayerInfo[playerid][DistanciaMissel] += 1;
                if(PlayerInfo[playerid][DistanciaMissel] == 0){ TextDrawColor(MisselTD[4][playerid], 16777215); TextDrawColor(MisselTD[5][playerid], -1); TextDrawColor(MisselTD[6][playerid], -1); }
                if(PlayerInfo[playerid][DistanciaMissel] == 1){ TextDrawColor(MisselTD[4][playerid], -1); TextDrawColor(MisselTD[5][playerid], 16777215); TextDrawColor(MisselTD[6][playerid], -1); }
                if(PlayerInfo[playerid][DistanciaMissel] == 2){ TextDrawColor(MisselTD[4][playerid], -1); TextDrawColor(MisselTD[5][playerid], -1); TextDrawColor(MisselTD[6][playerid], 16777215); }
                TextDrawHideForPlayer(playerid, MisselTD[4][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[4][playerid]);
                TextDrawHideForPlayer(playerid, MisselTD[5][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[5][playerid]);
                TextDrawHideForPlayer(playerid, MisselTD[6][playerid]);
                TextDrawShowForPlayer(playerid, MisselTD[6][playerid]);
                return 1;
            }
        }
    }
    if(newkeys == 65536)
    {
        if(PlayerInfo[playerid][EstaEmCorrida] == false)
        {
            if(PlayerInfo[playerid][Logando] == false)
            {
                OnPlayerCommandText(playerid,"/menu");
                return 1;
            }
        }
    }
    if(RELEASED(KEY_FIRE))
    {
        if(PlayerInfo[playerid][CarregadaSlot1Inventario] == 1)
        {
	        new municao,arma;
	        GetPlayerWeaponData(playerid, 5, arma, municao);
	        PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] = municao;
	        if(PlayerInfo[playerid][MunicaoUsandoSlot1Inventario] == 0)
	        {
	            SetPlayerAttachedObject( playerid, 0, 356, 1, 0.147813, 0.192977, -0.147979, 165.193389, 148.239089, 6.275139, 1.000000, 1.000000, 1.000000 );
	            PlayerInfo[playerid][CarregadaSlot1Inventario] = 1;
	            PlayerInfo[playerid][ArmaDescarregadaSlot1Inventario] = 1;
	        }
	        return 1;
        }
    }
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == skinlist)
    {
	    if(response)
        {
            ClearChatbox(playerid, 100);
            SetPlayerSkin(playerid, modelid);
            PlayerInfo[playerid][EmTutorial] = false;
            PlayerInfo[playerid][TutorialConcluido] = true;
            TogglePlayerControllable(playerid, 0);
            TogglePlayerSpectating(playerid, 0);
            PlayerInfo[playerid][Skin] = modelid;
            PlayerInfo[playerid][Dinheiro] = 40000;
            PlayerInfo[playerid][Level] = 20;
            PlayerInfo[playerid][PrimeiraVez] = 1;
            SetTimerEx("SegundospUP",1000,true,"i",playerid);
            SendClientMessage(playerid, BRANCO, "--------------------------------------------------------[{FF0000}HOT-PURSUIT{FFFFFF}]-------------------------------------------------------");
            SendClientMessage(playerid, BRANCO, "       Seja bem vindo ao nosso servidor! não esqueça de ver as novidades do servidor.");
            SendClientMessage(playerid, BRANCO, "            Caso esteja interessado em ter coisas boas rapidamente veja o comando /socios.");
            SendClientMessage(playerid, BRANCO, "                                     Estamos na versão atual {FF0000}v1.0.000{FFFFFF}.");
            SendClientMessage(playerid, BRANCO, "---------------------------------------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, BRANCO, "[{FFFF00}Info]{FFFFFF}: Digite /menu e clique em concessionaria para comprar seu carro!");
            SalvarConta(playerid);
            new msg[500];
            format(msg, sizeof(msg), "[REGISTRO] %s entrou no servidor.", PlayerName(playerid));
            SendClientMessageToAll(0xFF0000AA, msg);
            return SpawnPlayer(playerid);
	    }
	    else
        {
            ClearChatbox(playerid, 100);
            SendClientMessage(playerid, ERROR, "Você não selecionou uma skin e foi escolhida automaticamente.");
            SetPlayerSkin(playerid, 23);
            PlayerInfo[playerid][Skin] = 23;
            PlayerInfo[playerid][EmTutorial] = false;
            PlayerInfo[playerid][TutorialConcluido] = true;
            TogglePlayerControllable(playerid, 0);
            TogglePlayerSpectating(playerid, 0);
            PlayerInfo[playerid][Dinheiro] = 40000;
            PlayerInfo[playerid][Level] = 20;
            PlayerInfo[playerid][PrimeiraVez] = 1;
            SetTimerEx("SegundospUP",1000,true,"i",playerid);
            SendClientMessage(playerid, BRANCO, "--------------------------------------------------------[{FF0000}HOT-PURSUIT{FFFFFF}]-------------------------------------------------------");
            SendClientMessage(playerid, BRANCO, "       Seja bem vindo ao nosso servidor! não esqueça de ver as novidades do servidor.");
            SendClientMessage(playerid, BRANCO, "            Caso esteja interessado em ter coisas boas rapidamente veja o comando /socios.");
            SendClientMessage(playerid, BRANCO, "                                     Estamos na versão atual {FF0000}v1.0.000{FFFFFF}.");
            SendClientMessage(playerid, BRANCO, "---------------------------------------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, BRANCO, "[{FFFF00}Info]{FFFFFF}: Digite /menu e clique em concessionaria para comprar seu carro!");
            SalvarConta(playerid);
            new msg[500];
            format(msg, sizeof(msg), "[REGISTRO] %s entrou no servidor.", PlayerName(playerid));
            SendClientMessageToAll(0xFF0000AA, msg);
            return SpawnPlayer(playerid);
        }
	}
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
    {
        if(PlayerInfo[playerid][Logando] == true)
        {
            return SelectTextDraw(playerid, -1);
        }
        if(PlayerInfo[playerid][GaragemeConce] == true)
        {
            return SelectTextDraw(playerid, -1);
        }
        if(PlayerInfo[playerid][MenuSala] == true)
        {
            return SelectTextDraw(playerid, -1);
        }
        if(PlayerInfo[playerid][EscolhendoBonus] == true)
        {
            return SelectTextDraw(playerid, -1);
        }
    }
    if(clickedid == BonusTD[4][playerid])
    {
        new bonus = random(10);
        switch(bonus)
        {
            case 0:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 1:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 2:
            {
                new nivel = random(maxnivelbonus+3);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 3:
            {
                new dinheiro = random(maxdinheirobonus+1000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 4:
            {
                new nivel = random(maxnivelbonus+2);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 5:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 6:
            {
                new nivel = random(maxnivelbonus);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 7:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 8:
            {
                new dinheiro = random(maxdinheirobonus+6000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 9:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
        }
        TextDrawHideForPlayer(playerid, BonusTD[0][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[1][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[2][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[3][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[4][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[5][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[6][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[7][playerid]);
        PlayerInfo[playerid][EscolhendoBonus] = false;
        CancelSelectTextDraw(playerid);
        SalvarConta(playerid);
    }
    if(clickedid == BonusTD[5][playerid])
    {
        new bonus = random(10);
        switch(bonus)
        {
            case 0:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 1:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 2:
            {
                new nivel = random(maxnivelbonus+3);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 3:
            {
                new dinheiro = random(maxdinheirobonus+1000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 4:
            {
                new nivel = random(maxnivelbonus+2);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 5:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 6:
            {
                new nivel = random(maxnivelbonus);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 7:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 8:
            {
                new dinheiro = random(maxdinheirobonus+6000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 9:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
        }
        TextDrawHideForPlayer(playerid, BonusTD[0][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[1][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[2][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[3][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[4][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[5][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[6][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[7][playerid]);
        PlayerInfo[playerid][EscolhendoBonus] = false;
        CancelSelectTextDraw(playerid);
        SalvarConta(playerid);
    }
    if(clickedid == BonusTD[6][playerid])
    {
        new bonus = random(10);
        switch(bonus)
        {
            case 0:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 1:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 2:
            {
                new nivel = random(maxnivelbonus+3);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 3:
            {
                new dinheiro = random(maxdinheirobonus+1000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 4:
            {
                new nivel = random(maxnivelbonus+2);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 5:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 6:
            {
                new nivel = random(maxnivelbonus);
                PlayerInfo[playerid][Level] += nivel;
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou nivel no bonus !");
            }
            case 7:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 8:
            {
                new dinheiro = random(maxdinheirobonus+6000);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
            case 9:
            {
                new dinheiro = random(maxdinheirobonus);
                GivePlayerMoneyR(playerid, dinheiro);
                SendClientMessage(playerid, 0xFFFF00AA, "[BONUS]{FFFFFF}: Você ganhou dinheiro no bonus !");
            }
        }
        TextDrawHideForPlayer(playerid, BonusTD[0][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[1][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[2][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[3][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[4][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[5][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[6][playerid]);
        TextDrawHideForPlayer(playerid, BonusTD[7][playerid]);
        PlayerInfo[playerid][EscolhendoBonus] = false;
        CancelSelectTextDraw(playerid);
        SalvarConta(playerid);
    }
    if(clickedid == NomeSalaTD[0])
    {
        if(SalaInfo[0][s_players] == 10){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
        if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
        ShowPlayerDialog(playerid, d_entrarsala, DIALOG_STYLE_MSGBOX, "Entrar Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você realmente deseja entrar nesta sala?\nClique em entrar para entrar na sala ou em deixar para não entrar na sala.\n\nMapa: San Fierro\nTamanho: Pequena", "Entrar", "Deixar");
    }
    if(clickedid == NomeSalaTD[1])
    {
        if(SalaInfo[1][s_players] == 20){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
        if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
        ShowPlayerDialog(playerid, d_entrarsala2, DIALOG_STYLE_MSGBOX, "Entrar Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você realmente deseja entrar nesta sala?\nClique em entrar para entrar na sala ou em deixar para não entrar na sala.\n\nMapa: MotoCross Estadio\nMax Players: 7\nMin Players: 2\nTipo: MotoCross", "Entrar", "Deixar");
    }
    if(clickedid == NomeSalaTD[3])
    {
        if(SalaInfo[1][s_players] == 20){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
        if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
        ShowPlayerDialog(playerid, d_entrarsala3, DIALOG_STYLE_MSGBOX, "Entrar Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você realmente deseja entrar nesta sala?\nClique em entrar para entrar na sala ou em deixar para não entrar na sala.\n\nMapa: Formula 1 Estadio\nMax Players: 8\nMin Player: 2\nTipo: Corrida", "Entrar", "Deixar");
    }
    if(clickedid == NomeSalaTD[2])
    {
        if(SalaInfo[1][s_players] == 20){ return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Esta sala já esta cheia."); }
        if(PlayerInfo[playerid][Sala] > 0){ return ShowPlayerDialog(playerid, d_deixarsala, DIALOG_STYLE_MSGBOX, "Opcção Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você já esta em uma sala!\nVocê deseja ficar ou deixar a sala atual?\n\nClique em ficar para ficar e deixar para sair da sala atual.", "Ficar", "Deixar"); }
        ShowPlayerDialog(playerid, d_entrarsala4, DIALOG_STYLE_MSGBOX, "Entrar Sala - {FF0000}[HOT-PURSUIT]", "{FFFFFF}Você realmente deseja entrar nesta sala?\nClique em entrar para entrar na sala ou em deixar para não entrar na sala.\n\nMapa: Afeganistão\nMax Players: 30\nMin Player: 10\nTipo: Guerra", "Entrar", "Deixar");
    }
    if(clickedid == Garagem[playerid][0])
    {
        if(PlayerInfo[playerid][PaginaGaragem] == 0)
        {
            return 1;
        }
        PlayerInfo[playerid][PaginaGaragem]-=1;
        new nome[200];
        if(PlayerInfo[playerid][PaginaGaragem] == 0)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 1)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro2]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro2], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro2], PlayerInfo[playerid][CorSlotCarro2], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 2)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro3]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro3], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro3], PlayerInfo[playerid][CorSlotCarro3], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 3)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro4]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro4], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro4], PlayerInfo[playerid][CorSlotCarro4], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 4)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro5]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro5], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro5], PlayerInfo[playerid][CorSlotCarro5], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        TextDrawSetString( Garagem[playerid][4], nome);
    }
    if(clickedid == Garagem[playerid][1])
    {
        if(PlayerInfo[playerid][PaginaGaragem] == 5)
        {
            return 1;
        }
        PlayerInfo[playerid][PaginaGaragem]+=1;
        new nome[200];
        if(PlayerInfo[playerid][PaginaGaragem] == 0)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 1)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro2]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro2], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro2], PlayerInfo[playerid][CorSlotCarro2], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 2)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro3]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro3], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro3], PlayerInfo[playerid][CorSlotCarro3], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 3)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro4]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro4], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro4], PlayerInfo[playerid][CorSlotCarro4], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 4)
        {
            format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro5]));
            DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
            PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro5], -1928.8998, 273.4213, 41.5428, 180.0000, PlayerInfo[playerid][CorSlotCarro5], PlayerInfo[playerid][CorSlotCarro5], 0);
            SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        }
        TextDrawSetString( Garagem[playerid][4], nome);
    }
    if(clickedid == Garagem[playerid][5])
    {
        if(PlayerInfo[playerid][PaginaGaragem] == 0){ if(PlayerInfo[playerid][SlotCarro] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 1){ if(PlayerInfo[playerid][SlotCarro2] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 2){ if(PlayerInfo[playerid][SlotCarro3] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 3){ if(PlayerInfo[playerid][SlotCarro4] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 4){ if(PlayerInfo[playerid][SlotCarro5] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        SendClientMessage(playerid, BRANCO, "[{0000CD}HotPursuit{FFFFFF}]: Agora você esta usando este carro para correr!");
        if(PlayerInfo[playerid][PrimeiraVez] == 2)
        {
            PlayerInfo[playerid][PrimeiraVez] = 4;
            SendClientMessage(playerid, BRANCO, "[{00FF00}SUCESSO{FFFFFF}]: Você seguiu todos os passos e agora já esta pronto para correr!");
        }
        if(PlayerInfo[playerid][PaginaGaragem] == 0){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro]; PlayerInfo[playerid][CorSlotCarroUsando] = PlayerInfo[playerid][CorSlotCarro];  }
        if(PlayerInfo[playerid][PaginaGaragem] == 1){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro2]; PlayerInfo[playerid][CorSlotCarroUsando] = PlayerInfo[playerid][CorSlotCarro2]; }
        if(PlayerInfo[playerid][PaginaGaragem] == 2){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro3]; PlayerInfo[playerid][CorSlotCarroUsando] = PlayerInfo[playerid][CorSlotCarro3]; }
        if(PlayerInfo[playerid][PaginaGaragem] == 3){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro4]; PlayerInfo[playerid][CorSlotCarroUsando] = PlayerInfo[playerid][CorSlotCarro4]; }
        if(PlayerInfo[playerid][PaginaGaragem] == 4){ PlayerInfo[playerid][SlotCarroUsando] = PlayerInfo[playerid][SlotCarro5]; PlayerInfo[playerid][CorSlotCarroUsando] = PlayerInfo[playerid][CorSlotCarro5]; }
        SalvarConta(playerid);
    }
    if(clickedid == Garagem[playerid][6])
    {
        if(PlayerInfo[playerid][PaginaGaragem] == 0){ if(PlayerInfo[playerid][SlotCarro] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 1){ if(PlayerInfo[playerid][SlotCarro2] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 2){ if(PlayerInfo[playerid][SlotCarro3] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 3){ if(PlayerInfo[playerid][SlotCarro4] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 4){ if(PlayerInfo[playerid][SlotCarro5] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        ShowPlayerDialog(playerid, d_deletarcarro, DIALOG_STYLE_MSGBOX, "{FFFFFF}Garagem - {FF0000}[AVISO]", "{FFFFFF} Você realmente deseja {FF0000}deletar{FFFFFF} este carro permanentemente?\n - Clique em sim para deletar ou não para não deletar.", "Sim", "Não");
    }
    if(clickedid == Garagem[playerid][7])
    {
        if(PlayerInfo[playerid][PaginaGaragem] == 0){ if(PlayerInfo[playerid][SlotCarro] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 1){ if(PlayerInfo[playerid][SlotCarro2] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 2){ if(PlayerInfo[playerid][SlotCarro3] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 3){ if(PlayerInfo[playerid][SlotCarro4] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        if(PlayerInfo[playerid][PaginaGaragem] == 4){ if(PlayerInfo[playerid][SlotCarro5] == 0){ return SendClientMessage(playerid, ERROR, "ERROR{FFFFFF}: Este slot não possui nenhum carro."); } }
        ShowPlayerDialog(playerid, d_vendercarro, DIALOG_STYLE_MSGBOX, "{FFFFFF}Garagem - {FFFF00}[AVISO]", "{FFFFFF} Você realmente deseja {00FF00}vender{FFFFFF} este carro?\n - Clique em sim para vender ou não para não vender.", "Sim", "Não");
    }
    if(clickedid == Cores[playerid][1])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 0;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][2])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 1;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][3])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 2;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][4])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 3;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][5])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 4;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][6])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 5;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][7])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 6;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][8])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 7;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][9])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true){

            PlayerInfo[playerid][CorComprar] = 8;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Cores[playerid][10])
    {
        if(PlayerInfo[playerid][ComprandoConce] == true)
        {
            PlayerInfo[playerid][CorComprar] = 9;
            ConcluirCompra(playerid);
        }
    }
    if(clickedid == Concessionaria[playerid][13])
    {
        new id = PlayerInfo[playerid][PaginaConce];
        if(GetPlayerScore(playerid) < ConcessionariaI[id][veiculolevel])
        {
            SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Você não tem level suficiente para comprar este veiculo!");
            return 1;
        }
        TextDrawShowForPlayer(playerid, Cores[playerid][0]);
        TextDrawShowForPlayer(playerid, Cores[playerid][1]);
        TextDrawShowForPlayer(playerid, Cores[playerid][2]);
        TextDrawShowForPlayer(playerid, Cores[playerid][3]);
        TextDrawShowForPlayer(playerid, Cores[playerid][4]);
        TextDrawShowForPlayer(playerid, Cores[playerid][5]);
        TextDrawShowForPlayer(playerid, Cores[playerid][6]);
        TextDrawShowForPlayer(playerid, Cores[playerid][7]);
        TextDrawShowForPlayer(playerid, Cores[playerid][8]);
        TextDrawShowForPlayer(playerid, Cores[playerid][9]);
        TextDrawShowForPlayer(playerid, Cores[playerid][10]);
        SelectTextDraw(playerid, 0xFFFFFF99);
        PlayerInfo[playerid][ComprandoConce] = true;
    }
    if(clickedid == Concessionaria[playerid][11])
    {
        new id = PlayerInfo[playerid][PaginaConce]-1;
        PlayerInfo[playerid][PaginaConce] = id;
        if(id < 0)
        {
            PlayerInfo[playerid][PaginaConce] = 0;
            return 1;
        }
        new nome[100],velocidade[100],preco[100],motor[100];
        format(nome, sizeof(nome), "NOME: %s", ConcessionariaI[id][veiculonome]);
        TextDrawSetString( Concessionaria[playerid][5], nome);
        format(preco, sizeof(preco), "PRECO: R$%d", ConcessionariaI[id][veiculopreco]);
        TextDrawSetString( Concessionaria[playerid][6], preco);
        format(velocidade, sizeof(velocidade), "VELOCIDADE MAX: %d KMH", ConcessionariaI[id][veiculovelocidade]);
        TextDrawSetString( Concessionaria[playerid][7], velocidade);
        format(motor, sizeof(motor), "MOTOR: %s", ConcessionariaI[id][veiculomotor]);
        TextDrawSetString( Concessionaria[playerid][9], motor);
        if(GetPlayerScore(playerid) > ConcessionariaI[id][veiculolevel])
        {
            TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~g~DESBLOQUEADO");
            TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: COM NIVEL");
        }
        if(GetPlayerScore(playerid) < ConcessionariaI[id][veiculolevel])
        {
            TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~r~BLOQUEADO");
            TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: SEM NIVEL");
        }
        DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
        PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(ConcessionariaI[id][veiculoid], -1970.7778, 284.3213, 35.6628, 90.0000, -1, -1, 0);
        SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        TextDrawSetPreviewModel(Concessionaria[playerid][14], ConcessionariaI[id][veiculoid]);
        TextDrawHideForPlayer(playerid, Concessionaria[playerid][14]);
        TextDrawShowForPlayer(playerid, Concessionaria[playerid][14]);
    }
    if(clickedid == Concessionaria[playerid][12])
    {
        new id = PlayerInfo[playerid][PaginaConce]+1;
        PlayerInfo[playerid][PaginaConce] = id;
        if(id > MAXCARROSCONCE)
        {
            PlayerInfo[playerid][PaginaConce] = MAXCARROSCONCE;
            return 1;
        }
        new nome[100],velocidade[100],preco[100],motor[100];
        format(nome, sizeof(nome), "NOME: %s", ConcessionariaI[id][veiculonome]);
        TextDrawSetString( Concessionaria[playerid][5], nome);
        format(preco, sizeof(preco), "PRECO: R$%d", ConcessionariaI[id][veiculopreco]);
        TextDrawSetString( Concessionaria[playerid][6], preco);
        format(velocidade, sizeof(velocidade), "VELOCIDADE MAX: %d KMH", ConcessionariaI[id][veiculovelocidade]);
        TextDrawSetString( Concessionaria[playerid][7], velocidade);
        format(motor, sizeof(motor), "MOTOR: %s", ConcessionariaI[id][veiculomotor]);
        TextDrawSetString( Concessionaria[playerid][9], motor);
        if(GetPlayerScore(playerid) > ConcessionariaI[id][veiculolevel])
        {
            TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~g~DESBLOQUEADO");
            TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: COM NIVEL");
        }
        if(GetPlayerScore(playerid) < ConcessionariaI[id][veiculolevel])
        {
            TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~r~BLOQUEADO");
            TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: SEM NIVEL");
        }
        DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
        PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(ConcessionariaI[id][veiculoid], -1970.7778, 284.3213, 35.6628, 90.0000, -1, -1, 0);
        SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
        TextDrawSetPreviewModel(Concessionaria[playerid][14], ConcessionariaI[id][veiculoid]);
        TextDrawHideForPlayer(playerid, Concessionaria[playerid][14]);
        TextDrawShowForPlayer(playerid, Concessionaria[playerid][14]);
    }
    if(clickedid == InicioSessaoTextDraw[playerid][11])
    {
        if(PlayerInfo[playerid][cSenha] == false)
        {
            return ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_MSGBOX, "Aviso de erro", "- Você não digitou uma senha!\n- Digite sua senha para iniciar uma sessão.", "Certo", "");
        }
        else if(PlayerInfo[playerid][cSenha] == true)
        {
            new arquivo[500],nome[MAX_PLAYER_NAME];
            GetPlayerName(playerid, nome, sizeof(nome));
            format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
            if(DOF2_FileExists(arquivo))
            {
                strmid(PlayerInfo[playerid][Senha], DOF2_GetString(arquivo,"Senha"),0, strlen(DOF2_GetString(arquivo,"Senha")), 255);
                if(!strcmp(PlayerInfo[playerid][Senha], PlayerInfo[playerid][Senhac],false))
                {
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][0]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][1]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][2]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][3]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][4]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][5]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][6]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][7]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][8]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][9]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][10]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][12]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][13]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][14]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][15]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][16]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][17]);
                    TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][11]);
                    ResetarVariaveis(playerid);
                    CancelSelectTextDraw(playerid);
                    CarregarConta(playerid);
                    PlayerInfo[playerid][Logando] = false;
                    new ip[100],arquivo2[500];
                    GetPlayerIp(playerid, ip, sizeof(ip));
                    format(arquivo2, sizeof(arquivo2), PASTAIP, ip);
                    if(!DOF2_FileExists(arquivo2))
                    {
                        DOF2_CreateFile(arquivo2);
                    }
                    new log[500];
                    getdate(ano,mes,dia);
                    gettime(horas,minutos,segundos);
                    format(log, sizeof(log), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: %s entrou(iniciou uma sessao/logou) no servidor.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid));
                    CriarLogLogin(log);
                    SetTimerEx("SegundospUP",1000,true,"i",playerid);
                    SendClientMessage(playerid, BRANCO, "--------------------------------------------------------[{FF0000}HOT-PURSUIT{FFFFFF}]-------------------------------------------------------");
                    SendClientMessage(playerid, BRANCO, "   Seja bem vindo de volta ao nosso servidor! não esqueça de olhar sempre as novidades do servidor.");
                    SendClientMessage(playerid, BRANCO, "            Caso esteja interessado em ter coisas boas rapidamente veja o comando /socios.");
                    SendClientMessage(playerid, BRANCO, "                                     Estamos na versão atual {FF0000}v1.0.000{FFFFFF}.");
                    SendClientMessage(playerid, BRANCO, "---------------------------------------------------------------------------------------------------------------------------------------");
                    if(PlayerInfo[playerid][TutorialConcluido] == false)
                    {
                        SendClientMessage(playerid, ERROR, "Você não completou o tutorial e agora tera que fazelo novamente!");
                        SetTimerEx("IrProTutorial", 2000, false, "i", playerid);
                        PlayerInfo[playerid][TimerTutorial] = SetTimerEx("AvancarTutorial", 5000+2000, false, "i", playerid);
                        foreach(Player, i)
                        {
                            if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                            {
                                new msg[500];
                                format(msg, sizeof(msg), "[Login-Warning]{FFFFFF} O Player %s logou no servidor com o tutorial não lido e esta re-lendo.", PlayerName(playerid));
                                SendClientMessage(i, 0xFF0000AA, msg);
                            }
                        }
                        return PlayerInfo[playerid][EmTutorial] = true;
                    }
                    TogglePlayerControllable(playerid, 0);
                    TogglePlayerSpectating(playerid, 0);
                    foreach(Player, i)
                    {
                        if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                        {
                            new msg[500];
                            format(msg, sizeof(msg), "[Login-Warning]{FFFFFF} O Player %s logou no servidor.", PlayerName(playerid));
                            SendClientMessage(i, 0xFF0000AA, msg);
                        }
                    }
                    new msg[500];
                    format(msg, sizeof(msg), "[LOGIN] %s entrou no servidor.", PlayerName(playerid));
                    SendClientMessageToAll(0xFF0000AA, msg);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][0]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][1]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][2]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][3]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][4]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][5]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][6]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][7]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][8]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][9]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][10]);
                    TextDrawDestroy(InicioSessaoTextDraw[playerid][11]);
                    return SpawnPlayer(playerid);
                }
                else
                {
                    new log[500],IP[100];
                    getdate(ano,mes,dia);
                    gettime(horas,minutos,segundos);
                    GetPlayerIp(playerid, IP, sizeof(IP));
                    format(log, sizeof(log), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: %s(IP:%s) errou sua senha na hora de iniciar sessão.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid),IP);
                    CriarLogSenha(log);
                    foreach(Player, i)
                    {
                        if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                        {
                            new msg[500];
                            format(msg, sizeof(msg), "[Login-Senha-Warning]{FFFFFF} O Player %s errou a senha na tentativa de iniciar uma sessão.", PlayerName(playerid));
                            SendClientMessage(i, 0xFF0000AA, msg);
                        }
                    }
                    return ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_MSGBOX, "Aviso de erro", "- Senha errada!\n-Digite sua senha novamente.", "Certo", "");
                }
            }
            else
            {
                new ip[100],arquivo3[500];
                GetPlayerIp(playerid, ip, sizeof(ip));
                format(arquivo3, sizeof(arquivo3), PASTAIP, ip);
                if(DOF2_FileExists(arquivo3))
                {
                    SetTimerEx("Kickar",1000,false,"i",playerid);
                    foreach(Player, i)
                    {
                        if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                        {
                            new msg[500];
                            format(msg, sizeof(msg), "[Register-Warning]{FFFFFF} O Player %s tentou se criar uma segunda conta no servidor.", PlayerName(playerid));
                            SendClientMessage(i, 0xFF0000AA, msg);
                        }
                    }
                    return SendClientMessage(playerid, ERROR, "[ERROR]{FFFFFF}: Já há uma conta registrada neste ip.");
                }
                else
                {
                    DOF2_CreateFile(arquivo3);
                }
                getdate(ano,mes,dia);
                DOF2_CreateFile(arquivo);
                DOF2_SetString(arquivo,"Senha",PlayerInfo[playerid][Senha]);
                DOF2_SetInt(arquivo,"UltimaVisitaDia",dia);
                DOF2_SetInt(arquivo,"UltimaVisitaMes",mes);
                DOF2_SetInt(arquivo,"UltimaVisitaAno",ano);
                DOF2_SaveFile();
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][0]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][1]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][2]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][3]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][4]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][5]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][6]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][7]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][8]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][9]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][10]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][12]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][13]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][14]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][15]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][16]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][17]);
                TextDrawHideForPlayer(playerid, InicioSessaoTextDraw[playerid][11]);
                PlayerInfo[playerid][Logando] = false;
                PlayerInfo[playerid][EmTutorial] = true;
                PlayerInfo[playerid][ParteDoTutorial] = 1;
                SetTimerEx("IrProTutorial", 2000, false, "i", playerid);
                SetTimerEx("SegundospUP",1000,true,"i",playerid);
                PlayerInfo[playerid][TimerTutorial] = SetTimerEx("AvancarTutorial", 5000+2000, false, "i", playerid);
                new log[500];
                getdate(ano,mes,dia);
                gettime(horas,minutos,segundos);
                format(log, sizeof(log), "Data:(%d/%d/%d) - Horario:[%d:%d:%d] Log: %s se registrou no servidor.", dia,mes,ano,horas,minutos,segundos,PlayerName(playerid));
                CriarLogRegistro(log);
                foreach(Player, i)
                {
                    if(PlayerInfo[i][Administrador] == 1 || PlayerInfo[i][Administrador] == 2 || PlayerInfo[i][Administrador] == 3)
                    {
                        new msg[500];
                        format(msg, sizeof(msg), "[Register-Warning]{FFFFFF} O Player %s se registrou no servidor.", PlayerName(playerid));
                        SendClientMessage(i, 0xFF0000AA, msg);
                    }
                }
                return ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_MSGBOX, "Aviso de sucesso", "- Você digitou sua senha e clicou em entrar e criou uma conta!", "Certo", "");
            }
        }
        return 1;
    }
    if(clickedid == InicioSessaoTextDraw[playerid][13])
    {
        return ShowPlayerDialog(playerid, d_senhasessao, DIALOG_STYLE_INPUT, "Digite a sua senha.", " - Coloque sua senha\n- Evite errar sua senha para não ser banido.", "Pronto.", "");
    }
    return 1;
}
forward IrProTutorial(playerid);
public IrProTutorial(playerid)
{
    PlayerInfo[playerid][PodePassarTutorial] = false;
    new aba[702];
    strcat(aba, "{FFFFFF}    Bom, o servidor é de {FF0000}Hot{0000CD}Pursuit{FFFFFF} como vocês podem ver no titulo do servidor, você\n");
    strcat(aba, "pode ganhar dinheiro/level fazendo perseguições e fugindo.\n\n");
    strcat(aba, "    Não terá sempre admins logados pois o servidor é automatico! ou seja você joga por conta da GameMode!\n");
    strcat(aba, "e claro os admins do servidor so podem usar comandos com um tipo de senha que é trocada sempre.\n\n");
    strcat(aba, "    Assim que você spawnar digite /menu e compre um carro na concessionaria! após feito isso vá na garagem(/menu) e selecione o carro\n");
    strcat(aba, "clicando no botão 'usar' e depois saia e comece a jogar em uma sala.\n\n");
    strcat(aba, "    Obs: Para sair de um local(não podera sair de uma perseguição) usando o comando /menu e clicando em sair.");
    ShowPlayerDialog(playerid, d_tutorial, DIALOG_STYLE_MSGBOX, " Informações sobre o servidor", aba, "Avançar", "");
    return 1;
}
public AvancarTutorial(playerid)
{
    KillTimer(PlayerInfo[playerid][TimerTutorial]);
    SendClientMessage(playerid, -1, "Você foi liberado para avançar o tutorial!");
    return PlayerInfo[playerid][PodePassarTutorial] = true;
}
SalvarConta(playerid);
SalvarConta(playerid)
{
    new arquivo[500],nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
    DOF2_SetString(arquivo,"Senha",PlayerInfo[playerid][Senha]);
    DOF2_SetInt(arquivo,"Skin", PlayerInfo[playerid][Skin]);
    DOF2_SetInt(arquivo,"Dinheiro", PlayerInfo[playerid][Dinheiro]);
    DOF2_SetInt(arquivo,"Level", PlayerInfo[playerid][Level]);
    DOF2_SetInt(arquivo,"UltimaVisitaDia",PlayerInfo[playerid][UltimaVisitaDia]);
    DOF2_SetInt(arquivo,"UltimaVisitaMes",PlayerInfo[playerid][UltimaVisitaMes]);
    DOF2_SetInt(arquivo,"UltimaVisitaAno",PlayerInfo[playerid][UltimaVisitaAno]);
    DOF2_SetInt(arquivo,"TutorialConcluido",PlayerInfo[playerid][TutorialConcluido]);
    DOF2_SetInt(arquivo,"ParteDoTutorial",PlayerInfo[playerid][ParteDoTutorial]);
    DOF2_SetInt(arquivo,"SlotCarro",PlayerInfo[playerid][SlotCarro]);
    DOF2_SetInt(arquivo,"SlotCarro2",PlayerInfo[playerid][SlotCarro2]);
    DOF2_SetInt(arquivo,"SlotCarro3",PlayerInfo[playerid][SlotCarro3]);
    DOF2_SetInt(arquivo,"SlotCarro4",PlayerInfo[playerid][SlotCarro4]);
    DOF2_SetInt(arquivo,"SlotCarro5",PlayerInfo[playerid][SlotCarro5]);
    DOF2_SetInt(arquivo,"CorSlotCarro",PlayerInfo[playerid][CorSlotCarro]);
    DOF2_SetInt(arquivo,"CorSlotCarro2",PlayerInfo[playerid][CorSlotCarro2]);
    DOF2_SetInt(arquivo,"CorSlotCarro3",PlayerInfo[playerid][CorSlotCarro3]);
    DOF2_SetInt(arquivo,"CorSlotCarro4",PlayerInfo[playerid][CorSlotCarro4]);
    DOF2_SetInt(arquivo,"CorSlotCarro5",PlayerInfo[playerid][CorSlotCarro5]);
    DOF2_SetInt(arquivo,"CarroUsando",PlayerInfo[playerid][SlotCarroUsando]);
    DOF2_SetInt(arquivo,"CorCarroUsando",PlayerInfo[playerid][CorSlotCarroUsando]);
    DOF2_SetInt(arquivo,"Nitro",PlayerInfo[playerid][NitroVeiculo]);
    DOF2_SetInt(arquivo,"Administrador",PlayerInfo[playerid][Administrador]);
    DOF2_SetInt(arquivo,"Tag",PlayerInfo[playerid][Tag]);
    DOF2_SetInt(arquivo,"Socio",PlayerInfo[playerid][Socio]);
    DOF2_SetInt(arquivo,"CupomCarro",PlayerInfo[playerid][CupomCarro]);
    DOF2_SetInt(arquivo,"SegundosUP",PlayerInfo[playerid][SegundosUP]);
    DOF2_SetInt(arquivo,"Escudo",PlayerInfo[playerid][Escudo]);
    DOF2_SetInt(arquivo,"Prego",PlayerInfo[playerid][Prego]);
    DOF2_SetInt(arquivo,"Missel",PlayerInfo[playerid][Missel]);
    DOF2_SetInt(arquivo,"Novato",PlayerInfo[playerid][PrimeiraVez]);
    DOF2_SaveFile();
    return 1;
}
CarregarConta(playerid);
CarregarConta(playerid)
{
    new arquivo[500],nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    format(arquivo, sizeof(arquivo), PASTACONTAS, nome);
    strmid(PlayerInfo[playerid][Senha], DOF2_GetString(arquivo,"Senha"),0, strlen(DOF2_GetString(arquivo,"Senha")), 255);
    PlayerInfo[playerid][Skin] = DOF2_GetInt(arquivo,"Skin");
    PlayerInfo[playerid][Dinheiro] = DOF2_GetInt(arquivo,"Dinheiro");
    PlayerInfo[playerid][Level] = DOF2_GetInt(arquivo,"Level");
    PlayerInfo[playerid][UltimaVisitaDia] = DOF2_GetInt(arquivo,"UltimaVisitaDia");
    PlayerInfo[playerid][UltimaVisitaMes] = DOF2_GetInt(arquivo,"UltimaVisitaMes");
    PlayerInfo[playerid][UltimaVisitaAno] = DOF2_GetInt(arquivo,"UltimaVisitaAno");
    PlayerInfo[playerid][TutorialConcluido] = DOF2_GetBool(arquivo,"TutorialConcluido");
    PlayerInfo[playerid][ParteDoTutorial] = DOF2_GetInt(arquivo,"ParteDoTutorial");
    PlayerInfo[playerid][SlotCarro] = DOF2_GetInt(arquivo,"SlotCarro");
    PlayerInfo[playerid][SlotCarro2] = DOF2_GetInt(arquivo,"SlotCarro2");
    PlayerInfo[playerid][SlotCarro3] = DOF2_GetInt(arquivo,"SlotCarro3");
    PlayerInfo[playerid][SlotCarro4] = DOF2_GetInt(arquivo,"SlotCarro4");
    PlayerInfo[playerid][SlotCarro5] = DOF2_GetInt(arquivo,"SlotCarro5");
    PlayerInfo[playerid][CorSlotCarro] = DOF2_GetInt(arquivo,"CorSlotCarro");
    PlayerInfo[playerid][CorSlotCarro2] = DOF2_GetInt(arquivo,"CorSlotCarro2");
    PlayerInfo[playerid][CorSlotCarro3] = DOF2_GetInt(arquivo,"CorSlotCarro3");
    PlayerInfo[playerid][CorSlotCarro4] = DOF2_GetInt(arquivo,"CorSlotCarro4");
    PlayerInfo[playerid][CorSlotCarro5] = DOF2_GetInt(arquivo,"CorSlotCarro5");
    PlayerInfo[playerid][SlotCarroUsando] = DOF2_GetInt(arquivo,"CarroUsando");
    PlayerInfo[playerid][CorSlotCarroUsando] = DOF2_GetInt(arquivo,"CorCarroUsando");
    PlayerInfo[playerid][NitroVeiculo] = DOF2_GetBool(arquivo,"Nitro");
    PlayerInfo[playerid][Administrador] = DOF2_GetInt(arquivo,"Administrador");
    PlayerInfo[playerid][Tag] = DOF2_GetInt(arquivo,"Tag");
    PlayerInfo[playerid][Socio] = DOF2_GetInt(arquivo,"Socio");
    PlayerInfo[playerid][CupomCarro] = DOF2_GetInt(arquivo,"CupomCarro");
    PlayerInfo[playerid][SegundosUP] = DOF2_GetInt(arquivo,"SegundosUP");
    PlayerInfo[playerid][Escudo] = DOF2_GetBool(arquivo,"Escudo");
    PlayerInfo[playerid][Prego] = DOF2_GetBool(arquivo,"Prego");
    PlayerInfo[playerid][Missel] = DOF2_GetBool(arquivo,"Missel");
    PlayerInfo[playerid][PrimeiraVez] = DOF2_GetInt(arquivo,"Novato");
    return 1;
}
forward SegundospUP(playerid);
public SegundospUP(playerid)
{
    if(PlayerInfo[playerid][Socio] == 0)
    {
        if(PlayerInfo[playerid][SegundosUP] == up)
        {
            GameTextForPlayer(playerid, "~w~Level ~g~UP", 2000, 1);
            PlayerInfo[playerid][SegundosUP] = 0;
            PlayerInfo[playerid][Level] += 1;
            SalvarConta(playerid);
        }
    }
    if(PlayerInfo[playerid][Socio] == 1)
    {
        if(PlayerInfo[playerid][SegundosUP] == upsociobronze)
        {
            GameTextForPlayer(playerid, "~w~Level ~g~UP", 2000, 1);
            PlayerInfo[playerid][SegundosUP] = 0;
            PlayerInfo[playerid][Level] += 1;
            SalvarConta(playerid);
        }
    }
    if(PlayerInfo[playerid][Socio] == 2)
    {
        if(PlayerInfo[playerid][SegundosUP] == upsocioprata)
        {
            GameTextForPlayer(playerid, "~w~Level ~g~UP", 2000, 1);
            PlayerInfo[playerid][SegundosUP] = 0;
            PlayerInfo[playerid][Level] += 1;
            SalvarConta(playerid);
        }
    }
    if(PlayerInfo[playerid][Socio] == 3)
    {
        if(PlayerInfo[playerid][SegundosUP] == upsocioouro)
        {
            GameTextForPlayer(playerid, "~w~Level ~g~UP", 2000, 1);
            PlayerInfo[playerid][SegundosUP] = 0;
            PlayerInfo[playerid][Level] += 1;
            SalvarConta(playerid);
        }
    }
    PlayerInfo[playerid][SegundosUP] += 1;
    return 1;
}
public CarregandoObjetos(playerid)
{
    KillTimer(PlayerInfo[playerid][TimerCarregarOBJ]);
    return TogglePlayerControllable(playerid, 1);
}
stock ResetarVariaveis(playerid)
{
    PlayerInfo[playerid][Logando] = false;
    PlayerInfo[playerid][cSenha] = false;
    PlayerInfo[playerid][PassarTutorial] = false;
    PlayerInfo[playerid][EmTutorial] = false;
    PlayerInfo[playerid][PodePassarTutorial] = false;
    PlayerInfo[playerid][TutorialConcluido] = false;
    PlayerInfo[playerid][ComprandoConce] = false;
    PlayerInfo[playerid][GaragemeConce] = false;
    PlayerInfo[playerid][Policial] = false;
    PlayerInfo[playerid][Bandido] = false;
    PlayerInfo[playerid][EstaEmCorrida] = false;
    PlayerInfo[playerid][NitroVeiculo] = false;
    PlayerInfo[playerid][JogandoSala] = false;
    PlayerInfo[playerid][NitroPermissao] = false;
    PlayerInfo[playerid][Banido] = false;
    PlayerInfo[playerid][Spawnado] = false;
    PlayerInfo[playerid][EntrandoComecado] = false;
    PlayerInfo[playerid][Escudo] = false;
    PlayerInfo[playerid][Prego] = false;
    PlayerInfo[playerid][Missel] = false;
    PlayerInfo[playerid][MorreuBandido] = false;
    PlayerInfo[playerid][Skin] = 0;
    PlayerInfo[playerid][Dinheiro] = 0;
    PlayerInfo[playerid][Level] = 0;
    PlayerInfo[playerid][PaginaConce] = 0;
    PlayerInfo[playerid][veiculoconcepreview] = 0;
    PlayerInfo[playerid][SlotCarro] = 0;
    PlayerInfo[playerid][SlotCarro2] = 0;
    PlayerInfo[playerid][SlotCarro3] = 0;
    PlayerInfo[playerid][SlotCarro4] = 0;
    PlayerInfo[playerid][SlotCarro5] = 0;
    PlayerInfo[playerid][CorSlotCarro] = 0;
    PlayerInfo[playerid][CorSlotCarro2] = 0;
    PlayerInfo[playerid][CorSlotCarro3] = 0;
    PlayerInfo[playerid][CorSlotCarro4] = 0;
    PlayerInfo[playerid][CorSlotCarro5] = 0;
    PlayerInfo[playerid][PaginaGaragem] = 0;
    PlayerInfo[playerid][CorComprar] = 0;
    PlayerInfo[playerid][SlotCarroUsando] = 0;
    PlayerInfo[playerid][Sala] = 0;
    PlayerInfo[playerid][IdSala] = 0;
    PlayerInfo[playerid][CorMiniMapa] = 0;
    PlayerInfo[playerid][Socio] = 0;
    PlayerInfo[playerid][CupomCarro] = 0;
    PlayerInfo[playerid][SegundosUP] = 0;
    PlayerInfo[playerid][Administrador] = 0;
    PlayerInfo[playerid][Tag] = 0;
    PlayerInfo[playerid][Nitro] = 0;
    PlayerInfo[playerid][EscudoTempo] = 0;
    PlayerInfo[playerid][PregoTempo] = 0;
    PlayerInfo[playerid][MisselTempo] = 0;
    PlayerInfo[playerid][CheckPoint] = 0;
    PlayerInfo[playerid][Volta] = 0;
    PlayerInfo[playerid][CorridaCar] = 0;
    KillTimer(PlayerInfo[playerid][TimerTutorial]);
    KillTimer(PlayerInfo[playerid][ContagemInicialT]);
    KillTimer(PlayerInfo[playerid][TimerCarregarOBJ]);
    KillTimer(PlayerInfo[playerid][TimerSetTempoTD]);
    KillTimer(PlayerInfo[playerid][MiniMapaT]);
    KillTimer(PlayerInfo[playerid][NitroT]);
    KillTimer(PlayerInfo[playerid][NitroT2]);
    KillTimer(PlayerInfo[playerid][RecuperarNitroT]);
    KillTimer(PlayerInfo[playerid][EscudoTimer]);
    KillTimer(PlayerInfo[playerid][PregoTimer]);
    KillTimer(PlayerInfo[playerid][MisselTimer]);
    return 1;
}
public CriarLogPrincipal(text[])
{
	new entrada[128];
	format(entrada, sizeof(entrada), "%s\r\n",text);
	new File:lArquivo;
	lArquivo = fopen(LOGPRINCIPAL,io_append);
	fwrite(lArquivo, entrada);
	fclose(lArquivo);
    return 1;
}
public CriarLogLogin(text[])
{
	new entrada[128];
	format(entrada, sizeof(entrada), "%s\r\n",text);
	new File:lArquivo;
	lArquivo = fopen(LOGLOGIN,io_append);
	fwrite(lArquivo, entrada);
	fclose(lArquivo);
    return 1;
}
public CriarLogRegistro(text[])
{
	new entrada[128];
	format(entrada, sizeof(entrada), "%s\r\n",text);
	new File:lArquivo;
	lArquivo = fopen(LOGREGISTRO,io_append);
	fwrite(lArquivo, entrada);
	fclose(lArquivo);
    return 1;
}
public CriarLogSenha(text[])
{
	new entrada[128];
	format(entrada, sizeof(entrada), "%s\r\n",text);
	new File:lArquivo;
	lArquivo = fopen(LOGSENHA,io_append);
	fwrite(lArquivo, entrada);
	fclose(lArquivo);
    return 1;
}
public CriarLogAdministradorCMD(text[])
{
	new entrada[128];
	format(entrada, sizeof(entrada), "%s\r\n",text);
	new File:lArquivo;
	lArquivo = fopen(LOGADMINISTRADORCMD,io_append);
	fwrite(lArquivo, entrada);
	fclose(lArquivo);
    return 1;
}
stock PlayerName(playerid)
{
    new nome[MAX_PLAYER_NAME];
    GetPlayerName(playerid, nome, sizeof(nome));
    return nome;
}
public ClearChatbox(playerid, lines)
{
    for(new i=0; i<lines; i++)
    {
        SendClientMessage(playerid, BRANCO, " ");
    }
    return 1;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}
	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

stock AbrirConcessionaria(playerid)
{
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][0]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][1]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][2]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][3]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][4]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][5]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][6]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][7]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][8]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][9]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][10]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][11]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][12]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][13]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][14]);
    PlayerInfo[playerid][PaginaConce] = 0;
    new id = PlayerInfo[playerid][PaginaConce];
    TogglePlayerControllable(playerid, 0);
    SetPlayerPos(playerid, -2038.5042,171.3578,28.8359);
    SetPlayerCameraPos(playerid, -1980.1117, 290.2411, 37.5321);
    SetPlayerCameraLookAt(playerid, -1979.2274, 289.7778, 37.4371);
    new nome[100],velocidade[100],preco[100],motor[100];
    format(nome, sizeof(nome), "NOME: %s", ConcessionariaI[id][veiculonome]);
    TextDrawSetString( Concessionaria[playerid][5], nome);
    format(preco, sizeof(preco), "PRECO: R$%d", ConcessionariaI[id][veiculopreco]);
    TextDrawSetString( Concessionaria[playerid][6], preco);
    format(velocidade, sizeof(velocidade), "VELOCIDADE MAX: %d KMH", ConcessionariaI[id][veiculovelocidade]);
    TextDrawSetString( Concessionaria[playerid][7], velocidade);
    format(motor, sizeof(motor), "MOTOR: %s", ConcessionariaI[id][veiculomotor]);
    TextDrawSetString( Concessionaria[playerid][9], motor);
    if(GetPlayerScore(playerid) > ConcessionariaI[id][veiculolevel])
    {
        TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~g~DESBLOQUEADO");
        TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: COM NIVEL");
    }
    if(GetPlayerScore(playerid) < ConcessionariaI[id][veiculolevel])
    {
        TextDrawSetString( Concessionaria[playerid][8], "STATUS: ~r~BLOQUEADO");
        TextDrawSetString( Concessionaria[playerid][10], "STATUS MOTIVO: SEM NIVEL");
    }
    SetPlayerVirtualWorld(playerid, playerid);
    TogglePlayerControllable(playerid, 1);
    SelectTextDraw(playerid, ERROR);
    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(ConcessionariaI[id][veiculoid], -1970.7778, 284.3213, 35.6628, 90.0000, -1, -1, 0);
    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
    TextDrawSetPreviewModel(Concessionaria[playerid][14], ConcessionariaI[id][veiculoid]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][14]);
    TextDrawShowForPlayer(playerid, Concessionaria[playerid][14]);
    return 1;
}
public AbrirAGaragem(playerid)
{
    TogglePlayerControllable(playerid, 1);
    SetPlayerPos(playerid, -1950.2538,261.4997,41.0534);
    SetPlayerCameraPos(playerid, -1933.4467, 267.4268, 42.7323);
    SetPlayerCameraLookAt(playerid, -1932.8597, 268.2410, 42.5773);
    SetPlayerVirtualWorld(playerid, playerid);
    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
    PlayerInfo[playerid][veiculoconcepreview] = AddStaticVehicleEx(PlayerInfo[playerid][SlotCarro], -1928.8998, 273.4213, 41.5428, 180.0000, -1, -1, 0);
    SetVehicleVirtualWorld(PlayerInfo[playerid][veiculoconcepreview], playerid);
    ChangeVehicleColor(PlayerInfo[playerid][veiculoconcepreview], PlayerInfo[playerid][CorSlotCarro], PlayerInfo[playerid][CorSlotCarro]);
    PlayerInfo[playerid][PaginaGaragem] = 0;
    SelectTextDraw(playerid, AZUL);
    TextDrawShowForPlayer(playerid, Garagem[playerid][0]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][1]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][2]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][3]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][4]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][5]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][6]);
    TextDrawShowForPlayer(playerid, Garagem[playerid][7]);
    new nome[200];
    format(nome, sizeof(nome), "VEICULO: %s", GetVehicleName(PlayerInfo[playerid][SlotCarro]));
    TextDrawSetString( Garagem[playerid][4], nome);
    return 1;
}

stock SairOMenu(playerid)
{
    if(PlayerInfo[playerid][PrimeiraVez] == 4){ PlayerInfo[playerid][PrimeiraVez] = 0; }
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][0]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][1]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][2]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][3]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][4]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][5]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][6]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][7]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][8]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][9]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][10]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][11]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][12]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][13]);
    TextDrawHideForPlayer(playerid, Concessionaria[playerid][14]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][0]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][1]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][2]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][3]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][4]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][5]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][6]);
    TextDrawHideForPlayer(playerid, Garagem[playerid][7]);
    TextDrawHideForPlayer(playerid, Cores[playerid][0]);
    TextDrawHideForPlayer(playerid, Cores[playerid][1]);
    TextDrawHideForPlayer(playerid, Cores[playerid][2]);
    TextDrawHideForPlayer(playerid, Cores[playerid][3]);
    TextDrawHideForPlayer(playerid, Cores[playerid][4]);
    TextDrawHideForPlayer(playerid, Cores[playerid][5]);
    TextDrawHideForPlayer(playerid, Cores[playerid][6]);
    TextDrawHideForPlayer(playerid, Cores[playerid][7]);
    TextDrawHideForPlayer(playerid, Cores[playerid][8]);
    TextDrawHideForPlayer(playerid, Cores[playerid][9]);
    TextDrawHideForPlayer(playerid, Cores[playerid][10]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][0]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][1]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][2]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][3]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][4]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][5]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][6]);
    TextDrawHideForPlayer(playerid, SalaTD[playerid][7]);
    TextDrawHideForPlayer(playerid, NomeSalaTD[0]);
    TextDrawHideForPlayer(playerid, NomeSalaTD[1]);
    TextDrawHideForPlayer(playerid, NomeSalaTD[2]);
    TextDrawHideForPlayer(playerid, NomeSalaTD[3]);
    PlayerInfo[playerid][MenuSala] = false;
    PlayerInfo[playerid][GaragemeConce] = false;
    if(PlayerInfo[playerid][Spawnado] == true)
    {
        new Float:x,Float:y,Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z);
    }
    PlayerInfo[playerid][Spawnado] = false;
    TogglePlayerControllable(playerid, 0);
    CancelSelectTextDraw(playerid);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetCameraBehindPlayer(playerid);
    DestroyVehicle(PlayerInfo[playerid][VeiculoCorrendo]);
    DestroyVehicle(PlayerInfo[playerid][veiculoconcepreview]);
    SpawnPlayer(playerid);
    if(PlayerInfo[playerid][PrimeiraVez] == 3){ PlayerInfo[playerid][PrimeiraVez] = 2; }
    return 1;
}

public CarregarConcessionaria()
{
	for(new idx = 0; idx < sizeof(ConcessionariaI) ; idx++)
	{
        new arquivo[800];
        format(arquivo, sizeof(arquivo), CONCESSIONARIA, idx);
        strmid(ConcessionariaI[idx][veiculonome], DOF2_GetString(arquivo,"Nome"),0, strlen(DOF2_GetString(arquivo,"Nome")), 255);
        ConcessionariaI[idx][veiculopreco] = DOF2_GetInt(arquivo,"Preco");
        ConcessionariaI[idx][veiculovelocidade] = DOF2_GetInt(arquivo,"Velocidade");
        ConcessionariaI[idx][veiculolevel] = DOF2_GetInt(arquivo,"Level");
        ConcessionariaI[idx][veiculoid] = DOF2_GetInt(arquivo,"Id");
        ConcessionariaI[idx][desbug] = DOF2_GetInt(arquivo,"desbug");
        strmid(ConcessionariaI[idx][veiculomotor], DOF2_GetString(arquivo,"Motor"),0, strlen(DOF2_GetString(arquivo,"Motor")), 255);
    }
    new printar[100];
    format(printar, sizeof(printar), "(CONCESSIONARIA-SYSTEM WARNING[SUCESS]) %d veiculos carregados ao todo.\n", MAXCARROSCONCE);
    print(printar);
    return 0x01;
}
public ConcluirCompra(playerid)
{
    new dialog[1000],slot[100],slot2[100],slot3[100],slot4[100],slot5[100];
    if(PlayerInfo[playerid][SlotCarro] > 1) { slot = "Ocupado."; } else slot = "Vazio.";
    if(PlayerInfo[playerid][SlotCarro2] > 1) { slot2 = "Ocupado."; } else slot2 = "Vazio.";
    if(PlayerInfo[playerid][SlotCarro3] > 1) { slot3 = "Ocupado."; } else slot3 = "Vazio.";
    if(PlayerInfo[playerid][SlotCarro4] > 1) { slot4 = "Ocupado."; } else slot4 = "Vazio.";
    if(PlayerInfo[playerid][SlotCarro5] > 1) { slot5 = "Ocupado."; } else slot5 = "Vazio.";
    format(dialog, sizeof(dialog), "Selecione o slot que você deseja armazenar o veiculo\tEstado\n - Slot 1\t%s\n - Slot 2\t%s\n - Slot 3\t%s\n - Slot 4\t%s\n - Slot 5\t%s", slot, slot2, slot3, slot4, slot5);
    ShowPlayerDialog(playerid, d_escolherslotcarro, DIALOG_STYLE_TABLIST_HEADERS, "Concessionaria", dialog, "Selecionar", "Cancel");
    return 1;
}
public GivePlayerMoneyR(playerid, quantia)
{
    TextDrawHideForPlayer(playerid, DinheiroTD[playerid]);
    KillTimer(PlayerInfo[playerid][TimerDinheiro]);
    PlayerInfo[playerid][Dinheiro] += quantia;
    new td[500];
    if(quantia < 0)
    {
        format(td, sizeof(td), "-R$%d", quantia);
        TextDrawSetString( DinheiroTD[playerid], td);
    }
    else if(quantia > 0)
    {
        format(td, sizeof(td), "+R$%d", quantia);
        TextDrawSetString( DinheiroTD[playerid], td);
    }
    TextDrawShowForPlayer(playerid, DinheiroTD[playerid]);
    PlayerInfo[playerid][TimerDinheiro] = SetTimerEx("SumirTDDinheiro",4000,false,"i",playerid);
    return GivePlayerMoney(playerid, quantia);
}
forward SumirTDDinheiro(playerid);
public SumirTDDinheiro(playerid)
{
    KillTimer(PlayerInfo[playerid][TimerDinheiro]);
    TextDrawHideForPlayer(playerid, DinheiroTD[playerid]);
    return 1;
}
stock AbrirSalas(playerid)
{
    PlayerInfo[playerid][MenuSala] = true;
    SelectTextDraw(playerid, -1);
    TogglePlayerControllable(playerid, 1);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][0]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][1]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][2]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][3]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][4]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][5]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][6]);
    TextDrawShowForPlayer(playerid, SalaTD[playerid][7]);
    TextDrawShowForPlayer(playerid, NomeSalaTD[0]);
    TextDrawShowForPlayer(playerid, NomeSalaTD[1]);
    TextDrawShowForPlayer(playerid, NomeSalaTD[2]);
    TextDrawShowForPlayer(playerid, NomeSalaTD[3]);
    return 1;
}
forward IniciarJogoSala1();
public IniciarJogoSala1()
{
    SalaInfo[0][s_comecou] = true;
    if(SalaInfo[0][s_players] < 2)
    {
        SalaInfo[0][s_comecou] = false;
        return 1;
    }
    SalaInfo[0][s_timerfugir] = SetTimer("BandidoFugiuSala1",600000+2500,false);
    KillTimer(SalaInfo[1][s_timeriniciar]);
    new randombandido = random(SalaInfo[0][s_players]);
    if(randombandido == 0)
    {
        randombandido = 1;
    }
    foreach(Player, i)
    {
        if(PlayerInfo[i][Sala] == 1)
        {
            PlayerInfo[i][Policial] = true;
            PlayerInfo[i][EstaEmCorrida] = true;
            if(PlayerInfo[i][IdSala] == randombandido)
            {
                PlayerInfo[i][Policial] = false;
                PlayerInfo[i][Bandido] = true;
            }
            SairOMenu(i);
            TextDrawShowForPlayer(i, Contagem[i]);
            PlayerInfo[i][ContagemInicial] = 5;
            PlayerInfo[i][ContagemInicialT] = SetTimerEx("ContagemParaInicioSala1",1000,true,"i",i);
        }
    }
    SalaInfo[0][s_timerverificar] = SetTimer("VerificarSala1",50,true);
    return 1;
}
forward ContagemParaInicioSala1(playerid);
public ContagemParaInicioSala1(playerid)
{
    if(PlayerInfo[playerid][ContagemInicial] == 0)
    {
        KillTimer(PlayerInfo[playerid][ContagemInicialT]);
        TogglePlayerControllable(playerid, 1);
        TextDrawHideForPlayer(playerid, Contagem[playerid]);
        if(PlayerInfo[playerid][Bandido] == true)
        {
            TextDrawSetString( TempoFugirTD[playerid], "~w~Tempo: ~r~10 minutos.");
            PlayerInfo[playerid][JogandoSala] = true;
        }
        TextDrawShowForPlayer(playerid, TempoFugirTD[playerid]);
        PlayerInfo[playerid][TimerSetTempoTD] = SetTimerEx("SetarTD",60000,true,"i",playerid);
        PlayerInfo[playerid][TempoTD] = 10;
        return 1;
    }
    PlayerInfo[playerid][ContagemInicial] -= 1;
    new contagemg[200];
    format(contagemg, sizeof(contagemg), "%d", PlayerInfo[playerid][ContagemInicial]);
    TextDrawSetString( Contagem[playerid], contagemg);
    return 1;
}
forward BandidoFugiuSala1();
public BandidoFugiuSala1()
{
    KillTimer(SalaInfo[0][s_timerfugir]);
    SalaInfo[0][s_bandidoganhou] = true;
    return 1;
}
forward SetarTD(playerid);
public SetarTD(playerid)
{
    if(PlayerInfo[playerid][TempoTD] == 1)
    {
        TextDrawHideForPlayer(playerid, TempoFugirTD[playerid]);
        KillTimer(PlayerInfo[playerid][TimerSetTempoTD]);
        return 1;
    }
    PlayerInfo[playerid][TempoTD] -= 1;
    new formatar[300];
    if(PlayerInfo[playerid][Bandido] == true)
    {
        if(PlayerInfo[playerid][TempoTD] < 3){ format(formatar, sizeof(formatar), "Tempo: ~g~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
        if(PlayerInfo[playerid][TempoTD] < 4){ format(formatar, sizeof(formatar), "Tempo: ~y~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
        if(PlayerInfo[playerid][TempoTD] < 10){ format(formatar, sizeof(formatar), "Tempo: ~r~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
    }
    if(PlayerInfo[playerid][Policial] == true)
    {
        if(PlayerInfo[playerid][TempoTD] < 3){ format(formatar, sizeof(formatar), "~w~Tempo: ~r~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
        if(PlayerInfo[playerid][TempoTD] < 4){ format(formatar, sizeof(formatar), "~w~Tempo: ~y~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
        if(PlayerInfo[playerid][TempoTD] < 10){ format(formatar, sizeof(formatar), "~w~Tempo: ~g~%d Minutos.", PlayerInfo[playerid][TempoTD]); }
    }
    TextDrawSetString( TempoFugirTD[playerid], formatar);
    return 1;
}
forward MiniMapaSet(playerid);
public MiniMapaSet(playerid)
{
    if(PlayerInfo[playerid][CorMiniMapa] == 0)
    {
        TextDrawHideForPlayer(playerid, MiniMapa[playerid]);
        TextDrawShowForPlayer(playerid, MiniMapa2[playerid]);
        PlayerInfo[playerid][CorMiniMapa] = 1;
        return 1;
    }
    else if(PlayerInfo[playerid][CorMiniMapa] == 1)
    {
        TextDrawHideForPlayer(playerid, MiniMapa2[playerid]);
        TextDrawShowForPlayer(playerid, MiniMapa[playerid]);
        PlayerInfo[playerid][CorMiniMapa] = 0;
        return 1;
    }
    return 1;
}
forward SetNitroTDP(playerid);
public SetNitroTDP(playerid)
{
    if(PlayerInfo[playerid][Nitro] == 1)
    {
        KillTimer(PlayerInfo[playerid][NitroT]);
        RemoveVehicleComponent(GetPlayerVehicleID(playerid),1010);
        PlayerInfo[playerid][RecuperarNitroT] = SetTimerEx("RecuperarNitro",3000,true,"i",playerid);
        return 1;
    }
    PlayerInfo[playerid][Nitro] -= 1;
    AddVehicleComponent(GetPlayerVehicleID(playerid),1010);
    if(PlayerInfo[playerid][Nitro] == 16){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 15){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIIII~b~I"); }
    if(PlayerInfo[playerid][Nitro] == 14){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIII~b~II"); }
    if(PlayerInfo[playerid][Nitro] == 13){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIII~b~III"); }
    if(PlayerInfo[playerid][Nitro] == 12){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIII~b~IIII"); }
    if(PlayerInfo[playerid][Nitro] == 11){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIII~b~IIIII"); }
    if(PlayerInfo[playerid][Nitro] == 10){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIII~b~IIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 9){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIII~b~IIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 8){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIII~b~IIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 7){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIII~b~IIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 6){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIII~b~IIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 5){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIII~b~IIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 4){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~III~b~IIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 3){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~II~b~IIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 2){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~I~b~IIIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 1){ TextDrawSetString( NitroTD[playerid][1], "~b~IIIIIIIIIIIIIIII"); }
    return 1;
}
forward RecuperarNitro(playerid);
public RecuperarNitro(playerid)
{
    if(PlayerInfo[playerid][Nitro] == 16)
    {
        KillTimer(PlayerInfo[playerid][RecuperarNitroT]);
        return 1;
    }
    PlayerInfo[playerid][Nitro] += 1;
    if(PlayerInfo[playerid][Nitro] == 16){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 15){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIIII~b~I"); }
    if(PlayerInfo[playerid][Nitro] == 14){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIIII~b~II"); }
    if(PlayerInfo[playerid][Nitro] == 13){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIIII~b~III"); }
    if(PlayerInfo[playerid][Nitro] == 12){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIIII~b~IIII"); }
    if(PlayerInfo[playerid][Nitro] == 11){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIIII~b~IIIII"); }
    if(PlayerInfo[playerid][Nitro] == 10){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIIII~b~IIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 9){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIIII~b~IIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 8){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIIIII~b~IIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 7){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIIII~b~IIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 6){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIIII~b~IIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 5){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~IIII~b~IIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 4){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~III~b~IIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 3){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~II~b~IIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 2){ TextDrawSetString( NitroTD[playerid][1], "~b~~h~~h~I~b~IIIIIIIIIIIIIII"); }
    if(PlayerInfo[playerid][Nitro] == 1){ TextDrawSetString( NitroTD[playerid][1], "~b~IIIIIIIIIIIIIIII"); }
    return 1;
}
forward PoderUsarDeNovo(playerid);
public PoderUsarDeNovo(playerid)
{
    KillTimer(PlayerInfo[playerid][NitroT2]);
    PlayerInfo[playerid][NitroPermissao] = true;
    return 1;
}
public AtualizarChatBubble()
{
    for(new x=0; x < MAX_PLAYERS; x++)
    {
        if(PlayerInfo[x][Administrador] == 1)
        {
            SetPlayerChatBubble(x, "[Administrador]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Administrador] == 2)
        {
            SetPlayerChatBubble(x, "[Dono]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Administrador] == 3)
        {
            SetPlayerChatBubble(x, "[Programador]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Tag] == 1)
        {
            SetPlayerChatBubble(x, "[Beta-Tester]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 1)
        {
            SetPlayerChatBubble(x, "[Socio Bronze]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 2)
        {
            SetPlayerChatBubble(x, "[Socio Prata]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 3)
        {
            SetPlayerChatBubble(x, "[Socio Ouro]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 1 && PlayerInfo[x][Tag] == 1)
        {
            SetPlayerChatBubble(x, "[Beta-Tester|Socio Bronze]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 2 && PlayerInfo[x][Tag] == 1)
        {
            SetPlayerChatBubble(x, "[Beta-Tester|Socio Prata]", 0xFFFF00AA, 100.0, 10000);
        }
        if(PlayerInfo[x][Socio] == 3 && PlayerInfo[x][Tag] == 1)
        {
            SetPlayerChatBubble(x, "[Beta-Tester|Socio Ouro]", 0xFFFF00AA, 100.0, 10000);
        }
    }
}
forward Kickar(playerid);
public Kickar(playerid)
{
    Kick(playerid);
    return 1;
}
IsNumeric(const string[])
{
	for (new i = 0, j = strlen(string); i < j; i++)
	{
		if (string[i] > '9' || string[i] < '0') return 0;
	}
	return 1;
}
ReturnUser(text[], playerid = INVALID_PLAYER_ID)
{
	new pos = 0;
	while (text[pos] < 0x21)
	{
		if (text[pos] == 0) return INVALID_PLAYER_ID;
		pos++;
	}
	new userid = INVALID_PLAYER_ID;
	if (IsNumeric(text[pos]))
	{
		userid = strval(text[pos]);
		if (userid >=0 && userid < MAX_PLAYERS)
		{
			if(!IsPlayerConnected(userid))
			{
				userid = INVALID_PLAYER_ID;
			}
			else
			{
				return userid;
			}
		}
	}
	new len = strlen(text[pos]);
	new count = 0;
	new name[MAX_PLAYER_NAME];
	for (new i = 0; i < MAX_PLAYERS; i++)
	{
		if (IsPlayerConnected(i))
		{
			GetPlayerName(i, name, sizeof (name));
			if (strcmp(name, text[pos], true, len) == 0)
			{
				if (len == strlen(name))
				{
					return i;
				}
				else
				{
					count++;
					userid = i;
				}
			}
		}
	}
	if (count != 1)
	{
		if (playerid != INVALID_PLAYER_ID)
		{
			if (count)
			{
				SendClientMessage(playerid, 0xFF0000AA, "Multiple users found, please narrow earch");
			}
			else
			{
				SendClientMessage(playerid, 0xFF0000AA, "No matching user found");
			}
		}
		userid = INVALID_PLAYER_ID;
	}
	return userid;
}
stock GetVehicleSpeed(vehicleid)
{
        new Float:xPos[3];
        GetVehicleVelocity(vehicleid, xPos[0], xPos[1], xPos[2]);
        return floatround(floatsqroot(xPos[0] * xPos[0] + xPos[1] * xPos[1] + xPos[2] * xPos[2]) * 170.00);
}
public VerificarSala1()
{
    if(SalaInfo[0][s_players] < 2 && SalaInfo[0][s_comecou] == true)
    {
        foreach(Player, i)
        {
            if(PlayerInfo[i][Sala] == 1)
            {
                SalaInfo[0][s_comecou] = false;
                SalaInfo[0][s_players] = 0;
                SalaInfo[0][s_spawn] = 0;
                KillTimer(SalaInfo[0][s_timerverificar]);
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                SendClientMessage(i, ERROR, "[AVISO]{FFFFFF}: Não há player suficientes e a perseguição foi encerrada!");
                SalaInfo[0][s_players] = 0;
                new sala[500];
                format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                TextDrawSetString( NomeSalaTD[0], sala);
                KillTimer(SalaInfo[0][s_timerfugir]);
                KillTimer(PlayerInfo[i][TimerSetTempoTD]);
                TextDrawHideForPlayer(i, TempoFugirTD[i]);
                ResetarVariavelSala1();
            }
        }
        return 1;
    }
    if(SalaInfo[0][s_bandidoganhou] == true)
    {
        foreach(Player, i)
        {
            TogglePlayerControllable(i, 1);
            if(PlayerInfo[i][Sala] == 1)
            {
                DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                TextDrawSetString( TempoFugirTD[i], "Tempo: ~g~10 Minutos.");
                KillTimer(PlayerInfo[i][MiniMapaT]);
                TextDrawHideForPlayer(i, MiniMapa[i]);
                TextDrawHideForPlayer(i, MiniMapa2[i]);
                if(PlayerInfo[i][Bandido] == true)
                {
                    SendClientMessage(i, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}] Você conseguiu roubar R$4000 do banco.");
                    GivePlayerMoneyR(i, 4000);
                    SalvarConta(i);
                    PlayerInfo[i][JogandoSala] = false;
                }
                if(PlayerInfo[i][Policial] == true)
                {
                    SendClientMessage(i, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}] O bandido conseguiu fugir e você perdeu R$2000.");
                    SendClientMessage(i, BRANCO, "[{0000FF}San-News{FFFFFF}] O bandido conseguiu fugir com o dinheiro na perseguição da PM!");
                    GivePlayerMoneyR(i, -2000);
                    SalvarConta(i);
                }
                TextDrawSetString( TempoFugirTD[i], "Tempo: ~g~10 Minutos.");
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                SelectTextDraw(i, -1);
                PlayerInfo[i][EscolhendoBonus] = true;
                TextDrawShowForPlayer(i, BonusTD[0][i]);
                TextDrawShowForPlayer(i, BonusTD[1][i]);
                TextDrawShowForPlayer(i, BonusTD[2][i]);
                TextDrawShowForPlayer(i, BonusTD[3][i]);
                TextDrawShowForPlayer(i, BonusTD[4][i]);
                TextDrawShowForPlayer(i, BonusTD[5][i]);
                TextDrawShowForPlayer(i, BonusTD[6][i]);
                TextDrawShowForPlayer(i, BonusTD[7][i]);
                KillTimer(PlayerInfo[i][TimerSetTempoTD]);
                TextDrawHideForPlayer(i, TempoFugirTD[i]);
                new sala[300];
                format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                TextDrawSetString( NomeSalaTD[0], sala);
            }
            ResetarVariavelSala1();
            return 1;
        }
    }
    else if(SalaInfo[0][s_bandidoganhou] == false)
    {
        foreach(Player, i)
        {
            TogglePlayerControllable(i, 1);
            if(PlayerInfo[i][Sala] == 1)
            {
                DestroyVehicle(PlayerInfo[i][VeiculoCorrendo]);
                TextDrawSetString( TempoFugirTD[i], "Tempo: ~g~10 Minutos.");
                KillTimer(PlayerInfo[i][MiniMapaT]);
                TextDrawHideForPlayer(i, MiniMapa[i]);
                TextDrawHideForPlayer(i, MiniMapa2[i]);
                if(PlayerInfo[i][Bandido] == true)
                {
                    SendClientMessage(i, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}] Você não conseguiu roubar R$4000 do banco e perdeu R$2000.");
                    GivePlayerMoneyR(i, -2000);
                    SalvarConta(i);
                    PlayerInfo[i][JogandoSala] = false;
                }
                if(PlayerInfo[i][Policial] == true)
                {
                    SendClientMessage(i, BRANCO, "[{FF0000}Hot-Pursuit{FFFFFF}] O bandido não conseguiu fugir e você ganhou R$4000.");
                    SendClientMessage(i, BRANCO, "[{0000FF}San-News{FFFFFF}] O bandido não conseguiu fugir com o dinheiro na perseguição da PM!");
                    GivePlayerMoneyR(i, 4000);
                    SalvarConta(i);
                }
                TextDrawSetString( TempoFugirTD[i], "Tempo: ~g~10 Minutos.");
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                SelectTextDraw(i, -1);
                PlayerInfo[i][EscolhendoBonus] = true;
                TextDrawShowForPlayer(i, BonusTD[0][i]);
                TextDrawShowForPlayer(i, BonusTD[1][i]);
                TextDrawShowForPlayer(i, BonusTD[2][i]);
                TextDrawShowForPlayer(i, BonusTD[3][i]);
                TextDrawShowForPlayer(i, BonusTD[4][i]);
                TextDrawShowForPlayer(i, BonusTD[5][i]);
                TextDrawShowForPlayer(i, BonusTD[6][i]);
                TextDrawShowForPlayer(i, BonusTD[7][i]);
                new sala[300];
                format(sala, sizeof(sala), "~l~[~r~HOT~l~-~b~PURSUIT~l~]      Tamanho: Pequena       %d/10 Players", SalaInfo[0][s_players]);
                TextDrawSetString( NomeSalaTD[0], sala);
            }
            ResetarVariavelSala1();
        }
    }
    return 1;
}
stock ResetarVariavelSala1()
{
    SalaInfo[0][s_players] = 0;
    SalaInfo[0][s_spawn] = 0;
    SalaInfo[0][s_spawn2] = 0;
    SalaInfo[0][s_bandidoganhou] = false;
    SalaInfo[0][s_comecou] = false;
    KillTimer(SalaInfo[0][s_timerfinalizarpartida]);
    KillTimer(SalaInfo[0][s_timerverificacao]);
    KillTimer(SalaInfo[0][s_timerfugir]);
    KillTimer(SalaInfo[0][s_timerverificar]);
    KillTimer(SalaInfo[0][s_timeriniciar]);
    return 1;
}
stock ResetarVariavelSala2()
{
    SalaInfo[1][s_players] = 0;
    SalaInfo[1][s_spawn] = 0;
    SalaInfo[1][s_spawn2] = 0;
    SalaInfo[1][s_bandidoganhou] = false;
    SalaInfo[1][s_comecou] = false;
    KillTimer(SalaInfo[1][s_timerfinalizarpartida]);
    KillTimer(SalaInfo[1][s_timerverificacao]);
    KillTimer(SalaInfo[1][s_timerfugir]);
    KillTimer(SalaInfo[1][s_timerverificar]);
    KillTimer(SalaInfo[1][s_timeriniciar]);
    return 1;
}
forward SetEscudoTempo(playerid);
public SetEscudoTempo(playerid)
{
    if(PlayerInfo[playerid][EscudoTempo] == 0)
    {
        TextDrawBoxColor(PoderTD[1][playerid], 0xFF0000FF);
        TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
        TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
        DestroyObject(PlayerInfo[playerid][AttachmentObject]);
        return KillTimer(PlayerInfo[playerid][EscudoTimer]);
    }
    PlayerInfo[playerid][EscudoTempo] -= 1;
    PlayerInfo[playerid][TamanhoTDPoder] += 5;
    TextDrawTextSize(PoderTD[1][playerid], PlayerInfo[playerid][TamanhoTDPoder], 2.333333);
    TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
    TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
    return 1;
}
forward SetPregoTempo(playerid);
public SetPregoTempo(playerid)
{
    if(PlayerInfo[playerid][EscudoTempo] == 0)
    {
        TextDrawBoxColor(PoderTD[1][playerid], 0xFF0000FF);
        TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
        TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
        DestroyObject(PlayerInfo[playerid][AttachmentObject]);
        return KillTimer(PlayerInfo[playerid][EscudoTimer]);
    }
    PlayerInfo[playerid][PregoTempo] -= 1;
    PlayerInfo[playerid][TamanhoTDPoder] += 5;
    TextDrawTextSize(PoderTD[1][playerid], PlayerInfo[playerid][TamanhoTDPoder], 2.333333);
    TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
    TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
    foreach(Player, i)
    {
        new Float:Pos[3];
        GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
        if(IsPlayerInRangeOfPoint(i, 7.0, Pos[0]+4, Pos[1], Pos[2]))
        {
            new danor = random(4);
            new panels, doors, lights, tires;
            GetVehicleDamageStatus(GetPlayerVehicleID(i), panels, doors, lights, tires);
            CreateAudioPlayerLocation(playerid, 1100);
            CreateAudioPlayerLocation(i, 1100);
            switch(danor)
            {
                case 0:
                {
                    UpdateVehicleDamageStatus(GetPlayerVehicleID(i), panels+3, doors, lights, tires);
                }
                case 1:
                {
                    UpdateVehicleDamageStatus(GetPlayerVehicleID(i), panels, doors+3, lights, tires);
                }
                case 2:
                {
                    UpdateVehicleDamageStatus(GetPlayerVehicleID(i), panels, doors, lights+3, tires);
                }
                case 3:
                {
                    UpdateVehicleDamageStatus(GetPlayerVehicleID(i), panels, doors, lights, tires+3);
                }
            }
        }
    }
    return 1;
}
forward SetMisselTempo(playerid);
public SetMisselTempo(playerid)
{
    if(PlayerInfo[playerid][MisselTempo] == 0)
    {
        TextDrawBoxColor(PoderTD[1][playerid], 0xFF0000FF);
        TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
        TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
        DestroyObject(PlayerInfo[playerid][AttachmentObject]);
        TextDrawSetString(PoderTD[2][playerid], "Missel Lancado");
        new Float:Pos[3];
        GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
        if(PlayerInfo[playerid][DistanciaMissel] == 0){ CreateExplosion(Pos[0], Pos[1]+35, Pos[2], 2, 60); }
        if(PlayerInfo[playerid][DistanciaMissel] == 1){ CreateExplosion(Pos[0], Pos[1]+65, Pos[2], 2, 60); }
        if(PlayerInfo[playerid][DistanciaMissel] == 2){ CreateExplosion(Pos[0], Pos[1]+100, Pos[2], 2, 60); }
        return KillTimer(PlayerInfo[playerid][MisselTimer]);
    }
    if(PlayerInfo[playerid][MisselTempo] > 0)
    {
        TextDrawSetString(PoderTD[2][playerid], "Lancando Missel");
        TextDrawBoxColor(PoderTD[1][playerid], 0xFFFF00FF);
    }
    if(PlayerInfo[playerid][MisselTempo] > 6)
    {
        TextDrawSetString(PoderTD[2][playerid], "Preparando Missel");
        TextDrawBoxColor(PoderTD[1][playerid], 16777215);
    }
    PlayerInfo[playerid][MisselTempo] -= 1;
    PlayerInfo[playerid][TamanhoTDPoder] += 5;
    TextDrawTextSize(PoderTD[1][playerid], PlayerInfo[playerid][TamanhoTDPoder], 2.333333);
    TextDrawHideForPlayer(playerid, PoderTD[1][playerid]);
    TextDrawShowForPlayer(playerid, PoderTD[1][playerid]);
    return 1;
}
public CreateAudioPlayerLocation(playerid, soundid)
{
    new Float:Pos[3];
    GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
    PlayerPlaySound(playerid, soundid, Pos[0], Pos[1], Pos[2]);
    return 1;
}
forward IniciarMotocross();
public IniciarMotocross()
{
    KillTimer(MotoCrossSInfo[0][timercomecarpartida]);
    if(MotoCrossSInfo[0][players] < 2)
    {
        ResetarVariaveisSala2();
        return 1;
    }
    foreach(Player, i)
    {
        if(PlayerInfo[i][Sala] == 2)
        {
            SairOMenu(i);
            PlayerInfo[i][EstaEmCorrida] = true;
            TextDrawShowForPlayer(i, Contagem[i]);
            PlayerInfo[i][ContagemInicial] = 5;
            PlayerInfo[i][ContagemInicialT] = SetTimerEx("ContagemParaInicioSala2",1000,true,"i",i);
        }
    }
    MotoCrossSInfo[0][timerverificarpartida] = SetTimer("VerificarMotoCross",50,true);
    return 1;
}
forward VerificarMotoCross();
public VerificarMotoCross()
{
    if(MotoCrossSInfo[0][players] < 2)
    {
        foreach(Player, i)
        {
            if(PlayerInfo[i][Sala] == 2)
            {
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: Não houve players suficientes e a partida foi encerrada.");
            }
        }
        ResetarVariaveisSala2();
        KillTimer(MotoCrossSInfo[0][timerverificarpartida]);
        return 1;
    }
    return 1;
}
stock ResetarVariaveisSala2()
{
    MotoCrossSInfo[0][players] = 0;
    MotoCrossSInfo[0][comecou] = false;
    MotoCrossSInfo[0][posicaospawnar] = 0;
    MotoCrossSInfo[0][terminoupos] = 0;
    KillTimer(MotoCrossSInfo[0][timercomecarpartida]);
    KillTimer(MotoCrossSInfo[0][timerverificarpartida]);
    return 1;
}
forward ContagemParaInicioSala2(playerid);
public ContagemParaInicioSala2(playerid)
{
    if(PlayerInfo[playerid][ContagemInicial] == 1)
    {
        KillTimer(PlayerInfo[playerid][ContagemInicialT]);
        TogglePlayerControllable(playerid, 1);
        TextDrawHideForPlayer(playerid, Contagem[playerid]);
        CreateAudioPlayerLocation(playerid, 1057);
        return 1;
    }
    CreateAudioPlayerLocation(playerid, 1057);
    PlayerInfo[playerid][ContagemInicial] -= 1;
    new contagemg[200];
    format(contagemg, sizeof(contagemg), "%d", PlayerInfo[playerid][ContagemInicial]);
    TextDrawSetString(Contagem[playerid], contagemg);
    if(PlayerInfo[playerid][ContagemInicial] == 1){ TextDrawSetString(Contagem[playerid], "GO"); }
    return 1;
}
forward IniciarCorrida();
public IniciarCorrida()
{
    KillTimer(CorridaHSInfo[0][timercomecarpartida]);
    if(CorridaHSInfo[0][players] < 2)
    {
        ResetarVariaveisSala3();
        return 1;
    }
    foreach(Player, i)
    {
        if(PlayerInfo[i][Sala] == 3)
        {
            SairOMenu(i);
            PlayerInfo[i][EstaEmCorrida] = true;
            TextDrawShowForPlayer(i, Contagem[i]);
            PlayerInfo[i][ContagemInicial] = 5;
            PlayerInfo[i][ContagemInicialT] = SetTimerEx("ContagemParaInicioSala3",1000,true,"i",i);
        }
    }
    CorridaHSInfo[0][timerverificarpartida] = SetTimer("VerificarCorrida",50,true);
    return 1;
}
forward VerificarCorrida();
public VerificarCorrida()
{
    if(CorridaHSInfo[0][players] < 2)
    {
        foreach(Player, i)
        {
            if(PlayerInfo[i][Sala] == 3)
            {
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: Não houve players suficientes e a partida foi encerrada.");
            	new sala[300];
                format(sala, sizeof(sala), "~l~[~b~CORRIDA~l~]            Premio: ~g~R$%d~l~         %d/8 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
                TextDrawSetString( NomeSalaTD[3], sala);
			}
        }
        ResetarVariaveisSala3();
        KillTimer(CorridaHSInfo[0][timerverificarpartida]);
        return 1;
    }
    return 1;
}
stock ResetarVariaveisSala3()
{
    CorridaHSInfo[0][players] = 0;
    CorridaHSInfo[0][comecou] = false;
    CorridaHSInfo[0][posicaospawnar] = 0;
    CorridaHSInfo[0][terminoupos] = 0;
    KillTimer(CorridaHSInfo[0][timercomecarpartida]);
    KillTimer(CorridaHSInfo[0][timerverificarpartida]);
   	new sala[300];
    format(sala, sizeof(sala), "~l~[~b~CORRIDA~l~]            Premio: ~g~R$%d~l~         %d/8 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
	TextDrawSetString( NomeSalaTD[3], sala);
    return 1;
}
forward ContagemParaInicioSala3(playerid);
public ContagemParaInicioSala3(playerid)
{
    if(PlayerInfo[playerid][ContagemInicial] == 1)
    {
        TextDrawSetString(Contagem[playerid], "GO");
        KillTimer(PlayerInfo[playerid][ContagemInicialT]);
        TogglePlayerControllable(playerid, 1);
        TextDrawHideForPlayer(playerid, Contagem[playerid]);
        CreateAudioPlayerLocation(playerid, 1056);
        return 1;
    }
    CreateAudioPlayerLocation(playerid, 1057);
    PlayerInfo[playerid][ContagemInicial] -= 1;
    new contagemg[200];
    format(contagemg, sizeof(contagemg), "%d", PlayerInfo[playerid][ContagemInicial]);
    TextDrawSetString(Contagem[playerid], contagemg);
    return 1;
}
forward IniciarGuerra();
public IniciarGuerra()
{
    KillTimer(GuerraSInfo[0][timercomecarpartida]);
    if(GuerraSInfo[0][players] < 1)
    {
        ResetarVariaveisSala4();
        return 1;
    }
    foreach(Player, i)
    {
        if(PlayerInfo[i][Sala] == 4)
        {
            SairOMenu(i);
            PlayerInfo[i][EstaEmGuerra] = true;
        }
    }
    GuerraSInfo[0][timerverificarpartida] = SetTimer("VerificarCorrida",50,true);
    return 1;
}
forward VerificarGuerra();
public VerificarGuerra()
{
    if(GuerraSInfo[0][players] < 1)
    {
        foreach(Player, i)
        {
            if(PlayerInfo[i][Sala] == 4)
            {
                ResetarVariaveis(i);
                CarregarConta(i);
                SpawnPlayer(i);
                SendClientMessage(i, 0xFF0000FF, "[AVISO]{FFFFFF}: Não houve players suficientes e a partida foi encerrada.");
            	new sala[300];
                format(sala, sizeof(sala), "~l~[~r~EUAxAFEGANI~l~]      Premio: ~g~R$%d~l~         %d/30 Players", CorridaHSInfo[0][premio], CorridaHSInfo[0][players]);
                TextDrawSetString( NomeSalaTD[2], sala);
			}
        }
        ResetarVariaveisSala4();
        KillTimer(GuerraSInfo[0][timerverificarpartida]);
        return 1;
    }
    return 1;
}
stock ResetarVariaveisSala4()
{
    GuerraSInfo[0][players] = 0;
    GuerraSInfo[0][comecou] = false;
    KillTimer(GuerraSInfo[0][timercomecarpartida]);
    KillTimer(GuerraSInfo[0][timerverificarpartida]);
   	new sala[300];
    format(sala, sizeof(sala), "~l~[~r~EUAxAFEGANI~l~]      Premio: ~g~R$%d~l~         %d/30 Players", GuerraSInfo[0][premio], GuerraSInfo[0][players]);
	TextDrawSetString( NomeSalaTD[2], sala);
    return 1;
}

/*

                MUNDOS VIRTUAIS

        1 - Concessionaria do servidor.

*/

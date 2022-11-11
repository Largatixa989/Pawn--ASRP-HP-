#include <a_samp>
#include <a_mysql> // R39 - download it here: http://forum.sa-mp.com/showthread.php?t=56564
#include <foreach>
#include <easyDialog>
#include <mSelection>
#include <sscanf2>
#include <streamer>
#include <zcmd>
#include <strtok>
#include <YSI/y_va>

#define SQL_HOSTNAME "localhost"
#define SQL_USERNAME "mysql"
#define SQL_DATABASE "servidorgta"
#define SQL_PASSWORD "w9yK68QESWPzbDEd"

#define SERVER_MODE "American's RP v1.0000"
#define SERVER_NAME "hostname American State Roleplay @HeavyHost.com.br"
#define SERVER_SITE "www.as-rp.forumeiros.com"

#define SendSyntaxMessage(%0,%1) \
 	va_SendClientMessage(%0, COLOR_GREY, "[SYNTAX]:{FFFFFF} "%1)

#define SendServerMessage(%0,%1) \
	va_SendClientMessage(%0, COLOR_YELLOW, "[SERVER]: "%1)

#define SendErrorMessage(%0,%1) \
	va_SendClientMessage(%0, COLOR_LIGHTRED, "[ERRO]:{FFFFFF} "%1)
	
#define COLOR_CLIENT      (0xAAC4E5FF)
#define COLOR_WHITE       (0xFFFFFFFF)
#define COLOR_RED         (0xFF0000FF)
#define COLOR_CYAN        (0x33CCFFFF)
#define COLOR_LIGHTRED    (0xFF6347FF)
#define COLOR_LIGHTGREEN  (0x9ACD32FF)
#define COLOR_YELLOW      (0xFFFF00FF)
#define COLOR_GREY        (0x888888C8)
#define COLOR_HOSPITAL    (0xFF8282FF)
#define COLOR_PURPLE      (0xD0AEEBFF)
#define COLOR_LIGHTYELLOW (0xF5DEB3FF)
#define COLOR_DARKBLUE    (0x1394BFFF)
#define COLOR_ORANGE      (0xFFA500FF)
#define COLOR_LIME        (0x00FF00FF)
#define COLOR_GREEN       (0x33CC33FF)
#define COLOR_BLUE        (0x2641FEFF)
#define COLOR_FACTION     (0xBDF38BFF)
#define COLOR_RADIO       (0x8D8DFFFF)
#define COLOR_SERVER      (0xFFFF90FF) // 6688FF
#define COLOR_DEPARTMENT  (0xF0CC00FF)
#define COLOR_ADMINCHAT   (0x33EE33FF)
#define DEFAULT_COLOR     (0xFFFFFFFF)
#define COLOR_RADIOCHAT   (0x996600AA)
#define COLOR_FACTIONCHAT (0x6699FFAA)
#define COLOR_NEWGREEN    (0x00E228FF)
#define COLOR_NEWBLUE     (0x80BCFF)
#define COLOR_DONATOR     (0x99660000)
#define COLOR_DONATORCHAT (0x996600AA)
#define COLOR_LIGHTBLUE   (0x3AB3EDFF)
#define COLOR_INTERCOM    (0x58D3A6FF)
#define COLOR_FADVERT     (0x00AA00FF)
#define COLOR_CHATADMIN   (0x3CB371FF)
#define COLOR_HEADADMIN   (0x104E8BFF)
#define COLOR_LEADADMIN   (0x00CD00FF)
#define COLOR_GAMEADMIN   (0x607B8BFF)
#define COLOR_MANAGEMENT  (0xCD5C5CFF)
#define COLOR_CHATTESTER  (0x8B2323FF)

#define INDEX_PLAYER_WEAPON 0

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))


#define MAX_CARACTERES_SENHA (150)
new mysqlconexao;

#define MAX_HOUSES (3000)
#define MAX_DOORS (5000)
#define MAX_FURNITURES (5000)

#define MODELOS_PORTAS (1)

new Modelos_pPorta = mS_INVALID_LISTID;
new Modelos_fParedes = mS_INVALID_LISTID;
new Modelos_fPortas = mS_INVALID_LISTID;
new Modelos_fMoveis = mS_INVALID_LISTID;
new Modelos_fObjetos = mS_INVALID_LISTID;

enum dataplayer
{
	pName[MAX_PLAYER_NAME+3],
	pID,
	pSenha[MAX_CARACTERES_SENHA],
	pDinheiro,
	pLoginData[100],
	Float:pD_Pos[3],
	pD_Interior,
	pD_MundoVirtual,
	pSkin,
	pAdministrador,
	pTimerInterior,
	pEditandoPlaca,
	pCasaEditando,
	PlayerText:pTextdraws,
	bool:pCasaLuz,
	pEditandoPorta,
	pPortaEditando,
	pMovelHouse,
	pMovelEditando,
	pEditandoMovel,
	pDinheiroMobilia,
	pGaragemEntrou,
	bool:pVendoCasa,
	pIDCasaVendo,
 	pTimerVendoCasa,
	bool:pVendoGaragem,
	pIDGaragemVendo,
 	pTimerVendoGaragem,
 	pBalas,
 	pBalasSobrando,
 	pArmaUsando,
 	bool:pUsarCartucho
};
new PlayerData[MAX_PLAYERS][dataplayer];
enum housedata
{
	houseID,
	houseExiste,
	houseDono,
	houseComprada,
	houseEndereco[54],
	housePreco,
	houseDonoNome[MAX_PLAYER_NAME+24],
	Float:housePos[4],
	Float:housePlacaPos[4],
	Float:houseGaragemPos[4],
	Float:houseInt[4],
	houseInterior,
	houseExterior,
	houseVWInterior,
	houseVWExterior,
	houseTrancada,
	houseGaragemTrancada,
	housePlaca,
	Text3D:houseTextLabel,
	Text3D:houseTextLabel2,
	houseLuz,
	houseArmazenamentoArma[9],
	houseArmazenamentoBalas[9],
	houseOferecendo,
	houseOferecendoTexto[54]
};
enum furnituredata
{
	fExiste,
	fMundoVirtual,
	fInterior,
	fHouseID,
	fID,
	fModel,
	Float:fPos[6],
	fObject,
	fArmazenamento[10],
	fArmazenamentoBalas[10],
};
new FurnitureData[MAX_FURNITURES][furnituredata];
new HouseData[MAX_HOUSES][housedata];
enum doordata
{
	doorDono,
	Float:doorPos[4],
	doorObject,
	doorModel,
	doorInterior,
	doorExiste,
	doorMundoVirtual,
	doorAberta
};
new DoorData[MAX_DOORS][doordata];

GiveWeapon(playerid, weaponid, ammo)
{
    RemovePlayerAttachedObject(playerid, INDEX_PLAYER_WEAPON);
	PlayerData[playerid][pUsarCartucho] = false;
	PlayerData[playerid][pBalas] = ammo;
	PlayerData[playerid][pBalas] -= 7;
	PlayerData[playerid][pBalasSobrando] = 7;
	PlayerData[playerid][pArmaUsando] = weaponid;
	GivePlayerWeapon(playerid, PlayerData[playerid][pArmaUsando], PlayerData[playerid][pBalasSobrando]);
	return 1;
}

ReturnName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

GetWeaponModel(weaponid) {
    new const g_aWeaponModels[] = {
		0, 331, 333, 334, 335, 336, 337, 338, 339, 341, 321, 322, 323, 324,
		325, 326, 342, 343, 344, 0, 0, 0, 346, 347, 348, 349, 350, 351, 352,
		353, 355, 356, 372, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366,
		367, 368, 368, 371
    };
    if (1 <= weaponid <= 46)
        return g_aWeaponModels[weaponid];

	return 0;
}

stock PlayReloadAnimation(playerid, weaponid)
{
	switch (weaponid)
	{
	    case 22: ApplyAnimation(playerid, "COLT45", "colt45_reload", 4.0, 0, 0, 0, 0, 0);
		case 23: ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0, 0, 0, 0, 0, 0);
		case 24: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
		case 25, 27: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
		case 26: ApplyAnimation(playerid, "COLT45", "sawnoff_reload", 4.0, 0, 0, 0, 0, 0);
		case 29..31, 33, 34: ApplyAnimation(playerid, "RIFLE", "rifle_load", 4.0, 0, 0, 0, 0, 0);
		case 28, 32: ApplyAnimation(playerid, "TEC", "tec_reload", 4.0, 0, 0, 0, 0, 0);
	}
	return 1;
}

ReturnWeaponName(weaponid)
{
	static
		name[32];

	GetWeaponName(weaponid, name, sizeof(name));

	if (!weaponid)
	    name = "Soco";

	else if (weaponid == 18)
	    name = "Molotov Cocktail";

	else if (weaponid == 44)
	    name = "Nightvision";

	else if (weaponid == 45)
	    name = "Infrared";

	else if (weaponid == 54)
	    name = "Queda";

	return name;
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	new plyWeapons[12];
	new plyAmmo[12];

	for(new slot = 0; slot != 12; slot++)
	{
		new wep, ammo;
		GetPlayerWeaponData(playerid, slot, wep, ammo);

		if(wep != weaponid)
		{
			GetPlayerWeaponData(playerid, slot, plyWeapons[slot], plyAmmo[slot]);
		}
	}

	ResetPlayerWeapons(playerid);
	for(new slot = 0; slot != 12; slot++)
	{
		GivePlayerWeapon(playerid, plyWeapons[slot], plyAmmo[slot]);
	}
}

stock SendClientMessageFormatted(playerid, colour, format[], va_args<>)
{
    new
        out[2128]
	;
    va_format(out, sizeof(out), format, va_start<3>);
    SendClientMessage(playerid, colour, out);
    return 1;
}

stock Float:cache_get_field_float(row, const field_name[])
{
	new
	    str[16];

	cache_get_field_content(row, field_name, str, mysqlconexao);
	return floatstr(str);
}

cache_get_field_int(row, const field_name[])
{
	new
	    str[12];

	cache_get_field_content(row, field_name, str, mysqlconexao);
	return strval(str);
}

Casa_Distancia(playerid)
{
    for (new i = 0; i != MAX_HOUSES; i ++) if ( GetPlayerInterior(playerid) == HouseData[i][houseExterior] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[i][housePos][0], HouseData[i][housePos][1], HouseData[i][housePos][2])){
		return i;
    }
    return -1;
}

Garagem_Distancia(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)){
    	for (new i = 0; i != MAX_HOUSES; i ++) if ( GetPlayerInterior(playerid) == HouseData[i][houseExterior] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[i][houseGaragemPos][0], HouseData[i][houseGaragemPos][1], HouseData[i][houseGaragemPos][2])){
			return i;
		}
    }
    else if(IsPlayerInAnyVehicle(playerid)){
    	for (new i = 0; i != MAX_HOUSES; i ++) if ( GetPlayerInterior(playerid) == HouseData[i][houseExterior] && IsPlayerInRangeOfPoint(playerid, 5.0, HouseData[i][houseGaragemPos][0], HouseData[i][houseGaragemPos][1], HouseData[i][houseGaragemPos][2])){
			return i;
		}
    }
    return -1;
}

Casa_InteriorPorta(playerid)
{
    for (new i = 0; i != MAX_HOUSES; i ++) if ( GetPlayerVirtualWorld(playerid) == HouseData[i][houseVWInterior] && GetPlayerInterior(playerid) == HouseData[i][houseInterior] && IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[i][houseInt][0], HouseData[i][houseInt][1], HouseData[i][houseInt][2])){
		return i;
    }
    return -1;
}

Porta_Proxima(playerid)
{
    for (new i = 0; i != MAX_DOORS; i ++) if ( GetPlayerVirtualWorld(playerid) == DoorData[i][doorMundoVirtual] && GetPlayerInterior(playerid) == DoorData[i][doorInterior] && IsPlayerInRangeOfPoint(playerid, 2.0, DoorData[i][doorPos][0], DoorData[i][doorPos][1], DoorData[i][doorPos][2])){
		return i;
    }
    return -1;
}

Mobilia_Proxima(playerid)
{
    for (new i = 0; i != MAX_FURNITURES; i ++) if ( GetPlayerVirtualWorld(playerid) == FurnitureData[i][fMundoVirtual] && GetPlayerInterior(playerid) == FurnitureData[i][fInterior] && IsPlayerInRangeOfPoint(playerid, 2.0, FurnitureData[i][fPos][0], FurnitureData[i][fPos][1], FurnitureData[i][fPos][2])){
		return i;
    }
    return -1;
}

Casa_InteriorProximo(playerid)
{
    for (new i = 0; i != MAX_HOUSES; i ++) if ( GetPlayerVirtualWorld(playerid) == HouseData[i][houseVWInterior] && GetPlayerInterior(playerid) == HouseData[i][houseInterior] && IsPlayerInRangeOfPoint(playerid, 30.0, HouseData[i][houseInt][0], HouseData[i][houseInt][1], HouseData[i][houseInt][2])){
		return i;
    }
    return -1;
}

GetPlayerSQLID(playerid)
{
	return (PlayerData[playerid][pID]);
}

SQL_VerificarConta(playerid)
{
	new query[1024];
	format(query, sizeof(query), "SELECT * FROM `contas` WHERE `Usuario` = '%s' ", ReturnName(playerid));
	mysql_function_query(mysqlconexao, query, true, "q_rVerificarConta", "d", playerid);
	SpawnPlayer(playerid);
	return 1;
}

SQL_LoadPlayer(playerid)
{
	PlayerData[playerid][pID] = cache_get_field_int(0, "ID");
	PlayerData[playerid][pLoginData] = cache_get_field_int(0, "UltimoLogin");
	PlayerData[playerid][pD_Pos][0] = cache_get_field_float(0, "UltimaPosicaoX");
	PlayerData[playerid][pD_Pos][1] = cache_get_field_float(0, "UltimaPosicaoY");
	PlayerData[playerid][pD_Pos][2] = cache_get_field_float(0, "UltimaPosicaoZ");
	PlayerData[playerid][pD_Interior] = cache_get_field_int(0, "UltimoInterior");
	PlayerData[playerid][pD_MundoVirtual] = cache_get_field_int(0, "UltimoMundoVirtual");
	PlayerData[playerid][pSkin] = cache_get_field_int(0, "Skin");
	PlayerData[playerid][pDinheiro] = cache_get_field_int(0, "Dinheiro");
	PlayerData[playerid][pAdministrador] = cache_get_field_int(0, "Administrador");
	SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
	GivePlayerMoney(playerid, PlayerData[playerid][pDinheiro]);
	SetPlayerInterior(playerid, PlayerData[playerid][pD_Interior]);
	SetPlayerPos(playerid, PlayerData[playerid][pD_Pos][0], PlayerData[playerid][pD_Pos][1], PlayerData[playerid][pD_Pos][2]);
 	SetPlayerVirtualWorld(playerid, PlayerData[playerid][pD_MundoVirtual]);
	if(PlayerData[playerid][pD_Pos][0] == 0 && PlayerData[playerid][pD_Pos][1] == 0 && PlayerData[playerid][pD_Pos][2] == 0)
	{
	    SetPlayerPos(playerid, 2282.99, 23.8053, 26.4843);
	}
	return 1;
}


SQL_SavePlayer(playerid)
{
	GetPlayerPos(playerid, PlayerData[playerid][pD_Pos][0], PlayerData[playerid][pD_Pos][1], PlayerData[playerid][pD_Pos][2]);
	new ano,mes,dia,str[100];
	getdate(ano,mes,dia); format(str, sizeof(str), "%d/%d/%d", dia, mes, ano);
	PlayerData[playerid][pLoginData] = str;
	PlayerData[playerid][pDinheiro] = GetPlayerMoney(playerid);
	PlayerData[playerid][pSkin] = GetPlayerSkin(playerid);
	new query[1054];
	format(query, sizeof(query), "UPDATE `contas` SET `UltimoLogin` = '%s', `UltimaPosicaoX` = '%.4f', `UltimaPosicaoY` = '%.4f', `UltimaPosicaoZ` = '%.4f', `UltimoInterior` = '%d', `UltimoMundoVirtual` = '%d', `Skin` = '%d', `Dinheiro` = '%d', `Administrador` = '%d' WHERE `ID` = '%d'",
    PlayerData[playerid][pLoginData],
    PlayerData[playerid][pD_Pos][0],
    PlayerData[playerid][pD_Pos][1],
    PlayerData[playerid][pD_Pos][2],
    GetPlayerInterior(playerid),
    GetPlayerVirtualWorld(playerid),
    PlayerData[playerid][pSkin],
    PlayerData[playerid][pDinheiro],
    PlayerData[playerid][pAdministrador],
	PlayerData[playerid][pID]
    );
    mysql_function_query(mysqlconexao, query, false, "", "");
    return 1;
}

Criar_Porta(playerid, modelo)
{
 	static
 		Float:x,
	    Float:y,
	    Float:z,
		Float:angle;
 	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_DOORS; i ++)
		{
	    	if (!DoorData[i][doorExiste])
		    {
		    
		        DoorData[i][doorExiste] = 1;
		        DoorData[i][doorAberta] = 0;
		        
		        DoorData[i][doorDono] = GetPlayerSQLID(playerid);
		        
		        DoorData[i][doorMundoVirtual] = GetPlayerVirtualWorld(playerid);
		        DoorData[i][doorInterior] = GetPlayerInterior(playerid);
		        
		        DoorData[i][doorPos][0] = x;
		        DoorData[i][doorPos][1] = y;
		        DoorData[i][doorPos][2] = z;
		        DoorData[i][doorPos][3] = angle;
		        
		        DoorData[i][doorModel] = modelo;
		        
		        DoorData[i][doorObject] = CreateDynamicObject(modelo, x+2, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				EditDynamicObject(playerid, DoorData[i][doorObject]);
				SetPlayerPos(playerid, x, y, z);
		        
		        SendServerMessage(playerid, "Edite a porta, apos terminar clique em salvar.");
		        
		        PlayerData[playerid][pEditandoPorta] = 1;
		        PlayerData[playerid][pPortaEditando] = i;
		    
		        new query[1024];
		        format(query, sizeof(query), "INSERT INTO `portas` (ID, Dono) VALUES ('%d', '0')", i);
		        mysql_function_query(mysqlconexao, query, false, "", "");
		        return i;
		    }
		}
	}
	return 1;
}

Criar_Mobilia(playerid, modelo)
{
 	static
 		Float:x,
	    Float:y,
	    Float:z,
		Float:angle;
 	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_FURNITURES; i ++)
		{
	    	if (!FurnitureData[i][fExiste])
		    {

		        FurnitureData[i][fExiste] = 1;

		        FurnitureData[i][fHouseID] = PlayerData[playerid][pMovelHouse];

		        FurnitureData[i][fMundoVirtual] = GetPlayerVirtualWorld(playerid);
		        FurnitureData[i][fInterior] = GetPlayerInterior(playerid);

		        FurnitureData[i][fPos][0] = x;
		        FurnitureData[i][fPos][1] = y;
		        FurnitureData[i][fPos][2] = z;
		        FurnitureData[i][fPos][5] = angle;

		        FurnitureData[i][fModel] = modelo;

		        FurnitureData[i][fObject] = CreateDynamicObject(modelo, x+2, y, z, 0.0, 0.0, angle, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				EditDynamicObject(playerid, FurnitureData[i][fObject]);
				SetPlayerPos(playerid, x, y, z);

		        SendServerMessage(playerid, "Edite a mobilia, apos terminar clique em salvar.");

		        PlayerData[playerid][pEditandoMovel] = 1;
		        PlayerData[playerid][pMovelEditando] = i;

		        new query[1024];
		        format(query, sizeof(query), "INSERT INTO `mobilias` (ID, HouseID) VALUES ('%d', '%d')", i, PlayerData[playerid][pMovelHouse]);
		        mysql_function_query(mysqlconexao, query, false, "", "");
		        return i;
		    }
		}
	}
	return 1;
}

Casa_Criar(playerid, endereco[], preco)
{
 	static
 		Float:x,
	    Float:y,
	    Float:z,
		Float:angle;
 	if (GetPlayerPos(playerid, x, y, z) && GetPlayerFacingAngle(playerid, angle))
	{
		for (new i = 0; i != MAX_HOUSES; i ++)
		{
	    	if (!HouseData[i][houseExiste])
		    {
		    
 				HouseData[i][housePreco] = preco;
 				HouseData[i][houseComprada] = 0;
 				HouseData[i][houseExiste] = 1;
 				HouseData[i][houseTrancada] = 0;
 				
        	    new str[128];
        	    format(str, sizeof(str), "A venda por $%d", HouseData[i][housePreco]);
        	    format(HouseData[i][houseDonoNome], 32, str);
        	    
        	    format(HouseData[i][houseEndereco], 32, endereco);
        	    
    	        HouseData[i][housePos][0] = x;
    	        HouseData[i][housePos][1] = y;
    	        HouseData[i][housePos][2] = z;
    	        HouseData[i][housePos][3] = angle;
    	        
     			HouseData[i][houseInt][0] = 321.6608;
                HouseData[i][houseInt][1] = 1139.0358;
                HouseData[i][houseInt][2] = 1083.8828;
                HouseData[i][houseInt][3] = 359.9105;
        	    
				HouseData[i][houseInterior] = 5;
				HouseData[i][houseExterior] = GetPlayerInterior(playerid);
				HouseData[i][houseVWInterior] = i;
				HouseData[i][houseVWExterior] = GetPlayerVirtualWorld(playerid);
				SQL_AtualizarCasa(i);
				
				//mysql_query(mysqlconexao, "INSERT INTO `casas` (`houseDono`) VALUES(0)", "q_rOnCasaCriada", "d", i);
    			new query[1024];
		        format(query, sizeof(query), "INSERT INTO `casas` (ID, Dono) VALUES ('%d', '0')", i);
                mysql_function_query(mysqlconexao, query, false, "q_rOnCasaCriada", "d", i);
                return i;
		    }
		}
	}
	return 1;
}

SQL_AtualizarCasa(houseid)
{
	if(HouseData[houseid][houseDono] == 0 && HouseData[houseid][houseExiste]){
	    DestroyDynamicObject(HouseData[houseid][housePlaca]);
	    Delete3DTextLabel(HouseData[houseid][houseTextLabel]);
	    Delete3DTextLabel(HouseData[houseid][houseTextLabel2]);
		//HouseData[houseid][housePlaca] = CreateObject(19470, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2], 0.0, 0.0, HouseData[houseid][housePlacaPos][3]);
        HouseData[houseid][housePlaca] = CreateDynamicObject(19470, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2], 0.0, 0.0, HouseData[houseid][housePlacaPos][3], HouseData[houseid][houseVWExterior], HouseData[houseid][houseExterior]);
		new str[135];
		format(str, sizeof(str), "A venda por $%d.", HouseData[houseid][housePreco]);
		HouseData[houseid][houseTextLabel] = Create3DTextLabel(str, COLOR_GREEN, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2]+0.5, 4.0, HouseData[houseid][houseExterior], 0);
	}
	else if(HouseData[houseid][houseOferecendo] == 1)
	{
 		DestroyDynamicObject(HouseData[houseid][housePlaca]);
 		Delete3DTextLabel(HouseData[houseid][houseTextLabel]);
 		Delete3DTextLabel(HouseData[houseid][houseTextLabel2]);
		HouseData[houseid][housePlaca] = CreateDynamicObject(19470, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2], 0.0, 0.0, HouseData[houseid][housePlacaPos][3], HouseData[houseid][houseVWExterior], HouseData[houseid][houseExterior]);
		new str[135];
		format(str, sizeof(str), "A venda por $%d.", HouseData[houseid][housePreco]);
		HouseData[houseid][houseTextLabel] = Create3DTextLabel(str, COLOR_GREEN, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2]+0.5, 4.0, HouseData[houseid][houseExterior], 0);
		HouseData[houseid][houseTextLabel2] = Create3DTextLabel(HouseData[houseid][houseOferecendoTexto], COLOR_GREEN, HouseData[houseid][housePlacaPos][0], HouseData[houseid][housePlacaPos][1], HouseData[houseid][housePlacaPos][2]+0.4, 4.0, HouseData[houseid][houseExterior], 0);
	}
	else if(HouseData[houseid][houseDono] > 0 && HouseData[houseid][houseExiste]){
		DestroyDynamicObject(HouseData[houseid][housePlaca]);
		Delete3DTextLabel(HouseData[houseid][houseTextLabel]);
		Delete3DTextLabel(HouseData[houseid][houseTextLabel2]);
	}
}

SQL_AtualizarMovel(furnitureid)
{
	if(FurnitureData[furnitureid][fExiste]){
	    DestroyDynamicObject(FurnitureData[furnitureid][fObject]);
	    FurnitureData[furnitureid][fObject] = CreateDynamicObject(FurnitureData[furnitureid][fModel], FurnitureData[furnitureid][fPos][0], FurnitureData[furnitureid][fPos][1], FurnitureData[furnitureid][fPos][2], FurnitureData[furnitureid][fPos][3], FurnitureData[furnitureid][fPos][4], FurnitureData[furnitureid][fPos][5], FurnitureData[furnitureid][fMundoVirtual], FurnitureData[furnitureid][fInterior]);
	}
}

SQL_AtualizarPorta(doorid)
{
	if(DoorData[doorid][doorAberta] == 1 && DoorData[doorid][doorExiste]){
	    DestroyDynamicObject(DoorData[doorid][doorObject]);
	    DoorData[doorid][doorObject] = CreateDynamicObject(DoorData[doorid][doorModel], DoorData[doorid][doorPos][0], DoorData[doorid][doorPos][1], DoorData[doorid][doorPos][2], 0.0, 0.0, DoorData[doorid][doorPos][3]+90, DoorData[doorid][doorMundoVirtual], DoorData[doorid][doorInterior]);
	}
	if(DoorData[doorid][doorAberta] == 0 && DoorData[doorid][doorExiste]){
 		DestroyDynamicObject(DoorData[doorid][doorObject]);
	    DoorData[doorid][doorObject] = CreateDynamicObject(DoorData[doorid][doorModel], DoorData[doorid][doorPos][0], DoorData[doorid][doorPos][1], DoorData[doorid][doorPos][2], 0.0, 0.0, DoorData[doorid][doorPos][3], DoorData[doorid][doorMundoVirtual], DoorData[doorid][doorInterior]);
	}
}

SQL_SalvarMovel(furnitureid)
{
	new query[1054];
	format(query, sizeof(query), "UPDATE `mobilias` SET `Modelo`='%d', `MobiliaX`='%.4f', `MobiliaY`='%.4f', `MobiliaZ`='%.4f', `MobiliaRX`='%.4f', `MobiliaRY`='%.4f', `MobiliaRZ`='%.4f', `Interior`='%d', `MundoVirtual`='%d'",
	FurnitureData[furnitureid][fModel],
	FurnitureData[furnitureid][fPos][0],
	FurnitureData[furnitureid][fPos][1],
	FurnitureData[furnitureid][fPos][2],
	FurnitureData[furnitureid][fPos][3],
	FurnitureData[furnitureid][fPos][4],
	FurnitureData[furnitureid][fPos][5],
	FurnitureData[furnitureid][fInterior],
	FurnitureData[furnitureid][fMundoVirtual]
	);
	format(query, sizeof(query), "%s, `Dinheiro`='%d', `Arma`='%d', `Arma2`='%d', `Arma3`='%d', `Arma4`='%d', `Arma5`='%d', `Arma6`='%d', `Arma7`='%d', `Arma8`='%d', `Arma9`='%d' ",
	query,
	FurnitureData[furnitureid][fArmazenamento][0],
	FurnitureData[furnitureid][fArmazenamento][1],
	FurnitureData[furnitureid][fArmazenamento][2],
	FurnitureData[furnitureid][fArmazenamento][3],
	FurnitureData[furnitureid][fArmazenamento][4],
	FurnitureData[furnitureid][fArmazenamento][5],
	FurnitureData[furnitureid][fArmazenamento][6],
	FurnitureData[furnitureid][fArmazenamento][7],
	FurnitureData[furnitureid][fArmazenamento][8],
	FurnitureData[furnitureid][fArmazenamento][9]
	);
	format(query, sizeof(query), "%s, `Balas`='%d', `Balas2`='%d', `Balas3`='%d', `Balas4`='%d', `Balas5`='%d', `Balas6`='%d', `Balas7`='%d', `Balas8`='%d', `Balas9`='%d' WHERE `ID`='%d'",
	query,
	FurnitureData[furnitureid][fArmazenamentoBalas][1],
	FurnitureData[furnitureid][fArmazenamentoBalas][2],
	FurnitureData[furnitureid][fArmazenamentoBalas][3],
	FurnitureData[furnitureid][fArmazenamentoBalas][4],
	FurnitureData[furnitureid][fArmazenamentoBalas][5],
	FurnitureData[furnitureid][fArmazenamentoBalas][6],
	FurnitureData[furnitureid][fArmazenamentoBalas][7],
	FurnitureData[furnitureid][fArmazenamentoBalas][8],
	FurnitureData[furnitureid][fArmazenamentoBalas][9],
	furnitureid
	);
	mysql_function_query(mysqlconexao, query, false, "", "");
}

SQL_SalvarPorta(doorid)
{
	new query[1054];
	format(query, sizeof(query), "UPDATE `portas` SET `Dono`='%d', `Modelo`='%d', `PosicaoX`='%.4f', `PosicaoY`='%.4f', `PosicaoZ`='%.4f', `PosicaoR`='%.4f', `Aberta`='%d', `Interior`='%d', `MundoVirtual`='%d' WHERE `ID`='%d'",
	DoorData[doorid][doorDono],
	DoorData[doorid][doorModel],
	DoorData[doorid][doorPos][0],
	DoorData[doorid][doorPos][1],
	DoorData[doorid][doorPos][2],
	DoorData[doorid][doorPos][3],
	DoorData[doorid][doorAberta],
	DoorData[doorid][doorInterior],
	DoorData[doorid][doorMundoVirtual],
	doorid
	);
    mysql_function_query(mysqlconexao, query, false, "", "");
}

SQL_SalvarCasa(houseid)
{
	new query[1354];
	format(query, sizeof(query), "UPDATE `casas` SET `Dono`='%d', `DonoNome`='%s', `Endereco`='%s', `Trancada`='%d', `Preco`='%d', `Interior`='%d', `Exterior`='%d', `MundoVirtualInterior`='%d', `MundoVirtualExterior`='%d', `Comprada`='%d', `PosicaoX`='%.4f', `PosicaoY`='%.4f', `PosicaoZ`='%.4f', `PosicaoA`='%.4f', `PlacaX`='%.4f', `PlacaY`='%.4f', `PlacaZ`='%.4f', `PlacaA`='%.4f', `GaragemX`='%.4f', `GaragemY`='%.4f', `GaragemZ`='%.4f', `GaragemA`='%.4f'",
	HouseData[houseid][houseDono],
	HouseData[houseid][houseDonoNome],
	HouseData[houseid][houseEndereco],
	HouseData[houseid][houseTrancada],
	HouseData[houseid][housePreco],
	HouseData[houseid][houseInterior],
	HouseData[houseid][houseExterior],
	HouseData[houseid][houseVWInterior],
	HouseData[houseid][houseVWExterior],
	HouseData[houseid][houseComprada],
	HouseData[houseid][housePos][0],
	HouseData[houseid][housePos][1],
	HouseData[houseid][housePos][2],
	HouseData[houseid][housePos][3],
	HouseData[houseid][housePlacaPos][0],
	HouseData[houseid][housePlacaPos][1],
	HouseData[houseid][housePlacaPos][2],
	HouseData[houseid][housePlacaPos][3],
	HouseData[houseid][houseGaragemPos][0],
	HouseData[houseid][houseGaragemPos][1],
	HouseData[houseid][houseGaragemPos][2],
	HouseData[houseid][houseGaragemPos][3]
	);
	format(query, sizeof(query), "%s, `InteriorX`='%.4f', `InteriorY`='%.4f', `InteriorZ`='%.4f'",
	query,
	HouseData[houseid][houseInt][0],
	HouseData[houseid][houseInt][1],
	HouseData[houseid][houseInt][2],
	houseid
	);
	format(query, sizeof(query), "%s, `Arma`='%d', `Arma2`='%d', `Arma3`='%d', `Arma4`='%d', `Arma5`='%d', `Arma6`='%d', `Arma7`='%d', `Arma8`='%d', `Arma9`='%d' ",
	query,
	HouseData[houseid][houseArmazenamentoArma][0],
	HouseData[houseid][houseArmazenamentoArma][1],
	HouseData[houseid][houseArmazenamentoArma][2],
	HouseData[houseid][houseArmazenamentoArma][3],
	HouseData[houseid][houseArmazenamentoArma][4],
	HouseData[houseid][houseArmazenamentoArma][5],
	HouseData[houseid][houseArmazenamentoArma][6],
	HouseData[houseid][houseArmazenamentoArma][7],
	HouseData[houseid][houseArmazenamentoArma][8]
	);
	format(query, sizeof(query), "%s, `Balas`='%d', `Balas2`='%d', `Balas3`='%d', `Balas4`='%d', `Balas5`='%d', `Balas6`='%d', `Balas7`='%d', `Balas8`='%d', `Balas9`='%d' ",
	query,
	HouseData[houseid][houseArmazenamentoBalas][0],
	HouseData[houseid][houseArmazenamentoBalas][1],
	HouseData[houseid][houseArmazenamentoBalas][2],
	HouseData[houseid][houseArmazenamentoBalas][3],
	HouseData[houseid][houseArmazenamentoBalas][4],
	HouseData[houseid][houseArmazenamentoBalas][5],
	HouseData[houseid][houseArmazenamentoBalas][6],
	HouseData[houseid][houseArmazenamentoBalas][7],
	HouseData[houseid][houseArmazenamentoBalas][8]
	);
	format(query, sizeof(query), "%s, `Oferecendo`='%d', `AnuncioOferta`='%s', `GaragemTrancada`='%d' WHERE `ID`='%d' ",
	query,
	HouseData[houseid][houseOferecendo],
	HouseData[houseid][houseOferecendoTexto],
	HouseData[houseid][houseGaragemTrancada],
	houseid
	);
    mysql_function_query(mysqlconexao, query, false, "", "");
}

forward VerificarCasa(playerid);
public VerificarCasa(playerid)
{
	static
	    id;
	    
	id = PlayerData[playerid][pIDCasaVendo];

	if(!IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]))
	{
	    if(PlayerData[playerid][pVendoCasa] == true)
	    {
	        DisablePlayerCheckpoint(playerid);
	        KillTimer(PlayerData[playerid][pTimerVendoCasa]);
	    	PlayerData[playerid][pVendoCasa] = false;
		}
	}
	return 1;
}

forward VerificarGaragem(playerid);
public VerificarGaragem(playerid)
{
	static
	    id;

	id = PlayerData[playerid][pIDGaragemVendo];

	if(!IsPlayerInRangeOfPoint(playerid, 2.0, HouseData[id][houseGaragemPos][0], HouseData[id][houseGaragemPos][1], HouseData[id][houseGaragemPos][2]))
	{
	    if(PlayerData[playerid][pVendoGaragem] == true)
	    {
	        DisablePlayerCheckpoint(playerid);
	        KillTimer(PlayerData[playerid][pTimerVendoGaragem]);
	    	PlayerData[playerid][pVendoGaragem] = false;
		}
	}
	return 1;
}

forward q_rOnCasaCriada(houseid);
public q_rOnCasaCriada(houseid)
{
	if(houseid == -1 || !HouseData[houseid][houseExiste])
	    return 0;

	SQL_SalvarCasa(houseid);

	return 1;
}

forward q_rVerificarConta(playerid);
public q_rVerificarConta(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);

	if(rows > 0)
	{
	    SpawnPlayer(playerid);
	    TogglePlayerSpectating(playerid, 1);
	    InterpolateCameraPos(playerid, 2033.609252, 68.796401, 82.306152, 2309.079345, -49.802814, 38.296329, 20000);
		InterpolateCameraLookAt(playerid, 2038.110961, 67.566467, 80.511192, 2305.039550, -46.989498, 37.421943, 20000);
		cache_get_field_content(0, "UltimoLogin", PlayerData[playerid][pLoginData]);
 		new string[500];
	    format(string, sizeof(string), "Seja bem vindo novamente ao servidor\nSeu ultimo login foi %s\nDigite sua senha para logar.", PlayerData[playerid][pLoginData]);
 		return Dialog_Show(playerid, AccountLogin, DIALOG_STYLE_PASSWORD, "UCP - Login", string, "Logar", "Sair");
	}
	else
	{
        SendErrorMessage(playerid, "Você não possui uma conta no servidor.");
        return Kick(playerid);
	}
}

forward q_rVerificarSenha(playerid);
public q_rVerificarSenha(playerid)
{
	new rows, fields;
	cache_get_data(rows, fields);

	if(rows > 0)
	{
	    TogglePlayerSpectating(playerid, 0);
	    SpawnPlayer(playerid);
	    SQL_LoadPlayer(playerid);
		return SendServerMessage(playerid, "Logado com sucesso.");
	}
	else
	{
 		return Dialog_Show(playerid, AccountLogin, DIALOG_STYLE_PASSWORD, "UCP - Login", "Seja bem vindo novamente ao servidor\nDigite sua senha para logar.\n{FF0000}Senha digitada anteriormente incorreta.", "Logar", "Sair");
	}
}

forward q_rCarregarMobilias();
public q_rCarregarMobilias()
{
	new rowsc, fieldsc;
	cache_get_data(rowsc, fieldsc);

	if(rowsc > 0)
	{
		static
		    rows,
		    fields;

		cache_get_data(rows, fields, mysqlconexao);

		for (new i = 0; i < rows; i ++) if (i < MAX_FURNITURES)
		{
		    FurnitureData[i][fExiste] = 1;

		    FurnitureData[i][fPos][0] = cache_get_field_float(i, "MobiliaX");
		    FurnitureData[i][fPos][1] = cache_get_field_float(i, "MobiliaY");
		    FurnitureData[i][fPos][2] = cache_get_field_float(i, "MobiliaZ");
		    FurnitureData[i][fPos][3] = cache_get_field_float(i, "MobiliaRX");
		    FurnitureData[i][fPos][4] = cache_get_field_float(i, "MobiliaRY");
		    FurnitureData[i][fPos][5] = cache_get_field_float(i, "MobiliaRZ");

		    FurnitureData[i][fInterior] = cache_get_field_int(i, "Interior");
		    FurnitureData[i][fMundoVirtual] = cache_get_field_int(i, "MundoVirtual");
		    FurnitureData[i][fHouseID] = cache_get_field_int(i, "HouseID");
		    FurnitureData[i][fModel] = cache_get_field_int(i, "Modelo");
		    
		    FurnitureData[i][fArmazenamento][0] = cache_get_field_int(i, "Dinheiro");
		    
		    
		    FurnitureData[i][fArmazenamento][1] = cache_get_field_int(i, "Arma");
		    FurnitureData[i][fArmazenamento][2] = cache_get_field_int(i, "Arma2");
		    FurnitureData[i][fArmazenamento][3] = cache_get_field_int(i, "Arma3");
		    FurnitureData[i][fArmazenamento][4] = cache_get_field_int(i, "Arma4");
		    FurnitureData[i][fArmazenamento][5] = cache_get_field_int(i, "Arma5");
		    FurnitureData[i][fArmazenamento][6] = cache_get_field_int(i, "Arma6");
		    FurnitureData[i][fArmazenamento][7] = cache_get_field_int(i, "Arma7");
		    FurnitureData[i][fArmazenamento][8] = cache_get_field_int(i, "Arma8");
		    FurnitureData[i][fArmazenamento][9] = cache_get_field_int(i, "Arma9");
		    
		    
		    FurnitureData[i][fArmazenamentoBalas][1] = cache_get_field_int(i, "Balas");
		    FurnitureData[i][fArmazenamentoBalas][2] = cache_get_field_int(i, "Balas2");
		    FurnitureData[i][fArmazenamentoBalas][3] = cache_get_field_int(i, "Balas3");
		    FurnitureData[i][fArmazenamentoBalas][4] = cache_get_field_int(i, "Balas4");
		    FurnitureData[i][fArmazenamentoBalas][5] = cache_get_field_int(i, "Balas5");
		    FurnitureData[i][fArmazenamentoBalas][6] = cache_get_field_int(i, "Balas6");
		    FurnitureData[i][fArmazenamentoBalas][7] = cache_get_field_int(i, "Balas7");
		    FurnitureData[i][fArmazenamentoBalas][8] = cache_get_field_int(i, "Balas8");
		    FurnitureData[i][fArmazenamentoBalas][9] = cache_get_field_int(i, "Balas9");


		    SQL_AtualizarMovel(i);
		}
	}
}

forward q_rCarregarPortas();
public q_rCarregarPortas()
{
	new rowsc, fieldsc;
	cache_get_data(rowsc, fieldsc);

	if(rowsc > 0)
	{
		static
		    rows,
		    fields;

		cache_get_data(rows, fields, mysqlconexao);

		for (new i = 0; i < rows; i ++) if (i < MAX_DOORS)
		{
		    DoorData[i][doorExiste] = 1;
		    
		    DoorData[i][doorPos][0] = cache_get_field_float(i, "PosicaoX");
		    DoorData[i][doorPos][1] = cache_get_field_float(i, "PosicaoY");
		    DoorData[i][doorPos][2] = cache_get_field_float(i, "PosicaoZ");
		    DoorData[i][doorPos][3] = cache_get_field_float(i, "PosicaoR");
		    
		    DoorData[i][doorInterior] = cache_get_field_int(i, "Interior");
		    DoorData[i][doorAberta] = cache_get_field_int(i, "Aberta");
		    DoorData[i][doorDono] = cache_get_field_int(i, "Dono");
		    DoorData[i][doorModel] = cache_get_field_int(i, "Modelo");
		    DoorData[i][doorMundoVirtual] = cache_get_field_int(i, "MundoVirtual");
		    
		    SQL_AtualizarPorta(i);
		}
	}
}

forward q_rCarregarCasas();
public q_rCarregarCasas()
{
	new rowsc, fieldsc;
	cache_get_data(rowsc, fieldsc);

	if(rowsc > 0)
	{
		static
		    rows,
		    fields;

		cache_get_data(rows, fields, mysqlconexao);

		for (new i = 0; i < rows; i ++) if (i < MAX_HOUSES)
		{
		    HouseData[i][houseExiste] = 1;
		    
		    HouseData[i][houseID] = cache_get_field_int(i, "ID");
		    
		    HouseData[i][houseVWInterior] = cache_get_field_int(i, "MundoVirtualInterior");
		    HouseData[i][houseVWExterior] = cache_get_field_int(i, "MundoVirtualExterior");
		    HouseData[i][houseInterior] = cache_get_field_int(i, "Interior");
		    HouseData[i][houseExterior] = cache_get_field_int(i, "Exterior");
		    HouseData[i][housePreco] = cache_get_field_int(i, "Preco");
		    HouseData[i][houseTrancada] = cache_get_field_int(i, "Trancada");
		    HouseData[i][houseGaragemTrancada] = cache_get_field_int(i, "GaragemTrancada");
		    HouseData[i][houseDono] = cache_get_field_int(i, "Dono");
		    
		    cache_get_field_content(i, "DonoNome", HouseData[i][houseDonoNome]);
		    cache_get_field_content(i, "Endereco", HouseData[i][houseEndereco]);
		    
		    HouseData[i][housePos][0] = cache_get_field_float(i, "PosicaoX");
		    HouseData[i][housePos][1] = cache_get_field_float(i, "PosicaoY");
		    HouseData[i][housePos][2] = cache_get_field_float(i, "PosicaoZ");
		    HouseData[i][housePos][3] = cache_get_field_float(i, "PosicaoA");
		    HouseData[i][housePlacaPos][0] = cache_get_field_float(i, "PlacaX");
		    HouseData[i][housePlacaPos][1] = cache_get_field_float(i, "PlacaY");
		    HouseData[i][housePlacaPos][2] = cache_get_field_float(i, "PlacaZ");
		    HouseData[i][housePlacaPos][3] = cache_get_field_float(i, "PlacaA");
		    HouseData[i][houseGaragemPos][0] = cache_get_field_float(i, "GaragemX");
		    HouseData[i][houseGaragemPos][1] = cache_get_field_float(i, "GaragemY");
		    HouseData[i][houseGaragemPos][2] = cache_get_field_float(i, "GaragemZ");
		    HouseData[i][houseGaragemPos][3] = cache_get_field_float(i, "GaragemA");
  			HouseData[i][houseInt][0] = cache_get_field_float(i, "InteriorX");
		    HouseData[i][houseInt][1] = cache_get_field_float(i, "InteriorY");
		    HouseData[i][houseInt][2] = cache_get_field_float(i, "InteriorZ");
		    HouseData[i][houseInt][3] = cache_get_field_float(i, "InteriorA");
		    
		    HouseData[i][houseArmazenamentoArma][0] = cache_get_field_int(i, "Arma");
		    HouseData[i][houseArmazenamentoArma][1] = cache_get_field_int(i, "Arma2");
		    HouseData[i][houseArmazenamentoArma][2] = cache_get_field_int(i, "Arma3");
		    HouseData[i][houseArmazenamentoArma][3] = cache_get_field_int(i, "Arma4");
		    HouseData[i][houseArmazenamentoArma][4] = cache_get_field_int(i, "Arma5");
		    HouseData[i][houseArmazenamentoArma][5] = cache_get_field_int(i, "Arma6");
		    HouseData[i][houseArmazenamentoArma][6] = cache_get_field_int(i, "Arma7");
		    HouseData[i][houseArmazenamentoArma][7] = cache_get_field_int(i, "Arma8");
		    HouseData[i][houseArmazenamentoArma][8] = cache_get_field_int(i, "Arma9");
		    
		    HouseData[i][houseArmazenamentoBalas][0] = cache_get_field_int(i, "Balas");
		    HouseData[i][houseArmazenamentoBalas][1] = cache_get_field_int(i, "Balas2");
		    HouseData[i][houseArmazenamentoBalas][2] = cache_get_field_int(i, "Balas3");
		    HouseData[i][houseArmazenamentoBalas][3] = cache_get_field_int(i, "Balas4");
		    HouseData[i][houseArmazenamentoBalas][4] = cache_get_field_int(i, "Balas5");
		    HouseData[i][houseArmazenamentoBalas][5] = cache_get_field_int(i, "Balas6");
		    HouseData[i][houseArmazenamentoBalas][6] = cache_get_field_int(i, "Balas7");
		    HouseData[i][houseArmazenamentoBalas][7] = cache_get_field_int(i, "Balas8");
		    HouseData[i][houseArmazenamentoBalas][8] = cache_get_field_int(i, "Balas9");
		    
		    HouseData[i][houseOferecendo] = cache_get_field_int(i, "Oferecendo");
            cache_get_field_content(i, "AnuncioOferta", HouseData[i][houseOferecendoTexto]);
		    
			SQL_AtualizarCasa(i);
		}
	}
}

main()
{
	print("San Andreas County RolePlay ");
}

public OnGameModeInit()
{
	mysql_debug(1);
	mysqlconexao = mysql_connect(SQL_HOSTNAME, SQL_USERNAME, SQL_DATABASE, SQL_PASSWORD);
	if(mysqlconexao)
	{
	    printf("[SQL]: Conexão com \"%s\" bem sucedida.", SQL_HOSTNAME);
	}
	else if(!mysqlconexao)
	{
	    printf("[SQL]: Conexão com \"%s\" falhou! por favor verifique as configurações...", SQL_HOSTNAME);
	}
	SetGameModeText(SERVER_MODE);
	SendRconCommand(SERVER_NAME);
	
	DisableInteriorEnterExits();
	
	mysql_function_query(mysqlconexao, "SELECT * FROM `casas`", true, "q_rCarregarCasas", "");
	mysql_function_query(mysqlconexao, "SELECT * FROM `portas`", true, "q_rCarregarPortas", "");
	mysql_function_query(mysqlconexao, "SELECT * FROM `mobilias`", true, "q_rCarregarMobilias", "");
	
	//Interiores casas.
	CreateDynamicObject(14735, 338.21030, 1145.75769, 1084.50781,   0.00000, 0.00000, 0.00000);/* Crack den - 5 */
	
	Modelos_pPorta = LoadModelSelectionMenu("PortasModelos.txt");
	
	Modelos_fParedes = LoadModelSelectionMenu("ParedesModelos.txt");
	Modelos_fPortas = LoadModelSelectionMenu("PortasModelos2.txt");
	Modelos_fMoveis = LoadModelSelectionMenu("MoveisModelos.txt");
	Modelos_fObjetos = LoadModelSelectionMenu("ObjetosModelos.txt");
	
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(PlayerData[playerid][pVendoCasa] == true)
	{
	    new id = PlayerData[playerid][pIDCasaVendo];
	    SetPlayerCheckpoint(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2], 1.0);
	    return 1;
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == Modelos_pPorta && response)
	{
	    static
	        id;
	    SendServerMessage(playerid, "Modelo escolhido com sucesso.");
	    SendServerMessage(playerid, "Porta ID: %d, criada com sucesso.", id);
	    id = Criar_Porta(playerid, modelid);
	}
	if(listid == Modelos_fParedes && response)
	{
 		static
	        id;
	    SendServerMessage(playerid, "Modelo(parede) escolhido com sucesso.");
	    SendServerMessage(playerid, "Mobilia ID: %d, criada com sucesso.", id);
	    id = Criar_Mobilia(playerid, modelid);
	}
	if(listid == Modelos_fPortas && response)
	{
 		static
	        id;
	    SendServerMessage(playerid, "Modelo(porta) escolhido com sucesso.");
	    SendServerMessage(playerid, "Mobilia ID: %d, criada com sucesso.", id);
	    id = Criar_Mobilia(playerid, modelid);
	}
	if(listid == Modelos_fMoveis && response)
	{
 		static
	        id;
	    SendServerMessage(playerid, "Modelo(movel) escolhido com sucesso.");
	    SendServerMessage(playerid, "Mobilia ID: %d, criada com sucesso.", id);
	    id = Criar_Mobilia(playerid, modelid);
	}
	if(listid == Modelos_fObjetos && response)
	{
 		static
	        id;
	    SendServerMessage(playerid, "Modelo(objeto) escolhido com sucesso.");
	    SendServerMessage(playerid, "Mobilia ID: %d, criada com sucesso.", id);
	    id = Criar_Mobilia(playerid, modelid);
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	SetPlayerColor(playerid, -1);
    SQL_VerificarConta(playerid);
    
    //TextDraws !!
   	PlayerData[playerid][pTextdraws] = CreatePlayerTextDraw(playerid, 644.000000, 1.000000, "_");
	PlayerTextDrawBackgroundColor(playerid, PlayerData[playerid][pTextdraws], 255);
	PlayerTextDrawFont(playerid, PlayerData[playerid][pTextdraws], 1);
	PlayerTextDrawLetterSize(playerid, PlayerData[playerid][pTextdraws], 0.530000, 51.000000);
	PlayerTextDrawColor(playerid, PlayerData[playerid][pTextdraws], -1);
	PlayerTextDrawSetOutline(playerid, PlayerData[playerid][pTextdraws], 0);
	PlayerTextDrawSetProportional(playerid, PlayerData[playerid][pTextdraws], 1);
	PlayerTextDrawSetShadow(playerid, PlayerData[playerid][pTextdraws], 1);
	PlayerTextDrawUseBox(playerid, PlayerData[playerid][pTextdraws], 1);
	PlayerTextDrawBoxColor(playerid, PlayerData[playerid][pTextdraws], 119);
	PlayerTextDrawTextSize(playerid, PlayerData[playerid][pTextdraws], -6.000000, 30.000000);
	PlayerTextDrawSetSelectable(playerid, PlayerData[playerid][pTextdraws], 0);
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	SQL_SavePlayer(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	SetPlayerSkin(playerid, PlayerData[playerid][pSkin]);
	GivePlayerMoney(playerid, PlayerData[playerid][pDinheiro]);
	SetPlayerInterior(playerid, PlayerData[playerid][pD_Interior]);
	SetPlayerPos(playerid, PlayerData[playerid][pD_Pos][0], PlayerData[playerid][pD_Pos][1], PlayerData[playerid][pD_Pos][2]);
 	SetPlayerVirtualWorld(playerid, PlayerData[playerid][pD_MundoVirtual]);
	if(PlayerData[playerid][pD_Pos][0] == 0 && PlayerData[playerid][pD_Pos][1] == 0 && PlayerData[playerid][pD_Pos][2] == 0)
	{
	    SetPlayerPos(playerid, 2282.99, 23.8053, 26.4843);
	}
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	KillTimer(PlayerData[playerid][pTimerInterior]);
	PlayerData[playerid][pTimerInterior] = SetTimerEx("rOnPlayerChangeInterior",3000,false,"i",playerid);
	TogglePlayerControllable(playerid, 0);
	return 1;
}

public OnPlayerUpdate(playerid)
{
	static
	    id;
	if((id = Casa_Distancia(playerid)) != -1)
	{
	    if(PlayerData[playerid][pVendoCasa] == false)
	    {
			new str[534];
	    
			format(str, sizeof(str), "Endereço: %s  Proprietário: %s  ID: %d", HouseData[id][houseEndereco], HouseData[id][houseDonoNome], id);
			SendClientMessage(playerid, 0x006400FF, str);
	    
	        PlayerData[playerid][pVendoCasa] = true;
	        PlayerData[playerid][pIDCasaVendo] = id;
	        PlayerData[playerid][pTimerVendoCasa] = SetTimerEx("VerificarCasa",500,true,"i",playerid);
	        
	        SetPlayerCheckpoint(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2], 1.0);
	    }
	}
	if((id = Garagem_Distancia(playerid)) != -1)
	{
	    if(PlayerData[playerid][pVendoGaragem] == false)
	    {
			new str[534];

			format(str, sizeof(str), "Garagem: %s  Proprietário: %s  ID: %d", HouseData[id][houseEndereco], HouseData[id][houseDonoNome], id);
			SendClientMessage(playerid, 0x006400FF, str);

	        PlayerData[playerid][pVendoGaragem] = true;
	        PlayerData[playerid][pIDGaragemVendo] = id;
	        PlayerData[playerid][pTimerVendoGaragem] = SetTimerEx("VerificarGaragem",500,true,"i",playerid);

	        SetPlayerCheckpoint(playerid, HouseData[id][houseGaragemPos][0], HouseData[id][houseGaragemPos][1], HouseData[id][houseGaragemPos][2], 1.0);
	    }
	}
 	if(PlayerData[playerid][pBalasSobrando] == 0 && PlayerData[playerid][pUsarCartucho] == false)
  	{
        PlayerData[playerid][pUsarCartucho] = true;
        SetPlayerAttachedObject( playerid, INDEX_PLAYER_WEAPON, GetWeaponModel(PlayerData[playerid][pArmaUsando]), 6, 0.020773, 0.019853, 0.028769, 7.781971, 351.224060, 4.016965, 1.000000, 1.000000, 1.000000 );
	}
	if(GetPlayerMoney(playerid) != PlayerData[playerid][pDinheiro])
	{
	    GivePlayerMoney(playerid, -GetPlayerMoney(playerid));
	    GivePlayerMoney(playerid, PlayerData[playerid][pDinheiro]);
	}

    for (new i = 0; i != MAX_HOUSES; i ++) if( GetPlayerVirtualWorld(playerid) == HouseData[i][houseVWInterior] && GetPlayerInterior(playerid) == HouseData[i][houseInterior] && HouseData[i][houseExiste] && IsPlayerInRangeOfPoint(playerid, 30.0, HouseData[i][houseInt][0], HouseData[i][houseInt][1], HouseData[i][houseInt][2]))
    {
        if(HouseData[i][houseLuz] == 0) { PlayerTextDrawShow(playerid, PlayerData[playerid][pTextdraws]); }
        else if(HouseData[i][houseLuz] == 1) { PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws]); }
    }
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(RELEASED(KEY_FIRE))
	{
	    static
	        arma,
	        municao;

		for (new i = 0; i <= 12; i++)
		{
	        GetPlayerWeaponData(playerid, i, arma, municao);
	        if(arma == PlayerData[playerid][pArmaUsando])
	        {
	            PlayerData[playerid][pBalasSobrando] = municao;
	            SendServerMessage(playerid, "%d balas.", municao);
	            return i;
	        }
		}
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(response == 1)
	{
	    if(PlayerData[playerid][pEditandoPlaca])
	    {
			new houseid = PlayerData[playerid][pCasaEditando];
	        DestroyDynamicObject(HouseData[houseid][housePlaca]);
			HouseData[houseid][housePlacaPos][0] = x;
			HouseData[houseid][housePlacaPos][1] = y;
			HouseData[houseid][housePlacaPos][2] = z;
			HouseData[houseid][housePlacaPos][3] = rz;
	        PlayerData[playerid][pEditandoPlaca] = 0;
	        SQL_SalvarCasa(houseid);
			SQL_AtualizarCasa(houseid);
	        return SendServerMessage(playerid, "Placa editada com sucesso.");
	    }
	    if(PlayerData[playerid][pEditandoPorta])
	    {
	        new doorid = PlayerData[playerid][pPortaEditando];
	        DoorData[doorid][doorPos][0] = x;
	        DoorData[doorid][doorPos][1] = y;
	        DoorData[doorid][doorPos][2] = z;
	        DoorData[doorid][doorPos][3] = rz;
	        PlayerData[playerid][pEditandoPorta] = 0;
	        SQL_SalvarPorta(doorid);
			SQL_AtualizarPorta(doorid);
	        return SendServerMessage(playerid, "Porta editada com sucesso.");
	    }
	    if(PlayerData[playerid][pEditandoMovel])
	    {
     		new furnitureid = PlayerData[playerid][pMovelEditando];
	        FurnitureData[furnitureid][fPos][0] = x;
	        FurnitureData[furnitureid][fPos][1] = y;
	        FurnitureData[furnitureid][fPos][2] = z;
	        FurnitureData[furnitureid][fPos][3] = rx;
	        FurnitureData[furnitureid][fPos][4] = ry;
	        FurnitureData[furnitureid][fPos][5] = rz;
	        PlayerData[playerid][pEditandoMovel] = 0;
	        SQL_SalvarMovel(furnitureid);
			SQL_AtualizarMovel(furnitureid);
	        return SendServerMessage(playerid, "Mobilia editada com sucesso.");
	    }
	}
	else if(response == 0) {
	
 		if(PlayerData[playerid][pEditandoPlaca])
	    {
	        new houseid = PlayerData[playerid][pCasaEditando];
            return EditDynamicObject(playerid, HouseData[houseid][housePlaca]);
	    }
 		if(PlayerData[playerid][pEditandoPorta])
	    {
	        new doorid = PlayerData[playerid][pPortaEditando];
	        return EditDynamicObject(playerid, DoorData[doorid][doorObject]);
	    }
   		if(PlayerData[playerid][pEditandoMovel])
	    {
	        new furnitureid = PlayerData[playerid][pMovelEditando];
	        return EditDynamicObject(playerid, FurnitureData[furnitureid][fObject]);
	    }
	}
	return 1;
}

forward rOnPlayerChangeInterior(playerid);
public rOnPlayerChangeInterior(playerid)
{
    KillTimer(PlayerData[playerid][pTimerInterior]);
    TogglePlayerControllable(playerid, 1);
    return 1;
}

Dialog:AccountLogin(playerid, response, listitem, inputtext[])
{
	//if(!response) return Kick(playerid);
	if(response)
	{
	    new query[1054];
	    format(query, sizeof(query), "SELECT * FROM `contas` WHERE `Usuario` = '%s' AND `Senha` = '%s'", ReturnName(playerid), inputtext);
	    mysql_function_query(mysqlconexao, query, true, "q_rVerificarSenha", "d", playerid);
	}
	return 1;
}

Dialog:ModelosMobilia(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		switch(listitem)
		{
		    case 0:
		    {
		        ShowModelSelectionMenu(playerid, Modelos_fParedes, "Modelos", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
		    }
		    case 1:
		    {
                ShowModelSelectionMenu(playerid, Modelos_fPortas, "Modelos", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
		    }
		    case 2:
		    {
                ShowModelSelectionMenu(playerid, Modelos_fMoveis, "Modelos", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
		    }
		    case 3:
		    {
                ShowModelSelectionMenu(playerid, Modelos_fObjetos, "Modelos", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
		    }
		}
	}
	return 1;
}

Dialog:MobiliaDinheiro2(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    if(PlayerData[playerid][pDinheiroMobilia] == 1)
	    {
   			static
	        	id;

	 		if((id = Mobilia_Proxima(playerid)) != -1)
	 		{
				static
					houseid;
				houseid = Casa_InteriorProximo(playerid);
	 		    if(FurnitureData[id][fHouseID] == houseid)
	    		{
	    		    if(FurnitureData[id][fArmazenamento][0] >= strval(inputtext))
	    		    {
	    		        PlayerData[playerid][pDinheiro] += strval(inputtext);
	    		        FurnitureData[id][fArmazenamento][0] -= strval(inputtext);
	    		        return 1;
	    		    }
	    		    return SendErrorMessage(playerid, "O valor digitado não existe na mobilia.");
	    		}
				return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
			}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	    }
	    if(PlayerData[playerid][pDinheiroMobilia] == 2)
	    {
   			static
	        	id;

	 		if((id = Mobilia_Proxima(playerid)) != -1)
	 		{
				static
					houseid;
				houseid = Casa_InteriorProximo(playerid);
	 		    if(FurnitureData[id][fHouseID] == houseid)
	    		{
					if(PlayerData[playerid][pDinheiro] >= strval(inputtext))
					{
					    PlayerData[playerid][pDinheiro] -= strval(inputtext);
					    FurnitureData[id][fArmazenamento][0] += strval(inputtext);
					    return 1;
					}
					return SendErrorMessage(playerid, "Você não tem esta quantia.");
	    		}
				return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
			}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	    }
	}
	return 1;
}

Dialog:MobiliaDinheiro(playerid, response, listitem, inputtext[])
{

	if(listitem == 1)
	    return 1;
	    
	if(response == 1)
	{
 		static
	        id;

 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(FurnitureData[id][fArmazenamento][0] > 0)
    		    {
    		        PlayerData[playerid][pDinheiroMobilia] = 1;
                    Dialog_Show(playerid, MobiliaDinheiro2, DIALOG_STYLE_INPUT, "Mobilia - Armazenamento", " Digite o valor que deseja retirar ", "Retirar", "Cancelar");
					return 1;
				}
				return SendErrorMessage(playerid, "Slot vazio.");
    		}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	if(response == 0)
	{
		static
	        id;

 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(PlayerData[playerid][pDinheiro] > 0)
    		    {
    		        PlayerData[playerid][pDinheiroMobilia] = 2;
                    Dialog_Show(playerid, MobiliaDinheiro2, DIALOG_STYLE_INPUT, "Mobilia - Armazenamento", " Digite o valor que deseja armazenar ", "Armazenar", "Cancelar");
					return 1;
				}
				return SendErrorMessage(playerid, "Você não tem dinheiro para realizar esta ação.");
    		}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	return 1;
}

Dialog:MobiliaArma(playerid, response, listitem, inputtext[])
{
	listitem += 1;
	static
		lista;
		
	lista = listitem;
	
	if(lista == 10)
	    return 1;
	
	if(response == 1)
	{
	    static
	        id;
	
 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(FurnitureData[id][fArmazenamento][lista] > 0)
    		    {
    		        GiveWeapon(playerid, FurnitureData[id][fArmazenamento][lista], FurnitureData[id][fArmazenamentoBalas][lista]);
    		        FurnitureData[id][fArmazenamento][lista] = 0;
    		        FurnitureData[id][fArmazenamentoBalas][lista] = 0;
    		        return 1;
    		    }
				return SendErrorMessage(playerid, "O slot selecionado esta vazio.");
    		}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	if(response == 0)
	{
	    static
	        id;

 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(FurnitureData[id][fArmazenamento][lista] == 0)
    		    {
					if(GetPlayerWeapon(playerid) > 0)
					{
					    FurnitureData[id][fArmazenamento][lista] = GetPlayerWeapon(playerid);
					    FurnitureData[id][fArmazenamentoBalas][lista] = GetPlayerAmmo(playerid);
					    RemovePlayerWeapon(playerid, GetPlayerWeapon(playerid));
					    return 1;
					}
					return SendErrorMessage(playerid, "Você não tem nenhuma arma em mãos.");
    		    }
				return SendErrorMessage(playerid, "O slot selecionado esta ocupado.");
    		}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	return 1;
}

Dialog:CasaArmazenamento(playerid, response, listitem, inputtext[])
{
	static
		lista;

	lista = listitem;

	if(lista == 9)
	    return 1;

	if(response == 1)
	{
	    static
	        id;

 		if((id = Casa_InteriorProximo(playerid)) != -1)
 		{
 		    if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
    		{
       		 	if(HouseData[id][houseArmazenamentoArma][lista] > 0)
		        {
    		        GiveWeapon(playerid, HouseData[id][houseArmazenamentoArma][lista], HouseData[id][houseArmazenamentoBalas][lista]);
    		        HouseData[id][houseArmazenamentoArma][lista] = 0;
    		        HouseData[id][houseArmazenamentoBalas][lista] = 0;
    		        return 1;
    		    }
				return SendErrorMessage(playerid, "O slot selecionado esta vazio.");
    		}
			return SendErrorMessage(playerid, "Você não é proprietario desta casa.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma casa.");
	}
	if(response == 0)
	{
	    static
	        id;

 		if((id = Casa_InteriorProximo(playerid)) != -1)
 		{
 		    if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
    		{
    		    if(HouseData[id][houseArmazenamentoArma][lista] == 0)
    		    {
					if(GetPlayerWeapon(playerid) > 0)
					{
					    HouseData[id][houseArmazenamentoArma][lista] = GetPlayerWeapon(playerid);
					    HouseData[id][houseArmazenamentoBalas][lista] = GetPlayerAmmo(playerid);
					    RemovePlayerWeapon(playerid, GetPlayerWeapon(playerid));
					    return 1;
					}
					return SendErrorMessage(playerid, "Você não tem nenhuma arma em mãos.");
    		    }
				return SendErrorMessage(playerid, "O slot selecionado esta ocupado.");
    		}
			return SendErrorMessage(playerid, "Você não é proprietario desta casa.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma casa.");
	}
	return 1;
}

Dialog:AnunciarCasa(playerid, response, listitem, inputtext[])
{
	if(response)
	{
	    static
	        id;
	
		if((id = Casa_Distancia(playerid)) != -1)
	    {
	        if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
	        {
				if(strlen(inputtext) > 54){
    				return SendErrorMessage(playerid, "Use no maximo 54 caracteres!");
				}

				format(HouseData[id][houseOferecendoTexto], 54, inputtext);
				HouseData[id][houseOferecendo] = 1;
	    		SQL_SalvarCasa(id);
	    		SQL_AtualizarCasa(id);
				return SendServerMessage(playerid, "Você colocou sua casa a oferta.");
	        }
	        return SendErrorMessage(playerid, "Você não é o proprietario desta casa.");
	    }
	    return SendErrorMessage(playerid, "Você não esta perto de uma porta.");
	}
	return 1;
}

CMD:criarcasa(playerid, params[])
{
	static
	    preco,
	    id,
	    endereco[54];

	if(PlayerData[playerid][pAdministrador] < 5)
	    return SendErrorMessage(playerid, "Você não pode usar este comando.");

 	if (sscanf(params, "ds[32]", preco, endereco)){
	    return SendSyntaxMessage(playerid, "/criarcasa [preço] [endereço]");
	}
 	id = Casa_Criar(playerid, endereco, preco);
  	PlayerData[playerid][pVendoCasa] = true;
   	PlayerData[playerid][pIDCasaVendo] = id;
    PlayerData[playerid][pTimerVendoCasa] = SetTimerEx("VerificarCasa",500,true,"i",playerid);
 	SendServerMessage(playerid, "Casa ID: %d, criada com sucesso.", id);
 	
	GetPlayerPos(playerid, HouseData[id][housePlacaPos][0], HouseData[id][housePlacaPos][1], HouseData[id][housePlacaPos][2]);
	GetPlayerFacingAngle(playerid, HouseData[id][housePlacaPos][3]);
	SetPlayerPos(playerid, HouseData[id][housePlacaPos][0]+2, HouseData[id][housePlacaPos][1], HouseData[id][housePlacaPos][2]);
	SQL_AtualizarCasa(id);
	EditDynamicObject(playerid, HouseData[id][housePlaca]);
	PlayerData[playerid][pEditandoPlaca] = 1;
	SendServerMessage(playerid, "Edite a placa e apos isso clique em salvar.");
	PlayerData[playerid][pCasaEditando] = id;
	return 1;
}

CMD:editarcasa(playerid, params[])
{
	static
	    id,
	    tipo[24];

	if (PlayerData[playerid][pAdministrador] < 5)
	    return SendErrorMessage(playerid, "Você não tem permissão para utilizar este comando.");

	if (sscanf(params, "ds[24]", id, tipo))
 	{
	 	SendSyntaxMessage(playerid, "/editarcasa [id] [nome]");
	    SendClientMessage(playerid, COLOR_ORANGE, "[NOMES]:{FFFFFF} posicao, placa, garagem");
		return 1;
	}
	if (!HouseData[id][houseExiste])
	    return SendErrorMessage(playerid, "Você colocou um ID invalido.");
	    
	if (!strcmp(tipo, "posicao", true))
	{
		GetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][housePos][3]);

		HouseData[id][houseExterior] = GetPlayerInterior(playerid);
		SQL_SalvarCasa(id);
		SendServerMessage(playerid, "Casa ID %d editada com sucesso.", id);
		return 1;
	}
	if (!strcmp(tipo, "placa", true))
	{
	    if(PlayerData[playerid][pEditandoPlaca])
	        return SendErrorMessage(playerid, "Você já esta editando uma placa.");
	        
		GetPlayerPos(playerid, HouseData[id][housePlacaPos][0], HouseData[id][housePlacaPos][1], HouseData[id][housePlacaPos][2]);
		GetPlayerFacingAngle(playerid, HouseData[id][housePlacaPos][3]);
		SetPlayerPos(playerid, HouseData[id][housePlacaPos][0]+2, HouseData[id][housePlacaPos][1], HouseData[id][housePlacaPos][2]);
		SQL_AtualizarCasa(id);
		EditDynamicObject(playerid, HouseData[id][housePlaca]);
		PlayerData[playerid][pEditandoPlaca] = 1;
		SendServerMessage(playerid, "Edite a placa e apos isso clique em salvar.");
		PlayerData[playerid][pCasaEditando] = id;
		return 1;
	}
	if (!strcmp(tipo, "garagem", true))
	{
	    GetPlayerPos(playerid, HouseData[id][houseGaragemPos][0], HouseData[id][houseGaragemPos][1], HouseData[id][houseGaragemPos][2]);
	    GetPlayerFacingAngle(playerid, HouseData[id][houseGaragemPos][3]);
	    SQL_SalvarCasa(id);
	    return SendServerMessage(playerid, "Garagem editada com sucesso.");
	}
	return 1;
}

CMD:salvar(playerid, params[])
{
	return SQL_SavePlayer(playerid);
}

CMD:mobilia(playerid, params[])
{
	static
	    id;
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/mobilia [nome]");
	    SendClientMessage(playerid, COLOR_ORANGE, "[NOMES]:{FFFFFF} criar, editar, armas");
		return 1;
	}
	if (!strcmp(params, "criar", true))
	{
 		if((id = Casa_InteriorProximo(playerid)) != -1)
 		{
 		    if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
    		{
    		    PlayerData[playerid][pMovelHouse] = id;
    		    Dialog_Show(playerid, ModelosMobilia, DIALOG_STYLE_LIST, "Tipo", " - Paredes\n - Portas\n - Moveis\n - Objetos em geral", "Selecionar", "Cancelar");
				return 1;
			}
			return SendErrorMessage(playerid, "Você não esta dentro da sua casa.");
		}
		return SendErrorMessage(playerid, "Você não esta dentro de uma propriedade.");
	}
	if (!strcmp(params, "editar", true))
	{
 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(HouseData[houseid][houseDono] == GetPlayerSQLID(playerid))
    		    {
				    EditDynamicObject(playerid, FurnitureData[id][fObject]);

			 		SendServerMessage(playerid, "Edite a mobilia, apos terminar clique em salvar.");

					PlayerData[playerid][pEditandoMovel] = 1;
			  		PlayerData[playerid][pMovelEditando] = id;
			  		return 1;
				}
				return SendErrorMessage(playerid, "Você não é dono desta casa pra mecher nesta mobilia.");
			}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	if (!strcmp(params, "dinheiro", true))
	{
 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(HouseData[houseid][houseDono] == GetPlayerSQLID(playerid))
    		    {
    		        if(FurnitureData[id][fModel] == 936)
    		        {
    		            new
    		                string[500];

						string = "Dinheiro\n";

						if(FurnitureData[id][fArmazenamento][0] <= 0)
							format(string, sizeof(string), "%sVazio", string);

						if(FurnitureData[id][fArmazenamento][0] > 0)
							format(string, sizeof(string), "%s$%d", string, FurnitureData[id][fArmazenamento][0]);

						format(string, sizeof(string), "%s\nSair", string);
    		            Dialog_Show(playerid, MobiliaDinheiro, DIALOG_STYLE_TABLIST_HEADERS, "Mobilia - Armazenamento", string, "Pegar", "Guardar");
						return 1;
					}
					return SendErrorMessage(playerid, "Você não esta perto de uma mobilia que possa armazenar dinheiro.");
    		    }
				return SendErrorMessage(playerid, "Você não é dono desta casa pra mecher nesta mobilia.");
			}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	if (!strcmp(params, "armas", true))
	{
 		if((id = Mobilia_Proxima(playerid)) != -1)
 		{
			static
				houseid;
			houseid = Casa_InteriorProximo(playerid);
 		    if(FurnitureData[id][fHouseID] == houseid)
    		{
    		    if(HouseData[houseid][houseDono] == GetPlayerSQLID(playerid))
    		    {
    		        if(FurnitureData[id][fModel] == 936)
    		        {
	      				new slotsfurniture;
	    		        slotsfurniture = 10;

						new
						    string [500];
						string = "Arma\tBalas\n";
	              		for (new i = 1; i < slotsfurniture; i ++)
	    		        {
	    		            if(!FurnitureData[id][fArmazenamento][i])
	    		                format(string, sizeof(string), "%sNenhuma\t0 Balas\n", string);

							if(FurnitureData[id][fArmazenamento][i])
							    format(string, sizeof(string), "%s%s\t%d balas.\n", string, ReturnWeaponName(FurnitureData[id][fArmazenamento][i]), FurnitureData[id][fArmazenamentoBalas][i]);
	    		        }
	    		        format(string, sizeof(string), "%sSair", string);
	    		        Dialog_Show(playerid, MobiliaArma, DIALOG_STYLE_TABLIST_HEADERS, "Mobilia - Armazenamento", string, "Pegar", "Guardar");
						return 1;
					}
					return SendErrorMessage(playerid, "Você não esta perto de uma mobilia que possa armazenar armas.");
    		    }
				return SendErrorMessage(playerid, "Você não é dono desta casa pra mecher nesta mobilia.");
			}
			return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia valida.");
		}
		return SendErrorMessage(playerid, "Você não esta proximo de nenhuma mobilia.");
	}
	return 1;
}

CMD:porta(playerid, params[])
{
	static
	    id;
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/porta [nome]");
	    SendClientMessage(playerid, COLOR_ORANGE, "[NOMES]:{FFFFFF} criar, abrir, fechar, editar");
		return 1;
	}
	if (!strcmp(params, "criar", true))
	{
	    if((id = Casa_InteriorProximo(playerid)) != -1)
 		{
 		    if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
    		{
	  			SendServerMessage(playerid, "Escolha um modelo de porta.");
		    	ShowModelSelectionMenu(playerid, Modelos_pPorta, "Modelos", 0x4A5A6BBB, 0x88888899, 0xFFFF00AA);
				return 1;
			}
			return SendErrorMessage(playerid, "Você não esta dentro da sua casa.");
		}
		return SendErrorMessage(playerid, "Você não esta dentro de uma propriedade.");
	}
	if (!strcmp(params, "abrir", true))
	{
		if((id = Porta_Proxima(playerid)) != -1)
		{
    	    if(GetPlayerSQLID(playerid) == DoorData[id][doorDono])
    	    {
    	        if(DoorData[id][doorAberta] == 0)
    	        {
		  			SendServerMessage(playerid, "Porta aberta.");
					SetDynamicObjectRot(DoorData[id][doorObject], 0.0, 0.0, DoorData[id][doorPos][3]+90);
					DoorData[id][doorAberta] = 1;
					SQL_SalvarPorta(id);
					return 1;
				}
				return SendErrorMessage(playerid, "Esta porta já esta aberta.");
			}
			return SendErrorMessage(playerid, "Você não tem as chaves desta porta.");
		}
		return SendErrorMessage(playerid, "Você não esta perto de uma porta.");
    }
   	if (!strcmp(params, "fechar", true))
	{
		if((id = Porta_Proxima(playerid)) != -1)
		{
    	    if(DoorData[id][doorDono] == GetPlayerSQLID(playerid))
    	    {
    	        if(DoorData[id][doorAberta] == 1)
    	        {
		  			SendServerMessage(playerid, "Porta fechada.");
					SetDynamicObjectRot(DoorData[id][doorObject], 0.0, 0.0, DoorData[id][doorPos][3]);
					DoorData[id][doorAberta] = 0;
					SQL_SalvarPorta(id);
					return 1;
				}
				return SendErrorMessage(playerid, "Esta porta já esta fechada.");
			}
			return SendErrorMessage(playerid, "Você não tem as chaves desta porta.");
		}
		return SendErrorMessage(playerid, "Você não esta perto de uma porta.");
    }
   	if (!strcmp(params, "editar", true))
	{
		if((id = Porta_Proxima(playerid)) != -1)
		{
    	    if(DoorData[id][doorDono] == GetPlayerSQLID(playerid))
    	    {
				EditDynamicObject(playerid, DoorData[id][doorObject]);

		        SendServerMessage(playerid, "Edite a porta, apos terminar clique em salvar.");

		        PlayerData[playerid][pEditandoPorta] = 1;
		        PlayerData[playerid][pPortaEditando] = id;
		        return 1;
  			}
			return SendErrorMessage(playerid, "Você não tem as chaves desta porta.");
		}
		return SendErrorMessage(playerid, "Você não esta perto de uma porta.");
	}
    return SendErrorMessage(playerid, "Você não esta perto de nada.");
}

CMD:casa(playerid, params[])
{
   	static
	    id;
	if (isnull(params))
 	{
	 	SendSyntaxMessage(playerid, "/casa [nome]");
	    SendClientMessage(playerid, COLOR_ORANGE, "[NOMES]:{FFFFFF} interruptor, trancar, armazenamento");
		return 1;
	}
	if (!strcmp(params, "interruptor", true))
	{
	    if((id = Casa_InteriorProximo(playerid)) != -1)
	    {
     		if(HouseData[id][houseLuz] == 0)
			{
				HouseData[id][houseLuz] = 1;
				SendServerMessage(playerid, "Luzes acesas.");
				return 1;
			}
   			if(HouseData[id][houseLuz] == 1)
			{
				HouseData[id][houseLuz] = 0;
				SendServerMessage(playerid, "Luzes apagadas.");
				return 1;
			}
	    }
	    return SendErrorMessage(playerid, "Você não esta perto de um interruptor.");
	}
	if (!strcmp(params, "trancar", true))
	{
		if((id = Casa_Distancia(playerid)) != -1)
	    {
	        if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
	        {
	            if(HouseData[id][houseTrancada] == 0)
				{
					HouseData[id][houseTrancada] = 1;
					SendServerMessage(playerid, "Portas trancadas.");
					return 1;
				}
	            if(HouseData[id][houseTrancada] == 1)
				{
					HouseData[id][houseTrancada] = 0;
					SendServerMessage(playerid, "Portas abertas.");
					return 1;
				}
	        }
	        return SendErrorMessage(playerid, "Você não é o proprietario desta casa.");
	    }
   		if((id = Garagem_Distancia(playerid)) != -1)
	    {
     		if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
	        {
	            if(HouseData[id][houseGaragemTrancada] == 0)
				{
					HouseData[id][houseGaragemTrancada] = 1;
					SendServerMessage(playerid, "Garagem trancada.");
					return 1;
				}
	            if(HouseData[id][houseGaragemTrancada] == 1)
				{
					HouseData[id][houseGaragemTrancada] = 0;
					SendServerMessage(playerid, "Garagem aberta.");
					return 1;
				}
	        }
	        return SendErrorMessage(playerid, "Você não é o proprietario desta casa.");
	    }
	    return SendErrorMessage(playerid, "Você não esta perto de uma porta.");
	}
	if (!strcmp(params, "armazenamento", true))
	{
 		if((id = Casa_InteriorProximo(playerid)) != -1)
	    {
     		if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
	        {
				new
			    	string [500];
			    	
				string = "Arma\tBalas\n";
				
    			for (new i = 0; i < 9; i ++)
      			{
 		            if(!HouseData[id][houseArmazenamentoArma][i])
               			format(string, sizeof(string), "%sNenhuma\t0 Balas\n", string);

					if(HouseData[id][houseArmazenamentoArma][i])
	    				format(string, sizeof(string), "%s%s\t%d balas.\n", string, ReturnWeaponName(HouseData[id][houseArmazenamentoArma][i]), HouseData[id][houseArmazenamentoBalas][i]);
 		        }
 		        format(string, sizeof(string), "%sSair", string);
 		        Dialog_Show(playerid, CasaArmazenamento, DIALOG_STYLE_TABLIST_HEADERS, "Armazenamento", string, "Pegar", "Guardar");
				return 1;
			}
	        return SendErrorMessage(playerid, "Você não é o proprietario desta casa.");
		}
		return SendErrorMessage(playerid, "Você não esta dentro de uma casa.");
	}
	if (!strcmp(params, "anunciar", true))
	{
		if((id = Casa_Distancia(playerid)) != -1)
	    {
	        if(HouseData[id][houseDono] == GetPlayerSQLID(playerid))
	        {
	            if(HouseData[id][houseOferecendo] == 0)
	            {
                    Dialog_Show(playerid, AnunciarCasa, DIALOG_STYLE_INPUT, "Anunciamento - Propriedade", " Digite um anuncio com no maximo 54 caracteres. ", "Anunciar", "Cancelar");
					return 1;
				}
				if(HouseData[id][houseOferecendo] == 1)
				{
				    HouseData[id][houseOferecendo] = 0;
				    SQL_SalvarCasa(id);
				    SQL_AtualizarCasa(id);
				    return SendServerMessage(playerid, "Você retirou sua casa de oferta.");
				}
			}
			return SendErrorMessage(playerid, "Você não é o proprietario desta casa.");
		}
		return SendErrorMessage(playerid, "Você não esta na porta de nenhuma propriedade.");
	}
    return 1;
}

CMD:comprar(playerid, params[])
{
	static
	    id;
    if((id = Casa_Distancia(playerid)) != -1)
    {
        if(HouseData[id][houseDono] == 0 && HouseData[id][houseExiste])
        {
            HouseData[id][houseDono] = GetPlayerSQLID(playerid);
            format(HouseData[id][houseDonoNome], 32, ReturnName(playerid));
            SQL_SalvarCasa(id);
			SQL_AtualizarCasa(id);
			PlayerData[playerid][pDinheiro] -= HouseData[id][housePreco];
			return SendServerMessage(playerid, "Você comprou esta propriedade por $%d",HouseData[id][housePreco]);
        }
        return SendErrorMessage(playerid, "Esta propriedade já tem um proprietario.");
    }
    return SendErrorMessage(playerid, "Você não esta perto de nada.");
}

CMD:entrar(playerid, params[])
{
	static
	    id;
    if((id = Casa_Distancia(playerid)) != -1)
    {
		if(HouseData[id][houseTrancada] == 0)
		{
		    SetPlayerPos(playerid, HouseData[id][houseInt][0], HouseData[id][houseInt][1], HouseData[id][houseInt][2]);
		    SetPlayerFacingAngle(playerid, HouseData[id][houseInt][3]);
		    SetPlayerInterior(playerid, HouseData[id][houseInterior]);
		    SetPlayerVirtualWorld(playerid, HouseData[id][houseVWInterior]);
		    return 1;
		}
		return SendErrorMessage(playerid, "Esta propriedade esta trancada.");
    }
    if((id = Garagem_Distancia(playerid)) != -1)
    {
  		if(HouseData[id][houseGaragemTrancada] == 0)
		{
		    SetPlayerVirtualWorld(playerid, HouseData[id][houseVWInterior]);
  			if(IsPlayerInAnyVehicle(playerid))
	        {
	            SetVehiclePos(GetPlayerVehicleID(playerid), 1644.0980, -1516.0828, 13.6757);
	            SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), HouseData[id][houseVWInterior]);
	            SetVehicleZAngle(GetPlayerVehicleID(playerid), 1.8058);
	            PlayerData[playerid][pGaragemEntrou] = id;
	            return 1;
	        }
		    SetPlayerPos(playerid, 1643.9777, -1519.6318, 13.5674);
		    PlayerData[playerid][pGaragemEntrou] = id;
		    return 1;
		}
		return SendErrorMessage(playerid, "Esta entrada esta trancada.");
  	}
    return SendErrorMessage(playerid, "Você não esta perto de nada.");
}

CMD:sair(playerid, params[])
{
	static
	    id;
    if((id = Casa_InteriorPorta(playerid)) != -1)
    {
		if(HouseData[id][houseTrancada] == 0)
		{
		    SetPlayerPos(playerid, HouseData[id][housePos][0], HouseData[id][housePos][1], HouseData[id][housePos][2]);
		    SetPlayerFacingAngle(playerid, HouseData[id][housePos][3]);
		    SetPlayerInterior(playerid, HouseData[id][houseExterior]);
		    SetPlayerVirtualWorld(playerid, 0);
		    PlayerTextDrawHide(playerid, PlayerData[playerid][pTextdraws]);
		    PlayerData[playerid][pVendoCasa] = true;
		    PlayerData[playerid][pIDCasaVendo] = id;
		    PlayerData[playerid][pTimerVendoCasa] = SetTimerEx("VerificarCasa",500,true,"i",playerid);
		    return 1;
		}
		return SendErrorMessage(playerid, "Esta propriedade esta trancada.");
    }
    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1643.9777, -1519.6318, 13.5674))
    {
        id = PlayerData[playerid][pGaragemEntrou];
        SetPlayerVirtualWorld(playerid, HouseData[id][houseVWExterior]);
        SetPlayerPos(playerid, HouseData[id][houseGaragemPos][0], HouseData[id][houseGaragemPos][1], HouseData[id][houseGaragemPos][2]);
        SetPlayerFacingAngle(playerid, HouseData[id][houseGaragemPos][3]);
    	PlayerData[playerid][pVendoGaragem] = true;
	    PlayerData[playerid][pIDGaragemVendo] = id;
	    PlayerData[playerid][pTimerVendoGaragem] = SetTimerEx("VerificarCasa",500,true,"i",playerid);
        if(IsPlayerInAnyVehicle(playerid))
        {
            SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), HouseData[id][houseVWExterior]);
            SetVehiclePos(GetPlayerVehicleID(playerid), HouseData[id][houseGaragemPos][0]+6, HouseData[id][houseGaragemPos][1], HouseData[id][houseGaragemPos][2]);
            SetVehicleZAngle(GetPlayerVehicleID(playerid), HouseData[id][houseGaragemPos][3]);
			return 1;
        }
        return 1;
    }
    return SendErrorMessage(playerid, "Você não esta perto de nada.");
}

CMD:dararma(playerid, params[])
{
	static
	    id,
	    balas;
	if (sscanf(params, "dd", id, balas))
 	{
		return SendSyntaxMessage(playerid, "/dararma [arma] [balas]");
 	}
	GiveWeapon(playerid, id, balas);
	SendServerMessage(playerid, "Você recebeu uma %s com %d balas", ReturnWeaponName(id), balas);
	return 1;
}

CMD:carregar(playerid, params[])
{

	if(PlayerData[playerid][pUsarCartucho] != true)
	    return SendErrorMessage(playerid, "Você não pode carregar agora.");
	    
	if(PlayerData[playerid][pBalas] <= 0)
	    return SendErrorMessage(playerid, "Você não tem mais balas para esta arma.");
	    
	if(PlayerData[playerid][pBalasSobrando] != 0)
	    return SendErrorMessage(playerid, "Você já tem balas carregadas.");
	    

	RemovePlayerAttachedObject(playerid, INDEX_PLAYER_WEAPON);
	PlayerData[playerid][pBalasSobrando] = 7;
	PlayerData[playerid][pBalas] -= 7;
	PlayerData[playerid][pUsarCartucho] = false;
	GivePlayerWeapon(playerid, PlayerData[playerid][pArmaUsando], PlayerData[playerid][pBalasSobrando]);
	PlayReloadAnimation(playerid, PlayerData[playerid][pArmaUsando]);
	SendServerMessage(playerid, "Sobrando %d balas.", PlayerData[playerid][pBalas]);
	return 1;
}

CMD:gmx(playerid, params[])
{
    SendRconCommand("gmx");
	return 1;
}

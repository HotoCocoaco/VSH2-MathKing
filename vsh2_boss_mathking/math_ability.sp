#define PLUS				"+"
#define MINUS				"-"
#define DIVISOR				"/"
#define MULTIPLE			"*"

bool inQuizz[MAXPLAYERS+1];

char op[MAXPLAYERS+1][32];
char operators[4][5] = {"+", "-", "/", "*"};

int nbrmin = 1;
int nbrmax = 100;
int questionResult[MAXPLAYERS+1];

int number1[MAXPLAYERS+1];
int number2[MAXPLAYERS+1];

float MathKing_Rage_Lastused;
float MathKing_Rage_TimeLimit;

VSH2Player MathKingPlayer;


void Math_Register()
{
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");

	Math_ResetInQuizzState();
}

void Math_ResetInQuizzState()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		inQuizz[i] = false;
	}
}

void Math_DoRage(VSH2Player player)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && IsPlayerAlive(i))
		{
			inQuizz[i] = true;
			CreateQuestionForClient(i);
			FreezeClientInput(i);
		}
	}

	MathKing_Rage_Lastused = GetGameTime();
	MathKingPlayer = player;
	gMathKing.cfg.GetFloat("boss.rage.timelimit", MathKing_Rage_TimeLimit);
	gMathKing.cfg.GetInt("boss.rage.nbrmin", nbrmin);
	gMathKing.cfg.GetInt("boss.rage.nbrmax", nbrmax);
}

void GenerateNumberForClient(int client)
{
	number1[client] = GetRandomInt(nbrmin, nbrmax);
	number2[client] = GetRandomInt(nbrmin, nbrmax);
}

void CreateQuestionForClient(int client)
{
	int tmp = GetRandomInt(0, 3);
	Format(op[client], sizeof(op), "%s", operators[tmp]);

	if (StrEqual(op[client], PLUS))
	{
		GenerateNumberForClient(client);
		questionResult[client] = number1[client] + number2[client];
	}
	else if (StrEqual(op[client], MINUS))
	{
		do
		{
			GenerateNumberForClient(client);
		}
		while(number1[client] % number2[client] != 0);
		questionResult[client] = number1[client] - number2[client];
	}
	else if (StrEqual(op[client], DIVISOR))
	{
		do
		{
			GenerateNumberForClient(client);
		}
		while(number1[client] % number2[client] != 0);
		questionResult[client] = number1[client] / number2[client];
	}
	else if (StrEqual(op[client], MULTIPLE))
	{
		GenerateNumberForClient(client);
		questionResult[client] = number1[client] * number2[client];
	}

	CPrintToChat(client, "{unique}[MathKing] {default}Math Quiz：%i %s %i = ?", number1[client], op[client], number2[client]);
	PrintCenterText(client, "%i %s %i = ?", number1[client], op[client], number2[client]);
}

Action Command_Say(int client, const char[] command, int args)
{
	if (inQuizz[client])
	{
		char str[128];
		GetCmdArg(1, str, sizeof(str));
		int number = StringToInt(str);
		int len = strlen(str);
		for(int i = 0; i < len; i++)
		{
			if (!IsCharNumeric(str[i]))
				return Plugin_Continue;
		}

		if (ProcessSolution(client, number))
		{
			Math_ClientWin(client);
		}
		else
		{
			Math_ClientLose(client);
		}
	}

	return Plugin_Continue;
}

void Math_ClientWin(int client)
{
	inQuizz[client] = false;

	if (IsClientInGame(client) && IsPlayerAlive(client))
	{
		UnFreezeClientInput(client);
		CPrintToChat(client, "{unique}[MathKing] {default}You just finished the quiz correctly!");
		PrintCenterText(client, "You just finished the quiz correctly!");
	}

	if (VSH2_IsMathKing(VSH2Player(client)))
	{
		float ubertime; gMathKing.cfg.GetFloat("boss.rage.ubertime", ubertime);
		TF2_AddCondition(client, TFCond_Ubercharged, ubertime);
	}
}

void Math_ClientLose(int client)
{
	inQuizz[client] = false;

	if (!IsClientInGame(client) || !IsPlayerAlive(client))
		return;

	VSH2Player player = VSH2Player(client);
	if (!VSH2_IsMathKing(player))
	{
		//Loser is a red player.
		int boss = MathKingPlayer.index;
		if (boss > 0)
		{
			int boss_melee = GetPlayerWeaponSlot(boss, TFWeaponSlot_Melee);
			SDKHooks_TakeDamage(client, boss_melee, boss, 600.0, DMG_CLUB|DMG_CRIT, boss_melee);

			// Make sure baka fucking die.
			if (IsPlayerAlive(client))
			{
				ForcePlayerSuicide(client);
			}
		}
	}
	else
	{
		//Loser is boss. Unfreeze it and add drug to it.
		UnFreezeClientInput(client);
		ServerCommand("sm_drug #%i 1", GetClientUserId(client));
		float drugtime; gMathKing.cfg.GetFloat("boss.rage.drugtime", drugtime);
		CreateTimer(drugtime, Timer_KillDrug, EntIndexToEntRef(client));
	}

	CPrintToChat(client, "{unique}[MathKing] {default}You failed the quiz!");
	PrintCenterText(client, "You failed the quiz!");
}

Action Timer_KillDrug(Handle timer, int ref)
{
	int client = EntRefToEntIndex(ref);
	if (client == INVALID_ENT_REFERENCE)
	{
		return Plugin_Stop;
	}

	ServerCommand("sm_drug #%i 0", GetClientUserId(client));

	return Plugin_Stop;
}

void Math_QuestionThink(int client)
{
	if (!IsClientInGame(client) || !IsPlayerAlive(client))
	{
		inQuizz[client] = false;
		return;
	}

	if (inQuizz[client])
	{
		if (MathKing_Rage_Lastused < GetGameTime() - MathKing_Rage_TimeLimit)
		{
			// Time limit has been reached. But client's inQuizz is still true. Meaning they cannot slove the math. Baka.
			Math_ClientLose(client);
			// After this. inQuizz[client] will be false therefore no need for return;
		}
	}
}

bool ProcessSolution(int client, int number)
{
	if (questionResult[client] == number)
	{
		return true;
	}
	else
	{
		return false;
	}
}

void FreezeClientInput(int client)
{
	TF2_AddCondition(client, TFCond_FreezeInput);
}

void UnFreezeClientInput(int client)
{
	if (TF2_IsPlayerInCondition(client, TFCond_FreezeInput))
	{
		TF2_RemoveCondition(client, TFCond_FreezeInput);
	}
}

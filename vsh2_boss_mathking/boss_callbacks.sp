void MathKing_OnBossSelected(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	int panel_len = gMathKing.cfg.GetSize("boss.help panel");
	char[] panel_info = new char[panel_len];
	gMathKing.cfg.Get("boss.help panel", panel_info, panel_len);

	Panel panel = new Panel();
	panel.SetTitle(panel_info);
	panel.DrawItem("退出");
	panel.Send(player.index, HintPanel, 99);
	delete panel;
}

int HintPanel(Menu menu, MenuAction action, int param1, int param2) {
	return;
}

void MathKing_OnBossThink(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	int client = player.index;
	if (!IsPlayerAlive(client))	return;

	player.SpeedThink(340.0);
	player.GlowThink(0.1);
	player.WeighDownThink(2.0, 0.1);

	if (player.SuperJumpThink(2.5, 25.0))
	{
		player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.jump"), VSH2_VOICE_ABILITY);
		player.SuperJump(player.GetPropFloat("flCharge"), -100.0);
	}

	if (OnlyScoutsLeft(VSH2Team_Red))
	{
		player.SetPropFloat("flRAGE", player.GetPropFloat("flRAGE") + gMathKing.scout_rage_gen);
	}

	SetHudTextParams(-1.0, 0.77, 0.35, 255, 255, 255, 255);
	Handle hud = gMathKing.gm.hHUD;
	float jmp = player.GetPropFloat("flCharge");
	float rage = rage = player.GetPropFloat("flRAGE");
	if (rage >= 100.0)
	{
		ShowSyncHudText(client, hud, "%s%i%% | 愤怒：已满 - 呼叫医生（默认E）激活", (jmp >= 25.0) ? "传送：" : "超级跳：", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4);
	}
	else
	{
		ShowSyncHudText(client, hud, "%s %i%% | 愤怒：%0.1f", (jmp >= 25.0) ? "传送：" : "超级跳：", player.GetPropInt("bSuperCharge") ? 1000 : RoundFloat(jmp) * 4, rage);
	}

	Math_QuestionThink(client);
}

void MathKing_OnBossModelTimer(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	int client = player.index;
	int boss_mdl_len = gMathKing.cfg.GetSize("boss.model");
	char[] boss_mdl = new char[boss_mdl_len];
	gMathKing.cfg.Get("boss.model", boss_mdl, boss_mdl_len);
	SetVariantString(boss_mdl);
	AcceptEntityInput(client, "SetCustomModel");
	SetEntProp(client, Prop_Send, "m_bUseClassAnimations", 1);
}

void MathKing_OnBossDeath(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.death"), VSH2_VOICE_LOSE);
}

void MathKing_OnBossEquipped(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	char name[MAX_BOSS_NAME_SIZE];
	gMathKing.cfg.Get("boss.name", name, sizeof(name));
	player.SetName(name);

	player.RemoveAllItems();
	ConfigMap melee_wep = gMathKing.cfg.GetSection("boss.melee");
	if (melee_wep == null)
		return;

	int attribs_len = melee_wep.GetSize("attribs");
	char[] attribs_str = new char[attribs_len];
	melee_wep.Get("attribs", attribs_str, attribs_len);

	int classname_len = melee_wep.GetSize("classname");
	char[] classname_str = new char[classname_len];
	melee_wep.Get("classname", classname_str, classname_len);

	int index, level, quality;
	melee_wep.GetInt("index",   index);
	melee_wep.GetInt("level",   level);
	melee_wep.GetInt("quality", quality);

	int wep = player.SpawnWeapon(classname_str, index, level, quality, attribs_str);
	SetEntPropEnt(player.index, Prop_Send, "m_hActiveWeapon", wep);
}

void MathKing_OnBossInitialized(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	TF2_SetPlayerClass(player.index, TFClass_Engineer);
}

void MathKing_OnBossPlayIntro(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.intro"), VSH2_VOICE_INTRO);

	player.SetPropAny("bNoAmmoPacks", true);

	Math_ResetInQuizzState();
}

void MathKing_OnBossMedicCall(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	if (player.GetPropFloat("flRAGE") < 100.0)	return;

	player.SetPropFloat("flRAGE", 0.0);
	player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.rage"), VSH2_VOICE_RAGE);

	Math_DoRage(player);
	player.StunBuildings(9999.0, 10.0);
}

void MathKing_OnLastPlayer(const VSH2Player player)
{
	if (!VSH2_IsMathKing(player)) return;

	player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.lastplayer"), VSH2_VOICE_LASTGUY);
}

void MathKing_OnRoundEndInfo(
	const VSH2Player player,
	bool boss_won,
	char message[MAXMESSAGE]
)
{
	if (!VSH2_IsMathKing(player)) return;

	if (boss_won)
	{
		player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.win"), VSH2_VOICE_WIN);
	}

	player.SetPropAny("bNoAmmoPacks", false);

	Math_ResetInQuizzState();
}

void MathKing_OnMusic(
	char song[PLATFORM_MAX_PATH],
	float& time,
	const VSH2Player player,
	float& volume
)
{
	if (!VSH2_IsMathKing(player)) return;

	ConfigMap music_sect = gMathKing.cfg.GetSection("boss.sounds.music");
	ConfigMap music_time_sect = gMathKing.cfg.GetSection("boss.sounds.music time");
	if (music_sect == null || music_time_sect == null)	return;

	int size = (music_sect.Size > music_time_sect.Size) ? music_time_sect.Size : music_sect.Size;
	static int index;
	index = ShuffleIndex(size, index);
	music_sect.GetIntKey(index, song, sizeof(song));
	music_time_sect.GetIntKeyFloat(index, time);
}

void MathKing_OnBossMenu(Menu& menu, const VSH2Player player)
{
	char tostr[10];
	IntToString(gMathKing.boss_id, tostr, sizeof(tostr));
	int menu_name_len = gMathKing.cfg.GetSize("boss.menu name");
	char[] menu_name_str = new char[menu_name_len];
	gMathKing.cfg.Get("boss.menu name", menu_name_str, menu_name_len);
	menu.AddItem(tostr, menu_name_str);
}

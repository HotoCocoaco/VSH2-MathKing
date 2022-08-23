void MathKing_OnCallDownloads()
{
	{
		/// model.
		int boss_mdl_len = gMathKing.cfg.GetSize("boss.model");
		char[] boss_mdl_str = new char[boss_mdl_len];
		if (gMathKing.cfg.Get("boss.model", boss_mdl_str, boss_mdl_len) > 0)
		{
			PrepareModel(boss_mdl_str);
		}

		/// model skins.
		ConfigMap skins = gMathKing.cfg.GetSection("boss.skins");
		PrepareAssetsFromCfgMap(skins, ResourceMaterial);
	}

	ConfigMap sounds_sect = gMathKing.cfg.GetSection("boss.sounds");
	if (sounds_sect != null)
	{
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("intro"),      ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("rage"),       ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("jump"),       ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("backstab"),   ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("death"),      ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("lastplayer"), ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("kill"),       ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("spree"),      ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("win"),        ResourceSound);
		PrepareAssetsFromCfgMap(sounds_sect.GetSection("music"),      ResourceSound);
	}
	ConfigMap downloads = gMathKing.cfg.GetSection("boss.downloads");
	int downloads_size = downloads ? downloads.Size : 0;
	for (int i = 0; i < downloads_size; i++)
	{
		int file_size = downloads.GetIntKeySize(i);
		char[] file = new char[file_size];
		downloads.GetIntKey(i, file, file_size);
		if (!FileExists(file, true))
		{
			LogError("[VSH2] File doesn't exists \"%s\" ", file);
			continue;
		}
		AddFileToDownloadsTable(file);
	}
}

Action MathKing_OnSoundHook(
	const VSH2Player player,
	char sample[PLATFORM_MAX_PATH],
	int& channel,
	float& volume,
	int& level,
	int& pitch,
	int& flags
)
{
	if (!VSH2_IsMathKing(player)) return Plugin_Continue;

	if ( (channel == SNDCHAN_VOICE || channel == SNDCHAN_STATIC) && !StrContains(sample, "vo") )
	{
		ConfigMap phrase = gMathKing.cfg.GetSection("boss.sounds.phrase");
		int phrase_size = phrase ? phrase.Size : phrase_size;
		if (phrase_size)
		{
			phrase.GetIntKey(GetRandomInt(0, phrase_size - 1), sample, sizeof(sample));
			return Plugin_Changed;
		}
		else return Plugin_Stop;
	}

	return Plugin_Continue;
}

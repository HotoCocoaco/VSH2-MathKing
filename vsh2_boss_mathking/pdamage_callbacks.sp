void MathKing_OnPlayerHurt(
	const VSH2Player player,
	const VSH2Player victim,
	Event event
)
{
	if (!VSH2_IsMathKing(victim))	return;

	victim.GiveRage(event.GetInt("damageamount"));
}

void MathKing_OnPlayerKilled(
	const VSH2Player player,
	const VSH2Player victim,
	Event event
)
{
	if (!VSH2_IsMathKing(victim))	return;

	float curtime = GetGameTime();
	if (curtime <= player.GetPropFloat("flKillSpree"))
	{
		gMathKing.kills++;
	}
	else
	{
		gMathKing.kills++;
	}

	if (gMathKing.kills == 3 && gMathKing.gm.iLivingReds != 1)
	{
		player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.spree"), VSH2_VOICE_SPREE);
		gMathKing.kills = 0;
	}
	else
	{
		player.SetPropFloat("flKillSpree", curtime + 5.0);
		player.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.kill"), VSH2_VOICE_BOSSENT);
	}
}

void MathKing_OnPlayerAirblasted(
	const VSH2Player player,
	const VSH2Player victim,
	Event event
)
{
	if (!VSH2_IsMathKing(victim))	return;

	victim.SetPropFloat("flRAGE", victim.GetPropFloat("flRAGE") + gMathKing.airblast_rage);
}

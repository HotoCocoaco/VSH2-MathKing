Action MathKing_OnBossTakeDamage_OnStabbed(
	const VSH2Player victim,
	int& attacker,
	int& inflictor,
	float& damage,
	int& damagetype,
	int& weapon,
	float damageForce[3],
	float damagePosition[3],
	int damagecustom
)
{
	if (!VSH2_IsMathKing(victim)) return Plugin_Continue;

	victim.PlayRandVoiceClipCfgMap(gMathKing.cfg.GetSection("boss.sounds.backstab"), VSH2_VOICE_STABBED);

	return Plugin_Continue;
}

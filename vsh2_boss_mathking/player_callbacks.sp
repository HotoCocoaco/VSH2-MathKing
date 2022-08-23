void MathKing_OnBossJarated(const VSH2Player victim, const VSH2Player attacker)
{
	if (!VSH2_IsMathKing(victim))	return;

	victim.SetPropFloat("flRAGE", victim.GetPropFloat("flRAGE") - gMathKing.jarate_rage);
}

void MathKing_OnRedPlayerThink(const VSH2Player player)
{
	int client = player.index;
	Math_QuestionThink(client);
}

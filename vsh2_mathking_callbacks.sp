#include "vsh2_boss_mathking/boss_callbacks.sp"
#include "vsh2_boss_mathking/btd_callbacks.sp"
#include "vsh2_boss_mathking/global_callbacks.sp"
#include "vsh2_boss_mathking/pdamage_callbacks.sp"
#include "vsh2_boss_mathking/player_callbacks.sp"
#include "vsh2_boss_mathking/math_ability.sp"

void VSH2_HookMathKing()
{
	VSH2_Hook(OnBossDeath, MathKing_OnBossDeath);
	VSH2_Hook(OnBossEquipped, MathKing_OnBossEquipped);
	VSH2_Hook(OnBossInitialized, MathKing_OnBossInitialized);
	VSH2_Hook(OnBossJarated, MathKing_OnBossJarated);
	VSH2_Hook(OnBossMedicCall, MathKing_OnBossMedicCall);
	VSH2_Hook(OnBossMenu, MathKing_OnBossMenu);
	VSH2_Hook(OnBossModelTimer, MathKing_OnBossModelTimer);
	VSH2_Hook(OnBossPlayIntro, MathKing_OnBossPlayIntro);
	VSH2_Hook(OnBossSelected, MathKing_OnBossSelected);
	VSH2_Hook(OnBossTakeDamage_OnStabbed, MathKing_OnBossTakeDamage_OnStabbed);
	VSH2_Hook(OnBossThink, MathKing_OnBossThink);
	VSH2_Hook(OnCallDownloads, MathKing_OnCallDownloads);
	VSH2_Hook(OnLastPlayer, MathKing_OnLastPlayer);
	VSH2_Hook(OnMusic, MathKing_OnMusic);
	VSH2_Hook(OnPlayerAirblasted, MathKing_OnPlayerAirblasted);
	VSH2_Hook(OnPlayerHurt, MathKing_OnPlayerHurt);
	VSH2_Hook(OnPlayerKilled, MathKing_OnPlayerKilled);
	VSH2_Hook(OnRoundEndInfo, MathKing_OnRoundEndInfo);
	VSH2_Hook(OnSoundHook, MathKing_OnSoundHook);
	VSH2_Hook(OnRedPlayerThink, MathKing_OnRedPlayerThink);
}

void VSH2_UnhookMathKing()
{
	VSH2_Unhook(OnBossDeath, MathKing_OnBossDeath);
	VSH2_Unhook(OnBossEquipped, MathKing_OnBossEquipped);
	VSH2_Unhook(OnBossInitialized, MathKing_OnBossInitialized);
	VSH2_Unhook(OnBossJarated, MathKing_OnBossJarated);
	VSH2_Unhook(OnBossMedicCall, MathKing_OnBossMedicCall);
	VSH2_Unhook(OnBossMenu, MathKing_OnBossMenu);
	VSH2_Unhook(OnBossModelTimer, MathKing_OnBossModelTimer);
	VSH2_Unhook(OnBossPlayIntro, MathKing_OnBossPlayIntro);
	VSH2_Unhook(OnBossSelected, MathKing_OnBossSelected);
	VSH2_Unhook(OnBossTakeDamage_OnStabbed, MathKing_OnBossTakeDamage_OnStabbed);
	VSH2_Unhook(OnBossThink, MathKing_OnBossThink);
	VSH2_Unhook(OnCallDownloads, MathKing_OnCallDownloads);
	VSH2_Unhook(OnLastPlayer, MathKing_OnLastPlayer);
	VSH2_Unhook(OnMusic, MathKing_OnMusic);
	VSH2_Unhook(OnPlayerAirblasted, MathKing_OnPlayerAirblasted);
	VSH2_Unhook(OnPlayerHurt, MathKing_OnPlayerHurt);
	VSH2_Unhook(OnPlayerKilled, MathKing_OnPlayerKilled);
	VSH2_Unhook(OnRoundEndInfo, MathKing_OnRoundEndInfo);
	VSH2_Unhook(OnSoundHook, MathKing_OnSoundHook);
	VSH2_Unhook(OnRedPlayerThink, MathKing_OnRedPlayerThink);
}

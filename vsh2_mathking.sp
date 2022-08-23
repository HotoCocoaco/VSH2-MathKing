enum struct MathKingConfig
{
	int boss_id;
	VSH2GameMode gm;
	ConfigMap cfg;

	float scout_rage_gen;
	float airblast_rage;
	float jarate_rage;

	int kills;

	void Register()
	{
		this.cfg = new ConfigMap("configs/saxton_hale/boss_cfgs/mathking_boss.cfg");
		if (this.cfg == null)
		{
			LogError("[VSH2] ERROR :: **** couldn't find 'configs/saxton_hale/boss_cfgs/mathking_boss.cfg'. Failed to register Boss module. ****");
			return;
		}
		char plugin_name_str[MAX_BOSS_NAME_SIZE];
		this.cfg.Get("boss.plugin name", plugin_name_str, sizeof(plugin_name_str));
		this.boss_id = VSH2_RegisterPlugin(plugin_name_str);
		VSH2_HookMathKing();

		this.scout_rage_gen = FindConVar("vsh2_scout_rage_gen").FloatValue;
		this.airblast_rage = FindConVar("vsh2_airblast_rage").FloatValue;
		this.jarate_rage = FindConVar("vsh2_jarate_rage").FloatValue;

		Math_Register();
	}

	void Unregister()
	{
		VSH2_UnhookMathKing();
		DeleteCfg(this.cfg);
	}
}

MathKingConfig gMathKing;

bool VSH2_IsMathKing(const VSH2Player player)
{
	return gMathKing.boss_id == player.GetPropInt("iBossType");
}

#include "vsh2_mathking_callbacks.sp"

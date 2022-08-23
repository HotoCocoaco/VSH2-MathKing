#include <sourcemod>
#include <vsh2>
#include <sdkhooks>
#include <morecolors>
#include "modules/stocks.inc"

public Plugin info = {
	name = "VSH2 Mathking Boss",
	author = "HotoCocoaco",
	description = "Add Mathking into vsh2",
	version = "1.0",
	url = ""
};

#include "vsh2_mathking.sp"

public void OnLibraryAdded(const char[] name)
{
	if (StrEqual(name, "VSH2"))
	{
		gMathKing.Register();
	}
}

public void OnLibraryRemoved(const char[] name)
{
	if (StrEqual(name, "VSH2"))
	{
		gMathKing.Unregister();
	}
}

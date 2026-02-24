GlobalForward g_OnStatusEffectApplied, g_OnStatusEffectRemoved;

public void CFSE_MakeForwards()
{
    g_OnStatusEffectApplied = new GlobalForward("CF_OnStatusEffectApplied", ET_Event, Param_Cell, Param_String, Param_Cell, Param_CellByRef);
    g_OnStatusEffectRemoved = new GlobalForward("CF_OnStatusEffectRemoved", ET_Ignore, Param_Cell, Param_String, Param_Cell);
}

public void CFSE_MakeNatives()
{
    CreateNative("CF_HasStatusEffect", Native_CF_HasStatusEffect);
    CreateNative("CF_ApplyStatusEffect", Native_CF_ApplyStatusEffect);
    CreateNative("CF_RemoveStatusEffect", Native_CF_RemoveStatusEffect);
    CreateNative("CF_RemoveAllPositiveEffects", Native_CF_RemoveAllPositiveEffects);
    CreateNative("CF_RemoveAllNegativeEffects", Native_CF_RemoveAllNegativeEffects);
    CreateNative("CF_RemoveAllStatusEffects", Native_CF_RemoveAllStatusEffects);
    CreateNative("CF_GetStatusEffectArgF", Native_CF_GetStatusEffectArgF);
    CreateNative("CF_GetStatusEffectArgI", Native_CF_GetStatusEffectArgI);
    CreateNative("CF_GetStatusEffectArgB", Native_CF_GetStatusEffectArgB);
    CreateNative("CF_GetStatusEffectArgS", Native_CF_GetStatusEffectArgS);
    CreateNative("CF_GetStatusEffectActiveValue", Native_CF_GetStatusEffectActiveValue);
    CreateNative("CF_SetStatusEffectActiveValue", Native_CF_SetStatusEffectActiveValue);
}

char s_StatusNames[2049][255];
g_StatusInfo g_StatusTemplates[2049];
int i_NumTemplates = 0;

ArrayList g_StatusTemplateArgs[2049];
ArrayList g_StatusTemplateValues[2049];

enum struct g_StatusInfo
{
    bool positive;
    bool allow_entities;

    void Create(bool pos, bool ents) { this.positive = pos; this.allow_entities = ents; }
    void RevertToDefault() { this.positive = false; this.allow_entities = false; }
}

public void CFSE_LoadStatusEffectsFromCharacter(ConfigMap Character)
{
    ConfigMap Effects = Character.GetSection("character.status_effects");
    if (Effects == null)
        return;

    StringMapSnapshot snap = Effects.Snapshot();
				
	for (int i = 0; i < snap.Length; i++)
	{
		char effectName[255];
		snap.GetKey(i, effectName, sizeof(effectName));
					
		ConfigMap subsection = Effects.GetSection(effectName);
        if (subsection != null)
        {
            CFSE_AddStatusEffect(subsection, effectName);
        }
	}
			
	delete snap;
}

public void CFSE_AddStatusEffect(ConfigMap effect, char[] name)
{
    strcopy(s_StatusNames[i_NumTemplates], 255, name);
    g_StatusTemplates[i_NumTemplates].Create(GetBoolFromCFGMap(effect, "positive", false), GetBoolFromCFGMap(effect, "allow_entities", true));

    #if defined DEBUG_STATUS_EFFECTS
    PrintToServer("ADDED STATUS EFFECT: %s", name);
    PrintToServer("     - Positive: %i", g_StatusTemplates[i_NumTemplates].positive);
    PrintToServer("     - Allows Entities: %i", g_StatusTemplates[i_NumTemplates].allow_entities);
    #endif

    ConfigMap custArgs = effect.GetSection("custom_args");
    if (custArgs != null)
    {
        StringMapSnapshot snap = custArgs.Snapshot();

        if (snap.Length > 0)
        {
            g_StatusTemplateArgs[i_NumTemplates] = CreateArray(128);
            g_StatusTemplateValues[i_NumTemplates] = CreateArray(128);
        }
				
        for (int i = 0; i < snap.Length; i++)
        {
            char argName[128], value[128];
            snap.GetKey(i, argName, sizeof(argName));
            custArgs.Get(argName, value, 128);

            PushArrayString(g_StatusTemplateArgs[i_NumTemplates], argName);
            PushArrayString(g_StatusTemplateValues[i_NumTemplates], value);

            #if defined DEBUG_STATUS_EFFECTS
            PrintToServer("     - ''%s''    ''%s''", argName, value);
            #endif
        }
                
        delete snap;
    }

    i_NumTemplates++;
}

public void CFSE_ClearStatusEffects()
{
    for (int i = 0; i < i_NumTemplates; i++)
    {
        strcopy(s_StatusNames[i], 255, "");
        g_StatusTemplates[i].RevertToDefault();

        delete g_StatusTemplateArgs[i];
        delete g_StatusTemplateValues[i];
    }

    i_NumTemplates = 0;
}

public int CFSE_GetEffectSlot(char[] effect)
{
    if (i_NumTemplates < 1)
        return -1;

    for (int i = 0; i < i_NumTemplates; i++)
    {
        if (StrEqual(s_StatusNames[i], effect))
            return i;
    }

    return -1;
}

public int CFSE_GetArgSlot(int effectSlot, char[] arg)
{
    if (effectSlot < 0 || effectSlot > 2048 || g_StatusTemplateArgs[effectSlot] == null)
        return -1;

    for (int i = 0; i < GetArraySize(g_StatusTemplateArgs[effectSlot]); i++)
    {
        char argName[255];
        GetArrayString(g_StatusTemplateArgs[effectSlot], i, argName, 255);

        if (StrEqual(argName, arg))
            return i;
    }

    return -1;
}

public bool CFSE_GetArgValue(char[] effect, char[] arg, char[] output, int size)
{
    int effectSlot = CFSE_GetEffectSlot(effect);
    if (effectSlot < 0)
        return false;

    int argSlot = CFSE_GetArgSlot(effectSlot, arg);
    if (argSlot < 0)
        return false;

    GetArrayString(g_StatusTemplateValues[effectSlot], argSlot, output, size);
}

public any Native_CF_HasStatusEffect(Handle plugin, int numParams)
{

}

public any Native_CF_ApplyStatusEffect(Handle plugin, int numParams)
{

}

public Native_CF_RemoveStatusEffect(Handle plugin, int numParams)
{

    return 0;
}

public Native_CF_RemoveAllPositiveEffects(Handle plugin, int numParams)
{

    return 0;
}

public Native_CF_RemoveAllNegativeEffects(Handle plugin, int numParams)
{

    return 0;
}

public Native_CF_RemoveAllStatusEffects(Handle plugin, int numParams)
{

    return 0;
}

public any Native_CF_GetStatusEffectArgF(Handle plugin, int numParams)
{
    char effect[255], arg[255];
    GetNativeString(1, effect, 255);
    GetNativeString(2, arg, 255);

    if (CFSE_GetArgValue(effect, arg, arg, 255))
    {
        return StringToFloat(arg);
    }
    
    return GetNativeCell(3);
}

public Native_CF_GetStatusEffectArgI(Handle plugin, int numParams)
{
    char effect[255], arg[255];
    GetNativeString(1, effect, 255);
    GetNativeString(2, arg, 255);

    if (CFSE_GetArgValue(effect, arg, arg, 255))
    {
        return StringToInt(arg);
    }
    
    return GetNativeCell(3);
}

public any Native_CF_GetStatusEffectArgB(Handle plugin, int numParams)
{
    char effect[255], arg[255];
    GetNativeString(1, effect, 255);
    GetNativeString(2, arg, 255);

    if (CFSE_GetArgValue(effect, arg, arg, 255))
    {
        return StringToInt(arg) > 0;
    }
    
    return GetNativeCell(3);
}

public Native_CF_GetStatusEffectArgS(Handle plugin, int numParams)
{
    char effect[255], arg[255];
    GetNativeString(1, effect, 255);
    GetNativeString(2, arg, 255);

    if (CFSE_GetArgValue(effect, arg, arg, 255))
    {
        SetNativeString(3, arg, GetNativeCell(4));
        return 0;
    }
    
    char defaultVal[255];
    GetNativeString(5, defaultVal, 255);
    SetNativeString(3, defaultVal, GetNativeCell(4));

    return 0;
}

public any Native_CF_GetStatusEffectActiveValue(Handle plugin, int numParams)
{

}

public any Native_CF_SetStatusEffectActiveValue(Handle plugin, int numParams)
{

    return 0;
}
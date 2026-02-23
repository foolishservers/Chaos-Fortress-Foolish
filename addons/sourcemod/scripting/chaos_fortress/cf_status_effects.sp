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

}

public Native_CF_GetStatusEffectArgI(Handle plugin, int numParams)
{

}

public any Native_CF_GetStatusEffectArgB(Handle plugin, int numParams)
{

}

public Native_CF_GetStatusEffectArgS(Handle plugin, int numParams)
{

    return 0;
}

public any Native_CF_GetStatusEffectActiveValue(Handle plugin, int numParams)
{

}

public any Native_CF_SetStatusEffectActiveValue(Handle plugin, int numParams)
{

    return 0;
}
function RER_showCompanionIndicator( npc_tag : name, optional icon_path : string ) {
	var hud: CR4ScriptedHud;	
	var companionModule: CR4HudModuleCompanion;
	var npc: CNewNPC;

	npc = theGame.GetNPCByTag(npc_tag);

	if (!npc) {
    return;
	}
	
	hud = (CR4ScriptedHud)theGame.GetHud();	
	if (hud) {
		companionModule = (CR4HudModuleCompanion)hud.GetHudModule("CompanionModule");

		if ( companionModule ) {
			companionModule.ShowCompanion( true, npc_tag, icon_path );
			
			if ( npc.GetStat( BCS_Essence, true ) < 0 ) {
        if ( theGame.GetDifficultyMode() == EDM_Hard && !npc.HasAbility('_combatFollowerHardV') ) {
          npc.AddAbility('_combatFollowerHardV', false);
        }
        else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc.HasAbility('_combatFollowerHardcoreV') ) {
          npc.AddAbility('_combatFollowerHardcoreV', false);
        }
      } else if ( npc.GetStat( BCS_Vitality, true ) < 0 ) {
        if ( theGame.GetDifficultyMode() == EDM_Hard && !npc.HasAbility('_combatFollowerHardE') ) {
          npc.AddAbility('_combatFollowerHardE', false);
        }
        else if ( theGame.GetDifficultyMode() == EDM_Hardcore && !npc.HasAbility('_combatFollowerHardcoreE') ) {
          npc.AddAbility('_combatFollowerHardcoreE', false);
        }
      } 
		}
	}
}

function RER_hideCompanionIndicator( npc_tag : name, optional icon_path : string ) {
	var hud: CR4ScriptedHud;	
	var companionModule: CR4HudModuleCompanion;
	
	hud = (CR4ScriptedHud)theGame.GetHud();	
	if (hud) {
		companionModule = (CR4HudModuleCompanion)hud.GetHudModule("CompanionModule");

		if ( companionModule ) {
			companionModule.ShowCompanion( false, npc_tag, icon_path );
		}
	}
}

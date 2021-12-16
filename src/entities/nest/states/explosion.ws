
state Explosion in RER_MonsterNest {
	event OnEnterState(prevStateName: name) {
    NLOG("RER_MonsterNest - State EXPLOSION");
		parent.canPlayVset = false;
		
		Explosion();
	}
	
	entry function Explosion() {
		var wasDestroyed : bool;
		var parentEntity : CR4MapPinEntity;
		var commonMapManager : CCommonMapManager;
		var l_pos: Vector;

    commonMapManager = theGame.GetCommonMapManager();
		
		ProcessExplosion();
		SleepOneFrame();

		if (parent.appearanceChangeDelayAfterExplosion > 0) {
			Sleep(parent.appearanceChangeDelayAfterExplosion);
		}
		
		parent.ApplyAppearance('nest_destroyed');
		
		if (parent.lootOnNestDestroyed) {
			l_pos = parent.GetWorldPosition();
			l_pos.Z += 0.5;

			parent.container = (W3Container)theGame.CreateEntity(
        parent.lootOnNestDestroyed,
        l_pos,
        parent.GetWorldRotation()
      );
		}
		
		//focus mode highlight
		parent.SetFocusModeVisibility(0);
		
		//destruction fact - immediate
		if(parent.IsSetDestructionFactImmediately()) {
			FactsAdd( parent.factSetAfterSuccessfulDestruction, 1 );
    }
			
		//destruction tag
		wasDestroyed = parent.HasTag('WasDestroyed');
		parent.AddTag('WasDestroyed');
			
		parentEntity = ( CR4MapPinEntity )parent;
		
		//achievement for destroying X nests
		if(!wasDestroyed && !parent.HasTag('AchievementFireInTheHoleExcluded')) {
			theGame.GetGamerProfile().IncStat(ES_DestroyedNests);
		}
		
		//remove mappin
		commonMapManager.SetEntityMapPinDisabled(parent.entityName, true);
		parent.AddExp();
		
		if (!parent.airDmg) {
			parent.PlayEffect('fire');
		}
		else {
			parent.PlayEffect('dust');
		}

		if(parent.nestBurnedAfter != 0) {
			Sleep(parent.nestBurnedAfter);
		}
		
		//destruction fact - not immediate
		if(!parent.IsSetDestructionFactImmediately()) {
			FactsAdd(parent.factSetAfterSuccessfulDestruction, 1);
    }
		
    parent.GotoState('NestDestroyed');
	}
		
	private function ProcessExplosion() {
		ProcessExplosionEffects();
		
		if(parent.shouldDealDamageOnExplosion) {
			ProcessExplosionDamage();
    }
	}
	
	private function ProcessExplosionEffects() {
		if(parent.shouldPlayFXOnExplosion && !parent.airDmg) {
			parent.PlayEffect('explosion');
		}

		GCameraShake(0.5, true, parent.GetWorldPosition(), 1.0f);

		//Stopping Deploy effect 
		parent.StopEffect('deploy');
	}
	
	private function ProcessExplosionDamage() {
		var damage: W3DamageAction;
		var entitiesInRange: array<CGameplayEntity>;
		var explosionRadius: float;
		var damageVal: float;
		var i: int;

    explosionRadius = 3.0;
    damageVal = 50.0;
		
		FindGameplayEntitiesInSphere(
      entitiesInRange,
      parent.GetWorldPosition(),
      explosionRadius,
      100
    );

		entitiesInRange.Remove(parent);

		for(i = 0; i < entitiesInRange.Size(); i += 1) {
			if(entitiesInRange[ i ] == thePlayer && thePlayer.CanUseSkill( S_Perk_16 )) {
				continue;
			}
			
			if((CActor)entitiesInRange[i]) {
				damage = new W3DamageAction in parent;
				
				damage.Initialize( parent, entitiesInRange[i], NULL, parent, EHRT_None, CPS_Undefined, false, false, false, true );
				damage.AddDamage( theGame.params.DAMAGE_NAME_FIRE, damageVal );
				damage.AddEffectInfo( EET_Burning );
				damage.AddEffectInfo( EET_Stagger );
				theGame.damageMgr.ProcessAction( damage );
				
				delete damage;
			}
			else {
				entitiesInRange[i].OnFireHit(parent);
			}
		}
	}
}

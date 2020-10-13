
// Randomly add more creatures to groups of creatures in the world.
class RER_ListenerFillCreaturesGroup extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  var can_duplicate_creatures_in_combat: bool;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERadvancedEvents', 'eventFillCreaturesGroup')
    );

    this.can_duplicate_creatures_in_combat = inGameConfigWrapper
      .GetVarValue('RERadvancedEvents', 'eventFillCreaturesGroupAllowCombat');

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var has_duplicated_creature: bool;
    
    if (was_spawn_already_triggered) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - spawn already triggered");

      return false;
    }

    if (this.time_before_other_spawn > 0) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - delay between spawns");

      time_before_other_spawn -= delta;

      return false;
    }

    if (RandRangeF(100) < this.trigger_chance * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - duplicateRandomNearbyEntity");
      
      has_duplicated_creature = duplicateRandomNearbyEntity(master);
      if (has_duplicated_creature) {
        this.time_before_other_spawn += master.events_manager.internal_cooldown;

        // NOTE: this event SHOULD return true but doesn't because it doesn't affect
        // the other events. Other events use the "true" to know if another event
        // spawned a creature. But as this one only add creatures that are out of
        // combat it should not infer with the other event.
        return false; 
      }
    }

    return false;
  }

  private latent function duplicateRandomNearbyEntity(master: CRandomEncounters): bool {
    var entities : array<CGameplayEntity>;
    var picked_npc_list: array<CNewNPC>;
    var picked_npc_index: int;
    var picked_npc: CNewNPC;
    var duplicated_npc: CNewNPC;
    var boss_tag: name;
    var i: int;
    var entity_template: CEntityTemplate;
    var created_entity: CEntity;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      300, // radius
      100, // max number of entities
      , // tag
      FLAG_Attitude_Hostile + FLAG_ExcludePlayer + FLAG_OnlyAliveActors,
      thePlayer, // target
      'CNewNPC'
    );

    // to avoid duplicating bosses
    boss_tag = thePlayer.GetBossTag();

    for (i = 0; i < entities.Size(); i += 1) {
      if (((CNewNPC)entities[i])
      && ((CNewNPC)entities[i]).GetNPCType() == ENGT_Enemy
      
      // this one removes animals like bears, wolves
      // and also humans like bandits
      // && ((CNewNPC)entities[i]).IsMonster()
      
      // if the user allows even creatures who are in combat
      // or if the creature is not in combat
      && (
        this.can_duplicate_creatures_in_combat
        || !((CNewNPC)entities[i]).IsInCombat()
      )
      && !((CNewNPC)entities[i]).HasTag(boss_tag)) {
        picked_npc_list.PushBack((CNewNPC)entities[i]);
      }
    }

    LogChannel('modRandomEncouters', "found " + picked_npc_list.Size() + " creatures to duplicate");

    if (picked_npc_list.Size() == 0) {
      return false;
    }



    picked_npc_index = RandRange(picked_npc_list.Size());
    picked_npc = picked_npc_list[picked_npc_index];

    LogChannel('modRandomEncounters', "getName = " + StrAfterFirst(picked_npc.ToString(), "::"));

    entity_template = (CEntityTemplate)LoadResourceAsync(StrAfterFirst(picked_npc.ToString(), "::"), true);

    created_entity = theGame.CreateEntity(
      entity_template,
      picked_npc.GetWorldPosition(),
      picked_npc.GetWorldRotation()
    );

    ((CNewNPC)created_entity).SetLevel(
      getRandomLevelBasedOnSettings(master.settings)
    );

    // duplicated_npc = (CNewNPC)(picked_npc.Duplicate());

    return true;
  }
}

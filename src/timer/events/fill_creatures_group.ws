
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
      .GetVarValue('RERevents', 'eventFillCreaturesGroup')
    );

    this.can_duplicate_creatures_in_combat = inGameConfigWrapper
      .GetVarValue('RERevents', 'eventFillCreaturesGroupAllowCombat');

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var random_entity_to_duplicate: CNewNPC;
    var creature_height: float;
    
    if (was_spawn_already_triggered) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - spawn already triggered");

      return false;
    }

    if (this.time_before_other_spawn > 0) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - delay between spawns");

      time_before_other_spawn -= delta;

      return false;
    }

    if (!this.getRandomNearbyEntity(random_entity_to_duplicate)) {
      return false;
    }

    // here i divide the chance by the creature height / 2 so that larger creatures
    // have a smaller chance to be duplicated
    if (RandRangeF(100) / ( * 0.5) < this.trigger_chance * chance_scale) {
      // it's done inside the if and only after a successful roll to avoid retrieving
      // the creature's height every interval. It's an attempt at optimizing it.
      //
      // small creatures will have a higher chance to pass, while larger creatures
      // will have a lower chance. The height is divided by two because some creatures
      // are 4 meters tall like fiends and dividing their chances by 4 would be
      // too much. So instead we divide their chance by 4meters / 2.
      // because the height is almost divided by two, lots of creatures will
      // automatically pass the test. For example, werewolves are 1.8 meters tall
      // so the 0.6 is an attempt at avoiding this.
      creature_height = getCreatureHeight(random_entity_to_duplicate) * 0.6;
      
      if (creature_height > 1 && RandRangeF(creature_height) < 1) {
        return false;
      }

      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - duplicateRandomNearbyEntity");
      
      this.duplicateEntity(master, random_entity_to_duplicate);
      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // NOTE: this event SHOULD return true but doesn't because it doesn't affect
      // the other events. Other events use the "true" to know if another event
      // spawned a creature. But as this one only add creatures that are out of
      // combat it should not infer with the other event.
      return false;
    }

    return false;
  }

  private function getRandomNearbyEntity(out entity: CNewNPC): bool {
    var entities : array<CGameplayEntity>;
    var picked_npc_list: array<CNewNPC>;
    var picked_npc_index: int;
    var i: int;
    var picked_npc: CNewNPC;
    var boss_tag: name;

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

    if (picked_npc_list.Size() == 0) {
      return false;
    }

    picked_npc_index = RandRange(picked_npc_list.Size());
    entity = picked_npc_list[picked_npc_index];

    return true;
  }

  private latent function duplicateEntity(master: CRandomEncounters, entity: CNewNPC) {
    var entity_template: CEntityTemplate;
    var created_entity: CEntity;

    LogChannel('modRandomEncounters', "duplicating = " + StrAfterFirst(entity.ToString(), "::"));

    entity_template = (CEntityTemplate)LoadResourceAsync(
      StrAfterFirst(entity.ToString(), "::"),
      true
    );

    created_entity = theGame.CreateEntity(
      entity_template,
      entity.GetWorldPosition(),
      entity.GetWorldRotation()
    );

    ((CNewNPC)created_entity).SetLevel(
      getRandomLevelBasedOnSettings(master.settings)
    );
  }
}

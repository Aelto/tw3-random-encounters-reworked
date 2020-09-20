
// Randomly add more creatures to groups of creatures in the world.
class RER_ListenerFillCreaturesGroup extends RER_EventsListener {
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool {
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

    if (RandRangeF(100) < 3 * delta * master.settings.event_system_chances_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerFillCreaturesGroup - duplicateRandomNearbyEntity");
      
      has_duplicated_creature = duplicateRandomNearbyEntity();
      if (has_duplicated_creature) {
        // so that we don't spawn an ambush too frequently
        this.time_before_other_spawn += 60.0f;

        return true;
      }
    }

    return false;
  }

  private latent function duplicateRandomNearbyEntity(): bool {
    var entities : array<CGameplayEntity>;
    var picked_npc_list: array<CNewNPC>;
    var picked_npc_index: int;
    var picked_npc: CNewNPC;
    var duplicated_npc: CNewNPC;
    var boss_tag: name;
    var i: int;
    var entity_template: CEntityTemplate;

    FindGameplayEntitiesInRange( entities, thePlayer, 200, 30, , FLAG_ExcludePlayer,, 'CNewNPC' );

    // to avoid duplicating bosses
    boss_tag = thePlayer.GetBossTag();

    for (i = 0; i < entities.Size(); i += 1) {
      if (((CNewNPC)entities[i]) && ((CNewNPC)entities[i]).GetNPCType() == ENGT_Enemy && ((CNewNPC)entities[i]).IsMonster() && !((CNewNPC)entities[i]).HasTag(boss_tag)) {
        picked_npc_list.PushBack((CNewNPC)entities[i]);
      }
    }

    if (picked_npc_list.Size() == 0) {
      return false;
    }



    picked_npc_index = RandRange(picked_npc_list.Size());
    picked_npc = picked_npc_list[picked_npc_index];

    LogChannel('modRandomEncounters', "getName = " + StrAfterFirst(picked_npc.ToString(), "::"));

    entity_template = (CEntityTemplate)LoadResourceAsync(StrAfterFirst(picked_npc.ToString(), "::"), true);

    theGame.CreateEntity(
      entity_template,
      picked_npc.GetWorldPosition(),
      picked_npc.GetWorldRotation()
    );

    // duplicated_npc = (CNewNPC)(picked_npc.Duplicate());

    return true;
  }
}
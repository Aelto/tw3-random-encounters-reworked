
// When the player is in a combat, there is a small chance a new encounter appears
// around him.
class RER_ListenerFightNoise extends RER_EventsListener {
  private var already_spawned_this_combat: bool;
  
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERadvancedEvents', 'eventFightNoise')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var is_in_combat: bool;

    is_in_combat = thePlayer.IsInCombat();

    // to avoid triggering more than one event per fight
    if (is_in_combat && (was_spawn_already_triggered || this.already_spawned_this_combat)) {
      this.already_spawned_this_combat = true;

      return false;
    }

    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;

      return false;
    }

    this.already_spawned_this_combat = false;

    if (is_in_combat && RandRangeF(100) < this.trigger_chance * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerFightNoise - triggered");
      
      // we disable it for the fight so it doesn't spawn non-stop
      this.already_spawned_this_combat = is_in_combat;

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      // create a random ambush with no creature type chosen, let RER pick one
      // randomly.
      createRandomCreatureAmbush(master, CreatureNONE);

      return true;
    }

    return false;
  }
}

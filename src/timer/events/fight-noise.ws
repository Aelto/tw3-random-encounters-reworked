
// When the player is in a combat, there is a small chance a new encounter appears
// around him.
class RER_ListenerFightNoise extends RER_EventsListener {
  private var already_spawned_this_combat: bool;

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool {
    var is_in_combat: bool;

    if (was_spawn_already_triggered || already_spawned_this_combat) {
      return false;
    }

    is_in_combat = thePlayer.IsInCombat();

    if (is_in_combat && RandRangeF(100) < 1 * delta * master.settings.event_system_chances_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerFightNoise - triggered");
      
      // we disable it for the fight so it doesn't spawn non-stop
      this.already_spawned_this_combat = true;

      // create a random ambush with no creature type chosen, let RER pick one
      // randomly.
      createRandomCreatureAmbush(master, CreatureNONE);

      return true;
    }

    // this line will execute when the player is out of combat only
    // and will reset the listener to the active state.
    if (!is_in_combat) {
      this.already_spawned_this_combat = false;
    }

    return false;
  }
}

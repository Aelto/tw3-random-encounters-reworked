
// When the player is near a noticeboard, if the noticeboard has no contracts left
// it will start a CONTRACT encounter
class RER_ListenerNoticeboardContract extends RER_EventsListener {
  // if this boolean is set at true, it means the event triggered when Geralt was
  // near a noticeboard. So if it is true the event will instead wait for Geralt
  // to leave the city instead of looking for nearby noticeboards
  private var was_triggered: bool;

  // this is the position that will be stored when the event will first be
  // triggered. This is the position near the noticeboard.
  // It is used to draw a cone from the noticeboard to the player's position
  // outside the city and to spawn the contract in this cone.
  private var position_near_noticeboard: Vector;
  
  var time_before_other_spawn: float;
  default time_before_other_spawn = 0;

  var trigger_chance: float;

  public latent function loadSettings() {
    var inGameConfigWrapper: CInGameConfigWrapper;

    inGameConfigWrapper = theGame.GetInGameConfigWrapper();

    this.trigger_chance = StringToFloat(
      inGameConfigWrapper
      .GetVarValue('RERadvancedEvents', 'eventNoticeboardContract')
    );

    // the event is only active if its chances to trigger are greater than 0
    this.active = this.trigger_chance > 0;
  }

  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float, chance_scale: float): bool {
    var has_spawned: bool;

    if (this.time_before_other_spawn > 0) {
      time_before_other_spawn -= delta;
    }

    if (this.was_triggered) {
      has_spawned = this.waitForPlayerToLeaveCity(master, chance_scale);
    }
    else {
      has_spawned = this.lookForNearbyNoticeboards(master);
    }

    return has_spawned;
  }

  private latent function waitForPlayerToLeaveCity(master: CRandomEncounters, chance_scale: float): bool {
    if (!master.rExtra.isPlayerInSettlement()) {
      return false;
    }

    if (RandRangeF(100) < this.trigger_chance * chance_scale) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered encounter");

      this.createContractEncounter(master);

      return true;
    }

    return false;
  }

  private latent function createContractEncounter(master: CRandomEncounters) {
    var contract_position: Vector;
    var player_distance_from_noticeboard: float;

    player_distance_from_noticeboard = VecDistance(thePlayer.GetWorldPosition(), this.position_near_noticeboard);

    contract_position = VecConeRand(
      VecHeading(thePlayer.GetWorldPosition() - this.position_near_noticeboard),
      5, // small angle to increase the chances the player will see the encounter
      player_distance_from_noticeboard,
      player_distance_from_noticeboard * 1.1
    );

    createRandomCreatureContract(master);
  }

  private latent function lookForNearbyNoticeboards(master: CRandomEncounters): bool {
    // to avoid triggering this event too frequently
    if (this.time_before_other_spawn > 0) {
      return false;
    }

    if (this.trigger_chance > 0 && !this.isThereEmptyNoticeboardNearby()) {
      LogChannel('modRandomEncounters', "RER_ListenerNoticeboardContract - triggered nearby noticeboard");

      this.time_before_other_spawn += master.events_manager.internal_cooldown;

      this.position_near_noticeboard = thePlayer.GetWorldPosition();

      this.was_triggered = true;
    }

    return false;
  }

  private function getNearbyNoticeboards(): array<CGameplayEntity> {
    var entities: array<CGameplayEntity>;

     // 'W3NoticeBoard' for noticeboards, 'W3FastTravelEntity' for signpost
    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      5, // range, we'll have to check if 50 is too big/small
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    return entities;
  }

  private function isThereEmptyNoticeboardNearby(): bool {
    var noticeboards: array<CGameplayEntity>;
    var current_noticeboard: W3NoticeBoard;
    var i: int;

    noticeboards = this.getNearbyNoticeboards();

    // no noticeboad nearby, we can leave
    if (noticeboards.Size() == 0) {
      return false;
    }

    for (i = 0; i < noticeboards.Size(); i += 1) {
      if ((W3NoticeBoard)noticeboards[i]) {
        current_noticeboard = (W3NoticeBoard)noticeboards[i];

        if (!current_noticeboard.HasAnyQuest()) {
          return true;
        }
      }
    }
    
    return false;
  }
}

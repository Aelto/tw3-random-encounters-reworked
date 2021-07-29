
state NestContract in RER_contractManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_contractManager - state NestContract");

    this.NestContract_main();
  }

  private var menu_distance_value: float;

  entry function NestContract_main() {
    this.startNoticeboardCutscene();
    this.createNestEncounter();
  }

  latent function createNestEncounter() {
    var current_template: CEntityTemplate;
    var nest: RER_MonsterNest;
    var position: Vector;
    var path: string;

    path = "dlc\modtemplates\randomencounterreworkeddlc\data\rer_monster_nest.w2ent";

    position = SU_getSafeCoordinatesFromPoint(
      SU_moveCoordinatesAwayFromSafeAreas(
        SU_moveCoordinatesInsideValidAreas(
          thePlayer.GetWorldPosition()
          + VecRingRand(100, 150)
        )
      )
    );

    FixZAxis(position);

    // it doesn't matter if it fails to find a ground position
    getGroundPosition(position, 10, 25);

    current_template = (CEntityTemplate)LoadResourceAsync(path, true);
    nest = (RER_MonsterNest)theGame.CreateEntity(
      current_template,
      position,
      thePlayer.GetWorldRotation(),,,,
      PM_DontPersist
    );

    nest.startEncounter(parent.master);
    parent.GotoState('Waiting');
  }

  private latent function startNoticeboardCutscene() {
    RER_tutorialTryShowNoticeboard();

    if (RandRange(10) < 2) {
      REROL_unusual_contract();
    }

    Sleep(0.4);
    REROL_mhm();
    Sleep(0.1);

    if (RandRange(10) < 5) {
      REROL_ill_tend_to_the_monster();
    }
    else {
      REROL_i_accept_the_challenge();
    }
  }
}
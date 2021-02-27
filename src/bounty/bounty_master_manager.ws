
statemachine class RER_BountyMasterManager {

  var bounty_master_entity: CEntity;

  public latent function init() {
    this.spawnBountyMaster();
    this.GotoState('Waiting');
  }

  public latent function spawnBountyMaster() {
    var valid_positions: array<Vector>;
    var template: CEntityTemplate;
    var position_index: int;

    this.bounty_master_entity = theGame.GetEntityByTag('RER_bounty_master');

    // every hour of playtime it changes the index in the valid positions
    valid_positions = this.getBountyMasterValidPositions();
    position_index = (int)RandNoiseF(
      GameTimeHours(theGame.CalculateTimePlayed()),
      valid_positions.Size()
    );

    // the bounty master already exist
    if (bounty_master_entity) {
      // remove a pin, and if there was no pin and it returns true, remove the
      // one we added just now then.
      if (RER_toggleInfoPinAtPosition(bounty_master_entity.GetWorldPosition())) {
        RER_toggleInfoPinAtPosition(bounty_master_entity.GetWorldPosition());
      }

      // teleport the bounty master at the current position based on the current playtime
      bounty_master_entity.Teleport(valid_positions[position_index]);
    }
    else {
      // TODO: spawn him
      template = (CEntityTemplate)LoadResourceAsync("dlc\bob\data\quests\secondary_npcs\damien.w2ent", true);

      this.bounty_master_entity = theGame.CreateEntity(
        template,
        valid_positions[position_index],
        thePlayer.GetWorldRotation(),,,,
        PM_Persist
      );

      this.bounty_master_entity.AddTag('RER_bounty_master');
    }

    if (!RER_toggleInfoPinAtPosition(bounty_master_entity.GetWorldPosition())) {
      RER_toggleInfoPinAtPosition(bounty_master_entity.GetWorldPosition());
    }

    NLOG("bounty master placed at " + VecToString(valid_positions[position_index]));

  }

  public function getBountyMasterValidPositions(): array<Vector> {
    var area: EAreaName;
    var area_string: string;
    var output: array<Vector>;

    area = theGame.GetCommonMapManager().GetCurrentArea();

    switch (area) {
      case AN_Prologue_Village:
      case AN_Prologue_Village_Winter:
        // Nilfgaardian garrison
        output.PushBack(Vector(-371.5, 372.5, 1.9));

        // Ransacked village
        output.PushBack(Vector(491.3, -64.7, 8.9));

        // Woeson Bridge - white orchard blacksmith
        output.PushBack(Vector(11.5, -24.9, 2.2));
        
        break;

      case AN_Skellige_ArdSkellig:
        // Holmstein port
        output.PushBack(Vector(-297.9, -1049, 6));

        // Holmstein port
        output.PushBack(Vector(-36, 619, 2));

        // Urialla harbor
        output.PushBack(Vector(1488, 1907, 4.7));
        break;

      case AN_Kaer_Morhen:
        // Crows perch
        output.PushBack(Vector(-91, -22.8, 146));
        break;

      case AN_NMLandNovigrad:
      case AN_Velen:
        // Blackbough
        output.PushBack(Vector(-186, 187, 7.6));

        // Crows perch
        output.PushBack(Vector(175, 7, 13.8));

        // Nilfgaardian camp
        output.PushBack(Vector(2321, -881, 16.1));

        // Novigrad - gregory bridge
        output.PushBack(Vector(691, 2025, 33.4));

        // Novigrad - portside gate
        output.PushBack(Vector(543, 1669, 4.12));

        // Novigrad - rosemary and thyme
        output.PushBack(Vector(707.6, 1751.2, 4.2));

        // Oxenfurt - novigrad gate
        output.PushBack(Vector(1758, 1049, 6.8));

        // Oxenfurt - western gate
        output.PushBack(Vector(1714.3, 918, 14));

        // Upper mill
          output.PushBack(Vector(2497, 2497, 2.8));
        break;

      default:
        area_string = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

        if (area_string == "bob") {
          // Beauclair port
          output.PushBack(Vector(-229, -1184, 3.7));

          // Castel vineyard
          output.PushBack(Vector(-745, -321, 29.4));

          // Cockatrice inn
          output.PushBack(Vector(-148.6, -635.4, 11.4));

          // Tourney grounds
          output.PushBack(Vector(-490.4, -954.3, 61.2));
        }
        else {
          // the real default
        }

        break;
    }

    return output;
  }

}

state Waiting in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Waiting");

    this.Waiting_main();
  }

  entry function Waiting_main() {
    var distance_from_player: float;
    var radius: float;

    radius = 100 * 100;
    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    while (distance_from_player > radius) {
      distance_from_player = VecDistanceSquared(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );

      // sleep for:
      // 0.5s at 10 meters
      // 2s at 20 meters
      // 4.5s at 30 meters
      // 12.5s at 50 meters
      // 50s at 100 meters
      // 200s at 200 meters
      //
      // Capped at 60s
      Sleep(MinF(distance_from_player / 200, 60));
    }

    parent.GotoState('Talking');
  }
}

state Talking in RER_BountyMasterManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    NLOG("RER_BountyMasterManager - Talking");

    this.Talking_main();
  }

  entry function Talking_main() {
    this.runConversation();
    parent.GotoState('Waiting');
  }

  latent function runConversation() {
    var npc_actor: CActor;
    var distance_from_player: float;
    var radius: float;
    var max_radius: float;

    npc_actor = (CActor)(parent.bounty_master_entity);
    max_radius = 10 * 10;

    // 1. first we wait for the player to get near enough so that the bounty master
    //    starts calling him.
    radius = 5 * 5;
    distance_from_player = VecDistanceSquared(
      thePlayer.GetWorldPosition(),
      parent.bounty_master_entity.GetWorldPosition()
    );

    while (distance_from_player > radius) {
      distance_from_player = VecDistanceSquared(
        thePlayer.GetWorldPosition(),
        parent.bounty_master_entity.GetWorldPosition()
      );

      SleepOneFrame();

      if (distance_from_player > max_radius) {
        return;
      }

    }

    (new RER_RandomDialogBuilder in thePlayer)
      .start()
      .dialog(new REROL_damien_greetings_witcher in thePlayer, true)
      .play(npc_actor);

    // 3.
    (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .dialog(new REROL_what_surprise_new_monster_to_kill in thePlayer, true)
        .play();

    (new RER_RandomDialogBuilder in thePlayer)
      .start()
      .dialog(new REROL_damien_he_died_claws in thePlayer, true)
      .play(npc_actor);

    // if (RandRange(10) > 5) {
    //   (new RER_RandomDialogBuilder in thePlayer)
    //     .start()
    //     .dialog(new REROL_less_moaning in thePlayer, true)
    //     .play();

    //   (new RER_RandomDialogBuilder in thePlayer)
    //     .start()
    //     .dialog(new REROL_damien_i_told_you_what_i_saw in thePlayer, true)
    //     .play(npc_actor);
    // }
    // else {
    //   (new RER_RandomDialogBuilder in thePlayer)
    //     .start()
    //     .dialog(new REROL_not_the_first_time in thePlayer, true)
    //     .play();

    //   (new RER_RandomDialogBuilder in thePlayer)
    //     .start()
    //     .dialog(new REROL_damien_must_you_always in thePlayer, true)
    //     .dialog(new REROL_damien_i_told_you_what_i_saw in thePlayer, true)
    //     .play(npc_actor);
    // }

    (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .dialog(new REROL_damien_all_brainless_beasts in thePlayer, true)
        .dialog(new REROL_damien_do_you_have_a_plan in thePlayer, true)
        .play(npc_actor);

    (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .dialog(new REROL_not_sure_monster_no_side_war in thePlayer, true)
        .play();

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_damien_you_certain_of_this in thePlayer, true)
          .play(npc_actor);

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_im_a_monster_slayer in thePlayer, true)
          .play();

    (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .dialog(new REROL_damien_if_thats_how_you_treat_it in thePlayer, true)
        .dialog(new REROL_damien_i_should_double_patrols in thePlayer, true)
        .play(npc_actor);

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .either(new REROL_this_is_work_for_witcher in thePlayer, true, 1)
          .either(new REROL_send_them_certain_death in thePlayer, true, 1)
          .either(new REROL_boys_could_handle_monsters in thePlayer, true, 1)
          .play();

    if (RandRange(10) > 5) {
      (new RER_RandomDialogBuilder in thePlayer)
        .start()
        .either(new REROL_damien_to_a_lone_witcher in thePlayer, true, 1)
        .either(new REROL_damien_my_guardsmen_in_action in thePlayer, true, 1)
        .play(npc_actor);
    }

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_got_a_different_plan in thePlayer, true)
          .play();

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_damien_and_what_would_that_be in thePlayer, true)
          .play(npc_actor);

    (new RER_RandomDialogBuilder in thePlayer)
            .start()
            .dialog(new REROL_i_see_the_wounds in thePlayer, true)
            .dialog(new REROL_any_witnesses in thePlayer, true)
            .play();

    (new RER_RandomDialogBuilder in thePlayer)
          .start()
          .dialog(new REROL_damien_do_you_believe_me_an_amateur in thePlayer, true)
          .play(npc_actor);

    (new RER_RandomDialogBuilder in thePlayer)
            .start()
            .either(new REROL_fine_show_me_where_monsters in thePlayer, true, 1)
            .either(new REROL_fine_ill_see_what_i_can_do in thePlayer, true, 1)
            .play();

    (new RER_RandomDialogBuilder in thePlayer)
      .start()
      .either(new REROL_damien_i_thank_you_witcher in thePlayer, true, 1)
      .either(new REROL_damien_thank_you_i_hope_youre_worth_the_coin in thePlayer, true, 1)
      .either(new REROL_damien_good_luck in thePlayer, true, 1)
      .either(new REROL_damien_i_see_the_effort_you_put in thePlayer, true, 1)
      .then()
      .dialog(new REROL_damien_onward_witcher in thePlayer, true)
      .play(npc_actor);

    // if (RandRange(10) < 2) {
    //   (new RER_RandomDialogBuilder in thePlayer)
    //       .start()
    //       .dialog(new REROL_damien_very_well_you_must_behave_less_like_thug in thePlayer, true)
    //       .either(new REROL_damien_ive_heard_much_about_you in thePlayer, true, 1)
    //       .either(new REROL_damien_youd_best_maintain_silence in thePlayer, true, 1)
    //       .then()
    //       .dialog(new REROL_damien_thank_you_i_hope_youre_worth_the_coin in thePlayer, true)
    //       .either(new REROL_damien_do_not_tarry_time_is_not_our_friend in thePlayer, true, 1)
    //       .either(new REROL_damien_why_do_you_wait_save_them in thePlayer, true, 1)
    //       .play(npc_actor);
    // }
    // else {
    //   (new RER_RandomDialogBuilder in thePlayer)
    //       .start()
    //       .either(new REROL_damien_i_agree_with_you in thePlayer, true, 1)
    //       .either(new REROL_damien_will_start_at_the_beginning in thePlayer, true, 1)
    //       .then()
    //       .either(new REROL_damien_i_thank_you_witcher in thePlayer, true, 1)
    //       .either(new REROL_damien_thank_you_i_hope_youre_worth_the_coin in thePlayer, true, 1)
    //       .either(new REROL_damien_good_luck in thePlayer, true, 1)
    //       .either(new REROL_damien_i_see_the_effort_you_put in thePlayer, true, 1)
    //       .then()
    //       .dialog(new REROL_damien_onward_witcher in thePlayer, true)
    //       .play(npc_actor);
    // }
  }
}
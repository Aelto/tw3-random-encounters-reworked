
state CluesInvestigate in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State CluesInvestigate");

    this.CluesInvestigate_Main();
  }

  entry function CluesInvestigate_Main() {
    this.pickRandomBestiaryEntry();
    this.createClues();
    this.waitUntilPlayerReachesFirstClue();
    this.createLastClues();
    this.waitUntilPlayerReachesLastClue();
    this.CluesInvestigate_goToNextState();
  }

  latent function pickRandomBestiaryEntry() {
    parent.chosen_bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(parent.master, EncounterType_CONTRACT);

    parent.number_of_creatures = rollDifficultyFactor(
      parent.chosen_bestiary_entry.template_list.difficulty_factor,
      parent.master.settings.selectedDifficulty
    );

    LogChannel('modrandomencounters', "chosen bestiary entry" + parent.chosen_bestiary_entry.type);
  }

  var investigation_radius: int;
  default investigation_radius = 15;

  latent function createClues() {
    var found_initial_position: bool;
    var max_number_of_clues: int;
    var current_clue_position: Vector;
    var i: int;
    
    // 1. first find the place where the clues will be created
    found_initial_position = getRandomPositionBehindCamera(
      parent.investigation_center_position,
      parent.master.settings.minimum_spawn_distance
      + parent.master.settings.spawn_diameter,
      parent.master.settings.minimum_spawn_distance,
      10
    );

    if (!found_initial_position) {
      parent.GotoState('Ending');

      return;
    }

    // 2. load all the needed resources
    parent.track_resource = (CEntityTemplate)LoadResourceAsync(
      "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\entities\mh202_nekker_tracks.w2ent",
      true
    );

    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_01.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_03.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_05.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\bandit_corpses\bandit_corpses_06.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_02_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_03_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_04_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_05_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_06_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_07_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\corpse_08_nml_villager.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_01_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_02_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_03_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_04_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_05_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_06_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\novigrad_citizen\corpse_07_novigrad.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_01_nml_woman.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_02_nml_woman.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_03_nml_woman.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_04_nml_woman.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_woman\corpse_05_nml_woman.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_01.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_02.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\merchant\merchant_corpses_03.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_01.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_02.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_03.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_04.w2ent", true));
    parent.corpse_reources.PushBack((CEntityTemplate)LoadResourceAsync("environment\decorations\corpses\human_corpses\nml_villagers\model\nml_villager_corpse_05.w2ent", true));

    parent.blood_resources = parent
      .master
      .resources
      .getBloodSplatsResources();

    parent.blood_resources_size = parent.blood_resources.Size();

    // 3. we place the clues randomly
    // 3.1 first by placing the corpses
    max_number_of_clues = RandRange(20, 10);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent.investigation_clues.PushBack(
        theGame.CreateEntity(
          parent.getRandomCorpseResource(),
          current_clue_position,
          RotRand(0, 360)
        )
      );
    }

    // 3.2 then we place some random tracks
    max_number_of_clues = RandRange(120, 60);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent.addTrackHere(current_clue_position, RotRand(0, 360));
    }

    // 3.3 then we place lots of blood
    max_number_of_clues = RandRange(100, 200);

    for (i = 0; i < max_number_of_clues; i += 1) {
      current_clue_position = parent.investigation_center_position 
        + VecRingRand(0, this.investigation_radius);

      FixZAxis(current_clue_position);

      parent.addBloodTrackHere(current_clue_position);
    }
  }

  latent function waitUntilPlayerReachesFirstClue() {
    var distance_from_player: float;

    // 1. first we wait until the player is in the investigation radius
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.investigation_center_position); 

      Sleep(0.5);
    } while (distance_from_player > this.investigation_radius * this.investigation_radius);

    // 2. once the player is in the radius, we play sone oneliners
    if (RandRange(10) < 2) {
      REROL_so_many_corpses();

      // a small sleep to leave some space between the oneliners
      Sleep(0.5);
    }

    REROL_died_recently();
  }


  latent function createLastClues() {
    var number_of_foot_paths: int;
    var current_track_position: Vector;
    var current_track_heading: float;
    var i: int;

    LogChannel('modRandomEncounters', "creating Last clues");

    // 1. we search for a random position around the site.
    parent.investigation_last_clues_position = parent.investigation_center_position + VecRingRand(
      this.investigation_radius * 2,
      this.investigation_radius * 1.6
    );

    // 2. we place the last clues, tracks leaving the investigation site
    // from somewhere in the investigation radius to the last clues position.
    // We do this multiple times
    number_of_foot_paths = parent.number_of_creatures;

    for (i = 0; i < number_of_foot_paths; i += 1) {
      // 2.1 we find a random position in the investigation radius
      current_track_position = parent.investigation_center_position + VecRingRand(
        0,
        this.investigation_radius
      );

      // 2.2 we slowly move toward the last clues position
      while (VecDistanceSquared(current_track_position, parent.investigation_last_clues_position) > 6 * 6) {
        current_track_heading = VecHeading(parent.investigation_last_clues_position - current_track_position);

        current_track_position += VecConeRand(
          current_track_heading,
          60, // 60 degrees randomness
          1,
          2
        );

        FixZAxis(current_track_position);

        parent.addTrackHere(
          current_track_position,
          VecToRotation(parent.investigation_last_clues_position - current_track_position)
        );

        // SleepOneFrame();
      }
    }
  }

  latent function waitUntilPlayerReachesLastClue() {
    var distance_from_player: float;

    Sleep(1);

    // 1. first we wait until the player is near the last investigation clues
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.investigation_last_clues_position);

      Sleep(0.2);
    } while (distance_from_player > 15 * 15);

    // 2. once the player is near, we play some oneliners
    REROL_wonder_clues_will_lead_me();
  }

  latent function CluesInvestigate_goToNextState() {
    parent.GotoState('CluesFollow');
  }
}

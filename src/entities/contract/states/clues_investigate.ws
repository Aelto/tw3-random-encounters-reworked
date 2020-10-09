
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

  var has_necrophages_with_clues: bool;

  var eating_animation_slot: CAIPlayAnimationSlotAction;

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

    // 4. there is a chance necrophages are feeding on the corpses
    if (RandRange(10) < 6) {
      this.addNecrophagesWithClues();
    }
  }

  private latent function addNecrophagesWithClues() {
    var number_of_necropages: int;
    var necrophages_bestiary_entry: RER_BestiaryEntry;
    var creatures_templates: EnemyTemplateList;
    var group_positions: array<Vector>;
    var current_template: CEntityTemplate;
    var current_entity_template: SEnemyTemplate;
    var group_positions_index: int;
    var created_entity: CEntity;
    var i: int;
    var j: int;

    necrophages_bestiary_entry = parent
      .master
      .bestiary
      .entries[CreatureGHOUL];

    this.has_necrophages_with_clues = true;

    this.eating_animation_slot = new CAIPlayAnimationSlotAction in this;
    this.eating_animation_slot.OnCreated();
    this.eating_animation_slot.animName = 'exploration_eating_loop';
    this.eating_animation_slot.blendInTime = 1.0f;
    this.eating_animation_slot.blendOutTime = 1.0f;  
    this.eating_animation_slot.slotName = 'NPC_ANIM_SLOT';

    number_of_necropages = rollDifficultyFactor(
      parent.chosen_bestiary_entry.template_list.difficulty_factor,
      parent.master.settings.selectedDifficulty
    );

    creatures_templates = fillEnemyTemplateList(
      necrophages_bestiary_entry.template_list,
      number_of_necropages,
      parent.master.settings.only_known_bestiary_creatures
    );

    group_positions = getGroupPositions(
      parent.investigation_center_position,
      number_of_necropages,
      0.01
    );

    for (i = 0; i < creatures_templates.templates.Size(); i += 1) {
      current_entity_template = creatures_templates.templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

        FixZAxis(group_positions[group_positions_index]);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entity = theGame.CreateEntity(
            current_template,
            group_positions[group_positions_index],
            thePlayer.GetWorldRotation()
          );

          ((CNewNPC)created_entity).SetLevel(
            getRandomLevelBasedOnSettings(parent.master.settings)
          );

          parent.entities.PushBack(created_entity);

          group_positions_index += 1;
        }
      }
    }

    if (!parent.master.settings.enable_encounters_loot) {
      parent.removeAllLoot();
    }

    // TODO: handle settings like trophies
  }

  latent function waitUntilPlayerReachesFirstClue() {
    var distance_from_player: float;

    // 1. first we wait until the player is in the investigation radius
    do {
      distance_from_player = VecDistanceSquared(thePlayer.GetWorldPosition(), parent.investigation_center_position);

      if (this.has_necrophages_with_clues) {
        if (parent.hasOneOfTheEntitiesGeraltAsTarget()) {
          break;
        }

        this.playEatingAnimationNecrophages();
      }

      Sleep(0.5);
    } while (distance_from_player > this.investigation_radius * this.investigation_radius);

    if (this.has_necrophages_with_clues) {
      REROL_necrophages_great();

      this.makeNecrophagesTargetPlayer();

      this.waitUntilAllEntitiesAreDead();
      parent.entities.Clear();

      Sleep(0.5);
    }

    // 2. once the player is in the radius, we play sone oneliners
    //    cannot play if there were necrophages around the corpses.
    if (!this.has_necrophages_with_clues && RandRange(10) < 2) {
      REROL_so_many_corpses();

      // a small sleep to leave some space between the oneliners
      Sleep(0.5);
    }

    REROL_died_recently();
  }

  private latent function playEatingAnimationNecrophages() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'q104_avallach_friendly_to_all',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).ForgetAllActors();

      ((CActor)parent.entities[i]).ForceAIBehavior(this.eating_animation_slot, BTAP_Emergency);
    }
  }

  private latent function makeNecrophagesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      // ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  private latent function waitUntilAllEntitiesAreDead() {
    while (!parent.areAllEntitiesDead()) {
      Sleep(0.4);
    }
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

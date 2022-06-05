
/**
 * In this state we display a list of dialogue options to the player so that
 * he can pick the contract he likes.
 */
state DialogChoice in RER_ContractManager {
  var camera: SU_StaticCamera;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_ContractManager - state DialogChoice");

    this.DialogChoice_main();
  }

  private var menu_distance_value: float;

  entry function DialogChoice_main() {
    this.startNoticeboardCutscene();
    this.DialogChoice_prepareAndDisplayDialogueChoices();
  }

  private latent function startNoticeboardCutscene() {
    var noticeboard: W3NoticeBoard;

    REROL_mhm();
    Sleep(0.1);

    this.camera = SU_getStaticCamera();
    noticeboard = parent.getNearbyNoticeboard();
    
    this.camera.teleportAndLookAt(
      noticeboard.GetWorldPosition() + VecFromHeading(noticeboard.GetHeading()) * 2 + Vector(0, 0, 1.5),
      noticeboard.GetWorldPosition() + Vector(0, 0, 1.5)
    );

    theGame.FadeOut(0.2);
    this.camera.start();
    theGame.FadeInAsync(0.4);
  }

  private latent function DialogChoice_prepareAndDisplayDialogueChoices() {
    var noticeboard_identifier: RER_NoticeboardIdentifier;
    var selected_difficulty: RER_ContractDifficultyLevel;
    var contract_identifier: RER_ContractIdentifier;
    var generation_time: RER_GenerationTime;
    var random_creature_type: CreatureType;
    var reputation_system_enabled: bool;
    var required_time_elapsed: float;
    var choices: array<SSceneChoice>;
    var creature_type_choices: array<CreatureType>;
    var rng: RandomNumberGenerator;
    var bestiary_entry: RER_BestiaryEntry;
    var amount_of_options: int;
    var line: string;
    var i: int;

    generation_time = parent.getGenerationTime(GameTimeHours(theGame.CalculateTimePlayed()));
    reputation_system_enabled = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERcontractsReputationSystemEnabled');
    
    if (parent.isItTimeToRegenerateContracts(generation_time)) {
      parent.updateStorageGenerationTime(generation_time);
    }

    noticeboard_identifier = parent.getUniqueIdFromNoticeboard(parent.getNearbyNoticeboard());
    selected_difficulty = parent.selected_difficulty;
    rng = this.getRandomNumberGenerator(noticeboard_identifier, generation_time, selected_difficulty);

    line = GetLocStringByKey("rer_available_rewards");
    line = StrReplace(line, "{{rewards_list}}", RER_getLocalizedRewardTypesFromFlag(
      RER_getAllowedContractRewardsMaskFromRegion()
      | RER_getRandomAllowedRewardType(parent, noticeboard_identifier)
    ));

    choices.PushBack(SSceneChoice(
      upperCaseFirstLetter(line),
      false,
      true, // already choosen
      true, // disabled
      DialogAction_MONSTERCONTRACT,
      'StartContractDifficultyEasyDistanceClose'
    ));

    if (reputation_system_enabled) {
      line = GetLocStringByKey("rer_current_reputation");
      line = StrReplace(line, "{{reputation}}", parent.getNoticeboardReputation(noticeboard_identifier));

      choices.PushBack(SSceneChoice(
        upperCaseFirstLetter(line),
        false,
        true, // already choosen
        true, // disabled
        DialogAction_MONSTERCONTRACT,
        'StartContractDifficultyEasyDistanceClose'
      ));
    }

    for (i = 0; i < 3; i += 1) {
      random_creature_type = RER_getSeededRandomCreatureType(parent.master, selected_difficulty, rng);
      creature_type_choices.PushBack(random_creature_type);

      contract_identifier = parent.getUniqueIdFromContract(
        noticeboard_identifier,
        selected_difficulty,
        random_creature_type,
        generation_time,
        i
      );

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{difficulty}}", "(" + selected_difficulty.value + ")");
      line = StrReplace(line, "{{species}}", upperCaseFirstLetter(getCreatureNameFromCreatureType(parent.master.bestiary, random_creature_type)));

      NLOG("Adding contract choice, uuid = " + contract_identifier.identifier);

      choices.PushBack(SSceneChoice(
        upperCaseFirstLetter(line),
        false,
        parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartContractDifficultyEasy'
      ));
    }

    choices.PushBack(SSceneChoice(
      GetLocStringByKey("rer_cancel"),
      false,
      false,
      false,
      DialogAction_EXIT,
      'Cancel'
    ));

    this.displayDialogChoices(choices, creature_type_choices, noticeboard_identifier, generation_time, selected_difficulty, rng);
  }

  latent function displayDialogChoices(choices: array<SSceneChoice>, creature_type_choices: array<CreatureType>, noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, difficulty: RER_ContractDifficultyLevel, rng: RandomNumberGenerator) {
    var creature_type: CreatureType;
    var response: SSceneChoice;
    var i: int;

    // while on gamepad, the interact input is directly sent in the dialog choice
    // it is safer to wait a bit before capturing the input.
    Sleep(0.25);

    while (true) {
      response = SU_setDialogChoicesAndWaitForResponse(choices);
      SU_closeDialogChoiceInterface();

      if (response.previouslyChoosen) {
        continue;
      }

      if (!IsNameValid(response.playGoChunk) || response.playGoChunk == 'Cancel') {
        this.camera.Stop();
        Sleep(0.25);
        parent.GotoState('Waiting');
        return;
      }

      for (i = 0; i < 3; i += 1) {
        // get the choices starting at 4th from last until 2nd to last, as the last
        // is the exit choice
        if (choices[choices.Size() - 4 + i].description == response.description) {
          creature_type = creature_type_choices[i];

          break;
        }
      }

      if (i > 3) {
        NDEBUG("RER ERROR: Unable to get creature_type from dialogue choices");
      }

      this.acceptContract(creature_type, noticeboard_identifier, generation_time, difficulty, rng, i);
    }
  }

  function getRandomNumberGenerator(noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, difficulty: RER_ContractDifficultyLevel): RandomNumberGenerator {
    var rng: RandomNumberGenerator;
    var menu_seed: float;

    menu_seed = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERcontractsGenerationSeed')
    );
    rng = new RandomNumberGenerator in this;

    return rng
      .setSeed((int)(menu_seed + RER_identifierToInt(noticeboard_identifier.identifier) + generation_time.time + difficulty.value))
      .useSeed(true);
  }

  latent function acceptContract(creature_type: CreatureType, noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, difficulty: RER_ContractDifficultyLevel, rng: RandomNumberGenerator, index: int) {
    var contract_data: RER_ContractGenerationData;
    var creature_t: RER_ContractRepresentation;
    var bestiary_entry: RER_BestiaryEntry;
    var nearby_noticeboard: W3NoticeBoard;

    nearby_noticeboard = parent.getNearbyNoticeboard();

    contract_data = RER_ContractGenerationData();
    contract_data.creature_type = creature_type;
    contract_data.difficulty_level = difficulty;
    
    contract_data.noticeboard_identifier = noticeboard_identifier;
    contract_data.identifier = parent.getUniqueIdFromContract(
      noticeboard_identifier,
      contract_data.difficulty_level,
      creature_type,
      generation_time,
      index
    );

    rng.setSeed(RER_identifierToInt(contract_data.identifier.identifier));
    rng.next();
    contract_data.rng_seed = (int)rng.previous_number + rng.seed;

    NLOG("acceptContract(), contract_data.identifier.identifier = " + contract_data.identifier.identifier + " contract_data.rng_seed = " + contract_data.rng_seed);

    contract_data.region_name = SUH_getCurrentRegion();
    contract_data.starting_point = nearby_noticeboard.GetWorldPosition();

    parent.master.storages.contract.active_contract = parent.generateContract(contract_data);
    parent.master.storages.contract.has_ongoing_contract = true;
    parent.master.storages.contract.save();

    theSound.SoundEvent("gui_ingame_quest_active");
    this.camera.Stop();

    Sleep(1.5);
    NHUD(
      StrReplace(
        GetLocStringByKey('rer_contract_started'),
        "{{species}}",
        getCreatureNameFromCreatureType(parent.master.bestiary, creature_type)
      )
    );

    parent.GotoState('Processing');
  }
}
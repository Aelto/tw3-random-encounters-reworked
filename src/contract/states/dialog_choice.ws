
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

    Sleep(0.25);
  }

  event OnLeaveState( nextStateName : name ) {
    this.camera.Stop();
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
    noticeboard = this.getNearbyNoticeboard();
    
    this.camera.teleportAndLookAt(
      noticeboard.GetWorldPosition() + VecFromHeading(noticeboard.GetHeading()) * 2 + Vector(0, 0, 1.5),
      noticeboard.GetWorldPosition() + Vector(0, 0, 1.5)
    );

    theGame.FadeOut(0.2);
    this.camera.start();
    theGame.FadeInAsync(0.4);

    RER_tutorialTryShowNoticeboard();
  }

  private latent function DialogChoice_prepareAndDisplayDialogueChoices() {
    var noticeboard_identifier: RER_NoticeboardIdentifier;
    var contract_identifier: RER_ContractIdentifier;
    var generation_time: RER_GenerationTime;
    var random_species: RER_SpeciesTypes;
    var required_time_elapsed: float;
    var choices: array<SSceneChoice>;
    var rng: RandomNumberGenerator;
    var amount_of_options: int;
    var line: string;
    var i: int;

    generation_time = parent.getGenerationTime(GameTimeHours(theGame.CalculateTimePlayed()));
    
    if (parent.isItTimeToRegenerateContracts(generation_time)) {
      parent.updateStorageGenerationTime(generation_time);
    }

    noticeboard_identifier = parent.getUniqueIdFromNoticeboard(this.getNearbyNoticeboard());
    rng = this.getRandomNumberGenerator(noticeboard_identifier, generation_time);

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

    if (parent.hasRequiredReputationForContractAtNoticeboard(noticeboard_identifier, ContractDifficulty_EASY)) {
      // easy,
      // easy contracts are always NEARBY

      amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'REReasyContractsNumber'));

      for (i = 0; i < amount_of_options; i += 1) {
        random_species = RER_getSeededRandomSpeciesType(rng);

        line = GetLocStringByKey("rer_contract_dialog_choice");
        line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_nearby")));
        line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_easy")));
        line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(random_species)));

        contract_identifier = parent.getUniqueIdFromContract(
          noticeboard_identifier,
          ContractDistance_NEARBY, // is_far
          ContractDifficulty_EASY, // difficulty
          random_species,
          generation_time
        );

        NLOG("Adding contract choice, uuid = " + contract_identifier.identifier);

        choices.PushBack(SSceneChoice(
          upperCaseFirstLetter(line),
          false,
          parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
          false,
          DialogAction_MONSTERCONTRACT,
          'StartContractDifficultyEasyDistanceNearby'
        ));
      }
    }
    else {
      line = GetLocStringByKey("rer_complete_more_contracts");
      choices.PushBack(SSceneChoice(
        upperCaseFirstLetter(line),
        false,
        true, // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'NotEnoughReputation'
      ));
    }
    

    if (parent.hasRequiredReputationForContractAtNoticeboard(noticeboard_identifier, ContractDifficulty_MEDIUM)) {
      // close & medium
      amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERmediumNearbyContractsNumber'));

      for (i = 0; i < amount_of_options; i += 1) {
        random_species = RER_getSeededRandomSpeciesType(rng);

        line = GetLocStringByKey("rer_contract_dialog_choice");
        line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_close")));
        line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_medium")));
        line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(random_species)));

        contract_identifier = parent.getUniqueIdFromContract(
          noticeboard_identifier,
          ContractDistance_CLOSE, // is_far
          ContractDifficulty_MEDIUM, // difficulty
          random_species,
          generation_time
        );

        NLOG("Adding contract choice, uuid = " + contract_identifier.identifier);

        choices.PushBack(SSceneChoice(
          upperCaseFirstLetter(line),
          false,
          parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
          false,
          DialogAction_MONSTERCONTRACT,
          'StartContractDifficultyMediumDistanceClose'
        ));
      }

      // far & medium
      amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERmediumFarContractsNumber'));

      for (i = 0; i < amount_of_options; i += 1) {
        random_species = RER_getSeededRandomSpeciesType(rng);

        line = GetLocStringByKey("rer_contract_dialog_choice");
        line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_far")));
        line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_medium")));
        line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(random_species)));

        contract_identifier = parent.getUniqueIdFromContract(
          noticeboard_identifier,
          ContractDistance_FAR, // is_far
          ContractDifficulty_MEDIUM, // difficulty
          random_species,
          generation_time
        );

        choices.PushBack(SSceneChoice(
          upperCaseFirstLetter(line),
          false,
          parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
          false,
          DialogAction_MONSTERCONTRACT,
          'StartContractDifficultyMediumDistanceFar'
        ));
      }
    }
    else {
      line = GetLocStringByKey("rer_complete_more_contracts");
      choices.PushBack(SSceneChoice(
        upperCaseFirstLetter(line),
        false,
        true, // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'NotEnoughReputation'
      ));
    }

    if (parent.hasRequiredReputationForContractAtNoticeboard(noticeboard_identifier, ContractDifficulty_HARD)) {
      // close & hard
      amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERhardNearbyContractsNumber'));

      for (i = 0; i < amount_of_options; i += 1) {
        random_species = RER_getSeededRandomSpeciesType(rng);

        line = GetLocStringByKey("rer_contract_dialog_choice");
        line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_close")));
        line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_hard")));
        line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(random_species)));

        contract_identifier = parent.getUniqueIdFromContract(
          noticeboard_identifier,
          ContractDistance_CLOSE, // is_far
          ContractDifficulty_HARD, // difficulty
          random_species,
          generation_time
        );

        choices.PushBack(SSceneChoice(
          upperCaseFirstLetter(line),
          false,
          parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
          false,
          DialogAction_MONSTERCONTRACT,
          'StartContractDifficultyHardDistanceClose'
        ));
      }

      // far & hard
      amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERhardFarContractsNumber'));

      for (i = 0; i < amount_of_options; i += 1) {
        random_species = RER_getSeededRandomSpeciesType(rng);

        line = GetLocStringByKey("rer_contract_dialog_choice");
        line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_far")));
        line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_hard")));
        line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(random_species)));

        contract_identifier = parent.getUniqueIdFromContract(
          noticeboard_identifier,
          ContractDistance_FAR, // is_far
          ContractDifficulty_HARD, // difficulty
          random_species,
          generation_time
        );

        choices.PushBack(SSceneChoice(
          upperCaseFirstLetter(line),
          false,
          parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
          false,
          DialogAction_MONSTERCONTRACT,
          'StartContractDifficultyHardDistanceFar'
        ));
      }
    }
    else {
      line = GetLocStringByKey("rer_complete_more_contracts");
      choices.PushBack(SSceneChoice(
        upperCaseFirstLetter(line),
        false,
        true, // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'NotEnoughReputation'
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

    this.displayDialogChoices(choices, noticeboard_identifier, generation_time, rng);
  }

  latent function displayDialogChoices(choices: array<SSceneChoice>, noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, rng: RandomNumberGenerator) {
    var response: SSceneChoice;

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
        Sleep(0.25);
        parent.GotoState('Waiting');
        return;
      }

      this.acceptContract(response, noticeboard_identifier, generation_time, rng);  
    }
  }

  function getNearbyNoticeboard(): W3NoticeBoard {
    var entities: array<CGameplayEntity>;
    var board: W3NoticeBoard;
    var i: int;

    FindGameplayEntitiesInRange(
      entities,
      thePlayer,
      20, // range, 
      1, // max results
      , // tag: optional value
      FLAG_ExcludePlayer,
      , // optional value
      'W3NoticeBoard'
    );

    // bold move here, if there are no noticeboard nearby the game will crash.
    board = (W3NoticeBoard)entities[0];

    return board;
  }

  function getRandomNumberGenerator(noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime): RandomNumberGenerator {
    var rng: RandomNumberGenerator;
    var menu_seed: float;

    menu_seed = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERcontractsGenerationSeed')
    );
    rng = new RandomNumberGenerator in this;

    return rng
      .setSeed((int)(menu_seed + RER_identifierToInt(noticeboard_identifier.identifier) + generation_time.time))
      .useSeed(true);
  }

  latent function acceptContract(response: SSceneChoice, noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, rng: RandomNumberGenerator) {
    var contract_data: RER_ContractGenerationData;
    var nearby_noticeboard: W3NoticeBoard;

    nearby_noticeboard = this.getNearbyNoticeboard();

    // here we'll do a bit of an ugly hack:
    // to get the data we displayed in the choice we will extract the localized
    // text from the strings and do according to that.
    contract_data = RER_ContractGenerationData();
    contract_data.species = RER_getSpeciesFromLocalizedString(response.description);
    
    if (StrContains(NameToString(response.playGoChunk), "DifficultyHard")) {
      contract_data.difficulty = ContractDifficulty_HARD;
    }
    else if (StrContains(NameToString(response.playGoChunk)), "DifficultyMedium") {
      contract_data.difficulty = ContractDifficulty_MEDIUM;
    }
    else {
      contract_data.difficulty = ContractDifficulty_EASY;
    }

    if (StrContains(NameToString(response.playGoChunk), "DistanceFar")) {
      contract_data.distance = ContractDistance_FAR;
    }
    else if (StrContains(NameToString(response.playGoChunk), "DistanceNearby")) {
      contract_data.distance = ContractDistance_NEARBY;
    }
    else {
      contract_data.distance = ContractDistance_CLOSE;
    }

    contract_data.noticeboard_identifier = noticeboard_identifier;
    contract_data.identifier = parent.getUniqueIdFromContract(
      noticeboard_identifier,
      contract_data.distance,
      contract_data.difficulty, // difficulty
      contract_data.species,
      generation_time
    );

    rng.setSeed(RER_identifierToInt(contract_data.identifier.identifier));
    rng.next();
    contract_data.rng_seed = (int)rng.previous_number + rng.seed;

    contract_data.region_name = SUH_getCurrentRegion();
    contract_data.starting_point = nearby_noticeboard.GetWorldPosition();

    parent.master.storages.contract.ongoing_contract = parent.generateContract(contract_data);
    parent.master.storages.contract.has_ongoing_contract = true;
    parent.master.storages.contract.save();

    theSound.SoundEvent("gui_ingame_quest_active");

    Sleep(1.5);
    NHUD(
      StrReplace(
        GetLocStringByKey('rer_contract_started'),
        "{{species}}",
        RER_getSpeciesLocalizedString(contract_data.species)
      )
    );

    parent.GotoState('Processing');
  }
}
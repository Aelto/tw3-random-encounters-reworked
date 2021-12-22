
/**
 * In this state we display a list of dialogue options to the player so that
 * he can pick the contract he likes.
 */
state DialogChoice in RER_ContractManager {
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
    RER_tutorialTryShowNoticeboard();

    Sleep(0.1);
    REROL_mhm();
    Sleep(0.1);
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
      line,
      false,
      true, // already choosen
      true, // disabled
      DialogAction_MONSTERCONTRACT,
      'StartContractDifficultyEasyDistanceClose'
    ));

    // close & easy
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'REReasyNearbyContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_close")));
      line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_easy")));
      line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

      contract_identifier = parent.getUniqueIdFromContract(
        noticeboard_identifier,
        false, // is_far
        false, // is_hard
        random_species,
        generation_time
      );

      choices.PushBack(SSceneChoice(
        line,
        false,
        parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartContractDifficultyEasyDistanceClose'
      ));
    }

    // far & easy
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'REReasyFarContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_far")));
      line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_easy")));
      line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

      contract_identifier = parent.getUniqueIdFromContract(
        noticeboard_identifier,
        true, // is_far
        false, // is_hard
        random_species,
        generation_time
      );

      choices.PushBack(SSceneChoice(
        line,
        false,
        parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartContractDifficultyEasyDistanceFar'
      ));
    }

    // close & hard
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERhardNearbyContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", StrLowerUTF(GetLocStringByKey("rer_distance_close")));
      line = StrReplace(line, "{{difficulty}}", StrLowerUTF(GetLocStringByKey("preset_value_rer_hard")));
      line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

      contract_identifier = parent.getUniqueIdFromContract(
        noticeboard_identifier,
        false, // is_far
        true, // is_hard
        random_species,
        generation_time
      );

      choices.PushBack(SSceneChoice(
        line,
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
      line = StrReplace(line, "{{species}}", StrLowerUTF(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

      contract_identifier = parent.getUniqueIdFromContract(
        noticeboard_identifier,
        true, // is_far
        true, // is_hard
        random_species,
        generation_time
      );

      choices.PushBack(SSceneChoice(
        line,
        false,
        parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartContractDifficultyHardDistanceFar'
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

      if (response.playGoChunk == 'Cancel') {
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
      .setSeed((int)(menu_seed + noticeboard_identifier.identifier + generation_time.time))
      .useSeed(true);
  }

  function acceptContract(response: SSceneChoice, noticeboard_identifier: RER_NoticeboardIdentifier, generation_time: RER_GenerationTime, rng: RandomNumberGenerator) {
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
    else {
      contract_data.difficulty = ContractDifficulty_EASY;
    }

    if (StrContains(NameToString(response.playGoChunk), "DistanceFar")) {
      contract_data.distance = ContractDistance_FAR;
    }
    else {
      contract_data.distance = ContractDistance_CLOSE;
    }

    contract_data.noticeboard_identifier = noticeboard_identifier;
    contract_data.identifier = parent.getUniqueIdFromContract(
      noticeboard_identifier,
      contract_data.distance == ContractDistance_FAR, // is_far
      contract_data.difficulty == ContractDifficulty_HARD, // is_hard
      contract_data.species,
      generation_time
    );

    contract_data.rng_seed = (int)rng.previous_number + rng.seed;
    contract_data.region_name = SUH_getCurrentRegion();
    contract_data.starting_point = nearby_noticeboard.GetWorldPosition();

    parent.master.storages.contract.ongoing_contract = parent.generateContract(contract_data);
    parent.master.storages.contract.has_ongoing_contract = true;
    parent.master.storages.contract.save();

    parent.GotoState('Processing');
  }
}
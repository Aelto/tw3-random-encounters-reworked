
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

    // close & easy
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'REReasyNearbyContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", GetLocStringByKey("rer_distance_close"));
      line = StrReplace(line, "{{difficulty}}", GetLocStringByKey("preset_value_rer_easy"));
      line = StrReplace(line, "{{species}}", GetLocStringByKey(RER_getSpeciesLocalizedString(random_species)));

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
        !parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartEasyCloseContract'
      ));
    }

    // far & easy
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'REReasyFarContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", GetLocStringByKey("rer_distance_far"));
      line = StrReplace(line, "{{difficulty}}", GetLocStringByKey("preset_value_rer_easy"));
      line = StrReplace(line, "{{species}}", GetLocStringByKey(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

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
        !parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartEasyCloseContract'
      ));
    }

    // close & hard
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERcloseNearbyContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", GetLocStringByKey("rer_distance_close"));
      line = StrReplace(line, "{{difficulty}}", GetLocStringByKey("preset_value_rer_hard"));
      line = StrReplace(line, "{{species}}", GetLocStringByKey(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

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
        !parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartEasyCloseContract'
      ));
    }

    // far & hard
    amount_of_options = StringToInt(theGame.GetInGameConfigWrapper().GetVarValue('RERcontracts', 'RERcloseFarContractsNumber'));

    for (i = 0; i < amount_of_options; i += 1) {
      random_species = RER_getSeededRandomSpeciesType(rng);

      line = GetLocStringByKey("rer_contract_dialog_choice");
      line = StrReplace(line, "{{distance}}", GetLocStringByKey("rer_distance_far"));
      line = StrReplace(line, "{{difficulty}}", GetLocStringByKey("preset_value_rer_hard"));
      line = StrReplace(line, "{{species}}", GetLocStringByKey(RER_getSpeciesLocalizedString(RER_getSeededRandomSpeciesType(rng))));

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
        !parent.isContractInStorageCompletedContracts(contract_identifier), // already choosen
        false,
        DialogAction_MONSTERCONTRACT,
        'StartEasyCloseContract'
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

    this.displayDialogChoices(choices);
  }

  latent function displayDialogChoices(choices: array<SSceneChoice>) {
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

      if (response.playGoChunk == 'EasyCloseContract') {
        parent.GotoState('StartEasyCloseContract');
        return;
      }

      if (response.playGoChunk == 'HardCloseContract') {
        parent.GotoState('StartHardCloseContract');
        return;
      }

      if (response.playGoChunk == 'EasyFarContract') {
        parent.GotoState('StartEasyFarContract');
        return;
      }

      if (response.playGoChunk == 'HardFarContract') {
        parent.GotoState('StartHardFarContract');
        return;
      }

      if (response.playGoChunk == 'Cancel') {
        return;
      }
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
}
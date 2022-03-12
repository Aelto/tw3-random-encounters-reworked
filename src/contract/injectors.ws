
function RER_addNoticeboardInjectors() {
  var entities: array<CGameplayEntity>;
  var board: W3NoticeBoard;
  var i: int;

  FindGameplayEntitiesInRange(
    entities,
    thePlayer,
    5000, // range, 
    100, // max results
    , // tag: optional value
    FLAG_ExcludePlayer,
    , // optional value
    'W3NoticeBoard'
  );

  for (i = 0; i < entities.Size(); i += 1) {
    board = (W3NoticeBoard)entities[i];
    
    if (board && !SU_hasErrandInjectorWithTag(board, "RER_ContractErrandInjector")) {
      NLOG("adding errand injector to 1 board");
      board.addErrandInjector(new RER_ContractErrandInjector in board);
    }
  }
}

class RER_ContractErrandInjector extends SU_ErrandInjector {
  default tag = "RER_ContractErrandInjector";
  
  public function run(out board: W3NoticeBoard) {
    var identifier: RER_NoticeboardIdentifier;
    var reputation_system_enabled: bool;
    var master: CRandomEncounters;
    var can_inject_errand: bool;

    can_inject_errand = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERnoticeboardErrands');

    if (!can_inject_errand) {
      return;
    }

    if (!getRandomEncounters(master)) {
      NLOG("ERROR: could not get the RER entity for RER_ContractErrandInjector.");

      return;
    }

    reputation_system_enabled = theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERcontractsReputationSystemEnabled');

    identifier = master.contract_manager.getUniqueIdFromNoticeboard(board);

    // if the reputation system is enabled but the player
    // does not meet the requirement to see the vanilla
    // contracts yet, we remove all of the quest contracts
    // before injecting our errand.
    if (reputation_system_enabled && !master.contract_manager.hasRequiredReputationForNoticeboard(identifier)) {
      this.removeAllQuestErrands(board);
    }

    SU_replaceFlawWithErrand(board, "rer_noticeboard_errand_1");
  }

  public function accepted(out board: W3NoticeBoard, errand_name: string) {
    var rer_entity: CRandomEncounters;

    if (errand_name != "rer_noticeboard_errand_1") {
      return;
    }

    if (getRandomEncounters(rer_entity)) {
      rer_entity.contract_manager.pickedContractNoticeFromNoticeboard(errand_name);
    }
  }

  private function removeAllQuestErrands(out board: W3NoticeBoard) {
    var i: int;

    NLOG("removeAllQuestErrands");

    i = board.activeErrands.Size();
    while (i >= 0) {
      if (board.activeErrands[i].newQuestFact == "flaw") {
        continue;
      }

      board.activeErrands.EraseFast(i);
    }
  }
}
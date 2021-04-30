
/**
 * a basic example that shows how to add a custom injector to a nearby
 * noticeboard.
 */
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
    SU_replaceFlawWithErrand(board, "rer_noticeboard_errand_0");
  }

  public function accepted(out board: W3NoticeBoard, errand_name: string) {
    var rer_entity: CRandomEncounters;

    if (errand_name == "rer_noticeboard_errand_0" && getRandomEncounters(rer_entity)) {
      rer_entity.contract_manager.pickedContractNoticeFromNoticeboard();
    }
  }
}
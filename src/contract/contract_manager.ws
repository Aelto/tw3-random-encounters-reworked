
statemachine class RER_contractManager extends CEntity {
  var master: CRandomEncounters;

  function init(_master: CRandomEncounters) {
    this.master = _master;

    this.GotoState('Waiting');
  }

  function pickedContractNoticeFromNoticeboard(errand_name: string) {
    switch (errand_name) {
      case "rer_noticeboard_errand_0":
        this.GotoState('GeneratedContract');
        break;

      case "rer_noticeboard_errand_1":
        this.GotoState('NestContract');
        break;

    }
  }
}
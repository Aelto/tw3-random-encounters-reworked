
exec function rer_start_ambush(optional creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunCreatureAmbush');
}

exec function rer_start_hunt(optional creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunCreatureHunt');
}

exec function rer_start_human(optional human_type: EHumanType, optional count: int) {
  var rer_entity: CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>");

    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, CreatrueNONE);
  exec_runner.RunHumanAmbush_main(human_type, count);
}

// Why a statemachine and a whole class for exec functions
// and console commands?
// Most of RER functions are latent functions to keep things
// asynchronous and not hurt the framerates.
// The only way to call a latent function in from an entry function
// or another latetn function. This is why this class is a statemachine.
// Entry functions are called when the statemachine enters a specific
// state.
statemachine class RER_ExecRunner extends CEntity {
  var master: CRandomEncounters;
  var creature: CreatureType;


  public function init(master: CRandomEncounters, creature: CreatureType) {
    this.master = master;
    this.creature = creature;
  }
}

state RunCreatureAmbush in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunCreatureAmbush");

    this.RunCreatureAmbush_main();
  }

  entry function RunCreatureAmbush_main() {
    createRandomCreatureAmbush(parent.master, parent.creature);
  }
}

state RunCreatureHunt in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunCreatureHunt");

    this.RunCreatureHunt_main();
  }

  entry function RunCreatureHunt_main() {
    createRandomCreatureHunt(parent.master, parent.creature);
  }
}

state RunHumanAmbush in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunHumanAmbush");
  }

  entry function RunHumanAmbush_main(human_type: EHumanType, count: int) {
    var composition: CreatureAmbushWitcherComposition;

    composition = new CreatureAmbushWitcherComposition in master;

    composition.init(parent.master.settings);
    composition.setBestiaryEntry(parent.master.bestiary.human_entries[human_type])
      .setNumberOfCreatures(count)
      .spawn(master);
  }
}
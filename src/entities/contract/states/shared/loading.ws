
state Loading in RandomEncountersReworkedContractEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State Loading");

    this.Loading_main();
  }

  entry function Loading_main() {
    this.Loading_loadTrailMakers();
    this.Loading_loadBasicVariables();    

    parent.GotoState(PhasePick);
  }

  latent function Loading_loadTrailMakers() {
    var trail_resources: array<RER_TrailMakerTrack>;
    var blood_resources: array<RER_TrailMakerTrack>;
    var corpse_resources: array<RER_TrailMakerTrack>;
    var trail_ratio: int;

    switch (parent.chosen_bestiary_entry.type) {
      case CreatureBARGHEST :
      case CreatureWILDHUNT :
      case CreatureNIGHTWRAITH :
      case CreatureNOONWRAITH :
      case CreatureWRAITH :
        // these are the type of creatures where we use fog
        // so we increase the ratio to save performances.
        trail_ratio = parent.master.settings.foottracks_ratio * 4;

      default :
        trail_ratio = parent.master.settings.foottracks_ratio * 1;
    }

    parent.trail_maker = new RER_TrailMaker in this;

    LogChannel('RER', "loading trail_maker, ratio = " + parent.master.settings.foottracks_ratio);
    
    trail_resources.PushBack(
      getTracksTemplateByCreatureType(
        parent.chosen_bestiary_entry.type
      )
    );

    parent.trail_maker.init(
      trail_ratio,
      600,
      trail_resources
    );

    LogChannel('RER', "loading blood_maker");

    blood_resources = parent
        .master
        .resources
        .getBloodSplatsResources();
    
    parent.blood_maker = new RER_TrailMaker in this;
    parent.blood_maker.init(
      parent.master.settings.foottracks_ratio,
      100,
      blood_resources
    );

    LogChannel('RER', "loading corpse_maker");

    corpse_resources = parent
        .master
        .resources
        .getCorpsesResources();

    parent.corpse_maker = new RER_TrailMaker in this;
    parent.corpse_maker.init(
      parent.master.settings.foottracks_ratio,
      50,
      corpse_resources
    );
  }

  function Loading_loadBasicVariables() {
    parent.previous_phase_checkpoint = parent.GetWorldPosition();
    parent.
  }
}


state Loading in RandomEncountersReworkedHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedHuntEntity - State Loading");
    this.Loading_main();
  }

  entry function Loading_main() {
    var template: CEntityTemplate;
    var tracks_templates: array<RER_TrailMakerTrack>;

    template = (CEntityTemplate)LoadResourceAsync("characters\npc_entities\animals\hare.w2ent", true);

    parent.bait_entity = theGame.CreateEntity(
      template,
      parent.GetWorldPosition(),
      parent.GetWorldRotation()
    );

    ((CNewNPC)parent.bait_entity).SetGameplayVisibility(false);
    ((CNewNPC)parent.bait_entity).SetVisibility(false);
    ((CActor)parent.bait_entity).EnableCharacterCollisions(false);
    ((CActor)parent.bait_entity).EnableDynamicCollisions(false);
    ((CActor)parent.bait_entity).EnableStaticCollisions(false);
    ((CActor)parent.bait_entity).SetImmortalityMode(AIM_Immortal, AIC_Default);

    tracks_templates.PushBack(getTracksTemplateByCreatureType(parent.bestiary_entry.type));

    parent.trail_maker = new RER_TrailMaker in parent;
    parent.trail_maker.init(
      parent.master.settings.foottracks_ratio,
      200,
      tracks_templates
    );

    // to calculate the initial position we go from the
    // monsters position and use the inverse tracks_heading to
    // cross ThePlayer's path.
    parent.trail_maker
      .drawTrail(
        VecInterpolate(
          parent.GetWorldPosition(),
          thePlayer.GetWorldPosition(),
          1.3
        ),

        parent.GetWorldPosition(),
        20,,,
        true
      );


    parent.GotoState('Wandering');
  }

  
}


latent function getTracksTemplate(actor : CActor): CEntityTemplate {
  var monsterCategory : EMonsterCategory;
  var soundMonsterName : CName;
  var isTeleporting : bool;
  var canBeTargeted : bool;
  var canBeHitByFists : bool;
  var entity_template: CEntityTemplate;

  theGame.GetMonsterParamsForActor(
    actor,
    monsterCategory,
    soundMonsterName,
    isTeleporting,
    canBeTargeted,canBeTargeted
  );

  switch(monsterCategory) {
    case MC_Specter :
    case MC_Magicals :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\skellige\quest_files\mh207_wraith\entities\mh207_area_fog.w2ent",
        true
      );

      return entity_template;
      break;
        
      break;
        
    case MC_Vampire :
    case MC_Human :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\minor_quests\no_mans_land\quest_files\mq1051_monster_hunt_nilfgaard1\entities\mq1051_mc_scout_footprint.w2ent",
        true
      );

      return entity_template;
      break;
        
    case MC_Insectoid :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\no_mans_land\quest_files\mh102_arachas\entities\mh102_arachas_tracks.w2ent",
        true
      );
    case MC_Cursed :
    case MC_Troll :
    case MC_Animal :
    case MC_Necrophage :
    case MC_Hybrid :
    case MC_Relic :
    case MC_Beast :
    case MC_Draconide :
    default :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\skellige\quest_files\mh202_nekker_warrior\entities\mh202_nekker_tracks.w2ent",
        true
      );

      return entity_template;
  }
}

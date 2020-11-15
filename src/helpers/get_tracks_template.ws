
latent function getTracksTemplateByCreatureType(create_type: CreatureType): CEntityTemplate {
  var entity_template: CEntityTemplate;

  switch(create_type) {
    case CreatureBARGHEST :
    case CreatureNIGHTWRAITH :
    case CreatureNOONWRAITH :
    case CreatureWRAITH :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "quests\generic_quests\skellige\quest_files\mh207_wraith\entities\mh207_area_fog.w2ent",
        true
      );

      return entity_template;
      break;
        
    case CreatureHUMAN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\generic_footprints_clue.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueHuman';
      break;

    case CreatureDROWNER:
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueDrowner';
      break;

    case CreatureDROWNERDLC:
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueDrowner';
      break;

    case CreatureROTFIEND:
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueRotfiend';
      break;

    case CreatureNEKKER :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueNekker';
      break;

    case CreatureGHOUL :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGhoul';
      break;

    case CreatureALGHOUL :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueAlghoul';
      break;

    case CreatureFIEND :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueFiend';
      break;

    case CreatureCHORT :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueChort';
      break;

    case CreatureWEREWOLF :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueWerewolf';
      break;

    case CreatureLESHEN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueLeshen';
      break;

    case CreatureKATAKAN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueKatakan';
      break;

    case CreatureEKIMMARA :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueEkimmara';
      break;

    case CreatureELEMENTAL :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueElemental';
      break;

    case CreatureGOLEM :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGolem';
      break;
    
    case CreatureGIANT :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGiant';
      break;

    case CreatureCYCLOP :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueCyclop';
      break;

    case CreatureGRYPHON :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGryphon';
      break;

    case CreatureWYVERN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueWyvern';
      break;

    case CreatureCOCKATRICE :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueCockatrice';
      break;

    case CreatureBASILISK :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBasilisk';
      break;

    case CreatureFORKTAIL :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueForktail';
      break;

    case CreatureWIGHT :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueWight';
      break;

    case CreatureSHARLEY :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueSharley';
      break;

    case CreatureHAG :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueHag';
      break;

    case CreatureFOGLET :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueFoglet';
      break;

    case CreatureTROLL :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueTroll';
      break;

    case CreatureBRUXA :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBruxa';
      break;

    case CreatureDETLAFF :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueDetlaff';
      break;

    case CreatureGARKAIN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGarkain';
      break;
    
    case CreatureFLEDER :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueFleder';
      break;

    case CreatureGARGOYLE :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueGargoyle';
      break;

    case CreatureKIKIMORE :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueKikimore';
      break;

    case CreatureCENTIPEDE :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueCentipede';
      break;

    case CreatureBERSERKER :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBerserker';
      break;

    case CreatureWOLF :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueWolf';
      break;

    case CreatureBEAR :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBear';
      break;

    case CreatureBOAR :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBoar';
      break;

    case CreaturePANTHER :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBoar';
      break;

    case CreatureSPIDER :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueBoar';
      break;

    case CreatureWILDHUNT :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueWildhunt';
      break;

    case CreatureARACHAS :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueArachas';
      break;

    case CreatureHARPY :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueHarpy';
      break;

    case CreatureSIREN :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueSiren';
      break;

    case CreatureENDREGA :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueEndrega';
      break;

    case CreatureECHINOPS :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueEchinops';
      break;

    case CreatureDRACOLIZARD :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClueDracolizard';
      break;

    default :
      entity_template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the entityClass to our own. Easier than to create
      // 32 w2ent files
      entity_template.entityClass = 'RER_MonsterClue';
      break;

    // case CreatureNIGHTWRAITH :
    //   entity_template = (CEntityTemplate)LoadResourceAsync(
    //     "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
    //     true
    //   );

    //   // dynamically assigning the entityClass to our own. Easier than to create
    //   // 32 w2ent files
    //   entity_template.entityClass = 'RER_MonsterClueFleder';
    //   break;
  }

  return entity_template;
}

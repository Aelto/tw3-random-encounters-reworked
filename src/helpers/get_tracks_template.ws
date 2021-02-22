
latent function getTracksTemplateByCreatureType(create_type: CreatureType): RER_TrailMakerTrack {
  var track: RER_TrailMakerTrack;

  track = RER_TrailMakerTrack();

  switch(create_type) {
    case CreatureBARGHEST :
    case CreatureNIGHTWRAITH :
    case CreatureNOONWRAITH :
    case CreatureWRAITH :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        // "quests\generic_quests\skellige\quest_files\mh207_wraith\entities\mh207_area_fog.w2ent",
        // "fx\quest\sq108\sq108_fog.w2ent", // insane GPU cost.
        true
      );

      track.monster_clue_type = 'RER_MonsterClueNightwraith';

      // only 1 out of 10 clouds of mist are created.
      // track.trail_ratio_multiplier = 5;

      return track;
      break;
        
    case CreatureHUMAN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\generic_footprints_clue.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHuman';
      break;

    case CreatureDROWNER:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDrowner';
      break;

    case CreatureDROWNERDLC:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDrowner';
      break;

    case CreatureROTFIEND:
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueRotfiend';
      break;

    case CreatureNEKKER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueNekker';
      break;

    case CreatureGHOUL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGhoul';
      break;

    case CreatureALGHOUL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueAlghoul';
      break;

    case CreatureFIEND :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFiend';
      break;

    case CreatureCHORT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueChort';
      break;

    case CreatureWEREWOLF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWerewolf';
      break;

    case CreatureLESHEN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueLeshen';
      break;

    case CreatureKATAKAN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueKatakan';
      break;

    case CreatureEKIMMARA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEkimmara';
      break;

    case CreatureELEMENTAL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueElemental';
      break;

    case CreatureGOLEM :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGolem';
      break;
    
    case CreatureGIANT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGiant';
      break;

    case CreatureCYCLOP :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCyclop';
      break;

    case CreatureGRYPHON :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGryphon';
      break;

    case CreatureWYVERN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWyvern';
      break;

    case CreatureCOCKATRICE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCockatrice';
      break;

    case CreatureBASILISK :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBasilisk';
      break;

    case CreatureFORKTAIL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueForktail';
      break;

    case CreatureWIGHT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWight';
      break;

    case CreatureSHARLEY :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueSharley';
      break;

    case CreatureHAG :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHag';
      break;

    case CreatureFOGLET :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFoglet';
      break;

    case CreatureTROLL :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueTroll';
      break;

    case CreatureBRUXA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBruxa';
      break;

    case CreatureDETLAFF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDetlaff';
      break;

    case CreatureGARKAIN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGarkain';
      break;
    
    case CreatureFLEDER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueFleder';
      break;

    case CreatureGARGOYLE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueGargoyle';
      break;

    case CreatureKIKIMORE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueKikimore';
      break;

    case CreatureCENTIPEDE :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueCentipede';
      break;

    case CreatureBERSERKER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBerserker';
      break;

    case CreatureWOLF :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWolf';
      break;

    case CreatureBEAR :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBear';
      break;

    case CreatureBOAR :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreaturePANTHER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreatureSPIDER :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueBoar';
      break;

    case CreatureWILDHUNT :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueWildhunt';
      break;

    case CreatureARACHAS :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueArachas';
      break;

    case CreatureHARPY :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueHarpy';
      break;

    case CreatureSIREN :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueSiren';
      break;

    case CreatureENDREGA :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEndrega';
      break;

    case CreatureECHINOPS :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh102_arachas_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueEchinops';
      break;

    case CreatureDRACOLIZARD :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClueDracolizard';
      break;

    default :
      track.template = (CEntityTemplate)LoadResourceAsync(
        "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
        true
      );

      // dynamically assigning the monster_clue_type to our own. Easier than to create
      // 32 w2ent files
      track.monster_clue_type = 'RER_MonsterClue';
      break;

    // case CreatureNIGHTWRAITH :
    //   track.template = (CEntityTemplate)LoadResourceAsync(
    //     "dlc\modtemplates\randomencounterreworkeddlc\data\tracks\mh202_nekker_tracks.w2ent",
    //     true
    //   );

    //   // dynamically assigning the monster_clue_type to our own. Easier than to create
    //   // 32 w2ent files
    //   track.monster_clue_type = 'RER_MonsterClueFleder';
    //   break;
  }

  return track;
}

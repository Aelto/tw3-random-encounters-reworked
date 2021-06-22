
// This phase creates an NPC that needs to be rescued.
state NpcRescue in RandomEncountersReworkedContractEntity {
  var npc_to_rescue: CEntity;

  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Contract - State NpcRescue");

    this.NpcRescue_main();
  }

  entry function NpcRescue_main() {
    parent.facts.add(ContractFact_PHASE_NPC_RESCUE_PLAYED);

    this.spawnEntities();
    this.waitForPlayerToReachArea();
    this.makeEntitiesTargetPlayer();
    RER_tryRefillRandomContainer();
    this.waitUntilPlayerFinishesCombat();
    this.playGoodbyeDialogue();
    RER_hideCompanionIndicator('RER_contract_companion', "icons/quests/Companions/mq2017_hero_wannabe_quest_item_64x64.png");

    parent.GotoState('PhasePick');
  }

  latent function spawnEntities() {
    var bestiary_entry: RER_BestiaryEntry;
    var template: CEntityTemplate;
    var template_path: string;
    var position: Vector;

    if (!getRandomPositionBehindCamera(position)) {
      position = thePlayer.GetWorldPosition();
    }

    // 1.
    // first spawn the NPC to rescue
    template_path = "gameplay\templates\characters\presets\skellige\ske_1h_axe_t1.w2ent";
    template = (CEntityTemplate)LoadResourceAsync(template_path, true);
    this.npc_to_rescue = theGame.CreateEntity(
      template,
      position,
      thePlayer.GetWorldRotation(),,,,
      PM_DontPersist
    );

    this.npc_to_rescue.AddTag('RER_contract_companion');
    RER_showCompanionIndicator('RER_contract_companion', "icons/quests/Companions/mq2017_hero_wannabe_quest_item_64x64.png");

    // 2.
    // spawn the monsters
    bestiary_entry = parent
      .master
      .bestiary
      .getRandomEntryFromBestiary(
        parent.master,
        EncounterType_CONTRACT,
        , // for bounty
        CreatureHUMAN,  // left offset
        CreatureDRACOLIZARD // right offset
      );

    parent.entities = bestiary_entry.spawn(
      parent.master,
      position,
      ,,
      parent.entity_settings.allow_trophies,
      EncounterType_CONTRACT
    );
  }

  latent function waitForPlayerToReachArea() {
    var distance: float;
    var entity: CEntity;

    distance = 10 * 10 + 1;

    this.playRandomHelpDialogue();
    
    this.makeNpcTargetEntities();

    while (distance > 10 * 10 && !parent.hasOneOfTheEntitiesGeraltAsTarget()) {
      distance = VecDistanceSquared(
        this.npc_to_rescue.GetWorldPosition(),
        thePlayer.GetWorldPosition()
      );

      this.healEntities();


      if (RandRange(100) < 5) {
        this.playRandomHelpDialogue();
      }

      Sleep(1);
    }
  }

  latent function playRandomHelpDialogue() {
    (new RER_RandomDialogBuilder in thePlayer).start()
      .either(new REROL_vongratz_witcher in thePlayer, true, 1)
      .either(new REROL_vongratz_hey_help_help in thePlayer, true, 1)
      .either(new REROL_vongratz_geralt in thePlayer, true, 1)
      .play((CActor)this.npc_to_rescue);
  }

  function makeNpcTargetEntities() {
    var i: int;

    ((CActor)this.npc_to_rescue).SetAttitude( thePlayer, AIA_Friendly );

    ((CGameplayEntity)this.npc_to_rescue).AddAbility('IsNotScaredOfMonsters', false);

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)this.npc_to_rescue).SetAttitude( (CActor)parent.entities[i], AIA_Hostile );
      
      

      ((CNewNPC)this.npc_to_rescue).NoticeActor((CActor)parent.entities[i]);
    }
  }

  function healEntities() {
    var i: int;

    ((CActor)this.npc_to_rescue)
      .SetHealthPerc(((CActor)this.npc_to_rescue).GetHealthPercents() + 0.05);


    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i])
        .SetHealthPerc(((CActor)parent.entities[i]).GetHealthPercents() + 0.05);
    }
  }

  function makeEntitiesTargetPlayer() {
    var i: int;

    for (i = 0; i < parent.entities.Size(); i += 1) {
      ((CActor)parent.entities[i]).SetTemporaryAttitudeGroup(
        'monsters',
        AGP_Default
      );

      ((CNewNPC)parent.entities[i]).NoticeActor(thePlayer);
    }
  }

  latent function waitUntilPlayerFinishesCombat() {
    // sometimes the game takes time to set the player in combat, in this case
    // we wait a few seconds and then start looping.
    if (!thePlayer.IsInCombat()) {
      Sleep(2);
    }

    // 1. we wait until the player is out of combat
    while (!parent.areAllEntitiesFarFromPlayer() || thePlayer.IsInCombat()) {
      parent.removeDeadEntities();
      RER_moveCreaturesAwayIfPlayerIsInCutscene(parent.entities, 20);
      Sleep(1);
    }
  }

  latent function playGoodbyeDialogue() {
    if (((CActor)this.npc_to_rescue).IsAlive()) {
      (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_vongratz_mmmh_thank_you in thePlayer, true, 1)
        .either(new REROL_vongratz_thank_you_geralt in thePlayer, true, 1)
        .play((CActor)this.npc_to_rescue);

      Sleep(0.2);

      (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_sorry_gotta_go in thePlayer, true, 1)
        .either(new REROL_sorry_gotta_go_2 in thePlayer, true, 1)
        .then()
        .dialog(new REROL_farewell in thePlayer, true)
        .play((CActor)this.npc_to_rescue);
    } else {
      (new RER_RandomDialogBuilder in thePlayer).start()
        .either(new REROL_damn in thePlayer, true, 1)
        .then(0.2)
        .dialog(new REROL_nothing_i_could_do in thePlayer, true)
        .play((CActor)this.npc_to_rescue);
    }
  }
}

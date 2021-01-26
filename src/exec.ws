
// gpc for GetPlayerCoordinates
exec function rergpc() {
  var entities: array<CGameplayEntity>;
  var message: string;
  var i: int;

  FindGameplayEntitiesInRange(
    entities,
    thePlayer,
    25, // radius
    10, // max number of entities
    , // tag
    FLAG_Attitude_Hostile + FLAG_ExcludePlayer + FLAG_OnlyAliveActors,
    thePlayer, // target
    'CNewNPC'
  );

  message += "position: " + VecToString(thePlayer.GetWorldPosition()) + "<br/>";
  
  if (entities.Size() > 0) {
    message += "nearby entities:<br/>";
  }

  for (i = 0; i < entities.Size(); i += 1) {
    message += " - " + StrAfterFirst(entities[i].ToString(), "::") + "<br/>";
  }

  NDEBUG(message);
}

exec function rertestbook() {
  var popup_data: BookPopupFeedback;
  var id: SItemUniqueId;


  popup_data = new BookPopupFeedback in thePlayer;
  popup_data.SetMessageTitle( "Surrounding ecosystem" );
  popup_data.SetMessageText( "The area is 65% filled with bears, 10% wolves, 2% leshens and other creatures." );
  popup_data.curInventory = thePlayer.GetInventory();
  popup_data.PauseGame = true;
  popup_data.bookItemId = id;
			
  theGame.RequestMenu('PopupMenu', popup_data);
}

exec function rerbestiarycanspawn(creature: CreatureType) {
  var rer_entity : CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, creature);
  exec_runner.GotoState('RunBestiaryCanSpawn');
}

exec function rera(optional creature: CreatureType) {
  _rer_start_ambush(creature);
}
exec function rer_start_ambush(optional creature: CreatureType) {
  _rer_start_ambush(creature);
}
function _rer_start_ambush(optional creature: CreatureType) {
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

exec function rerh(optional creature: CreatureType) {
  _rer_start_hunt(creature);
}
exec function rer_start_hunt(optional creature: CreatureType) {
  _rer_start_hunt(creature);
}
function _rer_start_hunt(optional creature: CreatureType) {
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


exec function rerhu(optional human_type: EHumanType, optional count: int) {
  _rer_start_human(human_type, count);
}
exec function rer_start_human(optional human_type: EHumanType, optional count: int) {
  _rer_start_human(human_type, count);
}
function _rer_start_human(optional human_type: EHumanType, optional count: int) {
  var rer_entity: CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>");

    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, CreatureNONE);

  exec_runner.human_type = human_type;
  exec_runner.count = count;

  exec_runner.GotoState('RunHumanAmbush');
}

exec function rer_test_camera(optional scene_id: int) {
  var rer_entity: CRandomEncounters;
  var exec_runner: RER_ExecRunner;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>");

    return;
  }

  exec_runner = new RER_ExecRunner in rer_entity;
  exec_runner.init(rer_entity, CreatureNONE);

  exec_runner.count = scene_id;

  exec_runner.GotoState('TestCameraScenePlayer');
}

// Why a statemachine and a whole class for exec functions
// and console commands?
// Most of RER functions are latent functions to keep things
// asynchronous and not hurt the framerates.
// The only way to call a latent function is from an entry function
// or another latent function. This is why this class is a statemachine.
// Entry functions are called when the statemachine enters a specific
// state.
statemachine class RER_ExecRunner extends CEntity {
  var master: CRandomEncounters;
  var creature: CreatureType;
  var human_type: EHumanType;
  var count: int;


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

    this.RunHumanAmbush_main(parent.human_type, parent.count);
  }

  entry function RunHumanAmbush_main(human_type: EHumanType, count: int) {
    var composition: CreatureAmbushWitcherComposition;

    composition = new CreatureAmbushWitcherComposition in parent.master;

    composition.init(parent.master.settings);
    composition.setBestiaryEntry(parent.master.bestiary.human_entries[human_type])
      .setNumberOfCreatures(count)
      .spawn(parent.master);
  }
}

state TestCameraScenePlayer in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State TestCameraScenePlayer");

    if (parent.count == 0) {
      this.TestCameraScenePlayer_main();
    }
    else {
      this.TestCameraScenePlayer_one();
    }
  }

  entry function TestCameraScenePlayer_main() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    
    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    scene.position = thePlayer.GetWorldPosition() + Vector(3, 3, 3);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_NODE;
    scene.look_at_target_node = thePlayer;

    // scene.velocity = Vector(0, 0.01, 0);
    // scene.velocity_type = RER_CameraVelocityType_RELATIVE;

    scene.position_blending_ratio = 0.5;
    scene.rotation_blending_ratio = 0.5;

    scene.duration = 5;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene, true);
  }

  entry function TestCameraScenePlayer_one() {
    var scene: RER_CameraScene;
    var camera: RER_StaticCamera;
    
    // where the camera is placed
    scene.position_type = RER_CameraPositionType_ABSOLUTE;
    // scene.position = parent.investigation_center_position + Vector(0, 0, 5);
    scene.position = thePlayer.GetWorldPosition() + Vector(5, 0, 5);

    // where the camera is looking
    scene.look_at_target_type = RER_CameraTargetType_STATIC;
    scene.look_at_target_static = thePlayer.GetWorldPosition();

    scene.velocity_type = RER_CameraVelocityType_RELATIVE;
    scene.velocity = Vector(0, 0.05, 0);

    scene.position_blending_ratio = 0.01;
    scene.rotation_blending_ratio = 0.01;

    scene.duration = 10;

    camera = RER_getStaticCamera();
    
    camera.playCameraScene(scene);
  }
}

state RunBestiaryCanSpawn in RER_ExecRunner {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    LogChannel('modRandomEncounters', "RER_ExecRunner - State RunBestiaryCanSpawn");

    this.RunBestiaryCanSpawn_main(parent.human_type, parent.count);
  }

  entry function RunBestiaryCanSpawn_main(human_type: EHumanType, count: int) {
    var manager : CWitcherJournalManager;
    var can_spawn_creature: bool;
    
    manager = theGame.GetJournalManager();
  
    can_spawn_creature = bestiaryCanSpawnEnemyTemplateList(
      parent.master.bestiary.entries[parent.creature].template_list,
      manager
    );

    NDEBUG("Can spawn creature [" + parent.creature + "] = " + can_spawn_creature);
  }
}

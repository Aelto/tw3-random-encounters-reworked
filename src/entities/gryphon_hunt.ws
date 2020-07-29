
statemachine class RandomEncountersReworkedGryphonHuntEntity extends CEntity {
  private var bait_position: Vector;

  public var this_entity: CEntity;
  public var this_actor: CActor;
  public var this_newnpc: CNewNPC;

  event OnSpawned( spawnData : SEntitySpawnData ){
		super.OnSpawned(spawnData);

    LogChannel('modRandomEncounters', "RandomEncountersReworkedGryphonHuntEntity spawned");
	}

  public function attach(actor: CActor, newnpc: CNewNPC, this_entity: CEntity) {
    this.this_actor = actor;
    this.this_newnpc = newnpc;
    this.this_entity = this_entity;

		this.CreateAttachment( this_entity );
    this.AddTag('RandomEncountersReworked_Entity');
  }

  // ENTRY-POINT for the gryphon fight
  public function start() {
    if (RandRange(10) >= 5) {
      this.GotoState('WaitingForPlayer');
    }
    else {
      this.GotoState('FlyingAbovePlayer');
    }
  }
}

// When the gryphon is on the ground waiting for the player to attack it
// The gryphon is feeding on a dead beast on the ground. You have to find
// it with tracks and blood spills on the ground.
// ENTRY-POINT state.
state WaitingForPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State WaitingForPlayer");
  }
}

// When the gryphon flies over the player, then comes back to attack it
// Imagine it flying at high-speed above you, he sees you and screems
// then he does a complete turn and starts attacking you
// ENTRY-POINT state.
state FlyingAbovePlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State FlyingAbovePlayer");
  }
}

// When the gryphon is fighting with the player. 
// The gryphon is fighting with you until a health threshold. Where he
// will start fleeing
// MULTIPLE state. Can be used multiple times in the encounter
state GryphonFightingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFightingPlayer");
  }
}

// The gryphon is fleeing far from the player.
// The gryphon is hurt, he's bleeding and start flying far from the
// player at low speed. So the player can catch him with or without
// Roach. It ends when the gryphon is exhausted and goes on the ground
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonFleeingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonFleeingPlayer");
  }
}

// The gryphon is tauting the player.
// The gryphon flies at low altitude above the player in circles
// The player cannot interrupt it.
// SINGLE state. Used once in the encounter (more would be annoying)
state GryphonTauntingPlayer in RandomEncountersReworkedGryphonHuntEntity {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    LogChannel('modRandomEncounters', "Gryphon - State GryphonTauntingPlayer");
  }
}
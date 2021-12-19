
statemachine class RER_ContractManager {
  var master: CRandomEncounters;

  function init(_master: CRandomEncounters) {
    this.master = _master;

    this.GotoState('Waiting');
  }

  function pickedContractNoticeFromNoticeboard(errand_name: string) {
    this.GotoState('DialogChoice');
  }

  public function getGenerationTime(time: int): RER_GenerationTime {
    var required_time_elapsed: float;

    required_time_elapsed = StringToFloat(
      theGame.GetInGameConfigWrapper()
      .GetVarValue('RERcontracts', 'RERhoursBeforeNewContracts')
    );

    return RER_GenerationTime(time / required_time_elapsed);
  }

  public function isItTimeToRegenerateContracts(generation_time: RER_GenerationTime): bool {
    return this.master.storages.contract.last_generation_time.time != generation_time.time;
  }

  public function updateStorageGenerationTime(generation_time: RER_GenerationTime) {
    this.master.storages.contract.last_generation_time = generation_time;
    this.master.storages.contract.completed_contracts.Clear();
    this.master.storages.contract.save();
  }

  public function isContractInStorageCompletedContracts(contract: RER_ContractIdentifier): bool {
    var i: int;

    for (i = 0; i < this.master.storages.contract.completed_contracts.Size(); i += 1) {
      if (this.master.storages.contract.completed_contracts[i].identifier == contract.identifier) {
        return true;
      }
    }

    return false;
  }

  public function getUniqueIdFromNoticeboard(noticeboard: W3NoticeBoard): RER_NoticeboardIdentifier {
    var position: Vector;
    var heading: float;

    position = noticeboard.GetWorldPosition();
    heading = noticeboard.GetHeading();

    // a random formula to limit the chances of collision, nothing too fancy
    return RER_NoticeboardIdentifier(
      position.X * heading
      - position.Y / heading
      + position.Z + heading
    );
  }

  public function getUniqueIdFromContract(noticeboard: RER_NoticeboardIdentifier, is_far: bool, is_hard: bool, species: RER_SpeciesTypes, generation_time: RER_GenerationTime): RER_ContractIdentifier {
    var output: float;

    output = noticeboard.identifier;

    if (is_far) {
      output /= generation_time.time;
    }
    else {
      output *= generation_time.time;
    }

    if (is_hard) {
      output -= generation_time.time;
    }
    else {
      output += generation_time.time;
    }

    return RER_ContractIdentifier(output);
  }

  public function generateContract(data: RER_ContractGenerationData): RER_ContractRepresentation {
    var contract: RER_ContractRepresentation;
    var bestiary_entry: RER_BestiaryEntry;
    var rng: RandomNumberGenerator;

    contract = RER_ContractRepresentation();
    rng = (new RandomNumberGenerator in this).setSeed(data.rng_seed)
      .useSeed(true);

    contract.identifier = data.identifier;
    contract.destination_point = this.getRandomDestinationAroundPoint(data.starting_point, data.distance, rng);
    contract.destination_radius = 100;

    bestiary_entry = this.master.bestiary.getRandomEntryFromSpeciesType(data.species, rng);
    contract.creature_type = bestiary_entry.type;
    contract.region_name = data.region_name;
    contract.reward_type = ContractRewardType_ALL;
    contract.rng_seed = data.rng_seed;

    if (data.difficulty == ContractDifficulty_EASY) {
      if (rng.nextRange(10, 0) < 5) {
        contract.event_type = ContractEventType_HORDE;
      }
      else {
        contract.event_type = ContractEventType_NEST;
      }
    }
    else {
      contract.event_type = ContractEventType_BOSS;
    }

    return contract;
  }

  public function getRandomDestinationAroundPoint(starting_point: Vector, distance: RER_ContractDistance, rng: RandomNumberGenerator): Vector {
    var closest_points: array<Vector>;
    var index: int;
    var size: int;

    if (distance == ContractDistance_CLOSE) {
      closest_points = this.getClosestDestinationPoints(starting_point, 5);
    }
    else {
      closest_points = this.getClosestDestinationPoints(starting_point, 10);
    }

    // since it can return less than what we asked for
    size = closest_points.Size();
    index = (int)rng.nextRange(size, 0);

    return closest_points[index];
  }

  public function getClosestDestinationPoints(starting_point: Vector, amount_of_points: int): array<Vector> {
    // we will use a linked-list to sort the positions based on the distances
    var queue_starting_node: RER_PositionNode;
    var current_node: RER_PositionNode;
    var next_node: RER_PositionNode;
    var current_position: Vector;
    var current_distance: float;
    var current_region: string;
    var output: array<Vector>;
    var i: int;
    var k: int;

    current_region = AreaTypeToName(theGame.GetCommonMapManager().GetCurrentArea());

    current_position = this.master.static_encounter_manager.encounters[0].position;
    current_distance = VecDistanceSquared2D(starting_point, current_position);

    for (i = 0; i < this.master.static_encounter_manager.encounters.Size(); i += 1) {
      if (!this.master.static_encounter_manager.encounters[i].isInRegion(current_region)) {
        continue;
      }

      current_position = this.master.static_encounter_manager.encounters[0].position;
      current_distance = VecDistanceSquared2D(starting_point, current_position);

      break;
    }

    queue_starting_node = (new RER_PositionNode in this).init(NULL, current_position, current_distance, NULL);

    // important: it starts at i since we did the first one above.
    for (i; i < this.master.static_encounter_manager.encounters.Size(); i += 1) {
      if (!this.master.static_encounter_manager.encounters[i].isInRegion(current_region)) {
        continue;
      }

      current_position = this.master.static_encounter_manager.encounters[i].position;
      current_distance = VecDistanceSquared2D(starting_point, current_position);

      // now we insert the node in the linked-list right before the first node that
      // that has a greater distance than the current one. Or if there is no next
      // node, which would mean the current distance is the greatest
      queue_starting_node = this.insertNodeInLinkedList(queue_starting_node, current_position, current_distance);
    }

    // now that we have a sorted linked-list, we can start reading the positions
    // from the list in ascending order.
    current_node = queue_starting_node;

    for (i = 0; i < amount_of_points; i += 1) {
      output.PushBack(current_node.position);

      current_node = current_node.next;

      if (!current_node) {
        break;
      }
    }

    return output;
  }

  public function insertNodeInLinkedList(out queue_starting_node: RER_PositionNode, current_position: Vector, current_distance: float): RER_PositionNode {
    var new_starting_point: RER_PositionNode;
    var current_node: RER_PositionNode;
    var next_node: RER_PositionNode;

    // first we check if the current node is not closer than the first one
    if (queue_starting_node.distance > current_distance) {
      current_node = (new RER_PositionNode in this).init(NULL, current_position, current_distance, queue_starting_node);
      queue_starting_node.previous = current_node;

      return current_node;
    }

    current_node = queue_starting_node;
    while (true) {
      next_node = current_node.next;

      if (!next_node) {
        current_node.next = (new RER_PositionNode in this).init(current_node, current_position, current_distance, NULL);

        break;
      }

      if (next_node.distance > current_distance) {
        current_node.next = (new RER_PositionNode in this).init(current_node, current_position, current_distance, next_node);
        next_node.previous = current_node.next;

        break;
      }

      current_node = next_node;
    }

    return queue_starting_node;
  }
}
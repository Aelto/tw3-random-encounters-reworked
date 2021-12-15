
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
}
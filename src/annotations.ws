
//#region annotations
@addField(CR4Player) 
saved var random_encounters_reworked: CRandomEncounters;

@addMethod(CR4Player)
public function getRandomEncountersReworked(): CRandomEncounters {
  if (!this.random_encounters_reworked) {
    this.random_encounters_reworked = new CRandomEncounters in this;
  }

  return this.random_encounters_reworked;
}

@wrapMethod(CR4Player)
function OnSpawned(spawnData: SEntitySpawnData) {
  var rer: CRandomEncounters;

  wrappedMethod(spawnData);

  rer = this.getRandomEncountersReworked();
  rer.start();
}
//#endregion
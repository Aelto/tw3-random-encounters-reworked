
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EncounterType, random_encounters_class: CRandomEncounters) {
  if (encounter_type == EncounterType_HUNT) {
    LogChannel('modRandomEncounters', "spawning - HUNT");
    createRandomCreatureHunt(random_encounters_class);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
  else {
    LogChannel('modRandomEncounters', "spawning - NOT HUNT");
    createRandomCreatureComposition(random_encounters_class);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
}

abstract class CompositionSpawner {

  // When you need to force a creature type
  var _creature_type: CreatureType;
  default _creature_type = CreatureNONE;

  public function setCreatureType(type: CreatureType): CompositionSpawner {
    this._creature_type = type;

    return this;
  }

  // When you need to force a number of creatures
  var _number_of_creatures: int;
  default _number_of_creatures = 0;

  public function setNumberOfCreatures(count: int): CompositionSpawner {
    this._number_of_creatures = count;

    return this;
  }

  // When you need to force the spawn position
  var spawn_position: Vector;
  
  public function setSpawnPosition(position: Vector): CompositionSpawner {
    this.spawn_position = position;

    return this;
  }

  // When you need to force the creature template
  var _creatures_templates: EnemyTemplateList;

  public function setCreaturesTemplates(templates: EnemyTemplateList): CompositionSpawner {
    this._creatures_templates = templates;

    return this;
  }

  // When using a random position
  // this will be the max radius used
  var _random_position_max_radius: float;
  default _random_position_max_radius = 200;

  public function setRandomPositionMaxRadius(radius: float): CompositionSpawner {
    this._random_position_max_radius = radius;

    return this;
  }

  // When using a random position
  // this will be the min radius used
  var _random_positition_min_radius: float;
  default _random_positition_min_radius = 150;

  public function setRandomPositionMinRadius(radius: float): CompositionSpawner {
    this._random_positition_min_radius = radius;

    return this;
  }

  // when spawning multiple creature
  var _group_positions_density: float;
  default _group_positions_density = 0.01;

  public function setGroupPositionsDensity(density: float): CompositionSpawner {
    this._group_positions_density = density;

    return this;
  }

  var master: CRandomEncounters;
  var creature_type: CreatureType;
  var creatures_templates: EnemyTemplateList;
  var number_of_creatures: int;
  var initial_position: Vector;
  var group_positions: array<Vector>;
  var created_entities: array<CEntity>;

  public latent function spawn(master: CRandomEncounters) {
    var current_entity_template: SEnemyTemplate;
    var current_template: CEntityTemplate;
    var i: int;
    var j: int;
    var group_positions_index: int;

    this.master = master;

    this.creature_type = this.getCreatureType(master);
    this.creatures_templates = this.getCreaturesTemplates(master, this.creature_type);
    this.number_of_creatures = this.getNumberOfCreatures(master, this.creatures_templates);

    this.creatures_templates = fillEnemyTemplateList(
      this.creatures_templates,
      this.number_of_creatures
    );

    if (!this.getInitialPosition(this.initial_position)) {
      LogChannel('modRandomEncounters', "could not find proper spawning position");

      return;
    }

    this.group_positions = getGroupPositions(
      this.initial_position,
      this.number_of_creatures,
      this._group_positions_density
    );

    if (!this.beforeSpawningEntities(
      this.creature_type,
      this.creatures_templates,
      this.number_of_creatures,
      initial_position,
      group_positions
    )) {
      return;
    }

    for (i = 0; i < this.creatures_templates.Size(); i += 1) {
      current_entity_template = this.creatures_templates[i];

      if (current_entity_template.count > 0) {
        current_template = (CEntityTemplate)LoadResourceAsync(current_entity_template.template, true);

        for (j = 0; j < current_entity_template.count; j += 1) {
          created_entities.PushBack(
            this.createEntity(
              current_template,
              group_positions[group_positions_index],
              thePlayer.GetWorldRotation()
            )
          );

          group_positions_index += 1;
        }
      }
    }

    for (i = 0; i < this.created_entities.Size(); i += 1) {
      this.forEachEntity(
        this.created_entities[i]
      );
    }

    if (!this.afterSpawningEntities()) {
      return;
    }
  }

  // A method to override if needed,
  // such as creating a custom class for handling the fight.
  // If it returns false the spawn is cancelled.
  protected latent function beforeSpawningEntities(): bool {
    return true;
  }

  protected latent function createEntity(template: CEntityTemplate, position: Vector, rotation: EulerAngles): CEntity {
    return theGame.CreateEntity(
      template,
      position,
      rotation
    );
  }

  // A method to override if needed,
  // such as creating a custom class and attaching it.
  protected latent function forEachEntity(entity: CEntity) {}

  // A method to override if needed,
  // such as creating a custom class for handling the fight.
  // If it returns false the spawn is cancelled.
  protected latent function AfterSpawningEntities(): bool {
    return true;
  }



  protected function getCreatureType(master: CRandomEncounters): CreatureType {
    if (!this._creature_type || this._creature_type == CreatureNONE) {
      return master.rExtra.getRandomCreatureByCurrentArea(
        master.settings,
        master.spawn_roller
      );
    }

    return this._creature_type;
  }

  protected function getCreaturesTemplates(master: CRandomEncounters, _creature_type: CreatureType): EnemyTemplateList {
    if (!this._creatures_templates) {
      return this._creatures_templates;
    }

    return master
      .resources
      .getCreatureResourceByCreatureType(_creature_type, master.rExtra);
  }

  protected function getNumberOfCreatures(master: CRandomEncounters, _creatures_templates: EnemyTemplateList): int {
    if (this._number_of_creatures != 0) {
      return this._number_of_creatures;
    }

    return rollDifficultyFactor(
      _creatures_templates.difficulty_factor,
      master.settings.selectedDifficulty
    );
  }

  protected function getInitialPosition(initial_position: Vector): bool {
    var attempt: bool;

    if (!this.spawn_position) {
      attempt = !getRandomPositionBehindCamera(
        initial_position,
        this._random_position_max_radius,
        this._random_positition_min_radius,
        10
      );

      return attempt;
    }

    return this.spawn_position;
  }

}

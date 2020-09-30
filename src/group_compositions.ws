
// Sometimes solo creatures can be accompanied by smaller creatures,
// this is what i call a group composition. Imagine a leshen and a few wolves
// or a giant fighting humans.

latent function makeGroupComposition(encounter_type: EncounterType, random_encounters_class: CRandomEncounters) {
  if (encounter_type == EncounterType_HUNT) {
    LogChannel('modRandomEncounters', "spawning - HUNT");
    createRandomCreatureHunt(random_encounters_class, CreatureNONE);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "MiscFreshTracks" );
    }
  }
  else {
    LogChannel('modRandomEncounters', "spawning - NOT HUNT");
    createRandomCreatureAmbush(random_encounters_class, CreatureNONE);

    if (random_encounters_class.settings.geralt_comments_enabled) {
      thePlayer.PlayVoiceset( 90, "BattleCryBadSituation" );
    }
  }
}

abstract class CompositionSpawner {

  // When you need to force a creature type
  var _bestiary_entry: RER_BestiaryEntry;
  var _bestiary_entry_null: bool;
  default _bestiary_entry_null = true;

  public function setBestiaryEntry(bentry: RER_BestiaryEntry): CompositionSpawner {
    this._bestiary_entry = bentry;
    this._bestiary_entry_null = bentry.isNull();

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
  var spawn_position_force: bool;
  default spawn_position_force = false;
  
  public function setSpawnPosition(position: Vector): CompositionSpawner {
    this.spawn_position = position;
    this.spawn_position_force = true;

    return this;
  }

  // When you need to force the creature template
  var _creatures_templates: EnemyTemplateList;
  var _creatures_templates_force: bool;
  default _creatures_templates_force = false;

  public function setCreaturesTemplates(templates: EnemyTemplateList): CompositionSpawner {
    this._creatures_templates = templates;
    this._creatures_templates_force = true;

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

  // the distance at which an RER creature is killed
  var automatic_kill_threshold_distance: float;
  default automatic_kill_threshold_distance = 200;

  public function setAutomaticKillThresholdDistance(distance: float): CompositionSpawner {
    this.automatic_kill_threshold_distance = distance;

    return this;
  }

  // should the creature drop a trophy on death
  var allow_trophy: bool;
  default allow_trophy = true;

  public function setAllowTrophy(value: bool): CompositionSpawner {
    this.allow_trophy = value;

    return this;
  }

  // should the creature trigger a loot pickup cutscene on death
  var allow_trophy_pickup_scene: bool;
  default allow_trophy_pickup_scene = false;

  public function setAllowTrophyPickupScene(value: bool): CompositionSpawner {
    this.allow_trophy_pickup_scene = value;

    return this;
  }

  private function removeQuestItemsFromEntity(actor: CActor) {
    // the code was taken from `playerWitcher.ws` and from the function
    // transfering the save to NG+
    var inv : CInventoryComponent;
		var questItems : array<name>;
    var i: int;

    inv = actor.GetInventory();

    //1) some non-quest items might dynamically have 'Quest' tag added so first we remove all items that 
    //currently have Quest tag
    inv.RemoveItemByTag('Quest', -1);

    //2) some quest items might lose 'Quest' tag during the course of the game so we need to check their 
    //XML definitions rather than actual items in inventory
    questItems = theGame.GetDefinitionsManager().GetItemsWithTag('Quest');
    for(i=0; i<questItems.Size(); i+=1) {
      inv.RemoveItemByName(questItems[i], -1);
    }
    
    //3) some quest items don't have 'Quest' tag at all
    inv.RemoveItemByName('mq1002_artifact_3', -1);
    
    //4) some quest items are regular items but become quest items at some point - Quests will mark them with proper tag
    inv.RemoveItemByTag('NotTransferableToNGP', -1);
    
    //remove notice board notices - they are not quest items
    inv.RemoveItemByTag('NoticeBoardNote', -1);

    //remove trophies
    inv.RemoveItemByTag('Trophy', -1);
  }

  var master: CRandomEncounters;
  var bestiary_entry: RER_BestiaryEntry;
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
    var success: bool;

    this.master = master;

    this.bestiary_entry = this.getBestiaryEntry(master);
    this.creatures_templates = this.getCreaturesTemplates(this.bestiary_entry);
    this.number_of_creatures = this.getNumberOfCreatures(this.creatures_templates);

    this.creatures_templates = fillEnemyTemplateList(
      this.creatures_templates,
      this.number_of_creatures,
      master.settings.only_known_bestiary_creatures
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

    LogChannel('modRandomEncounters', "GroupComposition spawn - " + this.bestiary_entry.type);
    LogChannel('modRandomEncounters', "GroupComposition spawn - number of creatures: " + number_of_creatures);
    LogChannel('modRandomEncounters', "GroupComposition spawn - initial position: " + VecToString(initial_position));

    success = this.beforeSpawningEntities();
    if (!success) {
      return;
    }

    for (i = 0; i < this.creatures_templates.templates.Size(); i += 1) {
      current_entity_template = this.creatures_templates.templates[i];

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
      ((CNewNPC)this.created_entities[i]).SetLevel(
        getRandomLevelBasedOnSettings(this.master.settings)
      );

      this.forEachEntity(
        this.created_entities[i]
      );

      LogChannel('modRandomEncounters', "creature trophy chances: " + this.bestiary_entry.trophy_chance);

      if (this.allow_trophy && RandRange(100) < this.bestiary_entry.trophy_chance) {
        LogChannel('modRandomEncounters', "adding 1 trophy " + this.bestiary_entry.type);
        
        ((CActor)this.created_entities[i])
          .GetInventory()
          .AddAnItem(
            this.bestiary_entry.trophy_names[master.settings.trophy_price],
            1
          );
      }
    }

    success = this.afterSpawningEntities();
    if (!success) {
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
  protected latent function afterSpawningEntities(): bool {
    return true;
  }


  protected latent function getBestiaryEntry(master: CRandomEncounters): RER_BestiaryEntry {
    var bestiary_entry: RER_BestiaryEntry;

    if (this._bestiary_entry_null) {
      bestiary_entry = master
        .bestiary
        .getRandomEntryFromBestiary(master);

      return bestiary_entry;
    }

    return this._bestiary_entry;
  }

  protected function getCreaturesTemplates(bestiary_entry: RER_BestiaryEntry): EnemyTemplateList {
    if (this._creatures_templates_force) {
      return this._creatures_templates;
    }

    return bestiary_entry
      .template_list;
  }

  protected function getNumberOfCreatures(creatures_templates: EnemyTemplateList): int {
    if (this._number_of_creatures != 0) {
      return this._number_of_creatures;
    }

    return rollDifficultyFactor(
      creatures_templates.difficulty_factor,
      master.settings.selectedDifficulty
    );
  }

  protected function getInitialPosition(out initial_position: Vector): bool {
    var attempt: bool;

    if (this.spawn_position_force) {
      return true;
    }

    attempt = getRandomPositionBehindCamera(
      initial_position,
      this._random_position_max_radius,
      this._random_positition_min_radius,
      10
    );

    return attempt;
  }

}


class RER_BestiaryWerewolf extends RER_BestiaryEntry {
  public function init() {
    this.type = CreatureWEREWOLF;
    this.menu_name = 'Werewolves';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl1.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl2.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl3__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl4__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    );  
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\werewolf_lvl5__lycan.w2ent",,,
        "gameplay\journal\bestiary\lycanthrope.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_01.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    ); 
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\_quest__werewolf_02.w2ent",,,
        "gameplay\journal\bestiary\bestiarywerewolf.journal"
      )
    );

    this.trophy_names.PushBack('modrer_werewolf_trophy_low');
    this.trophy_names.PushBack('modrer_werewolf_trophy_medium');
    this.trophy_names.PushBack('modrer_werewolf_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}

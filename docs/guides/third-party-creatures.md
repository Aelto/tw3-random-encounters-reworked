# 3rd party creatures for RER
In this document you will learn how to add creatures to the RER bestiary so that it spawns them as well as the original creatures. This features allows you to add creatures you added through a mod or simply vanilla creatures that RER doesn't offer by default.

At the end the document you will know how to create a mod that will make the interface between your mod and RER. Which means that if you intend to add new creatures to the game and RER you will have a total of 3 mods.

The mod you will have to create will use bootstrap, this is to prevent any merges with RER so that the interfacing mod stays compatible even if RER gets updated. And the users of the interfacing mods won't have to merge anything for it to work, only a registry update will be necessary.

## Integrating your creatures into RER's bestiary
RER's [bestiary](/src/bestiary/) is where the mod stores all the information it needs about the creatures and their settings. The bestiary was created to support extra creatures, the 3rd party creatures.

Integrating your creatures in the bestiary will require some coding, i will assume that you have programming experience.

### The bestiary entry
First, here is the [bestiary entry](/src/bestiary/bestiary_entry.ws). This is the class every entry in the bestiary extends.

The class one method that is important for you:
- `loadSettings`

In this method the entry loads the data from the menu and initializes the variables. In your case you will want to create a new class that extends the bestiary entry and override this method to use your own menus if you want to add menus.

Here is an example:
```js
class EX_BestiaryEntry extends RER_BestiaryEntry {
  public function loadSettings(inGameConfigWrapper: CInGameConfigWrapper) {
    var i: int;

    this.city_spawn = inGameConfigWrapper.GetVarValue('EXencountersSettlement', this.menu_name);
    this.trophy_chance = StringToInt(inGameConfigWrapper.GetVarValue('EXmonsterTrophies', this.menu_name));
    this.region_constraint = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersConstraints', this.menu_name));

    this.chances_day.Clear();
    this.chances_night.Clear();

    for (i = 0; i < EncounterType_MAX; i += 1) {
      this.chances_day.PushBack(0);
      this.chances_night.PushBack(0);
    }

    this.chances_day[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersAmbushDay', this.menu_name));
    this.chances_night[EncounterType_DEFAULT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersAmbushNight', this.menu_name));
    this.chances_day[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersHuntDay', this.menu_name));
    this.chances_night[EncounterType_HUNT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersHuntNight', this.menu_name));
    this.chances_day[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersContractDay', this.menu_name));
    this.chances_night[EncounterType_CONTRACT] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersContractNight', this.menu_name));
    this.chances_day[EncounterType_HUNTINGGROUND] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersHuntingGroundDay', this.menu_name));
    this.chances_night[EncounterType_HUNTINGGROUND] = StringToInt(inGameConfigWrapper.GetVarValue('EXencountersHuntingGroundNight', this.menu_name));
    this.creature_type_multiplier = StringToFloat(inGameConfigWrapper.GetVarValue('EXcreatureTypeMultiplier', this.menu_name));
    this.crowns_percentage = StringToFloat(inGameConfigWrapper.GetVarValue('EXmonsterCrowns', this.menu_name)) / 100.0f;

    for (i = 0; i < this.template_list.templates.Size(); i += 1) {
      this.template_hashes.PushBack(
        this.template_list.templates[i].template
      );
    }
  }
}

```
In this example I named the class `EX_BestiaryEntry` where `EX` stands for example, and then for the calls to `GetVarValue` I fetched the values from menus prefixed with `EX` too: `EXencountersAmbushDay`. If you don't want to ship a mod menu with your mod, you could instead hardcode values here. The mod menus for RER are quite extensive and you should know that it could potentially take more time than creating the rest of the interfacing mod.

Once you have created your own bestiary entry class for your own mod, you can now create the bestiary entries for the creatures of your mod. For example, here is the leshen bestiary entry: (I explain the code with comments)
```js

// -----------------------------------------------------------------------------
// It starts by extending the RER bestiary entry class.
class RER_BestiaryLeshen extends RER_BestiaryEntry {
  // ---------------------------------------------------------------------------
  // Then overrides the init() method. This method is called by RER whenever the
  // entry is added in the bestiary.
  public function init() {
    // -------------------------------------------------------------------------
    // The variables, this will stay the same in your case.
    var influences: RER_ConstantInfluences;
    influences = RER_ConstantInfluences();

    // -------------------------------------------------------------------------
    // Then the creature type and its menu name. You should know that the menu
    // name should be in the plural form because it may sometimes be displayed
    // to the player through the UI and it will make more sense if the name
    // is in the plural form.
    //
    // And in your case the type will be obtained with a function. I'll explain it
    // in the example below.
    this.type = CreatureLESHEN;
    this.menu_name = 'Leshens';

    // -------------------------------------------------------------------------
    // This is how a creature is inserted in the bestiary entry (the line with .w2ent)
    // And the journal is for the bestiary feature, if the journal is not in the player's
    // bestiary, the creature will be removed from the spawn pool. You can leave it
    // empty if you want the creature to spawn no matter what.
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl1.w2ent",,,
        "gameplay\journal\bestiary\leshy1.journal"
      )
    );
    
    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_lvl2__ancient.w2ent",,,
        "gameplay\journal\bestiary\sq204ancientleszen.journal"
      )
    );

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "characters\npc_entities\monsters\lessog_mh.w2ent",,,
        "gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal"
      )
    );
    
    // -------------------------------------------------------------------------
    // This is what to do if a creature originates from a DLC, otherwise the game will
    // crash when RER will try to spawn it because it doesn't exist.
    if(theGame.GetDLCManager().IsEP2Available() && theGame.GetDLCManager().IsEP2Enabled()){
      this.template_list.templates.PushBack(
        makeEnemyTemplate(
          "dlc\bob\data\characters\npc_entities\monsters\spriggan.w2ent",,,
          "dlc\bob\journal\bestiary\mq7002spriggan.journal"
        )
      );
    }

    // -------------------------------------------------------------------------
    // This is the food chain and influences of this creature towards the other
    // creatures of the ecosystem. If you don't want to bother with this,
    // simply set `influences.no_influence` to every line.
    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)

	// Small creatures below.
      .influence(influences.kills_them) //CreatureHUMAN
      .influence(influences.friend_with) //CreatureARACHAS
      .influence(influences.friend_with) //CreatureENDREGA
      .influence(influences.kills_them) //CreatureGHOUL
      .influence(influences.kills_them) //CreatureALGHOUL
      .influence(influences.kills_them) //CreatureNEKKER
      .influence(influences.kills_them) //CreatureDROWNER
      .influence(influences.kills_them) //CreatureROTFIEND
      .influence(influences.friend_with) //CreatureWOLF
      .influence(influences.kills_them) //CreatureWRAITH
      .influence(influences.kills_them) //CreatureHARPY
      .influence(influences.friend_with) //CreatureSPIDER
      .influence(influences.friend_with) //CreatureCENTIPEDE
      .influence(influences.kills_them) //CreatureDROWNERDLC
      .influence(influences.friend_with) //CreatureBOAR
      .influence(influences.friend_with) //CreatureBEAR
      .influence(influences.friend_with) //CreaturePANTHER
      .influence(influences.kills_them) //CreatureSKELETON
      .influence(influences.friend_with) //CreatureECHINOPS
      .influence(influences.friend_with) //CreatureKIKIMORE
      .influence(influences.kills_them) //CreatureBARGHEST
      .influence(influences.friend_with) //CreatureSKELWOLF
      .influence(influences.friend_with) //CreatureSKELBEAR
      .influence(influences.kills_them) //CreatureWILDHUNT
      .influence(influences.friend_with) //CreatureBERSERKER
      .influence(influences.kills_them) //CreatureSIREN

	// Large creatures below.
      .influence(influences.kills_them) //CreatureDRACOLIZARD
      .influence(influences.kills_them) //CreatureGARGOYLE
      .influence(influences.self_influence) //CreatureLESHEN
      .influence(influences.kills_them) //CreatureWEREWOLF
      .influence(influences.kills_them) //CreatureFIEND
      .influence(influences.kills_them) //CreatureEKIMMARA
      .influence(influences.kills_them) //CreatureKATAKAN
      .influence(influences.kills_them) //CreatureGOLEM
      .influence(influences.kills_them) //CreatureELEMENTAL
      .influence(influences.kills_them) //CreatureNIGHTWRAITH
      .influence(influences.kills_them) //CreatureNOONWRAITH
      .influence(influences.kills_them) //CreatureCHORT
      .influence(influences.kills_them) //CreatureCYCLOP
      .influence(influences.kills_them) //CreatureTROLL
      .influence(influences.kills_them) //CreatureHAG
      .influence(influences.kills_them) //CreatureFOGLET
      .influence(influences.kills_them) //CreatureBRUXA
      .influence(influences.kills_them) //CreatureFLEDER
      .influence(influences.kills_them) //CreatureGARKAIN
      .influence(influences.kills_them) //CreatureDETLAFF
      .influence(influences.kills_them) //CreatureGIANT
      .influence(influences.kills_them) //CreatureSHARLEY
      .influence(influences.kills_them) //CreatureWIGHT
      .influence(influences.kills_them) //CreatureGRYPHON
      .influence(influences.kills_them) //CreatureCOCKATRICE
      .influence(influences.kills_them) //CreatureBASILISK
      .influence(influences.kills_them) //CreatureWYVERN
      .influence(influences.kills_them) //CreatureFORKTAIL
      .influence(influences.kills_them) //CreatureSKELTROLL
      .build();

    // -------------------------------------------------------------------------
    // Here you tell the enemy count for every difficulty level.
    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 1;
    this.template_list.difficulty_factor.minimum_count_medium = 1;
    this.template_list.difficulty_factor.maximum_count_medium = 1;
    this.template_list.difficulty_factor.minimum_count_hard = 1;
    this.template_list.difficulty_factor.maximum_count_hard = 1;
    
    // -------------------------------------------------------------------------
    // The names of the trophies your creature will drop. Three variants for
    // three different shop prices.
    this.trophy_names.PushBack('modrer_leshen_trophy_low');
    this.trophy_names.PushBack('modrer_leshen_trophy_medium');
    this.trophy_names.PushBack('modrer_leshen_trophy_high');

  }

  // ---------------------------------------------------------------------------
  // And finally, the biomes your creature likes.
  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type)
    .addOnlyBiome(BiomeForest);
  }
}
```

And here is an example:
```js

// -----------------------------------------------------------------------------
// This function is used to get the RER class and all of its public members.
// We'll use it to access the RER bestiary class.
function getRandomEncounters(out rer_entity: CRandomEncounters): bool {
  var entities : array<CEntity>;

  theGame.GetEntitiesByTag('RandomEncounterTag', entities);

  if (entities.Size() == 0) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );

    return false;
  }

  rer_entity = (CRandomEncounters)entities[0];

  return true;
}

class EX_BestiaryBraveWarrior extends RER_BestiaryEntry {
  public function init() {
    var influences: RER_ConstantInfluences;
    var rer_class: CRandomEncounters;
    influences = RER_ConstantInfluences();

    if (!getRandomEncounters(rer_class)) {
      NDEBUG("Failed to get the RER class for 3rd party creatures");
      
      return;
    }

    this.type = rer_class.bestiary.getThirdPartyCreatureId();
    this.menu_name = 'Brave warriors';

    this.template_list.templates.PushBack(
      makeEnemyTemplate(
        "dlc\ex_entities\monsters\ex_monster_one.w2ent",,,
      )
    );

    this.ecosystem_impact = (new EcosystemCreatureImpactBuilder in thePlayer)

	// Small creatures below.
      .influence(influences.no_influence) //CreatureHUMAN
      .influence(influences.no_influence) //CreatureARACHAS
      .influence(influences.no_influence) //CreatureENDREGA
      .influence(influences.no_influence) //CreatureGHOUL
      .influence(influences.no_influence) //CreatureALGHOUL
      .influence(influences.no_influence) //CreatureNEKKER
      .influence(influences.no_influence) //CreatureDROWNER
      .influence(influences.no_influence) //CreatureROTFIEND
      .influence(influences.no_influence) //CreatureWOLF
      .influence(influences.no_influence) //CreatureWRAITH
      .influence(influences.no_influence) //CreatureHARPY
      .influence(influences.no_influence) //CreatureSPIDER
      .influence(influences.no_influence) //CreatureCENTIPEDE
      .influence(influences.no_influence) //CreatureDROWNERDLC
      .influence(influences.no_influence) //CreatureBOAR
      .influence(influences.no_influence) //CreatureBEAR
      .influence(influences.no_influence) //CreaturePANTHER
      .influence(influences.no_influence) //CreatureSKELETON
      .influence(influences.no_influence) //CreatureECHINOPS
      .influence(influences.no_influence) //CreatureKIKIMORE
      .influence(influences.no_influence) //CreatureBARGHEST
      .influence(influences.no_influence) //CreatureSKELWOLF
      .influence(influences.no_influence) //CreatureSKELBEAR
      .influence(influences.no_influence) //CreatureWILDHUNT
      .influence(influences.no_influence) //CreatureBERSERKER
      .influence(influences.no_influence) //CreatureSIREN

	// Targe creatures below.
      .influence(influences.no_influence) //CreatureDRACOLIZARD
      .influence(influences.no_influence) //CreatureGARGOYLE
      .influence(influences.no_influence) //CreatureLESHEN
      .influence(influences.no_influence) //CreatureWEREWOLF
      .influence(influences.no_influence) //CreatureFIEND
      .influence(influences.no_influence) //CreatureEKIMMARA
      .influence(influences.no_influence) //CreatureKATAKAN
      .influence(influences.no_influence) //CreatureGOLEM
      .influence(influences.no_influence) //CreatureELEMENTAL
      .influence(influences.no_influence) //CreatureNIGHTWRAITH
      .influence(influences.no_influence) //CreatureNOONWRAITH
      .influence(influences.no_influence) //CreatureCHORT
      .influence(influences.no_influence) //CreatureCYCLOP
      .influence(influences.no_influence) //CreatureTROLL
      .influence(influences.no_influence) //CreatureHAG
      .influence(influences.no_influence) //CreatureFOGLET
      .influence(influences.no_influence) //CreatureBRUXA
      .influence(influences.no_influence) //CreatureFLEDER
      .influence(influences.no_influence) //CreatureGARKAIN
      .influence(influences.no_influence) //CreatureDETLAFF
      .influence(influences.no_influence) //CreatureGIANT
      .influence(influences.no_influence) //CreatureSHARLEY
      .influence(influences.no_influence) //CreatureWIGHT
      .influence(influences.no_influence) //CreatureGRYPHON
      .influence(influences.no_influence) //CreatureCOCKATRICE
      .influence(influences.no_influence) //CreatureBASILISK
      .influence(influences.no_influence) //CreatureWYVERN
      .influence(influences.no_influence) //CreatureFORKTAIL
      .influence(influences.no_influence) //CreatureSKELTROLL
      .build();

    this.template_list.difficulty_factor.minimum_count_easy = 1;
    this.template_list.difficulty_factor.maximum_count_easy = 4;
    this.template_list.difficulty_factor.minimum_count_medium = 2;
    this.template_list.difficulty_factor.maximum_count_medium = 6;
    this.template_list.difficulty_factor.minimum_count_hard = 3;
    this.template_list.difficulty_factor.maximum_count_hard = 8;

    this.trophy_names.PushBack('modex_brave_warriors_trophy_low');
    this.trophy_names.PushBack('modex_brave_warriors_trophy_medium');
    this.trophy_names.PushBack('modex_brave_warriors_trophy_high');

  }

  public function setCreaturePreferences(preferences: RER_CreaturePreferences, encounter_type: EncounterType): RER_CreaturePreferences{
    return super.setCreaturePreferences(preferences, encounter_type);
  }
}
```

### Adding the entry to the bestiary.
> This is a summary of the bootstrap guide.
```js
class CExampleRERInterfaceInitializer extends CEntityMod {
  default modName = 'Example interface RER mod';
  default modAuthor = "your name";
  default modUrl = "nexusmods url";
  default modVersion = '1.0.0';

  default logLevel = MLOG_DEBUG;

  default template = "dlc\modtemplates\examplemod\data\ex_initializer.w2ent";
}

function modCreate_ExampleInterfaceRerMod() : CMod {
  return new CExampleRERInterfaceInitializer in thePlayer;
}

// -----------------------------------------------------------------------------
// And now your class.
class ExampleInterfaceRerMod extends CEntity {
  event OnSpawned(spawn_data: SEntitySpawnData) {
    var entities: array<CEntity>;
    
    theGame.GetEntitiesByTag('ExampleInterfaceRerTag', ents);

    if (entities.Size() > 1) {
      this.Destroy();

      return;
    }

    this.AddTag('ExampleInterfaceRerTag');
    this.injectEntriesInRerBestiary();
  }

  function injectEntriesInRerBestiary() {
    var rer_class: CRandomEncounters;

    if (!getRandomEncounters(rer_class)) {
      NDEBUG("Could not get RER class when injecting entries in bestiary");

      return;
    }

    rer_class.bestiary.addThirdPartyCreature(new EX_BestiaryBraveWarrior in rer_class);
  }
}
```
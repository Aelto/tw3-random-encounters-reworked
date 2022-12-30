# Making an add-on for RER
Add-ons are an easy way to inject data into RER at runtime. It uses a simple
technique using fake items whose tag is actually the name of a state you add to
an existing statemachine.

## Registering the add-on
Before writing any code we must define the name of our addon and declare it so
Random Encounters Reworked can detect it when running.

To do so, we must create a fake item with no attribute other than a tag. This
item name is actually the name of a state we will add to the RER addon manager.
When the mod will run it will fetch all items with the pre-defined tag and then
get their names. This is how it gets the list of installed addons.

Create a mod bundle with an xml file and copy this content:
```xml
<?xml version="1.0" encoding="UTF-16"?>
<redxml>
  <definitions>
    <items>

      <!--
        Update the name of the item to the name of your addon.
       -->
      <item name="MyAddon">
        <!-- Make sure to add this tag or else the item won't be detected: -->
        <tags>RER_Addon</tags>
      </item>
      
    </items>
  </definitions>
</redxml>
```

## The code
Now that we registered our add-on named `MyAddon`, we can finally start writing
code. Here is the basic template that will get you started, with it you can do
anything to the RER class while it is running:
```js
/**
 * To create a global interaction event listener you must add a state to the 
 * SU_NpcInteraction_GlobalEventHandler statemachine and extend
 * GlobalEventListener.
 *
 * In this example we are adding MyAddon to the RER_AddonManager statemachine.
 *
 * Note that if two event listeners have the same name the game won't compile,
 * this is intended to ensure good compatibility between mods. For this reason
 * you must use unique names.
 */ 
state MyAddon in RER_AddonManager extends Addon {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);

    this.MyAddon_main();
  }

  /**
   * States can have undefined behaviors when two states have methods with the
   * same name. For this reason it is recommend to use a prefix on your function
   * names, using the state name is a good solution.
   */
  entry function MyAddon_main() {
    var master: CRandomEncounters;

    master = this.getMaster();
    
    // Now we can do anything we want with RER, for example adding an exception
    // area so the mod spawns creatures in out of bound areas of the map:
    master
      .addon_manager
      .addons_data
      .exception_areas.PushBack(Vector(10, 10, 1000));

    // When our job is done, we MUST call the finish method. Not doing so will
    // block the add-on manager and it won't load any other add-on.
    this.finish();
  }
}
```

If you wish to have code that runs through the whole session, refer to
the `RER_BaseAddon` abstract class and the field `addons` of the `RER_AddonsData`
class.

The engine runs with a garbage collector and if you have a statemachine or timer
that runs longer than a few seconds, it will eventually get collected and deleted
without finishing its job.

RER offers an array where you can push your own classes as long as they extend
the `RER_BaseAddon` class.
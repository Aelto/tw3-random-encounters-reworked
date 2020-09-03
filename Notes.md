
# Notes
> Custom notes i write for myself to not forget them 😊

- to enable logging use `-debugscripts` flag

- ideas for Event reaction:
  - maybe higher chance for some creatures to spawn if you're injured. As they are attracted to the blood. by Czartchonn on discord
  - looting chests, bandits attacking you. by Czartchonn on discord
  - fighting makes noise, it can attract creatures
  - bodies attract necrophages

- how to get a creature entry, look at how it's made in `activateAllGlossaryBeastiary`



## RER spawning system and events
> The goal is to make a new system controlling when and which creatures will spawn.

I imagine an array of struct 
```rs
array<SpawningControl>
```
where `SpawningControl` is something like this:
```rs

// a custom value used in the SpawningControl we
// can disable by setting `ignore_it` to `true`.
// it allows us the change only specific values.
struct NullableControlValue {
  ignore_it: bool;
  value: int;
}

struct SpawningControl {
  // so we can identify the SpawningControls
  // and eventually remove them by name
  name: string;

  effect_on_lower_controls: Add|Multiply|Overwrite;

  minimum_spawning_delay: NullableControlValue;
  maximum_spawning_delay: NullableControlValue;

  // some creatures cannot appear in some areas
  // drowners not appearing in high mountains for ex.
  is_near_water: NullableControlValue; // from 0 to 100
  is_near_forest: NullableControlValue; // from 0 to 100
  is_near_corpse: NullableControlValue; // from 0 to 100

  // Like the SpawnRoller the current system uses
  // we would fill the values the way we want.
  // the first SpawningControl would be filled with
  // the settings values coming from the mod-menu.
  creatures_chances: ...;

}
```

This way we add a `SpawningControl` to the array and it changes the values from the previous `SpawningControl`s by
adding a number, multiplying the current values or completely overwriting them (great for disabling a creature).

- bestiary entries:
  ```
  dlc\bob\journal\bestiary\alp.journal
  dlc\bob\journal\bestiary\archespore.journal
  dlc\bob\journal\bestiary\barghests.journal
  dlc\bob\journal\bestiary\beanshie.journal
  dlc\bob\journal\bestiary\bestiarymonsterhuntmh701.journal
  dlc\bob\journal\bestiary\bestiarymonsterhuntmq7017.journal
  dlc\bob\journal\bestiary\bestiarymq7004.journal
  dlc\bob\journal\bestiary\bigbadwolf.journal
  dlc\bob\journal\bestiary\bruxa.journal
  dlc\bob\journal\bestiary\dagonet.journal
  dlc\bob\journal\bestiary\darkpixies.journal
  dlc\bob\journal\bestiary\dettlaffmonster.journal
  dlc\bob\journal\bestiary\dracolizard.journal
  dlc\bob\journal\bestiary\ep2arachnomorphs.journal
  dlc\bob\journal\bestiary\ep2beast.journal
  dlc\bob\journal\bestiary\ep2boar.journal
  dlc\bob\journal\bestiary\ep2sharley.journal
  dlc\bob\journal\bestiary\ep2virtbeasts.journal
  dlc\bob\journal\bestiary\ep2virtconstructs.journal
  dlc\bob\journal\bestiary\ep2virtcursed.journal
  dlc\bob\journal\bestiary\ep2virtdraconides.journal
  dlc\bob\journal\bestiary\ep2virtinsectoid.journal
  dlc\bob\journal\bestiary\ep2virtnecro.journal
  dlc\bob\journal\bestiary\ep2virtrelicts.journal
  dlc\bob\journal\bestiary\ep2virtspectres.journal
  dlc\bob\journal\bestiary\ep2virtvampires.journal
  dlc\bob\journal\bestiary\fleder.journal
  dlc\bob\journal\bestiary\garkain.journal
  dlc\bob\journal\bestiary\kikimora.journal
  dlc\bob\journal\bestiary\kikimoraworker.journal
  dlc\bob\journal\bestiary\moreausgolem.journal
  dlc\bob\journal\bestiary\mq7002grottore.journal
  dlc\bob\journal\bestiary\mq7002spriggan.journal
  dlc\bob\journal\bestiary\mq7010dracolizard.journal
  dlc\bob\journal\bestiary\mq7018basilisk.journal
  dlc\bob\journal\bestiary\palewidow.journal
  dlc\bob\journal\bestiary\panther.journal
  dlc\bob\journal\bestiary\parszywiec.journal
  dlc\bob\journal\bestiary\protofleder.journal
  dlc\bob\journal\bestiary\q701bruxa.journal
  dlc\bob\journal\bestiary\q701sharley.journal
  dlc\bob\journal\bestiary\q702wight.journal
  dlc\bob\journal\bestiary\q704alphagarkain.journal
  dlc\bob\journal\bestiary\q704bigbadwolfasbeast.journal
  dlc\bob\journal\bestiary\q704cloudgiant.journal
  dlc\bob\journal\bestiary\q704ftwitch.journal
  dlc\bob\journal\bestiary\q704rapunzel.journal
  dlc\bob\journal\bestiary\q704threelittlepigs.journal
  dlc\bob\journal\bestiary\scolopedromorph.journal
  dlc\bob\journal\bestiary\wicht.journal
  dlc\bob\journal\bestiary\wp2virtogrowate.journal

  gameplay\journal\bestiary\armoredarachas.journal
  gameplay\journal\bestiary\bear.journal
  gameplay\journal\bestiary\beasts.journal
  gameplay\journal\bestiary\bestiaryalghoul.journal
  gameplay\journal\bestiary\bestiarybasilisk.journal
  gameplay\journal\bestiary\bestiarycockatrice.journal
  gameplay\journal\bestiary\bestiarycrabspider.journal
  gameplay\journal\bestiary\bestiaryekkima.journal
  gameplay\journal\bestiary\bestiaryelemental.journal
  gameplay\journal\bestiary\bestiaryendriag.journal
  gameplay\journal\bestiary\bestiaryforktail.journal
  gameplay\journal\bestiary\bestiaryghoul.journal
  gameplay\journal\bestiary\bestiarygolem.journal
  gameplay\journal\bestiary\bestiarygreaterrotfiend.journal
  gameplay\journal\bestiary\bestiarykatakan.journal
  gameplay\journal\bestiary\bestiarymiscreant.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh101.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh102.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh103.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh104.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh105.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh106.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh107.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh108.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh202.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh203.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh206.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh207.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh208.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh210.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh301.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh302.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh303.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh304.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh305.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh306.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh307.journal
  gameplay\journal\bestiary\bestiarymonsterhuntmh308.journal
  gameplay\journal\bestiary\bestiarymoonwright.journal
  gameplay\journal\bestiary\bestiarynoonwright.journal
  gameplay\journal\bestiary\bestiarypesta.journal
  gameplay\journal\bestiary\bestiarywerebear.journal
  gameplay\journal\bestiary\bestiarywerewolf.journal
  gameplay\journal\bestiary\bestiarywyvern.journal
  gameplay\journal\bestiary\bies.journal
  gameplay\journal\bestiary\constructs.journal
  gameplay\journal\bestiary\cursed.journal
  gameplay\journal\bestiary\cyclops.journal
  gameplay\journal\bestiary\czart.journal
  gameplay\journal\bestiary\czart1.journal
  gameplay\journal\bestiary\czart2.journal
  gameplay\journal\bestiary\dog.journal
  gameplay\journal\bestiary\doppler.journal
  gameplay\journal\bestiary\drowner.journal
  gameplay\journal\bestiary\dzinn.journal
  gameplay\journal\bestiary\endriagatruten.journal
  gameplay\journal\bestiary\endriagaworker.journal
  gameplay\journal\bestiary\erynia.journal
  gameplay\journal\bestiary\fiend.journal
  gameplay\journal\bestiary\fiend2.journal
  gameplay\journal\bestiary\fiends.journal
  gameplay\journal\bestiary\fireelemental.journal
  gameplay\journal\bestiary\fogling.journal
  gameplay\journal\bestiary\gargoyle.journal
  gameplay\journal\bestiary\godling.journal
  gameplay\journal\bestiary\gravehag.journal
  gameplay\journal\bestiary\griffin.journal
  gameplay\journal\bestiary\harpy.journal
  gameplay\journal\bestiary\highervampire.journal
  gameplay\journal\bestiary\him.journal
  gameplay\journal\bestiary\humans.journal
  gameplay\journal\bestiary\hybrids.journal
  gameplay\journal\bestiary\icegiant.journal
  gameplay\journal\bestiary\icegolem.journal
  gameplay\journal\bestiary\icetroll.journal
  gameplay\journal\bestiary\insectoids.journal
  gameplay\journal\bestiary\leshy.journal
  gameplay\journal\bestiary\leshy1.journal
  gameplay\journal\bestiary\leszy.journal
  gameplay\journal\bestiary\lycanthrope.journal
  gameplay\journal\bestiary\mq0003noonwraith.journal
  gameplay\journal\bestiary\necrophages.journal
  gameplay\journal\bestiary\nekker.journal
  gameplay\journal\bestiary\ogrelike.journal
  gameplay\journal\bestiary\ornithosaur.journal
  gameplay\journal\bestiary\poisonousarachas.journal
  gameplay\journal\bestiary\relicts.journal
  gameplay\journal\bestiary\sentient.journal
  gameplay\journal\bestiary\silvan.journal
  gameplay\journal\bestiary\silvan1.journal
  gameplay\journal\bestiary\silvan2.journal
  gameplay\journal\bestiary\siren.journal
  gameplay\journal\bestiary\spectre.journal
  gameplay\journal\bestiary\sq204ancientleszen.journal
  gameplay\journal\bestiary\succubus.journal
  gameplay\journal\bestiary\trollcave.journal
  gameplay\journal\bestiary\vampires.journal
  gameplay\journal\bestiary\waterhag.journal
  gameplay\journal\bestiary\whminion.journal
  gameplay\journal\bestiary\witches.journal
  gameplay\journal\bestiary\wolf.journal
  gameplay\journal\bestiary\wraith.journal
  ```
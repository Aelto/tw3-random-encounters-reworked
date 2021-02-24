
function RER_tutorialTryShowContract(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialMonsterContract')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Monster contract",
    "A " + RER_yellowFont("Monster Contract") + "from the mod Random Encounters Reworked " +
    "has just started. You may have noticed a camera scene was played and perhaps Geralt talking " +
    ", from now on and if you want to progress through the monster contract you will have to " +
    "follow the trails, the map markers the mod placed or where the camera scene guided you. " +
    "<br/>" +
    "A monster contract is randomly generated and is composed of small pre-built phases that " +
    "are combined to form something that could look like a vanilla contract, with less details " +
    "of-course as it is generated on the fly. " +
    "<br />" +
    "You can control the amount of phases that are used to build the contract, or in other terms, " +
    "its length with the " + RER_yellowFont("Longevity") + " slider you can find in the mod menu. " +
    "One longevity point is roughly equivalent to 1 minute and 30 seconds of gameplay after you're " +
    "used to the flow of the system. " +
    "<br />" +
    "<br />" +
    "Some phases are pretty simple and ask you to simply follow a trail or examine the ground, " +
    "while some others will get you in combat. The monster contract is an encounter where you " +
    "must be prepared to fight and should be considered as hard, if not harder, than vanilla contracts. " +
    "<br />" +
    "<br />" +
    "A monster contract lasts until Geralt says the line " + RER_yellowFont("`It's over`.") + 
    "There are some cases where the mod is not able to find a suitable position or an error occured " +
    "and the encounter will be shut down and Geralt will once again say the line. So whenever you hear" +
    "the line `It's over` don't look further because everything about the contract except the loot " +
    "will soon disappear " +
    "<br />" +
    "<br />" +
    "Good luck, and if you encounter any bug, have a suggestion or feedback, feel free to contact me!" +
    "<br />" +
    "   - Aeltoth"
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialMonsterContract', 0);

  theGame.SaveUserSettings();

  return true;
}
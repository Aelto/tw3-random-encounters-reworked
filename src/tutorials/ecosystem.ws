
function RER_tutorialTryShowEcosystem(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialEcosystem')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - The ecosystem",
    "You recently killed a creature and indirectly changed the " + RER_yellowFont(" surrounding ecosystem. ") +
    "The mod Random Encounters Reworked simulates a food chain that will permanently change " +
    "the creatures you see (only creatures from the mod). Because you killed " +
    "living creatures or bandits, the surrounding ecosystem changed a little and " +
    "if you continue new species will come and some other will even migrate to new " +
    "places. " +
    "<br />" +
    "<br />" +
    "You can examine the surrounding ecosystem with the " + RER_yellowFont("Ecosystem Analyse") +
    " keybind, which will allow you to learn useful information about the species " +
    "and their habits. To learn how to get the keybind, please refer to the in-depth " +
    "install guide. " +
    "<br />" +
    "<br />" +
    "If you do not like the feature you can change its settings in the " + RER_yellowFont("Ecosystem System") +
    " menu. The power value controls how much your actions and the species' actions " +
    "will impact the ecosystem. To get a more restrictive but realistic ecosystem you " +
    "can increase the value. The spread value controls how much species will migrate " +
    "when you kill creatures. The death rate controls the speed at which creatures die."
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialEcosystem', 0);

  theGame.SaveUserSettings();

  return true;
}
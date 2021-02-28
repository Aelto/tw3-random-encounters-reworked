
function RER_tutorialTryShowBounty(): bool {
  if (!theGame.GetInGameConfigWrapper()
      .GetVarValue('RERtutorials', 'RERtutorialBountyHunting')) {
    return false;
  }

  RER_openPopup(
    "RER Tutorial - Bounty hunting",
    "A " + RER_yellowFont("Bounty hunt") + " from the mod Random Encounters Reworked " +
    "has just started. A bounty is pretty simple, important groups of creatures are " +
    "marked on your map. You have to kill every marked groups to finish the bounty, and " +
    "as you progress through the bounty new marked groups may appear. The bounty continues " +
    "until there is no more groups to kill. " +
    "<br />" +
    "<br />" +
    "Everything you see during bounties like the markers and their positions, the creatures " +
    "that compose the bounties, and how many markers and overall creatures are determined " +
    "by the seed (the number) that you picked in the seed selector window. Two bounties " +
    "with the same seed will result in the exact same encounter. But don't worry, there is " +
    "an almost infinite number of seeds. " +
    "If you're indecisive about the seed, picking a seed of 0 will make a completely random bounty " +
    "for you." +
    "<br />" +
    "Higher seeds result in more difficult bounties. And as you complete bounties you unlock " + 
    "more seeds and thus more difficult bounties. " +
    "<br />" +
    "<br />" +
    "You may have found bounty notices when killing wild creatures before. These notices, if in your inventory " +
    "when you start a bounty are all consumed to increase the rewards for the bounty by 3% per notice, but also " +
    "increase all effects of difficulty by 1%. The notice are found on non-bounty creatures and may be stored in " +
    "your bank if you do not want them to be consumed." +
    "<br />" +
    "<br />" +
    "You should know that if you use the mod Friendly HUD, the map markers also appear as 3D markers " +
    "which is really useful."
  );

  theGame
    .GetInGameConfigWrapper()
    .SetVarValue('RERtutorials', 'RERtutorialBountyHunting', 0);

  theGame.SaveUserSettings();

  return true;
}
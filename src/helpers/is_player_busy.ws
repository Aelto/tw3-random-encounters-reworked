
// return true in cases where the player is busy in a cutscene or in the boat.
// When a spawn should be cancelled.
function isPlayerBusy(): bool {
  return thePlayer.IsInInterior()
      || thePlayer.IsInCombat()
      || thePlayer.IsUsingBoat()
      || thePlayer.IsInFistFightMiniGame()
      || thePlayer.IsSwimming()
      || thePlayer.IsInNonGameplayCutscene()
      || thePlayer.IsInGameplayScene()
      || theGame.IsDialogOrCutscenePlaying()
      || theGame.IsCurrentlyPlayingNonGameplayScene()
      || theGame.IsFading()
      || theGame.IsBlackscreen();
}
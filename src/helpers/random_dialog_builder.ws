
// represents all the data we need to play a oneliner
class RER_DialogData {
  var dialog_id: int;
  var dialog_duration: float;
  var wait_until_end: bool;
}
// and then replace the oneliner functions i have with structs like these that
// extend the RER_DialogData and set default values like
class RER_DialogDataExample extends RER_DialogData {
  default dialog_id = 380546;
  default dialog_duration = 1.5;
}
// and then we use the build like so
// (new RER_RandomDialogBuilder in thePlayer)
//  .start()
//  .dialog(new RER_DialogDataExample in thePlayer, true)
//  .then()
//  .either(new RER_DialogDataExample in thePlayer, true, 0.5)
//  .either(new RER_DialogDataExample in thePlayer, false, 0.5)
//  .play()
// 
// and it plays a voiceline, then pick randomly between one or the other
// and the boolean we pass mean if we should wait_until_the_end or not.
class RER_RandomDialogBuilder {
  var sections: array<RandomDialogSection>;
  var current_section: RandomDialogSection;
  var talking_actor: CActor;

  function then(optional pause_after: float): RER_RandomDialogBuilder {
    this.current_section.pause_after = pause_after;
    this.sections.PushBack(this.current_section);
    this.current_section = new RandomDialogSection in this;

    return this;
  }

  function start(): RER_RandomDialogBuilder {
    this.current_section = new RandomDialogSection in this;

    return this;
  }

  function dialog(data: RER_DialogData, wait: bool): RER_RandomDialogBuilder {
    return this.either(data, wait, 1).then();
  }

  function either(data: RER_DialogData, wait: bool, chance: float): RER_RandomDialogBuilder {
    data.wait_until_end = wait;

    this.current_section.dialogs.PushBack(data);
    this.current_section.chances.PushBack(chance);

    return this;
  }

  latent function play(optional actor: CActor) {
    var i: int;

    if (actor) {
      this.talking_actor = actor;
    }
    else {
      this.talking_actor = thePlayer;
    }

    this.then();

    for (i = 0; i < this.sections.Size(); i += 1) {
      this.playSection(i);
    }
  }

  private latent function playSection(index: int) {
    var total: float;
    var k: int;
    
    for (k = 0; k < this.sections[index].chances.Size(); k += 1) {
      total += this.sections[index].chances[k];
    }

    for (k = 0; k < this.sections[index].chances.Size(); k += 1) {
      if (RandRangeF(total) < this.sections[index].chances[k]) {
        break;
      }

      total -= this.sections[index].chances[k];
    }

    // from here we know the picked section is at index K so we play it
    this.talking_actor.PlayLine(this.sections[index].dialogs[k].dialog_id, true);

    if (this.sections[index].dialogs[k].wait_until_end) {
      this.talking_actor.WaitForEndOfSpeach();
    }

    if (this.sections[index].pause_after > 0) {
      Sleep(this.sections[index].pause_after);
    }
  }
}

class RandomDialogSection {
  var dialogs: array<RER_DialogData>;
  var chances: array<float>;
  var pause_after: float;
}
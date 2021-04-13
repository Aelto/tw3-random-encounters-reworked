
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

  latent function play(optional actor: CActor, optional with_camera: bool) {
    var i: int;
    var camera: RER_StaticCamera;

    if (actor) {
      this.talking_actor = actor;
    }
    else {
      this.talking_actor = thePlayer;
    }

    this.then();

    if (with_camera) {
      camera = this.teleportCameraToLookAtTalkingActor();
    }

    for (i = 0; i < this.sections.Size(); i += 1) {
      this.playSection(i);
    }

    if (with_camera) {
      camera.Stop();
    }
  }

  private latent function teleportCameraToLookAtTalkingActor(): RER_StaticCamera {
    var camera: RER_StaticCamera;
    var position: Vector;
    var rotation: EulerAngles;

    camera = RER_getStaticCamera();
    camera.deactivationDuration = 1;
    camera.activationDuration = 1;

    // left camera
    if (RandRange(10) > 5) {
      position = this.talking_actor.GetWorldPosition() + Vector(0, 0, getCreatureHeight(this.talking_actor) * 1.1) + VecConeRand(
        this.talking_actor.GetHeading() - 45,
        45,
        2,
        2.5
      );
    }
    // right camera
    else {
      position = this.talking_actor.GetWorldPosition() + Vector(0, 0, getCreatureHeight(this.talking_actor) * 1.1) + VecConeRand(
        this.talking_actor.GetHeading() + 45,
        45,
        4,
        5
      );
    }

    rotation = VecToRotation(
      this.talking_actor.GetWorldPosition() + Vector(0, 0, 2)
      - position
    );
    rotation.Pitch *= -1;

    camera.TeleportWithRotation(
      position,
      rotation
    );

    camera.Run();

    return camera;
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
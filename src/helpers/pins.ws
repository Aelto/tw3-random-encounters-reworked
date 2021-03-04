
enum RER_PinType {
  RER_SkullPin = 1,
  RER_InterestPin = 2,
  RER_InfoPin = 3
}

function RER_togglePinAtPosition(position: Vector, type: RER_PinType): bool {
  var manager  : CCommonMapManager;
  var id_to_add, id_to_remove: int;

  manager = theGame.GetCommonMapManager();

  manager
  .ToggleUserMapPin(
    manager.GetCurrentArea(),
    position,
    (int)type,
    false,
    id_to_add, // out variable, doesn't matter
    id_to_remove // out variable, doesn't matter
  );

  NLOG("id to add = " + id_to_add + " && id to remove =" + id_to_remove );

  // returns true if it was added, false if it was removed
  return id_to_add != 0;
}

struct RER_PinManagerRequest {
  var position: Vector;
  var type: RER_PinType;
}

// Should be used when creating multiple pins at the same time. It seems the game
// doesn't handle well the creation of pins simultaneously. Instead it only creates
// one of the pins and ignores the rest
//
// The class is pretty simple, there is queue. And whenever you add a pin to the
// queue, the class will enter in state where it empties the queue with a delay
// between each pin.
// Once the queue is empty it returns to the waiting state.
class RER_PinManager extends CEntity {
  // queues for pins to add or remove.
  // The difference between them is that we cannot know if there is a pin at the
  // given position or not. Our only way to know if there was a pin at a position
  // is to send a toggle call and see the return value of the toggle (added or
  // removed).
  //
  // So this class will make sure that a pin in add queue results in an added
  // pin and not a removed one, by toggle it a second time if the first time
  // removed one. And vice-versa for the remove queue.
  var add_queue: array<RER_PinManagerRequest>;
  var remove_queue: array<RER_PinManagerRequest>;

  public function addPinHere(position: Vector, type: RER_PinType) {
    this.add_queue.PushBack(RER_PinManagerRequest(position, type));

    if (this.GetCurrentStateName() != 'Processing') {
      this.GotoState('Processing');
    }
  }

  public function removePinHere(position: Vector, type: RER_PinType) {
    this.remove_queue.PushBack(RER_PinManagerRequest(position, type));

    if (this.GetCurrentStateName() != 'Processing') {
      this.GotoState('Processing');
    }
  }
}

state Waiting in RER_PinManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_PinManager - state Waiting");

    if (parent.add_queue.Size() > 0 || parent.remove_queue.Size() > 0) {
      parent.GotoState('Processing');
    }
  }
}

state Processing in RER_PinManager {
  event OnEnterState(previous_state_name: name) {
    super.OnEnterState(previous_state_name);
    NLOG("RER_PinManager - state Processing");

    this.process_pins();
  }

  entry function process_pins() {
    var current_request: RER_PinManagerRequest;

    while (parent.add_queue.Size() > 0) {
      current_request = parent.add_queue.PopBack();

      // we initially wanted to add a pin here but the return values says we
      // removed one. It means there was already a toggle at the position, so we
      // add a new request in the queue that will add the pin back.
      if (!RER_togglePinAtPosition(current_request.position, current_request.type)) {
        parent.addPinHere(current_request.position, current_request.type);
      }

      Sleep(0.5);
    }

    while (parent.remove_queue.Size() > 0) {
      current_request = parent.remove_queue.PopBack();

      // we initially wanted to remove a pin here but the return values says
      // we added one. It means there was already a toggle at the position, so
      // we add a new request in the queue that will remove the pin this time.
      if (RER_togglePinAtPosition(current_request.position, current_request.type)) {
        parent.removePinHere(current_request.position, current_request.type);
      }

      Sleep(0.5);
    }

    parent.GotoState('Waiting');
  }
}
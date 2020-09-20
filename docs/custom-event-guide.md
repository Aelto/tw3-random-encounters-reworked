# Creating a custom event for Random Encounters Reworked
> Random Encounters Reworked is called by RER to keep phrases short.

This guide is intended for people with programming experience who want to create and inject their own custom event into RER event system.
RER event system is a simple yet effective framework to help developpers create their own events in only a few lines of code.

The guide will use the [Geralt enters swamp](/src/timer/events/enters_swamp.ws) event already implemented into the mod as an example.

Here is a [youtube video](https://www.youtube.com/watch?v=QUfOvbN8xHk) during which i code the event. In only 7 minutes the event is fully developped.

## The framework
Two classes are used for the whole system:
  - [RER_EventsManager](src/../../src/timer/events_manager.ws) is where the events are stored and run. It is started by RER on startup and is then fully independant.
  
    You will only use one method from this class which is used to add your event into the collection of events:
    ```js
    public function addListener(listener: RER_EventsListener)
    ```

    Its full workflow is quite simple, it is a statemachine with 3 states:
    - [starting](../src/timer/states/starting.ws) for when the class is initializing the stored events
    - [listening](../src/timer/states/listening.ws) for when the class is iterating through each event and run them. Once the `listening` state is done it goes back to the `waiting` state automatically.
    - [waiting](waiting.../src/timer/states/waiting.ws) for when the class is waiting for the next `listening` phase.
  - [RER_EventsListener](../src/timer/events_listener.ws) is the abtract class the custom events must implement.
    It has 3 main elements:
    - the attribute `public var active: bool;` which once set to `false` will stop the manager from running the event during its `listening` state. If you happen to set it to false you must find a way to activate, such as a timer for example.
    - the method `public latent function onReady(manager: RER_EventsManager)` launched as soon as the event is added into the manager's collection.
    - the method `onInterval` which is called every time the manager goes into the `listening` state. The `was_spawn_already_triggered` boolean is used to check if a previous event was already triggered during this listening. The `master` is the main CRandomEncounters class mainly used to access to the settings and helper functions. The `delta` is the time between this listening and the last one, if you want to calculate things such as % chances you MUST use the delta. If you don't your chances will be tied to the user's framerate.
      ```js
      public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool
      ```

## Base for a custom event
Here is the base code for a custom event:
```js
// When the player enters a swamp, there is a small chance for drowners or hags to appear
class RER_ListenerBasicEvent extends RER_EventsListener {
  public latent function onInterval(was_spawn_already_triggered: bool, master: CRandomEncounters, delta: float): bool {
    // a previous event was triggered already, we don't want two events
    // to trigger at the same time.
    if (was_spawn_already_triggered) {
      return false;
    }

    // nothing was done, we return false to mean the event was not triggered.
    return false;
  }
}
```

And this is how you add it to the current instance of `RandomEncountersReworked`:
```js
function addBasicEventToRER() {
  var rer_entity : CRandomEncounters;

  if (!getRandomEncounters(rer_entity)) {
    LogAssert(false, "No entity found with tag <RandomEncounterTag>" );
    
    return;
  }

  rer_entity
    .events_manager
    .addListener(new RER_ListenerBasicEvent in rer_entity.events_manager);
}
```

You then call `addBasicEventToRER` when RER is initialized and your event is now injected into RER event system.

> NOTE: you must use modBootstrap to run this function on startup.
>
> I will see if i can make a guide or find a simpler way to bootstrap your events.
class CModExampleEntityMod extends CEntityMod {
    default modName = 'ExampleEntityMod';
    default modAuthor = "unknown";
    default modUrl = "http://www.nexusmods.com/witcher3/mods/????/";
    default modVersion = '0.1';

    default logLevel = MLOG_DEBUG;

    // define template for entity to be spawned on startup. entity must be added
    // in DLC and use CModExampleTimerEntity as class (don't forget flat compiled
    // data!).
    // just copy this stripped down entity into *your* dlc directory:
    //      dlc/modtemplates/<yourmodname>/<yourmodentityname>
    // and change its class to <yourmodclass>
    // Note: no reddlc for mounting required as dlc/modtemplates/* and subdirs is
    // already defined in bootstrap reddlc!
    default template = "dlc/modtemplates/bootstrap/modentity.w2ent";

    // no need for init function as the entity from above function will be spawned automatically
}

class CModExampleEntity extends CEntity {
    private var counter: int;

    event OnSpawned(spawnData: SEntitySpawnData) {
        super.OnSpawned(spawnData);

        GetWitcherPlayer().DisplayHudMessage("Example Entity Mod spawned");
        AddTimer('myTimerCallback', 10, true, , , , true);
    }

    timer function myTimerCallback(deltaTime: float, id: int) {

        if (counter < 5) {
            counter += 1;
            GetWitcherPlayer().DisplayHudMessage("Timer Entity callback called " + IntToString(counter));

        } else {
            RemoveTimer('myTimerCallback');
        }
    }
}

function modCreate_ExampleEntityMod() : CMod {
    // do nothing besides creating and returning of mod class!
    return new CModExampleEntityMod in thePlayer;
}

// ----------------------------------------------------------------------------
quest function modStartBootstrap() {
    var bootstrap: CModBootstrap;
    var entity : CEntity;
    var template : CEntityTemplate;

    // bootstrap as entity makes sure it survives fast travel in same hub
    template = (CEntityTemplate)LoadResource("dlc/modtemplates/bootstrap/bootstrap.w2ent", true);
    entity = theGame.CreateEntity(template,
        thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation());

    bootstrap = (CModBootstrap)entity;
    bootstrap.bootstrap();
}
// ----------------------------------------------------------------------------
quest function modIsBootstrapStarted(): bool {
    return FactsQuerySum("bootstrap_started") > 0;
}
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
class CModBootstrap extends CEntity {
    protected var modVersion : CName;
    default modVersion = '0.4.1';
    // ------------------------------------------------------------------------
    protected var modRegistry: CModRegistry;
    protected var log: CModLogger;
    // ------------------------------------------------------------------------
    public function bootstrap() {
        log = new CModLogger in this;
        log.init('ModBootstrap', MLOG_DEBUG);

        log.info("bootstrap v" + NameToString(modVersion) + " started");
        // create + initialize all registered mods (scripts and entity mods)
        modRegistry = new CModRegistry in this;
        modRegistry.init();

        initMods();

        FactsRemove("bootstrap_started");
        FactsAdd("bootstrap_started", 1);
    }
    // ------------------------------------------------------------------------
    private function createEntitymod(path: String) : CEntity {
        var ent : CEntity;
        var template : CEntityTemplate;

        template = (CEntityTemplate)LoadResource(path, true);
        ent = theGame.CreateEntity(template,
            thePlayer.GetWorldPosition(), thePlayer.GetWorldRotation());

        return ent;
    }
    // ------------------------------------------------------------------------
    private function initMods() {
        var mods: array<CMod>;
        var entityMod: CEntityMod;
        var i: int;

        log.info("bootstrapping registered mods...");

        mods = modRegistry.getMods();

        for (i = 0; i < mods.Size(); i += 1) {
            entityMod = (CEntityMod)mods[i];

            if (entityMod) {
                entityMod.setModEntity(createEntitymod(entityMod.getTemplate()));
            }
            mods[i].init();

            // show/log some info about creation
            log.info("spawned mod: " + mods[i].getModInfo());
        }
    }
    // ------------------------------------------------------------------------
}
// ----------------------------------------------------------------------------
abstract class CModFactory {
    private var mods: array<CMod>;

    protected function createMods();

    public final function init() { createMods(); }

    protected final function add(mod: CMod) { mods.PushBack(mod); }

    public final function getMods() : array<CMod> { return mods; }
}
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
abstract class CMod extends IScriptable {
    protected var modName : CName;
    protected var modVersion : CName;
    protected var modAuthor : String;
    protected var modUrl : String;

    protected var log: CModLogger;
    protected var logLevel: EModLogLevel;

    public function init() {
        log = new CModLogger in this;
        log.init(modName, logLevel);
        log.debug("initialized");
    }

    public function getModInfo() : String {
        return NameToString(modName) + " v" + NameToString(modVersion)
            + " by " + modAuthor + " (" + modUrl + ")";
    }
}
// ----------------------------------------------------------------------------
abstract class CEntityMod extends CMod {
    protected var template: String;
    protected var modEntity: CEntity;

    public final function getTemplate() : String { return template; }

    public final function setModEntity(ent: CEntity) {
        modEntity = ent;
    }
}
// ----------------------------------------------------------------------------
class CModConverter extends CUnknownResource {
    private var u8: array<Uint8>;

    public final function u8ToInt(u8: Uint8) : Int {
        return StringToInt(IntToString(u8));
    }

    public final function intToU8(i32: Int) : Uint8 {
        return u8[Clamp(i32, 0, 255)];
    }
}
// ----------------------------------------------------------------------------
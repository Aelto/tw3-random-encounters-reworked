// ----------------------------------------------------------------------------
abstract class IModStorageData {
    public var id: CName;
    public var containerId: CName;
}
// ----------------------------------------------------------------------------
class CModStorage extends CPeristentEntity {
    // ------------------------------------------------------------------------
    private saved var data: array<IModStorageData>;
    // ------------------------------------------------------------------------
    public function listContainerIds(id: CName): array<CName> {
        var null: IModStorageData;
        var containers: int = data.Size();
        var i: int;
        var result: array<CName>;

        for (i = 0; i < containers; i += 1) {
            if (data[i].id == id) {
                result.PushBack(data[i].containerId);
            }
        }

        return result;
    }
    // ------------------------------------------------------------------------
    public function load(id: CName, optional containerid: CName) : IModStorageData {
        var null: IModStorageData;
        var containers: int = data.Size();
        var i: int;

        for (i = 0; i < containers; i += 1) {
            if (data[i].id == id && data[i].containerId == containerid) {
                return data[i];
            }
        }

        return null;
    }
    // ------------------------------------------------------------------------
    public function save(savedata: IModStorageData) : bool {
        var containers: int = data.Size();
        var i: int;

        if (savedata.id != '') {

            for (i = 0; i < containers; i += 1) {
                if (data[i].id == savedata.id && data[i].containerId == savedata.containerId) {
                    // replace
                    data[i] = savedata;
                    return true;
                }
            }

            // nothing saved yet
            data.PushBack(savedata);
            return true;
        }
        return false;
    }
    // ------------------------------------------------------------------------
    public function remove(id: CName, optional containerid: CName) : bool {
        var containers: int = data.Size();
        var i: int;
        for (i = 0; i < containers; i += 1) {
            if (data[i].id == id && data[i].containerId == containerid) {
                data.Erase(i);
                return true;
            }
        }
        // not found
        return false;
    }
    // ------------------------------------------------------------------------
}
// ----------------------------------------------------------------------------
function GetModStorage() : CModStorage {
    var storage: CModStorage;
    var template : CEntityTemplate;
    var tags: array<CName>;

    storage = (CModStorage)theGame.GetEntityByTag('MOD_STORAGE');

    if (!storage) {
        // FIXME path
        template = (CEntityTemplate)LoadResource("dlc/modtemplates/bootstrap/modstorage.w2ent", true);
        tags.PushBack('MOD_STORAGE');
        storage = (CModStorage) theGame.CreateEntity(
            template, thePlayer.GetWorldPosition(), , , , , PM_Persist, tags);
    }

    return storage;
}
// ----------------------------------------------------------------------------

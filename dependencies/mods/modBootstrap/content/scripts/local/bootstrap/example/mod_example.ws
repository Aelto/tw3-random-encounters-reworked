
class CModExampleMod extends CMod {
    default modName = 'ExampleMod';
    default modAuthor = "unknown";
    default modUrl = "http://www.nexusmods.com/witcher3/mods/????/";
    default modVersion = '0.1';

    default logLevel = MLOG_DEBUG;

    public function init() {
        super.init();

        // DO STUFF
        // Note: when this mode is called the screen is still black.
    }
}

function modCreate_ExampleMod() : CMod {
    // do nothing besides creating and returning of mod class!
    return new CModExampleMod in thePlayer;
}

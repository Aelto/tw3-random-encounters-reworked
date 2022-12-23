// ----------------------------------------------------------------------------
enum EModLogLevel {
    MLOG_NONE = 0,
    MLOG_ERROR = 1,
    MLOG_INFO = 2,
    MLOG_DEBUG = 3
}
// ----------------------------------------------------------------------------
class CModLogger {
    protected var channel : name;
    protected var verbosity : EModLogLevel;

    protected final function logOut(level : EModLogLevel, prefix : string, msg : string) {
        if (level <= verbosity) {
            LogChannel(channel, prefix + msg);
        }
    }

    public function init(loggerName: name, optional verbosity: EModLogLevel) {
        this.channel = loggerName;
        this.verbosity = verbosity;
    }

    public function error(msg : string) {
        logOut(MLOG_ERROR, "ERROR: ",  msg);
    }

    public function debug(msg : string) {
        logOut(MLOG_DEBUG, "DEBUG: ",  msg);
    }

    public function info(msg : string) {
        logOut(MLOG_INFO, "INFO: ",  msg);
    }
}
// ----------------------------------------------------------------------------

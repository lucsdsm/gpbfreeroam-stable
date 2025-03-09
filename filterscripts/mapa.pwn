#define FILTERSCRIPT

#include <open.mp>

#if defined FILTERSCRIPT

public OnFilterScriptInit() {
    return 1;

}

public OnFilterScriptExit() {
    return 1;
}

#else

#endif

public OnPlayerConnect(playerid) {
    return 1;
}
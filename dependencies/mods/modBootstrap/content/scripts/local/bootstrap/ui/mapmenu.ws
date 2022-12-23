// ----------------------------------------------------------------------------
// provides information about a custom hub
class CCustomHubInfo extends CUnknownResource {
    // hubname must be the same as world path name (levels/<hubname>/<hubname>.w2w
    // hubicon is fetched as  "img://icons/hub_<hubname>.png" with the img path
    // setup in CR4ScaleformContentDLCMounter
    public var hubname: String;
    // positions of the hubicon in the world map
    public var worldMapPosX: int;
    public var worldMapPosY: int;
    // information about the (suggested) level shown in the world map
    public var suggestedLevel: Uint8;
}
// ----------------------------------------------------------------------------
// derived to add custom hubs to map menu
class CCustomHubsMapMenu extends CR4MapMenu {
    // ------------------------------------------------------------------------
    function Initialize() {
        var manager: CCommonMapManager;
        var currentJournalArea : int;
        var currentJournalAreaName : string;

        // Initialize updates map pins in last statement (call to SwitchToHubMap)
        // since this may break some pins for new hubs the call to SwitchToHubMap will
        // be postponed (ignored in overwritten method if onStartUp is true).
        // after addition of custom hubs the call will be "redone"
        super.Initialize();

        // add custom hubs
        SetCustomHubs();

        // redo postponed SwitchToHubMap call: simulate steps for onStartup == true
        // manually (set area name in flash)
        manager = theGame.GetCommonMapManager();
        currentJournalArea = manager.GetCurrentJournalArea();

        SwitchToHubMap(currentJournalArea, false);
        GetMenuFlashValueStorage().SetFlashString("map.current.area.name", manager.GetMapName(currentJournalArea));
    }
    // ------------------------------------------------------------------------
    // workaround for wrong quest area markers in custom multi-hub quests
    private function UpdateQuestAreas() {
        var manager: CWitcherJournalManager = theGame.GetJournalManager();
        var areasWithQuests : array< int >;
        var i : int;
        var flashObject : CScriptedFlashObject;
        var flashArray  : CScriptedFlashArray;
        // --
        var trackedObjectives: array<SJournalQuestObjectiveData>;
        var objectiveData: SJournalQuestObjectiveData;
        var maxHubSlot, hubId: int;

        areasWithQuests = manager.GetJournalAreasWithQuests();

        // use workaround only if custom hubs are involved
        maxHubSlot = ArrayFindMaxInt(areasWithQuests);
        if (areasWithQuests[maxHubSlot] > (int)AN_Dlc_Bob) {
            areasWithQuests.Clear();

            // just mark worlds of all *active* objectives
            manager.GetTrackedQuestObjectivesData(trackedObjectives);
            for (i = 0; i < trackedObjectives.Size(); i += 1) {
                objectiveData = trackedObjectives[i];

                if (objectiveData.status == JS_Active) {
                    hubId = objectiveData.objectiveEntry.GetWorld();
                    if (!areasWithQuests.Contains(hubId)) {
                        areasWithQuests.PushBack(hubId);
                    }
                }
            }
        }

        flashArray = m_flashValueStorage.CreateTempFlashArray();
        for ( i = 0; i < areasWithQuests.Size(); i += 1 )
        {
            //areasNamesWithQuests.PushBack( AreaTypeToName( areasWithQuests[ i ] ) );
            flashObject = m_flashValueStorage.CreateTempFlashObject();
            flashObject.SetMemberFlashString( "area", AreaTypeToName( areasWithQuests[ i ] ) );
            flashArray.PushBackFlashObject( flashObject );
        }
        m_flashValueStorage.SetFlashArray( "worldmap.global.universe.questareas", flashArray );
    }
    // ------------------------------------------------------------------------
    // New functions for declaring custom hubs
    private function SetCustomHubs() {
        var hubInfo: CCustomHubInfo;
        var l_flashArray : CScriptedFlashArray;
        var l_flashObject : CScriptedFlashObject;
        var i, currentArea: int;
        var isInArea : bool;

        currentArea = theGame.GetCommonMapManager().GetCurrentArea();
        l_flashArray = GetMenuFlashValueStorage().CreateTempFlashArray();

        // check all available testhub slots for info
        for (i = 12; i < 15; i += 1) {
            hubInfo = (CCustomHubInfo)LoadResource("dlc\testhubinfo_" + IntToString(i) + ".w3hub", true);
            if (hubInfo) {
                LogChannel('WORLD', "found testhub info for id " + IntToString(i) + ": " + hubInfo.hubname);

                isInArea = currentArea == (int)AreaNameToType(hubInfo.hubname);
                l_flashArray.PushBackFlashObject(CreateCustomHubObject(
                        hubInfo.hubname, hubInfo.worldMapPosX, hubInfo.worldMapPosY, hubInfo.suggestedLevel, isInArea)
                );
            }
        }

        // check all available public hubslots for info
        for (i = 15; i < 99; i += 1) {
            hubInfo = (CCustomHubInfo)LoadResource("dlc\hubinfo_" + IntToString(i) + ".w3hub", true);
            if (hubInfo) {
                // LogChannel('WORLD', "found hub info for id " + IntToString(i) + ": " + hubInfo.hubname);
                isInArea = currentArea == (int)AreaNameToType(hubInfo.hubname);
                l_flashArray.PushBackFlashObject(CreateCustomHubObject(
                        hubInfo.hubname, hubInfo.worldMapPosX, hubInfo.worldMapPosY, hubInfo.suggestedLevel, isInArea)
                );
            }
        }
        GetMenuFlashValueStorage().SetFlashArray("map.hubs.custom", l_flashArray);
    }
    // ------------------------------------------------------------------------
    private function CreateCustomHubObject(areaName : string, x: int, y : int, level : int, isInArea: bool) : CScriptedFlashObject
    {
        var l_flashObject : CScriptedFlashObject;
        var isVisible, isEnabled, isQuest, isPlayer : bool;

        // visible - visibility of hub icon in the map menu
        isVisible = FactsQuerySum("hubvisibility_" + areaName) > 0;

        // enabled - clicking on the hub icon: false means nothing happens
        isEnabled = isVisible && FactsQuerySum("hubenabled_" + areaName) > 0;

        // check if currently tracked objective is in this area
        if (AreaTypeToName(theGame.GetJournalManager().GetHighlightedObjective().GetWorld()) == areaName) {
            isQuest = true;
        }

        l_flashObject = GetMenuFlashValueStorage().CreateTempFlashObject("Hub_Custom");

        l_flashObject.SetMemberFlashNumber("recLevel", level);
        l_flashObject.SetMemberFlashInt("x", x);
        l_flashObject.SetMemberFlashInt("y", y);
        l_flashObject.SetMemberFlashString("worldName", areaName);
        l_flashObject.SetMemberFlashString("realName", areaName);

        l_flashObject.SetMemberFlashString("uiIcon", "img://icons/hub_" + areaName + ".png");

        l_flashObject.SetMemberFlashBool("visible", isVisible);
        l_flashObject.SetMemberFlashBool("enabled", isEnabled);
        l_flashObject.SetMemberFlashBool("isPlayer", isInArea);
        l_flashObject.SetMemberFlashBool("isQuest", isQuest);

        return l_flashObject;
    }
    // ------------------------------------------------------------------------
    function SwitchToHubMap(area : EAreaName, onStartup : bool) {
        // ignore first start - it will be called explicitly from overwritten Initialize()

        if (onStartup) {
            return;
        }

        super.SwitchToHubMap(area, onStartup);
    }
    // ------------------------------------------------------------------------
    // only called in Initialize <- extension maybe/probably not required?
    /*
    function UpdateActiveAreas() : void {
        var pinsList      : array< SAvailableFastTravelMapPin >;
        var curPin      : SAvailableFastTravelMapPin;
        var availableAreas  : array< bool >;
        var i         : int;

        super.UpdateActiveAreas();

        for (i = 0; i < EnumGetMax('EAreaName') + 1; i += 1) {
            availableAreas.PushBack(false);
        }

        pinsList = theGame.GetCommonMapManager().GetFastTravelPoints(true, true);

        for (i = 0; i < pinsList.Size(); i += 1) {
            curPin = pinsList[i];
            availableAreas[curPin.area] = true;
        }
        // set available flag for custom hubs
        for (i = 15; i < 100; i += 1) {
            //TODO
            // if hub installed update flash flag
            //m_flashValueStorage.SetFlashBool("universearea.toussaint.active", availableAreas[AN_Dlc_Bob]);
        }
    }*/
    // ------------------------------------------------------------------------
}
// ----------------------------------------------------------------------------

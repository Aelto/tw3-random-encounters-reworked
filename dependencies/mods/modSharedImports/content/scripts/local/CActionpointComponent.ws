import class CActionPointComponent extends CWayPointComponent {
    import var isEnabled: Bool;
    import var jobTreeRes: CJobTree;
    import var actionBreakable: Bool;
    import var breakableByCutscene: Bool;
    import var preferredNextAPs: TagList;
    import var activateOnStart: Bool;
    import var placementImportance: EWorkPlacementImportance;
    import var ignoreCollosions: Bool;
    import var disableSoftReactions: Bool;
    import var fireSourceDependent: Bool;
    import var forceKeepIKactive: Bool;
    //import var customWorkTree: ptr:CAIPerformCustomWorkTree;
    //import var eventWorkStarted: "array:2,0,ptr:IPerformableAction;
    //import var eventWorkEnded: "array:2,0,ptr:IPerformableAction;
}
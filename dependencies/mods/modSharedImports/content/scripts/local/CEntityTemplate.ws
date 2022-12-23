import class CEntityTemplate extends CResource {
    import var includes: array<CEntityTemplate>;
    import var overrides: array<SEntityTemplateOverride>;
    import var properOverrides: Bool;
    import var backgroundOffset: Vector;
    import var dataCompilationTime: CDateTime;
    import var entityClass: CName;
    //import var entityObject: ptr:CEntity;
    import var bodyParts: array<CEntityBodyPart>;
    import var appearances: array<CEntityAppearance>;
    import var usedAppearances: array<CName>;
    import var voicetagAppearances: array<VoicetagAppearancePair>;
    //import var effects: array<ptr:CFXDefinition>;
    import var slots: array<EntitySlot>;
    //import var templateParams: array<ptr:CEntityTemplateParam>;
    import var coloringEntries: array<SEntityTemplateColoringEntry>;
    import var instancePropEntries: array<SComponentInstancePropertyEntry>;
    import var flatCompiledData: array<Uint8>;
    import var streamedAttachments: array<SStreamedAttachment>;
    import var cookedEffects: array<CEntityTemplateCookedEffect>;
    import var cookedEffectsVersion: Uint32;
}

import struct SEntityTemplateOverride {
    import var componentName: CName;
    import var className: CName;
    import var overriddenProperties: array<CName>;
}

import struct CEntityBodyPart {
    //import var name: CName;                       -- name is reserved keyword
    import var states: array<CEntityBodyPartState>;
    import var wasIncluded: Bool;
}

import struct CEntityBodyPartState {
    //import var name: CName;                       -- name is reserved keyword
    import var componentsInUse: array<CComponentReference>;
}
import struct CComponentReference {
    //import var name: String;                      -- name is reserved keyword
    import var className: CName;
}

import struct CEntityAppearance {
    //import var name: CName;                       -- name is reserved keyword
    import var voicetag: CName;
    //import var appearanceParams: array<ptr:CEntityTemplateParam>;
    import var useVertexCollapse: Bool;
    import var usesRobe: Bool;
    import var wasIncluded: Bool;
    import var includedTemplates: array<CEntityTemplate>;
    import var collapsedComponents: array<CName>;
}

import struct VoicetagAppearancePair {
    import var voicetag: CName;
    import var appearance: CName;
}
import struct EntitySlot {
    import var wasIncluded: Bool;
    //import var name: CName;                       -- name is reserved keyword
    import var componentName: CName;
    import var boneName: CName;
    import var transform: EngineTransform;
    import var freePositionAxisX: Bool;
    import var freePositionAxisY: Bool;
    import var freePositionAxisZ: Bool;
    import var freeRotation: Bool;
}
import struct SEntityTemplateColoringEntry {
    import var appearance: CName;
    import var componentName: CName;
    import var colorShift1: CColorShift;
    import var colorShift2: CColorShift;
}
import struct CColorShift {
    import var hue: Uint16;
    import var saturation: Int8;
    import var luminance: Int8;
}
import struct SComponentInstancePropertyEntry {
    import var component: CName;
    import var property: CName;
}
import struct SStreamedAttachment {
    import var parentName: CName;
    import var parentClass: CName;
    import var childName: CName;
    import var childClass: CName;
    import var data: array<Uint8>;
}
import struct CEntityTemplateCookedEffect {
    //import var name: CName;                       -- name is reserved keyword
    import var animName: CName;
    import var buffer: SharedDataBuffer;
}

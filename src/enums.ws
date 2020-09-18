
enum EHumanType
{
  HT_BANDIT       = 0,
  HT_NOVBANDIT    = 1,
  HT_SKELBANDIT   = 2,
  HT_SKELBANDIT2  = 3,
  HT_CANNIBAL     = 4,
  HT_RENEGADE     = 5,
  HT_PIRATE       = 6,
  HT_SKELPIRATE   = 7,
  HT_NILFGAARDIAN = 8,
  HT_WITCHHUNTER  = 9,

  HT_MAX          = 10,
  HT_NONE         = 11
}

enum CreatureType {
  CreatureHuman        = 0,
  CreatureARACHAS      = 1,
  CreatureENDREGA      = 2,
  CreatureGHOUL        = 3,
  CreatureALGHOUL      = 4,
  CreatureNEKKER       = 5,
  CreatureDROWNER      = 6,
  CreatureROTFIEND     = 7,
  CreatureWOLF         = 8,
  CreatureWRAITH       = 9,
  CreatureHARPY        = 10,
  CreatureSPIDER       = 11,
  CreatureCENTIPEDE    = 12,
  CreatureDROWNERDLC   = 13,  
  CreatureBOAR         = 14,  
  CreatureBEAR         = 15,
  CreaturePANTHER      = 16,  
  CreatureSKELETON     = 17,
  CreatureECHINOPS     = 18,
  CreatureKIKIMORE     = 19,
  CreatureBARGHEST     = 20,
  CreatureSKELWOLF     = 21,
  CreatureSKELBEAR     = 22,
  CreatureWILDHUNT     = 23,

  // large creatures below
  CreatureLESHEN       = 24,
  CreatureWEREWOLF     = 25,
  CreatureFIEND        = 26,
  CreatureEKIMMARA     = 27,
  CreatureKATAKAN      = 28,
  CreatureGOLEM        = 29,
  CreatureELEMENTAL    = 30,
  CreatureNIGHTWRAITH  = 31,
  CreatureNOONWRAITH   = 32,
  CreatureCHORT        = 33,
  CreatureCYCLOPS      = 34,
  CreatureTROLL        = 35,
  CreatureHAG          = 36,
  CreatureFOGLET       = 37,
  CreatureBRUXA        = 38,
  CreatureFLEDER       = 39,
  CreatureGARKAIN      = 40,
  CreatureDETLAFF      = 41,
  CreatureGIANT        = 42,  
  CreatureSHARLEY      = 43,
  CreatureWIGHT        = 44,
  CreatureGRYPHON      = 45,
  CreatureCOCKATRICE   = 46,
  CreatureBASILISK     = 47,
  CreatureWYVERN       = 48,
  CreatureFORKTAIL     = 49,
  CreatureSKELTROLL    = 50,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  CreatureMAX          = 51,
  CreatureNONE         = 52,
}


enum EncounterType {
  EncounterType_DEFAULT  = 0,
  EncounterType_HUNT     = 1,
  EncounterType_CONTRACT = 2,
  EncounterType_MAX      = 3
}


enum OutOfCombatRequest {
  OutOfCombatRequest_TROPHY_CUTSCENE = 0,
  OutOfCombatRequest_TROPHY_NONE     = 1
}

enum TrophyVariant {
  TrophyVariant_PRICE_LOW = 0,
  TrophyVariant_PRICE_MEDIUM = 1,
  TrophyVariant_PRICE_HIGH = 2
}

enum RER_Trophy {
  Trophy_HUMAN,
  Trophy_ARACHAS,
  Trophy_INSECTOID,
  Trophy_NECROPHAGE,
  Trophy_NEKKER,
  Trophy_WRAITH,
  Trophy_HARPY,
  Trophy_SPIRIT,
  Trophy_BEAST,
  Trophy_WILDHUNT,
  Trophy_LESHEN,
  Trophy_WEREWOLF,
  Trophy_FIEND,
  Trophy_EKIMMARA,
  Trophy_KATAKAN,
  Trophy_ELEMENTAL,
  Trophy_NIGHTWRAITH,
  Trophy_NOONWRAITH,
  Trophy_CZART,
  Trophy_CYCLOP,
  Trophy_TROLL,
  Trophy_GRAVE_HAG,
  Trophy_FOGLING,
  Trophy_GARKAIN,
  Trophy_VAMPIRE,
  Trophy_GIANT,
  Trophy_SHARLEY,
  Trophy_WIGHT,
  Trophy_GRIFFIN,
  Trophy_COCKATRICE,
  Trophy_BASILISK,
  Trophy_WYVERN,
  Trophy_FORKTAIL
}
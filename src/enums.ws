
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
  CreatureHUMAN        = 0,
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
  CreatureBERSERKER    = 24,
  CreatureSIREN        = 25,

  // large creatures below
  CreatureDRACOLIZARD  = 26,
  CreatureGARGOYLE     = 27,
  CreatureLESHEN       = 28,
  CreatureWEREWOLF     = 29,
  CreatureFIEND        = 30,
  CreatureEKIMMARA     = 31,
  CreatureKATAKAN      = 32,
  CreatureGOLEM        = 33,
  CreatureELEMENTAL    = 34,
  CreatureNIGHTWRAITH  = 35,
  CreatureNOONWRAITH   = 36,
  CreatureCHORT        = 37,
  CreatureCYCLOP      = 38,
  CreatureTROLL        = 39,
  CreatureHAG          = 40,
  CreatureFOGLET       = 41,
  CreatureBRUXA        = 42,
  CreatureFLEDER       = 43,
  CreatureGARKAIN      = 44,
  CreatureDETLAFF      = 45,
  CreatureGIANT        = 46,  
  CreatureSHARLEY      = 47,
  CreatureWIGHT        = 48,
  CreatureGRYPHON      = 49,
  CreatureCOCKATRICE   = 50,
  CreatureBASILISK     = 51,
  CreatureWYVERN       = 52,
  CreatureFORKTAIL     = 53,
  CreatureSKELTROLL    = 54,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  CreatureMAX          = 55,
  CreatureNONE         = 56,
}


enum EncounterType {
  // default means an ambush.
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

enum RER_Difficulty {
  RER_Difficulty_EASY = 0,
  RER_Difficulty_MEDIUM = 1,
  RER_Difficulty_HARD = 2,
  RER_Difficulty_RANDOM = 3
}

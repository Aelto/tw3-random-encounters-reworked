

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
  SMALL_CREATURE,
  LARGE_CREATURE
}

enum SmallCreatureType {
  SmallCreatureHuman        = 0,
  SmallCreatureARACHAS      = 1,
  SmallCreatureENDREGA      = 2,
  SmallCreatureGHOUL        = 3,
  SmallCreatureALGHOUL      = 4,
  SmallCreatureNEKKER       = 5,
  SmallCreatureDROWNER      = 6,
  SmallCreatureROTFIEND     = 7,
  SmallCreatureWOLF         = 8,
  SmallCreatureWRAITH       = 9,
  SmallCreatureHARPY        = 10,
  SmallCreatureSPIDER       = 11,
  SmallCreatureCENTIPEDE    = 12,
  SmallCreatureDROWNERDLC   = 13,  
  SmallCreatureBOAR         = 14,  
  SmallCreatureBEAR         = 15,
  SmallCreaturePANTHER      = 16,  
  SmallCreatureSKELETON     = 17,
  SmallCreatureECHINOPS     = 18,
  SmallCreatureKIKIMORE     = 19,
  SmallCreatureBARGHEST     = 20,
  SmallCreatureSKELWOLF     = 21,
  SmallCreatureSKELBEAR     = 22,
  SmallCreatureWILDHUNT     = 23,

  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  SmallCreatureMAX          = 24,
  SmallCreatureNONE         = 25,
}

enum LargeCreatureType {
  LargeCreatureLESHEN       = 0,
  LargeCreatureWEREWOLF     = 1,
  LargeCreatureFIEND        = 2,
  LargeCreatureEKIMMARA     = 3,
  LargeCreatureKATAKAN      = 4,
  LargeCreatureGOLEM        = 5,
  LargeCreatureELEMENTAL    = 6,
  LargeCreatureNIGHTWRAITH  = 7,
  LargeCreatureNOONWRAITH   = 8,
  LargeCreatureCHORT        = 9,
  LargeCreatureCYCLOPS      = 10,
  LargeCreatureTROLL        = 11,
  LargeCreatureHAG          = 12,
  LargeCreatureFOGLET       = 13,
  LargeCreatureBRUXA        = 14,
  LargeCreatureFLEDER       = 15,
  LargeCreatureGARKAIN      = 16,
  LargeCreatureDETLAFF      = 17,
  LargeCreatureGIANT        = 18,  
  LargeCreatureSHARLEY      = 19,
  LargeCreatureWIGHT        = 20,
  LargeCreatureVAMPIRE      = 21,
  LargeCreatureGRYPHON      = 22,
  LargeCreatureCOCKATRICE   = 23,
  LargeCreatureBASILISK     = 24,
  LargeCreatureWYVERN       = 25,
  LargeCreatureFORKTAIL     = 26,
  LargeCreatureSKELTROLL    = 27,


  // It is important to keep the numbers continuous.
  // The `SpawnRoller` classes uses these numbers to
  // to fill its arrays.
  // (so that i dont have to write 40 lines by hand)
  LargeCreatureMAX          = 28,
  LargeCreatureNONE         = 29
}

enum EncounterType {
  EncounterType_DEFAULT = 0,
  EncounterType_HUNT    = 1
}

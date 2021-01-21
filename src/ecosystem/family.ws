
// this struct is there to store the impact the specified creature has on other
// creatures, be it positively or negatively.
struct EcosystemCreatureImpact {
  // this array stores how much the CreatureType's (the index) spawn rate should
  // be influenced. The `float` value can be positive or even negative and will
  // affect the spawn rate positively or negatively.
  var influences: array<float>;
}

// defines the ecosystem is the specified area and the different impacts living
// creatures have over other creatures.
struct EcosystemArea {
  // the radius is stored as a property because the ecosystem could grow/disappear
  // over time.
  var radius: float;

  var position: Vector;

  // it's an array where for each CreatureType (that is the index) we specify
  // the power of CreatureImpact.
  // by default it will be 0, and whenever a creature is killed it will be decreased
  // by 1 and each time a new one appear it will be increased by 1.
  var impacts_power_by_creature_type: array<int>;
}

class EcosystemCreatureImpactBuilder {
  var impact: EcosystemCreatureImpact;

  function influence(strength: float): EcosystemCreatureImpactBuilder {
    this.impact.PushBack(strength);

    return this;
  }

  function build(): EcosystemCreatureImpact {
    return this.impact;
  }
}



function getEcosystemImpactList(): array<EcosystemCreatureImpact> {
  var impacts: array<EcosystemCreatureImpact>;

  // CreatureHUMAN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(0) //CreatureHUMAN
      .influence(-1) //CreatureARACHAS
      .influence(-1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(-1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(-1) //CreatureHARPY
      .influence(-1) //CreatureSPIDER
      .influence(-1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(-1) //CreatureBOAR
      .influence(-1) //CreatureBEAR
      .influence(-1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(-1) //CreatureECHINOPS
      .influence(-1) //CreatureKIKIMORE
      .influence(-1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(-1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(-1) //CreatureSIREN

      // large creatures below
      .influence(-1) //CreatureDRACOLIZARD
      .influence(-1) //CreatureGARGOYLE
      .influence(-1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(-1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(-1) //CreatureCHORT
      .influence(-1) //CreatureCYCLOP
      .influence(-1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(-1) //CreatureFLEDER
      .influence(-1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(-1) //CreatureGIANT
      .influence(-1) //CreatureSHARLEY
      .influence(-1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureARACHAS
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureENDREGA
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGHOUL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureALGHOUL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureNEKKER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureDROWNER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureROTFIEND
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWOLF
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWRAITH
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureHARPY
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSPIDER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureCENTIPEDE
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureDROWNERDLC
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBOAR
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBEAR
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreaturePANTHER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSKELETON
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureECHINOPS
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureKIKIMORE
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBARGHEST
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSKELWOLF
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSKELBEAR
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWILDHUNT
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBERSERKER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSIREN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // large creatures below
  // CreatureDRACOLIZARD
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGARGOYLE
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureLESHEN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWEREWOLF
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureFIEND
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureEKIMMARA
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureKATAKAN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGOLEM
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureELEMENTAL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureNIGHTWRAITH
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureNOONWRAITH
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureCHORT
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureCYCLOP
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureTROLL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureHAG
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureFOGLET
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBRUXA
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureFLEDER
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGARKAIN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureDETLAFF
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGIANT
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSHARLEY
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWIGHT
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureGRYPHON
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureCOCKATRICE
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureBASILISK
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureWYVERN
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureFORKTAIL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  // CreatureSKELTROLL
  impacts.PushBack(
    (new EcosystemCreatureImpactBuilder in thePlayer)
      .influence(1) //CreatureHUMAN
      .influence(1) //CreatureARACHAS
      .influence(1) //CreatureENDREGA
      .influence(1) //CreatureGHOUL
      .influence(1) //CreatureALGHOUL
      .influence(1) //CreatureNEKKER
      .influence(1) //CreatureDROWNER
      .influence(1) //CreatureROTFIEND
      .influence(1) //CreatureWOLF
      .influence(1) //CreatureWRAITH
      .influence(1) //CreatureHARPY
      .influence(1) //CreatureSPIDER
      .influence(1) //CreatureCENTIPEDE
      .influence(1) //CreatureDROWNERDLC
      .influence(1) //CreatureBOAR
      .influence(1) //CreatureBEAR
      .influence(1) //CreaturePANTHER
      .influence(1) //CreatureSKELETON
      .influence(1) //CreatureECHINOPS
      .influence(1) //CreatureKIKIMORE
      .influence(1) //CreatureBARGHEST
      .influence(1) //CreatureSKELWOLF
      .influence(1) //CreatureSKELBEAR
      .influence(1) //CreatureWILDHUNT
      .influence(1) //CreatureBERSERKER
      .influence(1) //CreatureSIREN

      // large creatures below
      .influence(1) //CreatureDRACOLIZARD
      .influence(1) //CreatureGARGOYLE
      .influence(1) //CreatureLESHEN
      .influence(1) //CreatureWEREWOLF
      .influence(1) //CreatureFIEND
      .influence(1) //CreatureEKIMMARA
      .influence(1) //CreatureKATAKAN
      .influence(1) //CreatureGOLEM
      .influence(1) //CreatureELEMENTAL
      .influence(1) //CreatureNIGHTWRAITH
      .influence(1) //CreatureNOONWRAITH
      .influence(1) //CreatureCHORT
      .influence(1) //CreatureCYCLOP
      .influence(1) //CreatureTROLL
      .influence(1) //CreatureHAG
      .influence(1) //CreatureFOGLET
      .influence(1) //CreatureBRUXA
      .influence(1) //CreatureFLEDER
      .influence(1) //CreatureGARKAIN
      .influence(1) //CreatureDETLAFF
      .influence(1) //CreatureGIANT
      .influence(1) //CreatureSHARLEY
      .influence(1) //CreatureWIGHT
      .influence(1) //CreatureGRYPHON
      .influence(1) //CreatureCOCKATRICE
      .influence(1) //CreatureBASILISK
      .influence(1) //CreatureWYVERN
      .influence(1) //CreatureFORKTAIL
      .influence(1) //CreatureSKELTROLL
      .build()
  );

  return web;
}
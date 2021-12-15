
enum RER_SpeciesTypes {
  SpeciesTypes_BEASTS = 0,
  SpeciesTypes_CURSED = 1,
  SpeciesTypes_DRACONIDS = 2,
  SpeciesTypes_ELEMENTA = 3,
  SpeciesTypes_HYBRIDS = 4,
  SpeciesTypes_INSECTOIDS = 5,
  SpeciesTypes_NECROPHAGES = 6,
  SpeciesTypes_OGROIDS = 7,
  SpeciesTypes_RELICTS = 8,
  SpeciesTypes_SPECTERS = 9,
  SpeciesTypes_VAMPIRES = 10,

  SpeciesTypes_MAX = 11,
  SpeciesTypes_NONE = 12,
}

function RER_getRandomSpeciesType(): RER_SpeciesTypes {
  return (RER_SpeciesTypes)RandRange(SpeciesTypes_MAX);
}

function RER_getSeededRandomSpeciesType(rng: RandomNumberGenerator): RER_SpeciesTypes {
  var max: float;

  max = ((float)((int)SpeciesTypes_MAX));

  return (RER_SpeciesTypes)RoundF(rng.nextRange(max, 0));
}

function RER_getSpeciesLocalizedString(species: RER_SpeciesTypes): string {
  switch (species) {
    case SpeciesTypes_BEASTS:
      return GetLocStringByKey("rer_species_beasts");
      break;
    
    case SpeciesTypes_CURSED:
      return GetLocStringByKey("rer_species_cursed");
      break;

    case SpeciesTypes_DRACONIDS:
      return GetLocStringByKey("rer_species_draconids");
      break;

    case SpeciesTypes_ELEMENTA:
      return GetLocStringByKey("rer_species_elementa");
      break;

    case SpeciesTypes_HYBRIDS:
      return GetLocStringByKey("rer_species_hybrids");
      break;

    case SpeciesTypes_INSECTOIDS:
      return GetLocStringByKey("rer_species_insectoids");
      break;

    case SpeciesTypes_NECROPHAGES:
      return GetLocStringByKey("rer_species_necrophages");
      break;

    case SpeciesTypes_OGROIDS:
      return GetLocStringByKey("rer_species_ogroids");
      break;

    case SpeciesTypes_RELICTS:
      return GetLocStringByKey("rer_species_relicts");
      break;

    case SpeciesTypes_SPECTERS:
      return GetLocStringByKey("rer_species_specters");
      break;

    case SpeciesTypes_VAMPIRES:
      return GetLocStringByKey("rer_species_vampires");
      break;
  }
}
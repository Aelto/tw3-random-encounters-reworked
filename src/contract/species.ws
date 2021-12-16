
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
  var output: string;
  
  switch (species) {
    case SpeciesTypes_BEASTS:
      output = GetLocStringByKey("rer_species_beasts");
      break;
    
    case SpeciesTypes_CURSED:
      output = GetLocStringByKey("rer_species_cursed");
      break;

    case SpeciesTypes_DRACONIDS:
      output = GetLocStringByKey("rer_species_draconids");
      break;

    case SpeciesTypes_ELEMENTA:
      output = GetLocStringByKey("rer_species_elementa");
      break;

    case SpeciesTypes_HYBRIDS:
      output = GetLocStringByKey("rer_species_hybrids");
      break;

    case SpeciesTypes_INSECTOIDS:
      output = GetLocStringByKey("rer_species_insectoids");
      break;

    case SpeciesTypes_NECROPHAGES:
      output = GetLocStringByKey("rer_species_necrophages");
      break;

    case SpeciesTypes_OGROIDS:
      output = GetLocStringByKey("rer_species_ogroids");
      break;

    case SpeciesTypes_RELICTS:
      output = GetLocStringByKey("rer_species_relicts");
      break;

    case SpeciesTypes_SPECTERS:
      output = GetLocStringByKey("rer_species_specters");
      break;

    case SpeciesTypes_VAMPIRES:
      output = GetLocStringByKey("rer_species_vampires");
      break;
  }

  return output;
}

function RER_getSpeciesFromLocalizedString(localized_string: string): RER_SpeciesTypes {
  if (StrContains(localized_string, GetLocStringByKey("rer_species_beasts"))) {
    return SpeciesTypes_BEASTS;
  }
    
  if (StrContains(localized_string, GetLocStringByKey("rer_species_cursed"))) {
    return SpeciesTypes_CURSED;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_draconids"))) {
    return SpeciesTypes_DRACONIDS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_elementa"))) {
    return SpeciesTypes_ELEMENTA;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_hybrids"))) {
    return SpeciesTypes_HYBRIDS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_insectoids"))) {
    return SpeciesTypes_INSECTOIDS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_necrophages"))) {
    return SpeciesTypes_NECROPHAGES;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_ogroids"))) {
    return SpeciesTypes_OGROIDS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_relicts"))) {
    return SpeciesTypes_RELICTS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_specters"))) {
    return SpeciesTypes_SPECTERS;
  }

  if (StrContains(localized_string, GetLocStringByKey("rer_species_vampires"))) {
    return SpeciesTypes_VAMPIRES;
  }

  return SpeciesTypes_NONE;
}
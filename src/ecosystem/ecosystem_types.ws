
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
  var impacts_power_by_creature_type: array<float>;
}

class EcosystemCreatureImpactBuilder {
  var impact: EcosystemCreatureImpact;

  function influence(strength: float): EcosystemCreatureImpactBuilder {
    this.impact.influences.PushBack(strength);

    return this;
  }

  function build(): EcosystemCreatureImpact {
    return this.impact;
  }
}

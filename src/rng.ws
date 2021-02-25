
// A random number generator based on the noise implementation by CDPR.
// Usage example:
//
// rng = (new RandomNumberGenerator in this).setSeed(10);
// rng.next(); // gives 0.035296
// rng.next(); // gives 0.715992
//
// rng.setSeed(10); // sets the seed at 10 and resets the generator
// rng.next(); // gives 0.035296
// rng.next(); // gives 0.715992
// 
class RandomNumberGenerator {
  var previous_number: float;
  var seed: int;

  public function setSeed(seed: int): RandomNumberGenerator {
    this.seed = seed;
    this.previous_number = 0;

    return this;
  }

  public function next(): float {
    var number: float;

    number = RandNoiseF(this.seed + (int)(this.previous_number * 10000000), 1);

    this.previous_number = number;

    return number;
  }

  public function nextRange(max: float, min: float): float {
    return this.next() * (max - min) + min;
  }
}
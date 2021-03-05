
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

  // when set at false the RNG class will ignore the seed and will simply
  // return true random numbers each time.
  var use_seed: bool;
  default use_seed = true;

  public function setSeed(seed: int): RandomNumberGenerator {
    this.seed = seed;
    this.previous_number = 0;

    return this;
  }

  public function useSeed(uses: bool): RandomNumberGenerator {
    this.use_seed = uses;

    return this;
  }

  public function next(): float {
    var number: float;

    // ignore the seed stuff if the class was set to ignore it
    if (!this.use_seed) {
      return RandF();
    }

    number = RandNoiseF(this.seed + (int)(this.previous_number * 10000000), 1);

    this.previous_number = number;

    return number;
  }

  public function nextRange(max: float, min: float): float {
    return this.next() * (max - min) + min;
  }
}
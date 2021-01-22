
// a TERRIBLE implementation of a hashing function.
// i wanted to do better but i was not sure i could use bitwise operators
function rer_hash_string(str: string): int {
  var output: int;
  var i: int;

  for (i = 0; i < StrLen(str); i += 1) {
    output += (int)str + i;
  }

  return output;
}
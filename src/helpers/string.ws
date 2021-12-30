
function upperCaseFirstLetter(text: string): string {
  var first_char: string;

  first_char = StrLeft(text, 1);

  return StrReplace(
    text,
    first_char,
    StrUpper(first_char)
  );
}
const fs = require('fs');
const path = require('path');

const strings_directory = path.join(
  __dirname,
  '..',
  'strings'
);

const FILE_TO_COPY = "en.w3strings";
const full_path_to_file_to_copy = path.join(
  strings_directory,
  FILE_TO_COPY
);

const LANGUAGES = [
  'ar',
  'br',
  'cz',
  'de',
  'es',
  'esmx',
  'fr',
  'hu',
  'it',
  'jp',
  'kr',
  'pl',
  'ru',
  'zh'
];

const FILE_EXTENSION = 'w3strings';

for (const language of LANGUAGES) {
  fs.copyFileSync(
    full_path_to_file_to_copy,
    path.join(strings_directory, `${language}.${FILE_EXTENSION}`)
  );
}

for (const file of fs.readdirSync(strings_directory)) {
  if (file === FILE_TO_COPY) {
    continue;
  }

  
}

console.log('done');
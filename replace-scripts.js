const path = require('path');
const fs = require('fs');

const witcher_game_location = path.join(
  'D:',
  'programs',
  'steam',
  'steamapps',
  'common',
  'The Witcher 3'
);

const repository_content_path = path.join(__dirname, 'content');

const backup_directory = path.join(
  __dirname,
  'content.backup'
);

const randomencounter_content_path = path.join(
  witcher_game_location,
  'mods',
  'modRandomEncounters',
  'content'
);

main(witcher_game_location);

function backup_content_files() {
  try {
    fs.mkdirSync(backup_directory);
  } catch (e) {}

  copy_directory(
    randomencounter_content_path,
    backup_directory
  );
}

function replace_content_files() {
  copy_directory(
    repository_content_path,
    randomencounter_content_path
  );
}

function revert_content_files(randomencounter_content_path) {
  copy_directory(
    backup_directory,
    randomencounter_content_path
  );
}

function copy_directory(origin, destination) {
  recursive_files_list(origin)
  .map(origin_file => ({ origin_file, destination_file: origin_file.replace(origin, destination) }))
  .forEach(({ origin_file, destination_file }) => {
    fs.mkdirSync(path.dirname(destination_file), { recursive: true });
    fs.copyFileSync(origin_file, destination_file);
  });
}

function recursive_files_list(directory, list = []) {
  const children = fs.readdirSync(directory);

  for (const child of children) {
    const child_path = path.join(directory, child);
    const stats = fs.statSync(child_path);

    if (stats.isDirectory()) {
      list.concat(recursive_files_list(child_path, list));
    }
    else {
      list.push(child_path);
    }
  }

  return list;
}

function main(witcher_game_location) {
  console.log(`witcher game location: ${witcher_game_location}`);

  if (process.argv.includes('--revert')) {
    console.log(`reverting changes using backup`);

    revert_content_files();
  }

  else if (process.argv.includes('--install')) {
    console.log(`doing backup of the files in ${randomencounter_content_path}`);

    backup_content_files();

    console.log(`copying files from ${repository_content_path} into ${randomencounter_content_path}`);
    replace_content_files();

    console.log(`you can use --revert to revert the changes made`);
  }

  else {
    console.log(`nothing done, use --revert or --install`);
  }
}
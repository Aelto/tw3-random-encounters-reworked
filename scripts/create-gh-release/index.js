const { execSync } = require('child_process');
const readline = require('readline');
const fs = require('fs');
const tokens = require('./tokens.js');
const AdmZip = require('adm-zip');
const { Octokit } = require("@octokit/rest");

const question = message => new Promise(resolve => {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  return rl.question(message, answer => {
    rl.close();

    resolve(answer);
  });
});

async function main() {
  const only_zip = process.argv.some(arg => arg === '-only-zip');
  console.log("process argv" + only_zip);

  const latest_release = execSync('git describe --tags --abbrev^=0').toString().trim();
  console.log(`last release is: ${latest_release}`);

  const new_version_name = await question('New version name? ');
  const commits_since_last_release = execSync(`git log ${latest_release}..HEAD --oneline`).toString();

  console.log(`commits since last release`);
  console.log(commits_since_last_release);

  if (!only_zip) {
    if (await question('Confirm you want to continue? (y/n) ') !== 'y') {
      console.log('Cancelling');

      return;
    }
  }

  const commits = commits_since_last_release
    .trim()
    .split('\n')
    .filter(str => str.length > 0)
    .map(commit => commit.slice(commit.indexOf(' ')));

  const changelog = commits
    .map(c => ` -${c}`)
    .join('\n');

  console.log(`new version changelog:\n${changelog} `);

  const is_prerelease = only_zip
    ? true
    : await question('Is it a pre-release? (y/n) ') === 'y';

  const zip_file_path = `tw3-random-encounters-reworked.zip`;
  const zip = new AdmZip();

  // Transfer the three folders mods/bin/dlc from the release folder to the zip
  // archive.
  const folders_to_transfer = ['mods', 'bin', 'dlc'];
  for (const folder of folders_to_transfer) {
    zip.addLocalFolder(`${__dirname}/../../release/${folder}`, folder);
  }

  zip.writeZip(zip_file_path);

  if (only_zip) {
    return;
  }


  const octokit = new Octokit({
    auth: tokens.github
  });

  let body = '';

  body += `
# Random Encounters Reworked ${new_version_name}

> **📩 Want to get emails or notifications when new releases are created?**
> You can click the \`watch\` button at the top of the page and set a custom rule, or just star the repository to get the news on your homepage.
`;

  if (is_prerelease) {
    body += `
## CHANGELOG (Since last release.)
${changelog}
`;
  }
  else {
    body += `
## CHANGELOG (Since last full release.)
${changelog}
`;
  }

  const create_release_response = await octokit.repos.createRelease({
    owner: 'Aelto',
    repo: 'tw3-random-encounters-reworked',
    name: new_version_name,
    tag_name: new_version_name,
    body: body,
    prerelease: is_prerelease,
  });

  // Start by pushing the zip asset for the release.
  octokit.repos.uploadReleaseAsset({
    owner: 'Aelto',
    repo: 'tw3-random-encounters-reworked',
    release_id: create_release_response.data.id,
    name: zip_file_path,
    label: zip_file_path,
    data: fs.readFileSync(zip_file_path)
  });

  // Then push the install script for this release.
  const install_script_name = 'install-mod.ps1';
  const install_script_path = `${__dirname}/../${install_script_name}`;
  octokit.repos.uploadReleaseAsset({
    owner: 'Aelto',
    repo: 'tw3-random-encounters-reworked',
    release_id: create_release_response.data.id,
    name: install_script_name,
    label: install_script_name,
    data: fs.readFileSync(install_script_path)
  });

  fs.unlinkSync(zip_file_path);
}

main();

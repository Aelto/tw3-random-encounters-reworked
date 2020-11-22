const { execSync } = require('child_process');
const readline = require('readline');
const fs = require('fs');
const tokens = require('./tokens.js');
const axios = require('axios').default;
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
  const latest_release = execSync('git describe --tags --abbrev^=0').toString().trim();
  console.log(`last release is: ${latest_release}`);
  
  const new_version_name = await question('New version name? ');
  const commits_since_last_release = execSync(`git log ${latest_release}..HEAD --oneline`).toString();

  console.log(`commits since last release`);
  console.log(commits_since_last_release);

  if (await question('Confirm you want to continue? (y/n) ') !== 'y') {
    console.log('Cancelling');

    return;
  }

  const commits = commits_since_last_release
    .trim()
    .split('\n')
    .filter(str => str.length > 0)
    .map(commit => commit.slice(commit.indexOf(' ')));

  const changelog = commits
    .map(c => ` - ${c}`)
    .join('\n');

  console.log(`new version changelog:\n${changelog} `);

  const is_prerelease = await question('Is it a pre-release? (y/n) ') === 'y';
  
  const zip_file_path = `${new_version_name}.zip`;
  const zip = new AdmZip();
  zip.addLocalFolder(`${__dirname}/../../release`);
  zip.writeZip(zip_file_path);

  const octokit = new Octokit({
    auth: tokens.github
  });
  
  const create_release_response = await octokit.repos.createRelease({
    owner: 'Aelto',
    repo: 'W3_RandomEncounters_Tweaks',
    name: new_version_name,
    tag_name: new_version_name,
    body: changelog,
    prerelease: is_prerelease,
  });

  octokit.repos.uploadReleaseAsset({
    owner: 'Aelto',
    repo: 'W3_RandomEncounters_Tweaks',
    release_id: create_release_response.data.id,
    name: zip_file_path,
    label: zip_file_path,
    data: fs.readFileSync(zip_file_path)
  });

  fs.unlinkSync(zip_file_path)
}

main();
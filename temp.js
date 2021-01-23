const fs = require('fs');

const content = fs.readFileSync('src/ecosystem/family.ws', 'utf8');
const impacts = (`// CreatureHUMAN` +
  content
  .split(`// CreatureHUMAN`)[1]
  .split('return impacts;')[0])
  .trim()
  .split(';')
  .map(impact => impact.trim())
  .filter(Boolean)
  .map((impact, i) => ({
    type: impact.split('\n')[0].replace('// Creature', '').toLowerCase().trim(),
    call: 'this.ecosystem = ' +
      impact.split('impacts.PushBack(')[1]
      .split('\n')
      .slice(1, -1)
      .join('\n')
      .replace('build()', 'build();')
      // .replace(/      /g, '    ')
      .replace('    (new', ' (new')
  }));

for (const impact of impacts) {
  let { type, call } = impact;

  if (type === 'drownerdlc') {
    type = 'gravier';
  }

  if (type === 'foglet') {
    type = 'fogling';
  }

  const entry = fs.readFileSync(`src/bestiary/entries/${type}.ws`, 'utf8');
  const new_entry = entry.replace('}', '  ' + call + '\n  }');

  console.log(new_entry);
  // console.log(entry);

  fs.writeFileSync(`src/bestiary/entries/${type}.ws`, new_entry, 'utf8');
}

// console.log(impacts)
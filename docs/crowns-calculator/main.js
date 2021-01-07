const fields = {
  base_amount: document.querySelector('#base-amount'),
  size_scaling: document.querySelector('#size-scaling'),
  scaling_offset: document.querySelector('#scaling-offset'),

  results: {
    ghoul: document.querySelector('.form-results #ghoul'),
    werewolf: document.querySelector('.form-results #werewolf'),
    fiend: document.querySelector('.form-results #fiend'),
  }
};

const getCrownDrop = (base, scaling, offset, size) => Math.round(
  base * Math.log(size * offset) * scaling
);

function updateResultBar(dom_element, value) {
  const bar = dom_element.querySelector('.bar');
  const value_element = dom_element.querySelector('.value');

  value_element.textContent = value;
  bar.style.height = `${value}px`;
}

function updateResultsDOM() {
  const base_amount = fields.base_amount.value;
  const size_scaling = fields.size_scaling.value;
  const scaling_offset = fields.scaling_offset.value;

  const crowns = size => getCrownDrop(
    base_amount,
    size_scaling,
    scaling_offset,
    size
  );

  updateResultBar(fields.results.ghoul, crowns(1));
  updateResultBar(fields.results.werewolf, crowns(1.8));
  updateResultBar(fields.results.fiend, crowns(4));
}

fields.base_amount.value = 1;
fields.size_scaling.value = 1;
fields.scaling_offset.value = 1;
updateResultsDOM();

fields.base_amount.addEventListener('change', updateResultsDOM);
fields.size_scaling.addEventListener('change', updateResultsDOM);
fields.scaling_offset.addEventListener('change', updateResultsDOM);
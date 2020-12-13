const fs = require('fs').promises;

fs.readFile('./input', 'utf-8')
  .then(i => i.split('\n'))
  // Group by /^$/
  .then(i => i.reduce((acc, ln) => {
    if (/^$/.test(ln))
      acc.push('');
    else
      acc[acc.length -1] += ln;
    return acc;
  }, ['']))
  .then(i => i.map(g => g.split('')))
  // Unique
  .then(i => i.map(g => g.reduce((acc, q) => {
    if (!acc.includes(q)) acc.push(q);
    return acc;
  }, [])))
  // Count & Sum
  .then(i => i.map(g => g.length))
  .then(i => i.reduce((acc, g) => acc + g))
  .then(console.log);

const fs = require('fs').promises;

fs.readFile('./input', 'utf-8')
  .then(i => i.split('\n'))
  // Group by /^$/
  .then(i => i.reduce((acc, ln) => {
    const n  = acc.length - 1;
    if (/^$/.test(ln))
      acc.push([]);
    else
      acc[n] = acc[n].concat(ln)
    return acc;
  }, [[]]))
  .then(i => i.slice(0, i.length - 1))
  // Common
  .then(i => i.map(g => g.reduce(
    (comm, p) => comm.filter(c => p.includes(c)),
    g[0].split('')
  )))
  // Count & Sum
  .then(i => i.map(g => g.length))
  .then(i => i.reduce((acc, g) => acc + g))
  .then(console.log);

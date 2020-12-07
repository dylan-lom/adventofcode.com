const fs = require('fs').promises;

const isValidPassport = (passport) => {
  if (!passport || typeof passport !== 'object') return false;
  if (typeof passport.byr !== 'string') return false;
  if (typeof passport.iyr !== 'string') return false;
  if (typeof passport.eyr !== 'string') return false;
  if (typeof passport.hgt !== 'string') return false;
  if (typeof passport.hcl !== 'string') return false;
  if (typeof passport.ecl !== 'string') return false;
  if (typeof passport.pid !== 'string') return false;
  //if (typeof passport.cid !== 'string') return false;
  return true;
}

fs.readFile('./input', 'utf-8')
	.then(input => input.split('\n'))
  //.then(input => input.slice(0, 20)) // TESTING
  .then(input => input.reduce((a, v) => {
    if (/$^/.test(v)) a.push('');
    else a[a.length-1] += v + ' ';
    return a;
  }, ['']))
  .then(input => input.map(v => v.slice(0, -1)))
  .then(input => input.map(v => {
    const split = v.split(' ');
    const kv = split.map(p => p.split(':'))
    return kv.reduce((a, [k, v]) => {
      a[k] = v;
      return a;
    }, {});
  }))
  .then(input => input.filter(isValidPassport))
  .then(input => console.log(input.length));

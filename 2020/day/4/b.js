const fs = require('fs').promises;

const isString = (t) => {
  if (typeof t !== 'string') return false;
  return true;
}

const isBetweenInc = (t, l, h) => t >= l && t <= h;

const isValidPassport = (passport) => {
  let i = 0;
  if (!passport || typeof passport !== 'object') return false;

  if (!isString(passport.byr) || !isBetweenInc(passport.byr, 1920, 2002))
    return false;

  if (!isString(passport.iyr) || !isBetweenInc(passport.iyr, 2010, 2020))
    return false;

  if (!isString(passport.eyr) || !isBetweenInc(passport.eyr, 2020, 2030))
    return false;

  if (
    !isString(passport.hgt)
    || !/.*(cm|in)$/.test(passport.hgt)
    || (/.*cm$/.test(passport.hgt) && !isBetweenInc(passport.hgt, '150cm', '193cm'))
    || (/.*in$/.test(passport.hgt) && !isBetweenInc(passport.hgt, '59in', '76in'))
  ) return false;

  if (!isString(passport.hcl) || !/^#[0-9a-f]{6}$/.test(passport.hcl))
    return false;

  if (
    !isString(passport.ecl)
    || !/^(amb|blu|brn|gry|grn|hzl|oth)$/.test(passport.ecl)
  ) return false;

  if (!isString(passport.pid) || !/^\d{9}$/.test(passport.pid))
    return false;

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

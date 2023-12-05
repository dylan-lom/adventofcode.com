const fs = require('fs/promises')

function log(x) {
  console.log(x)
  return x
}

Array.prototype.sum = function() {
  return this.reduce((acc, n) => acc + n, 0)
}

Array.prototype.zip = function(ys) {
  return this.map((x, i) => [ x, ys[i] ])
}

const f = (function() {
  const memo = {}
  return function (cards, i) {
    if (!memo[i]) {
      memo[i] = [...Array(cards[i])]
        .map((_, offset) => offset + i + 1)
        .map(i => f(cards, i))
        .sum() + 1
    }
    return memo[i]
  }
})()

fs.readFile('/dev/stdin')
  .then(b => b.toString())
  .then(s => s.split('\n')) // Game n: ... | ...
  .then(lines => lines.map((line, i) => {
    const [ winners, tickets ] = line.split(':').pop()
      .split('|')
      .map(s => {
        return s.split(' ')
          .map(t => t.trim())
          .filter(t => !!t)
      })
    const winningTickets = tickets?.filter(t => winners.includes(t)) ?? []
    return winningTickets.length
  })) // [ 4, 2, 2, 1, 0, 0 ]
  .then(cards => cards.map((_, i) => f(cards, i)))
  .then(cards => cards.sum())
  .then(log)

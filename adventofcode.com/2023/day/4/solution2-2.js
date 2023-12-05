const fs = require('fs/promises')

function log(x) {
  console.log(x)
  return x
}

function slurpLines(source) {
  return fs.readFile(source)
    .then(s => s.toString())
    .then(s => s.split('\n'))
    .then(ss => ss.filter(s => !!s))
}

function parseNumberString(s) {
  if (!s) return []
  if (typeof s !== 'string') throw new Error('panik so types works' + typeof s)
  return s.split(' ')
    .map(s => Number.parseInt(s))
    .filter(n => !Number.isNaN(n))
}

function parseCards(cards) {
  const ir = cards.map(c => c.split(':').pop()) /* Discard "Game n:" */
    .map(c => c.split('|'))

  if (!Array.isArray(ir)) throw new Error('panik so types works')
  return ir
    .map(([ws, es], i) => {
      const winners = parseNumberString(ws)
      const entries = parseNumberString(es)
      const score = entries.filter(e => winners.includes(e)).length
      return {
        winners, entries, score, i, id: i + 1
      }
    })
}

const getScoreRec = (() => {
  const memo = {}
  const f = function (cards, i) {
    if (!memo[i]) {
      memo[i] = [...Array(cards[i].score)]
        .map((_, offset) => i + offset + 1)
        .map(j => f(cards, j))
        .reduce((a, v) => a + v, 1)
    }

    return memo[i]
  }

  return f
})()


async function solve(source) {
  const lines = await slurpLines(source)
  const cards = parseCards(lines)
  const score = cards
    .map((_, i) => getScoreRec(cards, i))
    .reduce((a, v) => a + v, 0)
  return score
}

solve("/dev/stdin")
  .then(console.log)
const fs = require('fs/promises')
const process = require('process')

fs.readFile('/dev/stdin')
  .then(b => b.toString())
  .then(s => s.split('\n')) // Game n: ... | ...
  .then(lines => lines.map(line => {
    const [ winners, tickets ] = line.split(':').pop()
      .split('|').map(s => s.split(' ').map(t => t.trim()).filter(t => !!t))
    const winningTickets = tickets?.filter(t => winners.includes(t)) ?? []
    console.log(winningTickets)
    return Math.floor(2 ** (winningTickets.length - 1))
  }))
  .then(scores => scores.reduce((acc, x) => acc + x, 0))
  .then(console.log)


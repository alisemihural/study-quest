const monsters = {
  player1: {
    position: {
      x: 280,
      y: 325
    },
    image: {
      src: './img/characterSprite.png'
    },
    frames: {
      max: 4,
      hold: 30
    },
    name: 'player1',
    attacks: [attacks.sword, attacks.fireball]
  },
  player2: {
    position: {
      x: 800,
      y: 100
    },
    image: {
      src: './img/characterSprite.png'
    },
    frames: {
      max: 4,
      hold: 30
    },
    isEnemy: true,
    name: 'player2',
    attacks: [attacks.sword, attacks.fireball]
  }
}

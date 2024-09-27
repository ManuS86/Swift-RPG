import Foundation

struct CombatSystem {
    private let heroes: [Hero]
    private var enemies: [Enemy]
    private let inventory: Inventory
    private let necro: Necromancer?
    private var golem: Golem? = nil
    private let cleric: Cleric?
    private let mage: Mage?
    private let warrior: Warrior?
    private var cursedHero: Hero? = nil
    private var inventoryUsed = false
    
    init(heroes: [Hero], enemies: inout [Enemy], inventory: Inventory) {
        self.heroes = heroes
        self.enemies = enemies
        self.inventory = inventory
        self.necro = enemies[0] as? Necromancer
        self.cleric = heroes[0] as? Cleric
        self.mage = heroes[1] as? Mage
        self.warrior = heroes[2] as? Warrior
    }
    
    func gameLoop() {
        gameIntro()
        
        var nr = 1
        
        sleep(600)
        
        while !gameOverCheck() {
            round(nr)
            nr += 1
        }
        
        gameOver(nr - 1)
        
        sleep(600)
        
        newGame()
    }
    
    private func gameIntro() {
        print("                  ---------------------------------------- RPG FIGHT ----------------------------------------")
        sleep(600)
        print()
        print("The heroes \(cleric!), \(mage!) and \(warrior!) are fighting the boss \(necro!).")
        sleep(400)
        print("                                            Defeat him before it's too late!")
        print()
        print()
    }
    
    private func newGame() {
        let prompt = """
            Do you want to play again?
            [1] Yes
            [2] No
        """
        
        switch select(prompt, 2) {
        case 1:
            sleep(600)
            main()
        case 2:
            exit(0)
        default:
            print("Something went wrong")
        }
    }
    private func gameOver(_ nr: Int) {
        //print("                  ---------------------------------------- GAME OVER ----------------------------------------")
        print(
            "                               ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ " +
            "                              ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗" +
            "                              ██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝" +
            "                              ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗" +
            "                              ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║" +
            "                               ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝"
        )
        
        if (heroes.allSatisfy { hero in hero.hp <= 0 }) {
            sleep(200)
            print("                                                >>> The fight lasted \(nr) rounds <<<")
            print()
            print("                                            >>> All your heroes are dead. You lost! <<<")
        } else {
            sleep(200)
            print()
            print("                                                >>> The fight lasted \(nr) rounds <<<")
            print()
            print("                                            >>> All enemies are defeated. You won! <<<")
        }
}
        
    private func gameOverCheck() -> Bool {
        let isGameOver = enemies.allSatisfy { enemy in enemy.hp <= 0 } || heroes.allSatisfy { hero in hero.hp <= 0 }
        return isGameOver
    }
        
    private func round(_ nr: Int) {
        beginningOfRound(nr)
        
        heroesTurn()
        
        sleep(600)
        
        if necro.hp > 0 {
            necroAttack()
            
            if gameOverCheck() {
                return
            }
        }
        
        sleep(600)
        
        if golem != nil && golem!.hp > 0 {
            golemAttack()
            
            if (gameOverCheck()) {
                return
            }
        }
        
        endOfRound()
    }
        
    private func beginningOfRound(_ nr: Int) {
        print("               ------------------------------------------- ROUND \(nr) -------------------------------------------")
        curseTracker()
        burnTracker()
    }
        
    private func endOfRound() {
        warriorTauntTracker()
        
        golemTauntTracker()
        
        cantHealTracker()
        
        inventoryUsed = false
        print()
    }
        
    private func cantHealTracker() {
        heroes.forEach { hero in
            if hero.cantHeal {
                hero.cantHealTimer -= 1
            }
        }
        
        heroes.forEach { hero in
            if hero.cantHealTimer == 0 {
                hero.cantHeal = false
            }
        }
    }
        
    private func golemTauntTracker() {
        if golem != nil && golem!.isTaunting {
            golem!.tauntTimer -= 1
        }
        
        if golem != nil && golem!.tauntTimer == 0 {
            golem!.isTaunting = false
        }
    }
        
    private func warriorTauntTracker() {
        if warrior.isTaunting {
            warrior.tauntTimer -= 1
        }
        
        if warrior.tauntTimer == 0 {
            warrior.isTaunting = false
        }
    }
    
    private func heroesTurn() {
        print()
        print("Your party of \(heroes.filter { hero in hero.hp > 0 }) attacks \(enemies.filter { enemy in enemy.hp > 0 }).")

        var attackers = heroes.filter { hero in hero.hp > 0 }

        while !gameOverCheck() && attackers.count > 0 {
            let prompt = """
                    \(attackers)
                    Select an attacker [1, 2, ..]:
            """

            sleep(400)

            if attackers.count > 1 {
                switch attackers[select(prompt, attackers.count) - 1] {
                case cleric:
                    clericTurn(attackers)
                case mage:
                    mageTurn(attackers)
                case warrior:
                    warriorTurn(attackers)
                }
            } else {
                switch attackers[0] {
                case cleric:
                    clericTurn(attackers)
                case mage:
                    mageTurn(attackers)
                case warrior:
                    warriorTurn(attackers)
                }
            }
        }
    }

    private func burnTracker() {
        enemies.forEach { enemy in
            if enemy.burning {
                enemy.hp -= 15 * mage.skillMod
                print()
                print("                                         >>> \(enemy.name) is burning and takes \(Int.round(15 * mage.skillMod)) dmg <<<")
                sleep(200)
            }
        }
    }

    private func curseTracker() {
        if cursedHero != nil {
            if cursedHero!.hp <= cursedHero!.maxHp * 0.2 {
                print("\(cursedHero)'s curse ended.")
                cursedHero = nil
            }
            cursedHero!.hp -= cursedHero!.maxHp * 0.1
            print()
            print("                                           >>> \(cursedHero!.name) is cursed and loses \(Int(cursedHero!.maxHp * 0.1)) hp <<<")
            sleep(200)
        }
    }
        
    private func warriorTurn(_ attackers: inout [Hero]) {
            sleep(400)
            warriorAttack()
            attackers.removeAll(warrior)
            print()
        }

    private func mageTurn(_ attackers: inout [Hero]) {
            sleep(400)
            mageAttack()
            attackers.removeAll(mage)
            print()
        }

    private func clericTurn(_ attackers: inout [Hero]) {
            sleep(400)
            clericAttack()
            attackers.removeAll(cleric)
            print()
        }
    
    private func golemAttack() {
        golemLogo()
        switch Int.random(in: 1...3) {
            case 1:
                sleep(600)
                if (warrior!.isTaunting && warrior!.hp > 0) {
                    golem!.smash(warrior!)
                } else {
                    golem!.smash(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                }

            case 2:
                sleep(600)
                golem!.groundSlam(heroes.filter { hero in hero.hp > 0 })

            case 3:
                sleep(600)
                golem!.taunt()
        default:
            print("Something went wrong.")
        }
        print()
    }

    private func golemLogo() {
        print("""
                                                        ⠀⠀⠀⠀⢶⡆⠀⠀⣴⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⢠⣾⣿⣦⣤⣭⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⣰⠏⠀⢹⣻⣭⣭⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⢠⠏⠀⠴⠚⣷⣿⣿⠀⠀⢀⡤⠖⠛⠹⠶⠤⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡏⠀⠀⠀⡼⠉⠉⠁⢀⡴⠋⠀⠀⠤⢄⡀⠀⠀⠈⢢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡇⠀⠀⠀⢧⡀⠀⢠⠎⠀⢠⣤⡞⠒⠲⡌⠃⠀⠀⠀⠱⢤⡀⠀⢀⣀⣀⣀⠀⠀
                                                        ⠀⣧⠀⠀⠀⠀⠙⠲⠏⠀⢀⡀⠙⣇⠀⠀⢘⡶⠆⣤⠤⠔⢲⣯⡖⠉⠀⠀⠈⢧⠀
                                                        ⠀⢺⣦⡀⠀⠂⠀⠀⠀⠀⠀⢠⣄⠼⣗⠒⠋⠀⠀⠹⣄⣠⣿⡋⡀⢠⣤⡆⠀⢸⠀
                                                        ⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠈⠦⣠⠴⣄⢀⣠⣄⣸⠇⠀⣳⣿⣧⠈⢹⠁
                                                        ⠀⠀⠀⠘⠶⡆⠀⠆⢶⣴⠀⢾⠀⠀⠀⠀⠀⠀⠈⠉⡼⡭⣭⡴⠖⠼⠛⣿⣿⠏⠀
                                                        ⠀⠀⠀⠀⠀⢻⠀⠀⠀⠁⠀⠘⡄⠀⣠⢤⣀⡤⡄⢸⣿⣿⠋⠀⠀⠀ ⠀⠙⠁⠀⠀
                                                        ⠀⠀⠀⠀⠀⣏⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⠘⠛⢱⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⣸⠁⠀⠀⠸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠃⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⣷⣄⢠⡀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⢸⠃⠀⡄⠀⠀⠺⠾⠃⠀⠀⠀⠀⠾⠀⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⣀⣀⡴⠋⠀⠛⠁⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠃⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⢸⠁⠀⠀⠀⠀⣤⡄⠀⠀⠀⡴⠛⠲⡄⠀⠀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⡇⠀⠀⠀⣀⠀⠘⠀⠀⣠⠞⠁⠀⠀⢣⠀⠀⠀⠀⠠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠘⠒⠒⠶⠁⠉⠉⠉⠉⠀⠀⠀⠀⡞⠀⠀⠰⠇⠐⠛⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                            ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣼⠁⠀⠀⠀⠀⠀⠀⠈⢳⡄⠀⠀⠀⠀⠀⠀⠀
                                                            ⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠈⠉⠙⠷⠤⠤⠤⠤⠿⠉⠁
                        The \(golem) attacks your party of \(heroes.filter { hero in hero.hp > 0 }).
        """)
        print()
        sleep(400)
    }
    
    private func necroAttack() {
            necroLogo()
            if golem == nil && necro!.hp <= necro!.maxHp * 0.5 {
                sleep(600)
                necro!.summonGolem(enemies)
                golem = enemies[1] as? Golem
            } else {
                switch Int.random(in: 1...5) {
                case 1:
                    sleep(600)
                    necro!.deathWave(heroes.filter { hero in hero.hp > 0 })
                case 2:
                    sleep(600)
                    if (warrior!.isTaunting && warrior!.hp > 0) {
                        necro!.blight(warrior!)
                    } else {
                        necro!.blight(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                    }
                case 3:
                    sleep(600)
                    if warrior!.isTaunting && warrior!.hp > 0 {
                        necro!.vampiricTouch(warrior!)
                    } else {
                        necro!.vampiricTouch(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                    }
                case 4:
                    sleep(600)
                    if warrior!.isTaunting && warrior!.hp > 0 {
                        necro!.grievousWounds(warrior!)
                    } else {
                        necro!.grievousWounds(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                    }
                case 5:
                    sleep(600)
                    if (cursedHero == nil) {
                        if (warrior!.isTaunting && warrior!.hp > 0) {
                            cursedHero = warrior
                            necro!.bestowCurse(cursedHero!)
                        } else {
                            cursedHero = heroes.filter { hero in hero.hp > 0 }.randomElement()
                            necro!.bestowCurse(cursedHero!)
                        }
                    } else {
                        necroAttack()
                    }
                default:
                    print ("Something went wrong.")
                }
            }
        print()
        }

        private func necroLogo() {
            print(
                """
                                                             .                                                      .
                                                           .n                   .                 .                  n.
                                                     .   .dP                  dP                   9b                 9b.    .
                                                    4    qXb         .       dX                     Xb       .        dXp     t
                                                   dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb
                                                   9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
                                                    9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
                                                     `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'
                                                       `9XXXXXXXXXXXP' `9XX'          `98v8P'          `XXP' `9XXXXXXXXXXXP'
                                                           ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                                                                           )b.  .dbo.dP'`v'`9b.odb.  .dX(
                                                                         ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                                                                        dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb
                                                                       dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                                                                       9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP
                                                                        `'      9XXXXXX(   )XXXXXXP      `'
                                                                                 XXXX X.`v'.X XXXX
                                                                                 XP^X'`b   d'`X^XX
                                                                                 X. 9  `   '  P )X
                                                                                 `b  `       '  d'
                                                                                  `             '
                            \(necro) attacks your party of \(heroes.filter { hero in hero.hp > 0 }).
                """
            )
            print()
            sleep(400)
        }
    
    private func warriorAttack() {
        let prompt =
            """
                                 /}
                                //
                               /{     />
                ,_____________///----/{_______________________________________________
              /|=============|/\|---/-/_______________________________________________\
              \|=============|\/|---\-\_______________________________________________/
                '~~~~~~~~~~~~~\\\----\{
                               \{     \>
                                \\
                                 \}
                >>> It's \(warrior)'s turn <<<

            Choose which ability to use:
            [1] Stab (Deal \(Int.round(50 * warrior.skillMod)) dmg to an enemy.)
            [2] Cleave (Deal \(Int.round(30 * warrior.skillMod)) dmg to each enemy.)
            [3] Taunt (Force enemies to target \(warrior.name) for 3 turns.)
            [4] Battle Shout (Increase your tenacity by 10%.)
            [5] Use Item
            """

        switch select(prompt, 5) {
        case 1:
            sleep(400)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if (golem != nil && golem!.isTaunting && golem!.hp > 0) {
                    warrior!.stab(golem!)
                } else {
                    let target = targetEnemy()
                    warrior!.stab(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    warrior!.stab(golem!)
                } else {
                    warrior!.stab(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 2:
            sleep(400)
            warrior!.cleave(enemies.filter { enemy in enemy.hp > 0 })
        case 3:
                sleep(400)
                warrior!.taunt()
        case 4:
                warrior!.battleShout()
        case 5:
                sleep(200)
                if !inventoryUsed {
                    if (!useInventory()) {
                        warriorAttack()
                    } else {
                        inventoryUsed = true
                    }
                } else {
                    print("!You have already used your inventory this round, try something else!")
                    warriorAttack()
                }
            }
        }
    }

    private func mageAttack() {
        let prompt =
            """
                    __...--~~~~~-._   _.-~~~~~--...__
                  //               `V'               \\ 
                 //                 |                 \\ 
                //__...--~~~~~~-._  |  _.-~~~~~~--...__\\ 
               //__.....----~~~~._\ | /_.~~~~----.....__\\
              ====================\\|//====================
                >>> It's \(mage)'s turn <<<

            Choose which ability to use:
            [1] Fireball$reset (Deal \(Int.round(35 * mage.skillMod))-\(Int.round(45 * mage.skillMod)) dmg to each enemy.)
            [2] Lightning Bolt (Deal \(Int.round(50 * mage.skillMod))-\(Int.round(60 * mage.skillMod)) dmg to an enemy.)
            [3] Magic Missiles (Deal \(Int.round(20 * mage.skillMod))-\(Int.round(35 * mage.skillMod)) dmg to a random enemy, then repeat this.)
            [4] Searing Touch (Deal \(Int.round(30 * mage.skillMod)) dmg to an enemy and burn them for an additional \(Int.round(15 * mage.skillMod)) dmg each turn.)
            [5] Use Item
            """

        switch select(prompt, 5) {
        case 1:
            sleep(400)
            mage.fireball(enemies.filter { enemy in enemy.hp > 0 })
        case 2:
            sleep(400)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    mage.lightningBolt(golem!)
                } else {
                    let target = targetEnemy()
                    mage.lightningBolt(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    mage.lightningBolt(golem!)
                } else {
                    mage.lightningBolt(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 3:
            sleep(400)
            mage.magicMissiles(enemies.filter { enemy in enemy.hp > 0 })
        case 4:
            sleep(400)
            if enemies.filter { enemy in enemy.hp > 0 }.count > 1 {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    mage.searingTouch(golem!)
                } else {
                    let target = targetEnemy()
                    mage.searingTouch(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    mage.searingTouch(golem!)
                } else {
                    let target = enemies.filter { enemy in enemy.hp > 0 }[0]
                    mage.searingTouch(target)
                }
            }
        case 5:
            sleep(200)
            if !inventoryUsed {
                if !useInventory() {
                    mageAttack()
                } else {
                    inventoryUsed = true
                }
            } else {
                print("!You have already used your inventory this round, try something else!")
                mageAttack()
            }
        default:
            print("Something went wrong")
        }
    }

    private func clericAttack() {
        let prompt =
            """
                                    .-.
                              ___  (   )  ___
                         ,_.-'   `'-| |-'`   '-._,
                          '.      .-| |-.      .'
                            `~~~~`  |.') `~~~~`
                                   (_.|
                                    |._)
                                    |.')
                                   (_.|
                                    |._)
                                   ('.|
                                    |._)
                                    '-'
                >>> It's \(cleric)'s turn <<<
            
            Choose which ability to use:
            [1] Healing Hands (Heal an ally for \(Int.round(35 * mage.skillMod))-\(Int.round(45 * mage.skillMod)) hp.)
            [2] Healing Wave (Heal each ally for \(Int.round(25 * mage.skillMod))-\(Int.round(35 * mage.skillMod)) hp.)
            [3] Dispel (Dispel an ally's debuff.)
            [4] Cripple (Reduce an enemy's dmg dealt by 10%.)
            [5] Use Item
            """

        switch select(prompt, 5) {
        case 1:
            sleep(400)
            let target = targetHero()
            if (target.cantHeal) {
                print("!The target is grievously wounded and can't be healed currently. Try another action!")
                clericAttack()
            } else {
                cleric.healingHands(target)
            }
        case 2:
            sleep(400)
            cleric.healingWave(heroes.filter { hero in hero.hp > 0 })
        case 3:
            sleep(400)
            let target = targetHero()
            cleric.dispel(target)
            cursedHero = nil
        case 4:
            sleep(400)
            if enemies.filter { enemy in enemy.hp > 0 }.count > 1 {
                if (golem != nil && golem!.isTaunting && golem!.hp > 0) {
                    cleric.cripple(golem!)
                } else {
                    let target = targetEnemy()
                    cleric.cripple(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    cleric.cripple(golem!)
                } else {
                    cleric.cripple(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 5:
            sleep(200)
            if !inventoryUsed {
                if !useInventory() {
                    clericAttack()
                } else {
                    inventoryUsed = true
                }
            } else {
                print("!You have already used your inventory this round, try something else!")
                clericAttack()
            }
        default:
            print("Something went wrong")
        }
    }
        
    private func useInventory() -> Bool {
        let prompt = """
                
                >>> \(inventory) <<<
            [1] Health Potion
            [2] Elixir
            Select an item to use:
        """

        switch select(prompt, 2) {
        case 1:
            sleep(400)
            let target = targetHero()
            return inventory.tryUseHealthPotion(target)
        case 2:
            sleep(400)
            let target = targetHero()
            return inventory.tryUseElixir(target)
        default:
            print("Something went wrong")
        }
        return false
        }
        
    private func targetEnemy() -> Enemy {
        let prompt = """
            
            \(enemies.filter { enemy in enemy.hp > 0 })
            Select a target [1, 2, ..]:
        """
            
        let target = enemies.filter { enemy in enemy.hp > 0 }[select(prompt, enemies.filter { enemy in enemy.hp > 0 }.count) - 1]
        return target
        }
        
    private func targetHero() -> Hero {
        let prompt = """
            
            \(heroes.filter { hero in hero.hp > 0 })
            Select a target [1, 2, ..]:
        """
            
        let target = heroes.filter { hero in hero.hp > 0 }[select(prompt, heroes.filter { hero in hero.hp > 0 }.count) - 1]
        return target
        }
        
    private func select(_ prompt: String, _ max: Int) -> Int {
            print()
            print(prompt)
            while true {
                print("> ")
                if let input = readLine(), let integer = Int(input) {
                    print()
                    if integer >= 1 && integer <= max {
                        return integer
                    }
                    print("!Invalid Input. Please try again!")
                }
            }
        }
    }

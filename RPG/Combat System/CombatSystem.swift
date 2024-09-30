import Foundation

struct CombatSystem {
    private let heroes: [Hero]
    private var enemies: [Enemy]
    private var inventory: Inventory
    private let necro: Necromancer
    private var golem: Golem? = nil
    private let cleric: Cleric
    private let mage: Mage
    private let warrior: Warrior
    private var cursedHero: Hero? = nil
    private var inventoryUsed = false
    
    init(heroes: [Hero], enemies: inout [Enemy], inventory: Inventory) {
        self.heroes = heroes
        self.enemies = enemies
        self.inventory = inventory
        self.necro = enemies[0] as! Necromancer
        self.cleric = heroes[0] as! Cleric
        self.mage = heroes[1] as! Mage
        self.warrior = heroes[2] as! Warrior
    }
    
    mutating func gameLoop() {
        gameIntro()
        var nr = 1
        Thread.sleep(forTimeInterval: 0.6)
        
        while !gameOverCheck() {
            round(nr)
            nr += 1
        }
        
        gameOver(nr - 1)
        Thread.sleep(forTimeInterval: 0.6)
        newGame()
    }
    
    private func gameIntro() {
        print("                  ---------------------------------------- RPG FIGHT ----------------------------------------")
        Thread.sleep(forTimeInterval: 0.6)
        print()
        print("The heroes \(cleric.toString()), \(mage.toString()) and \(warrior.toString()) are fighting the boss \(necro.toString()).")
        Thread.sleep(forTimeInterval: 0.4)
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
        print(
            "                               ██████╗  █████╗ ███╗   ███╗███████╗     ██████╗ ██╗   ██╗███████╗██████╗ " +
            "                              ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔═══██╗██║   ██║██╔════╝██╔══██╗" +
            "                              ██║  ███╗███████║██╔████╔██║█████╗      ██║   ██║██║   ██║█████╗  ██████╔╝" +
            "                              ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗" +
            "                              ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║" +
            "                               ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝     ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝"
        )
        
        if (heroes.allSatisfy { hero in hero.hp <= 0 }) {
            Thread.sleep(forTimeInterval: 0.2)
            print("                                                >>> The fight lasted \(nr) rounds <<<")
            print()
            print("                                            >>> All your heroes are dead. You lost! <<<")
        } else {
            Thread.sleep(forTimeInterval: 0.2)
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
    
    private mutating func round(_ nr: Int) {
        beginningOfRound(nr)
        heroesTurn()
        Thread.sleep(forTimeInterval: 0.6)
    
        if necro.hp > 0 {
            necro.attack(heroes, warrior, &enemies, &golem, &cursedHero)
    
            if gameOverCheck() {
                return
            }
        }
        
        Thread.sleep(forTimeInterval: 0.6)
        
        if golem != nil && golem!.hp > 0 {
            golem!.attack(heroes, warrior, enemies)
            
            if (gameOverCheck()) {
                return
            }
        }
        
        endOfRound()
    }
    
    private mutating func beginningOfRound(_ nr: Int) {
        print("               ------------------------------------------- ROUND \(nr) -------------------------------------------")
        curseTracker(&cursedHero)
        burnTracker(enemies, mage)
    }
    
    private mutating func endOfRound() {
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
    
    private mutating func heroesTurn() {
        print()
        print("Your party of \(heroes.filter { hero in hero.hp > 0 }.map { hero in hero.toString() }) attacks \(enemies.filter { enemy in enemy.hp > 0 }.map { enemy in enemy.toString() }).")
        var attackers = heroes.filter { hero in hero.hp > 0 }
        
        while !gameOverCheck() && attackers.count > 0 {
            let prompt = """
                    \(attackers.map { hero in hero.toString() })
                    Select an attacker [1, 2, ..]:
            """
            Thread.sleep(forTimeInterval: 0.4)
            
            if attackers.count > 1 {
                switch attackers[select(prompt, attackers.count) - 1] {
                case is Cleric:
                    clericTurn(&attackers)
                case is Mage:
                    mageTurn(&attackers)
                case is Warrior:
                    warriorTurn(&attackers)
                default:
                    print("Something went wrong.")
                }
            } else {
                switch attackers[0] {
                case is Cleric:
                    clericTurn(&attackers)
                case is Mage:
                    mageTurn(&attackers)
                case is Warrior:
                    warriorTurn(&attackers)
                default:
                    print("Something went wrong.")
                }
            }
        }
    }
    
    private mutating func warriorTurn(_ attackers: inout [Hero]) {
        Thread.sleep(forTimeInterval: 0.4)
        warrior.attack(heroes, enemies, golem, &inventory, &inventoryUsed)
        attackers.removeAll { hero in hero is Warrior }
        print()
    }
    
    private mutating func mageTurn(_ attackers: inout [Hero]) {
        Thread.sleep(forTimeInterval: 0.4)
        mage.attack(heroes, enemies, golem, &inventory, &inventoryUsed)
        attackers.removeAll { hero in hero is Mage }
        print()
    }
    
    private mutating func clericTurn(_ attackers: inout [Hero]) {
        Thread.sleep(forTimeInterval: 0.4)
        cleric.attack(heroes, enemies, golem, &inventory, &inventoryUsed, &cursedHero)
        attackers.removeAll { hero in hero is Cleric }
        print()
    }
}

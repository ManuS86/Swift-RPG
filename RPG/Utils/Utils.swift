import Foundation

func select(_ prompt: String, _ max: Int) -> Int {
    print()
    print(prompt)
    while true {
        print("> ", terminator: "")
        if let input = readLine(), let integer = Int(input) {
            print()
            if integer >= 1 && integer <= max {
                return integer
            }
            print("!Invalid Input. Please try again!")
        }
    }
}

func targetEnemy(_ enemies: [Enemy]) -> Enemy {
    let prompt = """
        
        \(enemies.filter { enemy in enemy.hp > 0 }.map { enemy in enemy.toString() })
        Select a target [1, 2, ..]:
    """
    
    let target = enemies.filter { enemy in enemy.hp > 0 }[select(prompt, enemies.filter { enemy in enemy.hp > 0 }.count) - 1]
    return target
}

func targetHero(_ heroes: [Hero]) -> Hero {
    let prompt = """
        
        \(heroes.filter { hero in hero.hp > 0 }.map { hero in hero.toString() })
        Select a target [1, 2, ..]:
    """
    
    let target = heroes.filter { hero in hero.hp > 0 }[select(prompt, heroes.filter { hero in hero.hp > 0 }.count) - 1]
    return target
}

func burnTracker(_ enemies: [Enemy], _ mage: Mage) {
    enemies.forEach { enemy in
        if enemy.burning {
            enemy.hp -= 15 * mage.abilityMod
            print()
            print("                                         >>> \(enemy.name) is burning and takes \(Int(15 * mage.abilityMod)) dmg <<<")
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
}

func curseTracker(_ cursedHero: inout Hero?) {
    if cursedHero != nil {
        if cursedHero!.hp <= cursedHero!.maxHp * 0.2 {
            print("\(cursedHero!)'s curse ended.")
            cursedHero = nil
        }
        cursedHero!.hp -= cursedHero!.maxHp * 0.1
        print()
        print("                                           >>> \(cursedHero!.name) is cursed and loses \(Int(cursedHero!.maxHp * 0.1)) hp <<<")
        Thread.sleep(forTimeInterval: 0.2)
    }
}


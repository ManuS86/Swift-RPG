import Foundation

class Cleric: Hero, HolyUser {
    
    init() {
        super.init(name: "Elara", maxHp: 90.0)
    }
    
    func healingHands(_ target: Hero) {
        let healAmnt = Double.random(in: 35...45) * abilityMod
        let preHealHp = target.hp
        target.heal(healAmnt)
        let amntHealed = hp - preHealHp
        
        print("    >>> \(name) heals \(target.name == name ? "herself" : target.name) for \(Int(amntHealed)) hp with Healing Hands <<<")
        sleep(200)
        print("               >>> \(target.name) now has \(Int(target.hp)) hp <<<")
    }
    
    func healingWave(_ targets: [Hero]) {
        let healAmnt = Double.random(in: 25...35) * abilityMod
        let preHealHp = targets.map { target in target.hp }
        targets.forEach { target in if !target.cantHeal {target.heal(healAmnt)} }
        let postHealHp = targets.map { hp in hp.hp }
        let amntsHealed = zip(preHealHp, postHealHp).map { preHealhp, postHealHp in Int(postHealHp - preHealhp) }
        
        print("   >>> \(name) heals all allies \(targets.map { target in target.name }) for \(amntsHealed) hp with Healing Wave <<<")
        sleep(200)
        print("                   >>>\(targets.map { target in target.name }) now have \(targets.map { target in Int(target.hp) }) hp <<<")
    }
    
    func dispel(_ target: Hero) {
        target.cantHeal = false
        target.cantHealTimer = 0
        
        print("    >>> \(name) removed all of \(target.name == name ? "her" : "\(target.name)'s") negative effects with Dispel <<<")
    }
    
    func cripple(_ target: Enemy) {
        if (target.dmgMod > 0.1) {
            target.dmgMod -= 0.1
        }
        
        print("    >>> \(name) reduced \(target.name)'s dmg by 10% with Cripple <<<")
    }
    
    func attack(_ heroes: [Hero], _ enemies: [Enemy], _ golem: Golem?, _ inventory: inout Inventory, _ inventoryUsed: inout Bool, _ cursedHero: inout Hero?) {
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
                >>> It's \(toString())'s turn <<<
            
            Choose which ability to use:
            [1] Healing Hands (Heal an ally for \(Int(35 * abilityMod))-\(Int(45 * abilityMod)) hp.)
            [2] Healing Wave (Heal each ally for \(Int(25 * abilityMod))-\(Int(35 * abilityMod)) hp.)
            [3] Dispel (Dispel an ally's debuff.)
            [4] Cripple (Reduce an enemy's dmg dealt by 10%.)
            [5] Use Item
            """
        
        switch select(prompt, 5) {
        case 1:
            Thread.sleep(forTimeInterval: 0.4)
            let target = targetHero(heroes)
            if (target.cantHeal) {
                print("!The target is grievously wounded and can't be healed currently. Try another action!")
                attack(heroes, enemies, golem, &inventory, &inventoryUsed, &cursedHero)
            } else {
                healingHands(target)
            }
        case 2:
            Thread.sleep(forTimeInterval: 0.4)
            healingWave(heroes.filter { hero in hero.hp > 0 })
        case 3:
            Thread.sleep(forTimeInterval: 0.4)
            let target = targetHero(heroes)
            dispel(target)
            cursedHero = nil
        case 4:
            Thread.sleep(forTimeInterval: 0.4)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if (golem != nil && golem!.isTaunting && golem!.hp > 0) {
                    cripple(golem!)
                } else {
                    let target = targetEnemy(enemies)
                    cripple(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    cripple(golem!)
                } else {
                    cripple(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 5:
            Thread.sleep(forTimeInterval: 0.2)
            if !inventoryUsed {
                if !inventory.use(heroes) {
                    attack(heroes, enemies, golem, &inventory, &inventoryUsed, &cursedHero)
                } else {
                    inventoryUsed = true
                }
            } else {
                print("!You have already used your inventory this round, try something else!")
                attack(heroes, enemies, golem, &inventory, &inventoryUsed, &cursedHero)
            }
        default:
            print("Something went wrong")
        }
    }
}


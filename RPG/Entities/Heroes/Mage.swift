import Foundation

class Mage: Hero, MagicUser {
    
    init() {
        super.init(name: "Keros", maxHp: 80.0)
    }
    
    func fireball(_ targets: [Enemy]) {
        targets.forEach { target in target.hp -= Double.random(in: 35...45) * abilityMod }
        
        print("    >>> \(name) deals \(Int(30 * abilityMod)) dmg to each enemy with Fireball <<<")
        print("            >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
              
        deathCheckAoE(targets)
    }
    
    func lightningBolt(_ target: Enemy) {
        let dmgAmnt = Double.random(in: 50...60) * abilityMod
        target.hp -= dmgAmnt
        
        print("    >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Lightning Bolt <<<")
        sleep(200)
        print("               >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func magicMissiles(_ targets: [Enemy]) {
        let dmgAmnt1 = Double.random(in: 20...35) * abilityMod
        let target1 = targets.filter { target in target.hp > 0 }.randomElement()
        target1?.hp -= dmgAmnt1
        let dmgAmnt2 = Double.random(in: 20...35) * abilityMod
        var target2: Enemy? = nil
        if (targets.contains { target in target.hp > 0 }) {
            target2 = targets.filter { target in target.hp > 0 }.randomElement()
            target2?.hp -= dmgAmnt2
        }
        
        print("    >>> \(name) deals \(Int(dmgAmnt1)) dmg to \(target1!.name) \(target2 != nil ? "and \(dmgAmnt2) dmg to \(target2!.name)" : "") with Magic Missiles <<<")
        sleep(200)
        print("                >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
              
        deathCheckAoE(targets)
    }
    
    func searingTouch(_ target: Enemy) {
        if (!target.burning) {
            let dmgAmnt = 30 * abilityMod
            target.hp -= dmgAmnt
            target.burning = true
            
            print("    >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Searing Touch and sets them on fire <<<")
            sleep(200)
            print("              >>> \(target.name) now has \(Int(target.hp)) hp <<<")
            
            deathCheck(target)
        }
    }
    
    func attack(_ heroes: [Hero], _ enemies: [Enemy], _ golem: Golem?, _ inventory: inout Inventory, _ inventoryUsed: inout Bool) {
        let prompt =
            """
            
                     ,..........   ..........,
                 ,..,'          '.'          ',..,
                ,' ,'            :            ', ',
               ,' ,'             :             ', ',
              ,' ,'              :              ', ',
             ,' ,'............., : ,.............', ',
            ,'  '............   '.'   ............'  ',
             '''''''''''''''''';''';''''''''''''''''''
                                '''
            
                >>> It's \(toString)'s turn <<<
            
            Choose which ability to use:
            [1] Fireball$reset (Deal \(Int(35 * abilityMod))-\(Int(45 * abilityMod)) dmg to each enemy.)
            [2] Lightning Bolt (Deal \(Int(50 * abilityMod))-\(Int(60 * abilityMod)) dmg to an enemy.)
            [3] Magic Missiles (Deal \(Int(20 * abilityMod))-\(Int(35 * abilityMod)) dmg to a random enemy, then repeat this.)
            [4] Searing Touch (Deal \(Int(30 * abilityMod)) dmg to an enemy and burn them for an additional \(Int(15 * abilityMod)) dmg each turn.)
            [5] Use Item
            """
        
        switch select(prompt, 5) {
        case 1:
            Thread.sleep(forTimeInterval: 0.4)
            fireball(enemies.filter { enemy in enemy.hp > 0 })
        case 2:
            Thread.sleep(forTimeInterval: 0.4)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    lightningBolt(golem!)
                } else {
                    let target = targetEnemy(enemies)
                    lightningBolt(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    lightningBolt(golem!)
                } else {
                    lightningBolt(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 3:
            Thread.sleep(forTimeInterval: 0.4)
            magicMissiles(enemies.filter { enemy in enemy.hp > 0 })
        case 4:
            Thread.sleep(forTimeInterval: 0.4)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    searingTouch(golem!)
                } else {
                    let target = targetEnemy(enemies)
                    searingTouch(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    searingTouch(golem!)
                } else {
                    let target = enemies.filter { enemy in enemy.hp > 0 }[0]
                    searingTouch(target)
                }
            }
        case 5:
            Thread.sleep(forTimeInterval: 0.2)
            if !inventoryUsed {
                if !inventory.use(heroes) {
                    attack(heroes, enemies, golem, &inventory, &inventoryUsed)
                } else {
                    inventoryUsed = true
                }
            } else {
                print("!You have already used your inventory this round, try something else!")
                attack(heroes, enemies, golem, &inventory, &inventoryUsed)
            }
        default:
            print("Something went wrong")
        }
    }
}


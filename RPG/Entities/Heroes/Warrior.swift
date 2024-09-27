import Foundation

class Warrior: Hero {
    var isTaunting = true
    var tauntTimer = 0
    
    init() {
        super.init(name: "Haarkon", maxHp: 100.0)
    }
    
    func stab(_ target: Enemy) {
        let dmgAmnt = 50 * skillMod
        target.hp -= dmgAmnt
        
        print("    >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Stab <<<")
        
        sleep(200)
        
        print("             >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func cleave(_ targets: [Enemy]) {
        targets.forEach { target in target.hp -= 30 * skillMod }
        
        print("    >>> \(name) deals \(Int(30 * skillMod)) dmg to each enemy with Cleave <<<")
        
        sleep(200)
        
        print("              >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
        
        deathCheckAoE(targets)
    }
    
    func taunt() {
        isTaunting = true
        tauntTimer = 3
        
        print("    >>> \(name) is taunting the enemies, forcing them to attack him for the next 3 turns <<<")
    }
    
    func battleShout() {
        tenacity += 0.1
        
        print("    >>> \(name) made himself more tenacious (x10% dmg reduction) with Battle Shout <<<")
    }
    
    func attack(_ heroes: [Hero], _ warrior: Warrior, _ enemies: [Enemy], _ golem: Golem?, _ inventory: inout Inventory, _ inventoryUsed: inout Bool) {
        let prompt =
            """

                >>> It's \(warrior.toString)'s turn <<<
            
            Choose which ability to use:
            [1] Stab (Deal \(Int(50 * warrior.skillMod)) dmg to an enemy.)
            [2] Cleave (Deal \(Int(30 * warrior.skillMod)) dmg to each enemy.)
            [3] Taunt (Force enemies to target \(warrior.name) for 3 turns.)
            [4] Battle Shout (Increase your tenacity by 10%.)
            [5] Use Item
            """
        let selection = select(prompt, 5)
        
        switch selection {
        case 1:
            Thread.sleep(forTimeInterval: 0.4)
            if (enemies.filter { enemy in enemy.hp > 0 }.count > 1) {
                if (golem != nil && golem!.isTaunting && golem!.hp > 0) {
                    warrior.stab(golem!)
                } else {
                    let target = targetEnemy(enemies)
                    warrior.stab(target)
                }
            } else {
                if golem != nil && golem!.isTaunting && golem!.hp > 0 {
                    warrior.stab(golem!)
                } else {
                    warrior.stab(enemies.filter { enemy in enemy.hp > 0 }[0])
                }
            }
        case 2:
            Thread.sleep(forTimeInterval: 0.4)
            warrior.cleave(enemies.filter { enemy in enemy.hp > 0 })
        case 3:
            Thread.sleep(forTimeInterval: 0.4)
            warrior.taunt()
        case 4:
            warrior.battleShout()
        case 5:
            Thread.sleep(forTimeInterval: 0.2)
            if !inventoryUsed {
                let isInventoryUsable = inventory.use(&inventory, heroes)
                if (!isInventoryUsable) {
                    attack(heroes, warrior, enemies, golem, &inventory, &inventoryUsed)
                } else {
                    inventoryUsed = true
                }
            } else {
                print("!You have already used your inventory this round, try something else!")
                attack(heroes, warrior, enemies, golem, &inventory, &inventoryUsed)
            }
        default:
            print ("Something went wrong.")
        }
    }
}

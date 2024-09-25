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
    
}

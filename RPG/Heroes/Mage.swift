import Foundation

class Mage: Hero {
    
    init() {
        super.init(name: "Keros", maxHp: 80.0)
    }
    
    func fireball(_ targets: [Enemy]) {
        targets.forEach { target in target.hp -= (35...45).random() * skillMod }
        
        print("    >>> \(name) deals \(Int(30 * skillMod)) dmg to each enemy with Fireball <<<")
        print("            >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
              
        deathCheckAoE(targets)
    }
    
    func lightningBolt(_ target: Enemy) {
        let dmgAmnt = (50...60).random() * skillMod
        target.hp -= dmgAmnt
        
        print("    >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Lightning Bolt <<<")
        
        sleep(200)
        
        print("               >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func magicMissiles(_ targets: [Enemy]) {
        let dmgAmnt1 = (20...35).random() * skillMod
        let target1 = targets.filter { target in target.hp > 0 }.random()
        target1.hp -= dmgAmnt1
        let dmgAmnt2 = (20...35).random() * skillMod
        var target2: Enemy? = nil
        if (targets.contains { target in target.hp > 0 }) {
            target2 = targets.filter { target in target.hp > 0 }.random()
            target2.hp -= dmgAmnt2
        }
        print("    >>> \(name) deals \(Int(dmgAmnt1)) dmg to \(target1.name) \(target2 != nil ? "and \(dmgAmnt2) dmg to \(target2.name)" : "") with Magic Missiles <<<")
              
        sleep(200)
              
        print("                >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
              
        deathCheckAoE(targets)
    }
    
    func searingTouch(_ target: Enemy) {
        if (!target.burning) {
            let dmgAmnt = 30 * skillMod
            target.hp -= dmgAmnt
            target.burning = true
            
            print("    >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Searing Touch and sets them on fire <<<")
            
            sleep(200)
            
            print("              >>> \(target.name) now has \(Int(target.hp)) hp <<<")
            
            deathCheck(target)
        }
    }
}


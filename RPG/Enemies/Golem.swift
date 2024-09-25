import Foundation

class Golem: Enemy {
    var isTaunting = false
    var tauntTimer = 0
    
    init() {
        super.init(name: "Golem", maxHp: 250.0)
    }
    
    func smash(_ target: Hero) {
        let dmgAmnt = 50 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        
        print("                         >>> \(name) deals \(dmgAmnt) dmg to \(target.name) with Smash <<<")
        
        sleep(200)
        
        print("                                 >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func groundSlam(_ targets: [Hero]) {
        targets.forEach { target in target.hp -= 30 * dmgMod / target.tenacity }
        
        print("                 >>> \(name) deals \(targets.map { target in Int(20 * dmgMod / target.tenacity) }) dmg to the heroes \(targets.map { target in target.name }) with Ground Slam <<<")
        
        sleep(200)
        
        print("                                >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
        
        deathCheckAoE(targets)
    }
    
    func taunt() {
        isTaunting = true
        tauntTimer = 3
        
        print("           >>> The \(name) is taunting the heroes, forcing them to attack him for the next 2 turns <<<")
    }
}


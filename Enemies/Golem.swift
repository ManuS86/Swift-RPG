class Golem(name = "Golem", maxHp = 250.0): Enemy(name, maxHp) {
    var isTaunting = false
    var tauntTimer = 0
    
    func smash(_ target: Hero) {
        let dmgAmnt = Int(50 * dmgMod / target.tenacity)
        target.hp -= dmgAmnt
        
        print(">>> \(name) deals \(dmgAmnt) dmg to \(target.name) with Smash <<<")
        
        Thread.sleep(forTimeInterval: 200)
        
        print(">>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func groundSlam(_ targets: [Hero]) {
        targets.forEach { it.hp -= 30 * dmgMod / it.tenacity }
        
        print(">>> \(bold)\(name) \(normal)deals \(targets.map { Int(20 * dmgMod / it.tenacity) }) dmg to the heroes \(bold)\(targets.map { target.name }) \(normal)with \(bold)Ground Slam \(normal)<<<")
        
        Thread.sleep(200)
        
        print(">>> \(bold)\(targets.map { target.name })\(normal) now \(
                if (targets.size == 1) {
                    "has"
                } else {
                    "have"
                }) \(targets.map { Int(target.hp) }) hp <<<")
        
        deathCheckAoe(targets)
    }
    
    func taunt() {
        isTaunting = true
        tauntTimer = 3
        
        print(">>> The \(bold)\(name) \(normal)is \(bold)taunting \(normal)the \(bold)heroes\(normal), forcing them to attack \(bold)him \(normal)for the next 2 turns <<<")
    }
}


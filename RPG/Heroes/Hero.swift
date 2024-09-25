class Hero {
    var name: String
    let maxHp: Double
    var hp: Int
    var skillMod = 1.0
    var tenacity = 1.0
    var cantHeal = false
    var cantHealTimer = 0
    
    init(name: String, maxHp: Double) {
        self.name = name
        self.maxHp = maxHp
        self.hp = maxHp
    }

    
    func heal(_ healAmount: Double) {
        hp = min(hp + healAmount, maxHp)
    }
    
    func deathCheck(_ target: Enemy) {
        if target.hp <= 0 {
            print(">>> \(target.name) is dead <<<")
        }
    }
    
    func deathCheckAoE(_ targets: inout [Enemy]) {
        if targets.any { target.hp <= 0 } {
            print(">>> \(targets.filter { target.hp <= 0 }.map { target.name }) \(if targets.filter { target.hp <= 0 }.size == 1 {
                "is"
            } else {
                "are"
            }) dead <<<")
        }
    }
}


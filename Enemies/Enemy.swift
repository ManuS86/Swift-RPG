class Enemy {
    var name: String
    let maxHp: Double
    
    init(name: String, maxHp: Double) {
        self.name = name
        self.maxHp = maxHp
    }
    
    var hp = maxHp
    var dmgMod = 1.0
    var burning = false
    
    func heal(_ healAmount: Double) {
        hp = min(hp + healAmount, maxHp)
    }
    
    func deathCheck(_ target: Hero) {
        if target.hp <= 0 {
            print(">>> \(target.name) is dead <<<")
        }
    }
    
    func deathCheckAoE(_ targets: [Hero]) {
        if targets.any { target.hp <= 0 } {
            print(">>> \(
            targets.filter { target.hp <= 0 }.map { target.name }
            ) \(
            if targets.filter { target.hp <= 0 }.size == 1 {
                "is"
            } else {
                "are"
            }) dead <<<")
        }
    }
}

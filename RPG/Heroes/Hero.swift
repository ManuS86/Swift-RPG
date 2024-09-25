class Hero {
    var name: String
    var maxHp: Double
    var hp: Double
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
    
    func deathCheckAoE(_ targets: [Enemy]) {
        if (targets.contains { target in target.hp <= 0 }) {
            print(">>> \(targets.filter { target in target.hp <= 0 }.map { target in target.name }) \(targets.filter { target in target.hp <= 0 }.count == 1 ? "is" : "are") dead <<<")}
    }
}

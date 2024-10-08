class Hero: Entity {
    var abilityMod = 1.0
    var tenacity = 1.0
    var cantHeal = false
    var cantHealTimer = 0
    
    override init(name: String, maxHp: Double) {
        super.init(name: name, maxHp: maxHp)
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
    
    func toString() -> String {
        return "\(name) (\(Int(hp)) hp)"
    }
}

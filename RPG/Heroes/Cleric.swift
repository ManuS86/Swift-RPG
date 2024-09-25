import Foundation

class Cleric: Hero {
    
    init() {
        super.init(name: "Elara", maxHp: 90.0)
    }
    
    func healingHands(_ target: Hero) {
        let healAmnt = (35...45).randomElement() * skillMod
        let preHealHp = target.hp
        target.heal(healAmnt)
        let amntHealed = hp - preHealHp
        
        print("    >>> \(name) heals \(target.name == name ? "herself" : target.name) for \(Int(amntHealed)) hp with Healing Hands <<<")

        sleep(200)

        print("               >>> \(target.name) now has \(Int(target.hp)) hp <<<")
    }
    
    func healingWave(_ targets: [Hero]) {
        let healAmnt = (25...35).randomElement() * skillMod
        let preHealHp = targets.map { target in target.hp }
        targets.forEach { target in if !target.cantHeal {target.heal(healAmnt)} }
        let postHealHp = targets.map { hp in hp.hp }
        let amntsHealed = (preHealHp zip postHealHp).map { hp in Int(hp.second - hp.first) }
        print("   >>> \(name) heals all allies \(targets.map { target in target.name }) for \(amntsHealed) hp with Healing Wave <<<")
        
        sleep(200)
        
        print("                   >>>\(targets.map { target in target.name }) now have \(targets.map { target in Int(target.hp) }) hp <<<")
    }
    
    func dispel(_ target: Hero) {
        target.cantHeal = false
        target.cantHealTimer = 0
        
        print("    >>> \(name) removed all of \(target.name == name ? "her" : "\(target.name)'s") negative effects with Dispel <<<")
    }
    
    func cripple(_ target: Enemy) {
        if (target.dmgMod > 0.1) {
            target.dmgMod -= 0.1
        }
        
        print("    >>> \(name) reduced \(target.name)'s dmg by 10% with Cripple <<<")
    }
}


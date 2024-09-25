import Foundation

class Necromancer: Enemy {
    
    override init(name: String, maxHp: Double) {
        self.name = "Archeron"
        self.maxHp = 500.0
        self.hp = maxHp
    }
    
    func deathwave(_ targets: [Hero]) {
        targets.forEach { target in target.hp -= 40 * dmgMod / target.tenacity }
        
        print("                     >>> \(name) deal \(Int(40 * dmgMod)) dmg to the heroes \(targets.map { target in target.name }) with Death Wave <<<")
        
        sleep(200)
        
        print("                                  >>> \(targets.map { target in target.name }) now \(if targets.count == 1 {"has"} else {"have"}) \(targets.map { target in Int(target.hp) }) hp <<<")
        
        deathCheckAoE(targets)
    }
    
    func blight(_ target: Hero) {
        let dmgAmnt = 60 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        
        print("                                     >>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Blight <<<")
        
        sleep(200)
        
        print("                                                >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func vampiricTouch(_ target: Hero) {
        let dmgAmnt = 30 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        let preHealHp = hp
        heal(dmgAmnt)
        let amntHealed = hp - preHealHp
        
        print("                      >>> \(name) drains \(target.name) for \(Int(dmgAmnt)) dmg and heals himself for \(Int(amntHealed)) hp with Vampiric Touch <<<")
        
        sleep(200)
        
        print("                                      >>> \(name) now has \(hp) hp and \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func grievousWounds(_ target: Hero) {
        let dmgAmnt = 40 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        target.cantHeal = true
        target.cantHealTimer = 2
        
        print("                 >>> \(name) wounds \(target.name) can't heal for 1 turn and deals  \(Int(dmgAmnt)) dmg with Grievous Wounds <<<")
        
        sleep(200)
        
        print("                                                >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        
        deathCheck(target)
    }
    
    func bestowCurse(_ target: Hero) {
        if target.hp > (target.maxHp * 0.2) {
            target.hp -= target.hp * 0.1
            
            print("              >>> \(name) casts Bestow Curse on \(target.name) and they lose 10% \(Int(target.maxHp * 0.1)) of their health <<<")
            
            sleep(200)
            
            print("                                                >>> \(target.name) now has \(Int(target.hp)) hp <<<")
        }
    }
    
    func summonGolem(_ enemies: [Enemy]) {
        let golem = Golem()
        enemies.append(golem)
        
        print("                                      >>> \(name) has summones a \(golem) <<<")
    }
}

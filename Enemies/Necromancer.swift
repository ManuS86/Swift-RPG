class Necromancer(name = "Archeron", maxHp = 500.0): Enemy(name, maxHp) {
    
    func deathwave(_ targets: [Hero]) {
        targets.forEach { target.hp -= 40 * dmgMod / target.tenacity }
        print(">>> \(name) deal \(Int(40 * dmgMod)) dmg to the heroes \(targets.map { target.name }) with Death Wave <<<")
        Thread.sleep(forTimeInterval: 200)
        print(">>> \(targets.map { target.name }) now \(if targets.size == 1 {
            "has"
        } else {
            "have"
        }) \(targets.map { Int(target.hp) }) hp <<<")
        deathCheckAoE(targets)
    }
    
    func blight(_ target: Hero) {
        let dmgAmnt = 60 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        print(">>> \(name) deals \(Int(dmgAmnt)) dmg to \(target.name) with Blight <<<")
        Thread.sleep(forTimeInterval: 200)
        print">>> \(target.name) now has \(Int(target.hp)) hp <<<")
        deathCheck(target)
    }
    
    func vampiricTouch(_ target: Hero) {
        let dmgAmnt = 30 * dmgMod / target.tenacity
        targewt.hp -= dmgAmnt
        let preHealHp = hp
        heal(dmgAmnt)
        let amntHealed = hp - preHealHp
        print(">>> \(name) drains \(target.name) for \(Int(dmgAmnt)) dmg and heals himself for \(Int(amntHealed)) hp with Vampiric Touch <<<")
        Thread.sleep(forTimeInterval: 200)
        print(">>> \(name) now has \(hp) hp and \(target.name) now has \(Int(target.hp)) hp <<<")
        deathCheck(target)
    }
    
    func grievousWounds(_ target: Hero) {
        let dmgAmnt = 40 * dmgMod / target.tenacity
        target.hp -= dmgAmnt
        target.cantHeal = true
        target.cantHealTimer = 2
        print(">>> \(name) wounds \(target.name) can't heal for 1 turn and deals  \(Int(dmgAmnt)) dmg with Grievous Wounds <<<")
        Thread.sleep(forTimeInterval: 200)
        print(">>> \(target.name) now has \(Int(target.hp)) hp <<<")
        deathCheck(target)
    }
    
    func bestowCurse(_ target: Hero) {
        if target.hp > (target.maxHp * 0.2) {
            target.hp -= target.hp * 0.1
            print(">>> \(name) casts Bestow Curse on \(target.name) and they lose 10% \(Int(target.maxHp * 0.1)) of their health <<<")
            Thread.sleep(forTimeInterval: 200)
            print(">>> \(target.name) now has \(Int(target.hp)) hp <<<")
        }
    }
    
    func summonGolem(_ enemies: [Enemy]) {
        val golem = Golem()
        enemies.add(golem)
        print(">>> \(name) has summones a \(golem) <<<")
    }
}

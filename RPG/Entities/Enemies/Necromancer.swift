import Foundation

class Necromancer: Enemy {
    
    init() {
        super.init(name: "Archeron", maxHp: 500.0)
    }
    
    func deathWave(_ targets: [Hero]) {
        targets.forEach { target in target.hp -= 40 * dmgMod / target.tenacity }
        
        print("                     >>> \(name) deal \(Int(40 * dmgMod)) dmg to the heroes \(targets.map { target in target.name }) with Death Wave <<<")
        sleep(200)
        print("                                  >>> \(targets.map { target in target.name }) now \(targets.count == 1 ? "has" : "have") \(targets.map { target in Int(target.hp) }) hp <<<")
        
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
    
    func summonGolem(_ enemies: inout [Enemy]) {
        let golem = Golem()
        enemies.append(golem)
        
        print("                                      >>> \(name) has summones a \(golem.toString()) <<<")
    }
    
    func attack(_ heroes: [Hero], _ warrior: Warrior, _ enemies: inout [Enemy], _ golem: inout Golem?, _ cursedHero: inout Hero?) {
        necroLogo(heroes)
        if golem == nil && hp <= maxHp * 0.5 {
            Thread.sleep(forTimeInterval: 0.6)
            summonGolem(&enemies)
            golem = enemies[1] as? Golem
        } else {
            switch Int.random(in: 1...5) {
            case 1:
                Thread.sleep(forTimeInterval: 0.6)
                deathWave(heroes.filter { hero in hero.hp > 0 })
            case 2:
                Thread.sleep(forTimeInterval: 0.6)
                if (warrior.isTaunting && warrior.hp > 0) {
                    blight(warrior)
                } else {
                    blight(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                }
            case 3:
                Thread.sleep(forTimeInterval: 0.6)
                if warrior.isTaunting && warrior.hp > 0 {
                    vampiricTouch(warrior)
                } else {
                    vampiricTouch(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                }
            case 4:
                Thread.sleep(forTimeInterval: 0.6)
                if warrior.isTaunting && warrior.hp > 0 {
                    grievousWounds(warrior)
                } else {
                    grievousWounds(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
                }
            case 5:
                Thread.sleep(forTimeInterval: 0.6)
                guard cursedHero == nil else {
                    if (warrior.isTaunting && warrior.hp > 0) {
                        cursedHero = warrior
                        bestowCurse(cursedHero!)
                    } else {
                        cursedHero = heroes.filter { hero in hero.hp > 0 }.randomElement()
                        bestowCurse(cursedHero!)
                    }
                    return
                }
                attack(heroes, warrior, &enemies, &golem, &cursedHero)
            default:
                print ("Something went wrong.")
            }
        }
        print()
    }
    
    private func necroLogo(_ heroes: [Hero]) {
        print(
                """
                                                             .                                                      .
                                                           .n                   .                 .                  n.
                                                     .   .dP                  dP                   9b                 9b.    .
                                                    4    qXb         .       dX                     Xb       .        dXp     t
                                                   dX.    9Xb      .dXb    __                         __    dXb.     dXP     .Xb
                                                   9XXb._       _.dXXXXb dXXXXbo.                 .odXXXXb dXXXXb._       _.dXXP
                                                    9XXXXXXXXXXXXXXXXXXXVXXXXXXXXOo.           .oOXXXXXXXXVXXXXXXXXXXXXXXXXXXXP
                                                     `9XXXXXXXXXXXXXXXXXXXXX'~   ~`OOO8b   d8OOO'~   ~`XXXXXXXXXXXXXXXXXXXXXP'
                                                       `9XXXXXXXXXXXP' `9XX'          `98v8P'          `XXP' `9XXXXXXXXXXXP'
                                                           ~~~~~~~       9X.          .db|db.          .XP       ~~~~~~~
                                                                           )b.  .dbo.dP'`v'`9b.odb.  .dX(
                                                                         ,dXXXXXXXXXXXb     dXXXXXXXXXXXb.
                                                                        dXXXXXXXXXXXP'   .   `9XXXXXXXXXXXb
                                                                       dXXXXXXXXXXXXb   d|b   dXXXXXXXXXXXXb
                                                                       9XXb'   `XXXXXb.dX|Xb.dXXXXX'   `dXXP
                                                                        `'      9XXXXXX(   )XXXXXXP      `'
                                                                                 XXXX X.`v'.X XXXX
                                                                                 XP^X'`b   d'`X^XX
                                                                                 X. 9  `   '  P )X
                                                                                 `b  `       '  d'
                                                                                  `             '
                            \(toString()) attacks your party of \(heroes.filter { hero in hero.hp > 0 }.map{ hero in hero.toString }).
                """
        )
        print()
        Thread.sleep(forTimeInterval: 0.4)
    }
}

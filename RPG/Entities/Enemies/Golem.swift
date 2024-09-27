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
    
    func attack(_ heroes: [Hero], _ warrior: Warrior, _ enemies: [Enemy]) {
        golemLogo(heroes)
        switch Int.random(in: 1...3) {
        case 1:
            Thread.sleep(forTimeInterval: 0.6)
            if (warrior.isTaunting && warrior.hp > 0) {
                smash(warrior)
            } else {
                smash(heroes.filter { hero in hero.hp > 0 }.randomElement()!)
            }
            
        case 2:
            Thread.sleep(forTimeInterval: 0.6)
            groundSlam(heroes.filter { hero in hero.hp > 0 })
            
        case 3:
            Thread.sleep(forTimeInterval: 0.6)
            taunt()
        default:
            print("Something went wrong.")
        }
        print()
    }
    
    func golemLogo(_ heroes: [Hero]) {
        print("""
                                                        ⠀⠀⠀⠀⢶⡆⠀⠀⣴⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⢠⣾⣿⣦⣤⣭⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⣰⠏⠀⢹⣻⣭⣭⡧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⢠⠏⠀⠴⠚⣷⣿⣿⠀⠀⢀⡤⠖⠛⠹⠶⠤⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡏⠀⠀⠀⡼⠉⠉⠁⢀⡴⠋⠀⠀⠤⢄⡀⠀⠀⠈⢢⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡇⠀⠀⠀⢧⡀⠀⢠⠎⠀⢠⣤⡞⠒⠲⡌⠃⠀⠀⠀⠱⢤⡀⠀⢀⣀⣀⣀⠀⠀
                                                        ⠀⣧⠀⠀⠀⠀⠙⠲⠏⠀⢀⡀⠙⣇⠀⠀⢘⡶⠆⣤⠤⠔⢲⣯⡖⠉⠀⠀⠈⢧⠀
                                                        ⠀⢺⣦⡀⠀⠂⠀⠀⠀⠀⠀⢠⣄⠼⣗⠒⠋⠀⠀⠹⣄⣠⣿⡋⡀⢠⣤⡆⠀⢸⠀
                                                        ⠀⠀⠀⣇⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠈⠦⣠⠴⣄⢀⣠⣄⣸⠇⠀⣳⣿⣧⠈⢹⠁
                                                        ⠀⠀⠀⠘⠶⡆⠀⠆⢶⣴⠀⢾⠀⠀⠀⠀⠀⠀⠈⠉⡼⡭⣭⡴⠖⠼⠛⣿⣿⠏⠀
                                                        ⠀⠀⠀⠀⠀⢻⠀⠀⠀⠁⠀⠘⡄⠀⣠⢤⣀⡤⡄⢸⣿⣿⠋⠀⠀⠀ ⠀⠙⠁⠀⠀
                                                        ⠀⠀⠀⠀⠀⣏⠀⠀⠀⠀⠀⠀⠈⠉⠁⠀⠀⠀⠘⠛⢱⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⣸⠁⠀⠀⠸⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⡞⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠃⠀⢿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⠹⡆⠀⠀⠀⣷⣄⢠⡀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⠀⠀⠀⢸⠃⠀⡄⠀⠀⠺⠾⠃⠀⠀⠀⠀⠾⠀⢹⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⠀⣀⣀⡴⠋⠀⠛⠁⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠀⡞⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠃⠀⢀⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⢸⠁⠀⠀⠀⠀⣤⡄⠀⠀⠀⡴⠛⠲⡄⠀⠀⠀⠀⠸⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⡇⠀⠀⠀⣀⠀⠘⠀⠀⣠⠞⠁⠀⠀⢣⠀⠀⠀⠀⠠⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                        ⠘⠒⠒⠶⠁⠉⠉⠉⠉⠀⠀⠀⠀⡞⠀⠀⠰⠇⠐⠛⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀
                                                            ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣼⠁⠀⠀⠀⠀⠀⠀⠈⢳⡄⠀⠀⠀⠀⠀⠀⠀
                                                            ⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠀⠈⠉⠙⠷⠤⠤⠤⠤⠿⠉⠁
                        The \(toString()) attacks your party of \(heroes.filter { hero in hero.hp > 0 }).
        """)
        print()
        Thread.sleep(forTimeInterval: 0.4)
    }
}


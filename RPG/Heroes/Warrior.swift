class Warrior(): Hero(name, maxHp) {
    
    init(name: String, maxHp: Double) {
        self.name = "Haarkon"
        self.maxHp = 100
    }
    var isTaunting = true
    var tauntTimer = 0
    
    func stab(_ target: Enemy) {
        
    }
    
    func cleave(_ targets: [Enemy]) {
        
    }
    
    func taunt() {
        isTaunting = true
        tauntTimer = 3
        
        println(">>> \(bold)\(name) \(normal)is $boldtaunting$reset the ${bold}enemies$reset, forcing them to attack $boldhim$reset for the next 3 turns$reset <<<")
    }
    
    func battleShout() {
        tenacity += 0.1
        
        println(">>> \(bold)\(name) \(normal)made himself more tenacious (x10% dmg reduction) with \(bold)Battle Shout \(normal)<<<")
    }
    
}

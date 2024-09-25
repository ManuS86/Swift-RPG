class HealthPotion: Potion {
    
    override func use(_ target: Hero) {
        let healAmnt = target.maxHp * 0.5
        let preHealHp = target.hp
        
        target.heal(healAmnt)
        
        let amntHealed = target.hp - preHealHp
        
        print("   >>> \(target.name) drinks a Health Potion to heal for \(Int(amntHealed)) hp <<<")
        print("               >>> \(target.name) now has \(Int(target.hp)) hp <<<")
    }
}

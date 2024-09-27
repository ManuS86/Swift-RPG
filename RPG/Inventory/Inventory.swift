import Foundation

struct Inventory {
    private var content = [HealthPotion(), HealthPotion(), HealthPotion(), Elixir()]
    
    mutating func tryUseHealthPotion(_ target: Hero) -> Bool {
        guard let healthPotion = (content.first { potion in potion is HealthPotion }) else {
            print("You are out of Health Potions. Try using another action.")
            return false
        }
        if (target.cantHeal) {
            print("The target is wounded and can't be healed currently. Try another action.")
            return false
        }
        healthPotion.use(target)
        let healthPotionIndex = content.firstIndex { potion in potion is HealthPotion }
        content.remove(at: healthPotionIndex!)
        return true
    }
    
    mutating func tryUseElixir(_ target: Hero) -> Bool {
        guard let elixir = (content.first { potion in potion is Elixir }) else {
            print("You are out of Elixirs. Try using another action.")
            return false
        }
        elixir.use(target)
        let elixirIndex = content.firstIndex { potion in potion is Elixir }
        content.remove(at: elixirIndex!)
        return true
    }
    
    mutating func use(_ heroes: [Hero]) -> Bool {
        let prompt = """
                
                >>> \(self) <<<
            [1] Health Potion
            [2] Elixir
            Select an item to use:
        """
        
        switch select(prompt, 2) {
        case 1:
            Thread.sleep(forTimeInterval: 0.4)
            let target = targetHero(heroes)
            return tryUseHealthPotion(target)
        case 2:
            Thread.sleep(forTimeInterval: 0.4)
            let target = targetHero(heroes)
            return tryUseElixir(target)
        default:
            print("Something went wrong")
        }
        return false
    }
    
    func size() -> Int {
        return content.count
    }
}

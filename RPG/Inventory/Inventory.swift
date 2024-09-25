class Inventory {
    private var content = [HealthPotion(), HealthPotion(), HealthPotion(), Elixir()]
    
    init(content: [Potion]) {
        self.content = content
    }
    
    func tryUseHealthPotion(_ target: Hero) -> Bool {
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
    
    func tryUseElixir(_ target: Hero) -> Bool {
        guard let elixir = (content.first { potion in potion is Elixir }) else {
            print("You are out of Elixirs. Try using another action.")
            return false
        }
        elixir.use(target)
        let elixirIndex = content.firstIndex { potion in potion is Elixir }
        content.remove(at: elixirIndex!)
        return true
    }
    
    func size() -> Int {
        return content.count
    }
}

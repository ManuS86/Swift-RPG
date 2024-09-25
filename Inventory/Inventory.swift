class Inventory {
    private var content: [
        HealthPotion(),
        HealthPotion(),
        HealthPotion(),
        Elixir()
    ]
    
    init(content: [Potion]) {
        self.content = content
    }
    
    func tryUseHealthPotion(target: Hero) {
        
    }
    
    func tryUseElixir(target: Hero) {
        
    }
    
    func size() -> Int {
        return content.size
    }
}

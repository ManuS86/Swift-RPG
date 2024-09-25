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
    
    func tryUseHealthPotion(_ target: Hero) {
        
    }
    
    func tryUseElixir(_ target: Hero) {
        
    }
    
    func size() -> Int {
        return content.size
    }
}

class Elixir: Potion {
    override func use(_ target: Hero) {
        target.abilityMod += 0.1
        print("   >>> \(target.name) drinks an Elixir to increase their ability effects by +10% <<<")
    }
}

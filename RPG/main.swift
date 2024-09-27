import Foundation

func main() {
    var enemies: [Enemy] = [Necromancer()]
    var game = CombatSystem(heroes: [Cleric(), Mage(), Warrior()], enemies: &enemies, inventory: Inventory())
    game.gameLoop()
}

main()

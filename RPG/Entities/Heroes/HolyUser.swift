protocol HolyUser {
    
    func healingHands(_ target: Hero)
    
    func healingWave(_ targets: [Hero])
    
    func dispel(_ target: Hero)
    
    func cripple(_ target: Enemy)
}

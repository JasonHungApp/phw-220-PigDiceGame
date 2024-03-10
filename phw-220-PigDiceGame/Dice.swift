//
//  Dice.swift
//  phw-220-PigDiceGame
//
//  Created by jasonhung on 2024/3/9.
//


enum Dice: String, CaseIterable {
    case one = "die.face.1"
    case two = "die.face.2"
    case three = "die.face.3"
    case four = "die.face.4"
    case five = "die.face.5"
    case six = "die.face.6"
    
    var point: Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        case .five:
            return 5
        case .six:
            return 6
        }
    }
}

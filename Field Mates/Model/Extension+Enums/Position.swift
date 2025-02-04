//
//  Position.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//


enum Position: String, CaseIterable {
    case Goalkeeper
    case Defender
    case Midfielder
    case Forward
}

extension Position {
    
    func localizedDescription() -> String {
        switch self {
        case .Goalkeeper:
            return "Goalkeeper"
        case .Defender:
            return "Defender"
        case .Midfielder:
            return "Midfielder"
        case .Forward:
            return "Forward"
        }
    }
    
}

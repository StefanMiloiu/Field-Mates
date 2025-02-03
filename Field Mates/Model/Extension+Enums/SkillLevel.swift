//
//  SkillLevel.swift
//  Field Mates
//
//  Created by Stefan Miloiu on 30.01.2025.
//


enum SkillLevel: Int, CaseIterable {
    case beginner
    case intermediate
    case advanced
    case professional
}

extension SkillLevel {
    
    func localizedDescription() -> String {
        switch self {
        case .beginner:
            return "Beginner"
        case .intermediate:
            return "Intermediate"
        case .advanced:
            return "Advanced"
        case .professional:
            return "Professional"
        }
    }
    
}

//
//  CalculatorTheme.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

struct CalculatorTheme: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let background: Color
    let displayBackground: Color
    let displayText: Color
    let numberButton: Color
    let numberButtonText: Color
    let operatorButton: Color
    let operatorButtonText: Color
    let specialButton: Color
    let specialButtonText: Color
    let accentGlow: Color
    
    static let themes: [CalculatorTheme] = [
        // Tema Oceano (Azul e Turquesa)
        CalculatorTheme(
            name: "Oceano",
            background: Color(red: 0.05, green: 0.15, blue: 0.25),
            displayBackground: Color(red: 0.08, green: 0.20, blue: 0.30),
            displayText: .white,
            numberButton: Color(red: 0.15, green: 0.35, blue: 0.50),
            numberButtonText: .white,
            operatorButton: Color(red: 0.20, green: 0.70, blue: 0.90),
            operatorButtonText: .white,
            specialButton: Color(red: 0.10, green: 0.50, blue: 0.70),
            specialButtonText: .white,
            accentGlow: Color(red: 0.20, green: 0.70, blue: 0.90)
        ),
        
        // Tema Sunset (Laranja e Rosa)
        CalculatorTheme(
            name: "Pôr do Sol",
            background: Color(red: 0.20, green: 0.10, blue: 0.15),
            displayBackground: Color(red: 0.25, green: 0.12, blue: 0.18),
            displayText: Color(red: 1.0, green: 0.95, blue: 0.90),
            numberButton: Color(red: 0.40, green: 0.25, blue: 0.30),
            numberButtonText: Color(red: 1.0, green: 0.95, blue: 0.90),
            operatorButton: Color(red: 1.0, green: 0.40, blue: 0.50),
            operatorButtonText: .white,
            specialButton: Color(red: 0.90, green: 0.50, blue: 0.30),
            specialButtonText: .white,
            accentGlow: Color(red: 1.0, green: 0.40, blue: 0.50)
        ),
        
        // Tema Neon (Verde e Roxo)
        CalculatorTheme(
            name: "Neon",
            background: Color(red: 0.10, green: 0.05, blue: 0.20),
            displayBackground: Color(red: 0.15, green: 0.08, blue: 0.25),
            displayText: Color(red: 0.60, green: 1.0, blue: 0.80),
            numberButton: Color(red: 0.25, green: 0.15, blue: 0.40),
            numberButtonText: Color(red: 0.80, green: 0.60, blue: 1.0),
            operatorButton: Color(red: 0.40, green: 1.0, blue: 0.70),
            operatorButtonText: Color(red: 0.10, green: 0.05, blue: 0.20),
            specialButton: Color(red: 0.70, green: 0.30, blue: 1.0),
            specialButtonText: .white,
            accentGlow: Color(red: 0.40, green: 1.0, blue: 0.70)
        ),
        
        // Tema Minimalista (Preto e Branco)
        CalculatorTheme(
            name: "Minimalista",
            background: Color(red: 0.95, green: 0.95, blue: 0.95),
            displayBackground: .white,
            displayText: .black,
            numberButton: .white,
            numberButtonText: .black,
            operatorButton: .black,
            operatorButtonText: .white,
            specialButton: Color(red: 0.85, green: 0.85, blue: 0.85),
            specialButtonText: .black,
            accentGlow: .black
        ),
        
        // Tema Dark Mode (Cinza e Laranja)
        CalculatorTheme(
            name: "Dark Pro",
            background: Color(red: 0.08, green: 0.08, blue: 0.08),
            displayBackground: Color(red: 0.12, green: 0.12, blue: 0.12),
            displayText: .white,
            numberButton: Color(red: 0.20, green: 0.20, blue: 0.20),
            numberButtonText: .white,
            operatorButton: Color(red: 1.0, green: 0.60, blue: 0.20),
            operatorButtonText: .white,
            specialButton: Color(red: 0.30, green: 0.30, blue: 0.30),
            specialButtonText: .white,
            accentGlow: Color(red: 1.0, green: 0.60, blue: 0.20)
        ),
        
        // Tema Floresta (Verde e Marrom)
        CalculatorTheme(
            name: "Floresta",
            background: Color(red: 0.15, green: 0.20, blue: 0.15),
            displayBackground: Color(red: 0.20, green: 0.25, blue: 0.20),
            displayText: Color(red: 0.90, green: 1.0, blue: 0.80),
            numberButton: Color(red: 0.25, green: 0.35, blue: 0.25),
            numberButtonText: Color(red: 0.90, green: 1.0, blue: 0.80),
            operatorButton: Color(red: 0.40, green: 0.70, blue: 0.40),
            operatorButtonText: .white,
            specialButton: Color(red: 0.50, green: 0.35, blue: 0.25),
            specialButtonText: .white,
            accentGlow: Color(red: 0.40, green: 0.70, blue: 0.40)
        ),
        
        // Tema Royal (Roxo e Dourado)
        CalculatorTheme(
            name: "Royal",
            background: Color(red: 0.15, green: 0.10, blue: 0.25),
            displayBackground: Color(red: 0.20, green: 0.15, blue: 0.30),
            displayText: Color(red: 1.0, green: 0.90, blue: 0.60),
            numberButton: Color(red: 0.30, green: 0.20, blue: 0.45),
            numberButtonText: Color(red: 1.0, green: 0.90, blue: 0.60),
            operatorButton: Color(red: 1.0, green: 0.80, blue: 0.20),
            operatorButtonText: Color(red: 0.15, green: 0.10, blue: 0.25),
            specialButton: Color(red: 0.50, green: 0.30, blue: 0.70),
            specialButtonText: .white,
            accentGlow: Color(red: 1.0, green: 0.80, blue: 0.20)
        )
    ]
}

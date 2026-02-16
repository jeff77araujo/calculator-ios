//
//  CalculatorButton.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import Foundation

enum CalculatorButton: Hashable {
    case digit(Int)
    case decimal
    case operation(CalculatorOperation)
    case equals
    case clear
    case negate
    case percent
    
    var title: String {
        switch self {
        case .digit(let digit):
            return String(digit)
        case .decimal:
            return "."
        case .operation(let op):
            switch op {
            case .add: return "+"
            case .subtract: return "−"
            case .multiply: return "×"
            case .divide: return "÷"
            }
        case .equals:
            return "="
        case .clear:
            return "C"
        case .negate:
            return "±"
        case .percent:
            return "%"
        }
    }
}

enum CalculatorOperation {
    case add, subtract, multiply, divide
}

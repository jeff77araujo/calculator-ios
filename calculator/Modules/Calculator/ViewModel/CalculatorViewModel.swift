//
//  CalculatorViewModel.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

@Observable
class CalculatorViewModel {
    var displayText: String = "0"
    var currentTheme: CalculatorTheme = CalculatorTheme.themes[0]
    
    private var currentNumber: Double = 0
    private var previousNumber: Double = 0
    private var operation: CalculatorOperation?
    private var shouldResetDisplay = false
    
    func buttonTapped(_ button: CalculatorButton) {
        switch button {
        case .digit(let digit):
            handleDigit(digit)
        case .decimal:
            handleDecimal()
        case .operation(let op):
            handleOperation(op)
        case .equals:
            calculateResult()
        case .clear:
            clear()
        case .negate:
            negate()
        case .percent:
            percent()
        }
    }
    
    private func handleDigit(_ digit: Int) {
        if shouldResetDisplay {
            displayText = String(digit)
            shouldResetDisplay = false
        } else {
            if displayText == "0" {
                displayText = String(digit)
            } else {
                displayText += String(digit)
            }
        }
        currentNumber = Double(displayText) ?? 0
    }
    
    private func handleDecimal() {
        if shouldResetDisplay {
            displayText = "0."
            shouldResetDisplay = false
        } else if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    private func handleOperation(_ op: CalculatorOperation) {
        if operation != nil {
            calculateResult()
        }
        previousNumber = currentNumber
        operation = op
        shouldResetDisplay = true
    }
    
    private func calculateResult() {
        guard let operation = operation else { return }
        
        var result: Double = 0
        
        switch operation {
        case .add:
            result = previousNumber + currentNumber
        case .subtract:
            result = previousNumber - currentNumber
        case .multiply:
            result = previousNumber * currentNumber
        case .divide:
            if currentNumber != 0 {
                result = previousNumber / currentNumber
            } else {
                displayText = "Erro"
                clear()
                return
            }
        }
        
        currentNumber = result
        displayText = formatNumber(result)
        self.operation = nil
        shouldResetDisplay = true
    }
    
    private func clear() {
        displayText = "0"
        currentNumber = 0
        previousNumber = 0
        operation = nil
        shouldResetDisplay = false
    }
    
    private func negate() {
        currentNumber = -currentNumber
        displayText = formatNumber(currentNumber)
    }
    
    private func percent() {
        currentNumber = currentNumber / 100
        displayText = formatNumber(currentNumber)
    }
    
    private func formatNumber(_ number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(number))
        } else {
            return String(number)
        }
    }
    
    func changeTheme(to theme: CalculatorTheme) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentTheme = theme
        }
    }
}


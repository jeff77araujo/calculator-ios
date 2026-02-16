//
//  CalculatorButtonView.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

struct CalculatorButtonView: View {
    let button: CalculatorButton
    let theme: CalculatorTheme
    let action: () -> Void
    
    @State private var isPressed = false
    
    enum ButtonType {
        case number
        case operation
        case special
    }
    
    var buttonType: ButtonType {
        switch button {
        case .digit, .decimal:
            return .number
        case .operation, .equals:
            return .operation
        case .clear, .negate, .percent:
            return .special
        }
    }
    
    var backgroundColor: Color {
        switch buttonType {
        case .number:
            return theme.numberButton
        case .operation:
            return theme.operatorButton
        case .special:
            return theme.specialButton
        }
    }
    
    var textColor: Color {
        switch buttonType {
        case .number:
            return theme.numberButtonText
        case .operation:
            return theme.operatorButtonText
        case .special:
            return theme.specialButtonText
        }
    }
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            action()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
            }
        }) {
            Text(button.title)
                .font(.system(size: 32, weight: .medium))
                .foregroundStyle(textColor)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    ZStack {
                        // Background com gradiente sutil
                        RoundedRectangle(cornerRadius: 20)
                            .fill(backgroundColor)
                        
                        // Brilho quando pressionado
                        if isPressed {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(theme.accentGlow.opacity(0.3))
                        }
                    }
                )
                .shadow(color: backgroundColor.opacity(0.5), radius: isPressed ? 5 : 10, y: isPressed ? 2 : 5)
                .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

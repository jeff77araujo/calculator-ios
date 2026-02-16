//
//  ThemePreviewCard.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

struct ThemePreviewCard: View {
    let theme: CalculatorTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Preview visual do tema
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(theme.background)
                    
                    VStack(spacing: 8) {
                        // Display preview
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.displayBackground)
                            .frame(height: 30)
                            .overlay(
                                Text("123")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundStyle(theme.displayText)
                            )
                        
                        // Botões preview
                        HStack(spacing: 6) {
                            Circle()
                                .fill(theme.numberButton)
                                .frame(width: 25, height: 25)
                            Circle()
                                .fill(theme.operatorButton)
                                .frame(width: 25, height: 25)
                            Circle()
                                .fill(theme.specialButton)
                                .frame(width: 25, height: 25)
                        }
                    }
                    .padding(12)
                }
                .frame(height: 120)
                
                Text(theme.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? theme.accentGlow : .clear, lineWidth: 3)
                    )
                    .shadow(color: isSelected ? theme.accentGlow.opacity(0.5) : .clear, radius: 10)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Múltiplos Cards") {
    ZStack {
        Color.black.ignoresSafeArea()
        VStack {
            HStack(spacing: 20) {
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[0],
                    isSelected: true,
                    action: {}
                )
                .frame(width: 180)
                
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[1],
                    isSelected: false,
                    action: {}
                )
                .frame(width: 180)
            }
            .padding()
            
            HStack(spacing: 20) {
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[2],
                    isSelected: true,
                    action: {}
                )
                .frame(width: 180)
                
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[3],
                    isSelected: false,
                    action: {}
                )
                .frame(width: 180)
            }
            .padding()
            
            HStack(spacing: 20) {
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[4],
                    isSelected: true,
                    action: {}
                )
                .frame(width: 180)
                
                ThemePreviewCard(
                    theme: CalculatorTheme.themes[5],
                    isSelected: false,
                    action: {}
                )
                .frame(width: 180)
            }
            .padding()
        }
    }
}


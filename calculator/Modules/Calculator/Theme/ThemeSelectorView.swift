//
//  ThemeSelectorView.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

struct ThemeSelectorView: View {
    @Binding var selectedTheme: CalculatorTheme
    @Binding var isPresented: Bool
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Escolher Tema")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(CalculatorTheme.themes) { theme in
                        ThemePreviewCard(
                            theme: theme,
                            isSelected: selectedTheme.id == theme.id
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedTheme = theme
                                
                                // Haptic feedback
                                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                                impactFeedback.impactOccurred()
                                
                                // Fechar após seleção
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                        isPresented = false
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .frame(maxWidth: 500, maxHeight: 600)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(red: 0.15, green: 0.15, blue: 0.15))
                .shadow(color: .black.opacity(0.5), radius: 30)
        )
        .padding(40)
    }
}
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ThemeSelectorView(
            selectedTheme: .constant(CalculatorTheme.themes[0]),
            isPresented: .constant(true)
        )
    }
}

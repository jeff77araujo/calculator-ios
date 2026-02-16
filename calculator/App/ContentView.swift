//
//  ContentView.swift
//  calculator
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = CalculatorViewModel()
    @State private var showThemeSelector = false
    
    let buttonLayout: [[CalculatorButton]] = [
        [.clear, .negate, .percent, .operation(.divide)],
        [.digit(7), .digit(8), .digit(9), .operation(.multiply)],
        [.digit(4), .digit(5), .digit(6), .operation(.subtract)],
        [.digit(1), .digit(2), .digit(3), .operation(.add)],
        [.digit(0), .decimal, .equals]
    ]
    
    var body: some View {
        ZStack {
            // Background com gradiente
            LinearGradient(
                gradient: Gradient(colors: [
                    viewModel.currentTheme.background,
                    viewModel.currentTheme.background.opacity(0.8)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header com botão de temas
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showThemeSelector.toggle()
                        }
                    }) {
                        Image(systemName: "paintpalette.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(viewModel.currentTheme.operatorButton)
                            .padding()
                            .background(
                                Circle()
                                    .fill(viewModel.currentTheme.displayBackground)
                                    .shadow(color: viewModel.currentTheme.accentGlow.opacity(0.3), radius: 10)
                            )
                    }
                    .padding()
                }
                
                Spacer()
                
                // Display
                VStack(alignment: .trailing, spacing: 10) {
                    Text(viewModel.displayText)
                        .font(.system(size: 70, weight: .light))
                        .foregroundStyle(viewModel.currentTheme.displayText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
                .frame(height: 150)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(viewModel.currentTheme.displayBackground)
                        .shadow(color: .black.opacity(0.2), radius: 15, y: 5)
                )
                .padding(.horizontal)
                
                // Botões da calculadora
                VStack(spacing: 15) {
                    ForEach(0..<buttonLayout.count, id: \.self) { row in
                        HStack(spacing: 15) {
                            ForEach(buttonLayout[row], id: \.self) { button in
                                if button == .digit(0) {
                                    // Botão 0 ocupa dois espaços
                                    CalculatorButtonView(
                                        button: button,
                                        theme: viewModel.currentTheme,
                                        action: { viewModel.buttonTapped(button) }
                                    )
                                    .frame(height: 75)
                                    .frame(maxWidth: .infinity)
                                    .gridCellColumns(2)
                                } else {
                                    CalculatorButtonView(
                                        button: button,
                                        theme: viewModel.currentTheme,
                                        action: { viewModel.buttonTapped(button) }
                                    )
                                    .frame(height: 75)
                                    .frame(maxWidth: .infinity)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            
            // Theme Selector Overlay
            if showThemeSelector {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showThemeSelector = false
                        }
                    }
                
                ThemeSelectorView(
                    selectedTheme: $viewModel.currentTheme,
                    isPresented: $showThemeSelector
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}

//
//  calculatorTests.swift
//  calculatorTests
//
//  Created by Jefferson Oliveira de Araujo on 15/02/26.
//

import Testing
@testable import calculator

@Suite("Calculator Tests")
@MainActor
struct CalculatorTests {
    
    // MARK: - Basic Digit Input Tests
    
    @Test("Digitar um único número")
    func testSingleDigitInput() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        
        #expect(viewModel.displayText == "5")
    }
    
    @Test("Digitar múltiplos números")
    func testMultipleDigitInput() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.digit(3))
        
        #expect(viewModel.displayText == "123")
    }
    
    @Test("Digitar zero substitui o display inicial")
    func testZeroReplacesInitialDisplay() async throws {
        let viewModel = CalculatorViewModel()
        
        #expect(viewModel.displayText == "0")
        
        viewModel.buttonTapped(.digit(5))
        
        #expect(viewModel.displayText == "5")
    }
    
    // MARK: - Decimal Tests
    
    @Test("Adicionar ponto decimal")
    func testDecimalInput() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.decimal)
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.digit(4))
        
        #expect(viewModel.displayText == "3.14")
    }
    
    @Test("Não permite múltiplos pontos decimais")
    func testMultipleDecimalsPrevented() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.decimal)
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.decimal) // Este não deve ser adicionado
        viewModel.buttonTapped(.digit(4))
        
        #expect(viewModel.displayText == "3.14")
    }
    
    // MARK: - Addition Tests
    
    @Test("Somar dois números inteiros")
    func testAdditionIntegers() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "8")
    }
    
    // MARK: - Subtraction Tests
    
    @Test("Subtrair dois números")
    func testSubtraction() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.digit(0))
        viewModel.buttonTapped(.operation(.subtract))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "7")
    }
    
    @Test("Subtração resultando em número negativo")
    func testSubtractionNegativeResult() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.operation(.subtract))
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "-2")
    }
    
    // MARK: - Multiplication Tests
    
    @Test("Multiplicar dois números")
    func testMultiplication() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(6))
        viewModel.buttonTapped(.operation(.multiply))
        viewModel.buttonTapped(.digit(7))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "42")
    }
    
    @Test("Multiplicar por zero")
    func testMultiplicationByZero() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.multiply))
        viewModel.buttonTapped(.digit(0))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "0")
    }
    
    // MARK: - Division Tests
    
    @Test("Dividir dois números")
    func testDivision() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(8))
        viewModel.buttonTapped(.operation(.divide))
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "4")
    }
    
    @Test("Dividir por zero mostra erro")
    func testDivisionByZero() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.divide))
        viewModel.buttonTapped(.digit(0))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "0") // Após o erro, limpa para "0"
    }
    
    // MARK: - Clear Tests
    
    @Test("Limpar reseta o display")
    func testClear() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.clear)
        
        #expect(viewModel.displayText == "0")
    }
    
    @Test("Limpar reseta operações pendentes")
    func testClearResetsOperations() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.clear)
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "2") // Sem operação pendente
    }
    
    // MARK: - Negate Tests
    
    @Test("Negar um número positivo")
    func testNegatePositive() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.negate)
        
        #expect(viewModel.displayText == "-5")
    }
    
    @Test("Negar um número negativo")
    func testNegateNegative() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.negate)
        viewModel.buttonTapped(.negate)
        
        #expect(viewModel.displayText == "5")
    }
    
    // MARK: - Percent Tests
    
    @Test("Calcular porcentagem")
    func testPercent() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.digit(0))
        viewModel.buttonTapped(.percent)
        
        #expect(viewModel.displayText == "0.5")
    }
    
    @Test("Porcentagem de zero")
    func testPercentOfZero() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(0))
        viewModel.buttonTapped(.percent)
        
        #expect(viewModel.displayText == "0")
    }
    
    // MARK: - Chained Operations Tests
    
    @Test("Operações encadeadas")
    func testChainedOperations() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.operation(.multiply)) // Deve calcular 2+3=5 antes
        viewModel.buttonTapped(.digit(4))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "20") // 5 * 4 = 20
    }
    
    @Test("Múltiplas operações de soma")
    func testMultipleAdditions() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(1))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.digit(2))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.digit(3))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "6")
    }
}

@Suite("Calculator Theme Tests")
@MainActor
struct CalculatorThemeTests {
    
    @Test("Número de temas disponíveis")
    func testThemeCount() async throws {
        #expect(CalculatorTheme.themes.count == 7)
    }
    
    @Test("Todos os temas têm nome")
    func testAllThemesHaveNames() async throws {
        for theme in CalculatorTheme.themes {
            #expect(!theme.name.isEmpty)
        }
    }
    
    @Test("IDs dos temas são únicos")
    func testThemeIDsAreUnique() async throws {
        let ids = CalculatorTheme.themes.map { $0.id }
        let uniqueIds = Set(ids)
        
        #expect(ids.count == uniqueIds.count)
    }
    
    @Test("Mudar tema no ViewModel")
    func testChangeTheme() async throws {
        let viewModel = CalculatorViewModel()
        let oceanTheme = CalculatorTheme.themes[0]
        let sunsetTheme = CalculatorTheme.themes[1]
        
        #expect(viewModel.currentTheme.id == oceanTheme.id)
        
        viewModel.changeTheme(to: sunsetTheme)
        
        #expect(viewModel.currentTheme.id == sunsetTheme.id)
        #expect(viewModel.currentTheme.name == "Pôr do Sol")
    }
}

@Suite("Calculator Button Tests")
struct CalculatorButtonTests {
    
    @Test("Título dos dígitos")
    func testDigitTitles() async throws {
        for digit in 0...9 {
            let button = CalculatorButton.digit(digit)
            #expect(button.title == String(digit))
        }
    }
    
    @Test("Título do decimal")
    func testDecimalTitle() async throws {
        let button = CalculatorButton.decimal
        #expect(button.title == ".")
    }
    
    @Test("Títulos das operações")
    func testOperationTitles() async throws {
        #expect(CalculatorButton.operation(.add).title == "+")
        #expect(CalculatorButton.operation(.subtract).title == "−")
        #expect(CalculatorButton.operation(.multiply).title == "×")
        #expect(CalculatorButton.operation(.divide).title == "÷")
    }
    
    @Test("Título dos botões especiais")
    func testSpecialButtonTitles() async throws {
        #expect(CalculatorButton.equals.title == "=")
        #expect(CalculatorButton.clear.title == "C")
        #expect(CalculatorButton.negate.title == "±")
        #expect(CalculatorButton.percent.title == "%")
    }
    
    @Test("Botões são hasháveis")
    func testButtonsAreHashable() async throws {
        let button1 = CalculatorButton.digit(5)
        let button2 = CalculatorButton.digit(5)
        let button3 = CalculatorButton.digit(3)
        
        #expect(button1 == button2)
        #expect(button1 != button3)
    }
}
@Suite("Calculator Edge Cases")
@MainActor
struct CalculatorEdgeCaseTests {
    
    @Test("Pressionar equals sem operação")
    func testEqualsWithoutOperation() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "5")
    }
    
    @Test("Operação sem segundo número")
    func testOperationWithoutSecondNumber() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.equals)
        
        // Deve usar o número atual como segundo operando
        #expect(viewModel.displayText == "10") // 5 + 5
    }
    
    @Test("Números grandes")
    func testLargeNumbers() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(9))
        viewModel.buttonTapped(.digit(9))
        viewModel.buttonTapped(.digit(9))
        viewModel.buttonTapped(.digit(9))
        viewModel.buttonTapped(.digit(9))
        
        #expect(viewModel.displayText == "99999")
    }
    
    @Test("Múltiplos decimais após operação")
    func testDecimalAfterOperation() async throws {
        let viewModel = CalculatorViewModel()
        
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.operation(.add))
        viewModel.buttonTapped(.decimal)
        viewModel.buttonTapped(.digit(5))
        viewModel.buttonTapped(.equals)
        
        #expect(viewModel.displayText == "5.5")
    }
}


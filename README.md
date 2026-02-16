# CI/CD com GitHub Actions - iOS

## Pré-requisitos

- Xcode instalado
- Projeto iOS criado
- Conta no GitHub

## Passo a Passo

### 1. Estrutura do Projeto

Certifique-se de que seu projeto tem testes:
- Target principal: `calculator`
- Target de testes: `calculatorTests`

### 2. Compartilhar o Scheme

No Xcode:
1. **Product → Scheme → Manage Schemes...**
2. Marque **"Shared"** ao lado do seu scheme
3. Feche a janela

Isso cria: `calculator.xcodeproj/xcshareddata/xcschemes/calculator.xcscheme`

### 3. Criar o Workflow

**No terminal, cole este comando completo:**

```bash
mkdir -p .github/workflows

cat > .github/workflows/ci.yml << 'EOF'
name: iOS CI

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  testar:
    name: Build e Testes
    runs-on: macos-15

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4

      - name: Verificar Xcode
        run: xcodebuild -version

      - name: Build e Testes
        run: |
          xcodebuild test \
            -project calculator.xcodeproj \
            -scheme calculator \
            -destination 'platform=iOS Simulator,name=iPhone 16' \
            -skip-testing:calculatorUITests \
            -enableCodeCoverage YES
EOF
```

### 4. Configurar o .gitignore

**No terminal, cole este comando completo:**

```bash
cat > .gitignore << 'EOF'
# Xcode
*.xcodeproj/*
!*.xcodeproj/project.pbxproj
!*.xcodeproj/xcshareddata/

*.xcworkspace/*
!*.xcworkspace/contents.xcworkspacedata
!*.xcworkspace/xcshareddata/

DerivedData/
*.xcuserstate
*.xcuserdatad
UserInterfaceState.xcuserstate

# Swift Package Manager
.build/
Packages/
*.xcodeproj/project.xcworkspace/xcuserdata/

# CocoaPods
Pods/

# macOS
.DS_Store
EOF
```

### 5. Ajustar Deployment Target

No Xcode:
1. Selecione o projeto
2. Em cada target (app e testes), configure:
   - **iOS Deployment Target** → `17.0` ou `18.0`

### 6. Corrigir Imports nos Testes

Abra `calculatorTests/calculatorTests.swift` e adicione no topo:

```swift
import Foundation
import XCTest
@testable import calculator
```

### 7. Desabilitar Testes de UI (opcional)

**Opção A - No Xcode:**
1. **Product → Scheme → Edit Scheme...**
2. Aba **Test**
3. Desmaque `calculatorUITests`

**Opção B - No workflow:**
Adicione a flag `-skip-testing:calculatorUITests` no comando `xcodebuild`

### 8. Inicializar Git e Subir

```bash
git init
git add .
git commit -m "feat: adiciona CI/CD com GitHub Actions"
```

Crie o repositório no GitHub (manual ou via CLI):

```bash
# Via CLI (requer gh instalado)
gh repo create calculator-ios --public --source=. --push

# Ou manualmente
git remote add origin https://github.com/SEU-USUARIO/calculator-ios.git
git branch -M main
git push -u origin main
```

### 9. Verificar a Esteira

Acesse: `https://github.com/SEU-USUARIO/calculator-ios/actions`

A esteira roda automaticamente a cada push.

## Estrutura Final

```
calculator/
├── .github/
│   └── workflows/
│       └── ci.yml
├── .gitignore
├── calculator.xcodeproj/
│   └── xcshareddata/
│       └── xcschemes/
│           └── calculator.xcscheme
├── calculator/
├── calculatorTests/
└── README.md
```

## Comandos Úteis

Testar localmente antes do push:
```bash
xcodebuild test \
  -scheme calculator \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

Listar schemes disponíveis:
```bash
xcodebuild -list
```

Listar simuladores:
```bash
xcrun simctl list devices available
```

## Troubleshooting

| Erro | Solução |
|------|---------|
| Scheme not found | Compartilhar o scheme no Xcode |
| Deployment target inválido | Ajustar para iOS 17.0 ou 18.0 |
| Missing import Foundation | Adicionar `import Foundation` nos testes |
| UITests failing | Usar `-skip-testing:calculatorUITests` |

## Badge de Status

Adicione ao README para mostrar o status da esteira:

```markdown
![CI Status](https://github.com/SEU-USUARIO/calculator-ios/actions/workflows/ci.yml/badge.svg)
```

# Configuração do SonarCloud

Guia para integrar análise de qualidade de código com SonarCloud no pipeline iOS.

---

## Pré-requisitos

- Projeto iOS com CI/CD configurado
- Conta no GitHub
- Repositório público (ou conta paga do SonarCloud)

---

## Passo 1 — Criar conta no SonarCloud

1. Acesse: https://sonarcloud.io
2. Clique em **"Sign up"**
3. Escolha **"Sign up with GitHub"**
4. Autorize o SonarCloud
5. Selecione sua organização pessoal
6. Escolha o plano **FREE** (para repositórios públicos)

---

## Passo 2 — Adicionar o projeto

1. No dashboard do SonarCloud, clique em **"+"** (canto superior direito)
2. Clique em **"Analyze new project"**
3. Selecione seu repositório
4. Clique em **"Set Up"**
5. Escolha **"With GitHub Actions"**

---

## Passo 3 — Gerar token de API

Na tela de setup:

1. Vá em **Administration** → **Analysis Method**
2. Ou acesse seu perfil → **My Account** → **Security**
3. Em **"Generate Tokens"**:
   - **Name:** `seu-projeto-token`
   - **Type:** `Global Analysis Token`
   - **Expires in:** `No expiration`
4. Clique em **"Generate"**
5. **Copie o token** (você só verá uma vez)

---

## Passo 4 — Adicionar token como Secret no GitHub

1. Vá em: `https://github.com/SEU-USUARIO/SEU-REPO/settings/secrets/actions`
2. Clique em **"New repository secret"**
3. Preencha:
   - **Name:** `SONAR_TOKEN`
   - **Secret:** cole o token copiado
4. Clique em **"Add secret"**

---

## Passo 5 — Criar arquivo de configuração

**No terminal, na raiz do projeto:**

```bash
cat > sonar-project.properties << 'EOF'
# Identificação do projeto (substitua SEU-USUARIO pelo seu GitHub username)
sonar.projectKey=SEU-USUARIO_SEU-REPO
sonar.organization=SEU-USUARIO

# Metadados
sonar.projectName=SEU-REPO
sonar.projectVersion=1.0

# Caminhos
sonar.sources=.
sonar.tests=SEU-PROJETOTests

# Exclusões
sonar.exclusions=**/*Tests.swift,**/AppDelegate.swift,**/SceneDelegate.swift

# Linguagem
sonar.language=swift
sonar.sourceEncoding=UTF-8

# Quality Gate
sonar.qualitygate.wait=true
EOF
```

**Importante:** substitua `SEU-USUARIO` e `SEU-REPO` pelos valores reais.

---

## Passo 6 — Atualizar o workflow do GitHub Actions

Edite `.github/workflows/ci.yml` e adicione os steps do SonarCloud:

```yaml
name: iOS CI with SonarQube

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-test:
    name: Build, Test & Quality Check
    runs-on: macos-15

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Necessário para análise completa

      - name: Verificar Xcode
        run: xcodebuild -version

      - name: Detectar simulador iOS disponível
        id: simulator
        run: |
          DEVICE_ID=$(xcrun simctl list devices available | \
            grep -m 1 "iPad" | \
            grep -oE '[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}')
          echo "device_id=$DEVICE_ID" >> $GITHUB_OUTPUT
          echo "📱 Usando simulador: $DEVICE_ID"

      - name: Build e Testes
        run: |
          xcodebuild test \
            -project SEU-PROJETO.xcodeproj \
            -scheme SEU-SCHEME \
            -destination "platform=iOS Simulator,id=${{ steps.simulator.outputs.device_id }}" \
            -skip-testing:SEU-PROJETOUITests \
            -enableCodeCoverage YES \
            -resultBundlePath TestResults

      - name: Verificar Cobertura Mínima
        run: |
          COVERAGE=$(xcrun xccov view --report --json TestResults.xcresult | \
            python3 -c "import sys, json; data=json.load(sys.stdin); print(data['lineCoverage']*100)")
          
          echo "📊 Cobertura atual: ${COVERAGE}%"
          
          MINIMO=65  # Ajuste conforme necessário
          if (( $(echo "$COVERAGE < $MINIMO" | bc -l) )); then
            echo "❌ ERRO: Cobertura de ${COVERAGE}% está abaixo do mínimo de ${MINIMO}%"
            exit 1
          else
            echo "✅ Cobertura de ${COVERAGE}% está acima do mínimo de ${MINIMO}%"
          fi

      - name: Instalar SonarScanner
        run: brew install sonar-scanner

      - name: Executar SonarCloud Scan
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          sonar-scanner \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.organization=SEU-USUARIO \
            -Dsonar.projectKey=SEU-USUARIO_SEU-REPO
```

**Importante:** substitua:
- `SEU-PROJETO.xcodeproj`
- `SEU-SCHEME`
- `SEU-PROJETOUITests`
- `SEU-USUARIO`
- `SEU-REPO`

---

## Passo 7 — Configurar New Code Definition

No SonarCloud, quando criar o projeto:

1. Escolha **"Previous version"** como definição de código novo
2. Clique em **"Create project"**

---

## Passo 8 — Associar Quality Gate

1. No SonarCloud, vá em: **Project Settings** → **Quality Gate**
2. Selecione **"Sonar way"** (padrão gratuito)
3. Salve

**Nota:** Quality Gates customizados requerem plano pago. No plano free, use "Sonar way" + verificação de cobertura no workflow.

---

## Passo 9 — Commitar e testar

```bash
git add sonar-project.properties .github/workflows/ci.yml
git commit -m "feat: adiciona SonarCloud para análise de qualidade"
git push
```

Vá na aba **Actions** do GitHub e acompanhe a execução.

---

## Visualizar resultados

Após o workflow rodar com sucesso:

1. Acesse: `https://sonarcloud.io/project/overview?id=SEU-USUARIO_SEU-REPO`
2. Você verá:
   - **Bugs** encontrados
   - **Code Smells** (melhorias sugeridas)
   - **Security Hotspots**
   - **Coverage** (cobertura de testes)
   - **Duplications** (código duplicado)

---

## Métricas do Sonar way (Quality Gate padrão)

O Quality Gate "Sonar way" bloqueia a pipeline se:

- **Bugs** em código novo > 0
- **Vulnerabilities** em código novo > 0
- **Security Hotspots Review** em código novo < 100%
- **Code Smells** em código novo > 0
- **Coverage** em código novo < 80%
- **Duplicated Lines** em código novo > 3%

---

## Configuração de cobertura customizada

Como o plano free não permite Quality Gates customizados, a verificação de cobertura mínima é feita **diretamente no workflow**.

Para ajustar o percentual mínimo, edite a variável `MINIMO` no step "Verificar Cobertura Mínima":

```yaml
MINIMO=80  # Altere para o valor desejado (ex: 70, 80, 90)
```

---

## Badge de status

Adicione ao README para mostrar o status do SonarCloud:

```markdown
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=SEU-USUARIO_SEU-REPO&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=SEU-USUARIO_SEU-REPO)
```

Substitua `SEU-USUARIO` e `SEU-REPO`.

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Token inválido | Regenere o token no SonarCloud e atualize no GitHub Secrets |
| "Project not found" | Verifique se `projectKey` e `organization` estão corretos |
| Cobertura sempre 0% | Verifique se `-enableCodeCoverage YES` está no xcodebuild |
| Scanner não encontrado | Certifique-se de que o step "Instalar SonarScanner" rodou |
| Quality Gate não atualiza | Adicione `fetch-depth: 0` no checkout para análise completa |

---

## Comandos úteis

Rodar SonarScanner localmente (após instalar via brew):

```bash
sonar-scanner \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.organization=SEU-USUARIO \
  -Dsonar.projectKey=SEU-USUARIO_SEU-REPO \
  -Dsonar.login=SEU-TOKEN
```

Ver cobertura local:

```bash
xcodebuild test \
  -project SEU-PROJETO.xcodeproj \
  -scheme SEU-SCHEME \
  -destination 'platform=iOS Simulator,name=iPad (10th generation)' \
  -enableCodeCoverage YES \
  -resultBundlePath TestResults

xcrun xccov view --report --json TestResults.xcresult
```

---

## Próximos passos

- Melhorar cobertura de testes para atingir 80%+
- Corrigir Code Smells apontados pelo SonarCloud
- Revisar Security Hotspots
- Adicionar verificação de segurança com [Snyk](SECURITY.md)

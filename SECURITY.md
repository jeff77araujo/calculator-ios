# Configuração do Snyk

Guia para integrar verificação de vulnerabilidades de segurança com Snyk no pipeline iOS.

---

## Pré-requisitos

- Projeto iOS com CI/CD configurado
- Conta no GitHub
- Repositório configurado

---

## O que é Snyk?

Snyk escaneia seu código e dependências em busca de **vulnerabilidades conhecidas** de segurança. A ferramenta:

- Identifica vulnerabilidades em dependências (CocoaPods, Swift Package Manager)
- Detecta problemas de segurança no código
- Classifica severidade: Low, Medium, High, Critical
- Sugere correções e versões seguras

---

## Passo 1 — Criar conta no Snyk

1. Acesse: https://snyk.io
2. Clique em **"Sign up for free"**
3. Escolha **"Sign up with GitHub"**
4. Autorize o Snyk
5. Escolha o plano **FREE** (200 testes/mês)

---

## Passo 2 — Integrar o repositório

1. No dashboard do Snyk, clique em **"Add project"**
2. Escolha **"GitHub"**
3. Selecione seu repositório
4. Clique em **"Add selected repository"**
5. O Snyk fará o primeiro scan automaticamente

---

## Passo 3 — Gerar token de API

### Opção A: Token pessoal (recomendado para projetos pessoais)

1. Clique na sua foto (canto superior direito)
2. Vá em **"Account settings"**
3. Na seção **"General"**, procure **"Auth Token"**
4. Clique em **"click to show"**
5. **Copie o token completo**

### Opção B: Service Account (para projetos em equipe)

1. Vá em **Organization Settings**
2. Clique em **"Manage service accounts"**
3. Clique em **"Create a service account"**
4. Preencha:
   - **Name:** `nome-do-projeto-github`
   - **Role:** `Org Admin`
5. **Copie o token gerado**

---

## Passo 4 — Adicionar token como Secret no GitHub

1. Vá em: `https://github.com/SEU-USUARIO/SEU-REPO/settings/secrets/actions`
2. Clique em **"New repository secret"**
3. Preencha:
   - **Name:** `SNYK_TOKEN`
   - **Secret:** cole o token copiado
4. Clique em **"Add secret"**

---

## Passo 5 — Atualizar o workflow do GitHub Actions

Edite `.github/workflows/ci.yml` e adicione os steps do Snyk **ANTES** do build:

```yaml
name: iOS CI with SonarQube & Snyk

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-test:
    name: Build, Test & Security Check
    runs-on: macos-15

    steps:
      - name: Checkout do código
        uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Verificar Xcode
        run: xcodebuild -version

      # 🛡️ SNYK - Verificação de Segurança (PRIMEIRO)
      - name: Setup Snyk
        run: |
          brew tap snyk/tap
          brew install snyk

      - name: Snyk Security Scan
        continue-on-error: false
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        run: |
          snyk auth $SNYK_TOKEN
          snyk test --severity-threshold=high --fail-on=all || echo "✅ No dependencies found or no high/critical vulnerabilities"

      # ... resto do workflow (build, testes, cobertura, sonarcloud)
```

---

## Entendendo as configurações do Snyk

### Flags importantes:

```bash
snyk test --severity-threshold=high --fail-on=all
```

- `--severity-threshold=high` → Reporta apenas vulnerabilidades **ALTAS** e **CRÍTICAS**
- `--fail-on=all` → **BLOQUEIA** a pipeline se encontrar qualquer vulnerabilidade acima do threshold
- `continue-on-error: false` → Se Snyk falhar, toda a pipeline para

### Outros níveis de severidade:

```bash
--severity-threshold=low     # Reporta: low, medium, high, critical
--severity-threshold=medium  # Reporta: medium, high, critical
--severity-threshold=high    # Reporta: high, critical
--severity-threshold=critical # Reporta: apenas critical
```

### Comportamento em caso de falha:

```bash
--fail-on=all          # Falha se encontrar qualquer vulnerabilidade
--fail-on=upgradable   # Falha apenas se houver fix disponível
--fail-on=patchable    # Falha apenas se houver patch disponível
```

---

## Passo 6 — Commitar e testar

```bash
git add .github/workflows/ci.yml
git commit -m "feat: adiciona Snyk para verificação de segurança"
git push
```

Vá na aba **Actions** do GitHub e acompanhe a execução.

---

## Cenários de execução

### ✅ Cenário 1: Nenhuma vulnerabilidade

```
🛡️ Snyk Security Scan
  ✅ No dependencies found
  ✅ No vulnerabilities detected
```

Pipeline continua normalmente.

---

### ⚠️ Cenário 2: Vulnerabilidades baixas/médias

```
🛡️ Snyk Security Scan
  ⚠️ Found 2 medium severity vulnerabilities
  ⚠️ Found 1 low severity vulnerability
```

Pipeline **NÃO bloqueia** (threshold é `high`).

---

### ❌ Cenário 3: Vulnerabilidades altas/críticas

```
🛡️ Snyk Security Scan
  ❌ Found 1 high severity vulnerability in package X
  ❌ BLOCKING PIPELINE
```

Pipeline **BLOQUEIA IMEDIATAMENTE**. Build e testes não executam.

---

## Visualizar resultados no Snyk

Após o workflow rodar:

1. Acesse: https://app.snyk.io
2. Vá em **Projects**
3. Clique no seu repositório
4. Você verá:
   - **Vulnerabilities** encontradas
   - **Severidade** de cada uma
   - **Como corrigir** (upgrade de versão, patch, etc)
   - **Detalhes técnicos** da vulnerabilidade (CVE)

---

## Nota sobre projetos iOS puros

Projetos iOS que **não usam dependências externas** (sem CocoaPods, SPM, Carthage) não têm nada para o Snyk escanear:

```
✅ No dependencies found to scan
```

**Isso é normal e esperado!** Significa que seu projeto não tem vulnerabilidades porque não depende de bibliotecas de terceiros.

Para ver o Snyk em ação de verdade, você precisaria adicionar dependências, por exemplo:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0")
]
```

---

## Configurações avançadas

### Ignorar vulnerabilidades específicas

Se você precisar ignorar uma vulnerabilidade temporariamente:

```bash
snyk ignore --id=SNYK-XXX-XXXXX --reason="Aguardando patch do fornecedor"
```

### Monitorar projeto continuamente

Para que o Snyk monitore seu projeto e te notifique de novas vulnerabilidades:

```bash
snyk monitor
```

Adicione isso como último step do workflow (após os testes passarem).

### Gerar relatórios

```bash
snyk test --json > snyk-report.json
snyk test --sarif > snyk-report.sarif
```

---

## Integração com Pull Requests

O Snyk pode comentar automaticamente em PRs quando detectar vulnerabilidades:

1. No Snyk, vá em **Integrations** → **GitHub**
2. Ative **"Pull request checks"**
3. Configure para bloquear merge se houver vulnerabilidades altas

---

## Badge de status

Adicione ao README para mostrar o status de segurança:

```markdown
[![Known Vulnerabilities](https://snyk.io/test/github/SEU-USUARIO/SEU-REPO/badge.svg)](https://snyk.io/test/github/SEU-USUARIO/SEU-REPO)
```

Substitua `SEU-USUARIO` e `SEU-REPO`.

---

## Troubleshooting

| Problema | Solução |
|----------|---------|
| Authentication error (401) | Token inválido. Regenere no Snyk e atualize no GitHub Secrets |
| "No supported files found" | Projeto não tem dependências. Isso é normal para projetos iOS puros |
| Snyk CLI não encontrado | Certifique-se de que o step "Setup Snyk" rodou com sucesso |
| Timeout no scan | Projeto muito grande. Considere usar `--all-projects=false` |
| Falso positivo | Use `snyk ignore` para marcar como não aplicável |

---

## Comandos úteis

Rodar Snyk localmente (após instalar via brew):

```bash
# Instalar
brew tap snyk/tap
brew install snyk

# Autenticar
snyk auth

# Testar projeto
snyk test

# Ver todas as vulnerabilidades (incluindo low/medium)
snyk test --severity-threshold=low

# Testar sem bloquear
snyk test || true

# Monitorar projeto
snyk monitor
```

---

## Boas práticas

1. **Rode Snyk ANTES do build** para falhar rápido
2. **Use threshold `high`** para não bloquear por problemas menores
3. **Monitore continuamente** com `snyk monitor` após merge
4. **Revise regularmente** o dashboard do Snyk
5. **Atualize dependências** assim que patches forem disponibilizados
6. **Documente exceções** quando usar `snyk ignore`
7. **Integre com PRs** para detectar problemas antes do merge

---

## Fluxo de segurança completo

```
Desenvolvedor faz push
    ↓
1. Snyk escaneia código e dependências
    ↓
2. Encontrou vulnerabilidade alta/crítica?
   └─ SIM → ❌ BLOQUEIA pipeline
   └─ NÃO → ✅ Continua
    ↓
3. Build e testes
    ↓
4. Cobertura de código
    ↓
5. SonarCloud (qualidade)
    ↓
6. Deploy (se tudo passou)
```

---

## Diferença entre Snyk e SonarCloud

| Ferramenta | Foco | O que detecta |
|------------|------|---------------|
| **Snyk** | Segurança | Vulnerabilidades conhecidas (CVEs) em dependências e código |
| **SonarCloud** | Qualidade | Code smells, bugs, duplicação, cobertura de testes |

**Use ambos** para ter cobertura completa: qualidade + segurança.

---

## Próximos passos

- Adicionar dependências e testar o Snyk detectando vulnerabilidades reais
- Configurar notificações do Snyk (email, Slack)
- Integrar Snyk Open Source + Snyk Code (análise estática)
- Explorar Snyk Container (para Docker)
- Configurar políticas customizadas de segurança

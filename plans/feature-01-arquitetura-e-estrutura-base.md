# Feature Plan: 01 - Arquitetura Base, Estrutura e Governança do Projeto

> Baseado na Seção 1 (Visão Geral e Arquitetura) e Seção 3 (Estrutura do Repositório e Governança) de `plans/roadmap.md`.

## 1. Visão Geral
Estabelecer a fundação técnica do projeto Fábula TCG Companion App em Flutter, estruturando a Clean Architecture e Feature-First com Riverpod, padrões de código estritos e governança open-source alinhada ao `AGENTS.md`.

## 2. Escopo e Objetivos
- Criar a estrutura inicial de diretórios modularizada (Feature-First com camadas Core, Domain, Data, Presentation).
- Configurar o motor de injeção de dependência e gerenciamento de estado com Riverpod.
- Estabelecer a infraestrutura de persistência offline-first local (ex.: Hive/Isar/Drift).
- Configurar linters estritos (`flutter_lints` / `analysis_options.yaml`) e pipeline inicial de testes unitários.
- Estabelecer os contratos fundamentais de domínio imutáveis (`@immutable` / `freezed`).

## 3. Arquitetura e Diretórios
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── theme/
│   └── utils/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── rules/
├── presentation/
│   ├── components/
│   ├── screens/
│   └── state/
└── main.dart
test/
├── core/
├── data/
├── domain/
│   └── rules/
└── presentation/
```

## 4. Tarefas de Implementação

### 4.1. Setup do Projeto e Dependências
- [ ] Inicializar/validar `pubspec.yaml` com as dependências centrais:
  - `flutter_riverpod` (ou `hooks_riverpod`)
  - `freezed_annotation`, `json_annotation`
  - Pacote de persistência offline (`hive` / `isar` / `drift`)
  - `flutter_lints` nas dev_dependencies
  - `build_runner`, `freezed`, `json_serializable`
- [ ] Configurar `analysis_options.yaml` com linting estrito conforme regras de `AGENTS.md`.

### 4.2. Estrutura Core e Contratos Base
- [ ] Criar classes de erro/falhas e value objects fundamentais (ex.: `GameRuleException`, `PlayerId`).
- [ ] Implementar a abstração do serviço de persistência local (`LocalStorageService`).
- [ ] Implementar provedor de inicialização assíncrona (garantindo carregamento offline antes da UI).

### 4.3. Pipeline de Testes e Governança
- [ ] Configurar suíte básica de testes em `test/domain/` para validação contínua.
- [ ] Documentar o fluxo de contribuição e convenções semânticas de commits em consonância com `AGENTS.md`.

## 5. Critérios de Aceite
- [ ] Projeto compila sem avisos no `flutter analyze`.
- [ ] `flutter test` executa com sucesso.
- [ ] Separação clara entre Presentation, Domain e Data respeitada.

# Fábula TCG - Mobile Companion App

Aplicativo open-source desenvolvido em **Flutter** para atuar como marcador de mesa, assistente de regras e controlador de recursos/território para o jogo de cartas **Fábula TCG**.

---

## 📋 Requisitos Prévios

- **Flutter SDK**: `>= 3.22.0`
- **Dart SDK**: `>= 3.4.0`
- **Make**: Para execução automatizada dos comandos do projeto (opcional, mas recomendado)
- **Android Studio / Xcode**: Para emulação e compilação nativa (Android/iOS)

---

## ⚡ Guia Rápido com Makefile

O projeto conta com um `Makefile` configurado para facilitar a rotina de desenvolvimento, testes e builds:

| Comando | Descrição |
| :--- | :--- |
| `make setup` | Instala dependências do Flutter (`flutter pub get`) |
| `make run` | Executa o app em modo de desenvolvimento |
| `make test` | Executa a suíte de testes unitários e de widgets |
| `make analyze` | Roda a análise estática estrita (`flutter analyze`) |
| `make check` | Roda a validação completa (`analyze` + `test`) |
| `make format` | Formata o código fonte (`dart format`) |
| `make build-runner` | Gera código via `build_runner` (Freezed, JSON, Riverpod) |
| `make clean` | Limpa diretórios temporários e recarrega dependências |
| `make build-apk` | Compila o pacote APK de produção (Android Release) |
| `make build-ipa` | Compila o pacote de produção para iOS (requer macOS e Xcode) |
| `make help` | Exibe a lista interativa de todos os comandos |

---

## 🛠️ Execução e Compilação Manual (Sem Make)

Caso não queira ou não possa utilizar `make`, utilize os comandos oficiais do Flutter:

1. **Instalar dependências**:
   ```bash
   flutter pub get
   ```

2. **Geração de código**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Executar em desenvolvimento**:
   ```bash
   flutter run
   ```

4. **Executar testes e análise estática**:
   ```bash
   flutter analyze
   flutter test
   ```

5. **Compilação de Produção**:
   - **Android (APK)**:
     ```bash
     flutter build apk --release
     ```
   - **iOS (IPA - requer macOS e Xcode)**:
     ```bash
     flutter build ipa --release
     ```

---

## 📐 Arquitetura e Padrões de Código

- **Padrão Arquitetural**: Clean Architecture com abordagem *Feature-First*.
- **Gerenciamento de Estado**: Riverpod com controllers/notifiers imutáveis.
- **Identidade Visual**: Paleta baseada nas 7 cores oficiais de cartas/bases de Fábula TCG e tipografia de alta legibilidade para visualização de mesa (1+ metro de distância).
- **Regras de Contribuição e Gitflow**: Consulte [AGENTS.md](AGENTS.md) e [skills/gitflow/SKILL.md](skills/gitflow/SKILL.md).

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
| `make build-web` | Compila o aplicativo para Web (GitHub Pages / SPA) |
| `make help` | Exibe a lista interativa de todos os comandos |

---

## 🌐 Publicação Web (GitHub Pages)

O projeto está configurado para deploy contínuo no **GitHub Pages** via **GitHub Actions** através do workflow [`.github/workflows/deploy-web.yml`](.github/workflows/deploy-web.yml).

### URL Publicada Prevista
- **URL do Projeto**: `https://jacksoncl7.github.io/fabula-tcg-app/`
  *(O subcaminho `/fabula-tcg-app/` corresponde ao nome do repositório no GitHub).*

### Passos para Ativação no GitHub
1. Acesse o repositório no GitHub (`https://github.com/jacksoncl7/fabula-tcg-app`).
2. Vá em **Settings** → **Pages** (no menu lateral esquerdo).
3. Na seção **Build and deployment**:
   - Em **Source**, selecione **GitHub Actions**.
4. Dispare o deploy:
   - Faça push na branch `main`, ou
   - Vá na aba **Actions**, selecione o workflow **Deploy Web to GitHub Pages** e clique em **Run workflow**.
5. Quando o deploy concluir, a URL pública estará disponível na página de **Settings → Pages** e na visualização da execução da Action.

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
   - **Web (GitHub Pages)**:
     ```bash
     flutter build web --release --base-href "/fabula-tcg-app/"
     ```
     *(Substitua `/fabula-tcg-app/` por `/` apenas se o repositório for um site raiz de usuário no formato `<usuario>.github.io`).*

---

## 📐 Arquitetura e Padrões de Código

- **Padrão Arquitetural**: Clean Architecture com abordagem *Feature-First*.
- **Gerenciamento de Estado**: Riverpod com controllers/notifiers imutáveis.
- **Identidade Visual**: Paleta baseada nas 7 cores oficiais de cartas/bases de Fábula TCG e tipografia de alta legibilidade para visualização de mesa (1+ metro de distância).
- **Regras de Contribuição e Gitflow**: Consulte [AGENTS.md](AGENTS.md) e [skills/gitflow/SKILL.md](skills/gitflow/SKILL.md).

# Fábula TCG - Mobile Companion App

Aplicativo open-source para contagem de recursos e estado de jogo de Fábula TCG.

## Requisitos Prévia
- Flutter SDK (>= 3.22.0)
- Dart SDK (>= 3.4.0)
- Android Studio / Xcode (para emuladores e builds nativas)

## Como Executar e Compilar Manualmente

1. Clone o repositório:
   git clone [suspicious link removed]
   cd fabula-tcg-app

2. Instale as dependências:
   flutter pub get

3. Execute em modo de desenvolvimento:
   flutter run

4. Compilação de Produção (Build Manual):
   - Android (APK):
     flutter build apk --release
   - iOS (Requer macOS e Xcode configurado):
     flutter build ipa --release

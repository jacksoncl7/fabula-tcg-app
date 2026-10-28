.PHONY: help setup clean run test analyze build-runner build-apk build-ipa check format

help: ## Exibe a lista de comandos disponíveis
	@echo "=========================================================="
	@echo "            Fábula TCG App - Makefile Helper              "
	@echo "=========================================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

setup: ## Instala as dependências do projeto e ativa build_runner
	flutter pub get

clean: ## Limpa os artefatos de build e cache do Flutter
	flutter clean
	flutter pub get

run: ## Executa o aplicativo em modo de desenvolvimento
	flutter run

test: ## Executa todos os testes unitários e de widgets
	flutter test

analyze: ## Executa a análise estática estrita do código Dart
	flutter analyze

format: ## Formata todo o código fonte Dart
	dart format lib test

build-runner: ## Executa a geração de código (Freezed, JSON, Riverpod)
	dart run build_runner build --delete-conflicting-outputs

build-apk: ## Compila o aplicativo para Android em modo Release
	flutter build apk --release

build-ipa: ## Compila o pacote iOS Release (requer macOS e Xcode)
	flutter build ipa --release

check: analyze test ## Executa validação completa (análise estática + testes)

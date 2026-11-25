# Diretrizes de Contribuição — Fábula TCG App

Obrigado pelo interesse em contribuir para o **Fábula TCG App**! 🎉

Este é um projeto de código aberto desenvolvido em **Flutter** e **Dart**, focado em ser um assistente de mesa (marcador de vida/recursos, árbitro digital e gestor de territórios) *offline-first* para a comunidade do card game Fábula TCG.

Este documento detalha o fluxo de trabalho, os padrões técnicos e as convenções que utilizamos.

---

## Índice

- [Código de Conduta](#código-de-conduta)
- [Como Posso Contribuir?](#como-posso-contribuir)
  - [Reportando Bugs](#reportando-bugs)
  - [Sugerindo Melhorias](#sugerindo-melhorias)
  - [Contribuindo com Código](#contribuindo-com-código)
- [Fluxo de Desenvolvimento (Gitflow)](#fluxo-de-desenvolvimento-gitflow)
  - [1. Fork e Clonagem](#1-fork-e-clonagem)
  - [2. Criação da Branch](#2-criação-da-branch)
  - [3. Instalação e Ambiente](#3-instalação-e-ambiente)
  - [4. Padrão de Commits](#4-padrão-de-commits)
  - [5. Sincronização e Rebase](#5-sincronização-e-rebase)
  - [6. Submissão do Pull Request](#6-submissão-do-pull-request)
- [Diretrizes de Qualidade e Código](#diretrizes-de-qualidade-e-código)
  - [Arquitetura e Boas Práticas](#arquitetura-e-boas-práticas)
  - [Comandos de Validação Local](#comandos-de-validação-local)
- [Regras de Negócio e Fidelidade ao Livro de Regras](#regras-de-negócio-e-fidelidade-ao-livro-de-regras)

---

## Código de Conduta

Ao participar deste projeto, você concorda em seguir o nosso [Código de Conduta](CODE_OF_CONDUCT.md). Tratamos todos os colaboradores com respeito e empatia.

---

## Como Posso Contribuir?

### Reportando Bugs

Antes de abrir uma issue, verifique se o problema já foi reportado nas [Issues abertas](https://github.com/jacksoncl7/fabula-tcg-app/issues).

Ao relatar um bug, utilize o nosso template e inclua:
- Uma descrição clara do problema.
- Passos detalhados para reproduzir o comportamento.
- Comportamento esperado vs. comportamento ocorrido.
- Capturas de tela ou gravações (se aplicável).
- Ambiente (sistema operacional, versão do Flutter, dispositivo/emulador).

### Sugerindo Melhorias

Sugestões de melhorias de interface, ergonomia de mesa ou novas funcionalidades de arbitragem são sempre bem-vindas! Ao abrir uma sugestão:
- Explique o caso de uso e a motivação.
- Se for uma regra de jogo, cite a respectiva seção do Livro Oficial de Regras de Fábula TCG.
- Descreva alternativas consideradas.

### Contribuindo com Código

Se deseja implementar uma nova funcionalidade ou correção:
1. Verifique se existe uma issue aberta ou crie uma para discutir a proposta antes de codificar grandes mudanças.
2. Siga as instruções abaixo de branch, estilo e testes.

---

## Fluxo de Desenvolvimento (Gitflow)

Seguimos um fluxo baseado em **feature branches** com histórico linear:

### 1. Fork e Clonagem

1. Crie um Fork do repositório para a sua conta GitHub.
2. Clone o repositório localmente:
   ```bash
   git clone https://github.com/<seu-usuario>/fabula-tcg-app.git
   cd fabula-tcg-app
   ```
3. Configure o repositório original como `upstream`:
   ```bash
   git remote add upstream https://github.com/jacksoncl7/fabula-tcg-app.git
   ```

### 2. Criação da Branch

Trabalhe sempre em uma branch isolada criada a partir da `upstream/main`:

```bash
git fetch upstream
git checkout -b <tipo>/<nome-em-kebab-case> upstream/main
```

Prefixos padrão:
- `feat/`: Nova funcionalidade
- `fix/`: Correção de bug
- `refactor/`: Refatoração sem alteração de funcionalidade
- `docs/`: Documentação
- `test/`: Adição ou ajuste de testes
- `chore/`: Infraestrutura, CI, dependências

*Exemplo*: `git checkout -b feat/support-card-counter upstream/main`

### 3. Instalação e Ambiente

O projeto requer:
- **Flutter SDK**: `>= 3.22.0`
- **Dart SDK**: `>= 3.4.0 < 4.0.0`

Instale as dependências:
```bash
make setup
# ou manualmente:
flutter pub get
```

### 4. Padrão de Commits

Adotamos **Conventional Commits**. Cada commit deve ser semântico, atômico e manter a suíte de testes passando.

Formato:
```text
<tipo>(<escopo-opcional>): <descrição no imperativo e em minúsculas>

[corpo opcional explicando o quê e por quê]
```

Tipos aceitos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

*Exemplos*:
- `feat(territory): implement exposed center validation`
- `fix(counter): reset maneuver resources on turn pass`
- `docs: update contributing instructions`

### 5. Sincronização e Rebase

Mantenha sua branch atualizada realizando **rebase** sobre a `upstream/main` (nunca faça commits de merge de sincronização):

```bash
git fetch upstream
git rebase upstream/main
```

Se houver conflitos: resolva-os, execute `git add <arquivos>` e prossiga com `git rebase --continue`.

### 6. Submissão do Pull Request

1. Envie sua branch para o seu fork:
   ```bash
   git push -u origin <tipo>/<nome-da-branch>
   ```
2. Abra um Pull Request (PR) contra a branch `main` do repositório principal.
3. Preencha o template de PR detalhando as alterações, testes realizados e referências às issues relacionadas.
4. Aguarde a validação dos checks de CI e a revisão da comunidade. O merge na `main` é realizado via **Squash and Merge**.

---

## Diretrizes de Qualidade e Código

Para que um PR seja aceito, ele deve atender a todos os critérios abaixo:

### Arquitetura e Boas Práticas

1. **Clean Architecture & Feature-First**:
   - `core/`: Utilitários compartilhados, tema, constantes.
   - `domain/`: Regras de negócio puras, entidades imutáveis, interfaces.
   - `data/`: Repositórios locais e fontes de dados offline.
   - `presentation/`: Widgets, layouts de mesa e estado Riverpod.
2. **Offline-First**: Nenhuma funcionalidade de partida pode exigir login ou conexão de rede obrigatória.
3. **Imutabilidade**: Modelos de domínio e estados Riverpod devem ser imutáveis, implementando `copyWith` e igualdade sem quebrar tipagem.
4. **Ergonomia de Mesa**: Numerais de alto contraste (visíveis a 1m de distância) e suporte para inversão 180° no lado do oponente (`RotatablePlayerZone`).

### Comandos de Validação Local

Antes de abrir o PR, execute:

```bash
# 1. Formatar código
make format
# (ou dart format lib test)

# 2. Executar análise estática estrita
make analyze
# (ou flutter analyze)

# 3. Executar suíte de testes
make test
# (ou flutter test)

# 4. Ou execute o comando unificado de checagem:
make check
```

> [!IMPORTANT]
> O PR não será aceito se houver erros ou avisos (*warnings*) no `flutter analyze` ou se algum teste falhar.

---

## Regras de Negócio e Fidelidade ao Livro de Regras

Toda lógica de jogo introduzida deve ser fiel às regras oficiais de Fábula TCG (consulte [AGENTS.md](AGENTS.md) para detalhes):
- **Progressão de Recursos** (Regras 1.7.2c, 1.18.10): Turno 1 inicia com 2 Recursos Máximos; +2 por turno ativo até o teto de 10.
- **Recursos para Manobras** (Regra 1.7.3): Recursos não gastos permanecem disponíveis no turno do oponente para reações imediatas.
- **Fase de Restauração** (Regras 1.7.2b, 1.18.9): Recursos residuais são limpos e redefinidos ao valor máximo. Desvirar aliados custa 1 recurso cada.
- **Território e Bases** (Regras 3.1.7 – 3.1.11, 1.22.5a): Cada jogador possui 5 bases (4 Entornos com 5 de resistência e 1 Centro com 15). O Centro não pode ser atacado enquanto houver ao menos 1 Entorno original controlado.
- **Vitória**: Conquista ou destruição do Centro inimigo encerra a partida imediatamente.

---

Agradecemos imensamente por ajudar a construir o Fábula TCG App! 🃏⚔️

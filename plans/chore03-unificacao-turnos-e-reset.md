# Chore 03: Unificação de Turnos, Contador Central e Reinício de Partida

> Documentação do plano de implementação para centralização do fluxo de turnos, explicitação numérica do contador de turno, diálogo de confirmação para reinício do jogo e despoluição da barra central.

## 1. Contexto e Motivação
Atualmente, cada jogador possui um botão individual de "Próx. Turno" em seu dashboard, o que pode gerar confusão sobre de quem é a vez na mesa de jogo e não reflete com clareza o ciclo sequencial de turnos de Fábula TCG.
Além disso:
- A barra central não exibe o número do turno corrente da partida.
- Não há um mecanismo rápido para reiniciar o jogo ao estado inicial caso os jogadores queiram começar uma nova partida.
- O botão de "Modo Stream/Webcam" ocupa espaço prioritário na barra central e foi solicitado para remoção.

## 2. Requisitos e Comportamento Esperado

### 2.1. Botão Unificado de "Próximo Turno"
- **Localização**: Centralizado na barra central entre as duas metades da mesa.
- **Comportamento**:
  - A partida inicia no **Turno 1** com o **Jogador 1** ativo.
  - Ao clicar em "Passar Turno", a vez passa para o **Jogador 2**.
  - Quando o Jogador 2 encerra sua vez, a partida avança para o **Turno 2**, a vez volta para o **Jogador 1**, e o Jogador 1 recebe sua progressão de +2 Recursos Máximos (até o teto de 10) com restauração automática do saldo.
  - O jogador inativo mantém seus recursos remanescentes utilizáveis para Manobras (Regra 1.7.3).
  - Remoção dos botões individuais de "Próx. Turno" nos dashboards de Jogador 1 e 2.

### 2.2. Contador Numérico de Turno Explicito
- Exibir com destaque numérico na barra central o turno da partida (ex: `TURNO 1`, `TURNO 2`, etc.).
- Exibir indicação visual clara de quem está com a vez (ex: `Vez: Jogador 1` com realce na cor do jogador ativo).

### 2.3. Botão e Fluxo de Reiniciar Jogo
- Botão dedicado na barra central com ícone `Icons.restart_alt`.
- **Etapa de Confirmação Obrigatória**:
  - Diálogo modal:
    - **Título**: *Reiniciar Partida*
    - **Mensagem**: *"Deseja reiniciar a partida? Todos os recursos, turnos e bases voltarão ao estado inicial."*
    - **Ações**: *Cancelar* e *Reiniciar* (estilo destrutivo `FabulaColors.error`).
  - Ao confirmar:
    - Jogador 1 e Jogador 2 têm seus recursos reiniciados para o Turno 1 (2 Recursos Max e 2 Atuais).
    - Territórios de ambos os jogadores são restaurados (todas as 5 bases intactas e controladores originais).
    - Turno da partida volta ao Turno 1 com o Jogador 1 ativo.

### 2.4. Remoção do Botão "Modo Stream / Webcam"
- Remover o botão de toggle de stream da barra central.

---

## 3. Arquitetura e Estrutura Técnica Planejada

### 3.1. Camada de Domínio (`lib/domain/`)
- **`entities/match_state.dart`**:
  - `int turnNumber` (inicia em 1).
  - `PlayerId activePlayer` (inicia em `player_1`).
- **`rules/match_rules.dart`** (`MatchNotifier`):
  - `advanceTurn({required ResourceNotifier p1Resource, required ResourceNotifier p2Resource})`: gerencia o ciclo sequencial de alternância e progressão de recursos.
  - `resetMatch({required ResourceNotifier p1Resource, required ResourceNotifier p2Resource, required TerritoryNotifier p1Territory, required TerritoryNotifier p2Territory})`: reseta todos os estados para o início.
- **`rules/resource_rules.dart`**:
  - Adição do método `reset()` para reiniciar os recursos para Turno 1 e 2 recursos.

### 3.2. Camada de Apresentação (`lib/presentation/`)
- **`providers.dart`**:
  - Expor `matchProvider = StateNotifierProvider<MatchNotifier, MatchState>(...)`.
- **`screens/home_screen.dart`**:
  - Barra central reestruturada com:
    - `[Reiniciar]` (com diálogo modal).
    - `[Contador de Turno]` (`TURNO X` + indicador visual da vez).
    - `[Passar Turno]` (botão unificado com estilo de ação).
    - `[Acessibilidade]` (menu de alto contraste / monocromático mantido).
  - Remoção dos botões de próximo turno de cada `_PlayerDashboard`.

---

## 4. Plano de Testes Automatizados
1. **Regras de Partida (`test/domain/rules/match_rules_test.dart`)**:
   - Inicialização (Turno 1, Jogador 1 ativo).
   - Alternância sequencial J1 -> J2 -> J1 (com incremento de turno).
   - Progressão correta de recursos a cada turno ativo.
   - Reinício completo da partida.
2. **Widgets (`test/presentation/components_test.dart` / `home_screen_test.dart`)**:
   - Renderização da barra central com "TURNO 1".
   - Ausência do botão de stream.
   - Avanço de turno via botão central.
   - Abertura de diálogo de confirmação de reinício e cancelamento/confirmação.

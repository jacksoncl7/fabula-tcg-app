# Feature Plan: 07 - Histórico de Partidas, Estatísticas e Suporte Multi-Formato (Fase 3)

> Baseado na Seção 5.3 (Fase 3: Histórico de Partidas, Estatísticas e Suporte Multi-Formato) e Seção 2.2 de `plans/roadmap.md`.

## 1. Visão Geral
Implementar persistência local de partidas finalizadas, registro e auditoria do tipo de vitória, métricas analíticas e estatísticas de jogo (taxas de vitória, tempo médio, salt rating) e suporte expandido a formatos multiplayer (até 6 jogadores) e torneios.

## 2. Requisitos e Regras
- **Persistência Sem Fricção**: Armazenamento 100% local no dispositivo, sem obrigatoriedade de criação de conta ou login na nuvem.
- **Auditoria de Condição de Vitória**:
  - **Vitória por Captura do Centro**: Centro oponente destruído via dano de Ofensiva ou conquistado via disputa de Influência.
  - **Vitória por Esgotamento de Baralho (Regra 1.5.3a)**: Quando o oponente não consegue comprar carta de seu baralho na Fase de Compra.
- **Métricas e Avaliação**:
  - Duração total da partida e tempo médio gasto por turno.
  - Contagem total de turnos jogados.
  - Avaliação de tom da partida (*salt rating* ou satisfação/intensidade).
  - Identidade de cor das bases utilizadas e taxa de vitória por arquétipo/cor.
- **Cronômetro de Torneio**: Cronômetro de rodada oficial configurável (ex.: 50 minutos) com alertas visuais/sonoros para torneios presenciais.
- **Suporte Multi-Formato**: Expansão do marcador para até 6 jogadores em formatos multiplayer ou partidas em equipe.

## 3. Modelo de Dados (Local Persistence)
```dart
enum VictoryType { centerCaptured, deckOut, concession }

class MatchRecord {
  final String id;
  final DateTime startedAt;
  final DateTime endedAt;
  final Duration totalDuration;
  final int totalTurns;
  final PlayerId winnerId;
  final VictoryType victoryType;
  final int saltRating; // Escala 1 a 5
  final List<PlayerMatchSummary> playerSummaries;
  final String? notes;
}

class PlayerMatchSummary {
  final String playerName;
  final List<CardColor> baseColors;
  final int finalDamageDealt;
  final int basesControlled;
}
```

## 4. Tarefas de Implementação

### 4.1. Camada de Persistência Local (Data & Repositories)
- [ ] Criar entidade e schema de banco de dados para `MatchRecord` e `PlayerMatchSummary`.
- [ ] Implementar `MatchHistoryRepository` com métodos `saveMatch()`, `getAllMatches()`, `getMatchById()` e `deleteMatch()`.
- [ ] Implementar motor de cálculo de estatísticas agregadas (`StatisticsService`):
  - Taxa de vitórias global e por cor de base.
  - Distribuição percentual dos tipos de vitória (Captura de Centro vs Esgotamento).
  - Média de duração de partida e tempo por turno.

### 4.2. Cronômetro de Rodada e Torneio
- [ ] Implementar `TournamentTimerController`:
  - Contagem regressiva com pause/resume/reset.
  - Configurações pré-definidas (45 min, 50 min, customizado).
  - Notificações sutis ao atingir 10 min, 5 min e tempo esgotado.

### 4.3. Telas e Visualização de Estatísticas
- [ ] Criar diálogo/tela de "Fim de Partida":
  - Seleção do vencedor e tipo de vitória (Centro Capturado vs Esgotamento de Baralho).
  - Campo para salt rating e notas rápidas.
  - Salvamento instantâneo no histórico local.
- [ ] Criar tela de Histórico de Partidas (lista cronológica com filtros por data e resultado).
- [ ] Criar tela de Painel de Estatísticas com gráficos e métricas de desempenho.
- [ ] Suporte a layouts configuráveis para 3 a 6 jogadores.

### 4.4. Testes
- [ ] Testes de integridade do salvamento e recuperação do histórico de partidas.
- [ ] Testes dos cálculos agregados de estatísticas e métricas.
- [ ] Testes de fluxo e estados do cronômetro de torneio.

## 5. Critérios de Aceite
- [ ] Partidas salvas e persistidas offline entre reinicializações do app.
- [ ] Estatísticas calculadas com exatidão conforme os tipos oficiais de vitória.
- [ ] Cronômetro estável e funcional em segundo plano durante a partida.

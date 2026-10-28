# Feature Plan: 05 - Fases do Turno, Ações Pré-Jogo e Aliados (MVP Core)

> Baseado na Seção 4.3 (Auxiliares de Fase de Turno e Ações Pré-Jogo) e Seção 5.1 de `plans/roadmap.md`.

## 1. Visão Geral
Orquestrar as fases estruturadas do turno oficial de Fábula TCG, oferecer assistentes para ações pré-jogo (sorteio inicial e Mulligan com restrição de primeiro turno) e rastrear o estado dos aliados em campo (virado/desvirado, custo de desvirar e condição "Se Preparando").

## 2. Regras Oficiais e Fluxos
### 2.1. Ações Pré-Jogo e Mulligan (Regras 1.4.1 a 1.4.5)
- **Sorteio Inicial**: Cara/coroa ou dado digital para definir quem começa.
- **Mão Inicial**: 6 cartas no formato padrão.
- **Mulligan**: Permitido exatamente 1 vez antes do início da partida; permite enviar $N$ cartas ao fundo do baralho em ordem aleatória e comprar a mesma quantidade $N$.
- **Primeiro Turno (Regra Especial)**: O jogador que começa a partida **NÃO** realiza a Fase de Compra em seu primeiro turno.

### 2.2. Sequência Oficial das 5 Fases do Turno (Seção 5)
1. **Fase Inicial / Compra**: Compra sinalizada até 6 cartas (pulada no T1 do jogador inicial).
2. **Fase de Restauração**: Restauração total de recursos; desvirar permanentes/aliados mediante pagamento do custo padrão de 1 recurso por aliado.
3. **Fase de Ação**: Baixar aliados, modificações, jogar manobras ou ativar habilidades.
4. **Fase de Combate**:
   - *Subfase de Ofensiva*: declaração de atacantes e bloqueadores virados, cálculo de dano simultâneo.
   - *Subfase de Influência*: declaração de influenciadores e bloqueadores, comparação com a resistência da base.
5. **Fase Final**: Sinalização de descarte até 5 cartas na mão (Regra 4.2.5) e restauração da vida de todos os aliados em campo.

### 2.3. Estado dos Aliados em Campo
- **Virado / Desvirado**: Indica exaustão por combate/ação. Custo de desvirar na restauração = 1 recurso por aliado.
- **"Se Preparando" (Regra 3.2.10)**: Aliados que entram em campo no turno atual não podem atacar, influenciar ou ativar habilidades no mesmo turno.

## 3. Modelo de Domínio
```dart
enum TurnPhase { draw, restoration, action, combat, endPhase }
enum CombatSubPhase { none, offensive, influence }

class AllyCardState {
  final String id;
  final String name;
  final int maxLife;
  final int currentLife;
  final int offensivePower;
  final int influencePower;
  final bool isTapped; // Virado
  final bool isPreparing; // Se Preparando
  final int turnEnteredField;
}

class TurnFlowState {
  final int roundNumber;
  final PlayerId activePlayerId;
  final TurnPhase currentPhase;
  final CombatSubPhase combatSubPhase;
  final bool firstTurnDrawSkipped;
}
```

## 4. Tarefas de Implementação

### 4.1. Módulo Pré-Jogo e Mulligan
- [ ] Implementar utilitário de sorteio aleatório criptograficamente seguro (`CoinToss`, `DiceRoller`).
- [ ] Criar modal de declaração de Mulligan (seleção de cartas trocadas e contagem de 1 uso único).
- [ ] Aplicar trava lógica que suprime a fase de compra no Turno 1 do jogador inicial.

### 4.2. Rastreador de Fases do Turno (TurnFlowNotifier)
- [ ] Implementar máquina de estados finitos para progressão de fases: `Draw -> Restoration -> Action -> Combat (Offensive -> Influence) -> EndPhase -> Next Turn`.
- [ ] Integrar gatilhos automáticos:
  - Na `Restoration`: aciona o `ResourceNotifier.restore()` e interface para desvirar aliados.
  - Na `EndPhase`: sinaliza verificação de descarte (mão <= 5) e restaura vida dos aliados sobreviventes.
  - Na transição de turno: remove a flag `isPreparing` dos aliados que entraram no turno anterior.

### 4.3. Marcadores de Aliados em Mesa
- [ ] Desenvolver card/marcador de aliado:
  - Botão de virar/desvirar com custo de 1 recurso.
  - Indicador visual da condição "Se Preparando" (badge e bloqueio de ações ofensivas).
  - Controle de dano e restauração ao fim do turno.

### 4.4. Testes Unitários
- [ ] Teste de bloqueio de compra no turno 1 do jogador inicial e permissão nos turnos seguintes.
- [ ] Teste da máquina de estados do turno (fases avançam na ordem correta).
- [ ] Teste de desvirar aliado debitando 1 recurso do jogador.
- [ ] Teste de limpeza do status "Se Preparando" no turno subsequente.
- [ ] Teste de restauração de vida de aliados na Fase Final.

## 5. Critérios de Aceite
- [ ] Progressão de fases intuitiva com avanço por toque único.
- [ ] Verificação de fim de turno com alerta para limite de 5 cartas na mão.
- [ ] Cobertura de testes unitários para a máquina de estados e regras dos aliados.
